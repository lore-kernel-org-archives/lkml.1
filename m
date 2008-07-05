Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbYGEBxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbYGEBxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 21:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYGEBx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 21:53:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751714AbYGEBxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 21:53:25 -0400
Date: Fri, 4 Jul 2008 18:53:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Cc: torvalds@linuxfoundation.org, akpm@linuxfoundation.org, mpm@selenic.com,
       linux-kernel@vger.kernel.org
Subject: Re: *sigh* /proc/*/pagemap
Message-Id: <20080704185312.052e7145.akpm@linux-foundation.org>
In-Reply-To: <b6fcc0a0807041807p24cce461m419d7b54fce72d34@mail.gmail.com>
References: <b6fcc0a0807041807p24cce461m419d7b54fce72d34@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jul 2008 05:07:02 +0400 "Alexey Dobriyan" <adobriyan@gmail.com> wrote:

> I'm few days from my patch-sending facility, but could someone
> _please_ do the following before release:
> 
> 1) initialize pagemap_walk.mm to "mm" , so the code starts working as
> advertised, and
> 2) also initialize ->private to "&pm" so it wouldn't immediately oops
> in pagemap_pte_hole(), and

Geeze you're picky!  If everyone was like you we wouldn't need that
nice oops-printing code.

> 3) unstatic struct pagemap_walk, so two threads won't fsckup each other
>    (including those started by root, including flipping ->mm when you
> don't have permissions),

Below

>     and
> 4) remove second ptrace_may_attach(), and

Can't find what you're referring to here.

> 5) check with microscope allocation there -- page-aligned address and size == 0
>     should allocate 0 bytes, and

Where?

> 6) actually check that it works.

Will have a shot.

From: Andrew Morton <akpm@linux-foundation.org>

- initialize pagemap_walk.mm to "mm" , so the code starts working as
  advertised

- initialize ->private to "&pm" so it wouldn't immediately oops in
  pagemap_pte_hole()

- unstatic struct pagemap_walk, so two threads won't fsckup each other
  (including those started by root, including flipping ->mm when you don't
  have permissions)



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-fixes-to-pagemap_read fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-fixes-to-pagemap_read
+++ a/fs/proc/task_mmu.c
@@ -602,11 +602,6 @@ static int pagemap_pte_range(pmd_t *pmd,
 	return err;
 }
 
-static struct mm_walk pagemap_walk = {
-	.pmd_entry = pagemap_pte_range,
-	.pte_hole = pagemap_pte_hole
-};
-
 /*
  * /proc/pid/pagemap - an array mapping virtual pages to pfns
  *
@@ -641,6 +636,7 @@ static ssize_t pagemap_read(struct file 
 	struct pagemapread pm;
 	int pagecount;
 	int ret = -ESRCH;
+	static struct mm_walk pagemap_walk;
 
 	if (!task)
 		goto out;
@@ -659,6 +655,7 @@ static ssize_t pagemap_read(struct file 
 	if (!mm)
 		goto out_task;
 
+
 	ret = -ENOMEM;
 	uaddr = (unsigned long)buf & PAGE_MASK;
 	uend = (unsigned long)(buf + count);
@@ -684,6 +681,11 @@ static ssize_t pagemap_read(struct file 
 	pm.out = (u64 *)buf;
 	pm.end = (u64 *)(buf + count);
 
+	pagemap_walk.pmd_entry = pagemap_pte_range;
+	pagemap_walk.pte_hole = pagemap_pte_hole;
+	pagemap_walk.mm = mm;
+	pagemap_walk.private = &pm;
+
 	if (!ptrace_may_attach(task)) {
 		ret = -EIO;
 	} else {
_

