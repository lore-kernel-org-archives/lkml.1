Return-Path: <linux-kernel-owner+w=401wt.eu-S1761719AbYEHIEC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761719AbYEHIEC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:04:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYEHIDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:03:44 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:40227 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbYEHIDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:03:42 -0400
Date: Thu, 8 May 2008 10:03:39 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] Alchemy: register mmc platform device for
	db1200/pb1200 boards
Message-ID: <20080508080339.GE24383@roarinelk.homelinux.net>
References: <20080508080040.GA24383@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508080040.GA24383@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a2ecbdb747a53792dd90c83d48235ae2fddfb95e Mon Sep 17 00:00:00 2001
From: Manuel Lauss <mlau@msc-ge.com>
Date: Wed, 7 May 2008 14:59:45 +0200
Subject: [PATCH] Alchemy: register mmc platform device for db1200/pb1200 boards

register the mmc platform device for db1200/pb1200 boards, with
board-specific card detect/readonly facilities wrapped in platform data.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 arch/mips/au1000/common/platform.c |   32 ---------
 arch/mips/au1000/pb1200/platform.c |  128 +++++++++++++++++++++++++++++++++++-
 2 files changed, 127 insertions(+), 33 deletions(-)

diff --git a/arch/mips/au1000/common/platform.c b/arch/mips/au1000/common/platform.c
index 31d2a22..08a5900 100644
--- a/arch/mips/au1000/common/platform.c
+++ b/arch/mips/au1000/common/platform.c
@@ -162,24 +162,6 @@ static struct resource au1xxx_usb_gdt_resources[] = {
 	},
 };
 
