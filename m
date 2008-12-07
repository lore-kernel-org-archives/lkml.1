Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbYLGPzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbYLGPzr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 10:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbYLGPz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 10:55:27 -0500
Received: from gate.compton.nu ([217.169.19.106]:52366 "EHLO
	gosford.compton.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbYLGPzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 10:55:24 -0500
Message-ID: <493BF1D4.7090602@compton.nu>
Date: Sun, 07 Dec 2008 15:55:00 +0000
From: Tom Hughes <tom@compton.nu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Thomas Renninger <trenn@suse.de>,
       Cristiano Prisciandaro <cristiano.p@solnet.ch>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
References: <1227454026.7262.59.camel@localhost> <492A7632.4040106@compton.nu> <4936DD78.4090501@compton.nu> <200812040257.09099.trenn@suse.de> <4939B3C3.8060205@compton.nu> <20081206163539.GB7623@srcf.ucam.org>
In-Reply-To: <20081206163539.GB7623@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.6 (--)
X-Spam-Report: Spam detection software, running on the system "gosford.compton.nu", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Matthew Garrett wrote: > It appears to be implemented in the
	900 and 901 BIOSes as well, so some > kind of limitation is probably needed.
	The best approach would probably > to check whether the CPU has the EST flag.
	Just do something like: > > struct cpuinfo_x86 *cpu = &cpu_data(policy->cpu);
	> > if (cpu->x86_vendor != X86_VENDOR_INTEL || cpu_has(cpu, X86_FEATURE_EST))
	> return -ENODEV > > at the top of the cpufreq init code. That way you'll
	refuse to bind on > anything that implements speedstep and acpi-cpufreq can
	be used instead. [...] 
	Content analysis details:   (-2.6 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-0.0 NO_RELAYS              Informational: message was not relayed via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:

> It appears to be implemented in the 900 and 901 BIOSes as well, so some 
> kind of limitation is probably needed. The best approach would probably 
> to check whether the CPU has the EST flag. Just do something like:
> 
> struct cpuinfo_x86 *cpu = &cpu_data(policy->cpu);
> 
> if (cpu->x86_vendor != X86_VENDOR_INTEL || cpu_has(cpu, X86_FEATURE_EST))
> 	return -ENODEV
> 
> at the top of the cpufreq init code. That way you'll refuse to bind on 
> anything that implements speedstep and acpi-cpufreq can be used instead.

Sounds like a good idea - here's a new version with that check added:

--- kmod-eeepc-laptop-2.6.28rc5/eeepc-laptop.c	2008-11-20 09:24:41.000000000 +0000
+++ kmod-eeepc-laptop-cpufreq/eeepc-laptop.c	2008-12-07 15:54:07.000000000 +0000
@@ -25,6 +25,7 @@
 #include <linux/fb.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
+#include <linux/cpufreq.h>
 #include <acpi/acpi_drivers.h>
 #include <acpi/acpi_bus.h>
 #include <linux/uaccess.h>
@@ -731,6 +732,118 @@
 };
 
 /*
+ * Cpufreq
+ *
+ * Based on work by Cristiano P. <cris69@solnet.ch>
+ */
+static struct cpufreq_frequency_table eeepc_cpufreq_table[] = {
+       {0, 630000},
+       {1, 900000},
+       {0, CPUFREQ_TABLE_END}
+};
+
+static unsigned int eeepc_cpufreq_get(unsigned int cpu)
+{
+	switch (get_acpi(CM_ASL_CPUFV)) {
+	case 0x200:
+		return 900000;
+	case 0x201:
+		return 630000;
+	}
+
+	return 0;
+}
+
+static void eeepc_cpufreq_set(unsigned int frequency)
+{
+	struct cpufreq_freqs freqs;
+
+	freqs.cpu = 0;
+	freqs.old = eeepc_cpufreq_get(0);
+	freqs.new = frequency;
+
+	cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
+
+	switch (frequency) {
+	case 900000:
+		set_acpi(CM_ASL_CPUFV, 0);
+		break;
+	case 630000:
+		set_acpi(CM_ASL_CPUFV, 1);
+		break;
+	}
+
+	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
+
+	return;
+}
+
+static int eeepc_cpufreq_verify(struct cpufreq_policy *policy)
+{
+	return cpufreq_frequency_table_verify(policy, eeepc_cpufreq_table);
+}
+
+static int eeepc_cpufreq_target (struct cpufreq_policy *policy,
+				 unsigned int target_freq,
+				 unsigned int relation)
+{
+	unsigned int newstate = 0;
+
+	if (cpufreq_frequency_table_target(policy, eeepc_cpufreq_table,
+					   target_freq, relation, &newstate))
+		return -EINVAL;
+
+	eeepc_cpufreq_set(eeepc_cpufreq_table[newstate].frequency);
+
+	return 0;
+}
+
+static int eeepc_cpufreq_cpu_init(struct cpufreq_policy *policy)
+{
+	struct cpuinfo_x86 *cpu = &cpu_data(policy->cpu);
+
+	/* Defer to acpi-cpufreq if this CPU has SpeedStep support */
+	if (cpu->x86_vendor != X86_VENDOR_INTEL || cpu_has(cpu, X86_FEATURE_EST))
+		return -ENODEV;
+
+	if (get_acpi(CM_ASL_CPUFV) < 0)
+		return -ENODEV;
+
+	policy->cpuinfo.transition_latency = 1000000;
+	policy->cur = eeepc_cpufreq_get(policy->cpu);
+
+	if (cpufreq_frequency_table_cpuinfo(policy, eeepc_cpufreq_table))
+		return -EINVAL;
+
+	cpufreq_frequency_table_get_attr(eeepc_cpufreq_table, policy->cpu);
+
+	return 0;
+}
+
+static int eeepc_cpufreq_cpu_exit(struct cpufreq_policy *policy)
+{
+	cpufreq_frequency_table_put_attr(policy->cpu);
+
+	return 0;
+}
+
+static struct freq_attr *eeepc_cpufreq_attr[] = {
+	&cpufreq_freq_attr_scaling_available_freqs,
+	NULL,
+};
+
+static struct cpufreq_driver eeepc_cpufreq_driver = {
+	.verify         = eeepc_cpufreq_verify,
+	.target         = eeepc_cpufreq_target,
+	.init           = eeepc_cpufreq_cpu_init,
+	.exit           = eeepc_cpufreq_cpu_exit,
+	.get            = eeepc_cpufreq_get,
+	.name           = "eeepc",
+	.owner          = THIS_MODULE,
+	.attr           = eeepc_cpufreq_attr,
+};
+
+/*
  * exit/init
  */
 static void eeepc_backlight_exit(void)
@@ -759,10 +872,16 @@
 	eeepc_hwmon_device = NULL;
 }
 
