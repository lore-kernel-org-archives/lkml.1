Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbYEWO0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbYEWO0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757118AbYEWOZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:25:44 -0400
Received: from gw.goop.org ([64.81.55.164]:48130 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020AbYEWOZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:25:43 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 4] paravirt: add hooks for pte_rmw_start/commit
X-Mercurial-Node: 186dc4ac6f298036564d74ff003c3543f33f9f3b
Message-Id: <186dc4ac6f298036564d.1211552450@localhost>
In-Reply-To: <patchbomb.1211552448@localhost>
Date: Fri, 23 May 2008 15:20:50 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds paravirt-ops hooks in pv_mmu_ops for pte_rmw_start and
pte_rmw_commit.  This allows the hypervisor-specific backends to
implement these in some more efficient way.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/paravirt.c |    3 +++
 arch/x86/xen/enlighten.c   |    3 +++
 include/asm-x86/paravirt.h |   26 ++++++++++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -383,6 +383,9 @@
 	.pte_update = paravirt_nop,
 	.pte_update_defer = paravirt_nop,
 
+	.pte_rmw_start = __pte_rmw_start,
+	.pte_rmw_commit = __pte_rmw_commit,
+
 #ifdef CONFIG_HIGHPTE
 	.kmap_atomic_pte = kmap_atomic,
 #endif
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1103,6 +1103,9 @@
 	.set_pte_at = xen_set_pte_at,
 	.set_pmd = xen_set_pmd,
 
+	.pte_rmw_start = __pte_rmw_start,
+	.pte_rmw_commit = __pte_rmw_commit,
+
 	.pte_val = xen_pte_val,
 	.pte_flags = native_pte_val,
 	.pgd_val = xen_pgd_val,
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -238,6 +238,11 @@
 			   pte_t *ptep);
 	void (*pte_update_defer)(struct mm_struct *mm,
 				 unsigned long addr, pte_t *ptep);
+
+	pte_t (*pte_rmw_start)(struct mm_struct *mm, unsigned long addr,
+			       pte_t *ptep);
+	void (*pte_rmw_commit)(struct mm_struct *mm, unsigned long addr,
+			       pte_t *ptep, pte_t pte);
 
 	pteval_t (*pte_val)(pte_t);
 	pteval_t (*pte_flags)(pte_t);
@@ -1040,6 +1045,27 @@
 	return ret;
 }
 
+#define  __HAVE_ARCH_PTE_RMW_TRANSACTION
+static inline pte_t pte_rmw_start(struct mm_struct *mm, unsigned long addr,
+				  pte_t *ptep)
+{
+	pteval_t ret;
+
+	ret = PVOP_CALL3(pteval_t, pv_mmu_ops.pte_rmw_start, mm, addr, ptep);
+
+	return (pte_t) { .pte = ret };
+}
+
+static inline void pte_rmw_commit(struct mm_struct *mm, unsigned long addr,
+				   pte_t *ptep, pte_t pte)
+{
+	if (sizeof(pteval_t) > sizeof(long))
+		/* 5 arg words */
+		pv_mmu_ops.pte_rmw_commit(mm, addr, ptep, pte);
+	else
+		PVOP_VCALL4(pv_mmu_ops.pte_rmw_commit, mm, addr, ptep, pte.pte);
+}
+
 static inline void set_pte(pte_t *ptep, pte_t pte)
 {
 	if (sizeof(pteval_t) > sizeof(long))


