Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbZBFSJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbZBFSJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760256AbZBFSG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:06:59 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:3231 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759941AbZBFSG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:06:58 -0500
Date: Fri, 6 Feb 2009 21:06:57 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 08/11] sdhci: Add support for hosts that don't specify
	clocks in the cap. register
Message-ID: <20090206180657.GH11548@oksana.dev.rtsoft.ru>
References: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FSL eSDHC hosts don't provide clocks bits in the capabilities register,
instead we're getting clocks values from the device tree.

There is somewhat similar change[1] from Ben Dooks, the change adds
callbacks for getting the clocks. But for eSDHC the callbacks are
superfluous, since the clocks are static.

[1] http://lkml.org/lkml/2008/12/2/157

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index ede3790..0293368 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1703,24 +1703,23 @@ int sdhci_add_host(struct sdhci_host *host)
 		mmc_dev(host->mmc)->dma_mask = &host->dma_mask;
 	}
 
-	host->max_clk =
-		(caps & SDHCI_CLOCK_BASE_MASK) >> SDHCI_CLOCK_BASE_SHIFT;
-	if (host->max_clk == 0) {
-		printk(KERN_ERR "%s: Hardware doesn't specify base clock "
-			"frequency.\n", mmc_hostname(mmc));
-		return -ENODEV;
+	if (!host->max_clk) {
+		host->max_clk = (caps & SDHCI_CLOCK_BASE_MASK) >>
+						SDHCI_CLOCK_BASE_SHIFT;
+		if (host->max_clk == 0) {
+			printk(KERN_ERR "%s: Hardware doesn't specify base "
+				"clock frequency.\n", mmc_hostname(mmc));
+			return -ENODEV;
+		}
+		host->max_clk *= 1000000;
 	}
-	host->max_clk *= 1000000;
 
-	host->timeout_clk =
-		(caps & SDHCI_TIMEOUT_CLK_MASK) >> SDHCI_TIMEOUT_CLK_SHIFT;
-	if (host->timeout_clk == 0) {
-		printk(KERN_ERR "%s: Hardware doesn't specify timeout clock "
-			"frequency.\n", mmc_hostname(mmc));
-		return -ENODEV;
+	if (!host->timeout_clk) {
+		host->timeout_clk = (caps & SDHCI_TIMEOUT_CLK_MASK) >>
+						SDHCI_TIMEOUT_CLK_SHIFT;
+		if (caps & SDHCI_TIMEOUT_CLK_UNIT)
+			host->timeout_clk *= 1000;
 	}
-	if (caps & SDHCI_TIMEOUT_CLK_UNIT)
-		host->timeout_clk *= 1000;
 
 	/*
 	 * Set host parameters.
-- 
1.5.6.5

