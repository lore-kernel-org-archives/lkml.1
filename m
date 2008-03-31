Return-Path: <linux-kernel-owner+w=401wt.eu-S1759379AbYCaOpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379AbYCaOpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYCaOhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:47 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51312
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbYCaOhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:34 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 27/40] KVM: SVM: add support for Nested Paging
Date: Mon, 31 Mar 2008 17:37:11 +0300
Message-Id: <1206974244-9716-28-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch contains the SVM architecture dependent changes for KVM to enable
support for the Nested Paging feature of AMD Barcelona and Phenom processors.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 67 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9e29a13..8e9d4a5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -47,7 +47,12 @@ MODULE_LICENSE("GPL");
 #define SVM_FEATURE_LBRV (1 << 1)
 #define SVM_DEATURE_SVML (1 << 2)
 
+/* enable NPT for AMD64 and X86 with PAE */
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
+static bool npt_enabled = true;
+#else
 static bool npt_enabled = false;
+#endif
 static int npt = 1;
 
 module_param(npt, int, S_IRUGO);
@@ -187,7 +192,7 @@ static inline void flush_guest_tlb(struct kvm_vcpu *vcpu)
 
 static void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
-	if (!(efer & EFER_LMA))
+	if (!npt_enabled && !(efer & EFER_LMA))
 		efer &= ~EFER_LME;
 
 	to_svm(vcpu)->vmcb->save.efer = efer | MSR_EFER_SVME_MASK;
@@ -573,6 +578,22 @@ static void init_vmcb(struct vmcb *vmcb)
 	save->cr0 = 0x00000010 | X86_CR0_PG | X86_CR0_WP;
 	save->cr4 = X86_CR4_PAE;
 	/* rdx = ?? */
+
+	if (npt_enabled) {
+		/* Setup VMCB for Nested Paging */
+		control->nested_ctl = 1;
+		control->intercept_exceptions &= ~(1 << PF_VECTOR);
+		control->intercept_cr_read &= ~(INTERCEPT_CR0_MASK|
+						INTERCEPT_CR3_MASK);
+		control->intercept_cr_write &= ~(INTERCEPT_CR0_MASK|
+						 INTERCEPT_CR3_MASK);
+		save->g_pat = 0x0007040600070406ULL;
+		/* enable caching because the QEMU Bios doesn't enable it */
+		save->cr0 = X86_CR0_ET;
+		save->cr3 = 0;
+		save->cr4 = 0;
+	}
+
 }
 
 static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
@@ -807,6 +828,9 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 		}
 	}
 #endif
+	if (npt_enabled)
+		goto set;
+
 	if ((vcpu->arch.cr0 & X86_CR0_TS) && !(cr0 & X86_CR0_TS)) {
 		svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
 		vcpu->fpu_active = 1;
@@ -814,18 +838,26 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 	vcpu->arch.cr0 = cr0;
 	cr0 |= X86_CR0_PG | X86_CR0_WP;
-	cr0 &= ~(X86_CR0_CD | X86_CR0_NW);
 	if (!vcpu->fpu_active) {
 		svm->vmcb->control.intercept_exceptions |= (1 << NM_VECTOR);
 		cr0 |= X86_CR0_TS;
 	}
+set:
+	/*
+	 * re-enable caching here because the QEMU bios
+	 * does not do it - this results in some delay at
+	 * reboot
+	 */
+	cr0 &= ~(X86_CR0_CD | X86_CR0_NW);
 	svm->vmcb->save.cr0 = cr0;
 }
 
 static void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
        vcpu->arch.cr4 = cr4;
-       to_svm(vcpu)->vmcb->save.cr4 = cr4 | X86_CR4_PAE;
+       if (!npt_enabled)
+	       cr4 |= X86_CR4_PAE;
+       to_svm(vcpu)->vmcb->save.cr4 = cr4;
 }
 
 static void svm_set_segment(struct kvm_vcpu *vcpu,
@@ -1313,14 +1345,34 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 	[SVM_EXIT_WBINVD]                       = emulate_on_interception,
 	[SVM_EXIT_MONITOR]			= invalid_op_interception,
 	[SVM_EXIT_MWAIT]			= invalid_op_interception,
+	[SVM_EXIT_NPF]				= pf_interception,
 };
 
-
 static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 exit_code = svm->vmcb->control.exit_code;
 
+	if (npt_enabled) {
+		int mmu_reload = 0;
+		if ((vcpu->arch.cr0 ^ svm->vmcb->save.cr0) & X86_CR0_PG) {
+			svm_set_cr0(vcpu, svm->vmcb->save.cr0);
+			mmu_reload = 1;
+		}
+		vcpu->arch.cr0 = svm->vmcb->save.cr0;
+		vcpu->arch.cr3 = svm->vmcb->save.cr3;
+		if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
+			if (!load_pdptrs(vcpu, vcpu->arch.cr3)) {
+				kvm_inject_gp(vcpu, 0);
+				return 1;
+			}
+		}
+		if (mmu_reload) {
+			kvm_mmu_reset_context(vcpu);
+			kvm_mmu_load(vcpu);
+		}
+	}
+
 	kvm_reput_irq(svm);
 
 	if (svm->vmcb->control.exit_code == SVM_EXIT_ERR) {
@@ -1331,7 +1383,8 @@ static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	}
 
 	if (is_external_interrupt(svm->vmcb->control.exit_int_info) &&
-	    exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR)
+	    exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR &&
+	    exit_code != SVM_EXIT_NPF)
 		printk(KERN_ERR "%s: unexpected exit_ini_info 0x%x "
 		       "exit_code 0x%x\n",
 		       __FUNCTION__, svm->vmcb->control.exit_int_info,
@@ -1522,6 +1575,9 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	svm->host_dr6 = read_dr6();
 	svm->host_dr7 = read_dr7();
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
+	/* required for live migration with NPT */
+	if (npt_enabled)
+		svm->vmcb->save.cr3 = vcpu->arch.cr3;
 
 	if (svm->vmcb->save.dr7 & 0xff) {
 		write_dr7(0);
@@ -1665,6 +1721,12 @@ static void svm_set_cr3(struct kvm_vcpu *vcpu, unsigned long root)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (npt_enabled) {
+		svm->vmcb->control.nested_cr3 = root;
+		force_new_asid(vcpu);
+		return;
+	}
+
 	svm->vmcb->save.cr3 = root;
 	force_new_asid(vcpu);
 
-- 
1.5.4.5

