Return-Path: <linux-kernel-owner+w=401wt.eu-S937251AbXHHDmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937251AbXHHDmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 23:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936077AbXHHDgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 23:36:32 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:13539 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934674AbXHHDfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 23:35:52 -0400
X-IronPort-AV: i="4.19,233,1183348800"; 
   d="scan'208"; a="36639275:sNHT885045910"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: dbrownell@users.sourceforge.net, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 10/12] Blackfin arch: update platform driver resource information to the ezkitBF548 board file
Date: Wed,  8 Aug 2007 11:35:35 +0800
Message-Id: <11865441411009-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11865441373719-git-send-email-bryan.wu@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-bf548/boards/ezkit.c |  367 ++++++++++++++++++++++++++++++-
 1 files changed, 366 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index 96ad95f..59e64c5 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -35,9 +35,13 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #include <linux/irq.h>
-#include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <asm/bfin5xx_spi.h>
+#include <asm/dma.h>
+#include <asm/gpio.h>
+#include <asm/mach/nand.h>
+#include <asm/mach/bf54x_keys.h>
+#include <linux/spi/ad7877.h>
 
 /*
  * Name the Board for the /proc/cpuinfo
@@ -48,6 +52,87 @@ char *bfin_board_name = "ADSP-BF548-EZKIT";
  *  Driver needs to know address, irq and flag pin.
  */
 
