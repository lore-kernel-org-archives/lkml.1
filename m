Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbXKEGPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbXKEGPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 01:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbXKEGP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 01:15:29 -0500
Received: from ozlabs.org ([203.10.76.45]:34775 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbXKEGP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 01:15:28 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC PATCH 2/2] sg_ring instead of scatterlist chaining in virtio
Date: Mon, 5 Nov 2007 17:15:50 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Paul Mackerras <paulus@samba.org>, Boaz Harrosh <bharrosh@panasas.com>,
       Jens Axboe <jens.axboe@oracle.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu
References: <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <alpine.LFD.0.999.0710260742140.30120@woody.linux-foundation.org> <200711051711.55364.rusty@rustcorp.com.au>
In-Reply-To: <200711051711.55364.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711051715.50864.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Example using virtio.

The interface actually improves because we don't need to hand two lengths to
add_buf (it needs an input and output sg[], so we used to hand one pointer
and a counter of how many were in and how many out, now we can neatly hand
two separate sgs).

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index a901eee..6a9b54d 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -23,7 +23,9 @@ struct virtio_blk
 	mempool_t *pool;
 
 	/* Scatterlist: can be too big for stack. */
-	struct scatterlist sg[3+MAX_PHYS_SEGMENTS];
+	DECLARE_SG(out, 1);
+	DECLARE_SG(in, 1);
+	DECLARE_SG(sg, MAX_PHYS_SEGMENTS);
 };
 
 struct virtblk_req
