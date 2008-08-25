Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbYHYRvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbYHYRvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbYHYRvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:51:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47779 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbYHYRvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:51:10 -0400
Date: Mon, 25 Aug 2008 19:50:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] x86 fixes
Message-ID: <20080825175051.GA7101@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

I'd like to highlight this commit:

   x86: fix HPET regression in 2.6.26 versus 2.6.25, check hpet against BAR, v3

... which solves the bug for v2.6.27 but the long-term solution would 
IMO be to:

  1) convert all x86 platform device support to the generic struct 
     platform_device abstraction

  2) and to extend the resource manager in kernel/resource.c with the 
     ability to make resources registered by a platform device 
     'sticky/aliasable'.

That way platform devices would run first and register their resources, 
and the PCI code would then later on automatically recognize a resource 
already registered by a platform driver and would not re-allocate that 
PCI BAR and thus confuse the platform driver into not working. I havent 
seen such current capability/flag in kernel/resource.c - but i might 
have overlooked it.

We can delay that commit/fix if you can see a better solution for 
v2.6.27.

	Ingo

------------------>
Austin Zhang (1):
      x86: add X86_FEATURE_XMM4_2 definitions

Linus Torvalds (1):
      x86: do not enable TSC notifier if we don't need it

Peter Zijlstra (1):
      x86: fix cpufreq + sched_clock() regression

Rafael J. Wysocki (1):
      x86 MCE: Fix CPU hotplug problem with multiple multicore AMD CPUs

Robert Richter (2):
      x86: fix: do not run code in amd_bus.c on non-AMD CPUs
      x86: fix: make PCI ECS for AMD CPUs hotplug capable

Yinghai Lu (1):
      x86: fix HPET regression in 2.6.26 versus 2.6.25, check hpet against BAR, v3


 arch/x86/kernel/cpu/mcheck/mce_64.c     |    5 ++
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |   18 ++-----
 arch/x86/kernel/tsc.c                   |    6 ++-
 arch/x86/pci/amd_bus.c                  |   52 ++++++++++++++++++--
 arch/x86/pci/i386.c                     |   78 +++++++++++++++++++++++++++++++
 include/asm-x86/cpufeature.h            |    2 +
 include/asm-x86/mce.h                   |    1 +
 7 files changed, 142 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 65a3396..726a5fc 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -759,6 +759,7 @@ static struct sysdev_class mce_sysclass = {
 };
 
 DEFINE_PER_CPU(struct sys_device, device_mce);
+void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu) __cpuinitdata;
 
 /* Why are there no generic functions for this? */
 #define ACCESSOR(name, var, start) \
@@ -883,9 +884,13 @@ static int __cpuinit mce_cpu_callback(struct notifier_block *nfb,
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		mce_create_device(cpu);
+		if (threshold_cpu_callback)
+			threshold_cpu_callback(action, cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
+		if (threshold_cpu_callback)
+			threshold_cpu_callback(action, cpu);
 		mce_remove_device(cpu);
 		break;
 	}
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index 88736ca..5eb390a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -628,6 +628,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 	deallocate_threshold_block(cpu, bank);
 
 free_out:
+	kobject_del(b->kobj);
 	kobject_put(b->kobj);
 	kfree(b);
 	per_cpu(threshold_banks, cpu)[bank] = NULL;
@@ -645,14 +646,11 @@ static void threshold_remove_device(unsigned int cpu)
 }
 
 /* get notified when a cpu comes on/off */
-static int __cpuinit threshold_cpu_callback(struct notifier_block *nfb,
-					    unsigned long action, void *hcpu)
+static void __cpuinit amd_64_threshold_cpu_callback(unsigned long action,
+						     unsigned int cpu)
 {
-	/* cpu was unsigned int to begin with */
-	unsigned int cpu = (unsigned long)hcpu;
-
 	if (cpu >= NR_CPUS)
-		goto out;
+		return;
 
 	switch (action) {
 	case CPU_ONLINE:
@@ -666,14 +664,8 @@ static int __cpuinit threshold_cpu_callback(struct notifier_block *nfb,
 	default:
 		break;
 	}
-      out:
-	return NOTIFY_OK;
 }
 
-static struct notifier_block threshold_cpu_notifier __cpuinitdata = {
-	.notifier_call = threshold_cpu_callback,
-};
-
 static __init int threshold_init_device(void)
 {
 	unsigned lcpu = 0;
@@ -684,7 +676,7 @@ static __init int threshold_init_device(void)
 		if (err)
 			return err;
 	}
-	register_hotcpu_notifier(&threshold_cpu_notifier);
+	threshold_cpu_callback = amd_64_threshold_cpu_callback;
 	return 0;
 }
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 46af716..8e786b0 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -314,7 +314,7 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 			mark_tsc_unstable("cpufreq changes");
 	}
 
