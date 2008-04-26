Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYDZJce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYDZJce (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 05:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYDZJc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 05:32:27 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:55227 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779AbYDZJc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 05:32:26 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Apr 2008 05:32:24 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EABiREkh20D0b/2dsb2JhbACBU6RxhFw
X-IronPort-AV: E=Sophos;i="4.25,710,1199626200"; 
   d="scan'208";a="103086805"
From: Dave Airlie <airlied@redhat.com>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, arjan@linux.intel.com
Cc: Dave Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>
Subject: [PATCH] x86: create array based interface to chagne page attribute
Date: Sat, 26 Apr 2008 19:27:17 +1000
Message-Id: <1209202037-6513-1-git-send-email-airlied@redhat.com>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <thomas@tungstengraphics.com
References: <thomas@tungstengraphics.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@linux.ie>

When cpa was refactored to the new set_memory_ interfaces, it removed
a special case fast path for AGP systems, which did a lot of page by page
attribute changing and held the flushes until they were finished. The
DRM memory manager also required this to get useable speeds.

This introduces a new interface, which accepts an array of memory addresses
to have attributes changed on and to flush once finished.

Further changes to the AGP stack to actually use this interface will be
published later.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 arch/x86/mm/pageattr-test.c  |   11 ++-
 arch/x86/mm/pageattr.c       |  148 ++++++++++++++++++++++++++++++-----------
 include/asm-x86/cacheflush.h |    4 +
 3 files changed, 119 insertions(+), 44 deletions(-)

diff --git a/arch/x86/mm/pageattr-test.c b/arch/x86/mm/pageattr-test.c
index 75f1b10..9cb7186 100644
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -111,6 +111,7 @@ static int pageattr_test(void)
 	unsigned int level;
 	int i, k;
 	int err;
+	unsigned long test_addr;
 
 	if (print)
 		printk(KERN_INFO "CPA self-test:\n");
@@ -165,8 +166,9 @@ static int pageattr_test(void)
 			continue;
 		}
 
-		err = change_page_attr_clear(addr[i], len[i],
-					       __pgprot(_PAGE_GLOBAL));
+		test_addr = addr[i];
+		err = change_page_attr_clear(&test_addr, len[i],
+					     __pgprot(_PAGE_GLOBAL), 0);
 		if (err < 0) {
 			printk(KERN_ERR "CPA %d failed %d\n", i, err);
 			failed++;
@@ -198,8 +200,9 @@ static int pageattr_test(void)
 			failed++;
 			continue;
 		}
-		err = change_page_attr_set(addr[i], len[i],
-					     __pgprot(_PAGE_GLOBAL));
+		test_addr = addr[i];
+		err = change_page_attr_set(&test_addr, len[i],
+					   __pgprot(_PAGE_GLOBAL), 0);
 		if (err < 0) {
 			printk(KERN_ERR "CPA reverting failed: %d\n", err);
 			failed++;
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index bd5e05c..ee16b1b 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -25,13 +25,15 @@
  * The current flushing context - we pass it instead of 5 arguments:
  */
 struct cpa_data {
-	unsigned long	vaddr;
+	unsigned long	*vaddr;
 	pgprot_t	mask_set;
 	pgprot_t	mask_clr;
 	int		numpages;
-	int		flushtlb;
+	int             curaddr;
 	unsigned long	pfn;
 	unsigned	force_split : 1;
+	unsigned        flushtlb : 1;
+	unsigned        array : 1;
 };
 
 #ifdef CONFIG_X86_64
@@ -119,6 +121,35 @@ static void __cpa_flush_range(void *arg)
 	__flush_tlb_all();
 }
 
