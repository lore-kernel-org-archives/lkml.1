Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbXJVR2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbXJVR2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 13:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbXJVR2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 13:28:33 -0400
Received: from il.qumranet.com ([82.166.9.18]:54349 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbXJVR2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 13:28:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 2.6.24-rc
Date: Mon, 22 Oct 2007 19:28:52 +0200
Message-Id: <11930741323893-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the kvm updates in

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus

These fix bugs introduces in the latest update (except for two commits: one
adds support for the movnti instruction, used by Linus 2.6.16 for mmio,
and one makes use of smp_call_function_mask(), which is new in x86_64).

The change in sched.c is trivial and has been acked by Ingo.

Aurelien Jarno (1):
      KVM: x86 emulator: fix access registers for instructions with ModR/M byte and Mod = 3

Avi Kivity (2):
      KVM: VMX: Handle NMIs before enabling interrupts and preemption
      KVM: VMX: Force vm86 mode if setting flags during real mode

Eddie Dong (1):
      KVM: VMX: Reset mmu context when entering real mode

Izik Eidus (1):
      KVM: MMU: Set shadow pte atomically in mmu_pte_write_zap_pte()

Kevin Pedretti (2):
      KVM: Fix local apic timer divide by zero
      KVM: Improve local apic timer wraparound handling

Laurent Vivier (4):
      KVM: x86 emulator: fix repne/repnz decoding
      KVM: Move kvm_guest_exit() after local_irq_enable()
      sched: don't clear PF_VCPU in scheduler
      KVM: Use new smp_call_function_mask() in kvm_flush_remote_tlbs()

Nitin A Kamble (1):
      KVM: x86 emulator: fix merge screwup due to emulator split

Sheng Yang (1):
      KVM: x86 emulator: implement 'movnti mem, reg'

 drivers/kvm/kvm_main.c    |   37 +++++++--------------
 drivers/kvm/lapic.c       |   38 ++++++++++++++++------
 drivers/kvm/mmu.c         |    3 +-
 drivers/kvm/vmx.c         |   16 +++++++--
 drivers/kvm/x86_emulate.c |   77 ++++++++++++++++++++++++++++----------------
 kernel/sched.c            |    1 -
 6 files changed, 103 insertions(+), 69 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index af2d288..07ae280 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -198,21 +198,15 @@ static void vcpu_put(struct kvm_vcpu *vcpu)
 
 static void ack_flush(void *_completed)
 {
-	atomic_t *completed = _completed;
-
-	atomic_inc(completed);
 }
 
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
-	int i, cpu, needed;
+	int i, cpu;
 	cpumask_t cpus;
 	struct kvm_vcpu *vcpu;
-	atomic_t completed;
 
-	atomic_set(&completed, 0);
 	cpus_clear(cpus);
-	needed = 0;
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		vcpu = kvm->vcpus[i];
 		if (!vcpu)
@@ -221,23 +215,9 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 			continue;
 		cpu = vcpu->cpu;
 		if (cpu != -1 && cpu != raw_smp_processor_id())
-			if (!cpu_isset(cpu, cpus)) {
-				cpu_set(cpu, cpus);
-				++needed;
-			}
-	}
-
-	/*
-	 * We really want smp_call_function_mask() here.  But that's not
-	 * available, so ipi all cpus in parallel and wait for them
-	 * to complete.
-	 */
-	for (cpu = first_cpu(cpus); cpu != NR_CPUS; cpu = next_cpu(cpu, cpus))
-		smp_call_function_single(cpu, ack_flush, &completed, 1, 0);
-	while (atomic_read(&completed) != needed) {
-		cpu_relax();
-		barrier();
+			cpu_set(cpu, cpus);
 	}
+	smp_call_function_mask(cpus, ack_flush, NULL, 1);
 }
 
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
@@ -2054,12 +2034,21 @@ again:
 
 	kvm_x86_ops->run(vcpu, kvm_run);
 
-	kvm_guest_exit();
 	vcpu->guest_mode = 0;
 	local_irq_enable();
 
 	++vcpu->stat.exits;
 
