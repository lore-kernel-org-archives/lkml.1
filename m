Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbYKCUK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbYKCUK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbYKCUKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:10:16 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:36615 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754184AbYKCUKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:10:13 -0500
Message-Id: <20081103201010.464075837@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 03 Nov 2008 20:09:48 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, sdhci-devel@list.drzeus.cx,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 4/7] SDHCI: Add quirk for controller with no end-of-busy IRQ
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
--- linux.git.orig/drivers/mmc/host/sdhci.c	2008-11-03 10:01:03.000000000 +0000
+++ linux.git/drivers/mmc/host/sdhci.c	2008-11-03 12:20:40.000000000 +0000
@@ -1291,11 +1291,24 @@ static void sdhci_cmd_irq(struct sdhci_h
 	 *       controllers.
 	 */
 	if (host->cmd->flags & MMC_RSP_BUSY) {
+		u32 present;
+
 		if (host->cmd->data)
 			DBG("Cannot wait for busy signal when also "
 				"doing a data transfer");
-		else
+		else if (!(host->quirks & SDHCI_QUIRK_NO_TCIRQ_ON_NOT_BUSY))
 			return;
+
+		/* The Samsung SDHCI does not seem to provide an INT_DATA_END
+		 * when the system goes non-busy, so check the state of the
+		 * transfer by reading SDHCI_PRESENT_STATE to see if the
+		 * controller is ready
+		 */
+
+		present = readl(host->ioaddr + SDHCI_PRESENT_STATE);
+		DBG("busy? present %08x, intstat %08x\n", present, intmask);
+
+		/* fall through and take the SDHCI_INT_RESPONSE */
 	}
 
 	if (intmask & SDHCI_INT_RESPONSE)
Index: linux.git/drivers/mmc/host/sdhci.h
===================================================================
--- linux.git.orig/drivers/mmc/host/sdhci.h	2008-11-03 10:01:03.000000000 +0000
+++ linux.git/drivers/mmc/host/sdhci.h	2008-11-03 12:20:00.000000000 +0000
@@ -57,6 +57,7 @@
 #define  SDHCI_DATA_AVAILABLE	0x00000800
 #define  SDHCI_CARD_PRESENT	0x00010000
 #define  SDHCI_WRITE_PROTECT	0x00080000
+#define  SDHCI_DATA_BIT(x)	(1 << ((x) + 20))
 
 #define SDHCI_HOST_CONTROL 	0x28
 #define  SDHCI_CTRL_LED		0x01
@@ -210,6 +211,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_BROKEN_SMALL_PIO			(1<<13)
 /* Controller supports high speed but doesn't have the caps bit set */
 #define SDHCI_QUIRK_FORCE_HIGHSPEED			(1<<14)
+/* Controller does not provide transfer-complete interrupt when not busy */
+#define SDHCI_QUIRK_NO_TCIRQ_ON_NOT_BUSY		(1<<15)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
