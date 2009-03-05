Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbZCEUaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbZCEUaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 15:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbZCEU2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 15:28:43 -0500
Received: from [213.79.90.228] ([213.79.90.228]:46817 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755229AbZCEU2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 15:28:42 -0500
Date: Thu, 5 Mar 2009 23:28:40 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 06/11] sdhci: Add get_{max,timeout}_clock callbacks
Message-ID: <20090305202840.GF28709@oksana.dev.rtsoft.ru>
References: <20090305202737.GA24166@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090305202737.GA24166@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben-linux@fluff.org>

Some controllers do not provide clock information in their capabilities
(in the Samsung case, it is because there are multiple clock sources
available to the controller). Add hooks to allow the system to supply
clock information.

p.s.
In the original Ben's patch there was a bug that makes sdhci_add_host()
return -ENODEV even if callbacks were specified. This is fixed now.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci.c |   22 +++++++++++++++-------
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 8aaf3a5..cca80d3 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1729,19 +1729,27 @@ int sdhci_add_host(struct sdhci_host *host)
 
 	host->max_clk =
 		(caps & SDHCI_CLOCK_BASE_MASK) >> SDHCI_CLOCK_BASE_SHIFT;
+	host->max_clk *= 1000000;
 	if (host->max_clk == 0) {
-		printk(KERN_ERR "%s: Hardware doesn't specify base clock "
-			"frequency.\n", mmc_hostname(mmc));
-		return -ENODEV;
+		if (!host->ops->get_max_clock) {
+			printk(KERN_ERR
+			       "%s: Hardware doesn't specify base clock "
+			       "frequency.\n", mmc_hostname(mmc));
+			return -ENODEV;
+		}
+		host->max_clk = host->ops->get_max_clock(host);
 	}
-	host->max_clk *= 1000000;
 
 	host->timeout_clk =
 		(caps & SDHCI_TIMEOUT_CLK_MASK) >> SDHCI_TIMEOUT_CLK_SHIFT;
 	if (host->timeout_clk == 0) {
-		printk(KERN_ERR "%s: Hardware doesn't specify timeout clock "
-			"frequency.\n", mmc_hostname(mmc));
-		return -ENODEV;
+		if (!host->ops->get_timeout_clock) {
+			printk(KERN_ERR
+			       "%s: Hardware doesn't specify timeout clock "
+			       "frequency.\n", mmc_hostname(mmc));
+			return -ENODEV;
+		}
+		host->timeout_clk = host->ops->get_timeout_clock(host);
 	}
 	if (caps & SDHCI_TIMEOUT_CLK_UNIT)
 		host->timeout_clk *= 1000;
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index d0d812e..34f1849 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -281,6 +281,8 @@ struct sdhci_ops {
 	void		(*writeb)(struct sdhci_host *host, u8 val, int reg);
 
 	int		(*enable_dma)(struct sdhci_host *host);
+	unsigned int	(*get_max_clock)(struct sdhci_host *host);
+	unsigned int	(*get_timeout_clock)(struct sdhci_host *host);
 };
 
 extern void sdhci_writel(struct sdhci_host *host, u32 val, int reg);
-- 
1.5.6.5

