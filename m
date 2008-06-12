Return-Path: <linux-kernel-owner+w=401wt.eu-S1760209AbYFLMSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209AbYFLMSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbYFLMSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:18:32 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:39691 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbYFLMSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:18:31 -0400
Date: Thu, 12 Jun 2008 14:18:28 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, sshtylyov@ru.mvista.com, drzeus@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] Alchemy: register mmc platform device for
	db1200/pb1200 boards.
Message-ID: <20080612121828.GA24603@roarinelk.homelinux.net>
References: <20080609063521.GA8724@roarinelk.homelinux.net> <20080609063702.GC8724@roarinelk.homelinux.net> <20080612090206.GB21601@linux-mips.org> <20080612101839.GC21601@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612101839.GC21601@linux-mips.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf, Pierre,

On Thu, Jun 12, 2008 at 11:18:39AM +0100, Ralf Baechle wrote:
> On Thu, Jun 12, 2008 at 10:02:06AM +0100, Ralf Baechle wrote:
> 
> I cleaned the numerals for the DMA constants with below patch which now
> is in the 2.6.27 patch queue.

Here's a new version of [PATCH 2/8], against those changes.

---

From: Manuel Lauss <mano@roarinelk.homelinux.net>

Add au1xmmc platform data for PB1200/DB1200 boards, and wire up
the 2 SD controllers for them.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 arch/mips/au1000/common/platform.c |   98 +++++++++++++++++++++++++++---------
 arch/mips/au1000/pb1200/platform.c |   81 +++++++++++++++++++++++++++++
 2 files changed, 155 insertions(+), 24 deletions(-)

diff --git a/arch/mips/au1000/common/platform.c b/arch/mips/au1000/common/platform.c
index d01fe5f..5c76c64 100644
--- a/arch/mips/au1000/common/platform.c
+++ b/arch/mips/au1000/common/platform.c
@@ -17,6 +17,8 @@
 #include <linux/init.h>
 
 #include <asm/mach-au1x00/au1xxx.h>
