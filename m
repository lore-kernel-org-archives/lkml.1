Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbZHGQu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbZHGQu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 12:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbZHGQu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 12:50:26 -0400
Received: from ru.mvista.com ([213.79.90.228]:1785 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754331AbZHGQuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 12:50:23 -0400
Date: Fri, 7 Aug 2009 20:50:24 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pierre Ossman <pierre@ossman.eu>, Kumar Gala <galak@kernel.crashing.org>,
       Ben Dooks <ben@fluff.org>, Sascha Hauer <s.hauer@pengutronix.de>,
       linux-kernel@vger.kernel.org, sdhci-devel@lists.ossman.eu,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 4/4] sdhci-of: Cleanup eSDHC's set_clock() a little bit
Message-ID: <20090807165024.GC524@oksana.dev.rtsoft.ru>
References: <20090807163940.GA29192@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090807163940.GA29192@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Get rid of incomprehensible "if { for { if } }" construction for the
  exponential divisor calculation. The first if statement isn't correct
  at all, since it should check for "host->max_clk / pre_div / 16 >
  clock". The error doesn't cause any bugs because the check in the for
  loop does the right thing, and so the outer check becomes useless;

- For the linear divisor do the same: a single while statement is more
  readable than for + if construction;

- Add dev_dbg() that prints desired and actual clock frequency.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci-of.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of.c b/drivers/mmc/host/sdhci-of.c
index b6ff2e8..bbdd468 100644
--- a/drivers/mmc/host/sdhci-of.c
+++ b/drivers/mmc/host/sdhci-of.c
@@ -120,8 +120,8 @@ static void esdhc_writeb(struct sdhci_host *host, u8 val, int reg)
 
 static void esdhc_set_clock(struct sdhci_host *host, unsigned int clock)
 {
-	int div;
 	int pre_div = 2;
+	int div = 1;
 
 	clrbits32(host->ioaddr + ESDHC_SYSTEM_CONTROL, ESDHC_CLOCK_IPGEN |
 		  ESDHC_CLOCK_HCKEN | ESDHC_CLOCK_PEREN | ESDHC_CLOCK_MASK);
@@ -129,17 +129,14 @@ static void esdhc_set_clock(struct sdhci_host *host, unsigned int clock)
 	if (clock == 0)
 		goto out;
 
-	if (host->max_clk / 16 > clock) {
-		for (; pre_div < 256; pre_div *= 2) {
-			if (host->max_clk / pre_div < clock * 16)
-				break;
-		}
-	}
+	while (host->max_clk / pre_div / 16 > clock && pre_div < 256)
+		pre_div *= 2;
 
-	for (div = 1; div <= 16; div++) {
-		if (host->max_clk / (div * pre_div) <= clock)
-			break;
-	}
+	while (host->max_clk / pre_div / div > clock && div < 16)
+		div++;
+
+	dev_dbg(mmc_dev(host->mmc), "desired SD clock: %d, actual: %d\n",
+		clock, host->max_clk / pre_div / div);
 
 	pre_div >>= 1;
 	div--;
-- 
1.6.3.3
