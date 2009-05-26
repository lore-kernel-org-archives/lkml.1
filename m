Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZEZLMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZEZLMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 07:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZEZLMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 07:12:13 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:6192 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751364AbZEZLMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 07:12:12 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH] mmc_spi: do propper retry managment in the block layer - 3rd try
Date: Tue, 26 May 2009 12:11:45 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905261311.45725.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

o This patch adds a propper retry managment for reading
  and writing data blocks for mmc and mmc_spi. Blocks are
  retransmitted if the cause of failure might be a transmission
  fault. After a permanent failure, we try to read all other
  pending sectors, but terminate on write.
  This patch was tested with induced transmission errors
  by ESD pulses (and survived).

This patch is based on 
[PATCH] mmc_spi: don't use EINVAL for possible transmission errors

Suggested changes from Matt Fleming and David Brownell are
incorporated.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---
diff -uprN 2_6_29_rc7_patch_EILSEQ/drivers/mmc/card/block.c 2_6_29_rc7_patch_retries/drivers/mmc/card/block.c
--- 2_6_29_rc7_patch_EILSEQ/drivers/mmc/card/block.c	2009-03-09 17:10:55.000000000 +0100
+++ 2_6_29_rc7_patch_retries/drivers/mmc/card/block.c	2009-05-18 15:00:41.000000000 +0200
@@ -230,12 +230,14 @@ static int mmc_blk_issue_rq(struct mmc_q
 	struct mmc_card *card = md->queue.card;
 	struct mmc_blk_request brq;
 	int ret = 1, disable_multi = 0;
+	int retries = 3;

 	mmc_claim_host(card->host);

 	do {
 		struct mmc_command cmd;
 		u32 readcmd, writecmd, status = 0;
+		int error = 0;

 		memset(&brq, 0, sizeof(struct mmc_blk_request));
 		brq.mrq.cmd = &brq.cmd;
@@ -251,10 +253,8 @@ static int mmc_blk_issue_rq(struct mmc_q
 		brq.stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
 		brq.data.blocks = req->nr_sectors;

-		/*
-		 * After a read error, we redo the request one sector at a time
-		 * in order to accurately determine which sectors can be read
-		 * successfully.
+		/* After an transmission error, we switch to single block
+		 * transfer until the problem is solved or we fail.
 		 */
 		if (disable_multi && brq.data.blocks > 1)
 			brq.data.blocks = 1;
@@ -262,10 +262,12 @@ static int mmc_blk_issue_rq(struct mmc_q
 		if (brq.data.blocks > 1) {
 			/* SPI multiblock writes terminate using a special
 			 * token, not a STOP_TRANSMISSION request.
+			 * Here, this request is set for ALL types of
+			 * hosts, so that we can use it in the lower
+			 * layers if the data transfer stage has failed
+			 * and the card is not able to accept the token.
 			 */
-			if (!mmc_host_is_spi(card->host)
-					|| rq_data_dir(req) == READ)
-				brq.mrq.stop = &brq.stop;
+			brq.mrq.stop = &brq.stop;
 			readcmd = MMC_READ_MULTIPLE_BLOCK;
 			writecmd = MMC_WRITE_MULTIPLE_BLOCK;
 		} else {
@@ -311,52 +313,71 @@ static int mmc_blk_issue_rq(struct mmc_q
 		mmc_wait_for_req(card->host, &brq.mrq);

 		mmc_queue_bounce_post(mq);
-
-		/*
-		 * Check for errors here, but don't jump to cmd_err
-		 * until later as we need to wait for the card to leave
-		 * programming mode even when things go wrong.
-		 */
-		if (brq.cmd.error || brq.data.error || brq.stop.error) {
-			if (brq.data.blocks > 1 && rq_data_dir(req) == READ) {
-				/* Redo read one sector at a time */
-				printk(KERN_WARNING "%s: retrying using single "
-				       "block read\n", req->rq_disk->disk_name);
-				disable_multi = 1;
-				continue;
-			}
-			status = get_card_status(card, req);
-		}
-
+#if 0
+		printk(KERN_INFO "%s transfer sector %d count %d\n",
+			(rq_data_dir(req) == READ) ? "Read" : "Write",
+			(int)req->sector, (int)brq.data.blocks);
+#endif
+		/* Error reporting */
 		if (brq.cmd.error) {
+			error = brq.cmd.error;
+			status = get_card_status(card, req);
 			printk(KERN_ERR "%s: error %d sending read/write "
 			       "command, response %#x, card status %#x\n",
 			       req->rq_disk->disk_name, brq.cmd.error,
 			       brq.cmd.resp[0], status);
-		}
-
-		if (brq.data.error) {
-			if (brq.data.error == -ETIMEDOUT && brq.mrq.stop)
+		} else if (brq.data.error) {
+			error = brq.data.error;
+			if ((brq.data.error == -ETIMEDOUT)
+			    && brq.mrq.stop && !brq.stop.error)
 				/* 'Stop' response contains card status */
 				status = brq.mrq.stop->resp[0];
+			else
+				status = get_card_status(card, req);
 			printk(KERN_ERR "%s: error %d transferring data,"
 			       " sector %u, nr %u, card status %#x\n",
 			       req->rq_disk->disk_name, brq.data.error,
 			       (unsigned)req->sector,
 			       (unsigned)req->nr_sectors, status);
-		}
-
-		if (brq.stop.error) {
+		} else if (brq.stop.error) {
+			error = brq.stop.error;
+			status = get_card_status(card, req);
 			printk(KERN_ERR "%s: error %d sending stop command, "
 			       "response %#x, card status %#x\n",
 			       req->rq_disk->disk_name, brq.stop.error,
 			       brq.stop.resp[0], status);
 		}

+		/*
+		 * If this is an SD card and we're writing, we can first
+		 * mark the known good sectors as ok.
+		 *
+		 * If the card is not SD, we can still ok written sectors
+		 * as reported by the controller (which might be less than
+		 * the real number of written sectors, but never more).
+		 *
+		 * For read transfers, we report the number of tranfered bytes.
+		 */
+		if (error && mmc_card_sd(card) && (rq_data_dir(req) != READ)) {
+			u32 blocks;
+
+			blocks = mmc_sd_num_wr_blocks(card);
+			if (blocks != (u32)-1)
+				brq.data.bytes_xfered = blocks << 9;
+		}
+		if (brq.data.bytes_xfered) {
+			spin_lock_irq(&md->lock);
+			ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
+			spin_unlock_irq(&md->lock);
+		}
+
+		/* Wait until card is ready for new data. This information is
+		 * only available in non-SPI mode. In SPI mode, the busy
+		 * handling is done in the SPI driver.
+		 */
 		if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
 			do {
 				int err;
-
 				cmd.opcode = MMC_SEND_STATUS;
 				cmd.arg = card->rca << 16;
 				cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
@@ -374,66 +395,63 @@ static int mmc_blk_issue_rq(struct mmc_q
 			} while (!(cmd.resp[0] & R1_READY_FOR_DATA) ||
 				(R1_CURRENT_STATE(cmd.resp[0]) == 7));

-#if 0
-			if (cmd.resp[0] & ~0x00000900)
-				printk(KERN_ERR "%s: status = %08x\n",
-				       req->rq_disk->disk_name, cmd.resp[0]);
-			if (mmc_decode_status(cmd.resp))
-				goto cmd_err;
-#endif
 		}

-		if (brq.cmd.error || brq.stop.error || brq.data.error) {
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
-		}
+		/* Do retries for all sort of transmission errors */
+		switch (error) {

-		/*
-		 * A block was successfully transferred.
+		case 0:	/* no error: continue, reset error variables */
+			disable_multi = 0;
+			retries = 3;
+			break;
+
+		/* Card has not understand command. As we do only send
+		 * valid commands, this must be a transmission error. */
+		case -EPROTO:	/* fall through */
+
+		/* Transmission error */
+		case -EILSEQ:	/* fall through */
+
+		/* Timeout, no answer. This might be a transmission error
+		 * host -> card or a real timeout. If we repeat the command,
+		 * we do an overall slowdown and have good chances to
+		 * complete the transfer even in case of a real timeout.
 		 */
-		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
-		spin_unlock_irq(&md->lock);
+		case -ETIMEDOUT:
+			disable_multi = 1;
+			if (--retries > 0)
+				break;
+			/* Fall through */
+
+		/* non-recoverable error or retries exhausted */
+		default:
+			/* Terminate, if transfer direction is write.
+			 * We are not allowed to continue after a non-
+			 * recoverable write!
+			 */
+			if (rq_data_dir(req) != READ)
+				goto cmd_err;
+			/* If transfer direction is read, report error
+			 * for this sector and continue to read
+			 * the rest. Get all available information!
+			 */
+			spin_lock_irq(&md->lock);
+			ret = __blk_end_request(req, -EIO, brq.data.blksz);
+			spin_unlock_irq(&md->lock);
+			/* reset error variables */
+			disable_multi = 0;
+			retries = 3;
+			break;
+		}
+
+	/* repeat until no more sectors left */
 	} while (ret);

 	mmc_release_host(card->host);

 	return 1;

- cmd_err:
- 	/*
- 	 * If this is an SD card and we're writing, we can first
- 	 * mark the known good sectors as ok.
- 	 *
-	 * If the card is not SD, we can still ok written sectors
-	 * as reported by the controller (which might be less than
-	 * the real number of written sectors, but never more).
-	 */
-	if (mmc_card_sd(card)) {
-		u32 blocks;
-
-		blocks = mmc_sd_num_wr_blocks(card);
-		if (blocks != (u32)-1) {
-			spin_lock_irq(&md->lock);
-			ret = __blk_end_request(req, 0, blocks << 9);
-			spin_unlock_irq(&md->lock);
-		}
-	} else {
-		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
-		spin_unlock_irq(&md->lock);
-	}
-
+cmd_err:
 	mmc_release_host(card->host);

 	spin_lock_irq(&md->lock);
diff -uprN 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch_retries/drivers/mmc/host/mmc_spi.c
--- 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c	2009-05-14 12:49:42.000000000 +0200
+++ 2_6_29_rc7_patch_retries/drivers/mmc/host/mmc_spi.c	2009-05-14 15:01:15.000000000 +0200
@@ -743,12 +743,11 @@ mmc_spi_writeblock(struct mmc_spi_host *
 	if (status != 0) {
 		dev_dbg(&spi->dev, "write error %02x (%d)\n",
 			scratch->status[0], status);
-		return status;
-	}
-
+	} else {
 	t->tx_buf += t->len;
 	if (host->dma_dev)
 		t->tx_dma += t->len;
+	}

 	/* Return when not busy.  If we didn't collect that status yet,
 	 * we'll need some more I/O.
@@ -756,9 +755,12 @@ mmc_spi_writeblock(struct mmc_spi_host *
 	for (i = 4; i < sizeof(scratch->status); i++) {
 		/* card is non-busy if the most recent bit is 1 */
 		if (scratch->status[i] & 0x01)
-			return 0;
+		return status;
 	}
-	return mmc_spi_wait_unbusy(host, timeout);
+	i = mmc_spi_wait_unbusy(host, timeout);
+	if (!status)
+		status = i;
+	return status;
 }

 /*
@@ -1087,7 +1089,15 @@ static void mmc_spi_request(struct mmc_h
 	status = mmc_spi_command_send(host, mrq, mrq->cmd, mrq->data != NULL);
 	if (status == 0 && mrq->data) {
 		mmc_spi_data_do(host, mrq->cmd, mrq->data, mrq->data->blksz);
-		if (mrq->stop)
+		/* filter-out the stop command for multiblock writes,
+		* only if the data stage has no transmission error.
+		* If the data stage has a transmission error, send the
+		* STOP command because there is a great chance that the
+		* SPI stop token was not accepted by the card.
+		*/
+		if (mrq->stop &&
+		  ((mrq->data->flags & MMC_DATA_READ)
+		 || mrq->data->error))
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
