Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbZCKNx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbZCKNx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbZCKNxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:53:18 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:62978 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbZCKNxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:53:18 -0400
Date: Wed, 11 Mar 2009 14:49:51 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Matt Mackall <mpm@selenic.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>, akpm@linux-foundation.org
Subject: [PATCH] fix/improve generic page table walker
Message-ID: <20090311144951.58c6ab60@skybase>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

On s390 the /proc/pid/pagemap interface is currently broken. This is
caused by the unconditional loop over all pgd/pud entries as specified
by the address range passed to walk_page_range. The tricky bit here
is that the pgd++ in the outer loop may only be done if the page table
really has 4 levels. For the pud++ in the second loop the page table needs
to have at least 3 levels. With the dynamic page tables on s390 we can have
page tables with 2, 3 or 4 levels. Which means that the pgd and/or the
pud pointer can get out-of-bounds causing all kinds of mayhem.

The proposed solution is to fast-forward over the hole between the start
address and the first vma and the hole between the last vma and the end
address. The pgd/pud/pmd/pte loops are used only for the address range
between the first and last vma. This guarantees that the page table
pointers stay in range for s390. For the other architectures this is
a small optimization.

As the page walker now accesses the vma list the mmap_sem is required.
All callers of the walk_page_range function needs to acquire the semaphore.

Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 fs/proc/task_mmu.c |    2 ++
 mm/pagewalk.c      |   28 ++++++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/fs/proc/task_mmu.c linux-2.6-patched/fs/proc/task_mmu.c
--- linux-2.6/fs/proc/task_mmu.c	2009-03-11 13:38:53.000000000 +0100
+++ linux-2.6-patched/fs/proc/task_mmu.c	2009-03-11 13:39:45.000000000 +0100
@@ -716,7 +716,9 @@ static ssize_t pagemap_read(struct file 
 	 * user buffer is tracked in "pm", and the walk
 	 * will stop when we hit the end of the buffer.
 	 */
+	down_read(&mm->mmap_sem);
 	ret = walk_page_range(start_vaddr, end_vaddr, &pagemap_walk);
+	up_read(&mm->mmap_sem);
 	if (ret == PM_END_OF_BUFFER)
 		ret = 0;
 	/* don't need mmap_sem for these, but this looks cleaner */
diff -urpN linux-2.6/mm/pagewalk.c linux-2.6-patched/mm/pagewalk.c
--- linux-2.6/mm/pagewalk.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6-patched/mm/pagewalk.c	2009-03-11 13:39:45.000000000 +0100
@@ -104,6 +104,8 @@ static int walk_pud_range(pgd_t *pgd, un
 int walk_page_range(unsigned long addr, unsigned long end,
 		    struct mm_walk *walk)
 {
+	struct vm_area_struct *vma, *prev;
+	unsigned long stop;
 	pgd_t *pgd;
 	unsigned long next;
 	int err = 0;
@@ -114,9 +116,28 @@ int walk_page_range(unsigned long addr, 
 	if (!walk->mm)
 		return -EINVAL;
 
+	/* Find first valid address contained in a vma. */
+	vma = find_vma(walk->mm, addr);
+	if (!vma)
+		/* One big hole. */
+		return walk->pte_hole(addr, end, walk);
+	if (addr < vma->vm_start) {
+		/* Skip over all ptes in the area before the first vma. */
+		err = walk->pte_hole(addr, vma->vm_start, walk);
+		if (err)
+			return err;
+		addr = vma->vm_start;
+	}
+
+	/* Find last valid address contained in a vma. */
+	stop = end;
+	vma = find_vma_prev(walk->mm, end, &prev);
+	if (!vma)
+		stop = prev->vm_end;
+
 	pgd = pgd_offset(walk->mm, addr);
 	do {
-		next = pgd_addr_end(addr, end);
+		next = pgd_addr_end(addr, stop);
 		if (pgd_none_or_clear_bad(pgd)) {
 			if (walk->pte_hole)
 				err = walk->pte_hole(addr, next, walk);
@@ -131,7 +152,10 @@ int walk_page_range(unsigned long addr, 
 			err = walk_pud_range(pgd, addr, next, walk);
 		if (err)
 			break;
-	} while (pgd++, addr = next, addr != end);
+	} while (pgd++, addr = next, addr != stop);
 
+	if (stop < end)
+		/* Skip over all ptes in the area after the last vma. */
+		err = walk->pte_hole(stop, end, walk);
 	return err;
 }
