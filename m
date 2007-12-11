Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbXLKWnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbXLKWnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbXLKWmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:42:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164AbXLKWmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:42:38 -0500
Date: Tue, 11 Dec 2007 17:42:27 -0500 (EST)
Message-Id: <20071211.174227.66055336.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com, toshihiro.kobayashi@nokia.com,
       Hiroshi.DOYU@nokia.com
Subject: [PATCH 04/30] blk_end_request: changing arm (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts arm's OMAP mailbox driver to use
blk_end_request interfaces.

If the original code was converted literally, blk_end_request would
be called with '-EIO' because end_that_request_last() were called
with '0' (i.e. failure).
But I think these '0's are bugs in the original code because it's
unlikely that all requests are treated as failure.
(The bugs should have no effect unless these requests have an end_io
 callback.)

So I changed them to pass '0' (i.e. success) to blk_end_request.

Cc: Toshihiro Kobayashi <toshihiro.kobayashi@nokia.com>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---

 arch/arm/plat-omap/mailbox.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

Index: 2.6.24-rc4/arch/arm/plat-omap/mailbox.c
===================================================================
--- 2.6.24-rc4.orig/arch/arm/plat-omap/mailbox.c
+++ 2.6.24-rc4/arch/arm/plat-omap/mailbox.c
@@ -116,8 +116,8 @@ static void mbox_tx_work(struct work_str
 		}
 
 		spin_lock(q->queue_lock);
-		blkdev_dequeue_request(rq);
-		end_that_request_last(rq, 0);
+		if (__blk_end_request(rq, 0, 0))
+			BUG();
 		spin_unlock(q->queue_lock);
 	}
 }
@@ -149,10 +149,8 @@ static void mbox_rx_work(struct work_str
 
 		msg = (mbox_msg_t) rq->data;
 
-		spin_lock_irqsave(q->queue_lock, flags);
-		blkdev_dequeue_request(rq);
-		end_that_request_last(rq, 0);
-		spin_unlock_irqrestore(q->queue_lock, flags);
+		if (blk_end_request(rq, 0, 0))
+			BUG();
 
 		mbox->rxq->callback((void *)msg);
 	}
@@ -263,10 +261,8 @@ omap_mbox_read(struct device *dev, struc
 
 		*p = (mbox_msg_t) rq->data;
 
-		spin_lock_irqsave(q->queue_lock, flags);
-		blkdev_dequeue_request(rq);
-		end_that_request_last(rq, 0);
-		spin_unlock_irqrestore(q->queue_lock, flags);
+		if (blk_end_request(rq, 0, 0))
+			BUG();
 
 		if (unlikely(mbox_seq_test(mbox, *p))) {
 			pr_info("mbox: Illegal seq bit!(%08x) ignored\n", *p);
