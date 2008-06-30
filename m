Return-Path: <linux-kernel-owner+w=401wt.eu-S1759562AbYF3JWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562AbYF3JWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbYF3JWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:22:09 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:62537 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809AbYF3JWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:22:06 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 7/8] avr32: Add system device for the internal interrupt controller (intc)
Date: Mon, 30 Jun 2008 11:21:15 +0200
Message-Id: <1214817676-30378-8-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214817676-30378-7-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214817676-30378-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-4-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-5-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-6-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-7-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 30 Jun 2008 09:21:08.0039 (UTC) FILETIME=[A0F28D70:01C8DA92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haavard Skinnemoen <hskinnemoen@atmel.com>

This makes the intc show up in sysfs (probably not very useful), and
allows us to easily add suspend/resume support later.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/mach-at32ap/intc.c |   28 +++++++++++++++++++++++++---
 1 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/avr32/mach-at32ap/intc.c b/arch/avr32/mach-at32ap/intc.c
index 097cf4e..644a3fb 100644
--- a/arch/avr32/mach-at32ap/intc.c
+++ b/arch/avr32/mach-at32ap/intc.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2006 Atmel Corporation
+ * Copyright (C) 2006, 2008 Atmel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -12,14 +12,16 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/platform_device.h>
+#include <linux/sysdev.h>
 
 #include <asm/io.h>
 
 #include "intc.h"
 
 struct intc {
-	void __iomem	*regs;
-	struct irq_chip	chip;
+	void __iomem		*regs;
+	struct irq_chip		chip;
+	struct sys_device	sysdev;
 };
 
 extern struct platform_device at32_intc0_device;
@@ -136,6 +138,26 @@ fail:
 	panic("Interrupt controller initialization failed!\n");
 }
 
+static struct sysdev_class intc_class = {
+	.name	= "intc",
+};
+
+static int __init intc_init_sysdev(void)
+{
+	int ret;
+
+	ret = sysdev_class_register(&intc_class);
+	if (ret)
+		return ret;
+
+	intc0.sysdev.id = 0;
+	intc0.sysdev.cls = &intc_class;
+	ret = sysdev_register(&intc0.sysdev);
+
+	return ret;
+}
+device_initcall(intc_init_sysdev);
+
 unsigned long intc_get_pending(unsigned int group)
 {
 	return intc_readl(&intc0, INTREQ0 + 4 * group);
-- 
1.5.5.4

