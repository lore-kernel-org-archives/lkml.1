Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab0CCASw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:18:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:20201 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab0CCASj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:18:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,570,1262592000"; 
   d="scan'208";a="600719590"
Message-Id: <20100303000849.278509000@intel.com>
References: <20100303000649.757684000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 02 Mar 2010 16:06:51 -0800
From: venkatesh.pallipadi@intel.com
To: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 2/2] x86: Manage ENERGY_PERF_BIAS based on cpufreq governor
Content-Disposition: inline; filename=0002-x86-Driver-to-manage-ENERGY_PERF_BIAS-based-on-cpuf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manage IA32_ENERGY_PERF_BIAS setting.

By default, this driver sets IA32_ENERGY_PERF_BIAS as follows
0 when cpufreq performance governor is being used
15 when cpufreq powersave governor is being used
7 otherwise

There is an option to disable setting IA32_ENERGY_PERF_BIAS using
epb=disable boot option.
There is an option to manual override IA32_ENERGY_PERF_BIAS using
epb=<0..15> where user set energy_perf_bias value will be set,
irrespective of cpufreq governor.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 Documentation/kernel-parameters.txt            |    4 +
 arch/x86/kernel/cpu/cpufreq/Kconfig            |    6 +
 arch/x86/kernel/cpu/cpufreq/Makefile           |    1 +
 arch/x86/kernel/cpu/cpufreq/energy_perf_bias.c |  186 ++++++++++++++++++++++++
 4 files changed, 197 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/cpufreq/energy_perf_bias.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 8c666d8..4945add 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -749,6 +749,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			Default value is 0.
 			Value can be changed at runtime via /selinux/enforce.
 
+	epb		[X86] Control IA32_ENERGY_PERF_BIAS setting
+			"disable" - Kernel will not modify this MSR
+			<0..15> - Kernel will set this MSR to i/p static value
+
 	ether=		[HW,NET] Ethernet cards parameters
 			This option is obsoleted by the "netdev=" option, which
 			has equivalent usage. See its documentation for details.
diff --git a/arch/x86/kernel/cpu/cpufreq/Kconfig b/arch/x86/kernel/cpu/cpufreq/Kconfig
index f138c6c..1addc05 100644
--- a/arch/x86/kernel/cpu/cpufreq/Kconfig
+++ b/arch/x86/kernel/cpu/cpufreq/Kconfig
@@ -26,6 +26,12 @@ config X86_ACPI_CPUFREQ
 
 	  If in doubt, say N.
 
+config X86_ENERGY_PERF_BIAS
+	def_bool y
+	depends on X86_ACPI_CPUFREQ
+	help
+	  Support for x86 Intel ENERGY_PERF_BIAS MSR
+
 config ELAN_CPUFREQ
 	tristate "AMD Elan SC400 and SC410"
 	select CPU_FREQ_TABLE
diff --git a/arch/x86/kernel/cpu/cpufreq/Makefile b/arch/x86/kernel/cpu/cpufreq/Makefile
index 509296d..5290428 100644
--- a/arch/x86/kernel/cpu/cpufreq/Makefile
+++ b/arch/x86/kernel/cpu/cpufreq/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_X86_SPEEDSTEP_SMI)		+= speedstep-smi.o
 obj-$(CONFIG_X86_SPEEDSTEP_CENTRINO)	+= speedstep-centrino.o
 obj-$(CONFIG_X86_P4_CLOCKMOD)		+= p4-clockmod.o
 obj-$(CONFIG_X86_CPUFREQ_NFORCE2)	+= cpufreq-nforce2.o
