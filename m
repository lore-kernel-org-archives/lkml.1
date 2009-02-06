Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbZBFSKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbZBFSKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbZBFSHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:07:05 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:3254 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756857AbZBFSHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:07:04 -0500
Date: Fri, 6 Feb 2009 21:07:01 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 10/11] sdhci: Add quirk for Freescale eSDHC controllers
Message-ID: <20090206180701.GJ11548@oksana.dev.rtsoft.ru>
References: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds SDHCI_QUIRK_FSL quirk. The quirk is used to instruct
the sdhci driver about various FSL eSDHC host incompatibilities:

1) FSL eSDHC controllers can support maximum block size up to 4096
   bytes. The MBL (Maximum Block Length) field in the capabilities
   register extended by one bit.

   (Should we implement a dedicated quirk for this? I.e.
    SDHCI_QUIRK_MAX_BLK_SZ_4096?)

2) sdhci_init() is needed after error conditions.

   (Can we safely do this for all controllers?)

3) Small udelay is needed to make eSDHC work in PIO mode. Without
   the delay reading causes endless interrupt storm, and writing
   corrupts data. The first guess would be that we must wait for
   some bit in some register, but I didn't find any reliable bits
   that changes before and after the delay. Though, more investigation
   on this is in my todo list.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci.c |   36 ++++++++++++++++++++++++++++++------
 drivers/mmc/host/sdhci.h |    3 +++
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 3c1f1d5..87ba0ed 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -328,6 +328,10 @@ static void sdhci_transfer_pio(struct sdhci_host *host)
 		mask = ~0;
 
 	while (sdhci_readl(host, SDHCI_PRESENT_STATE) & mask) {
+		/* FIXME */
+		if (host->quirks & SDHCI_QUIRK_FSL)
+			udelay(100);
+
 		if (host->data->flags & MMC_DATA_READ)
 			sdhci_read_block_pio(host);
 		else
@@ -625,6 +629,7 @@ static void sdhci_set_pio_irqs(struct sdhci_host *host, bool state)
 
 static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 {
+	u16 blksz;
 	u8 count;
 	u8 ctrl;
 	int ret;
@@ -775,7 +780,12 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 	}
 
 	/* We do not handle DMA boundaries, so set it to max (512 KiB) */
-	sdhci_writew(host, SDHCI_MAKE_BLKSZ(7, data->blksz), SDHCI_BLOCK_SIZE);
+	if (host->quirks & SDHCI_QUIRK_FSL)
+		blksz = data->blksz;
+	else
+		blksz = SDHCI_MAKE_BLKSZ(7, data->blksz);
+
+	sdhci_writew(host, blksz, SDHCI_BLOCK_SIZE);
 	sdhci_writew(host, data->blocks, SDHCI_BLOCK_COUNT);
 }
 
@@ -1280,6 +1290,9 @@ static void sdhci_tasklet_finish(unsigned long param)
 		   controllers do not like that. */
 		sdhci_reset(host, SDHCI_RESET_CMD);
 		sdhci_reset(host, SDHCI_RESET_DATA);
+		/* FSL controllers need this. */
+		if (host->quirks & SDHCI_QUIRK_FSL)
+			sdhci_init(host);
 	}
 
 	host->mrq = NULL;
@@ -1789,13 +1802,24 @@ int sdhci_add_host(struct sdhci_host *host)
 	 * Maximum block size. This varies from controller to controller and
 	 * is specified in the capabilities register.
 	 */
-	mmc->max_blk_size = (caps & SDHCI_MAX_BLOCK_MASK) >> SDHCI_MAX_BLOCK_SHIFT;
-	if (mmc->max_blk_size >= 3) {
+	if (host->quirks & SDHCI_QUIRK_FSL) {
+		mmc->max_blk_size = (caps & SDHCI_FSL_MAX_BLOCK_MASK) >>
+				SDHCI_MAX_BLOCK_SHIFT;
+		if (mmc->max_blk_size >= 4)
+			mmc->max_blk_size = ~0;
+	} else {
+		mmc->max_blk_size = (caps & SDHCI_MAX_BLOCK_MASK) >>
+				SDHCI_MAX_BLOCK_SHIFT;
+		if (mmc->max_blk_size >= 3)
+			mmc->max_blk_size = ~0;
+	}
+
+	if (mmc->max_blk_size == ~0) {
 		printk(KERN_WARNING "%s: Invalid maximum block size, "
 			"assuming 512 bytes\n", mmc_hostname(mmc));
-		mmc->max_blk_size = 512;
-	} else
-		mmc->max_blk_size = 512 << mmc->max_blk_size;
+		mmc->max_blk_size = 0;
+	}
+	mmc->max_blk_size = 512 << mmc->max_blk_size;
 
 	/*
 	 * Maximum block count.
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 497276b..cb575f3 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -152,6 +152,7 @@ static inline int sdhci_off(sdhci_reg_t reg)
 #define  SDHCI_CLOCK_BASE_MASK	0x00003F00
 #define  SDHCI_CLOCK_BASE_SHIFT	8
 #define  SDHCI_MAX_BLOCK_MASK	0x00030000
+#define  SDHCI_FSL_MAX_BLOCK_MASK 0x00070000
 #define  SDHCI_MAX_BLOCK_SHIFT  16
 #define  SDHCI_CAN_DO_ADMA2	0x00080000
 #define  SDHCI_CAN_DO_ADMA1	0x00100000
@@ -237,6 +238,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_32BIT_REGISTERS			(1<<18)
 /* Controller issues PIO interrupts during DMA transfers */
 #define SDHCI_QUIRK_PIO_IRQS_DURING_DMA			(1<<19)
+/* Controller is Freescale eSDHC */
+#define SDHCI_QUIRK_FSL					(1<<20)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.6.5

