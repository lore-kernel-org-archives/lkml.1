Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968285Ab0B0PJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 10:09:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48619 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964958Ab0B0PJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 10:09:56 -0500
Date: Sat, 27 Feb 2010 16:09:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu changes for v2.6.34
Message-ID: <20100227150942.GA6394@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cpu-for-linus


out-of-topic modifications in x86-cpu-for-linus:
------------------------------------------------
drivers/char/agp/intel-agp.c       # 48a719c: intel-agp: Switch to wbinvd_on_al

 Thanks,

	Ingo

------------------>
Borislav Petkov (7):
      x86, lib: Add wbinvd smp helpers
      intel-agp: Switch to wbinvd_on_all_cpus
      x86, cacheinfo: Fix disabling of L3 cache indices
      x86, cacheinfo: Add cache index disable sysfs attrs only to L3 caches
      x86, cacheinfo: Calculate L3 indices
      x86, cacheinfo: Remove NUMA dependency, fix for AMD Fam10h rev D1
      x86, cacheinfo: Enable L3 CID only on AMD

Joerg Roedel (1):
      x86, cpu: Print AMD virtualization features in /proc/cpuinfo


 arch/x86/include/asm/cpufeature.h          |    4 +
 arch/x86/include/asm/smp.h                 |    9 +
 arch/x86/kernel/cpu/addon_cpuid_features.c |    4 +
 arch/x86/kernel/cpu/intel_cacheinfo.c      |  250 +++++++++++++++++-----------
 arch/x86/lib/Makefile                      |    2 +-
 arch/x86/lib/cache-smp.c                   |   19 ++
 drivers/char/agp/intel-agp.c               |   15 +--
 7 files changed, 197 insertions(+), 106 deletions(-)
 create mode 100644 arch/x86/lib/cache-smp.c

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 637e1ec..0cd82d0 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -168,6 +168,10 @@
 #define X86_FEATURE_FLEXPRIORITY (8*32+ 2) /* Intel FlexPriority */
 #define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
 #define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
+#define X86_FEATURE_NPT		(8*32+5)  /* AMD Nested Page Table support */
+#define X86_FEATURE_LBRV	(8*32+6)  /* AMD LBR Virtualization support */
+#define X86_FEATURE_SVML	(8*32+7)  /* "svm_lock" AMD SVM locking MSR */
+#define X86_FEATURE_NRIPS	(8*32+8)  /* "nrip_save" AMD SVM next_rip save */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 1e79678..4cfc908 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -135,6 +135,8 @@ int native_cpu_disable(void);
 void native_cpu_die(unsigned int cpu);
 void native_play_dead(void);
 void play_dead_common(void);
+void wbinvd_on_cpu(int cpu);
+int wbinvd_on_all_cpus(void);
 
 void native_send_call_func_ipi(const struct cpumask *mask);
 void native_send_call_func_single_ipi(int cpu);
@@ -147,6 +149,13 @@ static inline int num_booting_cpus(void)
 {
 	return cpumask_weight(cpu_callout_mask);
 }
+#else /* !CONFIG_SMP */
+#define wbinvd_on_cpu(cpu)     wbinvd()
+static inline int wbinvd_on_all_cpus(void)
+{
+	wbinvd();
+	return 0;
+}
 #endif /* CONFIG_SMP */
 
 extern unsigned disabled_cpus __cpuinitdata;
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 468489b..97ad79c 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -32,6 +32,10 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
 		{ X86_FEATURE_IDA, CR_EAX, 1, 0x00000006 },
 		{ X86_FEATURE_ARAT, CR_EAX, 2, 0x00000006 },
+		{ X86_FEATURE_NPT,   CR_EDX, 0, 0x8000000a },
+		{ X86_FEATURE_LBRV,  CR_EDX, 1, 0x8000000a },
+		{ X86_FEATURE_SVML,  CR_EDX, 2, 0x8000000a },
+		{ X86_FEATURE_NRIPS, CR_EDX, 3, 0x8000000a },
 		{ 0, 0, 0, 0 }
 	};
 
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index fc6c8ef..d440123 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -18,6 +18,7 @@
 #include <asm/processor.h>
 #include <linux/smp.h>
 #include <asm/k8.h>
