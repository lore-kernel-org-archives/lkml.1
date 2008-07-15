Return-Path: <linux-kernel-owner+w=401wt.eu-S1762085AbYGOCjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762085AbYGOCjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761124AbYGOCfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:35:07 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:15623 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761158AbYGOCe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:34:56 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 14/14] ACPI: Provide /sys/devices/system/cpu/cpuN/deconfigure
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Alex Chiang <achiang@hp.com>,
       Andi Kleen <ak@linux.intel.com>
Date: Mon, 14 Jul 2008 20:34:56 -0600
Message-ID: <20080715023455.2528.16193.stgit@blender.achiang>
In-Reply-To: <20080715023344.2528.1836.stgit@blender.achiang>
References: <20080715023344.2528.1836.stgit@blender.achiang>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a new sysfs interface for CPU deconfiguration.

Since no vendors can agree on terminology for related but slightly
different features, provide a method for a platform to implement
its own version of what it thinks 'deconfiguring' a CPU might be.

Provide an HP-specific CPU deconfiguration implementation.

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Andi Kleen <ak@linux.intel.com>
---

 drivers/acpi/Kconfig                 |   18 ++
 drivers/acpi/Makefile                |    4 
 drivers/acpi/processor_core.c        |    8 +
 drivers/acpi/processor_deconfigure.c |  275 ++++++++++++++++++++++++++++++++++
 include/acpi/processor.h             |    6 +
 5 files changed, 311 insertions(+), 0 deletions(-)
 create mode 100644 drivers/acpi/processor_deconfigure.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index c52fca8..36ad177 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -188,6 +188,24 @@ config ACPI_HOTPLUG_CPU
 	select ACPI_CONTAINER
 	default y
 
+config ACPI_DECONFIGURE_CPU
+	bool "Processor deconfiguration"
+	depends on ACPI_PROCESSOR
+	default n
+	help
+	  This processor driver submodule allows a user to mark a CPU
+	  for firmware disabling/enabling. It will create the following
+	  sysfs file:
+	  
+	  /sys/devices/system/cpu/cpuN/deconfigure
+	  
+	  Behavior of this interface is highly vendor-dependent and
+	  requires firmware support.
+
+	  This option is NOT required for CPU hotplug support.
+
+	  If unsure, say N.
+
 config ACPI_THERMAL
 	tristate "Thermal Zone"
 	depends on ACPI_PROCESSOR
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 40b0fca..92a5037 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -35,6 +35,10 @@ ifdef CONFIG_CPU_FREQ
 processor-objs	+= processor_perflib.o
 endif
 
+ifdef CONFIG_ACPI_DECONFIGURE_CPU
+processor-objs	+= processor_deconfigure.o
+endif
+
 obj-y				+= sleep/
 obj-y				+= bus.o glue.o
 obj-y				+= scan.o
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 9dd0fa9..ef582ca 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -1099,6 +1099,10 @@ static int __init acpi_processor_init(void)
 
 	acpi_processor_throttling_init();
 
+#ifdef CONFIG_ACPI_DECONFIGURE_CPU
+	acpi_processor_deconfigure_init();
+#endif
+
 	return 0;
 
 out_cpuidle:
