Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbYLGVtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbYLGVtV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 16:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbYLGVtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 16:49:13 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:60136 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYLGVtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 16:49:08 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19RxVK3hK2xmY2xAb0AyEuQ
Subject: [PATCH 3/5] omap mmc: Add low-level initialization for hsmmc
	controller
To: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
From: Tony Lindgren <tony@atomide.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-omap@vger.kernel.org, Grazvydas Ignotas <notasas@gmail.com>
Date: Sun, 07 Dec 2008 13:49:05 -0800
Message-ID: <20081207214905.10456.20016.stgit@localhost>
In-Reply-To: <20081207213617.10456.43951.stgit@localhost>
References: <20081207213617.10456.43951.stgit@localhost>
User-Agent: Whatever/0.14.3.285.g62874
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add low-level initialization for hsmmc controller. Merged into
this patch patch are various improvments and board support by
Grazvydas Ignotas and David Brownell.

Also change wire4 to be wires, as some newer controllers support
8 data lines.

Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-innovator.c     |    2 
 arch/arm/mach-omap1/devices.c             |    4 
 arch/arm/mach-omap2/Makefile              |   15 +
 arch/arm/mach-omap2/board-2430sdp.c       |   48 +++
 arch/arm/mach-omap2/board-ldp.c           |   40 +++
 arch/arm/mach-omap2/board-omap3beagle.c   |   90 ++++++
 arch/arm/mach-omap2/board-omap3pandora.c  |   32 ++
 arch/arm/mach-omap2/board-overo.c         |   43 +++
 arch/arm/mach-omap2/devices.c             |    3 
 arch/arm/mach-omap2/mmc-twl4030.c         |  408 +++++++++++++++++++++++++++++
 arch/arm/mach-omap2/mmc-twl4030.h         |   29 ++
 arch/arm/plat-omap/include/mach/control.h |   17 +
 arch/arm/plat-omap/include/mach/mmc.h     |   16 +
 drivers/mmc/host/omap.c                   |    2 
 14 files changed, 730 insertions(+), 19 deletions(-)
 create mode 100644 arch/arm/mach-omap2/mmc-twl4030.c
 create mode 100644 arch/arm/mach-omap2/mmc-twl4030.h

diff --git a/arch/arm/mach-omap1/board-innovator.c b/arch/arm/mach-omap1/board-innovator.c
index eee0657..f59acef 100644
--- a/arch/arm/mach-omap1/board-innovator.c
+++ b/arch/arm/mach-omap1/board-innovator.c
@@ -385,7 +385,7 @@ static struct omap_mmc_platform_data mmc1_data = {
 	.nr_slots                       = 1,
 	.slots[0]       = {
 		.set_power		= mmc_set_power,
-		.wire4			= 1,
+		.wires			= 4,
 		.name                   = "mmcblk",
 	},
 };
diff --git a/arch/arm/mach-omap1/devices.c b/arch/arm/mach-omap1/devices.c
index 024dab1..77382d8 100644
--- a/arch/arm/mach-omap1/devices.c
+++ b/arch/arm/mach-omap1/devices.c
@@ -116,7 +116,7 @@ static inline void omap1_mmc_mux(struct omap_mmc_platform_data *mmc_controller,
 			omap_cfg_reg(P19_1710_MMC_CMDDIR);
 			omap_cfg_reg(P20_1710_MMC_DATDIR0);
 		}
