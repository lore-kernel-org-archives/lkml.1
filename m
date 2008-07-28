Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbYG1Qsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbYG1Qsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757122AbYG1Qqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:46:49 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:38533 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYG1Qqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:46:44 -0400
X-BigFish: VPS7(zz1cddkzz10d3izzz32i43j67h)
X-Spam-TCS-SCL: 6:0
X-FB-SS: 5,
X-WSS-ID: 0K4Q6LG-02-TW7-01
Message-ID: <20080728164449.234580245@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 28 Jul 2008 18:44:21 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: [patch 10/11] [PATCH 10/11] x86: Major refactoring.
References: <20080728164411.490752571@amd.com>
Content-Disposition: inline; filename="0010-x86-Major-refactoring.patch"
X-OriginalArrivalTime: 28 Jul 2008 16:46:29.0778 (UTC) FILETIME=[7BE95720:01C8F0D1]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactored code by introducing a two-module solution. There is one
general module in which vendor specific modules can hook into.
However, that is exclusive, there is only one vendor specific module
allowed at a time. A CPU vendor check makes sure only the corect
module for the underlying system gets called. Functinally in terms
of patch loading itself there are no changes. This refactoring
provides a basis for future implementations of other vendors'
patch loaders.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 arch/x86/Kconfig                  |   25 +++++++++--
 arch/x86/kernel/Makefile          |    4 +-
 arch/x86/kernel/microcode.c       |   80 +++++++++++++++++++++---------------
 arch/x86/kernel/microcode_intel.c |   50 ++++++++++++++++++-----
 include/asm-x86/microcode.h       |    3 +
 5 files changed, 112 insertions(+), 50 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b6fa287..6b0b885 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -782,7 +782,7 @@ config X86_REBOOTFIXUPS
 	  Say N otherwise.
 
 config MICROCODE
-	tristate "/dev/cpu/microcode - Intel IA32 CPU microcode support"
+	tristate "/dev/cpu/microcode - microcode support"
 	select FW_LOADER
 	---help---
 	  If you say Y here, you will be able to update the microcode on
@@ -791,14 +791,29 @@ config MICROCODE
 	  actual microcode binary data itself which is not shipped with the
 	  Linux kernel.
 
-	  For latest news and information on obtaining all the required
-	  ingredients for this driver, check:
-	  <http://www.urbanmyth.org/microcode/>.
+	  This option selects the general module only, you need to select
+	  at least one vendor specific module as well.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called microcode.
 
-config MICROCODE_OLD_INTERFACE
+config MICROCODE_INTEL
+       tristate "Intel microcode patch loading support"
+       depends on MICROCODE
+       default MICROCODE
+       select FW_LOADER
+       --help---
+         This options enables microcode patch loading support for Intel
+         processors.
+
+         For latest news and information on obtaining all the required
+         Intel ingredients for this driver, check:
+         <http://www.urbanmyth.org/microcode/>.
+
+         This driver is only available as a module: the module
+         will be called microcode_intel.  
+
+   config MICROCODE_OLD_INTERFACE
 	def_bool y
 	depends on MICROCODE
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index abb32ae..f2f9f6d 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -51,8 +51,8 @@ obj-$(CONFIG_X86_BIOS_REBOOT)	+= reboot.o
 obj-$(CONFIG_MCA)		+= mca_32.o
 obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
-obj-$(CONFIG_MICROCODE)		+= ucode.o
-ucode-objs                      := microcode.o microcode_intel.o
+obj-$(CONFIG_MICROCODE)		+= microcode.o
+obj-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
 apm-y				:= apm_32.o
 obj-$(CONFIG_APM)		+= apm.o
diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index c1047d7..1e42e79 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -99,25 +99,22 @@ MODULE_DESCRIPTION("Microcode Update Driver");
 MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
 MODULE_LICENSE("GPL");
 
-#define MICROCODE_VERSION 	"1.14a"
+#define MICROCODE_VERSION 	"2.00"
 
