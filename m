Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbXDDSJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbXDDSJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbXDDSJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:09:25 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:37226 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbXDDSI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:08:58 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Vladimir Ananiev <vovan888@gmail.com>, Pavel Machek <pavel@suse.cz>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 32/90] ARM: OMAP: Basic support for siemens sx1
Date: Wed,  4 Apr 2007 14:05:11 -0400
Message-Id: <11757100511172-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757100491583-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladimir Ananiev <vovan888@gmail.com>

This adds basic support for Siemens SX1. More patches are available,
with video driver, mixer, and serial ports working. That is enough to
do gsm calls with right userland.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/Kconfig           |   11 +
 arch/arm/mach-omap1/Makefile          |    1 +
 arch/arm/mach-omap1/board-sx1.c       |  494 +++++++++++++++++++++++++++++++++
 include/asm-arm/arch-omap/board-sx1.h |   46 +++
 include/asm-arm/arch-omap/hardware.h  |    4 +
 5 files changed, 556 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
index c3f2b20..96e3bb3 100644
--- a/arch/arm/mach-omap1/Kconfig
+++ b/arch/arm/mach-omap1/Kconfig
@@ -104,6 +104,17 @@ config MACH_OMAP_PALMTT
 	  http://www.hackndev.com/palm/tt/ for more information.
 	  Say Y here if you have this PDA model, say N otherwise.
 
+config MACH_SX1
+	bool "Siemens SX1"
+	depends on ARCH_OMAP1 && ARCH_OMAP15XX
+	help
+	  Support for the Siemens SX1 phone. To boot the kernel,
+	  you'll need a SX1 compatible bootloader; check out
+	  http://forum.oslik.ru and
+	  http://www.handhelds.org/moin/moin.cgi/SiemensSX1
+	  for more information.
+	  Say Y here if you have such a phone, say NO otherwise.
+
 config MACH_NOKIA770
 	bool "Nokia 770"
 	depends on ARCH_OMAP1 && ARCH_OMAP16XX
diff --git a/arch/arm/mach-omap1/Makefile b/arch/arm/mach-omap1/Makefile
index d008c7e..6ebed81 100644
--- a/arch/arm/mach-omap1/Makefile
+++ b/arch/arm/mach-omap1/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_MACH_OMAP_PALMZ71)		+= board-palmz71.o
 obj-$(CONFIG_MACH_OMAP_PALMTT)		+= board-palmtt.o
 obj-$(CONFIG_MACH_NOKIA770)		+= board-nokia770.o
 obj-$(CONFIG_MACH_AMS_DELTA)		+= board-ams-delta.o
+obj-$(CONFIG_MACH_SX1)			+= board-sx1.o
 
 ifeq ($(CONFIG_ARCH_OMAP15XX),y)
 # Innovator-1510 FPGA