-		if (mmc_controller->slots[0].wire4) {
+		if (mmc_controller->slots[0].wires == 4) {
 			omap_cfg_reg(MMC_DAT1);
 			/* NOTE: DAT2 can be on W10 (here) or M15 */
 			if (!mmc_controller->slots[0].nomux)
@@ -132,7 +132,7 @@ static inline void omap1_mmc_mux(struct omap_mmc_platform_data *mmc_controller,
 			omap_cfg_reg(Y10_1610_MMC2_CLK);
 			omap_cfg_reg(R18_1610_MMC2_CLKIN);
 			omap_cfg_reg(W8_1610_MMC2_DAT0);
-			if (mmc_controller->slots[1].wire4) {
+			if (mmc_controller->slots[1].wires == 4) {
 				omap_cfg_reg(V8_1610_MMC2_DAT1);
 				omap_cfg_reg(W15_1610_MMC2_DAT2);
 				omap_cfg_reg(R10_1610_MMC2_DAT3);
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index f12c43e..bbd12bc 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -27,10 +27,15 @@ obj-$(CONFIG_ARCH_OMAP3)		+= clock34xx.o
 # Specific board support
 obj-$(CONFIG_MACH_OMAP_GENERIC)		+= board-generic.o
 obj-$(CONFIG_MACH_OMAP_H4)		+= board-h4.o
-obj-$(CONFIG_MACH_OMAP_2430SDP)		+= board-2430sdp.o
+obj-$(CONFIG_MACH_OMAP_2430SDP)		+= board-2430sdp.o \
+					   mmc-twl4030.o
 obj-$(CONFIG_MACH_OMAP_APOLLON)		+= board-apollon.o
-obj-$(CONFIG_MACH_OMAP3_BEAGLE)		+= board-omap3beagle.o
-obj-$(CONFIG_MACH_OMAP_LDP)		+= board-ldp.o
-obj-$(CONFIG_MACH_OVERO)		+= board-overo.o
-obj-$(CONFIG_MACH_OMAP3_PANDORA)	+= board-omap3pandora.o
+obj-$(CONFIG_MACH_OMAP3_BEAGLE)		+= board-omap3beagle.o \
+					   mmc-twl4030.o
+obj-$(CONFIG_MACH_OMAP_LDP)		+= board-ldp.o \
+					   mmc-twl4030.o
+obj-$(CONFIG_MACH_OVERO)		+= board-overo.o \
+					   mmc-twl4030.o
+obj-$(CONFIG_MACH_OMAP3_PANDORA)	+= board-omap3pandora.o \
+					   mmc-twl4030.o
 
diff --git a/arch/arm/mach-omap2/board-2430sdp.c b/arch/arm/mach-omap2/board-2430sdp.c
index 6748de6..83fa372 100644
--- a/arch/arm/mach-omap2/board-2430sdp.c
+++ b/arch/arm/mach-omap2/board-2430sdp.c
@@ -19,6 +19,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/delay.h>
+#include <linux/i2c/twl4030.h>
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
@@ -35,6 +36,7 @@
 #include <mach/common.h>
 #include <mach/gpmc.h>
 
+#include "mmc-twl4030.h"
 
 #define	SDP2430_FLASH_CS	0
 #define	SDP2430_SMC91X_CS	5
@@ -197,12 +199,58 @@ static struct omap_board_config_kernel sdp2430_config[] = {
 	{OMAP_TAG_UART, &sdp2430_uart_config},
 };
 
+
+static struct twl4030_gpio_platform_data sdp2430_gpio_data = {
+	.gpio_base	= OMAP_MAX_GPIO_LINES,
+	.irq_base	= TWL4030_GPIO_IRQ_BASE,
+	.irq_end	= TWL4030_GPIO_IRQ_END,
+};
+
+static struct twl4030_platform_data sdp2430_twldata = {
+	.irq_base	= TWL4030_IRQ_BASE,
+	.irq_end	= TWL4030_IRQ_END,
+
+	/* platform_data for children goes here */
+	.gpio		= &sdp2430_gpio_data,
+};
+
+static struct i2c_board_info __initdata sdp2430_i2c_boardinfo[] = {
+	{
+		I2C_BOARD_INFO("twl4030", 0x48),
+		.flags = I2C_CLIENT_WAKE,
+		.irq = INT_24XX_SYS_NIRQ,
+		.platform_data = &sdp2430_twldata,
+	},
+};
+
+static int __init omap2430_i2c_init(void)
+{
+	omap_register_i2c_bus(1, 400, NULL, 0);
+	omap_register_i2c_bus(2, 2600, sdp2430_i2c_boardinfo,
+			ARRAY_SIZE(sdp2430_i2c_boardinfo));
+	return 0;
+}
+
+static struct twl4030_hsmmc_info mmc[] __initdata = {
+	{
+		.mmc		= 1,
+		.wires		= 4,
+		.gpio_cd	= -EINVAL,
+		.gpio_wp	= -EINVAL,
+		.ext_clock	= 1,
+	},
+	{}	/* Terminator */
+};
+
 static void __init omap_2430sdp_init(void)
 {
+	omap2430_i2c_init();
+
 	platform_add_devices(sdp2430_devices, ARRAY_SIZE(sdp2430_devices));
 	omap_board_config = sdp2430_config;
 	omap_board_config_size = ARRAY_SIZE(sdp2430_config);
 	omap_serial_init();
+	twl4030_mmc_init(mmc);
 }
 
 static void __init omap_2430sdp_map_io(void)
diff --git a/arch/arm/mach-omap2/board-ldp.c b/arch/arm/mach-omap2/board-ldp.c
index 43c7ac4..aa69727 100644
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@ -21,6 +21,7 @@
 #include <linux/clk.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
+#include <linux/i2c/twl4030.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
@@ -38,6 +39,8 @@
 #include <asm/delay.h>
 #include <mach/control.h>
 
+#include "mmc-twl4030.h"
+
 #define SDP3430_SMC91X_CS	3
 
 static struct resource ldp_smc911x_resources[] = {
@@ -109,14 +112,48 @@ static struct omap_board_config_kernel ldp_config[] __initdata = {
 	{ OMAP_TAG_UART,	&ldp_uart_config },
 };
 
+static struct twl4030_gpio_platform_data ldp_gpio_data = {
+	.gpio_base	= OMAP_MAX_GPIO_LINES,
+	.irq_base	= TWL4030_GPIO_IRQ_BASE,
+	.irq_end	= TWL4030_GPIO_IRQ_END,
+};
+
+static struct twl4030_platform_data ldp_twldata = {
+	.irq_base	= TWL4030_IRQ_BASE,
+	.irq_end	= TWL4030_IRQ_END,
+
+	/* platform_data for children goes here */
+	.gpio		= &ldp_gpio_data,
+};
+
+static struct i2c_board_info __initdata ldp_i2c_boardinfo[] = {
+	{
+		I2C_BOARD_INFO("twl4030", 0x48),
+		.flags = I2C_CLIENT_WAKE,
+		.irq = INT_34XX_SYS_NIRQ,
+		.platform_data = &ldp_twldata,
+	},
+};
+
 static int __init omap_i2c_init(void)
 {
-	omap_register_i2c_bus(1, 2600, NULL, 0);
+	omap_register_i2c_bus(1, 2600, ldp_i2c_boardinfo,
+			ARRAY_SIZE(ldp_i2c_boardinfo));
 	omap_register_i2c_bus(2, 400, NULL, 0);
 	omap_register_i2c_bus(3, 400, NULL, 0);
 	return 0;
 }
 
+static struct twl4030_hsmmc_info mmc[] __initdata = {
+	{
+		.mmc		= 1,
+		.wires		= 4,
+		.gpio_cd	= -EINVAL,
+		.gpio_wp	= -EINVAL,
+	},
+	{}	/* Terminator */
+};
+
 static void __init omap_ldp_init(void)
 {
 	omap_i2c_init();
@@ -124,6 +161,7 @@ static void __init omap_ldp_init(void)
 	omap_board_config = ldp_config;
 	omap_board_config_size = ARRAY_SIZE(ldp_config);
 	omap_serial_init();
+	twl4030_mmc_init(mmc);
 }
 
 static void __init omap_ldp_map_io(void)
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index baa7967..9e5ada0 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -38,7 +38,9 @@
 #include <mach/common.h>
 #include <mach/gpmc.h>
 #include <mach/nand.h>
+#include <mach/mux.h>
 
+#include "mmc-twl4030.h"
 
 #define GPMC_CS0_BASE  0x60
 #define GPMC_CS_SIZE   0x30
@@ -103,6 +105,78 @@ static struct omap_uart_config omap3_beagle_uart_config __initdata = {
 	.enabled_uarts	= ((1 << 0) | (1 << 1) | (1 << 2)),
 };
 
+static struct twl4030_hsmmc_info mmc[] = {
+	{
+		.mmc		= 1,
+		.wires		= 8,
+		.gpio_wp	= 29,
+	},
+	{}	/* Terminator */
+};
+
+static struct gpio_led gpio_leds[];
+
+static int beagle_twl_gpio_setup(struct device *dev,
+		unsigned gpio, unsigned ngpio)
+{
+	/* gpio + 0 is "mmc0_cd" (input/IRQ) */
+
+	/* REVISIT: need ehci-omap hooks for external VBUS
+	 * power switch and overcurrent detect
+	 */
+
+	gpio_request(gpio + 1, "EHCI_nOC");
+	gpio_direction_input(gpio + 1);
+
+	/* TWL4030_GPIO_MAX + 0 == ledA, EHCI nEN_USB_PWR (out, active low) */
+	gpio_request(gpio + TWL4030_GPIO_MAX, "nEN_USB_PWR");
+	gpio_direction_output(gpio + TWL4030_GPIO_MAX, 1);
+
+	/* TWL4030_GPIO_MAX + 1 == ledB, PMU_STAT (out, active low LED) */
+	gpio_leds[2].gpio = gpio + TWL4030_GPIO_MAX + 1;
+
+	return 0;
+}
+
+static struct twl4030_gpio_platform_data beagle_gpio_data = {
+	.gpio_base	= OMAP_MAX_GPIO_LINES,
+	.irq_base	= TWL4030_GPIO_IRQ_BASE,
+	.irq_end	= TWL4030_GPIO_IRQ_END,
+	.use_leds	= true,
+	.pullups	= BIT(1),
+	.pulldowns	= BIT(2) | BIT(6) | BIT(7) | BIT(8) | BIT(13)
+				| BIT(15) | BIT(16) | BIT(17),
+	.setup		= beagle_twl_gpio_setup,
+};
+
+static struct twl4030_platform_data beagle_twldata = {
+	.irq_base	= TWL4030_IRQ_BASE,
+	.irq_end	= TWL4030_IRQ_END,
+
+	/* platform_data for children goes here */
+	.gpio		= &beagle_gpio_data,
+};
+
+static struct i2c_board_info __initdata beagle_i2c_boardinfo[] = {
+	{
+		I2C_BOARD_INFO("twl4030", 0x48),
+		.flags = I2C_CLIENT_WAKE,
+		.irq = INT_34XX_SYS_NIRQ,
+		.platform_data = &beagle_twldata,
+	},
+};
+
+static int __init omap3_beagle_i2c_init(void)
+{
+	omap_register_i2c_bus(1, 2600, beagle_i2c_boardinfo,
+			ARRAY_SIZE(beagle_i2c_boardinfo));
+#ifdef CONFIG_I2C2_OMAP_BEAGLE
+	omap_register_i2c_bus(2, 400, NULL, 0);
+#endif
+	omap_register_i2c_bus(3, 400, NULL, 0);
+	return 0;
+}
+
 static void __init omap3_beagle_init_irq(void)
 {
 	omap2_init_common_hw();
@@ -130,6 +204,11 @@ static struct gpio_led gpio_leds[] = {
 		.default_trigger	= "mmc0",
 		.gpio			= 149,
 	},
+	{
+		.name			= "beagleboard::pmu_stat",
+		.gpio			= -EINVAL,	/* gets replaced */
+		.active_low		= true,
+	},
 };
 
 static struct gpio_led_platform_data gpio_led_info = {
@@ -218,11 +297,22 @@ static void __init omap3beagle_flash_init(void)
 
 static void __init omap3_beagle_init(void)
 {
+	omap3_beagle_i2c_init();
 	platform_add_devices(omap3_beagle_devices,
 			ARRAY_SIZE(omap3_beagle_devices));
 	omap_board_config = omap3_beagle_config;
 	omap_board_config_size = ARRAY_SIZE(omap3_beagle_config);
 	omap_serial_init();
+
+	omap_cfg_reg(AH8_34XX_GPIO29);
+	mmc[0].gpio_cd = gpio + 0;
+	twl4030_mmc_init(mmc);
+
+	omap_cfg_reg(J25_34XX_GPIO170);
+	gpio_request(170, "DVI_nPD");
+	/* REVISIT leave DVI powered down until it's needed ... */
+	gpio_direction_output(170, true);
+
 	omap3beagle_flash_init();
 }
 
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index fcb6bdc..b3954a0 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -46,6 +46,8 @@
 #include <mach/nand.h>
 #include <mach/mcspi.h>
 
+#include "mmc-twl4030.h"
+
 #define NAND_BLOCK_SIZE			SZ_128K
 #define GPMC_CS0_BASE			0x60
 #define GPMC_CS_SIZE			0x30
@@ -137,14 +139,44 @@ static void __init omap3pandora_flash_init(void)
 	}
 }
 
+static struct twl4030_hsmmc_info omap3pandora_mmc[] = {
+	{
+		.mmc		= 1,
+		.wires		= 4,
+		.gpio_cd	= -EINVAL,
+		.gpio_wp	= 126,
+		.ext_clock	= 0,
+	},
+	{
+		.mmc		= 2,
+		.wires		= 4,
+		.gpio_cd	= -EINVAL,
+		.gpio_wp	= 127,
+		.ext_clock	= 1,
+	},
+	{}	/* Terminator */
+};
+
 static struct omap_uart_config omap3pandora_uart_config __initdata = {
 	.enabled_uarts	= (1 << 2), /* UART3 */
 };
 
+static int omap3pandora_twl_gpio_setup(struct device *dev,
+		unsigned gpio, unsigned ngpio)
+{
+	/* gpio + {0,1} is "mmc{0,1}_cd" (input/IRQ) */
+	omap3pandora_mmc[0].gpio_cd = gpio + 0;
+	omap3pandora_mmc[1].gpio_cd = gpio + 1;
+	twl4030_mmc_init(omap3pandora_mmc);
+
+	return 0;
+}
+
 static struct twl4030_gpio_platform_data omap3pandora_gpio_data = {
 	.gpio_base	= OMAP_MAX_GPIO_LINES,
 	.irq_base	= TWL4030_GPIO_IRQ_BASE,
 	.irq_end	= TWL4030_GPIO_IRQ_END,
+	.setup		= omap3pandora_twl_gpio_setup,
 };
 
 static struct twl4030_usb_data omap3pandora_usb_data = {
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index e09aa59..82b3dc5 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -26,6 +26,7 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
+#include <linux/i2c/twl4030.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
@@ -44,6 +45,8 @@
 #include <mach/hardware.h>
 #include <mach/nand.h>
 
+#include "mmc-twl4030.h"
+
 #define NAND_BLOCK_SIZE SZ_128K
 #define GPMC_CS0_BASE  0x60
 #define GPMC_CS_SIZE   0x30
@@ -139,8 +142,31 @@ static struct omap_uart_config overo_uart_config __initdata = {
 	.enabled_uarts	= ((1 << 0) | (1 << 1) | (1 << 2)),
 };
 
+static struct twl4030_gpio_platform_data overo_gpio_data = {
+	.gpio_base	= OMAP_MAX_GPIO_LINES,
+	.irq_base	= TWL4030_GPIO_IRQ_BASE,
+	.irq_end	= TWL4030_GPIO_IRQ_END,
+};
+
+static struct twl4030_platform_data overo_twldata = {
+	.irq_base	= TWL4030_IRQ_BASE,
+	.irq_end	= TWL4030_IRQ_END,
+	.gpio		= &overo_gpio_data,
+};
+
+static struct i2c_board_info __initdata overo_i2c_boardinfo[] = {
+	{
+		I2C_BOARD_INFO("twl4030", 0x48),
+		.flags = I2C_CLIENT_WAKE,
+		.irq = INT_34XX_SYS_NIRQ,
+		.platform_data = &overo_twldata,
+	},
+};
+
 static int __init overo_i2c_init(void)
 {
+	omap_register_i2c_bus(1, 2600, overo_i2c_boardinfo,
+			ARRAY_SIZE(overo_i2c_boardinfo));
 	/* i2c2 pins are used for gpio */
 	omap_register_i2c_bus(3, 400, NULL, 0);
 	return 0;
@@ -171,6 +197,22 @@ static struct platform_device *overo_devices[] __initdata = {
 	&overo_lcd_device,
 };
 
+static struct twl4030_hsmmc_info mmc[] __initdata = {
+	{
+		.mmc		= 1,
+		.wires		= 4,
+		.gpio_cd	= -EINVAL,
+		.gpio_wp	= -EINVAL,
+	},
+	{
+		.mmc		= 2,
+		.wires		= 4,
+		.gpio_cd	= -EINVAL,
+		.gpio_wp	= -EINVAL,
+	},
+	{}	/* Terminator */
+};
+
 static void __init overo_init(void)
 {
 	overo_i2c_init();
@@ -178,6 +220,7 @@ static void __init overo_init(void)
 	omap_board_config = overo_config;
 	omap_board_config_size = ARRAY_SIZE(overo_config);
 	omap_serial_init();
+	twl4030_mmc_init(mmc);
 	overo_flash_init();
 
 	if ((gpio_request(OVERO_GPIO_W2W_NRESET,
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 8ccdfcf..6e03272 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -19,6 +19,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/map.h>
 
+#include <mach/control.h>
 #include <mach/tc.h>
 #include <mach/board.h>
 #include <mach/mux.h>
@@ -311,7 +312,7 @@ static inline void omap2_mmc_mux(struct omap_mmc_platform_data *mmc_controller,
 		omap_cfg_reg(F20_24XX_MMC_DAT0);
 		omap_cfg_reg(F19_24XX_MMC_DAT_DIR0);
 		omap_cfg_reg(G18_24XX_MMC_CMD_DIR);
-		if (mmc_controller->slots[0].wire4) {
+		if (mmc_controller->slots[0].wires == 4) {
 			omap_cfg_reg(H14_24XX_MMC_DAT1);
 			omap_cfg_reg(E19_24XX_MMC_DAT2);
 			omap_cfg_reg(D19_24XX_MMC_DAT3);
diff --git a/arch/arm/mach-omap2/mmc-twl4030.c b/arch/arm/mach-omap2/mmc-twl4030.c
new file mode 100644
index 0000000..437f520
--- /dev/null
+++ b/arch/arm/mach-omap2/mmc-twl4030.c
@@ -0,0 +1,408 @@
+/*
+ * linux/arch/arm/mach-omap2/mmc-twl4030.c
+ *
+ * Copyright (C) 2007-2008 Texas Instruments
+ * Copyright (C) 2008 Nokia Corporation
+ * Author: Texas Instruments
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/i2c/twl4030.h>
+
+#include <mach/hardware.h>
+#include <mach/control.h>
+#include <mach/mmc.h>
+#include <mach/board.h>
+
+#include "mmc-twl4030.h"
+
+#if defined(CONFIG_TWL4030_CORE) && \
+	(defined(CONFIG_MMC_OMAP_HS) || defined(CONFIG_MMC_OMAP_HS_MODULE))
+
+#define LDO_CLR			0x00
+#define VSEL_S2_CLR		0x40
+
+#define VMMC1_DEV_GRP		0x27
+#define VMMC1_CLR		0x00
+#define VMMC1_315V		0x03
+#define VMMC1_300V		0x02
+#define VMMC1_285V		0x01
+#define VMMC1_185V		0x00
+#define VMMC1_DEDICATED		0x2A
+
+#define VMMC2_DEV_GRP		0x2B
+#define VMMC2_CLR		0x40
+#define VMMC2_315V		0x0c
+#define VMMC2_300V		0x0b
+#define VMMC2_285V		0x0a
+#define VMMC2_260V		0x08
+#define VMMC2_185V		0x06
+#define VMMC2_DEDICATED		0x2E
+
+#define VMMC_DEV_GRP_P1		0x20
+
+static u16 control_pbias_offset;
+static u16 control_devconf1_offset;
+
+#define HSMMC_NAME_LEN	9
+
+static struct twl_mmc_controller {
+	struct omap_mmc_platform_data	*mmc;
+	u8		twl_vmmc_dev_grp;
+	u8		twl_mmc_dedicated;
+	char		name[HSMMC_NAME_LEN];
+} hsmmc[] = {
+	{
+		.twl_vmmc_dev_grp		= VMMC1_DEV_GRP,
+		.twl_mmc_dedicated		= VMMC1_DEDICATED,
+	},
+	{
+		.twl_vmmc_dev_grp		= VMMC2_DEV_GRP,
+		.twl_mmc_dedicated		= VMMC2_DEDICATED,
+	},
+};
+
+static int twl_mmc_card_detect(int irq)
+{
+	unsigned i;
+
+	for (i = 0; i < ARRAY_SIZE(hsmmc); i++) {
+		struct omap_mmc_platform_data *mmc;
+
+		mmc = hsmmc[i].mmc;
+		if (!mmc)
+			continue;
+		if (irq != mmc->slots[0].card_detect_irq)
+			continue;
+
+		/* NOTE: assumes card detect signal is active-low */
+		return !gpio_get_value_cansleep(mmc->slots[0].switch_pin);
+	}
+	return -ENOSYS;
+}
+
+static int twl_mmc_get_ro(struct device *dev, int slot)
+{
+	struct omap_mmc_platform_data *mmc = dev->platform_data;
+
+	/* NOTE: assumes write protect signal is active-high */
+	return gpio_get_value_cansleep(mmc->slots[0].gpio_wp);
+}
+
+/*
+ * MMC Slot Initialization.
+ */
+static int twl_mmc_late_init(struct device *dev)
+{
+	struct omap_mmc_platform_data *mmc = dev->platform_data;
+	int ret = 0;
+	int i;
+
+	ret = gpio_request(mmc->slots[0].switch_pin, "mmc_cd");
+	if (ret)
+		goto done;
+	ret = gpio_direction_input(mmc->slots[0].switch_pin);
+	if (ret)
+		goto err;
+
+	for (i = 0; i < ARRAY_SIZE(hsmmc); i++) {
+		if (hsmmc[i].name == mmc->slots[0].name) {
+			hsmmc[i].mmc = mmc;
+			break;
+		}
+	}
+
+	return 0;
+
+err:
+	gpio_free(mmc->slots[0].switch_pin);
+done:
+	mmc->slots[0].card_detect_irq = 0;
+	mmc->slots[0].card_detect = NULL;
+
+	dev_err(dev, "err %d configuring card detect\n", ret);
+	return ret;
+}
+
+static void twl_mmc_cleanup(struct device *dev)
+{
+	struct omap_mmc_platform_data *mmc = dev->platform_data;
+
+	gpio_free(mmc->slots[0].switch_pin);
+}
+
+#ifdef CONFIG_PM
+
+static int twl_mmc_suspend(struct device *dev, int slot)
+{
+	struct omap_mmc_platform_data *mmc = dev->platform_data;
+
+	disable_irq(mmc->slots[0].card_detect_irq);
+	return 0;
+}
+
+static int twl_mmc_resume(struct device *dev, int slot)
+{
+	struct omap_mmc_platform_data *mmc = dev->platform_data;
+
+	enable_irq(mmc->slots[0].card_detect_irq);
+	return 0;
+}
+
+#else
+#define twl_mmc_suspend	NULL
+#define twl_mmc_resume	NULL
+#endif
+
+/*
+ * Sets the MMC voltage in twl4030
+ */
+static int twl_mmc_set_voltage(struct twl_mmc_controller *c, int vdd)
+{
+	int ret;
+	u8 vmmc, dev_grp_val;
+
+	switch (1 << vdd) {
+	case MMC_VDD_35_36:
+	case MMC_VDD_34_35:
+	case MMC_VDD_33_34:
+	case MMC_VDD_32_33:
+	case MMC_VDD_31_32:
+	case MMC_VDD_30_31:
+		if (c->twl_vmmc_dev_grp == VMMC1_DEV_GRP)
+			vmmc = VMMC1_315V;
+		else
+			vmmc = VMMC2_315V;
+		break;
+	case MMC_VDD_29_30:
+		if (c->twl_vmmc_dev_grp == VMMC1_DEV_GRP)
+			vmmc = VMMC1_315V;
+		else
+			vmmc = VMMC2_300V;
+		break;
+	case MMC_VDD_27_28:
+	case MMC_VDD_26_27:
+		if (c->twl_vmmc_dev_grp == VMMC1_DEV_GRP)
+			vmmc = VMMC1_285V;
+		else
+			vmmc = VMMC2_285V;
+		break;
+	case MMC_VDD_25_26:
+	case MMC_VDD_24_25:
+	case MMC_VDD_23_24:
+	case MMC_VDD_22_23:
+	case MMC_VDD_21_22:
+	case MMC_VDD_20_21:
+		if (c->twl_vmmc_dev_grp == VMMC1_DEV_GRP)
+			vmmc = VMMC1_285V;
+		else
+			vmmc = VMMC2_260V;
+		break;
+	case MMC_VDD_165_195:
+		if (c->twl_vmmc_dev_grp == VMMC1_DEV_GRP)
+			vmmc = VMMC1_185V;
+		else
+			vmmc = VMMC2_185V;
+		break;
+	default:
+		vmmc = 0;
+		break;
+	}
+
+	if (vmmc)
+		dev_grp_val = VMMC_DEV_GRP_P1;	/* Power up */
+	else
+		dev_grp_val = LDO_CLR;		/* Power down */
+
+	ret = twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+					dev_grp_val, c->twl_vmmc_dev_grp);
+	if (ret)
+		return ret;
+
+	ret = twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+					vmmc, c->twl_mmc_dedicated);
+
+	return ret;
+}
+
+static int twl_mmc1_set_power(struct device *dev, int slot, int power_on,
+				int vdd)
+{
+	u32 reg;
+	int ret = 0;
+	struct twl_mmc_controller *c = &hsmmc[0];
+	struct omap_mmc_platform_data *mmc = dev->platform_data;
+
+	if (power_on) {
+		if (cpu_is_omap2430()) {
+			reg = omap_ctrl_readl(OMAP243X_CONTROL_DEVCONF1);
+			if ((1 << vdd) >= MMC_VDD_30_31)
+				reg |= OMAP243X_MMC1_ACTIVE_OVERWRITE;
+			else
+				reg &= ~OMAP243X_MMC1_ACTIVE_OVERWRITE;
+			omap_ctrl_writel(reg, OMAP243X_CONTROL_DEVCONF1);
+		}
+
+		if (mmc->slots[0].internal_clock) {
+			reg = omap_ctrl_readl(OMAP2_CONTROL_DEVCONF0);
+			reg |= OMAP2_MMCSDIO1ADPCLKISEL;
+			omap_ctrl_writel(reg, OMAP2_CONTROL_DEVCONF0);
+		}
+
+		reg = omap_ctrl_readl(control_pbias_offset);
+		reg |= OMAP2_PBIASSPEEDCTRL0;
+		reg &= ~OMAP2_PBIASLITEPWRDNZ0;
+		omap_ctrl_writel(reg, control_pbias_offset);
+
+		ret = twl_mmc_set_voltage(c, vdd);
+
+		/* 100ms delay required for PBIAS configuration */
+		msleep(100);
+		reg = omap_ctrl_readl(control_pbias_offset);
+		reg |= (OMAP2_PBIASLITEPWRDNZ0 | OMAP2_PBIASSPEEDCTRL0);
+		if ((1 << vdd) <= MMC_VDD_165_195)
+			reg &= ~OMAP2_PBIASLITEVMODE0;
+		else
+			reg |= OMAP2_PBIASLITEVMODE0;
+		omap_ctrl_writel(reg, control_pbias_offset);
+	} else {
+		reg = omap_ctrl_readl(control_pbias_offset);
+		reg &= ~OMAP2_PBIASLITEPWRDNZ0;
+		omap_ctrl_writel(reg, control_pbias_offset);
+
+		ret = twl_mmc_set_voltage(c, 0);
+
+		/* 100ms delay required for PBIAS configuration */
+		msleep(100);
+		reg = omap_ctrl_readl(control_pbias_offset);
+		reg |= (OMAP2_PBIASSPEEDCTRL0 | OMAP2_PBIASLITEPWRDNZ0 |
+			OMAP2_PBIASLITEVMODE0);
+		omap_ctrl_writel(reg, control_pbias_offset);
+	}
+
+	return ret;
+}
+
+static int twl_mmc2_set_power(struct device *dev, int slot, int power_on, int vdd)
+{
+	int ret;
+	struct twl_mmc_controller *c = &hsmmc[1];
+	struct omap_mmc_platform_data *mmc = dev->platform_data;
+
+	if (power_on) {
+		if (mmc->slots[0].internal_clock) {
+			u32 reg;
+
+			reg = omap_ctrl_readl(control_devconf1_offset);
+			reg |= OMAP2_MMCSDIO2ADPCLKISEL;
+			omap_ctrl_writel(reg, control_devconf1_offset);
+		}
+		ret = twl_mmc_set_voltage(c, vdd);
+	} else {
+		ret = twl_mmc_set_voltage(c, 0);
+	}
+
+	return ret;
+}
+
+static struct omap_mmc_platform_data *hsmmc_data[OMAP34XX_NR_MMC] __initdata;
+
+void __init twl4030_mmc_init(struct twl4030_hsmmc_info *controllers)
+{
+	struct twl4030_hsmmc_info *c;
+	int nr_hsmmc = ARRAY_SIZE(hsmmc_data);
+
+	if (cpu_is_omap2430()) {
+		control_pbias_offset = OMAP243X_CONTROL_PBIAS_LITE;
+		control_devconf1_offset = OMAP243X_CONTROL_DEVCONF1;
+		nr_hsmmc = 2;
+	} else {
+		control_pbias_offset = OMAP343X_CONTROL_PBIAS_LITE;
+		control_devconf1_offset = OMAP343X_CONTROL_DEVCONF1;
+	}
+
+	for (c = controllers; c->mmc; c++) {
+		struct twl_mmc_controller *twl = hsmmc + c->mmc - 1;
+		struct omap_mmc_platform_data *mmc = hsmmc_data[c->mmc - 1];
+
+		if (!c->mmc || c->mmc > nr_hsmmc) {
+			pr_debug("MMC%d: no such controller\n", c->mmc);
+			continue;
+		}
+		if (mmc) {
+			pr_debug("MMC%d: already configured\n", c->mmc);
+			continue;
+		}
+
+		mmc = kzalloc(sizeof(struct omap_mmc_platform_data), GFP_KERNEL);
+		if (!mmc) {
+			pr_err("Cannot allocate memory for mmc device!\n");
+			return;
+		}
+
+		sprintf(twl->name, "mmc%islot%i", c->mmc, 1);
+		mmc->slots[0].name = twl->name;
+		mmc->nr_slots = 1;
+		mmc->slots[0].ocr_mask = MMC_VDD_165_195 |
+					MMC_VDD_26_27 | MMC_VDD_27_28 |
+					MMC_VDD_29_30 |
+					MMC_VDD_30_31 | MMC_VDD_31_32;
+		mmc->slots[0].wires = c->wires;
+		mmc->slots[0].internal_clock = !c->ext_clock;
+		mmc->dma_mask = 0xffffffff;
+
+		/* note: twl4030 card detect GPIOs normally switch VMMCx ... */
+		if (gpio_is_valid(c->gpio_cd)) {
+			mmc->init = twl_mmc_late_init;
+			mmc->cleanup = twl_mmc_cleanup;
+			mmc->suspend = twl_mmc_suspend;
+			mmc->resume = twl_mmc_resume;
+
+			mmc->slots[0].switch_pin = c->gpio_cd;
+			mmc->slots[0].card_detect_irq = gpio_to_irq(c->gpio_cd);
+			mmc->slots[0].card_detect = twl_mmc_card_detect;
+		} else
+			mmc->slots[0].switch_pin = -EINVAL;
+
+		/* write protect normally uses an OMAP gpio */
+		if (gpio_is_valid(c->gpio_wp)) {
+			gpio_request(c->gpio_wp, "mmc_wp");
+			gpio_direction_input(c->gpio_wp);
+
+			mmc->slots[0].gpio_wp = c->gpio_wp;
+			mmc->slots[0].get_ro = twl_mmc_get_ro;
+		} else
+			mmc->slots[0].gpio_wp = -EINVAL;
+
+		/* NOTE:  we assume OMAP's MMC1 and MMC2 use
+		 * the TWL4030's VMMC1 and VMMC2, respectively;
+		 * and that OMAP's MMC3 isn't used.
+		 */
+
+		switch (c->mmc) {
+		case 1:
+			mmc->slots[0].set_power = twl_mmc1_set_power;
+			break;
+		case 2:
+			mmc->slots[0].set_power = twl_mmc2_set_power;
+			break;
+		default:
+			pr_err("MMC%d configuration not supported!\n", c->mmc);
+			continue;
+		}
+		hsmmc_data[c->mmc - 1] = mmc;
+	}
+
+	omap2_init_mmc(hsmmc_data, OMAP34XX_NR_MMC);
+}
+
+#endif
diff --git a/arch/arm/mach-omap2/mmc-twl4030.h b/arch/arm/mach-omap2/mmc-twl4030.h
new file mode 100644
index 0000000..e1c8076
--- /dev/null
+++ b/arch/arm/mach-omap2/mmc-twl4030.h
@@ -0,0 +1,29 @@
+/*
+ * MMC definitions for OMAP2
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+struct twl4030_hsmmc_info {
+	u8	mmc;		/* controller 1/2/3 */
+	u8	wires;		/* 1/4/8 wires */
+	int	gpio_cd;	/* or -EINVAL */
+	int	gpio_wp;	/* or -EINVAL */
+	int	ext_clock:1;	/* use external pin for input clock */
+};
+
+#if	defined(CONFIG_TWL4030_CORE) && \
+	(defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE) || \
+	 defined(CONFIG_MMC_OMAP_HS) || defined(CONFIG_MMC_OMAP_HS_MODULE))
+
+void twl4030_mmc_init(struct twl4030_hsmmc_info *);
+
+#else
+
+static inline void twl4030_mmc_init(struct twl4030_hsmmc_info *info)
+{
+}
+
+#endif
diff --git a/arch/arm/plat-omap/include/mach/control.h b/arch/arm/plat-omap/include/mach/control.h
index dc98867..269147f 100644
--- a/arch/arm/plat-omap/include/mach/control.h
+++ b/arch/arm/plat-omap/include/mach/control.h
@@ -74,6 +74,7 @@
 #define OMAP243X_CONTROL_IVA2_BOOTADDR	(OMAP2_CONTROL_GENERAL + 0x0190)
 #define OMAP243X_CONTROL_IVA2_BOOTMOD	(OMAP2_CONTROL_GENERAL + 0x0194)
 #define OMAP243X_CONTROL_IVA2_GEMCFG	(OMAP2_CONTROL_GENERAL + 0x0198)
+#define OMAP243X_CONTROL_PBIAS_LITE	(OMAP2_CONTROL_GENERAL + 0x0230)
 
 /* 24xx-only CONTROL_GENERAL register offsets */
 #define OMAP24XX_CONTROL_DEBOBS		(OMAP2_CONTROL_GENERAL + 0x0000)
@@ -140,6 +141,7 @@
 #define OMAP343X_CONTROL_TEST_KEY_13	(OMAP2_CONTROL_GENERAL + 0x00fc)
 #define OMAP343X_CONTROL_IVA2_BOOTADDR	(OMAP2_CONTROL_GENERAL + 0x0190)
 #define OMAP343X_CONTROL_IVA2_BOOTMOD	(OMAP2_CONTROL_GENERAL + 0x0194)
+#define OMAP343X_CONTROL_PBIAS_LITE	(OMAP2_CONTROL_GENERAL + 0x02b0)
 #define OMAP343X_CONTROL_TEMP_SENSOR	(OMAP2_CONTROL_GENERAL + 0x02b4)
 
 /*
@@ -154,11 +156,14 @@
  * and the security mode (secure, non-secure, don't care)
  */
 /* CONTROL_DEVCONF0 bits */
+#define OMAP2_MMCSDIO1ADPCLKISEL	(1 << 24) /* MMC1 loop back clock */
 #define OMAP24XX_USBSTANDBYCTRL		(1 << 15)
 #define OMAP2_MCBSP2_CLKS_MASK		(1 << 6)
 #define OMAP2_MCBSP1_CLKS_MASK		(1 << 2)
 
 /* CONTROL_DEVCONF1 bits */
+#define OMAP243X_MMC1_ACTIVE_OVERWRITE	(1 << 31)
+#define OMAP2_MMCSDIO2ADPCLKISEL	(1 << 6) /* MMC2 loop back clock */
 #define OMAP2_MCBSP5_CLKS_MASK		(1 << 4) /* > 242x */
 #define OMAP2_MCBSP4_CLKS_MASK		(1 << 2) /* > 242x */
 #define OMAP2_MCBSP3_CLKS_MASK		(1 << 0) /* > 242x */
@@ -172,6 +177,18 @@
 #define OMAP2_SYSBOOT_1_MASK		(1 << 1)
 #define OMAP2_SYSBOOT_0_MASK		(1 << 0)
 
+/* CONTROL_PBIAS_LITE bits */
+#define OMAP343X_PBIASLITESUPPLY_HIGH1	(1 << 15)
+#define OMAP343X_PBIASLITEVMODEERROR1	(1 << 11)
+#define OMAP343X_PBIASSPEEDCTRL1	(1 << 10)
+#define OMAP343X_PBIASLITEPWRDNZ1	(1 << 9)
+#define OMAP343X_PBIASLITEVMODE1	(1 << 8)
+#define OMAP343X_PBIASLITESUPPLY_HIGH0	(1 << 7)
+#define OMAP343X_PBIASLITEVMODEERROR0	(1 << 3)
+#define OMAP2_PBIASSPEEDCTRL0		(1 << 2)
+#define OMAP2_PBIASLITEPWRDNZ0		(1 << 1)
+#define OMAP2_PBIASLITEVMODE0		(1 << 0)
+
 #ifndef __ASSEMBLY__
 #if defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3)
 extern void __iomem *omap_ctrl_base_get(void);
diff --git a/arch/arm/plat-omap/include/mach/mmc.h b/arch/arm/plat-omap/include/mach/mmc.h
index 0c2ef3b..031250f 100644
--- a/arch/arm/plat-omap/include/mach/mmc.h
+++ b/arch/arm/plat-omap/include/mach/mmc.h
@@ -61,6 +61,11 @@ struct omap_mmc_platform_data {
 
 	struct omap_mmc_slot_data {
 
+		/* 4 wire signaling is optional, and is used for SD/SDIO/HSMMC;
+		 * 8 wire signaling is also optional, and is used with HSMMC
+		 */
+		u8 wires;
+
 		/*
 		 * nomux means "standard" muxing is wrong on this board, and
 		 * that board-specific code handled it before common init logic.
@@ -70,13 +75,12 @@ struct omap_mmc_platform_data {
 		/* switch pin can be for card detect (default) or card cover */
 		unsigned cover:1;
 
-		/* 4 wire signaling is optional, and is only used for SD/SDIO */
-		unsigned wire4:1;
-
 		/* use the internal clock */
 		unsigned internal_clock:1;
 		s16 power_pin;
-		s16 switch_pin;
+
+		int switch_pin;			/* gpio (card detect) */
+		int gpio_wp;			/* gpio (write protect) */
 
 		int (* set_bus_mode)(struct device *dev, int slot, int bus_mode);
 		int (* set_power)(struct device *dev, int slot, int power_on, int vdd);
@@ -111,7 +115,6 @@ void omap1_init_mmc(struct omap_mmc_platform_data **mmc_data,
 				int nr_controllers);
 void omap2_init_mmc(struct omap_mmc_platform_data **mmc_data,
 				int nr_controllers);
-void hsmmc_init(int controller_mask);
 int omap_mmc_add(int id, unsigned long base, unsigned long size,
 			unsigned int irq, struct omap_mmc_platform_data *data);
 #else
@@ -123,9 +126,6 @@ static inline void omap2_init_mmc(struct omap_mmc_platform_data **mmc_data,
 				int nr_controllers)
 {
 }
-static inline void hsmmc_init(int controller_mask)
-{
-}
 static inline int omap_mmc_add(int id, unsigned long base, unsigned long size,
 		unsigned int irq, struct omap_mmc_platform_data *data)
 {
diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index c6544d2..67d7b7f 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1317,7 +1317,7 @@ static int __init mmc_omap_new_slot(struct mmc_omap_host *host, int id)
 	host->slots[id] = slot;
 
 	mmc->caps = 0;
-	if (host->pdata->slots[id].wire4)
+	if (host->pdata->slots[id].wires >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
 	mmc->ops = &mmc_omap_ops;

