Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbXIQI4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbXIQI4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXIQIdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:38 -0400
Received: from il.qumranet.com ([82.166.9.18]:45292 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639AbXIQIcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:36 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 091/104] KVM: Move main vcpu loop into subarch independent code
Date: Mon, 17 Sep 2007 10:32:13 +0200
Message-Id: <11900179492436-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies adding new code as well as reducing overall code size.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    9 +++-
 drivers/kvm/kvm_main.c |  124 +++++++++++++++++++++++++++++++++++++++++-
 drivers/kvm/svm.c      |  142 +++++++++++++-----------------------------------
 drivers/kvm/vmx.c      |  129 ++++++--------------------------------------
 4 files changed, 187 insertions(+), 217 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 42bb225..d93ab48 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -453,13 +453,16 @@ struct kvm_x86_ops {
 	/* Create, but do not attach this VCPU */
 	struct kvm_vcpu *(*vcpu_create)(struct kvm *kvm, unsigned id);
 	void (*vcpu_free)(struct kvm_vcpu *vcpu);
+	void (*vcpu_reset)(struct kvm_vcpu *vcpu);
 
+	void (*prepare_guest_switch)(struct kvm_vcpu *vcpu);
 	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
 	void (*vcpu_decache)(struct kvm_vcpu *vcpu);
 
 	int (*set_guest_debug)(struct kvm_vcpu *vcpu,
 			       struct kvm_debug_guest *dbg);
+	void (*guest_debug_pre)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata);
 	int (*set_msr)(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 	u64 (*get_segment_base)(struct kvm_vcpu *vcpu, int seg);
@@ -491,12 +494,16 @@ struct kvm_x86_ops {
 
 	void (*inject_gp)(struct kvm_vcpu *vcpu, unsigned err_code);
 
-	int (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
+	void (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
+	int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
 				unsigned char *hypercall_addr);
 	int (*get_irq)(struct kvm_vcpu *vcpu);
 	void (*set_irq)(struct kvm_vcpu *vcpu, int vec);
+	void (*inject_pending_irq)(struct kvm_vcpu *vcpu);
+	void (*inject_pending_vectors)(struct kvm_vcpu *vcpu,
+				       struct kvm_run *run);
 };
 
 extern struct kvm_x86_ops *kvm_x86_ops;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 4c3b7ed..e6301ce 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -38,6 +38,7 @@
 #include <linux/cpumask.h>
 #include <linux/smp.h>
 #include <linux/anon_inodes.h>
+#include <linux/profile.h>
 
 #include <asm/processor.h>
 #include <asm/msr.h>
@@ -1970,6 +1971,127 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_pio_string);
 
+/*
+ * Check if userspace requested an interrupt window, and that the
+ * interrupt window is open.
+ *
+ * No need to exit to userspace if we already have an interrupt queued.
+ */
+static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu,
+					  struct kvm_run *kvm_run)
+{
+	return (!vcpu->irq_summary &&
+		kvm_run->request_interrupt_window &&
+		vcpu->interrupt_window_open &&
+		(kvm_x86_ops->get_rflags(vcpu) & X86_EFLAGS_IF));
+}
+
+static void post_kvm_run_save(struct kvm_vcpu *vcpu,
+			      struct kvm_run *kvm_run)
+{
+	kvm_run->if_flag = (kvm_x86_ops->get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
+	kvm_run->cr8 = get_cr8(vcpu);
+	kvm_run->apic_base = kvm_get_apic_base(vcpu);
+	if (irqchip_in_kernel(vcpu->kvm))
+		kvm_run->ready_for_interrupt_injection = 1;
+	else
+		kvm_run->ready_for_interrupt_injection =
+					(vcpu->interrupt_window_open &&
+					 vcpu->irq_summary == 0);
+}
+
+static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	int r;
+
+	if (unlikely(vcpu->mp_state == VCPU_MP_STATE_SIPI_RECEIVED)) {
+		printk("vcpu %d received sipi with vector # %x\n",
+		       vcpu->vcpu_id, vcpu->sipi_vector);
+		kvm_lapic_reset(vcpu);
+		kvm_x86_ops->vcpu_reset(vcpu);
+		vcpu->mp_state = VCPU_MP_STATE_RUNNABLE;
+	}
+
+preempted:
+	if (vcpu->guest_debug.enabled)
+		kvm_x86_ops->guest_debug_pre(vcpu);
+
+again:
+	r = kvm_mmu_reload(vcpu);
+	if (unlikely(r))
+		goto out;
+
+	preempt_disable();
+
+	kvm_x86_ops->prepare_guest_switch(vcpu);
+	kvm_load_guest_fpu(vcpu);
+
+	local_irq_disable();
+
+	if (signal_pending(current)) {
+		local_irq_enable();
+		preempt_enable();
+		r = -EINTR;
+		kvm_run->exit_reason = KVM_EXIT_INTR;
+		++vcpu->stat.signal_exits;
+		goto out;
+	}
+
+	if (irqchip_in_kernel(vcpu->kvm))
+		kvm_x86_ops->inject_pending_irq(vcpu);
+	else if (!vcpu->mmio_read_completed)
+		kvm_x86_ops->inject_pending_vectors(vcpu, kvm_run);
+
+	vcpu->guest_mode = 1;
+
+	if (vcpu->requests)
+		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
+			kvm_x86_ops->tlb_flush(vcpu);
+
+	kvm_x86_ops->run(vcpu, kvm_run);
+
+	vcpu->guest_mode = 0;
+	local_irq_enable();
+
+	++vcpu->stat.exits;
+
+	preempt_enable();
+
+	/*
+	 * Profile KVM exit RIPs:
+	 */
+	if (unlikely(prof_on == KVM_PROFILING)) {
+		kvm_x86_ops->cache_regs(vcpu);
+		profile_hit(KVM_PROFILING, (void *)vcpu->rip);
+	}
+
+	r = kvm_x86_ops->handle_exit(kvm_run, vcpu);
+
+	if (r > 0) {
+		if (dm_request_for_irq_injection(vcpu, kvm_run)) {
+			r = -EINTR;
+			kvm_run->exit_reason = KVM_EXIT_INTR;
+			++vcpu->stat.request_irq_exits;
+			goto out;
+		}
+		if (!need_resched()) {
+			++vcpu->stat.light_exits;
+			goto again;
+		}
+	}
+
+out:
+	if (r > 0) {
+		kvm_resched(vcpu);
+		goto preempted;
+	}
+
+	post_kvm_run_save(vcpu, kvm_run);
+
+	return r;
+}
+
+
 static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	int r;
