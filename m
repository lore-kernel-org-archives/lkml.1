Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbZETLUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbZETLUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbZETLSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:18:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55256 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbZETLSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:46 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 04/46] KVM: ia64: enable external interrupt in vmm
Date: Wed, 20 May 2009 14:18:01 +0300
Message-Id: <1242818323-10413-5-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang Zhang <yang.zhang@intel.com>

Currently, the interrupt enable bit is cleared when in
the vmm.  This patch sets the bit and the external interrupts can
be dealt with when in the vmm.  This improves the I/O performance.

Signed-off-by: Yang Zhang <yang.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/process.c |    5 +++++
 arch/ia64/kvm/vmm_ivt.S |   18 +++++++++---------
 arch/ia64/kvm/vtlb.c    |    3 ++-
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/ia64/kvm/process.c b/arch/ia64/kvm/process.c
index b1dc809..a8f84da 100644
--- a/arch/ia64/kvm/process.c
+++ b/arch/ia64/kvm/process.c
@@ -652,20 +652,25 @@ void  kvm_ia64_handle_break(unsigned long ifa, struct kvm_pt_regs *regs,
 		unsigned long isr, unsigned long iim)
 {
 	struct kvm_vcpu *v = current_vcpu;
+	long psr;
 
 	if (ia64_psr(regs)->cpl == 0) {
 		/* Allow hypercalls only when cpl = 0.  */
 		if (iim == DOMN_PAL_REQUEST) {
+			local_irq_save(psr);
 			set_pal_call_data(v);
 			vmm_transition(v);
 			get_pal_call_result(v);
 			vcpu_increment_iip(v);
+			local_irq_restore(psr);
 			return;
 		} else if (iim == DOMN_SAL_REQUEST) {
+			local_irq_save(psr);
 			set_sal_call_data(v);
 			vmm_transition(v);
 			get_sal_call_result(v);
 			vcpu_increment_iip(v);
+			local_irq_restore(psr);
 			return;
 		}
 	}
diff --git a/arch/ia64/kvm/vmm_ivt.S b/arch/ia64/kvm/vmm_ivt.S
index 3ef1a01..40920c6 100644
--- a/arch/ia64/kvm/vmm_ivt.S
+++ b/arch/ia64/kvm/vmm_ivt.S
@@ -95,7 +95,7 @@ GLOBAL_ENTRY(kvm_vmm_panic)
 	;;
 	srlz.i    // guarantee that interruption collection is on
 	;;
-	//(p15) ssm psr.i               // restore psr.i
+	(p15) ssm psr.i               // restore psr.
 	addl r14=@gprel(ia64_leave_hypervisor),gp
 	;;
 	KVM_SAVE_REST
@@ -249,7 +249,7 @@ ENTRY(kvm_break_fault)
 	;;
 	srlz.i         // guarantee that interruption collection is on
 	;;
-	//(p15)ssm psr.i               // restore psr.i
+	(p15)ssm psr.i               // restore psr.i
 	addl r14=@gprel(ia64_leave_hypervisor),gp
 	;;
 	KVM_SAVE_REST
@@ -439,7 +439,7 @@ kvm_dispatch_vexirq:
 	;;
 	srlz.i // guarantee that interruption collection is on
 	;;
-	//(p15) ssm psr.i               // restore psr.i
+	(p15) ssm psr.i               // restore psr.i
 	adds r3=8,r2                // set up second base pointer
 	;;
 	KVM_SAVE_REST
@@ -819,7 +819,7 @@ ENTRY(kvm_dtlb_miss_dispatch)
 	;;
 	srlz.i     // guarantee that interruption collection is on
 	;;
-	//(p15) ssm psr.i               // restore psr.i
+	(p15) ssm psr.i               // restore psr.i
 	addl r14=@gprel(ia64_leave_hypervisor_prepare),gp
 	;;
 	KVM_SAVE_REST
@@ -842,7 +842,7 @@ ENTRY(kvm_itlb_miss_dispatch)
 	;;
 	srlz.i   // guarantee that interruption collection is on
 	;;
-	//(p15) ssm psr.i               // restore psr.i
+	(p15) ssm psr.i               // restore psr.i
 	addl r14=@gprel(ia64_leave_hypervisor),gp
 	;;
 	KVM_SAVE_REST
@@ -871,7 +871,7 @@ ENTRY(kvm_dispatch_reflection)
 	;;
 	srlz.i   // guarantee that interruption collection is on
 	;;
-	//(p15) ssm psr.i               // restore psr.i
+	(p15) ssm psr.i               // restore psr.i
 	addl r14=@gprel(ia64_leave_hypervisor),gp
 	;;
 	KVM_SAVE_REST
@@ -898,7 +898,7 @@ ENTRY(kvm_dispatch_virtualization_fault)
 	;;
 	srlz.i    // guarantee that interruption collection is on
 	;;
-	//(p15) ssm psr.i               // restore psr.i
+	(p15) ssm psr.i               // restore psr.i
 	addl r14=@gprel(ia64_leave_hypervisor_prepare),gp
 	;;
 	KVM_SAVE_REST
@@ -920,7 +920,7 @@ ENTRY(kvm_dispatch_interrupt)
 	;;
 	srlz.i
 	;;
-	//(p15) ssm psr.i
+	(p15) ssm psr.i
 	addl r14=@gprel(ia64_leave_hypervisor),gp
 	;;
 	KVM_SAVE_REST
@@ -1333,7 +1333,7 @@ hostret =   r24
 	;;
 (p7)    srlz.i
 	;;
-//(p6)    ssm psr.i
+(p6)    ssm psr.i
 	;;
 	mov rp=rpsave
 	mov ar.pfs=pfssave
diff --git a/arch/ia64/kvm/vtlb.c b/arch/ia64/kvm/vtlb.c
index 2c2501f..4290a42 100644
--- a/arch/ia64/kvm/vtlb.c
+++ b/arch/ia64/kvm/vtlb.c
@@ -254,7 +254,8 @@ u64 guest_vhpt_lookup(u64 iha, u64 *pte)
 			"(p7) st8 [%2]=r9;;"
 			"ssm psr.ic;;"
 			"srlz.d;;"
-			/* "ssm psr.i;;" Once interrupts in vmm open, need fix*/
+			"ssm psr.i;;"
+			"srlz.d;;"
 			: "=r"(ret) : "r"(iha), "r"(pte):"memory");
 
 	return ret;
-- 
1.6.0.6

