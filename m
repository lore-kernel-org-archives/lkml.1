Return-Path: <linux-kernel-owner+w=401wt.eu-S1764113AbZEHDFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764113AbZEHDFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762677AbZEHC57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:57:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:36183 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947AbZEHC4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:56:10 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, rusty@rustcorp.com.au,
       James.Bottomley@HansenPartnership.com, mike.miller@hp.com,
       donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net,
       Geert.Uytterhoeven@sonycom.com, davem@davemloft.net,
       Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com,
       grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk,
       sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, oakad@yahoo.com, drzeus@drzeus.cx,
       dwmw2@infradead.org, Markus.Lidel@shadowconnect.com, wein@de.ibm.com,
       schwidefsky@de.ibm.com, zaitcev@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/18] mg_disk: dequeue and track in-flight request
Date: Fri,  8 May 2009 11:54:01 +0900
Message-Id: <1241751256-17435-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 02:54:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mg_disk has at most single request in flight per device.  Till now,
whenever it needs to access the in-flight request it called
elv_next_request().  This patch makes mg_disk track the in-flight
request directly using mg_host->req and dequeue it when processing
starts.

q->queuedata is set to mg_host so that mg_host can be determined
without fetching request from the queue.

[ Impact: dequeue in-flight request, one elv_next_request() per request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: unsik Kim <donari75@gmail.com>
---
 drivers/block/mg_disk.c |  109 +++++++++++++++++++++++++---------------------
 1 files changed, 59 insertions(+), 50 deletions(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index be32388..1ca5d14 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -135,6 +135,7 @@ struct mg_host {
 	struct device *dev;
 
 	struct request_queue *breq;
+	struct request *req;
 	spinlock_t lock;
 	struct gendisk *gd;
 
@@ -171,17 +172,27 @@ struct mg_host {
 
 static void mg_request(struct request_queue *);
 
+static bool mg_end_request(struct mg_host *host, int err, unsigned int nr_bytes)
+{
+	if (__blk_end_request(host->req, err, nr_bytes))
+		return true;
+
+	host->req = NULL;
+	return false;
+}
+
+static bool mg_end_request_cur(struct mg_host *host, int err)
+{
+	return mg_end_request(host, err, blk_rq_cur_bytes(host->req));
+}
+
 static void mg_dump_status(const char *msg, unsigned int stat,
 		struct mg_host *host)
 {
 	char *name = MG_DISK_NAME;
-	struct request *req;
 
-	if (host->breq) {
-		req = elv_next_request(host->breq);
-		if (req)
-			name = req->rq_disk->disk_name;
-	}
+	if (host->req)
+		name = host->req->rq_disk->disk_name;
 
 	printk(KERN_ERR "%s: %s: status=0x%02x { ", name, msg, stat & 0xff);
 	if (stat & ATA_BUSY)
@@ -217,13 +228,9 @@ static void mg_dump_status(const char *msg, unsigned int stat,
 			printk("AddrMarkNotFound ");
 		printk("}");
 		if (host->error & (ATA_BBK | ATA_UNC | ATA_IDNF | ATA_AMNF)) {
-			if (host->breq) {
-				req = elv_next_request(host->breq);
-				if (req)
-					printk(", sector=%u",
-					       (unsigned int)blk_rq_pos(req));
-			}
-
+			if (host->req)
+				printk(", sector=%u",
+				       (unsigned int)blk_rq_pos(host->req));
 		}
 		printk("\n");
 	}
@@ -453,11 +460,10 @@ static int mg_disk_init(struct mg_host *host)
 
 static void mg_bad_rw_intr(struct mg_host *host)
 {
-	struct request *req = elv_next_request(host->breq);
-	if (req != NULL)
-		if (++req->errors >= MG_MAX_ERRORS ||
-				host->error == MG_ERR_TIMEOUT)
-			__blk_end_request_cur(req, -EIO);
+	if (host->req)
+		if (++host->req->errors >= MG_MAX_ERRORS ||
+		    host->error == MG_ERR_TIMEOUT)
+			mg_end_request_cur(host, -EIO);
 }
 
 static unsigned int mg_out(struct mg_host *host,
@@ -515,7 +521,7 @@ static void mg_read(struct request *req)
 
 		outb(MG_CMD_RD_CONF, (unsigned long)host->dev_base +
 				MG_REG_COMMAND);
-	} while (__blk_end_request(req, 0, MG_SECTOR_SIZE));
+	} while (mg_end_request(host, 0, MG_SECTOR_SIZE));
 }
 
 static void mg_write(struct request *req)
@@ -545,14 +551,14 @@ static void mg_write(struct request *req)
 
 		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
 				MG_REG_COMMAND);
-	} while (__blk_end_request(req, 0, MG_SECTOR_SIZE));
+	} while (mg_end_request(host, 0, MG_SECTOR_SIZE));
 }
 
 static void mg_read_intr(struct mg_host *host)
 {
+	struct request *req = host->req;
 	u32 i;
 	u16 *buff;
-	struct request *req;
 
 	/* check status */
 	do {
@@ -571,7 +577,6 @@ static void mg_read_intr(struct mg_host *host)
 
 ok_to_read:
 	/* get current segment of request */
-	req = elv_next_request(host->breq);
 	buff = (u16 *)req->buffer;
 
 	/* read 1 sector */
@@ -585,7 +590,7 @@ ok_to_read:
 	/* send read confirm */
 	outb(MG_CMD_RD_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
 
-	if (__blk_end_request(req, 0, MG_SECTOR_SIZE)) {
+	if (mg_end_request(host, 0, MG_SECTOR_SIZE)) {
 		/* set handler if read remains */
 		host->mg_do_intr = mg_read_intr;
 		mod_timer(&host->timer, jiffies + 3 * HZ);
@@ -595,14 +600,11 @@ ok_to_read:
 
 static void mg_write_intr(struct mg_host *host)
 {
+	struct request *req = host->req;
 	u32 i, j;
 	u16 *buff;
-	struct request *req;
 	bool rem;
 
-	/* get current segment of request */
-	req = elv_next_request(host->breq);
-
 	/* check status */
 	do {
 		i = inb((unsigned long)host->dev_base + MG_REG_STATUS);
@@ -619,7 +621,7 @@ static void mg_write_intr(struct mg_host *host)
 	return;
 
 ok_to_write:
-	if ((rem = __blk_end_request(req, 0, MG_SECTOR_SIZE))) {
+	if ((rem = mg_end_request(host, 0, MG_SECTOR_SIZE))) {
 		/* write 1 sector and set handler if remains */
 		buff = (u16 *)req->buffer;
 		for (j = 0; j < MG_STORAGE_BUFFER_SIZE >> 1; j++) {
@@ -644,44 +646,47 @@ void mg_times_out(unsigned long data)
 {
 	struct mg_host *host = (struct mg_host *)data;
 	char *name;
-	struct request *req;
 
 	spin_lock_irq(&host->lock);
 
-	req = elv_next_request(host->breq);
-	if (!req)
+	if (!host->req)
 		goto out_unlock;
 
 	host->mg_do_intr = NULL;
 
-	name = req->rq_disk->disk_name;
+	name = host->req->rq_disk->disk_name;
 	printk(KERN_DEBUG "%s: timeout\n", name);
 
 	host->error = MG_ERR_TIMEOUT;
 	mg_bad_rw_intr(host);
 
-	mg_request(host->breq);
 out_unlock:
+	mg_request(host->breq);
 	spin_unlock_irq(&host->lock);
 }
 
 static void mg_request_poll(struct request_queue *q)
 {
-	struct request *req;
-	struct mg_host *host;
+	struct mg_host *host = q->queuedata;
 
-	while ((req = elv_next_request(q)) != NULL) {
-		host = req->rq_disk->private_data;
+	while (1) {
+		if (!host->req) {
+			host->req = elv_next_request(q);
+			if (host->req)
+				blkdev_dequeue_request(host->req);
+			else
+				break;
+		}
 
-		if (unlikely(!blk_fs_request(req))) {
-			__blk_end_request_cur(req, -EIO);
+		if (unlikely(!blk_fs_request(host->req))) {
+			mg_end_request_cur(host, -EIO);
 			continue;
 		}
 
-		if (rq_data_dir(req) == READ)
-			mg_read(req);
+		if (rq_data_dir(host->req) == READ)
+			mg_read(host->req);
 		else
-			mg_write(req);
+			mg_write(host->req);
 	}
 }
 
@@ -733,16 +738,19 @@ static unsigned int mg_issue_req(struct request *req,
 /* This function also called from IRQ context */
 static void mg_request(struct request_queue *q)
 {
+	struct mg_host *host = q->queuedata;
 	struct request *req;
-	struct mg_host *host;
 	u32 sect_num, sect_cnt;
 
 	while (1) {
-		req = elv_next_request(q);
-		if (!req)
-			return;
-
-		host = req->rq_disk->private_data;
+		if (!host->req) {
+			host->req = elv_next_request(q);
+			if (host->req)
+				blkdev_dequeue_request(host->req);
+			else
+				break;
+		}
+		req = host->req;
 
 		/* check unwanted request call */
 		if (host->mg_do_intr)
@@ -762,12 +770,12 @@ static void mg_request(struct request_queue *q)
 					"%s: bad access: sector=%d, count=%d\n",
 					req->rq_disk->disk_name,
 					sect_num, sect_cnt);
-			__blk_end_request_cur(req, -EIO);
+			mg_end_request_cur(host, -EIO);
 			continue;
 		}
 
 		if (unlikely(!blk_fs_request(req))) {
-			__blk_end_request_cur(req, -EIO);
+			mg_end_request_cur(host, -EIO);
 			continue;
 		}
 
@@ -981,6 +989,7 @@ static int mg_probe(struct platform_device *plat_dev)
 				__func__, __LINE__);
 		goto probe_err_5;
 	}
+	host->breq->queuedata = host;
 
 	/* mflash is random device, thanx for the noop */
 	elevator_exit(host->breq->elevator);
-- 
1.6.0.2

