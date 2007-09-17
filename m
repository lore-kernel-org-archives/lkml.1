Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbXIQIlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbXIQIlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbXIQIcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:48 -0400
Received: from il.qumranet.com ([82.166.9.18]:45259 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbXIQIc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:29 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 033/104] KVM: SVM: de-containization
Date: Mon, 17 Sep 2007 10:31:15 +0200
Message-Id: <11900179471458-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

container_of is wonderful, but not casting at all is better.  This
patch changes svm.c's internal functions to pass "struct vcpu_svm"
instead of "struct kvm_vcpu" and using container_of.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |  232 +++++++++++++++++++++++++----------------------------
 1 files changed, 108 insertions(+), 124 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index c18f0b2..504fb50 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -98,9 +98,9 @@ static inline u32 svm_has(u32 feat)
 	return svm_features & feat;
 }
 
-static unsigned get_addr_size(struct kvm_vcpu *vcpu)
+static unsigned get_addr_size(struct vcpu_svm *svm)
 {
-	struct vmcb_save_area *sa = &to_svm(vcpu)->vmcb->save;
+	struct vmcb_save_area *sa = &svm->vmcb->save;
 	u16 cs_attrib;
 
 	if (!(sa->cr0 & X86_CR0_PE) || (sa->rflags & X86_EFLAGS_VM))
@@ -865,17 +865,15 @@ static void save_host_msrs(struct kvm_vcpu *vcpu)
 #endif
 }
 
-static void new_asid(struct kvm_vcpu *vcpu, struct svm_cpu_data *svm_data)
+static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *svm_data)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-
 	if (svm_data->next_asid > svm_data->max_asid) {
 		++svm_data->asid_generation;
 		svm_data->next_asid = 1;
 		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
 	}
 
-	vcpu->cpu = svm_data->cpu;
+	svm->vcpu.cpu = svm_data->cpu;
 	svm->asid_generation = svm_data->asid_generation;
 	svm->vmcb->control.asid = svm_data->next_asid++;
 }
@@ -929,42 +927,43 @@ static void svm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long value,
 	}
 }
 
-static int pf_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int pf_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 exit_int_info = svm->vmcb->control.exit_int_info;
+	struct kvm *kvm = svm->vcpu.kvm;
 	u64 fault_address;
 	u32 error_code;
 	enum emulation_result er;
 	int r;
 
 	if (is_external_interrupt(exit_int_info))
-		push_irq(vcpu, exit_int_info & SVM_EVTINJ_VEC_MASK);
+		push_irq(&svm->vcpu, exit_int_info & SVM_EVTINJ_VEC_MASK);
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&kvm->lock);
 
 	fault_address  = svm->vmcb->control.exit_info_2;
 	error_code = svm->vmcb->control.exit_info_1;
-	r = kvm_mmu_page_fault(vcpu, fault_address, error_code);
+	r = kvm_mmu_page_fault(&svm->vcpu, fault_address, error_code);
 	if (r < 0) {
-		mutex_unlock(&vcpu->kvm->lock);
+		mutex_unlock(&kvm->lock);
 		return r;
 	}
 	if (!r) {
-		mutex_unlock(&vcpu->kvm->lock);
+		mutex_unlock(&kvm->lock);
 		return 1;
 	}
-	er = emulate_instruction(vcpu, kvm_run, fault_address, error_code);
-	mutex_unlock(&vcpu->kvm->lock);
+	er = emulate_instruction(&svm->vcpu, kvm_run, fault_address,
+				 error_code);
+	mutex_unlock(&kvm->lock);
 
 	switch (er) {
 	case EMULATE_DONE:
 		return 1;
 	case EMULATE_DO_MMIO:
-		++vcpu->stat.mmio_exits;
+		++svm->vcpu.stat.mmio_exits;
 		return 0;
 	case EMULATE_FAIL:
-		vcpu_printf(vcpu, "%s: emulate fail\n", __FUNCTION__);
+		vcpu_printf(&svm->vcpu, "%s: emulate fail\n", __FUNCTION__);
 		break;
 	default:
 		BUG();
@@ -974,21 +973,18 @@ static int pf_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	return 0;
 }
 
-static int nm_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int nm_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-
 	svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
-	if (!(vcpu->cr0 & X86_CR0_TS))
+	if (!(svm->vcpu.cr0 & X86_CR0_TS))
 		svm->vmcb->save.cr0 &= ~X86_CR0_TS;
