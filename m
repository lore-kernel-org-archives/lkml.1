Return-Path: <linux-kernel-owner+w=401wt.eu-S1760560AbYAYU4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560AbYAYU4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbYAYUzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:55:55 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:55354 "EHLO
	outbound1-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755638AbYAYUzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:55:54 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
cc: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 8/8] SVM: add support for Nested Paging
Date: Fri, 25 Jan 2008 21:53:13 +0100
Message-ID: <1201294393-22613-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Jan 2008 20:53:14.0723 (UTC)
 FILETIME=[4DECEB30:01C85F94]
MIME-Version: 1.0
X-WSS-ID: 6B8493F60QK8882788-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the SVM architecture dependent changes for KVM to enable
support for the Nested Paging feature of AMD Barcelona and Phenom processors.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d0bfdd8..578d8ec 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -47,7 +47,12 @@ MODULE_LICENSE("GPL");
 #define SVM_FEATURE_LBRV (1 << 1)
 #define SVM_DEATURE_SVML (1 << 2)
 
+#ifdef CONFIG_X86_64
+static bool npt_enabled = true;
+#else
 static bool npt_enabled = false;
+#endif
+
 static char *npt = "on";
 
 module_param(npt, charp, S_IRUGO);
@@ -187,7 +192,7 @@ static inline void flush_guest_tlb(struct kvm_vcpu *vcpu)
 
 static void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
-	if (!(efer & EFER_LMA))
+	if (!npt_enabled && !(efer & EFER_LMA))
 		efer &= ~EFER_LME;
 
 	to_svm(vcpu)->vmcb->save.efer = efer | MSR_EFER_SVME_MASK;
@@ -568,6 +573,24 @@ static void init_vmcb(struct vmcb *vmcb)
 	save->cr0 = 0x00000010 | X86_CR0_PG | X86_CR0_WP;
 	save->cr4 = X86_CR4_PAE;
 	/* rdx = ?? */
+
+	if (npt_enabled) {
+		/* Setup VMCB for Nested Paging */
+		control->nested_ctl = 1;
+		control->intercept_exceptions &= ~(1 << PF_VECTOR);
+		control->intercept_cr_read &= ~(INTERCEPT_CR0_MASK|
+						INTERCEPT_CR3_MASK|
+						INTERCEPT_CR4_MASK);
+		control->intercept_cr_write &= ~(INTERCEPT_CR0_MASK|
+						 INTERCEPT_CR3_MASK|
+						 INTERCEPT_CR4_MASK);
+		save->g_pat = 0x0007040600070406ULL;
+		/* enable caching because the QEMU Bios doesn't enable it */
+		save->cr0 = X86_CR0_ET;
+		save->cr3 = 0;
+		save->cr4 = 0;
+	}
+
 }
 
 static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
@@ -789,6 +812,15 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (npt_enabled) {
+		/*
+		 * re-enable caching here because the QEMU bios
+		 * does not do it - this results in some delay at
+		 * reboot
+		 */
+		cr0 &= ~(X86_CR0_CD | X86_CR0_NW);
+		goto set;
+	}
 #ifdef CONFIG_X86_64
 	if (vcpu->arch.shadow_efer & EFER_LME) {
 		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
@@ -812,13 +844,16 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	cr0 &= ~(X86_CR0_CD | X86_CR0_NW);
 	if (!vcpu->fpu_active)
 		cr0 |= X86_CR0_TS;
+set:
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
@@ -1284,14 +1319,31 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
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
+		if (((vcpu->arch.cr0 ^ svm->vmcb->save.cr0) & X86_CR0_PG)
+		    || ((vcpu->arch.cr4 ^ svm->vmcb->save.cr4) &
+			(X86_CR4_PGE|X86_CR4_PAE)))
+			mmu_reload = 1;
+		vcpu->arch.cr0 = svm->vmcb->save.cr0;
+		vcpu->arch.cr4 = svm->vmcb->save.cr4;
+		vcpu->arch.cr3 = svm->vmcb->save.cr3;
+		if (mmu_reload) {
+			kvm_mmu_reset_context(vcpu);
+			kvm_mmu_load(vcpu);
+		}
+		if (is_pae(vcpu) && !is_long_mode(vcpu))
+			load_pdptrs(vcpu, vcpu->arch.cr3);
+	}
+
 	kvm_reput_irq(svm);
 
 	if (svm->vmcb->control.exit_code == SVM_EXIT_ERR) {
@@ -1302,7 +1354,8 @@ static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	}
 
 	if (is_external_interrupt(svm->vmcb->control.exit_int_info) &&
-	    exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR)
+	    exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR &&
+	    exit_code != SVM_EXIT_NPF)
 		printk(KERN_ERR "%s: unexpected exit_ini_info 0x%x "
 		       "exit_code 0x%x\n",
 		       __FUNCTION__, svm->vmcb->control.exit_int_info,
@@ -1636,6 +1689,12 @@ static void svm_set_cr3(struct kvm_vcpu *vcpu, unsigned long root)
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
1.5.3.7



