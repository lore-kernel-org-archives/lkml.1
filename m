Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328Ab0AWAZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab0AWAZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317Ab0AWAZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:25:10 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37950 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab0AWAZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:25:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kX5IWtUDda7B9NMfnECPknUA5j6xH0ImU9uqViF9fEIkLOQ7Luoj16H7KW0RTjcG2I
         qlAeQInhvfvpBqMTGxvj11ss90j8GM4NWNRR0yYRMr1mFlGHPom2yAOVPZ06v85ppBMd
         BocSDnoEisIOtTr/Iexp05eGEtE7hTET8/yy8=
Subject: [PATCH 6/8] blktrans: flush all requests before we remove the
 device
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1264205925.31827.3.camel@maxim-laptop>
References: <1264205925.31827.3.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Jan 2010 02:24:58 +0200
Message-ID: <1264206298.31827.10.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6d5a70a18bea40bfc354e73d7fde5042465fc534 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Sat, 23 Jan 2010 02:09:11 +0200
Subject: [PATCH 6/8] blktrans: flush all requests before we remove the device

Flush all requests, so we can be sure we don't deadlock the system later
when we remove the disk queue.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtd_blkdevs.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index f165115..33bdef1 100644
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
 

@@ -359,6 +365,8 @@ error1:
 
 int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 {
+	unsigned long flags;
+
 	if (mutex_trylock(&mtd_table_mutex)) {
 		mutex_unlock(&mtd_table_mutex);
 		BUG();
@@ -369,7 +377,11 @@ int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
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



