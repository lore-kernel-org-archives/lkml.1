Return-Path: <linux-kernel-owner+w=401wt.eu-S1758389AbZLOSnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbZLOSnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 13:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbZLOSnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 13:43:00 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39721 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283AbZLOSm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 13:42:58 -0500
Subject: [RFC PATCH] Subject: virtio: Add unused buffers detach from vring
From: Shirley Ma <mashirle@us.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
       "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <20091215163901.GA24015@redhat.com>
References: <1258697359.7416.14.camel@localhost.localdomain>
	 <200911231123.18898.rusty@rustcorp.com.au>
	 <20091208122134.GA17286@redhat.com>
	 <1260534506.30371.6.camel@localhost.localdomain>
	 <1260535613.30371.24.camel@localhost.localdomain>
	 <20091213114320.GC7074@redhat.com>
	 <1260828518.8716.105.camel@localhost.localdomain>
	 <20091215113327.GC13110@redhat.com>
	 <1260894320.4387.64.camel@localhost.localdomain>
	 <20091215163901.GA24015@redhat.com>
Content-Type: text/plain
Date: Tue, 15 Dec 2009 10:42:53 -0800
Message-Id: <1260902573.4387.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I submit one split patch for review to make sure that's the right format.
I copied Rusty's comment for the commit message, and change destroy
to detach since we destroy the buffers in caller. This patch is built
against Dave's net-next tree.

There's currently no way for a virtio driver to ask for unused
buffers, so it has to keep a list itself to reclaim them at shutdown.
This is redundant, since virtio_ring stores that information.  So
add a new hook to do this: virtio_net will be the first user.

Signed-off-by: Shirley Ma <xma@us.ibm.com> 
---
 drivers/virtio/virtio_ring.c |   24 ++++++++++++++++++++++++
 include/linux/virtio.h       |    1 +
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index fbd2ecd..f847bc3 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -334,6 +334,29 @@ static bool vring_enable_cb(struct virtqueue *_vq)
 	return true;
 }
 
+/* This function is used to return vring unused buffers to caller for free */
+static void *vring_detach_bufs(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	unsigned int i;
+
+	START_USE(vq);
+
+	for (i = 0; i < vq->vring.num; ++i) {
+		if (vq->data[i]) {
+			/* detach_buf clears data, so grab it now. */
+			detach_buf(vq, i);
+			END_USE(vq);
+			return vq->data[i];
+		}
+	}
+	/* That should have freed everything. */
+	BUG_ON(vq->num_free != vq->vring.num);
+
+	END_USE(vq);
+	return NULL;
+}
+
 irqreturn_t vring_interrupt(int irq, void *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
@@ -360,6 +383,7 @@ static struct virtqueue_ops vring_vq_ops = {
 	.kick = vring_kick,
 	.disable_cb = vring_disable_cb,
 	.enable_cb = vring_enable_cb,
+	.detach_bufs = vring_detach_bufs,
 };
 
 struct virtqueue *vring_new_virtqueue(unsigned int num,
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 057a2e0..d7da456 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -71,6 +71,7 @@ struct virtqueue_ops {
 
 	void (*disable_cb)(struct virtqueue *vq);
 	bool (*enable_cb)(struct virtqueue *vq);
+	void *(*detach_bufs)(struct virtqueue *vq);
 };
 
 /**

Thanks
Shirley

