Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbXD0VDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbXD0VDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757276AbXD0VDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:03:04 -0400
Received: from gretel.pobox.com ([208.58.1.197]:60627 "EHLO gretel.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757245AbXD0VDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:03:01 -0400
X-Greylist: delayed 1889 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2007 17:03:01 EDT
Message-ID: <46325A6F.4050705@pobox.com>
Date: Fri, 27 Apr 2007 16:17:51 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@pobox.com>
Reply-To: Alan.Brunelle@pobox.com
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH linux-2.6-block.git] Fix blktrace trace ordering for plug
 branch
Content-Type: multipart/mixed;
 boundary="------------020605070204010906010503"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020605070204010906010503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The attached patch will correct the ordering of trace output between 
request queue insertions (I) and unplug calls (U). Right now the insert 
precedes the unplug, which just isn't right:

 65,128  0        1    67.699868965  7882  Q   R 0 + 1 [aiod]
 65,128  0        2    67.699876462  7882  G   R 0 + 1 [aiod]
 65,128  0        3    67.699878286  7882  P   W [aiod]
 65,128  0        4    67.699880491  7882  I   R 0 + 1 [aiod]
 65,128  0        5    67.699887589  7882  U   R [aiod] 1
 65,128  0        6    67.699898317    54  D   R 0 + 1 [kblockd/0]
 65,128  2      153    67.700126590     0  C   R 0 + 1 [0]

With the patch provided the unplug comes first:

 65,128  3        1     0.000000000  7045  Q   R 0 + 1 [aiod]
 65,128  3        2     0.000002295  7045  G   R 0 + 1 [aiod]
 65,128  3        3     0.000002617  7045  P   W [aiod]
 65,128  3        4     0.000003685  7045  U   R [aiod] 1
 65,128  3        5     0.000004107  7045  I   R 0 + 1 [aiod]
 65,128  3        6     0.000009491    57  D   R 0 + 1 [kblockd/3]
 65,128  2        1     0.000232447     0  C   R 0 + 1 [0]

Jens: If you agree, the patch can be applied to your plug branch for 
git://git.kernel.dk/data/git/linux-2.6-block.git

Thanks,
Alan

--------------020605070204010906010503
Content-Type: text/x-patch;
 name="fix-unplug-order.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-unplug-order.patch"

From: Alan D. Brunelle <Alan.Brunelle@hp.com>

Fix unplug/insert trace inversion problem.

Signed-off-by: Alan D. Brunelle <Alan.Brunelle@hp.com>
---
 block/ll_rw_blk.c      |    8 ++++----
 include/linux/blkdev.h |    1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 46d29f7..3bec97f 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2981,6 +2981,7 @@ out_unlock:
 		if (bio_data_dir(bio) == WRITE && ioc->qrcu_idx == -1)
 			ioc->qrcu_idx = qrcu_read_lock(&q->qrcu);
 		list_add_tail(&req->queuelist, &ioc->plugged_list);
+		ioc->plugged_list_len++;
 	}
 
 out:
@@ -3720,7 +3721,6 @@ void blk_unplug_current(void)
 	struct io_context *ioc = current->io_context;
 	struct request *req;
 	request_queue_t *q;
-	int nr_unplug;
 
 	if (!ioc)
 		return;
@@ -3735,19 +3735,19 @@ void blk_unplug_current(void)
 	if (list_empty(&ioc->plugged_list))
 		goto out;
 
-	nr_unplug = 0;
+	blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_IO, NULL, ioc->plugged_list_len);
+
 	spin_lock_irq(q->queue_lock);
 	do {
 		req = list_entry_rq(ioc->plugged_list.next);
 		list_del_init(&req->queuelist);
 		add_request(q, req);
-		nr_unplug++;
 	} while (!list_empty(&ioc->plugged_list));
+	ioc->plugged_list_len = 0;
 
 	spin_unlock_irq(q->queue_lock);
 
 	queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
-	blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_IO, NULL, nr_unplug);
 
 out:
 	/*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f8cdd44..848564c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -113,6 +113,7 @@ struct io_context {
 	 */
 	int plugged;
 	int qrcu_idx;
+	int plugged_list_len;
 	struct list_head plugged_list;
 	struct request_queue *plugged_queue;
 

--------------020605070204010906010503--
