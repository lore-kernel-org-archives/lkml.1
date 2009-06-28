Return-Path: <linux-kernel-owner+w=401wt.eu-S1757027AbZF1SKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbZF1SKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 14:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZF1SKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 14:10:30 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:47665 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbZF1SK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 14:10:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Rksa/6fif/ZahRPYbUOQekHUDeRdwO53xdH5O/mIzVU6BV4i6PdzYz0c74tGNmkKBL
         Jf7MCU79c2DawupGuQpOKxKTA/JZWzVf+fnZYwdHa4ExiWey4AuK2MHGMQ3tUnmbMle/
         YQ2GCtM8reRYZjrLsYSZupKXlzGD9X+WWMPEs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: unsik Kim <donari75@gmail.com>
Subject: [PATCH][RESEND] mg_disk: fix issue with data integrity on error in mg_write()
Date: Sun, 28 Jun 2009 20:14:59 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906282015.00854.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] mg_disk: fix issue with data integrity on error in mg_write()

We cannot acknowledge the sector write before checking its status
(which is done on the next loop iteration) and we also need to do
the final status register check after writing the last sector.

Fix mg_write() to match mg_write_intr() in this regard.

While at it:
- add mg_read_one() and mg_write_one() helpers
- always use MG_SECTOR_SIZE and remove MG_STORAGE_BUFFER_SIZE

[bart: thanks to Tejun for porting the patch over recent block changes]

Cc: unsik Kim <donari75@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Ported over 2.6.31-rc1.

 drivers/block/mg_disk.c |   89 +++++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 42 deletions(-)

Index: b/drivers/block/mg_disk.c
===================================================================
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -36,7 +36,6 @@
 
 /* Register offsets */
 #define MG_BUFF_OFFSET			0x8000
-#define MG_STORAGE_BUFFER_SIZE		0x200
 #define MG_REG_OFFSET			0xC000
 #define MG_REG_FEATURE			(MG_REG_OFFSET + 2)	/* write case */
 #define MG_REG_ERROR			(MG_REG_OFFSET + 2)	/* read case */
@@ -469,9 +468,18 @@ static unsigned int mg_out(struct mg_hos
 	return MG_ERR_NONE;
 }
 
+static void mg_read_one(struct mg_host *host, struct request *req)
+{
+	u16 *buff = (u16 *)req->buffer;
+	u32 i;
+
+	for (i = 0; i < MG_SECTOR_SIZE >> 1; i++)
+		*buff++ = inw((unsigned long)host->dev_base + MG_BUFF_OFFSET +
+			      (i << 1));
+}
+
 static void mg_read(struct request *req)
 {
-	u32 j;
 	struct mg_host *host = req->rq_disk->private_data;
 
 	if (mg_out(host, blk_rq_pos(req), blk_rq_sectors(req),
@@ -482,26 +490,33 @@ static void mg_read(struct request *req)
 	       blk_rq_sectors(req), blk_rq_pos(req), req->buffer);
 
 	do {
-		u16 *buff = (u16 *)req->buffer;
-
 		if (mg_wait(host, ATA_DRQ,
 			    MG_TMAX_WAIT_RD_DRQ) != MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
 			return;
 		}
-		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++)
-			*buff++ = inw((unsigned long)host->dev_base +
-				      MG_BUFF_OFFSET + (j << 1));
+
+		mg_read_one(host, req);
 
 		outb(MG_CMD_RD_CONF, (unsigned long)host->dev_base +
 				MG_REG_COMMAND);
 	} while (mg_end_request(host, 0, MG_SECTOR_SIZE));
 }
 
