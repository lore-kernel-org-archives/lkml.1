Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbYDXE6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbYDXE6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 00:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbYDXE4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 00:56:42 -0400
Received: from ozlabs.org ([203.10.76.45]:58764 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbYDXE4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 00:56:40 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 23 Apr 2008 23:56:36 -0500
Cc: virtualization@lists.linux-foundation.org,
       "ron minnich" <rminnich@gmail.com>
Subject: [PATCH 5/6] virtio: de-structify virtio_block status byte
Cc: "ron minnich" <rminnich@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804241456.36351.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ron Minnich points out that a struct containing a char is not always
sizeof(char); simplest to remove the structure to avoid confusion.

Cc: "ron minnich" <rminnich@gmail.com>

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/lguest/lguest.c |   12 ++++++------
 drivers/block/virtio_blk.c    |    6 +++---
 include/linux/virtio_blk.h    |    7 +------
 3 files changed, 10 insertions(+), 15 deletions(-)

diff -r 300d39c406d3 Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c	Thu Apr 24 14:05:57 2008 +1000
+++ b/Documentation/lguest/lguest.c	Thu Apr 24 14:11:27 2008 +1000
@@ -1859,7 +1859,7 @@ static bool service_io(struct device *de
 	struct vblk_info *vblk = dev->priv;
 	unsigned int out_num, in_num, wlen;
 	int head, ret;
-	struct virtio_blk_inhdr *in;
+	u8 *in;
 	struct virtio_blk_outhdr *out;
 	struct iovec iov[dev->vq->vqi.vring.num];
 	off64_t off;
@@ -1877,7 +1877,7 @@ static bool service_io(struct device *de
 		     head, out_num, in_num);
 
 	out = convert(&iov[0], struct virtio_blk_outhdr);
-	in = convert(&iov[out_num+in_num-1], struct virtio_blk_inhdr);
+	in = convert(&iov[out_num+in_num-1], u8);
 	off = out->sector * 512;
 
 	/* The block device implements "barriers", where the Guest indicates
@@ -1891,7 +1891,7 @@ static bool service_io(struct device *de
 	 * It'd be nice if we supported eject, for example, but we don't. */
 	if (out->type & VIRTIO_BLK_T_SCSI_CMD) {
 		fprintf(stderr, "Scsi commands unsupported\n");
-		in->status = VIRTIO_BLK_S_UNSUPP;
+		*in = VIRTIO_BLK_S_UNSUPP;
 		wlen = sizeof(*in);
 	} else if (out->type & VIRTIO_BLK_T_OUT) {
 		/* Write */
@@ -1914,7 +1914,7 @@ static bool service_io(struct device *de
 			errx(1, "Write past end %llu+%u", off, ret);
 		}
 		wlen = sizeof(*in);
-		in->status = (ret >= 0 ? VIRTIO_BLK_S_OK : VIRTIO_BLK_S_IOERR);
+		*in = (ret >= 0 ? VIRTIO_BLK_S_OK : VIRTIO_BLK_S_IOERR);
 	} else {
 		/* Read */
 
@@ -1927,10 +1927,10 @@ static bool service_io(struct device *de
 		verbose("READ from sector %llu: %i\n", out->sector, ret);
 		if (ret >= 0) {
 			wlen = sizeof(*in) + ret;
-			in->status = VIRTIO_BLK_S_OK;
+			*in = VIRTIO_BLK_S_OK;
 		} else {
 			wlen = sizeof(*in);
-			in->status = VIRTIO_BLK_S_IOERR;
+			*in = VIRTIO_BLK_S_IOERR;
 		}
 	}
 
diff -r 300d39c406d3 drivers/block/virtio_blk.c
--- a/drivers/block/virtio_blk.c	Thu Apr 24 14:05:57 2008 +1000
+++ b/drivers/block/virtio_blk.c	Thu Apr 24 14:11:27 2008 +1000
@@ -35,7 +35,7 @@ struct virtblk_req
 	struct list_head list;
 	struct request *req;
 	struct virtio_blk_outhdr out_hdr;
-	struct virtio_blk_inhdr in_hdr;
+	u8 status;
 };
 
 static void blk_done(struct virtqueue *vq)
@@ -48,7 +48,7 @@ static void blk_done(struct virtqueue *v
 	spin_lock_irqsave(&vblk->lock, flags);
 	while ((vbr = vblk->vq->vq_ops->get_buf(vblk->vq, &len)) != NULL) {
 		int uptodate;
-		switch (vbr->in_hdr.status) {
+		switch (vbr->status) {
 		case VIRTIO_BLK_S_OK:
 			uptodate = 1;
 			break;
@@ -101,7 +101,7 @@ static bool do_req(struct request_queue 
 	sg_init_table(vblk->sg, VIRTIO_MAX_SG);
 	sg_set_buf(&vblk->sg[0], &vbr->out_hdr, sizeof(vbr->out_hdr));
 	num = blk_rq_map_sg(q, vbr->req, vblk->sg+1);
-	sg_set_buf(&vblk->sg[num+1], &vbr->in_hdr, sizeof(vbr->in_hdr));
+	sg_set_buf(&vblk->sg[num+1], &vbr->status, sizeof(vbr->status));
 
 	if (rq_data_dir(vbr->req) == WRITE) {
 		vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
diff -r 300d39c406d3 include/linux/virtio_blk.h
--- a/include/linux/virtio_blk.h	Thu Apr 24 14:05:57 2008 +1000
+++ b/include/linux/virtio_blk.h	Thu Apr 24 14:11:27 2008 +1000
@@ -48,13 +48,8 @@ struct virtio_blk_outhdr
 	__u64 sector;
 };
 
+/* And this is the final byte of the write scatter-gather list. */
 #define VIRTIO_BLK_S_OK		0
 #define VIRTIO_BLK_S_IOERR	1
 #define VIRTIO_BLK_S_UNSUPP	2
-
-/* This is the first element of the write scatter-gather list */
-struct virtio_blk_inhdr
-{
-	unsigned char status;
-};
 #endif /* _LINUX_VIRTIO_BLK_H */

