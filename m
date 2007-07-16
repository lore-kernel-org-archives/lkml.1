Return-Path: <linux-kernel-owner+w=401wt.eu-S932632AbXGPOJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632AbXGPOJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761690AbXGPOIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:08:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:49141 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759966AbXGPOIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:08:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=o/M2JBgL4MalVV/BitnJXRCvohdjLE8vZa38Cx9EIPoeQIU/FF7sLNjZbGX8naL7d9Ltm+VMMjd83d4YbRq0Y2DdbypA3egmqu7MGcUiFEPWQ9X610H9OKoO4Dp/NxA8szwpm24HMJxzUDJ+qSN51L+DiFvsdmbnj5mBBVos36s=
Date: Mon, 16 Jul 2007 22:58:51 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 8/10] cpuid: fix cpu hotplug error handling
Message-ID: <20070716135851.GH2040@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20070716134855.GA1858@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716134855.GA1858@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make cpuid_device_create() CPU_UP_PREPARE event handler
instead of CPU_ONLINE event handler.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 arch/i386/kernel/cpuid.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

Index: 2.6-mm/arch/i386/kernel/cpuid.c
===================================================================
--- 2.6-mm.orig/arch/i386/kernel/cpuid.c
+++ 2.6-mm/arch/i386/kernel/cpuid.c
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