+#include <asm/smp.h>
 
 #define LVL_1_INST	1
 #define LVL_1_DATA	2
@@ -150,7 +151,8 @@ struct _cpuid4_info {
 	union _cpuid4_leaf_ebx ebx;
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
-	unsigned long can_disable;
+	bool can_disable;
+	unsigned int l3_indices;
 	DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
 };
 
@@ -160,7 +162,8 @@ struct _cpuid4_info_regs {
 	union _cpuid4_leaf_ebx ebx;
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
-	unsigned long can_disable;
+	bool can_disable;
+	unsigned int l3_indices;
 };
 
 unsigned short			num_cache_leaves;
@@ -290,6 +293,36 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 		(ebx->split.ways_of_associativity + 1) - 1;
 }
 
+struct _cache_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct _cpuid4_info *, char *);
+	ssize_t (*store)(struct _cpuid4_info *, const char *, size_t count);
+};
+
+#ifdef CONFIG_CPU_SUP_AMD
+static unsigned int __cpuinit amd_calc_l3_indices(void)
+{
+	/*
+	 * We're called over smp_call_function_single() and therefore
+	 * are on the correct cpu.
+	 */
+	int cpu = smp_processor_id();
+	int node = cpu_to_node(cpu);
+	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	unsigned int sc0, sc1, sc2, sc3;
+	u32 val = 0;
+
+	pci_read_config_dword(dev, 0x1C4, &val);
+
+	/* calculate subcache sizes */
+	sc0 = !(val & BIT(0));
+	sc1 = !(val & BIT(4));
+	sc2 = !(val & BIT(8))  + !(val & BIT(9));
+	sc3 = !(val & BIT(12)) + !(val & BIT(13));
+
+	return (max(max(max(sc0, sc1), sc2), sc3) << 10) - 1;
+}
+
 static void __cpuinit
 amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 {
@@ -299,12 +332,103 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 	if (boot_cpu_data.x86 == 0x11)
 		return;
 
-	/* see erratum #382 */
-	if ((boot_cpu_data.x86 == 0x10) && (boot_cpu_data.x86_model < 0x8))
+	/* see errata #382 and #388 */
+	if ((boot_cpu_data.x86 == 0x10) &&
+	    ((boot_cpu_data.x86_model < 0x8) ||
+	     (boot_cpu_data.x86_mask  < 0x1)))
 		return;
 
-	this_leaf->can_disable = 1;
+	this_leaf->can_disable = true;
+	this_leaf->l3_indices  = amd_calc_l3_indices();
+}
+
+static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
+				  unsigned int index)
+{
+	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
+	int node = amd_get_nb_id(cpu);
+	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	unsigned int reg = 0;
+
+	if (!this_leaf->can_disable)
+		return -EINVAL;
+
+	if (!dev)
+		return -EINVAL;
+
+	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
+	return sprintf(buf, "0x%08x\n", reg);
+}
+
+#define SHOW_CACHE_DISABLE(index)					\
+static ssize_t								\
+show_cache_disable_##index(struct _cpuid4_info *this_leaf, char *buf)	\
+{									\
+	return show_cache_disable(this_leaf, buf, index);		\
+}
+SHOW_CACHE_DISABLE(0)
+SHOW_CACHE_DISABLE(1)
+
+static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
+	const char *buf, size_t count, unsigned int index)
+{
+	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
+	int node = amd_get_nb_id(cpu);
+	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	unsigned long val = 0;
+
+#define SUBCACHE_MASK	(3UL << 20)
+#define SUBCACHE_INDEX	0xfff
+
+	if (!this_leaf->can_disable)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!dev)
+		return -EINVAL;
+
+	if (strict_strtoul(buf, 10, &val) < 0)
+		return -EINVAL;
+
+	/* do not allow writes outside of allowed bits */
+	if ((val & ~(SUBCACHE_MASK | SUBCACHE_INDEX)) ||
+	    ((val & SUBCACHE_INDEX) > this_leaf->l3_indices))
+		return -EINVAL;
+
+	val |= BIT(30);
+	pci_write_config_dword(dev, 0x1BC + index * 4, val);
+	/*
+	 * We need to WBINVD on a core on the node containing the L3 cache which
+	 * indices we disable therefore a simple wbinvd() is not sufficient.
+	 */
+	wbinvd_on_cpu(cpu);
+	pci_write_config_dword(dev, 0x1BC + index * 4, val | BIT(31));
+	return count;
+}
+
+#define STORE_CACHE_DISABLE(index)					\
+static ssize_t								\
+store_cache_disable_##index(struct _cpuid4_info *this_leaf,		\
+			    const char *buf, size_t count)		\
+{									\
+	return store_cache_disable(this_leaf, buf, count, index);	\
 }
