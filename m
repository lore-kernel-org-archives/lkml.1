Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbYFKSsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbYFKSsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757743AbYFKSrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:47:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757613AbYFKSrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:47:06 -0400
Message-Id: <20080611184339.899722381@redhat.com>
References: <20080611184214.605110868@redhat.com>
User-Agent: quilt/0.46-1
Date: Wed, 11 Jun 2008 14:42:31 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH -mm 17/24] mlock: downgrade mmap sem while populating mlocked regions
Content-Disposition: inline; filename=vmscan-downgrade-mmap-sem-while-populating-mlocked-regions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Schermerhorn <lee.schermerhorn@hp.com>

We need to hold the mmap_sem for write to initiatate mlock()/munlock()
because we may need to merge/split vmas.  However, this can lead to
very long lock hold times attempting to fault in a large memory region
to mlock it into memory.   This can hold off other faults against the
mm [multithreaded tasks] and other scans of the mm, such as via /proc.
To alleviate this, downgrade the mmap_sem to read mode during the 
population of the region for locking.  This is especially the case 
if we need to reclaim memory to lock down the region.  We [probably?]
don't need to do this for unlocking as all of the pages should be
resident--they're already mlocked.

Now, the caller's of the mlock functions [mlock_fixup() and 
mlock_vma_pages_range()] expect the mmap_sem to be returned in write
mode.  Changing all callers appears to be way too much effort at this
point.  So, restore write mode before returning.  Note that this opens
a window where the mmap list could change in a multithreaded process.
So, at least for mlock_fixup(), where we could be called in a loop over
multiple vmas, we check that a vma still exists at the start address
and that vma still covers the page range [start,end).  If not, we return
an error, -EAGAIN, and let the caller deal with it.

Return -EAGAIN from mlock_vma_pages_range() function and mlock_fixup()
if the vma at 'start' disappears or changes so that the page range
[start,end) is no longer contained in the vma.  Again, let the caller
deal with it.  Looks like only sys_remap_file_pages() [via mmap_region()]
should actually care.

With this patch, I no longer see processes like ps(1) blocked for seconds
or minutes at a time waiting for a large [multiple gigabyte] region to be
locked down.  However, I occassionally see delays while unlocking or
unmapping a large mlocked region.  Should we also downgrade the mmap_sem
for the unlock path?

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>

--- 
V2 -> V3:
+ rebase to 23-mm1 atop RvR's split lru series [no change]
+ fix function return types [void -> int] to fix build when
  not configured.

New in V2.

 mm/mlock.c |   46 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 3 deletions(-)

Index: linux-2.6.26-rc5-mm2/mm/mlock.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/mlock.c	2008-06-10 22:28:01.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/mlock.c	2008-06-10 22:28:05.000000000 -0400
@@ -308,6 +308,7 @@ static void __munlock_vma_pages_range(st
 int mlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	int nr_pages = (end - start) / PAGE_SIZE;
 	BUG_ON(!(vma->vm_flags & VM_LOCKED));
 
@@ -319,8 +320,19 @@ int mlock_vma_pages_range(struct vm_area
 
 	if (!((vma->vm_flags & (VM_DONTEXPAND | VM_RESERVED)) ||
 			is_vm_hugetlb_page(vma) ||
-			vma == get_gate_vma(current)))
-		return __mlock_vma_pages_range(vma, start, end);
+			vma == get_gate_vma(current))) {
+		downgrade_write(&mm->mmap_sem);
+		nr_pages = __mlock_vma_pages_range(vma, start, end);
+
+		up_read(&mm->mmap_sem);
+		/* vma can change or disappear */
+		down_write(&mm->mmap_sem);
+		vma = find_vma(mm, start);
+		/* non-NULL vma must contain @start, but need to check @end */
+		if (!vma ||  end > vma->vm_end)
+			return -EAGAIN;
+		return nr_pages;
+	}
 
 	/*
 	 * User mapped kernel pages or huge pages:
@@ -414,13 +426,41 @@ success:
 	vma->vm_flags = newflags;
 
 	if (lock) {
+		/*
+		 * mmap_sem is currently held for write.  Downgrade the write
+		 * lock to a read lock so that other faults, mmap scans, ...
+		 * while we fault in all pages.
+		 */
+		downgrade_write(&mm->mmap_sem);
+
 		ret = __mlock_vma_pages_range(vma, start, end);
 		if (ret > 0) {
 			mm->locked_vm -= ret;
 			ret = 0;
 		}
-	} else
+		/*
+		 * Need to reacquire mmap sem in write mode, as our callers
+		 * expect this.  We have no support for atomically upgrading
+		 * a sem to write, so we need to check for ranges while sem
+		 * is unlocked.
+		 */
+		up_read(&mm->mmap_sem);
+		/* vma can change or disappear */
+		down_write(&mm->mmap_sem);
+		*prev = find_vma(mm, start);
+		/* non-NULL *prev must contain @start, but need to check @end */
+		if (!(*prev) || end > (*prev)->vm_end)
+			ret = -EAGAIN;
+	} else {
+		/*
+		 * TODO:  for unlocking, pages will already be resident, so
+		 * we don't need to wait for allocations/reclaim/pagein, ...
+		 * However, unlocking a very large region can still take a
+		 * while.  Should we downgrade the semaphore for both lock
+		 * AND unlock ?
+		 */
 		__munlock_vma_pages_range(vma, start, end);
+	}
 
 out:
 	*prev = vma;

-- 
All Rights Reversed