+static void eeepc_cpufreq_exit(void)
+{
+	cpufreq_unregister_driver(&eeepc_cpufreq_driver);
+}
+
 static void __exit eeepc_laptop_exit(void)
 {
 	eeepc_backlight_exit();
 	eeepc_hwmon_exit();
+	eeepc_cpufreq_exit();
 	acpi_bus_unregister_driver(&eeepc_hotk_driver);
 	sysfs_remove_group(&platform_device->dev.kobj,
 			   &platform_attribute_group);
@@ -810,6 +929,11 @@
 	return result;
 }
 
+static int eeepc_cpufreq_init(struct device *dev)
+{
+	return cpufreq_register_driver(&eeepc_cpufreq_driver);
+}
+
 static int __init eeepc_laptop_init(void)
 {
 	struct device *dev;
@@ -837,6 +961,9 @@
 	result = eeepc_hwmon_init(dev);
 	if (result)
 		goto fail_hwmon;
+	result = eeepc_cpufreq_init(dev);
+	if (result)
+		goto fail_cpufreq;
 	/* Register platform stuff */
 	result = platform_driver_register(&platform_driver);
 	if (result)
@@ -861,6 +988,8 @@
 fail_platform_device1:
 	platform_driver_unregister(&platform_driver);
 fail_platform_driver:
+	eeepc_cpufreq_exit();
+fail_cpufreq:
 	eeepc_hwmon_exit();
 fail_hwmon:
 	eeepc_backlight_exit();


Tom

-- 
Tom Hughes (tom@compton.nu)
http://www.compton.nu/
