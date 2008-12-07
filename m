Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbYLGVsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbYLGVsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 16:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbYLGVrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 16:47:52 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:59720 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbYLGVrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 16:47:49 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+GDcdixaVQ72EgsAd11d7o
Subject: [PATCH 2/5] omap mmc: Add better MMC low-level init
To: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
From: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org
Date: Sun, 07 Dec 2008 13:47:47 -0800
Message-ID: <20081207214747.10456.34844.stgit@localhost>
In-Reply-To: <20081207213617.10456.43951.stgit@localhost>
References: <20081207213617.10456.43951.stgit@localhost>
User-Agent: Whatever/0.14.3.285.g62874
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will simplify the MMC low-level init, and make it more
flexible to add support for a newer MMC controller in the
following patches.

The patch rearranges platform data and gets rid of slot vs
controller confusion in the old data structures. Also fix
device id numbering in the clock code.

Some code snippets are based on an earlier patch by
Russell King <linux@arm.linux.org.uk>.

Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-h2-mmc.c         |   63 ++++++++
 arch/arm/mach-omap1/board-h2.c             |   15 ++
 arch/arm/mach-omap1/board-h3-mmc.c         |   50 ++++++
 arch/arm/mach-omap1/board-innovator.c      |   50 +++++-
 arch/arm/mach-omap1/board-nokia770.c       |   74 +++++++--
 arch/arm/mach-omap1/board-sx1-mmc.c        |   31 +---
 arch/arm/mach-omap1/clock.h                |    3 
 arch/arm/mach-omap1/devices.c              |   90 +++++++++++
 arch/arm/mach-omap2/clock24xx.h            |    9 -
 arch/arm/mach-omap2/clock34xx.h            |   10 -
 arch/arm/mach-omap2/devices.c              |   83 ++++++++++
 arch/arm/plat-omap/devices.c               |  225 ++++------------------------
 arch/arm/plat-omap/include/mach/board-h2.h |    6 -
 arch/arm/plat-omap/include/mach/board.h    |   22 ---
 arch/arm/plat-omap/include/mach/mmc.h      |   74 ++++++++-
 drivers/mmc/host/omap.c                    |    7 -
 16 files changed, 529 insertions(+), 283 deletions(-)

diff --git a/arch/arm/mach-omap1/board-h2-mmc.c b/arch/arm/mach-omap1/board-h2-mmc.c
index 504ae88..409fa56 100644
--- a/arch/arm/mach-omap1/board-h2-mmc.c
+++ b/arch/arm/mach-omap1/board-h2-mmc.c
@@ -12,13 +12,74 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/platform_device.h>
+
+#include <linux/i2c/tps65010.h>
+
 #include <mach/mmc.h>
 #include <mach/gpio.h>
 
+#if defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE)
+
+static int mmc_set_power(struct device *dev, int slot, int power_on,
+				int vdd)
+{
+	if (power_on)
+		gpio_direction_output(H2_TPS_GPIO_MMC_PWR_EN, 1);
+	else
+		gpio_direction_output(H2_TPS_GPIO_MMC_PWR_EN, 0);
+
+	return 0;
+}
+
+static int mmc_late_init(struct device *dev)
+{
+	int ret;
+
+	ret = gpio_request(H2_TPS_GPIO_MMC_PWR_EN, "MMC power");
+	if (ret < 0)
+		return ret;
+
+	gpio_direction_output(H2_TPS_GPIO_MMC_PWR_EN, 0);
+
+	return ret;
+}
+
+static void mmc_shutdown(struct device *dev)
+{
+	gpio_free(H2_TPS_GPIO_MMC_PWR_EN);
+}
+
+/*
+ * H2 could use the following functions tested:
+ * - mmc_get_cover_state that uses OMAP_MPUIO(1)
+ * - mmc_get_wp that uses OMAP_MPUIO(3)
+ */
+static struct omap_mmc_platform_data mmc1_data = {
+	.nr_slots                       = 1,
+	.init				= mmc_late_init,
+	.shutdown			= mmc_shutdown,
+	.dma_mask			= 0xffffffff,
+	.slots[0]       = {
+		.set_power              = mmc_set_power,
+		.ocr_mask               = MMC_VDD_28_29 | MMC_VDD_30_31 |
+					  MMC_VDD_32_33 | MMC_VDD_33_34,
+		.name                   = "mmcblk",
+	},
+};
+
+static struct omap_mmc_platform_data *mmc_data[OMAP16XX_NR_MMC];
+
 void __init h2_mmc_init(void)
 {
+	mmc_data[0] = &mmc1_data;
+	omap1_init_mmc(mmc_data, OMAP16XX_NR_MMC);
 }
 
-void h2_mmc_slot_cover_handler(void *arg, int state)
+#else
+
+void __init h2_mmc_init(void)
 {
 }
+
+#endif
diff --git a/arch/arm/mach-omap1/board-h2.c b/arch/arm/mach-omap1/board-h2.c
index 125d8e2..b240c5f 100644
--- a/arch/arm/mach-omap1/board-h2.c
+++ b/arch/arm/mach-omap1/board-h2.c
@@ -345,10 +345,25 @@ static void __init h2_init_smc91x(void)
 	}
 }
 
