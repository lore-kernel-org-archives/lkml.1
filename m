Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbXFLHbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbXFLHbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXFLHbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:31:13 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:52850 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751439AbXFLHbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:31:12 -0400
Message-Id: <466E680F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 12 Jun 2007 09:31:59 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] adjust nosmp handling
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Especially when !CONFIG_HOTPLUG_CPU, avoid needlessy allocating
resources for CPUs that can never become available.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 init/main.c |   42 +++++++++++++++++++++++++++---------------
 1 files changed, 27 insertions(+), 15 deletions(-)

--- linux-2.6.22-rc4/init/main.c	2007-06-11 18:10:51.000000000 +0200
+++ 2.6.22-rc4-nosmp/init/main.c	2007-06-11 09:10:42.000000000 +0200
@@ -132,20 +132,9 @@ static char *static_command_line;
 static char *execute_command;
 static char *ramdisk_execute_command;
 
+#ifdef CONFIG_SMP
 /* Setup configured maximum number of CPUs to activate */
-static unsigned int max_cpus = NR_CPUS;
-
-/*
- * If set, this is an indication to the drivers that reset the underlying
- * device before going ahead with the initialization otherwise driver might
- * rely on the BIOS and skip the reset operation.
- *
- * This is useful if kernel is booting in an unreliable environment.
- * For ex. kdump situaiton where previous kernel has crashed, BIOS has been
- * skipped and devices will be in unknown state.
- */
-unsigned int reset_devices;
-EXPORT_SYMBOL(reset_devices);
+static unsigned int __initdata max_cpus = NR_CPUS;
 
 /*
  * Setup routine for controlling SMP activation
@@ -160,10 +149,10 @@ EXPORT_SYMBOL(reset_devices);
 static int __init nosmp(char *str)
 {
 	max_cpus = 0;
-	return 1;
+	return 0;
 }
 
-__setup("nosmp", nosmp);
+early_param("nosmp", nosmp);
 
 static int __init maxcpus(char *str)
 {
@@ -172,6 +161,21 @@ static int __init maxcpus(char *str)
 }
 
 __setup("maxcpus=", maxcpus);
+#else
+#define max_cpus NR_CPUS
+#endif
+
+/*
+ * If set, this is an indication to the drivers that reset the underlying
+ * device before going ahead with the initialization otherwise driver might
+ * rely on the BIOS and skip the reset operation.
+ *
+ * This is useful if kernel is booting in an unreliable environment.
+ * For ex. kdump situaiton where previous kernel has crashed, BIOS has been
+ * skipped and devices will be in unknown state.
+ */
+unsigned int reset_devices;
+EXPORT_SYMBOL(reset_devices);
 
 static int __init set_reset_devices(char *str)
 {
@@ -385,6 +389,10 @@ static void __init smp_init(void)
 {
 	unsigned int cpu;
 
+#ifndef CONFIG_HOTPLUG_CPU
+	cpu_possible_map = cpu_present_map;
+#endif
+
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= max_cpus)
@@ -525,6 +533,10 @@ asmlinkage void __init start_kernel(void
 	setup_arch(&command_line);
 	setup_command_line(command_line);
 	unwind_setup();
+#ifndef CONFIG_HOTPLUG_CPU
+	if (max_cpus < 2)
+		cpu_possible_map = cpu_online_map;
+#endif
 	setup_per_cpu_areas();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 



