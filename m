Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZCKTSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZCKTSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZCKTSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:18:35 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:35502 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbZCKTSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:18:34 -0400
Date: Wed, 11 Mar 2009 20:18:14 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Stoyan Gaydarov <stoyboyker@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 06/25] [mips] BUG to BUG_ON changes
Message-ID: <20090311191814.GA3112@linux-mips.org>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com> <1236661850-8237-2-git-send-email-stoyboyker@gmail.com> <1236661850-8237-3-git-send-email-stoyboyker@gmail.com> <1236661850-8237-4-git-send-email-stoyboyker@gmail.com> <1236661850-8237-5-git-send-email-stoyboyker@gmail.com> <1236661850-8237-6-git-send-email-stoyboyker@gmail.com> <1236661850-8237-7-git-send-email-stoyboyker@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236661850-8237-7-git-send-email-stoyboyker@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 12:10:31AM -0500, Stoyan Gaydarov wrote:

I wonder if this patch series was generated with
http://www.emn.fr/x-info/coccinelle/rules/bugon.html ?  That semantic
patch misses the same places that your patch is missing.  The patch below
should catch all occurances below arch/mips.

  Ralf

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 arch/mips/jazz/jazzdma.c |    3 +--
 arch/mips/kernel/traps.c |    3 +--
 arch/mips/mm/highmem.c   |    9 +++------
 arch/mips/mm/init.c      |    3 +--
 arch/mips/mm/ioremap.c   |    9 +++------
 5 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/arch/mips/jazz/jazzdma.c b/arch/mips/jazz/jazzdma.c
index c672c08..f0fd636 100644
--- a/arch/mips/jazz/jazzdma.c
+++ b/arch/mips/jazz/jazzdma.c
@@ -68,8 +68,7 @@ static int __init vdma_init(void)
 	 */
 	pgtbl = (VDMA_PGTBL_ENTRY *)__get_free_pages(GFP_KERNEL | GFP_DMA,
 						    get_order(VDMA_PGTBL_SIZE));
-	if (!pgtbl)
-		BUG();
+	BUG_ON(!pgtbl);
 	dma_cache_wback_inv((unsigned long)pgtbl, VDMA_PGTBL_SIZE);
 	pgtbl = (VDMA_PGTBL_ENTRY *)KSEG1ADDR(pgtbl);
 
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index b2d7041..89956d5 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -1277,8 +1277,7 @@ static void *set_vi_srs_handler(int n, vi_handler_t addr, int srs)
 	u32 *w;
 	unsigned char *b;
 
-	if (!cpu_has_veic && !cpu_has_vint)
-		BUG();
+	BUG_ON(!cpu_has_veic && !cpu_has_vint);
 
 	if (addr == NULL) {
 		handler = (unsigned long) do_default_vi;
diff --git a/arch/mips/mm/highmem.c b/arch/mips/mm/highmem.c
index 8f2cd8e..060d28d 100644
--- a/arch/mips/mm/highmem.c
+++ b/arch/mips/mm/highmem.c
@@ -17,8 +17,7 @@ void *__kmap(struct page *page)
 
 void __kunmap(struct page *page)
 {
-	if (in_interrupt())
-		BUG();
+	BUG_ON(in_interrupt());
 	if (!PageHighMem(page))
 		return;
 	kunmap_high(page);
@@ -46,8 +45,7 @@ void *__kmap_atomic(struct page *page, enum km_type type)
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
-	if (!pte_none(*(kmap_pte-idx)))
-		BUG();
+	BUG_ON(!pte_none(*(kmap_pte - idx)));
 #endif
 	set_pte(kmap_pte-idx, mk_pte(page, kmap_prot));
 	local_flush_tlb_one((unsigned long)vaddr);
@@ -66,8 +64,7 @@ void __kunmap_atomic(void *kvaddr, enum km_type type)
 		return;
 	}
 
-	if (vaddr != __fix_to_virt(FIX_KMAP_BEGIN+idx))
-		BUG();
+	BUG_ON(vaddr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
 
 	/*
 	 * force other mappings to Oops if they'll try to access
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 137c14b..d934894 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -307,8 +307,7 @@ void __init fixrange_init(unsigned long start, unsigned long end,
 				if (pmd_none(*pmd)) {
 					pte = (pte_t *) alloc_bootmem_low_pages(PAGE_SIZE);
 					set_pmd(pmd, __pmd((unsigned long)pte));
-					if (pte != pte_offset_kernel(pmd, 0))
-						BUG();
+					BUG_ON(pte != pte_offset_kernel(pmd, 0));
 				}
 				vaddr += PMD_SIZE;
 			}
diff --git a/arch/mips/mm/ioremap.c b/arch/mips/mm/ioremap.c
index 59945b9..0c43248 100644
--- a/arch/mips/mm/ioremap.c
+++ b/arch/mips/mm/ioremap.c
@@ -27,8 +27,7 @@ static inline void remap_area_pte(pte_t * pte, unsigned long address,
 	end = address + size;
 	if (end > PMD_SIZE)
 		end = PMD_SIZE;
-	if (address >= end)
-		BUG();
+	BUG_ON(address >= end);
 	pfn = phys_addr >> PAGE_SHIFT;
 	do {
 		if (!pte_none(*pte)) {
@@ -52,8 +51,7 @@ static inline int remap_area_pmd(pmd_t * pmd, unsigned long address,
 	if (end > PGDIR_SIZE)
 		end = PGDIR_SIZE;
 	phys_addr -= address;
-	if (address >= end)
-		BUG();
+	BUG_ON(address >= end);
 	do {
 		pte_t * pte = pte_alloc_kernel(pmd, address);
 		if (!pte)
@@ -75,8 +73,7 @@ static int remap_area_pages(unsigned long address, phys_t phys_addr,
 	phys_addr -= address;
 	dir = pgd_offset(&init_mm, address);
 	flush_cache_all();
-	if (address >= end)
-		BUG();
+	BUG_ON(address >= end);
 	do {
 		pud_t *pud;
 		pmd_t *pmd;
