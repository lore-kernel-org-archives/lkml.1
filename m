Return-Path: <linux-kernel-owner+w=401wt.eu-S966197AbZLHU6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966197AbZLHU6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966155AbZLHU5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:57:43 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:43987 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966127AbZLHU52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:57:28 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] ioq: clearly specify endianness
Date: Tue,  8 Dec 2009 12:57:34 -0800
Message-Id: <1260305854-31472-6-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.6.0.rc1.71.gfba5.dirty
In-Reply-To: <1260305854-31472-1-git-send-email-iws@ovro.caltech.edu>
References: <1260305854-31472-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Tue, 08 Dec 2009 12:57:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IOQ code uses structures which are designed to be shared between
disparate systems, such as 32-bit and 64-bit, as well as Linux and Windows.

Since IOQ is primarily intended to be used by qemu/kvm, which support
virtual guests with a different CPU architecture than the host, clearly
define the endianness for the shared structures.

The endianness is defined to be little-endian, to avoid byte swapping in
the most common case: x86.

Note that the cookie member was not changed to have a fixed endianness.
This is because it is only intended for use by one side of the IOQ.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/net/vbus-enet.c   |   30 +++++++++++++++---------------
 drivers/vbus/bus-proxy.c  |    2 +-
 drivers/vbus/pci-bridge.c |    6 +++---
 include/linux/ioq.h       |   18 +++++++++---------
 lib/ioq.c                 |   28 ++++++++++++++++------------
 5 files changed, 44 insertions(+), 40 deletions(-)

diff --git a/drivers/net/vbus-enet.c b/drivers/net/vbus-enet.c
index 8232215..94b86d4 100644
--- a/drivers/net/vbus-enet.c
+++ b/drivers/net/vbus-enet.c
@@ -175,8 +175,8 @@ rxdesc_alloc(struct vbus_enet_priv *priv, struct ioq_ring_desc *desc, size_t len
 		iov->len     = len;
 	} else {
 		desc->cookie = (u64)(unsigned long)skb;
-		desc->ptr    = (u64)__pa(skb->data);
-		desc->len    = len; /* total length  */
+		desc->ptr    = cpu_to_le64(__pa(skb->data));
+		desc->len    = cpu_to_le64(len); /* total length  */
 	}
 
 	desc->valid  = 1;
@@ -212,8 +212,8 @@ rx_pageq_refill(struct vbus_enet_priv *priv, gfp_t gfp_mask)
 
 		added = 1;
 		iter.desc->cookie = (u64)(unsigned long)page;
-		iter.desc->ptr    = (u64)__pa(page_address(page));
-		iter.desc->len    = PAGE_SIZE;
+		iter.desc->ptr    = cpu_to_le64(__pa(page_address(page)));
+		iter.desc->len    = cpu_to_le64(PAGE_SIZE);
 
 		ret = ioq_iter_push(&iter, 0);
 		BUG_ON(ret < 0);
@@ -257,9 +257,9 @@ rx_setup(struct vbus_enet_priv *priv)
 			size_t offset = (i * SG_DESC_SIZE);
 			void *addr = &priv->l4ro.pool[offset];
 
-			iter.desc->ptr    = (u64)offset;
+			iter.desc->ptr    = cpu_to_le64(offset);
 			iter.desc->cookie = (u64)(unsigned long)addr;
-			iter.desc->len    = SG_DESC_SIZE;
+			iter.desc->len    = cpu_to_le64(SG_DESC_SIZE);
 		}
 
 		rxdesc_alloc(priv, iter.desc, priv->dev->mtu);
@@ -428,17 +428,17 @@ tx_setup(struct vbus_enet_priv *priv)
 			size_t offset = (i * SG_DESC_SIZE);
 
 			vsg = (struct venet_sg *)&priv->pmtd.pool[offset];
-			iter.desc->ptr = (u64)offset;
+			iter.desc->ptr = cpu_to_le64(offset);
 		} else {
 			vsg = kzalloc(SG_DESC_SIZE, GFP_KERNEL);
 			if (!vsg)
 				return -ENOMEM;
 
-			iter.desc->ptr = (u64)__pa(vsg);
+			iter.desc->ptr = cpu_to_le64(__pa(vsg));
 		}
 
 		iter.desc->cookie = (u64)(unsigned long)vsg;
