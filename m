Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYAQCbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYAQCbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYAQC3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:29:31 -0500
Received: from gw.goop.org ([64.81.55.164]:46848 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbYAQC31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:29:27 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 5 of 8] x86/paravirt: common implementation for pmd value ops
X-Mercurial-Node: ed8766572b5579afa372686bf33235900b916210
Message-Id: <ed8766572b5579afa372.1200526043@localhost>
In-Reply-To: <patchbomb.1200526038@localhost>
Date: Wed, 16 Jan 2008 15:27:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate __pmd/pmd_val functions.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/asm-x86/paravirt.h |   33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -978,18 +978,37 @@ static inline pgdval_t pgd_val(pgd_t pgd
 	return ret;
 }
 
-#ifdef CONFIG_X86_PAE
-static inline pmd_t __pmd(unsigned long long val)
+#if PAGETABLE_LEVELS >= 3
+static inline pmd_t __pmd(pmdval_t val)
 {
-	return (pmd_t) { PVOP_CALL2(unsigned long long, pv_mmu_ops.make_pmd,
-				    val, val >> 32) };
+	pmdval_t ret;
+
+	if (sizeof(pmdval_t) > sizeof(long))
+		ret = PVOP_CALL2(pmdval_t, pv_mmu_ops.make_pmd,
+				 val, (u64)val >> 32);
+	else
+		ret = PVOP_CALL1(pmdval_t, pv_mmu_ops.make_pmd,
+				 val);
+
+	return (pmd_t) { ret };
 }
 
-static inline unsigned long long pmd_val(pmd_t x)
+static inline pmdval_t pmd_val(pmd_t pmd)
 {
-	return PVOP_CALL2(unsigned long long, pv_mmu_ops.pmd_val,
-			  x.pmd, x.pmd >> 32);
+	pmdval_t ret;
+
+	if (sizeof(pmdval_t) > sizeof(long))
+		ret =  PVOP_CALL2(pmdval_t, pv_mmu_ops.pmd_val,
+				  pmd.pmd, (u64)pmd.pmd >> 32);
+	else
+		ret =  PVOP_CALL1(pmdval_t, pv_mmu_ops.pmd_val,
+				  pmd.pmd);
+
+	return ret;
 }
+#endif	/* PAGETABLE_LEVELS >= 3 */
+
+#ifdef CONFIG_X86_PAE
 
 static inline void set_pte(pte_t *ptep, pte_t pteval)
 {


