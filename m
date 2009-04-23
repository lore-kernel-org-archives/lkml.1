Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbZDWMbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbZDWMbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756217AbZDWM12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:27:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:38570 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492AbZDWM1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:27:25 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, joerg@dorchain.net,
       geert@linux-m68k.org, donari75@gmail.com, davem@davemloft.net,
       jdike@linux.intel.com, benh@kernel.crashing.org, Laurent@lvivier.info
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/12] mg_disk: clean up request completion paths
Date: Thu, 23 Apr 2009 21:25:53 +0900
Message-Id: <1240489553-15724-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240489553-15724-1-git-send-email-tj@kernel.org>
References: <1240489553-15724-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 12:26:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mg_disk implements its own partial completion.  Convert to standard
block layer partial completion.

[ Impact: cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: unsik Kim <donari75@gmail.com>
---
 drivers/block/mg_disk.c |  117 +++++++++++++---------------------------------
 1 files changed, 33 insertions(+), 84 deletions(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index bb0ff8c..95e08c0 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -503,95 +503,68 @@ static unsigned int mg_out(struct mg_host *host,
 
 static void mg_read(struct request *req)
 {
-	u32 remains, j;
+	u32 j;
 	struct mg_host *host = req->rq_disk->private_data;
 
-	remains = req->nr_sectors;
-
 	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_RD, NULL) !=
 			MG_ERR_NONE)
 		mg_bad_rw_intr(host);
 
 	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
-			remains, req->sector, req->buffer);
+	       req->nr_sectors, req->sector, req->buffer);
+
+	do {
+		u16 *buff = (u16 *)req->buffer;
 
-	while (remains) {
 		if (mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ,
 					MG_TMAX_WAIT_RD_DRQ) != MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
 			return;
 		}
-		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++) {
-			*(u16 *)req->buffer =
-				inw((unsigned long)host->dev_base +
-						MG_BUFF_OFFSET + (j << 1));
-			req->buffer += 2;
-		}
-
-		req->sector++;
-		req->errors = 0;
-		remains = --req->nr_sectors;
-		--req->current_nr_sectors;
-
-		if (req->current_nr_sectors <= 0) {
-			MG_DBG("remain : %d sects\n", remains);
-			__blk_end_request_cur(req, 0);
-			if (remains > 0)
-				req = elv_next_request(host->breq);
-		}
+		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++)
+			*buff++ = inw((unsigned long)host->dev_base +
+				      MG_BUFF_OFFSET + (j << 1));
 
 		outb(MG_CMD_RD_CONF, (unsigned long)host->dev_base +
 				MG_REG_COMMAND);
-	}
+	} while (__blk_end_request(req, 0, MG_SECTOR_SIZE));
 }
 
 static void mg_write(struct request *req)
 {
-	u32 remains, j;
+	u32 j;
 	struct mg_host *host = req->rq_disk->private_data;
 
-	remains = req->nr_sectors;
-
 	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_WR, NULL) !=
 			MG_ERR_NONE) {
 		mg_bad_rw_intr(host);
 		return;
 	}
 
-
 	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
-			remains, req->sector, req->buffer);
-	while (remains) {
+	       req->nr_sectors, req->sector, req->buffer);
+
+	do {
+		u16 *buff = (u16 *)req->buffer;
+
 		if (mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ,
 					MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
 			return;
 		}
-		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++) {
-			outw(*(u16 *)req->buffer,
-					(unsigned long)host->dev_base +
-					MG_BUFF_OFFSET + (j << 1));
-			req->buffer += 2;
-		}
-		req->sector++;
-		remains = --req->nr_sectors;
-		--req->current_nr_sectors;
-
-		if (req->current_nr_sectors <= 0) {
-			MG_DBG("remain : %d sects\n", remains);
-			__blk_end_request_cur(req, 0);
-			if (remains > 0)
-				req = elv_next_request(host->breq);
-		}
+		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++)
+			outw(*buff++, (unsigned long)host->dev_base +
+				      MG_BUFF_OFFSET + (j << 1));
 
 		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
 				MG_REG_COMMAND);
-	}
+	} while (__blk_end_request(req, 0, MG_SECTOR_SIZE));
 }
 
 static void mg_read_intr(struct mg_host *host)
 {
 	u32 i;
+	u16 *buff;
 	struct request *req;
 
 	/* check status */
@@ -612,39 +585,24 @@ static void mg_read_intr(struct mg_host *host)
 ok_to_read:
 	/* get current segment of request */
 	req = elv_next_request(host->breq);
+	buff = (u16 *)req->buffer;
 
 	/* read 1 sector */
-	for (i = 0; i < MG_SECTOR_SIZE >> 1; i++) {
-		*(u16 *)req->buffer =
-			inw((unsigned long)host->dev_base + MG_BUFF_OFFSET +
-					(i << 1));
-		req->buffer += 2;
-	}
+	for (i = 0; i < MG_SECTOR_SIZE >> 1; i++)
+		*buff++ = inw((unsigned long)host->dev_base + MG_BUFF_OFFSET +
+			      (i << 1));
 
-	/* manipulate request */
 	MG_DBG("sector %ld, remaining=%ld, buffer=0x%p\n",
 			req->sector, req->nr_sectors - 1, req->buffer);
 
-	req->sector++;
-	req->errors = 0;
-	i = --req->nr_sectors;
-	--req->current_nr_sectors;
-
-	/* let know if current segment done */
-	if (req->current_nr_sectors <= 0)
-		__blk_end_request_cur(req, 0);
-
-	/* set handler if read remains */
-	if (i > 0) {
-		host->mg_do_intr = mg_read_intr;
-		mod_timer(&host->timer, jiffies + 3 * HZ);
-	}
-
 	/* send read confirm */
 	outb(MG_CMD_RD_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
 
-	/* goto next request */
-	if (!i)
+	if (__blk_end_request(req, 0, MG_SECTOR_SIZE)) {
+		/* set handler if read remains */
+		host->mg_do_intr = mg_read_intr;
+		mod_timer(&host->timer, jiffies + 3 * HZ);
+	} else /* goto next request */
 		mg_request(host->breq);
 }
 
@@ -653,6 +611,7 @@ static void mg_write_intr(struct mg_host *host)
 	u32 i, j;
 	u16 *buff;
 	struct request *req;
+	bool rem;
 
 	/* get current segment of request */
 	req = elv_next_request(host->breq);
@@ -673,18 +632,8 @@ static void mg_write_intr(struct mg_host *host)
 	return;
 
 ok_to_write:
-	/* manipulate request */
-	req->sector++;
-	i = --req->nr_sectors;
-	--req->current_nr_sectors;
-	req->buffer += MG_SECTOR_SIZE;
-
-	/* let know if current segment or all done */
-	if (!i || (req->bio && req->current_nr_sectors <= 0))
-		__blk_end_request_cur(req, 0);
-
-	/* write 1 sector and set handler if remains */
-	if (i > 0) {
+	if ((rem = __blk_end_request(req, 0, MG_SECTOR_SIZE))) {
+		/* write 1 sector and set handler if remains */
 		buff = (u16 *)req->buffer;
 		for (j = 0; j < MG_STORAGE_BUFFER_SIZE >> 1; j++) {
 			outw(*buff, (unsigned long)host->dev_base +
@@ -700,7 +649,7 @@ ok_to_write:
 	/* send write confirm */
 	outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
 
-	if (!i)
+	if (!rem)
 		mg_request(host->breq);
 }
 
-- 
1.6.0.2