-static struct resource au1xxx_mmc_resources[] = {
-	[0] = {
-		.start          = SD0_PHYS_ADDR,
-		.end            = SD0_PHYS_ADDR + 0x40,
-		.flags          = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start		= SD1_PHYS_ADDR,
-		.end 		= SD1_PHYS_ADDR + 0x40,
-		.flags		= IORESOURCE_MEM,
-	},
-	[2] = {
-		.start          = AU1200_SD_INT,
-		.end            = AU1200_SD_INT,
-		.flags          = IORESOURCE_IRQ,
-	}
-};
-
 static u64 udc_dmamask = ~(u32)0;
 
 static struct platform_device au1xxx_usb_gdt_device = {
@@ -245,19 +227,6 @@ static struct platform_device au1200_lcd_device = {
 	.num_resources  = ARRAY_SIZE(au1200_lcd_resources),
 	.resource       = au1200_lcd_resources,
 };
-
-static u64 au1xxx_mmc_dmamask =  ~(u32)0;
-
-static struct platform_device au1xxx_mmc_device = {
-	.name = "au1xxx-mmc",
-	.id = 0,
-	.dev = {
-		.dma_mask               = &au1xxx_mmc_dmamask,
-		.coherent_dma_mask      = 0xffffffff,
-	},
-	.num_resources  = ARRAY_SIZE(au1xxx_mmc_resources),
-	.resource       = au1xxx_mmc_resources,
-};
 #endif /* #ifdef CONFIG_SOC_AU1200 */
 
 static struct platform_device au1x00_pcmcia_device = {
@@ -295,7 +264,6 @@ static struct platform_device *au1xxx_platform_devices[] __initdata = {
 	&au1xxx_usb_gdt_device,
 	&au1xxx_usb_otg_device,
 	&au1200_lcd_device,
-	&au1xxx_mmc_device,
 #endif
 #ifdef SMBUS_PSC_BASE
 	&pbdb_smbus_device,
diff --git a/arch/mips/au1000/pb1200/platform.c b/arch/mips/au1000/pb1200/platform.c
index 5930110..c87c173 100644
--- a/arch/mips/au1000/pb1200/platform.c
+++ b/arch/mips/au1000/pb1200/platform.c
@@ -20,8 +20,17 @@
 
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/mmc/host.h>
 
 #include <asm/mach-au1x00/au1xxx.h>
+#include <asm/mach-au1x00/au1xxx_dbdma.h>
+#include <asm/mach-au1x00/au1100_mmc.h>
+
+#if defined(CONFIG_MIPS_PB1200)
+#include <asm/mach-pb1x00/pb1200.h>
+#elif defined(CONFIG_MIPS_DB1200)
+#include <asm/mach-db1x00/db1200.h>
+#endif
 
 static struct resource ide_resources[] = {
 	[0] = {
@@ -70,9 +79,126 @@ static struct platform_device smc91c111_device = {
 	.resource	= smc91c111_resources
 };
 
+
+static const struct {
+	u16 bcsrpwr;
+	u16 bcsrstatus;
+	u16 wpstatus;
+} au1xmmc_card_table[] = {
+	{ BCSR_BOARD_SD0PWR, BCSR_INT_SD0INSERT, BCSR_STATUS_SD0WP },
+#ifndef CONFIG_MIPS_DB1200
+	{ BCSR_BOARD_SD1PWR, BCSR_INT_SD1INSERT, BCSR_STATUS_SD1WP }
+#endif
+};
+
+static void pb1200mmc_set_power(void *mmc_host, int state)
+{
+	struct au1xmmc_host *host = mmc_priv((struct mmc_host *)mmc_host);
+	u32 val = au1xmmc_card_table[host->id].bcsrpwr;
+
+	if (state)
+		bcsr->board |= val;
+	else
+		bcsr->board &= ~val;
+
+	au_sync_delay(1);
+}
+
+static int pb1200mmc_card_readonly(void *mmc_host)
+{
+	struct au1xmmc_host *host = mmc_priv((struct mmc_host *)mmc_host);
+	return (bcsr->status & au1xmmc_card_table[host->id].wpstatus) ? 1 : 0;
+}
+
+static int pb1200mmc_card_inserted(void *mmc_host)
+{
+	struct au1xmmc_host *host = mmc_priv((struct mmc_host *)mmc_host);
+	return (bcsr->sig_status & au1xmmc_card_table[host->id].bcsrstatus)
+		? 1 : 0;
+}
+
+static struct au1xmmc_platdata db1xmmcpd = {
+	.set_power	= pb1200mmc_set_power,
+	.card_inserted	= pb1200mmc_card_inserted,
+	.card_readonly	= pb1200mmc_card_readonly,
+	.cd_setup	= NULL,		/* use poll-timer in driver */
+};
+
+static u64 au1xxx_mmc_dmamask =  ~(u32)0;
+
+struct resource au1200_sd0_res[] = {
+	[0] = {
+		.start	= CPHYSADDR(SD0_BASE),
+		.end	= CPHYSADDR(SD0_BASE) + 0x40,
+		.flags	= IORESOURCE_MEM,
+	},
+	[2] = {
+		.start	= AU1200_SD_INT,
+		.flags	= IORESOURCE_IRQ,
+	},
+	[3] = {
+		.start	= DSCR_CMD0_SDMS_TX0,
+		.flags	= IORESOURCE_DMA,
+	},
+	[4] = {
+		.start	= DSCR_CMD0_SDMS_RX0,
+		.flags	= IORESOURCE_DMA,
+	},
+};
+
+static struct platform_device au1xxx_sd0_device = {
+	.name = "au1xxx-mmc",
+	.id = 0,	/* index into au1xmmc_card_table[] */
+	.dev = {
+		.dma_mask               = &au1xxx_mmc_dmamask,
+		.coherent_dma_mask      = 0xffffffff,
+		.platform_data		= &db1xmmcpd,
+	},
+	.num_resources  = ARRAY_SIZE(au1200_sd0_res),
+	.resource       = au1200_sd0_res,
+};
+
+#ifndef CONFIG_MIPS_DB1200
+struct resource au1200_sd1_res[] = {
+	[0] = {
+		.start	= CPHYSADDR(SD1_BASE),
+		.end	= CPHYSADDR(SD1_BASE) + 0x40,
+		.flags	= IORESOURCE_MEM,
+	},
+	[2] = {
+		.start	= AU1200_SD_INT,
+		.flags	= IORESOURCE_IRQ,
+	},
+	[3] = {
+		.start	= DSCR_CMD0_SDMS_TX1,
+		.flags	= IORESOURCE_DMA,
+	},
+	[4] = {
+		.start	= DSCR_CMD0_SDMS_RX1,
+		.flags	= IORESOURCE_DMA,
+	},
+};
+
+static struct platform_device au1xxx_sd1_device = {
+	.name = "au1xxx-mmc",
+	.id = 1,	/* index into au1xmmc_card_table[] */
+	.dev = {
+		.dma_mask               = &au1xxx_mmc_dmamask,
+		.coherent_dma_mask      = 0xffffffff,
+		.platform_data		= &db1xmmcpd,
+	},
+	.num_resources  = ARRAY_SIZE(au1200_sd1_res),
+	.resource       = au1200_sd1_res,
+};
+#endif
+
 static struct platform_device *board_platform_devices[] __initdata = {
 	&ide_device,
-	&smc91c111_device
+	&smc91c111_device,
+	&au1xxx_sd0_device,
+#ifndef CONFIG_MIPS_DB1200
+	&au1xxx_sd1_device,
+#endif
 };
 
 static int __init board_register_devices(void)
-- 
1.5.5.1