-		iter.desc->len    = SG_DESC_SIZE;
+		iter.desc->len    = cpu_to_le64(SG_DESC_SIZE);
 
 		ret = ioq_iter_seek(&iter, ioq_seek_next, 0, 0);
 		BUG_ON(ret < 0);
@@ -708,7 +708,7 @@ vbus_enet_flat_import(struct vbus_enet_priv *priv, struct ioq_ring_desc *desc)
 		return NULL;
 	}
 
-	skb_put(skb, desc->len);
+	skb_put(skb, le64_to_cpu(desc->len));
 
 	return skb;
 }
@@ -871,7 +871,7 @@ vbus_enet_tx_start(struct sk_buff *skb, struct net_device *dev)
 			iov->ptr = (u64)sg_phys(sg);
 		}
 
-		iter.desc->len = (u64)VSG_DESC_SIZE(vsg->count);
+		iter.desc->len = cpu_to_le64(VSG_DESC_SIZE(vsg->count));
 
 	} else {
 		/*
@@ -879,8 +879,8 @@ vbus_enet_tx_start(struct sk_buff *skb, struct net_device *dev)
 		 * ring.
 		 */
 		iter.desc->cookie = (u64)(unsigned long)skb;
-		iter.desc->len = (u64)skb->len;
-		iter.desc->ptr = (u64)__pa(skb->data);
+		iter.desc->len = cpu_to_le64(skb->len);
+		iter.desc->ptr = cpu_to_le64(__pa(skb->data));
 	}
 
 	iter.desc->valid  = 1;
@@ -1258,9 +1258,9 @@ vbus_enet_evq_negcap(struct vbus_enet_priv *priv, unsigned long count)
 			size_t offset = (i * query.evsize);
 			void *addr = &priv->evq.pool[offset];
 
-			iter.desc->ptr    = (u64)offset;
+			iter.desc->ptr    = cpu_to_le64(offset);
 			iter.desc->cookie = (u64)(unsigned long)addr;
-			iter.desc->len    = query.evsize;
+			iter.desc->len    = cpu_to_le64(query.evsize);
 
 			ret = ioq_iter_push(&iter, 0);
 			BUG_ON(ret < 0);
