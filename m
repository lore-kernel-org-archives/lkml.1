Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbYLGOVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbYLGOVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 09:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYLGOV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 09:21:28 -0500
Received: from iona.labri.fr ([147.210.8.143]:55944 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbYLGOV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 09:21:27 -0500
Message-ID: <493BDBE6.9040600@inria.fr>
Date: Sun, 07 Dec 2008 15:21:26 +0100
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH] No get_user/put_user while holding mmap_sem in do_pages_stat?
References: <493B3179.7030204@inria.fr> <20081206185050.544f67fc.akpm@linux-foundation.org>
In-Reply-To: <20081206185050.544f67fc.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Was lockdep able to tell you about this in any way?
>   

With CONFIG_PROVE_LOCKING (assuming that it's enough), it doesn't detect
the problem for real. It just says "possible recursive locking detected"
between do_page_fault and sys_move_pages. I actually understood the
problem after hitting sysrq-t and always getting the following backtraces:
* thread 1
[<ffffffff80430cb8>] __down_write_nested+0x9c/0xb4
[<ffffffff8028c2c4>] sys_mprotect+0xcc/0x230
* thread 2
[<ffffffff80430d73>] __down_read+0x9c/0xb4
[<ffffffff80223f5c>] do_page_fault+0x551/0x9d9
[...]
[<ffffffff8043111a>] error_exit+0x0/0x70
[<ffffffff802f5bec>] cap_task_movememory+0x0/0x3
[<ffffffff8032b99d>] __put_user_4+0x1d/0x30
[<ffffffff802a091f>] sys_move_pages+0x453/0x4c0


> Directly dereferencing a user pointer is very bad.  Fortunately, it's
> just that the above __user annotation is now wrong.
>   

Sorry, I totally messed up my annotations. I fixed up the annotations
and applied your other changes. The new patch (below) makes sparse and
checkpatch.pl happy.

> Given that this code use to perform acceptably (presumably) doing one
> page at a time, I suspect that you could have retained that behaviour,
> avoiding the complexity of those two arrays.  Would an additional
> down_read()/up_read() per page have been unacceptably costly?
>
> The arrays could have been allocated on the stack, I expect.  16 slots
> is enough?
>   

I thought down/up_read would be more expensive but it does not seem to
be that bad:
* original code: do_pages_stat stats pages at 30-45GB/s (depending on
buffer size) on a quad-quad-core 1.9GHz opteron
* if moving down/up inside the main loop in do_pages_stat() so as to
down/up once per page, we get to 20-30GB/s
* if working on __get_free_page-based arrays (my first patch), we reach
35GB/s for large buffers (32, 128MB, or so), but it is very slow for
small buffers (about 500MB/s for 32kB).
* if allocating 16-slots arrays on the stack, we get back to 30-45GB/s
(new patch below)
So 16-slots on the stack looks like a good code-complexity/performance
compromise to me. do_pages_stat() performance doesn't look critical
anyway, as long as it's not very slow.

> It's a small semantic change, isn't it?  We release the semaphore in
> the middle of the operation, thus presenting possibly
> non-internally-consistent results to userspace.  Why does this not matter?
>   

Unless I am mistaken, both do_pages_stat() and do_pages_move() only take
the mmap_sem for read, they can happen concurrently. I think you never
had any guarantee such as migrating in one thread being seen as "atomic"
from another thread stat'ing the same buffer.

By the way, in 2.6.29, sys_move_pages() will release the semaphore in
the middle of page migration as well. My rework patch removed the need
to vmalloc a huge array, get_user everything in there, and then migrate
all pages at once. The new code will get_user a page-size array, migrate
it, and switch to the next slots (releasing the semaphore in-between).

If we look at do_pages_stat() "atomicity" versus another operation that
takes the mmap_sem for write, I don't see any actual problem. Either
do_pages_stat() doesn't care much about the operation occuring while it
released the mmap_sem (mprotect or so), or user-threads should be
synchronized instead of stat'ing some VMAs that are removed/reduced in
parallel (mmap/munmap/...).

Brice



[PATCH] No get_user/put_user while holding mmap_sem in do_pages_stat

Since commit 2f007e74bb85b9fc4eab28524052161703300f1a, do_pages_stat()
gets the page address from user-space and puts the corresponding status
back while holding the mmap_sem for read. There is no need to hold
mmap_sem there while some page-faults may occur.

This patch adds a temporary address and status buffer so as to only hold
mmap_sem while working on these kernel buffers. This is implemented by
extracting do_pages_stat_array() out of do_pages_stat().

diff --git a/mm/migrate.c b/mm/migrate.c
index ded190d..bc2c773 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1018,25 +1018,18 @@ out:
 /*
  * Determine the nodes of an array of pages and store it in an array of status.
  */
-static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
-			 const void __user * __user *pages,
-			 int __user *status)
+static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
+				const void __user **pages, int *status)
 {
 	unsigned long i;
-	int err;
 
 	down_read(&mm->mmap_sem);
 
 	for (i = 0; i < nr_pages; i++) {
-		const void __user *p;
-		unsigned long addr;
+		unsigned long addr = (unsigned long)(*pages);
 		struct vm_area_struct *vma;
 		struct page *page;
-
-		err = -EFAULT;
-		if (get_user(p, pages+i))
-			goto out;
-		addr = (unsigned long) p;
+		int err;
 
 		vma = find_vma(mm, addr);
 		if (!vma)
@@ -1055,12 +1048,52 @@ static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
 
 		err = page_to_nid(page);
 set_status:
-		put_user(err, status+i);
+		*status = err;
+
+		pages++;
+		status++;
+	}
+
+	up_read(&mm->mmap_sem);
+}
+
+/*
+ * Determine the nodes of a user array of pages and store it in
+ * a user array of status.
+ */
+static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
+			 const void __user * __user *pages,
+			 int __user *status)
+{
+#define DO_PAGES_STAT_CHUNK_NR 16
+	const void __user *chunk_pages[DO_PAGES_STAT_CHUNK_NR];
+	int chunk_status[DO_PAGES_STAT_CHUNK_NR];
+	unsigned long i, chunk_nr = DO_PAGES_STAT_CHUNK_NR;
+	int err;
+
+	for (i = 0; i < nr_pages; i += chunk_nr) {
+		if (chunk_nr + i > nr_pages)
+			chunk_nr = nr_pages - i;
+
+		err = copy_from_user(chunk_pages, &pages[i],
+				     chunk_nr * sizeof(*chunk_pages));
+		if (err) {
+			err = -EFAULT;
+			goto out;
+		}
+
+		do_pages_stat_array(mm, chunk_nr, chunk_pages, chunk_status);
+
+		err = copy_to_user(&status[i], chunk_status,
+				   chunk_nr * sizeof(*chunk_status));
+		if (err) {
+			err = -EFAULT;
+			goto out;
+		}
 	}
 	err = 0;
 
 out:
-	up_read(&mm->mmap_sem);
 	return err;
 }
 


