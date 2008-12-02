Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbYLBPl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbYLBPl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYLBPky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:40:54 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:34936 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751459AbYLBPkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:40:51 -0500
Message-Id: <20081202154112.316341865@fluff.org.uk>
References: <20081202154018.906091477@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 15:40:21 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       drzeus-sdhci@drzeus.cx
Cc: Ben Dooks <ben-linux@fluff.org>
Subject: [patch 3/8] SDHCI: Add set_ios hook
Content-Disposition: inline; filename=simtec/s3c64xx/sdhci-add-ios-hook.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a set_ios hook which is called when the SDHCI driver
is called to change parameters such as clock or card
width.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux.git/drivers/mmc/host/sdhci.c
===================================================================
--- linux.git.orig/drivers/mmc/host/sdhci.c	2008-12-01 19:26:25.000000000 +0000
+++ linux.git/drivers/mmc/host/sdhci.c	2008-12-02 14:36:47.000000000 +0000
@@ -1038,6 +1038,9 @@ static void sdhci_set_ios(struct mmc_hos
 		sdhci_init(host);
 	}
 
+	if (host->ops->set_ios)
+		host->ops->set_ios(host, ios);
+
 	sdhci_set_clock(host, ios->clock);
 
 	if (ios->power_mode == MMC_POWER_OFF)
@@ -1615,11 +1618,12 @@ int sdhci_add_host(struct sdhci_host *ho
 	if (host->max_clk == 0) {
 		if (host->ops->get_max_clock)
 			host->max_clk = host->ops->get_max_clock(host);
-		else
+		else {
 			printk(KERN_ERR
 			       "%s: Hardware doesn't specify base clock "
 			       "frequency.\n", mmc_hostname(mmc));
-		return -ENODEV;
+			return -ENODEV;
+		}
 	}
 
 	host->timeout_clk =
@@ -1627,11 +1631,12 @@ int sdhci_add_host(struct sdhci_host *ho
 	if (host->timeout_clk == 0) {
 		if (host->ops->get_timeout_clock)
 			host->timeout_clk = host->ops->get_timeout_clock(host);
-		else
+		else {
 			printk(KERN_ERR
 			       "%s: Hardware doesn't specify timeout clock "
 			       "frequency.\n", mmc_hostname(mmc));
-		return -ENODEV;
+			return -ENODEV;
+		}
 	}
 	if (caps & SDHCI_TIMEOUT_CLK_UNIT)
 		host->timeout_clk *= 1000;
Index: linux.git/drivers/mmc/host/sdhci.h
===================================================================
--- linux.git.orig/drivers/mmc/host/sdhci.h	2008-12-01 19:17:55.000000000 +0000
+++ linux.git/drivers/mmc/host/sdhci.h	2008-12-02 14:36:39.000000000 +0000
@@ -269,6 +269,9 @@ struct sdhci_ops {
 	int		(*enable_dma)(struct sdhci_host *host);
 	unsigned int	(*get_max_clock)(struct sdhci_host *host);
 	unsigned int	(*get_timeout_clock)(struct sdhci_host *host);
+
+	void		(*set_ios)(struct sdhci_host *host,
+				   struct mmc_ios *ios);
 };
 
 

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
