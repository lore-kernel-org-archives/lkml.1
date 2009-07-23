Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbZGWEXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbZGWEXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 00:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbZGWEXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 00:23:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:50037 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbZGWEXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 00:23:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=II6dzfEVyDsYVby6BEHGTeF3UH19lJXHiQdcTLLqVfMFp67d65FWhN5Ecmt27iluAY
         jIaTWNed+CRhbBH/JpaLwvmX97HAfmu+hweNjZxRwIS3GvKulTqK1gnZiBS+qng3neGJ
         LuUjQT2enOFmapBSpqta9SpkcqaBapOVfEJZY=
From: unsik Kim <donari75@gmail.com>
To: bzolnier@gmail.com
Cc: tj@kernel.org, linux-kernel@vger.kernel.org,
       unsik Kim <donari75@gmail.com>
Subject: [PATCH] mg_disk: Add missing ready status check on mg_write()
Date: Thu, 23 Jul 2009 13:21:18 +0900
Message-Id: <1248322878-3804-1-git-send-email-donari75@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <200907031516.51893.bzolnier@gmail.com>
References: <200907031516.51893.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When last sector is written, ready bit of status register should be
checked.

Signed-off-by: unsik Kim <donari75@gmail.com>
---
 drivers/block/mg_disk.c |   32 +++++++++++++++-----------------
 1 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index f8149db..64f90f5 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -516,16 +516,16 @@ static void mg_write_one(struct mg_host *host, struct request *req)
 static void mg_write(struct request *req)
 {
 	struct mg_host *host = req->rq_disk->private_data;
-	bool rem;
+	unsigned int rem = blk_rq_sectors(req);
 
-	if (mg_out(host, blk_rq_pos(req), blk_rq_sectors(req),
+	if (mg_out(host, blk_rq_pos(req), rem,
 		   MG_CMD_WR, NULL) != MG_ERR_NONE) {
 		mg_bad_rw_intr(host);
 		return;
 	}
 
 	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
-	       blk_rq_sectors(req), blk_rq_pos(req), req->buffer);
+	       rem, blk_rq_pos(req), req->buffer);
 
 	if (mg_wait(host, ATA_DRQ,
 		    MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
@@ -533,25 +533,23 @@ static void mg_write(struct request *req)
 		return;
 	}
 
-	mg_write_one(host, req);
+	do {
+		mg_write_one(host, req);
 
-	outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
+		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
+				MG_REG_COMMAND);
 
-	do {
-		if (blk_rq_sectors(req) > 1 &&
-		     mg_wait(host, ATA_DRQ,
-			     MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
+		rem--;
+		if (rem > 1 && mg_wait(host, ATA_DRQ,
+					MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
+			mg_bad_rw_intr(host);
+			return;
+		} else if (mg_wait(host, MG_STAT_READY,
+					MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
 			return;
 		}
-
-		rem = mg_end_request(host, 0, MG_SECTOR_SIZE);
-		if (rem)
-			mg_write_one(host, req);
-
-		outb(MG_CMD_WR_CONF,
-		     (unsigned long)host->dev_base + MG_REG_COMMAND);
-	} while (rem);
+	} while (mg_end_request(host, 0, MG_SECTOR_SIZE));
 }
 
 static void mg_read_intr(struct mg_host *host)
-- 
1.6.0.6

