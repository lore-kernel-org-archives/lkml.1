Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbXIQIvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbXIQIvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbXIQId1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:27 -0400
Received: from il.qumranet.com ([82.166.9.18]:45319 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbXIQIcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:36 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Subject: [PATCH 088/104] KVM: Rename kvm_arch_ops to kvm_x86_ops
Date: Mon, 17 Sep 2007 10:32:10 +0200
Message-Id: <1190017949474-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

This patch just renames the current (misnamed) _arch namings to _x86 to
ensure better readability when a real arch layer takes place.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    8 +-
 drivers/kvm/kvm_main.c    |  160 ++++++++++++++++++++++----------------------
 drivers/kvm/mmu.c         |    6 +-
 drivers/kvm/paging_tmpl.h |    2 +-
 drivers/kvm/svm.c         |    6 +-
 drivers/kvm/vmx.c         |    6 +-
 drivers/kvm/x86_emulate.c |    4 +-
 7 files changed, 96 insertions(+), 96 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 351da40..42bb225 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -441,7 +441,7 @@ struct descriptor_table {
 	unsigned long base;
 } __attribute__((packed));
 
-struct kvm_arch_ops {
+struct kvm_x86_ops {
 	int (*cpu_has_kvm_support)(void);          /* __init */
 	int (*disabled_by_bios)(void);             /* __init */
 	void (*hardware_enable)(void *dummy);      /* __init */
@@ -499,7 +499,7 @@ struct kvm_arch_ops {
 	void (*set_irq)(struct kvm_vcpu *vcpu, int vec);
 };
 
-extern struct kvm_arch_ops *kvm_arch_ops;
+extern struct kvm_x86_ops *kvm_x86_ops;
 
 /* The guest did something we don't support. */
 #define pr_unimpl(vcpu, fmt, ...)					\
@@ -515,9 +515,9 @@ extern struct kvm_arch_ops *kvm_arch_ops;
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
 
-int kvm_init_arch(struct kvm_arch_ops *ops, unsigned int vcpu_size,
+int kvm_init_x86(struct kvm_x86_ops *ops, unsigned int vcpu_size,
 		  struct module *module);
-void kvm_exit_arch(void);
+void kvm_exit_x86(void);
 
 int kvm_mmu_module_init(void);
 void kvm_mmu_module_exit(void);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index c2c8c93..4c3b7ed 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -53,7 +53,7 @@ static LIST_HEAD(vm_list);
 
 static cpumask_t cpus_hardware_enabled;
 
-struct kvm_arch_ops *kvm_arch_ops;
+struct kvm_x86_ops *kvm_x86_ops;
 struct kmem_cache *kvm_vcpu_cache;
 EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
 
@@ -182,14 +182,14 @@ static void vcpu_load(struct kvm_vcpu *vcpu)
 	mutex_lock(&vcpu->mutex);
 	cpu = get_cpu();
 	preempt_notifier_register(&vcpu->preempt_notifier);
-	kvm_arch_ops->vcpu_load(vcpu, cpu);
+	kvm_x86_ops->vcpu_load(vcpu, cpu);
 	put_cpu();
 }
 
 static void vcpu_put(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
-	kvm_arch_ops->vcpu_put(vcpu);
+	kvm_x86_ops->vcpu_put(vcpu);
 	preempt_notifier_unregister(&vcpu->preempt_notifier);
 	preempt_enable();
 	mutex_unlock(&vcpu->mutex);
@@ -374,7 +374,7 @@ static void kvm_free_vcpus(struct kvm *kvm)
 			kvm_unload_vcpu_mmu(kvm->vcpus[i]);
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		if (kvm->vcpus[i]) {
-			kvm_arch_ops->vcpu_free(kvm->vcpus[i]);
+			kvm_x86_ops->vcpu_free(kvm->vcpus[i]);
 			kvm->vcpus[i] = NULL;
 		}
 	}
@@ -405,7 +405,7 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
 
 static void inject_gp(struct kvm_vcpu *vcpu)
 {
-	kvm_arch_ops->inject_gp(vcpu, 0);
+	kvm_x86_ops->inject_gp(vcpu, 0);
 }
 
 /*
@@ -480,7 +480,7 @@ void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 				inject_gp(vcpu);
 				return;
 			}
-			kvm_arch_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
+			kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
 			if (cs_l) {
 				printk(KERN_DEBUG "set_cr0: #GP, start paging "
 				       "in long mode while CS.L == 1\n");
@@ -499,7 +499,7 @@ void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 	}
 
-	kvm_arch_ops->set_cr0(vcpu, cr0);
+	kvm_x86_ops->set_cr0(vcpu, cr0);
 	vcpu->cr0 = cr0;
 
 	mutex_lock(&vcpu->kvm->lock);
@@ -542,7 +542,7 @@ void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		inject_gp(vcpu);
 		return;
 	}
-	kvm_arch_ops->set_cr4(vcpu, cr4);
+	kvm_x86_ops->set_cr4(vcpu, cr4);
 	vcpu->cr4 = cr4;
 	mutex_lock(&vcpu->kvm->lock);
 	kvm_mmu_reset_context(vcpu);
@@ -1134,7 +1134,7 @@ static int emulator_write_emulated_onepage(unsigned long addr,
 	gpa_t                 gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
 
 	if (gpa == UNMAPPED_GVA) {
-		kvm_arch_ops->inject_page_fault(vcpu, addr, 2);
+		kvm_x86_ops->inject_page_fault(vcpu, addr, 2);
 		return X86EMUL_PROPAGATE_FAULT;
 	}
 
@@ -1197,7 +1197,7 @@ static int emulator_cmpxchg_emulated(unsigned long addr,
 
 static unsigned long get_segment_base(struct kvm_vcpu *vcpu, int seg)
 {
-	return kvm_arch_ops->get_segment_base(vcpu, seg);
+	return kvm_x86_ops->get_segment_base(vcpu, seg);
 }
 
 int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address)
@@ -1208,7 +1208,7 @@ int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address)
 int emulate_clts(struct kvm_vcpu *vcpu)
 {
 	vcpu->cr0 &= ~X86_CR0_TS;
-	kvm_arch_ops->set_cr0(vcpu, vcpu->cr0);
+	kvm_x86_ops->set_cr0(vcpu, vcpu->cr0);
 	return X86EMUL_CONTINUE;
 }
 
@@ -1218,7 +1218,7 @@ int emulator_get_dr(struct x86_emulate_ctxt* ctxt, int dr, unsigned long *dest)
 
 	switch (dr) {
 	case 0 ... 3:
-		*dest = kvm_arch_ops->get_dr(vcpu, dr);
+		*dest = kvm_x86_ops->get_dr(vcpu, dr);
 		return X86EMUL_CONTINUE;
 	default:
 		pr_unimpl(vcpu, "%s: unexpected dr %u\n", __FUNCTION__, dr);
@@ -1231,7 +1231,7 @@ int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr, unsigned long value)
 	unsigned long mask = (ctxt->mode == X86EMUL_MODE_PROT64) ? ~0ULL : ~0U;
 	int exception;
 
-	kvm_arch_ops->set_dr(ctxt->vcpu, dr, value & mask, &exception);
+	kvm_x86_ops->set_dr(ctxt->vcpu, dr, value & mask, &exception);
 	if (exception) {
 		/* FIXME: better handling */
 		return X86EMUL_UNHANDLEABLE;
@@ -1277,12 +1277,12 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 	int cs_db, cs_l;
 
 	vcpu->mmio_fault_cr2 = cr2;
-	kvm_arch_ops->cache_regs(vcpu);
+	kvm_x86_ops->cache_regs(vcpu);
 
-	kvm_arch_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
+	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
 
 	emulate_ctxt.vcpu = vcpu;
-	emulate_ctxt.eflags = kvm_arch_ops->get_rflags(vcpu);
+	emulate_ctxt.eflags = kvm_x86_ops->get_rflags(vcpu);
 	emulate_ctxt.cr2 = cr2;
 	emulate_ctxt.mode = (emulate_ctxt.eflags & X86_EFLAGS_VM)
 		? X86EMUL_MODE_REAL : cs_l
@@ -1328,8 +1328,8 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 		return EMULATE_DO_MMIO;
 	}
 
-	kvm_arch_ops->decache_regs(vcpu);
-	kvm_arch_ops->set_rflags(vcpu, emulate_ctxt.eflags);
+	kvm_x86_ops->decache_regs(vcpu);
+	kvm_x86_ops->set_rflags(vcpu, emulate_ctxt.eflags);
 
 	if (vcpu->mmio_is_write) {
 		vcpu->mmio_needed = 0;
@@ -1386,7 +1386,7 @@ int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	unsigned long nr, a0, a1, a2, a3, a4, a5, ret;
 
-	kvm_arch_ops->cache_regs(vcpu);
+	kvm_x86_ops->cache_regs(vcpu);
 	ret = -KVM_EINVAL;
 #ifdef CONFIG_X86_64
 	if (is_long_mode(vcpu)) {
@@ -1419,11 +1419,11 @@ int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		run->hypercall.args[5] = a5;
 		run->hypercall.ret = ret;
 		run->hypercall.longmode = is_long_mode(vcpu);
-		kvm_arch_ops->decache_regs(vcpu);
+		kvm_x86_ops->decache_regs(vcpu);
 		return 0;
 	}
 	vcpu->regs[VCPU_REGS_RAX] = ret;
-	kvm_arch_ops->decache_regs(vcpu);
+	kvm_x86_ops->decache_regs(vcpu);
 	return 1;
 }
 EXPORT_SYMBOL_GPL(kvm_hypercall);
@@ -1437,26 +1437,26 @@ void realmode_lgdt(struct kvm_vcpu *vcpu, u16 limit, unsigned long base)
 {
 	struct descriptor_table dt = { limit, base };
 
-	kvm_arch_ops->set_gdt(vcpu, &dt);
+	kvm_x86_ops->set_gdt(vcpu, &dt);
 }
 
 void realmode_lidt(struct kvm_vcpu *vcpu, u16 limit, unsigned long base)
 {
 	struct descriptor_table dt = { limit, base };
 
-	kvm_arch_ops->set_idt(vcpu, &dt);
+	kvm_x86_ops->set_idt(vcpu, &dt);
 }
 
 void realmode_lmsw(struct kvm_vcpu *vcpu, unsigned long msw,
 		   unsigned long *rflags)
 {
 	lmsw(vcpu, msw);
-	*rflags = kvm_arch_ops->get_rflags(vcpu);
+	*rflags = kvm_x86_ops->get_rflags(vcpu);
 }
 
 unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr)
 {
-	kvm_arch_ops->decache_cr4_guest_bits(vcpu);
+	kvm_x86_ops->decache_cr4_guest_bits(vcpu);
 	switch (cr) {
 	case 0:
 		return vcpu->cr0;
@@ -1478,7 +1478,7 @@ void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long val,
 	switch (cr) {
 	case 0:
 		set_cr0(vcpu, mk_cr_64(vcpu->cr0, val));
-		*rflags = kvm_arch_ops->get_rflags(vcpu);
+		*rflags = kvm_x86_ops->get_rflags(vcpu);
 		break;
 	case 2:
 		vcpu->cr2 = val;
@@ -1552,7 +1552,7 @@ static int vcpu_register_para(struct kvm_vcpu *vcpu, gpa_t para_state_gpa)
 	mark_page_dirty(vcpu->kvm, hypercall_gpa >> PAGE_SHIFT);
 	hypercall = kmap_atomic(pfn_to_page(hypercall_hpa >> PAGE_SHIFT),
 				KM_USER1) + (hypercall_hpa & ~PAGE_MASK);
-	kvm_arch_ops->patch_hypercall(vcpu, hypercall);
+	kvm_x86_ops->patch_hypercall(vcpu, hypercall);
 	kunmap_atomic(hypercall, KM_USER1);
 
 	para_state->ret = 0;
@@ -1619,7 +1619,7 @@ EXPORT_SYMBOL_GPL(kvm_get_msr_common);
  */
 int kvm_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 {
-	return kvm_arch_ops->get_msr(vcpu, msr_index, pdata);
+	return kvm_x86_ops->get_msr(vcpu, msr_index, pdata);
 }
 
 #ifdef CONFIG_X86_64
@@ -1640,7 +1640,7 @@ static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
 		return;
 	}
 
-	kvm_arch_ops->set_efer(vcpu, efer);
+	kvm_x86_ops->set_efer(vcpu, efer);
 
 	efer &= ~EFER_LMA;
 	efer |= vcpu->shadow_efer & EFER_LMA;
@@ -1697,7 +1697,7 @@ EXPORT_SYMBOL_GPL(kvm_set_msr_common);
  */
 int kvm_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 {
-	return kvm_arch_ops->set_msr(vcpu, msr_index, data);
+	return kvm_x86_ops->set_msr(vcpu, msr_index, data);
 }
 
 void kvm_resched(struct kvm_vcpu *vcpu)
@@ -1714,7 +1714,7 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 	u32 function;
 	struct kvm_cpuid_entry *e, *best;
 
-	kvm_arch_ops->cache_regs(vcpu);
+	kvm_x86_ops->cache_regs(vcpu);
 	function = vcpu->regs[VCPU_REGS_RAX];
 	vcpu->regs[VCPU_REGS_RAX] = 0;
 	vcpu->regs[VCPU_REGS_RBX] = 0;
@@ -1740,8 +1740,8 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 		vcpu->regs[VCPU_REGS_RCX] = best->ecx;
 		vcpu->regs[VCPU_REGS_RDX] = best->edx;
 	}
-	kvm_arch_ops->decache_regs(vcpu);
-	kvm_arch_ops->skip_emulated_instruction(vcpu);
+	kvm_x86_ops->decache_regs(vcpu);
+	kvm_x86_ops->skip_emulated_instruction(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_cpuid);
 
@@ -1776,7 +1776,7 @@ static int complete_pio(struct kvm_vcpu *vcpu)
 	long delta;
 	int r;
 
-	kvm_arch_ops->cache_regs(vcpu);
+	kvm_x86_ops->cache_regs(vcpu);
 
 	if (!io->string) {
 		if (io->in)
@@ -1786,7 +1786,7 @@ static int complete_pio(struct kvm_vcpu *vcpu)
 		if (io->in) {
 			r = pio_copy_data(vcpu);
 			if (r) {
-				kvm_arch_ops->cache_regs(vcpu);
+				kvm_x86_ops->cache_regs(vcpu);
 				return r;
 			}
 		}
@@ -1809,13 +1809,13 @@ static int complete_pio(struct kvm_vcpu *vcpu)
 			vcpu->regs[VCPU_REGS_RSI] += delta;
 	}
 
-	kvm_arch_ops->decache_regs(vcpu);
+	kvm_x86_ops->decache_regs(vcpu);
 
 	io->count -= io->cur_count;
 	io->cur_count = 0;
 
 	if (!io->count)
-		kvm_arch_ops->skip_emulated_instruction(vcpu);
+		kvm_x86_ops->skip_emulated_instruction(vcpu);
 	return 0;
 }
 
@@ -1871,9 +1871,9 @@ int kvm_emulate_pio (struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	vcpu->pio.guest_page_offset = 0;
 	vcpu->pio.rep = 0;
 
-	kvm_arch_ops->cache_regs(vcpu);
+	kvm_x86_ops->cache_regs(vcpu);
 	memcpy(vcpu->pio_data, &vcpu->regs[VCPU_REGS_RAX], 4);
-	kvm_arch_ops->decache_regs(vcpu);
+	kvm_x86_ops->decache_regs(vcpu);
 
 	pio_dev = vcpu_find_pio_dev(vcpu, port);
 	if (pio_dev) {
@@ -1908,7 +1908,7 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	vcpu->pio.rep = rep;
 
 	if (!count) {
-		kvm_arch_ops->skip_emulated_instruction(vcpu);
+		kvm_x86_ops->skip_emulated_instruction(vcpu);
 		return 1;
 	}
 
@@ -2012,12 +2012,12 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	}
 
 	if (kvm_run->exit_reason == KVM_EXIT_HYPERCALL) {
-		kvm_arch_ops->cache_regs(vcpu);
+		kvm_x86_ops->cache_regs(vcpu);
 		vcpu->regs[VCPU_REGS_RAX] = kvm_run->hypercall.ret;
-		kvm_arch_ops->decache_regs(vcpu);
+		kvm_x86_ops->decache_regs(vcpu);
 	}
 
-	r = kvm_arch_ops->run(vcpu, kvm_run);
+	r = kvm_x86_ops->run(vcpu, kvm_run);
 
 out:
 	if (vcpu->sigset_active)
@@ -2032,7 +2032,7 @@ static int kvm_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu,
 {
 	vcpu_load(vcpu);
 
-	kvm_arch_ops->cache_regs(vcpu);
+	kvm_x86_ops->cache_regs(vcpu);
 
 	regs->rax = vcpu->regs[VCPU_REGS_RAX];
 	regs->rbx = vcpu->regs[VCPU_REGS_RBX];
@@ -2054,7 +2054,7 @@ static int kvm_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu,
 #endif
 
 	regs->rip = vcpu->rip;
-	regs->rflags = kvm_arch_ops->get_rflags(vcpu);
+	regs->rflags = kvm_x86_ops->get_rflags(vcpu);
 
 	/*
 	 * Don't leak debug flags in case they were set for guest debugging
@@ -2092,9 +2092,9 @@ static int kvm_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu,
 #endif
 
 	vcpu->rip = regs->rip;
-	kvm_arch_ops->set_rflags(vcpu, regs->rflags);
+	kvm_x86_ops->set_rflags(vcpu, regs->rflags);
 
-	kvm_arch_ops->decache_regs(vcpu);
+	kvm_x86_ops->decache_regs(vcpu);
 
 	vcpu_put(vcpu);
 
@@ -2104,7 +2104,7 @@ static int kvm_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu,
 static void get_segment(struct kvm_vcpu *vcpu,
 			struct kvm_segment *var, int seg)
 {
-	return kvm_arch_ops->get_segment(vcpu, var, seg);
+	return kvm_x86_ops->get_segment(vcpu, var, seg);
 }
 
 static int kvm_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
@@ -2125,14 +2125,14 @@ static int kvm_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 	get_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
 	get_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
 
-	kvm_arch_ops->get_idt(vcpu, &dt);
+	kvm_x86_ops->get_idt(vcpu, &dt);
 	sregs->idt.limit = dt.limit;
 	sregs->idt.base = dt.base;
-	kvm_arch_ops->get_gdt(vcpu, &dt);
+	kvm_x86_ops->get_gdt(vcpu, &dt);
 	sregs->gdt.limit = dt.limit;
 	sregs->gdt.base = dt.base;
 
-	kvm_arch_ops->decache_cr4_guest_bits(vcpu);
+	kvm_x86_ops->decache_cr4_guest_bits(vcpu);
 	sregs->cr0 = vcpu->cr0;
 	sregs->cr2 = vcpu->cr2;
 	sregs->cr3 = vcpu->cr3;
@@ -2144,7 +2144,7 @@ static int kvm_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 	if (irqchip_in_kernel(vcpu->kvm)) {
 		memset(sregs->interrupt_bitmap, 0,
 		       sizeof sregs->interrupt_bitmap);
-		pending_vec = kvm_arch_ops->get_irq(vcpu);
+		pending_vec = kvm_x86_ops->get_irq(vcpu);
 		if (pending_vec >= 0) {
 			set_bit(pending_vec, sregs->interrupt_bitmap);
 			printk("pending irq in kernel %d\n",pending_vec);
@@ -2161,7 +2161,7 @@ static int kvm_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 static void set_segment(struct kvm_vcpu *vcpu,
 			struct kvm_segment *var, int seg)
 {
-	return kvm_arch_ops->set_segment(vcpu, var, seg);
+	return kvm_x86_ops->set_segment(vcpu, var, seg);
 }
 
 static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
@@ -2175,10 +2175,10 @@ static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 
 	dt.limit = sregs->idt.limit;
 	dt.base = sregs->idt.base;
-	kvm_arch_ops->set_idt(vcpu, &dt);
+	kvm_x86_ops->set_idt(vcpu, &dt);
 	dt.limit = sregs->gdt.limit;
 	dt.base = sregs->gdt.base;
-	kvm_arch_ops->set_gdt(vcpu, &dt);
+	kvm_x86_ops->set_gdt(vcpu, &dt);
 
 	vcpu->cr2 = sregs->cr2;
 	mmu_reset_needed |= vcpu->cr3 != sregs->cr3;
@@ -2188,18 +2188,18 @@ static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 
 	mmu_reset_needed |= vcpu->shadow_efer != sregs->efer;
 #ifdef CONFIG_X86_64
-	kvm_arch_ops->set_efer(vcpu, sregs->efer);
+	kvm_x86_ops->set_efer(vcpu, sregs->efer);
 #endif
 	kvm_set_apic_base(vcpu, sregs->apic_base);
 
-	kvm_arch_ops->decache_cr4_guest_bits(vcpu);
+	kvm_x86_ops->decache_cr4_guest_bits(vcpu);
 
 	mmu_reset_needed |= vcpu->cr0 != sregs->cr0;
 	vcpu->cr0 = sregs->cr0;
-	kvm_arch_ops->set_cr0(vcpu, sregs->cr0);
+	kvm_x86_ops->set_cr0(vcpu, sregs->cr0);
 
 	mmu_reset_needed |= vcpu->cr4 != sregs->cr4;
-	kvm_arch_ops->set_cr4(vcpu, sregs->cr4);
+	kvm_x86_ops->set_cr4(vcpu, sregs->cr4);
 	if (!is_long_mode(vcpu) && is_pae(vcpu))
 		load_pdptrs(vcpu, vcpu->cr3);
 
@@ -2220,7 +2220,7 @@ static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 			max_bits);
 		/* Only pending external irq is handled here */
 		if (pending_vec < max_bits) {
-			kvm_arch_ops->set_irq(vcpu, pending_vec);
+			kvm_x86_ops->set_irq(vcpu, pending_vec);
 			printk("Set back pending irq %d\n", pending_vec);
 		}
 	}
@@ -2413,7 +2413,7 @@ static int kvm_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
 
 	vcpu_load(vcpu);
 
-	r = kvm_arch_ops->set_guest_debug(vcpu, dbg);
+	r = kvm_x86_ops->set_guest_debug(vcpu, dbg);
 
 	vcpu_put(vcpu);
 
@@ -2495,7 +2495,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 	if (!valid_vcpu(n))
 		return -EINVAL;
 
-	vcpu = kvm_arch_ops->vcpu_create(kvm, n);
+	vcpu = kvm_x86_ops->vcpu_create(kvm, n);
 	if (IS_ERR(vcpu))
 		return PTR_ERR(vcpu);
 
@@ -2536,7 +2536,7 @@ mmu_unload:
 	vcpu_put(vcpu);
 
 free_vcpu:
-	kvm_arch_ops->vcpu_free(vcpu);
+	kvm_x86_ops->vcpu_free(vcpu);
 	return r;
 }
 
@@ -3165,7 +3165,7 @@ static void decache_vcpus_on_cpu(int cpu)
 			 */
 			if (mutex_trylock(&vcpu->mutex)) {
 				if (vcpu->cpu == cpu) {
-					kvm_arch_ops->vcpu_decache(vcpu);
+					kvm_x86_ops->vcpu_decache(vcpu);
 					vcpu->cpu = -1;
 				}
 				mutex_unlock(&vcpu->mutex);
@@ -3181,7 +3181,7 @@ static void hardware_enable(void *junk)
 	if (cpu_isset(cpu, cpus_hardware_enabled))
 		return;
 	cpu_set(cpu, cpus_hardware_enabled);
-	kvm_arch_ops->hardware_enable(NULL);
+	kvm_x86_ops->hardware_enable(NULL);
 }
 
 static void hardware_disable(void *junk)
@@ -3192,7 +3192,7 @@ static void hardware_disable(void *junk)
 		return;
 	cpu_clear(cpu, cpus_hardware_enabled);
 	decache_vcpus_on_cpu(cpu);
-	kvm_arch_ops->hardware_disable(NULL);
+	kvm_x86_ops->hardware_disable(NULL);
 }
 
 static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
