Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbYBHWId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbYBHWId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbYBHWHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:07:03 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51251 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753020AbYBHWG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:06:58 -0500
Message-Id: <20080208220656.791732808@sgi.com>
References: <20080208220616.089936205@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 08 Feb 2008 14:06:21 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com
Subject: [patch 5/6] mmu_notifier: Support for drivers with revers maps (f.e. for XPmem)
Content-Disposition: inline; filename=mmu_rmap_support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These special additional callbacks are required because XPmem (and likely
other mechanisms) do use their own rmap (multiple processes on a series
of remote Linux instances may be accessing the memory of a process).
F.e. XPmem may have to send out notifications to remote Linux instances
and receive confirmation before a page can be freed.

So we handle this like an additional Linux reverse map that is walked after
the existing rmaps have been walked. We leave the walking to the driver that
is then able to use something else than a spinlock to walk its reverse
maps. So we can actually call the driver without holding spinlocks while
we hold the Pagelock.

However, we cannot determine the mm_struct that a page belongs to at
that point. The mm_struct can only be determined from the rmaps by the
device driver.

We add another pageflag (PageExternalRmap) that is set if a page has
been remotely mapped (f.e. by a process from another Linux instance).
We can then only perform the callbacks for pages that are actually in
remote use.

Rmap notifiers need an extra page bit and are only available
on 64 bit platforms. This functionality is not available on 32 bit!

A notifier that uses the reverse maps callbacks does not need to provide
the invalidate_page() method that is called when locks are held.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mmu_notifier.h |   65 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/page-flags.h   |   11 +++++++
 mm/mmu_notifier.c            |   34 ++++++++++++++++++++++
 mm/rmap.c                    |    9 +++++
 4 files changed, 119 insertions(+)

Index: linux-2.6/include/linux/page-flags.h
===================================================================
--- linux-2.6.orig/include/linux/page-flags.h	2008-02-08 12:35:14.000000000 -0800
+++ linux-2.6/include/linux/page-flags.h	2008-02-08 12:44:33.000000000 -0800
@@ -105,6 +105,7 @@
  * 64 bit  |           FIELDS             | ??????         FLAGS         |
  *         63                            32                              0
  */
+#define PG_external_rmap	30	/* Page has external rmap */
 #define PG_uncached		31	/* Page has been mapped as uncached */
 #endif
 
@@ -296,6 +297,16 @@ static inline void __ClearPageTail(struc
 #define SetPageUncached(page)	set_bit(PG_uncached, &(page)->flags)
 #define ClearPageUncached(page)	clear_bit(PG_uncached, &(page)->flags)
 
+#if defined(CONFIG_MMU_NOTIFIER) && defined(CONFIG_64BIT)
+#define PageExternalRmap(page)	test_bit(PG_external_rmap, &(page)->flags)
+#define SetPageExternalRmap(page) set_bit(PG_external_rmap, &(page)->flags)
+#define ClearPageExternalRmap(page) clear_bit(PG_external_rmap, \
+							&(page)->flags)
+#else
+#define ClearPageExternalRmap(page) do {} while (0)
+#define PageExternalRmap(page)	0
+#endif
+
 struct page;	/* forward declaration */
 
 extern void cancel_dirty_page(struct page *page, unsigned int account_size);
Index: linux-2.6/include/linux/mmu_notifier.h
===================================================================
--- linux-2.6.orig/include/linux/mmu_notifier.h	2008-02-08 12:35:14.000000000 -0800
+++ linux-2.6/include/linux/mmu_notifier.h	2008-02-08 12:44:33.000000000 -0800
@@ -23,6 +23,18 @@
  * 	where sleeping is allowed or in atomic contexts. A flag is passed
  * 	to indicate an atomic context.
  *
+ *
+ * 2. mmu_rmap_notifier
+ *
+ *	Callbacks for subsystems that provide their own rmaps. These
+ *	need to walk their own rmaps for a page. The invalidate_page
+ *	callback is outside of locks so that we are not in a strictly
+ *	atomic context (but we may be in a PF_MEMALLOC context if the
+ *	notifier is called from reclaim code) and are able to sleep.
+ *
+ *	Rmap notifiers need an extra page bit and are only available
+ *	on 64 bit platforms.
+ *
  *	Pages must be marked dirty if dirty bits are found to be set in
  *	the external ptes.
  */
