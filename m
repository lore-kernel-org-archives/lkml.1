Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbYEWO0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbYEWO0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757226AbYEWOZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:25:48 -0400
Received: from gw.goop.org ([64.81.55.164]:48119 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793AbYEWOZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:25:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 4] xen: implement pte_rmw_start/commit
X-Mercurial-Node: 68c53281433b439c36644fbcf4e9f54ff7bac576
Message-Id: <68c53281433b439c3664.1211552451@localhost>
In-Reply-To: <patchbomb.1211552448@localhost>
Date: Fri, 23 May 2008 15:20:51 +0100
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

Xen has a pte update function which will update a pte while preserving
its accessed and dirty bits.  This means that pte_rmw_start() can be
implemented as a simple read of the pte value.  The hardware may
update the pte in the meantime, but pte_rmw_commit() updates it while
preserving any changes that may have happened in the meantime.

The updates in pte_rmw_commit() are batched if we're currently in lazy
mmu mode.

The mmu_update hypercall can take a batch of updates to perform, but
this code doesn't make particular use of that feature, in favour of
using generic multicall batching to get them all into the hypervisor.

The net effect of this is that each mprotect pte update turns from two
expensive trap-and-emulate faults into they hypervisor into a single
hypercall whose cost is amortized in a batched multicall.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c         |   13 ++++++++++---
 arch/x86/xen/mmu.c               |   21 +++++++++++++++++++++
 arch/x86/xen/mmu.h               |    4 ++++
 include/xen/interface/features.h |    3 +++
 include/xen/interface/xen.h      |    9 +++++++--
 5 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -140,7 +140,9 @@
 {
 	printk(KERN_INFO "Booting paravirtualized kernel on %s\n",
 	       pv_info.name);
-	printk(KERN_INFO "Hypervisor signature: %s\n", xen_start_info->magic);
+	printk(KERN_INFO "Hypervisor signature: %s%s\n",
+	       xen_start_info->magic,
+	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" : "");
 }
 
 static void xen_cpuid(unsigned int *ax, unsigned int *bx,
@@ -1208,6 +1210,8 @@
 
 	BUG_ON(memcmp(xen_start_info->magic, "xen-3", 5) != 0);
 
+	xen_setup_features();
+
 	/* Install Xen paravirt ops */
 	pv_info = xen_info;
 	pv_init_ops = xen_init_ops;
@@ -1217,13 +1221,16 @@
 	pv_apic_ops = xen_apic_ops;
 	pv_mmu_ops = xen_mmu_ops;
 
+	if (xen_feature(XENFEAT_mmu_pt_update_preserve_ad)) {
+		pv_mmu_ops.pte_rmw_start = xen_pte_rmw_start;
+		pv_mmu_ops.pte_rmw_commit = xen_pte_rmw_commit;
+	}
+
 	machine_ops = xen_machine_ops;
 
 #ifdef CONFIG_SMP
 	smp_ops = xen_smp_ops;
 #endif
-
-	xen_setup_features();
 
 	/* Get mfn list */
 	if (!xen_feature(XENFEAT_auto_translated_physmap))
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -300,6 +300,27 @@
 out:
 	if (mm == &init_mm)
 		preempt_enable();
+}
+
+pte_t xen_pte_rmw_start(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	/* Just return the pte as-is.  We preserve the bits on commit */
+	return *ptep;
+}
+
+void xen_pte_rmw_commit(struct mm_struct *mm, unsigned long addr,
+			pte_t *ptep, pte_t pte)
+{
+	struct multicall_space mcs;
+	struct mmu_update *u;
+
+	mcs = xen_mc_entry(sizeof(*u));
+	u = mcs.args;
+	u->ptr = virt_to_machine(ptep).maddr | MMU_PT_UPDATE_PRESERVE_AD;
+	u->val = pte_val_ma(pte);
+	MULTI_mmu_update(mcs.mc, u, 1, NULL, DOMID_SELF);
+
+	xen_mc_issue(PARAVIRT_LAZY_MMU);
 }
 
 pteval_t xen_pte_val(pte_t pte)
diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -52,4 +52,8 @@
 void xen_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 void xen_pmd_clear(pmd_t *pmdp);
 
+pte_t xen_pte_rmw_start(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+void  xen_pte_rmw_commit(struct mm_struct *mm, unsigned long addr,
+			 pte_t *ptep, pte_t pte);
+
 #endif	/* _XEN_MMU_H */
diff --git a/include/xen/interface/features.h b/include/xen/interface/features.h
--- a/include/xen/interface/features.h
+++ b/include/xen/interface/features.h
@@ -38,6 +38,9 @@
  */
 #define XENFEAT_pae_pgdir_above_4gb        4
 
+/* x86: Does this Xen host support the MMU_PT_UPDATE_PRESERVE_AD hypercall? */
+#define XENFEAT_mmu_pt_update_preserve_ad  5
+
 #define XENFEAT_NR_SUBMAPS 1
 
 #endif /* __XEN_PUBLIC_FEATURES_H__ */
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -113,9 +113,14 @@
  * ptr[:2]  -- Machine address within the frame whose mapping to modify.
  *             The frame must belong to the FD, if one is specified.
  * val      -- Value to write into the mapping entry.
+ *
+ * ptr[1:0] == MMU_PT_UPDATE_PRESERVE_AD:
+ * As MMU_NORMAL_PT_UPDATE above, but A/D bits currently in the PTE are ORed
+ * with those in @val.
  */
-#define MMU_NORMAL_PT_UPDATE     0 /* checked '*ptr = val'. ptr is MA.       */
-#define MMU_MACHPHYS_UPDATE      1 /* ptr = MA of frame to modify entry for  */
+#define MMU_NORMAL_PT_UPDATE      0 /* checked '*ptr = val'. ptr is MA.       */
+#define MMU_MACHPHYS_UPDATE       1 /* ptr = MA of frame to modify entry for  */
+#define MMU_PT_UPDATE_PRESERVE_AD 2 /* atomically: *ptr = val | (*ptr&(A|D)) */
 
 /*
  * MMU EXTENDED OPERATIONS


