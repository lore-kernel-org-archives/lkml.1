Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbZCLNL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbZCLNL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZCLNLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:11:12 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:38959 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbZCLNLL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:11:11 -0400
Message-Id: <49B91826.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 13:11:50 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: create a non-zero sized bm_pte only when needed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: kernel image size reduction

Since in most configurations the pmd page needed maps the same range of
virtual addresses which is also mapped by the earlier inserted one for
covering FIX_DBGP_BASE, that page (and its insertion in the page
tables) can be avoided altogether by detecting the condition at compile
time.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/ioremap.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- linux-2.6.29-rc7/arch/x86/mm/ioremap.c	2009-03-04 09:10:19.000000000 +0100
+++ 2.6.29-rc7-x86-avoid-bm_pte/arch/x86/mm/ioremap.c	2009-02-18 15:34:02.000000000 +0100
@@ -490,7 +490,12 @@ static int __init early_ioremap_debug_se
 early_param("early_ioremap_debug", early_ioremap_debug_setup);
 
 static __initdata int after_paging_init;
-static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
+#define __FIXADDR_TOP (-PAGE_SIZE)
+static pte_t bm_pte[(__fix_to_virt(FIX_DBGP_BASE)
+		     ^ __fix_to_virt(FIX_BTMAP_BEGIN)) >> PMD_SHIFT
+		    ? PAGE_SIZE / sizeof(pte_t) : 0] __page_aligned_bss;
+#undef __FIXADDR_TOP
+static __initdata pte_t *bm_ptep;
 
 static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 {
@@ -505,6 +510,8 @@ static inline pmd_t * __init early_iorem
 
 static inline pte_t * __init early_ioremap_pte(unsigned long addr)
 {
+	if (!sizeof(bm_pte))
+		return &bm_ptep[pte_index(addr)];
 	return &bm_pte[pte_index(addr)];
 }
 
@@ -516,8 +523,14 @@ void __init early_ioremap_init(void)
 		printk(KERN_INFO "early_ioremap_init()\n");
 
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
-	memset(bm_pte, 0, sizeof(bm_pte));
-	pmd_populate_kernel(&init_mm, pmd, bm_pte);
+	if (sizeof(bm_pte)) {
+		memset(bm_pte, 0, sizeof(bm_pte));
+		pmd_populate_kernel(&init_mm, pmd, bm_pte);
+	} else {
+		bm_ptep = pte_offset_kernel(pmd, 0);
+		if (early_ioremap_debug)
+			printk(KERN_INFO "bm_ptep=%p\n", bm_ptep);
+	}
 
 	/*
 	 * The boot-ioremap range spans multiple pmds, for which