-	vcpu->fpu_active = 1;
+	svm->vcpu.fpu_active = 1;
 
 	return 1;
 }
 
-static int shutdown_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int shutdown_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
 	/*
 	 * VMCB is undefined after a SHUTDOWN intercept
 	 * so reinitialize it.
@@ -1000,11 +996,10 @@ static int shutdown_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	return 0;
 }
 
-static int io_get_override(struct kvm_vcpu *vcpu,
+static int io_get_override(struct vcpu_svm *svm,
 			  struct vmcb_seg **seg,
 			  int *addr_override)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
 	u8 inst[MAX_INST_SIZE];
 	unsigned ins_length;
 	gva_t rip;
@@ -1024,7 +1019,7 @@ static int io_get_override(struct kvm_vcpu *vcpu,
 		       svm->vmcb->control.exit_info_2,
 		       ins_length);
 
-	if (kvm_read_guest(vcpu, rip, ins_length, inst) != ins_length)
+	if (kvm_read_guest(&svm->vcpu, rip, ins_length, inst) != ins_length)
 		/* #PF */
 		return 0;
 
@@ -1065,28 +1060,27 @@ static int io_get_override(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static unsigned long io_adress(struct kvm_vcpu *vcpu, int ins, gva_t *address)
+static unsigned long io_adress(struct vcpu_svm *svm, int ins, gva_t *address)
 {
 	unsigned long addr_mask;
 	unsigned long *reg;
 	struct vmcb_seg *seg;
 	int addr_override;
-	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_save_area *save_area = &svm->vmcb->save;
 	u16 cs_attrib = save_area->cs.attrib;
-	unsigned addr_size = get_addr_size(vcpu);
+	unsigned addr_size = get_addr_size(svm);
 
-	if (!io_get_override(vcpu, &seg, &addr_override))
+	if (!io_get_override(svm, &seg, &addr_override))
 		return 0;
 
 	if (addr_override)
 		addr_size = (addr_size == 2) ? 4: (addr_size >> 1);
 
 	if (ins) {
-		reg = &vcpu->regs[VCPU_REGS_RDI];
+		reg = &svm->vcpu.regs[VCPU_REGS_RDI];
 		seg = &svm->vmcb->save.es;
 	} else {
-		reg = &vcpu->regs[VCPU_REGS_RSI];
+		reg = &svm->vcpu.regs[VCPU_REGS_RSI];
 		seg = (seg) ? seg : &svm->vmcb->save.ds;
 	}
 
@@ -1099,7 +1093,7 @@ static unsigned long io_adress(struct kvm_vcpu *vcpu, int ins, gva_t *address)
 	}
 
 	if (!(seg->attrib & SVM_SELECTOR_P_SHIFT)) {
-		svm_inject_gp(vcpu, 0);
+		svm_inject_gp(&svm->vcpu, 0);
 		return 0;
 	}
 
@@ -1107,16 +1101,15 @@ static unsigned long io_adress(struct kvm_vcpu *vcpu, int ins, gva_t *address)
 	return addr_mask;
 }
 
-static int io_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int io_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 io_info = svm->vmcb->control.exit_info_1; //address size bug?
 	int size, down, in, string, rep;
 	unsigned port;
 	unsigned long count;
 	gva_t address = 0;
 
-	++vcpu->stat.io_exits;
+	++svm->vcpu.stat.io_exits;
 
 	svm->next_rip = svm->vmcb->control.exit_info_2;
 
@@ -1131,7 +1124,7 @@ static int io_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (string) {
 		unsigned addr_mask;
 
-		addr_mask = io_adress(vcpu, in, &address);
+		addr_mask = io_adress(svm, in, &address);
 		if (!addr_mask) {
 			printk(KERN_DEBUG "%s: get io address failed\n",
 			       __FUNCTION__);
@@ -1139,60 +1132,57 @@ static int io_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		}
 
 		if (rep)
-			count = vcpu->regs[VCPU_REGS_RCX] & addr_mask;
+			count = svm->vcpu.regs[VCPU_REGS_RCX] & addr_mask;
 	}
-	return kvm_setup_pio(vcpu, kvm_run, in, size, count, string, down,
-			     address, rep, port);
+	return kvm_setup_pio(&svm->vcpu, kvm_run, in, size, count, string,
+			     down, address, rep, port);
 }
 
