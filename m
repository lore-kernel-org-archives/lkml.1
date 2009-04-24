Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbZDXTjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbZDXTjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 15:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbZDXTiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 15:38:55 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:47529 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbZDXTiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 15:38:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=lvmqsK3SADYbNln8E0L1IYOLWT1JmcSWGPgJA6U5RnWUj0WsEI9V4TeYDHt0nivtFh
         o/BoihLUtniQ9kFKAH8gko+Yp9TCAJiV73DNGRHQ5WVqS9jgrIgPv3miPDNP1hQY7lab
         Hk9ev4ElIIJVdOc4YqOC1a9X2ElxA4V/GouC8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCHSET linux-2.6-block#for-2.6.31] block: lld cleanup patches
Date: Fri, 24 Apr 2009 21:41:55 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, joerg@dorchain.net,
       geert@linux-m68k.org, donari75@gmail.com, davem@davemloft.net,
       jdike@linux.intel.com, benh@kernel.crashing.org, Laurent@lvivier.info
References: <1240489553-15724-1-git-send-email-tj@kernel.org>
In-Reply-To: <1240489553-15724-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904242141.56375.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 April 2009 14:25:41 Tejun Heo wrote:
> Hello,
> 
> This is a RFC patchset.  Please do NOT pull directly from the git
> tree.
> 
> This patchset contains block lld cleanups and is consisted of the
> following 12 patches.
> 
>  0001-block-update-end_cur.patch
>  0002-block-don-t-init-rq-fields-unnecessarily.patch
>  0003-amiflop-ataflop-xd-mg_disk-clean-up-unnecessary-stu.patch
>  0004-ps3disk-simplify-request-completion.patch
>  0005-sunvdc-kill-vdc_end_request.patch
>  0006-ubd-cleanup-completion-path.patch
>  0007-ubd-drop-unnecessary-rq-sector-manipulation.patch
>  0008-hd-clean-up-request-completion-paths.patch
>  0009-swim3-clean-up-request-completion-paths.patch
>  0010-swim-clean-up-request-completion-paths.patch
>  0011-mg_disk-fold-mg_disk.h-into-mg_disk.c.patch
>  0012-mg_disk-clean-up-request-completion-paths.patch
> 
> 0001 fixes a stupid mistake while implementing blk_request_end_cur()
> and 0002 and 0003 are pretty straight forward cleanup.  Please feel
> free to apply these three patches.
> 
> 0004-0012 are cleanup patches for various block low level drivers
> mostly focusing on completion paths.  The biggest change is use of
> standard block layer mechanisms for partial completion instead of
> doing it by manipulating request directly.  All the touched drivers
> are only compile tested.
> 
> I'm planning on testing hd, xd and um but can't test others.  Can you
> guys please verify the following drivers work?
> 
>  ps3disk, sunvdc, swim3, swim and mg_disk.
> 
> The following git tree can be used for testing.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git rfc-block-lld-cleanup

I finally found some time to catch up with your patchsets and everything
looks good so far. :)

BTW while going through mg_disk changes I noticed that this driver may
need the following fix (just a RFC on top of your patchset, feel free to
take it over if unsik acks the change):

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [RFC][PATCH] mg_disk: fix issue with data integrity on error in mg_write()

We cannot acknowledge the sector write before checking its status
(which is done on the next loop iteration) and we also need to do
the final status register check after writing the last sector.

Fix mg_write() to match mg_write_intr() in this regard.

While at it:
- add mg_read_one() and mg_write_one() helpers
- always use MG_SECTOR_SIZE and remove MG_STORAGE_BUFFER_SIZE

Cc: unsik Kim <donari75@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/block/mg_disk.c |   87 +++++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 40 deletions(-)

Index: b/drivers/block/mg_disk.c
===================================================================
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -37,7 +37,6 @@
 
 /* Register offsets */
 #define MG_BUFF_OFFSET			0x8000
-#define MG_STORAGE_BUFFER_SIZE		0x200
 #define MG_REG_OFFSET			0xC000
 #define MG_REG_FEATURE			(MG_REG_OFFSET + 2)	/* write case */
 #define MG_REG_ERROR			(MG_REG_OFFSET + 2)	/* read case */
@@ -501,9 +500,18 @@ static unsigned int mg_out(struct mg_hos
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
@@ -514,26 +522,33 @@ static void mg_read(struct request *req)
 	       req->nr_sectors, req->sector, req->buffer);
 
 	do {
-		u16 *buff = (u16 *)req->buffer;
-
 		if (mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ,
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
@@ -544,28 +559,37 @@ static void mg_write(struct request *req
 	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
 	       req->nr_sectors, req->sector, req->buffer);
 
-	do {
-		u16 *buff = (u16 *)req->buffer;
+	if (mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ,
+			MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
+		mg_bad_rw_intr(host);
+		return;
+	}
 
-		if (mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ,
-					MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
+	mg_write_one(host, req);
+
+	outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
+
+	do {
+		if ((req->nr_sectors > 1) &&
+		     mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ,
+				MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
 			return;
 		}
-		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++)
-			outw(*buff++, (unsigned long)host->dev_base +
-				      MG_BUFF_OFFSET + (j << 1));
+
+		rem = __blk_end_request(req, 0, MG_SECTOR_SIZE);
+		if (rem)
+			mg_write_one(host, req);
 
 		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
-				MG_REG_COMMAND);
-	} while (__blk_end_request(req, 0, MG_SECTOR_SIZE));
+			MG_REG_COMMAND);
+	} while (rem);
 }
 
 static void mg_read_intr(struct mg_host *host)
 {
-	u32 i;
-	u16 *buff;
 	struct request *req;
+	u32 i;
 
 	/* check status */
 	do {
@@ -585,12 +609,9 @@ static void mg_read_intr(struct mg_host 
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
@@ -608,9 +629,8 @@ ok_to_read:
 
 static void mg_write_intr(struct mg_host *host)
 {
-	u32 i, j;
-	u16 *buff;
 	struct request *req;
+	u32 i;
 	bool rem;
 
 	/* get current segment of request */
@@ -634,12 +654,7 @@ static void mg_write_intr(struct mg_host
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
@@ -703,9 +718,6 @@ static unsigned int mg_issue_req(struct 
 		unsigned int sect_num,
 		unsigned int sect_cnt)
 {
-	u16 *buff;
-	u32 i;
-
 	switch (rq_data_dir(req)) {
 	case READ:
 		if (mg_out(host, sect_num, sect_cnt, MG_CMD_RD, &mg_read_intr)
@@ -732,12 +744,7 @@ static unsigned int mg_issue_req(struct 
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
