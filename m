Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbZKSLbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbZKSLbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 06:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbZKSLbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 06:31:00 -0500
Received: from cantor.suse.de ([195.135.220.2]:47688 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZKSLa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 06:30:58 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Dave Jones <davej@redhat.com>
Subject: [PATCH] ACPI: do not define acpi_processor_get_bios_limit() in processor.h (snd ver)
Date: Thu, 19 Nov 2009 12:31:01 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.29-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alex Chiang <achiang@hp.com>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
References: <20091117220729.25933.57884.stgit@bob.kio> <20091117221125.25933.71150.stgit@bob.kio> <20091118000909.GB1855@redhat.com>
In-Reply-To: <20091118000909.GB1855@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911191231.02905.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 18 November 2009 01:09:09 Dave Jones wrote:
> On Tue, Nov 17, 2009 at 03:11:25PM -0700, Alex Chiang wrote:
>  > If we provide a definition for acpi_processor_get_bios_limit(), we will
>  > encounter build errors (multiple definitions of the function) when we
>  > do not have CONFIG_CPU_FREQ configured.
>  > 
>  > We've already changed the modules that depend on this function to only
>  > get built when CONFIG_CPU_FREQ is configured, so removing the definition
>  > when unconfigured is safe.
>  > 
>  > Cc: Thomas Renninger <trenn@suse.de>
>  > Cc: Len Brown <lenb@kernel.org>
>  > Signed-off-by: Alex Chiang <achiang@hp.com>
>  > ---
>  > 
>  >  include/acpi/processor.h |    5 -----
>  >  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> There's 2-3 other fixes pending for the bios_limit patch.
Alex removed the function that should have get
static inline and that looks like the right fix for two
mentioned problems.

> For now, I've dropped it from cpufreq.next, until Thomas sends
> a rediffed version with the compilation problems fixed.
Attached is my old version, merged with Alex's one.
Alex drops out as author of the fix by that, hope that's ok
with you.

I also added a build fix for powernow-k7 if:
# CONFIG_X86_POWERNOW_K7_ACPI is not set

Instead of always including acpi_processor.h, I added:
+#ifdef CONFIG_X86_POWERNOW_K7_ACPI
+       .bios_limit     = acpi_processor_get_bios_limit,
+#endif

Otherwise I could imagine you run into the next trouble if
you enable powernow-k7 (without acpi support) and remove
the acpi processor driver.

I test compiled the relevant cpufreq drivers on i386 with
cpufreq on/off and with CONFIG_X86_POWERNOW_K7_ACPI switched off.

I hope that was all?

Thanks,

    Thomas
---

ACPI/CPUFREQ: Introduce bios_limit per cpu cpufreq sysfs interface

This interface is mainly intended (and implemented) for ACPI _PPC BIOS
frequency limitations, but other cpufreq drivers can also use it for
similar use-cases.

Why is this needed:

Currently it's not obvious why cpufreq got limited.
People see cpufreq/scaling_max_freq reduced, but this could have
happened by:
  - any userspace prog writing to scaling_max_freq
  - thermal limitations
  - hardware (_PPC in ACPI case) limitiations

Therefore export bios_limit (in kHz) to:
  - Point the user that it's the BIOS (broken or intended) which limits
    frequency
  - Export it as a sysfs interface for userspace progs.
    While this was a rarely used feature on laptops, there will appear
    more and more server implemenations providing "Green IT" features like
    allowing the service processor to limit the frequency. People want
    to know about HW/BIOS frequency limitations.

All ACPI P-state driven cpufreq drivers are covered with this patch:
  - powernow-k8
  - powernow-k7
  - acpi-cpufreq

Tested with a patched DSDT which limits the first two cores (_PPC returns 1)
via _PPC, exposed by bios_limit:
# echo 2200000 >cpu2/cpufreq/scaling_max_freq
# cat cpu*/cpufreq/scaling_max_freq
2600000
2600000
2200000
2200000
# #scaling_max_freq shows general user/thermal/BIOS limitations

# cat cpu*/cpufreq/bios_limit
2600000
2600000
2800000
2800000
# #bios_limit only shows the HW/BIOS limitation

CC: Pallipadi Venkatesh <venkatesh.pallipadi@intel.com>
CC: Len Brown <lenb@kernel.org>
CC: davej@codemonkey.org.uk
CC: linux@dominikbrodowski.net

Signed-off-by: Thomas Renninger <trenn@suse.de>

diff --git a/Documentation/cpu-freq/user-guide.txt b/Documentation/cpu-freq/user-guide.txt
index 2a5b850..eeb958b 100644
--- a/Documentation/cpu-freq/user-guide.txt
+++ b/Documentation/cpu-freq/user-guide.txt
@@ -203,6 +203,17 @@ scaling_cur_freq :		Current frequency of the CPU as determined by
 				the frequency the kernel thinks the CPU runs
 				at.
 
+bios_limit :			If the BIOS tells the OS to limit a CPU to
+				lower frequencies, the user can read out the
+				maximum available frequency from this file.
+				This typically can happen through (often not
+				intended) BIOS settings, restrictions
+				triggered through a service processor or other
+				BIOS/HW based implementations.
+				This does not cover thermal ACPI limitations
+				which can be detected through the generic
+				thermal driver.
+				
 If you have selected the "userspace" governor which allows you to
 set the CPU operating frequency to a specific value, you can read out
 the current frequency in
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 8b581d3..d2e7c77 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -764,14 +764,15 @@ static struct freq_attr *acpi_cpufreq_attr[] = {
 };
 
 static struct cpufreq_driver acpi_cpufreq_driver = {
-	.verify = acpi_cpufreq_verify,
-	.target = acpi_cpufreq_target,
-	.init = acpi_cpufreq_cpu_init,
-	.exit = acpi_cpufreq_cpu_exit,
-	.resume = acpi_cpufreq_resume,
-	.name = "acpi-cpufreq",
-	.owner = THIS_MODULE,
-	.attr = acpi_cpufreq_attr,
+	.verify		= acpi_cpufreq_verify,
+	.target		= acpi_cpufreq_target,
+	.bios_limit	= acpi_processor_get_bios_limit,
+	.init		= acpi_cpufreq_cpu_init,
+	.exit		= acpi_cpufreq_cpu_exit,
+	.resume		= acpi_cpufreq_resume,
+	.name		= "acpi-cpufreq",
+	.owner		= THIS_MODULE,
+	.attr		= acpi_cpufreq_attr,
 };
 
 static int __init acpi_cpufreq_init(void)
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
index d47c775..9a97116 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
@@ -714,14 +714,17 @@ static struct freq_attr *powernow_table_attr[] = {
 };
 
 static struct cpufreq_driver powernow_driver = {
-	.verify	= powernow_verify,
-	.target	= powernow_target,
-	.get	= powernow_get,
-	.init	= powernow_cpu_init,
-	.exit	= powernow_cpu_exit,
-	.name	= "powernow-k7",
-	.owner	= THIS_MODULE,
-	.attr	= powernow_table_attr,
+	.verify		= powernow_verify,
+	.target		= powernow_target,
+	.get		= powernow_get,
+#ifdef CONFIG_X86_POWERNOW_K7_ACPI
+	.bios_limit	= acpi_processor_get_bios_limit,
+#endif
+	.init		= powernow_cpu_init,
+	.exit		= powernow_cpu_exit,
+	.name		= "powernow-k7",
+	.owner		= THIS_MODULE,
+	.attr		= powernow_table_attr,
 };
 
 static int __init powernow_init(void)
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index f30d253..a9df944 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1398,14 +1398,15 @@ static struct freq_attr *powernow_k8_attr[] = {
 };
 
 static struct cpufreq_driver cpufreq_amd64_driver = {
-	.verify = powernowk8_verify,
-	.target = powernowk8_target,
-	.init = powernowk8_cpu_init,
-	.exit = __devexit_p(powernowk8_cpu_exit),
-	.get = powernowk8_get,
-	.name = "powernow-k8",
-	.owner = THIS_MODULE,
-	.attr = powernow_k8_attr,
+	.verify		= powernowk8_verify,
+	.target		= powernowk8_target,
+	.bios_limit	= acpi_processor_get_bios_limit,
+	.init		= powernowk8_cpu_init,
+	.exit		= __devexit_p(powernowk8_cpu_exit),
+	.get		= powernowk8_get,
+	.name		= "powernow-k8",
+	.owner		= THIS_MODULE,
+	.attr		= powernow_k8_attr,
 };
 
 /* driver entry point for init */
diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 8ba0ed0..6b4be59 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -167,6 +167,19 @@ int acpi_processor_ppc_has_changed(struct acpi_processor *pr)
 		return cpufreq_update_policy(pr->id);
 }
 
