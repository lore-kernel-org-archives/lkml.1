Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbYAQCac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbYAQCac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYAQC33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:29:29 -0500
Received: from gw.goop.org ([64.81.55.164]:46825 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbYAQC30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:29:26 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 8] x86/paravirt: common implementation for pte value ops
X-Mercurial-Node: ee3af933339f011538a006e6bf65db7f62c7e33e
Message-Id: <ee3af933339f011538a0.1200526041@localhost>
In-Reply-To: <patchbomb.1200526038@localhost>
Date: Wed, 16 Jan 2008 15:27:21 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate __pte/pte_val functions.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/asm-x86/paravirt.h |   48 ++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -920,15 +920,37 @@ static inline void pte_update_defer(stru
 	PVOP_VCALL3(pv_mmu_ops.pte_update_defer, mm, addr, ptep);
 }
 
-#ifdef CONFIG_X86_PAE
-static inline pte_t __pte(unsigned long long val)
+static inline pte_t __pte(pteval_t val)
 {
-	unsigned long long ret = PVOP_CALL2(unsigned long long,
-					    pv_mmu_ops.make_pte,
-					    val, val >> 32);
+	pteval_t ret;
+
+	if (sizeof(pteval_t) > sizeof(long))
+		ret = PVOP_CALL2(pteval_t,
+				 pv_mmu_ops.make_pte,
+				 val, (u64)val >> 32);
+	else
+		ret = PVOP_CALL1(pteval_t,
+				 pv_mmu_ops.make_pte,
+				 val);
+
 	return (pte_t) { .pte = ret };
 }
 
+static inline pteval_t pte_val(pte_t pte)
+{
+	pteval_t ret;
+
+	if (sizeof(pteval_t) > sizeof(long))
+		ret = PVOP_CALL2(pteval_t, pv_mmu_ops.pte_val,
+				 pte.pte, (u64)pte.pte >> 32);
+	else
+		ret = PVOP_CALL1(pteval_t, pv_mmu_ops.pte_val,
+				 pte.pte);
+
+	return ret;
+}
+
+#ifdef CONFIG_X86_PAE
 static inline pmd_t __pmd(unsigned long long val)
 {
 	return (pmd_t) { PVOP_CALL2(unsigned long long, pv_mmu_ops.make_pmd,
@@ -939,12 +961,6 @@ static inline pgd_t __pgd(unsigned long 
 {
 	return (pgd_t) { PVOP_CALL2(unsigned long long, pv_mmu_ops.make_pgd,
 				    val, val >> 32) };
-}
-
-static inline unsigned long long pte_val(pte_t x)
-{
-	return PVOP_CALL2(unsigned long long, pv_mmu_ops.pte_val,
-			  x.pte_low, x.pte_high);
 }
 
 static inline unsigned long long pmd_val(pmd_t x)
@@ -1008,19 +1024,9 @@ static inline void pmd_clear(pmd_t *pmdp
 
 #else  /* !CONFIG_X86_PAE */
 
-static inline pte_t __pte(unsigned long val)
-{
-	return (pte_t) { PVOP_CALL1(unsigned long, pv_mmu_ops.make_pte, val) };
-}
-
 static inline pgd_t __pgd(unsigned long val)
 {
 	return (pgd_t) { PVOP_CALL1(unsigned long, pv_mmu_ops.make_pgd, val) };
-}
-
-static inline unsigned long pte_val(pte_t x)
-{
-	return PVOP_CALL1(unsigned long, pv_mmu_ops.pte_val, x.pte_low);
 }
 
 static inline unsigned long pgd_val(pgd_t x)


