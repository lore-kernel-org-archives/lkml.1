Return-Path: <linux-kernel-owner+w=401wt.eu-S1761676AbZE1FPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761676AbZE1FPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 01:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760471AbZE1FOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 01:14:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:32734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760009AbZE1FOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 01:14:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JWzvo3EH0/ucikBsQfpJ4OwQYp71KFrc91WjfFckzFCDyZTPGEOtssov77WICOI93f
         iZplezXWix5fv6Wq8e7mQJs5p7FwIrWfdRrDlKYAJ4omykjWFTBcye2tDrdcXZccSyvY
         xBVgmSOjrp12SIBDh2b77v7o4boM8w0WMw9Cw=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Eric Miao <eric.miao@marvell.com>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 3/3] pxa/hx4700: add Maxim 1587A voltage regulator
Date: Thu, 28 May 2009 07:15:18 +0200
Message-Id: <1243487718-5423-4-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <878wkibmv9.fsf@free.fr>
References: <878wkibmv9.fsf@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On this board, the PXA270 CPU voltage VCC_CORE is provided
by a Maxim 1587A voltage regulator configured to provide
1.55 V maximum voltage for 624 MHz operation.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 arch/arm/mach-pxa/hx4700.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/hx4700.c b/arch/arm/mach-pxa/hx4700.c
index 0f65680..5bc1e2b 100644
--- a/arch/arm/mach-pxa/hx4700.c
+++ b/arch/arm/mach-pxa/hx4700.c
@@ -30,6 +30,7 @@
 #include <linux/pwm_backlight.h>
 #include <linux/regulator/bq24022.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/max1586.h>
 #include <linux/spi/ads7846.h>
 #include <linux/spi/spi.h>
 #include <linux/usb/gpio_vbus.h>
@@ -775,6 +776,45 @@ static struct platform_device strataflash = {
 };
 
 /*
+ * Maxim MAX1587A on PI2C
+ */
+
+static struct regulator_consumer_supply max1587a_consumer = {
+	.supply = "vcc_core",
+};
+
+static struct regulator_init_data max1587a_v3_info = {
+	.constraints = {
+		.name = "vcc_core range",
+		.min_uV =  900000,
+		.max_uV = 1705000,
+		.always_on = 1,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
+	},
+	.num_consumer_supplies = 1,
+	.consumer_supplies     = &max1587a_consumer,
+};
+
+static struct max1586_subdev_data max1587a_subdev = {
+	.name = "vcc_core",
+	.id   = MAX1586_V3,
+	.platform_data = &max1587a_v3_info,
+};
+
+static struct max1586_platform_data max1587a_info = {
+	.num_subdevs = 1,
+	.subdevs     = &max1587a_subdev,
+	.v3_gain     = MAX1586_GAIN_R24_3k32, /* 730..1550 mV */
+};
+
+static struct i2c_board_info __initdata pi2c_board_info[] = {
+	{
+		I2C_BOARD_INFO("max1586", 0x14),
+		.platform_data = &max1587a_info,
+	},
+};
+
+/*
  * PCMCIA
  */
 
@@ -828,6 +868,7 @@ static void __init hx4700_init(void)
 	pxa_set_ficp_info(&ficp_info);
 	pxa27x_set_i2c_power_info(NULL);
 	pxa_set_i2c_info(NULL);
+	i2c_register_board_info(1, ARRAY_AND_SIZE(pi2c_board_info));
 	pxa2xx_set_spi_info(2, &pxa_ssp2_master_info);
 	spi_register_board_info(ARRAY_AND_SIZE(tsc2046_board_info));
 
-- 
1.6.3.1

