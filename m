Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbYKWPim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbYKWPim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 10:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758508AbYKWPiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 10:38:21 -0500
Received: from mail04.solnet.ch ([212.101.4.138]:53309 "EHLO mail04.solnet.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758206AbYKWPiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 10:38:18 -0500
X-Greylist: delayed 667 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Nov 2008 10:38:17 EST
Subject: [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
From: Cristiano Prisciandaro <cristiano.p@solnet.ch>
To: Dave Jones <davej@redhat.com>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
X-Sieve: CMU Sieve 2.2
X-Spam-Flag: NO
X-Spam-Score: -0.832
Content-Type: text/plain
Date: Sun, 23 Nov 2008 16:27:06 +0100
Message-Id: <1227454026.7262.59.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cristiano Prisciandaro <cristiano.p@solnet.ch>

The bios of the eeepc 900 exposes an acpi method that allows clocking
the cpu to 630/900 MHz. This driver allows controlling the frequency
switch through the cpufreq subsystem.

Signed-off-by: Cristiano Prisciandaro <cristiano.p@solnet.ch>

---

diff -uprN -X linux-2.6.vanilla/Documentation/dontdiff linux-2.6.vanilla/arch/x86/kernel/cpu/cpufreq/eee900freq.c linux-2.6/arch/x86/kernel/cpu/cpufreq/eee900freq.c
--- linux-2.6.vanilla/arch/x86/kernel/cpu/cpufreq/eee900freq.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/eee900freq.c	2008-11-23 15:06:56.000000000 +0100
@@ -0,0 +1,232 @@
+/*
+ * Experimental cpu frequency scaling driver for the eeepc 900
+ *
+ * Copyright (C) 2008  Cristiano Prisciandaro <cristiano.p@solnet.ch>
+ *
+ * This driver is based on the (experimental) finding that the
+ * eeepc bios exposes a method to underclock the bus/cpu.
+ *
+ * It seems to work fine with the following BIOS versions:
+ * 0501, 0601, 0704 and 0802.
+ *
+ * Parts of this code are from
+ *  asus_acpi.c Copyright (C) Julien Lerouge, Karol Kozimor
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * BIG FAT DISCLAIMER: experimental code. Possibly *dangerous*
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/cpufreq.h>
+#include <linux/cpufreq.h>
+#include <acpi/acpi_drivers.h>
+#include <acpi/acpi_bus.h>
+
+#define MNAME                    "eee900freq:"
+#define ASUS_HOTK_PREFIX         "\\_SB.ATKD"
+#define ASUS_CPUFV_READ_METHOD   "CFVG"
+#define ASUS_CPUFV_WRITE_METHOD  "CFVS"
+
+static acpi_handle handle;
+static unsigned int cpufreq_eee900_get(unsigned int cpu);
+
+/* available frequencies */
+static struct cpufreq_frequency_table eee900freq_table[] = {
+	{0, 630000},
+	{1, 900000},
+	{0, CPUFREQ_TABLE_END}
+};
+
+struct eee900_acpi_value {
+	int frequency;
+	int value;
+};
+
+static struct eee900_acpi_value eee900_acpi_values_table[] = {
+	{630000, 1},
+	{900000, 0}
+};
+
+/* read from the acpi handle (from asus_acpi.c) */
+static int read_eee900_acpi_int(acpi_handle handle, const char *method,
+				int *val)
+{
+	struct acpi_buffer output;
+	union acpi_object out_obj;
+	acpi_status status;
+
+	output.length = sizeof(out_obj);
+	output.pointer = &out_obj;
+	status = acpi_evaluate_object(handle, (char *)method, NULL, &output);
+	*val = out_obj.integer.value;
+	return status == AE_OK && out_obj.type == ACPI_TYPE_INTEGER;
+}
+
+/* write to the acpi handle (from asus_acpi.c) */
+static int write_eee900_acpi_int(acpi_handle handle, const char *method,
+				 int val, struct acpi_buffer *output)
+{
+	struct acpi_object_list params;
+	union acpi_object in_obj;
+	acpi_status status;
+
+	params.count = 1;
+	params.pointer = &in_obj;
+	in_obj.type = ACPI_TYPE_INTEGER;
+	in_obj.integer.value = val;
+	status = acpi_evaluate_object(handle, (char *)method, &params, output);
+	return status == AE_OK;
+}
+
+/* return the current frequency as in acpi */
+static unsigned int cpufreq_eee900_get(unsigned int cpu)
+{
+	int value;
+
+	if (!read_eee900_acpi_int(handle, ASUS_CPUFV_READ_METHOD, &value)) {
+		printk(KERN_WARNING MNAME
+		       "unable to read current frequency from "
+		       ASUS_CPUFV_READ_METHOD "\n");
+		return -EINVAL;
+	}
+
+	switch (value) {
+	case 0x200:
+		return 900000;
+	case 0x201:
+		return 630000;
+	}
+
+	return 0;
+}
+
+static void cpufreq_eee900_set_freq(unsigned int index)
+{
+	struct cpufreq_freqs freqs;
+
+	freqs.old = cpufreq_eee900_get(0);
+	freqs.new = eee900freq_table[index].frequency;
+	freqs.cpu = 0;
+
+	cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
+
+	if (!write_eee900_acpi_int(handle, ASUS_CPUFV_WRITE_METHOD,
+				   eee900_acpi_values_table[index].value, NULL))
+		printk(KERN_WARNING "unable to set new frequency: val=%x",
+		       eee900_acpi_values_table[index].value);
+
+	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
+
+	return;
+}
+
+static int cpufreq_eee900_target(struct cpufreq_policy *policy,
+				 unsigned int target_freq,
+				 unsigned int relation)
+{
+	unsigned int newstate = 0;
+
+	if (cpufreq_frequency_table_target
+	    (policy, &eee900freq_table[0], target_freq, relation, &newstate))
+		return -EINVAL;
+
+	cpufreq_eee900_set_freq(newstate);
+
+	return 0;
+}
+
+static int cpufreq_eee900_cpu_init(struct cpufreq_policy *policy)
+{
+
+	unsigned int cfreq;
+
+	cfreq = cpufreq_eee900_get(policy->cpu);
+
+	cpufreq_frequency_table_get_attr(eee900freq_table, policy->cpu);
+
+	/* cpuinfo and default policy values */
+	policy->cpuinfo.transition_latency = 1000000;	/* assumed */
+	policy->cur = cfreq;
+
+	return cpufreq_frequency_table_cpuinfo(policy, &eee900freq_table[0]);
+}
+
+static int cpufreq_eee900_cpu_exit(struct cpufreq_policy *policy)
+{
+	cpufreq_frequency_table_put_attr(policy->cpu);
+	return 0;
+}
+
+static int cpufreq_eee900_verify(struct cpufreq_policy *policy)
+{
+	return cpufreq_frequency_table_verify(policy, &eee900freq_table[0]);
+}
+
+static struct freq_attr *eee900freq_attr[] = {
+	&cpufreq_freq_attr_scaling_available_freqs,
+	NULL,
+};
+
+static struct cpufreq_driver eee900freq_driver = {
+	.verify	= cpufreq_eee900_verify,
+	.target	= cpufreq_eee900_target,
+	.init	= cpufreq_eee900_cpu_init,
+	.exit	= cpufreq_eee900_cpu_exit,
+	.get	= cpufreq_eee900_get,
+	.name	= "eee900freq",
+	.owner	= THIS_MODULE,
+	.attr	= eee900freq_attr,
+};
+
+static int __init cpufreq_eee900_init(void)
+{
+	struct cpuinfo_x86 *c = &cpu_data(0);
+	acpi_status status;
+	int ret;
+	int test;
+
+	if (c->x86_vendor != X86_VENDOR_INTEL)
+		return -ENODEV;
+
+	status = acpi_get_handle(NULL, ASUS_HOTK_PREFIX, &handle);
+
+	if (ACPI_FAILURE(status)) {
+		printk(KERN_INFO MNAME "unable to get acpi handle.\n");
+		handle = NULL;
+		return -ENODEV;
+	}
+
+	/* check if the control method is supported */
+	if (!read_eee900_acpi_int(handle, ASUS_CPUFV_READ_METHOD, &test)) {
+		printk(KERN_INFO "Get control method test failed\n");
+		return -ENODEV;
+	}
+
+	ret = cpufreq_register_driver(&eee900freq_driver);
+
+	if (!ret)
+		printk(KERN_INFO MNAME
+		       "CPU frequency scaling driver for the eeepc 900.\n");
+
+	return ret;
+}
+
+static void __exit cpufreq_eee900_exit(void)
+{
+	cpufreq_unregister_driver(&eee900freq_driver);
+	printk(KERN_INFO MNAME
+	       "CPU frequency scaling driver for the eeepc 900 unregistered.\n");
+}
+
+module_init(cpufreq_eee900_init);
+module_exit(cpufreq_eee900_exit);
+
+MODULE_AUTHOR("Cristiano Prisciandaro <cristiano.p@solnet.ch>");
+MODULE_DESCRIPTION("Frequency scaling driver for the eeepc 900.");
+MODULE_LICENSE("GPL");
diff -uprN -X linux-2.6.vanilla/Documentation/dontdiff linux-2.6.vanilla/arch/x86/kernel/cpu/cpufreq/Kconfig linux-2.6/arch/x86/kernel/cpu/cpufreq/Kconfig
--- linux-2.6.vanilla/arch/x86/kernel/cpu/cpufreq/Kconfig	2008-11-21 00:19:22.000000000 +0100
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/Kconfig	2008-11-23 12:24:47.000000000 +0100
@@ -243,6 +243,15 @@ config X86_E_POWERSAVER
 
 	  If in doubt, say N.
 
+config X86_CPUFREQ_EEEPC900
+	tristate "Eeepc 900 ACPI frequency scaling driver"
+	select CPU_FREQ_TABLE
+	depends on ACPI && X86_32 && EXPERIMENTAL
+	help
+	  This adds the CPUFreq driver for the eeepc 900.
+
+	  If in doubt, say N.
+
 comment "shared options"
 
 config X86_ACPI_CPUFREQ_PROC_INTF
diff -uprN -X linux-2.6.vanilla/Documentation/dontdiff linux-2.6.vanilla/arch/x86/kernel/cpu/cpufreq/Makefile linux-2.6/arch/x86/kernel/cpu/cpufreq/Makefile
--- linux-2.6.vanilla/arch/x86/kernel/cpu/cpufreq/Makefile	2008-11-21 00:19:22.000000000 +0100
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/Makefile	2008-11-23 12:24:53.000000000 +0100
@@ -14,3 +14,4 @@ obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-
 obj-$(CONFIG_X86_SPEEDSTEP_CENTRINO)	+= speedstep-centrino.o
 obj-$(CONFIG_X86_P4_CLOCKMOD)		+= p4-clockmod.o
 obj-$(CONFIG_X86_CPUFREQ_NFORCE2)	+= cpufreq-nforce2.o
+obj-$(CONFIG_X86_CPUFREQ_EEEPC900)	+= eee900freq.o



