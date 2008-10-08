Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbYJHTgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbYJHTgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbYJHTfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:35:50 -0400
Received: from mail24.svc.cra.dublin.eircom.net ([159.134.118.53]:46400 "HELO
	mail24.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754497AbYJHTfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:35:48 -0400
From: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       Herbert Xu <herbert.xu@redhat.com>, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 2/2] virtio_net: Improve the recv buffer allocation scheme
Date: Wed,  8 Oct 2008 20:34:59 +0100
Message-Id: <1223494499-18732-2-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1223494499-18732-1-git-send-email-markmc@redhat.com>
References: <>
 <1223494499-18732-1-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert.xu@redhat.com>

If segmentation offload is enabled by the host, we currently allocate
maximum sized packet buffers and pass them to the host. This uses up
20 ring entries, allowing us to supply only 20 packet buffers to the
host with a 256 entry ring. This is a huge overhead when receiving
small packets, and is most keenly felt when receiving MTU sized
packets from off-host.

The VIRTIO_NET_F_MRG_RXBUF feature flag is set by hosts which support
using receive buffers which are smaller than the maximum packet size.
Buffers must be at least a page in size. In order to transfer large
packets to the guest, the host merges together multiple receive buffers
to form a larger logical buffer. The size of the logical buffer is
returned to the guest rather than the size of the individual smaller
buffers.

Make use of this support by supplying single page receive buffers to
the host. On receive, we extract the virtio_net_hdr, copy 128 bytes of
the payload to the skb's linear data buffer and adjust the fragment
offset to point to the remaining data. This ensures proper alignment
and allows us to not use any paged data for small packets. If the
payload occupies multiple pages, we simply append those pages as
fragments and free the associated skbs.

This scheme allows us to be efficient in our use of ring entries
while still supporting large packets. Benchmarking using netperf from
an external machine to a guest over a 10Gb/s network shows a 100%
improvement from ~1Gb/s to ~2Gb/s. With a local host->guest benchmark
with GSO disabled on the host side, throughput was seen to increase
from 700Mb/s to 1.7Gb/s.

Slightly modified version of Herbert's original patch, mostly just
renaming the feature from "datahead".

Signed-off-by: Herbert Xu <herbert.xu@redhat.com>
Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/net/virtio_net.c   |  146 +++++++++++++++++++++++++++++++++++++++++---
 include/linux/virtio_net.h |    1 +
 2 files changed, 139 insertions(+), 8 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 985271a..1780d6d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -34,6 +34,7 @@ module_param(gso, bool, 0444);
 
 /* FIXME: MTU in config. */
 #define MAX_PACKET_LEN (ETH_HLEN+ETH_DATA_LEN)