+static void cpa_flush_array(unsigned long *start, int numpages, int cache)
+{
+	unsigned int i, level;
+	unsigned long *addr;
+
+	BUG_ON(irqs_disabled());
+
+	on_each_cpu(__cpa_flush_range, NULL, 1, 1);
+
+	if (!cache)
+		return;
+
+	/*
+	 * We only need to flush on one CPU,
+	 * clflush is a MESI-coherent instruction that
+	 * will cause all other CPUs to flush the same
+	 * cachelines:
+	 */
+	for (i = 0, addr = start; i < numpages; i++, addr++) {
+		pte_t *pte = lookup_address(*addr, &level);
+
+		/*
+		 * Only flush present addresses:
+		 */
+		if (pte && (pte_val(*pte) & _PAGE_PRESENT))
+			clflush_cache_range((void *) *addr, PAGE_SIZE);
+	}
+}
+
 static void cpa_flush_range(unsigned long start, int numpages, int cache)
 {
 	unsigned int i, level;
@@ -532,11 +563,12 @@ out_unlock:
 
 static int __change_page_attr(struct cpa_data *cpa, int primary)
 {
-	unsigned long address = cpa->vaddr;
+	unsigned long address;
 	int do_split, err;
 	unsigned int level;
 	pte_t *kpte, old_pte;
 
+	address = cpa->vaddr[cpa->curaddr];
 repeat:
 	kpte = lookup_address(address, &level);
 	if (!kpte)
@@ -548,7 +580,7 @@ repeat:
 			return 0;
 		printk(KERN_WARNING "CPA: called for zero pte. "
 		       "vaddr = %lx cpa->vaddr = %lx\n", address,
-		       cpa->vaddr);
+		       *cpa->vaddr);
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -612,19 +644,25 @@ static int cpa_process_alias(struct cpa_data *cpa)
 {
 	struct cpa_data alias_cpa;
 	int ret = 0;
+	unsigned long temp_cpa_vaddr, vaddr;
 
 	if (cpa->pfn > max_pfn_mapped)
 		return 0;
 
+	vaddr = cpa->vaddr[cpa->curaddr];
+
 	/*
 	 * No need to redo, when the primary call touched the direct
 	 * mapping already:
 	 */
-	if (!within(cpa->vaddr, PAGE_OFFSET,
+	if (!within(vaddr, PAGE_OFFSET,
 		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))) {
 
 		alias_cpa = *cpa;
-		alias_cpa.vaddr = (unsigned long) __va(cpa->pfn << PAGE_SHIFT);
+		temp_cpa_vaddr = (unsigned long)__va(cpa->pfn << PAGE_SHIFT);
+		alias_cpa.vaddr = &temp_cpa_vaddr;
+		alias_cpa.curaddr = 0;
+		alias_cpa.array = 0;
 
 		ret = __change_page_attr_set_clr(&alias_cpa, 0);
 	}
@@ -636,7 +674,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	 * No need to redo, when the primary call touched the high
 	 * mapping already:
 	 */
-	if (within(cpa->vaddr, (unsigned long) _text, (unsigned long) _end))
+	if (within(vaddr, (unsigned long) _text, (unsigned long) _end))
 		return 0;
 
 	/*
@@ -647,8 +685,11 @@ static int cpa_process_alias(struct cpa_data *cpa)
 		return 0;
 
 	alias_cpa = *cpa;
-	alias_cpa.vaddr =
-		(cpa->pfn << PAGE_SHIFT) + __START_KERNEL_map - phys_base;
+	temp_cpa_vaddr = (cpa->pfn << PAGE_SHIFT) + __START_KERNEL_map -
+		phys_base;
+	alias_cpa.vaddr = &temp_cpa_vaddr;
+	alias_cpa.curaddr = 0;
+	alias_cpa.array = 0;
 
 	/*
 	 * The high mapping range is imprecise, so ignore the return value.
@@ -686,7 +727,10 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 		 */
 		BUG_ON(cpa->numpages > numpages);
 		numpages -= cpa->numpages;
-		cpa->vaddr += cpa->numpages * PAGE_SIZE;
+		if (cpa->array)
+			cpa->curaddr++;
+		else
+			cpa->vaddr += cpa->numpages * PAGE_SIZE;
 	}
 	return 0;
 }
@@ -697,9 +741,9 @@ static inline int cache_attr(pgprot_t attr)
 		(_PAGE_PAT | _PAGE_PAT_LARGE | _PAGE_PWT | _PAGE_PCD);
 }
 
