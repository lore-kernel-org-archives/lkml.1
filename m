Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbZJNGDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbZJNGDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbZJNGDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:03:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:58681 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317AbZJNGD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:03:29 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Marcelo Tosatti <mtosatti@redhat.com>, x86@kernel.org
Subject: [PATCH 09/16] percpu: make percpu symbols in x86 unique
Date: Wed, 14 Oct 2009 15:01:58 +0900
Message-Id: <1255500125-3210-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255500125-3210-1-git-send-email-tj@kernel.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:02:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates percpu related symbols in x86 such that percpu
symbols are unique and don't clash with local symbols.  This serves
two purposes of decreasing the possibility of global percpu symbol
collision and allowing dropping per_cpu__ prefix from percpu symbols.

* arch/x86/kernel/cpu/common.c: rename local variable to avoid collision

* arch/x86/kvm/svm.c: s/svm_data/sd/ for local variables to avoid collision

* arch/x86/kernel/cpu/cpu_debug.c: s/cpu_arr/cpud_arr/
  				   s/priv_arr/cpud_priv_arr/
				   s/cpu_priv_count/cpud_priv_count/

* arch/x86/kernel/cpu/intel_cacheinfo.c: s/cpuid4_info/ici_cpuid4_info/
  					 s/cache_kobject/ici_cache_kobject/
					 s/index_kobject/ici_index_kobject/

* arch/x86/kernel/ds.c: s/cpu_context/cpu_ds_context/

