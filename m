Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbXK3X1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbXK3X1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbXK3X1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:27:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757940AbXK3X1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:27:05 -0500
Date: Fri, 30 Nov 2007 18:26:35 -0500 (EST)
Message-Id: <20071130.182635.31637441.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 05/28] blk_end_request: changing um (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
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

Index: 2.6.24-rc3-mm2/arch/um/drivers/ubd_kern.c
===================================================================
--- 2.6.24-rc3-mm2.orig/arch/um/drivers/ubd_kern.c
+++ 2.6.24-rc3-mm2/arch/um/drivers/ubd_kern.c
@@ -481,15 +481,7 @@ int thread_fd = -1;
 
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
