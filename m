Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbYAUVxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbYAUVxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYAUVxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:53:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbYAUVxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:53:13 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com
Subject: [PATCH 2/4] include/asm-x86/paravirt.h: x86_64 mmu operations
Date: Mon, 21 Jan 2008 19:48:51 -0200
Message-Id: <1200952133-31581-3-git-send-email-ehabkost@redhat.com>
X-Mailer: git-send-email 1.5.4.rc3
In-Reply-To: <1200952133-31581-1-git-send-email-ehabkost@redhat.com>
References: <1200952133-31581-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add .set_pgd field to pv_mmu_ops.

Implement pud_val(), __pud(), set_pgd(), pud_clear(), pgd_clear().

pud_clear() and pgd_clear() are implemented simply using set_pud()
and set_pmd(). They don't have a field at pv_mmu_ops.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 include/asm-x86/paravirt.h |   55 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index 62cecb7..9f9ff57 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -259,6 +259,8 @@ struct pv_mmu_ops {
 #if PAGETABLE_LEVELS == 4
 	pudval_t (*pud_val)(pud_t);
 	pud_t (*make_pud)(pudval_t pud);
+
+	void (*set_pgd)(pgd_t *pudp, pgd_t pgdval);
 #endif	/* PAGETABLE_LEVELS == 4 */
 #endif	/* PAGETABLE_LEVELS >= 3 */
 
@@ -1065,6 +1067,59 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
 		PVOP_VCALL2(pv_mmu_ops.set_pud, pudp,
 			    val);
 }
+#if PAGETABLE_LEVELS == 4
+static inline pud_t __pud(pudval_t val)
+{
+	pudval_t ret;
+
+	if (sizeof(pudval_t) > sizeof(long))
+		ret = PVOP_CALL2(pudval_t, pv_mmu_ops.make_pud,
+				 val, (u64)val >> 32);
+	else
+		ret = PVOP_CALL1(pudval_t, pv_mmu_ops.make_pud,
+				 val);
+
+	return (pud_t) { ret };
+}
+
+static inline pudval_t pud_val(pud_t pud)
+{
+	pudval_t ret;
+
+	if (sizeof(pudval_t) > sizeof(long))
+		ret =  PVOP_CALL2(pudval_t, pv_mmu_ops.pud_val,
+				  pud.pud, (u64)pud.pud >> 32);
+	else
+		ret =  PVOP_CALL1(pudval_t, pv_mmu_ops.pud_val,
+				  pud.pud);
+
+	return ret;
+}
+
+static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
+{
+	pgdval_t val = native_pgd_val(pgd);
+
+	if (sizeof(pgdval_t) > sizeof(long))
+		PVOP_VCALL3(pv_mmu_ops.set_pgd, pgdp,
+			    val, (u64)val >> 32);
+	else
+		PVOP_VCALL2(pv_mmu_ops.set_pgd, pgdp,
+			    val);
+}
+
+static inline void pgd_clear(pgd_t *pgdp)
+{
+	set_pgd(pgdp, __pgd(0));
+}
+
+static inline void pud_clear(pud_t *pudp)
+{
+	set_pud(pudp, __pud(0));
+}
+
+#endif	/* PAGETABLE_LEVELS == 4 */
+
 #endif	/* PAGETABLE_LEVELS >= 3 */
 
 #ifdef CONFIG_X86_PAE
-- 
1.5.3.4