diff --git a/drivers/vbus/bus-proxy.c b/drivers/vbus/bus-proxy.c
index a318c67..4792842 100644
--- a/drivers/vbus/bus-proxy.c
+++ b/drivers/vbus/bus-proxy.c
@@ -217,7 +217,7 @@ int vbus_driver_ioq_alloc(struct vbus_device_proxy *dev, const char *name,
 
 	head->magic     = IOQ_RING_MAGIC;
 	head->ver	= IOQ_RING_VER;
-	head->count     = count;
+	head->count     = cpu_to_le32(count);
 
 	ret = dev->ops->shm(dev, name, id, prio, head, len,
 			    &head->signal, &signal, 0);
diff --git a/drivers/vbus/pci-bridge.c b/drivers/vbus/pci-bridge.c
index 078b8f4..0d51324 100644
--- a/drivers/vbus/pci-bridge.c
+++ b/drivers/vbus/pci-bridge.c
@@ -579,8 +579,8 @@ eventq_init(int qlen)
 		BUG_ON(iter.desc->valid);
 
 		desc->cookie = (u64)(unsigned long)event;
-		desc->ptr    = (u64)__pa(event);
-		desc->len    = len; /* total length  */
+		desc->ptr    = cpu_to_le64(__pa(event));
+		desc->len    = cpu_to_le64(len); /* total length */
 		desc->valid  = 1;
 
 		/*
@@ -798,7 +798,7 @@ _ioq_init(size_t ringsize, struct ioq *ioq, struct ioq_ops *ops)
 
 	head->magic     = IOQ_RING_MAGIC;
 	head->ver	= IOQ_RING_VER;
-	head->count     = ringsize;
+	head->count     = cpu_to_le32(ringsize);
 
 	_signal_init(signal, &head->signal, &eventq_signal_ops);
 
diff --git a/include/linux/ioq.h b/include/linux/ioq.h
index f04dfb4..7c6d6ca 100644
--- a/include/linux/ioq.h
+++ b/include/linux/ioq.h
@@ -52,18 +52,18 @@
  */
 struct ioq_ring_desc {
 	__u64                 cookie; /* for arbitrary use by north-side */
-	__u64                 ptr;
-	__u64                 len;
+	__le64                ptr;
+	__le64                len;
 	__u8                  valid;
 	__u8                  sown; /* South owned = 1, North owned = 0 */
 };
 
-#define IOQ_RING_MAGIC 0x47fa2fe4
-#define IOQ_RING_VER   4
+#define IOQ_RING_MAGIC cpu_to_le32(0x47fa2fe4)
+#define IOQ_RING_VER   cpu_to_le32(4)
 
 struct ioq_ring_idx {
-	__u32                 head;    /* 0 based index to head of ptr array */
-	__u32                 tail;    /* 0 based index to tail of ptr array */
+	__le32                head;    /* 0 based index to head of ptr array */
+	__le32                tail;    /* 0 based index to tail of ptr array */
 	__u8                  full;
 };
 
@@ -73,11 +73,11 @@ enum ioq_locality {
 };
 
 struct ioq_ring_head {
-	__u32                  magic;
-	__u32                  ver;
+	__le32                 magic;
+	__le32                 ver;
 	struct shm_signal_desc signal;
 	struct ioq_ring_idx    idx[2];
-	__u32                  count;
+	__le32                 count;
 	struct ioq_ring_desc   ring[1]; /* "count" elements will be allocated */
 };
 
diff --git a/lib/ioq.c b/lib/ioq.c
index d5e57be..4027848 100644
--- a/lib/ioq.c
+++ b/lib/ioq.c
@@ -71,10 +71,10 @@ int ioq_iter_seek(struct ioq_iterator *iter, enum ioq_seek_type type,
 		pos = modulo_inc(iter->pos, iter->ioq->count);
 		break;
 	case ioq_seek_tail:
-		pos = idx->tail;
+		pos = le32_to_cpu(idx->tail);
 		break;
 	case ioq_seek_head:
-		pos = idx->head;
+		pos = le32_to_cpu(idx->head);
 		break;
 	case ioq_seek_set:
 		if (offset >= iter->ioq->count)
@@ -91,19 +91,23 @@ EXPORT_SYMBOL_GPL(ioq_iter_seek);
 
 static int ioq_ring_count(struct ioq_ring_idx *idx, int count)
 {
-	if (idx->full && (idx->head == idx->tail))
+	u32 head = le32_to_cpu(idx->head);
+	u32 tail = le32_to_cpu(idx->tail);
+
+	if (idx->full && (head == tail))
 		return count;
-	else if (idx->tail >= idx->head)
-		return idx->tail - idx->head;
+	else if (tail >= head)
+		return tail - head;
 	else
-		return (idx->tail + count) - idx->head;
+		return (tail + count) - head;
 }
 
 static void idx_tail_push(struct ioq_ring_idx *idx, int count)
 {
-	u32 tail = modulo_inc(idx->tail, count);
+	u32 tail = modulo_inc(le32_to_cpu(idx->tail), count);
+	u32 head = le32_to_cpu(idx->head);
 
-	if (idx->head == tail) {
+	if (head == tail) {
 		rmb();
 
 		/*
@@ -116,7 +120,7 @@ static void idx_tail_push(struct ioq_ring_idx *idx, int count)
 		wmb();
 	}
 
-	idx->tail = tail;
+	idx->tail = cpu_to_le32(tail);
 }
 
 int ioq_iter_push(struct ioq_iterator *iter, int flags)
@@ -128,7 +132,7 @@ int ioq_iter_push(struct ioq_iterator *iter, int flags)
 	/*
 	 * Its only valid to push if we are currently pointed at the tail
 	 */
-	if (iter->pos != idx->tail || iter->desc->sown != iter->ioq->locale)
+	if (iter->pos != le32_to_cpu(idx->tail) || iter->desc->sown != iter->ioq->locale)
 		return -EINVAL;
 
 	idx_tail_push(idx, iter->ioq->count);
@@ -167,10 +171,10 @@ int ioq_iter_pop(struct ioq_iterator *iter,  int flags)
 	/*
 	 * Its only valid to pop if we are currently pointed at the head
 	 */
-	if (iter->pos != idx->head || iter->desc->sown != iter->ioq->locale)
+	if (iter->pos != le32_to_cpu(idx->head) || iter->desc->sown != iter->ioq->locale)
 		return -EINVAL;
 
-	idx->head = modulo_inc(idx->head, iter->ioq->count);
+	idx->head = cpu_to_le32(modulo_inc(le32_to_cpu(idx->head), iter->ioq->count));
 	wmb(); /* head must be visible before full */
 
 	if (idx->full) {
-- 
1.5.4.3