@@ -2017,7 +2139,7 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		kvm_x86_ops->decache_regs(vcpu);
 	}
 
-	r = kvm_x86_ops->run(vcpu, kvm_run);
+	r = __vcpu_run(vcpu, kvm_run);
 
 out:
 	if (vcpu->sigset_active)
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 7b22d39..95681ea 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -22,7 +22,6 @@
 #include <linux/kernel.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
-#include <linux/profile.h>
 #include <linux/sched.h>
 
 #include <asm/desc.h>
@@ -50,6 +49,8 @@ MODULE_LICENSE("GPL");
 #define SVM_FEATURE_LBRV (1 << 1)
 #define SVM_DEATURE_SVML (1 << 2)
 
+static void kvm_reput_irq(struct vcpu_svm *svm);
+
 static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 {
 	return container_of(vcpu, struct vcpu_svm, vcpu);
@@ -555,6 +556,13 @@ static void init_vmcb(struct vmcb *vmcb)
 	/* rdx = ?? */
 }
 
+static void svm_vcpu_reset(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	init_vmcb(svm->vmcb);
+}
+
 static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 {
 	struct vcpu_svm *svm;
@@ -1252,10 +1260,20 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 };
 
 
-static int handle_exit(struct vcpu_svm *svm, struct kvm_run *kvm_run)
+static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 exit_code = svm->vmcb->control.exit_code;
 
+	kvm_reput_irq(svm);
+
+	if (svm->vmcb->control.exit_code == SVM_EXIT_ERR) {
+		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+		kvm_run->fail_entry.hardware_entry_failure_reason
+			= svm->vmcb->control.exit_code;
+		return 0;
+	}
+
 	if (is_external_interrupt(svm->vmcb->control.exit_int_info) &&
 	    exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR)
 		printk(KERN_ERR "%s: unexpected exit_ini_info 0x%x "
@@ -1313,11 +1331,11 @@ static void svm_set_irq(struct kvm_vcpu *vcpu, int irq)
 	svm_inject_irq(svm, irq);
 }
 
