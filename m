Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab0BQSLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:11:16 -0500
Received: from lmv.inov.pt ([146.193.64.2]:57255 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab0BQSLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:11:14 -0500
Message-ID: <4B7C30DF.90805@inov.pt>
Date: Wed, 17 Feb 2010 18:09:35 +0000
From: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben@simtec.co.uk>
CC: David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Simtec Linux Team <linux@simtec.co.uk>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH] spi_s3c24xx: Fix for SPI on S3C2412
Content-Type: multipart/mixed;
 boundary="------------020001050709070404040205"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0.1 (lmv.inov.pt [146.193.64.2]); Wed, 17 Feb 2010 18:09:39 +0000 (WET)
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020001050709070404040205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

Testing some SPI temperature sensors and ADCs with a S3C4212 host I have 
found that I could not read the correct data.  I've probed the SPI 
signals with a scope and everything seemed OK.
I dig into the driver sources and on the S3C2412 datasheet to find that 
this device can not use the same S3C2410 driver's code because of the 
added FIFOs, even if not used. The following patch is needed to make the 
driver to work on the S3C2412 chip (and probably on the S3C2413).

Regards,
José Miguel Gonçalves

--------------020001050709070404040205
Content-Type: text/x-patch;
 name="linux-2.6.git-spi_s3c2412.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.git-spi_s3c2412.patch"

Signed-off-by: Jose Miguel Goncalves <jose.goncalves@inov.pt>

diff --git a/arch/arm/mach-s3c2412/s3c2412.c b/arch/arm/mach-s3c2412/s3c2412.c
index bef39f7..c58330f 100644
--- a/arch/arm/mach-s3c2412/s3c2412.c
+++ b/arch/arm/mach-s3c2412/s3c2412.c
@@ -100,11 +100,9 @@ void __init s3c2412_init_uarts(struct s3c2410_uartcfg *cfg, int no)
 	s3c_device_sdi.resource[1].end   = IRQ_S3C2412_SDI;
 
 	/* spi channel related changes, s3c2412/13 specific */
-	s3c_device_spi0.name = "s3c2412-spi";
-	s3c_device_spi0.resource[0].end = S3C24XX_PA_SPI + 0x24;
-	s3c_device_spi1.name = "s3c2412-spi";
+	s3c_device_spi0.resource[0].end = S3C24XX_PA_SPI + 0x2F;
 	s3c_device_spi1.resource[0].start = S3C24XX_PA_SPI + S3C2412_SPI1;
-	s3c_device_spi1.resource[0].end = S3C24XX_PA_SPI + S3C2412_SPI1 + 0x24;
+	s3c_device_spi1.resource[0].end = S3C24XX_PA_SPI + S3C2412_SPI1 + 0x2F;
 
 }
 
diff --git a/arch/arm/plat-s3c24xx/include/plat/regs-spi.h b/arch/arm/plat-s3c24xx/include/plat/regs-spi.h
index 2b35479..57e799c 100644
--- a/arch/arm/plat-s3c24xx/include/plat/regs-spi.h
+++ b/arch/arm/plat-s3c24xx/include/plat/regs-spi.h
@@ -75,7 +75,8 @@
 #define S3C2410_SPRDAT	 (0x14)
 
 #define S3C2412_TXFIFO	 (0x18)
-#define S3C2412_RXFIFO	 (0x18)
+#define S3C2412_RXFIFO	 (0x1C)
+#define S3C2412_SPRDATB	 (0x20)
 #define S3C2412_SPFIC	 (0x24)
 
 
diff --git a/drivers/spi/spi_s3c24xx.c b/drivers/spi/spi_s3c24xx.c
index c010733..9c57715 100644
--- a/drivers/spi/spi_s3c24xx.c
+++ b/drivers/spi/spi_s3c24xx.c
@@ -440,6 +440,12 @@ static int s3c24xx_spi_txrx(struct spi_device *spi, struct spi_transfer *t)
 	return hw->count;
 }
 
+#ifdef CONFIG_CPU_S3C2412
+#define SPRDAT S3C2412_SPRDATB
+#else
+#define SPRDAT S3C2410_SPRDAT
+#endif
+
 static irqreturn_t s3c24xx_spi_irq(int irq, void *dev)
 {
 	struct s3c24xx_spi *hw = dev;
@@ -462,7 +468,7 @@ static irqreturn_t s3c24xx_spi_irq(int irq, void *dev)
 		hw->count++;
 
 		if (hw->rx)
-			hw->rx[count] = readb(hw->regs + S3C2410_SPRDAT);
+			hw->rx[count] = readb(hw->regs + SPRDAT);
 
 		count++;
 
@@ -475,7 +481,7 @@ static irqreturn_t s3c24xx_spi_irq(int irq, void *dev)
 		hw->fiq_inuse = 0;
 
 		if (hw->rx)
-			hw->rx[hw->len-1] = readb(hw->regs + S3C2410_SPRDAT);
+			hw->rx[hw->len-1] = readb(hw->regs + SPRDAT);
 
 		complete(&hw->done);
 	}

--------------020001050709070404040205--