@@ -3360,7 +3360,7 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
-	kvm_arch_ops->vcpu_load(vcpu, cpu);
+	kvm_x86_ops->vcpu_load(vcpu, cpu);
 }
 
 static void kvm_sched_out(struct preempt_notifier *pn,
@@ -3368,16 +3368,16 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
-	kvm_arch_ops->vcpu_put(vcpu);
+	kvm_x86_ops->vcpu_put(vcpu);
 }
 
-int kvm_init_arch(struct kvm_arch_ops *ops, unsigned int vcpu_size,
+int kvm_init_x86(struct kvm_x86_ops *ops, unsigned int vcpu_size,
 		  struct module *module)
 {
 	int r;
 	int cpu;
 
-	if (kvm_arch_ops) {
+	if (kvm_x86_ops) {
 		printk(KERN_ERR "kvm: already loaded the other module\n");
 		return -EEXIST;
 	}
@@ -3391,15 +3391,15 @@ int kvm_init_arch(struct kvm_arch_ops *ops, unsigned int vcpu_size,
 		return -EOPNOTSUPP;
 	}
 
-	kvm_arch_ops = ops;
+	kvm_x86_ops = ops;
 
-	r = kvm_arch_ops->hardware_setup();
+	r = kvm_x86_ops->hardware_setup();
 	if (r < 0)
 		goto out;
 
 	for_each_online_cpu(cpu) {
 		smp_call_function_single(cpu,
-				kvm_arch_ops->check_processor_compatibility,
+				kvm_x86_ops->check_processor_compatibility,
 				&r, 0, 1);
 		if (r < 0)
 			goto out_free_0;
@@ -3452,13 +3452,13 @@ out_free_2:
 out_free_1:
 	on_each_cpu(hardware_disable, NULL, 0, 1);
 out_free_0:
-	kvm_arch_ops->hardware_unsetup();
+	kvm_x86_ops->hardware_unsetup();
 out:
-	kvm_arch_ops = NULL;
+	kvm_x86_ops = NULL;
 	return r;
 }
 
-void kvm_exit_arch(void)
+void kvm_exit_x86(void)
 {
 	misc_deregister(&kvm_dev);
 	kmem_cache_destroy(kvm_vcpu_cache);
@@ -3467,8 +3467,8 @@ void kvm_exit_arch(void)
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 	on_each_cpu(hardware_disable, NULL, 0, 1);
-	kvm_arch_ops->hardware_unsetup();
-	kvm_arch_ops = NULL;
+	kvm_x86_ops->hardware_unsetup();
+	kvm_x86_ops = NULL;
 }
 
 static __init int kvm_init(void)
@@ -3511,5 +3511,5 @@ static __exit void kvm_exit(void)
 module_init(kvm_init)
 module_exit(kvm_exit)
 
-EXPORT_SYMBOL_GPL(kvm_init_arch);
-EXPORT_SYMBOL_GPL(kvm_exit_arch);
+EXPORT_SYMBOL_GPL(kvm_init_x86);
+EXPORT_SYMBOL_GPL(kvm_exit_x86);
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index e303b41..7b42c88 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -966,7 +966,7 @@ static int nonpaging_init_context(struct kvm_vcpu *vcpu)
 static void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
-	kvm_arch_ops->tlb_flush(vcpu);
+	kvm_x86_ops->tlb_flush(vcpu);
 }
 
 static void paging_new_cr3(struct kvm_vcpu *vcpu)
@@ -979,7 +979,7 @@ static void inject_page_fault(struct kvm_vcpu *vcpu,
 			      u64 addr,
 			      u32 err_code)
 {
-	kvm_arch_ops->inject_page_fault(vcpu, addr, err_code);
+	kvm_x86_ops->inject_page_fault(vcpu, addr, err_code);
 }
 
 static void paging_free(struct kvm_vcpu *vcpu)
@@ -1073,7 +1073,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	if (r)
 		goto out;
 	mmu_alloc_roots(vcpu);
-	kvm_arch_ops->set_cr3(vcpu, vcpu->mmu.root_hpa);
+	kvm_x86_ops->set_cr3(vcpu, vcpu->mmu.root_hpa);
 	kvm_mmu_flush_tlb(vcpu);
 out:
 	mutex_unlock(&vcpu->kvm->lock);
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 660243b..6b094b4 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -274,7 +274,7 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 			access_bits &= ~PT_WRITABLE_MASK;
 			if (is_writeble_pte(spte)) {
 				spte &= ~PT_WRITABLE_MASK;
-				kvm_arch_ops->tlb_flush(vcpu);
+				kvm_x86_ops->tlb_flush(vcpu);
 			}
 			if (write_fault)
 				*ptwrite = 1;
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 35f3f83..7b22d39 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1741,7 +1741,7 @@ static void svm_check_processor_compat(void *rtn)
 	*(int *)rtn = 0;
 }
 
-static struct kvm_arch_ops svm_arch_ops = {
+static struct kvm_x86_ops svm_x86_ops = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
 	.hardware_setup = svm_hardware_setup,
@@ -1794,13 +1794,13 @@ static struct kvm_arch_ops svm_arch_ops = {
 
 static int __init svm_init(void)
 {
-	return kvm_init_arch(&svm_arch_ops, sizeof(struct vcpu_svm),
+	return kvm_init_x86(&svm_x86_ops, sizeof(struct vcpu_svm),
 			      THIS_MODULE);
 }
 
 static void __exit svm_exit(void)
 {
-	kvm_exit_arch();
+	kvm_exit_x86();
 }
 
 module_init(svm_init)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 440cacf..57a6055 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -2548,7 +2548,7 @@ static void __init vmx_check_processor_compat(void *rtn)
 	}
 }
 
-static struct kvm_arch_ops vmx_arch_ops = {
+static struct kvm_x86_ops vmx_x86_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
 	.hardware_setup = hardware_setup,
@@ -2627,7 +2627,7 @@ static int __init vmx_init(void)
 	memset(iova, 0xff, PAGE_SIZE);
 	kunmap(vmx_io_bitmap_b);
 
-	r = kvm_init_arch(&vmx_arch_ops, sizeof(struct vcpu_vmx), THIS_MODULE);
+	r = kvm_init_x86(&vmx_x86_ops, sizeof(struct vcpu_vmx), THIS_MODULE);
 	if (r)
 		goto out1;
 
@@ -2645,7 +2645,7 @@ static void __exit vmx_exit(void)
 	__free_page(vmx_io_bitmap_b);
 	__free_page(vmx_io_bitmap_a);
 
-	kvm_exit_arch();
+	kvm_exit_x86();
 }
 
 module_init(vmx_init)
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 342594d..86171ca 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1432,7 +1432,7 @@ twobyte_special_insn:
 			| ((u64)_regs[VCPU_REGS_RDX] << 32);
 		rc = kvm_set_msr(ctxt->vcpu, _regs[VCPU_REGS_RCX], msr_data);
 		if (rc) {
-			kvm_arch_ops->inject_gp(ctxt->vcpu, 0);
+			kvm_x86_ops->inject_gp(ctxt->vcpu, 0);
 			_eip = ctxt->vcpu->rip;
 		}
 		rc = X86EMUL_CONTINUE;
@@ -1441,7 +1441,7 @@ twobyte_special_insn:
 		/* rdmsr */
 		rc = kvm_get_msr(ctxt->vcpu, _regs[VCPU_REGS_RCX], &msr_data);
 		if (rc) {
-			kvm_arch_ops->inject_gp(ctxt->vcpu, 0);
+			kvm_x86_ops->inject_gp(ctxt->vcpu, 0);
 			_eip = ctxt->vcpu->rip;
 		} else {
 			_regs[VCPU_REGS_RAX] = (u32)msr_data;
-- 
1.5.3

