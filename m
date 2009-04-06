Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbZDFRvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbZDFRvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 13:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750804AbZDFRvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 13:51:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57043 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbZDFRvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 13:51:12 -0400
Message-ID: <49DA40B9.2060804@redhat.com>
Date: Mon, 06 Apr 2009 13:49:45 -0400
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
CC: dannf@hp.com, ying.huang@intel.com
Subject: [PATCH] rtc: add x86 support for rtc-efi
Content-Type: multipart/mixed;
 boundary="------------040202070901050704000008"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040202070901050704000008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch adds support for rtc-efi (RTC Class Driver for EFI-based 
systems) to x86.

This patch is based on dann frazier patch [add rtc platform driver for 
EFI -> http://lkml.org/lkml/2009/1/8/434], and also depends on dann's 
patch. Dann's patch was in the mm tree, though I think its been merged 
already.

This patch has been tested and works perfectly on every x86 EFI system I 
could find, though all have been EL64 systems. I would appreciate any 
testing feedback from EL32 systems from anyone that has one and can test.

Signed-off-by: Brian Maly <bmaly@redhat.com>





--------------040202070901050704000008
Content-Type: text/x-patch;
 name="2.6.29-add-x86-support-for-efi-rtc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6.29-add-x86-support-for-efi-rtc.patch"

--- a/drivers/rtc/Kconfig	2009-03-28 04:25:33.000000000 -0400
+++ b/drivers/rtc/Kconfig	2009-03-26 12:53:59.000000000 -0400
@@ -442,7 +442,7 @@ config RTC_DRV_DS1742
 
 config RTC_DRV_EFI
 	tristate "EFI RTC"
-	depends on IA64
+	depends on IA64 || (X86 && EFI) || (X86_64 && EFI)
 	help
 	  If you say yes here you will get support for the EFI
 	  Real Time Clock.
--- a/arch/x86/kernel/time_32.c	2009-03-12 22:39:28.000000000 -0400
+++ b/arch/x86/kernel/time_32.c	2009-03-27 12:08:58.000000000 -0400
@@ -32,6 +32,7 @@
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/mca.h>
+#include <linux/platform_device.h>
 
 #include <asm/arch_hooks.h>
 #include <asm/hpet.h>
@@ -135,3 +136,24 @@ void __init time_init(void)
 	tsc_init();
 	late_time_init = choose_time_init();
 }
+
+#ifdef CONFIG_EFI
+extern int efi_enabled;
+
+static struct platform_device rtc_efi_dev = {
+	.name = "rtc-efi",
+	.id = -1,
+};
+
+static int __init rtc_init(void)
+{
+	if (efi_enabled) {
+		if (platform_device_register(&rtc_efi_dev) < 0)
+			printk(KERN_ERR "unable to register rtc device...\n");
+	}
+	/* not necessarily an error */
+	return 0;
+}
+module_init(rtc_init);
+#endif
+
--- a/arch/x86/kernel/time_64.c	2009-03-12 22:39:28.000000000 -0400
+++ b/arch/x86/kernel/time_64.c	2009-03-27 12:09:39.000000000 -0400
@@ -18,6 +18,7 @@
 #include <linux/time.h>
 #include <linux/mca.h>
 #include <linux/nmi.h>
+#include <linux/platform_device.h>
 
 #include <asm/i8253.h>
 #include <asm/hpet.h>
@@ -135,3 +136,24 @@ void __init time_init(void)
 
 	late_time_init = choose_time_init();
 }
+
+#ifdef CONFIG_EFI
+extern int efi_enabled;
+
+static struct platform_device rtc_efi_dev = {
+	.name = "rtc-efi",
+	.id = -1,
+};
+
+static int __init rtc_init(void)
+{
+	if (efi_enabled) {
+		if (platform_device_register(&rtc_efi_dev) < 0)
+			printk(KERN_ERR "unable to register rtc device...\n");
+	}
+	/* not necessarily an error */
+	return 0;
+}
+module_init(rtc_init);
+#endif
+

--------------040202070901050704000008--
