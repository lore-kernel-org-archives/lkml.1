Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbYCaFUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbYCaFUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 01:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbYCaFUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 01:20:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbYCaFUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 01:20:04 -0400
Subject: [PATCH] x86: create array based interface to change page attribute
From: Dave Airlie <airlied@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, arjan@linux.intel.com,
       thomas@tungstengraphics.com
Content-Type: text/plain
Date: Mon, 31 Mar 2008 15:19:48 +1000
Message-Id: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
 arch/x86/mm/pageattr-test.c  |   12 ++-
 arch/x86/mm/pageattr.c       |  164 +++++++++++++++++++++++++++++++-----------
 include/asm-x86/cacheflush.h |    3 +
 3 files changed, 132 insertions(+), 47 deletions(-)

diff --git a/arch/x86/mm/pageattr-test.c b/arch/x86/mm/pageattr-test.c
index 75f1b10..22c1496 100644
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -111,6 +111,7 @@ static int pageattr_test(void)
 	unsigned int level;
 	int i, k;
 	int err;
+	unsigned long test_addr;
 
 	if (print)
 		printk(KERN_INFO "CPA self-test:\n");
@@ -165,8 +166,10 @@ static int pageattr_test(void)
 			continue;
 		}
 
-		err = change_page_attr_clear(addr[i], len[i],
-					       __pgprot(_PAGE_GLOBAL));
+
+		test_addr = addr[i];
+		err = change_page_attr_clear(&test_addr, len[i],
+					     __pgprot(_PAGE_GLOBAL), 0);
 		if (err < 0) {
 			printk(KERN_ERR "CPA %d failed %d\n", i, err);
 			failed++;
@@ -198,8 +201,9 @@ static int pageattr_test(void)
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
index 7b79f6b..6124726 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -22,14 +22,18 @@
  * The current flushing context - we pass it instead of 5 arguments:
  */
 struct cpa_data {
-	unsigned long	vaddr;
+	unsigned long	*vaddr;
 	pgprot_t	mask_set;
 	pgprot_t	mask_clr;
 	int		numpages;
-	int		flushtlb;
+	int		flags;
 	unsigned long	pfn;
+	int             curaddr;
 };
 
+#define CPA_FLUSHTLB 1
+#define CPA_ARRAY 2
+
 #ifdef CONFIG_X86_64
 
 static inline unsigned long highmap_start_pfn(void)
@@ -145,6 +149,35 @@ static void cpa_flush_range(unsigned long start, int numpages, int cache)
 	}
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
 /*
  * Certain areas of memory on x86 require very specific protection flags,
  * for example the BIOS area or kernel text. Callers don't always get this
@@ -349,7 +382,7 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 		 */
 		new_pte = pfn_pte(pte_pfn(old_pte), canon_pgprot(new_prot));
 		__set_pmd_pte(kpte, address, new_pte);
-		cpa->flushtlb = 1;
+		cpa->flags |= CPA_FLUSHTLB;
 		do_split = 0;
 	}
 
@@ -527,11 +560,13 @@ out_unlock:
 
 static int __change_page_attr(struct cpa_data *cpa, int primary)
 {
-	unsigned long address = cpa->vaddr;
+	unsigned long address;
 	int do_split, err;
 	unsigned int level;
 	pte_t *kpte, old_pte;
 
+	address = cpa->vaddr[cpa->curaddr];
+
 repeat:
 	kpte = lookup_address(address, &level);
 	if (!kpte)
@@ -543,7 +578,7 @@ repeat:
 			return 0;
 		printk(KERN_WARNING "CPA: called for zero pte. "
 		       "vaddr = %lx cpa->vaddr = %lx\n", address,
-		       cpa->vaddr);
+		       *cpa->vaddr);
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -570,7 +605,7 @@ repeat:
 		 */
 		if (pte_val(old_pte) != pte_val(new_pte)) {
 			set_pte_atomic(kpte, new_pte);
-			cpa->flushtlb = 1;
+			cpa->flags |= CPA_FLUSHTLB;
 		}
 		cpa->numpages = 1;
 		return 0;
@@ -594,7 +629,7 @@ repeat:
 	 */
 	err = split_large_page(kpte, address);
 	if (!err) {
-		cpa->flushtlb = 1;
+		cpa->flags |= CPA_FLUSHTLB;
 		goto repeat;
 	}
 
