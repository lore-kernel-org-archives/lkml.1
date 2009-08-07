Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbZHGQuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbZHGQuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 12:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZHGQuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 12:50:17 -0400
Received: from ru.mvista.com ([213.79.90.228]:1777 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754248AbZHGQuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 12:50:15 -0400
Date: Fri, 7 Aug 2009 20:50:15 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pierre Ossman <pierre@ossman.eu>, Kumar Gala <galak@kernel.crashing.org>,
       Ben Dooks <ben@fluff.org>, Sascha Hauer <s.hauer@pengutronix.de>,
       linux-kernel@vger.kernel.org, sdhci-devel@lists.ossman.eu,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 3/4] sdhci-of: Fix high-speed cards recognition
Message-ID: <20090807165015.GB524@oksana.dev.rtsoft.ru>
References: <20090807163940.GA29192@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090807163940.GA29192@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eSDHC fails to recognize some SDHS cards, throwing timeout errors:

  mmc0: error -110 whilst initialising SD card

That's because we calculate timeout value in a wrong way: on eSDHC
hosts the timeout clock is derivied from the SD clock, which is set
dynamically.

This patch fixes the issue by introducing and implementing
DYNAMIC_TIMEOUT_CLOCK quirk for sdhci-of driver.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci-of.c |    5 ++---
 drivers/mmc/host/sdhci.c    |    4 ++++
 drivers/mmc/host/sdhci.h    |    2 ++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of.c b/drivers/mmc/host/sdhci-of.c
index 8440fd9..b6ff2e8 100644
--- a/drivers/mmc/host/sdhci-of.c
+++ b/drivers/mmc/host/sdhci-of.c
@@ -174,9 +174,7 @@ static unsigned int esdhc_get_min_clock(struct sdhci_host *host)
 
 static unsigned int esdhc_get_timeout_clock(struct sdhci_host *host)
 {
-	struct sdhci_of_host *of_host = sdhci_priv(host);
-
-	return of_host->clock / 1000;
+	return host->clock / 1000;
 }
 
 static struct sdhci_of_data sdhci_esdhc = {
@@ -185,6 +183,7 @@ static struct sdhci_of_data sdhci_esdhc = {
 		  SDHCI_QUIRK_INVERTED_WRITE_PROTECT |
 		  SDHCI_QUIRK_NO_BUSY_IRQ |
 		  SDHCI_QUIRK_NONSTANDARD_CLOCK |
+		  SDHCI_QUIRK_DYNAMIC_TIMEOUT_CLOCK |
 		  SDHCI_QUIRK_PIO_NEEDS_DELAY |
 		  SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET |
 		  SDHCI_QUIRK_NO_CARD_NO_RESET,
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index fc96f8c..0f273fe 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -591,6 +591,10 @@ static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_data *data)
 	target_timeout = data->timeout_ns / 1000 +
 		data->timeout_clks / host->clock;
 
+	if (host->quirks & SDHCI_QUIRK_DYNAMIC_TIMEOUT_CLOCK &&
+			host->ops->get_timeout_clock)
+		host->timeout_clk = host->ops->get_timeout_clock(host);
+
 	/*
 	 * Figure out needed cycles.
 	 * We do this in steps in order to fit inside a 32 bit int.
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index c77e9ff..44b1dcc 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -232,6 +232,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_FORCE_1_BIT_DATA			(1<<22)
 /* Controller needs 10ms delay between applying power and clock */
 #define SDHCI_QUIRK_DELAY_AFTER_POWER			(1<<23)
+/* Controller has dynamic timeout clock management */
+#define SDHCI_QUIRK_DYNAMIC_TIMEOUT_CLOCK		(1<<24)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.6.3.3