+#if defined(CONFIG_FB_BF54X_LQ043) || defined(CONFIG_FB_BF54X_LQ043_MODULE)
+
+#include <asm/mach/bf54x-lq043.h>
+
+static struct bfin_bf54xfb_mach_info bf54x_lq043_data = {
+	.width =	480,
+	.height =	272,
+	.xres =		{480, 480, 480},
+	.yres =		{272, 272, 272},
+	.bpp =		{24, 24, 24},
+	.disp =		GPIO_PE3,
+};
+
+static struct resource bf54x_lq043_resources[] = {
+	{
+		.start = IRQ_EPPI0_ERR,
+		.end = IRQ_EPPI0_ERR,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bf54x_lq043_device = {
+	.name		= "bf54x-lq043",
+	.id		= -1,
+	.num_resources 	= ARRAY_SIZE(bf54x_lq043_resources),
+	.resource 	= bf54x_lq043_resources,
+	.dev		= {
+		.platform_data = &bf54x_lq043_data,
+	},
+};
+#endif
+
+#if defined(CONFIG_KEYBOARD_BFIN) || defined(CONFIG_KEYBOARD_BFIN_MODULE)
+static int bf548_keymap[] = {
+	KEYVAL(0, 0, KEY_ENTER),
+	KEYVAL(0, 1, KEY_HELP),
+	KEYVAL(0, 2, KEY_0),
+	KEYVAL(0, 3, KEY_BACKSPACE),
+	KEYVAL(1, 0, KEY_TAB),
+	KEYVAL(1, 1, KEY_9),
+	KEYVAL(1, 2, KEY_8),
+	KEYVAL(1, 3, KEY_7),
+	KEYVAL(2, 0, KEY_DOWN),
+	KEYVAL(2, 1, KEY_6),
+	KEYVAL(2, 2, KEY_5),
+	KEYVAL(2, 3, KEY_4),
+	KEYVAL(3, 0, KEY_UP),
+	KEYVAL(3, 1, KEY_3),
+	KEYVAL(3, 2, KEY_2),
+	KEYVAL(3, 3, KEY_1),
+};
+
+static struct bfin_kpad_platform_data bf54x_kpad_data = {
+	.rows			= 4,
+	.cols			= 4,
+	.keymap 		= bf548_keymap,
+	.keymapsize 		= ARRAY_SIZE(bf548_keymap),
+	.debounce_time		= 5000,	/* ns (5ms) */
+	.coldrive_time		= 1000, /* ns (1ms) */
+	.keyup_test_interval	= 50, /* ms (50ms) */
+};
+
+static struct resource bf54x_kpad_resources[] = {
+	{
+		.start = IRQ_KEY,
+		.end = IRQ_KEY,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bf54x_kpad_device = {
+	.name		= "bf54x-keys",
+	.id		= -1,
+	.num_resources 	= ARRAY_SIZE(bf54x_kpad_resources),
+	.resource 	= bf54x_kpad_resources,
+	.dev		= {
+		.platform_data = &bf54x_kpad_data,
+	},
+};
+#endif
+
 #if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 static struct platform_device rtc_device = {
 	.name = "rtc-bfin",
@@ -94,6 +179,248 @@ static struct platform_device bfin_uart_device = {
 };
 #endif
 
+#if defined(CONFIG_SMSC911X) || defined(CONFIG_SMSC911X_MODULE)
+static struct resource smsc911x_resources[] = {
+	{
+		.name = "smsc911x-memory",
+		.start = 0x24000000,
+		.end = 0x24000000 + 0xFF,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = IRQ_PE8,
+		.end = IRQ_PE8,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL,
+	},
+};
+static struct platform_device smsc911x_device = {
+	.name = "smsc911x",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(smsc911x_resources),
+	.resource = smsc911x_resources,
+};
+#endif
+
+#if defined(CONFIG_USB_BF54x_HCD) || defined(CONFIG_USB_BF54x_HCD_MODULE)
+static struct resource bf54x_hcd_resources[] = {
+	{
+		.start = 0xFFC03C00,
+		.end = 0xFFC040FF,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device bf54x_hcd = {
+	.name = "bf54x-hcd",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(bf54x_hcd_resources),
+	.resource = bf54x_hcd_resources,
+};
+#endif
+
+#if defined(CONFIG_PATA_BF54X) || defined(CONFIG_PATA_BF54X_MODULE)
+static struct resource bfin_atapi_resources[] = {
+	{
+		.start = 0xFFC03800,
+		.end = 0xFFC0386F,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = IRQ_ATAPI_ERR,
+		.end = IRQ_ATAPI_ERR,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bfin_atapi_device = {
+	.name = "bf54x-atapi",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(bfin_atapi_resources),
+	.resource = bfin_atapi_resources,
+};
+#endif
+
+#if defined(CONFIG_MTD_NAND_BF54X) || defined(CONFIG_MTD_NAND_BF54X_MODULE)
+static struct mtd_partition partition_info[] = {
+	{
+		.name = "Linux Kernel",
+		.offset = 0,
+		.size = 4 * SIZE_1M,
+	},
+	{
+		.name = "File System",
+		.offset = 4 * SIZE_1M,
+		.size = (256 - 4) * SIZE_1M,
+	},
+};
+
+static struct bf54x_nand_platform bf54x_nand_platform = {
+	.page_size = NFC_PG_SIZE_256,
+	.data_width = NFC_NWIDTH_8,
+	.partitions = partition_info,
+	.nr_partitions = ARRAY_SIZE(partition_info),
+	.rd_dly = 3,
+	.wr_dly = 3,
+};
+
+static struct resource bf54x_nand_resources[] = {
+	{
+		.start = 0xFFC03B00,
+		.end = 0xFFC03B4F,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = CH_NFC,
+		.end = CH_NFC,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bf54x_nand_device = {
+	.name = "bf54x-nand",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(bf54x_nand_resources),
+	.resource = bf54x_nand_resources,
+	.dev = {
+		.platform_data = &bf54x_nand_platform,
+	},
+};
+#endif
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+/* all SPI peripherals info goes here */
+#if defined(CONFIG_MTD_M25P80) \
+	|| defined(CONFIG_MTD_M25P80_MODULE)
+/* SPI flash chip (m25p16) */
+static struct mtd_partition bfin_spi_flash_partitions[] = {
+	{
+		.name = "bootloader",
+		.size = 0x00030000,
+		.offset = 0,
+		.mask_flags = MTD_CAP_ROM
+	}, {
+		.name = "linux kernel",
+		.size = 0x1d0000,
+		.offset = 0x30000
+	}
+};
+
+static struct flash_platform_data bfin_spi_flash_data = {
+	.name = "m25p80",
+	.parts = bfin_spi_flash_partitions,
+	.nr_parts = ARRAY_SIZE(bfin_spi_flash_partitions),
+	.type = "m25p16",
+};
+
+static struct bfin5xx_spi_chip spi_flash_chip_info = {
+	.enable_dma = 0,         /* use dma transfer with this chip*/
+	.bits_per_word = 8,
+	.cs_change_per_word = 0,
+};
+#endif
+
+#if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
+static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
+	.cs_change_per_word = 1,
+	.enable_dma = 0,
+	.bits_per_word = 16,
+};
+
+static const struct ad7877_platform_data bfin_ad7877_ts_info = {
+	.model			= 7877,
+	.vref_delay_usecs	= 50,	/* internal, no capacitor */
+	.x_plate_ohms		= 419,
+	.y_plate_ohms		= 486,
+	.pressure_max		= 1000,
+	.pressure_min		= 0,
+	.stopacq_polarity 	= 1,
+	.first_conversion_delay = 3,
+	.acquisition_time 	= 1,
+	.averaging 		= 1,
+	.pen_down_acc_interval 	= 1,
+};
+#endif
+
+static struct spi_board_info bf54x_spi_board_info[] __initdata = {
+#if defined(CONFIG_MTD_M25P80) \
+	|| defined(CONFIG_MTD_M25P80_MODULE)
+	{
+		/* the modalias must be the same as spi device driver name */
+		.modalias = "m25p80", /* Name of spi_driver for this device */
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0, /* Framework bus number */
+		.chip_select = 1, /* SPI_SSEL1*/
+		.platform_data = &bfin_spi_flash_data,
+		.controller_data = &spi_flash_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
+#if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
+{
+	.modalias		= "ad7877",
+	.platform_data		= &bfin_ad7877_ts_info,
+	.irq			= IRQ_PJ11,
+	.max_speed_hz		= 12500000,     /* max spi clock (SCK) speed in HZ */
+	.bus_num		= 1,
+	.chip_select  		= 2,
+	.controller_data = &spi_ad7877_chip_info,
+},
+#endif
+};
+
+/* SPI (0) */
+static struct resource bfin_spi0_resource[] = {
+	[0] = {
+		.start = SPI0_REGBASE,
+		.end   = SPI0_REGBASE + 0xFF,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = CH_SPI0,
+		.end   = CH_SPI0,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+/* SPI controller data */
+static struct bfin5xx_spi_master bf54x_spi_master_info = {
+	.num_chipselect = 8,
+	.enable_dma = 1,  /* master has the ability to do dma transfer */
+};
+
+static struct platform_device bf54x_spi_master_device = {
+	.name = "bfin-spi",
+	.id = 0, /* Bus number */
+	.num_resources = ARRAY_SIZE(bfin_spi0_resource),
+	.resource = bfin_spi0_resource,
+	.dev = {
+		.platform_data = &bf54x_spi_master_info, /* Passed to driver */
+		},
+};
+#endif  /* spi master and devices */
+
+#if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
+static struct resource bfin_twi0_resource[] = {
+	[0] = {
+		.start = 0xFFC01400,
+		.end   = 0xFFC014FF,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_TWI0,
+		.end   = IRQ_TWI0,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device i2c_bfin_twi0_device = {
+	.name = "i2c-bfin-twi",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(bfin_twi0_resource),
+	.resource = bfin_twi0_resource,
+};
+#endif
+
 static struct platform_device *ezkit_devices[] __initdata = {
 #if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 	&rtc_device,
@@ -102,12 +429,50 @@ static struct platform_device *ezkit_devices[] __initdata = {
 #if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
 	&bfin_uart_device,
 #endif
+
+#if defined(CONFIG_FB_BF54X_LQ043) || defined(CONFIG_FB_BF54X_LQ043_MODULE)
+	&bf54x_lq043_device,
+#endif
+
+#if defined(CONFIG_SMSC911X) || defined(CONFIG_SMSC911X_MODULE)
+	&smsc911x_device,
+#endif
+
+#if defined(CONFIG_USB_BF54x_HCD) || defined(CONFIG_USB_BF54x_HCD_MODULE)
+	&bf54x_hcd,
+#endif
+
+#if defined(CONFIG_PATA_BF54X) || defined(CONFIG_PATA_BF54X_MODULE)
+	&bfin_atapi_device,
+#endif
+
+#if defined(CONFIG_MTD_NAND_BF54X) || defined(CONFIG_MTD_NAND_BF54X_MODULE)
+	&bf54x_nand_device,
+#endif
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+	&bf54x_spi_master_device,
+#endif
+
+#if defined(CONFIG_KEYBOARD_BFIN) || defined(CONFIG_KEYBOARD_BFIN_MODULE)
+	&bf54x_kpad_device,
+#endif
+
+#if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
+	&i2c_bfin_twi0_device,
+#endif
 };
 
 static int __init stamp_init(void)
 {
 	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
 	platform_add_devices(ezkit_devices, ARRAY_SIZE(ezkit_devices));
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+	spi_register_board_info(bf54x_spi_board_info,
+			ARRAY_SIZE(bf54x_spi_board_info));
+#endif
+
 	return 0;
 }
 
-- 
1.5.2
