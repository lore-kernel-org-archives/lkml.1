Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZBILAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZBILAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZBILAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:00:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41612 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbZBILA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:00:29 -0500
Date: Mon, 9 Feb 2009 12:00:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, pgtable.h: fix 2-level 32-bit build
Message-ID: <20090209110009.GA26517@elte.hu>
References: <498CCFB5.3000706@goop.org> <20090209102211.GJ20467@elte.hu> <20090209103322.GL20467@elte.hu> <20090209104438.GA16729@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209104438.GA16729@elte.hu>
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


Please double check the fix below.

Regarding the page.h include - maybe we should introduce asm/page_types.h just for 
the bare essentials? OTOH ... x86 asm/page.h already seems bare essentials.

Regarding types, each include file should be self-sufficient.

	Ingo

----------->

>From c47c1b1f3a9d6973108020df1dcab7604f7774dd Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 9 Feb 2009 11:57:45 +0100
Subject: [PATCH] x86, pgtable.h: fix 2-level 32-bit build

- pmd_flags() needs to be available on 2-levels too
- provide pud_large() wrapper as well
- include page.h - it provides basic types relied on by pgtable.h

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/page.h    |    9 +++++----
 arch/x86/include/asm/pgtable.h |    9 +++++++++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 0b16b64..823cc93 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -139,10 +139,6 @@ static inline pmdval_t native_pmd_val(pmd_t pmd)
 	return pmd.pmd;
 }
 
-static inline pmdval_t pmd_flags(pmd_t pmd)
-{
-	return native_pmd_val(pmd) & PTE_FLAGS_MASK;
-}
 #else  /* PAGETABLE_LEVELS == 2 */
 #include <asm-generic/pgtable-nopmd.h>
 
@@ -152,6 +148,11 @@ static inline pmdval_t native_pmd_val(pmd_t pmd)
 }
 #endif	/* PAGETABLE_LEVELS >= 3 */
 
+static inline pmdval_t pmd_flags(pmd_t pmd)
+{
+	return native_pmd_val(pmd) & PTE_FLAGS_MASK;
+}
+
 static inline pte_t native_make_pte(pteval_t val)
 {
 	return (pte_t) { .pte = val };
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 76696e9..1782053 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_PGTABLE_H
 #define _ASM_X86_PGTABLE_H
 
+#include <asm/page.h>
+
 #define FIRST_USER_ADDRESS	0
 
 #define _PAGE_BIT_PRESENT	0	/* is present */
@@ -528,6 +530,13 @@ static inline unsigned long pages_to_mb(unsigned long npg)
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)	\
 	remap_pfn_range(vma, vaddr, pfn, size, prot)
 
+#if PAGETABLE_LEVELS == 2
+static inline int pud_large(pud_t pud)
+{
+	return 0;
+}
+#endif
+
 #if PAGETABLE_LEVELS > 2
 static inline int pud_none(pud_t pud)
 {