-static int change_page_attr_set_clr(unsigned long addr, int numpages,
+static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 				    pgprot_t mask_set, pgprot_t mask_clr,
-				    int force_split)
+				    int force_split, int array)
 {
 	struct cpa_data cpa;
 	int ret, cache, checkalias;
@@ -714,12 +758,14 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 		return 0;
 
 	/* Ensure we are PAGE_SIZE aligned */
-	if (addr & ~PAGE_MASK) {
-		addr &= PAGE_MASK;
-		/*
-		 * People should not be passing in unaligned addresses:
-		 */
-		WARN_ON_ONCE(1);
+	if (!array) {
+		if (*addr & ~PAGE_MASK) {
+			*addr &= PAGE_MASK;
+			/*
+			 * People should not be passing in unaligned addresses:
+			 */
+			WARN_ON_ONCE(1);
+		}
 	}
 
 	cpa.vaddr = addr;
@@ -728,6 +774,7 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 	cpa.mask_clr = mask_clr;
 	cpa.flushtlb = 0;
 	cpa.force_split = force_split;
+	cpa.array = array;
 
 	/* No alias checking for _NX bit modifications */
 	checkalias = (pgprot_val(mask_set) | pgprot_val(mask_clr)) != _PAGE_NX;
@@ -753,7 +800,10 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 	 * wbindv):
 	 */
 	if (!ret && cpu_has_clflush)
-		cpa_flush_range(addr, numpages, cache);
+		if (cpa.array)
+			cpa_flush_array(addr, numpages, cache);
+		else
+			cpa_flush_range(*addr, numpages, cache);
 	else
 		cpa_flush_all(cache);
 
@@ -763,22 +813,24 @@ out:
 	return ret;
 }
 
-static inline int change_page_attr_set(unsigned long addr, int numpages,
-				       pgprot_t mask)
+static inline int change_page_attr_set(unsigned long *addr, int numpages,
+				       pgprot_t mask, int array)
 {
-	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0), 0);
+	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0), 0,
+		array);
 }
 
-static inline int change_page_attr_clear(unsigned long addr, int numpages,
-					 pgprot_t mask)
+static inline int change_page_attr_clear(unsigned long *addr, int numpages,
+					 pgprot_t mask, int array)
 {
-	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask, 0);
+	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask, 0,
+		array);
 }
 
 int _set_memory_uc(unsigned long addr, int numpages)
 {
-	return change_page_attr_set(addr, numpages,
-				    __pgprot(_PAGE_CACHE_UC));
+	return change_page_attr_set(&addr, numpages,
+				    __pgprot(_PAGE_CACHE_UC), 0);
 }
 
 int set_memory_uc(unsigned long addr, int numpages)
@@ -791,10 +843,24 @@ int set_memory_uc(unsigned long addr, int numpages)
 }
 EXPORT_SYMBOL(set_memory_uc);
 
+int set_memory_array_uc(unsigned long *addrs, int numaddrs)
+{
+	return change_page_attr_set(addrs, numaddrs,
+				    __pgprot(_PAGE_PCD), 1);
+}
+EXPORT_SYMBOL(set_memory_array_uc);
+
+int set_memory_array_wb(unsigned long *addrs, int numaddrs)
+{
+	return change_page_attr_set(addrs, numaddrs,
+				    __pgprot(_PAGE_PCD | _PAGE_PWT), 1);
+}
+EXPORT_SYMBOL(set_memory_array_wb);
+
 int _set_memory_wc(unsigned long addr, int numpages)
 {
-	return change_page_attr_set(addr, numpages,
-				    __pgprot(_PAGE_CACHE_WC));
+	return change_page_attr_set(&addr, numpages,
+				    __pgprot(_PAGE_CACHE_WC), 0);
 }
 
 int set_memory_wc(unsigned long addr, int numpages)
