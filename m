Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbZFRELE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbZFRELE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 00:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbZFREKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 00:10:54 -0400
Received: from ozlabs.org ([203.10.76.45]:42788 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbZFREKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 00:10:52 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [this_cpu_xx 01/11] Introduce this_cpu_ptr() and generic this_cpu_* operations
Date: Thu, 18 Jun 2009 12:31:48 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>, davem@davemloft.net
References: <20090605191819.376530498@gentwo.org> <4A38A719.2030709@kernel.org> <alpine.DEB.1.10.0906171343370.30060@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0906171343370.30060@gentwo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906181231.49816.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009 04:11:17 am Christoph Lameter wrote:
> It is possible to simply pass the full variable name of a percpu variable
> to this_cpu_* macros. See the patch of the vm statistics handling.
>
> It uses
>
> 	per_cpu_var(per_cpu_name_without_prefix)
>
> to generate the full name.

I have a patch to rip out the prefixes and use sparse annotations instead; I'll
dig it out...

OK, was a series of three.  Probably bitrotted, but here they are:

alloc_percpu: rename percpu vars which cause name clashes.

Currently DECLARE_PER_CPU vars have per_cpu__ prefixed to them, and
this effectively puts them in a separate namespace.  No surprise that
they clash with other names when that prefix is removed.

There may be others I've missed, but if so the transform is simple.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/ia64/kernel/crash.c                |    4 ++--
 arch/ia64/kernel/setup.c                |    8 ++++----
 arch/mn10300/kernel/kprobes.c           |    2 +-
 arch/powerpc/platforms/cell/interrupt.c |   14 +++++++-------
 arch/x86/include/asm/processor.h        |    2 +-
 arch/x86/include/asm/timer.h            |    5 +++--
 arch/x86/kernel/cpu/common.c            |    4 ++--
 arch/x86/kernel/dumpstack_64.c          |    2 +-
 arch/x86/kernel/tsc.c                   |    4 ++--
 arch/x86/kvm/svm.c                      |   14 +++++++-------
 drivers/cpufreq/cpufreq.c               |   16 ++++++++--------
 drivers/s390/net/netiucv.c              |    8 ++++----
 kernel/lockdep.c                        |   11 ++++++-----
 kernel/sched.c                          |   14 ++++++++------
 kernel/softirq.c                        |    4 ++--
 kernel/softlockup.c                     |   20 ++++++++++----------
 mm/slab.c                               |    8 ++++----
 mm/vmstat.c                             |    6 +++---
 18 files changed, 75 insertions(+), 71 deletions(-)

diff --git a/arch/ia64/kernel/crash.c b/arch/ia64/kernel/crash.c
--- a/arch/ia64/kernel/crash.c
+++ b/arch/ia64/kernel/crash.c
@@ -50,7 +50,7 @@ final_note(void *buf)
 
 extern void ia64_dump_cpu_regs(void *);
 
-static DEFINE_PER_CPU(struct elf_prstatus, elf_prstatus);
+static DEFINE_PER_CPU(struct elf_prstatus, elf_prstatus_pcpu);
 
 void
 crash_save_this_cpu(void)
@@ -59,7 +59,7 @@ crash_save_this_cpu(void)
 	unsigned long cfm, sof, sol;
 
 	int cpu = smp_processor_id();
-	struct elf_prstatus *prstatus = &per_cpu(elf_prstatus, cpu);
+	struct elf_prstatus *prstatus = &per_cpu(elf_prstatus_pcpu, cpu);
 
 	elf_greg_t *dst = (elf_greg_t *)&(prstatus->pr_reg);
 	memset(prstatus, 0, sizeof(*prstatus));
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -939,7 +939,7 @@ cpu_init (void)
 	unsigned long num_phys_stacked;
 	pal_vm_info_2_u_t vmi;
 	unsigned int max_ctx;
-	struct cpuinfo_ia64 *cpu_info;
+	struct cpuinfo_ia64 *cpuinfo;
 	void *cpu_data;
 
 	cpu_data = per_cpu_init();
@@ -972,15 +972,15 @@ cpu_init (void)
 	 * depends on the data returned by identify_cpu().  We break the dependency by
 	 * accessing cpu_data() through the canonical per-CPU address.
 	 */
-	cpu_info = cpu_data + ((char *) &__ia64_per_cpu_var(cpu_info) - __per_cpu_start);
-	identify_cpu(cpu_info);
+	cpuinfo = cpu_data + ((char *) &__ia64_per_cpu_var(cpu_info) - __per_cpu_start);
+	identify_cpu(cpuinfo);
 
 #ifdef CONFIG_MCKINLEY
 	{
 #		define FEATURE_SET 16
 		struct ia64_pal_retval iprv;
 
-		if (cpu_info->family == 0x1f) {
+		if (cpuinfo->family == 0x1f) {
 			PAL_CALL_PHYS(iprv, PAL_PROC_GET_FEATURES, 0, FEATURE_SET, 0);
 			if ((iprv.status == 0) && (iprv.v0 & 0x80) && (iprv.v2 & 0x80))
 				PAL_CALL_PHYS(iprv, PAL_PROC_SET_FEATURES,
diff --git a/arch/mn10300/kernel/kprobes.c b/arch/mn10300/kernel/kprobes.c
--- a/arch/mn10300/kernel/kprobes.c
+++ b/arch/mn10300/kernel/kprobes.c
@@ -39,7 +39,7 @@ static kprobe_opcode_t current_kprobe_ss
 static kprobe_opcode_t current_kprobe_ss_buf[MAX_INSN_SIZE + 2];
 static unsigned long current_kprobe_bp_addr;
 
-DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
+DEFINE_PER_CPU(struct kprobe *, current_kprobe_pcpu) = NULL;
 
 
 /* singlestep flag bits */
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -54,7 +54,7 @@ struct iic {
 	struct device_node *node;
 };
 
-static DEFINE_PER_CPU(struct iic, iic);
+static DEFINE_PER_CPU(struct iic, iic_pcpu);
 #define IIC_NODE_COUNT	2
 static struct irq_host *iic_host;
 
@@ -82,7 +82,7 @@ static void iic_unmask(unsigned int irq)
 
 static void iic_eoi(unsigned int irq)
 {
-	struct iic *iic = &__get_cpu_var(iic);
+	struct iic *iic = &__get_cpu_var(iic_pcpu);
 	out_be64(&iic->regs->prio, iic->eoi_stack[--iic->eoi_ptr]);
 	BUG_ON(iic->eoi_ptr < 0);
 }
@@ -146,7 +146,7 @@ static unsigned int iic_get_irq(void)
 	struct iic *iic;
 	unsigned int virq;
 
-	iic = &__get_cpu_var(iic);
+	iic = &__get_cpu_var(iic_pcpu);
 	*(unsigned long *) &pending =
 		in_be64((u64 __iomem *) &iic->regs->pending_destr);
 	if (!(pending.flags & CBE_IIC_IRQ_VALID))
@@ -161,12 +161,12 @@ static unsigned int iic_get_irq(void)
 
 void iic_setup_cpu(void)
 {
-	out_be64(&__get_cpu_var(iic).regs->prio, 0xff);
+	out_be64(&__get_cpu_var(iic_pcpu).regs->prio, 0xff);
 }
 
 u8 iic_get_target_id(int cpu)
 {
-	return per_cpu(iic, cpu).target_id;
+	return per_cpu(iic_pcpu, cpu).target_id;
 }
 
 EXPORT_SYMBOL_GPL(iic_get_target_id);
@@ -181,7 +181,7 @@ static inline int iic_ipi_to_irq(int ipi
 
 void iic_cause_IPI(int cpu, int mesg)
 {
-	out_be64(&per_cpu(iic, cpu).regs->generate, (0xf - mesg) << 4);
+	out_be64(&per_cpu(iic_pcpu, cpu).regs->generate, (0xf - mesg) << 4);
 }
 
 struct irq_host *iic_get_irq_host(int node)
@@ -350,7 +350,7 @@ static void __init init_one_iic(unsigned
 	/* XXX FIXME: should locate the linux CPU number from the HW cpu
 	 * number properly. We are lucky for now
 	 */
-	struct iic *iic = &per_cpu(iic, hw_cpu);
+	struct iic *iic = &per_cpu(iic_pcpu, hw_cpu);
 
 	iic->regs = ioremap(addr, sizeof(struct cbe_iic_thread_regs));
 	BUG_ON(iic->regs == NULL);
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -377,7 +377,7 @@ union thread_xstate {
 };
 
 #ifdef CONFIG_X86_64
-DECLARE_PER_CPU(struct orig_ist, orig_ist);
+DECLARE_PER_CPU(struct orig_ist, orig_ist_pcpu);
 #endif
 
 extern void print_cpu_info(struct cpuinfo_x86 *);
diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -42,13 +42,14 @@ extern int no_timer_check;
  *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
  */
 
-DECLARE_PER_CPU(unsigned long, cyc2ns);
+DECLARE_PER_CPU(unsigned long, percpu_cyc2ns);
 
 #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
 static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
 {
-	return cyc * per_cpu(cyc2ns, smp_processor_id()) >> CYC2NS_SCALE_FACTOR;
+	return cyc * per_cpu(percpu_cyc2ns, smp_processor_id()) >>
+		CYC2NS_SCALE_FACTOR;
 }
 
 static inline unsigned long long cycles_2_ns(unsigned long long cyc)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -955,7 +955,7 @@ unsigned long kernel_eflags;
  * Copies of the original ist values from the tss are only accessed during
  * debugging, no special alignment required.
  */
-DEFINE_PER_CPU(struct orig_ist, orig_ist);
+DEFINE_PER_CPU(struct orig_ist, orig_ist_pcpu);
 
 #else
 
@@ -980,7 +980,7 @@ void __cpuinit cpu_init(void)
 {
 	int cpu = stack_smp_processor_id();
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
-	struct orig_ist *orig_ist = &per_cpu(orig_ist, cpu);
+	struct orig_ist *orig_ist = &per_cpu(orig_ist_pcpu, cpu);
 	unsigned long v;
 	char *estacks = NULL;
 	struct task_struct *me;
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -40,7 +40,7 @@ static unsigned long *in_exception_stack
 	 * 'stack' is in one of them:
 	 */
 	for (k = 0; k < N_EXCEPTION_STACKS; k++) {
-		unsigned long end = per_cpu(orig_ist, cpu).ist[k];
+		unsigned long end = per_cpu(orig_ist_pcpu, cpu).ist[k];
 		/*
 		 * Is 'stack' above this exception frame's end?
 		 * If yes then skip to the next frame.
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -570,7 +570,7 @@ EXPORT_SYMBOL(recalibrate_cpu_khz);
  *                      -johnstul@us.ibm.com "math is hard, lets go shopping!"
  */
 
-DEFINE_PER_CPU(unsigned long, cyc2ns);
+DEFINE_PER_CPU(unsigned long, percpu_cyc2ns);
 
 static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
@@ -580,7 +580,7 @@ static void set_cyc2ns_scale(unsigned lo
 	local_irq_save(flags);
 	sched_clock_idle_sleep_event();
 
-	scale = &per_cpu(cyc2ns, cpu);
+	scale = &per_cpu(percpu_cyc2ns, cpu);
 
 	rdtscll(tsc_now);
 	ns_now = __cycles_2_ns(tsc_now);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -90,7 +90,7 @@ struct svm_cpu_data {
 	struct page *save_area;
 };
 
-static DEFINE_PER_CPU(struct svm_cpu_data *, svm_data);
+static DEFINE_PER_CPU(struct svm_cpu_data *, svm_data_pcpu);
 static uint32_t svm_features;
 
 struct svm_init_data {
@@ -275,7 +275,7 @@ static void svm_hardware_enable(void *ga
 		printk(KERN_ERR "svm_cpu_init: err EOPNOTSUPP on %d\n", me);
 		return;
 	}
-	svm_data = per_cpu(svm_data, me);
+	svm_data = per_cpu(svm_data_pcpu, me);
 
 	if (!svm_data) {
 		printk(KERN_ERR "svm_cpu_init: svm_data is NULL on %d\n",
@@ -301,12 +301,12 @@ static void svm_cpu_uninit(int cpu)
 static void svm_cpu_uninit(int cpu)
 {
 	struct svm_cpu_data *svm_data
-		= per_cpu(svm_data, raw_smp_processor_id());
+		= per_cpu(svm_data_pcpu, raw_smp_processor_id());
 
 	if (!svm_data)
 		return;
 
-	per_cpu(svm_data, raw_smp_processor_id()) = NULL;
+	per_cpu(svm_data_pcpu, raw_smp_processor_id()) = NULL;
 	__free_page(svm_data->save_area);
 	kfree(svm_data);
 }
@@ -325,7 +325,7 @@ static int svm_cpu_init(int cpu)
 	if (!svm_data->save_area)
 		goto err_1;
 
-	per_cpu(svm_data, cpu) = svm_data;
+	per_cpu(svm_data_pcpu, cpu) = svm_data;
 
 	return 0;
 
@@ -1508,7 +1508,7 @@ static void reload_tss(struct kvm_vcpu *
 {
 	int cpu = raw_smp_processor_id();
 
-	struct svm_cpu_data *svm_data = per_cpu(svm_data, cpu);
+	struct svm_cpu_data *svm_data = per_cpu(svm_data_pcpu, cpu);
 	svm_data->tss_desc->type = 9; /* available 32/64-bit TSS */
 	load_TR_desc();
 }
@@ -1517,7 +1517,7 @@ static void pre_svm_run(struct vcpu_svm 
 {
 	int cpu = raw_smp_processor_id();
 
-	struct svm_cpu_data *svm_data = per_cpu(svm_data, cpu);
+	struct svm_cpu_data *svm_data = per_cpu(svm_data_pcpu, cpu);
 
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
 	if (svm->vcpu.cpu != cpu ||
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -62,14 +62,14 @@ static DEFINE_SPINLOCK(cpufreq_driver_lo
  * - Governor routines that can be called in cpufreq hotplug path should not
  *   take this sem as top level hotplug notifier handler takes this.
  */
-static DEFINE_PER_CPU(int, policy_cpu);
+static DEFINE_PER_CPU(int, policy_cpu_pcpu);
 static DEFINE_PER_CPU(struct rw_semaphore, cpu_policy_rwsem);
 
 #define lock_policy_rwsem(mode, cpu)					\
 int lock_policy_rwsem_##mode						\
 (int cpu)								\
 {									\
-	int policy_cpu = per_cpu(policy_cpu, cpu);			\
+	int policy_cpu = per_cpu(policy_cpu_pcpu, cpu);			\
 	BUG_ON(policy_cpu == -1);					\
 	down_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));		\
 	if (unlikely(!cpu_online(cpu))) {				\
@@ -88,7 +88,7 @@ EXPORT_SYMBOL_GPL(lock_policy_rwsem_writ
 
 void unlock_policy_rwsem_read(int cpu)
 {
-	int policy_cpu = per_cpu(policy_cpu, cpu);
+	int policy_cpu = per_cpu(policy_cpu_pcpu, cpu);
 	BUG_ON(policy_cpu == -1);
 	up_read(&per_cpu(cpu_policy_rwsem, policy_cpu));
 }
@@ -96,7 +96,7 @@ EXPORT_SYMBOL_GPL(unlock_policy_rwsem_re
 
 void unlock_policy_rwsem_write(int cpu)
 {
-	int policy_cpu = per_cpu(policy_cpu, cpu);
+	int policy_cpu = per_cpu(policy_cpu_pcpu, cpu);
 	BUG_ON(policy_cpu == -1);
 	up_write(&per_cpu(cpu_policy_rwsem, policy_cpu));
 }
@@ -822,7 +822,7 @@ static int cpufreq_add_dev(struct sys_de
 	cpumask_copy(policy->cpus, cpumask_of(cpu));
 
 	/* Initially set CPU itself as the policy_cpu */
-	per_cpu(policy_cpu, cpu) = cpu;
+	per_cpu(policy_cpu_pcpu, cpu) = cpu;
 	lock_policy_rwsem_write(cpu);
 
 	init_completion(&policy->kobj_unregister);
@@ -866,7 +866,7 @@ static int cpufreq_add_dev(struct sys_de
 
 			/* Set proper policy_cpu */
 			unlock_policy_rwsem_write(cpu);
-			per_cpu(policy_cpu, cpu) = managed_policy->cpu;
+			per_cpu(policy_cpu_pcpu, cpu) = managed_policy->cpu;
 
 			if (lock_policy_rwsem_write(cpu) < 0)
 				goto err_out_driver_exit;
@@ -929,7 +929,7 @@ static int cpufreq_add_dev(struct sys_de
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus) {
 		per_cpu(cpufreq_cpu_data, j) = policy;
-		per_cpu(policy_cpu, j) = policy->cpu;
+		per_cpu(policy_cpu_pcpu, j) = policy->cpu;
 	}
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -1937,7 +1937,7 @@ static int __init cpufreq_core_init(void
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-		per_cpu(policy_cpu, cpu) = -1;
+		per_cpu(policy_cpu_pcpu, cpu) = -1;
 		init_rwsem(&per_cpu(cpu_policy_rwsem, cpu));
 	}
 	return 0;
diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -98,7 +98,7 @@ MODULE_DESCRIPTION ("Linux for S/390 IUC
 		debug_event(iucv_dbf_##name,level,(void*)(addr),len); \
 	} while (0)
 
-DECLARE_PER_CPU(char[256], iucv_dbf_txt_buf);
+DECLARE_PER_CPU(char[256], iucv_dbf_txt_buf_pcpu);
 
 /* Allow to sort out low debug levels early to avoid wasted sprints */
 static inline int iucv_dbf_passes(debug_info_t *dbf_grp, int level)
@@ -110,11 +110,11 @@ static inline int iucv_dbf_passes(debug_
 	do { \
 		if (iucv_dbf_passes(iucv_dbf_##name, level)) { \
 			char* iucv_dbf_txt_buf = \
-					get_cpu_var(iucv_dbf_txt_buf); \
+					get_cpu_var(iucv_dbf_txt_buf_pcpu); \
 			sprintf(iucv_dbf_txt_buf, text); \
 			debug_text_event(iucv_dbf_##name, level, \
 						iucv_dbf_txt_buf); \
-			put_cpu_var(iucv_dbf_txt_buf); \
+			put_cpu_var(iucv_dbf_txt_buf_pcpu); \
 		} \
 	} while (0)
 
@@ -462,7 +462,7 @@ static debug_info_t *iucv_dbf_data = NUL
 static debug_info_t *iucv_dbf_data = NULL;
 static debug_info_t *iucv_dbf_trace = NULL;
 
-DEFINE_PER_CPU(char[256], iucv_dbf_txt_buf);
+DEFINE_PER_CPU(char[256], iucv_dbf_txt_buf_pcpu);
 
 static void iucv_unregister_dbf_views(void)
 {
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -135,7 +135,8 @@ static inline struct lock_class *hlock_c
 }
 
 #ifdef CONFIG_LOCK_STAT
-static DEFINE_PER_CPU(struct lock_class_stats[MAX_LOCKDEP_KEYS], lock_stats);
+static DEFINE_PER_CPU(struct lock_class_stats[MAX_LOCKDEP_KEYS],
+		      percpu_lock_stats);
 
 static int lock_point(unsigned long points[], unsigned long ip)
 {
@@ -181,7 +182,7 @@ struct lock_class_stats lock_stats(struc
 	memset(&stats, 0, sizeof(struct lock_class_stats));
 	for_each_possible_cpu(cpu) {
 		struct lock_class_stats *pcs =
-			&per_cpu(lock_stats, cpu)[class - lock_classes];
+			&per_cpu(percpu_lock_stats, cpu)[class - lock_classes];
 
 		for (i = 0; i < ARRAY_SIZE(stats.contention_point); i++)
 			stats.contention_point[i] += pcs->contention_point[i];
@@ -208,7 +209,7 @@ void clear_lock_stats(struct lock_class 
 
 	for_each_possible_cpu(cpu) {
 		struct lock_class_stats *cpu_stats =
-			&per_cpu(lock_stats, cpu)[class - lock_classes];
+			&per_cpu(percpu_lock_stats, cpu)[class - lock_classes];
 
 		memset(cpu_stats, 0, sizeof(struct lock_class_stats));
 	}
@@ -218,12 +219,12 @@ void clear_lock_stats(struct lock_class 
 
 static struct lock_class_stats *get_lock_stats(struct lock_class *class)
 {
-	return &get_cpu_var(lock_stats)[class - lock_classes];
+	return &get_cpu_var(percpu_lock_stats)[class - lock_classes];
 }
 
 static void put_lock_stats(struct lock_class_stats *stats)
 {
-	put_cpu_var(lock_stats);
+	put_cpu_var(percpu_lock_stats);
 }
 
 static void lock_release_holdtime(struct held_lock *hlock)
diff --git a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -315,12 +315,14 @@ struct task_group root_task_group;
 /* Default task group's sched entity on each cpu */
 static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
 /* Default task group's cfs_rq on each cpu */
-static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
+static DEFINE_PER_CPU(struct cfs_rq, percpu_init_cfs_rq)
+	____cacheline_aligned_in_smp;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
-static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
+static DEFINE_PER_CPU(struct rt_rq, percpu_init_rt_rq)
+	____cacheline_aligned_in_smp;
 #endif /* CONFIG_RT_GROUP_SCHED */
 #else /* !CONFIG_USER_SCHED */
 #define root_task_group init_task_group
@@ -7213,14 +7215,14 @@ struct static_sched_domain {
  */
 #ifdef CONFIG_SCHED_SMT
 static DEFINE_PER_CPU(struct static_sched_domain, cpu_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_cpus);
+static DEFINE_PER_CPU(struct static_sched_group, sched_group_cpus_pcpu);
 
 static int
 cpu_to_cpu_group(int cpu, const struct cpumask *cpu_map,
 		 struct sched_group **sg, struct cpumask *unused)
 {
 	if (sg)
-		*sg = &per_cpu(sched_group_cpus, cpu).sg;
+		*sg = &per_cpu(sched_group_cpus_pcpu, cpu).sg;
 	return cpu;
 }
 #endif /* CONFIG_SCHED_SMT */
@@ -8408,7 +8410,7 @@ void __init sched_init(void)
 		 * tasks in rq->cfs (i.e init_task_group->se[] != NULL).
 		 */
 		init_tg_cfs_entry(&init_task_group,
-				&per_cpu(init_cfs_rq, i),
+				&per_cpu(percpu_init_cfs_rq, i),
 				&per_cpu(init_sched_entity, i), i, 1,
 				root_task_group.se[i]);
 
@@ -8423,7 +8425,7 @@ void __init sched_init(void)
 #elif defined CONFIG_USER_SCHED
 		init_tg_rt_entry(&root_task_group, &rq->rt, NULL, i, 0, NULL);
 		init_tg_rt_entry(&init_task_group,
-				&per_cpu(init_rt_rq, i),
+				&per_cpu(percpu_init_rt_rq, i),
 				&per_cpu(init_sched_rt_entity, i), i, 1,
 				root_task_group.rt_se[i]);
 #endif
diff --git a/kernel/softirq.c b/kernel/softirq.c
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -602,7 +602,7 @@ void __init softirq_init(void)
 	open_softirq(HI_SOFTIRQ, tasklet_hi_action);
 }
 
-static int ksoftirqd(void * __bind_cpu)
+static int run_ksoftirqd(void *__bind_cpu)
 {
 	set_current_state(TASK_INTERRUPTIBLE);
 
@@ -714,7 +714,7 @@ static int __cpuinit cpu_callback(struct
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		p = kthread_create(ksoftirqd, hcpu, "ksoftirqd/%d", hotcpu);
+		p = kthread_create(run_ksoftirqd, hcpu, "ksoftirqd/%d", hotcpu);
 		if (IS_ERR(p)) {
 			printk("ksoftirqd for %i failed\n", hotcpu);
 			return NOTIFY_BAD;
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -95,28 +95,28 @@ void softlockup_tick(void)
 void softlockup_tick(void)
 {
 	int this_cpu = smp_processor_id();
-	unsigned long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
-	unsigned long print_timestamp;
+	unsigned long touch_ts = per_cpu(touch_timestamp, this_cpu);
+	unsigned long print_ts;
 	struct pt_regs *regs = get_irq_regs();
 	unsigned long now;
 
 	/* Is detection switched off? */
 	if (!per_cpu(watchdog_task, this_cpu) || softlockup_thresh <= 0) {
 		/* Be sure we don't false trigger if switched back on */
-		if (touch_timestamp)
+		if (touch_ts)
 			per_cpu(touch_timestamp, this_cpu) = 0;
 		return;
 	}
 
-	if (touch_timestamp == 0) {
+	if (touch_ts == 0) {
 		__touch_softlockup_watchdog();
 		return;
 	}
 
-	print_timestamp = per_cpu(print_timestamp, this_cpu);
+	print_ts = per_cpu(print_timestamp, this_cpu);
 
 	/* report at most once a second */
-	if (print_timestamp == touch_timestamp || did_panic)
+	if (print_ts == touch_ts || did_panic)
 		return;
 
 	/* do not print during early bootup: */
@@ -131,18 +131,18 @@ void softlockup_tick(void)
 	 * Wake up the high-prio watchdog task twice per
 	 * threshold timespan.
 	 */
-	if (now > touch_timestamp + softlockup_thresh/2)
+	if (now > touch_ts + softlockup_thresh/2)
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
 
 	/* Warn about unreasonable delays: */
-	if (now <= (touch_timestamp + softlockup_thresh))
+	if (now <= (touch_ts + softlockup_thresh))
 		return;
 
-	per_cpu(print_timestamp, this_cpu) = touch_timestamp;
+	per_cpu(print_timestamp, this_cpu) = touch_ts;
 
 	spin_lock(&print_lock);
 	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
-			this_cpu, now - touch_timestamp,
+			this_cpu, now - touch_ts,
 			current->comm, task_pid_nr(current));
 	print_modules();
 	print_irqtrace_events(current);
diff --git a/mm/slab.c b/mm/slab.c
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -933,17 +933,17 @@ static void next_reap_node(void)
  */
 static void __cpuinit start_cpu_timer(int cpu)
 {
-	struct delayed_work *reap_work = &per_cpu(reap_work, cpu);
+	struct delayed_work *reap = &per_cpu(reap_work, cpu);
 
 	/*
 	 * When this gets called from do_initcalls via cpucache_init(),
 	 * init_workqueues() has already run, so keventd will be setup
 	 * at that time.
 	 */
-	if (keventd_up() && reap_work->work.func == NULL) {
+	if (keventd_up() && reap->work.func == NULL) {
 		init_reap_node(cpu);
-		INIT_DELAYED_WORK(reap_work, cache_reap);
-		schedule_delayed_work_on(cpu, reap_work,
+		INIT_DELAYED_WORK(reap, cache_reap);
+		schedule_delayed_work_on(cpu, reap,
 					__round_jiffies_relative(HZ, cpu));
 	}
 }
diff --git a/mm/vmstat.c b/mm/vmstat.c
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -903,10 +903,10 @@ static void vmstat_update(struct work_st
 
 static void __cpuinit start_cpu_timer(int cpu)
 {
-	struct delayed_work *vmstat_work = &per_cpu(vmstat_work, cpu);
+	struct delayed_work *vw = &per_cpu(vmstat_work, cpu);
 
-	INIT_DELAYED_WORK_DEFERRABLE(vmstat_work, vmstat_update);
-	schedule_delayed_work_on(cpu, vmstat_work, HZ + cpu);
+	INIT_DELAYED_WORK_DEFERRABLE(vw, vmstat_update);
+	schedule_delayed_work_on(cpu, vw, HZ + cpu);
 }
 
 /*
alloc_percpu: remove per_cpu__ prefix.

Now that the return from alloc_percpu is compatible with the address
of per-cpu vars, it makes sense to hand around the address of per-cpu
variables.  To make this sane, we remove the per_cpu__ prefix we used
created to stop people accidentally using these vars directly.

Now we have sparse, we can use that (next patch).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/alpha/include/asm/percpu.h         |    4 ++--
 arch/cris/arch-v10/kernel/entry.S       |    2 +-
 arch/cris/arch-v32/mm/mmu.S             |    2 +-
 arch/ia64/include/asm/percpu.h          |    4 ++--
 arch/ia64/kernel/ia64_ksyms.c           |    4 ++--
 arch/ia64/mm/discontig.c                |    2 +-
 arch/parisc/lib/fixup.S                 |    8 ++++----
 arch/powerpc/platforms/pseries/hvCall.S |    2 +-
 arch/sparc/kernel/rtrap_64.S            |    8 ++++----
 arch/x86/include/asm/percpu.h           |   20 ++++++++++----------
 arch/x86/kernel/entry_64.S              |    4 ++--
 arch/x86/kernel/head_32.S               |    2 +-
 arch/x86/kernel/head_64.S               |    2 +-
 arch/x86/xen/xen-asm_32.S               |    4 ++--
 include/asm-generic/percpu.h            |    2 +-
 include/linux/percpu.h                  |   12 ++++++------
 16 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/arch/alpha/include/asm/percpu.h b/arch/alpha/include/asm/percpu.h
--- a/arch/alpha/include/asm/percpu.h
+++ b/arch/alpha/include/asm/percpu.h
@@ -7,7 +7,7 @@
  * Determine the real variable name from the name visible in the
  * kernel sources.
  */
-#define per_cpu_var(var) per_cpu__##var
+#define per_cpu_var(var) var
 
 #ifdef CONFIG_SMP
 
@@ -43,7 +43,7 @@ extern unsigned long __per_cpu_offset[NR
 	unsigned long __ptr, tmp_gp;			\
 	asm (  "br	%1, 1f		  	      \n\
 	1:	ldgp	%1, 0(%1)	    	      \n\
-		ldq %0, per_cpu__" #var"(%1)\t!literal"		\
+		ldq %0, "#var"(%1)\t!literal"		\
 		: "=&r"(__ptr), "=&r"(tmp_gp));		\
 	(typeof(&per_cpu_var(var)))(__ptr + (offset)); })
 
diff --git a/arch/cris/arch-v10/kernel/entry.S b/arch/cris/arch-v10/kernel/entry.S
--- a/arch/cris/arch-v10/kernel/entry.S
+++ b/arch/cris/arch-v10/kernel/entry.S
@@ -358,7 +358,7 @@ 1:	btstq	12, $r1		   ; Refill?
 1:	btstq	12, $r1		   ; Refill?
 	bpl	2f
 	lsrq	24, $r1     ; Get PGD index (bit 24-31)
-	move.d  [per_cpu__current_pgd], $r0 ; PGD for the current process
+	move.d  [current_pgd], $r0 ; PGD for the current process
 	move.d	[$r0+$r1.d], $r0   ; Get PMD
 	beq	2f
 	nop
diff --git a/arch/cris/arch-v32/mm/mmu.S b/arch/cris/arch-v32/mm/mmu.S
--- a/arch/cris/arch-v32/mm/mmu.S
+++ b/arch/cris/arch-v32/mm/mmu.S
@@ -115,7 +115,7 @@ 3:	; Probably not in a loop, continue no
 #ifdef CONFIG_SMP
 	move    $s7, $acr	; PGD
 #else
-	move.d  per_cpu__current_pgd, $acr ; PGD
+	move.d  current_pgd, $acr ; PGD
 #endif
 	; Look up PMD in PGD
 	lsrq	24, $r0	; Get PMD index into PGD (bit 24-31)
diff --git a/arch/ia64/include/asm/percpu.h b/arch/ia64/include/asm/percpu.h
--- a/arch/ia64/include/asm/percpu.h
+++ b/arch/ia64/include/asm/percpu.h
@@ -9,7 +9,7 @@
 #define PERCPU_ENOUGH_ROOM PERCPU_PAGE_SIZE
 
 #ifdef __ASSEMBLY__
-# define THIS_CPU(var)	(per_cpu__##var)  /* use this to mark accesses to per-CPU variables... */
+# define THIS_CPU(var)	(var)  /* use this to mark accesses to per-CPU variables... */
 #else /* !__ASSEMBLY__ */
 
 
@@ -39,7 +39,7 @@ extern void *per_cpu_init(void);
  * On the positive side, using __ia64_per_cpu_var() instead of __get_cpu_var() is slightly
  * more efficient.
  */
-#define __ia64_per_cpu_var(var)	per_cpu__##var
+#define __ia64_per_cpu_var(var)	var
 
 #include <asm-generic/percpu.h>
 
diff --git a/arch/ia64/kernel/ia64_ksyms.c b/arch/ia64/kernel/ia64_ksyms.c
--- a/arch/ia64/kernel/ia64_ksyms.c
+++ b/arch/ia64/kernel/ia64_ksyms.c
@@ -29,9 +29,9 @@ EXPORT_SYMBOL(max_low_pfn);	/* defined b
 #endif
 
 #include <asm/processor.h>
-EXPORT_SYMBOL(per_cpu__cpu_info);
+EXPORT_SYMBOL(cpu_info);
 #ifdef CONFIG_SMP
-EXPORT_SYMBOL(per_cpu__local_per_cpu_offset);
+EXPORT_SYMBOL(local_per_cpu_offset);
 #endif
 
 #include <asm/uaccess.h>
diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -360,7 +360,7 @@ static void __init initialize_pernode_da
 		cpu = 0;
 		node = node_cpuid[cpu].nid;
 		cpu0_cpu_info = (struct cpuinfo_ia64 *)(__phys_per_cpu_start +
-			((char *)&per_cpu__cpu_info - __per_cpu_start));
+			((char *)&cpu_info - __per_cpu_start));
 		cpu0_cpu_info->node_data = mem_data[node].node_data;
 	}
 #endif /* CONFIG_SMP */
diff --git a/arch/parisc/lib/fixup.S b/arch/parisc/lib/fixup.S
--- a/arch/parisc/lib/fixup.S
+++ b/arch/parisc/lib/fixup.S
@@ -36,8 +36,8 @@
 #endif
 	/* t2 = &__per_cpu_offset[smp_processor_id()]; */
 	LDREGX \t2(\t1),\t2 
-	addil LT%per_cpu__exception_data,%r27
-	LDREG RT%per_cpu__exception_data(%r1),\t1
+	addil LT%exception_data,%r27
+	LDREG RT%exception_data(%r1),\t1
 	/* t1 = &__get_cpu_var(exception_data) */
 	add,l \t1,\t2,\t1
 	/* t1 = t1->fault_ip */
@@ -46,8 +46,8 @@
 #else
 	.macro  get_fault_ip t1 t2
 	/* t1 = &__get_cpu_var(exception_data) */
-	addil LT%per_cpu__exception_data,%r27
-	LDREG RT%per_cpu__exception_data(%r1),\t2
+	addil LT%exception_data,%r27
+	LDREG RT%exception_data(%r1),\t2
 	/* t1 = t2->fault_ip */
 	LDREG EXCDATA_IP(\t2), \t1
 	.endm
diff --git a/arch/powerpc/platforms/pseries/hvCall.S b/arch/powerpc/platforms/pseries/hvCall.S
--- a/arch/powerpc/platforms/pseries/hvCall.S
+++ b/arch/powerpc/platforms/pseries/hvCall.S
@@ -55,7 +55,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_PURR);				
 	/* calculate address of stat structure r4 = opcode */	\
 	srdi	r4,r4,2;		/* index into array */	\
 	mulli	r4,r4,HCALL_STAT_SIZE;				\
-	LOAD_REG_ADDR(r7, per_cpu__hcall_stats);		\
+	LOAD_REG_ADDR(r7, hcall_stats);				\
 	add	r4,r4,r7;					\
 	ld	r7,PACA_DATA_OFFSET(r13); /* per cpu offset */	\
 	add	r4,r4,r7;					\
diff --git a/arch/sparc/kernel/rtrap_64.S b/arch/sparc/kernel/rtrap_64.S
--- a/arch/sparc/kernel/rtrap_64.S
+++ b/arch/sparc/kernel/rtrap_64.S
@@ -149,11 +149,11 @@ rtrap_irq:
 rtrap_irq:
 rtrap:
 #ifndef CONFIG_SMP
-		sethi			%hi(per_cpu____cpu_data), %l0
-		lduw			[%l0 + %lo(per_cpu____cpu_data)], %l1
+		sethi			%hi(__cpu_data), %l0
+		lduw			[%l0 + %lo(__cpu_data)], %l1
 #else
-		sethi			%hi(per_cpu____cpu_data), %l0
-		or			%l0, %lo(per_cpu____cpu_data), %l0
+		sethi			%hi(__cpu_data), %l0
+		or			%l0, %lo(__cpu_data), %l0
 		lduw			[%l0 + %g5], %l1
 #endif
 		cmp			%l1, 0
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -66,13 +66,13 @@ DECLARE_PER_CPU(struct x8664_pda, pda);
  */
 #ifdef CONFIG_SMP
 #define PER_CPU(var, reg)				\
-	movl %fs:per_cpu__##this_cpu_off, reg;		\
-	lea per_cpu__##var(reg), reg
-#define PER_CPU_VAR(var)	%fs:per_cpu__##var
+	movl %fs:this_cpu_off, reg;			\
+	lea var(reg), reg
+#define PER_CPU_VAR(var)	%fs:var
 #else /* ! SMP */
 #define PER_CPU(var, reg)			\
-	movl $per_cpu__##var, reg
-#define PER_CPU_VAR(var)	per_cpu__##var
+	movl $var, reg
+#define PER_CPU_VAR(var)	var
 #endif	/* SMP */
 
 #else /* ...!ASSEMBLY */
@@ -162,11 +162,11 @@ do {							\
 	ret__;						\
 })
 
-#define x86_read_percpu(var) percpu_from_op("mov", per_cpu__##var)
-#define x86_write_percpu(var, val) percpu_to_op("mov", per_cpu__##var, val)
-#define x86_add_percpu(var, val) percpu_to_op("add", per_cpu__##var, val)
-#define x86_sub_percpu(var, val) percpu_to_op("sub", per_cpu__##var, val)
-#define x86_or_percpu(var, val) percpu_to_op("or", per_cpu__##var, val)
+#define x86_read_percpu(var) percpu_from_op("mov", var)
+#define x86_write_percpu(var, val) percpu_to_op("mov", var, val)
+#define x86_add_percpu(var, val) percpu_to_op("add", var, val)
+#define x86_sub_percpu(var, val) percpu_to_op("sub", var, val)
+#define x86_or_percpu(var, val) percpu_to_op("or", var, val)
 #endif /* !__ASSEMBLY__ */
 #endif /* !CONFIG_X86_64 */
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1073,9 +1073,9 @@ ENTRY(\sym)
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
 	movq %gs:pda_data_offset, %rbp
-	subq $EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
+	subq $EXCEPTION_STKSZ, init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
 	call \do_sym
-	addq $EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
+	addq $EXCEPTION_STKSZ, init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
 	jmp paranoid_exit	/* %ebx: no swapgs flag */
 	CFI_ENDPROC
 END(\sym)
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -702,7 +702,7 @@ idt_descr:
 	.word 0				# 32 bit align gdt_desc.address
 ENTRY(early_gdt_descr)
 	.word GDT_ENTRIES*8-1
-	.long per_cpu__gdt_page		/* Overwritten for secondary CPUs */
+	.long gdt_page			/* Overwritten for secondary CPUs */
 
 /*
  * The boot_gdt must mirror the equivalent in setup.S and is
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -401,7 +401,7 @@ NEXT_PAGE(level2_spare_pgt)
 	.globl early_gdt_descr
 early_gdt_descr:
 	.word	GDT_ENTRIES*8-1
-	.quad   per_cpu__gdt_page
+	.quad   gdt_page
 
 ENTRY(phys_base)
 	/* This must match the first entry in level2_kernel_pgt */
diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -164,9 +164,9 @@ ENTRY(xen_iret)
 	GET_THREAD_INFO(%eax)
 	movl TI_cpu(%eax),%eax
 	movl __per_cpu_offset(,%eax,4),%eax
-	mov per_cpu__xen_vcpu(%eax),%eax
+	mov xen_vcpu(%eax),%eax
 #else
-	movl per_cpu__xen_vcpu, %eax
+	movl xen_vcpu, %eax
 #endif
 
 	/* check IF state we're restoring */
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -7,7 +7,7 @@
  * Determine the real variable name from the name visible in the
  * kernel sources.
  */
-#define per_cpu_var(var) per_cpu__##var
+#define per_cpu_var(var) var
 
 #ifdef CONFIG_SMP
 
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -11,7 +11,7 @@
 #ifdef CONFIG_SMP
 #define DEFINE_PER_CPU(type, name)					\
 	__attribute__((__section__(".data.percpu")))			\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+	PER_CPU_ATTRIBUTES __typeof__(type) name
 
 #ifdef MODULE
 #define SHARED_ALIGNED_SECTION ".data.percpu"
@@ -21,15 +21,15 @@
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
 	__attribute__((__section__(SHARED_ALIGNED_SECTION)))		\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name		\
+	PER_CPU_ATTRIBUTES __typeof__(type) name			\
 	____cacheline_aligned_in_smp
 
 #define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)			\
 	__attribute__((__section__(".data.percpu.page_aligned")))	\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+	PER_CPU_ATTRIBUTES __typeof__(type) name
 #else
 #define DEFINE_PER_CPU(type, name)					\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+	PER_CPU_ATTRIBUTES __typeof__(type) name
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		      \
 	DEFINE_PER_CPU(type, name)
@@ -38,8 +38,8 @@
 	DEFINE_PER_CPU(type, name)
 #endif
 
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
+#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(var)
+#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(var)
 
 #ifndef PERCPU_ENOUGH_ROOM
 extern unsigned int percpu_reserve;
alloc_percpu: use __percpu annotation for sparse.

Add __percpu for sparse.

We have to make __kernel "__attribute__((address_space(0)))" so we can
cast to it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-generic/percpu.h |   19 ++++++++++++-------
 include/linux/compiler.h     |    4 +++-
 include/linux/percpu.h       |    8 ++++----
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -45,7 +45,9 @@ extern unsigned long __per_cpu_offset[NR
  * Only S390 provides its own means of moving the pointer.
  */
 #ifndef SHIFT_PERCPU_PTR
-#define SHIFT_PERCPU_PTR(__p, __offset)	RELOC_HIDE((__p), (__offset))
+/* Weird cast keeps both GCC and sparse happy. */
+#define SHIFT_PERCPU_PTR(__p, __offset)	\
+	((typeof(*__p) __kernel __force *)RELOC_HIDE((__p), (__offset)))
 #endif
 
 /*
@@ -61,16 +63,19 @@ extern unsigned long __per_cpu_offset[NR
 	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), __my_cpu_offset))
 
 /* Use RELOC_HIDE: some arch's SHIFT_PERCPU_PTR really want an identifier. */
+#define RELOC_PERCPU(addr, off) \
+	((typeof(*addr) __kernel __force *)RELOC_HIDE((addr), (off)))
+
 /**
  * per_cpu_ptr - get a pointer to a particular cpu's allocated memory
- * @ptr: the pointer returned from alloc_percpu
+ * @ptr: the pointer returned from alloc_percpu, or &per-cpu var
  * @cpu: the cpu whose memory you want to access
  *
  * Similar to per_cpu(), except for dynamic memory.
  * cpu_possible(@cpu) must be true.
  */
 #define per_cpu_ptr(ptr, cpu) \
-	RELOC_HIDE((ptr), (per_cpu_offset(cpu)))
+	RELOC_PERCPU((ptr), (per_cpu_offset(cpu)))
 
 /**
  * __get_cpu_ptr - get a pointer to this cpu's allocated memory
@@ -78,8 +83,8 @@ extern unsigned long __per_cpu_offset[NR
  *
  * Similar to __get_cpu_var(), except for dynamic memory.
  */
-#define __get_cpu_ptr(ptr) RELOC_HIDE(ptr, my_cpu_offset)
-#define __raw_get_cpu_ptr(ptr) RELOC_HIDE(ptr, __my_cpu_offset)
+#define __get_cpu_ptr(ptr) RELOC_PERCPU(ptr, my_cpu_offset)
+#define __raw_get_cpu_ptr(ptr) RELOC_PERCPU(ptr, __my_cpu_offset)
 
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 extern void setup_per_cpu_areas(void);
@@ -100,7 +105,7 @@ extern void setup_per_cpu_areas(void);
 #define PER_CPU_ATTRIBUTES
 #endif
 
-#define DECLARE_PER_CPU(type, name) extern PER_CPU_ATTRIBUTES \
-					__typeof__(type) per_cpu_var(name)
+#define DECLARE_PER_CPU(type, name) \
+	extern PER_CPU_ATTRIBUTES __percpu __typeof__(type) per_cpu_var(name)
 
 #endif /* _ASM_GENERIC_PERCPU_H_ */
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -5,7 +5,7 @@
 
 #ifdef __CHECKER__
 # define __user		__attribute__((noderef, address_space(1)))
-# define __kernel	/* default address space */
+# define __kernel	__attribute__((address_space(0)))
 # define __safe		__attribute__((safe))
 # define __force	__attribute__((force))
 # define __nocast	__attribute__((nocast))
@@ -15,6 +15,7 @@
 # define __acquire(x)	__context__(x,1)
 # define __release(x)	__context__(x,-1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
+# define __percpu	__attribute__((noderef, address_space(3)))
 extern void __chk_user_ptr(const volatile void __user *);
 extern void __chk_io_ptr(const volatile void __iomem *);
 #else
@@ -32,6 +33,7 @@ extern void __chk_io_ptr(const volatile 
 # define __acquire(x) (void)0
 # define __release(x) (void)0
 # define __cond_lock(x,c) (c)
+# define __percpu
 #endif
 
 #ifdef __KERNEL__
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -11,7 +11,7 @@
 #ifdef CONFIG_SMP
 #define DEFINE_PER_CPU(type, name)					\
 	__attribute__((__section__(".data.percpu")))			\
-	PER_CPU_ATTRIBUTES __typeof__(type) name
+	PER_CPU_ATTRIBUTES __typeof__(type) __percpu name
 
 #ifdef MODULE
 #define SHARED_ALIGNED_SECTION ".data.percpu"
@@ -21,15 +21,15 @@
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
 	__attribute__((__section__(SHARED_ALIGNED_SECTION)))		\
-	PER_CPU_ATTRIBUTES __typeof__(type) name			\
+	PER_CPU_ATTRIBUTES __typeof__(type) __percpu name		\
 	____cacheline_aligned_in_smp
 
 #define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)			\
 	__attribute__((__section__(".data.percpu.page_aligned")))	\
-	PER_CPU_ATTRIBUTES __typeof__(type) name
+	PER_CPU_ATTRIBUTES __typeof__(type) __percpu name
 #else
 #define DEFINE_PER_CPU(type, name)					\
-	PER_CPU_ATTRIBUTES __typeof__(type) name
+	PER_CPU_ATTRIBUTES __typeof__(type) __percpu name
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		      \
 	DEFINE_PER_CPU(type, name)

