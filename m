Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZBIKpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZBIKpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:45:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZBIKox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:44:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51019 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbZBIKow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:44:52 -0500
Date: Mon, 9 Feb 2009 11:44:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, pgtable.h: macro-ify *_page() methods
Message-ID: <20090209104438.GA16729@elte.hu>
References: <498CCFB5.3000706@goop.org> <20090209102211.GJ20467@elte.hu> <20090209103322.GL20467@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090209103322.GL20467@elte.hu>
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


Another header-spaghetti fallout is below.

The mmzone.h dependency looks quite ugly.

	Ingo

--------------->
>From e5f7f202f31fd05e9de7e1ba5a7b30de7855f5aa Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 9 Feb 2009 11:42:57 +0100
Subject: [PATCH] x86, pgtable.h: macro-ify *_page() methods
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

The p?d_page() methods still rely on highlevel types and methods:

In file included from arch/x86/kernel/early_printk.c:18:
/home/mingo/tip/arch/x86/include/asm/pgtable.h: In function ‘pmd_page’:
/home/mingo/tip/arch/x86/include/asm/pgtable.h:516: error: implicit declaration of function â__pfn_to_sectionâ
/home/mingo/tip/arch/x86/include/asm/pgtable.h:516: error: initialization makes pointer from integer without a cast
/home/mingo/tip/arch/x86/include/asm/pgtable.h:516: error: implicit declaration of function ‘__section_mem_map_addr’
/home/mingo/tip/arch/x86/include/asm/pgtable.h:516: error: return makes pointer from integer without a cast

So convert them to macros and document the type dependency.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/pgtable.h |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index a80a956..76696e9 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -473,10 +473,11 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 	return (unsigned long)__va(pmd_val(pmd) & PTE_PFN_MASK);
 }
 
-static inline struct page *pmd_page(pmd_t pmd)
-{
-	return pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT);
-}
+/*
+ * Currently stuck as a macro due to indirect forward reference to
+ * linux/mmzone.h's __section_mem_map_addr() definition:
+ */
+#define pmd_page(pmd)	pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT)
 
 /*
  * the pmd page can be thought of an array like this: pmd_t[PTRS_PER_PMD]
@@ -543,10 +544,11 @@ static inline unsigned long pud_page_vaddr(pud_t pud)
 	return (unsigned long)__va((unsigned long)pud_val(pud) & PTE_PFN_MASK);
 }
 
-static inline struct page *pud_page(pud_t pud)
-{
-	return pfn_to_page(pud_val(pud) >> PAGE_SHIFT);
-}
+/*
+ * Currently stuck as a macro due to indirect forward reference to
+ * linux/mmzone.h's __section_mem_map_addr() definition:
+ */
+#define pud_page(pud)		pfn_to_page(pud_val(pud) >> PAGE_SHIFT)
 
 /* Find an entry in the second-level page table.. */
 static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
@@ -582,10 +584,11 @@ static inline unsigned long pgd_page_vaddr(pgd_t pgd)
 	return (unsigned long)__va((unsigned long)pgd_val(pgd) & PTE_PFN_MASK);
 }
 
-static inline struct page *pgd_page(pgd_t pgd)
-{
-	return pfn_to_page(pgd_val(pgd) >> PAGE_SHIFT);
-}
+/*
+ * Currently stuck as a macro due to indirect forward reference to
+ * linux/mmzone.h's __section_mem_map_addr() definition:
+ */
+#define pgd_page(pgd)		pfn_to_page(pgd_val(pgd) >> PAGE_SHIFT)
 
 /* to find an entry in a page-table-directory. */
 static inline unsigned pud_index(unsigned long address)
