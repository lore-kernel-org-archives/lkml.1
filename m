Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbXGVPru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbXGVPru (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 11:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbXGVPor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 11:44:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:60825 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937AbXGVPoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 11:44:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=PcBxiXeQi0N9J1IOL0wmbDhWDvxoAecdV3joNPuJjTxRlg0b1PgRfsman/P7mYyRBWVqi9i7LebIqEkVMwqDOGni69oEX5iDgxtjljUfOEndXwZD1A/KDHpdq+GhOmHa4c6xp08QZbrf2usmrot7s9tkglrNs2CsgWkfoBH5k4w=
Message-Id: <20070722153409.377818295@gmail.com>
References: <20070722153312.083951746@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Jul 2007 00:33:19 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Akinobu Mita <akinobu.mita@gmail.com>
Subject: [patch 7/9] cpuid: fix cpu hotplug error handling
Content-Disposition: inline; filename=cpuid-cpuhotplug.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do cpuid_device_create() in CPU_UP_PREPARE instead of CPU_ONLINE.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 arch/i386/kernel/cpuid.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

Index: 2.6-git/arch/i386/kernel/cpuid.c
===================================================================
--- 2.6-git.orig/arch/i386/kernel/cpuid.c
+++ 2.6-git/arch/i386/kernel/cpuid.c
@@ -152,32 +152,38 @@ static const struct file_operations cpui
 	.open = cpuid_open,
 };
 
-static int cpuid_device_create(int i)
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
 
 static int cpuid_class_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
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
@@ -214,7 +220,7 @@ static int __init cpuid_init(void)
 out_class:
 	i = 0;
 	for_each_online_cpu(i) {
-		device_destroy(cpuid_class, MKDEV(CPUID_MAJOR, i));
+		cpuid_device_destroy(i);
 	}
 	class_destroy(cpuid_class);
 out_chrdev:
@@ -228,7 +234,7 @@ static void __exit cpuid_exit(void)
 	int cpu = 0;
 
 	for_each_online_cpu(cpu)
-		device_destroy(cpuid_class, MKDEV(CPUID_MAJOR, cpu));
+		cpuid_device_destroy(cpu);
 	class_destroy(cpuid_class);
 	unregister_chrdev(CPUID_MAJOR, "cpu/cpuid");
 	unregister_hotcpu_notifier(&cpuid_class_cpu_notifier);

-- 
