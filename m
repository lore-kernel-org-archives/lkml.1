Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZJ1U6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZJ1U6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 16:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbZJ1U6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 16:58:38 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44133 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbZJ1U6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 16:58:37 -0400
Message-ID: <4AE8B072.1070603@austin.ibm.com>
Date: Wed, 28 Oct 2009 15:58:26 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6 v5] CPU probe/release files
References: <4AE8ADCF.6090104@austin.ibm.com>
In-Reply-To: <4AE8ADCF.6090104@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create new probe and release sysfs files to facilitate adding and removing
cpus from the system.  This also creates the powerpc specific stubs to handle
the arch callouts from writes to the sysfs files.

The creation and use of these files is regulated by the 
CONFIG_ARCH_CPU_PROBE_RELEASE option so that only architectures that need the
capability will have the files created.

Signed-off-by: Nathan Fontenot <nfont at austin.ibm.com>
---

Index: powerpc/drivers/base/cpu.c
===================================================================
--- powerpc.orig/drivers/base/cpu.c	2009-10-28 15:20:34.000000000 -0500
+++ powerpc/drivers/base/cpu.c	2009-10-28 15:21:53.000000000 -0500
@@ -54,6 +54,7 @@
 		ret = count;
 	return ret;
 }
+
 static SYSDEV_ATTR(online, 0644, show_online, store_online);
 
 static void __cpuinit register_cpu_control(struct cpu *cpu)
@@ -72,6 +73,38 @@
 	per_cpu(cpu_sys_devices, logical_cpu) = NULL;
 	return;
 }
+
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+static ssize_t cpu_probe_store(struct class *class, const char *buf,
+			       size_t count)
+{
+	return arch_cpu_probe(buf, count);
+}
+
+static ssize_t cpu_release_store(struct class *class, const char *buf,
+				 size_t count)
+{
+	return arch_cpu_release(buf, count);
+}
+
+static CLASS_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
+static CLASS_ATTR(release, S_IWUSR, NULL, cpu_release_store);
+
+int __init cpu_probe_release_init(void)
+{
+	int rc;
+
+	rc = sysfs_create_file(&cpu_sysdev_class.kset.kobj,
+			       &class_attr_probe.attr);
+	if (!rc)
+		rc = sysfs_create_file(&cpu_sysdev_class.kset.kobj,
+				       &class_attr_release.attr);
+
+	return rc;
+}
+device_initcall(cpu_probe_release_init);
+#endif /* CONFIG_ARCH_CPU_PROBE_RELEASE */
+
 #else /* ... !CONFIG_HOTPLUG_CPU */
 static inline void register_cpu_control(struct cpu *cpu)
 {
Index: powerpc/arch/powerpc/include/asm/machdep.h
===================================================================
--- powerpc.orig/arch/powerpc/include/asm/machdep.h	2009-10-28 15:21:47.000000000 -0500
+++ powerpc/arch/powerpc/include/asm/machdep.h	2009-10-28 15:21:53.000000000 -0500
@@ -274,6 +274,11 @@
 	int (*memory_probe)(u64);
 #endif
 
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+	ssize_t (*cpu_probe)(const char *, size_t);
+	ssize_t (*cpu_release)(const char *, size_t);
+#endif
+
 };
 
 extern void e500_idle(void);
Index: powerpc/arch/powerpc/kernel/sysfs.c
===================================================================
--- powerpc.orig/arch/powerpc/kernel/sysfs.c	2009-10-28 15:20:34.000000000 -0500
+++ powerpc/arch/powerpc/kernel/sysfs.c	2009-10-28 15:21:53.000000000 -0500
@@ -461,6 +461,25 @@
 
 	cacheinfo_cpu_offline(cpu);
 }
+
+#ifdef CONFIG_ARCH_PROBE_RELEASE
+ssize_t arch_cpu_probe(const char *buf, size_t count)
+{
+	if (ppc_md.cpu_probe)
+		return ppc_md.cpu_probe(buf, count);
+
+	return -EINVAL;
+}
+
+ssize_t arch_cpu_release(const char *buf, size_t count)
+{
+	if (ppc_md.cpu_release)
+		return ppc_md.cpu_release(buf, count);
+
+	return -EINVAL;
+}
+#endif /* CONFIG_ARCH_PROBE_RELEASE */
+
 #endif /* CONFIG_HOTPLUG_CPU */
 
 static int __cpuinit sysfs_cpu_notify(struct notifier_block *self,
Index: powerpc/arch/powerpc/Kconfig
===================================================================
--- powerpc.orig/arch/powerpc/Kconfig	2009-10-28 15:21:47.000000000 -0500
+++ powerpc/arch/powerpc/Kconfig	2009-10-28 15:21:53.000000000 -0500
@@ -320,6 +320,10 @@
 
 	  Say N if you are unsure.
 
+config ARCH_CPU_PROBE_RELEASE
+	def_bool y
+	depends on HOTPLUG_CPU
+
 config ARCH_ENABLE_MEMORY_HOTPLUG
 	def_bool y
 
Index: powerpc/include/linux/cpu.h
===================================================================
--- powerpc.orig/include/linux/cpu.h	2009-10-28 15:20:34.000000000 -0500
+++ powerpc/include/linux/cpu.h	2009-10-28 15:21:53.000000000 -0500
@@ -43,6 +43,10 @@
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+extern ssize_t arch_cpu_probe(const char *, size_t);
+extern ssize_t arch_cpu_release(const char *, size_t);
+#endif
 #endif
 
 struct notifier_block;
Index: powerpc/arch/powerpc/kernel/smp.c
===================================================================
--- powerpc.orig/arch/powerpc/kernel/smp.c	2009-10-28 15:20:34.000000000 -0500
+++ powerpc/arch/powerpc/kernel/smp.c	2009-10-28 15:21:53.000000000 -0500
@@ -364,7 +364,24 @@
 	set_cpu_online(cpu, true);
 	local_irq_enable();
 }
+
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+ssize_t arch_cpu_probe(const char *buf, size_t count)
+{
+	if (ppc_md.cpu_probe)
+		return ppc_md.cpu_probe(buf, count);
+
+	return -EINVAL;
+}
+ssize_t arch_cpu_release(const char *buf, size_t count)
+{
+	if (ppc_md.cpu_release)
+		return ppc_md.cpu_release(buf, count);
+
+	return -EINVAL;
+}
 #endif
+#endif /* CONFIG_HOTPLUG_CPU */
 
 static int __devinit cpu_enable(unsigned int cpu)
 {