-	set_cyc2ns_scale(tsc_khz_ref, freq->cpu);
+	set_cyc2ns_scale(tsc_khz, freq->cpu);
 
 	return 0;
 }
@@ -325,6 +325,10 @@ static struct notifier_block time_cpufreq_notifier_block = {
 
 static int __init cpufreq_tsc(void)
 {
+	if (!cpu_has_tsc)
+		return 0;
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+		return 0;
 	cpufreq_register_notifier(&time_cpufreq_notifier_block,
 				CPUFREQ_TRANSITION_NOTIFIER);
 	return 0;
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index dbf5323..6a0fca7 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -1,6 +1,7 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/topology.h>
+#include <linux/cpu.h>
 #include "pci.h"
 
 #ifdef CONFIG_X86_64
@@ -555,15 +556,17 @@ static int __init early_fill_mp_bus_info(void)
 	return 0;
 }
 
-postcore_initcall(early_fill_mp_bus_info);
+#else  /* !CONFIG_X86_64 */
 
-#endif
+static int __init early_fill_mp_bus_info(void) { return 0; }
+
+#endif /* !CONFIG_X86_64 */
 
 /* common 32/64 bit code */
 
 #define ENABLE_CF8_EXT_CFG      (1ULL << 46)
 
-static void enable_pci_io_ecs_per_cpu(void *unused)
+static void enable_pci_io_ecs(void *unused)
 {
 	u64 reg;
 	rdmsrl(MSR_AMD64_NB_CFG, reg);
@@ -573,14 +576,51 @@ static void enable_pci_io_ecs_per_cpu(void *unused)
 	}
 }
 
