Return-Path: <linux-kernel-owner+w=401wt.eu-S933763AbZINULu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763AbZINULu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933752AbZINULs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:11:48 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54207 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933676AbZINUJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:09:11 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Harald Krapfenbauer <Harald.Krapfenbauer@bluetechnix.at>
Subject: [PATCH 70/72] Blackfin: update cm board resources
Date: Mon, 14 Sep 2009 16:08:14 -0400
Message-Id: <1252958896-25150-71-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Krapfenbauer <Harald.Krapfenbauer@bluetechnix.at>

Signed-off-by: Harald Krapfenbauer <Harald.Krapfenbauer@bluetechnix.at>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf527/boards/cm_bf527.c  |   97 ++++++++++++----------
 arch/blackfin/mach-bf533/boards/cm_bf533.c  |  114 ++++++++++++++++++++++++++-
 arch/blackfin/mach-bf537/boards/tcm_bf537.c |   13 ++--
 arch/blackfin/mach-bf548/boards/cm_bf548.c  |   15 +++-
 arch/blackfin/mach-bf561/boards/cm_bf561.c  |  113 ++++++++++++++++++++++++++-
 5 files changed, 297 insertions(+), 55 deletions(-)

diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index a0f623d..08a3f01 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -151,46 +151,6 @@ static struct platform_device musb_device = {
 };
 #endif
 