+	/*
+	 * We must have an instruction between local_irq_enable() and
+	 * kvm_guest_exit(), so the timer interrupt isn't delayed by
+	 * the interrupt shadow.  The stat.exits increment will do nicely.
+	 * But we need to prevent reordering, hence this barrier():
+	 */
+	barrier();
+
+	kvm_guest_exit();
+
 	preempt_enable();
 
 	/*
diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index a190587..238fcad 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -494,12 +494,19 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 
 static u32 apic_get_tmcct(struct kvm_lapic *apic)
 {
-	u32 counter_passed;
-	ktime_t passed, now = apic->timer.dev.base->get_time();
-	u32 tmcct = apic_get_reg(apic, APIC_TMICT);
+	u64 counter_passed;
+	ktime_t passed, now;
+	u32 tmcct;
 
 	ASSERT(apic != NULL);
 
+	now = apic->timer.dev.base->get_time();
+	tmcct = apic_get_reg(apic, APIC_TMICT);
+
+	/* if initial count is 0, current count should also be 0 */
+	if (tmcct == 0)
+		return 0;
+
 	if (unlikely(ktime_to_ns(now) <=
 		ktime_to_ns(apic->timer.last_update))) {
 		/* Wrap around */
@@ -514,15 +521,24 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
 
 	counter_passed = div64_64(ktime_to_ns(passed),
 				  (APIC_BUS_CYCLE_NS * apic->timer.divide_count));
-	tmcct -= counter_passed;
 
-	if (tmcct <= 0) {
-		if (unlikely(!apic_lvtt_period(apic)))
+	if (counter_passed > tmcct) {
+		if (unlikely(!apic_lvtt_period(apic))) {
+			/* one-shot timers stick at 0 until reset */
 			tmcct = 0;
-		else
-			do {
-				tmcct += apic_get_reg(apic, APIC_TMICT);
-			} while (tmcct <= 0);
+		} else {
+			/*
+			 * periodic timers reset to APIC_TMICT when they
+			 * hit 0. The while loop simulates this happening N
+			 * times. (counter_passed %= tmcct) would also work,
+			 * but might be slower or not work on 32-bit??
+			 */
+			while (counter_passed > tmcct)
+				counter_passed -= tmcct;
+			tmcct -= counter_passed;
+		}
+	} else {
+		tmcct -= counter_passed;
 	}
 
 	return tmcct;
@@ -853,7 +869,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 		apic_set_reg(apic, APIC_ISR + 0x10 * i, 0);
 		apic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
 	}
-	apic->timer.divide_count = 0;
+	update_divide_count(apic);
 	atomic_set(&apic->timer.pending, 0);
 	if (vcpu->vcpu_id == 0)
 		vcpu->apic_base |= MSR_IA32_APICBASE_BSP;
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 6d84d30..feb5ac9 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1049,6 +1049,7 @@ int kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 	destroy_kvm_mmu(vcpu);
 	return init_kvm_mmu(vcpu);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_reset_context);
 
 int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
@@ -1088,7 +1089,7 @@ static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 			mmu_page_remove_parent_pte(child, spte);
 		}
 	}
-	*spte = 0;
+	set_shadow_pte(spte, 0);
 	kvm_flush_remote_tlbs(vcpu->kvm);
 }
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 4f115a8..bb56ae3 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -523,6 +523,8 @@ static unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
 
 static void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 {
+	if (vcpu->rmode.active)
+		rflags |= IOPL_MASK | X86_EFLAGS_VM;
 	vmcs_writel(GUEST_RFLAGS, rflags);
 }
 
@@ -1128,6 +1130,7 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 	fix_rmode_seg(VCPU_SREG_GS, &vcpu->rmode.gs);
 	fix_rmode_seg(VCPU_SREG_FS, &vcpu->rmode.fs);
 
+	kvm_mmu_reset_context(vcpu);
 	init_rmode_tss(vcpu->kvm);
 }
 
@@ -1760,10 +1763,8 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		set_bit(irq / BITS_PER_LONG, &vcpu->irq_summary);
 	}
 
