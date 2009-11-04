Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbZKDNXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbZKDNXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbZKDNXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:23:21 -0500
Received: from smtp.nokia.com ([192.100.122.230]:40539 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039AbZKDNXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:23:20 -0500
From: Aaro Koskinen <aaro.koskinen@nokia.com>
To: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       tony@atomide.com
Cc: Aaro Koskinen <aaro.koskinen@nokia.com>
Subject: [PATCH v2 2/2] omap: RX-51: enable tsc2005
Date: Wed,  4 Nov 2009 15:23:02 +0200
Message-Id: <1257340982-22814-2-git-send-email-aaro.koskinen@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1257340982-22814-1-git-send-email-aaro.koskinen@nokia.com>
References: <1257340982-22814-1-git-send-email-aaro.koskinen@nokia.com>
X-OriginalArrivalTime: 04 Nov 2009 13:23:11.0497 (UTC) FILETIME=[F4D75F90:01CA5D51]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable tsc2005 touchscreen driver on the RX-51 board.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
---

The patch is for 2.6.32-rc6.

 arch/arm/configs/rx51_defconfig              |    1 +
 arch/arm/mach-omap2/board-rx51-peripherals.c |   66 ++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/rx51_defconfig b/arch/arm/configs/rx51_defconfig
index e7e3133..b10de8f 100644
--- a/arch/arm/configs/rx51_defconfig
+++ b/arch/arm/configs/rx51_defconfig
@@ -802,6 +802,7 @@ CONFIG_INPUT_TOUCHSCREEN=y
 # CONFIG_TOUCHSCREEN_TOUCHWIN is not set
 # CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
 # CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
+CONFIG_TOUCHSCREEN_TSC2005=m
 # CONFIG_TOUCHSCREEN_TSC2007 is not set
 CONFIG_INPUT_MISC=y
 # CONFIG_INPUT_ATI_REMOTE is not set
diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index e34d96a..ff3869a 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -14,6 +14,7 @@
 #include <linux/input.h>
 #include <linux/input/matrix_keypad.h>
 #include <linux/spi/spi.h>
+#include <linux/spi/tsc2005.h>
 #include <linux/i2c.h>
 #include <linux/i2c/twl4030.h>
 #include <linux/clk.h>
@@ -509,6 +510,68 @@ static inline void board_onenand_init(void)
 
 #endif
 
+#define	RX51_TSC2005_RESET_GPIO	104
+#define	RX51_TSC2005_IRQ_GPIO	100
+
+static struct omap2_mcspi_device_config tsc2005_mcspi_config = {
+	.turbo_mode     = 0,
+	.single_channel = 1,
+};
+
+static struct tsc2005_platform_data tsc2005_config = {
+	.ts_x_plate_ohm		= 280,
+	.ts_hw_avg		= 0,
+	.ts_touch_pressure	= 1500,
+	.ts_stab_time		= 1000,
+	.ts_pressure_max	= 2048,
+	.ts_pressure_fudge	= 2,
+	.ts_x_max		= 4096,
+	.ts_x_fudge		= 4,
+	.ts_y_max		= 4096,
+	.ts_y_fudge		= 7,
+
+	.esd_timeout		= 8*1000, /* ms of inactivity before we check */
+
+	.set_reset		= NULL,
+};
+
+static void rx51_tsc2005_set_reset(bool enable)
+{
+	gpio_set_value(RX51_TSC2005_RESET_GPIO, enable);
+}
+
+static void __init rx51_init_tsc2005(void)
+{
+	int r;
+
+	r = gpio_request(RX51_TSC2005_IRQ_GPIO, "tsc2005 DAV IRQ");
+	if (r >= 0)
+		gpio_direction_input(RX51_TSC2005_IRQ_GPIO);
+	else
+		printk(KERN_ERR "unable to get %s GPIO\n", "tsc2005 DAV IRQ");
+
+	r = gpio_request(RX51_TSC2005_RESET_GPIO, "tsc2005 reset");
+	if (r >= 0) {
+		gpio_direction_output(RX51_TSC2005_RESET_GPIO, 1);
+		tsc2005_config.set_reset = rx51_tsc2005_set_reset;
+	} else {
+		printk(KERN_ERR "unable to get %s GPIO\n", "tsc2005 reset");
+		tsc2005_config.esd_timeout = 0;
+	}
+}
+
+static struct spi_board_info rx51_peripherals_spi_board_info[] = {
+	[0] = {
+		.modalias		= "tsc2005",
+		.bus_num		= 1,
+		.chip_select		= 0,
+		.irq			= OMAP_GPIO_IRQ(RX51_TSC2005_IRQ_GPIO),
+		.max_speed_hz		= 6000000,
+		.controller_data	= &tsc2005_mcspi_config,
+		.platform_data		= &tsc2005_config,
+	},
+};
+
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
 
 static struct omap_smc91x_platform_data board_smc91x_data = {
@@ -538,6 +601,9 @@ static inline void board_smc91x_init(void)
 
 void __init rx51_peripherals_init(void)
 {
+	spi_register_board_info(rx51_peripherals_spi_board_info,
+				ARRAY_SIZE(rx51_peripherals_spi_board_info));
+	rx51_init_tsc2005();
 	rx51_i2c_init();
 	board_onenand_init();
 	board_smc91x_init();
-- 
1.6.0.4

