Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbYLBPlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbYLBPlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:41:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYLBPkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:40:52 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:34934 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751259AbYLBPkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:40:51 -0500
Message-Id: <20081202154112.488066220@fluff.org.uk>
References: <20081202154018.906091477@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 15:40:22 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       drzeus-sdhci@drzeus.cx
Cc: Ben Dooks <ben-linux@fluff.org>
Subject: [patch 4/8] SDHCI: Add quirk for controller with no end-of-busy IRQ
Content-Disposition: inline; filename=simtec/s3c64xx/sdhci-add-no-busy-transfer-finish-irq-quirk.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Samsung SDHCI controller block seems to fail to generate an
INT_DATA_END after the transfer has completed and the bus busy
state finished. 

Changes in e809517f6fa5803a5a1cd56026f0e2190fc13d5c to use the
new busy method are the cause of the behaviour change.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux.git/drivers/mmc/host/sdhci.c
===================================================================
--- linux.git.orig/drivers/mmc/host/sdhci.c	2008-12-01 19:31:15.000000000 +0000
+++ linux.git/drivers/mmc/host/sdhci.c	2008-12-01 19:43:30.000000000 +0000
@@ -1294,8 +1294,11 @@ static void sdhci_cmd_irq(struct sdhci_h
 		if (host->cmd->data)
 			DBG("Cannot wait for busy signal when also "
 				"doing a data transfer");
-		else
+		else if (!(host->quirks & SDHCI_QUIRK_NO_BUSY_IRQ))
 			return;
+
+		/* The controller does not support the end-of-busy IRQ,
+		 * fall through and take the SDHCI_INT_RESPONSE */
 	}
 
 	if (intmask & SDHCI_INT_RESPONSE)
Index: linux.git/drivers/mmc/host/sdhci.h
===================================================================
--- linux.git.orig/drivers/mmc/host/sdhci.h	2008-12-01 19:31:15.000000000 +0000
+++ linux.git/drivers/mmc/host/sdhci.h	2008-12-01 19:42:27.000000000 +0000
@@ -210,6 +210,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_BROKEN_SMALL_PIO			(1<<13)
 /* Controller supports high speed but doesn't have the caps bit set */
 #define SDHCI_QUIRK_FORCE_HIGHSPEED			(1<<14)
+/* Controller does not provide transfer-complete interrupt when not busy */
+#define SDHCI_QUIRK_NO_BUSY_IRQ			(1<<15)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
