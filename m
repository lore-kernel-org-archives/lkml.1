Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbZEDIM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbZEDIM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 04:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbZEDIJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 04:09:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:57234 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbZEDIJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 04:09:44 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com,
       stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp,
       zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com,
       sfr@canb.auug.org.au, grant.likely@secretlab.ca,
       paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com,
       adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org,
       schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net,
       rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com,
       bharrosh@panasas.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/11] nbd: don't clear rq->sector and nr_sectors unnecessarily
Date: Mon,  4 May 2009 16:58:37 +0900
Message-Id: <1241423927-11871-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1241423927-11871-1-git-send-email-tj@kernel.org>
References: <1241423927-11871-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 04 May 2009 07:58:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason to clear rq->sector and nr_sectors after calling
blk_rq_init().  They're guaranteed to be clear.  Drop unnecessary
clearing.

[ Impact: cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul Clements <paul.clements@steeleye.com>
---
 drivers/block/nbd.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 4d6de4f..a9ab8be 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -580,13 +580,6 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *lo,
 		blk_rq_init(NULL, &sreq);
 		sreq.cmd_type = REQ_TYPE_SPECIAL;
 		nbd_cmd(&sreq) = NBD_CMD_DISC;
-		/*
-		 * Set these to sane values in case server implementation
-		 * fails to check the request type first and also to keep
-		 * debugging output cleaner.
-		 */
-		sreq.sector = 0;
-		sreq.nr_sectors = 0;
 		if (!lo->sock)
 			return -EINVAL;
 		nbd_send_req(lo, &sreq);
-- 
1.6.0.2