-static int nop_on_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int nop_on_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	return 1;
 }
 
-static int halt_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int halt_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-
 	svm->next_rip = svm->vmcb->save.rip + 1;
-	skip_emulated_instruction(vcpu);
-	return kvm_emulate_halt(vcpu);
+	skip_emulated_instruction(&svm->vcpu);
+	return kvm_emulate_halt(&svm->vcpu);
 }
 
-static int vmmcall_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int vmmcall_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-
 	svm->next_rip = svm->vmcb->save.rip + 3;
-	skip_emulated_instruction(vcpu);
-	return kvm_hypercall(vcpu, kvm_run);
+	skip_emulated_instruction(&svm->vcpu);
+	return kvm_hypercall(&svm->vcpu, kvm_run);
 }
 
-static int invalid_op_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int invalid_op_interception(struct vcpu_svm *svm,
+				   struct kvm_run *kvm_run)
 {
-	inject_ud(vcpu);
+	inject_ud(&svm->vcpu);
 	return 1;
 }
 
-static int task_switch_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int task_switch_interception(struct vcpu_svm *svm,
+				    struct kvm_run *kvm_run)
 {
 	printk(KERN_DEBUG "%s: task swiche is unsupported\n", __FUNCTION__);
 	kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
 	return 0;
 }
 
-static int cpuid_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int cpuid_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-
 	svm->next_rip = svm->vmcb->save.rip + 2;
-	kvm_emulate_cpuid(vcpu);
+	kvm_emulate_cpuid(&svm->vcpu);
 	return 1;
 }
 
-static int emulate_on_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int emulate_on_interception(struct vcpu_svm *svm,
+				   struct kvm_run *kvm_run)
 {
-	if (emulate_instruction(vcpu, NULL, 0, 0) != EMULATE_DONE)
+	if (emulate_instruction(&svm->vcpu, NULL, 0, 0) != EMULATE_DONE)
 		printk(KERN_ERR "%s: failed\n", __FUNCTION__);
 	return 1;
 }
@@ -1241,19 +1231,18 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 	return 0;
 }
 
-static int rdmsr_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int rdmsr_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-	u32 ecx = vcpu->regs[VCPU_REGS_RCX];
+	u32 ecx = svm->vcpu.regs[VCPU_REGS_RCX];
 	u64 data;
 
-	if (svm_get_msr(vcpu, ecx, &data))
-		svm_inject_gp(vcpu, 0);
+	if (svm_get_msr(&svm->vcpu, ecx, &data))
+		svm_inject_gp(&svm->vcpu, 0);
 	else {
 		svm->vmcb->save.rax = data & 0xffffffff;
-		vcpu->regs[VCPU_REGS_RDX] = data >> 32;
+		svm->vcpu.regs[VCPU_REGS_RDX] = data >> 32;
 		svm->next_rip = svm->vmcb->save.rip + 2;
-		skip_emulated_instruction(vcpu);
+		skip_emulated_instruction(&svm->vcpu);
 	}
 	return 1;
 }
@@ -1302,29 +1291,28 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 	return 0;
 }
 
-static int wrmsr_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int wrmsr_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-	u32 ecx = vcpu->regs[VCPU_REGS_RCX];
+	u32 ecx = svm->vcpu.regs[VCPU_REGS_RCX];
 	u64 data = (svm->vmcb->save.rax & -1u)
-		| ((u64)(vcpu->regs[VCPU_REGS_RDX] & -1u) << 32);
+		| ((u64)(svm->vcpu.regs[VCPU_REGS_RDX] & -1u) << 32);
 	svm->next_rip = svm->vmcb->save.rip + 2;
-	if (svm_set_msr(vcpu, ecx, data))
-		svm_inject_gp(vcpu, 0);
+	if (svm_set_msr(&svm->vcpu, ecx, data))
+		svm_inject_gp(&svm->vcpu, 0);
 	else
-		skip_emulated_instruction(vcpu);
+		skip_emulated_instruction(&svm->vcpu);
 	return 1;
 }
 
-static int msr_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int msr_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	if (to_svm(vcpu)->vmcb->control.exit_info_1)
-		return wrmsr_interception(vcpu, kvm_run);
+	if (svm->vmcb->control.exit_info_1)
+		return wrmsr_interception(svm, kvm_run);
 	else
-		return rdmsr_interception(vcpu, kvm_run);
+		return rdmsr_interception(svm, kvm_run);
 }
 
