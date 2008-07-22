Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYGVEcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYGVEcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYGVEcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:32:14 -0400
Received: from ozlabs.org ([203.10.76.45]:36897 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYGVEcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:32:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: fix pte_flags() to only return flags, fix lguest.
Date: Tue, 22 Jul 2008 14:31:58 +1000
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221431.58991.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change a15af1c9ea2750a9ff01e51615c45950bad8221b 'x86/paravirt: add
pte_flags to just get pte flags' removed lguest's private pte_flags()
in favor of a generic one.

Unfortunately, the generic one doesn't filter out the non-flags bits:
this results in lguest creating corrupt shadow page tables and blowing
up host memory.

Since noone is supposed to use the pfn part of pte_flags(), it seems
safest to always do the filtering.

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r ee1a6adad3d2 arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c	Mon Jul 21 12:49:25 2008 +1000
+++ b/arch/x86/kernel/paravirt.c	Tue Jul 22 14:09:33 2008 +1000
@@ -428,7 +428,7 @@ struct pv_mmu_ops pv_mmu_ops = {
 #endif /* PAGETABLE_LEVELS >= 3 */
 
 	.pte_val = native_pte_val,
-	.pte_flags = native_pte_val,
+	.pte_flags = native_pte_flags,
 	.pgd_val = native_pgd_val,
 
 	.make_pte = native_make_pte,
diff -r ee1a6adad3d2 include/asm-x86/page.h
--- a/include/asm-x86/page.h	Mon Jul 21 12:49:25 2008 +1000
+++ b/include/asm-x86/page.h	Tue Jul 22 14:09:33 2008 +1000
@@ -144,6 +144,18 @@ static inline pteval_t native_pte_val(pt
 	return pte.pte;
 }
 
+/* This belongs in pgtable.h, but our includes are too much of a mess. */
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
+#define PTE_FLAGS	_AC(0x8000000000000FFF, ULL)
+#else
+#define PTE_FLAGS	0x00000FFF
+#endif
+
+static inline pteval_t native_pte_flags(pte_t pte)
+{
+	return native_pte_val(pte) & PTE_FLAGS;
+}
+
 #define pgprot_val(x)	((x).pgprot)
 #define __pgprot(x)	((pgprot_t) { (x) } )
 
@@ -165,7 +177,7 @@ static inline pteval_t native_pte_val(pt
 #endif
 
 #define pte_val(x)	native_pte_val(x)
-#define pte_flags(x)	native_pte_val(x)
+#define pte_flags(x)	native_pte_flags(x)
 #define __pte(x)	native_make_pte(x)
 
 #endif	/* CONFIG_PARAVIRT */
diff -r ee1a6adad3d2 include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h	Mon Jul 21 12:49:25 2008 +1000
+++ b/include/asm-x86/paravirt.h	Tue Jul 22 14:09:33 2008 +1000
@@ -1083,6 +1083,9 @@ static inline pteval_t pte_flags(pte_t p
 		ret = PVOP_CALL1(pteval_t, pv_mmu_ops.pte_flags,
 				 pte.pte);
 
+#ifdef CONFIG_PARAVIRT_DEBUG
+	BUG_ON(ret & ~PTE_FLAGS);
+#endif
 	return ret;
 }
 
