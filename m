Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbYAYF72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbYAYF72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbYAYF6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:58:11 -0500
Received: from relay1.sgi.com ([192.48.171.29]:38997 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753305AbYAYF6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:58:04 -0500
Message-Id: <20080125055801.212744875@sgi.com>
References: <20080125055606.102986685@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 24 Jan 2008 21:56:07 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>
Cc: Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: [patch 1/4] mmu_notifier: Core code
Content-Disposition: inline; filename=mmu_core
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Core code for mmu notifiers.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>

---
 include/linux/mm_types.h     |    8 ++
 include/linux/mmu_notifier.h |  152 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/page-flags.h   |    9 ++
 kernel/fork.c                |    2 
 mm/Kconfig                   |    4 +
 mm/Makefile                  |    1 
 mm/mmap.c                    |    2 
 mm/mmu_notifier.c            |   91 +++++++++++++++++++++++++
 8 files changed, 269 insertions(+)

Index: linux-2.6/include/linux/mm_types.h
===================================================================
--- linux-2.6.orig/include/linux/mm_types.h	2008-01-24 20:59:17.000000000 -0800
+++ linux-2.6/include/linux/mm_types.h	2008-01-24 20:59:19.000000000 -0800
@@ -153,6 +153,10 @@ struct vm_area_struct {
 #endif
 };
 
+struct mmu_notifier_head {
+	struct hlist_head head;
+};
+
 struct mm_struct {
 	struct vm_area_struct * mmap;		/* list of VMAs */
 	struct rb_root mm_rb;
@@ -219,6 +223,10 @@ struct mm_struct {
 	/* aio bits */
 	rwlock_t		ioctx_list_lock;
 	struct kioctx		*ioctx_list;
+
+#ifdef CONFIG_MMU_NOTIFIER
+	struct mmu_notifier_head mmu_notifier; /* MMU notifier list */
+#endif
 };
 
 #endif /* _LINUX_MM_TYPES_H */
Index: linux-2.6/include/linux/mmu_notifier.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/linux/mmu_notifier.h	2008-01-24 20:59:19.000000000 -0800
@@ -0,0 +1,152 @@
+#ifndef _LINUX_MMU_NOTIFIER_H
+#define _LINUX_MMU_NOTIFIER_H
+
+/*
+ * MMU motifier
+ *
+ * Notifier functions for hardware and software that establishes external
+ * references to pages of a Linux system. The notifier calls ensure that
+ * the external mappings are removed when the Linux VM removes memory ranges
+ * or individual pages from a process.
+ *
+ * These fall into two classes
+ *
+ * 1. mmu_notifier
+ *
+ * 	These are callbacks registered with an mm_struct. If mappings are
+ * 	removed from an address space then callbacks are performed.
+ * 	Spinlocks must be held in order to the walk reverse maps and the
+ * 	notifications are performed while the spinlock is held.
+ *
+ *
+ * 2. mmu_rmap_notifier
+ *
+ *	Callbacks for subsystems that provide their own rmaps. These
+ *	need to walk their own rmaps for a page. The invalidate_page
+ *	callback is outside of locks so that we are not in a strictly
+ *	atomic context (but we may be in a PF_MEMALLOC context if the
+ *	notifier is called from reclaim code) and are able to sleep.
+ *	Rmap notifiers need an extra page bit and are only available
+ *	on 64 bit platforms. It is up to the subsystem to mark pags
+ *	as PageExternalRmap as needed to trigger the callbacks. Pages
+ *	must be marked dirty if dirty bits are set in the external
+ *	pte.
+ */
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/rcupdate.h>
+#include <linux/mm_types.h>
+
+struct mmu_notifier_ops;
+
+struct mmu_notifier {
+	struct hlist_node hlist;
+	const struct mmu_notifier_ops *ops;
+};
+
+struct mmu_notifier_ops {
+	void (*release)(struct mmu_notifier *mn,
+			struct mm_struct *mm);
+	int (*age_page)(struct mmu_notifier *mn,
+			struct mm_struct *mm,
+			unsigned long address);
+	void (*invalidate_page)(struct mmu_notifier *mn,
+				struct mm_struct *mm,
+				unsigned long address);
+	void (*invalidate_range)(struct mmu_notifier *mn,
+				 struct mm_struct *mm,
+				 unsigned long start, unsigned long end);
+};
+
+struct mmu_rmap_notifier_ops;
+
+struct mmu_rmap_notifier {
+	struct hlist_node hlist;
+	const struct mmu_rmap_notifier_ops *ops;
+};
+
+struct mmu_rmap_notifier_ops {
+	/*
+	 * Called with the page lock held after ptes are modified or removed
+	 * so that a subsystem with its own rmap's can remove remote ptes
+	 * mapping a page.
+	 */
+	void (*invalidate_page)(struct mmu_rmap_notifier *mrn, struct page *page);
+};
+
+#ifdef CONFIG_MMU_NOTIFIER
+
+extern void mmu_notifier_register(struct mmu_notifier *mn,
+				  struct mm_struct *mm);
+extern void mmu_notifier_unregister(struct mmu_notifier *mn,
+				    struct mm_struct *mm);
+extern void mmu_notifier_release(struct mm_struct *mm);
+extern int mmu_notifier_age_page(struct mm_struct *mm,
+				 unsigned long address);
+
+static inline void mmu_notifier_head_init(struct mmu_notifier_head *mnh)
+{
+	INIT_HLIST_HEAD(&mnh->head);
+}
+
+#define mmu_notifier(function, mm, args...)				\
+	do {								\
+		struct mmu_notifier *__mn;				\
+		struct hlist_node *__n;					\
+									\
+		if (unlikely(!hlist_empty(&(mm)->mmu_notifier.head))) { \
+			rcu_read_lock();				\
+			hlist_for_each_entry_rcu(__mn, __n,		\
+					     &(mm)->mmu_notifier.head,	\
+					     hlist)			\
+				if (__mn->ops->function)		\
+					__mn->ops->function(__mn,	\
+							    mm,		\
+							    args);	\
+			rcu_read_unlock();				\
+		}							\
+	} while (0)
+
+extern void mmu_rmap_notifier_register(struct mmu_rmap_notifier *mrn);
+extern void mmu_rmap_notifier_unregister(struct mmu_rmap_notifier *mrn);
+
+extern struct hlist_head mmu_rmap_notifier_list;
+
+#define mmu_rmap_notifier(function, args...)					\
+	do {									\
+		struct mmu_rmap_notifier *__mrn;				\
+		struct hlist_node *__n;						\
+										\
+		rcu_read_lock();						\
+		hlist_for_each_entry_rcu(__mrn, __n, &mmu_rmap_notifier_list, 	\
+						hlist)				\
+			if (__mrn->ops->function)				\
+				__mrn->ops->function(__mrn, args);		\
+		rcu_read_unlock();						\
+	} while (0);
+
+#else /* CONFIG_MMU_NOTIFIER */
+
+#define mmu_notifier(function, mm, args...) do { } while (0)
+#define mmu_rmap_notifier(function, args...) do { } while (0)
+
+static inline void mmu_notifier_register(struct mmu_notifier *mn,
+						struct mm_struct *mm) {}
+static inline void mmu_notifier_unregister(struct mmu_notifier *mn,
+						struct mm_struct *mm) {}
+static inline void mmu_notifier_release(struct mm_struct *mm) {}
+static inline void mmu_notifier_age(struct mm_struct *mm,
+				unsigned long address)
+{
+	return 0;
+}
+
+static inline void mmu_notifier_head_init(struct mmu_notifier_head *mmh) {}
+
+static inline void mmu_rmap_notifier_register(struct mmu_rmap_notifier *mrn) {}
+static inline void mmu_rmap_notifier_unregister(struct mmu_rmap_notifier *mrn) {}
+
+#endif /* CONFIG_MMU_NOTIFIER */
+
+#endif /* _LINUX_MMU_NOTIFIER_H */
Index: linux-2.6/include/linux/page-flags.h
===================================================================
--- linux-2.6.orig/include/linux/page-flags.h	2008-01-24 20:59:17.000000000 -0800
+++ linux-2.6/include/linux/page-flags.h	2008-01-24 20:59:19.000000000 -0800
@@ -105,6 +105,7 @@
  * 64 bit  |           FIELDS             | ??????         FLAGS         |
  *         63                            32                              0
  */
+#define PG_external_rmap	30	/* Page has external rmap */
 #define PG_uncached		31	/* Page has been mapped as uncached */
 #endif
 
@@ -260,6 +261,14 @@ static inline void __ClearPageTail(struc
 #define SetPageUncached(page)	set_bit(PG_uncached, &(page)->flags)
 #define ClearPageUncached(page)	clear_bit(PG_uncached, &(page)->flags)
 
+#if defined(CONFIG_MMU_NOTIFIER) && defined(CONFIG_64BIT)
+#define PageExternalRmap(page)	test_bit(PG_external_rmap, &(page)->flags)
+#define SetPageExternalRmap(page)	set_bit(PG_external_rmap, &(page)->flags)
+#define ClearPageExternalRmap(page)	clear_bit(PG_external_rmap, &(page)->flags)
+#else
+#define PageExternalRmap(page)	0
+#endif
+
 struct page;	/* forward declaration */
 
 extern void cancel_dirty_page(struct page *page, unsigned int account_size);
Index: linux-2.6/mm/Kconfig
===================================================================
--- linux-2.6.orig/mm/Kconfig	2008-01-24 20:59:17.000000000 -0800
+++ linux-2.6/mm/Kconfig	2008-01-24 20:59:19.000000000 -0800
@@ -193,3 +193,7 @@ config NR_QUICK
 config VIRT_TO_BUS
 	def_bool y
 	depends on !ARCH_NO_VIRT_TO_BUS
+
+config MMU_NOTIFIER
+	def_bool y
+	bool "MMU notifier, for paging KVM/RDMA"
Index: linux-2.6/mm/Makefile
===================================================================
--- linux-2.6.orig/mm/Makefile	2008-01-24 20:59:17.000000000 -0800
+++ linux-2.6/mm/Makefile	2008-01-24 20:59:19.000000000 -0800
@@ -30,4 +30,5 @@ obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
+obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
 
Index: linux-2.6/mm/mmu_notifier.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/mm/mmu_notifier.c	2008-01-24 20:59:19.000000000 -0800
@@ -0,0 +1,91 @@
+/*
+ *  linux/mm/mmu_notifier.c
+ *
+ *  Copyright (C) 2008  Qumranet, Inc.
+ *  Copyright (C) 2008  SGI
+ *  		Christoph Lameter <clameter@sgi.com>
+ *
+ *  This work is licensed under the terms of the GNU GPL, version 2. See
+ *  the COPYING file in the top-level directory.
+ */
+
+#include <linux/mmu_notifier.h>
+#include <linux/module.h>
+
+void mmu_notifier_release(struct mm_struct *mm)
+{
+	struct mmu_notifier *mn;
+	struct hlist_node *n;
+
+	if (unlikely(!hlist_empty(&mm->mmu_notifier.head))) {
+		rcu_read_lock();
+		hlist_for_each_entry_rcu(mn, n,
+					  &mm->mmu_notifier.head, hlist) {
+			if (mn->ops->release)
+				mn->ops->release(mn, mm);
+			hlist_del(&mn->hlist);
+		}
+		rcu_read_unlock();
+	}
+}
+
+/*
+ * If no young bitflag is supported by the hardware, ->age_page can
+ * unmap the address and return 1 or 0 depending if the mapping previously
+ * existed or not.
+ */
+int mmu_notifier_age_page(struct mm_struct *mm, unsigned long address)
+{
+	struct mmu_notifier *mn;
+	struct hlist_node *n;
+	int young = 0;
+
+	if (unlikely(!hlist_empty(&mm->mmu_notifier.head))) {
+		rcu_read_lock();
+		hlist_for_each_entry_rcu(mn, n,
+					  &mm->mmu_notifier.head, hlist) {
+			if (mn->ops->age_page)
+				young |= mn->ops->age_page(mn, mm, address);
+		}
+		rcu_read_unlock();
+	}
+
+	return young;
+}
+
+static DEFINE_SPINLOCK(mmu_notifier_list_lock);
+
+void mmu_notifier_register(struct mmu_notifier *mn, struct mm_struct *mm)
+{
+	spin_lock(&mmu_notifier_list_lock);
+	hlist_add_head(&mn->hlist, &mm->mmu_notifier.head);
+	spin_unlock(&mmu_notifier_list_lock);
+}
+EXPORT_SYMBOL_GPL(mmu_notifier_register);
+
+void mmu_notifier_unregister(struct mmu_notifier *mn, struct mm_struct *mm)
+{
+	spin_lock(&mmu_notifier_list_lock);
+	hlist_del(&mn->hlist);
+	spin_unlock(&mmu_notifier_list_lock);
+}
+EXPORT_SYMBOL_GPL(mmu_notifier_unregister);
+
+HLIST_HEAD(mmu_rmap_notifier_list);
+
+void mmu_rmap_notifier_register(struct mmu_rmap_notifier *mrn)
+{
+	spin_lock(&mmu_notifier_list_lock);
+	hlist_add_head_rcu(&mrn->hlist, &mmu_rmap_notifier_list);
+	spin_unlock(&mmu_notifier_list_lock);
+}
+EXPORT_SYMBOL(mmu_rmap_notifier_register);
+
+void mmu_rmap_notifier_unregister(struct mmu_rmap_notifier *mrn)
+{
+	spin_lock(&mmu_notifier_list_lock);
+	hlist_del_rcu(&mrn->hlist);
+	spin_unlock(&mmu_notifier_list_lock);
+}
+EXPORT_SYMBOL(mmu_rmap_notifier_unregister);
+
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c	2008-01-24 20:59:17.000000000 -0800
+++ linux-2.6/kernel/fork.c	2008-01-24 20:59:19.000000000 -0800
@@ -51,6 +51,7 @@
 #include <linux/random.h>
 #include <linux/tty.h>
 #include <linux/proc_fs.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -359,6 +360,7 @@ static struct mm_struct * mm_init(struct
 
 	if (likely(!mm_alloc_pgd(mm))) {
 		mm->def_flags = 0;
+		mmu_notifier_head_init(&mm->mmu_notifier);
 		return mm;
 	}
 	free_mm(mm);
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c	2008-01-24 20:59:17.000000000 -0800
+++ linux-2.6/mm/mmap.c	2008-01-24 20:59:19.000000000 -0800
@@ -26,6 +26,7 @@
 #include <linux/mount.h>
 #include <linux/mempolicy.h>
 #include <linux/rmap.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -2043,6 +2044,7 @@ void exit_mmap(struct mm_struct *mm)
 	vm_unacct_memory(nr_accounted);
 	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, 0);
 	tlb_finish_mmu(tlb, 0, end);
+	mmu_notifier_release(mm);
 
 	/*
 	 * Walk the list again, actually closing and freeing it,

-- 