+STORE_CACHE_DISABLE(0)
+STORE_CACHE_DISABLE(1)
+
+static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
+		show_cache_disable_0, store_cache_disable_0);
+static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
+		show_cache_disable_1, store_cache_disable_1);
+
+#else	/* CONFIG_CPU_SUP_AMD */
+static void __cpuinit
+amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
+{
+};
+#endif /* CONFIG_CPU_SUP_AMD */
 
 static int
 __cpuinit cpuid4_cache_lookup_regs(int index,
@@ -711,82 +835,6 @@ static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf)
 #define to_object(k)	container_of(k, struct _index_kobject, kobj)
 #define to_attr(a)	container_of(a, struct _cache_attr, attr)
 
-static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
-				  unsigned int index)
-{
-	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = cpu_to_node(cpu);
-	struct pci_dev *dev = node_to_k8_nb_misc(node);
-	unsigned int reg = 0;
-
-	if (!this_leaf->can_disable)
-		return -EINVAL;
-
-	if (!dev)
-		return -EINVAL;
-
-	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
-	return sprintf(buf, "%x\n", reg);
-}
-
-#define SHOW_CACHE_DISABLE(index)					\
-static ssize_t								\
-show_cache_disable_##index(struct _cpuid4_info *this_leaf, char *buf)  	\
-{									\
-	return show_cache_disable(this_leaf, buf, index);		\
-}
-SHOW_CACHE_DISABLE(0)
-SHOW_CACHE_DISABLE(1)
-
-static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
-	const char *buf, size_t count, unsigned int index)
-{
-	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = cpu_to_node(cpu);
-	struct pci_dev *dev = node_to_k8_nb_misc(node);
-	unsigned long val = 0;
-	unsigned int scrubber = 0;
-
-	if (!this_leaf->can_disable)
-		return -EINVAL;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	if (!dev)
-		return -EINVAL;
-
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
-
-	val |= 0xc0000000;
-
-	pci_read_config_dword(dev, 0x58, &scrubber);
-	scrubber &= ~0x1f000000;
-	pci_write_config_dword(dev, 0x58, scrubber);
-
-	pci_write_config_dword(dev, 0x1BC + index * 4, val & ~0x40000000);
-	wbinvd();
-	pci_write_config_dword(dev, 0x1BC + index * 4, val);
-	return count;
-}
-
-#define STORE_CACHE_DISABLE(index)					\
-static ssize_t								\
-store_cache_disable_##index(struct _cpuid4_info *this_leaf,	     	\
-			    const char *buf, size_t count)		\
-{									\
-	return store_cache_disable(this_leaf, buf, count, index);	\
-}
-STORE_CACHE_DISABLE(0)
-STORE_CACHE_DISABLE(1)
-
-struct _cache_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct _cpuid4_info *, char *);
-	ssize_t (*store)(struct _cpuid4_info *, const char *, size_t count);
-};
-
 #define define_one_ro(_name) \
 static struct _cache_attr _name = \
 	__ATTR(_name, 0444, show_##_name, NULL)
@@ -801,23 +849,28 @@ define_one_ro(size);
 define_one_ro(shared_cpu_map);
 define_one_ro(shared_cpu_list);
 
-static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
-		show_cache_disable_0, store_cache_disable_0);
-static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
-		show_cache_disable_1, store_cache_disable_1);
+#define DEFAULT_SYSFS_CACHE_ATTRS	\
+	&type.attr,			\
+	&level.attr,			\
+	&coherency_line_size.attr,	\
+	&physical_line_partition.attr,	\
+	&ways_of_associativity.attr,	\
+	&number_of_sets.attr,		\
+	&size.attr,			\
+	&shared_cpu_map.attr,		\
+	&shared_cpu_list.attr
 
 static struct attribute *default_attrs[] = {
-	&type.attr,
-	&level.attr,
-	&coherency_line_size.attr,
-	&physical_line_partition.attr,
-	&ways_of_associativity.attr,
-	&number_of_sets.attr,
-	&size.attr,
-	&shared_cpu_map.attr,
-	&shared_cpu_list.attr,
+	DEFAULT_SYSFS_CACHE_ATTRS,
+	NULL
+};
+
+static struct attribute *default_l3_attrs[] = {
+	DEFAULT_SYSFS_CACHE_ATTRS,
+#ifdef CONFIG_CPU_SUP_AMD
 	&cache_disable_0.attr,
 	&cache_disable_1.attr,
+#endif
 	NULL
 };
 
