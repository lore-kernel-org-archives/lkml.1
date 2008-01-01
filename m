Return-Path: <linux-kernel-owner+w=401wt.eu-S1757181AbYAAPpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbYAAPpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbYAAPgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:47 -0500
Received: from il.qumranet.com ([82.166.9.18]:33787 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbYAAPg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:28 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 33/54] KVM: Replace page fault injection by the generalized exception queue
Date: Tue,  1 Jan 2008 17:35:59 +0200
Message-Id: <1199201780-14001-34-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    2 +-
 drivers/kvm/svm.c |   35 -----------------------------------
 drivers/kvm/vmx.c |   32 --------------------------------
 drivers/kvm/x86.c |   17 ++++++++++++++++-
 drivers/kvm/x86.h |    4 ++--
 5 files changed, 19 insertions(+), 71 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 9b9d1b6..62a7415 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1081,7 +1081,7 @@ static void inject_page_fault(struct kvm_vcpu *vcpu,
 			      u64 addr,
 			      u32 err_code)
 {
-	kvm_x86_ops->inject_page_fault(vcpu, addr, err_code);
+	kvm_inject_page_fault(vcpu, addr, err_code);
 }
 
 static void paging_free(struct kvm_vcpu *vcpu)
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index f4c61c8..ce77f15 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -225,12 +225,6 @@ static void inject_ud(struct kvm_vcpu *vcpu)
 						UD_VECTOR;
 }
 
-static int is_page_fault(uint32_t info)
-{
-	info &= SVM_EVTINJ_VEC_MASK | SVM_EVTINJ_TYPE_MASK | SVM_EVTINJ_VALID;
-	return info == (PF_VECTOR | SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_EXEPT);
-}
-
 static int is_external_interrupt(u32 info)
 {
 	info &= SVM_EVTINJ_TYPE_MASK | SVM_EVTINJ_VALID;
@@ -1624,34 +1618,6 @@ static void svm_set_cr3(struct kvm_vcpu *vcpu, unsigned long root)
 	}
 }
 
-static void svm_inject_page_fault(struct kvm_vcpu *vcpu,
-				  unsigned long  addr,
-				  uint32_t err_code)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	uint32_t exit_int_info = svm->vmcb->control.exit_int_info;
-
-	++vcpu->stat.pf_guest;
-
-	if (is_page_fault(exit_int_info)) {
-
-		svm->vmcb->control.event_inj_err = 0;
-		svm->vmcb->control.event_inj = 	SVM_EVTINJ_VALID |
-						SVM_EVTINJ_VALID_ERR |
-						SVM_EVTINJ_TYPE_EXEPT |
-						DF_VECTOR;
-		return;
-	}
-	vcpu->cr2 = addr;
-	svm->vmcb->save.cr2 = addr;
-	svm->vmcb->control.event_inj = 	SVM_EVTINJ_VALID |
-					SVM_EVTINJ_VALID_ERR |
-					SVM_EVTINJ_TYPE_EXEPT |
-					PF_VECTOR;
-	svm->vmcb->control.event_inj_err = err_code;
-}
-
-
 static int is_disabled(void)
 {
 	u64 vm_cr;
@@ -1721,7 +1687,6 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.set_rflags = svm_set_rflags,
 
 	.tlb_flush = svm_flush_tlb,
-	.inject_page_fault = svm_inject_page_fault,
 
 	.inject_gp = svm_inject_gp,
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 1ec1c28..20e9dfc 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -2487,37 +2487,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		asm("int $2");
 }
 
-static void vmx_inject_page_fault(struct kvm_vcpu *vcpu,
-				  unsigned long addr,
-				  u32 err_code)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 vect_info = vmx->idt_vectoring_info;
-
-	++vcpu->stat.pf_guest;
-
-	if (is_page_fault(vect_info)) {
-		printk(KERN_DEBUG "inject_page_fault: "
-		       "double fault 0x%lx @ 0x%lx\n",
-		       addr, vmcs_readl(GUEST_RIP));
-		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, 0);
-		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
-			     DF_VECTOR |
-			     INTR_TYPE_EXCEPTION |
-			     INTR_INFO_DELIEVER_CODE_MASK |
-			     INTR_INFO_VALID_MASK);
-		return;
-	}
-	vcpu->cr2 = addr;
-	vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, err_code);
-	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
-		     PF_VECTOR |
-		     INTR_TYPE_EXCEPTION |
-		     INTR_INFO_DELIEVER_CODE_MASK |
-		     INTR_INFO_VALID_MASK);
-
-}
-
 static void vmx_free_vmcs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -2649,7 +2618,6 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.set_rflags = vmx_set_rflags,
 
 	.tlb_flush = vmx_flush_tlb,
-	.inject_page_fault = vmx_inject_page_fault,
 
 	.inject_gp = vmx_inject_gp,
 
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 11440d1..dc007a3 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -142,6 +142,21 @@ void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr)
 }
 EXPORT_SYMBOL_GPL(kvm_queue_exception);
 
+void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long addr,
+			   u32 error_code)
+{
+	++vcpu->stat.pf_guest;
+	if (vcpu->exception.pending && vcpu->exception.nr == PF_VECTOR) {
+		printk(KERN_DEBUG "kvm: inject_page_fault:"
+		       " double fault 0x%lx\n", addr);
+		vcpu->exception.nr = DF_VECTOR;
+		vcpu->exception.error_code = 0;
+		return;
+	}
+	vcpu->cr2 = addr;
+	kvm_queue_exception_e(vcpu, PF_VECTOR, error_code);
+}
+
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
 {
 	WARN_ON(vcpu->exception.pending);
@@ -1601,7 +1616,7 @@ static int emulator_write_emulated_onepage(unsigned long addr,
 	gpa_t                 gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
 
 	if (gpa == UNMAPPED_GVA) {
-		kvm_x86_ops->inject_page_fault(vcpu, addr, 2);
+		kvm_inject_page_fault(vcpu, addr, 2);
 		return X86EMUL_PROPAGATE_FAULT;
 	}
 
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 1e71668..d3ac4e2 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -219,8 +219,6 @@ struct kvm_x86_ops {
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
 
 	void (*tlb_flush)(struct kvm_vcpu *vcpu);
-	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
-				  unsigned long addr, u32 err_code);
 
 	void (*inject_gp)(struct kvm_vcpu *vcpu, unsigned err_code);
 
@@ -306,6 +304,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
+void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long cr2,
+			   u32 error_code);
 
 void fx_init(struct kvm_vcpu *vcpu);
 
-- 
1.5.3.7

