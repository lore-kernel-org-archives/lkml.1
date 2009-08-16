Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbZHPJYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbZHPJYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbZHPJYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:24:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:30344 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbZHPJYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:24:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=PpIMiheRDTzWYaZgKxq8QZ1gDaoa5pk5bhzHHTL3mru9cb35nNM5xG//huXl+ht1xT
         U8RcgRIxJ4ZFsx34o06cxu0HRSbrw5tkEsxNFzyMrPHpiRx4CpMZWGiB12sWFAG1qjKC
         wlnW9IrPd5z8YdM5cG+TYTZ2LXPdZHD/NuwUg=
Message-ID: <4A87D049.2010605@gmail.com>
Date: Sun, 16 Aug 2009 17:24:25 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 1/2] ARM: Adjust the public device definition for w90x900
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

In fact, this patch follows previous nine patches series,
I adjust the position of platform device definition, if the
device is public between any two CPUs, I locate them in dev.c
rather than specific CPU file.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/cpu.h     |    7 ++
 arch/arm/mach-w90x900/dev.c     |  149 ++++++++++++++++++++++++++-------------
 arch/arm/mach-w90x900/nuc950.c  |    2 +
 arch/arm/mach-w90x900/w90p910.c |   48 +------------
 4 files changed, 111 insertions(+), 95 deletions(-)

diff --git a/arch/arm/mach-w90x900/cpu.h b/arch/arm/mach-w90x900/cpu.h
index 8b0520a..683c879 100644
--- a/arch/arm/mach-w90x900/cpu.h
+++ b/arch/arm/mach-w90x900/cpu.h
@@ -49,4 +49,11 @@ extern void nuc900_clock_source(struct device *dev, unsigned char *src);
 extern void nuc900_init_clocks(void);
 extern void nuc900_map_io(struct map_desc *mach_desc, int mach_size);
 extern void nuc900_board_init(struct platform_device **device, int size);
+
+/* for either public between 910 and 920, or between 920 and 950 */
+
 extern struct platform_device nuc900_serial_device;
+extern struct platform_device nuc900_device_fmi;
+extern struct platform_device nuc900_device_kpi;
+extern struct platform_device nuc900_device_rtc;
+extern struct platform_device nuc900_device_ts;
diff --git a/arch/arm/mach-w90x900/dev.c b/arch/arm/mach-w90x900/dev.c
index 76bc7fd..2a6f98d 100644
--- a/arch/arm/mach-w90x900/dev.c
+++ b/arch/arm/mach-w90x900/dev.c
@@ -140,29 +140,6 @@ static struct platform_device nuc900_device_usb_ohci = {
 	}
 };
 
