Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbYIKVeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbYIKVeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 17:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756949AbYIKVdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 17:33:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:31403 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874AbYIKVdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 17:33:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,383,1217833200"; 
   d="scan'208";a="615332301"
Message-Id: <20080911204151.152962000@linux-os.sc.intel.com>
References: <20080911203048.929515000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 11 Sep 2008 13:30:54 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 6/7] x86, cpa: remove cpa pool code
Content-Disposition: inline; filename=cleanup_cpa_pool.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupt context no longer splits large page in cpa(). So we can do away
with cpa memory pool code.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/mm/pageattr.c
===================================================================
--- tip.orig/arch/x86/mm/pageattr.c	2008-09-11 13:25:53.000000000 -0700
+++ tip/arch/x86/mm/pageattr.c	2008-09-11 13:25:55.000000000 -0700
@@ -445,112 +445,17 @@
 	return do_split;
 }
 
-static LIST_HEAD(page_pool);
-static unsigned long pool_size, pool_pages, pool_low;
-static unsigned long pool_used, pool_failed;
-
-static void cpa_fill_pool(struct page **ret)
-{
-	gfp_t gfp = GFP_KERNEL;
-	struct page *p;
-
-	/*
-	 * Avoid recursion (on debug-pagealloc) and also signal
-	 * our priority to get to these pagetables:
-	 */
-	if (current->flags & PF_MEMALLOC)
-		return;
-	current->flags |= PF_MEMALLOC;
-
-	/*
-	 * Allocate atomically from atomic contexts:
-	 */
-	if (in_atomic() || irqs_disabled() || debug_pagealloc)
-		gfp =  GFP_ATOMIC | __GFP_NORETRY | __GFP_NOWARN;
-
-	while (pool_pages < pool_size || (ret && !*ret)) {
-		p = alloc_pages(gfp, 0);
-		if (!p) {
-			pool_failed++;
-			break;
-		}
-		/*
-		 * If the call site needs a page right now, provide it:
-		 */
-		if (ret && !*ret) {
-			*ret = p;
-			continue;
-		}
-		spin_lock(&pgd_lock);
-		list_add(&p->lru, &page_pool);
-		pool_pages++;
-		spin_unlock(&pgd_lock);
-	}
-
-	current->flags &= ~PF_MEMALLOC;
-}
-
-#define SHIFT_MB		(20 - PAGE_SHIFT)
-#define ROUND_MB_GB		((1 << 10) - 1)
-#define SHIFT_MB_GB		10
-#define POOL_PAGES_PER_GB	16
-
-void __init cpa_init(void)
-{
-	struct sysinfo si;
-	unsigned long gb;
-
-	si_meminfo(&si);
-	/*
-	 * Calculate the number of pool pages:
-	 *
-	 * Convert totalram (nr of pages) to MiB and round to the next
-	 * GiB. Shift MiB to Gib and multiply the result by
-	 * POOL_PAGES_PER_GB:
-	 */
-	if (debug_pagealloc) {
-		gb = ((si.totalram >> SHIFT_MB) + ROUND_MB_GB) >> SHIFT_MB_GB;
-		pool_size = POOL_PAGES_PER_GB * gb;
-	} else {
-		pool_size = 1;
-	}
-	pool_low = pool_size;
-
-	cpa_fill_pool(NULL);
-	printk(KERN_DEBUG
-	       "CPA: page pool initialized %lu of %lu pages preallocated\n",
-	       pool_pages, pool_size);
-}
-
 static int split_large_page(pte_t *kpte, unsigned long address)
 {
 	unsigned long pfn, pfninc = 1;
 	unsigned int i, level;
 	pte_t *pbase, *tmp;
 	pgprot_t ref_prot;
-	struct page *base;
+	struct page *base = alloc_pages(GFP_KERNEL, 0);
+	if (!base)
+		return -ENOMEM;
 
-	/*
-	 * Get a page from the pool. The pool list is protected by the
-	 * pgd_lock, which we have to take anyway for the split
-	 * operation:
-	 */
 	spin_lock(&pgd_lock);
-	if (list_empty(&page_pool)) {
-		spin_unlock(&pgd_lock);
-		base = NULL;
-		cpa_fill_pool(&base);
-		if (!base)
-			return -ENOMEM;
-		spin_lock(&pgd_lock);
-	} else {
-		base = list_first_entry(&page_pool, struct page, lru);
-		list_del(&base->lru);
-		pool_pages--;
-
-		if (pool_pages < pool_low)
-			pool_low = pool_pages;
-	}
 
 	/*
 	 * Check for races, another CPU might have split this page
@@ -606,13 +511,10 @@
 out_unlock:
 	/*
 	 * If we dropped out via the lookup_address check under
-	 * pgd_lock then stick the page back into the pool:
+	 * pgd_lock then stick the page back into the free pool:
 	 */
-	if (base) {
-		list_add(&base->lru, &page_pool);
-		pool_pages++;
-	} else
-		pool_used++;
+	if (base)
+		__free_page(base);
 	spin_unlock(&pgd_lock);
 
 	return 0;
@@ -900,8 +802,6 @@
 		cpa_flush_all(cache);
 
 out:
-	cpa_fill_pool(NULL);
-
 	return ret;
 }
 
