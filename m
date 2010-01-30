Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940Ab0A3PD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0A3PD3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 10:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329Ab0A3PDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 10:03:23 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:34072 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab0A3PDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 10:03:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=k8QKbsY6XqLRurhL+YzbN4A/AYH/OIsZriZ8wM1r7xvcHh1/WTZxQRpgNkREkFEY1O
         DaSStDKdEhmg6rNjC314z1NZPCF4Cznr83Vr//YuVf/MEmSDW/lc2EF1T1LlZ5h0KA91
         h53LnA8awWenTXZh8G5QuzERKUAx+0CDQ5jxc=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 06/17] blktrans: flush all requests before we remove the device
Date: Sat, 30 Jan 2010 17:02:37 +0200
Message-Id: <1264863768-27606-7-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1264863768-27606-1-git-send-email-maximlevitsky@gmail.com>
References: <1264863768-27606-1-git-send-email-maximlevitsky@gmail.com>
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
index 841c6ae..a65eb07 100644
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
 
 
@@ -358,6 +364,8 @@ error1:
 
 int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 {
+	unsigned long flags;
+
 	if (mutex_trylock(&mtd_table_mutex)) {
 		mutex_unlock(&mtd_table_mutex);
 		BUG();
@@ -368,7 +376,11 @@ int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
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