-static void svm_intr_assist(struct vcpu_svm *svm)
+static void svm_intr_assist(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
 	int intr_vector = -1;
-	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	kvm_inject_pending_timer_irqs(vcpu);
 	if ((vmcb->control.exit_int_info & SVM_EVTINJ_VALID) &&
@@ -1376,9 +1394,10 @@ static void svm_do_inject_vector(struct vcpu_svm *svm)
 	svm_inject_irq(svm, irq);
 }
 
-static void do_interrupt_requests(struct vcpu_svm *svm,
+static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 				       struct kvm_run *kvm_run)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_control_area *control = &svm->vmcb->control;
 
 	svm->vcpu.interrupt_window_open =
@@ -1401,35 +1420,6 @@ static void do_interrupt_requests(struct vcpu_svm *svm,
 		control->intercept &= ~(1ULL << INTERCEPT_VINTR);
 }
 
-static void post_kvm_run_save(struct vcpu_svm *svm,
-			      struct kvm_run *kvm_run)
-{
-	if (irqchip_in_kernel(svm->vcpu.kvm))
-		kvm_run->ready_for_interrupt_injection = 1;
-	else
-		kvm_run->ready_for_interrupt_injection =
-					 (svm->vcpu.interrupt_window_open &&
-					  svm->vcpu.irq_summary == 0);
-	kvm_run->if_flag = (svm->vmcb->save.rflags & X86_EFLAGS_IF) != 0;
-	kvm_run->cr8 = get_cr8(&svm->vcpu);
-	kvm_run->apic_base = kvm_get_apic_base(&svm->vcpu);
-}
-
-/*
- * Check if userspace requested an interrupt window, and that the
- * interrupt window is open.
- *
- * No need to exit to userspace if we already have an interrupt queued.
- */
-static int dm_request_for_irq_injection(struct vcpu_svm *svm,
-					  struct kvm_run *kvm_run)
-{
-	return (!svm->vcpu.irq_summary &&
-		kvm_run->request_interrupt_window &&
-		svm->vcpu.interrupt_window_open &&
-		(svm->vmcb->save.rflags & X86_EFLAGS_IF));
-}
-
 static void save_db_regs(unsigned long *db_regs)
 {
 	asm volatile ("mov %%dr0, %0" : "=r"(db_regs[0]));
@@ -1451,38 +1441,16 @@ static void svm_flush_tlb(struct kvm_vcpu *vcpu)
 	force_new_asid(vcpu);
 }
 
-static int svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
+{
+}
+
+static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u16 fs_selector;
 	u16 gs_selector;
 	u16 ldt_selector;
-	int r;
-
-again:
-	r = kvm_mmu_reload(vcpu);
-	if (unlikely(r))
-		return r;
-
-	clgi();
-
-	if (signal_pending(current)) {
-		stgi();
-		++vcpu->stat.signal_exits;
-		post_kvm_run_save(svm, kvm_run);
-		kvm_run->exit_reason = KVM_EXIT_INTR;
-		return -EINTR;
-	}
-
-	if (irqchip_in_kernel(vcpu->kvm))
-		svm_intr_assist(svm);
-	else if (!vcpu->mmio_read_completed)
-		do_interrupt_requests(svm, kvm_run);
-
-	vcpu->guest_mode = 1;
-	if (vcpu->requests)
-		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
-		    svm_flush_tlb(vcpu);
 
 	pre_svm_run(svm);
 
@@ -1501,10 +1469,9 @@ again:
 		load_db_regs(svm->db_regs);
 	}
 
-	if (vcpu->fpu_active) {
-		fx_save(&vcpu->host_fx_image);
-		fx_restore(&vcpu->guest_fx_image);
-	}
+	clgi();
+
+	local_irq_enable();
 
 	asm volatile (
 #ifdef CONFIG_X86_64
@@ -1612,12 +1579,9 @@ again:
 #endif
 		: "cc", "memory" );
 
-	vcpu->guest_mode = 0;
+	local_irq_disable();
 
-	if (vcpu->fpu_active) {
-		fx_save(&vcpu->guest_fx_image);
-		fx_restore(&vcpu->host_fx_image);
-	}
+	stgi();
 
 	if ((svm->vmcb->save.dr7 & 0xff))
 		load_db_regs(svm->host_db_regs);
@@ -1635,40 +1599,7 @@ again:
 
 	reload_tss(vcpu);
 