-	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == 0x200) { /* nmi */
-		asm ("int $2");
-		return 1;
-	}
+	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == 0x200) /* nmi */
+		return 1;  /* already handled by vmx_vcpu_run() */
 
 	if (is_no_device(intr_info)) {
 		vmx_fpu_activate(vcpu);
@@ -2196,6 +2197,7 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 intr_info;
 
 	/*
 	 * Loading guest fpu may have cleared host cr0.ts
@@ -2322,6 +2324,12 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	asm ("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
 	vmx->launched = 1;
+
+	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+
+	/* We need to handle NMIs before interrupts are enabled */
+	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == 0x200) /* nmi */
+		asm("int $2");
 }
 
 static void vmx_inject_page_fault(struct kvm_vcpu *vcpu,
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 9737c3b..a6ace30 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -212,7 +212,8 @@ static u16 twobyte_table[256] = {
 	0, 0, ByteOp | DstReg | SrcMem | ModRM | Mov,
 	    DstReg | SrcMem16 | ModRM | Mov,
 	/* 0xC0 - 0xCF */
-	0, 0, 0, 0, 0, 0, 0, ImplicitOps | ModRM, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, DstMem | SrcReg | ModRM | Mov, 0, 0, 0, ImplicitOps | ModRM,
+	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xD0 - 0xDF */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xE0 - 0xEF */
@@ -596,11 +597,10 @@ x86_emulate_memop(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 		case 0xf0:	/* LOCK */
 			lock_prefix = 1;
 			break;
+		case 0xf2:	/* REPNE/REPNZ */
 		case 0xf3:	/* REP/REPE/REPZ */
 			rep_prefix = 1;
 			break;
-		case 0xf2:	/* REPNE/REPNZ */
-			break;
 		default:
 			goto done_prefixes;
 		}
@@ -825,6 +825,14 @@ done_prefixes:
 		if (twobyte && b == 0x01 && modrm_reg == 7)
 			break;
 	      srcmem_common:
+		/*
+		 * For instructions with a ModR/M byte, switch to register
+		 * access if Mod = 3.
+		 */
+		if ((d & ModRM) && modrm_mod == 3) {
+			src.type = OP_REG;
+			break;
+		}
 		src.type = OP_MEM;
 		src.ptr = (unsigned long *)cr2;
 		src.val = 0;
@@ -893,6 +901,14 @@ done_prefixes:
 		dst.ptr = (unsigned long *)cr2;
 		dst.bytes = (d & ByteOp) ? 1 : op_bytes;
 		dst.val = 0;
+		/*
+		 * For instructions with a ModR/M byte, switch to register
+		 * access if Mod = 3.
+		 */
+		if ((d & ModRM) && modrm_mod == 3) {
+			dst.type = OP_REG;
+			break;
+		}
 		if (d & BitOp) {
 			unsigned long mask = ~(dst.bytes * 8 - 1);
 
@@ -1083,31 +1099,6 @@ push:
 	case 0xd2 ... 0xd3:	/* Grp2 */
 		src.val = _regs[VCPU_REGS_RCX];
 		goto grp2;
-	case 0xe8: /* call (near) */ {
-		long int rel;
-		switch (op_bytes) {
-		case 2:
-			rel = insn_fetch(s16, 2, _eip);
-			break;
-		case 4:
-			rel = insn_fetch(s32, 4, _eip);
-			break;
-		case 8:
-			rel = insn_fetch(s64, 8, _eip);
-			break;
-		default:
-			DPRINTF("Call: Invalid op_bytes\n");
-			goto cannot_emulate;
-		}
-		src.val = (unsigned long) _eip;
-		JMP_REL(rel);
-		goto push;
-	}
-	case 0xe9: /* jmp rel */
-	case 0xeb: /* jmp rel short */
-		JMP_REL(src.val);
-		no_wb = 1; /* Disable writeback. */
-		break;
 	case 0xf6 ... 0xf7:	/* Grp3 */
 		switch (modrm_reg) {
 		case 0 ... 1:	/* test */
@@ -1350,6 +1341,32 @@ special_insn:
 	case 0xae ... 0xaf:	/* scas */
 		DPRINTF("Urk! I don't handle SCAS.\n");
 		goto cannot_emulate;
+	case 0xe8: /* call (near) */ {
+		long int rel;
+		switch (op_bytes) {
+		case 2:
+			rel = insn_fetch(s16, 2, _eip);
+			break;
+		case 4:
+			rel = insn_fetch(s32, 4, _eip);
+			break;
+		case 8:
+			rel = insn_fetch(s64, 8, _eip);
+			break;
+		default:
+			DPRINTF("Call: Invalid op_bytes\n");
+			goto cannot_emulate;
+		}
+		src.val = (unsigned long) _eip;
+		JMP_REL(rel);
+		goto push;
+	}
+	case 0xe9: /* jmp rel */
+	case 0xeb: /* jmp rel short */
+		JMP_REL(src.val);
+		no_wb = 1; /* Disable writeback. */
+		break;
+
 
 	}
 	goto writeback;
@@ -1501,6 +1518,10 @@ twobyte_insn:
 		dst.bytes = op_bytes;
 		dst.val = (d & ByteOp) ? (s8) src.val : (s16) src.val;
 		break;
+	case 0xc3:		/* movnti */
+		dst.bytes = op_bytes;
+		dst.val = (op_bytes == 4) ? (u32) src.val : (u64) src.val;
+		break;
 	}
 	goto writeback;
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 7581e33..2810e56 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3375,7 +3375,6 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 
 	if (p->flags & PF_VCPU) {
 		account_guest_time(p, cputime);
-		p->flags &= ~PF_VCPU;
 		return;
 	}
 
