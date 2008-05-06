Return-Path: <linux-kernel-owner+w=401wt.eu-S934250AbYEFXiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934250AbYEFXiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764120AbYEFXg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:36:58 -0400
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:59435 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934099AbYEFXgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:36:50 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+gEozlFC9cDbq+h8CifIpB
Date: Tue, 6 May 2008 16:36:47 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>,
       Anderson Briglia <anderson.briglia@indt.org.br>,
       Syed Khasim <sm.khasim@gmail.com>
Subject: [PATCH] MMC: Fix omap compile by replacing dev_name with
	dma_dev_name
Message-ID: <20080506233647.GL18682@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pierre,

Here's a fix to make omap.c compile again because of a name conflict
introduced by 3efcdd76c4906236f9043c8b34837818177b291d.

Regards,

Tony

--ikeVEW9yuYc//A+q
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="mmc-omap-fix-compile.patch"

>From 3efcdd76c4906236f9043c8b34837818177b291d Mon Sep 17 00:00:00 2001
From: Tony Lindgren <tony@atomide.com>
Date: Tue, 6 May 2008 16:06:06 -0700
Subject: [PATCH] MMC: Fix omap compile by replacing dev_name with dma_dev_name

This patch fixes error:

drivers/mmc/host/omap.c: In function 'mmc_omap_get_dma_channel':
drivers/mmc/host/omap.c:1038: error: called object 'dev_name' is not a function

Commit 06916639e2fed9ee475efef2747a1b7429f8fe76 adds a function
called dev_name. This will cause a name conflict as dev_dbg calls
dev_name(((host->mmc)->parent)).

This same issue should not affect other drivers as they don't seem
to use dev_name with dev_dbg.

Thanks to Paul Walmsley <paul@pwsan.com> for figuring this one out.

Cc: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 14759e9..549517c 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1003,7 +1003,7 @@ static void mmc_omap_dma_cb(int lch, u16 ch_status, void *data)
 
 static int mmc_omap_get_dma_channel(struct mmc_omap_host *host, struct mmc_data *data)
 {
-	const char *dev_name;
+	const char *dma_dev_name;
 	int sync_dev, dma_ch, is_read, r;
 
 	is_read = !(data->flags & MMC_DATA_WRITE);
@@ -1018,21 +1018,21 @@ static int mmc_omap_get_dma_channel(struct mmc_omap_host *host, struct mmc_data
 	if (is_read) {
 		if (host->id == 1) {
 			sync_dev = OMAP_DMA_MMC_RX;
-			dev_name = "MMC1 read";
+			dma_dev_name = "MMC1 read";
 		} else {
 			sync_dev = OMAP_DMA_MMC2_RX;
-			dev_name = "MMC2 read";
+			dma_dev_name = "MMC2 read";
 		}
 	} else {
 		if (host->id == 1) {
 			sync_dev = OMAP_DMA_MMC_TX;
-			dev_name = "MMC1 write";
+			dma_dev_name = "MMC1 write";
 		} else {
 			sync_dev = OMAP_DMA_MMC2_TX;
-			dev_name = "MMC2 write";
+			dma_dev_name = "MMC2 write";
 		}
 	}
-	r = omap_request_dma(sync_dev, dev_name, mmc_omap_dma_cb,
+	r = omap_request_dma(sync_dev, dma_dev_name, mmc_omap_dma_cb,
 			     host, &dma_ch);
 	if (r != 0) {
 		dev_dbg(mmc_dev(host->mmc), "omap_request_dma() failed with %d\n", r);

--ikeVEW9yuYc//A+q--
