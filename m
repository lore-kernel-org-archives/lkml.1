Return-Path: <linux-kernel-owner+w=401wt.eu-S1764099AbZDHJ4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764099AbZDHJ4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757026AbZDHJ4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:56:09 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:3100 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751840AbZDHJ4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:56:07 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH] mmc_spi: do propper retry managment in the block layer
Date: Wed, 8 Apr 2009 10:55:53 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904081155.53173.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

o This patch adds a propper retry managment for reading
  and writing data blocks for mmc and mmc_spi. Blocks are
  retransmitted 2 times in case of a transmission failure.
  This patch was tested with induced transmission errors
  by ESD pulses (and survived).

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---

diff -uprN 2_6_29_rc7_patch_wearout_speedup/drivers/mmc/card/block.c 2_6_29_rc7_patch_retries/drivers/mmc/card/block.c
--- 2_6_29_rc7_patch_wearout_speedup/drivers/mmc/card/block.c	2009-03-09 17:10:55.000000000 +0100
+++ 2_6_29_rc7_patch_retries/drivers/mmc/card/block.c	2009-04-08 11:19:55.000000000 +0200
@@ -230,12 +230,14 @@ static int mmc_blk_issue_rq(struct mmc_q
 	struct mmc_card *card = md->queue.card;
 	struct mmc_blk_request brq;
 	int ret = 1, disable_multi = 0;
+	int error_retry_count = 3;
 
 	mmc_claim_host(card->host);
 
 	do {
 		struct mmc_command cmd;
 		u32 readcmd, writecmd, status = 0;
+		int error;
 
 		memset(&brq, 0, sizeof(struct mmc_blk_request));
 		brq.mrq.cmd = &brq.cmd;
@@ -252,9 +254,9 @@ static int mmc_blk_issue_rq(struct mmc_q
 		brq.data.blocks = req->nr_sectors;
 
 		/*
-		 * After a read error, we redo the request one sector at a time
-		 * in order to accurately determine which sectors can be read
-		 * successfully.
+		 * After a transmission error, we redo the request one sector
+		 * at a time in order to accurately determine which sectors
+		 * can be read/written successfully.
 		 */
 		if (disable_multi && brq.data.blocks > 1)
 			brq.data.blocks = 1;
@@ -262,10 +264,12 @@ static int mmc_blk_issue_rq(struct mmc_q
 		if (brq.data.blocks > 1) {
 			/* SPI multiblock writes terminate using a special
 			 * token, not a STOP_TRANSMISSION request.
-			 */
-			if (!mmc_host_is_spi(card->host)
-					|| rq_data_dir(req) == READ)
-				brq.mrq.stop = &brq.stop;
+			 * Here, this request is set for all types of
+			 * hosts, so that we can use it in the lower
+			 * layers if the data transfer stage has failed
+			 * and the card is not able to accept the token.
+			*/
+			brq.mrq.stop = &brq.stop;
 			readcmd = MMC_READ_MULTIPLE_BLOCK;
 			writecmd = MMC_WRITE_MULTIPLE_BLOCK;
 		} else {
@@ -312,20 +316,44 @@ static int mmc_blk_issue_rq(struct mmc_q
 
 		mmc_queue_bounce_post(mq);
 
-		/*
-		 * Check for errors here, but don't jump to cmd_err
-		 * until later as we need to wait for the card to leave
-		 * programming mode even when things go wrong.
+		/* Check for all sort of errors which might be
+		 * a transmission fault.
 		 */
-		if (brq.cmd.error || brq.data.error || brq.stop.error) {
-			if (brq.data.blocks > 1 && rq_data_dir(req) == READ) {
-				/* Redo read one sector at a time */
-				printk(KERN_WARNING "%s: retrying using single "
-				       "block read\n", req->rq_disk->disk_name);
-				disable_multi = 1;
-				continue;
-			}
+		error = brq.cmd.error;
+		if (!error)
+			error = brq.data.error;
+		if (!error)
+			error = brq.stop.error;
+		/* Do retries for all sort of transmission errors */
+		switch (error) {
+		/* Card has not understand command. As we do only send
+		 * valid commands, this must be a transmission error.
+		 */
+		case -EPROTO:
+		/* CRC error */
+		case -EILSEQ:
+		/* Timeout, no answer. If we repeat the command,
+		 * we do an overall slowdown and have good chances to
+		 * complete the transfer.
+		 */
+		case -ETIMEDOUT:
+		/* Invalid response. This is most likely a transmission
+		 * error from card to host.
+		 */
+		case -EINVAL:
+			error_retry_count -= 1;
+			disable_multi = 1;
+			printk(KERN_WARNING "%s: transmission error %d\n",
+				req->rq_disk->disk_name, error);
 			status = get_card_status(card, req);
+			if (error_retry_count > 0)
+				continue;
+			break;
+		case 0:	 /* no error: reset retry count for next block. */
+			error_retry_count = 3;
+			break;
+		default: /* unknown error: do error handling below */
+			break;
 		}
 
 		if (brq.cmd.error) {
@@ -384,18 +412,15 @@ static int mmc_blk_issue_rq(struct mmc_q
 		}
 
 		if (brq.cmd.error || brq.stop.error || brq.data.error) {
-			if (rq_data_dir(req) == READ) {
-				/*
-				 * After an error, we redo I/O one sector at a
-				 * time, so we only reach here after trying to
-				 * read a single sector.
-				 */
-				spin_lock_irq(&md->lock);
-				ret = __blk_end_request(req, -EIO, brq.data.blksz);
-				spin_unlock_irq(&md->lock);
-				continue;
-			}
-			goto cmd_err;
+			/*
+			 * After an error, we redo I/O one sector at a
+			 * time, so we only reach here after trying to
+			 * read/write a single sector.
+			 */
+			spin_lock_irq(&md->lock);
+			ret = __blk_end_request(req, -EIO, brq.data.blksz);
+			spin_unlock_irq(&md->lock);
+			continue;
 		}
 
 		/*
diff -uprN 2_6_29_rc7_patch_wearout_speedup/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch_retries/drivers/mmc/host/mmc_spi.c
--- 2_6_29_rc7_patch_wearout_speedup/drivers/mmc/host/mmc_spi.c	2009-04-08 11:11:20.000000000 +0200
+++ 2_6_29_rc7_patch_retries/drivers/mmc/host/mmc_spi.c	2009-04-08 11:25:04.000000000 +0200
@@ -742,22 +742,24 @@ mmc_spi_writeblock(struct mmc_spi_host *
 	if (status != 0) {
 		dev_dbg(&spi->dev, "write error %02x (%d)\n",
 			scratch->status[0], status);
-		return status;
+	} else {
+		t->tx_buf += t->len;
+		if (host->dma_dev)
+			t->tx_dma += t->len;
 	}
 
-	t->tx_buf += t->len;
-	if (host->dma_dev)
-		t->tx_dma += t->len;
-
 	/* Return when not busy.  If we didn't collect that status yet,
 	 * we'll need some more I/O.
 	 */
 	for (i = 4; i < sizeof(scratch->status); i++) {
 		/* card is non-busy if the most recent bit is 1 */
 		if (scratch->status[i] & 0x01)
-			return 0;
+			return status;
 	}
-	return mmc_spi_wait_unbusy(host, timeout);
+	i = mmc_spi_wait_unbusy(host, timeout);
+	if (!status)
+		status = i;
+	return status;
 }
 
 /*
@@ -1086,7 +1088,15 @@ static void mmc_spi_request(struct mmc_h
 	status = mmc_spi_command_send(host, mrq, mrq->cmd, mrq->data != NULL);
 	if (status == 0 && mrq->data) {
 		mmc_spi_data_do(host, mrq->cmd, mrq->data, mrq->data->blksz);
-		if (mrq->stop)
+		/* filter-out the stop command for multiblock writes,
+		 * only if the data stage has no transmission error.
+		 * If the data stage has a transmission error, send the
+		 * STOP command because there is a great chance that the
+		 * SPI stop token was not accepted by the card.
+		 */
+		if (mrq->stop &&
+			((mrq->data->flags & MMC_DATA_READ)
+		       || mrq->data->error))
 			status = mmc_spi_command_send(host, mrq, mrq->stop, 0);
 		else
 			mmc_cs_off(host);
 
---
regards

i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
