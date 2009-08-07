Return-Path: <linux-kernel-owner+w=401wt.eu-S933391AbZHGT6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391AbZHGT6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 15:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933285AbZHGT6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 15:58:10 -0400
Received: from ru.mvista.com ([213.79.90.228]:2249 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933363AbZHGT6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 15:58:08 -0400
Date: Fri, 7 Aug 2009 23:58:08 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pierre Ossman <pierre@ossman.eu>, Kumar Gala <galak@kernel.crashing.org>,
       David Vrabel <david.vrabel@csr.com>, Ben Dooks <ben@fluff.org>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
       sdhci-devel@lists.ossman.eu, linuxppc-dev@ozlabs.org
Subject: [PATCH 3/7] sdhci-of: Fix high-speed cards recognition
Message-ID: <20090807195808.GC2735@oksana.dev.rtsoft.ru>
References: <20090807195724.GA24020@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090807195724.GA24020@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eSDHC fails to recognize some SDHS cards, throwing timeout errors:

  mmc0: error -110 whilst initialising SD card

That's because we calculate timeout value in a wrong way: on eSDHC
hosts the timeout clock is derivied from the SD clock, which is set
dynamically.

As David Vrabel suggested, deriving timeout clock from SD clock is
a common scheme, so let's implement DATA_TIMEOUT_USES_SDCLK quirk
and use it for eSDHC hosts.

Also, from now on we don't need esdhc_get_timeout_clock() callback,
so remove it.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci-of.c |    9 +--------
 drivers/mmc/host/sdhci.c    |    9 +++++++--
 drivers/mmc/host/sdhci.h    |    2 ++
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of.c b/drivers/mmc/host/sdhci-of.c
index 8440fd9..004f24d 100644
--- a/drivers/mmc/host/sdhci-of.c
+++ b/drivers/mmc/host/sdhci-of.c
@@ -172,19 +172,13 @@ static unsigned int esdhc_get_min_clock(struct sdhci_host *host)
 	return of_host->clock / 256 / 16;
 }
 
-static unsigned int esdhc_get_timeout_clock(struct sdhci_host *host)
-{
-	struct sdhci_of_host *of_host = sdhci_priv(host);
-
-	return of_host->clock / 1000;
-}
-
 static struct sdhci_of_data sdhci_esdhc = {
 	.quirks = SDHCI_QUIRK_FORCE_BLK_SZ_2048 |
 		  SDHCI_QUIRK_BROKEN_CARD_DETECTION |
 		  SDHCI_QUIRK_INVERTED_WRITE_PROTECT |
 		  SDHCI_QUIRK_NO_BUSY_IRQ |
 		  SDHCI_QUIRK_NONSTANDARD_CLOCK |
+		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
 		  SDHCI_QUIRK_PIO_NEEDS_DELAY |
 		  SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET |
 		  SDHCI_QUIRK_NO_CARD_NO_RESET,
@@ -199,7 +193,6 @@ static struct sdhci_of_data sdhci_esdhc = {
 		.enable_dma = esdhc_enable_dma,
 		.get_max_clock = esdhc_get_max_clock,
 		.get_min_clock = esdhc_get_min_clock,
-		.get_timeout_clock = esdhc_get_timeout_clock,
 	},
 };
 
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index fc96f8c..288e40b 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -591,6 +591,9 @@ static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_data *data)
 	target_timeout = data->timeout_ns / 1000 +
 		data->timeout_clks / host->clock;
 
+	if (host->quirks & SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK)
+		host->timeout_clk = host->clock / 1000;
+
 	/*
 	 * Figure out needed cycles.
 	 * We do this in steps in order to fit inside a 32 bit int.
@@ -1757,13 +1760,15 @@ int sdhci_add_host(struct sdhci_host *host)
 	host->timeout_clk =
 		(caps & SDHCI_TIMEOUT_CLK_MASK) >> SDHCI_TIMEOUT_CLK_SHIFT;
 	if (host->timeout_clk == 0) {
-		if (!host->ops->get_timeout_clock) {
+		if (host->ops->get_timeout_clock) {
+			host->timeout_clk = host->ops->get_timeout_clock(host);
+		} else if (!(host->quirks &
+				SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK)) {
 			printk(KERN_ERR
 			       "%s: Hardware doesn't specify timeout clock "
 			       "frequency.\n", mmc_hostname(mmc));
 			return -ENODEV;
 		}
-		host->timeout_clk = host->ops->get_timeout_clock(host);
 	}
 	if (caps & SDHCI_TIMEOUT_CLK_UNIT)
 		host->timeout_clk *= 1000;
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index c77e9ff..afda7f1 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -232,6 +232,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_FORCE_1_BIT_DATA			(1<<22)
 /* Controller needs 10ms delay between applying power and clock */
 #define SDHCI_QUIRK_DELAY_AFTER_POWER			(1<<23)
+/* Controller uses SDCLK instead of TMCLK for data timeouts */
+#define SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK		(1<<24)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.6.3.3

