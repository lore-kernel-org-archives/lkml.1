Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbZHOLdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbZHOLdG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 07:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbZHOLdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 07:33:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:57990 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbZHOLdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 07:33:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=qbb61l+BiXGaHGXAQge6VNnajWvbnsY3krstR+48mug9ZLgrFyoB+Nzv0flz3yIwix
         qRt3OlpWTU9LbphXKd/VEQXeHxk52HyPWAseb21DZSGKHwHiG1OjZXxJtA8piza/0q/z
         Gz8nEGeKIMXlqitLlL49ADD50XPWh7vTHXrrE=
Message-ID: <4A869CEA.2080103@gmail.com>
Date: Sat, 15 Aug 2009 19:32:58 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 2/9] ARM: modify mach-w90p910.c file for w90p910
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

To change mach-w90p910.c file for w90p910 platform.

At present, I re-arranged my w90x900 series platform architectures, adding 'dev.c' which was used to define the common platform device struct and adding  the 'cpu.c' file to implement the common CPU function API, and for the function of specific CPU that were implemented in other file, such as nuc950.c, w90p910.c, due to there are six CPU patches will added to the mach-w90x900, so I think it was distinct to do above.

For above reasons, I modify the 'mach-w90p910.c' file.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/mach-w90p910evb.c |  354 +------------------------------
 1 files changed, 4 insertions(+), 350 deletions(-)

diff --git a/arch/arm/mach-w90x900/mach-w90p910evb.c b/arch/arm/mach-w90x900/mach-w90p910evb.c
index 117578a..91ceb52 100644
--- a/arch/arm/mach-w90x900/mach-w90p910evb.c
+++ b/arch/arm/mach-w90x900/mach-w90p910evb.c
@@ -36,363 +36,17 @@
 #include <mach/regs-serial.h>
 #include <mach/map.h>
 
