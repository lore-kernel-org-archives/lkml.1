Return-Path: <linux-kernel-owner+w=401wt.eu-S932468AbZHZKih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbZHZKih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757311AbZHZKid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:38:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757052AbZHZKaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:12 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 17/47] KVM: SVM: move nested svm state into seperate struct
Date: Wed, 26 Aug 2009 13:29:39 +0300
Message-Id: <1251282609-12835-18-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This makes it more clear for which purpose these members in the vcpu_svm
exist.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   62 +++++++++++++++++++++++++++------------------------
 1 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 825b825..fbadaa7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -70,6 +70,18 @@ static const u32 host_save_user_msrs[] = {
 
 struct kvm_vcpu;
 
+struct nested_state {
+	struct vmcb *hsave;
+	u64 hsave_msr;
+	u64 vmcb;
+
+	/* These are the merged vectors */
+	u32 *msrpm;
+
+	/* gpa pointers to the real vectors */
+	u64 vmcb_msrpm;
+};
+
 struct vcpu_svm {
 	struct kvm_vcpu vcpu;
 	struct vmcb *vmcb;
@@ -85,16 +97,8 @@ struct vcpu_svm {
 	u64 host_gs_base;
 
 	u32 *msrpm;
-	struct vmcb *hsave;
-	u64 hsave_msr;
-
-	u64 nested_vmcb;
 
-	/* These are the merged vectors */
-	u32 *nested_msrpm;
-
-	/* gpa pointers to the real vectors */
-	u64 nested_vmcb_msrpm;
+	struct nested_state nested;
 };
 
 /* enable NPT for AMD64 and X86 with PAE */
@@ -127,7 +131,7 @@ static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 
 static inline bool is_nested(struct vcpu_svm *svm)
 {
-	return svm->nested_vmcb;
+	return svm->nested.vmcb;
 }
 
 static inline void enable_gif(struct vcpu_svm *svm)
@@ -636,7 +640,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	}
 	force_new_asid(&svm->vcpu);
 
-	svm->nested_vmcb = 0;
+	svm->nested.vmcb = 0;
 	svm->vcpu.arch.hflags = 0;
 
 	enable_gif(svm);
@@ -699,9 +703,9 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	hsave_page = alloc_page(GFP_KERNEL);
 	if (!hsave_page)
 		goto uninit;
-	svm->hsave = page_address(hsave_page);
+	svm->nested.hsave = page_address(hsave_page);
 
-	svm->nested_msrpm = page_address(nested_msrpm_pages);
+	svm->nested.msrpm = page_address(nested_msrpm_pages);
 
 	svm->vmcb = page_address(page);
 	clear_page(svm->vmcb);
@@ -731,8 +735,8 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 
 	__free_page(pfn_to_page(svm->vmcb_pa >> PAGE_SHIFT));
 	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
-	__free_page(virt_to_page(svm->hsave));
-	__free_pages(virt_to_page(svm->nested_msrpm), MSRPM_ALLOC_ORDER);
+	__free_page(virt_to_page(svm->nested.hsave));
+	__free_pages(virt_to_page(svm->nested.msrpm), MSRPM_ALLOC_ORDER);
 	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, svm);
 }
@@ -1558,13 +1562,13 @@ static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
 
 	switch (svm->vmcb->control.exit_code) {
 	case SVM_EXIT_MSR:
-		return nested_svm_do(svm, svm->nested_vmcb,
-				     svm->nested_vmcb_msrpm, NULL,
+		return nested_svm_do(svm, svm->nested.vmcb,
+				     svm->nested.vmcb_msrpm, NULL,
 				     nested_svm_exit_handled_msr);
 	default: break;
 	}
 
-	return nested_svm_do(svm, svm->nested_vmcb, 0, &k,
+	return nested_svm_do(svm, svm->nested.vmcb, 0, &k,
 			     nested_svm_exit_handled_real);
 }
 
@@ -1604,7 +1608,7 @@ static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 				  void *arg2, void *opaque)
 {
 	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
-	struct vmcb *hsave = svm->hsave;
+	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
 
 	/* Give the current vmcb to the guest */
@@ -1679,7 +1683,7 @@ static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 	svm->vmcb->control.exit_int_info = 0;
 
 	/* Exit nested SVM mode */
-	svm->nested_vmcb = 0;
+	svm->nested.vmcb = 0;
 
 	return 0;
 }
@@ -1687,7 +1691,7 @@ static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 static int nested_svm_vmexit(struct vcpu_svm *svm)
 {
 	nsvm_printk("VMexit\n");
-	if (nested_svm_do(svm, svm->nested_vmcb, 0,
+	if (nested_svm_do(svm, svm->nested.vmcb, 0,
 			  NULL, nested_svm_vmexit_real))
 		return 1;
 
@@ -1703,8 +1707,8 @@ static int nested_svm_vmrun_msrpm(struct vcpu_svm *svm, void *arg1,
 	int i;
 	u32 *nested_msrpm = (u32*)arg1;
 	for (i=0; i< PAGE_SIZE * (1 << MSRPM_ALLOC_ORDER) / 4; i++)
-		svm->nested_msrpm[i] = svm->msrpm[i] | nested_msrpm[i];
-	svm->vmcb->control.msrpm_base_pa = __pa(svm->nested_msrpm);
+		svm->nested.msrpm[i] = svm->msrpm[i] | nested_msrpm[i];
+	svm->vmcb->control.msrpm_base_pa = __pa(svm->nested.msrpm);
 
 	return 0;
 }
@@ -1713,11 +1717,11 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 			    void *arg2, void *opaque)
 {
 	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
-	struct vmcb *hsave = svm->hsave;
+	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
 
 	/* nested_vmcb is our indicator if nested SVM is activated */
-	svm->nested_vmcb = svm->vmcb->save.rax;
+	svm->nested.vmcb = svm->vmcb->save.rax;
 
 	/* Clear internal status */
 	kvm_clear_exception_queue(&svm->vcpu);
@@ -1795,7 +1799,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 
 	svm->vmcb->control.intercept |= nested_vmcb->control.intercept;
 
-	svm->nested_vmcb_msrpm = nested_vmcb->control.msrpm_base_pa;
+	svm->nested.vmcb_msrpm = nested_vmcb->control.msrpm_base_pa;
 
 	force_new_asid(&svm->vcpu);
 	svm->vmcb->control.exit_int_info = nested_vmcb->control.exit_int_info;
@@ -1897,7 +1901,7 @@ static int vmrun_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 			  NULL, nested_svm_vmrun))
 		return 1;
 
-	if (nested_svm_do(svm, svm->nested_vmcb_msrpm, 0,
+	if (nested_svm_do(svm, svm->nested.vmcb_msrpm, 0,
 		      NULL, nested_svm_vmrun_msrpm))
 		return 1;
 
@@ -2107,7 +2111,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 		*data = svm->vmcb->save.last_excp_to;
 		break;
 	case MSR_VM_HSAVE_PA:
-		*data = svm->hsave_msr;
+		*data = svm->nested.hsave_msr;
 		break;
 	case MSR_VM_CR:
 		*data = 0;
@@ -2195,7 +2199,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 			svm_disable_lbrv(svm);
 		break;
 	case MSR_VM_HSAVE_PA:
-		svm->hsave_msr = data;
+		svm->nested.hsave_msr = data;
 		break;
 	case MSR_VM_CR:
 	case MSR_VM_IGNNE:
-- 
1.6.4.1