diff --git a/arch/arm/mach-omap1/board-sx1.c b/arch/arm/mach-omap1/board-sx1.c
new file mode 100644
index 0000000..2743d63
--- /dev/null
+++ b/arch/arm/mach-omap1/board-sx1.c
@@ -0,0 +1,494 @@
+/*
+* linux/arch/arm/mach-omap1/board-sx1.c
+*
+* Modified from board-generic.c
+*
+* Support for the Siemens SX1 mobile phone.
+*
+* Original version : Vladimir Ananiev (Vovan888-at-gmail com)
+*
+* Maintainters : Vladimir Ananiev (aka Vovan888), Sergge
+*		oslik.ru
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*/
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/platform_device.h>
+#include <linux/notifier.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/types.h>
+#include <linux/i2c.h>
+#include <linux/errno.h>
+
+#include <asm/hardware.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/flash.h>
+#include <asm/mach/map.h>
+
+#include <asm/arch/gpio.h>
+#include <asm/arch/mux.h>
+#include <asm/arch/irda.h>
+#include <asm/arch/usb.h>
+#include <asm/arch/tc.h>
+#include <asm/arch/board.h>
+#include <asm/arch/common.h>
+#include <asm/arch/mcbsp.h>
+#include <asm/arch/omap-alsa.h>
+#include <asm/arch/keypad.h>
+
+/* Write to I2C device */
+int i2c_write_byte(u8 devaddr, u8 regoffset, u8 value)
+{
+	struct i2c_adapter *adap;
+	int err;
+	struct i2c_msg msg[1];
+	unsigned char data[2];
+
+	adap = i2c_get_adapter(0);
+	if (!adap)
+		return -ENODEV;
+	msg->addr = devaddr;	/* I2C address of chip */
+	msg->flags = 0;
+	msg->len = 2;
+	msg->buf = data;
+	data[0] = regoffset;	/* register num */
+	data[1] = value;		/* register data */
+	err = i2c_transfer(adap, msg, 1);
+	if (err >= 0)
+		return 0;
+	return err;
+}
+
+/* Read from I2C device */
+int i2c_read_byte(u8 devaddr, u8 regoffset, u8 * value)
+{
+	struct i2c_adapter *adap;
+	int err;
+	struct i2c_msg msg[1];
+	unsigned char data[2];
+
+	adap = i2c_get_adapter(0);
+	if (!adap)
+		return -ENODEV;
+
+	msg->addr = devaddr;	/* I2C address of chip */
+	msg->flags = 0;
+	msg->len = 1;
+	msg->buf = data;
+	data[0] = regoffset;	/* register num */
+	err = i2c_transfer(adap, msg, 1);
+
+	msg->addr = devaddr;	/* I2C address */
+	msg->flags = I2C_M_RD;
+	msg->len = 1;
+	msg->buf = data;
+	err = i2c_transfer(adap, msg, 1);
+	*value = data[0];
+
+	if (err >= 0)
+		return 0;
+	return err;
+}
+/* set keyboard backlight intensity */
+int sx1_setkeylight(u8 keylight)
+{
+	if (keylight > SOFIA_MAX_LIGHT_VAL)
+		keylight = SOFIA_MAX_LIGHT_VAL;
+	return i2c_write_byte(SOFIA_I2C_ADDR, SOFIA_KEYLIGHT_REG, keylight);
+}
+/* get current keylight intensity */
+int sx1_getkeylight(u8 * keylight)
+{
+	return i2c_read_byte(SOFIA_I2C_ADDR, SOFIA_KEYLIGHT_REG, keylight);
+}
+/* set LCD backlight intensity */
+int sx1_setbacklight(u8 backlight)
+{
+	if (backlight > SOFIA_MAX_LIGHT_VAL)
+		backlight = SOFIA_MAX_LIGHT_VAL;
+	return i2c_write_byte(SOFIA_I2C_ADDR, SOFIA_BACKLIGHT_REG, backlight);
+}
+/* get current LCD backlight intensity */
+int sx1_getbacklight (u8 * backlight)
+{
+	return i2c_read_byte(SOFIA_I2C_ADDR, SOFIA_BACKLIGHT_REG, backlight);
+}
+/* set LCD backlight power on/off */
+int sx1_setmmipower(u8 onoff)
+{
+	int err;
+	u8 dat = 0;
+	err = i2c_read_byte(SOFIA_I2C_ADDR, SOFIA_POWER1_REG, &dat);
+	if (err < 0)
+		return err;
+	if (onoff)
+		dat |= SOFIA_MMILIGHT_POWER;
+	else
+		dat &= ~SOFIA_MMILIGHT_POWER;
+	return i2c_write_byte(SOFIA_I2C_ADDR, SOFIA_POWER1_REG, dat);
+}
+/* set MMC power on/off */
+int sx1_setmmcpower(u8 onoff)
+{
+	int err;
+	u8 dat = 0;
+	err = i2c_read_byte(SOFIA_I2C_ADDR, SOFIA_POWER1_REG, &dat);
+	if (err < 0)
+		return err;
+	if (onoff)
+		dat |= SOFIA_MMC_POWER;
+	else
+		dat &= ~SOFIA_MMC_POWER;
+	return i2c_write_byte(SOFIA_I2C_ADDR, SOFIA_POWER1_REG, dat);
+}
+/* set USB power on/off */
+int sx1_setusbpower(u8 onoff)
+{
+	int err;
+	u8 dat = 0;
+	err = i2c_read_byte(SOFIA_I2C_ADDR, SOFIA_POWER1_REG, &dat);
+	if (err < 0)
+		return err;
+	if (onoff)
+		dat |= SOFIA_USB_POWER;
+	else
+		dat &= ~SOFIA_USB_POWER;
+	return i2c_write_byte(SOFIA_I2C_ADDR, SOFIA_POWER1_REG, dat);
+}
+
+EXPORT_SYMBOL(sx1_setkeylight);
+EXPORT_SYMBOL(sx1_getkeylight);
+EXPORT_SYMBOL(sx1_setbacklight);
+EXPORT_SYMBOL(sx1_getbacklight);
+EXPORT_SYMBOL(sx1_setmmipower);
+EXPORT_SYMBOL(sx1_setmmcpower);
+EXPORT_SYMBOL(sx1_setusbpower);
+
+/*----------- Keypad -------------------------*/
+
+static int sx1_keymap[] = {
+	KEY(5, 3, GROUP_0 | 117), /* camera Qt::Key_F17 */
+	KEY(0, 4, GROUP_0 | 114), /* voice memo Qt::Key_F14 */
+	KEY(1, 4, GROUP_2 | 114), /* voice memo */
+	KEY(2, 4, GROUP_3 | 114), /* voice memo */
+	KEY(0, 0, GROUP_1 | KEY_F12),	/* red button Qt::Key_Hangup */
+	KEY(4, 3, GROUP_1 | KEY_LEFT),
+	KEY(2, 3, GROUP_1 | KEY_DOWN),
+	KEY(1, 3, GROUP_1 | KEY_RIGHT),
+	KEY(0, 3, GROUP_1 | KEY_UP),
+	KEY(3, 3, GROUP_1 | KEY_POWER), /* joystick press or Qt::Key_Select */
+	KEY(5, 0, GROUP_1 | KEY_1),
+	KEY(4, 0, GROUP_1 | KEY_2),
+	KEY(3, 0, GROUP_1 | KEY_3),
+	KEY(3, 4, GROUP_1 | KEY_4),
+	KEY(4, 4, GROUP_1 | KEY_5),
+	KEY(5, 4, GROUP_1 | KEY_KPASTERISK),/* "*" */
+	KEY(4, 1, GROUP_1 | KEY_6),
+	KEY(5, 1, GROUP_1 | KEY_7),
+	KEY(3, 1, GROUP_1 | KEY_8),
+	KEY(3, 2, GROUP_1 | KEY_9),
+	KEY(5, 2, GROUP_1 | KEY_0),
+	KEY(4, 2, GROUP_1 | 113),	/* # F13 Toggle input method Qt::Key_F13 */
+	KEY(0, 1, GROUP_1 | KEY_F11),	/* green button Qt::Key_Call */
+	KEY(1, 2, GROUP_1 | KEY_YEN),	/* left soft Qt::Key_Context1 */
+	KEY(2, 2, GROUP_1 | KEY_F8),	/* right soft Qt::Key_Back */
+	KEY(2, 1, GROUP_1 | KEY_LEFTSHIFT), /* shift */
+	KEY(1, 1, GROUP_1 | KEY_BACKSPACE), /* C (clear) */
+	KEY(0, 2, GROUP_1 | KEY_F7),	/* menu Qt::Key_Menu */
+	0
+};
+
+static struct resource sx1_kp_resources[] = {
+	[0] = {
+		.start	= INT_KEYBOARD,
+		.end	= INT_KEYBOARD,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct omap_kp_platform_data sx1_kp_data = {
+	.rows		= 6,
+	.cols		= 6,
+	.keymap	= sx1_keymap,
+	.keymapsize = ARRAY_SIZE(sx1_keymap),
+	.delay	= 80,
+};
+
+static struct platform_device sx1_kp_device = {
+	.name		= "omap-keypad",
+	.id		= -1,
+	.dev		= {
+		.platform_data = &sx1_kp_data,
+	},
+	.num_resources	= ARRAY_SIZE(sx1_kp_resources),
+	.resource	= sx1_kp_resources,
+};
+
+/*----------- IRDA -------------------------*/
+
+static struct omap_irda_config sx1_irda_data = {
+	.transceiver_cap	= IR_SIRMODE,
+	.rx_channel		= OMAP_DMA_UART3_RX,
+	.tx_channel		= OMAP_DMA_UART3_TX,
+	.dest_start		= UART3_THR,
+	.src_start		= UART3_RHR,
+	.tx_trigger		= 0,
+	.rx_trigger		= 0,
+};
+
+static struct resource sx1_irda_resources[] = {
+	[0] = {
+		.start	= INT_UART3,
+		.end	= INT_UART3,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static u64 irda_dmamask = 0xffffffff;
+
+static struct platform_device sx1_irda_device = {
+	.name		= "omapirda",
+	.id		= 0,
+	.dev		= {
+		.platform_data	= &sx1_irda_data,
+		.dma_mask	= &irda_dmamask,
+	},
+	.num_resources	= ARRAY_SIZE(sx1_irda_resources),
+	.resource	= sx1_irda_resources,
+};
+
+/*----------- McBSP & Sound -------------------------*/
+
+/* Playback interface - McBSP1 */
+static struct omap_mcbsp_reg_cfg mcbsp1_regs = {
+	.spcr2	= XINTM(3),	/* SPCR2=30 */
+	.spcr1	= RINTM(3),	/* SPCR1=30 */
+	.rcr2	= 0,	/* RCR2 =00 */
+	.rcr1	= RFRLEN1(1) | RWDLEN1(OMAP_MCBSP_WORD_16),	/* RCR1=140 */
+	.xcr2	= 0,	/* XCR2 = 0 */
+	.xcr1	= XFRLEN1(1) | XWDLEN1(OMAP_MCBSP_WORD_16),	/* XCR1 = 140 */
+	.srgr1	= FWID(15) | CLKGDV(12),	/* SRGR1=0f0c */
+	.srgr2	= FSGM | FPER(31),	/* SRGR2=101f */
+	.pcr0	= FSXM | FSRM | CLKXM | CLKRM | FSXP | FSRP | CLKXP | CLKRP,
+						/* PCR0 =0f0f */
+};
+
+/* TODO: PCM interface - McBSP2 */
+static struct omap_mcbsp_reg_cfg mcbsp2_regs = {
+	.spcr2	= FRST | GRST | XRST | XINTM(3),	/* SPCR2=F1 */
+	.spcr1	= RINTM(3) | RRST,	/* SPCR1=30 */
+	.rcr2	= 0,	/* RCR2 =00 */
+	.rcr1	= RFRLEN1(1) | RWDLEN1(OMAP_MCBSP_WORD_16), /* RCR1 = 140 */
+	.xcr2	= 0,	/* XCR2 = 0 */
+	.xcr1	= XFRLEN1(1) | XWDLEN1(OMAP_MCBSP_WORD_16), /* XCR1 = 140 */
+	.srgr1	= FWID(15) | CLKGDV(12),	/* SRGR1=0f0c */
+	.srgr2	= FSGM | FPER(31),	/* SRGR2=101f */
+	.pcr0	= FSXM | FSRM | CLKXM | CLKRM | FSXP | FSRP | CLKXP | CLKRP,
+						/* PCR0=0f0f */
+	/* mcbsp: slave */
+};
+
+static struct omap_alsa_codec_config sx1_alsa_config = {
+	.name			= "SX1 EGold",
+	.mcbsp_regs_alsa	= &mcbsp1_regs,
+};
+
+static struct platform_device sx1_mcbsp1_device = {
+	.name	= "omap_alsa_mcbsp",
+	.id	= 1,
+	.dev = {
+		.platform_data	= &sx1_alsa_config,
+	},
+};
+
+/*----------- MTD -------------------------*/
+
+static struct mtd_partition sx1_partitions[] = {
+	/* bootloader (U-Boot, etc) in first sector */
+	{
+		.name		= "bootloader",
+		.offset		= 0x01800000,
+		.size		= SZ_128K,
+		.mask_flags	= MTD_WRITEABLE, /* force read-only */
+	},
+	/* bootloader params in the next sector */
+	{
+		.name		= "params",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= SZ_128K,
+		.mask_flags	= 0,
+	},
+	/* kernel */
+	{
+		.name		= "kernel",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= SZ_2M - 2 * SZ_128K,
+		.mask_flags	= 0
+	},
+	/* file system */
+	{
+		.name		= "filesystem",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= MTDPART_SIZ_FULL,
+		.mask_flags	= 0
+	}
+};
+
+static struct flash_platform_data sx1_flash_data = {
+	.map_name	= "cfi_probe",
+	.width		= 2,
+	.parts		= sx1_partitions,
+	.nr_parts	= ARRAY_SIZE(sx1_partitions),
+};
+
+#ifdef CONFIG_SX1_OLD_FLASH
+/* MTD Intel StrataFlash - old flashes */
+static struct resource sx1_old_flash_resource[] = {
+	[0] = {
+		.start	= OMAP_CS0_PHYS,	/* Physical */
+		.end	= OMAP_CS0_PHYS + SZ_16M - 1,,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= OMAP_CS1_PHYS,
+		.end	= OMAP_CS1_PHYS + SZ_8M - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device sx1_flash_device = {
+	.name		= "omapflash",
+	.id		= 0,
+	.dev		= {
+		.platform_data	= &sx1_flash_data,
+	},
+	.num_resources	= 2,
+	.resource	= &sx1_old_flash_resource,
+};
+#else
+/* MTD Intel 4000 flash - new flashes */
+static struct resource sx1_new_flash_resource = {
+	.start		= OMAP_CS0_PHYS,
+	.end		= OMAP_CS0_PHYS + SZ_32M - 1,
+	.flags		= IORESOURCE_MEM,
+};
+
+static struct platform_device sx1_flash_device = {
+	.name		= "omapflash",
+	.id		= 0,
+	.dev		= {
+		.platform_data	= &sx1_flash_data,
+	},
+	.num_resources	= 1,
+	.resource	= &sx1_new_flash_resource,
+};
+#endif
+
+/*----------- USB -------------------------*/
+
+static struct omap_usb_config sx1_usb_config __initdata = {
+	.otg		= 0,
+	.register_dev	= 1,
+	.register_host	= 0,
+	.hmc_mode	= 0,
+	.pins[0]	= 2,
+	.pins[1]	= 0,
+	.pins[2]	= 0,
+};
+
+/*----------- MMC -------------------------*/
+
+static struct omap_mmc_config sx1_mmc_config __initdata = {
+	.mmc [0] = {
+		.enabled 	= 1,
+		.wire4		= 0,
+		.wp_pin		= -1,
+		.power_pin	= -1, /* power is in Sofia */
+		.switch_pin	= OMAP_MPUIO(3),
+	},
+};
+
+/*----------- LCD -------------------------*/
+
+static struct platform_device sx1_lcd_device = {
+	.name		= "lcd_sx1",
+	.id		= -1,
+};
+
+static struct omap_lcd_config sx1_lcd_config __initdata = {
+	.ctrl_name	= "internal",
+};
+
+/*-----------------------------------------*/
+static struct platform_device *sx1_devices[] __initdata = {
+	&sx1_flash_device,
+	&sx1_kp_device,
+	&sx1_lcd_device,
+	&sx1_mcbsp1_device,
+	&sx1_irda_device,
+};
+/*-----------------------------------------*/
+
+static struct omap_uart_config sx1_uart_config __initdata = {
+	.enabled_uarts = ((1 << 0) | (1 << 1) | (1 << 2)),
+};
+
+static struct omap_board_config_kernel sx1_config[] = {
+	{ OMAP_TAG_USB,	&sx1_usb_config },
+	{ OMAP_TAG_MMC,	&sx1_mmc_config },
+	{ OMAP_TAG_LCD,	&sx1_lcd_config },
+	{ OMAP_TAG_UART,	&sx1_uart_config },
+};
+/*-----------------------------------------*/
+static void __init omap_sx1_init(void)
+{
+	platform_add_devices(sx1_devices, ARRAY_SIZE(sx1_devices));
+
+	omap_board_config = sx1_config;
+	omap_board_config_size = ARRAY_SIZE(sx1_config);
+	omap_serial_init();
+
+	/* turn on USB power */
+	/* sx1_setusbpower(1); cant do it here because i2c is not ready */
+	omap_request_gpio(1);	/* A_IRDA_OFF */
+	omap_request_gpio(11);	/* A_SWITCH */
+	omap_request_gpio(15);	/* A_USB_ON */
+	omap_set_gpio_direction(1, 0);/* gpio1 -> output */
+	omap_set_gpio_direction(11, 0);/* gpio11 -> output */
+	omap_set_gpio_direction(15, 0);/* gpio15 -> output */
+	/* set GPIO data */
+	omap_set_gpio_dataout(1, 1);/*A_IRDA_OFF = 1 */
+	omap_set_gpio_dataout(11, 0);/*A_SWITCH = 0 */
+	omap_set_gpio_dataout(15, 0);/*A_USB_ON = 0 */
+
+}
+/*----------------------------------------*/
+static void __init omap_sx1_init_irq(void)
+{
+	omap1_init_common_hw();
+	omap_init_irq();
+	omap_gpio_init();
+}
+/*----------------------------------------*/
+
+static void __init omap_sx1_map_io(void)
+{
+	omap1_map_common_io();
+}
+
+MACHINE_START(SX1, "OMAP310 based Siemens SX1")
+	.phys_io	= 0xfff00000,
+	.io_pg_offst	= ((0xfef00000) >> 18) & 0xfffc,
+	.boot_params	= 0x10000100,
+	.map_io		= omap_sx1_map_io,
+	.init_irq		= omap_sx1_init_irq,
+	.init_machine	= omap_sx1_init,
+	.timer		= &omap_timer,
+MACHINE_END
diff --git a/include/asm-arm/arch-omap/board-sx1.h b/include/asm-arm/arch-omap/board-sx1.h
new file mode 100644
index 0000000..2bb8dd6
--- /dev/null
+++ b/include/asm-arm/arch-omap/board-sx1.h
@@ -0,0 +1,46 @@
+/*
+ * Siemens SX1 board definitions
+ *
+ * Copyright: Vovan888 at gmail com
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef __ASM_ARCH_SX1_I2C_CHIPS_H
+#define __ASM_ARCH_SX1_I2C_CHIPS_H
+
+#define SOFIA_MAX_LIGHT_VAL	0x2B
+
+#define SOFIA_I2C_ADDR		0x32
+/* Sofia reg 3 bits masks */
+#define SOFIA_POWER1_REG	0x03
+
+#define	SOFIA_USB_POWER		0x01
+#define	SOFIA_MMC_POWER		0x04
+#define	SOFIA_BLUETOOTH_POWER	0x08
+#define	SOFIA_MMILIGHT_POWER	0x20
+
+#define SOFIA_POWER2_REG	0x04
+#define SOFIA_BACKLIGHT_REG	0x06
+#define SOFIA_KEYLIGHT_REG	0x07
+#define SOFIA_DIMMING_REG	0x09
+
+
+/* Function Prototypes for SX1 devices control on I2C bus */
+
+int sx1_setbacklight(u8 backlight);
+int sx1_getbacklight(u8 *backlight);
+int sx1_setkeylight(u8 keylight);
+int sx1_getkeylight(u8 *keylight);
+
+int sx1_setmmipower(u8 onoff);
+int sx1_setusbpower(u8 onoff);
+int sx1_setmmcpower(u8 onoff);
+
+#endif /* __ASM_ARCH_SX1_I2C_CHIPS_H */
diff --git a/include/asm-arm/arch-omap/hardware.h b/include/asm-arm/arch-omap/hardware.h
index 2633814..ad4c076 100644
--- a/include/asm-arm/arch-omap/hardware.h
+++ b/include/asm-arm/arch-omap/hardware.h
@@ -337,6 +337,10 @@
 #include "board-palmtt.h"
 #endif
 
+#ifdef CONFIG_MACH_SX1
+#include "board-sx1.h"
+#endif
+
 #endif /* !__ASSEMBLER__ */
 
 #endif	/* __ASM_ARCH_OMAP_HARDWARE_H */
-- 
1.4.4.2