-	/*
-	 * Profile KVM exit RIPs:
-	 */
-	if (unlikely(prof_on == KVM_PROFILING))
-		profile_hit(KVM_PROFILING,
-			(void *)(unsigned long)svm->vmcb->save.rip);
-
-	stgi();
-
-	kvm_reput_irq(svm);
-
 	svm->next_rip = 0;
-
-	if (svm->vmcb->control.exit_code == SVM_EXIT_ERR) {
-		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
-		kvm_run->fail_entry.hardware_entry_failure_reason
-			= svm->vmcb->control.exit_code;
-		post_kvm_run_save(svm, kvm_run);
-		return 0;
-	}
-
-	r = handle_exit(svm, kvm_run);
-	if (r > 0) {
-		if (dm_request_for_irq_injection(svm, kvm_run)) {
-			++vcpu->stat.request_irq_exits;
-			post_kvm_run_save(svm, kvm_run);
-			kvm_run->exit_reason = KVM_EXIT_INTR;
-			return -EINTR;
-		}
-		kvm_resched(vcpu);
-		goto again;
-	}
-	post_kvm_run_save(svm, kvm_run);
-	return r;
 }
 
 static void svm_set_cr3(struct kvm_vcpu *vcpu, unsigned long root)
@@ -1752,7 +1683,9 @@ static struct kvm_x86_ops svm_x86_ops = {
 
 	.vcpu_create = svm_create_vcpu,
 	.vcpu_free = svm_free_vcpu,
+	.vcpu_reset = svm_vcpu_reset,
 
+	.prepare_guest_switch = svm_prepare_guest_switch,
 	.vcpu_load = svm_vcpu_load,
 	.vcpu_put = svm_vcpu_put,
 	.vcpu_decache = svm_vcpu_decache,
@@ -1786,10 +1719,13 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.inject_gp = svm_inject_gp,
 
 	.run = svm_vcpu_run,
+	.handle_exit = handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.patch_hypercall = svm_patch_hypercall,
 	.get_irq = svm_get_irq,
 	.set_irq = svm_set_irq,
+	.inject_pending_irq = svm_intr_assist,
+	.inject_pending_vectors = do_interrupt_requests,
 };
 
 static int __init svm_init(void)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 713f78a..fa4277d 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -25,7 +25,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
-#include <linux/profile.h>
 #include <linux/sched.h>
 
 #include <asm/io.h>
@@ -355,8 +354,10 @@ static void load_transition_efer(struct vcpu_vmx *vmx)
 	vmx->vcpu.stat.efer_reload++;
 }
 
-static void vmx_save_host_state(struct vcpu_vmx *vmx)
+static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
 	if (vmx->host_state.loaded)
 		return;
 
@@ -1598,6 +1599,13 @@ out:
 	return ret;
 }
 
