Return-Path: <linux-kernel-owner+w=401wt.eu-S1759779AbXIQJCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779AbXIQJCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXIQId4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:56 -0400
Received: from il.qumranet.com ([82.166.9.18]:45310 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbXIQIc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:29 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 028/104] KVM: Use the scheduler preemption notifiers to make kvm preemptible
Date: Mon, 17 Sep 2007 10:31:10 +0200
Message-Id: <11900179472371-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Current kvm disables preemption while the new virtualization registers are
in use.  This of course is not very good for latency sensitive workloads (one
use of virtualization is to offload user interface and other latency
insensitive stuff to a container, so that it is easier to analyze the
remaining workload).  This patch re-enables preemption for kvm; preemption
is now only disabled when switching the registers in and out, and during
the switch to guest mode and back.

Contains fixes from Shaohua Li <shaohua.li@intel.com>.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/Kconfig    |    1 +
 drivers/kvm/kvm.h      |    4 +++-
 drivers/kvm/kvm_main.c |   43 +++++++++++++++++++++++++++++++++++++------
 drivers/kvm/mmu.c      |    2 --
 drivers/kvm/svm.c      |    6 ++----
 drivers/kvm/vmx.c      |   22 +++++++++++++---------
 6 files changed, 56 insertions(+), 22 deletions(-)

diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
index 7b64fd4..9b72f33 100644
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -16,6 +16,7 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on X86 && EXPERIMENTAL
+	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index e92c84b..0667183 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -13,6 +13,7 @@
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/preempt.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -301,6 +302,7 @@ void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
 
 struct kvm_vcpu {
 	struct kvm *kvm;
+	struct preempt_notifier preempt_notifier;
 	int vcpu_id;
 	struct mutex mutex;
 	int   cpu;
@@ -429,7 +431,7 @@ struct kvm_arch_ops {
 	struct kvm_vcpu *(*vcpu_create)(struct kvm *kvm, unsigned id);
 	void (*vcpu_free)(struct kvm_vcpu *vcpu);
 
-	void (*vcpu_load)(struct kvm_vcpu *vcpu);
+	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
 	void (*vcpu_decache)(struct kvm_vcpu *vcpu);
 
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 2094746..6035e6d 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -54,6 +54,8 @@ static cpumask_t cpus_hardware_enabled;
 
 struct kvm_arch_ops *kvm_arch_ops;
 
+static __read_mostly struct preempt_ops kvm_preempt_ops;
+
 #define STAT_OFFSET(x) offsetof(struct kvm_vcpu, stat.x)
 
 static struct kvm_stats_debugfs_item {
@@ -239,13 +241,21 @@ EXPORT_SYMBOL_GPL(kvm_put_guest_fpu);
  */
 static void vcpu_load(struct kvm_vcpu *vcpu)
 {
+	int cpu;
+
 	mutex_lock(&vcpu->mutex);
-	kvm_arch_ops->vcpu_load(vcpu);
+	cpu = get_cpu();
+	preempt_notifier_register(&vcpu->preempt_notifier);
+	kvm_arch_ops->vcpu_load(vcpu, cpu);
+	put_cpu();
 }
 
 static void vcpu_put(struct kvm_vcpu *vcpu)
 {
+	preempt_disable();
 	kvm_arch_ops->vcpu_put(vcpu);
+	preempt_notifier_unregister(&vcpu->preempt_notifier);
+	preempt_enable();
 	mutex_unlock(&vcpu->mutex);
 }
 
@@ -1672,9 +1682,7 @@ void kvm_resched(struct kvm_vcpu *vcpu)
 {
 	if (!need_resched())
 		return;
-	vcpu_put(vcpu);
 	cond_resched();
-	vcpu_load(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_resched);
 
@@ -1722,11 +1730,9 @@ static int pio_copy_data(struct kvm_vcpu *vcpu)
 	unsigned bytes;
 	int nr_pages = vcpu->pio.guest_pages[1] ? 2 : 1;
 
-	kvm_arch_ops->vcpu_put(vcpu);
 	q = vmap(vcpu->pio.guest_pages, nr_pages, VM_READ|VM_WRITE,
 		 PAGE_KERNEL);
 	if (!q) {
-		kvm_arch_ops->vcpu_load(vcpu);
 		free_pio_guest_pages(vcpu);
 		return -ENOMEM;
 	}
@@ -1738,7 +1744,6 @@ static int pio_copy_data(struct kvm_vcpu *vcpu)
 		memcpy(p, q, bytes);
 	q -= vcpu->pio.guest_page_offset;
 	vunmap(q);
-	kvm_arch_ops->vcpu_load(vcpu);
 	free_pio_guest_pages(vcpu);
 	return 0;
 }
@@ -2413,6 +2418,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 	if (IS_ERR(vcpu))
 		return PTR_ERR(vcpu);
 
+	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
+
 	vcpu_load(vcpu);
 	r = kvm_mmu_setup(vcpu);
 	vcpu_put(vcpu);
@@ -3145,6 +3152,27 @@ static struct sys_device kvm_sysdev = {
 
 hpa_t bad_page_address;
 
+static inline
+struct kvm_vcpu *preempt_notifier_to_vcpu(struct preempt_notifier *pn)
+{
+	return container_of(pn, struct kvm_vcpu, preempt_notifier);
+}
+
+static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
+{
+	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
+
+	kvm_arch_ops->vcpu_load(vcpu, cpu);
+}
+
+static void kvm_sched_out(struct preempt_notifier *pn,
+			  struct task_struct *next)
+{
+	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
+
+	kvm_arch_ops->vcpu_put(vcpu);
+}
+
 int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
 {
 	int r;
@@ -3191,6 +3219,9 @@ int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
 		goto out_free;
 	}
 
+	kvm_preempt_ops.sched_in = kvm_sched_in;
+	kvm_preempt_ops.sched_out = kvm_sched_out;
+
 	return r;
 
 out_free:
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 5437de2..396c736 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -276,9 +276,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_some_pages(vcpu);
 	if (r < 0) {
 		spin_unlock(&vcpu->kvm->lock);
-		kvm_arch_ops->vcpu_put(vcpu);
 		r = __mmu_topup_memory_caches(vcpu, GFP_KERNEL);
-		kvm_arch_ops->vcpu_load(vcpu);
 		spin_lock(&vcpu->kvm->lock);
 		kvm_mmu_free_some_pages(vcpu);
 	}
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 0feec85..3997bbd 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -625,12 +625,11 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	kfree(svm);
 }
 
-static void svm_vcpu_load(struct kvm_vcpu *vcpu)
+static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	int cpu, i;
+	int i;
 
-	cpu = get_cpu();
 	if (unlikely(cpu != vcpu->cpu)) {
 		u64 tsc_this, delta;
 
@@ -657,7 +656,6 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 
 	rdtscll(vcpu->host_tsc);
-	put_cpu();
 }
 
 static void svm_vcpu_decache(struct kvm_vcpu *vcpu)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 18f9b0b..8c87d20 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -396,6 +396,7 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 static void vmx_load_host_state(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long flags;
 
 	if (!vmx->host_state.loaded)
 		return;
@@ -408,12 +409,12 @@ static void vmx_load_host_state(struct kvm_vcpu *vcpu)
 		 * If we have to reload gs, we must take care to
 		 * preserve our gs base.
 		 */
-		local_irq_disable();
+		local_irq_save(flags);
 		load_gs(vmx->host_state.gs_sel);
 #ifdef CONFIG_X86_64
 		wrmsrl(MSR_GS_BASE, vmcs_readl(HOST_GS_BASE));
 #endif
-		local_irq_enable();
+		local_irq_restore(flags);
 
 		reload_tss();
 	}
@@ -427,15 +428,12 @@ static void vmx_load_host_state(struct kvm_vcpu *vcpu)
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
  */
-static void vmx_vcpu_load(struct kvm_vcpu *vcpu)
+static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u64 phys_addr = __pa(vmx->vmcs);
-	int cpu;
 	u64 tsc_this, delta;
 
-	cpu = get_cpu();
-
 	if (vcpu->cpu != cpu)
 		vcpu_clear(vcpu);
 
@@ -480,7 +478,6 @@ static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	vmx_load_host_state(vcpu);
 	kvm_put_guest_fpu(vcpu);
-	put_cpu();
 }
 
 static void vmx_fpu_activate(struct kvm_vcpu *vcpu)
@@ -2127,6 +2124,8 @@ again:
 	if (unlikely(r))
 		goto out;
 
+	preempt_disable();
+
 	if (!vcpu->mmio_read_completed)
 		do_interrupt_requests(vcpu, kvm_run);
 
@@ -2269,6 +2268,9 @@ again:
 	vcpu->interrupt_window_open = (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0;
 
 	asm ("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
+	vmx->launched = 1;
+
+	preempt_enable();
 
 	if (unlikely(fail)) {
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
@@ -2283,7 +2285,6 @@ again:
 	if (unlikely(prof_on == KVM_PROFILING))
 		profile_hit(KVM_PROFILING, (void *)vmcs_readl(GUEST_RIP));
 
-	vmx->launched = 1;
 	r = kvm_handle_exit(kvm_run, vcpu);
 	if (r > 0) {
 		/* Give scheduler a change to reschedule. */
@@ -2372,6 +2373,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 {
 	int err;
 	struct vcpu_vmx *vmx = kzalloc(sizeof(*vmx), GFP_KERNEL);
+	int cpu;
 
 	if (!vmx)
 		return ERR_PTR(-ENOMEM);
@@ -2396,9 +2398,11 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 
 	vmcs_clear(vmx->vmcs);
 
-	vmx_vcpu_load(&vmx->vcpu);
+	cpu = get_cpu();
+	vmx_vcpu_load(&vmx->vcpu, cpu);
 	err = vmx_vcpu_setup(&vmx->vcpu);
 	vmx_vcpu_put(&vmx->vcpu);
+	put_cpu();
 	if (err)
 		goto free_vmcs;
 
-- 
1.5.3

