Return-Path: <linux-kernel-owner+w=401wt.eu-S1759363AbZCZOtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbZCZOtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758861AbZCZOsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:48:30 -0400
Received: from mx1.emlix.com ([193.175.82.87]:54194 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758828AbZCZOs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:48:27 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 3/5] xtensa: add mt9d131l demo head to s6105 platform
Date: Thu, 26 Mar 2009 15:49:32 +0100
Message-Id: <1238078974-26040-3-git-send-email-dg@emlix.com>
In-Reply-To: <1238078974-26040-1-git-send-email-dg@emlix.com>
References: <1238078974-26040-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mt9d131 is behind a pca9543 which needs to be configured before
we can find the sensor. Our s6_pca9543_callback is called directly
from pca9543_probe, so we may not call i2c_new_device immediately.

If Rodolfo Giometti's multiplexed i2c bus code and pca954x driver
is accepted, most of this patch can be replaced by a simple
i2c_register_board_info call.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/platforms/s6105/device.c |   35 ++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/platforms/s6105/device.c b/arch/xtensa/platforms/s6105/device.c
index 07fb329..ff047fc 100644
--- a/arch/xtensa/platforms/s6105/device.c
+++ b/arch/xtensa/platforms/s6105/device.c
@@ -207,9 +207,33 @@ static struct s6dp_link s6dp_links[] = {
 		.is_egress = 1,
 		.minor = 2,
 	},
+	{
+		.port_mask = 1 << 3,
+		.is_egress = 0,
+		.minor = 3,
+	},
 	{ }
 };
 
+static void s6_attach_camera(struct work_struct *ws)
+{
+	struct i2c_board_info mt9d131_bi = {
+		I2C_BOARD_INFO("mt9d131", S6I2C_ADDR_MT9D131),
+		.platform_data = &s6dp_links[1]
+	};
+	i2c_new_device(i2c_get_adapter(0), &mt9d131_bi);
+}
+
+static DECLARE_WORK(s6_attach_camera_work, s6_attach_camera);
+
+static void s6_pca9543_callback(struct i2c_client *client,
+				int (set_switch)(struct i2c_client *, unsigned))
+{
+	set_switch(client, 3);
+	/* i2c_attach_client does not look reentrant */
+	schedule_work(&s6_attach_camera_work);
+}
+
 static struct i2c_board_info __initdata s6_i2c_devices[] = {
 	{
 		I2C_BOARD_INFO("24c02", S6I2C_ADDR_AT24HC02B),
@@ -221,6 +245,10 @@ static struct i2c_board_info __initdata s6_i2c_devices[] = {
 		I2C_BOARD_INFO("saa7121", S6I2C_ADDR_SAA7121),
 		.platform_data = &s6dp_links[0],
 	},
+	{
+		I2C_BOARD_INFO("pca9543", S6I2C_ADDR_PCA9543),
+		.platform_data = &s6_pca9543_callback
+	},
 };
 
 static struct resource s6_isef_resource[] = {
@@ -453,6 +481,13 @@ static int __init device_init(void)
 		gpio_set_value(GPIO_BP_RESET, 1);
 	}
 
+	/* reset MT9D131 */
+	if (!gpio_request(GPIO_IMAGER_RESET, "imager_reset")) {
+		gpio_direction_output(GPIO_IMAGER_RESET, 0);
+		udelay(1);
+		gpio_set_value(GPIO_IMAGER_RESET, 1);
+	}
+
 	i2c_register_board_info(S6_I2C_BUS_NUM, s6_i2c_devices,
 				ARRAY_SIZE(s6_i2c_devices));
 	spi_register_board_info(s6_spi_devices, ARRAY_SIZE(s6_spi_devices));
-- 
1.6.2.107.ge47ee

