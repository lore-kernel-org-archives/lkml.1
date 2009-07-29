Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbZG2M5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbZG2M5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbZG2M5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:57:46 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:36396 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbZG2M5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:57:44 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KNJNYD-03-5SO-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/12] kvm/svm: move nested svm state into seperate struct
Date: Wed, 29 Jul 2009 14:56:27 +0200
Message-ID: <1248872192-30881-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 29 Jul 2009 12:56:36.0655 (UTC) FILETIME=[01C24BF0:01CA104C]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it more clear for which purpose these members in the vcpu_svm
exist.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   62 +++++++++++++++++++++++++++------------------------
 1 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1756a4c..31467b1 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -76,6 +76,18 @@ static const u32 host_save_user_msrs[] = {
 
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
@@ -92,16 +104,8 @@ struct vcpu_svm {
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
@@ -134,7 +138,7 @@ static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 
 static inline bool is_nested(struct vcpu_svm *svm)
 {
-	return svm->nested_vmcb;
+	return svm->nested.vmcb;
 }
 
 static inline void enable_gif(struct vcpu_svm *svm)
@@ -645,7 +649,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	}
 	force_new_asid(&svm->vcpu);
 
-	svm->nested_vmcb = 0;
+	svm->nested.vmcb = 0;
 	enable_gif(svm);
 }
 
@@ -706,9 +710,9 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	hsave_page = alloc_page(GFP_KERNEL);
 	if (!hsave_page)
 		goto uninit;
-	svm->hsave = page_address(hsave_page);
+	svm->nested.hsave = page_address(hsave_page);
 
-	svm->nested_msrpm = page_address(nested_msrpm_pages);
+	svm->nested.msrpm = page_address(nested_msrpm_pages);
 
 	svm->vmcb = page_address(page);
 	clear_page(svm->vmcb);
@@ -738,8 +742,8 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 
 	__free_page(pfn_to_page(svm->vmcb_pa >> PAGE_SHIFT));
 	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
-	__free_page(virt_to_page(svm->hsave));
-	__free_pages(virt_to_page(svm->nested_msrpm), MSRPM_ALLOC_ORDER);
+	__free_page(virt_to_page(svm->nested.hsave));
+	__free_pages(virt_to_page(svm->nested.msrpm), MSRPM_ALLOC_ORDER);
 	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, svm);
 }
@@ -1565,13 +1569,13 @@ static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
 
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
 
@@ -1611,7 +1615,7 @@ static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 				  void *arg2, void *opaque)
 {
 	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
-	struct vmcb *hsave = svm->hsave;
+	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
 
 	/* Give the current vmcb to the guest */
@@ -1686,7 +1690,7 @@ static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 	svm->vmcb->control.exit_int_info = 0;
 
 	/* Exit nested SVM mode */
-	svm->nested_vmcb = 0;
+	svm->nested.vmcb = 0;
 
 	return 0;
 }
@@ -1694,7 +1698,7 @@ static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 static int nested_svm_vmexit(struct vcpu_svm *svm)
 {
 	nsvm_printk("VMexit\n");
-	if (nested_svm_do(svm, svm->nested_vmcb, 0,
+	if (nested_svm_do(svm, svm->nested.vmcb, 0,
 			  NULL, nested_svm_vmexit_real))
 		return 1;
 
@@ -1710,8 +1714,8 @@ static int nested_svm_vmrun_msrpm(struct vcpu_svm *svm, void *arg1,
 	int i;
 	u32 *nested_msrpm = (u32*)arg1;
 	for (i=0; i< PAGE_SIZE * (1 << MSRPM_ALLOC_ORDER) / 4; i++)
-		svm->nested_msrpm[i] = svm->msrpm[i] | nested_msrpm[i];
-	svm->vmcb->control.msrpm_base_pa = __pa(svm->nested_msrpm);
+		svm->nested.msrpm[i] = svm->msrpm[i] | nested_msrpm[i];
+	svm->vmcb->control.msrpm_base_pa = __pa(svm->nested.msrpm);
 
 	return 0;
 }
@@ -1720,11 +1724,11 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
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
@@ -1802,7 +1806,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 
 	svm->vmcb->control.intercept |= nested_vmcb->control.intercept;
 
-	svm->nested_vmcb_msrpm = nested_vmcb->control.msrpm_base_pa;
+	svm->nested.vmcb_msrpm = nested_vmcb->control.msrpm_base_pa;
 
 	force_new_asid(&svm->vcpu);
 	svm->vmcb->control.exit_int_info = nested_vmcb->control.exit_int_info;
@@ -1904,7 +1908,7 @@ static int vmrun_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 			  NULL, nested_svm_vmrun))
 		return 1;
 
-	if (nested_svm_do(svm, svm->nested_vmcb_msrpm, 0,
+	if (nested_svm_do(svm, svm->nested.vmcb_msrpm, 0,
 		      NULL, nested_svm_vmrun_msrpm))
 		return 1;
 
@@ -2114,7 +2118,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 		*data = svm->vmcb->save.last_excp_to;
 		break;
 	case MSR_VM_HSAVE_PA:
-		*data = svm->hsave_msr;
+		*data = svm->nested.hsave_msr;
 		break;
 	case MSR_VM_CR:
 		*data = 0;
@@ -2200,7 +2204,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 			svm_disable_lbrv(svm);
 		break;
 	case MSR_VM_HSAVE_PA:
-		svm->hsave_msr = data;
+		svm->nested.hsave_msr = data;
 		break;
 	case MSR_VM_CR:
 	case MSR_VM_IGNNE:
-- 
1.6.3.3