@@ -1170,52 +1070,7 @@
 	 * but that can deadlock->flush only current cpu:
 	 */
 	__flush_tlb_all();
-
-	/*
-	 * Try to refill the page pool here. We can do this only after
-	 * the tlb flush.
-	 */
-	cpa_fill_pool(NULL);
-}
-
-#ifdef CONFIG_DEBUG_FS
-static int dpa_show(struct seq_file *m, void *v)
-{
-	seq_puts(m, "DEBUG_PAGEALLOC\n");
-	seq_printf(m, "pool_size     : %lu\n", pool_size);
-	seq_printf(m, "pool_pages    : %lu\n", pool_pages);
-	seq_printf(m, "pool_low      : %lu\n", pool_low);
-	seq_printf(m, "pool_used     : %lu\n", pool_used);
-	seq_printf(m, "pool_failed   : %lu\n", pool_failed);
-
-	return 0;
-}
-
-static int dpa_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, dpa_show, NULL);
-}
-
-static const struct file_operations dpa_fops = {
-	.open		= dpa_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int __init debug_pagealloc_proc_init(void)
-{
-	struct dentry *de;
-
-	de = debugfs_create_file("debug_pagealloc", 0600, NULL, NULL,
-				 &dpa_fops);
-	if (!de)
-		return -ENOMEM;
-
-	return 0;
 }
-__initcall(debug_pagealloc_proc_init);
-#endif
 
 #ifdef CONFIG_HIBERNATION
 
Index: tip/arch/x86/mm/init_64.c
===================================================================
--- tip.orig/arch/x86/mm/init_64.c	2008-09-11 13:25:47.000000000 -0700
+++ tip/arch/x86/mm/init_64.c	2008-09-11 13:25:55.000000000 -0700
@@ -947,8 +947,6 @@
 		reservedpages << (PAGE_SHIFT-10),
 		datasize >> 10,
 		initsize >> 10);
-
-	cpa_init();
 }
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
Index: tip/arch/x86/mm/init_32.c
===================================================================
--- tip.orig/arch/x86/mm/init_32.c	2008-09-11 13:25:36.000000000 -0700
+++ tip/arch/x86/mm/init_32.c	2008-09-11 13:25:55.000000000 -0700
@@ -1053,7 +1053,6 @@
 	if (boot_cpu_data.wp_works_ok < 0)
 		test_wp_bit();
 
-	cpa_init();
 	save_pg_dir();
 	zap_low_mappings();
 }
Index: tip/include/asm-x86/cacheflush.h
===================================================================
--- tip.orig/include/asm-x86/cacheflush.h	2008-09-11 13:19:52.000000000 -0700
+++ tip/include/asm-x86/cacheflush.h	2008-09-11 13:25:55.000000000 -0700
@@ -99,8 +99,6 @@
 
 void clflush_cache_range(void *addr, unsigned int size);
 
-void cpa_init(void);
-
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
 extern const int rodata_test_data;

-- 

