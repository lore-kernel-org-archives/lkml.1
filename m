Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbYLOG7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbYLOG7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 01:59:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYLOG6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 01:58:52 -0500
Received: from sh.osrg.net ([192.16.179.4]:36256 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbYLOG6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 01:58:51 -0500
Date: Mon, 15 Dec 2008 15:58:40 +0900 (JST)
Message-Id: <20081215.155840.105124170.ryusuke@osrg.net>
To: andi@firstfloor.org
Cc: konishi.ryusuke@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm 1/5] nilfs2: fix problems of memory allocation in
 ioctl
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20081214151327.GM25779@one.firstfloor.org>
References: <1229059021-9538-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1229059021-9538-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<871vwdcxo1.fsf@basil.nowhere.org>
	<20081213.034808.104867584.ryusuke@osrg.net>
	<20081212202411.GK25779@one.firstfloor.org>
	<20081213.172915.31069043.ryusuke@osrg.net>
	<20081214.210839.09550698.ryusuke@osrg.net>
	<20081214151327.GM25779@one.firstfloor.org>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2008 16:13:27 +0100, Andi Kleen <andi@firstfloor.org> wrote:
> > -#define KMALLOC_SIZE_MIN	4096	/* 4KB */
> > -#define KMALLOC_SIZE_MAX	131072	/* 128 KB */
> > +#define NILFS_IOCTL_KMALLOC_SIZE	8192	/* 8KB */
> 
> Better would be if you could go to PAGE_SIZE. order 0 allocations
> are typically the fastest / least likely to stall.
> 
> Also in this case it's a good idea to use __get_free_pages()
> directly, kmalloc tends to be become less efficient at larger
> sizes.

Thanks again.  I've rewritten the patch to use __get_free_pages().

Regards,
Ryusuke Konishi

---
nilfs2: fix problems of memory allocation in ioctl 3

This is another patch for fixing the following problems of a memory
copy function in nilfs2 ioctl:

(1) It tries to allocate 128KB size of memory even for small objects.

(2) Though the function repeatedly tries large memory allocations
    while reducing the size, GFP_NOWAIT flag is not specified.
    This increases the possibility of system memory shortage.

(3) During the retries of (2), verbose warnings are printed
    because _GFP_NOWARN flag is not used for the kmalloc calls.

The first patch was still doing large allocations by kmalloc which are
repeatedly tried while reducing the size.

Andi Kleen told me that using copy_from_user for large memory is not
good from the viewpoint of preempt latency:

 On Fri, 12 Dec 2008 21:24:11 +0100, Andi Kleen <andi@firstfloor.org> wrote:
 > > In the current interface, each data item is copied twice: one is to
 > > the allocated memory from user space (via copy_from_user), and another
 >
 > For such large copies it is better to use multiple smaller (e.g. 4K)
 > copy user, that gives better real time preempt latencies. Each cfu has a
 > cond_resched(), but only one, not multiple times in the inner loop.

He also advised me that:

 On Sun, 14 Dec 2008 16:13:27 +0100, Andi Kleen <andi@firstfloor.org> wrote:
 > Better would be if you could go to PAGE_SIZE. order 0 allocations
 > are typically the fastest / least likely to stall.
 >
 > Also in this case it's a good idea to use __get_free_pages()
 > directly, kmalloc tends to be become less efficient at larger
 > sizes.

For the function in question, the size of buffer memory can be reduced
since the buffer is repeatedly used for a number of small objects.  On
the other hand, it may incur large preempt latencies for larger buffer
because a copy_from_user (and a copy_to_user) was applied only once
each cycle.

With that, this revision uses the order 0 allocations with
__get_free_pages() to fix the original problems.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/ioctl.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 35ba60e..02e91e1 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -34,9 +34,6 @@
 #include "dat.h"
 
 
-#define KMALLOC_SIZE_MIN	4096	/* 4KB */
-#define KMALLOC_SIZE_MAX	131072	/* 128 KB */
-
 static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 				 struct nilfs_argv *argv, int dir,
 				 ssize_t (*dofunc)(struct the_nilfs *,
@@ -44,21 +41,20 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 						   void *, size_t, size_t))
 {
 	void *buf;
-	size_t ksize, maxmembs, total, n;
+	size_t maxmembs, total, n;
 	ssize_t nr;
 	int ret, i;
 
 	if (argv->v_nmembs == 0)
 		return 0;
 
-	for (ksize = KMALLOC_SIZE_MAX; ksize >= KMALLOC_SIZE_MIN; ksize /= 2) {
-		buf = kmalloc(ksize, GFP_NOFS);
-		if (buf != NULL)
-			break;
-	}
-	if (ksize < KMALLOC_SIZE_MIN)
+	if (argv->v_size > PAGE_SIZE)
+		return -EINVAL;
+
+	buf = (void *)__get_free_pages(GFP_NOFS, 0);
+	if (unlikely(!buf))
 		return -ENOMEM;
-	maxmembs = ksize / argv->v_size;
+	maxmembs = PAGE_SIZE / argv->v_size;
 
 	ret = 0;
 	total = 0;
@@ -89,7 +85,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	}
 	argv->v_nmembs = total;
 
-	kfree(buf);
+	free_pages((unsigned long)buf, 0);
 	return ret;
 }
 
-- 
1.5.6.5

