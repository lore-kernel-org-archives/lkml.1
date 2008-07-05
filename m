Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYGEIDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYGEIDP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 04:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbYGEICU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 04:02:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752208AbYGEICQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 04:02:16 -0400
Date: Sat, 5 Jul 2008 01:02:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Cc: torvalds@linuxfoundation.org, mpm@selenic.com,
       linux-kernel@vger.kernel.org
Subject: Re: *sigh* /proc/*/pagemap
Message-Id: <20080705010201.c4eb3a0b.akpm@linux-foundation.org>
In-Reply-To: <b6fcc0a0807050044g7a34a688s903e74848ab14b92@mail.gmail.com>
References: <b6fcc0a0807041807p24cce461m419d7b54fce72d34@mail.gmail.com>
	<20080704185312.052e7145.akpm@linux-foundation.org>
	<b6fcc0a0807050044g7a34a688s903e74848ab14b92@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jul 2008 11:44:54 +0400 "Alexey Dobriyan" <adobriyan@gmail.com> wrote:

> On 7/5/08, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Sat, 5 Jul 2008 05:07:02 +0400 "Alexey Dobriyan" <adobriyan@gmail.com>
> > wrote:
> 
> >> 3) unstatic struct pagemap_walk, so two threads won't fsckup each other
> >>    (including those started by root, including flipping ->mm when you
> >> don't have permissions),
> >
> > Below
> 
> Below.
> 
> >> 4) remove second ptrace_may_attach(), and
> >
> > Can't find what you're referring to here.
> 
> pagemap_read() contains two calls to ptrace_may_attach(),
> second one looks unneeded.

Agree.

> >> 5) check with microscope allocation there -- page-aligned address and size
> >> == 0
> >>     should allocate 0 bytes, and
> >
> > Where?
> 
> kmalloc() in pagemap_read(). kmalloc(0)  and integer wraparound look possible.

hm, maybe.  Plug that anyway.  Used kcalloc() even though the memset
isn't needed (we need a non-zeroing kcalloc)

> >> 6) actually check that it works.
> >
> > Will have a shot.
> 
> Ha-ha!
> 
> > - unstatic struct pagemap_walk, so two threads won't fsckup each other
> >   (including those started by root, including flipping ->mm when you don't
> >   have permissions)
> 
> > --- a/fs/proc/task_mmu.c~pagemap-fixes-to-pagemap_read
> > +++ a/fs/proc/task_mmu.c
> > @@ -641,6 +636,7 @@ static ssize_t pagemap_read(struct file
> >  	struct pagemapread pm;
> >  	int pagecount;
> >  	int ret = -ESRCH;
> > +	static struct mm_walk pagemap_walk;
> 
> No, can't have static here, two threads doing pagemap_read() will overwrite
> each other's .mm and "out" at least. Like "pm" it shouldn't be global.

doh, copy-n-paste strikes again.



From: Andrew Morton <akpm@linux-foundation.org>

Fix some issues noted by Alexey:

- initialize pagemap_walk.mm to "mm" , so the code starts working as
  advertised

- initialize ->private to "&pm" so it wouldn't immediately oops in
  pagemap_pte_hole()

- unstatic struct pagemap_walk, so two threads won't fsckup each other
  (including those started by root, including flipping ->mm when you don't
  have permissions)

- pagemap_read() contains two calls to ptrace_may_attach(), second one
  looks unneeded.

- avoid possible kmalloc(0) and integer wraparound.

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   72 ++++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 34 deletions(-)

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
@@ -641,6 +636,11 @@ static ssize_t pagemap_read(struct file 
 	struct pagemapread pm;
 	int pagecount;
 	int ret = -ESRCH;
+	struct mm_walk pagemap_walk;
+	unsigned long src;
+	unsigned long svpfn;
+	unsigned long start_vaddr;
+	unsigned long end_vaddr;
 
 	if (!task)
 		goto out;
@@ -659,11 +659,15 @@ static ssize_t pagemap_read(struct file 
 	if (!mm)
 		goto out_task;
 
-	ret = -ENOMEM;
+
 	uaddr = (unsigned long)buf & PAGE_MASK;
 	uend = (unsigned long)(buf + count);
 	pagecount = (PAGE_ALIGN(uend) - uaddr) / PAGE_SIZE;
-	pages = kmalloc(pagecount * sizeof(struct page *), GFP_KERNEL);
+	ret = 0;
+	if (pagecount == 0)
+		goto out_mm;
+	pages = kcalloc(pagecount, sizeof(struct page *), GFP_KERNEL);
+	ret = -ENOMEM;
 	if (!pages)
 		goto out_mm;
 
@@ -684,33 +688,33 @@ static ssize_t pagemap_read(struct file 
 	pm.out = (u64 *)buf;
 	pm.end = (u64 *)(buf + count);
 
-	if (!ptrace_may_attach(task)) {
-		ret = -EIO;
-	} else {
-		unsigned long src = *ppos;
-		unsigned long svpfn = src / PM_ENTRY_BYTES;
-		unsigned long start_vaddr = svpfn << PAGE_SHIFT;
-		unsigned long end_vaddr = TASK_SIZE_OF(task);
-
-		/* watch out for wraparound */
-		if (svpfn > TASK_SIZE_OF(task) >> PAGE_SHIFT)
-			start_vaddr = end_vaddr;
-
-		/*
-		 * The odds are that this will stop walking way
-		 * before end_vaddr, because the length of the
-		 * user buffer is tracked in "pm", and the walk
-		 * will stop when we hit the end of the buffer.
-		 */
-		ret = walk_page_range(start_vaddr, end_vaddr,
-					&pagemap_walk);
-		if (ret == PM_END_OF_BUFFER)
-			ret = 0;
-		/* don't need mmap_sem for these, but this looks cleaner */
-		*ppos += (char *)pm.out - buf;
-		if (!ret)
-			ret = (char *)pm.out - buf;
-	}
+	pagemap_walk.pmd_entry = pagemap_pte_range;
+	pagemap_walk.pte_hole = pagemap_pte_hole;
+	pagemap_walk.mm = mm;
+	pagemap_walk.private = &pm;
+
+	src = *ppos;
+	svpfn = src / PM_ENTRY_BYTES;
+	start_vaddr = svpfn << PAGE_SHIFT;
+	end_vaddr = TASK_SIZE_OF(task);
+
+	/* watch out for wraparound */
+	if (svpfn > TASK_SIZE_OF(task) >> PAGE_SHIFT)
+		start_vaddr = end_vaddr;
+
+	/*
+	 * The odds are that this will stop walking way
+	 * before end_vaddr, because the length of the
+	 * user buffer is tracked in "pm", and the walk
+	 * will stop when we hit the end of the buffer.
+	 */
+	ret = walk_page_range(start_vaddr, end_vaddr, &pagemap_walk);
+	if (ret == PM_END_OF_BUFFER)
+		ret = 0;
+	/* don't need mmap_sem for these, but this looks cleaner */
+	*ppos += (char *)pm.out - buf;
+	if (!ret)
+		ret = (char *)pm.out - buf;
 
 out_pages:
 	for (; pagecount; pagecount--) {
_