Partly based on Rusty Russell's "alloc_percpu: rename percpu vars
which cause name clashes" patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: (kvm) Avi Kivity <avi@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/cpu/common.c          |    8 ++--
 arch/x86/kernel/cpu/cpu_debug.c       |   30 ++++++++--------
 arch/x86/kernel/cpu/intel_cacheinfo.c |   54 ++++++++++++++--------------
 arch/x86/kernel/ds.c                  |    4 +-
 arch/x86/kvm/svm.c                    |   63 ++++++++++++++++-----------------
 5 files changed, 79 insertions(+), 80 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cc25c2b..3192f22 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1093,7 +1093,7 @@ static void clear_all_debug_regs(void)
 
 void __cpuinit cpu_init(void)
 {
-	struct orig_ist *orig_ist;
+	struct orig_ist *oist;
 	struct task_struct *me;
 	struct tss_struct *t;
 	unsigned long v;
@@ -1102,7 +1102,7 @@ void __cpuinit cpu_init(void)
 
 	cpu = stack_smp_processor_id();
 	t = &per_cpu(init_tss, cpu);
-	orig_ist = &per_cpu(orig_ist, cpu);
+	oist = &per_cpu(orig_ist, cpu);
 
 #ifdef CONFIG_NUMA
 	if (cpu != 0 && percpu_read(node_number) == 0 &&
@@ -1143,12 +1143,12 @@ void __cpuinit cpu_init(void)
 	/*
 	 * set up and load the per-CPU TSS
 	 */
-	if (!orig_ist->ist[0]) {
+	if (!oist->ist[0]) {
 		char *estacks = per_cpu(exception_stacks, cpu);
 
 		for (v = 0; v < N_EXCEPTION_STACKS; v++) {
 			estacks += exception_stack_sizes[v];
-			orig_ist->ist[v] = t->x86_tss.ist[v] =
+			oist->ist[v] = t->x86_tss.ist[v] =
 					(unsigned long)estacks;
 		}
 	}
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index dca325c..b368cd8 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -30,9 +30,9 @@
 #include <asm/apic.h>
 #include <asm/desc.h>
 
-static DEFINE_PER_CPU(struct cpu_cpuX_base [CPU_REG_ALL_BIT], cpu_arr);
-static DEFINE_PER_CPU(struct cpu_private * [MAX_CPU_FILES], priv_arr);
-static DEFINE_PER_CPU(int, cpu_priv_count);
+static DEFINE_PER_CPU(struct cpu_cpuX_base [CPU_REG_ALL_BIT], cpud_arr);
+static DEFINE_PER_CPU(struct cpu_private * [MAX_CPU_FILES], cpud_priv_arr);
+static DEFINE_PER_CPU(int, cpud_priv_count);
 
 static DEFINE_MUTEX(cpu_debug_lock);
 
@@ -531,7 +531,7 @@ static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
 
 	/* Already intialized */
 	if (file == CPU_INDEX_BIT)
-		if (per_cpu(cpu_arr[type].init, cpu))
+		if (per_cpu(cpud_arr[type].init, cpu))
 			return 0;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
@@ -543,8 +543,8 @@ static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
 	priv->reg = reg;
 	priv->file = file;
 	mutex_lock(&cpu_debug_lock);
-	per_cpu(priv_arr[type], cpu) = priv;
-	per_cpu(cpu_priv_count, cpu)++;
+	per_cpu(cpud_priv_arr[type], cpu) = priv;
+	per_cpu(cpud_priv_count, cpu)++;
 	mutex_unlock(&cpu_debug_lock);
 
 	if (file)
@@ -552,10 +552,10 @@ static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
 				    dentry, (void *)priv, &cpu_fops);
 	else {
 		debugfs_create_file(cpu_base[type].name, S_IRUGO,
-				    per_cpu(cpu_arr[type].dentry, cpu),
+				    per_cpu(cpud_arr[type].dentry, cpu),
 				    (void *)priv, &cpu_fops);
 		mutex_lock(&cpu_debug_lock);
-		per_cpu(cpu_arr[type].init, cpu) = 1;
+		per_cpu(cpud_arr[type].init, cpu) = 1;
 		mutex_unlock(&cpu_debug_lock);
 	}
 
@@ -615,7 +615,7 @@ static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
 		if (!is_typeflag_valid(cpu, cpu_base[type].flag))
 			continue;
 		cpu_dentry = debugfs_create_dir(cpu_base[type].name, dentry);
-		per_cpu(cpu_arr[type].dentry, cpu) = cpu_dentry;
+		per_cpu(cpud_arr[type].dentry, cpu) = cpu_dentry;
 
 		if (type < CPU_TSS_BIT)
 			err = cpu_init_msr(cpu, type, cpu_dentry);
@@ -647,11 +647,11 @@ static int cpu_init_cpu(void)
 		err = cpu_init_allreg(cpu, cpu_dentry);
 
 		pr_info("cpu%d(%d) debug files %d\n",
-			cpu, nr_cpu_ids, per_cpu(cpu_priv_count, cpu));
-		if (per_cpu(cpu_priv_count, cpu) > MAX_CPU_FILES) {
+			cpu, nr_cpu_ids, per_cpu(cpud_priv_count, cpu));
+		if (per_cpu(cpud_priv_count, cpu) > MAX_CPU_FILES) {
 			pr_err("Register files count %d exceeds limit %d\n",
-				per_cpu(cpu_priv_count, cpu), MAX_CPU_FILES);
-			per_cpu(cpu_priv_count, cpu) = MAX_CPU_FILES;
+				per_cpu(cpud_priv_count, cpu), MAX_CPU_FILES);
+			per_cpu(cpud_priv_count, cpu) = MAX_CPU_FILES;
 			err = -ENFILE;
 		}
 		if (err)
@@ -676,8 +676,8 @@ static void __exit cpu_debug_exit(void)
 		debugfs_remove_recursive(cpu_debugfs_dir);
 
 	for (cpu = 0; cpu <  nr_cpu_ids; cpu++)
-		for (i = 0; i < per_cpu(cpu_priv_count, cpu); i++)
-			kfree(per_cpu(priv_arr[i], cpu));
+		for (i = 0; i < per_cpu(cpud_priv_count, cpu); i++)
+			kfree(per_cpu(cpud_priv_arr[i], cpu));
 }
 
 module_init(cpu_debug_init);
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 804c40e..f5ccb4f 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -512,8 +512,8 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 #ifdef CONFIG_SYSFS
 
 /* pointer to _cpuid4_info array (for each cache leaf) */
-static DEFINE_PER_CPU(struct _cpuid4_info *, cpuid4_info);
-#define CPUID4_INFO_IDX(x, y)	(&((per_cpu(cpuid4_info, x))[y]))
+static DEFINE_PER_CPU(struct _cpuid4_info *, ici_cpuid4_info);
+#define CPUID4_INFO_IDX(x, y)	(&((per_cpu(ici_cpuid4_info, x))[y]))
 
 #ifdef CONFIG_SMP
 static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