@@ -908,6 +961,7 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 	unsigned int cpu = sys_dev->id;
 	unsigned long i, j;
 	struct _index_kobject *this_object;
+	struct _cpuid4_info   *this_leaf;
 	int retval;
 
 	retval = cpuid4_cache_sysfs_init(cpu);
@@ -926,6 +980,14 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 		this_object = INDEX_KOBJECT_PTR(cpu, i);
 		this_object->cpu = cpu;
 		this_object->index = i;
+
+		this_leaf = CPUID4_INFO_IDX(cpu, i);
+
+		if (this_leaf->can_disable)
+			ktype_cache.default_attrs = default_l3_attrs;
+		else
+			ktype_cache.default_attrs = default_attrs;
+
 		retval = kobject_init_and_add(&(this_object->kobj),
 					      &ktype_cache,
 					      per_cpu(ici_cache_kobject, cpu),
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index cffd754..d85e0e4 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -14,7 +14,7 @@ $(obj)/inat.o: $(obj)/inat-tables.c
 
 clean-files := inat-tables.c
 
-obj-$(CONFIG_SMP) += msr-smp.o
+obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
 
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
new file mode 100644
index 0000000..a3c6688
--- /dev/null
+++ b/arch/x86/lib/cache-smp.c
@@ -0,0 +1,19 @@
+#include <linux/smp.h>
+#include <linux/module.h>
+
+static void __wbinvd(void *dummy)
+{
+	wbinvd();
+}
+
+void wbinvd_on_cpu(int cpu)
+{
+	smp_call_function_single(cpu, __wbinvd, NULL, 1);
+}
+EXPORT_SYMBOL(wbinvd_on_cpu);
+
+int wbinvd_on_all_cpus(void)
+{
+	return on_each_cpu(__wbinvd, NULL, 1);
+}
+EXPORT_SYMBOL(wbinvd_on_all_cpus);
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 3999a5f..8a713f1 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
 #include <linux/agp_backend.h>
+#include <asm/smp.h>
 #include "agp.h"
 
 /*
@@ -815,12 +816,6 @@ static void intel_i830_setup_flush(void)
 		intel_i830_fini_flush();
 }
 
-static void
-do_wbinvd(void *null)
-{
-	wbinvd();
-}
-
 /* The chipset_flush interface needs to get data that has already been
  * flushed out of the CPU all the way out to main memory, because the GPU
  * doesn't snoop those buffers.
@@ -837,12 +832,10 @@ static void intel_i830_chipset_flush(struct agp_bridge_data *bridge)
 
 	memset(pg, 0, 1024);
 
-	if (cpu_has_clflush) {
+	if (cpu_has_clflush)
 		clflush_cache_range(pg, 1024);
-	} else {
-		if (on_each_cpu(do_wbinvd, NULL, 1) != 0)
-			printk(KERN_ERR "Timed out waiting for cache flush.\n");
-	}
+	else if (wbinvd_on_all_cpus() != 0)
+		printk(KERN_ERR "Timed out waiting for cache flush.\n");
 }
 
 /* The intel i830 automatically initializes the agp aperture during POST.
