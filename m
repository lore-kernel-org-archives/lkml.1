Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYCBWiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYCBWiX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 17:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbYCBWiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 17:38:07 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39557 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbYCBWhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 17:37:54 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, kvm-devel@lists.sourceforge.net,
       Anthony Liguori <aliguori@us.ibm.com>
Subject: [PATCH] Use spin_lock_irqsave/restore for virtio-pci
Date: Sun,  2 Mar 2008 16:37:48 -0600
Message-Id: <1204497468-13463-1-git-send-email-aliguori@us.ibm.com>
X-Mailer: git-send-email 1.5.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio-pci acquires its spin lock in an interrupt context so it's necessary
to use spin_lock_irqsave/restore variants.  This patch fixes guest SMP when
using virtio devices in KVM.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>

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
 
