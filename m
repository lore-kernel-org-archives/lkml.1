Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbZFENku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbZFENku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbZFENkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:40:33 -0400
Received: from av8-1-sn3.vrr.skanova.net ([81.228.9.183]:60710 "EHLO
	av8-1-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbZFENkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:40:31 -0400
Message-ID: <4A292050.7010602@mocean-labs.com>
Date: Fri, 05 Jun 2009 15:40:32 +0200
From: =?ISO-8859-15?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-i2c@vger.kernel.org,
       Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH 3/9] I2C: i2c-ocores: Can add I2C devices to the bus
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is sometimes a need for the ocores driver to add devices to the
bus when installed.

i2c_register_board_info can not always be used, because the I2C devices
 are not known at an early state, they could for instance be connected
 on a I2C bus on a PCI device which has the Open Cores IP.

i2c_new_device can not be used in all cases either since the resulting
bus nummer might be unknown.

The solution is the pass a list of I2C devices in the platform data to
the Open Cores driver. This is useful for MFD drivers.

Signed-off-by: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>
---
Index: linux-2.6.30-rc7/drivers/i2c/busses/i2c-ocores.c
===================================================================
--- linux-2.6.30-rc7/drivers/i2c/busses/i2c-ocores.c	(revision 861)
+++ linux-2.6.30-rc7/drivers/i2c/busses/i2c-ocores.c	(working copy)
@@ -216,6 +216,7 @@
 	struct ocores_i2c_platform_data *pdata;
 	struct resource *res, *res2;
 	int ret;
+	int i;

 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
@@ -271,6 +272,10 @@
 		goto add_adapter_failed;
 	}

+	/* add in known devices to the bus */
+	for (i = 0; i < pdata->num_devices; i++)
+		i2c_new_device(&i2c->adap, pdata->devices + i);
+
 	return 0;

 add_adapter_failed:
Index: linux-2.6.30-rc7/Documentation/i2c/busses/i2c-ocores
===================================================================
--- linux-2.6.30-rc7/Documentation/i2c/busses/i2c-ocores	(revision 861)
+++ linux-2.6.30-rc7/Documentation/i2c/busses/i2c-ocores	(working copy)
@@ -20,6 +20,8 @@
 dev.platform_data of the device should also point to a struct
 ocores_i2c_platform_data (see linux/i2c-ocores.h) describing the
 distance between registers and the input clock speed.
+There is also a possibility to attach a list of i2c_board_info which
+the i2c-ocores driver will add to the bus upon creation.

 E.G. something like:

@@ -36,9 +38,24 @@
 	},
 };

+/* optional board info */
+struct i2c_board_info ocores_i2c_board_info[] = {
+	{
+		I2C_BOARD_INFO("tsc2003", 0x48),
+		.platform_data = &tsc2003_platform_data,
+		.irq = TSC_IRQ
+	},
+	{
+		I2C_BOARD_INFO("adv7180", 0x42 >> 1),
+		.irq = ADV_IRQ
+	}
+};
+
 static struct ocores_i2c_platform_data myi2c_data = {
 	.regstep	= 2,		/* two bytes between registers */
 	.clock_khz	= 50000,	/* input clock of 50MHz */
+	.devices	= ocores_i2c_board_info, /* optional table of devices */
+	.num_devices	= ARRAY_SIZE(ocores_i2c_board_info), /* table size */
 };

 static struct platform_device myi2c = {
Index: linux-2.6.30-rc7/include/linux/i2c-ocores.h
===================================================================
--- linux-2.6.30-rc7/include/linux/i2c-ocores.h	(revision 861)
+++ linux-2.6.30-rc7/include/linux/i2c-ocores.h	(working copy)
@@ -14,6 +14,8 @@
 struct ocores_i2c_platform_data {
 	u32 regstep;   /* distance between registers */
 	u32 clock_khz; /* input clock in kHz */
+	u8 num_devices; /* number of devices in the devices list */
+	struct i2c_board_info const *devices; /* devices connected to the bus */
 };

 #endif /* _LINUX_I2C_OCORES_H */