+static void vmx_vcpu_reset(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	vmx_vcpu_setup(vmx);
+}
+
 static void inject_rmode_irq(struct kvm_vcpu *vcpu, int irq)
 {
 	u16 ent[2];
@@ -2019,20 +2027,6 @@ static int handle_tpr_below_threshold(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
-static void post_kvm_run_save(struct kvm_vcpu *vcpu,
-			      struct kvm_run *kvm_run)
-{
-	kvm_run->if_flag = (vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) != 0;
-	kvm_run->cr8 = get_cr8(vcpu);
-	kvm_run->apic_base = kvm_get_apic_base(vcpu);
-	if (irqchip_in_kernel(vcpu->kvm))
-		kvm_run->ready_for_interrupt_injection = 1;
-	else
-		kvm_run->ready_for_interrupt_injection =
-					(vcpu->interrupt_window_open &&
-					 vcpu->irq_summary == 0);
-}
-
 static int handle_interrupt_window(struct kvm_vcpu *vcpu,
 				   struct kvm_run *kvm_run)
 {
@@ -2123,21 +2117,6 @@ static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-/*
- * Check if userspace requested an interrupt window, and that the
- * interrupt window is open.
- *
- * No need to exit to userspace if we already have an interrupt queued.
- */
-static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu,
-					  struct kvm_run *kvm_run)
-{
-	return (!vcpu->irq_summary &&
-		kvm_run->request_interrupt_window &&
-		vcpu->interrupt_window_open &&
-		(vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF));
-}
-
 static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
 {
 }
@@ -2214,59 +2193,15 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 		enable_irq_window(vcpu);
 }
 
-static int vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	int r;
-
-	if (unlikely(vcpu->mp_state == VCPU_MP_STATE_SIPI_RECEIVED)) {
-		printk("vcpu %d received sipi with vector # %x\n",
-		       vcpu->vcpu_id, vcpu->sipi_vector);
-		kvm_lapic_reset(vcpu);
-		vmx_vcpu_setup(vmx);
-		vcpu->mp_state = VCPU_MP_STATE_RUNNABLE;
-	}
-
-preempted:
-	if (vcpu->guest_debug.enabled)
-		kvm_guest_debug_pre(vcpu);
-
-again:
-	r = kvm_mmu_reload(vcpu);
-	if (unlikely(r))
-		goto out;
-
-	preempt_disable();
-
-	vmx_save_host_state(vmx);
-	kvm_load_guest_fpu(vcpu);
 
 	/*
 	 * Loading guest fpu may have cleared host cr0.ts
 	 */
 	vmcs_writel(HOST_CR0, read_cr0());
 
-	local_irq_disable();
-
-	if (signal_pending(current)) {
-		local_irq_enable();
-		preempt_enable();
-		r = -EINTR;
-		kvm_run->exit_reason = KVM_EXIT_INTR;
-		++vcpu->stat.signal_exits;
-		goto out;
-	}
-
-	if (irqchip_in_kernel(vcpu->kvm))
-		vmx_intr_assist(vcpu);
-	else if (!vcpu->mmio_read_completed)
-		do_interrupt_requests(vcpu, kvm_run);
-
-	vcpu->guest_mode = 1;
-	if (vcpu->requests)
-		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
-		    vmx_flush_tlb(vcpu);
-
 	asm (
 		/* Store host registers */
 #ifdef CONFIG_X86_64
@@ -2383,46 +2318,10 @@ again:
 		[cr2]"i"(offsetof(struct kvm_vcpu, cr2))
 	      : "cc", "memory" );
 
-	vcpu->guest_mode = 0;
-	local_irq_enable();
-
-	++vcpu->stat.exits;
-
 	vcpu->interrupt_window_open = (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0;
 
 	asm ("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
 	vmx->launched = 1;
-
-	preempt_enable();
-
-	/*
-	 * Profile KVM exit RIPs:
-	 */
-	if (unlikely(prof_on == KVM_PROFILING))
-		profile_hit(KVM_PROFILING, (void *)vmcs_readl(GUEST_RIP));
-
-	r = kvm_handle_exit(kvm_run, vcpu);
-	if (r > 0) {
-		if (dm_request_for_irq_injection(vcpu, kvm_run)) {
-			r = -EINTR;
-			kvm_run->exit_reason = KVM_EXIT_INTR;
-			++vcpu->stat.request_irq_exits;
-			goto out;
-		}
-		if (!need_resched()) {
-			++vcpu->stat.light_exits;
-			goto again;
-		}
-	}
-
-out:
-	if (r > 0) {
-		kvm_resched(vcpu);
-		goto preempted;
-	}
-
-	post_kvm_run_save(vcpu, kvm_run);
-	return r;
 }
 
 static void vmx_inject_page_fault(struct kvm_vcpu *vcpu,
@@ -2560,12 +2459,15 @@ static struct kvm_x86_ops vmx_x86_ops = {
 
 	.vcpu_create = vmx_create_vcpu,
 	.vcpu_free = vmx_free_vcpu,
+	.vcpu_reset = vmx_vcpu_reset,
 
+	.prepare_guest_switch = vmx_save_host_state,
 	.vcpu_load = vmx_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
 	.vcpu_decache = vmx_vcpu_decache,
 
 	.set_guest_debug = set_guest_debug,
+	.guest_debug_pre = kvm_guest_debug_pre,
 	.get_msr = vmx_get_msr,
 	.set_msr = vmx_set_msr,
 	.get_segment_base = vmx_get_segment_base,
@@ -2594,10 +2496,13 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.inject_gp = vmx_inject_gp,
 
 	.run = vmx_vcpu_run,
+	.handle_exit = kvm_handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.patch_hypercall = vmx_patch_hypercall,
 	.get_irq = vmx_get_irq,
 	.set_irq = vmx_inject_irq,
+	.inject_pending_irq = vmx_intr_assist,
+	.inject_pending_vectors = do_interrupt_requests,
 };
 
 static int __init vmx_init(void)
-- 
1.5.3

