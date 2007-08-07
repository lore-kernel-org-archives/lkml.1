Return-Path: <linux-kernel-owner+w=401wt.eu-S935245AbXHGWfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935245AbXHGWfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934726AbXHGWdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:33:14 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56920 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759945AbXHGWdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:33:08 -0400
Subject: [RFC][PATCH 5/5] pagemap: add walker for empty areas
To: mpm@selenic.com
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Tue, 07 Aug 2007 15:33:05 -0700
References: <20070807223300.9228E0E0@kernel>
In-Reply-To: <20070807223300.9228E0E0@kernel>
Message-Id: <20070807223305.7B47CC69@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


There's a pretty good deal of complexity surrounding dealing
with a sparse address space.  We have the pm->next pointer to
help indicate how far we've walked in the pagetables.  We also
attempt to fill empty areas without vmas manually.

This code adds an extension to the mm_walk code: a new handler
for "empty" pte ranges.  Those are areas where there is no
pte page present.  This allows us to get rid of the code that
inspects VMAs or that trys to keep track of how much of the
pagemap we have filled.

I should have broken these out, but there are a few more things
here as well:
- replaced -1's with a #define: PAGEMAP_NO_PAGE_PRESENT
- Rather than calculate the number of pagemap entries we
  expect to be able to make due to count, simply start making
  them, then return an error (PAGEMAP_END_OF_BUFFER) when the
  buffer is full in add_to_pagemap().  This gets rid of the
  vend/evaddr calculations.
- move around the code in the read function, and make some
  variables local to an else{} block.
- remove pagemapread->next variable.  It is no longer needed.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/proc/task_mmu.c |  135 ++++++++++++++++++--------------------------
 lxc-dave/include/linux/mm.h |    1 
 lxc-dave/lib/pagewalk.c     |   67 +++++++++------------
 3 files changed, 88 insertions(+), 115 deletions(-)

diff -puN fs/proc/task_mmu.c~walk-empty-ranges fs/proc/task_mmu.c
--- lxc/fs/proc/task_mmu.c~walk-empty-ranges	2007-08-07 15:30:54.000000000 -0700
+++ lxc-dave/fs/proc/task_mmu.c	2007-08-07 15:30:54.000000000 -0700
@@ -553,7 +553,6 @@ const struct file_operations proc_numa_m
 
 #ifdef CONFIG_PROC_PAGEMAP
 struct pagemapread {
-	unsigned long next;
 	unsigned long pos;
 	size_t count;
 	int index;
@@ -561,57 +560,66 @@ struct pagemapread {
 };
 
 #define PAGEMAP_ENTRY_SIZE_BYTES sizeof(unsigned long)
+#define PAGEMAP_END_OF_BUFFER 1
+#define PAGEMAP_NO_PAGE_PRESENT	((unsigned long)-1)
 
 static int add_to_pagemap(unsigned long addr, unsigned long pfn,
 			  struct pagemapread *pm)
 {
-	__put_user(pfn, pm->out);
+	int out_len = PAGEMAP_ENTRY_SIZE_BYTES;
+	if (pm->count < PAGEMAP_ENTRY_SIZE_BYTES)
+		out_len = pm->count;
+	copy_to_user(pm->out, &pfn, out_len);
 	pm->out++;
-	pm->pos += PAGEMAP_ENTRY_SIZE_BYTES;
-	pm->count -= PAGEMAP_ENTRY_SIZE_BYTES;
+	pm->pos += out_len;
+	pm->count -= out_len;
+	if (pm->count <= 0)
+		return PAGEMAP_END_OF_BUFFER;
 	return 0;
 }
 
+static int pagemap_pte_hole(unsigned long start, unsigned long end,
+			    void *private)
+{
+	struct pagemapread *pm = private;
+	unsigned long addr;
+	int err = 0;
+
+	for (addr = start; addr < end; addr += PAGE_SIZE) {
+		err = add_to_pagemap(addr, PAGEMAP_NO_PAGE_PRESENT, pm);
+		if (err)
+			break;
+	}
+	return err;
+}
+
 static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			     void *private)
 {
 	struct pagemapread *pm = private;
 	pte_t *pte;
-	int err;
+	int err = 0;
 
 	pte = pte_offset_map(pmd, addr);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
-		if (addr < pm->next)
-			continue;
-		if (!pte_present(*pte))
-			err = add_to_pagemap(addr, -1, pm);
-		else
-			err = add_to_pagemap(addr, pte_pfn(*pte), pm);
+		unsigned long pfn = PAGEMAP_NO_PAGE_PRESENT;
+		if (pte_present(*pte))
+			pfn = pte_pfn(*pte);
+		err = add_to_pagemap(addr, pte_pfn(*pte), pm);
 		if (err)
-			return err;
-		if (pm->count == 0)
 			break;
 	}
 	pte_unmap(pte - 1);
 
 	cond_resched();
 