-static int __init enable_pci_io_ecs(void)
+static int __cpuinit amd_cpu_notify(struct notifier_block *self,
+				    unsigned long action, void *hcpu)
 {
+	int cpu = (long)hcpu;
+	switch(action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		smp_call_function_single(cpu, enable_pci_io_ecs, NULL, 0);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata amd_cpu_notifier = {
+	.notifier_call	= amd_cpu_notify,
+};
+
+static int __init pci_io_ecs_init(void)
+{
+	int cpu;
+
 	/* assume all cpus from fam10h have IO ECS */
         if (boot_cpu_data.x86 < 0x10)
 		return 0;
-	on_each_cpu(enable_pci_io_ecs_per_cpu, NULL, 1);
+
+	register_cpu_notifier(&amd_cpu_notifier);
+	for_each_online_cpu(cpu)
+		amd_cpu_notify(&amd_cpu_notifier, (unsigned long)CPU_ONLINE,
+			       (void *)(long)cpu);
 	pci_probe |= PCI_HAS_IO_ECS;
+
+	return 0;
+}
+
+static int __init amd_postcore_init(void)
+{
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
+		return 0;
+
+	early_fill_mp_bus_info();
+	pci_io_ecs_init();
+
 	return 0;
 }
 
-postcore_initcall(enable_pci_io_ecs);
+postcore_initcall(amd_postcore_init);
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 5807d1b..d765da9 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -31,8 +31,11 @@
 #include <linux/ioport.h>
 #include <linux/errno.h>
 #include <linux/bootmem.h>
+#include <linux/acpi.h>
 
 #include <asm/pat.h>
+#include <asm/hpet.h>
+#include <asm/io_apic.h>
 
 #include "pci.h"
 
@@ -77,6 +80,77 @@ pcibios_align_resource(void *data, struct resource *res,
 }
 EXPORT_SYMBOL(pcibios_align_resource);
 
+static int check_res_with_valid(struct pci_dev *dev, struct resource *res)
+{
+	unsigned long base;
+	unsigned long size;
+	int i;
+
+	base = res->start;
+	size = (res->start == 0 && res->end == res->start) ? 0 :
+		 (res->end - res->start + 1);
+
+	if (!base || !size)
+		return 0;
+
+#ifdef CONFIG_HPET_TIMER
+	/* for hpet */
+	if (base == hpet_address && (res->flags & IORESOURCE_MEM)) {
+		dev_info(&dev->dev, "BAR has HPET at %08lx-%08lx\n",
+				 base, base + size - 1);
+		return 1;
+	}
+#endif
+
+#ifdef CONFIG_X86_IO_APIC
+	for (i = 0; i < nr_ioapics; i++) {
+		unsigned long ioapic_phys = mp_ioapics[i].mp_apicaddr;
+
+		if (base == ioapic_phys && (res->flags & IORESOURCE_MEM)) {
+			dev_info(&dev->dev, "BAR has ioapic at %08lx-%08lx\n",
+					 base, base + size - 1);
+			return 1;
+		}
+	}
+#endif
+
+#ifdef CONFIG_PCI_MMCONFIG
+	for (i = 0; i < pci_mmcfg_config_num; i++) {
+		unsigned long addr;
+
+		addr = pci_mmcfg_config[i].address;
+		if (base == addr && (res->flags & IORESOURCE_MEM)) {
+			dev_info(&dev->dev, "BAR has MMCONFIG at %08lx-%08lx\n",
+					 base, base + size - 1);
+			return 1;
+		}
+	}
+#endif
+
+	return 0;
+}
+
+static int check_platform(struct pci_dev *dev, struct resource *res)
+{
+	struct resource *root = NULL;
+
+	/*
+	 * forcibly insert it into the
+	 * resource tree
+	 */
+	if (res->flags & IORESOURCE_MEM)
+		root = &iomem_resource;
+	else if (res->flags & IORESOURCE_IO)
+		root = &ioport_resource;
+
+	if (root && check_res_with_valid(dev, res)) {
+		insert_resource(root, res);
+
+		return 1;
+	}
+
+	return 0;
+}
 /*
  *  Handle resources of PCI devices.  If the world were perfect, we could
  *  just allocate all the resource regions and do nothing more.  It isn't.
@@ -128,6 +202,8 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 				pr = pci_find_parent_resource(dev, r);
 				if (!r->start || !pr ||
 				    request_resource(pr, r) < 0) {
+					if (check_platform(dev, r))
+						continue;
 					dev_err(&dev->dev, "BAR %d: can't "
 						"allocate resource\n", idx);
 					/*
@@ -171,6 +247,8 @@ static void __init pcibios_allocate_resources(int pass)
 					r->flags, disabled, pass);
 				pr = pci_find_parent_resource(dev, r);
 				if (!pr || request_resource(pr, r) < 0) {
+					if (check_platform(dev, r))
+						continue;
 					dev_err(&dev->dev, "BAR %d: can't "
 						"allocate resource\n", idx);
 					/* We'll assign a new address later */
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 2f5a792..762f6a6 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -91,6 +91,7 @@
 #define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
 #define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
 #define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
+#define X86_FEATURE_XMM4_2	(4*32+20) /* Streaming SIMD Extensions-4.2 */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
 #define X86_FEATURE_XSTORE	(5*32+ 2) /* on-CPU RNG present (xstore insn) */
@@ -189,6 +190,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_gbpages		boot_cpu_has(X86_FEATURE_GBPAGES)
 #define cpu_has_arch_perfmon	boot_cpu_has(X86_FEATURE_ARCH_PERFMON)
 #define cpu_has_pat		boot_cpu_has(X86_FEATURE_PAT)
+#define cpu_has_xmm4_2		boot_cpu_has(X86_FEATURE_XMM4_2)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
diff --git a/include/asm-x86/mce.h b/include/asm-x86/mce.h
index 94f1fd7..531eaa5 100644
--- a/include/asm-x86/mce.h
+++ b/include/asm-x86/mce.h
@@ -92,6 +92,7 @@ extern int mce_disabled;
 
 void mce_log(struct mce *m);
 DECLARE_PER_CPU(struct sys_device, device_mce);
+extern void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
 
 #ifdef CONFIG_X86_MCE_INTEL
 void mce_intel_feature_init(struct cpuinfo_x86 *c);
