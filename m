Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbYIJITO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbYIJITO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 04:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbYIJITB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 04:19:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38477 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbYIJITA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 04:19:00 -0400
Date: Wed, 10 Sep 2008 10:18:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: alex.nixon@citrix.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] xen: fix pinning when not using split pte locks
Message-ID: <20080910081843.GE15255@elte.hu>
References: <1220959508-13806-1-git-send-email-alex.nixon@citrix.com> <48C6BB00.9040607@goop.org> <48C6CCD7.8030800@citrix.com> <48C6DE6E.1070804@goop.org> <48C6F80E.8010509@citrix.com> <48C6FC0D.9040009@goop.org> <20080909155306.921d453b.akpm@linux-foundation.org> <48C706E8.4020200@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C706E8.4020200@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > What are the effects of the bug which you fixed?
> >
> > Do you consider this to be 2.6.27 material?  2.6.26.x?  2.6.25.x?
> >   
> 
> This is a fix for a bug which only exists in tip.git.

instead of putting it into the x86 tree i've split out the mm patch into 
a separate, -git based isolated topic branch (tip/core/xen) - the 
coordinates for it are below. The commit ID is:

  4ef2d41: mm: define USE_SPLIT_PTLOCKS rather than repeating expression

Andrew, any objection to this approach? If it's fine to you then after 
testing this commit will eventually go to linux-next via 
tip/auto-core-next. (the x86 tree merges this tree and i've applied the 
Xen fix after that merge.)

	Ingo

----------------------------------------------->
the latest tip/core/xen topic tree is at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/xen

------------------>
Jeremy Fitzhardinge (1):
      mm: define USE_SPLIT_PTLOCKS rather than repeating expression


 arch/x86/xen/mmu.c       |    2 +-
 include/linux/mm.h       |    6 +++---
 include/linux/mm_types.h |   10 ++++++----
 include/linux/sched.h    |    6 +++---
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index aa37469..2e1b640 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -646,7 +646,7 @@ static spinlock_t *lock_pte(struct page *page)
 {
 	spinlock_t *ptl = NULL;
 
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#if USE_SPLIT_PTLOCKS
 	ptl = __pte_lockptr(page);
 	spin_lock(ptl);
 #endif
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 72a15dc..4194bf8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -919,7 +919,7 @@ static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long a
 }
 #endif /* CONFIG_MMU && !__ARCH_HAS_4LEVEL_HACK */
 
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#if USE_SPLIT_PTLOCKS
 /*
  * We tuck a spinlock to guard each pagetable page into its struct page,
  * at page->private, with BUILD_BUG_ON to make sure that this will not
@@ -932,14 +932,14 @@ static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long a
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
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index bf33413..9d49fa3 100644
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
@@ -65,7 +67,7 @@ struct page {
 						 * see PAGE_MAPPING_ANON below.
 						 */
 	    };
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#if USE_SPLIT_PTLOCKS
 	    spinlock_t ptl;
 #endif
 	    struct kmem_cache *slab;	/* SLUB: Pointer to slab */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3d9120c..272c353 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -352,7 +352,7 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 extern void arch_unmap_area(struct mm_struct *, unsigned long);
 extern void arch_unmap_area_topdown(struct mm_struct *, unsigned long);
 
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#if USE_SPLIT_PTLOCKS
 /*
  * The mm counters are not protected by its page_table_lock,
  * so must be incremented atomically.
@@ -363,7 +363,7 @@ extern void arch_unmap_area_topdown(struct mm_struct *, unsigned long);
 #define inc_mm_counter(mm, member) atomic_long_inc(&(mm)->_##member)
 #define dec_mm_counter(mm, member) atomic_long_dec(&(mm)->_##member)
 
-#else  /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+#else  /* !USE_SPLIT_PTLOCKS */
 /*
  * The mm counters are protected by its page_table_lock,
  * so can be incremented directly.
@@ -374,7 +374,7 @@ extern void arch_unmap_area_topdown(struct mm_struct *, unsigned long);
 #define inc_mm_counter(mm, member) (mm)->_##member++
 #define dec_mm_counter(mm, member) (mm)->_##member--
 
-#endif /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+#endif /* !USE_SPLIT_PTLOCKS */
 
 #define get_mm_rss(mm)					\
 	(get_mm_counter(mm, file_rss) + get_mm_counter(mm, anon_rss))
