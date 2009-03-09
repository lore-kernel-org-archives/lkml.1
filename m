Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZCIN2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZCIN2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 09:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZCIN0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 09:26:43 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35644 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751223AbZCIN0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 09:26:30 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Alessandro Zummo <alessandro.zummo@towertech.it>,
       Kyle McMartin <kyle@mcmartin.ca>
Cc: rtc-linux@googlegroups.com, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Dann Frazier <dannf@dannf.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 6/7] powerpc: Hook up rtc-generic, and kill rtc-ppc
Date: Mon,  9 Mar 2009 14:26:22 +0100
Message-Id: <1236605183-22718-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1236605183-22718-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1236605183-22718-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1236605183-22718-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1236605183-22718-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1236605183-22718-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1236605183-22718-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PowerPC has been a long time user of the generic RTC abstraction, so hook up
rtc-generic:
  - Create the "rtc-generic" platform device if ppc_md.get_rtc_time is set,
  - Kill rtc-ppc, as rtc-generic offers the same functionality in a more
    generic way, and supports autoloading through udev.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 arch/powerpc/kernel/time.c |   16 ++++++++++
 drivers/rtc/Kconfig        |   10 +------
 drivers/rtc/Makefile       |    1 -
 drivers/rtc/rtc-ppc.c      |   69 --------------------------------------------
 4 files changed, 17 insertions(+), 79 deletions(-)
 delete mode 100644 drivers/rtc/rtc-ppc.c

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index c956403..926ea86 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -1127,3 +1127,19 @@ void div128_by_32(u64 dividend_high, u64 dividend_low,
 	dr->result_low  = ((u64)y << 32) + z;
 
 }
+
+static int __init rtc_init(void)
+{
+	struct platform_device *pdev;
+
+	if (!ppc_md.get_rtc_time)
+		return -ENODEV;
+
+	pdev = platform_device_register_simple("rtc-generic", -1, NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	return 0;
+}
+
+module_init(rtc_init);
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index c8ead87..6488c50 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -681,20 +681,12 @@ config RTC_DRV_GENERIC
 	tristate "Generic RTC support"
 	# Please consider writing a new RTC driver instead of using the generic
 	# RTC abstraction
-	depends on PARISC || M68K
+	depends on PARISC || M68K || PPC
 	help
 	  Say Y or M here to enable RTC support on systems using the generic
 	  RTC abstraction. If you do not know what you are doing, you should
 	  just say Y.
 
-config RTC_DRV_PPC
-       tristate "PowerPC machine dependent RTC support"
-       depends on PPC
-       help
-	 The PowerPC kernel has machine-specific functions for accessing
-	 the RTC. This exposes that functionality through the generic RTC
-	 class.
-
 config RTC_DRV_PXA
        tristate "PXA27x/PXA3xx"
        depends on ARCH_PXA
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 9c18a01..bd209a5 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -56,7 +56,6 @@ obj-$(CONFIG_RTC_DRV_PCF8583)	+= rtc-pcf8583.o
 obj-$(CONFIG_RTC_DRV_PL030)	+= rtc-pl030.o
 obj-$(CONFIG_RTC_DRV_PL031)	+= rtc-pl031.o
 obj-$(CONFIG_RTC_DRV_GENERIC)	+= rtc-generic.o
-obj-$(CONFIG_RTC_DRV_PPC)	+= rtc-ppc.o
 obj-$(CONFIG_RTC_DRV_PXA)	+= rtc-pxa.o
 obj-$(CONFIG_RTC_DRV_R9701)	+= rtc-r9701.o
 obj-$(CONFIG_RTC_DRV_RS5C313)	+= rtc-rs5c313.o
diff --git a/drivers/rtc/rtc-ppc.c b/drivers/rtc/rtc-ppc.c
deleted file mode 100644
index c8e97e2..0000000
--- a/drivers/rtc/rtc-ppc.c
+++ /dev/null
@@ -1,69 +0,0 @@
-/*
- * RTC driver for ppc_md RTC functions
- *
- * © 2007 Red Hat, Inc.
- *
- * Author: David Woodhouse <dwmw2@infradead.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-
-#include <linux/module.h>
-#include <linux/err.h>
-#include <linux/rtc.h>
-#include <linux/platform_device.h>
-#include <asm/machdep.h>
-
-static int ppc_rtc_read_time(struct device *dev, struct rtc_time *tm)
-{
-	ppc_md.get_rtc_time(tm);
-	return 0;
-}
-
-static int ppc_rtc_set_time(struct device *dev, struct rtc_time *tm)
-{
-	return ppc_md.set_rtc_time(tm);
-}
-
-static const struct rtc_class_ops ppc_rtc_ops = {
-	.set_time = ppc_rtc_set_time,
-	.read_time = ppc_rtc_read_time,
-};
-
-static struct rtc_device *rtc;
-static struct platform_device *ppc_rtc_pdev;
-
-static int __init ppc_rtc_init(void)
-{
-	if (!ppc_md.get_rtc_time || !ppc_md.set_rtc_time)
-		return -ENODEV;
-
-	ppc_rtc_pdev = platform_device_register_simple("ppc-rtc", 0, NULL, 0);
-	if (IS_ERR(ppc_rtc_pdev))
-		return PTR_ERR(ppc_rtc_pdev);
-
-	rtc = rtc_device_register("ppc_md", &ppc_rtc_pdev->dev,
-				  &ppc_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		platform_device_unregister(ppc_rtc_pdev);
-		return PTR_ERR(rtc);
-	}
-
-	return 0;
-}
-
-static void __exit ppc_rtc_exit(void)
-{
-	rtc_device_unregister(rtc);
-	platform_device_unregister(ppc_rtc_pdev);
-}
-
-module_init(ppc_rtc_init);
-module_exit(ppc_rtc_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
-MODULE_DESCRIPTION("Generic RTC class driver for PowerPC");
-- 
1.6.0.4