@@ -607,6 +642,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 {
 	struct cpa_data alias_cpa;
 	int ret = 0;
+	unsigned long temp_cpa_vaddr, vaddr;
 
 	if (cpa->pfn > max_pfn_mapped)
 		return 0;
@@ -615,11 +651,16 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	 * No need to redo, when the primary call touched the direct
 	 * mapping already:
 	 */
-	if (!within(cpa->vaddr, PAGE_OFFSET,
+	vaddr = cpa->vaddr[cpa->curaddr];
+
+	if (!within(vaddr, PAGE_OFFSET,
 		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))) {
 
 		alias_cpa = *cpa;
-		alias_cpa.vaddr = (unsigned long) __va(cpa->pfn << PAGE_SHIFT);
+		temp_cpa_vaddr = (unsigned long) __va(cpa->pfn << PAGE_SHIFT);
+		alias_cpa.vaddr = &temp_cpa_vaddr;
+		alias_cpa.curaddr = 0;
+		alias_cpa.flags &= ~CPA_ARRAY;
 
 		ret = __change_page_attr_set_clr(&alias_cpa, 0);
 	}
@@ -631,7 +672,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	 * No need to redo, when the primary call touched the high
 	 * mapping already:
 	 */
-	if (within(cpa->vaddr, (unsigned long) _text, (unsigned long) _end))
+	if (within(vaddr, (unsigned long) _text, (unsigned long) _end))
 		return 0;
 
 	/*
@@ -642,8 +683,11 @@ static int cpa_process_alias(struct cpa_data *cpa)
 		return 0;
 
 	alias_cpa = *cpa;
-	alias_cpa.vaddr =
-		(cpa->pfn << PAGE_SHIFT) + __START_KERNEL_map - phys_base;
+	temp_cpa_vaddr = (cpa->pfn << PAGE_SHIFT) +
+			 __START_KERNEL_map - phys_base;
+	alias_cpa.vaddr = &temp_cpa_vaddr;
+	alias_cpa.curaddr = 0;
+	alias_cpa.flags &= ~CPA_ARRAY;
 
 	/*
 	 * The high mapping range is imprecise, so ignore the return value.
@@ -681,7 +725,10 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 		 */
 		BUG_ON(cpa->numpages > numpages);
 		numpages -= cpa->numpages;
-		cpa->vaddr += cpa->numpages * PAGE_SIZE;
+		if (cpa->flags & CPA_ARRAY)
+			cpa->curaddr++;
+		else
+			*cpa->vaddr += cpa->numpages * PAGE_SIZE;
 	}
 	return 0;
 }
@@ -692,8 +739,9 @@ static inline int cache_attr(pgprot_t attr)
 		(_PAGE_PAT | _PAGE_PAT_LARGE | _PAGE_PWT | _PAGE_PCD);
 }
 
-static int change_page_attr_set_clr(unsigned long addr, int numpages,
-				    pgprot_t mask_set, pgprot_t mask_clr)
+static int change_page_attr_set_clr(unsigned long *addr, int numpages,
+				    pgprot_t mask_set, pgprot_t mask_clr,
+				    int array)
 {
 	struct cpa_data cpa;
 	int ret, cache, checkalias;
@@ -708,19 +756,25 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
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
 	cpa.numpages = numpages;
 	cpa.mask_set = mask_set;
 	cpa.mask_clr = mask_clr;
-	cpa.flushtlb = 0;
+	cpa.flags = 0;
+	cpa.curaddr = 0;
+
+	if (array)
+		cpa.flags |= CPA_ARRAY;
 
 	/* No alias checking for _NX bit modifications */
 	checkalias = (pgprot_val(mask_set) | pgprot_val(mask_clr)) != _PAGE_NX;
@@ -730,7 +784,7 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 	/*
 	 * Check whether we really changed something:
 	 */
-	if (!cpa.flushtlb)
+	if (!(cpa.flags & CPA_FLUSHTLB))
 		goto out;
 
 	/*
@@ -746,7 +800,10 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 	 * wbindv):
 	 */
 	if (!ret && cpu_has_clflush)
-		cpa_flush_range(addr, numpages, cache);
+		if (cpa.flags & CPA_ARRAY)
+			cpa_flush_array(addr, numpages, cache);
+		else
+			cpa_flush_range(*addr, numpages, cache);
 	else
 		cpa_flush_all(cache);
 
@@ -756,57 +813,74 @@ out:
 	return ret;
 }
 
