Return-Path: <linux-kernel-owner+w=401wt.eu-S1761263AbYF0UWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263AbYF0UWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756885AbYF0UWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:22:00 -0400
Received: from mail.queued.net ([207.210.101.209]:1707 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522AbYF0UV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:21:59 -0400
Date: Fri, 27 Jun 2008 16:24:43 -0400
From: Andres Salomon <dilinger@queued.net>
To: drzeus-sdhci@drzeus.cx
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 2/2] [OLPC] sdhci: add quirk for the Marvell CaFe's
 interrupt timeout
Message-ID: <20080627162443.32c52d37@xo-debian>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Note that this is against Pierre's mmc/next branch]


The CaFe chip has a hardware bug that ends up with us getting a timeout
value that's too small, causing the following sorts of problems:

[   60.525138] mmcblk0: error -110 transferring data
[   60.531477] end_request: I/O error, dev mmcblk0, sector 1484353
[   60.533371] Buffer I/O error on device mmcblk0p2, logical block 181632
[   60.533371] lost page write due to I/O error on mmcblk0p2

To play it safe, we simply set the timeout to the max possible value
(0xE), and that works.  It also breaks the timeout calculation logic
out into a separate function.

Mitch verified that using 0xE instead of 0xC in OFW fixed timeout
problems for a user with an 8GB card, as well.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/mmc/host/sdhci-pci.c |    3 +-
 drivers/mmc/host/sdhci.c     |   43 +++++++++++++++++++++++++++++------------
 drivers/mmc/host/sdhci.h     |    2 +
 3 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index ec375b8..70c0c78 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -105,7 +105,8 @@ static const struct sdhci_pci_fixes sdhci_ene_714 = {
 };
 
 static const struct sdhci_pci_fixes sdhci_cafe = {
-	.quirks		= SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER,
+	.quirks		= SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER |
+			  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
 };
 
 static int jmicron_pmos(struct sdhci_pci_chip *chip, int on)
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 5f1c1bf..228457c 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -314,23 +314,19 @@ static void sdhci_transfer_pio(struct sdhci_host *host)
 	DBG("PIO transfer complete.\n");
 }
 
-static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
+static u8 calculate_timeout(struct sdhci_host *host, struct mmc_data *data)
 {
 	u8 count;
 	unsigned target_timeout, current_timeout;
 
-	WARN_ON(host->data);
-
-	if (data == NULL)
-		return;
-
-	/* Sanity checks */
-	BUG_ON(data->blksz * data->blocks > 524288);
-	BUG_ON(data->blksz > host->mmc->max_blk_size);
-	BUG_ON(data->blocks > 65535);
-
-	host->data = data;
-	host->data_early = 0;
+	/*
+	 * If the host controller provides us with an incorrect timeout
+	 * value, just skip the check and use 0xE.  The hardware may take
+	 * longer to time out, but that's much better than having a too-short
+	 * timeout value.
+	 */
+	if ((host->quirks & SDHCI_QUIRK_BROKEN_TIMEOUT_VAL))
+		return 0xE;
 
 	/* timeout in us */
 	target_timeout = data->timeout_ns / 1000 +
@@ -361,6 +357,27 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 		count = 0xE;
 	}
 
+	return count;
+}
+
+static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
+{
+	u8 count;
+
+	WARN_ON(host->data);
+
+	if (data == NULL)
+		return;
+
+	/* Sanity checks */
+	BUG_ON(data->blksz * data->blocks > 524288);
+	BUG_ON(data->blksz > host->mmc->max_blk_size);
+	BUG_ON(data->blocks > 65535);
+
+	host->data = data;
+	host->data_early = 0;
+
+	count = calculate_timeout(host, data);
 	writeb(count, host->ioaddr + SDHCI_TIMEOUT_CONTROL);
 
 	if (host->flags & SDHCI_USE_DMA)
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 37ae056..7c30251 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -178,6 +178,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_RESET_AFTER_REQUEST			(1<<8)
 /* Controller needs voltage and power writes to happen separately */
 #define SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER		(1<<9)
+/* Controller provides an incorrect timeout value for transfers */
+#define SDHCI_QUIRK_BROKEN_TIMEOUT_VAL			(1<<10)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.5.3