-static int interrupt_window_interception(struct kvm_vcpu *vcpu,
+static int interrupt_window_interception(struct vcpu_svm *svm,
 				   struct kvm_run *kvm_run)
 {
 	/*
@@ -1332,8 +1320,8 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu,
 	 * possible
 	 */
 	if (kvm_run->request_interrupt_window &&
-	    !vcpu->irq_summary) {
-		++vcpu->stat.irq_window_exits;
+	    !svm->vcpu.irq_summary) {
+		++svm->vcpu.stat.irq_window_exits;
 		kvm_run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
 		return 0;
 	}
@@ -1341,7 +1329,7 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
-static int (*svm_exit_handlers[])(struct kvm_vcpu *vcpu,
+static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 				      struct kvm_run *kvm_run) = {
 	[SVM_EXIT_READ_CR0]           		= emulate_on_interception,
 	[SVM_EXIT_READ_CR3]           		= emulate_on_interception,
@@ -1388,9 +1376,8 @@ static int (*svm_exit_handlers[])(struct kvm_vcpu *vcpu,
 };
 
 
-static int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int handle_exit(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 exit_code = svm->vmcb->control.exit_code;
 
 	if (is_external_interrupt(svm->vmcb->control.exit_int_info) &&
@@ -1407,7 +1394,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		return 0;
 	}
 
-	return svm_exit_handlers[exit_code](vcpu, kvm_run);
+	return svm_exit_handlers[exit_code](svm, kvm_run);
 }
 
 static void reload_tss(struct kvm_vcpu *vcpu)
@@ -1419,80 +1406,77 @@ static void reload_tss(struct kvm_vcpu *vcpu)
 	load_TR_desc();
 }
 
-static void pre_svm_run(struct kvm_vcpu *vcpu)
+static void pre_svm_run(struct vcpu_svm *svm)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
 	int cpu = raw_smp_processor_id();
 
 	struct svm_cpu_data *svm_data = per_cpu(svm_data, cpu);
 
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
-	if (vcpu->cpu != cpu ||
+	if (svm->vcpu.cpu != cpu ||
 	    svm->asid_generation != svm_data->asid_generation)
-		new_asid(vcpu, svm_data);
+		new_asid(svm, svm_data);
 }
 
 
-static inline void kvm_do_inject_irq(struct kvm_vcpu *vcpu)
+static inline void kvm_do_inject_irq(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control;
 
-	control = &to_svm(vcpu)->vmcb->control;
-	control->int_vector = pop_irq(vcpu);
+	control = &svm->vmcb->control;
+	control->int_vector = pop_irq(&svm->vcpu);
 	control->int_ctl &= ~V_INTR_PRIO_MASK;
 	control->int_ctl |= V_IRQ_MASK |
 		((/*control->int_vector >> 4*/ 0xf) << V_INTR_PRIO_SHIFT);
 }
 
-static void kvm_reput_irq(struct kvm_vcpu *vcpu)
+static void kvm_reput_irq(struct vcpu_svm *svm)
 {
-	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
+	struct vmcb_control_area *control = &svm->vmcb->control;
 
 	if (control->int_ctl & V_IRQ_MASK) {
 		control->int_ctl &= ~V_IRQ_MASK;
-		push_irq(vcpu, control->int_vector);
+		push_irq(&svm->vcpu, control->int_vector);
 	}
 
-	vcpu->interrupt_window_open =
+	svm->vcpu.interrupt_window_open =
 		!(control->int_state & SVM_INTERRUPT_SHADOW_MASK);
 }
 
-static void do_interrupt_requests(struct kvm_vcpu *vcpu,
+static void do_interrupt_requests(struct vcpu_svm *svm,
 				       struct kvm_run *kvm_run)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_control_area *control = &svm->vmcb->control;
 
-	vcpu->interrupt_window_open =
+	svm->vcpu.interrupt_window_open =
 		(!(control->int_state & SVM_INTERRUPT_SHADOW_MASK) &&
 		 (svm->vmcb->save.rflags & X86_EFLAGS_IF));
 
-	if (vcpu->interrupt_window_open && vcpu->irq_summary)
+	if (svm->vcpu.interrupt_window_open && svm->vcpu.irq_summary)
 		/*
 		 * If interrupts enabled, and not blocked by sti or mov ss. Good.
 		 */
-		kvm_do_inject_irq(vcpu);
+		kvm_do_inject_irq(svm);
 
 	/*
 	 * Interrupts blocked.  Wait for unblock.
 	 */
-	if (!vcpu->interrupt_window_open &&
-	    (vcpu->irq_summary || kvm_run->request_interrupt_window)) {
+	if (!svm->vcpu.interrupt_window_open &&
+	    (svm->vcpu.irq_summary || kvm_run->request_interrupt_window)) {
 		control->intercept |= 1ULL << INTERCEPT_VINTR;
 	} else
 		control->intercept &= ~(1ULL << INTERCEPT_VINTR);
 }
 
-static void post_kvm_run_save(struct kvm_vcpu *vcpu,
+static void post_kvm_run_save(struct vcpu_svm *svm,
 			      struct kvm_run *kvm_run)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	kvm_run->ready_for_interrupt_injection = (vcpu->interrupt_window_open &&
-						  vcpu->irq_summary == 0);
+	kvm_run->ready_for_interrupt_injection
+		= (svm->vcpu.interrupt_window_open &&
+		   svm->vcpu.irq_summary == 0);
 	kvm_run->if_flag = (svm->vmcb->save.rflags & X86_EFLAGS_IF) != 0;
-	kvm_run->cr8 = vcpu->cr8;
-	kvm_run->apic_base = vcpu->apic_base;
+	kvm_run->cr8 = svm->vcpu.cr8;
+	kvm_run->apic_base = svm->vcpu.apic_base;
 }
 
 /*
@@ -1501,13 +1485,13 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu,
  *
  * No need to exit to userspace if we already have an interrupt queued.
  */
-static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu,
+static int dm_request_for_irq_injection(struct vcpu_svm *svm,
 					  struct kvm_run *kvm_run)
 {
-	return (!vcpu->irq_summary &&
+	return (!svm->vcpu.irq_summary &&
 		kvm_run->request_interrupt_window &&
-		vcpu->interrupt_window_open &&
-		(to_svm(vcpu)->vmcb->save.rflags & X86_EFLAGS_IF));
+		svm->vcpu.interrupt_window_open &&
+		(svm->vmcb->save.rflags & X86_EFLAGS_IF));
 }
 
 static void save_db_regs(unsigned long *db_regs)
@@ -1545,7 +1529,7 @@ again:
 		return r;
 
 	if (!vcpu->mmio_read_completed)
-		do_interrupt_requests(vcpu, kvm_run);
+		do_interrupt_requests(svm, kvm_run);
 
 	clgi();
 
@@ -1554,7 +1538,7 @@ again:
 		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
 		    svm_flush_tlb(vcpu);
 
-	pre_svm_run(vcpu);
+	pre_svm_run(svm);
 
 	save_host_msrs(vcpu);
 	fs_selector = read_fs();
@@ -1714,7 +1698,7 @@ again:
 
 	stgi();
 
-	kvm_reput_irq(vcpu);
+	kvm_reput_irq(svm);
 
 	svm->next_rip = 0;
 
@@ -1722,29 +1706,29 @@ again:
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		kvm_run->fail_entry.hardware_entry_failure_reason
 			= svm->vmcb->control.exit_code;
-		post_kvm_run_save(vcpu, kvm_run);
+		post_kvm_run_save(svm, kvm_run);
 		return 0;
 	}
 
-	r = handle_exit(vcpu, kvm_run);
+	r = handle_exit(svm, kvm_run);
 	if (r > 0) {
 		if (signal_pending(current)) {
 			++vcpu->stat.signal_exits;
-			post_kvm_run_save(vcpu, kvm_run);
+			post_kvm_run_save(svm, kvm_run);
 			kvm_run->exit_reason = KVM_EXIT_INTR;
 			return -EINTR;
 		}
 
-		if (dm_request_for_irq_injection(vcpu, kvm_run)) {
+		if (dm_request_for_irq_injection(svm, kvm_run)) {
 			++vcpu->stat.request_irq_exits;
-			post_kvm_run_save(vcpu, kvm_run);
+			post_kvm_run_save(svm, kvm_run);
 			kvm_run->exit_reason = KVM_EXIT_INTR;
 			return -EINTR;
 		}
 		kvm_resched(vcpu);
 		goto again;
 	}
-	post_kvm_run_save(vcpu, kvm_run);
+	post_kvm_run_save(svm, kvm_run);
 	return r;
 }
 
-- 
1.5.3

