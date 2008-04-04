Return-Path: <linux-kernel-owner+w=401wt.eu-S1752626AbYDDWcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbYDDWcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 18:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbYDDWbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 18:31:34 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52672 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752233AbYDDWbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 18:31:32 -0400
Message-Id: <20080404223131.271668133@sgi.com>
References: <20080404223048.374852899@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 15:30:49 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>
Cc: kvm-devel@lists.sourceforge.net
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 01/10] emm: mm_lock: Lock a process against reclaim
Content-Disposition: inline; filename=mm_lock_unlock
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a way to lock an mm_struct against reclaim (try_to_unmap
etc). This is necessary for the invalidate notifier approaches so
that they can reliably add and remove a notifier.

Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h |   10 ++++++++
 mm/mmap.c          |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2008-04-02 11:41:47.741678873 -0700
+++ linux-2.6/include/linux/mm.h	2008-04-04 15:02:17.660504756 -0700
@@ -1050,6 +1050,16 @@ extern int install_special_mapping(struc
 				   unsigned long addr, unsigned long len,
 				   unsigned long flags, struct page **pages);
 
+/*
+ * Locking and unlocking am mm against reclaim.
+ *
+ * mm_lock will take mmap_sem writably (to prevent additional vmas from being
+ * added) and then take all mapping locks of the existing vmas. With that
+ * reclaim is effectively stopped.
+ */
+extern void mm_lock(struct mm_struct *mm);
+extern void mm_unlock(struct mm_struct *mm);
+
 extern unsigned long get_unmapped_area(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 
 extern unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c	2008-04-04 14:55:03.477593980 -0700
+++ linux-2.6/mm/mmap.c	2008-04-04 14:59:05.505395402 -0700
@@ -2242,3 +2242,69 @@ int install_special_mapping(struct mm_st
 
 	return 0;
 }
+
+static void mm_lock_unlock(struct mm_struct *mm, int lock)
+{
+	struct vm_area_struct *vma;
+	spinlock_t *i_mmap_lock_last, *anon_vma_lock_last;
+
+	i_mmap_lock_last = NULL;
+	for (;;) {
+		spinlock_t *i_mmap_lock = (spinlock_t *) -1UL;
+		for (vma = mm->mmap; vma; vma = vma->vm_next)
+			if (vma->vm_file && vma->vm_file->f_mapping &&
+			    (unsigned long) i_mmap_lock >
+			    (unsigned long)
+			    &vma->vm_file->f_mapping->i_mmap_lock &&
+			    (unsigned long)
+			    &vma->vm_file->f_mapping->i_mmap_lock >
+			    (unsigned long) i_mmap_lock_last)
+				i_mmap_lock =
+					&vma->vm_file->f_mapping->i_mmap_lock;
+		if (i_mmap_lock == (spinlock_t *) -1UL)
+			break;
+		i_mmap_lock_last = i_mmap_lock;
+		if (lock)
+			spin_lock(i_mmap_lock);
+		else
+			spin_unlock(i_mmap_lock);
+	}
+
+	anon_vma_lock_last = NULL;
+	for (;;) {
+		spinlock_t *anon_vma_lock = (spinlock_t *) -1UL;
+		for (vma = mm->mmap; vma; vma = vma->vm_next)
+			if (vma->anon_vma &&
+			    (unsigned long) anon_vma_lock >
+			    (unsigned long) &vma->anon_vma->lock &&
+			    (unsigned long) &vma->anon_vma->lock >
+			    (unsigned long) anon_vma_lock_last)
+				anon_vma_lock = &vma->anon_vma->lock;
+		if (anon_vma_lock == (spinlock_t *) -1UL)
+			break;
+		anon_vma_lock_last = anon_vma_lock;
+		if (lock)
+			spin_lock(anon_vma_lock);
+		else
+			spin_unlock(anon_vma_lock);
+	}
+}
+
+/*
+ * This operation locks against the VM for all pte/vma/mm related
+ * operations that could ever happen on a certain mm. This includes
+ * vmtruncate, try_to_unmap, and all page faults. The holder
+ * must not hold any mm related lock. A single task can't take more
+ * than one mm lock in a row or it would deadlock.
+ */
+void mm_lock(struct mm_struct * mm)
+{
+	down_write(&mm->mmap_sem);
+	mm_lock_unlock(mm, 1);
+}
+
+void mm_unlock(struct mm_struct *mm)
+{
+	mm_lock_unlock(mm, 0);
+	up_write(&mm->mmap_sem);
+}

-- 
