Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbXGVPrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbXGVPrO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 11:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbXGVPok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 11:44:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:60825 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbXGVPoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 11:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=JJ3gMfvjIYkA7LBa8k2VjGJQzOG+RiBmO5c/yfFU7Klnp0tYImcNcf1gLeBW7QhazOSgqT71ncuYhG5omO6dZiZyyA/cNk9UZUpnyDBS3DOFk8E50m7exoLWeCvpHzys/Mo1xfEjuXHAQDCKgme2Vs2Z+nmYvkGbWJyL9yhLbFY=
Message-Id: <20070722153403.159007663@gmail.com>
References: <20070722153312.083951746@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Jul 2007 00:33:18 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Akinobu Mita <akinobu.mita@gmail.com>
Subject: [patch 6/9] msr: fix cpu hotplug error handling
Content-Disposition: inline; filename=msr-cpuhotplug.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do msr_device_create() in CPU_UP_PREPARE instead of CPU_ONLINE.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 arch/i386/kernel/msr.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

Index: 2.6-git/arch/i386/kernel/msr.c
===================================================================
--- 2.6-git.orig/arch/i386/kernel/msr.c
+++ 2.6-git/arch/i386/kernel/msr.c
@@ -135,33 +135,39 @@ static const struct file_operations msr_
 	.open = msr_open,
 };
 
-static int msr_device_create(int i)
+static int msr_device_create(int cpu)
 {
-	int err = 0;
 	struct device *dev;
 
-	dev = device_create(msr_class, NULL, MKDEV(MSR_MAJOR, i), "msr%d",i);
-	if (IS_ERR(dev))
-		err = PTR_ERR(dev);
-	return err;
+	dev = device_create(msr_class, NULL, MKDEV(MSR_MAJOR, cpu),
+			    "msr%d", cpu);
+	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+}
+
+static void msr_device_destroy(int cpu)
+{
+	device_destroy(msr_class, MKDEV(MSR_MAJOR, cpu));
 }
 
 static int msr_class_cpu_callback(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
+	int err = 0;
 
 	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		msr_device_create(cpu);
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		err = msr_device_create(cpu);
 		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		device_destroy(msr_class, MKDEV(MSR_MAJOR, cpu));
+		msr_device_destroy(cpu);
 		break;
 	}
-	return NOTIFY_OK;
+	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
 static struct notifier_block __cpuinitdata msr_class_cpu_notifier =
@@ -198,7 +204,7 @@ static int __init msr_init(void)
 out_class:
 	i = 0;
 	for_each_online_cpu(i)
-		device_destroy(msr_class, MKDEV(MSR_MAJOR, i));
+		msr_device_destroy(i);
 	class_destroy(msr_class);
 out_chrdev:
 	unregister_chrdev(MSR_MAJOR, "cpu/msr");
@@ -210,7 +216,7 @@ static void __exit msr_exit(void)
 {
 	int cpu = 0;
 	for_each_online_cpu(cpu)
-		device_destroy(msr_class, MKDEV(MSR_MAJOR, cpu));
+		msr_device_destroy(cpu);
 	class_destroy(msr_class);
 	unregister_chrdev(MSR_MAJOR, "cpu/msr");
 	unregister_hotcpu_notifier(&msr_class_cpu_notifier);

-- 
