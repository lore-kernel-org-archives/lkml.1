Return-Path: <linux-kernel-owner+w=401wt.eu-S1758412AbZD1Dxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412AbZD1Dxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 23:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbZD1Dwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 23:52:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:46126 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552AbZD1Dwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 23:52:36 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, donari75@gmail.com,
       bzolnier@gmail.com, linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] mg_disk: fix locking
Date: Tue, 28 Apr 2009 12:52:17 +0900
Message-Id: <1240890740-3462-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240890740-3462-1-git-send-email-tj@kernel.org>
References: <1240890740-3462-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 28 Apr 2009 03:52:26 +0000 (UTC)
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
 drivers/block/mg_disk.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index fb39d9a..d3e72ad 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -160,11 +160,16 @@ static irqreturn_t mg_irq(int irq, void *dev_id)
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
 
@@ -363,7 +368,7 @@ static void mg_write(struct request *req)
 
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
-- 
1.6.0.2