+#include <asm/mach-au1x00/au1xxx_dbdma.h>
+#include <asm/mach-au1x00/au1100_mmc.h>
 
 #define PORT(_base, _irq)				\
 	{						\
@@ -163,24 +165,6 @@ static struct resource au1xxx_usb_gdt_resources[] = {
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
 static u64 udc_dmamask = DMA_32BIT_MASK;
 
 static struct platform_device au1xxx_usb_gdt_device = {
@@ -249,16 +233,79 @@ static struct platform_device au1200_lcd_device = {
 
 static u64 au1xxx_mmc_dmamask =  DMA_32BIT_MASK;
 
-static struct platform_device au1xxx_mmc_device = {
+extern struct au1xmmc_platform_data au1xmmc_platdata[2];
+
+static struct resource au1200_mmc0_resources[] = {
+	[0] = {
+		.start          = SD0_PHYS_ADDR,
+		.end            = SD0_PHYS_ADDR + 0x7ffff,
+		.flags          = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start		= AU1200_SD_INT,
+		.end		= AU1200_SD_INT,
+		.flags		= IORESOURCE_IRQ,
+	},
+	[2] = {
+		.start		= DSCR_CMD0_SDMS_TX0,
+		.end		= DSCR_CMD0_SDMS_TX0,
+		.flags		= IORESOURCE_DMA,
+	},
+	[3] = {
+		.start          = DSCR_CMD0_SDMS_RX0,
+		.end		= DSCR_CMD0_SDMS_RX0,
+		.flags          = IORESOURCE_DMA,
+	}
+};
+
+static struct platform_device au1200_mmc0_device = {
 	.name = "au1xxx-mmc",
 	.id = 0,
 	.dev = {
-		.dma_mask               = &au1xxx_mmc_dmamask,
-		.coherent_dma_mask      = DMA_32BIT_MASK,
+		.dma_mask		= &au1xxx_mmc_dmamask,
+		.coherent_dma_mask	= DMA_32BIT_MASK,
+		.platform_data		= &au1xmmc_platdata[0],
+	},
+	.num_resources	= ARRAY_SIZE(au1200_mmc0_resources),
+	.resource	= au1200_mmc0_resources,
+};
+
+#ifndef CONFIG_MIPS_DB1200
+static struct resource au1200_mmc1_resources[] = {
+	[0] = {
+		.start          = SD1_PHYS_ADDR,
+		.end            = SD1_PHYS_ADDR + 0x7ffff,
+		.flags          = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start		= AU1200_SD_INT,
+		.end		= AU1200_SD_INT,
+		.flags		= IORESOURCE_IRQ,
+	},
+	[2] = {
+		.start		= DSCR_CMD0_SDMS_TX1,
+		.end		= DSCR_CMD0_SDMS_TX1,
+		.flags		= IORESOURCE_DMA,
 	},
-	.num_resources  = ARRAY_SIZE(au1xxx_mmc_resources),
-	.resource       = au1xxx_mmc_resources,
+	[3] = {
+		.start          = DSCR_CMD0_SDMS_RX1,
+		.end		= DSCR_CMD0_SDMS_RX1,
+		.flags          = IORESOURCE_DMA,
+	}
 };
+
+static struct platform_device au1200_mmc1_device = {
+	.name = "au1xxx-mmc",
+	.id = 1,
+	.dev = {
+		.dma_mask		= &au1xxx_mmc_dmamask,
+		.coherent_dma_mask	= DMA_32BIT_MASK,
+		.platform_data		= &au1xmmc_platdata[1],
+	},
+	.num_resources	= ARRAY_SIZE(au1200_mmc1_resources),
+	.resource	= au1200_mmc1_resources,
+};
+#endif /* #ifndef CONFIG_MIPS_DB1200 */
 #endif /* #ifdef CONFIG_SOC_AU1200 */
 
 static struct platform_device au1x00_pcmcia_device = {
@@ -296,7 +343,10 @@ static struct platform_device *au1xxx_platform_devices[] __initdata = {
 	&au1xxx_usb_gdt_device,
 	&au1xxx_usb_otg_device,
 	&au1200_lcd_device,
-	&au1xxx_mmc_device,
+	&au1200_mmc0_device,
+#ifndef CONFIG_MIPS_DB1200
+	&au1200_mmc1_device,
+#endif
 #endif
 #ifdef SMBUS_PSC_BASE
 	&pbdb_smbus_device,
diff --git a/arch/mips/au1000/pb1200/platform.c b/arch/mips/au1000/pb1200/platform.c
index f8fb0ae..878b780 100644
--- a/arch/mips/au1000/pb1200/platform.c
+++ b/arch/mips/au1000/pb1200/platform.c
@@ -20,9 +20,90 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/init.h>
+#include <linux/leds.h>
 #include <linux/platform_device.h>
 
 #include <asm/mach-au1x00/au1xxx.h>
+#include <asm/mach-au1x00/au1100_mmc.h>
+
+static int mmc_activity;
+
+static void pb1200mmc0_set_power(void *mmc_host, int state)
+{
+	if (state)
+		bcsr->board |= BCSR_BOARD_SD0PWR;
+	else
+		bcsr->board &= ~BCSR_BOARD_SD0PWR;
+
+	au_sync_delay(1);
+}
+
+static int pb1200mmc0_card_readonly(void *mmc_host)
+{
+	return (bcsr->status & BCSR_STATUS_SD0WP) ? 1 : 0;
+}
+
+static int pb1200mmc0_card_inserted(void *mmc_host)
+{
+	return (bcsr->sig_status & BCSR_INT_SD0INSERT) ? 1 : 0;
+}
+
+static void pb1200_mmcled_set(struct led_classdev *led,
+			enum led_brightness brightness)
+{
+	if (brightness != LED_OFF) {
+		if (++mmc_activity == 1)
+			bcsr->disk_leds &= ~(1 << 8);
+	} else {
+		if (--mmc_activity == 0)
+			bcsr->disk_leds |= (1 << 8);
+	}
+}
+
+static struct led_classdev pb1200mmc_led = {
+	.brightness_set	= pb1200_mmcled_set,
+};
+
+#ifndef CONFIG_MIPS_DB1200
+static void pb1200mmc1_set_power(void *mmc_host, int state)
+{
+	if (state)
+		bcsr->board |= BCSR_BOARD_SD1PWR;
+	else
+		bcsr->board &= ~BCSR_BOARD_SD1PWR;
+
+	au_sync_delay(1);
+}
+
+static int pb1200mmc1_card_readonly(void *mmc_host)
+{
+	return (bcsr->status & BCSR_STATUS_SD1WP) ? 1 : 0;
+}
+
+static int pb1200mmc1_card_inserted(void *mmc_host)
+{
+	return (bcsr->sig_status & BCSR_INT_SD1INSERT) ? 1 : 0;
+}
+#endif
+
+const struct au1xmmc_platform_data au1xmmc_platdata[2] = {
+	[0] = {
+		.set_power	= pb1200mmc0_set_power,
+		.card_inserted	= pb1200mmc0_card_inserted,
+		.card_readonly	= pb1200mmc0_card_readonly,
+		.cd_setup	= NULL,		/* use poll-timer in driver */
+		.led		= &pb1200mmc_led,
+	},
+#ifndef CONFIG_MIPS_DB1200
+	[1] = {
+		.set_power	= pb1200mmc1_set_power,
+		.card_inserted	= pb1200mmc1_card_inserted,
+		.card_readonly	= pb1200mmc1_card_readonly,
+		.cd_setup	= NULL,		/* use poll-timer in driver */
+		.led		= &pb1200mmc_led,
+	},
+#endif
+};
 
 static struct resource ide_resources[] = {
 	[0] = {
-- 
1.5.5.3

