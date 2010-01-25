Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750Ab0AYCf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0AYCf4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 21:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436Ab0AYCfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 21:35:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56758 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab0AYCfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 21:35:54 -0500
Message-ID: <4B5D0409.3030908@cn.fujitsu.com>
Date: Mon, 25 Jan 2010 10:38:01 +0800
From: Zhu Qingsen <zhuqs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.7) Gecko/20100111 Lightning/1.0b1 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: nico@marvell.org
Subject: [Patch] Orion: Add Buffalo Linkstation LS-HGL support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Buffalo Linkstation LS-HGL platform.

Signed-off-by: Zhu Qingsen <zhuqs@cn.fujitsu.com>
---
  arch/arm/configs/orion5x_defconfig   |    1 +
  arch/arm/mach-orion5x/Kconfig        |    7 +
  arch/arm/mach-orion5x/Makefile       |    1 +
  arch/arm/mach-orion5x/ls_hgl-setup.c |  278 ++++++++++++++++++++++++++++++++++
  4 files changed, 287 insertions(+), 0 deletions(-)
  create mode 100644 arch/arm/mach-orion5x/ls_hgl-setup.c

diff --git a/arch/arm/configs/orion5x_defconfig b/arch/arm/configs/orion5x_defconfig
index 85b05d3..eacc9e9 100644
--- a/arch/arm/configs/orion5x_defconfig
+++ b/arch/arm/configs/orion5x_defconfig
@@ -192,6 +192,7 @@ CONFIG_MACH_TS209=y
  CONFIG_MACH_TERASTATION_PRO2=y
  CONFIG_MACH_LINKSTATION_PRO=y
  CONFIG_MACH_LINKSTATION_MINI=y
+CONFIG_MACH_LINKSTATION_LS_HGL=y
  CONFIG_MACH_TS409=y
  CONFIG_MACH_WRT350N_V2=y
  CONFIG_MACH_TS78XX=y
diff --git a/arch/arm/mach-orion5x/Kconfig b/arch/arm/mach-orion5x/Kconfig
index c3d513c..905719a 100644
--- a/arch/arm/mach-orion5x/Kconfig
+++ b/arch/arm/mach-orion5x/Kconfig
@@ -57,6 +57,13 @@ config MACH_LINKSTATION_MINI
  	  Say 'Y' here if you want your kernel to support the
  	  Buffalo Linkstation Mini platform.

+config MACH_LINKSTATION_LS_HGL
+	bool "Buffalo Linkstation LS-HGL"
+	select I2C_BOARDINFO
+	help
+	  Say 'Y' here if you want your kernel to support the
+	  Buffalo Linkstation LS-HGL platform.
+
  config MACH_TS409
  	bool "QNAP TS-409"
  	help
diff --git a/arch/arm/mach-orion5x/Makefile b/arch/arm/mach-orion5x/Makefile
index 89772fc..eb6eabc 100644
--- a/arch/arm/mach-orion5x/Makefile
+++ b/arch/arm/mach-orion5x/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_MACH_KUROBOX_PRO)	+= kurobox_pro-setup.o
  obj-$(CONFIG_MACH_TERASTATION_PRO2)	+= terastation_pro2-setup.o
  obj-$(CONFIG_MACH_LINKSTATION_PRO) += kurobox_pro-setup.o
  obj-$(CONFIG_MACH_LINKSTATION_MINI) += lsmini-setup.o
+obj-$(CONFIG_MACH_LINKSTATION_LS_HGL) += ls_hgl-setup.o
  obj-$(CONFIG_MACH_DNS323)	+= dns323-setup.o
  obj-$(CONFIG_MACH_TS209)	+= ts209-setup.o tsx09-common.o
  obj-$(CONFIG_MACH_TS409)	+= ts409-setup.o tsx09-common.o
