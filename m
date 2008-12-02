Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbYLBPm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbYLBPm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYLBPkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:40:55 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:34930 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751484AbYLBPkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:40:51 -0500
Message-Id: <20081202154112.009165156@fluff.org.uk>
References: <20081202154018.906091477@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 15:40:19 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       drzeus-sdhci@drzeus.cx
Cc: Ben Dooks <ben-linux@fluff.org>
Subject: [patch 1/8] SDHCI: Add timeout hooks
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
--- linux.git.orig/drivers/mmc/host/sdhci.c	2008-12-01 19:11:54.000000000 +0000
+++ linux.git/drivers/mmc/host/sdhci.c	2008-12-01 19:24:14.000000000 +0000
@@ -1606,18 +1606,26 @@ int sdhci_add_host(struct sdhci_host *ho
 
 	host->max_clk =
 		(caps & SDHCI_CLOCK_BASE_MASK) >> SDHCI_CLOCK_BASE_SHIFT;
+	host->max_clk *= 1000000;
 	if (host->max_clk == 0) {
-		printk(KERN_ERR "%s: Hardware doesn't specify base clock "
-			"frequency.\n", mmc_hostname(mmc));
+		if (host->ops->get_max_clock)
+			host->max_clk = host->ops->get_max_clock(host);
+		else
+			printk(KERN_ERR
+			       "%s: Hardware doesn't specify base clock "
+			       "frequency.\n", mmc_hostname(mmc));
 		return -ENODEV;
 	}
-	host->max_clk *= 1000000;
 
 	host->timeout_clk =
 		(caps & SDHCI_TIMEOUT_CLK_MASK) >> SDHCI_TIMEOUT_CLK_SHIFT;
 	if (host->timeout_clk == 0) {
-		printk(KERN_ERR "%s: Hardware doesn't specify timeout clock "
-			"frequency.\n", mmc_hostname(mmc));
+		if (host->ops->get_timeout_clock)
+			host->timeout_clk = host->ops->get_timeout_clock(host);
+		else
+			printk(KERN_ERR
+			       "%s: Hardware doesn't specify timeout clock "
+			       "frequency.\n", mmc_hostname(mmc));
 		return -ENODEV;
 	}
 	if (caps & SDHCI_TIMEOUT_CLK_UNIT)
Index: linux.git/drivers/mmc/host/sdhci.h
===================================================================
--- linux.git.orig/drivers/mmc/host/sdhci.h	2008-12-01 19:11:54.000000000 +0000
+++ linux.git/drivers/mmc/host/sdhci.h	2008-12-01 19:17:55.000000000 +0000
@@ -267,6 +267,8 @@ struct sdhci_host {
 
 struct sdhci_ops {
 	int		(*enable_dma)(struct sdhci_host *host);
+	unsigned int	(*get_max_clock)(struct sdhci_host *host);
+	unsigned int	(*get_timeout_clock)(struct sdhci_host *host);
 };
 
 

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
