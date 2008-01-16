Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbYAQCaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbYAQCaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYAQC32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:29:28 -0500
Received: from gw.goop.org ([64.81.55.164]:46827 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbYAQC30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:29:26 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 7 of 8] x86/paravirt: make set_pmd operation common
X-Mercurial-Node: 83201cf4ab6622f6bfdd010f48b6a7346229e8b6
Message-Id: <83201cf4ab6622f6bfdd.1200526045@localhost>
In-Reply-To: <patchbomb.1200526038@localhost>
Date: Wed, 16 Jan 2008 15:27:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate set_pmd()s.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/asm-x86/paravirt.h |   43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -998,6 +998,16 @@ static inline void set_pte_at(struct mm_
 		PVOP_VCALL4(pv_mmu_ops.set_pte_at, mm, addr, ptep, pte.pte);
 }
 
+static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
+{
+	pmdval_t val = native_pmd_val(pmd);
+
+	if (sizeof(pmdval_t) > sizeof(long))
+		PVOP_VCALL3(pv_mmu_ops.set_pmd, pmdp, val, (u64)val >> 32);
+	else
+		PVOP_VCALL2(pv_mmu_ops.set_pmd, pmdp, val);
+}
+
 #ifdef CONFIG_X86_PAE
 /* Special-case pte-setting operations for PAE, which can't update a
    64-bit pte atomically */
@@ -1019,6 +1029,11 @@ static inline void pte_clear(struct mm_s
 {
 	PVOP_VCALL3(pv_mmu_ops.pte_clear, mm, addr, ptep);
 }
+
+static inline void pmd_clear(pmd_t *pmdp)
+{
+	PVOP_VCALL1(pv_mmu_ops.pmd_clear, pmdp);
+}
 #else  /* !CONFIG_X86_PAE */
 static inline void set_pte_atomic(pte_t *ptep, pte_t pte)
 {
@@ -1035,6 +1050,11 @@ static inline void pte_clear(struct mm_s
 			     pte_t *ptep)
 {
 	set_pte_at(mm, addr, ptep, __pte(0));
+}
+
+static inline void pmd_clear(pmd_t *pmdp)
+{
+	set_pmd(pmdp, __pmd(0));
 }
 #endif	/* CONFIG_X86_PAE */
 
@@ -1070,33 +1090,10 @@ static inline pmdval_t pmd_val(pmd_t pmd
 
 #ifdef CONFIG_X86_PAE
 
-static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
-{
-	PVOP_VCALL3(pv_mmu_ops.set_pmd, pmdp,
-		    pmdval.pmd, pmdval.pmd >> 32);
-}
-
 static inline void set_pud(pud_t *pudp, pud_t pudval)
 {
 	PVOP_VCALL3(pv_mmu_ops.set_pud, pudp,
 		    pudval.pgd.pgd, pudval.pgd.pgd >> 32);
-}
-
-static inline void pmd_clear(pmd_t *pmdp)
-{
-	PVOP_VCALL1(pv_mmu_ops.pmd_clear, pmdp);
-}
-
-#else  /* !CONFIG_X86_PAE */
-
-static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
-{
-	PVOP_VCALL2(pv_mmu_ops.set_pmd, pmdp, pmdval.pud.pgd.pgd);
-}
-
-static inline void pmd_clear(pmd_t *pmdp)
-{
-	set_pmd(pmdp, __pmd(0));
 }
 
 #endif	/* CONFIG_X86_PAE */


