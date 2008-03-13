Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYCMQLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYCMQLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYCMQLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:11:24 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:27732 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYCMQLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:11:23 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>
Subject: [PATCH 09/10] avr32: Add system device for the internal interrupt controller (intc)
Date: Thu, 13 Mar 2008 15:39:44 +0100
Message-Id: <1205419185-26395-10-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205419185-26395-9-git-send-email-hskinnemoen@atmel.com>
References: <>
 <1205419185-26395-1-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-2-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-3-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-4-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-5-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-6-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-7-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-8-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-9-git-send-email-hskinnemoen@atmel.com>
X-OriginalArrivalTime: 13 Mar 2008 14:39:46.0571 (UTC) FILETIME=[157445B0:01C88518]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.5.4.3

