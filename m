Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbZHOLeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbZHOLeY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 07:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbZHOLeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 07:34:24 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:61856 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbZHOLeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 07:34:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=a+H8Hdl4oYkuqliWyrwK0QWkWxQ0YhOyrD3BuxHp6/L42zcWYEpOkxRStpBRTUo462
         7gDvnxaxN3LEkuX3ZgYq0TuXoAim/HvLxOoC/OKoPbGLyhu4kLdtDfa4WZTjJVIFcqcS
         RW7I3vUOShznZhDtu0/Xf/DNSOn27/TWM8vRQ=
Message-ID: <4A869D39.1030308@gmail.com>
Date: Sat, 15 Aug 2009 19:34:17 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 4/9] ARM: Add common file of platform define and cpu.
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear sir,

To add 'dev.c' which was used to define the common platform device struct.
To add the 'cpu.c' file for implementing the common CPU function API.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/cpu.c |  208 ++++++++++++++++++++++++++
 arch/arm/mach-w90x900/cpu.h |   41 ++---
 arch/arm/mach-w90x900/dev.c |  338 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 563 insertions(+), 24 deletions(-)
 create mode 100644 arch/arm/mach-w90x900/cpu.c
 create mode 100644 arch/arm/mach-w90x900/dev.c

diff --git a/arch/arm/mach-w90x900/cpu.c b/arch/arm/mach-w90x900/cpu.c
new file mode 100644
index 0000000..03ce462
--- /dev/null
+++ b/arch/arm/mach-w90x900/cpu.c
@@ -0,0 +1,208 @@
+/*
+ * linux/arch/arm/mach-w90x900/cpu.c
+ *
+ * Copyright (c) 2009 Nuvoton corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * NUC900 series cpu common support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/timer.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/serial_8250.h>
+#include <linux/delay.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+#include <asm/irq.h>
+
+#include <mach/hardware.h>
+#include <mach/regs-serial.h>
+#include <mach/regs-clock.h>
+#include <mach/regs-ebi.h>
+
+#include "cpu.h"
+#include "clock.h"
+
+/* Initial IO mappings */
+
+static struct map_desc nuc900_iodesc[] __initdata = {
+	IODESC_ENT(IRQ),
+	IODESC_ENT(GCR),
+	IODESC_ENT(UART),
+	IODESC_ENT(TIMER),
+	IODESC_ENT(EBI),
+};
+
+/* Initial clock declarations. */
+static DEFINE_CLK(lcd, 0);
+static DEFINE_CLK(audio, 1);
+static DEFINE_CLK(fmi, 4);
+static DEFINE_SUBCLK(ms, 0);
+static DEFINE_SUBCLK(sd, 1);
+static DEFINE_CLK(dmac, 5);
+static DEFINE_CLK(atapi, 6);
+static DEFINE_CLK(emc, 7);
+static DEFINE_SUBCLK(rmii, 2);
+static DEFINE_CLK(usbd, 8);
+static DEFINE_CLK(usbh, 9);
+static DEFINE_CLK(g2d, 10);;
+static DEFINE_CLK(pwm, 18);
+static DEFINE_CLK(ps2, 24);
+static DEFINE_CLK(kpi, 25);
+static DEFINE_CLK(wdt, 26);
+static DEFINE_CLK(gdma, 27);
+static DEFINE_CLK(adc, 28);
+static DEFINE_CLK(usi, 29);
+static DEFINE_CLK(ext, 0);
+
+static struct clk_lookup nuc900_clkregs[] = {
+	DEF_CLKLOOK(&clk_lcd, "nuc900-lcd", NULL),
+	DEF_CLKLOOK(&clk_audio, "nuc900-audio", NULL),
+	DEF_CLKLOOK(&clk_fmi, "nuc900-fmi", NULL),
+	DEF_CLKLOOK(&clk_ms, "nuc900-fmi", "MS"),
+	DEF_CLKLOOK(&clk_sd, "nuc900-fmi", "SD"),
+	DEF_CLKLOOK(&clk_dmac, "nuc900-dmac", NULL),
+	DEF_CLKLOOK(&clk_atapi, "nuc900-atapi", NULL),
+	DEF_CLKLOOK(&clk_emc, "nuc900-emc", NULL),
+	DEF_CLKLOOK(&clk_rmii, "nuc900-emc", "RMII"),
+	DEF_CLKLOOK(&clk_usbd, "nuc900-usbd", NULL),
+	DEF_CLKLOOK(&clk_usbh, "nuc900-usbh", NULL),
+	DEF_CLKLOOK(&clk_g2d, "nuc900-g2d", NULL),
+	DEF_CLKLOOK(&clk_pwm, "nuc900-pwm", NULL),
+	DEF_CLKLOOK(&clk_ps2, "nuc900-ps2", NULL),
+	DEF_CLKLOOK(&clk_kpi, "nuc900-kpi", NULL),
+	DEF_CLKLOOK(&clk_wdt, "nuc900-wdt", NULL),
+	DEF_CLKLOOK(&clk_gdma, "nuc900-gdma", NULL),
+	DEF_CLKLOOK(&clk_adc, "nuc900-adc", NULL),
+	DEF_CLKLOOK(&clk_usi, "nuc900-spi", NULL),
+	DEF_CLKLOOK(&clk_ext, NULL, "ext"),
+};
+
+/* Initial serial platform data */
+
+struct plat_serial8250_port nuc900_uart_data[] = {
+	NUC900_8250PORT(UART0),
+};
+
+struct platform_device nuc900_serial_device = {
+	.name			= "serial8250",
+	.id			= PLAT8250_DEV_PLATFORM,
+	.dev			= {
+		.platform_data	= nuc900_uart_data,
+	},
+};
+
+/*Set NUC900 series cpu frequence*/
+static int __init nuc900_set_clkval(unsigned int cpufreq)
+{
+	unsigned int pllclk, ahbclk, apbclk, val;
+
+	pllclk = 0;
+	ahbclk = 0;
+	apbclk = 0;
+
+	switch (cpufreq) {
+	case 66:
+		pllclk = PLL_66MHZ;
+		ahbclk = AHB_CPUCLK_1_1;
+		apbclk = APB_AHB_1_2;
+		break;
+
+	case 100:
+		pllclk = PLL_100MHZ;
+		ahbclk = AHB_CPUCLK_1_1;
+		apbclk = APB_AHB_1_2;
+		break;
+
+	case 120:
+		pllclk = PLL_120MHZ;
+		ahbclk = AHB_CPUCLK_1_2;
+		apbclk = APB_AHB_1_2;
+		break;
+
+	case 166:
+		pllclk = PLL_166MHZ;
+		ahbclk = AHB_CPUCLK_1_2;
+		apbclk = APB_AHB_1_2;
+		break;
+
+	case 200:
+		pllclk = PLL_200MHZ;
+		ahbclk = AHB_CPUCLK_1_2;
+		apbclk = APB_AHB_1_2;
+		break;
+	}
+
+	__raw_writel(pllclk, REG_PLLCON0);
+
+	val = __raw_readl(REG_CLKDIV);
+	val &= ~(0x03 << 24 | 0x03 << 26);
+	val |= (ahbclk << 24 | apbclk << 26);
+	__raw_writel(val, REG_CLKDIV);
+
+	return 	0;
+}
+static int __init nuc900_set_cpufreq(char *str)
+{
+	unsigned long cpufreq, val;
+
+	if (!*str)
+		return 0;
+
+	strict_strtoul(str, 0, &cpufreq);
+
+	nuc900_clock_source(NULL, "ext");
+
+	nuc900_set_clkval(cpufreq);
+
+	mdelay(1);
+
+	val = __raw_readl(REG_CKSKEW);
+	val &= ~0xff;
+	val |= DEFAULTSKEW;
+	__raw_writel(val, REG_CKSKEW);
+
+	nuc900_clock_source(NULL, "pll0");
+
+	return 1;
+}
+
+__setup("cpufreq=", nuc900_set_cpufreq);
+
+/*Init NUC950 evb io*/
+
+void __init nuc900_map_io(struct map_desc *mach_desc, int mach_size)
+{
+	unsigned long idcode = 0x0;
+
+	iotable_init(mach_desc, mach_size);
+	iotable_init(nuc900_iodesc, ARRAY_SIZE(nuc900_iodesc));
+
+	idcode = __raw_readl(NUC900PDID);
+	if (idcode == NUC950_CPUID)
+		printk(KERN_INFO "CPU type 0x%08lx is NUC950\n", idcode);
+	else if (idcode == NUC910_CPUID)
+		printk(KERN_INFO "CPU type 0x%08lx is NUC910\n", idcode);
+}
+
+/*Init NUC900 clock*/
+
+void __init nuc900_init_clocks(void)
+{
+	clks_register(nuc900_clkregs, ARRAY_SIZE(nuc900_clkregs));
+}
+
diff --git a/arch/arm/mach-w90x900/cpu.h b/arch/arm/mach-w90x900/cpu.h
index ddde959..8b0520a 100644
--- a/arch/arm/mach-w90x900/cpu.h
+++ b/arch/arm/mach-w90x900/cpu.h
@@ -24,30 +24,7 @@
        .type    = MT_DEVICE,                           \
 }
 
