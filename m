Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbZFKNTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbZFKNTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbZFKNTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:19:09 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:60965 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753488AbZFKNTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:19:08 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH] mmc_spi: do propper retry managment in the block layer - 4th try
Date: Thu, 11 Jun 2009 14:18:49 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906111518.49431.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

This patch adds a propper retry managment for reading
and writing data blocks for mmc and mmc_spi. Blocks are
retransmitted if the cause of failure might be a transmission
fault. After a permanent failure, we try to read all other
pending sectors, but terminate on write.
This patch was tested with induced transmission errors
by ESD pulses (and survived).

This patch is based on 
[PATCH] mmc_spi: don't use EINVAL for possible transmission errors

Changes from previous version:

(1)  no "o " and indentation in the commit text.
(2)  No dead code (#if 0).
(3)  No noise in dmesg for the cases where a retry 
     solved the issue.
(4)  All three errors (cmd,data,stop) are printed separately.
(5)  On unknown error codes, retain the old behaviour of
     doing retries for read, and fail for write.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---
diff -uprN 2_6_29_rc7_patch_EILSEQ/drivers/mmc/card/block.c 2_6_29_rc7_patch_retries/drivers/mmc/card/block.c
--- 2_6_29_rc7_patch_EILSEQ/drivers/mmc/card/block.c	2009-03-09 17:10:55.000000000 +0100
+++ 2_6_29_rc7_patch_retries/drivers/mmc/card/block.c	2009-06-11 15:07:12.000000000 +0200
@@ -230,12 +230,15 @@ static int mmc_blk_issue_rq(struct mmc_q
 	struct mmc_card *card = md->queue.card;
 	struct mmc_blk_request brq;
 	int ret = 1, disable_multi = 0;
+	int retries = 3;
 
 	mmc_claim_host(card->host);
 
 	do {
 		struct mmc_command cmd;
 		u32 readcmd, writecmd, status = 0;
+		int error = 0;
+		int terminate = 0;
 
 		memset(&brq, 0, sizeof(struct mmc_blk_request));
 		brq.mrq.cmd = &brq.cmd;
@@ -252,9 +255,8 @@ static int mmc_blk_issue_rq(struct mmc_q
 		brq.data.blocks = req->nr_sectors;
 
 		/*
-		 * After a read error, we redo the request one sector at a time
-		 * in order to accurately determine which sectors can be read
-		 * successfully.
+		 * After a transmission error, we switch to single block
+		 * transfer until the problem is solved or we fail.
 		 */
 		if (disable_multi && brq.data.blocks > 1)
 			brq.data.blocks = 1;
@@ -262,10 +264,12 @@ static int mmc_blk_issue_rq(struct mmc_q
 		if (brq.data.blocks > 1) {
 			/* SPI multiblock writes terminate using a special
 			 * token, not a STOP_TRANSMISSION request.
+			 * Here, this request is set for ALL types of
+			 * hosts, so that we can use it in the spi
+			 * driver if the data transfer stage has failed
+			 * and the card is not able to accept the token.
 			 */
-			if (!mmc_host_is_spi(card->host)
-					|| rq_data_dir(req) == READ)
-				brq.mrq.stop = &brq.stop;
+			brq.mrq.stop = &brq.stop;
 			readcmd = MMC_READ_MULTIPLE_BLOCK;
 			writecmd = MMC_WRITE_MULTIPLE_BLOCK;
 		} else {
@@ -312,47 +316,57 @@ static int mmc_blk_issue_rq(struct mmc_q
 
 		mmc_queue_bounce_post(mq);
 
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
-		if (brq.cmd.error) {
-			printk(KERN_ERR "%s: error %d sending read/write "
-			       "command, response %#x, card status %#x\n",
-			       req->rq_disk->disk_name, brq.cmd.error,
-			       brq.cmd.resp[0], status);
-		}
-
-		if (brq.data.error) {
-			if (brq.data.error == -ETIMEDOUT && brq.mrq.stop)
+		pr_debug("%s transfer sector %d count %d\n",
+			 (rq_data_dir(req) == READ) ? "Read" : "Write",
+			 (int)req->sector, (int)brq.data.blocks);
+
+		pr_debug("Cmd error = %d, Data error = %d, Stop error = %d\n",
+			  brq.cmd.error, brq.data.error, brq.stop.error);
+
+		/* Check for errors. */
+		error = brq.cmd.error;
+		if (!error)
+			error = brq.data.error;
+		if (!error)
+			error = brq.stop.error;
+
+		/* Aquire card status. */
+		if (error) {
+			if ((brq.data.error == -ETIMEDOUT)
+			  && brq.mrq.stop && !brq.stop.error)
 				/* 'Stop' response contains card status */
 				status = brq.mrq.stop->resp[0];
-			printk(KERN_ERR "%s: error %d transferring data,"
-			       " sector %u, nr %u, card status %#x\n",
-			       req->rq_disk->disk_name, brq.data.error,
-			       (unsigned)req->sector,
-			       (unsigned)req->nr_sectors, status);
+			else
+				status = get_card_status(card, req);
 		}
 
-		if (brq.stop.error) {
-			printk(KERN_ERR "%s: error %d sending stop command, "
-			       "response %#x, card status %#x\n",
-			       req->rq_disk->disk_name, brq.stop.error,
-			       brq.stop.resp[0], status);
+		/*
+		 * If this is an SD card and we're writing, we can first
+		 * mark the known good sectors as ok.
+		 *
+		 * If the card is not SD, we can still ok written sectors
+		 * as reported by the controller (which might be less than
+		 * the real number of written sectors, but never more).
+		 *
+		 * For read transfers, we report the number of transfered bytes.
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
 		}
 
+		/* Wait until card is ready for new data. This information is
+		 * only available in non-SPI mode. In SPI mode, the busy
+		 * handling is done in the SPI driver.
+		 */
 		if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
 			do {
 				int err;
@@ -374,66 +388,140 @@ static int mmc_blk_issue_rq(struct mmc_q
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
+		/* Error code evaluation */
+		switch (error) {
 
-		/*
-		 * A block was successfully transferred.
-		 */
-		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
-		spin_unlock_irq(&md->lock);
-	} while (ret);
+		/************** Recoverable Errors ********************/
 
-	mmc_release_host(card->host);
+		/* Card has not understand command. As we do only send
+		 * valid commands, this must be a transmission error. */
+		case -EPROTO:	/* fall through */
+
+		/* Transmission error/CRC. */
+		case -EILSEQ:	/* fall through */
+
+		/* Parameter or address error.
+		 * This might be a transmission error. */
+		case -EFAULT:	/* fall through */
+
+		/* Function not implemented.
+		 * This MUST be a transmission error. All cards
+		 * have to respond to read/write commands. */
+		case -ENOSYS:	/* fall through */
+
+		/* Erase response codes.
+		 * These MUST be transmission errors, because
+		 * erase codes are no valid responses after a
+		 * read/write command. */
+		case -EIO:	/* fall through */
+
+		/* Timeout, no answer. This might be a transmission error
+		 * host -> card or a real timeout. If we repeat the command,
+		 * we do an overall slowdown and have good chances to
+		 * complete the transfer even in case of a real timeout. */
+		case -ETIMEDOUT:
+			/* Common transmission fault handling. */
+			disable_multi = 1;
+			if (--retries > 0)
+				break;
+			/* Do not continue after a write fail. */
+			if (rq_data_dir(req) != READ)
+				terminate = 1;
+			goto report_error;
+
+		/******** Non-recoverable Errors ********************/
+
+		/* Request cannot be performed because of restrictions
+		 * in hardware and/or the driver. */
+		case -EINVAL:	/* fall through */
+
+		/* Host can determine that the slot is empty and is
+		 * actively failing requests. */
+		case -ENOMEDIUM:/* fall through */
+
+		/* No memory inside the driver. */
+		case -ENOMEM:
+			/* Common non-recoverable fault handling. */
+			terminate = 1;
+			goto report_error;
+
+		/*********************** Misc ************************/
+
+		case 0:	/* no error: continue, reset error variables */
+			disable_multi = 0;
+			retries = 3;
+			break;
+
+		/* We do not know this particular error code.
+		 * So we default to the old "proven" behaviour
+		 * and do retries for read requests, and fail
+		 * for write requests. */
+		default:
+			if (rq_data_dir(req) != READ) {
+				terminate = 1;
+				goto report_error;
+			}
+			disable_multi = 1;
+			if (--retries > 0)
+				break;
+
+report_error:		/* A non-recoverable error has occured.
+			 * Report this error. */
+
+			if (brq.cmd.error) {
+				printk(KERN_ERR "%s: error %d sending "
+				       "read/write command, response %#x, "
+				       "card status %#x\n",
+				       req->rq_disk->disk_name, brq.cmd.error,
+				       brq.cmd.resp[0], status);
+			}
 
-	return 1;
+			if (brq.data.error) {
+				printk(KERN_ERR "%s: error %d transferring "
+				       "data, sector %u, nr %u, card status "
+				       "%#x\n",
+				       req->rq_disk->disk_name,
+				       brq.data.error,
+				       (unsigned)req->sector,
+				       (unsigned)req->nr_sectors, status);
+			}
 
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
+			if (brq.stop.error) {
+				printk(KERN_ERR "%s: error %d sending stop "
+				       "command, response %#x, card status "
+				       "%#x\n",
+				       req->rq_disk->disk_name,
+				       brq.stop.error,
+				       brq.stop.resp[0], status);
+			}
 
-		blocks = mmc_sd_num_wr_blocks(card);
-		if (blocks != (u32)-1) {
+			/* Report the failure to the block layer. */
 			spin_lock_irq(&md->lock);
-			ret = __blk_end_request(req, 0, blocks << 9);
+			ret = __blk_end_request(req, -EIO,
+				(brq.data.blocks * brq.data.blksz)
+			       - brq.data.bytes_xfered);
 			spin_unlock_irq(&md->lock);
+
+			/* reset error variables */
+			disable_multi = 0;
+			retries = 3;
+
+			if (terminate)
+				goto cmd_err;
+
+			break;
 		}
-	} else {
-		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
-		spin_unlock_irq(&md->lock);
-	}
 
+	/* repeat until no more sectors left */
+	} while (ret);
+
+	mmc_release_host(card->host);
+
+	return 1;
+
+cmd_err:
 	mmc_release_host(card->host);
 
 	spin_lock_irq(&md->lock);
diff -uprN 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch_retries/drivers/mmc/host/mmc_spi.c
--- 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c	2009-05-26 09:37:28.000000000 +0200
+++ 2_6_29_rc7_patch_retries/drivers/mmc/host/mmc_spi.c	2009-05-26 11:30:33.000000000 +0200
@@ -743,22 +743,24 @@ mmc_spi_writeblock(struct mmc_spi_host *
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
+		 * only if the data stage has no transmission error.
+		 * If the data stage has a transmission error, send the
+		 * STOP command because there is a great chance that the
+		 * SPI stop token was not accepted by the card.
+		 */
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
