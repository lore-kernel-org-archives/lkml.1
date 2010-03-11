Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0CKInn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 03:43:43 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:65230 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab0CKInc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 03:43:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-tuid:x-uid:x-length
         :organization:to:cc:content-type:content-transfer-encoding
         :message-id;
        b=ox2Dl9XgY83R/p4qcxG8qUIczQ+3vw7tLggsu+Fi0f2kaFNAYKBG3wtib2F/kMbdxm
         u6o/YPgSPfajwHuS6G46dJ/rlpCDEfoB4IxSyiEKSzTr4Q1TWtW5EmOxWC3QJ8aM02Lo
         GhsCmm1FWx65OmrYeZnx2MM8N6vNApGrg8UK8=
From: Florian Fainelli <florian@openwrt.org>
Date: Thu, 11 Mar 2010 09:42:15 +0100
Subject: [PATCH 4/4 v2] WATCHDOG: convert rdc321x_wdt to use southbridge accessors
MIME-Version: 1.0
X-TUID: 8c2fed53eb3bc310
X-Length: 5146
Organization: OpenWrt
To: linux-kernel@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, Samuel Ortiz <sameo@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003110942.15442.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of the MFD driver which abstracts access to the PCI
device configuration space the watchdog driver must be converted to use these
accessors and provide safe register read/write. As a result we now use the
memory resource which comes with the platform device.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 69c6adb..5f68805 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -1,7 +1,7 @@
 /*
  * RDC321x watchdog driver
  *
- * Copyright (C) 2007 Florian Fainelli <florian@openwrt.org>
+ * Copyright (C) 2007-2010 Florian Fainelli <florian@openwrt.org>
  *
  * This driver is highly inspired from the cpu5_wdt driver
  *
@@ -36,8 +36,7 @@
 #include <linux/watchdog.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
-
-#include <asm/rdc321x_defs.h>
+#include <linux/mfd/rdc321x.h>
 
 #define RDC_WDT_MASK	0x80000000 /* Mask */
 #define RDC_WDT_EN	0x00800000 /* Enable bit */
@@ -63,6 +62,7 @@ static struct {
 	int default_ticks;
 	unsigned long inuse;
 	spinlock_t lock;
+	int base_reg;
 } rdc321x_wdt_device;
 
 /* generic helper functions */
@@ -70,14 +70,16 @@ static struct {
 static void rdc321x_wdt_trigger(unsigned long unused)
 {
 	unsigned long flags;
+	u32 val;
 
 	if (rdc321x_wdt_device.running)
 		ticks--;
 
 	/* keep watchdog alive */
 	spin_lock_irqsave(&rdc321x_wdt_device.lock, flags);
-	outl(RDC_WDT_EN | inl(RDC3210_CFGREG_DATA),
-		RDC3210_CFGREG_DATA);
+	rdc321x_pci_read(rdc321x_wdt_device.base_reg, &val);
+	val |= RDC_WDT_EN;
+	rdc321x_pci_write(rdc321x_wdt_device.base_reg, val);
 	spin_unlock_irqrestore(&rdc321x_wdt_device.lock, flags);
 
 	/* requeue?? */
@@ -105,10 +107,11 @@ static void rdc321x_wdt_start(void)
 
 		/* Clear the timer */
 		spin_lock_irqsave(&rdc321x_wdt_device.lock, flags);
-		outl(RDC_CLS_TMR, RDC3210_CFGREG_ADDR);
+		rdc321x_pci_write(rdc321x_wdt_device.base_reg, RDC_CLS_TMR);
 
 		/* Enable watchdog and set the timeout to 81.92 us */
-		outl(RDC_WDT_EN | RDC_WDT_CNT, RDC3210_CFGREG_DATA);
+		rdc321x_pci_write(rdc321x_wdt_device.base_reg,
+					RDC_WDT_EN | RDC_WDT_CNT);
 		spin_unlock_irqrestore(&rdc321x_wdt_device.lock, flags);
 
 		mod_timer(&rdc321x_wdt_device.timer,
@@ -148,7 +151,7 @@ static long rdc321x_wdt_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
-	unsigned int value;
+	u32 value;
 	static const struct watchdog_info ident = {
 		.options = WDIOF_CARDRESET,
 		.identity = "RDC321x WDT",
@@ -162,9 +165,9 @@ static long rdc321x_wdt_ioctl(struct file *file, unsigned int cmd,
 	case WDIOC_GETSTATUS:
 		/* Read the value from the DATA register */
 		spin_lock_irqsave(&rdc321x_wdt_device.lock, flags);
-		value = inl(RDC3210_CFGREG_DATA);
+		rdc321x_pci_read(rdc321x_wdt_device.base_reg, &value);
 		spin_unlock_irqrestore(&rdc321x_wdt_device.lock, flags);
-		if (copy_to_user(argp, &value, sizeof(int)))
+		if (copy_to_user(argp, &value, sizeof(u32)))
 			return -EFAULT;
 		break;
 	case WDIOC_GETSUPPORT:
@@ -219,17 +222,26 @@ static struct miscdevice rdc321x_wdt_misc = {
 static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
 {
 	int err;
+	struct resource *r;
+
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "wdt-reg");
+	if (!r) {
+		dev_err(&pdev->dev, "failed to get wdt-reg resource\n");
+		return -ENODEV;
+	}
+
+	rdc321x_wdt_device.base_reg = r->start;
 
 	err = misc_register(&rdc321x_wdt_misc);
 	if (err < 0) {
-		printk(KERN_ERR PFX "watchdog misc_register failed\n");
+		dev_err(&pdev->dev, "misc_register failed\n");
 		return err;
 	}
 
 	spin_lock_init(&rdc321x_wdt_device.lock);
 
 	/* Reset the watchdog */
-	outl(RDC_WDT_RST, RDC3210_CFGREG_DATA);
+	rdc321x_pci_write(rdc321x_wdt_device.base_reg, RDC_WDT_RST);
 
 	init_completion(&rdc321x_wdt_device.stop);
 	rdc321x_wdt_device.queue = 0;
@@ -240,7 +252,7 @@ static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
 
 	rdc321x_wdt_device.default_ticks = ticks;
 
-	printk(KERN_INFO PFX "watchdog init success\n");
+	dev_info(&pdev->dev, "watchdog init success\n");
 
 	return 0;
 }
