Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbXLZLS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbXLZLS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbXLZLGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:54 -0500
Received: from il.qumranet.com ([82.166.9.18]:50464 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbXLZLGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:07 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 33/55] KVM: Portability: Move x86 instruction emulation code to x86.c
Date: Wed, 26 Dec 2007 13:05:38 +0200
Message-Id: <1198667160-22953-34-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |  177 +-----------------------------------------------
 drivers/kvm/x86.c      |  175 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 177 insertions(+), 176 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index d030a82..ef2a6a8 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -591,6 +591,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 
 void fx_init(struct kvm_vcpu *vcpu);
 
+void kvm_vcpu_block(struct kvm_vcpu *vcpu);
 void kvm_resched(struct kvm_vcpu *vcpu);
 void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
 void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 11580be..a779d42 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -789,7 +789,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 /*
  * The vCPU has executed a HLT instruction with in-kernel mode enabled.
  */
-static void kvm_vcpu_block(struct kvm_vcpu *vcpu)
+void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
 	DECLARE_WAITQUEUE(wait, current);
 
@@ -812,144 +812,6 @@ static void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	remove_wait_queue(&vcpu->wq, &wait);
 }
 
-int kvm_emulate_halt(struct kvm_vcpu *vcpu)
-{
-	++vcpu->stat.halt_exits;
-	if (irqchip_in_kernel(vcpu->kvm)) {
-		vcpu->mp_state = VCPU_MP_STATE_HALTED;
-		kvm_vcpu_block(vcpu);
-		if (vcpu->mp_state != VCPU_MP_STATE_RUNNABLE)
-			return -EINTR;
-		return 1;
-	} else {
-		vcpu->run->exit_reason = KVM_EXIT_HLT;
-		return 0;
-	}
-}
-EXPORT_SYMBOL_GPL(kvm_emulate_halt);
-
-int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
-{
-	unsigned long nr, a0, a1, a2, a3, ret;
-
-	kvm_x86_ops->cache_regs(vcpu);
-
-	nr = vcpu->regs[VCPU_REGS_RAX];
-	a0 = vcpu->regs[VCPU_REGS_RBX];
-	a1 = vcpu->regs[VCPU_REGS_RCX];
-	a2 = vcpu->regs[VCPU_REGS_RDX];
-	a3 = vcpu->regs[VCPU_REGS_RSI];
-
-	if (!is_long_mode(vcpu)) {
-		nr &= 0xFFFFFFFF;
-		a0 &= 0xFFFFFFFF;
-		a1 &= 0xFFFFFFFF;
-		a2 &= 0xFFFFFFFF;
-		a3 &= 0xFFFFFFFF;
-	}
-
-	switch (nr) {
-	default:
-		ret = -KVM_ENOSYS;
-		break;
-	}
-	vcpu->regs[VCPU_REGS_RAX] = ret;
-	kvm_x86_ops->decache_regs(vcpu);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
-
-int kvm_fix_hypercall(struct kvm_vcpu *vcpu)
-{
-	char instruction[3];
-	int ret = 0;
-
-	mutex_lock(&vcpu->kvm->lock);
-
-	/*
-	 * Blow out the MMU to ensure that no other VCPU has an active mapping
-	 * to ensure that the updated hypercall appears atomically across all
-	 * VCPUs.
-	 */
-	kvm_mmu_zap_all(vcpu->kvm);
-
-	kvm_x86_ops->cache_regs(vcpu);
-	kvm_x86_ops->patch_hypercall(vcpu, instruction);
-	if (emulator_write_emulated(vcpu->rip, instruction, 3, vcpu)
-	    != X86EMUL_CONTINUE)
-		ret = -EFAULT;
-
-	mutex_unlock(&vcpu->kvm->lock);
-
-	return ret;
-}
-
-static u64 mk_cr_64(u64 curr_cr, u32 new_val)
-{
-	return (curr_cr & ~((1ULL << 32) - 1)) | new_val;
-}
-
-void realmode_lgdt(struct kvm_vcpu *vcpu, u16 limit, unsigned long base)
-{
-	struct descriptor_table dt = { limit, base };
-
-	kvm_x86_ops->set_gdt(vcpu, &dt);
-}
-
-void realmode_lidt(struct kvm_vcpu *vcpu, u16 limit, unsigned long base)
-{
-	struct descriptor_table dt = { limit, base };
-
-	kvm_x86_ops->set_idt(vcpu, &dt);
-}
-
-void realmode_lmsw(struct kvm_vcpu *vcpu, unsigned long msw,
-		   unsigned long *rflags)
-{
-	lmsw(vcpu, msw);
-	*rflags = kvm_x86_ops->get_rflags(vcpu);
-}
-
-unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr)
-{
-	kvm_x86_ops->decache_cr4_guest_bits(vcpu);
-	switch (cr) {
-	case 0:
-		return vcpu->cr0;
-	case 2:
-		return vcpu->cr2;
-	case 3:
-		return vcpu->cr3;
-	case 4:
-		return vcpu->cr4;
-	default:
-		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __FUNCTION__, cr);
-		return 0;
-	}
-}
-
-void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long val,
-		     unsigned long *rflags)
-{
-	switch (cr) {
-	case 0:
-		set_cr0(vcpu, mk_cr_64(vcpu->cr0, val));
-		*rflags = kvm_x86_ops->get_rflags(vcpu);
-		break;
-	case 2:
-		vcpu->cr2 = val;
-		break;
-	case 3:
-		set_cr3(vcpu, val);
-		break;
-	case 4:
-		set_cr4(vcpu, mk_cr_64(vcpu->cr4, val));
-		break;
-	default:
-		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __FUNCTION__, cr);
-	}
-}
-
 void kvm_resched(struct kvm_vcpu *vcpu)
 {
 	if (!need_resched())
@@ -958,43 +820,6 @@ void kvm_resched(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_resched);
 
-void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
-{
-	int i;
-	u32 function;
-	struct kvm_cpuid_entry *e, *best;
-
-	kvm_x86_ops->cache_regs(vcpu);
-	function = vcpu->regs[VCPU_REGS_RAX];
-	vcpu->regs[VCPU_REGS_RAX] = 0;
-	vcpu->regs[VCPU_REGS_RBX] = 0;
-	vcpu->regs[VCPU_REGS_RCX] = 0;
-	vcpu->regs[VCPU_REGS_RDX] = 0;
-	best = NULL;
-	for (i = 0; i < vcpu->cpuid_nent; ++i) {
-		e = &vcpu->cpuid_entries[i];
-		if (e->function == function) {
-			best = e;
-			break;
-		}
-		/*
-		 * Both basic or both extended?
-		 */
-		if (((e->function ^ function) & 0x80000000) == 0)
-			if (!best || e->function > best->function)
-				best = e;
-	}
-	if (best) {
-		vcpu->regs[VCPU_REGS_RAX] = best->eax;
-		vcpu->regs[VCPU_REGS_RBX] = best->ebx;
-		vcpu->regs[VCPU_REGS_RCX] = best->ecx;
-		vcpu->regs[VCPU_REGS_RDX] = best->edx;
-	}
-	kvm_x86_ops->decache_regs(vcpu);
-	kvm_x86_ops->skip_emulated_instruction(vcpu);
-}
-EXPORT_SYMBOL_GPL(kvm_emulate_cpuid);
-
 /*
  * Check if userspace requested an interrupt window, and that the
  * interrupt window is open.
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index c1f10e5..2cf7eba 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -1610,3 +1610,178 @@ __init void kvm_arch_init(void)
 {
 	kvm_init_msr_list();
 }
+
+int kvm_emulate_halt(struct kvm_vcpu *vcpu)
+{
+	++vcpu->stat.halt_exits;
+	if (irqchip_in_kernel(vcpu->kvm)) {
+		vcpu->mp_state = VCPU_MP_STATE_HALTED;
+		kvm_vcpu_block(vcpu);
+		if (vcpu->mp_state != VCPU_MP_STATE_RUNNABLE)
+			return -EINTR;
+		return 1;
+	} else {
+		vcpu->run->exit_reason = KVM_EXIT_HLT;
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_halt);
+
+int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
+{
+	unsigned long nr, a0, a1, a2, a3, ret;
+
+	kvm_x86_ops->cache_regs(vcpu);
+
+	nr = vcpu->regs[VCPU_REGS_RAX];
+	a0 = vcpu->regs[VCPU_REGS_RBX];
+	a1 = vcpu->regs[VCPU_REGS_RCX];
+	a2 = vcpu->regs[VCPU_REGS_RDX];
+	a3 = vcpu->regs[VCPU_REGS_RSI];
+
+	if (!is_long_mode(vcpu)) {
+		nr &= 0xFFFFFFFF;
+		a0 &= 0xFFFFFFFF;
+		a1 &= 0xFFFFFFFF;
+		a2 &= 0xFFFFFFFF;
+		a3 &= 0xFFFFFFFF;
+	}
+
+	switch (nr) {
+	default:
+		ret = -KVM_ENOSYS;
+		break;
+	}
+	vcpu->regs[VCPU_REGS_RAX] = ret;
+	kvm_x86_ops->decache_regs(vcpu);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
+
+int kvm_fix_hypercall(struct kvm_vcpu *vcpu)
+{
+	char instruction[3];
+	int ret = 0;
+
+	mutex_lock(&vcpu->kvm->lock);
+
+	/*
+	 * Blow out the MMU to ensure that no other VCPU has an active mapping
+	 * to ensure that the updated hypercall appears atomically across all
+	 * VCPUs.
+	 */
+	kvm_mmu_zap_all(vcpu->kvm);
+
+	kvm_x86_ops->cache_regs(vcpu);
+	kvm_x86_ops->patch_hypercall(vcpu, instruction);
+	if (emulator_write_emulated(vcpu->rip, instruction, 3, vcpu)
+	    != X86EMUL_CONTINUE)
+		ret = -EFAULT;
+
+	mutex_unlock(&vcpu->kvm->lock);
+
+	return ret;
+}
+
+static u64 mk_cr_64(u64 curr_cr, u32 new_val)
+{
+	return (curr_cr & ~((1ULL << 32) - 1)) | new_val;
+}
+
+void realmode_lgdt(struct kvm_vcpu *vcpu, u16 limit, unsigned long base)
+{
+	struct descriptor_table dt = { limit, base };
+
+	kvm_x86_ops->set_gdt(vcpu, &dt);
+}
+
+void realmode_lidt(struct kvm_vcpu *vcpu, u16 limit, unsigned long base)
+{
+	struct descriptor_table dt = { limit, base };
+
+	kvm_x86_ops->set_idt(vcpu, &dt);
+}
+
+void realmode_lmsw(struct kvm_vcpu *vcpu, unsigned long msw,
+		   unsigned long *rflags)
+{
+	lmsw(vcpu, msw);
+	*rflags = kvm_x86_ops->get_rflags(vcpu);
+}
+
+unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr)
+{
+	kvm_x86_ops->decache_cr4_guest_bits(vcpu);
+	switch (cr) {
+	case 0:
+		return vcpu->cr0;
+	case 2:
+		return vcpu->cr2;
+	case 3:
+		return vcpu->cr3;
+	case 4:
+		return vcpu->cr4;
+	default:
+		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __FUNCTION__, cr);
+		return 0;
+	}
+}
+
+void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long val,
+		     unsigned long *rflags)
+{
+	switch (cr) {
+	case 0:
+		set_cr0(vcpu, mk_cr_64(vcpu->cr0, val));
+		*rflags = kvm_x86_ops->get_rflags(vcpu);
+		break;
+	case 2:
+		vcpu->cr2 = val;
+		break;
+	case 3:
+		set_cr3(vcpu, val);
+		break;
+	case 4:
+		set_cr4(vcpu, mk_cr_64(vcpu->cr4, val));
+		break;
+	default:
+		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __FUNCTION__, cr);
+	}
+}
+
+void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
+{
+	int i;
+	u32 function;
+	struct kvm_cpuid_entry *e, *best;
+
+	kvm_x86_ops->cache_regs(vcpu);
+	function = vcpu->regs[VCPU_REGS_RAX];
+	vcpu->regs[VCPU_REGS_RAX] = 0;
+	vcpu->regs[VCPU_REGS_RBX] = 0;
+	vcpu->regs[VCPU_REGS_RCX] = 0;
+	vcpu->regs[VCPU_REGS_RDX] = 0;
+	best = NULL;
+	for (i = 0; i < vcpu->cpuid_nent; ++i) {
+		e = &vcpu->cpuid_entries[i];
+		if (e->function == function) {
+			best = e;
+			break;
+		}
+		/*
+		 * Both basic or both extended?
+		 */
+		if (((e->function ^ function) & 0x80000000) == 0)
+			if (!best || e->function > best->function)
+				best = e;
+	}
+	if (best) {
+		vcpu->regs[VCPU_REGS_RAX] = best->eax;
+		vcpu->regs[VCPU_REGS_RBX] = best->ebx;
+		vcpu->regs[VCPU_REGS_RCX] = best->ecx;
+		vcpu->regs[VCPU_REGS_RDX] = best->edx;
+	}
+	kvm_x86_ops->decache_regs(vcpu);
+	kvm_x86_ops->skip_emulated_instruction(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_cpuid);
-- 
1.5.3.7

