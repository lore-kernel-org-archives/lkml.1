Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbYLPLmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbYLPLmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758174AbYLPLmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:42:31 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:39706 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758350AbYLPLm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:42:26 -0500
Message-Id: <4947A245.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 16 Dec 2008 11:42:45 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: simplify alloc_low_page()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neither of the callers really needs the physical address this function
returns, so eliminate the pointless argument.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/init_32.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- linux-2.6.28-rc8/arch/x86/mm/init_32.c	2008-12-11 14:36:52.000000000 +0100
+++ 2.6.28-rc8-i386-alloc-low-page/arch/x86/mm/init_32.c	2008-10-13 16:16:13.000000000 +0200
@@ -67,7 +67,7 @@ static unsigned long __meminitdata table
 
 static int __initdata after_init_bootmem;
 
-static __init void *alloc_low_page(unsigned long *phys)
+static __init void *alloc_low_page(void)
 {
 	unsigned long pfn = table_end++;
 	void *adr;
@@ -77,7 +77,6 @@ static __init void *alloc_low_page(unsig
 
 	adr = __va(pfn * PAGE_SIZE);
 	memset(adr, 0, PAGE_SIZE);
-	*phys  = pfn * PAGE_SIZE;
 	return adr;
 }
 
@@ -92,12 +91,11 @@ static pmd_t * __init one_md_table_init(
 	pmd_t *pmd_table;
 
 #ifdef CONFIG_X86_PAE
-	unsigned long phys;
 	if (!(pgd_val(*pgd) & _PAGE_PRESENT)) {
 		if (after_init_bootmem)
 			pmd_table = (pmd_t *)alloc_bootmem_low_pages(PAGE_SIZE);
 		else
-			pmd_table = (pmd_t *)alloc_low_page(&phys);
+			pmd_table = (pmd_t *)alloc_low_page();
 		paravirt_alloc_pmd(&init_mm, __pa(pmd_table) >> PAGE_SHIFT);
 		set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
 		pud = pud_offset(pgd, 0);
@@ -126,10 +124,8 @@ static pte_t * __init one_page_table_ini
 			if (!page_table)
 				page_table =
 				(pte_t *)alloc_bootmem_low_pages(PAGE_SIZE);
-		} else {
-			unsigned long phys;
-			page_table = (pte_t *)alloc_low_page(&phys);
-		}
+		} else
+			page_table = (pte_t *)alloc_low_page();
 
 		paravirt_alloc_pte(&init_mm, __pa(page_table) >> PAGE_SHIFT);
 		set_pmd(pmd, __pmd(__pa(page_table) | _PAGE_TABLE));



