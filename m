Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969Ab0BPKmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:42:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932796Ab0BPKfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/38] KVM: Activate fpu on clts
Date: Tue, 16 Feb 2010 12:35:13 +0200
Message-Id: <1266316536-28936-16-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assume that if the guest executes clts, it knows what it's doing, and load the
guest fpu to prevent an #NM exception.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/svm.c              |    8 +++++++-
 arch/x86/kvm/vmx.c              |    1 +
 arch/x86/kvm/x86.c              |    1 +
 4 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d73ed48..7ebf9fe 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -511,6 +511,7 @@ struct kvm_x86_ops {
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
+	void (*fpu_activate)(struct kvm_vcpu *vcpu);
 	void (*fpu_deactivate)(struct kvm_vcpu *vcpu);
 
 	void (*tlb_flush)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a281368..800208a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1259,12 +1259,17 @@ static int ud_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
-static int nm_interception(struct vcpu_svm *svm)
+static void svm_fpu_activate(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
 	svm->vcpu.fpu_active = 1;
 	update_cr0_intercept(svm);
+}
 
+static int nm_interception(struct vcpu_svm *svm)
+{
+	svm_fpu_activate(&svm->vcpu);
 	return 1;
 }
 
@@ -2977,6 +2982,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.cache_reg = svm_cache_reg,
 	.get_rflags = svm_get_rflags,
 	.set_rflags = svm_set_rflags,
+	.fpu_activate = svm_fpu_activate,
 	.fpu_deactivate = svm_fpu_deactivate,
 
 	.tlb_flush = svm_flush_tlb,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index b7e812e..fad871c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3002,6 +3002,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		vmx_set_cr0(vcpu, kvm_read_cr0_bits(vcpu, ~X86_CR0_TS));
 		trace_kvm_cr_write(0, kvm_read_cr0(vcpu));
 		skip_emulated_instruction(vcpu);
+		vmx_fpu_activate(vcpu);
 		return 1;
 	case 1: /*mov from cr*/
 		switch (cr) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c61ec9c..4db0c8a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3269,6 +3269,7 @@ int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address)
 int emulate_clts(struct kvm_vcpu *vcpu)
 {
 	kvm_x86_ops->set_cr0(vcpu, kvm_read_cr0_bits(vcpu, ~X86_CR0_TS));
+	kvm_x86_ops->fpu_activate(vcpu);
 	return X86EMUL_CONTINUE;
 }
 
-- 
1.6.5.3