-/*Cpu identifier register*/
-
-#define W90X900PDID	W90X900_VA_GCR
-#define W90P910_CPUID	0x02900910
-#define W90P920_CPUID	0x02900920
-#define W90P950_CPUID	0x02900950
-#define W90N960_CPUID	0x02900960
-
-struct w90x900_uartcfg;
-struct map_desc;
-struct sys_timer;
-
-/* core initialisation functions */
-
-extern void w90x900_init_irq(void);
-extern void w90p910_init_io(struct map_desc *mach_desc, int size);
-extern void w90p910_init_uarts(struct w90x900_uartcfg *cfg, int no);
-extern void w90p910_init_clocks(void);
-extern void w90p910_map_io(struct map_desc *mach_desc, int size);
-extern struct platform_device w90p910_serial_device;
-extern struct sys_timer w90x900_timer;
-extern void w90p910_clock_source(struct device *dev, unsigned char *src);
-
-#define W90X900_8250PORT(name)					\
+#define NUC900_8250PORT(name)					\
 {								\
 	.membase	= name##_BA,				\
 	.mapbase	= name##_PA,				\
@@ -57,3 +34,19 @@ extern void w90p910_clock_source(struct device *dev, unsigned char *src);
 	.iotype		= UPIO_MEM,				\
 	.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,	\
 }
