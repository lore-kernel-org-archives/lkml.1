Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYKCUMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYKCUMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbYKCUKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:10:22 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:36630 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754149AbYKCUKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:10:13 -0500
Message-Id: <20081103201011.011975583@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 03 Nov 2008 20:09:51 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, sdhci-devel@list.drzeus.cx,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 7/7] SDHCI: Add change_clock callback for glue drivers
Content-Disposition: inline; filename=simtec/s3c64xx/sdhci-select-clock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a change_clock callback to allow drivers to update
device specific clock selections and control registers
when there is a change in clock.

Move the main part of sdhci_set_clock() to a new routine
which can be called by the glue drivers to do the sdhci
standard clock management.

Update the sdhci-s3c driver to use this to select the
appropriate clock source when clocks change.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux.git/drivers/mmc/host/sdhci-pci.c
===================================================================
--- linux.git.orig/drivers/mmc/host/sdhci-pci.c	2008-11-03 12:17:50.000000000 +0000
+++ linux.git/drivers/mmc/host/sdhci-pci.c	2008-11-03 12:18:41.000000000 +0000
@@ -391,6 +391,7 @@ static int sdhci_pci_enable_dma(struct s
 
 static struct sdhci_ops sdhci_pci_ops = {
 	.enable_dma	= sdhci_pci_enable_dma,
+	.change_clock	= sdhci_change_clock,
 };
 
 /*****************************************************************************\
Index: linux.git/drivers/mmc/host/sdhci-s3c.c
===================================================================
--- linux.git.orig/drivers/mmc/host/sdhci-s3c.c	2008-11-03 12:18:27.000000000 +0000
+++ linux.git/drivers/mmc/host/sdhci-s3c.c	2008-11-03 12:18:41.000000000 +0000
@@ -20,6 +20,7 @@
 
 #include <linux/mmc/host.h>
 
+#include <plat/regs-sdhci.h>
 #include <plat/sdhci.h>
 
 #include "sdhci.h"
@@ -31,6 +32,7 @@ struct sdhci_s3c {
 	struct platform_device	*pdev;
 	struct resource		*ioarea;
 	struct s3c_sdhci_platdata *pdata;
+	unsigned int		cur_clk;
 
 	struct clk		*clk_io;	/* clock for io bus */
 	struct clk		*clk_bus[MAX_BUS_CLK];
@@ -41,38 +43,50 @@ static inline struct sdhci_s3c *to_s3c(s
 	return sdhci_priv(host);
 }
 
+static u32 get_curclk(u32 ctrl2)
+{
+	ctrl2 &= S3C_SDHCI_CTRL2_SELBASECLK_MASK;
+	ctrl2 >>= S3C_SDHCI_CTRL2_SELBASECLK_SHIFT;
+
+	return ctrl2;
+}
 
-static void sdhci_s3c_sel_sclk(struct sdhci_host *host)
+static void sdhci_s3c_check_sclk(struct sdhci_host *host)
 {
 	struct sdhci_s3c *ourhost = to_s3c(host);
+	u32 tmp = readl(host->ioaddr + S3C_SDHCI_CONTROL2);
 
-	/* select sclk */
-	u32 tmp = readl(host->ioaddr + 0x80);
+	if (get_curclk(tmp) != ourhost->cur_clk) {
+		dev_dbg(&ourhost->pdev->dev, "restored ctrl2 clock setting\n");
 
-	if ((tmp & (3 << 4)) == (2 << 4))
-		return;
-
-	tmp &= ~(3<<4);
-	tmp |= (2 << 4);
-	writel(tmp, host->ioaddr + 0x80);
+		tmp &= ~S3C_SDHCI_CTRL2_SELBASECLK_MASK;
+		tmp |= ourhost->cur_clk << S3C_SDHCI_CTRL2_SELBASECLK_SHIFT;
+		writel(tmp, host->ioaddr + 0x80);
+	}
 }
 
-
 static unsigned int sdhci_s3c_get_max_clk(struct sdhci_host *host)
 {
 	struct sdhci_s3c *ourhost = to_s3c(host);
-	u32 control2;
-	unsigned int rate;
+	struct clk *busclk;
+	unsigned int rate, max;
 	int clk;
 
 	/* note, a reset will reset the clock source */
 
-	sdhci_s3c_sel_sclk(host);
+	sdhci_s3c_check_sclk(host);
+
+	for (max = 0, clk = 0; clk < MAX_BUS_CLK; clk++) {
+		busclk = ourhost->clk_bus[clk];
+		if (!busclk)
+			continue;
 
-	control2 = readl(host->ioaddr + 0x80);
-	clk = clk_get_rate(ourhost->clk_bus[(control2 >> 4) & 3]);
+		rate = clk_get_rate(busclk);
+		if (rate > max)
+			max = rate;
+	}
 
-	return clk;
+	return max;
 }
 
 static unsigned int sdhci_s3c_get_timeout_clk(struct sdhci_host *host)
@@ -87,7 +101,7 @@ static void sdhci_s3c_set_ios(struct sdh
 	struct s3c_sdhci_platdata *pdata = ourhost->pdata;
 	int width;
 
-	sdhci_s3c_sel_sclk(host);
+	sdhci_s3c_check_sclk(host);
 
 	if (ios->power_mode != MMC_POWER_OFF) {
 		switch (ios->bus_width) {
@@ -110,9 +124,76 @@ static void sdhci_s3c_set_ios(struct sdh
 				ios, host->mmc->card);
 }
 
+static unsigned int sdhci_s3c_consider_clock(struct sdhci_s3c *ourhost,
+					     unsigned int src,
+					     unsigned int wanted)
+{
+	unsigned long rate;
+	struct clk *clksrc = ourhost->clk_bus[src];
+	int div;
+
+	if (!clksrc)
+		return UINT_MAX;
+
+	rate = clk_get_rate(clksrc);
+
+	for (div = 1; div < 256; div *= 2) {
+		if ((rate / div) <= wanted)
+			break;
+	}
+
+	dev_dbg(&ourhost->pdev->dev, "clk %d: rate %ld, want %d, got %ld\n",
+		src, rate, wanted, rate / div);
+
+	return (wanted - (rate / div));
+}
+
+static void sdhci_s3c_change_clock(struct sdhci_host *host, unsigned int clock)
+{
+	struct sdhci_s3c *ourhost = to_s3c(host);
+	unsigned int best = UINT_MAX;
+	unsigned int delta;
+	int best_src = 0;
+	int src;
+	u32 ctrl;
+
+	for (src = 0; src < MAX_BUS_CLK; src++) {
+		delta = sdhci_s3c_consider_clock(ourhost, src, clock);
+		if (delta < best) {
+			best = delta;
+			best_src = src;
+		}
+	}
+
+	dev_dbg(&ourhost->pdev->dev,
+		"selected source %d, clock %d, delta %d\n",
+		 best_src, clock, best);
+
+	/* turn clock off to card before changing clock source */
+	writew(0, host->ioaddr + SDHCI_CLOCK_CONTROL);
+
+	/* select the new clock source */
+
+	if (ourhost->cur_clk != best_src) {
+		struct clk *clk = ourhost->clk_bus[best_src];
+
+		ourhost->cur_clk = best_src;
+		host->max_clk = clk_get_rate(clk);
+		host->timeout_clk = host->max_clk / 1000000;
+
+		ctrl = readl(host->ioaddr + S3C_SDHCI_CONTROL2);
+		ctrl &= ~S3C_SDHCI_CTRL2_SELBASECLK_MASK;
+		ctrl |= best_src << S3C_SDHCI_CTRL2_SELBASECLK_SHIFT;
+		writel(ctrl, host->ioaddr + S3C_SDHCI_CONTROL2);
+	}
+
+	sdhci_change_clock(host, clock);
+}
+
 static struct sdhci_ops sdhci_s3c_ops = {
 	.get_max_clock		= sdhci_s3c_get_max_clk,
 	.get_timeout_clock	= sdhci_s3c_get_timeout_clk,
+	.change_clock		= sdhci_s3c_change_clock,
 	.set_ios		= sdhci_s3c_set_ios,
 };
 
@@ -210,7 +291,7 @@ static int __devinit sdhci_s3c_probe(str
 	if (pdata->cfg_gpio)
 		pdata->cfg_gpio(pdev, 0);
 
-	sdhci_s3c_sel_sclk(host);
+	sdhci_s3c_check_sclk(host);
 
 	host->hw_name = "samsung-hsmmc";
 	host->ops = &sdhci_s3c_ops;
Index: linux.git/drivers/mmc/host/sdhci.c
===================================================================
--- linux.git.orig/drivers/mmc/host/sdhci.c	2008-11-03 12:18:39.000000000 +0000
+++ linux.git/drivers/mmc/host/sdhci.c	2008-11-03 12:18:41.000000000 +0000
@@ -907,13 +907,18 @@ static void sdhci_finish_command(struct 
 
 static void sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
 {
+	if (clock == host->clock)
+		return;
+
+	host->ops->change_clock(host, clock);
+}
+
+void sdhci_change_clock(struct sdhci_host *host, unsigned int clock)
+{
 	int div;
 	u16 clk;
 	unsigned long timeout;
 
-	if (clock == host->clock)
-		return;
-
 	writew(0, host->ioaddr + SDHCI_CLOCK_CONTROL);
 
 	if (clock == 0)
@@ -950,6 +955,8 @@ out:
 	host->clock = clock;
 }
 
+EXPORT_SYMBOL_GPL(sdhci_set_clock);
+
 static void sdhci_set_power(struct sdhci_host *host, unsigned short power)
 {
 	u8 pwr;
Index: linux.git/drivers/mmc/host/sdhci.h
===================================================================
--- linux.git.orig/drivers/mmc/host/sdhci.h	2008-11-03 12:17:50.000000000 +0000
+++ linux.git/drivers/mmc/host/sdhci.h	2008-11-03 12:18:41.000000000 +0000
@@ -273,6 +273,9 @@ struct sdhci_ops {
 	unsigned int	(*get_max_clock)(struct sdhci_host *host);
 	unsigned int	(*get_timeout_clock)(struct sdhci_host *host);
 
+	void		(*change_clock)(struct sdhci_host *host,
+					unsigned int clock);
+
 	void		(*set_ios)(struct sdhci_host *host,
 				   struct mmc_ios *ios);
 };
@@ -282,6 +285,8 @@ extern struct sdhci_host *sdhci_alloc_ho
 	size_t priv_size);
 extern void sdhci_free_host(struct sdhci_host *host);
 
+extern void sdhci_change_clock(struct sdhci_host *host, unsigned int clock);
+
 static inline void *sdhci_priv(struct sdhci_host *host)
 {
 	return (void *)host->private;

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
