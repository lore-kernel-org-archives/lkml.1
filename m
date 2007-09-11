Return-Path: <linux-kernel-owner+w=401wt.eu-S933649AbXIKS6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649AbXIKS6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932910AbXIKS6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:58:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932884AbXIKS6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:58:15 -0400
Date: Tue, 11 Sep 2007 14:57:53 -0400 (EDT)
Message-Id: <20070911.145753.91448649.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 05/27] blk_end_request: changing um (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts um to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 arch/um/drivers/ubd_kern.c |   10 +---------
 1 files changed, 1 insertion(+), 9 deletions(-)

diff -rupN 04-arm-caller-change/arch/um/drivers/ubd_kern.c 05-um-caller-change/arch/um/drivers/ubd_kern.c
--- 04-arm-caller-change/arch/um/drivers/ubd_kern.c	2007-08-27 21:32:35.000000000 -0400
+++ 05-um-caller-change/arch/um/drivers/ubd_kern.c	2007-09-10 17:59:35.000000000 -0400
@@ -476,15 +476,7 @@ int thread_fd = -1;
 
 static void ubd_end_request(struct request *req, int bytes, int uptodate)
 {
-	if (!end_that_request_first(req, uptodate, bytes >> 9)) {
-		struct ubd *dev = req->rq_disk->private_data;
-		unsigned long flags;
-
-		add_disk_randomness(req->rq_disk);
-		spin_lock_irqsave(&dev->lock, flags);
-		end_that_request_last(req, uptodate);
-		spin_unlock_irqrestore(&dev->lock, flags);
-	}
+	blk_end_request(req, uptodate, bytes);
 }
 
 /* Callable only from interrupt context - otherwise you need to do
