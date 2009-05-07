Return-Path: <linux-kernel-owner+w=401wt.eu-S1761141AbZEGCsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761141AbZEGCsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 22:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbZEGCs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 22:48:27 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:60920 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbZEGCsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 22:48:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=EAtMWaBpZmUXaKYXPqpoSocosysDaOtEO3Ck8ON7jOPb4irnfyOFoHDNi6TCeD+GLb
         ecTBk4A1H6YAQ26iFCrHaRQgbRNEl8cVWnF5y3f280i262ee5jFeymmccdyEDRfE9tMw
         30X4onRgeZenji6mC4xGFwmAlgKQpW33gAn4g=
Message-ID: <4A024BEB.305@gmail.com>
Date: Thu, 07 May 2009 11:48:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
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
Subject: Re: [GIT PATCH] block,scsi,ide: unify sector and data_len, take#2
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <49FFB9BE.1090709@gmail.com>
In-Reply-To: <49FFB9BE.1090709@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> Tejun Heo wrote:
>> Upon ack, please pull from the following git tree.
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-unify-sector-and-data_len
> 
> git tree has been updated as per comments.
> 
> * Acked-by:'s added.
> 
> * Too early blk_rq_bytes() conversion in ide-tape pushed to later
>   patch.
> 
> Both changes are minor and don't make any difference to the final
> result.  The new commit is f7ff5f0d7cda0b0da5e7de36dd97ff75412bbe16.

Tree updated again.  Changes are...

* I forgot to convert new drivers (mg_disk and swim) to accessors.
  0005-block-convert-to-pos-and-nr_sectors-accessors.patch updated to
  convert these new drivers.

* Acked-by added.

The new commit is 1df2a196e28cc8f97919dc530dc1c019e1d3a968.

diff f7ff5f0d..1df2a196 follows.  The conversions are straight
forward.

 drivers/block/mg_disk.c |   25 +++++++++++++------------
 drivers/block/swim.c    |    6 +++---
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 71e56cc..826c349 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -220,7 +220,8 @@ static void mg_dump_status(const char *msg, unsigned int stat,
 			if (host->breq) {
 				req = elv_next_request(host->breq);
 				if (req)
-					printk(", sector=%u", (u32)req->sector);
+					printk(", sector=%u",
+					       (unsigned int)blk_rq_pos(req));
 			}
 
 		}
@@ -493,12 +494,12 @@ static void mg_read(struct request *req)
 	u32 j;
 	struct mg_host *host = req->rq_disk->private_data;
 
-	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_RD, NULL) !=
-			MG_ERR_NONE)
+	if (mg_out(host, blk_rq_pos(req), blk_rq_sectors(req),
+		   MG_CMD_RD, NULL) != MG_ERR_NONE)
 		mg_bad_rw_intr(host);
 
 	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
-	       req->nr_sectors, req->sector, req->buffer);
+	       blk_rq_sectors(req), blk_rq_pos(req), req->buffer);
 
 	do {
 		u16 *buff = (u16 *)req->buffer;
@@ -522,14 +523,14 @@ static void mg_write(struct request *req)
 	u32 j;
 	struct mg_host *host = req->rq_disk->private_data;
 
-	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_WR, NULL) !=
-			MG_ERR_NONE) {
+	if (mg_out(host, blk_rq_pos(req), blk_rq_sectors(req),
+		   MG_CMD_WR, NULL) != MG_ERR_NONE) {
 		mg_bad_rw_intr(host);
 		return;
 	}
 
 	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
-	       req->nr_sectors, req->sector, req->buffer);
+	       blk_rq_sectors(req), blk_rq_pos(req), req->buffer);
 
 	do {
 		u16 *buff = (u16 *)req->buffer;
@@ -579,7 +580,7 @@ ok_to_read:
 			      (i << 1));
 
 	MG_DBG("sector %ld, remaining=%ld, buffer=0x%p\n",
-			req->sector, req->nr_sectors - 1, req->buffer);
+	       blk_rq_pos(req), blk_rq_sectors(req) - 1, req->buffer);
 
 	/* send read confirm */
 	outb(MG_CMD_RD_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
@@ -609,7 +610,7 @@ static void mg_write_intr(struct mg_host *host)
 			break;
 		if (!MG_READY_OK(i))
 			break;
-		if ((req->nr_sectors <= 1) || (i & ATA_DRQ))
+		if ((blk_rq_sectors(req) <= 1) || (i & ATA_DRQ))
 			goto ok_to_write;
 	} while (0);
 	mg_dump_status("mg_write_intr", i, host);
@@ -627,7 +628,7 @@ ok_to_write:
 			buff++;
 		}
 		MG_DBG("sector %ld, remaining=%ld, buffer=0x%p\n",
-				req->sector, req->nr_sectors, req->buffer);
+		       blk_rq_pos(req), blk_rq_sectors(req), req->buffer);
 		host->mg_do_intr = mg_write_intr;
 		mod_timer(&host->timer, jiffies + 3 * HZ);
 	}
@@ -749,9 +750,9 @@ static void mg_request(struct request_queue *q)
 
 		del_timer(&host->timer);
 
-		sect_num = req->sector;
+		sect_num = blk_rq_pos(req);
 		/* deal whole segments */
-		sect_cnt = req->nr_sectors;
+		sect_cnt = blk_rq_sectors(req);
 
 		/* sanity check */
 		if (sect_num >= get_capacity(req->rq_disk) ||
diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 97ef426..fc6a1c3 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -531,7 +531,7 @@ static void redo_fd_request(struct request_queue *q)
 	while ((req = elv_next_request(q))) {
 
 		fs = req->rq_disk->private_data;
-		if (req->sector < 0 || req->sector >= fs->total_secs) {
+		if (blk_rq_pos(req) >= fs->total_secs) {
 			__blk_end_request_cur(req, -EIO);
 			continue;
 		}
@@ -551,8 +551,8 @@ static void redo_fd_request(struct request_queue *q)
 			__blk_end_request_cur(req, -EIO);
 			break;
 		case READ:
-			if (floppy_read_sectors(fs, req->sector,
-						req->current_nr_sectors,
+			if (floppy_read_sectors(fs, blk_rq_pos(req),
+						blk_rq_cur_sectors(req),
 						req->buffer)) {
 				__blk_end_request_cur(req, -EIO);
 				continue;

-- 
tejun