@@ -1112,6 +1116,10 @@ out_proc:
 
 static void __exit acpi_processor_exit(void)
 {
+
+#ifdef CONFIG_ACPI_DECONFIGURE_CPU
+	acpi_processor_deconfigure_exit();
+#endif
 	acpi_processor_ppc_exit();
 
 	acpi_thermal_cpufreq_exit();
diff --git a/drivers/acpi/processor_deconfigure.c b/drivers/acpi/processor_deconfigure.c
new file mode 100644
index 0000000..e656f97
--- /dev/null
+++ b/drivers/acpi/processor_deconfigure.c
@@ -0,0 +1,275 @@
+/*
+ * processor_deconfigure.c - CPU deconfiguration submodule of the
+ *			     ACPI processor driver
+ *
+ * (c) Copyright 2008 Hewlett-Packard Development Company, L.P.
+ * 	Alex Chiang <achiang@hp.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ */
+
+#include <acpi/acpi.h>
+#include <acpi/acpi_drivers.h>
+#include <acpi/processor.h>
+
+static int supports_cpu_deconfigure;
+
+/*
+ * These function pointers must be overwritten by platforms supporting
+ * cpu deconfigure.
+ */
+static ssize_t (*show_deconfigure)(struct sys_device *, char *);
+static ssize_t (*store_deconfigure)(struct sys_device *, const char *, size_t);
+
+/*
+ * Under HP semantics, CPU deconfiguration is defined as removing a
+ * processor core or socket from operation at boot time, typically
+ * due to managability concerns, such as excessive detected errors.
+ *
+ * The HP semantics of 'deconfigure' are defined as:
+ *
+ * 	Mark CPU for deconfiguration at next boot.
+ * 	# echo 1 > /sys/devices/system/cpu/cpuN/deconfigure
+ *
+ * 	Mark CPU as enabled at next boot.
+ * 	# echo 0 > /sys/devices/system/cpu/cpuN/deconfigure
+ *
+ * 	Display next boot's deconfigure status
+ * 		0x0	- not marked for deconfiguration
+ * 		0x1	- scheduled deconfig at next boot
+ * 		0x3	- scheduled, OS-requested deconfig at next boot
+ * 		0x4	- thread disabled by firmware
+ * 	# cat /sys/devices/system/cpu/cpuN/deconfigure
+ *
+ * After echo'ing 0 or 1 into deconfigure, cat'ing the file will
+ * return the next boot's status. However, the CPU will not actually
+ * be deconfigured until the next boot.
+ *
+ * Attempting to configure or deconfigure a disabled thread is disallowed.
+ */
+struct hp_deconfigure_cb_args {
+	int cpu;
+	char *method;
+};
+
+static acpi_status hp_deconfigure_cb(acpi_handle handle,
+				     u32 lvl,
+				     void *context,
+				     void **rv)
+{
+	int cpu;
+	acpi_status status;
+	acpi_integer scfg;
+	struct hp_deconfigure_cb_args *args = context;
+	union acpi_object object = { 0 };
+	struct acpi_buffer buffer = { sizeof(union acpi_object), &object };
+
+	status = acpi_evaluate_object(handle, NULL, NULL, &buffer);
+	if (ACPI_FAILURE(status))
+		return AE_OK;
+
+	cpu = object.processor.proc_id;
+	if (cpu != args->cpu)
+		return AE_OK;
+
+	/*
+	 * Always check SCFG. If this is what the user actually wanted,
+	 * great, just return the answer. If the user wanted something
+	 * else, check to see if they were trying to poke a disabled
+	 * hardware thread and disallow it if so.
+	 */
+	status = acpi_evaluate_object(handle, "SCFG", NULL, &buffer);
+	scfg = object.integer.value;
+	if (!strcmp(args->method, "SCFG"))
+		**(int **)rv = ACPI_SUCCESS(status) ? scfg : -1;
+	/*
+	 * Disallow E/DCFG on disabled threads
+	 */
+	else if (scfg == 0x4)
+		**(int **)rv = -1;
+	else {
+		status = acpi_evaluate_object(handle, args->method,
+					      NULL, &buffer);
+		**(int **)rv = ACPI_SUCCESS(status) ? status : -1;
+	}
+
+	return AE_CTRL_TERMINATE;
+}
+
+/*
+ * We can do this the easy way or the hard way. The easy way is,
+ * if the CPU is online, we have easy access to its ACPI handle
+ * via its per_cpu() data area, and we can call SCFG directly.
+ *
+ * The hard way is when the CPU is not online, and does not have
+ * a valid per_cpu() data area. In that case, we have to walk the
+ * ACPI namespace, looking for the CPU and calling SCFG that way.
+ */
+static ssize_t hp_show_deconfigure(struct sys_device *dev, char *buf)
+{
+	int logical_cpu;
+	unsigned long cfg;
+	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
+
+	logical_cpu = cpu->sysdev.id;
+
+	if (cpu_isset(logical_cpu, cpu_online_map)) {
+		unsigned long tmp;
+		acpi_status status;
+		struct acpi_processor *pr;
+
+		pr = processors[logical_cpu];
+		status = acpi_evaluate_integer(pr->handle, "SCFG", NULL, &tmp);
+		cfg = ACPI_SUCCESS(status) ? tmp : -1;
+	} else {
+		int ret;
+		void *ret_ptr = &ret;
+		struct hp_deconfigure_cb_args args;
+
+		args.cpu = logical_cpu;
+		args.method = "SCFG";
+		acpi_walk_namespace(ACPI_TYPE_PROCESSOR,
+				    ACPI_ROOT_OBJECT,
+				    ACPI_UINT32_MAX,
+				    hp_deconfigure_cb,
+				    &args,
+				    (void *)&ret_ptr);
+		cfg = ret;
+	}
+
+	return sprintf(buf, "%#lx\n", cfg);
+}
+
+/*
+ * We can do this the easy way or the hard way. The easy way is,
+ * if the CPU is online, we have easy access to its ACPI handle
+ * via its per_cpu() data area, and we can call E/D-CFG directly.
+ *
+ * The hard way is when the CPU is not online, and does not have
+ * a valid per_cpu() data area. In that case, we have to walk the
+ * ACPI namespace, looking for the CPU and calling E/D-CFG that way.
+ */
+static ssize_t hp_store_deconfigure(struct sys_device *dev, const char *buf,
+				    size_t count)
+{
+	ssize_t ret;
+	char *method;
+	int logical_cpu;
+	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
+
+	logical_cpu = cpu->sysdev.id;
+	switch (buf[0]) {
+	case '0':
+		method = "ECFG";
+		break;
+	case '1':
+		method = "DCFG";
+		break;
+	default:
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (cpu_isset(logical_cpu, cpu_online_map)) {
+		struct acpi_processor *pr;
+		pr = processors[logical_cpu];
+		ret = acpi_evaluate_object(pr->handle, method, NULL, NULL);
+	} else {
+		int r;
+		void *ret_ptr = &r;
+		struct hp_deconfigure_cb_args args;
+
+		args.cpu = logical_cpu;
+		args.method = method;
+		acpi_walk_namespace(ACPI_TYPE_PROCESSOR,
+				    ACPI_ROOT_OBJECT,
+				    ACPI_UINT32_MAX,
+				    hp_deconfigure_cb,
+				    &args,
+				    (void *)&ret_ptr);
+		ret = r;
+	}
+
+	if (ret == 0)
+		if (!strcmp(method, "ECFG"))
+			cpu_set(logical_cpu, cpu_enabled_map);
+		else
+			cpu_clear(logical_cpu, cpu_enabled_map);
+
+out:
+	if (ret >= 0)
+		ret = count;
+	return ret;
+}
+
+static int hp_check_cpu_deconfigure(const struct dmi_system_id *d)
+{
+	acpi_handle hnd;
+	struct acpi_processor *pr;
+
+	/*
+	 * Operating assumption is that either all or none of the CPUs
+	 * will support deconfiguration.
+	 */
+	pr = processors[0];
+	if (ACPI_SUCCESS(acpi_get_handle(pr->handle, "SCFG", &hnd))) {
+		supports_cpu_deconfigure = 1;
+		show_deconfigure = hp_show_deconfigure;
+		store_deconfigure = hp_store_deconfigure;
+	}
+
+	return 0;
+}
+
+static struct dmi_system_id cpu_deconfigure_dmi_table[] __initdata = {
+	{
+	 .callback = hp_check_cpu_deconfigure,
+	 .ident = "Hewlett-Packard",
+	 .matches = {
+		DMI_MATCH(DMI_BIOS_VENDOR, "HP"),
+		},
+	},
+	{
+	 .callback = hp_check_cpu_deconfigure,
+	 .ident = "Hewlett-Packard",
+	 .matches = {
+		DMI_MATCH(DMI_BIOS_VENDOR, "Hewlett-Packard"),
+		},
+	},
+	{}
+};
+
+static SYSDEV_ATTR(deconfigure, 0644, NULL, NULL);
+
+void __init acpi_processor_deconfigure_init(void)
+{
+	int i;
+	struct sys_device *sysdev;
+
+	dmi_check_system(cpu_deconfigure_dmi_table);
+
+	if (supports_cpu_deconfigure) {
+		attr_deconfigure.show = show_deconfigure;
+		attr_deconfigure.store = store_deconfigure;
+
+		for_each_present_cpu(i) {
+			sysdev = get_cpu_sysdev(i);
+			sysdev_create_file(sysdev, &attr_deconfigure);
+		}
+	}
+}
+
+void acpi_processor_deconfigure_exit(void)
+{
+	int i;
+	struct sys_device *sysdev;
+
+	if (supports_cpu_deconfigure) {
+		for_each_present_cpu(i) {
+			sysdev = get_cpu_sysdev(i);
+			sysdev_remove_file(sysdev, &attr_deconfigure);
+		}
+	}
+}
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 06ebb6e..071fd42 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -289,6 +289,12 @@ static inline void acpi_processor_ffh_cstate_enter(struct acpi_processor_cx
 }
 #endif
 
+#ifdef CONFIG_ACPI_DECONFIGURE_CPU
+/* in processor_deconfigure.c */
+void __init acpi_processor_deconfigure_init(void);
+void acpi_processor_deconfigure_exit(void);
+#endif
+
 /* in processor_perflib.c */
 
 #ifdef CONFIG_CPU_FREQ

