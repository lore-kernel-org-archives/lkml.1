Return-Path: <linux-kernel-owner+w=401wt.eu-S1764380AbXKNGj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764380AbXKNGj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 01:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759620AbXKNGjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 01:39:49 -0500
Received: from ozlabs.org ([203.10.76.45]:44225 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758835AbXKNGjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 01:39:48 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] Attempt to get eject failures back to ioctl(CDROMEJECT)
Date: Wed, 14 Nov 2007 17:39:46 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711141739.46960.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

    As you asked for some time ago.  Of course, it turns out that the eject
command ignores the error anyway, but it's nice that it now errors.

    Not entirely comfortable with this patch: there's a req->errors but
that seems to have some existing semantics I'm not sure of, so I simply
added a new way of flagging an error.

Cheers,
Rusty.
---

Currently the CDROMEJECT ioctl always succeeds; it'd be nice if we
managed to get the errno passed back through the request.

This patch tries to do that.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r a7da575b248f block/ll_rw_blk.c
--- a/block/ll_rw_blk.c	Wed Nov 14 15:44:39 2007 +1100
+++ b/block/ll_rw_blk.c	Wed Nov 14 17:33:55 2007 +1100
@@ -261,6 +261,7 @@ static void rq_init(struct request_queue
 	rq->end_io_data = NULL;
 	rq->completion_data = NULL;
 	rq->next_rq = NULL;
+	rq->errno = 0;
 }
 
 /**
@@ -2657,7 +2658,9 @@ int blk_execute_rq(struct request_queue 
 	blk_execute_rq_nowait(q, bd_disk, rq, at_head, blk_end_sync_rq);
 	wait_for_completion(&wait);
 
-	if (rq->errors)
+	if (rq->errno)
+		err = rq->errno;
+	else if (rq->errors)
 		err = -EIO;
 
 	return err;
@@ -3427,8 +3430,10 @@ static int __end_that_request_first(stru
 	 * extend uptodate bool to allow < 0 value to be direct io error
 	 */
 	error = 0;
-	if (end_io_error(uptodate))
+	if (end_io_error(uptodate)) {
+		req->errno = uptodate;
 		error = !uptodate ? -EIO : uptodate;
+	}
 
 	/*
 	 * for a REQ_BLOCK_PC request, we want to carry any eventual
diff -r a7da575b248f drivers/block/virtio_blk.c
--- a/drivers/block/virtio_blk.c	Wed Nov 14 15:44:39 2007 +1100
+++ b/drivers/block/virtio_blk.c	Wed Nov 14 17:33:55 2007 +1100
@@ -51,7 +51,7 @@ static bool blk_done(struct virtqueue *v
 			uptodate = 1;
 			break;
 		case VIRTIO_BLK_S_UNSUPP:
-			uptodate = -ENOTTY;
+			uptodate = -ENOSYS;
 			break;
 		default:
 			uptodate = 0;
diff -r a7da575b248f include/linux/blkdev.h
--- a/include/linux/blkdev.h	Wed Nov 14 15:44:39 2007 +1100
+++ b/include/linux/blkdev.h	Wed Nov 14 17:33:55 2007 +1100
@@ -281,6 +281,8 @@ struct request {
 
 	int tag;
 	int errors;
+	/* If this isn't set, assume -EIO. */
+	int errno;
 
 	int ref_count;
 