@@ -812,8 +878,8 @@ EXPORT_SYMBOL(set_memory_wc);
 
 int _set_memory_wb(unsigned long addr, int numpages)
 {
-	return change_page_attr_clear(addr, numpages,
-				      __pgprot(_PAGE_CACHE_MASK));
+	return change_page_attr_clear(&addr, numpages,
+				      __pgprot(_PAGE_CACHE_MASK), 0);
 }
 
 int set_memory_wb(unsigned long addr, int numpages)
@@ -826,35 +892,35 @@ EXPORT_SYMBOL(set_memory_wb);
 
 int set_memory_x(unsigned long addr, int numpages)
 {
-	return change_page_attr_clear(addr, numpages, __pgprot(_PAGE_NX));
+	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_NX), 0);
 }
 EXPORT_SYMBOL(set_memory_x);
 
 int set_memory_nx(unsigned long addr, int numpages)
 {
-	return change_page_attr_set(addr, numpages, __pgprot(_PAGE_NX));
+	return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_NX), 0);
 }
 EXPORT_SYMBOL(set_memory_nx);
 
 int set_memory_ro(unsigned long addr, int numpages)
 {
-	return change_page_attr_clear(addr, numpages, __pgprot(_PAGE_RW));
+	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_RW), 0);
 }
 
 int set_memory_rw(unsigned long addr, int numpages)
 {
-	return change_page_attr_set(addr, numpages, __pgprot(_PAGE_RW));
+	return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_RW), 0);
 }
 
 int set_memory_np(unsigned long addr, int numpages)
 {
-	return change_page_attr_clear(addr, numpages, __pgprot(_PAGE_PRESENT));
+	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_PRESENT), 0);
 }
 
 int set_memory_4k(unsigned long addr, int numpages)
 {
-	return change_page_attr_set_clr(addr, numpages, __pgprot(0),
-					__pgprot(0), 1);
+	return change_page_attr_set_clr(&addr, numpages, __pgprot(0),
+					__pgprot(0), 1, 0);
 }
 
 int set_pages_uc(struct page *page, int numpages)
@@ -907,7 +973,8 @@ int set_pages_rw(struct page *page, int numpages)
 
 static int __set_pages_p(struct page *page, int numpages)
 {
-	struct cpa_data cpa = { .vaddr = (unsigned long) page_address(page),
+	unsigned long tempaddr = (unsigned long)page_address(page);
+	struct cpa_data cpa = { .vaddr = &tempaddr,
 				.numpages = numpages,
 				.mask_set = __pgprot(_PAGE_PRESENT | _PAGE_RW),
 				.mask_clr = __pgprot(0)};
@@ -917,7 +984,8 @@ static int __set_pages_p(struct page *page, int numpages)
 
 static int __set_pages_np(struct page *page, int numpages)
 {
-	struct cpa_data cpa = { .vaddr = (unsigned long) page_address(page),
+	unsigned long tempaddr = (unsigned long)page_address(page);
+	struct cpa_data cpa = { .vaddr = &tempaddr,
 				.numpages = numpages,
 				.mask_set = __pgprot(0),
 				.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW)};
diff --git a/include/asm-x86/cacheflush.h b/include/asm-x86/cacheflush.h
index f4c0ab5..344e7ee 100644
--- a/include/asm-x86/cacheflush.h
+++ b/include/asm-x86/cacheflush.h
@@ -66,6 +66,10 @@ int set_memory_rw(unsigned long addr, int numpages);
 int set_memory_np(unsigned long addr, int numpages);
 int set_memory_4k(unsigned long addr, int numpages);
 
+
+int set_memory_array_uc(unsigned long *addrs, int numaddrs);
+int set_memory_array_wb(unsigned long *addrs, int numaddrs);
+
 /*
  * For legacy compatibility with the old APIs, a few functions
  * are provided that work on a "struct page".
-- 
1.5.3.3