-/* KPI controller*/
-
-static struct resource nuc900_kpi_resource[] = {
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
-static struct platform_device nuc900_device_kpi = {
-	.name		= "nuc900-kpi",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(nuc900_kpi_resource),
-	.resource	= nuc900_kpi_resource,
-};
-
 /* USB Device (Gadget)*/
 
 static struct resource nuc900_usbgadget_resource[] = {
@@ -185,28 +162,6 @@ static struct platform_device nuc900_device_usbgadget = {
 	.resource	= nuc900_usbgadget_resource,
 };
 
-/* FMI Device */
-
-static struct resource nuc900_fmi_resource[] = {
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
-static struct platform_device nuc900_device_fmi = {
-	.name		= "nuc900-fmi",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(nuc900_fmi_resource),
-	.resource	= nuc900_fmi_resource,
-};
-
 /* MAC device */
 
 static struct resource nuc900_emc_resource[] = {
@@ -311,16 +266,112 @@ static struct platform_device nuc900_device_wdt = {
 	.resource	= nuc900_wdt_resource,
 };
 
+/*
+ * public device definition between 910 and 920, or 910
+ * and 950 or 950 and 960...,their dev platform register
+ * should be in specific file such as nuc950, nuc960 c
+ * files rather than the public dev.c file here. so the
+ * corresponding platform_device definition should not be
+ * static.
+*/
+
+/* RTC controller*/
+
+static struct resource nuc900_rtc_resource[] = {
+	[0] = {
+		.start = W90X900_PA_RTC,
+		.end   = W90X900_PA_RTC + 0xff,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_RTC,
+		.end   = IRQ_RTC,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device nuc900_device_rtc = {
+	.name		= "nuc900-rtc",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(nuc900_rtc_resource),
+	.resource	= nuc900_rtc_resource,
+};
+
+/*TouchScreen controller*/
+
+static struct resource nuc900_ts_resource[] = {
+	[0] = {
+		.start = W90X900_PA_ADC,
+		.end   = W90X900_PA_ADC + W90X900_SZ_ADC-1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_ADC,
+		.end   = IRQ_ADC,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device nuc900_device_ts = {
+	.name		= "nuc900-ts",
+	.id		= -1,
+	.resource	= nuc900_ts_resource,
+	.num_resources	= ARRAY_SIZE(nuc900_ts_resource),
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
+struct platform_device nuc900_device_fmi = {
+	.name		= "nuc900-fmi",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(nuc900_fmi_resource),
+	.resource	= nuc900_fmi_resource,
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
+struct platform_device nuc900_device_kpi = {
+	.name		= "nuc900-kpi",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(nuc900_kpi_resource),
+	.resource	= nuc900_kpi_resource,
+};
+
 /*Here should be your evb resourse,such as LCD*/
 
-static struct platform_device *nuc900_dev[] __initdata = {
+static struct platform_device *nuc900_public_dev[] __initdata = {
 	&nuc900_serial_device,
 	&nuc900_flash_device,
 	&nuc900_device_usb_ehci,
 	&nuc900_device_usb_ohci,
-	&nuc900_device_kpi,
 	&nuc900_device_usbgadget,
-	&nuc900_device_fmi,
 	&nuc900_device_emc,
 	&nuc900_device_spi,
 	&nuc900_device_wdt,
@@ -331,7 +382,7 @@ static struct platform_device *nuc900_dev[] __initdata = {
 void __init nuc900_board_init(struct platform_device **device, int size)
 {
 	platform_add_devices(device, size);
-	platform_add_devices(nuc900_dev, ARRAY_SIZE(nuc900_dev));
+	platform_add_devices(nuc900_public_dev, ARRAY_SIZE(nuc900_public_dev));
 	spi_register_board_info(nuc900_spi_board_info,
 					ARRAY_SIZE(nuc900_spi_board_info));
 }
diff --git a/arch/arm/mach-w90x900/nuc950.c b/arch/arm/mach-w90x900/nuc950.c
index 60363db..4c94a29 100644
--- a/arch/arm/mach-w90x900/nuc950.c
+++ b/arch/arm/mach-w90x900/nuc950.c
@@ -41,6 +41,8 @@
 /* define specific CPU platform device */
 
 static struct platform_device *nuc950_dev[] __initdata = {
+	&nuc900_device_kpi,
+	&nuc900_device_fmi,
 };
 
 /* define specific CPU platform io map */
diff --git a/arch/arm/mach-w90x900/w90p910.c b/arch/arm/mach-w90x900/w90p910.c
index fc94af1..3f4fe3b 100644
--- a/arch/arm/mach-w90x900/w90p910.c
+++ b/arch/arm/mach-w90x900/w90p910.c
@@ -39,55 +39,11 @@
 #include "cpu.h"
 #include "clock.h"
 
-/* RTC controller*/
-
-static struct resource nuc910_rtc_resource[] = {
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
-static struct platform_device nuc910_device_rtc = {
-	.name		= "nuc910-rtc",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(nuc910_rtc_resource),
-	.resource	= nuc910_rtc_resource,
-};
-
-/*TouchScreen controller*/
-
-static struct resource nuc910_ts_resource[] = {
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
-static struct platform_device nuc910_device_ts = {
-	.name		= "nuc910-ts",
-	.id		= -1,
-	.resource	= nuc910_ts_resource,
-	.num_resources	= ARRAY_SIZE(nuc910_ts_resource),
-};
-
 /* define specific CPU platform device */
 
 static struct platform_device *nuc910_dev[] __initdata = {
-	&nuc910_device_ts,
-	&nuc910_device_rtc,
+	&nuc900_device_ts,
+	&nuc900_device_rtc,
 };
 
 /* define specific CPU platform io map */
-- 
1.5.6.3
