Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab0BIRAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:00:45 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:65144 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab0BIQ6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 11:58:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PMnhU6Uw0Uh6dHj6YKvycgxiRcwlAFzTFHz/hFkCS5lS7A0s9VNs3YsvGOxtyHmqV0
         MWeKPRdO8uS0mE8nC4gArrsQhi0CjAZkQpvVe5PLzPMLsSFFpknehSLXdIG3JR6G9FtX
         pAjv7x7JdkIpJcLpMh3L/+o4oPUszH9kqsaS4=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 06/17] blktrans: flush all requests before we remove the device
Date: Tue,  9 Feb 2010 18:57:34 +0200
Message-Id: <1265734665-22656-7-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265734665-22656-1-git-send-email-maximlevitsky@gmail.com>
References: <1265734665-22656-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flush all requests, so we can be sure we don't deadlock the system later
when we remove the disk queue.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtd_blkdevs.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 082969c..9992b2d 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -115,7 +115,13 @@ static int mtd_blktrans_thread(void *arg)
 static void mtd_blktrans_request(struct request_queue *rq)
 {
 	struct mtd_blktrans_dev *dev = rq->queuedata;
-	wake_up_process(dev->thread);
+	struct request *req = NULL;
+
+	if (dev->deleted)
+		while ((req = blk_fetch_request(rq)) != NULL)
+			__blk_end_request_all(req, -ENODEV);
+	else
+		wake_up_process(dev->thread);
 }
 
 
@@ -357,6 +363,8 @@ error1:
 
 int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 {
+	unsigned long flags;
+
 	if (mutex_trylock(&mtd_table_mutex)) {
 		mutex_unlock(&mtd_table_mutex);
 		BUG();
@@ -367,7 +375,11 @@ int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 	/* stop new requests to arrive */
 	del_gendisk(old->disk);
 
+	/* flush current requests */
+	spin_lock_irqsave(&old->queue_lock, flags);
 	old->deleted = 1;
+	blk_start_queue(old->rq);
+	spin_unlock_irqrestore(&old->queue_lock, flags);
 
 	/* Stop the thread */
 	kthread_stop(old->thread);
-- 
1.6.3.3

