Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbZI2RSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbZI2RSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZI2RSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:18:44 -0400
Received: from ozlabs.org ([203.10.76.45]:59245 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbZI2RSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:18:43 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 30 Sep 2009 02:48:44 +0930
Subject: [PATCH 3/4] virtio_blk: implement a request-based ID command, VIRTIO_BLK_T_GET_ID
Cc: Jens Axboe <axboe@kernel.dk>, virtualization@lists.linux-foundation.org,
       john cooper <john.cooper@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909300248.44583.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is fairly simple: we create a request pointing at the 1k kmalloc,
then just change the type so our do_req() knows to mark it as a GET_ID
for the server.

Seems to work here; the only issue is that the error didn't get passed
back from __blk_end_request_all to blk_execute_rq, so we set ->errors
to 1 on error.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/virtio_blk.c |   66 +++++++++++++++++++++++++++++++++++----------
 include/linux/virtio_blk.h |    4 ++
 2 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -72,6 +72,8 @@ static void blk_done(struct virtqueue *v
 			vbr->req->sense_len = vbr->in_hdr.sense_len;
 			vbr->req->errors = vbr->in_hdr.errors;
 		}
+		if (blk_special_request(vbr->req))
+			vbr->req->errors = (error != 0);
 
 		__blk_end_request_all(vbr->req, error);
 		list_del(&vbr->list);
@@ -105,6 +107,11 @@ static bool do_req(struct request_queue 
 		vbr->out_hdr.sector = 0;
 		vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
 		break;
+	case REQ_TYPE_SPECIAL:
+		vbr->out_hdr.type = VIRTIO_BLK_T_GET_ID;
+		vbr->out_hdr.sector = 0;
+		vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
+		break;
 	case REQ_TYPE_LINUX_BLOCK:
 		if (req->cmd[0] == REQ_LB_OP_FLUSH) {
 			vbr->out_hdr.type = VIRTIO_BLK_T_FLUSH;
@@ -201,29 +208,59 @@ struct virtio_blk_config_deprecated {
 	__u8 identify[VIRTIO_BLK_ID_BYTES];
 } __attribute__((packed));
 
-static int virtblk_identify(struct gendisk *disk, void *argp)
+static int virtblk_identify_deprecated(struct virtio_blk *vblk, void *opaque)
+{
+	return virtio_config_buf(vblk->vdev, VIRTIO_BLK_F_IDENTIFY,
+		offsetof(struct virtio_blk_config_deprecated, identify), opaque,
+		VIRTIO_BLK_ID_BYTES);
+}
+
+static int virtblk_get_id(struct virtio_blk *vblk, void *opaque)
+{
+	struct request *req;
+	struct bio *bio;
+
+	bio = bio_map_kern(vblk->disk->queue, opaque, VIRTIO_BLK_ID_BYTES,
+			   GFP_KERNEL);
+	if (IS_ERR(bio))
+		return PTR_ERR(bio);
+
+	req = blk_make_request(vblk->disk->queue, bio, GFP_KERNEL);
+	if (IS_ERR(req)) {
+		bio_put(bio);
+		return PTR_ERR(req);
+	}
+
+	/* This is actually a special request. */
+	req->cmd_type = REQ_TYPE_SPECIAL;
+	return blk_execute_rq(vblk->disk->queue, vblk->disk, req, false);
+}
+
+static int virtblk_identify(struct gendisk *disk, void __user *argp)
 {
 	struct virtio_blk *vblk = disk->private_data;
 	void *opaque;
-	int err = -ENOMEM;
+	int err;
 
 	opaque = kmalloc(VIRTIO_BLK_ID_BYTES, GFP_KERNEL);
 	if (!opaque)
-		goto out;
+		return -ENOMEM;
 
-	err = virtio_config_buf(vblk->vdev, VIRTIO_BLK_F_IDENTIFY,
-		offsetof(struct virtio_blk_config_deprecated, identify), opaque,
-		VIRTIO_BLK_ID_BYTES);
+	/* The modern way. */
+	if (virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_GET_ID))
+		err = virtblk_get_id(vblk, opaque);
+	/* The deprecated way. */
+	else if (virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_IDENTIFY))
+		err = virtblk_identify_deprecated(vblk, opaque);
+	/* No way. */
+	else
+		err = -ENOTTY;
 
-	if (err)
-		goto out_kfree;
+	if (!err)
+		if (copy_to_user(argp, opaque, VIRTIO_BLK_ID_BYTES))
+			err = -EFAULT;
 
-	if (copy_to_user(argp, opaque, VIRTIO_BLK_ID_BYTES))
-		err = -EFAULT;
-
-out_kfree:
 	kfree(opaque);
-out:
 	return err;
 }
 
@@ -460,7 +497,8 @@ static struct virtio_device_id id_table[
 static unsigned int features[] = {
 	VIRTIO_BLK_F_BARRIER, VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX,
 	VIRTIO_BLK_F_GEOMETRY, VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
-	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_IDENTIFY, VIRTIO_BLK_F_FLUSH
+	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_IDENTIFY, VIRTIO_BLK_F_FLUSH,
+	VIRTIO_BLK_F_GET_ID
 };
 
 /*
diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
--- a/include/linux/virtio_blk.h
+++ b/include/linux/virtio_blk.h
@@ -15,6 +15,7 @@
 #define VIRTIO_BLK_F_SCSI	7	/* Supports scsi command passthru */
 #define VIRTIO_BLK_F_IDENTIFY	8	/* ATA IDENTIFY support (deprecated) */
 #define VIRTIO_BLK_F_FLUSH	9	/* Cache flush command support */
+#define VIRTIO_BLK_F_GET_ID	10	/* VIRTIO_BLK_T_GET_ID support */
 
 #define VIRTIO_BLK_ID_BYTES	(sizeof(__u16[256]))	/* IDENTIFY DATA */
 
@@ -65,6 +66,9 @@ struct virtio_blk_config {
 /* Cache flush command */
 #define VIRTIO_BLK_T_FLUSH	4
 
+/* Get ID command */
+#define VIRTIO_BLK_T_GET_ID	8
+
 /* Barrier before this op. */
 #define VIRTIO_BLK_T_BARRIER	0x80000000
 

