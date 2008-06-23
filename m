Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbYFWOLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbYFWOLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 10:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYFWOLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 10:11:16 -0400
Received: from mail.queued.net ([207.210.101.209]:2496 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbYFWOLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:11:15 -0400
Date: Mon, 23 Jun 2008 10:13:52 -0400
From: Andres Salomon <dilinger@queued.net>
To: akpm@linux-foundation.org
Cc: drzeus-sdhci@drzeus.cx, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [OLPC] sdhci: add quirk for the Marvell CaFe's interrupt
 timeout
Message-ID: <20080623101352.3bbaf5b0@xo-debian>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The CaFe chip has a hardware bug that ends up with us getting a timeout
value that's too small, causing the following sorts of problems:

[   60.525138] mmcblk0: error -110 transferring data
[   60.531477] end_request: I/O error, dev mmcblk0, sector 1484353
[   60.533371] Buffer I/O error on device mmcblk0p2, logical block 181632
[   60.533371] lost page write due to I/O error on mmcblk0p2

Presumably this is an off-by-one error in the hardware.  Incrementing
the timeout count value that we stuff into the TIMEOUT_CONTROL register
gets us a value that works.  This bug was originally discovered by
Pierre Ossman, I believe.

[thanks to Robert Millan for proving that this was still a problem]

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/mmc/host/sdhci.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 5b74c8c..2b3f06a 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -57,6 +57,8 @@ static unsigned int debug_quirks = 0;
 #define SDHCI_QUIRK_RESET_AFTER_REQUEST			(1<<8)
 /* Controller needs voltage and power writes to happen separately */
 #define SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER		(1<<9)
+/* Controller has an off-by-one issue with timeout value */
+#define SDHCI_QUIRK_INCR_TIMEOUT_CONTROL		(1<<10)
 
 static const struct pci_device_id pci_ids[] __devinitdata = {
 	{
@@ -134,7 +136,8 @@ static const struct pci_device_id pci_ids[] __devinitdata = {
 		.device         = PCI_DEVICE_ID_MARVELL_CAFE_SD,
 		.subvendor      = PCI_ANY_ID,
 		.subdevice      = PCI_ANY_ID,
-		.driver_data    = SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER,
+		.driver_data    = SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER |
+				  SDHCI_QUIRK_INCR_TIMEOUT_CONTROL,
 	},
 
 	{
@@ -479,6 +482,13 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 			break;
 	}
 
+	/*
+	 * Compensate for an off-by-one error in the CaFe hardware; otherwise,
+	 * a too-small count gives us interrupt timeouts.
+	 */
+	if ((host->chip->quirks & SDHCI_QUIRK_INCR_TIMEOUT_CONTROL))
+		count++;
+
 	if (count >= 0xF) {
 		printk(KERN_WARNING "%s: Too large timeout requested!\n",
 			mmc_hostname(host->mmc));
-- 
1.5.5.3

