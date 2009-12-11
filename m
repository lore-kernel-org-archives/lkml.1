Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbZLKMdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbZLKMdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 07:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbZLKMdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 07:33:23 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53997 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbZLKMdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 07:33:22 -0500
Subject: [PATCH v2 1/4] Defer skb allocation -- add destroy buffers
 function for virtio
From: Shirley Ma <mashirle@us.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
       netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <1260534506.30371.6.camel@localhost.localdomain>
References: <1258697359.7416.14.camel@localhost.localdomain>
	 <200911231123.18898.rusty@rustcorp.com.au>
	 <20091208122134.GA17286@redhat.com>
	 <1260534506.30371.6.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 11 Dec 2009 04:33:25 -0800
Message-Id: <1260534805.30371.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: <xma@us.ibm.com>
-------------

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c708ecc..bb5eb7b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -107,6 +107,16 @@ static struct page *get_a_page(struct virtnet_info *vi, gfp_t gfp_mask)
 	return p;
 }
 
+static void virtio_net_free_pages(void *buf)
+{
+	struct page *page, *next;
+
+	for (page = buf; page; page = next) {
+		next = (struct page *)page->private;
+		__free_pages(page, 0);
+	}
+}
+
 static void skb_xmit_done(struct virtqueue *svq)
 {
 	struct virtnet_info *vi = svq->vdev->priv;
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index fbd2ecd..db83465 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -334,6 +334,29 @@ static bool vring_enable_cb(struct virtqueue *_vq)
 	return true;
 }
 
+static int vring_destroy_bufs(struct virtqueue *_vq, void (*destroy)(void *))
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	void *buf;
+	unsigned int i;
+	int freed = 0;
+
+	START_USE(vq);
+
+	for (i = 0; i < vq->vring.num; i++) {
+		if (vq->data[i]) {
+			/* detach_buf clears data, so grab it now. */
+			buf = vq->data[i];
+			detach_buf(vq, i);
+			destroy(buf);
+			freed++;
+		}
+	}
+
+	END_USE(vq);
+	return freed;
+}
+
 irqreturn_t vring_interrupt(int irq, void *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
@@ -360,6 +383,7 @@ static struct virtqueue_ops vring_vq_ops = {
 	.kick = vring_kick,
 	.disable_cb = vring_disable_cb,
 	.enable_cb = vring_enable_cb,
+	.destroy_bufs = vring_destroy_bufs,
 };
 
 struct virtqueue *vring_new_virtqueue(unsigned int num,
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 057a2e0..e6d7d77 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -71,6 +71,7 @@ struct virtqueue_ops {
 
 	void (*disable_cb)(struct virtqueue *vq);
 	bool (*enable_cb)(struct virtqueue *vq);
+	int (*destroy_bufs)(struct virtqueue *vq, void (*destory)(void *));
 };
 
 /**