+obj-$(CONFIG_X86_ENERGY_PERF_BIAS)	+= energy_perf_bias.o
diff --git a/arch/x86/kernel/cpu/cpufreq/energy_perf_bias.c b/arch/x86/kernel/cpu/cpufreq/energy_perf_bias.c
new file mode 100644
index 0000000..2bd4e74
--- /dev/null
+++ b/arch/x86/kernel/cpu/cpufreq/energy_perf_bias.c
@@ -0,0 +1,186 @@
+/*
+ * x86 IA32_ENERGY_PERF_BIAS MSR driver
+ * This MSR lets software set a Energy Performance Preference, which
+ * can then be used by hardware to make Energy Performance tradeoffs.
+ */
+
+#include <linux/cpu.h>
+#include <linux/init.h>
+#include <linux/ctype.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/cpufreq.h>
+
+#include <asm/msr.h>
+#include <asm/system.h>
+#include <asm/processor.h>
+
+#define ENERGY_PERF_BIAS_BITS		0xff
+
+#define ENERGY_PERF_BIAS_INVALID	(-1)
+#define ENERGY_PERF_BIAS_PERF		0
+#define ENERGY_PERF_BIAS_ONDEMAND	7
+#define ENERGY_PERF_BIAS_POWER		15
+
+static int epb_override = ENERGY_PERF_BIAS_INVALID; /* User bias override */
+static int epb_disable; /* User disable option */
+
+#define is_epb_override_set() (epb_override != ENERGY_PERF_BIAS_INVALID)
+
+/*
+ * epb=disable
+ * Kernel will not touch ENERGY_PERF_BIAS
+ *
+ * epb=<0..15>
+ * Kernel will leave ENERGY_PERF_BIAS at user specified value, independent of
+ * cpufreq policy
+ *
+ * Default is to change ENERGY_PERF_BIAS based on cpufreq governor
+ */
+static int __init epb_setup(char *str)
+{
+	if (str) {
+		if (!strncmp("disable", str, 7)) {
+			epb_disable = 1;
+		} else if (isdigit(*str)) {
+			unsigned long val;
+			val = (uint) simple_strtoul(str, NULL, 0);
+			if (val >= ENERGY_PERF_BIAS_PERF &&
+			    val <= ENERGY_PERF_BIAS_POWER) {
+				epb_override = (uint) val;
+			}
+		}
+	}
+	return 0;
+}
+__setup("epb=", epb_setup);
+
+static void set_epb_on_cpu(int val, int cpu)
+{
+	val &= ENERGY_PERF_BIAS_BITS;
+	wrmsr_safe_on_cpu(cpu, MSR_IA32_ENERGY_PERF_BIAS, val, 0);
+}
+
+/* Policy notifier to hook into cpufreq policy updates */
+static int epb_policy_notifier(struct notifier_block *nb, unsigned long val,
+				void *data)
+{
+	int cpu;
+	int epb_val;
+	struct cpufreq_policy *policy = data;
+	struct cpufreq_governor *gov;
+
+	if (val != CPUFREQ_NOTIFY)
+		return 0;
+
+	if (!policy || !policy->governor)
+		return 0;
+
+	cpu = policy->cpu;
+	gov = policy->governor;
+
+	if (!strncmp(gov->name, "performance", strlen("performance")))
+		epb_val = ENERGY_PERF_BIAS_PERF;
+	else if (!strncmp(gov->name, "powersave", strlen("powersave")))
+		epb_val = ENERGY_PERF_BIAS_POWER;
+	else
+		epb_val = ENERGY_PERF_BIAS_ONDEMAND;
+
+	set_epb_on_cpu(epb_val, cpu);
+	return 0;
+}
+
+static struct notifier_block policy_nb = {
+        .notifier_call = epb_policy_notifier,
+};
+
+static void epb_cpu_online(int cpu)
+{
+	set_epb_on_cpu(epb_override, cpu);
+}
+
+/* Resume notifier to update the MSR on boot CPU on resume */
+static int epb_resume(struct sys_device *sys_dev)
+{
+        unsigned int cpu = sys_dev->id;
+
+	if (cpu != 0)
+		return 0;
+
+	epb_cpu_online(cpu);
+	return 0;
+}
+
+static struct sysdev_driver epb_sysdev_driver = {
+        .resume        = epb_resume,
+};
+
+/* Online notifier to update the MSR on all non-boot CPU on resume and online */
+static int __cpuinit epb_cpu_notifier(struct notifier_block *nfb,
+					unsigned long action, void *hcpu)
+{
+	int cpu = (long)hcpu;
+
+	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN)
+		epb_cpu_online(cpu);
+
+	return 0;
+}
+
+static struct notifier_block cpu_nb = {
+	.notifier_call = epb_cpu_notifier,
+};
+
+
+static int __init epb_init(void)
+{
+	int ret;
+	int cpu;
+
+	if (!boot_cpu_has(X86_FEATURE_EPB) || epb_disable) {
+		ret = -ENODEV;
+		goto err;
+	}
+
+	if (!is_epb_override_set()) {
+		ret = cpufreq_register_notifier(&policy_nb,
+						CPUFREQ_POLICY_NOTIFIER);
+		goto err;
+	} else {
+		ret = sysdev_driver_register(&cpu_sysdev_class,
+						&epb_sysdev_driver);
+		if (ret)
+			goto err;
+
+		ret = register_cpu_notifier(&cpu_nb);
+		if (ret)
+			goto err_sysdev_driver;
+
+		for_each_online_cpu(cpu)
+			set_epb_on_cpu(epb_override, cpu);
+	}
+	return 0;
+
+err_sysdev_driver:
+	sysdev_driver_unregister(&cpu_sysdev_class, &epb_sysdev_driver);
+err:
+	return ret;
+}
+
+static void __exit epb_exit(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_EPB) || epb_disable)
+		return;
+
+	if (!is_epb_override_set()) {
+		cpufreq_unregister_notifier(&policy_nb,
+						CPUFREQ_POLICY_NOTIFIER);
+	} else {
+		sysdev_driver_unregister(&cpu_sysdev_class, &epb_sysdev_driver);
+		unregister_cpu_notifier(&cpu_nb);
+	}
+}
+
+__initcall(epb_init);
+__exitcall(epb_exit);
-- 
1.6.0.6

-- 

