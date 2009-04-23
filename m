Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbZDWKvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbZDWKvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 06:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbZDWKvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 06:51:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:34702 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291AbZDWKvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:51:11 -0400
Message-ID: <49F04851.70702@kernel.org>
Date: Thu, 23 Apr 2009 19:52:01 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       unsik Kim <donari75@gmail.com>
Subject: [PATCH block#for-linus] mg_disk: fix locking
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 10:51:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ and timeout handlers call functions which expect locked queue lock
without locking it.  Fix it.

While at it, convert 0s used as null pointer constant to NULLs.

[ Impact: fix locking, cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: unsik Kim <donari75@gmail.com>
---
Only compile tested.  unsik, can you please ack it?

Thanks.

 drivers/block/mg_disk.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

Index: block/drivers/block/mg_disk.c
===================================================================
--- block.orig/drivers/block/mg_disk.c
+++ block/drivers/block/mg_disk.c
@@ -160,11 +160,16 @@ static irqreturn_t mg_irq(int irq, void
 	struct mg_host *host = dev_id;
 	void (*handler)(struct mg_host *) = host->mg_do_intr;
 
-	host->mg_do_intr = 0;
+	spin_lock(&host->lock);
+
+	host->mg_do_intr = NULL;
 	del_timer(&host->timer);
 	if (!handler)
 		handler = mg_unexpected_intr;
 	handler(host);
+
+	spin_unlock(&host->lock);
+
 	return IRQ_HANDLED;
 }
 
@@ -319,7 +324,7 @@ static void mg_read(struct request *req)
 
 	remains = req->nr_sectors;
 
-	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_RD, 0) !=
+	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_RD, NULL) !=
 			MG_ERR_NONE)
 		mg_bad_rw_intr(host);
 
@@ -363,7 +368,7 @@ static void mg_write(struct request *req
 
 	remains = req->nr_sectors;
 
-	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_WR, 0) !=
+	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_WR, NULL) !=
 			MG_ERR_NONE) {
 		mg_bad_rw_intr(host);
 		return;
@@ -521,9 +526,11 @@ void mg_times_out(unsigned long data)
 	char *name;
 	struct request *req;
 
+	spin_lock_irq(&host->lock);
+
 	req = elv_next_request(host->breq);
 	if (!req)
-		return;
+		goto out_unlock;
 
 	host->mg_do_intr = NULL;
 
@@ -534,6 +541,8 @@ void mg_times_out(unsigned long data)
 	mg_bad_rw_intr(host);
 
 	mg_request(host->breq);
+out_unlock:
+	spin_unlock_irq(&host->lock);
 }
 
 static void mg_request_poll(struct request_queue *q)