+#define GOOD_COPY_LEN	128
 
 struct virtnet_info
 {
@@ -58,6 +59,9 @@ struct virtnet_info
 	/* I like... big packets and I cannot lie! */
 	bool big_packets;
 
+	/* Host will merge rx buffers for big packets (shake it! shake it!) */
+	bool mergeable_rx_bufs;
+
 	/* Receive & send queues. */
 	struct sk_buff_head recv;
 	struct sk_buff_head send;
@@ -121,8 +125,10 @@ static void skb_xmit_done(struct virtqueue *svq)
 static void receive_skb(struct net_device *dev, struct sk_buff *skb,
 			unsigned len)
 {
+	struct virtnet_info *vi = dev->priv;
 	struct virtio_net_hdr *hdr = skb_vnet_hdr(skb);
 	int err;
+	int i;
 
 	if (unlikely(len < sizeof(struct virtio_net_hdr) + ETH_HLEN)) {
 		pr_debug("%s: short packet %i\n", dev->name, len);
@@ -131,15 +137,87 @@ static void receive_skb(struct net_device *dev, struct sk_buff *skb,
 	}
 	len -= sizeof(struct virtio_net_hdr);
 
-	if (len <= MAX_PACKET_LEN)
-		trim_pages(dev->priv, skb);
+	if (vi->mergeable_rx_bufs) {
+		unsigned int copy;
+		unsigned int plen;
+		char *p = page_address(skb_shinfo(skb)->frags[0].page);
 
-	err = pskb_trim(skb, len);
-	if (err) {
-		pr_debug("%s: pskb_trim failed %i %d\n", dev->name, len, err);
-		dev->stats.rx_dropped++;
-		goto drop;
+		memcpy(hdr, p, sizeof(*hdr));
+		p += sizeof(*hdr);
+
+		plen = PAGE_SIZE - sizeof(*hdr);
+		if (plen > len)
+			plen = len;
+
+		copy = plen;
+		if (copy > skb_tailroom(skb))
+			copy = skb_tailroom(skb);
+
+		memcpy(skb_put(skb, copy), p, copy);
+
+		len -= copy;
+		plen -= copy;
+
+		if (!plen) {
+			give_a_page(vi, skb_shinfo(skb)->frags[0].page);
+			skb_shinfo(skb)->nr_frags--;
+		} else {
+			skb_shinfo(skb)->frags[0].page_offset +=
+				sizeof(*hdr) + copy;
+			skb_shinfo(skb)->frags[0].size = plen;
+			skb->data_len += plen;
+			skb->len += plen;
+		}
+
+		while ((len -= plen)) {
+			struct sk_buff *nskb;
+			unsigned nlen;
+
+			i = skb_shinfo(skb)->nr_frags;
+			if (i >= MAX_SKB_FRAGS) {
+				pr_debug("%s: packet too long %d\n", dev->name,
+					 len);
+				dev->stats.rx_length_errors++;
+				goto drop;
+			}
+
+			nskb = vi->rvq->vq_ops->get_buf(vi->rvq, &nlen);
+			if (!nskb) {
+				pr_debug("%s: packet length error %d < %d\n",
+					 dev->name, skb->len, len);
+				dev->stats.rx_length_errors++;
+				goto drop;
+			}
+
+			__skb_unlink(nskb, &vi->recv);
+			vi->num--;
+
+			skb_shinfo(skb)->frags[i] = skb_shinfo(nskb)->frags[0];
+			skb_shinfo(nskb)->nr_frags = 0;
+			kfree_skb(nskb);
+
+			plen = PAGE_SIZE;
+			if (plen > len)
+				plen = len;
+
+			skb_shinfo(skb)->frags[i].size = plen;
+			skb_shinfo(skb)->nr_frags++;
+			skb->data_len += plen;
+			skb->len += plen;
+		}
+	} else {
+		if (len <= MAX_PACKET_LEN)
+			trim_pages(vi, skb);
+
+		err = pskb_trim(skb, len);
+		if (err) {
+			pr_debug("%s: pskb_trim failed %i %d\n", dev->name,
+				 len, err);
+			dev->stats.rx_dropped++;
+			goto drop;
+		}
 	}
+
 	skb->truesize += skb->data_len;
 	dev->stats.rx_bytes += skb->len;
 	dev->stats.rx_packets++;
@@ -198,7 +276,7 @@ drop:
 	dev_kfree_skb(skb);
 }
 
-static void try_fill_recv(struct virtnet_info *vi)
+static void try_fill_recv_maxbufs(struct virtnet_info *vi)
 {
 	struct sk_buff *skb;
 	struct scatterlist sg[2+MAX_SKB_FRAGS];
@@ -247,6 +325,54 @@ static void try_fill_recv(struct virtnet_info *vi)
 	vi->rvq->vq_ops->kick(vi->rvq);
 }
 
+static void try_fill_recv(struct virtnet_info *vi)
+{
+	struct sk_buff *skb;
+	struct scatterlist sg[1];
+	int err;
+
+	if (!vi->mergeable_rx_bufs) {
+		try_fill_recv_maxbufs(vi);
+		return;
+	}
+
+	for (;;) {
+		skb_frag_t *f;
+
+		skb = netdev_alloc_skb(vi->dev, GOOD_COPY_LEN + NET_IP_ALIGN);
+		if (unlikely(!skb))
+			break;
+
+		skb_reserve(skb, NET_IP_ALIGN);
+
+		f = &skb_shinfo(skb)->frags[0];
+		f->page = get_a_page(vi, GFP_ATOMIC);
+		if (!f->page) {
+			kfree_skb(skb);
+			break;
+		}
+
+		f->page_offset = 0;
+		f->size = PAGE_SIZE;
+
+		skb_shinfo(skb)->nr_frags++;
+
+		sg_init_one(sg, page_address(f->page), PAGE_SIZE);
+		skb_queue_head(&vi->recv, skb);
+
+		err = vi->rvq->vq_ops->add_buf(vi->rvq, sg, 0, 1, skb);
+		if (err) {
+			skb_unlink(skb, &vi->recv);
+			kfree_skb(skb);
+			break;
+		}
+		vi->num++;
+	}
+	if (unlikely(vi->num > vi->max))
+		vi->max = vi->num;
+	vi->rvq->vq_ops->kick(vi->rvq);
+}
+
 static void skb_recv_done(struct virtqueue *rvq)
 {
 	struct virtnet_info *vi = rvq->vdev->priv;
@@ -552,6 +678,9 @@ static int virtnet_probe(struct virtio_device *vdev)
 	    || virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_ECN))
 		vi->big_packets = true;
 
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
+		vi->mergeable_rx_bufs = true;
+
 	/* We expect two virtqueues, receive then send. */
 	vi->rvq = vdev->config->find_vq(vdev, 0, skb_recv_done);
 	if (IS_ERR(vi->rvq)) {
@@ -644,6 +773,7 @@ static unsigned int features[] = {
 	VIRTIO_NET_F_HOST_TSO4, VIRTIO_NET_F_HOST_UFO, VIRTIO_NET_F_HOST_TSO6,
 	VIRTIO_NET_F_HOST_ECN, VIRTIO_NET_F_GUEST_TSO4, VIRTIO_NET_F_GUEST_TSO6,
 	VIRTIO_NET_F_GUEST_ECN, /* We don't yet handle UFO input. */
+	VIRTIO_NET_F_MRG_RXBUF,
 	VIRTIO_F_NOTIFY_ON_EMPTY,
 };
 
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 5e33761..8f376a7 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -20,6 +20,7 @@
 #define VIRTIO_NET_F_HOST_TSO6	12	/* Host can handle TSOv6 in. */
 #define VIRTIO_NET_F_HOST_ECN	13	/* Host can handle TSO[6] w/ ECN in. */
 #define VIRTIO_NET_F_HOST_UFO	14	/* Host can handle UFO in. */
+#define VIRTIO_NET_F_MRG_RXBUF	15	/* Host can merge receive buffers. */
 
 struct virtio_net_config
 {
-- 
1.5.4.3

