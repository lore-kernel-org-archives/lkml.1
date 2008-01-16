Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbYAQC3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbYAQC3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYAQC31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:29:27 -0500
Received: from gw.goop.org ([64.81.55.164]:46835 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbYAQC30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:29:26 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 8 of 8] x86/paravirt: make set_pud operation common
X-Mercurial-Node: ebe43391c1ac39f0df69749e64647d58005a1001
Message-Id: <ebe43391c1ac39f0df69.1200526046@localhost>
In-Reply-To: <patchbomb.1200526038@localhost>
Date: Wed, 16 Jan 2008 15:27:26 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate set_pud()s.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/asm-x86/paravirt.h |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -1086,17 +1086,19 @@ static inline pmdval_t pmd_val(pmd_t pmd
 
 	return ret;
 }
+
+static inline void set_pud(pud_t *pudp, pud_t pud)
+{
+	pudval_t val = native_pud_val(pud);
+
+	if (sizeof(pudval_t) > sizeof(long))
+		PVOP_VCALL3(pv_mmu_ops.set_pud, pudp,
+			    val, (u64)val >> 32);
+	else
+		PVOP_VCALL2(pv_mmu_ops.set_pud, pudp,
+			    val);
+}
 #endif	/* PAGETABLE_LEVELS >= 3 */
-
-#ifdef CONFIG_X86_PAE
-
-static inline void set_pud(pud_t *pudp, pud_t pudval)
-{
-	PVOP_VCALL3(pv_mmu_ops.set_pud, pudp,
-		    pudval.pgd.pgd, pudval.pgd.pgd >> 32);
-}
-
-#endif	/* CONFIG_X86_PAE */
 
 /* Lazy mode for batching updates / context switch */
 enum paravirt_lazy_mode {


