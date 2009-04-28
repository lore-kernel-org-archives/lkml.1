Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZD1Wg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZD1Wg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 18:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZD1Wgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 18:36:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:34489 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbZD1Wgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 18:36:47 -0400
Message-ID: <49F784E4.9040009@kernel.org>
Date: Wed, 29 Apr 2009 07:36:20 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, joerg@dorchain.net,
       geert@linux-m68k.org, donari75@gmail.com, davem@davemloft.net,
       jdike@linux.intel.com, benh@kernel.crashing.org, Laurent@lvivier.info
Subject: Re: [RFC PATCHSET linux-2.6-block#for-2.6.31] block: lld cleanup
 patches
References: <1240489553-15724-1-git-send-email-tj@kernel.org> <200904242141.56375.bzolnier@gmail.com> <49F67B87.10103@kernel.org> <200904282038.31075.bzolnier@gmail.com>
In-Reply-To: <200904282038.31075.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 28 Apr 2009 22:35:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Fine with me and thanks for handling it.  BTW do you still have version this
> patch re-synced on top of other changes around?

Yeap, inlined below.

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: mg_disk: fix issue with data integrity on error in mg_write()

We cannot acknowledge the sector write before checking its status
(which is done on the next loop iteration) and we also need to do
the final status register check after writing the last sector.

Fix mg_write() to match mg_write_intr() in this regard.

While at it:
- add mg_read_one() and mg_write_one() helpers
- always use MG_SECTOR_SIZE and remove MG_STORAGE_BUFFER_SIZE

Cc: unsik Kim <donari75@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/block/mg_disk.c |   85 ++++++++++++++++++++++++++----------------------
 1 file changed, 47 insertions(+), 38 deletions(-)

Index: block/drivers/block/mg_disk.c
===================================================================
--- block.orig/drivers/block/mg_disk.c
+++ block/drivers/block/mg_disk.c
@@ -37,7 +37,6 @@
 
 /* Register offsets */
 #define MG_BUFF_OFFSET			0x8000
-#define MG_STORAGE_BUFFER_SIZE		0x200
 #define MG_REG_OFFSET			0xC000
 #define MG_REG_FEATURE			(MG_REG_OFFSET + 2)	/* write case */
 #define MG_REG_ERROR			(MG_REG_OFFSET + 2)	/* read case */
@@ -488,9 +487,18 @@ static unsigned int mg_out(struct mg_hos
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
 
 	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_RD, NULL) !=
@@ -501,26 +509,33 @@ static void mg_read(struct request *req)
 	       req->nr_sectors, req->sector, req->buffer);
 
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
 	} while (__blk_end_request(req, 0, MG_SECTOR_SIZE));
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
 
 	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_WR, NULL) !=
 			MG_ERR_NONE) {
@@ -531,20 +546,31 @@ static void mg_write(struct request *req
 	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
 	       req->nr_sectors, req->sector, req->buffer);
 
-	do {
-		u16 *buff = (u16 *)req->buffer;
+	if (mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ,
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
+		if ((req->nr_sectors > 1) &&
+		     mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ,
+			     MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
 			return;
 		}
-		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++)
-			outw(*buff++, (unsigned long)host->dev_base +
-				      MG_BUFF_OFFSET + (j << 1));
 
-		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
-				MG_REG_COMMAND);
-	} while (__blk_end_request(req, 0, MG_SECTOR_SIZE));
+		rem = __blk_end_request(req, 0, MG_SECTOR_SIZE);
+		if (rem)
+			mg_write_one(host, req);
+
+		outb(MG_CMD_WR_CONF,
+		     (unsigned long)host->dev_base + MG_REG_COMMAND);
+	} while (rem);
 }
 
 static void mg_read_intr(struct mg_host *host)
@@ -571,12 +597,9 @@ static void mg_read_intr(struct mg_host
 ok_to_read:
 	/* get current segment of request */
 	req = elv_next_request(host->breq);
-	buff = (u16 *)req->buffer;
 
 	/* read 1 sector */
-	for (i = 0; i < MG_SECTOR_SIZE >> 1; i++)
-		*buff++ = inw((unsigned long)host->dev_base + MG_BUFF_OFFSET +
-			      (i << 1));
+	mg_read_one(host, req);
 
 	MG_DBG("sector %ld, remaining=%ld, buffer=0x%p\n",
 			req->sector, req->nr_sectors - 1, req->buffer);
@@ -594,9 +617,8 @@ ok_to_read:
 
 static void mg_write_intr(struct mg_host *host)
 {
-	u32 i, j;
-	u16 *buff;
 	struct request *req;
+	u32 i;
 	bool rem;
 
 	/* get current segment of request */
@@ -620,12 +642,7 @@ static void mg_write_intr(struct mg_host
 ok_to_write:
 	if ((rem = __blk_end_request(req, 0, MG_SECTOR_SIZE))) {
 		/* write 1 sector and set handler if remains */
-		buff = (u16 *)req->buffer;
-		for (j = 0; j < MG_STORAGE_BUFFER_SIZE >> 1; j++) {
-			outw(*buff, (unsigned long)host->dev_base +
-					MG_BUFF_OFFSET + (j << 1));
-			buff++;
-		}
+		mg_write_one(host, req);
 		MG_DBG("sector %ld, remaining=%ld, buffer=0x%p\n",
 				req->sector, req->nr_sectors, req->buffer);
 		host->mg_do_intr = mg_write_intr;
@@ -689,9 +706,6 @@ static unsigned int mg_issue_req(struct
 		unsigned int sect_num,
 		unsigned int sect_cnt)
 {
-	u16 *buff;
-	u32 i;
-
 	switch (rq_data_dir(req)) {
 	case READ:
 		if (mg_out(host, sect_num, sect_cnt, MG_CMD_RD, &mg_read_intr)
@@ -715,12 +729,7 @@ static unsigned int mg_issue_req(struct
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

-- 
tejun
