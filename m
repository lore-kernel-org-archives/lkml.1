Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYCKMFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYCKMFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbYCKMFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:05:04 -0400
Received: from ozlabs.org ([203.10.76.45]:55519 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbYCKMFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:05:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Subject: [PATCH 1/4] virtio: Use spin_lock_irqsave/restore for virtio-pci
Date: Tue, 11 Mar 2008 23:03:22 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Anthony Liguori <aliguori@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803112303.22984.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anthony Liguori <aliguori@us.ibm.com>

virtio-pci acquires its spin lock in an interrupt context so it's necessary
to use spin_lock_irqsave/restore variants.  This patch fixes guest SMP when
using virtio devices in KVM.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/virtio/virtio_pci.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 26f787d..59a8f73 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -177,6 +177,7 @@ static irqreturn_t vp_interrupt(int irq, void *opaque)
 	struct virtio_pci_device *vp_dev = opaque;
 	struct virtio_pci_vq_info *info;
 	irqreturn_t ret = IRQ_NONE;
+	unsigned long flags;
 	u8 isr;
 
 	/* reading the ISR has the effect of also clearing it so it's very
@@ -197,12 +198,12 @@ static irqreturn_t vp_interrupt(int irq, void *opaque)
 			drv->config_changed(&vp_dev->vdev);
 	}
 
-	spin_lock(&vp_dev->lock);
+	spin_lock_irqsave(&vp_dev->lock, flags);
 	list_for_each_entry(info, &vp_dev->virtqueues, node) {
 		if (vring_interrupt(irq, info->vq) == IRQ_HANDLED)
 			ret = IRQ_HANDLED;
 	}
-	spin_unlock(&vp_dev->lock);
+	spin_unlock_irqrestore(&vp_dev->lock, flags);
 
 	return ret;
 }
@@ -214,6 +215,7 @@ static struct virtqueue *vp_find_vq(struct virtio_device *vdev, unsigned index,
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	struct virtio_pci_vq_info *info;
 	struct virtqueue *vq;
+	unsigned long flags;
 	u16 num;
 	int err;
 
@@ -255,9 +257,9 @@ static struct virtqueue *vp_find_vq(struct virtio_device *vdev, unsigned index,
 	vq->priv = info;
 	info->vq = vq;
 
-	spin_lock(&vp_dev->lock);
+	spin_lock_irqsave(&vp_dev->lock, flags);
 	list_add(&info->node, &vp_dev->virtqueues);
-	spin_unlock(&vp_dev->lock);
+	spin_unlock_irqrestore(&vp_dev->lock, flags);
 
 	return vq;
 
@@ -274,10 +276,11 @@ static void vp_del_vq(struct virtqueue *vq)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
 	struct virtio_pci_vq_info *info = vq->priv;
+	unsigned long flags;
 
-	spin_lock(&vp_dev->lock);
+	spin_lock_irqsave(&vp_dev->lock, flags);
 	list_del(&info->node);
-	spin_unlock(&vp_dev->lock);
+	spin_unlock_irqrestore(&vp_dev->lock, flags);
 
 	vring_del_virtqueue(vq);
 