-	return 0;
+	return err;
 }
 
-static int pagemap_fill(struct pagemapread *pm, unsigned long end)
-{
-	int ret;
-
-	while (pm->next != end && pm->count > 0) {
-		ret = add_to_pagemap(pm->next, -1UL, pm);
-		if (ret)
-			return ret;
-	}
-	return 0;
-}
-
-static struct mm_walk pagemap_walk = { .pmd_entry = pagemap_pte_range };
+static struct mm_walk pagemap_walk = {
+	.pmd_entry = pagemap_pte_range,
+	.pte_hole = pagemap_pte_hole
+};
 
 /*
  * /proc/pid/pagemap - an array mapping virtual pages to pfns
@@ -625,23 +633,14 @@ static struct mm_walk pagemap_walk = { .
  * Efficient users of this interface will use /proc/pid/maps to
  * determine which areas of memory are actually mapped and llseek to
  * skip over unmapped regions.
- *
- * The first 4 bytes of this file form a simple header:
- *
- * first byte:   0 for big endian, 1 for little
- * second byte:  page shift (eg 12 for 4096 byte pages)
- * third byte:   entry size in bytes (currently either 4 or 8)
- * fourth byte:  header size
  */
 static ssize_t pagemap_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *ppos)
 {
 	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
-	unsigned long src = *ppos;
 	struct page **pages, *page;
-	unsigned long addr, end, vend, svpfn, evpfn, uaddr, uend;
+	unsigned long uaddr, uend;
 	struct mm_struct *mm;
-	struct vm_area_struct *vma;
 	struct pagemapread pm;
 	int pagecount;
 	int ret = -ESRCH;
@@ -653,17 +652,6 @@ static ssize_t pagemap_read(struct file 
 	if (!ptrace_may_attach(task))
 		goto out;
 
-	ret = -EIO;
-	svpfn = src / PAGEMAP_ENTRY_SIZE_BYTES;
-	addr = PAGE_SIZE * svpfn;
-	if (svpfn * PAGEMAP_ENTRY_SIZE_BYTES != src)
-		goto out;
-	evpfn = min((src + count) / sizeof(unsigned long),
-		    ((~0UL) >> PAGE_SHIFT) + 1);
-	count = (evpfn - svpfn) * PAGEMAP_ENTRY_SIZE_BYTES;
-	end = PAGE_SIZE * evpfn;
-	//printk("src %ld svpfn %d evpfn %d count %d\n", src, svpfn, evpfn, count);
-
 	ret = 0;
 	mm = get_task_mm(task);
 	if (!mm)
@@ -672,7 +660,7 @@ static ssize_t pagemap_read(struct file 
 	ret = -ENOMEM;
 	uaddr = (unsigned long)buf & PAGE_MASK;
 	uend = (unsigned long)(buf + count);
-	pagecount = (uend - PAGE_ALIGN(uaddr)) / PAGE_SIZE;
+	pagecount = (PAGE_ALIGN(uend) - uaddr) / PAGE_SIZE;
 	pages = kmalloc(pagecount * sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
 		goto out_task;
@@ -682,44 +670,38 @@ static ssize_t pagemap_read(struct file 
 			     1, 0, pages, NULL);
 	up_read(&current->mm->mmap_sem);
 
-	//printk("%x(%x):%x %d@%ld (%d pages) -> %d\n", uaddr, buf, uend, count, src, pagecount, ret);
 	if (ret < 0)
 		goto out_free;
 
-	pm.next = addr;
-	pm.pos = src;
+	pm.pos = *ppos;
 	pm.count = count;
 	pm.out = (unsigned long __user *)buf;
 
 	down_read(&mm->mmap_sem);
-	vma = find_vma(mm, pm.next);
-	while (pm.count > 0 && vma) {
-		if (!ptrace_may_attach(task)) {
-			ret = -EIO;
-			up_read(&mm->mmap_sem);
-			goto out_release;
-		}
-		vend = min(vma->vm_start - 1, end - 1) + 1;
-		ret = pagemap_fill(&pm, vend);
-		if (ret || !pm.count)
-			break;
-		vend = min(vma->vm_end - 1, end - 1) + 1;
-		ret = walk_page_range(mm, vma->vm_start, vend,
+	if (!ptrace_may_attach(task)) {
+		ret = -EIO;
+	} else {
+		unsigned long src = *ppos;
+		unsigned long svpfn = src / PAGEMAP_ENTRY_SIZE_BYTES;
+		unsigned long start_vaddr = svpfn << PAGE_SHIFT;
+		unsigned long end_vaddr = TASK_SIZE_OF(task);
+		/*
+		 * The odds are that this will stop walking way
+		 * before end_vaddr, because the length of the
+		 * user buffer is tracked in "pm", and the walk
+		 * will stop when we hit the end of the buffer.
+		 */
+		ret = walk_page_range(mm, start_vaddr, end_vaddr,
 				      &pagemap_walk, &pm);
-		vma = vma->vm_next;
+		if (ret == PAGEMAP_END_OF_BUFFER)
+			ret = 0;
+		/* don't need mmap_sem for these, but this looks cleaner */
+		*ppos = pm.pos;
+		if (!ret)
+			ret = pm.pos - src;
 	}
 	up_read(&mm->mmap_sem);
 
-	//printk("before fill at %ld\n", pm.pos);
-	ret = pagemap_fill(&pm, end);
-
-	printk("after fill at %ld\n", pm.pos);
-	*ppos = pm.pos;
-	if (!ret)
-		ret = pm.pos - src;
-
-out_release:
-	printk("releasing pages\n");
 	for (; pagecount; pagecount--) {
 		page = pages[pagecount-1];
 		if (!PageReserved(page))
@@ -732,7 +714,6 @@ out_free:
 out_task:
 	put_task_struct(task);
 out:
-	printk("returning\n");
 	return ret;
 }
 
diff -puN include/linux/mm.h~walk-empty-ranges include/linux/mm.h
--- lxc/include/linux/mm.h~walk-empty-ranges	2007-08-07 15:30:54.000000000 -0700
+++ lxc-dave/include/linux/mm.h	2007-08-07 15:30:54.000000000 -0700
@@ -750,6 +750,7 @@ struct mm_walk {
 	int (*pud_entry)(pud_t *, unsigned long, unsigned long, void *);
 	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, void *);
 	int (*pte_entry)(pte_t *, unsigned long, unsigned long, void *);
+	int (*pte_hole) (unsigned long, unsigned long, void *);
 };
 
 int walk_page_range(struct mm_struct *, unsigned long addr, unsigned long end,
diff -puN lib/pagewalk.c~walk-empty-ranges lib/pagewalk.c
--- lxc/lib/pagewalk.c~walk-empty-ranges	2007-08-07 15:30:54.000000000 -0700
+++ lxc-dave/lib/pagewalk.c	2007-08-07 15:30:54.000000000 -0700
@@ -6,17 +6,13 @@ static int walk_pte_range(pmd_t *pmd, un
 			  struct mm_walk *walk, void *private)
 {
 	pte_t *pte;
-	int err;
+	int err = 0;
 
 	for (pte = pte_offset_map(pmd, addr); addr != end;
 	     addr += PAGE_SIZE, pte++) {
-		if (pte_none(*pte))
-			continue;
 		err = walk->pte_entry(pte, addr, addr, private);
-		if (err) {
-			pte_unmap(pte);
-			return err;
-		}
+		if (err)
+		       break;
 	}
 	pte_unmap(pte);
 	return 0;
@@ -27,25 +23,23 @@ static int walk_pmd_range(pud_t *pud, un
 {
 	pmd_t *pmd;
 	unsigned long next;
-	int err;
+	int err = 0;
 
 	for (pmd = pmd_offset(pud, addr); addr != end;
 	     pmd++, addr = next) {
 		next = pmd_addr_end(addr, end);
-		if (pmd_none_or_clear_bad(pmd))
+		if (pmd_none(*pmd)) {
+			err = walk->pte_hole(addr, next, private);
+		} else if (pmd_none_or_clear_bad(pmd))
 			continue;
-		if (walk->pmd_entry) {
+		if (!err && walk->pmd_entry)
 			err = walk->pmd_entry(pmd, addr, next, private);
-			if (err)
-				return err;
-		}
-		if (walk->pte_entry) {
+		if (!err && walk->pte_entry)
 			err = walk_pte_range(pmd, addr, next, walk, private);
-			if (err)
-				return err;
-		}
+		if (err)
+			break;
 	}
-	return 0;
+	return err;
 }
 
 static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
@@ -53,23 +47,21 @@ static int walk_pud_range(pgd_t *pgd, un
 {
 	pud_t *pud;
 	unsigned long next;
-	int err;
+	int err = 0;
 
 	for (pud = pud_offset(pgd, addr); addr != end;
 	     pud++, addr = next) {
 		next = pud_addr_end(addr, end);
-		if (pud_none_or_clear_bad(pud))
+		if (pud_none(*pud)) {
+			err = walk->pte_hole(addr, next, private);
+		} else if (pud_none_or_clear_bad(pud))
 			continue;
-		if (walk->pud_entry) {
+		if (!err && walk->pud_entry)
 			err = walk->pud_entry(pud, addr, next, private);
-			if (err)
-				return err;
-		}
-		if (walk->pmd_entry || walk->pte_entry) {
+		if (!err && (walk->pmd_entry || walk->pte_entry))
 			err = walk_pmd_range(pud, addr, next, walk, private);
-			if (err)
-				return err;
-		}
+		if (err)
+			return err;
 	}
 	return 0;
 }
@@ -91,23 +83,22 @@ int walk_page_range(struct mm_struct *mm
 {
 	pgd_t *pgd;
 	unsigned long next;
-	int err;
+	int err = 0;
 
 	for (pgd = pgd_offset(mm, addr); addr != end;
 	     pgd++, addr = next) {
 		next = pgd_addr_end(addr, end);
-		if (pgd_none_or_clear_bad(pgd))
+		if (pgd_none(*pgd)) {
+			err = walk->pte_hole(addr, next, private);
+		} else if (pgd_none_or_clear_bad(pgd))
 			continue;
-		if (walk->pgd_entry) {
+		if (!err && walk->pgd_entry)
 			err = walk->pgd_entry(pgd, addr, next, private);
-			if (err)
-				return err;
-		}
-		if (walk->pud_entry || walk->pmd_entry || walk->pte_entry) {
+		if (!err &&
+		    (walk->pud_entry || walk->pmd_entry || walk->pte_entry))
 			err = walk_pud_range(pgd, addr, next, walk, private);
-			if (err)
-				return err;
-		}
+		if (err)
+			return err;
 	}
 	return 0;
 }
_
