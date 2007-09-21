Return-Path: <linux-kernel-owner+w=401wt.eu-S933150AbXIUWrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150AbXIUWrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764135AbXIUWcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:47 -0400
Received: from ns2.suse.de ([195.135.220.15]:40506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762432AbXIUWck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:40 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: akinobu.mita@gmail.com, hpa@zytor.com, ego@in.ibm.com, oleg@tv-sign.ru,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [35/50] i386: Do cpuid_device_create() in CPU_UP_PREPARE instead of CPU_ONLINE.
Message-Id: <20070921223235.18A2A13DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Akinobu Mita <akinobu.mita@gmail.com>

Do cpuid_device_create() in CPU_UP_PREPARE instead of CPU_ONLINE.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpuid.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

Index: linux/arch/i386/kernel/cpuid.c
===================================================================
--- linux.orig/arch/i386/kernel/cpuid.c
+++ linux/arch/i386/kernel/cpuid.c
@@ -136,15 +136,18 @@ static const struct file_operations cpui
 	.open = cpuid_open,
 };
 
-static int __cpuinit cpuid_device_create(int i)
+static int cpuid_device_create(int cpu)
 {
-	int err = 0;
 	struct device *dev;
 
-	dev = device_create(cpuid_class, NULL, MKDEV(CPUID_MAJOR, i), "cpu%d",i);
-	if (IS_ERR(dev))
-		err = PTR_ERR(dev);
-	return err;
+	dev = device_create(cpuid_class, NULL, MKDEV(CPUID_MAJOR, cpu),
+			    "cpu%d", cpu);
+	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+}
+
+static void cpuid_device_destroy(int cpu)
+{
+	device_destroy(cpuid_class, MKDEV(CPUID_MAJOR, cpu));
 }
 
 static int __cpuinit cpuid_class_cpu_callback(struct notifier_block *nfb,
@@ -152,18 +155,21 @@ static int __cpuinit cpuid_class_cpu_cal
 					      void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
+	int err = 0;
 
 	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		cpuid_device_create(cpu);
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		err = cpuid_device_create(cpu);
 		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		device_destroy(cpuid_class, MKDEV(CPUID_MAJOR, cpu));
+		cpuid_device_destroy(cpu);
 		break;
 	}
-	return NOTIFY_OK;
+	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
 static struct notifier_block __cpuinitdata cpuid_class_cpu_notifier =
@@ -200,7 +206,7 @@ static int __init cpuid_init(void)
 out_class:
 	i = 0;
 	for_each_online_cpu(i) {
-		device_destroy(cpuid_class, MKDEV(CPUID_MAJOR, i));
+		cpuid_device_destroy(i);
 	}
 	class_destroy(cpuid_class);
 out_chrdev:
@@ -214,7 +220,7 @@ static void __exit cpuid_exit(void)
 	int cpu = 0;
 
 	for_each_online_cpu(cpu)
-		device_destroy(cpuid_class, MKDEV(CPUID_MAJOR, cpu));
+		cpuid_device_destroy(cpu);
 	class_destroy(cpuid_class);
 	unregister_chrdev(CPUID_MAJOR, "cpu/cpuid");
 	unregister_hotcpu_notifier(&cpuid_class_cpu_notifier);
