Return-Path: <linux-kernel-owner+w=401wt.eu-S1762457AbXGYMno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762457AbXGYMno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759752AbXGYMnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:43:00 -0400
Received: from il.qumranet.com ([82.166.9.18]:39206 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756567AbXGYMm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:42:58 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       shaohua.li@intel.com, rusty@rustcorp.com.au, Andi Kleen <ak@suse.de>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 2/3] KVM: Use the scheduler preemption hooks to make kvm preemptible
Date: Wed, 25 Jul 2007 15:43:06 +0300
Message-Id: <1185367387391-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <11853673872732-git-send-email-avi@qumranet.com>
References: <11853673872732-git-send-email-avi@qumranet.com>
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
 drivers/kvm/kvm_main.c |   46 +++++++++++++++++++++++++++++++++++++++-------
 drivers/kvm/mmu.c      |    2 --
 drivers/kvm/svm.c      |    6 ++----
 drivers/kvm/vmx.c      |   17 +++++++++--------
 6 files changed, 54 insertions(+), 22 deletions(-)

diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
index 6cecc39..65e009b 100644
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -11,6 +11,7 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on X86 && EXPERIMENTAL
+	select PREEMPT_HOOKS
 	select ANON_INODES
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index fc27c2f..50ddd3c 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -13,6 +13,7 @@
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/preempt.h>
 #include <asm/signal.h>
 
 #include "vmx.h"
