Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbXGHM6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbXGHM6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 08:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbXGHM6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 08:58:13 -0400
Received: from il.qumranet.com ([82.166.9.18]:59668 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbXGHM6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 08:58:12 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com, Avi Kivity <avi@qumranet.com>
Subject: [PATCH][RFC] kvm-scheduler integration
Date: Sun,  8 Jul 2007 15:58:17 +0300
Message-Id: <11838994974161-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Intel VT essentially introduces a new set of registers into the processor;
this means we cannot preempt kvm in kernel mode lest a new VM run with
and old VM's registers.  In addition, kvm lazy switches some host registers
as well. (AMD does not introduce new registers, but we still want lazy
msr switching, and we want to know when we move to a different cpu in order
to be able to guarantee a monotonously increasing tsc).

Current kvm code simply disables preemption when guest context is in use.
This, however, has many drawbacks:

- some kvm mmu code is O(n), causing possibly unbounded latencies and causing
  -rt great unhappiness.
- the mmu code wants to sleep (especially with guest paging), but can't.
- some optimizations are not possible; for example, if we switch from one
  VM to another, we need not restore some host registers (as they will simply
  be overwritten with the new guest registers immediately).

This patch adds hooks to the scheduler that allow kvm to be notified about
scheduling decisions involving virtual machines.  When we schedule out a VM,
kvm is told to swap guest registers out; when we schedule the VM in, we swap
the registers back in.

Note that this patch does not include optimizations; it just makes most
kvm code preemptible.  A follow on patch to convert the kvm spinlock to a
mutex should be trivial.

The only fly in the ointment is that it crashes quite soon.  Haven't figured
out why yet, but comments on the general direction would be welcome.

Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
index 33fa28a..b6aadc8 100644
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -40,4 +40,9 @@ config KVM_AMD
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
 
+config SCHED_KVM
+	bool
+	default y
+	depends on KVM
+
 endif # VIRTUALIZATION
diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index a7c5e6b..bb97dcc 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -474,7 +474,7 @@ struct kvm_arch_ops {
 	int (*vcpu_create)(struct kvm_vcpu *vcpu);
 	void (*vcpu_free)(struct kvm_vcpu *vcpu);
 
-	void (*vcpu_load)(struct kvm_vcpu *vcpu);
+	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
 	void (*vcpu_decache)(struct kvm_vcpu *vcpu);
 
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index ea02719..eb742d4 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -230,8 +230,13 @@ EXPORT_SYMBOL_GPL(kvm_put_guest_fpu);
  */
 static void vcpu_load(struct kvm_vcpu *vcpu)
 {
+	int cpu;
+
 	mutex_lock(&vcpu->mutex);
-	kvm_arch_ops->vcpu_load(vcpu);
+	cpu = get_cpu();
+	sched_load_kvm_state(vcpu);
+	kvm_arch_ops->vcpu_load(vcpu, cpu);
+	put_cpu();
 }
 
 /*
@@ -241,19 +246,26 @@ static void vcpu_load(struct kvm_vcpu *vcpu)
 static struct kvm_vcpu *vcpu_load_slot(struct kvm *kvm, int slot)
 {
 	struct kvm_vcpu *vcpu = &kvm->vcpus[slot];
+	int cpu;
 
 	mutex_lock(&vcpu->mutex);
 	if (!vcpu->vmcs) {
 		mutex_unlock(&vcpu->mutex);
 		return NULL;
 	}
-	kvm_arch_ops->vcpu_load(vcpu);
+	cpu = get_cpu();
+	sched_load_kvm_state(vcpu);
+	kvm_arch_ops->vcpu_load(vcpu, cpu);
+	put_cpu();
 	return vcpu;
 }
 
 static void vcpu_put(struct kvm_vcpu *vcpu)
 {
+	preempt_disable();
 	kvm_arch_ops->vcpu_put(vcpu);
+	sched_put_kvm_state();
+	preempt_enable();
 	mutex_unlock(&vcpu->mutex);
 }
 
@@ -1650,9 +1662,7 @@ void kvm_resched(struct kvm_vcpu *vcpu)
 {
 	if (!need_resched())
 		return;
-	vcpu_put(vcpu);
 	cond_resched();
-	vcpu_load(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_resched);
 
@@ -1718,11 +1728,9 @@ static int pio_copy_data(struct kvm_vcpu *vcpu)
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
@@ -1734,7 +1742,6 @@ static int pio_copy_data(struct kvm_vcpu *vcpu)
 		memcpy(p, q, bytes);
 	q -= vcpu->pio.guest_page_offset;
 	vunmap(q);
-	kvm_arch_ops->vcpu_load(vcpu);
 	free_pio_guest_pages(vcpu);
 	return 0;
 }
@@ -2375,6 +2382,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 	int r;
 	struct kvm_vcpu *vcpu;
 	struct page *page;
+	int cpu;
 
 	r = -EINVAL;
 	if (!valid_vcpu(n))
@@ -2414,7 +2422,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 	if (r < 0)
 		goto out_free_vcpus;
 
-	kvm_arch_ops->vcpu_load(vcpu);
+	cpu = get_cpu();
+	sched_load_kvm_state(vcpu);
+	kvm_arch_ops->vcpu_load(vcpu, cpu);
+	put_cpu();
 	r = kvm_mmu_setup(vcpu);
 	if (r >= 0)
 		r = kvm_arch_ops->vcpu_setup(vcpu);
@@ -3115,6 +3126,7 @@ hpa_t bad_page_address;
 int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
 {
 	int r;
+	struct sched_kvm_hooks sched_hooks;
 
 	if (kvm_arch_ops) {
 		printk(KERN_ERR "kvm: already loaded the other module\n");
@@ -3158,6 +3170,10 @@ int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
 		goto out_free;
 	}
 
+	sched_hooks.vcpu_load = kvm_arch_ops->vcpu_load;
+	sched_hooks.vcpu_put = kvm_arch_ops->vcpu_put;
+	sched_set_kvm_hooks(&sched_hooks);
+
 	return r;
 
 out_free:
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index b297a6b..f60aa87 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -254,9 +254,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
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
index bc818cc..22ae4a1 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -615,7 +615,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu)
 {
 	int cpu, i;
 
-	cpu = get_cpu();
+	cpu = sched_load_kvm_state(vcpu);
 	if (unlikely(cpu != vcpu->cpu)) {
 		u64 tsc_this, delta;
 
@@ -641,7 +641,7 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 		wrmsrl(host_save_user_msrs[i], vcpu->svm->host_user_msrs[i]);
 
 	rdtscll(vcpu->host_tsc);
-	put_cpu();
+	sched_put_kvm_state();
 }
 
 static void svm_vcpu_decache(struct kvm_vcpu *vcpu)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 80628f6..c72d583 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -179,6 +179,7 @@ static unsigned long vmcs_readl(unsigned long field)
 {
 	unsigned long value;
 
+	WARN_ON(raw_smp_processor_id() != current->kvm_vcpu->cpu);
 	asm volatile (ASM_VMX_VMREAD_RDX_RAX
 		      : "=a"(value) : "d"(field) : "cc");
 	return value;
@@ -214,6 +215,7 @@ static void vmcs_writel(unsigned long field, unsigned long value)
 {
 	u8 error;
 
+	WARN_ON(raw_smp_processor_id() != current->kvm_vcpu->cpu);
 	asm volatile (ASM_VMX_VMWRITE_RAX_RDX "; setna %0"
 		       : "=q"(error) : "a"(value), "d"(field) : "cc" );
 	if (unlikely(error))
@@ -366,14 +369,12 @@ static void vmx_load_host_state(struct kvm_vcpu *vcpu)
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
+	WARN_ON(!preempt_count());
 	if (vcpu->cpu != cpu)
 		vcpu_clear(vcpu);
 
@@ -426,9 +432,9 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu)
 
 static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	WARN_ON(!preempt_count());
 	vmx_load_host_state(vcpu);
 	kvm_put_guest_fpu(vcpu);
-	put_cpu();
 }
 
 static void vmx_fpu_activate(struct kvm_vcpu *vcpu)
@@ -2000,6 +2008,8 @@ preempted:
 		kvm_guest_debug_pre(vcpu);
 
 again:
+	preempt_disable();
+
 	if (!vcpu->mmio_read_completed)
 		do_interrupt_requests(vcpu, kvm_run);
 
@@ -2146,6 +2156,9 @@ again:
 	vcpu->interrupt_window_open = (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0;
 
 	asm ("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
+	vcpu->launched = 1;
+
+	preempt_enable();
 
 	if (unlikely(fail)) {
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
@@ -2160,7 +2174,6 @@ again:
 	if (unlikely(prof_on == KVM_PROFILING))
 		profile_hit(KVM_PROFILING, (void *)vmcs_readl(GUEST_RIP));
 
-	vcpu->launched = 1;
 	r = kvm_handle_exit(kvm_run, vcpu);
 	if (r > 0) {
 		/* Give scheduler a change to reschedule. */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 693f0e6..b705876 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -875,6 +875,10 @@ struct task_struct {
 	pid_t pid;
 	pid_t tgid;
 
+#ifdef CONFIG_SCHED_KVM
+	struct kvm_vcpu *kvm_vcpu;
+#endif
+
 #ifdef CONFIG_CC_STACKPROTECTOR
 	/* Canary value for the -fstack-protector gcc feature */
 	unsigned long stack_canary;
@@ -1369,6 +1373,18 @@ extern int send_group_sigqueue(int, struct sigqueue *,  struct task_struct *);
 extern int do_sigaction(int, struct k_sigaction *, struct k_sigaction *);
 extern int do_sigaltstack(const stack_t __user *, stack_t __user *, unsigned long);
 
+#ifdef CONFIG_SCHED_KVM
+
+struct sched_kvm_hooks {
+	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
+	void (*vcpu_put)(struct kvm_vcpu *vcpu);
+};
+
+int sched_load_kvm_state(struct kvm_vcpu *vcpu);
+void sched_put_kvm_state(void);
+void sched_set_kvm_hooks(struct sched_kvm_hooks *hooks);
+#endif
+
 static inline int kill_cad_pid(int sig, int priv)
 {
 	return kill_pid(cad_pid, sig, priv);
diff --git a/kernel/sched.c b/kernel/sched.c
index 13cdab3..beb3c45 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -57,6 +57,10 @@
 #include <asm/tlb.h>
 #include <asm/unistd.h>
 
+#ifdef CONFIG_SCHED_KVM
+static __read_mostly struct sched_kvm_hooks kvm_hooks;
+#endif
+
 /*
  * Scheduler clock - returns current time in nanosec units.
  * This is default implementation.
@@ -1805,6 +1809,51 @@ void fastcall sched_exit(struct task_struct *p)
 	task_rq_unlock(rq, &flags);
 }
 
+#ifdef CONFIG_SCHED_KVM
+
+int sched_load_kvm_state(struct kvm_vcpu *vcpu)
+{
+	current->kvm_vcpu = vcpu;
+	return raw_smp_processor_id();
+}
+EXPORT_SYMBOL_GPL(sched_load_kvm_state);
+
+void sched_put_kvm_state()
+{
+	current->kvm_vcpu = NULL;
+}
+EXPORT_SYMBOL_GPL(sched_put_kvm_state);
+
+void sched_set_kvm_hooks(struct sched_kvm_hooks *hooks)
+{
+	kvm_hooks = *hooks;
+}
+EXPORT_SYMBOL_GPL(sched_set_kvm_hooks);
+
+static void unload_kvm_vcpu(struct task_struct *tsk)
+{
+	if (tsk->kvm_vcpu)
+		kvm_hooks.vcpu_put(tsk->kvm_vcpu);
+}
+
+static void reload_kvm_vcpu(struct task_struct *tsk)
+{
+	if (tsk->kvm_vcpu)
+		kvm_hooks.vcpu_load(tsk->kvm_vcpu, raw_smp_processor_id());
+}
+
+#else
+
+static void unload_kvm_vcpu(struct task_struct *tsk)
+{
+}
+
+static void reload_kvm_vcpu(struct task_struct *tsk)
+{
+}
+
+#endif
+
 /**
  * prepare_task_switch - prepare to switch tasks
  * @rq: the runqueue preparing to switch
@@ -1819,6 +1870,7 @@ void fastcall sched_exit(struct task_struct *p)
  */
 static inline void prepare_task_switch(struct rq *rq, struct task_struct *next)
 {
+	unload_kvm_vcpu(current);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
 }
@@ -1860,6 +1912,7 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	prev_state = prev->state;
 	finish_arch_switch(prev);
 	finish_lock_switch(rq, prev);
+	reload_kvm_vcpu(current);
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