@@ -89,6 +101,23 @@ struct mmu_notifier_ops {
 				 int atomic);
 };
 
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
+	void (*invalidate_page)(struct mmu_rmap_notifier *mrn,
+						struct page *page);
+};
+
 #ifdef CONFIG_MMU_NOTIFIER
 
 /*
@@ -139,6 +168,27 @@ static inline void mmu_notifier_head_ini
 		}							\
 	} while (0)
 
+extern void mmu_rmap_notifier_register(struct mmu_rmap_notifier *mrn);
+extern void mmu_rmap_notifier_unregister(struct mmu_rmap_notifier *mrn);
+
+/* Must hold PageLock */
+extern void mmu_rmap_export_page(struct page *page);
+
+extern struct hlist_head mmu_rmap_notifier_list;
+
+#define mmu_rmap_notifier(function, args...)				\
+	do {								\
+		struct mmu_rmap_notifier *__mrn;			\
+		struct hlist_node *__n;					\
+									\
+		rcu_read_lock();					\
+		hlist_for_each_entry_rcu(__mrn, __n,			\
+				&mmu_rmap_notifier_list, hlist)		\
+			if (__mrn->ops->function)			\
+				__mrn->ops->function(__mrn, args);	\
+		rcu_read_unlock();					\
+	} while (0);
+
 #else /* CONFIG_MMU_NOTIFIER */
 
 /*
@@ -157,6 +207,16 @@ static inline void mmu_notifier_head_ini
 		};							\
 	} while (0)
 
+#define mmu_rmap_notifier(function, args...)				\
+	do {								\
+		if (0) {						\
+			struct mmu_rmap_notifier *__mrn;		\
+									\
+			__mrn = (struct mmu_rmap_notifier *)(0x00ff);	\
+			__mrn->ops->function(__mrn, args);		\
+		}							\
+	} while (0);
+
 static inline void mmu_notifier_register(struct mmu_notifier *mn,
 						struct mm_struct *mm) {}
 static inline void mmu_notifier_unregister(struct mmu_notifier *mn,
@@ -170,6 +230,11 @@ static inline int mmu_notifier_age_page(
 
 static inline void mmu_notifier_head_init(struct mmu_notifier_head *mmh) {}
 
+static inline void mmu_rmap_notifier_register(struct mmu_rmap_notifier *mrn)
+									{}
+static inline void mmu_rmap_notifier_unregister(struct mmu_rmap_notifier *mrn)
+									{}
+
 #endif /* CONFIG_MMU_NOTIFIER */
 
 #endif /* _LINUX_MMU_NOTIFIER_H */
Index: linux-2.6/mm/mmu_notifier.c
===================================================================
--- linux-2.6.orig/mm/mmu_notifier.c	2008-02-08 12:44:24.000000000 -0800
+++ linux-2.6/mm/mmu_notifier.c	2008-02-08 12:44:33.000000000 -0800
@@ -74,3 +74,37 @@ void mmu_notifier_unregister(struct mmu_
 }
 EXPORT_SYMBOL_GPL(mmu_notifier_unregister);
 
+#ifdef CONFIG_64BIT
+static DEFINE_SPINLOCK(mmu_notifier_list_lock);
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
+/*
+ * Export a page.
+ *
+ * Pagelock must be held.
+ * Must be called before a page is put on an external rmap.
+ */
+void mmu_rmap_export_page(struct page *page)
+{
+	BUG_ON(!PageLocked(page));
+	SetPageExternalRmap(page);
+}
+EXPORT_SYMBOL(mmu_rmap_export_page);
+
+#endif
Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c	2008-02-08 12:44:30.000000000 -0800
+++ linux-2.6/mm/rmap.c	2008-02-08 12:44:33.000000000 -0800
@@ -497,6 +497,10 @@ int page_mkclean(struct page *page)
 		struct address_space *mapping = page_mapping(page);
 		if (mapping) {
 			ret = page_mkclean_file(mapping, page);
+			if (unlikely(PageExternalRmap(page))) {
+				mmu_rmap_notifier(invalidate_page, page);
+				ClearPageExternalRmap(page);
+			}
 			if (page_test_dirty(page)) {
 				page_clear_dirty(page);
 				ret = 1;
@@ -1013,6 +1017,11 @@ int try_to_unmap(struct page *page, int 
 	else
 		ret = try_to_unmap_file(page, migration);
 
+	if (unlikely(PageExternalRmap(page))) {
+		mmu_rmap_notifier(invalidate_page, page);
+		ClearPageExternalRmap(page);
+	}
+
 	if (!page_mapped(page))
 		ret = SWAP_SUCCESS;
 	return ret;

-- 