@@ -526,7 +526,7 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
 	if ((index == 3) && (c->x86_vendor == X86_VENDOR_AMD)) {
 		struct cpuinfo_x86 *d;
 		for_each_online_cpu(i) {
-			if (!per_cpu(cpuid4_info, i))
+			if (!per_cpu(ici_cpuid4_info, i))
 				continue;
 			d = &cpu_data(i);
 			this_leaf = CPUID4_INFO_IDX(i, index);
@@ -548,7 +548,7 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
 			    c->apicid >> index_msb) {
 				cpumask_set_cpu(i,
 					to_cpumask(this_leaf->shared_cpu_map));
-				if (i != cpu && per_cpu(cpuid4_info, i))  {
+				if (i != cpu && per_cpu(ici_cpuid4_info, i))  {
 					sibling_leaf =
 						CPUID4_INFO_IDX(i, index);
 					cpumask_set_cpu(cpu, to_cpumask(
@@ -587,8 +587,8 @@ static void __cpuinit free_cache_attributes(unsigned int cpu)
 	for (i = 0; i < num_cache_leaves; i++)
 		cache_remove_shared_cpu_map(cpu, i);
 
-	kfree(per_cpu(cpuid4_info, cpu));
-	per_cpu(cpuid4_info, cpu) = NULL;
+	kfree(per_cpu(ici_cpuid4_info, cpu));
+	per_cpu(ici_cpuid4_info, cpu) = NULL;
 }
 
 static int
@@ -627,15 +627,15 @@ static int __cpuinit detect_cache_attributes(unsigned int cpu)
 	if (num_cache_leaves == 0)
 		return -ENOENT;
 
-	per_cpu(cpuid4_info, cpu) = kzalloc(
+	per_cpu(ici_cpuid4_info, cpu) = kzalloc(
 	    sizeof(struct _cpuid4_info) * num_cache_leaves, GFP_KERNEL);
-	if (per_cpu(cpuid4_info, cpu) == NULL)
+	if (per_cpu(ici_cpuid4_info, cpu) == NULL)
 		return -ENOMEM;
 
 	smp_call_function_single(cpu, get_cpu_leaves, &retval, true);
 	if (retval) {
-		kfree(per_cpu(cpuid4_info, cpu));
-		per_cpu(cpuid4_info, cpu) = NULL;
+		kfree(per_cpu(ici_cpuid4_info, cpu));
+		per_cpu(ici_cpuid4_info, cpu) = NULL;
 	}
 
 	return retval;
@@ -647,7 +647,7 @@ static int __cpuinit detect_cache_attributes(unsigned int cpu)
 extern struct sysdev_class cpu_sysdev_class; /* from drivers/base/cpu.c */
 
 /* pointer to kobject for cpuX/cache */
-static DEFINE_PER_CPU(struct kobject *, cache_kobject);
+static DEFINE_PER_CPU(struct kobject *, ici_cache_kobject);
 
 struct _index_kobject {
 	struct kobject kobj;
@@ -656,8 +656,8 @@ struct _index_kobject {
 };
 
 /* pointer to array of kobjects for cpuX/cache/indexY */
-static DEFINE_PER_CPU(struct _index_kobject *, index_kobject);
-#define INDEX_KOBJECT_PTR(x, y)		(&((per_cpu(index_kobject, x))[y]))
+static DEFINE_PER_CPU(struct _index_kobject *, ici_index_kobject);
+#define INDEX_KOBJECT_PTR(x, y)		(&((per_cpu(ici_index_kobject, x))[y]))
 
 #define show_one_plus(file_name, object, val)				\
 static ssize_t show_##file_name						\
@@ -876,10 +876,10 @@ static struct kobj_type ktype_percpu_entry = {
 
 static void __cpuinit cpuid4_cache_sysfs_exit(unsigned int cpu)
 {
-	kfree(per_cpu(cache_kobject, cpu));
-	kfree(per_cpu(index_kobject, cpu));
-	per_cpu(cache_kobject, cpu) = NULL;
-	per_cpu(index_kobject, cpu) = NULL;
+	kfree(per_cpu(ici_cache_kobject, cpu));
+	kfree(per_cpu(ici_index_kobject, cpu));
+	per_cpu(ici_cache_kobject, cpu) = NULL;
+	per_cpu(ici_index_kobject, cpu) = NULL;
 	free_cache_attributes(cpu);
 }
 
@@ -895,14 +895,14 @@ static int __cpuinit cpuid4_cache_sysfs_init(unsigned int cpu)
 		return err;
 
 	/* Allocate all required memory */
-	per_cpu(cache_kobject, cpu) =
+	per_cpu(ici_cache_kobject, cpu) =
 		kzalloc(sizeof(struct kobject), GFP_KERNEL);
-	if (unlikely(per_cpu(cache_kobject, cpu) == NULL))
+	if (unlikely(per_cpu(ici_cache_kobject, cpu) == NULL))
 		goto err_out;
 
-	per_cpu(index_kobject, cpu) = kzalloc(
+	per_cpu(ici_index_kobject, cpu) = kzalloc(
 	    sizeof(struct _index_kobject) * num_cache_leaves, GFP_KERNEL);
-	if (unlikely(per_cpu(index_kobject, cpu) == NULL))
+	if (unlikely(per_cpu(ici_index_kobject, cpu) == NULL))
 		goto err_out;
 
 	return 0;
@@ -926,7 +926,7 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 	if (unlikely(retval < 0))
 		return retval;
 
-	retval = kobject_init_and_add(per_cpu(cache_kobject, cpu),
+	retval = kobject_init_and_add(per_cpu(ici_cache_kobject, cpu),
 				      &ktype_percpu_entry,
 				      &sys_dev->kobj, "%s", "cache");
 	if (retval < 0) {
@@ -940,12 +940,12 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 		this_object->index = i;
 		retval = kobject_init_and_add(&(this_object->kobj),
 					      &ktype_cache,
-					      per_cpu(cache_kobject, cpu),
+					      per_cpu(ici_cache_kobject, cpu),
 					      "index%1lu", i);
 		if (unlikely(retval)) {
 			for (j = 0; j < i; j++)
 				kobject_put(&(INDEX_KOBJECT_PTR(cpu, j)->kobj));
-			kobject_put(per_cpu(cache_kobject, cpu));
+			kobject_put(per_cpu(ici_cache_kobject, cpu));
 			cpuid4_cache_sysfs_exit(cpu);
 			return retval;
 		}
@@ -953,7 +953,7 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 	}
 	cpumask_set_cpu(cpu, to_cpumask(cache_dev_map));
 
-	kobject_uevent(per_cpu(cache_kobject, cpu), KOBJ_ADD);
+	kobject_uevent(per_cpu(ici_cache_kobject, cpu), KOBJ_ADD);
 	return 0;
 }
 
@@ -962,7 +962,7 @@ static void __cpuinit cache_remove_dev(struct sys_device * sys_dev)
 	unsigned int cpu = sys_dev->id;
 	unsigned long i;
 
-	if (per_cpu(cpuid4_info, cpu) == NULL)
+	if (per_cpu(ici_cpuid4_info, cpu) == NULL)
 		return;
 	if (!cpumask_test_cpu(cpu, to_cpumask(cache_dev_map)))
 		return;
@@ -970,7 +970,7 @@ static void __cpuinit cache_remove_dev(struct sys_device * sys_dev)
 
 	for (i = 0; i < num_cache_leaves; i++)
 		kobject_put(&(INDEX_KOBJECT_PTR(cpu, i)->kobj));
-	kobject_put(per_cpu(cache_kobject, cpu));
+	kobject_put(per_cpu(ici_cache_kobject, cpu));
 	cpuid4_cache_sysfs_exit(cpu);
 }
 
diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index ef42a03..1c47390 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -265,13 +265,13 @@ struct ds_context {
 	int			cpu;
 };
 
-static DEFINE_PER_CPU(struct ds_context *, cpu_context);
+static DEFINE_PER_CPU(struct ds_context *, cpu_ds_context);
 
 
 static struct ds_context *ds_get_context(struct task_struct *task, int cpu)
 {
 	struct ds_context **p_context =
-		(task ? &task->thread.ds_ctx : &per_cpu(cpu_context, cpu));
+		(task ? &task->thread.ds_ctx : &per_cpu(cpu_ds_context, cpu));
 	struct ds_context *context = NULL;
 	struct ds_context *new_context = NULL;
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 944cc9c..6c79a14 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -319,7 +319,7 @@ static void svm_hardware_disable(void *garbage)
 static void svm_hardware_enable(void *garbage)
 {
 
-	struct svm_cpu_data *svm_data;
+	struct svm_cpu_data *sd;
 	uint64_t efer;
 	struct descriptor_table gdt_descr;
 	struct desc_struct *gdt;
@@ -329,62 +329,61 @@ static void svm_hardware_enable(void *garbage)
 		printk(KERN_ERR "svm_cpu_init: err EOPNOTSUPP on %d\n", me);
 		return;
 	}
-	svm_data = per_cpu(svm_data, me);
+	sd = per_cpu(svm_data, me);
 
-	if (!svm_data) {
+	if (!sd) {
 		printk(KERN_ERR "svm_cpu_init: svm_data is NULL on %d\n",
 		       me);
 		return;
 	}
 
-	svm_data->asid_generation = 1;
-	svm_data->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
-	svm_data->next_asid = svm_data->max_asid + 1;
+	sd->asid_generation = 1;
+	sd->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
+	sd->next_asid = sd->max_asid + 1;
 
 	kvm_get_gdt(&gdt_descr);
 	gdt = (struct desc_struct *)gdt_descr.base;
-	svm_data->tss_desc = (struct kvm_ldttss_desc *)(gdt + GDT_ENTRY_TSS);
+	sd->tss_desc = (struct kvm_ldttss_desc *)(gdt + GDT_ENTRY_TSS);
 
 	rdmsrl(MSR_EFER, efer);
 	wrmsrl(MSR_EFER, efer | EFER_SVME);
 
 	wrmsrl(MSR_VM_HSAVE_PA,
-	       page_to_pfn(svm_data->save_area) << PAGE_SHIFT);
+	       page_to_pfn(sd->save_area) << PAGE_SHIFT);
 }
 
 static void svm_cpu_uninit(int cpu)
 {
-	struct svm_cpu_data *svm_data
-		= per_cpu(svm_data, raw_smp_processor_id());
+	struct svm_cpu_data *sd = per_cpu(svm_data, raw_smp_processor_id());
 
-	if (!svm_data)
+	if (!sd)
 		return;
 
 	per_cpu(svm_data, raw_smp_processor_id()) = NULL;
-	__free_page(svm_data->save_area);
-	kfree(svm_data);
+	__free_page(sd->save_area);
+	kfree(sd);
 }
 
 static int svm_cpu_init(int cpu)
 {
-	struct svm_cpu_data *svm_data;
+	struct svm_cpu_data *sd;
 	int r;
 
-	svm_data = kzalloc(sizeof(struct svm_cpu_data), GFP_KERNEL);
-	if (!svm_data)
+	sd = kzalloc(sizeof(struct svm_cpu_data), GFP_KERNEL);
+	if (!sd)
 		return -ENOMEM;
-	svm_data->cpu = cpu;
-	svm_data->save_area = alloc_page(GFP_KERNEL);
+	sd->cpu = cpu;
+	sd->save_area = alloc_page(GFP_KERNEL);
 	r = -ENOMEM;
-	if (!svm_data->save_area)
+	if (!sd->save_area)
 		goto err_1;
 
-	per_cpu(svm_data, cpu) = svm_data;
+	per_cpu(svm_data, cpu) = sd;
 
 	return 0;
 
 err_1:
-	kfree(svm_data);
+	kfree(sd);
 	return r;
 
 }
@@ -1094,16 +1093,16 @@ static void save_host_msrs(struct kvm_vcpu *vcpu)
 #endif
 }
 
-static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *svm_data)
+static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 {
-	if (svm_data->next_asid > svm_data->max_asid) {
-		++svm_data->asid_generation;
-		svm_data->next_asid = 1;
+	if (sd->next_asid > sd->max_asid) {
+		++sd->asid_generation;
+		sd->next_asid = 1;
 		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
 	}
 
-	svm->asid_generation = svm_data->asid_generation;
-	svm->vmcb->control.asid = svm_data->next_asid++;
+	svm->asid_generation = sd->asid_generation;
+	svm->vmcb->control.asid = sd->next_asid++;
 }
 
 static unsigned long svm_get_dr(struct kvm_vcpu *vcpu, int dr)
@@ -2377,8 +2376,8 @@ static void reload_tss(struct kvm_vcpu *vcpu)
 {
 	int cpu = raw_smp_processor_id();
 
-	struct svm_cpu_data *svm_data = per_cpu(svm_data, cpu);
-	svm_data->tss_desc->type = 9; /* available 32/64-bit TSS */
+	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
+	sd->tss_desc->type = 9; /* available 32/64-bit TSS */
 	load_TR_desc();
 }
 
@@ -2386,12 +2385,12 @@ static void pre_svm_run(struct vcpu_svm *svm)
 {
 	int cpu = raw_smp_processor_id();
 
-	struct svm_cpu_data *svm_data = per_cpu(svm_data, cpu);
+	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
 
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
 	/* FIXME: handle wraparound of asid_generation */
-	if (svm->asid_generation != svm_data->asid_generation)
-		new_asid(svm, svm_data);
+	if (svm->asid_generation != sd->asid_generation)
+		new_asid(svm, sd);
 }
 
 static void svm_inject_nmi(struct kvm_vcpu *vcpu)
-- 
1.6.4.2