+static int tps_setup(struct i2c_client *client, void *context)
+{
+	tps65010_config_vregs1(TPS_LDO2_ENABLE | TPS_VLDO2_3_0V |
+				TPS_LDO1_ENABLE | TPS_VLDO1_3_0V);
+
+	return 0;
+}
+
+static struct tps65010_board tps_board = {
+	.base		= H2_TPS_GPIO_BASE,
+	.outmask	= 0x0f,
+	.setup		= tps_setup,
+};
+
 static struct i2c_board_info __initdata h2_i2c_board_info[] = {
 	{
 		I2C_BOARD_INFO("tps65010", 0x48),
 		.irq            = OMAP_GPIO_IRQ(58),
+		.platform_data	= &tps_board,
 	}, {
 		I2C_BOARD_INFO("isp1301_omap", 0x2d),
 		.irq		= OMAP_GPIO_IRQ(2),
diff --git a/arch/arm/mach-omap1/board-h3-mmc.c b/arch/arm/mach-omap1/board-h3-mmc.c
index 0baba1c..fdfe793 100644
--- a/arch/arm/mach-omap1/board-h3-mmc.c
+++ b/arch/arm/mach-omap1/board-h3-mmc.c
@@ -12,13 +12,61 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/platform_device.h>
+
+#include <linux/i2c/tps65010.h>
+
 #include <mach/mmc.h>
 #include <mach/gpio.h>
 
+#if defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE)
+
+static int mmc_set_power(struct device *dev, int slot, int power_on,
+				int vdd)
+{
+	if (power_on)
+		gpio_direction_output(H3_TPS_GPIO_MMC_PWR_EN, 1);
+	else
+		gpio_direction_output(H3_TPS_GPIO_MMC_PWR_EN, 0);
+
+	return 0;
+}
+
+/*
+ * H3 could use the following functions tested:
+ * - mmc_get_cover_state that uses OMAP_MPUIO(1)
+ * - mmc_get_wp that maybe uses OMAP_MPUIO(3)
+ */
+static struct omap_mmc_platform_data mmc1_data = {
+	.nr_slots                       = 1,
+	.dma_mask			= 0xffffffff,
+	.slots[0]       = {
+		.set_power              = mmc_set_power,
+		.ocr_mask               = MMC_VDD_28_29 | MMC_VDD_30_31 |
+					  MMC_VDD_32_33 | MMC_VDD_33_34,
+		.name                   = "mmcblk",
+	},
+};
+
+static struct omap_mmc_platform_data *mmc_data[OMAP16XX_NR_MMC];
+
 void __init h3_mmc_init(void)
 {
+	int ret;
+
+	ret = gpio_request(H3_TPS_GPIO_MMC_PWR_EN, "MMC power");
+	if (ret < 0)
+		return;
+	gpio_direction_output(H3_TPS_GPIO_MMC_PWR_EN, 0);
+
+	mmc_data[0] = &mmc1_data;
+	omap1_init_mmc(mmc_data, OMAP16XX_NR_MMC);
 }
 
-void h3_mmc_slot_cover_handler(void *arg, int state)
+#else
+
+void __init h3_mmc_init(void)
 {
 }
+
+#endif
diff --git a/arch/arm/mach-omap1/board-innovator.c b/arch/arm/mach-omap1/board-innovator.c
index dd6b54a..eee0657 100644
--- a/arch/arm/mach-omap1/board-innovator.c
+++ b/arch/arm/mach-omap1/board-innovator.c
@@ -39,6 +39,7 @@
 #include <mach/common.h>
 #include <mach/mcbsp.h>
 #include <mach/omap-alsa.h>
+#include <mach/mmc.h>
 
 static int innovator_keymap[] = {
 	KEY(0, 0, KEY_F1),
@@ -360,16 +361,49 @@ static struct omap_lcd_config innovator1610_lcd_config __initdata = {
 };
 #endif
 
-static struct omap_mmc_config innovator_mmc_config __initdata = {
-	.mmc [0] = {
-		.enabled 	= 1,
-		.wire4		= 1,
-		.wp_pin		= OMAP_MPUIO(3),
-		.power_pin	= -1,	/* FPGA F3 UIO42 */
-		.switch_pin	= -1,	/* FPGA F4 UIO43 */
+#if defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE)
+
+static int mmc_set_power(struct device *dev, int slot, int power_on,
+				int vdd)
+{
+	if (power_on)
+		fpga_write(fpga_read(OMAP1510_FPGA_POWER) | (1 << 3),
+				OMAP1510_FPGA_POWER);
+	else
+		fpga_write(fpga_read(OMAP1510_FPGA_POWER) & ~(1 << 3),
+				OMAP1510_FPGA_POWER);
+
+	return 0;
+}
+
+/*
+ * Innovator could use the following functions tested:
+ * - mmc_get_wp that uses OMAP_MPUIO(3)
+ * - mmc_get_cover_state that uses FPGA F4 UIO43
+ */
+static struct omap_mmc_platform_data mmc1_data = {
+	.nr_slots                       = 1,
+	.slots[0]       = {
+		.set_power		= mmc_set_power,
+		.wire4			= 1,
+		.name                   = "mmcblk",
 	},
 };
 
+static struct omap_mmc_platform_data *mmc_data[OMAP16XX_NR_MMC];
+
+void __init innovator_mmc_init(void)
+{
+	mmc_data[0] = &mmc1_data;
+	omap1_init_mmc(mmc_data, OMAP15XX_NR_MMC);
+}
+
+#else
+static inline void innovator_mmc_init(void)
+{
+}
+#endif
+
 static struct omap_uart_config innovator_uart_config __initdata = {
 	.enabled_uarts = ((1 << 0) | (1 << 1) | (1 << 2)),
 };
@@ -377,7 +411,6 @@ static struct omap_uart_config innovator_uart_config __initdata = {
 static struct omap_board_config_kernel innovator_config[] = {
 	{ OMAP_TAG_USB,         NULL },
 	{ OMAP_TAG_LCD,		NULL },
-	{ OMAP_TAG_MMC,		&innovator_mmc_config },
 	{ OMAP_TAG_UART,	&innovator_uart_config },
 };
 
@@ -412,6 +445,7 @@ static void __init innovator_init(void)
 	omap_board_config_size = ARRAY_SIZE(innovator_config);
 	omap_serial_init();
 	omap_register_i2c_bus(1, 100, NULL, 0);
+	innovator_mmc_init();
 }
 
 static void __init innovator_map_io(void)
diff --git a/arch/arm/mach-omap1/board-nokia770.c b/arch/arm/mach-omap1/board-nokia770.c
index b267824..4970c40 100644
--- a/arch/arm/mach-omap1/board-nokia770.c
+++ b/arch/arm/mach-omap1/board-nokia770.c
@@ -35,6 +35,7 @@
 #include <mach/aic23.h>
 #include <mach/omapfb.h>
 #include <mach/lcd_mipid.h>
+#include <mach/mmc.h>
 
 #define ADS7846_PENDOWN_GPIO	15
 
@@ -173,26 +174,68 @@ static struct omap_usb_config nokia770_usb_config __initdata = {
 	.pins[0]	= 6,
 };
 
-static struct omap_mmc_config nokia770_mmc_config __initdata = {
-	.mmc[0] = {
-		.enabled	= 0,
-		.wire4		= 0,
-		.wp_pin		= -1,
-		.power_pin	= -1,
-		.switch_pin	= -1,
-	},
-	.mmc[1] = {
-		.enabled	= 0,
-		.wire4		= 0,
-		.wp_pin		= -1,
-		.power_pin	= -1,
-		.switch_pin	= -1,
+#if defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE)
+
+#define NOKIA770_GPIO_MMC_POWER		41
+#define NOKIA770_GPIO_MMC_SWITCH	23
+
+static int nokia770_mmc_set_power(struct device *dev, int slot, int power_on,
+				int vdd)
+{
+	if (power_on)
+		gpio_set_value(NOKIA770_GPIO_MMC_POWER, 1);
+	else
+		gpio_set_value(NOKIA770_GPIO_MMC_POWER, 0);
+
+	return 0;
+}
+
+static int nokia770_mmc_get_cover_state(struct device *dev, int slot)
+{
+	return gpio_get_value(NOKIA770_GPIO_MMC_SWITCH);
+}
+
+static struct omap_mmc_platform_data nokia770_mmc2_data = {
+	.nr_slots                       = 1,
+	.dma_mask			= 0xffffffff,
+	.slots[0]       = {
+		.set_power		= nokia770_mmc_set_power,
+		.get_cover_state	= nokia770_mmc_get_cover_state,
+		.name                   = "mmcblk",
 	},
 };
 
+static struct omap_mmc_platform_data *nokia770_mmc_data[OMAP16XX_NR_MMC];
+
+static void __init nokia770_mmc_init(void)
+{
+	int ret;
+
+	ret = gpio_request(NOKIA770_GPIO_MMC_POWER, "MMC power");
+	if (ret < 0)
+		return;
+	gpio_direction_output(NOKIA770_GPIO_MMC_POWER, 0);
+
+	ret = gpio_request(NOKIA770_GPIO_MMC_SWITCH, "MMC cover");
+	if (ret < 0) {
+		gpio_free(NOKIA770_GPIO_MMC_POWER);
+		return;
+	}
+	gpio_direction_input(NOKIA770_GPIO_MMC_SWITCH);
+
+	/* Only the second MMC controller is used */
+	nokia770_mmc_data[1] = &nokia770_mmc2_data;
+	omap1_init_mmc(nokia770_mmc_data, OMAP16XX_NR_MMC);
+}
+
+#else
+static inline void nokia770_mmc_init(void)
+{
+}
+#endif
+
 static struct omap_board_config_kernel nokia770_config[] __initdata = {
 	{ OMAP_TAG_USB,		NULL },
-	{ OMAP_TAG_MMC,		&nokia770_mmc_config },
 };
 
 #if	defined(CONFIG_OMAP_DSP)
@@ -335,6 +378,7 @@ static void __init omap_nokia770_init(void)
 	omap_dsp_init();
 	ads7846_dev_init();
 	mipid_dev_init();
+	nokia770_mmc_init();
 }
 
 static void __init omap_nokia770_map_io(void)
diff --git a/arch/arm/mach-omap1/board-sx1-mmc.c b/arch/arm/mach-omap1/board-sx1-mmc.c
index 0ece109..66a4d7d 100644
--- a/arch/arm/mach-omap1/board-sx1-mmc.c
+++ b/arch/arm/mach-omap1/board-sx1-mmc.c
@@ -12,30 +12,20 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/platform_device.h>
+
 #include <mach/hardware.h>
 #include <mach/mmc.h>
 #include <mach/gpio.h>
 
-#ifdef CONFIG_MMC_OMAP
-static int slot_cover_open;
-static struct device *mmc_device;
+#if defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE)
 
-static int sx1_mmc_set_power(struct device *dev, int slot, int power_on,
+static int mmc_set_power(struct device *dev, int slot, int power_on,
 				int vdd)
 {
 	int err;
 	u8 dat = 0;
 
-#ifdef CONFIG_MMC_DEBUG
-	dev_dbg(dev, "Set slot %d power: %s (vdd %d)\n", slot + 1,
-		power_on ? "on" : "off", vdd);
-#endif
-
-	if (slot != 0) {
-		dev_err(dev, "No such slot %d\n", slot + 1);
-		return -ENODEV;
-	}
-
 	err = sx1_i2c_read_byte(SOFIA_I2C_ADDR, SOFIA_POWER1_REG, &dat);
 	if (err < 0)
 		return err;
@@ -48,19 +38,23 @@ static int sx1_mmc_set_power(struct device *dev, int slot, int power_on,
 	return sx1_i2c_write_byte(SOFIA_I2C_ADDR, SOFIA_POWER1_REG, dat);
 }
 
-static struct omap_mmc_platform_data sx1_mmc_data = {
+/* Cover switch is at OMAP_MPUIO(3) */
+static struct omap_mmc_platform_data mmc1_data = {
 	.nr_slots                       = 1,
 	.slots[0]       = {
-		.set_power              = sx1_mmc_set_power,
+		.set_power              = mmc_set_power,
 		.ocr_mask               = MMC_VDD_28_29 | MMC_VDD_30_31 |
 					  MMC_VDD_32_33 | MMC_VDD_33_34,
 		.name                   = "mmcblk",
 	},
 };
 
+static struct omap_mmc_platform_data *mmc_data[OMAP15XX_NR_MMC];
+
 void __init sx1_mmc_init(void)
 {
-	omap_set_mmc_info(1, &sx1_mmc_data);
+	mmc_data[0] = &mmc1_data;
+	omap1_init_mmc(mmc_data, OMAP15XX_NR_MMC);
 }
 
 #else
@@ -69,7 +63,4 @@ void __init sx1_mmc_init(void)
 {
 }
 
-void sx1_mmc_slot_cover_handler(void *arg, int state)
-{
-}
 #endif
diff --git a/arch/arm/mach-omap1/clock.h b/arch/arm/mach-omap1/clock.h
index 5635b51..c1dcdf1 100644
--- a/arch/arm/mach-omap1/clock.h
+++ b/arch/arm/mach-omap1/clock.h
@@ -705,7 +705,6 @@ static struct clk bclk_16xx = {
 
 static struct clk mmc1_ck = {
 	.name		= "mmc_ck",
-	.id		= 1,
 	/* Functional clock is direct from ULPD, interface clock is ARMPER */
 	.parent		= &armper_ck.clk,
 	.rate		= 48000000,
@@ -720,7 +719,7 @@ static struct clk mmc1_ck = {
 
 static struct clk mmc2_ck = {
 	.name		= "mmc_ck",
-	.id		= 2,
+	.id		= 1,
 	/* Functional clock is direct from ULPD, interface clock is ARMPER */
 	.parent		= &armper_ck.clk,
 	.rate		= 48000000,
diff --git a/arch/arm/mach-omap1/devices.c b/arch/arm/mach-omap1/devices.c
index e382b43..024dab1 100644
--- a/arch/arm/mach-omap1/devices.c
+++ b/arch/arm/mach-omap1/devices.c
@@ -22,6 +22,7 @@
 #include <mach/board.h>
 #include <mach/mux.h>
 #include <mach/gpio.h>
+#include <mach/mmc.h>
 
 /*-------------------------------------------------------------------------*/
 
@@ -99,6 +100,95 @@ static inline void omap_init_mbox(void)
 static inline void omap_init_mbox(void) { }
 #endif
 
+/*-------------------------------------------------------------------------*/
+
+#if defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE)
+
+static inline void omap1_mmc_mux(struct omap_mmc_platform_data *mmc_controller,
+			int controller_nr)
+{
+	if (controller_nr == 0) {
+		omap_cfg_reg(MMC_CMD);
+		omap_cfg_reg(MMC_CLK);
+		omap_cfg_reg(MMC_DAT0);
+		if (cpu_is_omap1710()) {
+			omap_cfg_reg(M15_1710_MMC_CLKI);
+			omap_cfg_reg(P19_1710_MMC_CMDDIR);
+			omap_cfg_reg(P20_1710_MMC_DATDIR0);
+		}
+		if (mmc_controller->slots[0].wire4) {
+			omap_cfg_reg(MMC_DAT1);
+			/* NOTE: DAT2 can be on W10 (here) or M15 */
+			if (!mmc_controller->slots[0].nomux)
+				omap_cfg_reg(MMC_DAT2);
+			omap_cfg_reg(MMC_DAT3);
+		}
+	}
+
+	/* Block 2 is on newer chips, and has many pinout options */
+	if (cpu_is_omap16xx() && controller_nr == 1) {
+		if (!mmc_controller->slots[1].nomux) {
+			omap_cfg_reg(Y8_1610_MMC2_CMD);
+			omap_cfg_reg(Y10_1610_MMC2_CLK);
+			omap_cfg_reg(R18_1610_MMC2_CLKIN);
+			omap_cfg_reg(W8_1610_MMC2_DAT0);
+			if (mmc_controller->slots[1].wire4) {
+				omap_cfg_reg(V8_1610_MMC2_DAT1);
+				omap_cfg_reg(W15_1610_MMC2_DAT2);
+				omap_cfg_reg(R10_1610_MMC2_DAT3);
+			}
+
+			/* These are needed for the level shifter */
+			omap_cfg_reg(V9_1610_MMC2_CMDDIR);
+			omap_cfg_reg(V5_1610_MMC2_DATDIR0);
+			omap_cfg_reg(W19_1610_MMC2_DATDIR1);
+		}
+
+		/* Feedback clock must be set on OMAP-1710 MMC2 */
+		if (cpu_is_omap1710())
+			omap_writel(omap_readl(MOD_CONF_CTRL_1) | (1 << 24),
+					MOD_CONF_CTRL_1);
+	}
+}
+
+void __init omap1_init_mmc(struct omap_mmc_platform_data **mmc_data,
+			int nr_controllers)
+{
+	int i;
+
+	for (i = 0; i < nr_controllers; i++) {
+		unsigned long base, size;
+		unsigned int irq = 0;
+
+		if (!mmc_data[i])
+			continue;
+
+		omap1_mmc_mux(mmc_data[i], i);
+
+		switch (i) {
+		case 0:
+			base = OMAP1_MMC1_BASE;
+			irq = INT_MMC;
+			break;
+		case 1:
+			if (!cpu_is_omap16xx())
+				return;
+			base = OMAP1_MMC2_BASE;
+			irq = INT_1610_MMC2;
+			break;
+		default:
+			continue;
+		}
+		size = OMAP1_MMC_SIZE;
+
+		omap_mmc_add(i, base, size, irq, mmc_data[i]);
+	};
+}
+
+#endif
+
+/*-------------------------------------------------------------------------*/
+
 #if defined(CONFIG_OMAP_STI)
 
 #define OMAP1_STI_BASE		0xfffea000
diff --git a/arch/arm/mach-omap2/clock24xx.h b/arch/arm/mach-omap2/clock24xx.h
index 242a19d..ff6cd14 100644
--- a/arch/arm/mach-omap2/clock24xx.h
+++ b/arch/arm/mach-omap2/clock24xx.h
@@ -2522,7 +2522,6 @@ static struct clk usbhs_ick = {
 
 static struct clk mmchs1_ick = {
 	.name		= "mmchs_ick",
-	.id		= 1,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -2533,7 +2532,6 @@ static struct clk mmchs1_ick = {
 
 static struct clk mmchs1_fck = {
 	.name		= "mmchs_fck",
-	.id		= 1,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l3_clkdm",
@@ -2544,7 +2542,7 @@ static struct clk mmchs1_fck = {
 
 static struct clk mmchs2_ick = {
 	.name		= "mmchs_ick",
-	.id		= 2,
+	.id		= 1,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -2555,7 +2553,7 @@ static struct clk mmchs2_ick = {
 
 static struct clk mmchs2_fck = {
 	.name		= "mmchs_fck",
-	.id		= 2,
+	.id		= 1,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
@@ -2595,7 +2593,6 @@ static struct clk mdm_intc_ick = {
 
 static struct clk mmchsdb1_fck = {
 	.name		= "mmchsdb_fck",
-	.id		= 1,
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
@@ -2606,7 +2603,7 @@ static struct clk mmchsdb1_fck = {
 
 static struct clk mmchsdb2_fck = {
 	.name		= "mmchsdb_fck",
-	.id		= 2,
+	.id		= 1,
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP243X,
 	.clkdm_name	= "core_l4_clkdm",
diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index 7217a08..a826094 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -1374,7 +1374,7 @@ static struct clk core_96m_fck = {
 
 static struct clk mmchs3_fck = {
 	.name		= "mmchs_fck",
-	.id		= 3,
+	.id		= 2,
 	.parent		= &core_96m_fck,
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430ES2_EN_MMC3_SHIFT,
@@ -1385,7 +1385,7 @@ static struct clk mmchs3_fck = {
 
 static struct clk mmchs2_fck = {
 	.name		= "mmchs_fck",
-	.id		= 2,
+	.id		= 1,
 	.parent		= &core_96m_fck,
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_MMC2_SHIFT,
@@ -1406,7 +1406,6 @@ static struct clk mspro_fck = {
 
 static struct clk mmchs1_fck = {
 	.name		= "mmchs_fck",
-	.id		= 1,
 	.parent		= &core_96m_fck,
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP3430_EN_MMC1_SHIFT,
@@ -1722,7 +1721,7 @@ static struct clk usbtll_ick = {
 
 static struct clk mmchs3_ick = {
 	.name		= "mmchs_ick",
-	.id		= 3,
+	.id		= 2,
 	.parent		= &core_l4_ick,
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430ES2_EN_MMC3_SHIFT,
@@ -1774,7 +1773,7 @@ static struct clk des2_ick = {
 
 static struct clk mmchs2_ick = {
 	.name		= "mmchs_ick",
-	.id		= 2,
+	.id		= 1,
 	.parent		= &core_l4_ick,
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MMC2_SHIFT,
@@ -1785,7 +1784,6 @@ static struct clk mmchs2_ick = {
 
 static struct clk mmchs1_ick = {
 	.name		= "mmchs_ick",
-	.id		= 1,
 	.parent		= &core_l4_ick,
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP3430_EN_MMC1_SHIFT,
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 90af2ac..8ccdfcf 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -24,6 +24,7 @@
 #include <mach/mux.h>
 #include <mach/gpio.h>
 #include <mach/eac.h>
+#include <mach/mmc.h>
 
 #if defined(CONFIG_OMAP_DSP) || defined(CONFIG_OMAP_DSP_MODULE)
 #define OMAP2_MBOX_BASE		IO_ADDRESS(OMAP24XX_MAILBOX_BASE)
@@ -295,6 +296,88 @@ static void omap_init_sha1_md5(void)
 static inline void omap_init_sha1_md5(void) { }
 #endif
 
+/*-------------------------------------------------------------------------*/
+
+#if defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE) || \
+	defined(CONFIG_MMC_OMAP_HS) || defined(CONFIG_MMC_OMAP_HS_MODULE)
+
+static inline void omap2_mmc_mux(struct omap_mmc_platform_data *mmc_controller,
+			int controller_nr)
+{
+	if (cpu_is_omap2420() && controller_nr == 0) {
+		omap_cfg_reg(H18_24XX_MMC_CMD);
+		omap_cfg_reg(H15_24XX_MMC_CLKI);
+		omap_cfg_reg(G19_24XX_MMC_CLKO);
+		omap_cfg_reg(F20_24XX_MMC_DAT0);
+		omap_cfg_reg(F19_24XX_MMC_DAT_DIR0);
+		omap_cfg_reg(G18_24XX_MMC_CMD_DIR);
+		if (mmc_controller->slots[0].wire4) {
+			omap_cfg_reg(H14_24XX_MMC_DAT1);
+			omap_cfg_reg(E19_24XX_MMC_DAT2);
+			omap_cfg_reg(D19_24XX_MMC_DAT3);
+			omap_cfg_reg(E20_24XX_MMC_DAT_DIR1);
+			omap_cfg_reg(F18_24XX_MMC_DAT_DIR2);
+			omap_cfg_reg(E18_24XX_MMC_DAT_DIR3);
+		}
+
+		/*
+		 * Use internal loop-back in MMC/SDIO Module Input Clock
+		 * selection
+		 */
+		if (mmc_controller->slots[0].internal_clock) {
+			u32 v = omap_ctrl_readl(OMAP2_CONTROL_DEVCONF0);
+			v |= (1 << 24);
+			omap_ctrl_writel(v, OMAP2_CONTROL_DEVCONF0);
+		}
+	}
+}
+
+void __init omap2_init_mmc(struct omap_mmc_platform_data **mmc_data,
+			int nr_controllers)
+{
+	int i;
+
+	for (i = 0; i < nr_controllers; i++) {
+		unsigned long base, size;
+		unsigned int irq = 0;
+
+		if (!mmc_data[i])
+			continue;
+
+		omap2_mmc_mux(mmc_data[i], i);
+
+		switch (i) {
+		case 0:
+			base = OMAP2_MMC1_BASE;
+			irq = INT_24XX_MMC_IRQ;
+			break;
+		case 1:
+			base = OMAP2_MMC2_BASE;
+			irq = INT_24XX_MMC2_IRQ;
+			break;
+		case 2:
+			if (!cpu_is_omap34xx())
+				return;
+			base = OMAP3_MMC3_BASE;
+			irq = INT_34XX_MMC3_IRQ;
+			break;
+		default:
+			continue;
+		}
+
+		if (cpu_is_omap2420())
+			size = OMAP2420_MMC_SIZE;
+		else
+			size = HSMMC_SIZE;
+
+		omap_mmc_add(i, base, size, irq, mmc_data[i]);
+	};
+}
+
+#endif
+
+/*-------------------------------------------------------------------------*/
+
 #if defined(CONFIG_HDQ_MASTER_OMAP) || defined(CONFIG_HDQ_MASTER_OMAP_MODULE)
 #if defined(CONFIG_ARCH_OMAP2430) || defined(CONFIG_ARCH_OMAP3430)
 #define OMAP_HDQ_BASE	0x480B2000
diff --git a/arch/arm/plat-omap/devices.c b/arch/arm/plat-omap/devices.c
index 0cb2b22..ac15c23 100644
--- a/arch/arm/plat-omap/devices.c
+++ b/arch/arm/plat-omap/devices.c
@@ -192,202 +192,48 @@ void omap_mcbsp_register_board_cfg(struct omap_mcbsp_platform_data *config,
 
 /*-------------------------------------------------------------------------*/
 
-#if	defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE) || \
+#if defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE) || \
 	defined(CONFIG_MMC_OMAP_HS) || defined(CONFIG_MMC_OMAP_HS_MODULE)
 
-#if defined(CONFIG_ARCH_OMAP24XX) || defined(CONFIG_ARCH_OMAP34XX)
-#define	OMAP_MMC1_BASE		0x4809c000
-#define	OMAP_MMC1_END		(OMAP_MMC1_BASE + 0x1fc)
-#define	OMAP_MMC1_INT		INT_24XX_MMC_IRQ
+#define OMAP_MMC_NR_RES		2
 
-#define	OMAP_MMC2_BASE		0x480b4000
-#define	OMAP_MMC2_END		(OMAP_MMC2_BASE + 0x1fc)
-#define	OMAP_MMC2_INT		INT_24XX_MMC2_IRQ
-
-#else
-
-#define	OMAP_MMC1_BASE		0xfffb7800
-#define	OMAP_MMC1_END		(OMAP_MMC1_BASE + 0x7f)
-#define OMAP_MMC1_INT		INT_MMC
-
-#define	OMAP_MMC2_BASE		0xfffb7c00	/* omap16xx only */
-#define	OMAP_MMC2_END		(OMAP_MMC2_BASE + 0x7f)
-#define	OMAP_MMC2_INT		INT_1610_MMC2
-
-#endif
-
-static struct omap_mmc_platform_data mmc1_data;
-
-static u64 mmc1_dmamask = 0xffffffff;
-
-static struct resource mmc1_resources[] = {
-	{
-		.start		= OMAP_MMC1_BASE,
-		.end		= OMAP_MMC1_END,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP_MMC1_INT,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device mmc_omap_device1 = {
-	.name		= "mmci-omap",
-	.id		= 1,
-	.dev = {
-		.dma_mask	= &mmc1_dmamask,
-		.platform_data	= &mmc1_data,
-	},
-	.num_resources	= ARRAY_SIZE(mmc1_resources),
-	.resource	= mmc1_resources,
-};
-
-#if defined(CONFIG_ARCH_OMAP16XX) || defined(CONFIG_ARCH_OMAP2430) || \
-	defined(CONFIG_ARCH_OMAP34XX)
-
-static struct omap_mmc_platform_data mmc2_data;
-
-static u64 mmc2_dmamask = 0xffffffff;
-
-static struct resource mmc2_resources[] = {
-	{
-		.start		= OMAP_MMC2_BASE,
-		.end		= OMAP_MMC2_END,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP_MMC2_INT,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device mmc_omap_device2 = {
-	.name		= "mmci-omap",
-	.id		= 2,
-	.dev = {
-		.dma_mask	= &mmc2_dmamask,
-		.platform_data	= &mmc2_data,
-	},
-	.num_resources	= ARRAY_SIZE(mmc2_resources),
-	.resource	= mmc2_resources,
-};
-#endif
-
-static inline void omap_init_mmc_conf(const struct omap_mmc_config *mmc_conf)
-{
-	if (cpu_is_omap2430() || cpu_is_omap34xx())
-		return;
-
-	if (mmc_conf->mmc[0].enabled) {
-		if (cpu_is_omap24xx()) {
-			omap_cfg_reg(H18_24XX_MMC_CMD);
-			omap_cfg_reg(H15_24XX_MMC_CLKI);
-			omap_cfg_reg(G19_24XX_MMC_CLKO);
-			omap_cfg_reg(F20_24XX_MMC_DAT0);
-			omap_cfg_reg(F19_24XX_MMC_DAT_DIR0);
-			omap_cfg_reg(G18_24XX_MMC_CMD_DIR);
-		} else {
-			omap_cfg_reg(MMC_CMD);
-			omap_cfg_reg(MMC_CLK);
-			omap_cfg_reg(MMC_DAT0);
-			if (cpu_is_omap1710()) {
-				omap_cfg_reg(M15_1710_MMC_CLKI);
-				omap_cfg_reg(P19_1710_MMC_CMDDIR);
-				omap_cfg_reg(P20_1710_MMC_DATDIR0);
-			}
-		}
-		if (mmc_conf->mmc[0].wire4) {
-			if (cpu_is_omap24xx()) {
-				omap_cfg_reg(H14_24XX_MMC_DAT1);
-				omap_cfg_reg(E19_24XX_MMC_DAT2);
-				omap_cfg_reg(D19_24XX_MMC_DAT3);
-				omap_cfg_reg(E20_24XX_MMC_DAT_DIR1);
-				omap_cfg_reg(F18_24XX_MMC_DAT_DIR2);
-				omap_cfg_reg(E18_24XX_MMC_DAT_DIR3);
-			} else {
-				omap_cfg_reg(MMC_DAT1);
-				/* NOTE:  DAT2 can be on W10 (here) or M15 */
-				if (!mmc_conf->mmc[0].nomux)
-					omap_cfg_reg(MMC_DAT2);
-				omap_cfg_reg(MMC_DAT3);
-			}
-		}
-	}
-
-#ifdef	CONFIG_ARCH_OMAP16XX
-	/* block 2 is on newer chips, and has many pinout options */
-	if (mmc_conf->mmc[1].enabled) {
-		if (!mmc_conf->mmc[1].nomux) {
-			omap_cfg_reg(Y8_1610_MMC2_CMD);
-			omap_cfg_reg(Y10_1610_MMC2_CLK);
-			omap_cfg_reg(R18_1610_MMC2_CLKIN);
-			omap_cfg_reg(W8_1610_MMC2_DAT0);
-			if (mmc_conf->mmc[1].wire4) {
-				omap_cfg_reg(V8_1610_MMC2_DAT1);
-				omap_cfg_reg(W15_1610_MMC2_DAT2);
-				omap_cfg_reg(R10_1610_MMC2_DAT3);
-			}
-
-			/* These are needed for the level shifter */
-			omap_cfg_reg(V9_1610_MMC2_CMDDIR);
-			omap_cfg_reg(V5_1610_MMC2_DATDIR0);
-			omap_cfg_reg(W19_1610_MMC2_DATDIR1);
-		}
-
-		/* Feedback clock must be set on OMAP-1710 MMC2 */
-		if (cpu_is_omap1710())
-			omap_writel(omap_readl(MOD_CONF_CTRL_1) | (1 << 24),
-				     MOD_CONF_CTRL_1);
-	}
-#endif
-}
-
-static void __init omap_init_mmc(void)
+/*
+ * Register MMC devices. Called from mach-omap1 and mach-omap2 device init.
+ */
+int __init omap_mmc_add(int id, unsigned long base, unsigned long size,
+		unsigned int irq, struct omap_mmc_platform_data *data)
 {
-	const struct omap_mmc_config	*mmc_conf;
-
-	/* NOTE:  assumes MMC was never (wrongly) enabled */
-	mmc_conf = omap_get_config(OMAP_TAG_MMC, struct omap_mmc_config);
-	if (!mmc_conf)
-		return;
-
-	omap_init_mmc_conf(mmc_conf);
-
-	if (mmc_conf->mmc[0].enabled) {
-		mmc1_data.conf = mmc_conf->mmc[0];
-		(void) platform_device_register(&mmc_omap_device1);
-	}
-
-#if defined(CONFIG_ARCH_OMAP16XX) || defined(CONFIG_ARCH_OMAP2430) || \
-	defined(CONFIG_ARCH_OMAP34XX)
-	if (mmc_conf->mmc[1].enabled) {
-		mmc2_data.conf = mmc_conf->mmc[1];
-		(void) platform_device_register(&mmc_omap_device2);
-	}
-#endif
-}
+	struct platform_device *pdev;
+	struct resource res[OMAP_MMC_NR_RES];
+	int ret;
+
+	pdev = platform_device_alloc("mmci-omap", id);
+	if (!pdev)
+		return -ENOMEM;
+
+	memset(res, 0, OMAP_MMC_NR_RES * sizeof(struct resource));
+	res[0].start = base;
+	res[0].end = base + size - 1;
+	res[0].flags = IORESOURCE_MEM;
+	res[1].start = res[1].end = irq;
+	res[1].flags = IORESOURCE_IRQ;
+
+	ret = platform_device_add_resources(pdev, res, ARRAY_SIZE(res));
+	if (ret == 0)
+		ret = platform_device_add_data(pdev, data, sizeof(*data));
+	if (ret)
+		goto fail;
+
+	ret = platform_device_add(pdev);
+	if (ret)
+		goto fail;
+	return 0;
 
-void omap_set_mmc_info(int host, const struct omap_mmc_platform_data *info)
-{
-	switch (host) {
-	case 1:
-		mmc1_data = *info;
-		break;
-#if defined(CONFIG_ARCH_OMAP16XX) || defined(CONFIG_ARCH_OMAP2430) || \
-	defined(CONFIG_ARCH_OMAP34XX)
-	case 2:
-		mmc2_data = *info;
-		break;
-#endif
-	default:
-		BUG();
-	}
+fail:
+	platform_device_put(pdev);
+	return ret;
 }
 
-#else
-static inline void omap_init_mmc(void) {}
-void omap_set_mmc_info(int host, const struct omap_mmc_platform_data *info) {}
 #endif
 
 /*-------------------------------------------------------------------------*/
@@ -532,7 +378,6 @@ static int __init omap_init_devices(void)
 	 */
 	omap_init_dsp();
 	omap_init_kp();
-	omap_init_mmc();
 	omap_init_uwire();
 	omap_init_wdt();
 	omap_init_rng();
diff --git a/arch/arm/plat-omap/include/mach/board-h2.h b/arch/arm/plat-omap/include/mach/board-h2.h
index 2a050e9..15531c8 100644
--- a/arch/arm/plat-omap/include/mach/board-h2.h
+++ b/arch/arm/plat-omap/include/mach/board-h2.h
@@ -29,13 +29,13 @@
 #ifndef __ASM_ARCH_OMAP_H2_H
 #define __ASM_ARCH_OMAP_H2_H
 
-/* Placeholder for H2 specific defines */
-
 /* At OMAP1610 Innovator the Ethernet is directly connected to CS1 */
 #define OMAP1610_ETHR_START		0x04000300
 
+#define H2_TPS_GPIO_BASE		(OMAP_MAX_GPIO_LINES + 16 /* MPUIO */)
+#	define H2_TPS_GPIO_MMC_PWR_EN	(H2_TPS_GPIO_BASE + 3)
+
 extern void h2_mmc_init(void);
-extern void h2_mmc_slot_cover_handler(void *arg, int state);
 
 #endif /*  __ASM_ARCH_OMAP_H2_H */
 
diff --git a/arch/arm/plat-omap/include/mach/board.h b/arch/arm/plat-omap/include/mach/board.h
index c23c12c..9466772 100644
--- a/arch/arm/plat-omap/include/mach/board.h
+++ b/arch/arm/plat-omap/include/mach/board.h
@@ -16,7 +16,6 @@
 
 /* Different peripheral ids */
 #define OMAP_TAG_CLOCK		0x4f01
-#define OMAP_TAG_MMC		0x4f02
 #define OMAP_TAG_SERIAL_CONSOLE 0x4f03
 #define OMAP_TAG_USB		0x4f04
 #define OMAP_TAG_LCD		0x4f05
@@ -35,27 +34,6 @@ struct omap_clock_config {
 	u8 system_clock_type;
 };
 
-struct omap_mmc_conf {
-	unsigned enabled:1;
-	/* nomux means "standard" muxing is wrong on this board, and that
-	 * board-specific code handled it before common init logic.
-	 */
-	unsigned nomux:1;
-	/* switch pin can be for card detect (default) or card cover */
-	unsigned cover:1;
-	/* 4 wire signaling is optional, and is only used for SD/SDIO */
-	unsigned wire4:1;
-	/* use the internal clock */
-	unsigned internal_clock:1;
-	s16 power_pin;
-	s16 switch_pin;
-	s16 wp_pin;
-};
-
-struct omap_mmc_config {
-	struct omap_mmc_conf mmc[2];
-};
-
 struct omap_serial_console_config {
 	u8 console_uart;
 	u32 console_speed;
diff --git a/arch/arm/plat-omap/include/mach/mmc.h b/arch/arm/plat-omap/include/mach/mmc.h
index fc15d13..0c2ef3b 100644
--- a/arch/arm/plat-omap/include/mach/mmc.h
+++ b/arch/arm/plat-omap/include/mach/mmc.h
@@ -17,12 +17,28 @@
 
 #include <mach/board.h>
 
+#define OMAP15XX_NR_MMC		1
+#define OMAP16XX_NR_MMC		2
+#define OMAP1_MMC_SIZE		0x080
+#define OMAP1_MMC1_BASE		0xfffb7800
+#define OMAP1_MMC2_BASE		0xfffb7c00	/* omap16xx only */
+
+#define OMAP24XX_NR_MMC		2
+#define OMAP34XX_NR_MMC		3
+#define OMAP2420_MMC_SIZE	OMAP1_MMC_SIZE
+#define HSMMC_SIZE		0x200
+#define OMAP2_MMC1_BASE		0x4809c000
+#define OMAP2_MMC2_BASE		0x480b4000
+#define OMAP3_MMC3_BASE		0x480ad000
+#define HSMMC3			(1 << 2)
+#define HSMMC2			(1 << 1)
+#define HSMMC1			(1 << 0)
+
 #define OMAP_MMC_MAX_SLOTS	2
 
 struct omap_mmc_platform_data {
-	struct omap_mmc_conf	conf;
 
-	/* number of slots on board */
+	/* number of slots per controller */
 	unsigned nr_slots:2;
 
 	/* set if your board has components or wiring that limits the
@@ -41,7 +57,27 @@ struct omap_mmc_platform_data {
 	int (*suspend)(struct device *dev, int slot);
 	int (*resume)(struct device *dev, int slot);
 
+	u64 dma_mask;
+
 	struct omap_mmc_slot_data {
+
+		/*
+		 * nomux means "standard" muxing is wrong on this board, and
+		 * that board-specific code handled it before common init logic.
+		 */
+		unsigned nomux:1;
+
+		/* switch pin can be for card detect (default) or card cover */
+		unsigned cover:1;
+
+		/* 4 wire signaling is optional, and is only used for SD/SDIO */
+		unsigned wire4:1;
+
+		/* use the internal clock */
+		unsigned internal_clock:1;
+		s16 power_pin;
+		s16 switch_pin;
+
 		int (* set_bus_mode)(struct device *dev, int slot, int bus_mode);
 		int (* set_power)(struct device *dev, int slot, int power_on, int vdd);
 		int (* get_ro)(struct device *dev, int slot);
@@ -49,8 +85,8 @@ struct omap_mmc_platform_data {
 		/* return MMC cover switch state, can be NULL if not supported.
 		 *
 		 * possible return values:
-		 *   0 - open
-		 *   1 - closed
+		 *   0 - closed
+		 *   1 - open
 		 */
 		int (* get_cover_state)(struct device *dev, int slot);
 
@@ -66,9 +102,35 @@ struct omap_mmc_platform_data {
 	} slots[OMAP_MMC_MAX_SLOTS];
 };
 
-extern void omap_set_mmc_info(int host, const struct omap_mmc_platform_data *info);
-
 /* called from board-specific card detection service routine */
 extern void omap_mmc_notify_cover_event(struct device *dev, int slot, int is_closed);
 
+#if	defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE) || \
+	defined(CONFIG_MMC_OMAP_HS) || defined(CONFIG_MMC_OMAP_HS_MODULE)
+void omap1_init_mmc(struct omap_mmc_platform_data **mmc_data,
+				int nr_controllers);
+void omap2_init_mmc(struct omap_mmc_platform_data **mmc_data,
+				int nr_controllers);
+void hsmmc_init(int controller_mask);
+int omap_mmc_add(int id, unsigned long base, unsigned long size,
+			unsigned int irq, struct omap_mmc_platform_data *data);
+#else
+static inline void omap1_init_mmc(struct omap_mmc_platform_data **mmc_data,
+				int nr_controllers)
+{
+}
+static inline void omap2_init_mmc(struct omap_mmc_platform_data **mmc_data,
+				int nr_controllers)
+{
+}
+static inline void hsmmc_init(int controller_mask)
+{
+}
+static inline int omap_mmc_add(int id, unsigned long base, unsigned long size,
+		unsigned int irq, struct omap_mmc_platform_data *data)
+{
+	return 0;
+}
+
+#endif
 #endif
diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 1b9fc3c..c6544d2 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1015,7 +1015,7 @@ static int mmc_omap_get_dma_channel(struct mmc_omap_host *host, struct mmc_data
 	}
 
 	if (is_read) {
-		if (host->id == 1) {
+		if (host->id == 0) {
 			sync_dev = OMAP_DMA_MMC_RX;
 			dma_dev_name = "MMC1 read";
 		} else {
@@ -1023,7 +1023,7 @@ static int mmc_omap_get_dma_channel(struct mmc_omap_host *host, struct mmc_data
 			dma_dev_name = "MMC2 read";
 		}
 	} else {
-		if (host->id == 1) {
+		if (host->id == 0) {
 			sync_dev = OMAP_DMA_MMC_TX;
 			dma_dev_name = "MMC1 write";
 		} else {
@@ -1317,7 +1317,7 @@ static int __init mmc_omap_new_slot(struct mmc_omap_host *host, int id)
 	host->slots[id] = slot;
 
 	mmc->caps = 0;
-	if (host->pdata->conf.wire4)
+	if (host->pdata->slots[id].wire4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
 	mmc->ops = &mmc_omap_ops;
@@ -1451,6 +1451,7 @@ static int __init mmc_omap_probe(struct platform_device *pdev)
 	host->irq = irq;
 
 	host->use_dma = 1;
+	host->dev->dma_mask = &pdata->dma_mask;
 	host->dma_ch = -1;
 
 	host->irq = irq;

