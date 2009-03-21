Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZCUAxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZCUAxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 20:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbZCUAxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 20:53:38 -0400
Received: from gw.goop.org ([64.81.55.164]:40518 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbZCUAxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 20:53:38 -0400
Message-ID: <49C43A8E.5090203@goop.org>
Date: Fri, 20 Mar 2009 17:53:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Jan Beulich <jbeulich@novell.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] revert "x86: create a non-zero sized bm_pte only when needed"
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 698609bdcd35d0641f4c6622c83680ab1a6d67cb.

69860 breaks Xen booting, as it relies on head*.S to set up the fixmap
pagetables (as a side-effect of initializing the USB debug port).
Xen, however, does not boot via head*.S, and so the fixmap area is
not initialized.

The specific symptom of the crash is a fault in dmi_scan(), because
the pointer that early_ioremap returns is not actually present.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 55e127f..83ed74a 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -487,12 +487,7 @@ static int __init early_ioremap_debug_setup(char *str)
 early_param("early_ioremap_debug", early_ioremap_debug_setup);
 
 static __initdata int after_paging_init;
-#define __FIXADDR_TOP (-PAGE_SIZE)
-static pte_t bm_pte[(__fix_to_virt(FIX_DBGP_BASE)
-		     ^ __fix_to_virt(FIX_BTMAP_BEGIN)) >> PMD_SHIFT
-		    ? PAGE_SIZE / sizeof(pte_t) : 0] __page_aligned_bss;
-#undef __FIXADDR_TOP
-static __initdata pte_t *bm_ptep;
+static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
 
 static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 {
@@ -507,8 +502,6 @@ static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 
 static inline pte_t * __init early_ioremap_pte(unsigned long addr)
 {
-	if (!sizeof(bm_pte))
-		return &bm_ptep[pte_index(addr)];
 	return &bm_pte[pte_index(addr)];
 }
 
@@ -526,14 +519,8 @@ void __init early_ioremap_init(void)
 		slot_virt[i] = fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*i);
 
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
-	if (sizeof(bm_pte)) {
-		memset(bm_pte, 0, sizeof(bm_pte));
-		pmd_populate_kernel(&init_mm, pmd, bm_pte);
-	} else {
-		bm_ptep = pte_offset_kernel(pmd, 0);
-		if (early_ioremap_debug)
-			printk(KERN_INFO "bm_ptep=%p\n", bm_ptep);
-	}
+	memset(bm_pte, 0, sizeof(bm_pte));
+	pmd_populate_kernel(&init_mm, pmd, bm_pte);
 
 	/*
 	 * The boot-ioremap range spans multiple pmds, for which