-static inline int change_page_attr_set(unsigned long addr, int numpages,
-				       pgprot_t mask)
+static inline int change_page_attr_set(unsigned long *addr, int numpages,
+				       pgprot_t mask, int array)
 {
-	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0));
+	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0),
+					array);
 }
 
-static inline int change_page_attr_clear(unsigned long addr, int numpages,
-					 pgprot_t mask)
+static inline int change_page_attr_clear(unsigned long *addr, int numpages,
+					 pgprot_t mask, int array)
 {
-	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask);
+	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask,
+					array);
 }
 
 int set_memory_uc(unsigned long addr, int numpages)
 {
-	return change_page_attr_set(addr, numpages,
-				    __pgprot(_PAGE_PCD));
+	return change_page_attr_set(&addr, numpages,
+				    __pgprot(_PAGE_PCD), 0);
 }
 EXPORT_SYMBOL(set_memory_uc);
 
+int set_memory_array_uc(unsigned long *addr, int addrinarray)
+{
+	return change_page_attr_set(addr, addrinarray,
+				    __pgprot(_PAGE_PCD), 1);
+}
+EXPORT_SYMBOL(set_memory_array_uc);
+
 int set_memory_wb(unsigned long addr, int numpages)
 {
-	return change_page_attr_clear(addr, numpages,
-				      __pgprot(_PAGE_PCD | _PAGE_PWT));
+	return change_page_attr_clear(&addr, numpages,
+				      __pgprot(_PAGE_PCD | _PAGE_PWT), 0);
 }
 EXPORT_SYMBOL(set_memory_wb);
 
+int set_memory_array_wb(unsigned long *addr, int addrinarray)
+{
+	return change_page_attr_clear(addr, addrinarray,
+				      __pgprot(_PAGE_PCD | _PAGE_PWT), 1);
+}
+EXPORT_SYMBOL(set_memory_array_wb);
+
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
+	return change_page_attr_clear(&addr, numpages,
+				      __pgprot(_PAGE_PRESENT), 0);
 }
 
 int set_pages_uc(struct page *page, int numpages)
@@ -859,20 +933,24 @@ int set_pages_rw(struct page *page, int numpages)
 
 static int __set_pages_p(struct page *page, int numpages)
 {
-	struct cpa_data cpa = { .vaddr = (unsigned long) page_address(page),
+	unsigned long tempaddr = (unsigned long)page_address(page);
+	struct cpa_data cpa = { .vaddr = &tempaddr,
 				.numpages = numpages,
 				.mask_set = __pgprot(_PAGE_PRESENT | _PAGE_RW),
-				.mask_clr = __pgprot(0)};
+				.mask_clr = __pgprot(0),
+				.flags = 0};
 
 	return __change_page_attr_set_clr(&cpa, 1);
 }
 
 static int __set_pages_np(struct page *page, int numpages)
 {
-	struct cpa_data cpa = { .vaddr = (unsigned long) page_address(page),
+	unsigned long tempaddr = (unsigned long)page_address(page);
+	struct cpa_data cpa = { .vaddr = &tempaddr,
 				.numpages = numpages,
 				.mask_set = __pgprot(0),
-				.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW)};
+				.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW),
+				.flags = 0};
 
 	return __change_page_attr_set_clr(&cpa, 1);
 }
diff --git a/include/asm-x86/cacheflush.h b/include/asm-x86/cacheflush.h
index 5396c21..5646584 100644
--- a/include/asm-x86/cacheflush.h
+++ b/include/asm-x86/cacheflush.h
@@ -42,6 +42,9 @@ int set_memory_ro(unsigned long addr, int numpages);
 int set_memory_rw(unsigned long addr, int numpages);
 int set_memory_np(unsigned long addr, int numpages);
 
+int set_memory_array_uc(unsigned long *addr, int addrinarray);
+int set_memory_array_wb(unsigned long *addr, int addrinarray);
+
 void clflush_cache_range(void *addr, unsigned int size);
 
 void cpa_init(void);