+int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
+{
+	struct acpi_processor *pr;
+	
+	pr = per_cpu(processors, cpu);
+	if (!pr || !pr->performance || !pr->performance->state_count)
+		return -ENODEV;
+	*limit = pr->performance->states[pr->performance_platform_limit].
+		core_frequency * 1000;
+	return 0;
+}
+EXPORT_SYMBOL(acpi_processor_get_bios_limit);
+
 void acpi_processor_ppc_init(void)
 {
 	if (!cpufreq_register_notifier
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 5b9b1c8..f20668c 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -647,6 +647,21 @@ static ssize_t show_scaling_setspeed(struct cpufreq_policy *policy, char *buf)
 	return policy->governor->show_setspeed(policy, buf);
 }
 
+/**
+ * show_scaling_driver - show the current cpufreq HW/BIOS limitation
+ */
+static ssize_t show_bios_limit(struct cpufreq_policy *policy, char *buf)
+{
+	unsigned int limit;
+	int ret;
+	if (cpufreq_driver->bios_limit) {
+		ret = cpufreq_driver->bios_limit(policy->cpu, &limit);
+		if (!ret)
+			return sprintf(buf, "%u\n", limit);
+	}
+	return sprintf(buf, "%u\n", policy->cpuinfo.max_freq);
+}
+
 #define define_one_ro(_name) \
 static struct freq_attr _name = \
 __ATTR(_name, 0444, show_##_name, NULL)
@@ -666,6 +681,7 @@ define_one_ro(cpuinfo_transition_latency);
 define_one_ro(scaling_available_governors);
 define_one_ro(scaling_driver);
 define_one_ro(scaling_cur_freq);
+define_one_ro(bios_limit);
 define_one_ro(related_cpus);
 define_one_ro(affected_cpus);
 define_one_rw(scaling_min_freq);
@@ -905,6 +921,11 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 		if (ret)
 			goto err_out_kobj_put;
 	}
+	if (cpufreq_driver->bios_limit) {
+		ret = sysfs_create_file(&policy->kobj, &bios_limit.attr);
+		if (ret)
+			goto err_out_kobj_put;
+	}
 
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus) {
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 740ac3a..8b668ea 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -295,6 +295,7 @@ static inline void acpi_processor_ffh_cstate_enter(struct acpi_processor_cx
 void acpi_processor_ppc_init(void);
 void acpi_processor_ppc_exit(void);
 int acpi_processor_ppc_has_changed(struct acpi_processor *pr);
+extern int acpi_processor_get_bios_limit(int cpu, unsigned int *limit);
 #else
 static inline void acpi_processor_ppc_init(void)
 {
@@ -316,6 +317,11 @@ static inline int acpi_processor_ppc_has_changed(struct acpi_processor *pr)
 	}
 	return 0;
 }
+static inline int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
+{
+	return -ENODEV;
+}
+
 #endif				/* CONFIG_CPU_FREQ */
 
 /* in processor_throttling.c */
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 79a2340..4de02b1 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -232,6 +232,7 @@ struct cpufreq_driver {
 	/* optional */
 	unsigned int (*getavg)	(struct cpufreq_policy *policy,
 				 unsigned int cpu);
+	int	(*bios_limit)	(int cpu, unsigned int *limit);
 
 	int	(*exit)		(struct cpufreq_policy *policy);
 	int	(*suspend)	(struct cpufreq_policy *policy, pm_message_t pmsg);