@@ -69,8 +71,8 @@ static bool blk_done(struct virtqueue *vq)
 static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		   struct request *req)
 {
-	unsigned long num, out, in;
 	struct virtblk_req *vbr;
+	struct sg_ring *in;
 
 	vbr = mempool_alloc(vblk->pool, GFP_ATOMIC);
 	if (!vbr)
@@ -94,23 +96,24 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 	if (blk_barrier_rq(vbr->req))
 		vbr->out_hdr.type |= VIRTIO_BLK_T_BARRIER;
 
-	/* We have to zero this, otherwise blk_rq_map_sg gets upset. */
-	memset(vblk->sg, 0, sizeof(vblk->sg));
-	sg_set_buf(&vblk->sg[0], &vbr->out_hdr, sizeof(vbr->out_hdr));
-	num = blk_rq_map_sg(q, vbr->req, vblk->sg+1);
-	sg_set_buf(&vblk->sg[num+1], &vbr->in_hdr, sizeof(vbr->in_hdr));
+	sg_init_single(&vblk->out.ring, &vbr->out_hdr, sizeof(vbr->out_hdr));
+	sg_ring_init(&vblk->sg.ring, ARRAY_SIZE(vblk->sg.sg));
+	vblk->sg.ring.num = blk_rq_map_sg(q, vbr->req, vblk->sg.sg);
+	sg_init_single(&vblk->in.ring, &vbr->in_hdr, sizeof(vbr->in_hdr));
 
 	if (rq_data_dir(vbr->req) == WRITE) {
 		vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
-		out = 1 + num;
-		in = 1;
+		/* Chain write request onto output buffers. */
+		list_add_tail(&vblk->sg.ring.list, &vblk->out.ring.list);
+		in = &vblk->in.ring;
 	} else {
 		vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
-		out = 1;
-		in = 1 + num;
+		/* Chain input (status) buffer at end of read buffers. */
+		list_add_tail(&vblk->in.ring.list, &vblk->sg.ring.list);
+		in = &vblk->sg.ring;
 	}
 
-	if (vblk->vq->vq_ops->add_buf(vblk->vq, vblk->sg, out, in, vbr)) {
+	if (vblk->vq->vq_ops->add_buf(vblk->vq, &vblk->out.ring, in, vbr)) {
 		mempool_free(vbr, vblk->pool);
 		return false;
 	}
@@ -127,7 +130,7 @@ static void do_virtblk_request(struct request_queue *q)
 
 	while ((req = elv_next_request(q)) != NULL) {
 		vblk = req->rq_disk->private_data;
-		BUG_ON(req->nr_phys_segments > ARRAY_SIZE(vblk->sg));
+		BUG_ON(req->nr_phys_segments > ARRAY_SIZE(vblk->sg.sg));
 
 		/* If this request fails, stop queue and wait for something to
 		   finish to restart it. */
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 100e8a2..e4d90c7 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -54,15 +54,15 @@ static struct hv_ops virtio_cons;
  * immediately (lguest's Launcher does). */
 static int put_chars(u32 vtermno, const char *buf, int count)
 {
-	struct scatterlist sg[1];
+	DECLARE_SG(sg, 1);
 	unsigned int len;
 
 	/* This is a convenient routine to initialize a single-elem sg list */
-	sg_init_one(sg, buf, count);
+	sg_init_single(&sg.ring, buf, count);
 
 	/* add_buf wants a token to identify this buffer: we hand it any
 	 * non-NULL pointer, since there's only ever one buffer. */
-	if (out_vq->vq_ops->add_buf(out_vq, sg, 1, 0, (void *)1) == 0) {
+	if (out_vq->vq_ops->add_buf(out_vq, &sg.ring, NULL, (void *)1) == 0) {
 		/* Tell Host to go! */
 		out_vq->vq_ops->kick(out_vq);
 		/* Chill out until it's done with the buffer. */
@@ -78,11 +78,12 @@ static int put_chars(u32 vtermno, const char *buf, int count)
  * queue. */
 static void add_inbuf(void)
 {
-	struct scatterlist sg[1];
-	sg_init_one(sg, inbuf, PAGE_SIZE);
+	DECLARE_SG(sg, 1);
+
+	sg_init_single(&sg.ring, inbuf, PAGE_SIZE);
 
 	/* We should always be able to add one buffer to an empty queue. */
-	if (in_vq->vq_ops->add_buf(in_vq, sg, 0, 1, inbuf) != 0)
+	if (in_vq->vq_ops->add_buf(in_vq, NULL, &sg.ring, inbuf) != 0)
 		BUG();
 	in_vq->vq_ops->kick(in_vq);
 }
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index e396c9d..2698592 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -143,20 +143,21 @@ drop:
 static void try_fill_recv(struct virtnet_info *vi)
 {
 	struct sk_buff *skb;
-	struct scatterlist sg[1+MAX_SKB_FRAGS];
-	int num, err;
+	DECLARE_SG(sg, 1+MAX_SKB_FRAGS);
+	int err;
 
+	sg_ring_init(&sg.ring, 1+MAX_SKB_FRAGS);
 	for (;;) {
 		skb = netdev_alloc_skb(vi->dev, MAX_PACKET_LEN);
 		if (unlikely(!skb))
 			break;
 
 		skb_put(skb, MAX_PACKET_LEN);
-		vnet_hdr_to_sg(sg, skb);
-		num = skb_to_sgvec(skb, sg+1, 0, skb->len) + 1;
+		vnet_hdr_to_sg(sg.sg, skb);
+		sg.ring.num = skb_to_sgvec(skb, sg.sg+1, 0, skb->len) + 1;
 		skb_queue_head(&vi->recv, skb);
 
-		err = vi->rvq->vq_ops->add_buf(vi->rvq, sg, 0, num, skb);
+		err = vi->rvq->vq_ops->add_buf(vi->rvq, NULL, &sg.ring, skb);
 		if (err) {
 			skb_unlink(skb, &vi->recv);
 			kfree_skb(skb);
@@ -225,14 +226,15 @@ static void free_old_xmit_skbs(struct virtnet_info *vi)
 static int start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
-	int num, err;
-	struct scatterlist sg[1+MAX_SKB_FRAGS];
+	int err;
+	DECLARE_SG(sg, 1+MAX_SKB_FRAGS);
 	struct virtio_net_hdr *hdr;
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
 	DECLARE_MAC_BUF(mac);
 
 	pr_debug("%s: xmit %p %s\n", dev->name, skb, print_mac(mac, dest));
 
+	sg_ring_init(&sg.ring, 1+MAX_SKB_FRAGS);
 	free_old_xmit_skbs(vi);
 
 	/* Encode metadata header at front. */
@@ -263,10 +265,10 @@ static int start_xmit(struct sk_buff *skb, struct net_device *dev)
 		hdr->gso_size = 0;
 	}
 
-	vnet_hdr_to_sg(sg, skb);
-	num = skb_to_sgvec(skb, sg+1, 0, skb->len) + 1;
+	vnet_hdr_to_sg(sg.sg, skb);
+	sg.ring.num = skb_to_sgvec(skb, sg.sg+1, 0, skb->len) + 1;
 	__skb_queue_head(&vi->send, skb);
-	err = vi->svq->vq_ops->add_buf(vi->svq, sg, num, 0, skb);
+	err = vi->svq->vq_ops->add_buf(vi->svq, &sg.ring, NULL, skb);
 	if (err) {
 		pr_debug("%s: virtio not prepared to send\n", dev->name);
 		skb_unlink(skb, &vi->send);
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index ae53570..d73cd18 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -69,48 +69,68 @@ struct vring_virtqueue
 
 #define to_vvq(_vq) container_of(_vq, struct vring_virtqueue, vq)
 
+static int add_desc(struct vring_virtqueue *vq, unsigned int i,
+		    struct scatterlist *sg, unsigned int flags)
+{
+	if (vq->num_free == 0)
+		return -ENOSPC;
+
+	vq->vring.desc[i].flags = VRING_DESC_F_NEXT | flags;
+	vq->vring.desc[i].addr = (page_to_pfn(sg->page)<<PAGE_SHIFT)
+		+ sg->offset;
+	vq->vring.desc[i].len = sg->length;
+	vq->num_free--;
+	return vq->vring.desc[i].next;
+}
+
 static int vring_add_buf(struct virtqueue *_vq,
-			 struct scatterlist sg[],
-			 unsigned int out,
-			 unsigned int in,
+			 struct sg_ring *out,
+			 struct sg_ring *in,
 			 void *data)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
-	unsigned int i, avail, head, uninitialized_var(prev);
+	unsigned int j, avail, head, free, uninitialized_var(prev);
+	int i;
+	struct sg_ring empty_sg, *start;
 
 	BUG_ON(data == NULL);
-	BUG_ON(out + in > vq->vring.num);
-	BUG_ON(out + in == 0);
+
+	sg_ring_init(&empty_sg, 0);
+	empty_sg.num = 0;
+	if (!out)
+		out = &empty_sg;
+	if (!in)
+		in = &empty_sg;
+
+	BUG_ON(in->num == 0 && out->num == 0);
 
 	START_USE(vq);
 
-	if (vq->num_free < out + in) {
-		pr_debug("Can't add buf len %i - avail = %i\n",
-			 out + in, vq->num_free);
-		END_USE(vq);
-		return -ENOSPC;
-	}
+	i = head = vq->free_head;
+	free = vq->num_free;
+
+	/* Lay out the output buffers first. */
+	start = out;
+	do {
+		for (j = 0; j < out->num; j++) {
+			prev = i;
+			i = add_desc(vq, i, &out->sg[j], 0);
+			if (unlikely(i < 0))
+				goto full;
+		}
+	} while ((out = sg_ring_next(out)) != start);
+
+	/* Lay out the input buffers next. */
+	start = in;
+	do {
+		for (j = 0; j < in->num; j++) {
+			prev = i;
+			i = add_desc(vq, i, &in->sg[j], VRING_DESC_F_WRITE);
+			if (unlikely(i < 0))
+				goto full;
+		}
+	} while ((in = sg_ring_next(in)) != start);
 
-	/* We're about to use some buffers from the free list. */
-	vq->num_free -= out + in;
-
-	head = vq->free_head;
-	for (i = vq->free_head; out; i = vq->vring.desc[i].next, out--) {
-		vq->vring.desc[i].flags = VRING_DESC_F_NEXT;
-		vq->vring.desc[i].addr = (page_to_pfn(sg->page)<<PAGE_SHIFT)
-			+ sg->offset;
-		vq->vring.desc[i].len = sg->length;
-		prev = i;
-		sg++;
-	}
-	for (; in; i = vq->vring.desc[i].next, in--) {
-		vq->vring.desc[i].flags = VRING_DESC_F_NEXT|VRING_DESC_F_WRITE;
-		vq->vring.desc[i].addr = (page_to_pfn(sg->page)<<PAGE_SHIFT)
-			+ sg->offset;
-		vq->vring.desc[i].len = sg->length;
-		prev = i;
-		sg++;
-	}
 	/* Last one doesn't continue. */
 	vq->vring.desc[prev].flags &= ~VRING_DESC_F_NEXT;
 
@@ -128,6 +148,12 @@ static int vring_add_buf(struct virtqueue *_vq,
 	pr_debug("Added buffer head %i to %p\n", head, vq);
 	END_USE(vq);
 	return 0;
+
+full:
+	pr_debug("Buffer needed more than %u on %p\n", free, vq);
+	vq->num_free = free;
+	END_USE(vq);
+	return i;
 }
 
 static void vring_kick(struct virtqueue *_vq)
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 14e1379..cee525f 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -29,9 +29,8 @@ struct virtqueue
  * virtqueue_ops - operations for virtqueue abstraction layer
  * @add_buf: expose buffer to other end
  *	vq: the struct virtqueue we're talking about.
- *	sg: the description of the buffer(s).
- *	out_num: the number of sg readable by other side
- *	in_num: the number of sg which are writable (after readable ones)
+ *	out: the scatter gather elements readable by other side (can be NULL)
+ *	in: the scatter gather elements which are writable (can be NULL)
  *	data: the token identifying the buffer.
  *      Returns 0 or an error.
  * @kick: update after add_buf
@@ -56,9 +55,8 @@ struct virtqueue
  */
 struct virtqueue_ops {
 	int (*add_buf)(struct virtqueue *vq,
-		       struct scatterlist sg[],
-		       unsigned int out_num,
-		       unsigned int in_num,
+		       struct sg_ring *out,
+		       struct sg_ring *in,
 		       void *data);
 
 	void (*kick)(struct virtqueue *vq);