-/* no concurrent ->write()s are allowed on /dev/cpu/microcode */
-DEFINE_MUTEX(microcode_mutex);
+struct microcode_ops *microcode_ops;
 
-struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
+/* no concurrent ->write()s are allowed on /dev/cpu/microcode */
+static DEFINE_MUTEX(microcode_mutex);
+EXPORT_SYMBOL_GPL(microcode_mutex);
 
-extern long get_next_ucode(void **mc, long offset);
-extern int microcode_sanity_check(void *mc);
-extern int get_matching_microcode(void *mc, int cpu);
-extern void collect_cpu_info(int cpu_num);
-extern int cpu_request_microcode(int cpu);
-extern void microcode_fini_cpu(int cpu);
-extern void apply_microcode(int cpu);
-extern int apply_microcode_check_cpu(int cpu);
+static struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
+EXPORT_SYMBOL_GPL(ucode_cpu_info);
 
 #ifdef CONFIG_MICROCODE_OLD_INTERFACE
-void __user *user_buffer;	/* user area microcode data buffer */
-unsigned int user_buffer_size;	/* it's size */
+static void __user *user_buffer;	/* user area microcode data buffer */
+EXPORT_SYMBOL_GPL(user_buffer);
+static unsigned int user_buffer_size;	/* it's size */
+EXPORT_SYMBOL_GPL(user_buffer_size);
 
 static int do_microcode_update (void)
 {
@@ -130,8 +127,8 @@ static int do_microcode_update (void)
 
 	old = current->cpus_allowed;
 
-	while ((cursor = get_next_ucode(&new_mc, cursor)) > 0) {
-		error = microcode_sanity_check(new_mc);
+	while ((cursor = microcode_ops->get_next_ucode(&new_mc, cursor)) > 0) {
+		error = microcode_ops->microcode_sanity_check(new_mc);
 		if (error)
 			goto out;
 		/*
@@ -145,11 +142,12 @@ static int do_microcode_update (void)
 				continue;
 			cpumask_of_cpu_ptr_next(newmask, cpu);
 			set_cpus_allowed_ptr(current, newmask);
-			error = get_maching_microcode(new_mc, cpu);
+			error = microcode_ops->get_matching_microcode(new_mc,
+								      cpu);
 			if (error < 0)
 				goto out;
 			if (error == 1)
-				apply_microcode(cpu);
+				microcode_ops->apply_microcode(cpu);
 		}
 		vfree(new_mc);
 	}
@@ -232,7 +230,8 @@ MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
 #endif
 
 /* fake device for request_firmware */
-struct platform_device *microcode_pdev;
+static struct platform_device *microcode_pdev;
+EXPORT_SYMBOL_GPL(microcode_pdev);
 
 static void microcode_init_cpu(int cpu, int resume)
 {
@@ -244,9 +243,9 @@ static void microcode_init_cpu(int cpu, int resume)
 
 	set_cpus_allowed_ptr(current, newmask);
 	mutex_lock(&microcode_mutex);
-	collect_cpu_info(cpu);
+	microcode_ops->collect_cpu_info(cpu);
 	if (uci->valid && system_state == SYSTEM_RUNNING && !resume)
-		cpu_request_microcode(cpu);
+		microcode_ops->cpu_request_microcode(cpu);
 	mutex_unlock(&microcode_mutex);
 	set_cpus_allowed_ptr(current, &old);
 }
@@ -274,7 +273,7 @@ static ssize_t reload_store(struct sys_device *dev,
 
 		mutex_lock(&microcode_mutex);
 		if (uci->valid)
-			err = cpu_request_microcode(cpu);
+			err = microcode_ops->cpu_request_microcode(cpu);
 		mutex_unlock(&microcode_mutex);
 		put_online_cpus();
 		set_cpus_allowed_ptr(current, &old);
@@ -349,7 +348,7 @@ static int mc_sysdev_remove(struct sys_device *sys_dev)
 		return 0;
 
 	pr_debug("microcode: CPU%d removed\n", cpu);
-	microcode_fini_cpu(cpu);
+	microcode_ops->microcode_fini_cpu(cpu);
 	sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
 	return 0;
 }
@@ -362,7 +361,7 @@ static int mc_sysdev_resume(struct sys_device *dev)
 		return 0;
 	pr_debug("microcode: CPU%d resumed\n", cpu);
 	/* only CPU 0 will apply ucode here */
-	apply_microcode(0);
+	microcode_ops->apply_microcode(0);
 	return 0;
 }
 
@@ -382,7 +381,7 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 	switch (action) {
 	case CPU_UP_CANCELED_FROZEN:
 		/* The CPU refused to come up during a system resume */
-		microcode_fini_cpu(cpu);
+		microcode_ops->microcode_fini_cpu(cpu);
 		break;
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
@@ -390,9 +389,9 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 		break;
 	case CPU_ONLINE_FROZEN:
 		/* System-wide resume is in progress, try to apply microcode */
-		if (apply_microcode_check_cpu(cpu)) {
+		if (microcode_ops->apply_microcode_check_cpu(cpu)) {
 			/* The application of microcode failed */
-			microcode_fini_cpu(cpu);
+			microcode_ops->microcode_fini_cpu(cpu);
 			__mc_sysdev_add(sys_dev, 1);
 			break;
 		}
@@ -416,12 +415,17 @@ static struct notifier_block __refdata mc_cpu_notifier = {
 	.notifier_call = mc_cpu_callback,
 };
 
-static int __init microcode_init (void)
+static int microcode_init(void *opaque, struct module *module)
 {
+	struct microcode_ops *ops = (struct microcode_ops *)opaque;
 	int error;
 
-	printk(KERN_INFO
-		"IA-32 Microcode Update Driver: v" MICROCODE_VERSION " <tigran@aivazian.fsnet.co.uk>\n");
+	if (microcode_ops) {
+		printk(KERN_ERR "microcode: already loaded the other module\n");
+		return -EEXIST;
+	}
+
+	microcode_ops = ops;
 
 	error = microcode_dev_init();
 	if (error)
@@ -443,8 +447,15 @@ static int __init microcode_init (void)
 	}
 
 	register_hotcpu_notifier(&mc_cpu_notifier);
+
+	printk(KERN_INFO
+	       "Microcode Update Driver: v" MICROCODE_VERSION
+	       " <tigran@aivazian.fsnet.co.uk>"
+	       " <peter.oruba@amd.com>\n");
+
 	return 0;
 }
+EXPORT_SYMBOL_GPL(microcode_init);
 
 static void __exit microcode_exit (void)
 {
@@ -457,7 +468,10 @@ static void __exit microcode_exit (void)
 	put_online_cpus();
 
 	platform_device_unregister(microcode_pdev);
-}
 
-module_init(microcode_init)
-module_exit(microcode_exit)
+	microcode_ops = NULL;
+
+	printk(KERN_INFO
+	       "Microcode Update Driver: v" MICROCODE_VERSION " removed.\n");
+}
+EXPORT_SYMBOL_GPL(microcode_exit);
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index ca9861b..831db53 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -127,7 +127,7 @@ extern struct mutex microcode_mutex;
 
 extern struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
 
-void collect_cpu_info(int cpu_num)
+static void collect_cpu_info(int cpu_num)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
@@ -175,7 +175,7 @@ static inline int microcode_update_match(int cpu_num,
 	return 1;
 }
 
-int microcode_sanity_check(void *mc)
+static int microcode_sanity_check(void *mc)
 {
 	struct microcode_header_intel *mc_header = mc;
 	struct extended_sigtable *ext_header = NULL;
@@ -259,7 +259,7 @@ int microcode_sanity_check(void *mc)
  * return 1 - found update
  * return < 0 - error
  */
-int get_matching_microcode(void *mc, int cpu)
+static int get_matching_microcode(void *mc, int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	struct microcode_header_intel *mc_header = mc;
@@ -288,7 +288,8 @@ int get_matching_microcode(void *mc, int cpu)
 	return 0;
 find:
 	pr_debug("microcode: CPU%d found a matching microcode update with"
-		 " version 0x%x (current=0x%x)\n", cpu, mc_header->rev, uci->rev);
+		 " version 0x%x (current=0x%x)\n",
+		 cpu, mc_header->rev, uci->rev);
 	new_mc = vmalloc(total_size);
 	if (!new_mc) {
 		printk(KERN_ERR "microcode: error! Can not allocate memory\n");
@@ -303,7 +304,7 @@ find:
 	return 1;
 }
 
-void apply_microcode(int cpu)
+static void apply_microcode(int cpu)
 {
 	unsigned long flags;
 	unsigned int val[2];
@@ -347,7 +348,7 @@ void apply_microcode(int cpu)
 extern void __user *user_buffer;        /* user area microcode data buffer */
 extern unsigned int user_buffer_size;   /* it's size */
 
-long get_next_ucode(void **mc, long offset)
+static long get_next_ucode(void **mc, long offset)
 {
 	struct microcode_header_intel mc_header;
 	unsigned long total_size;
@@ -406,7 +407,7 @@ static long get_next_ucode_from_buffer(void **mc, const u8 *buf,
 /* fake device for request_firmware */
 extern struct platform_device *microcode_pdev;
 
-int cpu_request_microcode(int cpu)
+static int cpu_request_microcode(int cpu)
 {
 	char name[30];
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
@@ -455,7 +456,7 @@ int cpu_request_microcode(int cpu)
 	return error;
 }
 
-int apply_microcode_check_cpu(int cpu)
+static int apply_microcode_check_cpu(int cpu)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
@@ -504,13 +505,42 @@ int apply_microcode_check_cpu(int cpu)
 	return err;
 }
 
-void microcode_fini_cpu(int cpu)
+static void microcode_fini_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
 	mutex_lock(&microcode_mutex);
 	uci->valid = 0;
-	kfree(uci->mc.mc_intel);
+	vfree(uci->mc.mc_intel);
 	uci->mc.mc_intel = NULL;
 	mutex_unlock(&microcode_mutex);
 }
+
+static struct microcode_ops microcode_intel_ops = {
+	.get_next_ucode                   = get_next_ucode,
+	.get_matching_microcode           = get_matching_microcode,
+	.microcode_sanity_check           = microcode_sanity_check,
+	.apply_microcode_check_cpu        = apply_microcode_check_cpu,
+	.cpu_request_microcode            = cpu_request_microcode,
+	.collect_cpu_info                 = collect_cpu_info,
+	.apply_microcode                  = apply_microcode,
+	.microcode_fini_cpu               = microcode_fini_cpu,
+};
+
+static int __init microcode_intel_module_init(void)
+{
+	struct cpuinfo_x86 *c = &cpu_data(get_cpu());
+
+	if (c->x86_vendor == X86_VENDOR_INTEL)
+		return microcode_init(&microcode_intel_ops, THIS_MODULE);
+	else
+		return -ENODEV;
+}
+
+static void __exit microcode_intel_module_exit(void)
+{
+	microcode_exit();
+}
+
+module_init(microcode_intel_module_init)
+module_exit(microcode_intel_module_exit)
diff --git a/include/asm-x86/microcode.h b/include/asm-x86/microcode.h
index 9231c87..18b2aee 100644
--- a/include/asm-x86/microcode.h
+++ b/include/asm-x86/microcode.h
@@ -1,3 +1,6 @@
+extern int microcode_init(void *opaque, struct module *module);
+extern void microcode_exit(void);
+
 struct microcode_ops {
 	long (*get_next_ucode)(void **mc, long offset);
 	long (*microcode_get_next_ucode)(void **mc, long offset);
-- 
1.5.4.5




