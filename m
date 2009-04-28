Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbZD1EJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbZD1EJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 00:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbZD1EHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 00:07:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:38775 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbZD1EHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 00:07:41 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, donari75@gmail.com,
       bzolnier@gmail.com, joerg@dorchain.net, geert@linux-m68k.org,
       davem@davemloft.net, jdike@linux.intel.com, benh@kernel.crashing.org,
       Laurent@lvivier.info
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/14] hd: clean up request completion paths
Date: Tue, 28 Apr 2009 13:06:11 +0900
Message-Id: <1240891577-4813-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240891577-4813-1-git-send-email-tj@kernel.org>
References: <1240891577-4813-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 28 Apr 2009 04:06:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hd read/write_intr() functions manually manipulate request to
incrementally complete it, which block layer already supports.  Simply
use block layer completion routines instead of manual partial
completion.

While at it, clear unnecessary elv_next_request() check at the tail of
read_intr().  This also makes read and write_intr() more consistent.

[ Impact: cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/hd.c |   36 ++++++++++++------------------------
 1 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index 5cb300b..75b9ca9 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -452,32 +452,25 @@ static void read_intr(void)
 	bad_rw_intr();
 	hd_request();
 	return;
+
 ok_to_read:
 	req = CURRENT;
 	insw(HD_DATA, req->buffer, 256);
-	req->sector++;
-	req->buffer += 512;
-	req->errors = 0;
-	i = --req->nr_sectors;
-	--req->current_nr_sectors;
 #ifdef DEBUG
 	printk("%s: read: sector %ld, remaining = %ld, buffer=%p\n",
-		req->rq_disk->disk_name, req->sector, req->nr_sectors,
+		req->rq_disk->disk_name, req->sector + 1, req->nr_sectors - 1,
 		req->buffer+512);
 #endif
-	if (req->current_nr_sectors <= 0)
-		__blk_end_request_cur(req, 0);
-	if (i > 0) {
+	if (__blk_end_request(req, 0, 512)) {
 		SET_HANDLER(&read_intr);
 		return;
 	}
+
 	(void) inb_p(HD_STATUS);
 #if (HD_DELAY > 0)
 	last_req = read_timer();
 #endif
-	if (elv_next_request(QUEUE))
-		hd_request();
-	return;
+	hd_request();
 }
 
 static void write_intr(void)
@@ -499,23 +492,18 @@ static void write_intr(void)
 	bad_rw_intr();
 	hd_request();
 	return;
+
 ok_to_write:
-	req->sector++;
-	i = --req->nr_sectors;
-	--req->current_nr_sectors;
-	req->buffer += 512;
-	if (!i || (req->bio && req->current_nr_sectors <= 0))
-		__blk_end_request_cur(req, 0);
-	if (i > 0) {
+	if (__blk_end_request(req, 0, 512)) {
 		SET_HANDLER(&write_intr);
 		outsw(HD_DATA, req->buffer, 256);
-	} else {
+		return;
+	}
+
 #if (HD_DELAY > 0)
-		last_req = read_timer();
+	last_req = read_timer();
 #endif
-		hd_request();
-	}
-	return;
+	hd_request();
 }
 
 static void recal_intr(void)
-- 
1.6.0.2