-#if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
-static struct mtd_partition ezkit_partitions[] = {
-	{
-		.name       = "bootloader(nor)",
-		.size       = 0x40000,
-		.offset     = 0,
-	}, {
-		.name       = "linux kernel(nor)",
-		.size       = 0x1C0000,
-		.offset     = MTDPART_OFS_APPEND,
-	}, {
-		.name       = "file system(nor)",
-		.size       = MTDPART_SIZ_FULL,
-		.offset     = MTDPART_OFS_APPEND,
-	}
-};
-
-static struct physmap_flash_data ezkit_flash_data = {
-	.width      = 2,
-	.parts      = ezkit_partitions,
-	.nr_parts   = ARRAY_SIZE(ezkit_partitions),
-};
-
-static struct resource ezkit_flash_resource = {
-	.start = 0x20000000,
-	.end   = 0x201fffff,
-	.flags = IORESOURCE_MEM,
-};
-
-static struct platform_device ezkit_flash_device = {
-	.name          = "physmap-flash",
-	.id            = 0,
-	.dev = {
-		.platform_data = &ezkit_flash_data,
-	},
-	.num_resources = 1,
-	.resource      = &ezkit_flash_resource,
-};
-#endif
-
 #if defined(CONFIG_MTD_NAND_BF5XX) || defined(CONFIG_MTD_NAND_BF5XX_MODULE)
 static struct mtd_partition partition_info[] = {
 	{
@@ -662,6 +622,55 @@ static struct platform_device bfin_fb_adv7393_device = {
 };
 #endif
 
+#if defined(CONFIG_MTD_GPIO_ADDR) || defined(CONFIG_MTD_GPIO_ADDR_MODULE)
+static struct mtd_partition cm_partitions[] = {
+	{
+		.name   = "bootloader(nor)",
+		.size   = 0x40000,
+		.offset = 0,
+	}, {
+		.name   = "linux kernel(nor)",
+		.size   = 0x100000,
+		.offset = MTDPART_OFS_APPEND,
+	}, {
+		.name   = "file system(nor)",
+		.size   = MTDPART_SIZ_FULL,
+		.offset = MTDPART_OFS_APPEND,
+	}
+};
+
+static struct physmap_flash_data cm_flash_data = {
+	.width    = 2,
+	.parts    = cm_partitions,
+	.nr_parts = ARRAY_SIZE(cm_partitions),
+};
+
+static unsigned cm_flash_gpios[] = { GPIO_PH9, GPIO_PG11 };
+
+static struct resource cm_flash_resource[] = {
+	{
+		.name  = "cfi_probe",
+		.start = 0x20000000,
+		.end   = 0x201fffff,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = (unsigned long)cm_flash_gpios,
+		.end   = ARRAY_SIZE(cm_flash_gpios),
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device cm_flash_device = {
+	.name          = "gpio-addr-flash",
+	.id            = 0,
+	.dev = {
+		.platform_data = &cm_flash_data,
+	},
+	.num_resources = ARRAY_SIZE(cm_flash_resource),
+	.resource      = cm_flash_resource,
+};
+#endif
+
 #if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
 static struct resource bfin_uart_resources[] = {
 #ifdef CONFIG_SERIAL_BFIN_UART0
@@ -847,7 +856,7 @@ static struct platform_device bfin_dpmc = {
 	},
 };
 
-static struct platform_device *stamp_devices[] __initdata = {
+static struct platform_device *cmbf527_devices[] __initdata = {
 
 	&bfin_dpmc,
 
@@ -930,8 +939,8 @@ static struct platform_device *stamp_devices[] __initdata = {
 	&bfin_device_gpiokeys,
 #endif
 
-#if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
-	&ezkit_flash_device,
+#if defined(CONFIG_MTD_GPIO_ADDR) || defined(CONFIG_MTD_GPIO_ADDR_MODULE)
+	&cm_flash_device,
 #endif
 
 	&bfin_gpios_device,
@@ -942,7 +951,7 @@ static int __init cm_init(void)
 	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	i2c_register_board_info(0, bfin_i2c_board_info,
 				ARRAY_SIZE(bfin_i2c_board_info));
-	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
+	platform_add_devices(cmbf527_devices, ARRAY_SIZE(cmbf527_devices));
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 	return 0;
 }
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index ef31bc5..7443b26 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -31,8 +31,10 @@
 #include <linux/platform_device.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
+#include <linux/mtd/physmap.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
+#include <linux/spi/mmc_spi.h>
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
 #endif
@@ -141,9 +143,9 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
 		.modalias = "mmc_spi",
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.max_speed_hz = 20000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
-		.chip_select = 5,
+		.chip_select = 1,
 		.controller_data = &mmc_spi_chip_info,
 		.mode = SPI_MODE_3,
 	},
@@ -225,6 +227,40 @@ static struct platform_device smc91x_device = {
 };
 #endif
 
+#if defined(CONFIG_SMSC911X) || defined(CONFIG_SMSC911X_MODULE)
+#include <linux/smsc911x.h>
+
+static struct resource smsc911x_resources[] = {
+	{
+		.name = "smsc911x-memory",
+		.start = 0x20308000,
+		.end = 0x20308000 + 0xFF,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IRQ_PF8,
+		.end = IRQ_PF8,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL,
+	},
+};
+
+static struct smsc911x_platform_config smsc911x_config = {
+	.flags = SMSC911X_USE_16BIT,
+	.irq_polarity = SMSC911X_IRQ_POLARITY_ACTIVE_LOW,
+	.irq_type = SMSC911X_IRQ_TYPE_OPEN_DRAIN,
+	.phy_interface = PHY_INTERFACE_MODE_MII,
+};
+
+static struct platform_device smsc911x_device = {
+	.name = "smsc911x",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(smsc911x_resources),
+	.resource = smsc911x_resources,
+	.dev = {
+		.platform_data = &smsc911x_config,
+	},
+};
+#endif
+
 static struct resource bfin_gpios_resources = {
 	.start = 0,
 	.end   = MAX_BLACKFIN_GPIOS - 1,
@@ -335,6 +371,68 @@ static struct platform_device isp1362_hcd_device = {
 };
 #endif
 
+
+#if defined(CONFIG_USB_NET2272) || defined(CONFIG_USB_NET2272_MODULE)
+static struct resource net2272_bfin_resources[] = {
+	{
+		.start = 0x20300000,
+		.end = 0x20300000 + 0x100,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IRQ_PF6,
+		.end = IRQ_PF6,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	},
+};
+
+static struct platform_device net2272_bfin_device = {
+	.name = "net2272",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(net2272_bfin_resources),
+	.resource = net2272_bfin_resources,
+};
+#endif
+
+
+
+#if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
+static struct mtd_partition para_partitions[] = {
+	{
+		.name       = "bootloader(nor)",
+		.size       = 0x40000,
+		.offset     = 0,
+	}, {
+		.name       = "linux+rootfs(nor)",
+		.size       = MTDPART_SIZ_FULL,
+		.offset     = MTDPART_OFS_APPEND,
+	},
+};
+
+static struct physmap_flash_data para_flash_data = {
+	.width      = 2,
+	.parts      = para_partitions,
+	.nr_parts   = ARRAY_SIZE(para_partitions),
+};
+
+static struct resource para_flash_resource = {
+	.start = 0x20000000,
+	.end   = 0x201fffff,
+	.flags = IORESOURCE_MEM,
+};
+
+static struct platform_device para_flash_device = {
+	.name          = "physmap-flash",
+	.id            = 0,
+	.dev = {
+		.platform_data = &para_flash_data,
+	},
+	.num_resources = 1,
+	.resource      = &para_flash_resource,
+};
+#endif
+
+
+
 static const unsigned int cclk_vlev_datasheet[] =
 {
 	VRPAIR(VLEV_085, 250000000),
@@ -393,10 +491,22 @@ static struct platform_device *cm_bf533_devices[] __initdata = {
 	&smc91x_device,
 #endif
 
+#if defined(CONFIG_SMSC911X) || defined(CONFIG_SMSC911X_MODULE)
+	&smsc911x_device,
+#endif
+
+#if defined(CONFIG_USB_NET2272) || defined(CONFIG_USB_NET2272_MODULE)
+	&net2272_bfin_device,
+#endif
+
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	&bfin_spi0_device,
 #endif
 
+#if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
+	&para_flash_device,
+#endif
+
 	&bfin_gpios_device,
 };
 
diff --git a/arch/blackfin/mach-bf537/boards/tcm_bf537.c b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
index dc4f161..61353f7 100644
--- a/arch/blackfin/mach-bf537/boards/tcm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
@@ -45,6 +45,7 @@
 #include <asm/bfin5xx_spi.h>
 #include <asm/portmux.h>
 #include <asm/dpmc.h>
+#include <linux/spi/mmc_spi.h>
 
 /*
  * Name the Board for the /proc/cpuinfo
@@ -148,7 +149,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.modalias = "mmc_spi",
 		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
-		.chip_select = 5,
+		.chip_select = 1,
 		.controller_data = &mmc_spi_chip_info,
 		.mode = SPI_MODE_3,
 	},
@@ -279,12 +280,12 @@ static struct platform_device isp1362_hcd_device = {
 #if defined(CONFIG_USB_NET2272) || defined(CONFIG_USB_NET2272_MODULE)
 static struct resource net2272_bfin_resources[] = {
 	{
-		.start = 0x20200000,
-		.end = 0x20200000 + 0x100,
+		.start = 0x20300000,
+		.end = 0x20300000 + 0x100,
 		.flags = IORESOURCE_MEM,
 	}, {
-		.start = IRQ_PH14,
-		.end = IRQ_PH14,
+		.start = IRQ_PG13,
+		.end = IRQ_PG13,
 		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
 	},
 };
@@ -318,7 +319,7 @@ static struct mtd_partition cm_partitions[] = {
 		.offset = 0,
 	}, {
 		.name   = "linux kernel(nor)",
-		.size   = 0xE0000,
+		.size   = 0x100000,
 		.offset = MTDPART_OFS_APPEND,
 	}, {
 		.name   = "file system(nor)",
diff --git a/arch/blackfin/mach-bf548/boards/cm_bf548.c b/arch/blackfin/mach-bf548/boards/cm_bf548.c
index 290b6e9..e565aae 100644
--- a/arch/blackfin/mach-bf548/boards/cm_bf548.c
+++ b/arch/blackfin/mach-bf548/boards/cm_bf548.c
@@ -291,6 +291,8 @@ static struct platform_device bfin_sir3_device = {
 #endif
 
 #if defined(CONFIG_SMSC911X) || defined(CONFIG_SMSC911X_MODULE)
+#include <linux/smsc911x.h>
+
 static struct resource smsc911x_resources[] = {
 	{
 		.name = "smsc911x-memory",
@@ -304,11 +306,22 @@ static struct resource smsc911x_resources[] = {
 		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL,
 	},
 };
+
+static struct smsc911x_platform_config smsc911x_config = {
+	.flags = SMSC911X_USE_16BIT,
+	.irq_polarity = SMSC911X_IRQ_POLARITY_ACTIVE_LOW,
+	.irq_type = SMSC911X_IRQ_TYPE_OPEN_DRAIN,
+	.phy_interface = PHY_INTERFACE_MODE_MII,
+};
+
 static struct platform_device smsc911x_device = {
 	.name = "smsc911x",
 	.id = 0,
 	.num_resources = ARRAY_SIZE(smsc911x_resources),
 	.resource = smsc911x_resources,
+	.dev = {
+		.platform_data = &smsc911x_config,
+	},
 };
 #endif
 
@@ -473,7 +486,7 @@ static struct mtd_partition para_partitions[] = {
 		.offset     = 0,
 	}, {
 		.name       = "linux kernel(nor)",
-		.size       = 0x400000,
+		.size       = 0x100000,
 		.offset     = MTDPART_OFS_APPEND,
 	}, {
 		.name       = "file system(nor)",
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index 5721620..6577ecf 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -42,6 +42,7 @@
 #include <asm/bfin5xx_spi.h>
 #include <asm/portmux.h>
 #include <asm/dpmc.h>
+#include <linux/mtd/physmap.h>
 
 /*
  * Name the Board for the /proc/cpuinfo
@@ -142,9 +143,9 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
 		.modalias = "mmc_spi",
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.max_speed_hz = 20000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
-		.chip_select = 5,
+		.chip_select = 1,
 		.controller_data = &mmc_spi_chip_info,
 		.mode = SPI_MODE_3,
 	},
@@ -228,6 +229,62 @@ static struct platform_device smc91x_device = {
 };
 #endif
 
+#if defined(CONFIG_SMSC911X) || defined(CONFIG_SMSC911X_MODULE)
+#include <linux/smsc911x.h>
+
+static struct resource smsc911x_resources[] = {
+	{
+		.name = "smsc911x-memory",
+		.start = 0x24008000,
+		.end = 0x24008000 + 0xFF,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = IRQ_PF43,
+		.end = IRQ_PF43,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL,
+	},
+};
+
+static struct smsc911x_platform_config smsc911x_config = {
+	.flags = SMSC911X_USE_16BIT,
+	.irq_polarity = SMSC911X_IRQ_POLARITY_ACTIVE_LOW,
+	.irq_type = SMSC911X_IRQ_TYPE_OPEN_DRAIN,
+	.phy_interface = PHY_INTERFACE_MODE_MII,
+};
+
+static struct platform_device smsc911x_device = {
+	.name = "smsc911x",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(smsc911x_resources),
+	.resource = smsc911x_resources,
+	.dev = {
+		.platform_data = &smsc911x_config,
+	},
+};
+#endif
+
+#if defined(CONFIG_USB_NET2272) || defined(CONFIG_USB_NET2272_MODULE)
+static struct resource net2272_bfin_resources[] = {
+	{
+		.start = 0x24000000,
+		.end = 0x24000000 + 0x100,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IRQ_PF45,
+		.end = IRQ_PF45,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	},
+};
+
+static struct platform_device net2272_bfin_device = {
+	.name = "net2272",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(net2272_bfin_resources),
+	.resource = net2272_bfin_resources,
+};
+#endif
+
 static struct resource bfin_gpios_resources = {
 	.start = 0,
 	.end   = MAX_BLACKFIN_GPIOS - 1,
@@ -363,6 +420,46 @@ static struct platform_device bfin_pata_device = {
 };
 #endif
 
+#if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
+static struct mtd_partition para_partitions[] = {
+	{
+		.name       = "bootloader(nor)",
+		.size       = 0x40000,
+		.offset     = 0,
+	}, {
+		.name       = "linux kernel(nor)",
+		.size       = 0x100000,
+		.offset     = MTDPART_OFS_APPEND,
+	}, {
+		.name       = "file system(nor)",
+		.size       = MTDPART_SIZ_FULL,
+		.offset     = MTDPART_OFS_APPEND,
+	}
+};
+
+static struct physmap_flash_data para_flash_data = {
+	.width      = 2,
+	.parts      = para_partitions,
+	.nr_parts   = ARRAY_SIZE(para_partitions),
+};
+
+static struct resource para_flash_resource = {
+	.start = 0x20000000,
+	.end   = 0x207fffff,
+	.flags = IORESOURCE_MEM,
+};
+
+static struct platform_device para_flash_device = {
+	.name          = "physmap-flash",
+	.id            = 0,
+	.dev = {
+		.platform_data = &para_flash_data,
+	},
+	.num_resources = 1,
+	.resource      = &para_flash_resource,
+};
+#endif
+
 static const unsigned int cclk_vlev_datasheet[] =
 {
 	VRPAIR(VLEV_085, 250000000),
@@ -416,6 +513,14 @@ static struct platform_device *cm_bf561_devices[] __initdata = {
 	&smc91x_device,
 #endif
 
+#if defined(CONFIG_SMSC911X) || defined(CONFIG_SMSC911X_MODULE)
+	&smsc911x_device,
+#endif
+
+#if defined(CONFIG_USB_NET2272) || defined(CONFIG_USB_NET2272_MODULE)
+	&net2272_bfin_device,
+#endif
+
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	&bfin_spi0_device,
 #endif
@@ -424,6 +529,10 @@ static struct platform_device *cm_bf561_devices[] __initdata = {
 	&bfin_pata_device,
 #endif
 
+#if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
+	&para_flash_device,
+#endif
+
 	&bfin_gpios_device,
 };
 
-- 
1.6.4.2