+
+/*Cpu identifier register*/
+
+#define NUC900PDID	W90X900_VA_GCR
+#define NUC910_CPUID	0x02900910
+#define NUC920_CPUID	0x02900920
+#define NUC950_CPUID	0x02900950
+#define NUC960_CPUID	0x02900960
+
+/* extern file from cpu.c */
+
+extern void nuc900_clock_source(struct device *dev, unsigned char *src);
+extern void nuc900_init_clocks(void);
+extern void nuc900_map_io(struct map_desc *mach_desc, int mach_size);
+extern void nuc900_board_init(struct platform_device **device, int size);
+extern struct platform_device nuc900_serial_device;
diff --git a/arch/arm/mach-w90x900/dev.c b/arch/arm/mach-w90x900/dev.c
new file mode 100644
index 0000000..76bc7fd
--- /dev/null
+++ b/arch/arm/mach-w90x900/dev.c
@@ -0,0 +1,338 @@
+/*
+ * linux/arch/arm/mach-w90x900/dev.c
+ *
+ * Copyright (C) 2009 Nuvoton corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/timer.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+
+#include <linux/mtd/physmap.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+
+#include <linux/spi/spi.h>
+#include <linux/spi/flash.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+#include <asm/mach-types.h>
+
+#include <mach/regs-serial.h>
+#include <mach/map.h>
+
+#include "cpu.h"
+
+/*NUC900 evb norflash driver data */
+
+#define NUC900_FLASH_BASE	0xA0000000
+#define NUC900_FLASH_SIZE	0x400000
+#define SPIOFFSET		0x200
+#define SPIOREG_SIZE		0x100
+
+static struct mtd_partition nuc900_flash_partitions[] = {
+	{
+		.name	=	"NOR Partition 1 for kernel (960K)",
+		.size	=	0xF0000,
+		.offset	=	0x10000,
+	},
+	{
+		.name	=	"NOR Partition 2 for image (1M)",
+		.size	=	0x100000,
+		.offset	=	0x100000,
+	},
+	{
+		.name	=	"NOR Partition 3 for user (2M)",
+		.size	=	0x200000,
+		.offset	=	0x00200000,
+	}
+};
+
+static struct physmap_flash_data nuc900_flash_data = {
+	.width		=	2,
+	.parts		=	nuc900_flash_partitions,
+	.nr_parts	=	ARRAY_SIZE(nuc900_flash_partitions),
+};
+
+static struct resource nuc900_flash_resources[] = {
+	{
+		.start	=	NUC900_FLASH_BASE,
+		.end	=	NUC900_FLASH_BASE + NUC900_FLASH_SIZE - 1,
+		.flags	=	IORESOURCE_MEM,
+	}
+};
+
+static struct platform_device nuc900_flash_device = {
+	.name		=	"physmap-flash",
+	.id		=	0,
+	.dev		= {
+				.platform_data = &nuc900_flash_data,
+			},
+	.resource	=	nuc900_flash_resources,
+	.num_resources	=	ARRAY_SIZE(nuc900_flash_resources),
+};
+
+/* USB EHCI Host Controller */
+
+static struct resource nuc900_usb_ehci_resource[] = {
+	[0] = {
+		.start = W90X900_PA_USBEHCIHOST,
+		.end   = W90X900_PA_USBEHCIHOST + W90X900_SZ_USBEHCIHOST - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_USBH,
+		.end   = IRQ_USBH,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static u64 nuc900_device_usb_ehci_dmamask = 0xffffffffUL;
+
+static struct platform_device nuc900_device_usb_ehci = {
+	.name		  = "nuc900-ehci",
+	.id		  = -1,
+	.num_resources	  = ARRAY_SIZE(nuc900_usb_ehci_resource),
+	.resource	  = nuc900_usb_ehci_resource,
+	.dev              = {
+		.dma_mask = &nuc900_device_usb_ehci_dmamask,
+		.coherent_dma_mask = 0xffffffffUL
+	}
+};
+
+/* USB OHCI Host Controller */
+
+static struct resource nuc900_usb_ohci_resource[] = {
+	[0] = {
+		.start = W90X900_PA_USBOHCIHOST,
+		.end   = W90X900_PA_USBOHCIHOST + W90X900_SZ_USBOHCIHOST - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_USBH,
+		.end   = IRQ_USBH,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static u64 nuc900_device_usb_ohci_dmamask = 0xffffffffUL;
+static struct platform_device nuc900_device_usb_ohci = {
+	.name		  = "nuc900-ohci",
+	.id		  = -1,
+	.num_resources	  = ARRAY_SIZE(nuc900_usb_ohci_resource),
+	.resource	  = nuc900_usb_ohci_resource,
+	.dev              = {
+		.dma_mask = &nuc900_device_usb_ohci_dmamask,
+		.coherent_dma_mask = 0xffffffffUL
+	}
+};
+
+/* KPI controller*/
+
+static struct resource nuc900_kpi_resource[] = {
+	[0] = {
+		.start = W90X900_PA_KPI,
+		.end   = W90X900_PA_KPI + W90X900_SZ_KPI - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_KPI,
+		.end   = IRQ_KPI,
+		.flags = IORESOURCE_IRQ,
+	}
+
+};
+
+static struct platform_device nuc900_device_kpi = {
+	.name		= "nuc900-kpi",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(nuc900_kpi_resource),
+	.resource	= nuc900_kpi_resource,
+};
+
+/* USB Device (Gadget)*/
+
+static struct resource nuc900_usbgadget_resource[] = {
+	[0] = {
+		.start = W90X900_PA_USBDEV,
+		.end   = W90X900_PA_USBDEV + W90X900_SZ_USBDEV - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_USBD,
+		.end   = IRQ_USBD,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device nuc900_device_usbgadget = {
+	.name		= "nuc900-usbgadget",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(nuc900_usbgadget_resource),
+	.resource	= nuc900_usbgadget_resource,
+};
+
+/* FMI Device */
+
+static struct resource nuc900_fmi_resource[] = {
+	[0] = {
+		.start = W90X900_PA_FMI,
+		.end   = W90X900_PA_FMI + W90X900_SZ_FMI - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_FMI,
+		.end   = IRQ_FMI,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device nuc900_device_fmi = {
+	.name		= "nuc900-fmi",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(nuc900_fmi_resource),
+	.resource	= nuc900_fmi_resource,
+};
+
+/* MAC device */
+
+static struct resource nuc900_emc_resource[] = {
+	[0] = {
+		.start = W90X900_PA_EMC,
+		.end   = W90X900_PA_EMC + W90X900_SZ_EMC - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_EMCTX,
+		.end   = IRQ_EMCTX,
+		.flags = IORESOURCE_IRQ,
+	},
+	[2] = {
+		.start = IRQ_EMCRX,
+		.end   = IRQ_EMCRX,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static u64 nuc900_device_emc_dmamask = 0xffffffffUL;
+static struct platform_device nuc900_device_emc = {
+	.name		= "nuc900-emc",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(nuc900_emc_resource),
+	.resource	= nuc900_emc_resource,
+	.dev              = {
+		.dma_mask = &nuc900_device_emc_dmamask,
+		.coherent_dma_mask = 0xffffffffUL
+	}
+};
+
+/* SPI device */
+
+static struct resource nuc900_spi_resource[] = {
+	[0] = {
+		.start = W90X900_PA_I2C + SPIOFFSET,
+		.end   = W90X900_PA_I2C + SPIOFFSET + SPIOREG_SIZE - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_SSP,
+		.end   = IRQ_SSP,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device nuc900_device_spi = {
+	.name		= "nuc900-spi",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(nuc900_spi_resource),
+	.resource	= nuc900_spi_resource,
+};
+
+/* spi device, spi flash info */
+
+static struct mtd_partition nuc900_spi_flash_partitions[] = {
+	{
+		.name = "bootloader(spi)",
+		.size = 0x0100000,
+		.offset = 0,
+	},
+};
+
+static struct flash_platform_data nuc900_spi_flash_data = {
+	.name = "m25p80",
+	.parts =  nuc900_spi_flash_partitions,
+	.nr_parts = ARRAY_SIZE(nuc900_spi_flash_partitions),
+	.type = "w25x16",
+};
+
+static struct spi_board_info nuc900_spi_board_info[] __initdata = {
+	{
+		.modalias = "m25p80",
+		.max_speed_hz = 20000000,
+		.bus_num = 0,
+		.chip_select = 1,
+		.platform_data = &nuc900_spi_flash_data,
+		.mode = SPI_MODE_0,
+	},
+};
+
+/* WDT Device */
+
+static struct resource nuc900_wdt_resource[] = {
+	[0] = {
+		.start = W90X900_PA_TIMER,
+		.end   = W90X900_PA_TIMER + W90X900_SZ_TIMER - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_WDT,
+		.end   = IRQ_WDT,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device nuc900_device_wdt = {
+	.name		= "nuc900-wdt",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(nuc900_wdt_resource),
+	.resource	= nuc900_wdt_resource,
+};
+
+/*Here should be your evb resourse,such as LCD*/
+
+static struct platform_device *nuc900_dev[] __initdata = {
+	&nuc900_serial_device,
+	&nuc900_flash_device,
+	&nuc900_device_usb_ehci,
+	&nuc900_device_usb_ohci,
+	&nuc900_device_kpi,
+	&nuc900_device_usbgadget,
+	&nuc900_device_fmi,
+	&nuc900_device_emc,
+	&nuc900_device_spi,
+	&nuc900_device_wdt,
+};
+
+/* Provide adding specific CPU platform devices API */
+
+void __init nuc900_board_init(struct platform_device **device, int size)
+{
+	platform_add_devices(device, size);
+	platform_add_devices(nuc900_dev, ARRAY_SIZE(nuc900_dev));
+	spi_register_board_info(nuc900_spi_board_info,
+					ARRAY_SIZE(nuc900_spi_board_info));
+}
+
-- 
1.5.6.3