-#include "cpu.h"
-/*w90p910 evb norflash driver data */
-
-#define W90P910_FLASH_BASE	0xA0000000
-#define W90P910_FLASH_SIZE	0x400000
-#define SPIOFFSET		0x200
-#define SPIOREG_SIZE		0x100
-
-static struct mtd_partition w90p910_flash_partitions[] = {
-	{
-		.name	=	"NOR Partition 1 for kernel (960K)",
-		.size	=	0xF0000,
-		.offset	=	0x10000,
-	},
-	{
-		.name	=	"NOR Partition 2 for image (1M)",
-		.size	=	0x100000,
-		.offset	=	0x100000,
-	},
-	{
-		.name	=	"NOR Partition 3 for user (2M)",
-		.size	=	0x200000,
-		.offset	=	0x00200000,
-	}
-};
-
-static struct physmap_flash_data w90p910_flash_data = {
-	.width		=	2,
-	.parts		=	w90p910_flash_partitions,
-	.nr_parts	=	ARRAY_SIZE(w90p910_flash_partitions),
-};
-
-static struct resource w90p910_flash_resources[] = {
-	{
-		.start	=	W90P910_FLASH_BASE,
-		.end	=	W90P910_FLASH_BASE + W90P910_FLASH_SIZE - 1,
-		.flags	=	IORESOURCE_MEM,
-	}
-};
-
-static struct platform_device w90p910_flash_device = {
-	.name		=	"physmap-flash",
-	.id		=	0,
-	.dev		= {
-				.platform_data = &w90p910_flash_data,
-			},
-	.resource	=	w90p910_flash_resources,
-	.num_resources	=	ARRAY_SIZE(w90p910_flash_resources),
-};
-
-/* USB EHCI Host Controller */
-
-static struct resource w90x900_usb_ehci_resource[] = {
-	[0] = {
-		.start = W90X900_PA_USBEHCIHOST,
-		.end   = W90X900_PA_USBEHCIHOST + W90X900_SZ_USBEHCIHOST - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_USBH,
-		.end   = IRQ_USBH,
-		.flags = IORESOURCE_IRQ,
-	}
-};
-
-static u64 w90x900_device_usb_ehci_dmamask = 0xffffffffUL;
-
-struct platform_device w90x900_device_usb_ehci = {
-	.name		  = "w90x900-ehci",
-	.id		  = -1,
-	.num_resources	  = ARRAY_SIZE(w90x900_usb_ehci_resource),
-	.resource	  = w90x900_usb_ehci_resource,
-	.dev              = {
-		.dma_mask = &w90x900_device_usb_ehci_dmamask,
-		.coherent_dma_mask = 0xffffffffUL
-	}
-};
-EXPORT_SYMBOL(w90x900_device_usb_ehci);
-
-/* USB OHCI Host Controller */
-
-static struct resource w90x900_usb_ohci_resource[] = {
-	[0] = {
-		.start = W90X900_PA_USBOHCIHOST,
-		.end   = W90X900_PA_USBOHCIHOST + W90X900_SZ_USBOHCIHOST - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_USBH,
-		.end   = IRQ_USBH,
-		.flags = IORESOURCE_IRQ,
-	}
-};
-
-static u64 w90x900_device_usb_ohci_dmamask = 0xffffffffUL;
-struct platform_device w90x900_device_usb_ohci = {
-	.name		  = "w90x900-ohci",
-	.id		  = -1,
-	.num_resources	  = ARRAY_SIZE(w90x900_usb_ohci_resource),
-	.resource	  = w90x900_usb_ohci_resource,
-	.dev              = {
-		.dma_mask = &w90x900_device_usb_ohci_dmamask,
-		.coherent_dma_mask = 0xffffffffUL
-	}
-};
-EXPORT_SYMBOL(w90x900_device_usb_ohci);
-
-/*TouchScreen controller*/
-
-static struct resource w90x900_ts_resource[] = {
-	[0] = {
-		.start = W90X900_PA_ADC,
-		.end   = W90X900_PA_ADC + W90X900_SZ_ADC-1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_ADC,
-		.end   = IRQ_ADC,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-struct platform_device w90x900_device_ts = {
-	.name		= "w90x900-ts",
-	.id		= -1,
-	.resource	= w90x900_ts_resource,
-	.num_resources	= ARRAY_SIZE(w90x900_ts_resource),
-};
-EXPORT_SYMBOL(w90x900_device_ts);
-
-/* RTC controller*/
-
-static struct resource w90x900_rtc_resource[] = {
-	[0] = {
-		.start = W90X900_PA_RTC,
-		.end   = W90X900_PA_RTC + 0xff,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_RTC,
-		.end   = IRQ_RTC,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-struct platform_device w90x900_device_rtc = {
-	.name		= "w90x900-rtc",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(w90x900_rtc_resource),
-	.resource	= w90x900_rtc_resource,
-};
-EXPORT_SYMBOL(w90x900_device_rtc);
-
-/* KPI controller*/
-
-static struct resource w90x900_kpi_resource[] = {
-	[0] = {
-		.start = W90X900_PA_KPI,
-		.end   = W90X900_PA_KPI + W90X900_SZ_KPI - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_KPI,
-		.end   = IRQ_KPI,
-		.flags = IORESOURCE_IRQ,
-	}
-
-};
-
-struct platform_device w90x900_device_kpi = {
-	.name		= "w90x900-kpi",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(w90x900_kpi_resource),
-	.resource	= w90x900_kpi_resource,
-};
-EXPORT_SYMBOL(w90x900_device_kpi);
-
-/* USB Device (Gadget)*/
-
-static struct resource w90x900_usbgadget_resource[] = {
-	[0] = {
-		.start = W90X900_PA_USBDEV,
-		.end   = W90X900_PA_USBDEV + W90X900_SZ_USBDEV - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_USBD,
-		.end   = IRQ_USBD,
-		.flags = IORESOURCE_IRQ,
-	}
-};
-
-struct platform_device w90x900_device_usbgadget = {
-	.name		= "w90x900-usbgadget",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(w90x900_usbgadget_resource),
-	.resource	= w90x900_usbgadget_resource,
-};
-EXPORT_SYMBOL(w90x900_device_usbgadget);
-
-/* FMI Device */
-
-static struct resource w90p910_fmi_resource[] = {
-	[0] = {
-		.start = W90X900_PA_FMI,
-		.end   = W90X900_PA_FMI + W90X900_SZ_FMI - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_FMI,
-		.end   = IRQ_FMI,
-		.flags = IORESOURCE_IRQ,
-	}
-};
-
-static struct platform_device w90p910_device_fmi = {
-	.name		= "w90p910-fmi",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(w90p910_fmi_resource),
-	.resource	= w90p910_fmi_resource,
-};
-
-/* MAC device */
-
-static struct resource w90x900_emc_resource[] = {
-	[0] = {
-		.start = W90X900_PA_EMC,
-		.end   = W90X900_PA_EMC + W90X900_SZ_EMC - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_EMCTX,
-		.end   = IRQ_EMCTX,
-		.flags = IORESOURCE_IRQ,
-	},
-	[2] = {
-		.start = IRQ_EMCRX,
-		.end   = IRQ_EMCRX,
-		.flags = IORESOURCE_IRQ,
-	}
-};
-
-static u64 w90x900_device_emc_dmamask = 0xffffffffUL;
-static struct platform_device w90p910_device_emc = {
-	.name		= "w90p910-emc",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(w90x900_emc_resource),
-	.resource	= w90x900_emc_resource,
-	.dev              = {
-		.dma_mask = &w90x900_device_emc_dmamask,
-		.coherent_dma_mask = 0xffffffffUL
-	}
-};
-
-/* SPI device */
-
-static struct resource w90p910_spi_resource[] = {
-	[0] = {
-		.start = W90X900_PA_I2C + SPIOFFSET,
-		.end   = W90X900_PA_I2C + SPIOFFSET + SPIOREG_SIZE - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_SSP,
-		.end   = IRQ_SSP,
-		.flags = IORESOURCE_IRQ,
-	}
-};
-
-static struct platform_device w90p910_device_spi = {
-	.name		= "w90p910-spi",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(w90p910_spi_resource),
-	.resource	= w90p910_spi_resource,
-};
-
-/* spi device, spi flash info */
-
-static struct mtd_partition w90p910_spi_flash_partitions[] = {
-	{
-		.name = "bootloader(spi)",
-		.size = 0x0100000,
-		.offset = 0,
-	},
-};
-
-static struct flash_platform_data w90p910_spi_flash_data = {
-	.name = "m25p80",
-	.parts =  w90p910_spi_flash_partitions,
-	.nr_parts = ARRAY_SIZE(w90p910_spi_flash_partitions),
-	.type = "w25x16",
-};
-
-static struct spi_board_info w90p910_spi_board_info[] __initdata = {
-	{
-		.modalias = "m25p80",
-		.max_speed_hz = 20000000,
-		.bus_num = 0,
-		.chip_select = 1,
-		.platform_data = &w90p910_spi_flash_data,
-		.mode = SPI_MODE_0,
-	},
-};
-
-/* WDT Device */
-
-static struct resource w90p910_wdt_resource[] = {
-	[0] = {
-		.start = W90X900_PA_TIMER,
-		.end   = W90X900_PA_TIMER + W90X900_SZ_TIMER - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_WDT,
-		.end   = IRQ_WDT,
-		.flags = IORESOURCE_IRQ,
-	}
-};
-
-static struct platform_device w90p910_device_wdt = {
-	.name		= "w90p910-wdt",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(w90p910_wdt_resource),
-	.resource	= w90p910_wdt_resource,
-};
-
-static struct map_desc w90p910_iodesc[] __initdata = {
-};
-
-/*Here should be your evb resourse,such as LCD*/
-
-static struct platform_device *w90p910evb_dev[] __initdata = {
-	&w90p910_serial_device,
-	&w90p910_flash_device,
-	&w90x900_device_usb_ehci,
-	&w90x900_device_usb_ohci,
-	&w90x900_device_ts,
-	&w90x900_device_rtc,
-	&w90x900_device_kpi,
-	&w90x900_device_usbgadget,
-	&w90p910_device_fmi,
-	&w90p910_device_emc,
-	&w90p910_device_spi,
-	&w90p910_device_wdt,
-};
+#include "nuc910.h"
 
 static void __init w90p910evb_map_io(void)
 {
-	w90p910_map_io(w90p910_iodesc, ARRAY_SIZE(w90p910_iodesc));
-	w90p910_init_clocks();
+	nuc910_map_io();
+	nuc910_init_clocks();
 }
 
 static void __init w90p910evb_init(void)
 {
-	platform_add_devices(w90p910evb_dev, ARRAY_SIZE(w90p910evb_dev));
-	spi_register_board_info(w90p910_spi_board_info,
-					ARRAY_SIZE(w90p910_spi_board_info));
+	nuc910_board_init();
 }
 
 MACHINE_START(W90P910EVB, "W90P910EVB")
-- 
1.5.6.3

