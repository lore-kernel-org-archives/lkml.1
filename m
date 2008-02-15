Return-Path: <linux-kernel-owner+w=401wt.eu-S1763524AbYBOGup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763524AbYBOGup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 01:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762089AbYBOGtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 01:49:39 -0500
Received: from relay2.sgi.com ([192.48.171.30]:38864 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756790AbYBOGtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 01:49:36 -0500
Message-Id: <20080215064933.177587095@sgi.com>
References: <20080215064859.384203497@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 14 Feb 2008 22:49:03 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Kanoj Sarcar <kanojsarcar@yahoo.com>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com
Subject: [patch 4/6] mmu_notifier: Skeleton driver for a simple mmu_notifier
Content-Disposition: inline; filename=mmu_skeleton
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is example code for a simple device driver interface to unmap
pages that were externally mapped.

Locking is simple through a single lock that is used to protect the
device drivers data structures as well as a counter that tracks the
active invalidates on a single address space.

The invalidation of extern ptes must be possible with code that does
not require sleeping. The lock is taken for all driver operations on
the mmu that the driver manages. Locking could be made more sophisticated
but I think this is going to be okay for most uses.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 Documentation/mmu_notifier/skeleton.c |  267 ++++++++++++++++++++++++++++++++++
 1 file changed, 267 insertions(+)

Index: linux-2.6/Documentation/mmu_notifier/skeleton.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/Documentation/mmu_notifier/skeleton.c	2008-02-14 22:23:18.000000000 -0800
@@ -0,0 +1,267 @@
+#include <linux/mm.h>
+#include <linux/mmu_notifier.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/pagemap.h>
+
+/*
+ * Skeleton for an mmu notifier without rmap callbacks and no need to slepp
+ * during invalidate_page().
+ *
+ * (C) 2008 Silicon Graphics, Inc.
+ * 		Christoph Lameter <clameter@sgi.com>
+ *
+ * Note that the locking is fairly basic. One can add various optimizations
+ * here and there. There is a single lock for an address space which should be
+ * satisfactory for most cases. If not then the lock can be split like the
+ * pte_lock in Linux. It is most likely best to place the locks in the
+ * page table structure or into whatever the external mmu uses to
+ * track the mappings.
+ */
+
+struct my_mmu {
+	/* MMU notifier specific fields */
+	struct mmu_notifier notifier;
+	spinlock_t lock;	/* Protects counter and invidual zaps */
+	int invalidates;	/* Number of active range_invalidates */
+};
+
+/*
+ * Called with m->lock held
+ */
+static void my_mmu_insert_page(struct my_mmu *m,
+		unsigned long address, unsigned long pfn)
+{
+	/* Must be provided */
+	printk(KERN_INFO "insert page %p address=%lx pfn=%ld\n",
+							m, address, pfn);
+}
+
+/*
+ * Called with m->lock held (optional but usually required to
+ * protect data structures of the driver).
+ */
+static void my_mmu_zap_page(struct my_mmu *m, unsigned long address)
+{
+	/* Must be provided */
+	printk(KERN_INFO "zap page %p address=%lx\n", m, address);
+}
+
+/*
+ * Called with m->lock held
+ */
+static void my_mmu_zap_range(struct my_mmu *m,
+	unsigned long start, unsigned long end, int atomic)
+{
+	/* Must be provided */
+	printk(KERN_INFO "zap range %p address=%lx-%lx atomic=%d\n",
+						m, start, end, atomic);
+}
+
+/*
+ * Zap an individual page.
+ *
+ * Serialization with establishment of a new external pte occurs
+ * through the pte lock. The m->lock is taken to serialize access
+ * to the driver private data. If the driver does not need this
+ * serialization then the lock can be omitted.
+ */
+static void my_mmu_invalidate_page(struct mmu_notifier *mn,
+	struct mm_struct *mm, unsigned long address)
+{
+	struct my_mmu *m = container_of(mn, struct my_mmu, notifier);
+
+	spin_lock(&m->lock);
+	my_mmu_zap_page(m, address);
+	spin_unlock(&m->lock);
+}
+
+/*
+ * Increment and decrement of the number of range invalidates
+ */
+static inline void inc_active(struct my_mmu *m)
+{
+	spin_lock(&m->lock);
+	m->invalidates++;
+	spin_unlock(&m->lock);
+}
+
+static inline void dec_active(struct my_mmu *m)
+{
+	spin_lock(&m->lock);
+	m->invalidates--;
+	spin_unlock(&m->lock);
+}
+
+static void my_mmu_invalidate_range_begin(struct mmu_notifier *mn,
+	struct mm_struct *mm, unsigned long start, unsigned long end,
+	int atomic)
+{
+	struct my_mmu *m = container_of(mn, struct my_mmu, notifier);
+
+	inc_active(m);	/* Holds off new references */
+	my_mmu_zap_range(m, start, end, atomic);
+}
+
+static void my_mmu_invalidate_range_end(struct mmu_notifier *mn,
+	struct mm_struct *mm, unsigned long start, unsigned long end,
+	int atomic)
+{
+	struct my_mmu *m = container_of(mn, struct my_mmu, notifier);
+
+	dec_active(m);		/* Enables new references */
+}
+
+/*
+ * Populate a page.
+ *
+ * A return value of-EAGAIN means please retry this operation.
+ *
+ * Acquisition of mmap_sem can be omitted if the caller already holds
+ * the semaphore.
+ */
+struct page *my_mmu_populate_page(struct my_mmu *m,
+	struct vm_area_struct *vma,
+	unsigned long address, int atomic, int write)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct page *page = ERR_PTR(-EAGAIN);
+	int err;
+	int done = 0;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep, pte;
+	spinlock_t *ptl;
+
+	/* No need to do anything if a range invalidate is running */
+	if (m->invalidates)
+		return ERR_PTR(-EAGAIN);
+
+	if (atomic) {
+		if (!down_read_trylock(&mm->mmap_sem))
+			return ERR_PTR(-EAGAIN);
+	} else
+		down_read(&mm->mmap_sem);
+
+	do {
+		page = ERR_PTR(-EAGAIN);
+
+		if (m->invalidates)
+			break;
+
+		pgd = pgd_offset(mm, address);
+		if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
+			goto check;
+
+		pud = pud_offset(pgd, address);
+		if (pud_none(*pud) || unlikely(pud_bad(*pud)))
+			goto check;
+
+		pmd = pmd_offset(pud, address);
+		if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
+			goto check;
+
+		ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+		if (!ptep)
+			goto check;
+
+		pte = *ptep;
+		if (!pte_present(pte))
+			goto pte_unlock;
+		if (write && !pte_write(pte))
+			goto pte_unlock;
+
+		page = vm_normal_page(vma, address, pte);
+		if (page) {
+			done = 1;
+			/*
+			 * The m->lock is held to ensure that the count of
+			 * current invalidates stays constant.
+			 * invalidate_page() is held off by the pte lock.
+			 */
+			spin_lock(&m->lock);
+
+			if (!m->invalidates)
+				my_mmu_insert_page(m, address, page_to_pfn(page));
+			else
+				page = ERR_PTR(-EAGAIN);
+
+			spin_unlock(&m->lock);
+		}
+pte_unlock:
+		pte_unmap_unlock(ptep, ptl);
+check:
+
+		if (done || atomic)
+			break;
+
+		/*
+		 * Need to run the page fault handler to get the pte entry
+		 * setup right.
+		 */
+		err = get_user_pages(current, vma->vm_mm, address, 1,
+					write, 1, NULL, NULL);
+
+		if (err < 0) {
+			page = ERR_PTR(err);
+			break;
+		}
+
+	} while (!done);
+
+	up_read(&vma->vm_mm->mmap_sem);
+	return page;
+}
+
+/*
+ * All other threads accessing this mm_struct must have terminated by now.
+ */
+static void my_mmu_release(struct mmu_notifier *mn, struct mm_struct *mm)
+{
+	struct my_mmu *m = container_of(mn, struct my_mmu, notifier);
+
+	my_mmu_zap_range(m, 0, TASK_SIZE, 0);
+	kfree(m);
+	printk(KERN_INFO "MMU Notifier detaching\n");
+}
+
+static struct mmu_notifier_ops my_mmu_ops = {
+	my_mmu_release,
+	NULL,			/* No aging function */
+	my_mmu_invalidate_page,
+	my_mmu_invalidate_range_begin,
+	my_mmu_invalidate_range_end
+};
+
+/*
+ * This function must be called to activate callbacks from a process
+ */
+int my_mmu_attach_to_process(struct mm_struct *mm)
+{
+	struct my_mmu *m = kzalloc(sizeof(struct my_mmu), GFP_KERNEL);
+
+	if (!m)
+		return -ENOMEM;
+
+	m->notifier.ops = &my_mmu_ops;
+	spin_lock_init(&m->lock);
+
+	/*
+	 * mmap_sem handling can be omitted if it is guaranteed that
+	 * the context from which my_mmu_attach_to_process is called
+	 * is already holding a writelock on mmap_sem.
+	 */
+	down_write(&mm->mmap_sem);
+	mmu_notifier_register(&m->notifier, mm);
+	up_write(&mm->mmap_sem);
+
+	/*
+	 * RCU sync is expensive but necessary if we need to guarantee
+	 * that multiple threads running on other cpus have seen the
+	 * notifier changes.
+	 */
+	synchronize_rcu();
+	return 0;
+}
+

-- 
