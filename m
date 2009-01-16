Return-Path: <linux-kernel-owner+w=401wt.eu-S1762229AbZAPI3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762229AbZAPI3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761959AbZAPI1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:27:49 -0500
Received: from smtp.nokia.com ([192.100.122.233]:41537 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761858AbZAPI1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:27:47 -0500
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH 05/10] omap mailbox: fix empty struct device for omap1
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org
Date: Fri, 16 Jan 2009 10:27:27 +0200
Message-ID: <20090116082727.17571.87307.stgit@oreo.research.nokia.com>
In-Reply-To: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
References: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 08:27:28.0386 (UTC) FILETIME=[44807E20:01C977B4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---

 arch/arm/mach-omap1/devices.c |    2 +-
 arch/arm/mach-omap1/mailbox.c |   31 +++++++++++++++++--------------
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-omap1/devices.c b/arch/arm/mach-omap1/devices.c
index 77382d8..b4b6106 100644
--- a/arch/arm/mach-omap1/devices.c
+++ b/arch/arm/mach-omap1/devices.c
@@ -86,7 +86,7 @@ static struct resource mbox_resources[] = {
 };
 
 static struct platform_device mbox_device = {
-	.name		= "mailbox",
+	.name		= "omap1-mailbox",
 	.id		= -1,
 	.num_resources	= ARRAY_SIZE(mbox_resources),
 	.resource	= mbox_resources,
diff --git a/arch/arm/mach-omap1/mailbox.c b/arch/arm/mach-omap1/mailbox.c
index 59abbf3..87539db 100644
--- a/arch/arm/mach-omap1/mailbox.c
+++ b/arch/arm/mach-omap1/mailbox.c
@@ -1,7 +1,7 @@
 /*
  * Mailbox reservation modules for DSP
  *
- * Copyright (C) 2006 Nokia Corporation
+ * Copyright (C) 2006-2008 Nokia Corporation
  * Written by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -17,6 +17,8 @@
 #include <mach/mailbox.h>
 #include <mach/irqs.h>
 
+#define DRV_NAME "omap1-mailbox"
+
 #define MAILBOX_ARM2DSP1		0x00
 #define MAILBOX_ARM2DSP1b		0x04
 #define MAILBOX_DSP2ARM1		0x08
@@ -27,7 +29,7 @@
 #define MAILBOX_DSP2ARM1_Flag		0x1c
 #define MAILBOX_DSP2ARM2_Flag		0x20
 
-unsigned long mbox_base;
+static void __iomem *mbox_base;
 
 struct omap_mbox1_fifo {
 	unsigned long cmd;
@@ -40,14 +42,14 @@ struct omap_mbox1_priv {
 	struct omap_mbox1_fifo rx_fifo;
 };
 
-static inline int mbox_read_reg(unsigned int reg)
+static inline int mbox_read_reg(size_t ofs)
 {
-	return __raw_readw(mbox_base + reg);
+	return __raw_readw(mbox_base + ofs);
 }
 
-static inline void mbox_write_reg(unsigned int val, unsigned int reg)
+static inline void mbox_write_reg(u32 val, size_t ofs)
 {
-	__raw_writew(val, mbox_base + reg);
+	__raw_writew(val, mbox_base + ofs);
 }
 
 /* msg */
@@ -143,7 +145,7 @@ struct omap_mbox mbox_dsp_info = {
 };
 EXPORT_SYMBOL(mbox_dsp_info);
 
-static int __init omap1_mbox_probe(struct platform_device *pdev)
+static int __devinit omap1_mbox_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	int ret = 0;
@@ -170,12 +172,10 @@ static int __init omap1_mbox_probe(struct platform_device *pdev)
 	}
 	mbox_dsp_info.irq = res->start;
 
-	ret = omap_mbox_register(&mbox_dsp_info);
-
-	return ret;
+	return omap_mbox_register(&pdev->dev, &mbox_dsp_info);
 }
 
-static int omap1_mbox_remove(struct platform_device *pdev)
+static int __devexit omap1_mbox_remove(struct platform_device *pdev)
 {
 	omap_mbox_unregister(&mbox_dsp_info);
 
@@ -184,9 +184,9 @@ static int omap1_mbox_remove(struct platform_device *pdev)
 
 static struct platform_driver omap1_mbox_driver = {
 	.probe	= omap1_mbox_probe,
-	.remove	= omap1_mbox_remove,
+	.remove	= __devexit_p(omap1_mbox_remove),
 	.driver	= {
-		.name	= "mailbox",
+		.name	= DRV_NAME,
 	},
 };
 
@@ -203,4 +203,7 @@ static void __exit omap1_mbox_exit(void)
 module_init(omap1_mbox_init);
 module_exit(omap1_mbox_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("omap mailbox: omap1 architecture specific functions");
+MODULE_AUTHOR("Hiroshi DOYU" <Hiroshi.DOYU@nokia.com>);
+MODULE_ALIAS("platform:"DRV_NAME);