+static void mg_write_one(struct mg_host *host, struct request *req)
+{
+	u16 *buff = (u16 *)req->buffer;
+	u32 i;
+
+	for (i = 0; i < MG_SECTOR_SIZE >> 1; i++)
+		outw(*buff++, (unsigned long)host->dev_base + MG_BUFF_OFFSET +
+		     (i << 1));
+}
+
 static void mg_write(struct request *req)
 {
-	u32 j;
 	struct mg_host *host = req->rq_disk->private_data;
+	bool rem;
 
 	if (mg_out(host, blk_rq_pos(req), blk_rq_sectors(req),
 		   MG_CMD_WR, NULL) != MG_ERR_NONE) {
@@ -512,27 +527,37 @@ static void mg_write(struct request *req
 	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
 	       blk_rq_sectors(req), blk_rq_pos(req), req->buffer);
 
-	do {
-		u16 *buff = (u16 *)req->buffer;
+	if (mg_wait(host, ATA_DRQ,
+		    MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
+		mg_bad_rw_intr(host);
+		return;
+	}
+
+	mg_write_one(host, req);
+
+	outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
 
-	if (mg_wait(host, ATA_DRQ, MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
+	do {
+		if (blk_rq_sectors(req) > 1 &&
+		     mg_wait(host, ATA_DRQ,
+			     MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
 			return;
 		}
-		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++)
-			outw(*buff++, (unsigned long)host->dev_base +
-				      MG_BUFF_OFFSET + (j << 1));
 
-		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
-				MG_REG_COMMAND);
-	} while (mg_end_request(host, 0, MG_SECTOR_SIZE));
+		rem = mg_end_request(host, 0, MG_SECTOR_SIZE);
+		if (rem)
+			mg_write_one(host, req);
+
+		outb(MG_CMD_WR_CONF,
+		     (unsigned long)host->dev_base + MG_REG_COMMAND);
+	} while (rem);
 }
 
 static void mg_read_intr(struct mg_host *host)
 {
 	struct request *req = host->req;
 	u32 i;
-	u16 *buff;
 
 	/* check status */
 	do {
@@ -550,13 +575,7 @@ static void mg_read_intr(struct mg_host 
 	return;
 
 ok_to_read:
-	/* get current segment of request */
-	buff = (u16 *)req->buffer;
-
-	/* read 1 sector */
-	for (i = 0; i < MG_SECTOR_SIZE >> 1; i++)
-		*buff++ = inw((unsigned long)host->dev_base + MG_BUFF_OFFSET +
-			      (i << 1));
+	mg_read_one(host, req);
 
 	MG_DBG("sector %ld, remaining=%ld, buffer=0x%p\n",
 	       blk_rq_pos(req), blk_rq_sectors(req) - 1, req->buffer);
@@ -575,8 +594,7 @@ ok_to_read:
 static void mg_write_intr(struct mg_host *host)
 {
 	struct request *req = host->req;
-	u32 i, j;
-	u16 *buff;
+	u32 i;
 	bool rem;
 
 	/* check status */
@@ -597,12 +615,7 @@ static void mg_write_intr(struct mg_host
 ok_to_write:
 	if ((rem = mg_end_request(host, 0, MG_SECTOR_SIZE))) {
 		/* write 1 sector and set handler if remains */
-		buff = (u16 *)req->buffer;
-		for (j = 0; j < MG_STORAGE_BUFFER_SIZE >> 1; j++) {
-			outw(*buff, (unsigned long)host->dev_base +
-					MG_BUFF_OFFSET + (j << 1));
-			buff++;
-		}
+		mg_write_one(host, req);
 		MG_DBG("sector %ld, remaining=%ld, buffer=0x%p\n",
 		       blk_rq_pos(req), blk_rq_sectors(req), req->buffer);
 		host->mg_do_intr = mg_write_intr;
@@ -667,9 +680,6 @@ static unsigned int mg_issue_req(struct 
 		unsigned int sect_num,
 		unsigned int sect_cnt)
 {
-	u16 *buff;
-	u32 i;
-
 	switch (rq_data_dir(req)) {
 	case READ:
 		if (mg_out(host, sect_num, sect_cnt, MG_CMD_RD, &mg_read_intr)
@@ -693,12 +703,7 @@ static unsigned int mg_issue_req(struct 
 			mg_bad_rw_intr(host);
 			return host->error;
 		}
-		buff = (u16 *)req->buffer;
-		for (i = 0; i < MG_SECTOR_SIZE >> 1; i++) {
-			outw(*buff, (unsigned long)host->dev_base +
-					MG_BUFF_OFFSET + (i << 1));
-			buff++;
-		}
+		mg_write_one(host, req);
 		mod_timer(&host->timer, jiffies + 3 * HZ);
 		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
 				MG_REG_COMMAND);
