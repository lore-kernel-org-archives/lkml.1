Return-Path: <linux-kernel-owner+w=401wt.eu-S1765923AbYARUH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765923AbYARUH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764307AbYARUE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:04:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763904AbYARUEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:04:55 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 10/10] change function orders in paravirt.h
Date: Fri, 18 Jan 2008 15:20:25 -0200
Message-Id: <12006768843721-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <12006768793416-git-send-email-gcosta@redhat.com>
References: <12006768251548-git-send-email-gcosta@redhat.com> <12006768362108-git-send-email-gcosta@redhat.com> <1200676842822-git-send-email-gcosta@redhat.com> <12006768473571-git-send-email-gcosta@redhat.com> <12006768521391-git-send-email-gcosta@redhat.com> <1200676857691-git-send-email-gcosta@redhat.com> <12006768631010-git-send-email-gcosta@redhat.com> <12006768683247-git-send-email-gcosta@redhat.com> <12006768732175-git-send-email-gcosta@redhat.com> <12006768793416-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__pmd, pmd_val and set_pud are used before they are defined (as static)
We move them a little up in the file, so it doesn't happen.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/paravirt.h |   84 ++++++++++++++++++++++----------------------
 1 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index 3e7ca42..12caaf1 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -1023,6 +1023,48 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 		PVOP_VCALL2(pv_mmu_ops.set_pmd, pmdp, val);
 }
 
+#if PAGETABLE_LEVELS >= 3
+static inline pmd_t __pmd(pmdval_t val)
+{
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
+}
+
+static inline pmdval_t pmd_val(pmd_t pmd)
+{
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
+}
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
+#endif	/* PAGETABLE_LEVELS >= 3 */
+
 #ifdef CONFIG_X86_PAE
 /* Special-case pte-setting operations for PAE, which can't update a
    64-bit pte atomically */
@@ -1073,48 +1115,6 @@ static inline void pmd_clear(pmd_t *pmdp)
 }
 #endif	/* CONFIG_X86_PAE */
 
-#if PAGETABLE_LEVELS >= 3
-static inline pmd_t __pmd(pmdval_t val)
-{
-	pmdval_t ret;
-
-	if (sizeof(pmdval_t) > sizeof(long))
-		ret = PVOP_CALL2(pmdval_t, pv_mmu_ops.make_pmd,
-				 val, (u64)val >> 32);
-	else
-		ret = PVOP_CALL1(pmdval_t, pv_mmu_ops.make_pmd,
-				 val);
-
-	return (pmd_t) { ret };
-}
-
-static inline pmdval_t pmd_val(pmd_t pmd)
-{
-	pmdval_t ret;
-
-	if (sizeof(pmdval_t) > sizeof(long))
-		ret =  PVOP_CALL2(pmdval_t, pv_mmu_ops.pmd_val,
-				  pmd.pmd, (u64)pmd.pmd >> 32);
-	else
-		ret =  PVOP_CALL1(pmdval_t, pv_mmu_ops.pmd_val,
-				  pmd.pmd);
-
-	return ret;
-}
-
-static inline void set_pud(pud_t *pudp, pud_t pud)
-{
-	pudval_t val = native_pud_val(pud);
-
-	if (sizeof(pudval_t) > sizeof(long))
-		PVOP_VCALL3(pv_mmu_ops.set_pud, pudp,
-			    val, (u64)val >> 32);
-	else
-		PVOP_VCALL2(pv_mmu_ops.set_pud, pudp,
-			    val);
-}
-#endif	/* PAGETABLE_LEVELS >= 3 */
-
 /* Lazy mode for batching updates / context switch */
 enum paravirt_lazy_mode {
 	PARAVIRT_LAZY_NONE,
-- 
1.4.4.2

