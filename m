Return-Path: <linux-kernel-owner+w=401wt.eu-S1761436AbZBMOu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436AbZBMOu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761378AbZBMOro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:47:44 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:16782 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761613AbZBMOrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:47:43 -0500
Date: Fri, 13 Feb 2009 17:47:39 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 12/13] sdhci: Add quirk for controllers with max. block
	size up to 4096 bytes
Message-ID: <20090213144739.GL23889@oksana.dev.rtsoft.ru>
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FSL eSDHC controllers can support maximum block size up to 4096
bytes. The MBL (Maximum Block Length) field in the capabilities
register extended by one bit, and bits 13:15 in the block size
register reserved.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci.c |   28 ++++++++++++++++++++--------
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index b308dbf..b341a9a 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -682,6 +682,7 @@ static void sdhci_set_transfer_irqs(struct sdhci_host *host)
 
 static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 {
+	u16 blksz;
 	u8 count;
 	u8 ctrl;
 	int ret;
@@ -831,7 +832,12 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 	sdhci_set_transfer_irqs(host);
 
 	/* We do not handle DMA boundaries, so set it to max (512 KiB) */
-	sdhci_writew(host, SDHCI_MAKE_BLKSZ(7, data->blksz), SDHCI_BLOCK_SIZE);
+	if (host->quirks & SDHCI_QUIRK_MAX_BLK_SZ_4096)
+		blksz = data->blksz;
+	else
+		blksz = SDHCI_MAKE_BLKSZ(7, data->blksz);
+
+	sdhci_writew(host, blksz, SDHCI_BLOCK_SIZE);
 	sdhci_writew(host, data->blocks, SDHCI_BLOCK_COUNT);
 }
 
@@ -1840,13 +1846,19 @@ int sdhci_add_host(struct sdhci_host *host)
 	 * Maximum block size. This varies from controller to controller and
 	 * is specified in the capabilities register.
 	 */
-	mmc->max_blk_size = (caps & SDHCI_MAX_BLOCK_MASK) >> SDHCI_MAX_BLOCK_SHIFT;
-	if (mmc->max_blk_size >= 3) {
-		printk(KERN_WARNING "%s: Invalid maximum block size, "
-			"assuming 512 bytes\n", mmc_hostname(mmc));
-		mmc->max_blk_size = 512;
-	} else
-		mmc->max_blk_size = 512 << mmc->max_blk_size;
+	if (host->quirks & SDHCI_QUIRK_MAX_BLK_SZ_4096) {
+		mmc->max_blk_size = 3;
+	} else {
+		mmc->max_blk_size = (caps & SDHCI_MAX_BLOCK_MASK) >>
+				SDHCI_MAX_BLOCK_SHIFT;
+		if (mmc->max_blk_size >= 3) {
+			printk(KERN_WARNING "%s: Invalid maximum block size, "
+				"assuming 512 bytes\n", mmc_hostname(mmc));
+			mmc->max_blk_size = 0;
+		}
+	}
+
+	mmc->max_blk_size = 512 << mmc->max_blk_size;
 
 	/*
 	 * Maximum block count.
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 5c5a950..c8628b4 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -231,6 +231,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_PIO_NEEDS_DELAY			(1<<20)
 /* Controller losing signal/interrupt enable states after reset */
 #define SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET		(1<<21)
+/* Controller supports nonstandard maximum block length of 4096 bytes */
+#define SDHCI_QUIRK_MAX_BLK_SZ_4096			(1<<22)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.6.5

