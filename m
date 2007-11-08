Return-Path: <linux-kernel-owner+w=401wt.eu-S1759516AbXKHIYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516AbXKHIYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 03:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbXKHIYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 03:24:12 -0500
Received: from grex.cyberspace.org ([216.86.77.194]:46698 "EHLO
	grex.cyberspace.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbXKHIYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 03:24:11 -0500
Date: Thu, 8 Nov 2007 03:24:10 -0500
From: Roopesh <roopesh@cyberspace.org>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: MMC/SD: Write operation in invalid states by borken cards.
Message-ID: <20071108082410.GA1875@grex.cyberspace.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi, 

 If a write operation fails, shouldnt we still check for the card 
 state to be 'ready to accept next data'?

 This question is because I have noticed that some (broken) cards 
 fail the write command, and the immediately issued subsequent 
 commands also fail since the card state was never checked before 
 sending these commands.
 (There was a discussion about these cards at the thread: "MMC: 
 CRC Errors with 2GB cards)

diff -a -u -p -r1.2 block.c
--- drivers/mmc/card/block.c	22 Oct 2007 10:39:44 -0000	1.2
+++ drivers/mmc/card/block.c	8 Nov 2007 06:55:37 -0000
@@ -206,6 +206,7 @@ static int mmc_blk_issue_rq(struct mmc_q
 	struct mmc_card *card = md->queue.card;
 	struct mmc_blk_request brq;
 	int ret = 1, sg_pos, data_size;
+	int data_error = 0;
 
 	mmc_claim_host(card->host);
 
@@ -282,19 +283,19 @@ static int mmc_blk_issue_rq(struct mmc_q
 		if (brq.cmd.error) {
 			printk(KERN_ERR "%s: error %d sending read/write command\n",
 			       req->rq_disk->disk_name, brq.cmd.error);
-			goto cmd_err;
+			data_error = 1;
 		}
 
 		if (brq.data.error) {
 			printk(KERN_ERR "%s: error %d transferring data\n",
 			       req->rq_disk->disk_name, brq.data.error);
-			goto cmd_err;
+			data_error = 1;
 		}
 
 		if (brq.stop.error) {
 			printk(KERN_ERR "%s: error %d sending stop command\n",
 			       req->rq_disk->disk_name, brq.stop.error);
-			goto cmd_err;
+			data_error = 1;
 		}
 
 		if (rq_data_dir(req) != READ) {
@@ -320,6 +321,9 @@ static int mmc_blk_issue_rq(struct mmc_q
 				goto cmd_err;
 #endif
 		}
+
+		if (data_error == 1)
+			goto cmd_err;
 
 		/*
 		 * A block was successfully transferred.
 

 Thanks,
 Roopesh.
