Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbZAVCC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbZAVCC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 21:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756700AbZAVCAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 21:00:41 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:44908 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756673AbZAVCAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 21:00:40 -0500
Date: Thu, 22 Jan 2009 05:00:39 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, Xie Xiaobo <X.Xie@freescale.com>,
       Konjin Lai <Konjin.Lai@freescale.com>,
       "Joe D'Abbraccio" <Joe.D'abbraccio@freescale.com>,
       sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 09/10] sdhci: Add quirk for Freescale eSDHC controllers
Message-ID: <20090122020039.GI11492@oksana.dev.rtsoft.ru>
References: <20090122015649.GA6835@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090122015649.GA6835@oksana.dev.rtsoft.ru>
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
index e456ae0..82085e4 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -321,6 +321,10 @@ static void sdhci_transfer_pio(struct sdhci_host *host)
 		mask = ~0;
 
 	while (sdhci_readl(host, SDHCI_PRESENT_STATE) & mask) {
+		/* FIXME */
+		if (host->quirks & SDHCI_QUIRK_FSL)
+			udelay(100);
+
 		if (host->data->flags & MMC_DATA_READ)
 			sdhci_read_block_pio(host);
 		else
@@ -618,6 +622,7 @@ static void sdhci_set_pio_irqs(struct sdhci_host *host, bool state)
 
 static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 {
+	u16 blksz;
 	u8 count;
 	u8 ctrl;
 	int ret;
@@ -768,7 +773,12 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 	}
 
 	/* We do not handle DMA boundaries, so set it to max (512 KiB) */
-	sdhci_writew(host, SDHCI_BLOCK_SIZE, SDHCI_MAKE_BLKSZ(7, data->blksz));
+	if (host->quirks & SDHCI_QUIRK_FSL)
+		blksz = data->blksz;
+	else
+		blksz = SDHCI_MAKE_BLKSZ(7, data->blksz);
+
+	sdhci_writew(host, SDHCI_BLOCK_SIZE, blksz);
 	sdhci_writew(host, SDHCI_BLOCK_COUNT, data->blocks);
 }
 
@@ -1270,6 +1280,9 @@ static void sdhci_tasklet_finish(unsigned long param)
 		   controllers do not like that. */
 		sdhci_reset(host, SDHCI_RESET_CMD);
 		sdhci_reset(host, SDHCI_RESET_DATA);
+		/* FSL controllers need this. */
+		if (host->quirks & SDHCI_QUIRK_FSL)
+			sdhci_init(host);
 	}
 
 	host->mrq = NULL;
@@ -1779,13 +1792,24 @@ int sdhci_add_host(struct sdhci_host *host)
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
index 39cfd5a..7b98ec6 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -138,6 +138,7 @@
 #define  SDHCI_CLOCK_BASE_MASK	0x00003F00
 #define  SDHCI_CLOCK_BASE_SHIFT	8
 #define  SDHCI_MAX_BLOCK_MASK	0x00030000
+#define  SDHCI_FSL_MAX_BLOCK_MASK 0x00070000
 #define  SDHCI_MAX_BLOCK_SHIFT  16
 #define  SDHCI_CAN_DO_ADMA2	0x00080000
 #define  SDHCI_CAN_DO_ADMA1	0x00100000
@@ -223,6 +224,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_32BIT_REGISTERS			(1<<18)
 /* Controller issues PIO interrupts during DMA transfers */
 #define SDHCI_QUIRK_PIO_IRQS_DURING_DMA			(1<<19)
+/* Controller is Freescale eSDHC */
+#define SDHCI_QUIRK_FSL					(1<<20)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.6.5

