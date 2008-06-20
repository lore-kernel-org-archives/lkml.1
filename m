Return-Path: <linux-kernel-owner+w=401wt.eu-S1760300AbYFTQMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbYFTQMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 12:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYFTQMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 12:12:44 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:34817 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbYFTQMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 12:12:43 -0400
Date: Fri, 20 Jun 2008 18:12:39 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       sshtylyov@ru.mvista.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Alchemy: register mmc platform device for
	db1200/pb1200 boards.
Message-ID: <20080620161239.GA31688@roarinelk.homelinux.net>
References: <20080609063521.GA8724@roarinelk.homelinux.net> <20080609063702.GC8724@roarinelk.homelinux.net> <20080612090206.GB21601@linux-mips.org> <20080612101839.GC21601@linux-mips.org> <20080612121828.GA24603@roarinelk.homelinux.net> <20080612122646.GA9493@linux-mips.org> <20080612154248.5c9c5c9d@mjolnir.drzeus.cx> <20080612134729.GA20015@linux-mips.org> <20080612135810.GA25352@roarinelk.homelinux.net> <20080620174607.50ad6874@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620174607.50ad6874@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pierre,

On Fri, Jun 20, 2008 at 05:46:07PM +0200, Pierre Ossman wrote:
> On Thu, 12 Jun 2008 15:58:10 +0200
> Manuel Lauss <mano@roarinelk.homelinux.net> wrote:
> 
> > On Thu, Jun 12, 2008 at 02:47:30PM +0100, Ralf Baechle wrote:
> > > On Thu, Jun 12, 2008 at 03:42:48PM +0200, Pierre Ossman wrote:
> > > 
> > > > 
> > > > How's the dependency issue though? Will this series be bisectable in my
> > > > tree?
> > > 
> > > If we're only talking about a build, there should be no dependencies
> > > between the Alchemy and the MMC parts of the series.  The Alchemy part
> > > sorts the device registration and that's a separate construction site
> > > from the rest.  Of course with only one applied things won't work
> > > terribly well but that would only be temporarily.
> > 
> > FWIW, I build tested-tested the DB1200 defconfig after each patch applied.
> > As Ralf said, patch 1 alone isn't terribly useful on it, but it should work.
> > 
> 
> This patch does not apply against HEAD. Are you sure there aren't any
> dependencies on what Ralf has in his tree? If so, perhaps this should
> be in the MIPS tree.

It was broken by commit dab8c6deaf1d654d09c3de8bd4c286d424df255a which went
in this week; here's another updated version of [PATCH 2/8].

Thanks!
	Manuel Lauss

--- 
From: Manuel Lauss <mano@roarinelk.homelinux.net>

Add au1xmmc platform data for PB1200/DB1200 boards and wire up
the 2 SD controllers for them.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 arch/mips/au1000/common/platform.c |   98 +++++++++++++++++++++++++++---------
 arch/mips/au1000/pb1200/platform.c |   81 +++++++++++++++++++++++++++++
 2 files changed, 155 insertions(+), 24 deletions(-)

diff --git a/arch/mips/au1000/common/platform.c b/arch/mips/au1000/common/platform.c
index dc8a67e..5c76c64 100644
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
-		.end            = SD0_PHYS_ADDR + 0x7ffff,
-		.flags          = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start		= SD1_PHYS_ADDR,
-		.end 		= SD1_PHYS_ADDR + 0x7ffff,
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
 	},
-	.num_resources  = ARRAY_SIZE(au1xxx_mmc_resources),
-	.resource       = au1xxx_mmc_resources,
+	.num_resources	= ARRAY_SIZE(au1200_mmc0_resources),
+	.resource	= au1200_mmc0_resources,
 };
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
+	},
+	[3] = {
+		.start          = DSCR_CMD0_SDMS_RX1,
+		.end		= DSCR_CMD0_SDMS_RX1,
+		.flags          = IORESOURCE_DMA,
+	}
+};
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
1.5.5.4