@@ -310,6 +311,7 @@ void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
 
 struct kvm_vcpu {
 	struct kvm *kvm;
+	struct preempt_hook preempt_hook;
 	int vcpu_id;
 	union {
 		struct vmcs *vmcs;
@@ -456,7 +458,7 @@ struct kvm_arch_ops {
 	int (*vcpu_create)(struct kvm_vcpu *vcpu);
 	void (*vcpu_free)(struct kvm_vcpu *vcpu);
 
-	void (*vcpu_load)(struct kvm_vcpu *vcpu);
+	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
 	void (*vcpu_decache)(struct kvm_vcpu *vcpu);
 
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index f6c6b0b..4f45247 100644
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
+	preempt_hook_register(&vcpu->preempt_hook);
+	kvm_arch_ops->vcpu_load(vcpu, cpu);
+	put_cpu();
 }
 
 static void vcpu_put(struct kvm_vcpu *vcpu)
 {
+	preempt_disable();
 	kvm_arch_ops->vcpu_put(vcpu);
+	preempt_hook_unregister(&vcpu->preempt_hook);
+	preempt_enable();
 	mutex_unlock(&vcpu->mutex);
 }
 
@@ -1638,9 +1648,7 @@ void kvm_resched(struct kvm_vcpu *vcpu)
 {
 	if (!need_resched())
 		return;
-	vcpu_put(vcpu);
 	cond_resched();
-	vcpu_load(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_resched);
 
@@ -1706,11 +1714,9 @@ static int pio_copy_data(struct kvm_vcpu *vcpu)
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
@@ -1722,7 +1728,6 @@ static int pio_copy_data(struct kvm_vcpu *vcpu)
 		memcpy(p, q, bytes);
 	q -= vcpu->pio.guest_page_offset;
 	vunmap(q);
-	kvm_arch_ops->vcpu_load(vcpu);
 	free_pio_guest_pages(vcpu);
 	return 0;
 }
@@ -2390,6 +2395,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 	int r;
 	struct kvm_vcpu *vcpu;
 	struct page *page;
+	int cpu;
 
 	r = -EINVAL;
 	if (!valid_vcpu(n))
@@ -2430,7 +2436,11 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 	if (r < 0)
 		goto out_free_vcpus;
 
-	kvm_arch_ops->vcpu_load(vcpu);
+	vcpu->preempt_hook.ops = &kvm_preempt_ops;
+	cpu = get_cpu();
+	preempt_hook_register(&vcpu->preempt_hook);
+	kvm_arch_ops->vcpu_load(vcpu, cpu);
+	put_cpu();
 	r = kvm_mmu_setup(vcpu);
 	if (r >= 0)
 		r = kvm_arch_ops->vcpu_setup(vcpu);
@@ -3147,6 +3157,25 @@ static struct sys_device kvm_sysdev = {
 
 hpa_t bad_page_address;
 
+static inline struct kvm_vcpu *preempt_hook_to_vcpu(struct preempt_hook *hook)
+{
+	return container_of(hook, struct kvm_vcpu, preempt_hook);
+}
+
+static void kvm_sched_in(struct preempt_hook *hook, int cpu)
+{
+	struct kvm_vcpu *vcpu = preempt_hook_to_vcpu(hook);
+
+	kvm_arch_ops->vcpu_load(vcpu, cpu);
+}
+
+static void kvm_sched_out(struct preempt_hook *hook)
+{
+	struct kvm_vcpu *vcpu = preempt_hook_to_vcpu(hook);
+
+	kvm_arch_ops->vcpu_put(vcpu);
+}
+
 int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
 {
 	int r;
@@ -3193,6 +3222,9 @@ int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
 		goto out_free;
 	}
 
+	kvm_preempt_ops.sched_in = kvm_sched_in;
+	kvm_preempt_ops.sched_out = kvm_sched_out;
+
 	return r;
 
 out_free:
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 3c33957..fdb967a 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -275,9 +275,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 	r = __mmu_topup_memory_caches(vcpu, GFP_NOWAIT);
 	if (r < 0) {
 		spin_unlock(&vcpu->kvm->lock);
-		kvm_arch_ops->vcpu_put(vcpu);
 		r = __mmu_topup_memory_caches(vcpu, GFP_KERNEL);
-		kvm_arch_ops->vcpu_load(vcpu);
 		spin_lock(&vcpu->kvm->lock);
 	}
 	return r;
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 850a1b1..e3a4722 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -610,11 +610,10 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	kfree(vcpu->svm);
 }
 
-static void svm_vcpu_load(struct kvm_vcpu *vcpu)
+static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	int cpu, i;
+	int i;
 
-	cpu = get_cpu();
 	if (unlikely(cpu != vcpu->cpu)) {
 		u64 tsc_this, delta;
 
@@ -640,7 +639,6 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 		wrmsrl(host_save_user_msrs[i], vcpu->svm->host_user_msrs[i]);
 
 	rdtscll(vcpu->host_tsc);
-	put_cpu();
 }
 
 static void svm_vcpu_decache(struct kvm_vcpu *vcpu)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index dac2f93..90f28f0 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -345,6 +345,7 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 static void vmx_load_host_state(struct kvm_vcpu *vcpu)
 {
 	struct vmx_host_state *hs = &vcpu->vmx_host_state;
+	unsigned long flags;
 
 	if (!hs->loaded)
 		return;
@@ -357,12 +358,12 @@ static void vmx_load_host_state(struct kvm_vcpu *vcpu)
 		 * If we have to reload gs, we must take care to
 		 * preserve our gs base.
 		 */
-		local_irq_disable();
+		local_irq_save(flags);
 		load_gs(hs->gs_sel);
 #ifdef CONFIG_X86_64
 		wrmsrl(MSR_GS_BASE, vmcs_readl(HOST_GS_BASE));
 #endif
-		local_irq_enable();
+		local_irq_restore(flags);
 
 		reload_tss();
 	}
@@ -376,14 +377,11 @@ static void vmx_load_host_state(struct kvm_vcpu *vcpu)
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
  */
-static void vmx_vcpu_load(struct kvm_vcpu *vcpu)
+static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	u64 phys_addr = __pa(vcpu->vmcs);
-	int cpu;
 	u64 tsc_this, delta;
 
-	cpu = get_cpu();
-
 	if (vcpu->cpu != cpu)
 		vcpu_clear(vcpu);
 
@@ -428,7 +426,6 @@ static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	vmx_load_host_state(vcpu);
 	kvm_put_guest_fpu(vcpu);
-	put_cpu();
 }
 
 static void vmx_fpu_activate(struct kvm_vcpu *vcpu)
@@ -2011,6 +2008,8 @@ again:
 	if (unlikely(r))
 		goto out;
 
+	preempt_disable();
+
 	if (!vcpu->mmio_read_completed)
 		do_interrupt_requests(vcpu, kvm_run);
 
@@ -2153,6 +2152,9 @@ again:
 	vcpu->interrupt_window_open = (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0;
 
 	asm ("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
+	vcpu->launched = 1;
+
+	preempt_enable();
 
 	if (unlikely(fail)) {
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
@@ -2167,7 +2169,6 @@ again:
 	if (unlikely(prof_on == KVM_PROFILING))
 		profile_hit(KVM_PROFILING, (void *)vmcs_readl(GUEST_RIP));
 
-	vcpu->launched = 1;
 	r = kvm_handle_exit(kvm_run, vcpu);
 	if (r > 0) {
 		/* Give scheduler a change to reschedule. */
-- 
1.5.2.4

