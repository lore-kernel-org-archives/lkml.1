Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbYAQCas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbYAQCas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYAQC33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:29:29 -0500
Received: from gw.goop.org ([64.81.55.164]:46832 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbYAQC30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:29:26 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 8] x86/paravirt: common implementation for pgd value ops
X-Mercurial-Node: 4b0082b04f2ed16dc5bdb85d78b35e0a23a62200
Message-Id: <4b0082b04f2ed16dc5bd.1200526042@localhost>
In-Reply-To: <patchbomb.1200526038@localhost>
Date: Wed, 16 Jan 2008 15:27:22 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate __pgd/pgd_val functions.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/asm-x86/paravirt.h |   50 ++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -950,6 +950,34 @@ static inline pteval_t pte_val(pte_t pte
 	return ret;
 }
 
+static inline pgd_t __pgd(pgdval_t val)
+{
+	pgdval_t ret;
+
+	if (sizeof(pgdval_t) > sizeof(long))
+		ret = PVOP_CALL2(pgdval_t, pv_mmu_ops.make_pgd,
+				 val, (u64)val >> 32);
+	else
+		ret = PVOP_CALL1(pgdval_t, pv_mmu_ops.make_pgd,
+				 val);
+
+	return (pgd_t) { ret };
+}
+
+static inline pgdval_t pgd_val(pgd_t pgd)
+{
+	pgdval_t ret;
+
+	if (sizeof(pgdval_t) > sizeof(long))
+		ret =  PVOP_CALL2(pgdval_t, pv_mmu_ops.pgd_val,
+				  pgd.pgd, (u64)pgd.pgd >> 32);
+	else
+		ret =  PVOP_CALL1(pgdval_t, pv_mmu_ops.pgd_val,
+				  pgd.pgd);
+
+	return ret;
+}
+
 #ifdef CONFIG_X86_PAE
 static inline pmd_t __pmd(unsigned long long val)
 {
@@ -957,22 +985,10 @@ static inline pmd_t __pmd(unsigned long 
 				    val, val >> 32) };
 }
 
-static inline pgd_t __pgd(unsigned long long val)
-{
-	return (pgd_t) { PVOP_CALL2(unsigned long long, pv_mmu_ops.make_pgd,
-				    val, val >> 32) };
-}
-
 static inline unsigned long long pmd_val(pmd_t x)
 {
 	return PVOP_CALL2(unsigned long long, pv_mmu_ops.pmd_val,
 			  x.pmd, x.pmd >> 32);
-}
-
-static inline unsigned long long pgd_val(pgd_t x)
-{
-	return PVOP_CALL2(unsigned long long, pv_mmu_ops.pgd_val,
-			  x.pgd, x.pgd >> 32);
 }
 
 static inline void set_pte(pte_t *ptep, pte_t pteval)
@@ -1023,16 +1039,6 @@ static inline void pmd_clear(pmd_t *pmdp
 }
 
 #else  /* !CONFIG_X86_PAE */
-
-static inline pgd_t __pgd(unsigned long val)
-{
-	return (pgd_t) { PVOP_CALL1(unsigned long, pv_mmu_ops.make_pgd, val) };
-}
-
-static inline unsigned long pgd_val(pgd_t x)
-{
-	return PVOP_CALL1(unsigned long, pv_mmu_ops.pgd_val, x.pgd);
-}
 
 static inline void set_pte(pte_t *ptep, pte_t pteval)
 {


