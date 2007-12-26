Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbXLZLK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbXLZLK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbXLZLG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:28 -0500
Received: from il.qumranet.com ([82.166.9.18]:50480 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbXLZLGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:06 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 16/55] KVM: Move page fault processing to common code
Date: Wed, 26 Dec 2007 13:05:21 +0200
Message-Id: <1198667160-22953-17-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code that dispatches the page fault and emulates if we failed to map
is duplicated across vmx and svm.  Merge it to simplify further bugfixing.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |   36 ++++++++++++++++++++++++++++++++++++
 drivers/kvm/svm.c |   33 +--------------------------------
 drivers/kvm/vmx.c |   29 +----------------------------
 drivers/kvm/x86.h |    6 +-----
 4 files changed, 39 insertions(+), 65 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index d9c5950..ace3cb8 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1347,6 +1347,42 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 	}
 }
 
+int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code)
+{
+	int r;
+	enum emulation_result er;
+
+	mutex_lock(&vcpu->kvm->lock);
+	r = vcpu->mmu.page_fault(vcpu, cr2, error_code);
+	if (r < 0)
+		goto out;
+
+	if (!r) {
+		r = 1;
+		goto out;
+	}
+
+	er = emulate_instruction(vcpu, vcpu->run, cr2, error_code, 0);
+	mutex_unlock(&vcpu->kvm->lock);
+
+	switch (er) {
+	case EMULATE_DONE:
+		return 1;
+	case EMULATE_DO_MMIO:
+		++vcpu->stat.mmio_exits;
+		return 0;
+	case EMULATE_FAIL:
+		kvm_report_emulation_failure(vcpu, "pagetable");
+		return 1;
+	default:
+		BUG();
+	}
+out:
+	mutex_unlock(&vcpu->kvm->lock);
+	return r;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
+
 static void free_mmu_pages(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_page *page;
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index cdd4fd2..991e77d 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -933,45 +933,14 @@ static int pf_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	struct kvm *kvm = svm->vcpu.kvm;
 	u64 fault_address;
 	u32 error_code;
-	enum emulation_result er;
-	int r;
 
 	if (!irqchip_in_kernel(kvm) &&
 		is_external_interrupt(exit_int_info))
 		push_irq(&svm->vcpu, exit_int_info & SVM_EVTINJ_VEC_MASK);
 
-	mutex_lock(&kvm->lock);
-
 	fault_address  = svm->vmcb->control.exit_info_2;
 	error_code = svm->vmcb->control.exit_info_1;
-	r = kvm_mmu_page_fault(&svm->vcpu, fault_address, error_code);
-	if (r < 0) {
-		mutex_unlock(&kvm->lock);
-		return r;
-	}
-	if (!r) {
-		mutex_unlock(&kvm->lock);
-		return 1;
-	}
-	er = emulate_instruction(&svm->vcpu, kvm_run, fault_address,
-				 error_code, 0);
-	mutex_unlock(&kvm->lock);
-
-	switch (er) {
-	case EMULATE_DONE:
-		return 1;
-	case EMULATE_DO_MMIO:
-		++svm->vcpu.stat.mmio_exits;
-		return 0;
-	case EMULATE_FAIL:
-		kvm_report_emulation_failure(&svm->vcpu, "pagetable");
-		break;
-	default:
-		BUG();
-	}
-
-	kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
-	return 0;
+	return kvm_mmu_page_fault(&svm->vcpu, fault_address, error_code);
 }
 
 static int ud_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index f76677d..265df86 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1796,7 +1796,6 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	unsigned long cr2, rip;
 	u32 vect_info;
 	enum emulation_result er;
-	int r;
 
 	vect_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
@@ -1834,33 +1833,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
 	if (is_page_fault(intr_info)) {
 		cr2 = vmcs_readl(EXIT_QUALIFICATION);
-
-		mutex_lock(&vcpu->kvm->lock);
-		r = kvm_mmu_page_fault(vcpu, cr2, error_code);
-		if (r < 0) {
-			mutex_unlock(&vcpu->kvm->lock);
-			return r;
-		}
-		if (!r) {
-			mutex_unlock(&vcpu->kvm->lock);
-			return 1;
-		}
-
-		er = emulate_instruction(vcpu, kvm_run, cr2, error_code, 0);
-		mutex_unlock(&vcpu->kvm->lock);
-
-		switch (er) {
-		case EMULATE_DONE:
-			return 1;
-		case EMULATE_DO_MMIO:
-			++vcpu->stat.mmio_exits;
-			return 0;
-		case EMULATE_FAIL:
-			kvm_report_emulation_failure(vcpu, "pagetable");
-			break;
-		default:
-			BUG();
-		}
+		return kvm_mmu_page_fault(vcpu, cr2, error_code);
 	}
 
 	if (vcpu->rmode.active &&
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 01452b5..20da8e9 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -85,11 +85,7 @@ struct kvm_vcpu {
 	struct x86_emulate_ctxt emulate_ctxt;
 };
 
-static inline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
-				     u32 error_code)
-{
-	return vcpu->mmu.page_fault(vcpu, gva, error_code);
-}
+int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva, u32 error_code);
 
 static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
-- 
1.5.3.7