diff --git a/arch/arm/mach-orion5x/ls_hgl-setup.c b/arch/arm/mach-orion5x/ls_hgl-setup.c
new file mode 100644
index 0000000..c3bb87d
--- /dev/null
+++ b/arch/arm/mach-orion5x/ls_hgl-setup.c
@@ -0,0 +1,278 @@
+/*
+ * arch/arm/mach-orion5x/ls_hgl-setup.c
+ *
+ * Maintainer: Zhu Qingsen <zhuqs@cn.fujistu.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/pci.h>
+#include <linux/mtd/physmap.h>
+#include <linux/mv643xx_eth.h>
+#include <linux/leds.h>
+#include <linux/gpio_keys.h>
+#include <linux/input.h>
+#include <linux/i2c.h>
+#include <linux/ata_platform.h>
+#include <asm/mach-types.h>
+#include <linux/gpio.h>
+#include <asm/mach/arch.h>
+#include "common.h"
+#include "mpp.h"
+#include "include/mach/system.h"
+
+/*****************************************************************************
+ * Linkstation LS-HGL Info
+ ****************************************************************************/
+
+/*
+ * 256K NOR flash Device bus boot chip select
+ */
+
+#define LS_HGL_NOR_BOOT_BASE	0xf4000000
+#define LS_HGL_NOR_BOOT_SIZE	SZ_256K
+
+/*****************************************************************************
+ * 256KB NOR Flash on BOOT Device
+ ****************************************************************************/
+
+static struct physmap_flash_data ls_hgl_nor_flash_data = {
+	.width		= 1,
+};
+
+static struct resource ls_hgl_nor_flash_resource = {
+	.flags	= IORESOURCE_MEM,
+	.start	= LS_HGL_NOR_BOOT_BASE,
+	.end	= LS_HGL_NOR_BOOT_BASE + LS_HGL_NOR_BOOT_SIZE - 1,
+};
+
+static struct platform_device ls_hgl_nor_flash = {
+	.name			= "physmap-flash",
+	.id			= 0,
+	.dev		= {
+		.platform_data	= &ls_hgl_nor_flash_data,
+	},
+	.num_resources		= 1,
+	.resource		= &ls_hgl_nor_flash_resource,
+};
+
+/*****************************************************************************
+ * Ethernet
+ ****************************************************************************/
+
+static struct mv643xx_eth_platform_data ls_hgl_eth_data = {
+	.phy_addr	= 8,
+};
+
+/*****************************************************************************
+ * RTC 5C372a on I2C bus
+ ****************************************************************************/
+
+static struct i2c_board_info __initdata ls_hgl_i2c_rtc = {
+	I2C_BOARD_INFO("rs5c372a", 0x32),
+};
+
+/*****************************************************************************
+ * LEDs attached to GPIO
+ ****************************************************************************/
+
+#define LS_HGL_GPIO_LED_ALARM   2
+#define LS_HGL_GPIO_LED_INFO    3
+#define LS_HGL_GPIO_LED_FUNC    17
+#define LS_HGL_GPIO_LED_PWR     0
+
+
+static struct gpio_led ls_hgl_led_pins[] = {
+	{
+		.name	   = "alarm:red",
+		.gpio	   = LS_HGL_GPIO_LED_ALARM,
+		.active_low     = 1,
+	}, {
+		.name	   = "info:amber",
+		.gpio	   = LS_HGL_GPIO_LED_INFO,
+		.active_low     = 1,
+	}, {
+		.name	   = "func:blue:top",
+		.gpio	   = LS_HGL_GPIO_LED_FUNC,
+		.active_low     = 1,
+	}, {
+		.name	   = "power:blue:bottom",
+		.gpio	   = LS_HGL_GPIO_LED_PWR,
+	},
+};
+
+static struct gpio_led_platform_data ls_hgl_led_data = {
+	.leds	   = ls_hgl_led_pins,
+	.num_leds       = ARRAY_SIZE(ls_hgl_led_pins),
+};
+
+static struct platform_device ls_hgl_leds = {
+	.name   = "leds-gpio",
+	.id     = -1,
+	.dev    = {
+		.platform_data  = &ls_hgl_led_data,
+	},
+};
+
+/****************************************************************************
+ * GPIO Attached Keys
+ ****************************************************************************/
+#define LS_HGL_GPIO_KEY_FUNC       15
+#define LS_HGL_GPIO_KEY_POWER      8
+#define LS_HGL_GPIO_KEY_AUTOPOWER  10
+
+#define LS_HGL_SW_POWER     0x00
+#define LS_HGL_SW_AUTOPOWER 0x01
+
+static struct gpio_keys_button ls_hgl_buttons[] = {
+	{
+		.code	   = KEY_OPTION,
+		.gpio	   = LS_HGL_GPIO_KEY_FUNC,
+		.desc	   = "Function Button",
+		.active_low     = 1,
+	}, {
+		.type		= EV_SW,
+		.code	   = LS_HGL_SW_POWER,
+		.gpio	   = LS_HGL_GPIO_KEY_POWER,
+		.desc	   = "Power-on Switch",
+		.active_low     = 1,
+	}, {
+		.type		= EV_SW,
+		.code	   = LS_HGL_SW_AUTOPOWER,
+		.gpio	   = LS_HGL_GPIO_KEY_AUTOPOWER,
+		.desc	   = "Power-auto Switch",
+		.active_low     = 1,
+	},
+};
+
+static struct gpio_keys_platform_data ls_hgl_button_data = {
+	.buttons	= ls_hgl_buttons,
+	.nbuttons       = ARRAY_SIZE(ls_hgl_buttons),
+};
+
+static struct platform_device ls_hgl_button_device = {
+	.name	   = "gpio-keys",
+	.id	     = -1,
+	.num_resources  = 0,
+	.dev	    = {
+		.platform_data  = &ls_hgl_button_data,
+	},
+};
+
+
+/*****************************************************************************
+ * SATA
+ ****************************************************************************/
+static struct mv_sata_platform_data ls_hgl_sata_data = {
+	.n_ports	= 2,
+};
+
+
+/*****************************************************************************
+ * Linkstation LS-HGL specific power off method: reboot
+ ****************************************************************************/
+/*
+ * On the Linkstation LS-HGL, the shutdown process is following:
+ * - Userland monitors key events until the power switch goes to off position
+ * - The board reboots
+ * - U-boot starts and goes into an idle mode waiting for the user
+ *   to move the switch to ON position
+ */
+
+static void ls_hgl_power_off(void)
+{
+	arch_reset(0, NULL);
+}
+
+
+/*****************************************************************************
+ * General Setup
+ ****************************************************************************/
+
+#define LS_HGL_GPIO_USB_POWER	9
+#define LS_HGL_GPIO_AUTO_POWER	10
+#define LS_HGL_GPIO_POWER	    8
+
+#define LS_HGL_GPIO_HDD_POWER	1
+
+static struct orion5x_mpp_mode ls_hgl_mpp_modes[] __initdata = {
+	{  0, MPP_GPIO }, /* LED_PWR */
+	{  1, MPP_GPIO }, /* HDD_PWR */
+	{  2, MPP_GPIO }, /* LED_ALARM */
+	{  3, MPP_GPIO }, /* LED_INFO */
+	{  4, MPP_UNUSED },
+	{  5, MPP_UNUSED },
+	{  6, MPP_GPIO }, /* FAN_LCK */
+	{  7, MPP_GPIO }, /* INIT */
+	{  8, MPP_GPIO }, /* POWER */
+	{  9, MPP_GPIO }, /* USB_PWR */
+	{ 10, MPP_GPIO }, /* AUTO_POWER */
+	{ 11, MPP_UNUSED }, /* LED_ETH (dummy) */
+	{ 12, MPP_UNUSED },
+	{ 13, MPP_UNUSED },
+	{ 14, MPP_UNUSED },
+	{ 15, MPP_GPIO }, /* FUNC */
+	{ 16, MPP_UNUSED },
+	{ 17, MPP_GPIO }, /* LED_FUNC */
+	{ 18, MPP_UNUSED },
+	{ 19, MPP_UNUSED },
+	{ -1 },
+};
+
+static void __init ls_hgl_init(void)
+{
+	/*
+	 * Setup basic Orion functions. Need to be called early.
+	 */
+	orion5x_init();
+
+	orion5x_mpp_conf(ls_hgl_mpp_modes);
+
+	/*
+	 * Configure peripherals.
+	 */
+	orion5x_ehci0_init();
+	orion5x_ehci1_init();
+	orion5x_eth_init(&ls_hgl_eth_data);
+	orion5x_i2c_init();
+	orion5x_sata_init(&ls_hgl_sata_data);
+	orion5x_uart0_init();
+	orion5x_xor_init();
+
+	orion5x_setup_dev_boot_win(LS_HGL_NOR_BOOT_BASE,
+				   LS_HGL_NOR_BOOT_SIZE);
+	platform_device_register(&ls_hgl_nor_flash);
+
+	platform_device_register(&ls_hgl_button_device);
+
+	platform_device_register(&ls_hgl_leds);
+
+	i2c_register_board_info(0, &ls_hgl_i2c_rtc, 1);
+
+	/* enable USB power */
+	gpio_set_value(LS_HGL_GPIO_USB_POWER, 1);
+
+	/* register power-off method */
+	pm_power_off = ls_hgl_power_off;
+
+	pr_info("%s: finished\n", __func__);
+}
+
+#ifdef CONFIG_MACH_LINKSTATION_LS_HGL
+MACHINE_START(LINKSTATION_LS_HGL, "Buffalo Linkstation LS-HGL")
+	/* Maintainer: Zhu Qingsen <zhuqs@cn.fujistu.com> */
+	.phys_io	= ORION5X_REGS_PHYS_BASE,
+	.io_pg_offst	= ((ORION5X_REGS_VIRT_BASE) >> 18) & 0xFFFC,
+	.boot_params	= 0x00000100,
+	.init_machine	= ls_hgl_init,
+	.map_io		= orion5x_map_io,
+	.init_irq	= orion5x_init_irq,
+	.timer		= &orion5x_timer,
+	.fixup		= tag_fixup_mem32,
+MACHINE_END
+#endif
-- 
1.6.5


