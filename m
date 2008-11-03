Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbYKCULh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbYKCULh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbYKCUKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:10:18 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:36624 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754198AbYKCUKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:10:13 -0500
Message-Id: <20081103201010.053060157@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 03 Nov 2008 20:09:45 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, sdhci-devel@list.drzeus.cx,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 1/7] SDHCI: Add timeout hooks
Content-Disposition: inline; filename=simtec/s3c64xx/sdhci-info-hooks1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some controllers do not provide clock information in their
capabilities (in the Samsung case, it is because there are
multiple clock sources available to the controller). Add hooks
to allow the system to supply clock information.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux.git/drivers/mmc/host/sdhci.c
===================================================================
--- linux.git.orig/drivers/mmc/host/sdhci.c	2008-10-21 10:49:19.000000000 +0100
+++ linux.git/drivers/mmc/host/sdhci.c	2008-10-21 11:01:38.000000000 +0100
@@ -1604,17 +1604,23 @@ int sdhci_add_host(struct sdhci_host *ho
 		mmc_dev(host->mmc)->dma_mask = &host->dma_mask;
 	}
 
-	host->max_clk =
-		(caps & SDHCI_CLOCK_BASE_MASK) >> SDHCI_CLOCK_BASE_SHIFT;
+	if (host->ops->get_max_clock)
+		host->max_clk = host->ops->get_max_clock(host);
+	else {
+		host->max_clk =	(caps & SDHCI_CLOCK_BASE_MASK) >> SDHCI_CLOCK_BASE_SHIFT;
+		host->max_clk *= 1000000;
+	}
 	if (host->max_clk == 0) {
 		printk(KERN_ERR "%s: Hardware doesn't specify base clock "
 			"frequency.\n", mmc_hostname(mmc));
 		return -ENODEV;
 	}
-	host->max_clk *= 1000000;
 
-	host->timeout_clk =
-		(caps & SDHCI_TIMEOUT_CLK_MASK) >> SDHCI_TIMEOUT_CLK_SHIFT;
+	if (host->ops->get_timeout_clock)
+		host->timeout_clk = host->ops->get_timeout_clock(host);
+	else
+		host->timeout_clk =
+			(caps & SDHCI_TIMEOUT_CLK_MASK) >> SDHCI_TIMEOUT_CLK_SHIFT;
 	if (host->timeout_clk == 0) {
 		printk(KERN_ERR "%s: Hardware doesn't specify timeout clock "
 			"frequency.\n", mmc_hostname(mmc));
Index: linux.git/drivers/mmc/host/sdhci.h
===================================================================
--- linux.git.orig/drivers/mmc/host/sdhci.h	2008-10-21 10:49:19.000000000 +0100
+++ linux.git/drivers/mmc/host/sdhci.h	2008-10-21 11:01:38.000000000 +0100
@@ -267,6 +267,8 @@ struct sdhci_host {
 
 struct sdhci_ops {
 	int		(*enable_dma)(struct sdhci_host *host);
+	unsigned int	(*get_max_clock)(struct sdhci_host *host);
+	unsigned int	(*get_timeout_clock)(struct sdhci_host *host);
 };
 
 

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
