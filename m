Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbYJCPMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbYJCPMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYJCPL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:11:57 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:34314 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbYJCPL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:11:57 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel@avr32linux.org, Hein_Tibosch <hein_tibosch@yahoo.es>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] atmel-mci: Initialize BLKR before sending data transfer command
Date: Fri,  3 Oct 2008 17:07:38 +0200
Message-Id: <1223046458-10851-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 03 Oct 2008 15:07:23.0266 (UTC) FILETIME=[BD30DE20:01C92569]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atmel-mci driver sometimes fails data transfers like this:

   mmcblk0: error -5 transferring data
   end_request: I/O error, dev mmcblk0, sector 2749769
   end_request: I/O error, dev mmcblk0, sector 2749777

It turns out that this might be caused by the BLKR register (which
contains the block size and the number of blocks being transfered) being
initialized too late. This patch moves the initialization of BLKR so
that it contains the correct value before the block transfer command is
sent.

This error is difficult to reproduce, but if you insert a long delay
(mdelay(10) or thereabouts) between the calls to atmci_start_command()
and atmci_submit_data(), all transfers seem to fail without this patch,
while I haven't seen any failures with this patch.

Reported-by: Hein_Tibosch <hein_tibosch@yahoo.es>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mmc/host/atmel-mci.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 917035e..0000896 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -426,8 +426,6 @@ static u32 atmci_submit_data(struct mmc_host *mmc, struct mmc_data *data)
 	host->sg = NULL;
 	host->data = data;
 
-	mci_writel(host, BLKR, MCI_BCNT(data->blocks)
-			| MCI_BLKLEN(data->blksz));
 	dev_vdbg(&mmc->class_dev, "BLKR=0x%08x\n",
 			MCI_BCNT(data->blocks) | MCI_BLKLEN(data->blksz));
 
@@ -483,6 +481,10 @@ static void atmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 		if (data->blocks > 1 && data->blksz & 3)
 			goto fail;
 		atmci_set_timeout(host, data);
+
+		/* Must set block count/size before sending command */
+		mci_writel(host, BLKR, MCI_BCNT(data->blocks)
+				| MCI_BLKLEN(data->blksz));
 	}
 
 	iflags = MCI_CMDRDY;
-- 
1.5.6.5

