Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0BPKlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:41:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805Ab0BPKfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/38] KVM: Add a helper for checking if the guest is in protected mode
Date: Tue, 16 Feb 2010 12:35:14 +0200
Message-Id: <1266316536-28936-17-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/emulate.c |    9 ++++-----
 arch/x86/kvm/vmx.c     |    4 ++--
 arch/x86/kvm/x86.c     |    7 +++----
 arch/x86/kvm/x86.h     |    6 ++++++
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 48c7f9f..6a429ee 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <asm/kvm_emulate.h>
 
+#include "x86.h"
 #include "mmu.h"		/* for is_long_mode() */
 
 /*
@@ -1515,7 +1516,7 @@ emulate_syscall(struct x86_emulate_ctxt *ctxt)
 
 	/* syscall is not available in real mode */
 	if (c->lock_prefix || ctxt->mode == X86EMUL_MODE_REAL
-	    || !kvm_read_cr0_bits(ctxt->vcpu, X86_CR0_PE))
+	    || !is_protmode(ctxt->vcpu))
 		return -1;
 
 	setup_syscalls_segments(ctxt, &cs, &ss);
@@ -1568,8 +1569,7 @@ emulate_sysenter(struct x86_emulate_ctxt *ctxt)
 		return -1;
 
 	/* inject #GP if in real mode or paging is disabled */
-	if (ctxt->mode == X86EMUL_MODE_REAL ||
-	    !kvm_read_cr0_bits(ctxt->vcpu, X86_CR0_PE)) {
+	if (ctxt->mode == X86EMUL_MODE_REAL || !is_protmode(ctxt->vcpu)) {
 		kvm_inject_gp(ctxt->vcpu, 0);
 		return -1;
 	}
@@ -1634,8 +1634,7 @@ emulate_sysexit(struct x86_emulate_ctxt *ctxt)
 		return -1;
 
 	/* inject #GP if in real mode or paging is disabled */
-	if (ctxt->mode == X86EMUL_MODE_REAL
-	    || !kvm_read_cr0_bits(ctxt->vcpu, X86_CR0_PE)) {
+	if (ctxt->mode == X86EMUL_MODE_REAL || !is_protmode(ctxt->vcpu)) {
 		kvm_inject_gp(ctxt->vcpu, 0);
 		return -1;
 	}
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index fad871c..2e89495 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1845,7 +1845,7 @@ static void vmx_get_segment(struct kvm_vcpu *vcpu,
 
 static int vmx_get_cpl(struct kvm_vcpu *vcpu)
 {
-	if (!kvm_read_cr0_bits(vcpu, X86_CR0_PE)) /* if real mode */
+	if (!is_protmode(vcpu))
 		return 0;
 
 	if (vmx_get_rflags(vcpu) & X86_EFLAGS_VM) /* if virtual 8086 */
@@ -2100,7 +2100,7 @@ static bool cs_ss_rpl_check(struct kvm_vcpu *vcpu)
 static bool guest_state_valid(struct kvm_vcpu *vcpu)
 {
 	/* real mode guest state checks */
-	if (!kvm_read_cr0_bits(vcpu, X86_CR0_PE)) {
+	if (!is_protmode(vcpu)) {
 		if (!rmode_segment_valid(vcpu, VCPU_SREG_CS))
 			return false;
 		if (!rmode_segment_valid(vcpu, VCPU_SREG_SS))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4db0c8a..a4a7d18 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3786,8 +3786,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	 * hypercall generates UD from non zero cpl and real mode
 	 * per HYPER-V spec
 	 */
-	if (kvm_x86_ops->get_cpl(vcpu) != 0 ||
-	    !kvm_read_cr0_bits(vcpu, X86_CR0_PE)) {
+	if (kvm_x86_ops->get_cpl(vcpu) != 0 || !is_protmode(vcpu)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 0;
 	}
@@ -4751,7 +4750,7 @@ int kvm_load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 {
 	struct kvm_segment kvm_seg;
 
-	if (is_vm86_segment(vcpu, seg) || !(kvm_read_cr0_bits(vcpu, X86_CR0_PE)))
+	if (is_vm86_segment(vcpu, seg) || !is_protmode(vcpu))
 		return kvm_load_realmode_segment(vcpu, selector, seg);
 	if (load_segment_descriptor_to_kvm_desct(vcpu, selector, &kvm_seg))
 		return 1;
@@ -5103,7 +5102,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	/* Older userspace won't unhalt the vcpu on reset. */
 	if (kvm_vcpu_is_bsp(vcpu) && kvm_rip_read(vcpu) == 0xfff0 &&
 	    sregs->cs.selector == 0xf000 && sregs->cs.base == 0xffff0000 &&
-	    !(kvm_read_cr0_bits(vcpu, X86_CR0_PE)))
+	    !is_protmode(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
 	vcpu_put(vcpu);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 5eadea5..f783d8f 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -2,6 +2,7 @@
 #define ARCH_X86_KVM_X86_H
 
 #include <linux/kvm_host.h>
+#include "kvm_cache_regs.h"
 
 static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
 {
@@ -35,4 +36,9 @@ static inline bool kvm_exception_is_soft(unsigned int nr)
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
                                              u32 function, u32 index);
 
+static inline bool is_protmode(struct kvm_vcpu *vcpu)
+{
+	return kvm_read_cr0_bits(vcpu, X86_CR0_PE);
+}
+
 #endif
-- 
1.6.5.3

