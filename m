Return-Path: <linux-kernel-owner+w=401wt.eu-S1762806AbYAKVvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762806AbYAKVvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762667AbYAKVub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:50:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761996AbYAKVu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:50:27 -0500
Date: Fri, 11 Jan 2008 16:50:18 -0500 (EST)
Message-Id: <20080111.165018.88470085.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 1/3] block: change virtio_blk to use blk-end-request
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts virtio_blk to use __blk_end_request() directly
so that end_{queued|dequeued}_request() can be removed.
Related 'uptodate' argument is converted to 'error'.

__blk_end_request() takes care of dequeueing request like below:

	if (!list_empty(&rq->queuelist))
		blkdev_dequeue_request(rq);

In the case of virtio_blk, blkdev_dequeue_request() has been done
in do_virtblk_request() and the queuelist is empty in blk_done().
So __blk_end_request() doesn't call blkdev_dequeue_request() and
the behavior of blk_done() doesn't change.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/virtio_blk.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

Index: 2.6.24-rc7/drivers/block/virtio_blk.c
===================================================================
--- 2.6.24-rc7.orig/drivers/block/virtio_blk.c
+++ 2.6.24-rc7/drivers/block/virtio_blk.c
@@ -45,20 +45,20 @@ static bool blk_done(struct virtqueue *v
 
 	spin_lock_irqsave(&vblk->lock, flags);
 	while ((vbr = vblk->vq->vq_ops->get_buf(vblk->vq, &len)) != NULL) {
-		int uptodate;
+		int error;
 		switch (vbr->in_hdr.status) {
 		case VIRTIO_BLK_S_OK:
-			uptodate = 1;
+			error = 0;
 			break;
 		case VIRTIO_BLK_S_UNSUPP:
-			uptodate = -ENOTTY;
+			error = -ENOTTY;
 			break;
 		default:
-			uptodate = 0;
+			error = -EIO;
 			break;
 		}
 
-		end_dequeued_request(vbr->req, uptodate);
+		__blk_end_request(vbr->req, error, blk_rq_bytes(vbr->req));
 		list_del(&vbr->list);
 		mempool_free(vbr, vblk->pool);
 	}
