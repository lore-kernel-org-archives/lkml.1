Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYIIWne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYIIWne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 18:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYIIWnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 18:43:24 -0400
Received: from gw.goop.org ([64.81.55.164]:35010 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbYIIWnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 18:43:24 -0400
Message-ID: <48C6FC0A.7070102@goop.org>
Date: Tue, 09 Sep 2008 15:43:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alex Nixon <alex.nixon@citrix.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] mm: define USE_SPLIT_PTLOCKS rather than repeating expression
References: <> <1220959508-13806-1-git-send-email-alex.nixon@citrix.com> <48C6BB00.9040607@goop.org> <48C6CCD7.8030800@citrix.com> <48C6DE6E.1070804@goop.org> <48C6F80E.8010509@citrix.com>
In-Reply-To: <48C6F80E.8010509@citrix.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define USE_SPLIT_PTLOCKS as a constant expression rather than repeating
"NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS" all over the place.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c       |    2 +-
 include/linux/mm.h       |    6 +++---
 include/linux/mm_types.h |   10 ++++++----
 include/linux/sched.h    |    6 +++---
 4 files changed, 13 insertions(+), 11 deletions(-)

===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -805,7 +805,7 @@
 {
 	spinlock_t *ptl = NULL;
 
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#if USE_SPLIT_PTLOCKS
 	ptl = __pte_lockptr(page);
 	spin_lock_nest_lock(ptl, &mm->page_table_lock);
 #endif
===================================================================
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -914,7 +914,7 @@
 }
 #endif /* CONFIG_MMU && !__ARCH_HAS_4LEVEL_HACK */
 
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#if USE_SPLIT_PTLOCKS
 /*
  * We tuck a spinlock to guard each pagetable page into its struct page,
  * at page->private, with BUILD_BUG_ON to make sure that this will not
@@ -927,14 +927,14 @@
 } while (0)
 #define pte_lock_deinit(page)	((page)->mapping = NULL)
 #define pte_lockptr(mm, pmd)	({(void)(mm); __pte_lockptr(pmd_page(*(pmd)));})
-#else
+#else	/* !USE_SPLIT_PTLOCKS */
 /*
  * We use mm->page_table_lock to guard all pagetable pages of the mm.
  */
 #define pte_lock_init(page)	do {} while (0)
 #define pte_lock_deinit(page)	do {} while (0)
 #define pte_lockptr(mm, pmd)	({(void)(pmd); &(mm)->page_table_lock;})
-#endif /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+#endif /* USE_SPLIT_PTLOCKS */
 
 static inline void pgtable_page_ctor(struct page *page)
 {
===================================================================
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -21,11 +21,13 @@
 
 struct address_space;
 
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#define USE_SPLIT_PTLOCKS	(NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS)
+
+#if USE_SPLIT_PTLOCKS
 typedef atomic_long_t mm_counter_t;
-#else  /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+#else  /* !USE_SPLIT_PTLOCKS */
 typedef unsigned long mm_counter_t;
-#endif /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+#endif /* !USE_SPLIT_PTLOCKS */
 
 /*
  * Each physical page in the system has a struct page associated with
@@ -65,7 +67,7 @@
 						 * see PAGE_MAPPING_ANON below.
 						 */
 	    };
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#if USE_SPLIT_PTLOCKS
 	    spinlock_t ptl;
 #endif
 	    struct kmem_cache *slab;	/* SLUB: Pointer to slab */
===================================================================
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -352,7 +352,7 @@
 extern void arch_unmap_area(struct mm_struct *, unsigned long);
 extern void arch_unmap_area_topdown(struct mm_struct *, unsigned long);
 
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#if USE_SPLIT_PTLOCKS
 /*
  * The mm counters are not protected by its page_table_lock,
  * so must be incremented atomically.
@@ -363,7 +363,7 @@
 #define inc_mm_counter(mm, member) atomic_long_inc(&(mm)->_##member)
 #define dec_mm_counter(mm, member) atomic_long_dec(&(mm)->_##member)
 
-#else  /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+#else  /* !USE_SPLIT_PTLOCKS */
 /*
  * The mm counters are protected by its page_table_lock,
  * so can be incremented directly.
@@ -374,7 +374,7 @@
 #define inc_mm_counter(mm, member) (mm)->_##member++
 #define dec_mm_counter(mm, member) (mm)->_##member--
 
-#endif /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+#endif /* !USE_SPLIT_PTLOCKS */
 
 #define get_mm_rss(mm)					\
 	(get_mm_counter(mm, file_rss) + get_mm_counter(mm, anon_rss))


