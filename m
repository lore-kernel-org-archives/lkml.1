Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbZCRJUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbZCRJUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZCRJT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:19:28 -0400
Received: from mail.suse.de ([195.135.220.2]:38232 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbZCRJT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:19:26 -0400
Message-ID: <49C0BBFB.5040605@suse.de>
Date: Wed, 18 Mar 2009 10:16:43 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: VIRTIO_BLK_T_SCSI_CMD handling in virtio-blk
References: <20090318060919.GA21777@infradead.org> <200903180947.36878.borntraeger@de.ibm.com>
In-Reply-To: <200903180947.36878.borntraeger@de.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------060309070601070502010900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060309070601070502010900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Christian Borntraeger wrote:
> Am Wednesday 18 March 2009 07:09:19 schrieb Christoph Hellwig:
>> Currently virtio-blk just sends down the payload for packet command
>> requests, setting the VIRTIO_BLK_T_SCSI_CMD flag in the type field and
>> zeroing out the sector field.
>>
>> But to make any sense of the payload of a packet command we need the
>> scsi command block (request->cmd) which specifies the operation,
>> location and length for this command.
>>
>> All backends that I checked just fail VIRTIO_BLK_T_SCSI_CMD commands, so
>> AFAICS no harm is done.  But should we really keep this broken support
>> in the protocol around?  If we do want to support packet commands in
>> the future we should probably just add the command as the first S/G list
>> entry.
> 
> Hannes did some implementation for SCSI command passthrough:
> https://lists.linux-foundation.org/pipermail/virtualization/2008-August/011629.html
> 
> After some addon fix this was working pretty well. I dont know why Hannes never
> pushed the final version upstream.
> 
Sorry, being busy. Someone keeps sending me multipath bugs to worry about.
Patch is attached.

Please do keep me in the loop here, I'm not subscribed to lkml.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------060309070601070502010900
Content-Type: text/plain;
 name="virtio-blk-scsi-passthrough"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="virtio-blk-scsi-passthrough"

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 4225109..46f03d2 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -35,6 +35,7 @@ struct virtblk_req
 	struct list_head list;
 	struct request *req;
 	struct virtio_blk_outhdr out_hdr;
+	struct virtio_blk_inhdr in_hdr;
 	u8 status;
 };
 
@@ -47,20 +48,29 @@ static void blk_done(struct virtqueue *vq)
 
 	spin_lock_irqsave(&vblk->lock, flags);
 	while ((vbr = vblk->vq->vq_ops->get_buf(vblk->vq, &len)) != NULL) {
-		int uptodate;
+		int error;
+		unsigned int bytes;
 		switch (vbr->status) {
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
+		if (blk_pc_request(vbr->req)) {
+			vbr->req->data_len = vbr->in_hdr.residual;
+			bytes = vbr->in_hdr.data_len;
+			vbr->req->sense_len = vbr->in_hdr.sense_len;
+			vbr->req->errors = vbr->in_hdr.status;
+		} else
+			bytes = blk_rq_bytes(vbr->req);
+
+		__blk_end_request(vbr->req, error, bytes);
 		list_del(&vbr->list);
 		mempool_free(vbr, vblk->pool);
 	}
@@ -72,7 +82,7 @@ static void blk_done(struct virtqueue *vq)
 static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		   struct request *req)
 {
-	unsigned long num, out, in;
+	unsigned long num, out = 0, in = 0;
 	struct virtblk_req *vbr;
 
 	vbr = mempool_alloc(vblk->pool, GFP_ATOMIC);
@@ -99,20 +109,31 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 
 	/* This init could be done at vblk creation time */
 	sg_init_table(vblk->sg, VIRTIO_MAX_SG);
-	sg_set_buf(&vblk->sg[0], &vbr->out_hdr, sizeof(vbr->out_hdr));
-	num = blk_rq_map_sg(q, vbr->req, vblk->sg+1);
-	sg_set_buf(&vblk->sg[num+1], &vbr->status, sizeof(vbr->status));
-
-	if (rq_data_dir(vbr->req) == WRITE) {
-		vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
-		out = 1 + num;
-		in = 1;
-	} else {
-		vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
-		out = 1;
-		in = 1 + num;
+	sg_set_buf(&vblk->sg[out], &vbr->out_hdr, sizeof(vbr->out_hdr));
+	out++;
+	if (blk_pc_request(vbr->req)) {
+		sg_set_buf(&vblk->sg[out], vbr->req->cmd, vbr->req->cmd_len);
+		out++;
+	}
+	num = blk_rq_map_sg(q, vbr->req, vblk->sg+out);
+	if (blk_pc_request(vbr->req)) {
+		sg_set_buf(&vblk->sg[num+out+in], vbr->req->sense, 96);
+		in++;
+		sg_set_buf(&vblk->sg[num+out+in], &vbr->in_hdr,
+			   sizeof(vbr->in_hdr));
+		in++;
+	}
+	sg_set_buf(&vblk->sg[num+out+in], &vbr->status, sizeof(vbr->status));
+	in++;
+	if (num) {
+		if (rq_data_dir(vbr->req) == WRITE) {
+			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
+			out += num;
+		} else {
+			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
+			in += num;
+		}
 	}
-
 	if (vblk->vq->vq_ops->add_buf(vblk->vq, vblk->sg, out, in, vbr)) {
 		mempool_free(vbr, vblk->pool);
 		return false;
diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
index c1aef85..089e596 100644
--- a/include/linux/virtio_blk.h
+++ b/include/linux/virtio_blk.h
@@ -54,6 +54,14 @@ struct virtio_blk_outhdr
 	__u64 sector;
 };
 
+struct virtio_blk_inhdr
+{
+	__u32 status;
+	__u32 data_len;
+	__u32 sense_len;
+	__u32 residual;
+};
+
 /* And this is the final byte of the write scatter-gather list. */
 #define VIRTIO_BLK_S_OK		0
 #define VIRTIO_BLK_S_IOERR	1

--------------060309070601070502010900--
