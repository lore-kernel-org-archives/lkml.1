Return-Path: <linux-kernel-owner+w=401wt.eu-S1760703AbXKHCri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703AbXKHCri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757816AbXKHCqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:46:42 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:42563 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbXKHCqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:46:40 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Anthony Liguori <aliguori@us.ibm.com>,
       Rusty Russell <rusty@rusycorp.com.au>, virtualization@lists.osdl.org,
       kvm-devel@lists.sourceforge.net
Subject: [PATCH 3/3] virtio PCI device
Date: Wed,  7 Nov 2007 20:46:32 -0600
Message-Id: <11944900163817-git-send-email-aliguori@us.ibm.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <11944900152750-git-send-email-aliguori@us.ibm.com>
References: <11944899922822-git-send-email-aliguori@us.ibm.com>
 <11944900141678-git-send-email-aliguori@us.ibm.com>
 <11944900152750-git-send-email-aliguori@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a PCI device that implements a transport for virtio.  It allows virtio
devices to be used by QEMU based VMMs like KVM or Xen.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 9e33fc4..c81e0f3 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -6,3 +6,20 @@ config VIRTIO
 config VIRTIO_RING
 	bool
 	depends on VIRTIO
+
+config VIRTIO_PCI
+	tristate "PCI driver for virtio devices (EXPERIMENTAL)"
+	depends on PCI && EXPERIMENTAL
+	select VIRTIO
+	select VIRTIO_RING
+	---help---
+	  This drivers provides support for virtio based paravirtual device
+	  drivers over PCI.  This requires that your VMM has appropriate PCI
+	  virtio backends.  Most QEMU based VMMs should support these devices
+	  (like KVM or Xen).
+
+	  Currently, the ABI is not considered stable so there is no guarantee
+	  that this version of the driver will work with your VMM.
+
+	  If unsure, say M.
+          
diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index f70e409..cc84999 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_VIRTIO) += virtio.o
 obj-$(CONFIG_VIRTIO_RING) += virtio_ring.o
+obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
new file mode 100644
index 0000000..85ae096
--- /dev/null
+++ b/drivers/virtio/virtio_pci.c
@@ -0,0 +1,469 @@
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/virtio.h>
+#include <linux/virtio_config.h>
+#include <linux/virtio_ring.h>
+#include <linux/virtio_pci.h>
+#include <linux/highmem.h>
+#include <linux/spinlock.h>
+
+MODULE_AUTHOR("Anthony Liguori <aliguori@us.ibm.com>");
+MODULE_DESCRIPTION("virtio-pci");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1");
+
+/* Our device structure */
+struct virtio_pci_device
+{
+	/* the virtio device */
+	struct virtio_device vdev;
+	/* the PCI device */
+	struct pci_dev *pci_dev;
+	/* the IO mapping for the PCI config space */
+	void *ioaddr;
+
+	spinlock_t lock;
+	struct list_head virtqueues;
+};
+
+struct virtio_pci_vq_info
+{
+	/* the number of entries in the queue */
+	int num;
+	/* the number of pages the device needs for the ring queue */
+	int n_pages;
+	/* the index of the queue */
+	int queue_index;
+	/* the struct page of the ring queue */
+	struct page *pages;
+	/* the virtual address of the ring queue */
+	void *queue;
+	/* a pointer to the virtqueue */
+	struct virtqueue *vq;
+	/* the node pointer */
+	struct list_head node;
+};
+
+/* We have to enumerate here all virtio PCI devices. */
+static struct pci_device_id virtio_pci_id_table[] = {
+	{ 0x5002, 0x2258, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, /* Dummy entry */
+	{ 0 },
+};
+
+MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
+
+/* A PCI device has it's own struct device and so does a virtio device so
+ * we create a place for the virtio devices to show up in sysfs.  I think it
+ * would make more sense for virtio to not insist on having it's own device. */
+static struct device virtio_pci_root = {
+	.parent		= NULL,
+	.bus_id		= "virtio-pci",
+};
+
+/* Unique numbering for devices under the kvm root */
+static unsigned int dev_index;
+
+/* Convert a generic virtio device to our structure */
+static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
+{
+	return container_of(vdev, struct virtio_pci_device, vdev);
+}
+
+/* virtio config->feature() implementation */
+static bool vp_feature(struct virtio_device *vdev, unsigned bit)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	u32 mask;
+
+	/* Since this function is supposed to have the side effect of
+	 * enabling a queried feature, we simulate that by doing a read
+	 * from the host feature bitmask and then writing to the guest
+	 * feature bitmask */
+	mask = ioread32(vp_dev->ioaddr + VIRTIO_PCI_HOST_FEATURES);
+	if (mask & (1 << bit)) {
+		mask |= (1 << bit);
+		iowrite32(mask, vp_dev->ioaddr + VIRTIO_PCI_GUEST_FEATURES);
+	}
+
+	return !!(mask & (1 << bit));
+}
+
+/* virtio config->get() implementation */
+static void vp_get(struct virtio_device *vdev, unsigned offset,
+		   void *buf, unsigned len)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	void *ioaddr = vp_dev->ioaddr + VIRTIO_PCI_CONFIG + offset;
+
+	/* We translate appropriately sized get requests into more natural
+	 * IO operations.  These functions also take care of endianness
+	 * conversion. */
+	switch (len) {
+	case 1: {
+		u8 val;
+		val = ioread8(ioaddr);
+		memcpy(buf, &val, sizeof(val));
+		break;
+	}
+	case 2: {
+		u16 val;
+		val = ioread16(ioaddr);
+		memcpy(buf, &val, sizeof(val));
+		break;
+	}
+	case 4: {
+		u32 val;
+		val = ioread32(ioaddr);
+		memcpy(buf, &val, sizeof(val));
+		break;
+	}
+	case 8: {
+		u64 val;
+		val = (u64)ioread32(ioaddr) << 32;
+		val |= ioread32(ioaddr + 4);
+		memcpy(buf, &val, sizeof(val));
+		break;
+	}
+
+	/* for strange accesses of an odd size, we do not perform any
+	 * endianness conversion. */
+	default:
+		ioread8_rep(ioaddr, buf, len);
+		break;
+	}
+}
+
+/* the config->set() implementation.  it's symmetric to the config->get()
+ * implementation */
+static void vp_set(struct virtio_device *vdev, unsigned offset,
+		   const void *buf, unsigned len)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	void *ioaddr = vp_dev->ioaddr + VIRTIO_PCI_CONFIG + offset;
+
+	switch (len) {
+	case 1: {
+		u8 val;
+		memcpy(&val, buf, sizeof(val));
+		iowrite8(val, ioaddr);
+		break;
+	}
+	case 2: {
+		u16 val;
+		memcpy(&val, buf, sizeof(val));
+		iowrite16(val, ioaddr);
+		break;
+	}
+	case 4: {
+		u32 val;
+		memcpy(&val, buf, sizeof(val));
+		iowrite32(val, ioaddr);
+		break;
+	}
+	case 8: {
+		u64 val;
+		memcpy(&val, buf, sizeof(val));
+		iowrite32(val >> 32, ioaddr);
+		iowrite32(val, ioaddr + 4);
+		break;
+	}
+	default:
+		iowrite8_rep(ioaddr, buf, len);
+		break;
+	}
+}
+
+/* config->{get,set}_status() implementations */
+static u8 vp_get_status(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	return ioread8(vp_dev->ioaddr + VIRTIO_PCI_STATUS);
+}
+
+static void vp_set_status(struct virtio_device *vdev, u8 status)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	return iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
+}
+
+/* the notify function used when creating a virt queue */
+static void vp_notify(struct virtqueue *vq)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
+	struct virtio_pci_vq_info *info = vq->priv;
+
+	/* we write the queue's selector into the notification register to
+	 * signal the other end */
+	iowrite16(info->queue_index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_NOTIFY);
+}
+
+/* A small wrapper to also acknowledge the interrupt when it's handled.
+ * I really need an EIO hook for the vring so I can ack the interrupt once we
+ * know that we'll be handling the IRQ but before we invoke the callback since
+ * the callback may notify the host which results in the host attempting to
+ * raise an interrupt that we would then mask once we acknowledged the
+ * interrupt. */
+static irqreturn_t vp_interrupt(int irq, void *opaque)
+{
+	struct virtio_pci_device *vp_dev = opaque;
+	struct virtio_pci_vq_info *info;
+	irqreturn_t ret = IRQ_NONE;
+	u8 isr;
+
+	/* reading the ISR has the effect of also clearing it so it's very
+	 * important to save off the value. */
+	isr = ioread8(vp_dev->ioaddr + VIRTIO_PCI_ISR);
+
+	/* It's definitely not us if the ISR was not high */
+	if (!isr)
+		return IRQ_NONE;
+
+	spin_lock(&vp_dev->lock);
+	list_for_each_entry(info, &vp_dev->virtqueues, node) {
+		if (vring_interrupt(irq, info->vq) == IRQ_HANDLED)
+			ret = IRQ_HANDLED;
+	}
+	spin_unlock(&vp_dev->lock);
+
+	return ret;
+}
+
+/* the config->find_vq() implementation */
+static struct virtqueue *vp_find_vq(struct virtio_device *vdev, unsigned index,
+				    bool (*callback)(struct virtqueue *vq))
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	struct virtio_pci_vq_info *info;
+	struct virtqueue *vq;
+	int err;
+	u16 num;
+
+	/* Select the queue we're interested in */
+	iowrite16(index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
+
+	/* Check if queue is either not available or already active. */
+	num = ioread16(vp_dev->ioaddr + VIRTIO_PCI_QUEUE_NUM);
+	if (!num || ioread32(vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN))
+		return ERR_PTR(-ENOENT);
+
+	/* allocate and fill out our structure the represents an active
+	 * queue */
+	info = kmalloc(sizeof(struct virtio_pci_vq_info), GFP_KERNEL);
+	if (!info)
+		return ERR_PTR(-ENOMEM);
+
+	info->queue_index = index;
+	info->num = num;
+
+	/* determine the memory needed for the queue and provide the memory
+	 * location to the host */
+	info->n_pages = DIV_ROUND_UP(vring_size(num), PAGE_SIZE);
+	info->pages = alloc_pages(GFP_KERNEL | __GFP_ZERO,
+				  get_order(info->n_pages));
+	if (info->pages == NULL) {
+		err = -ENOMEM;
+		goto out_info;
+	}
+
+	/* FIXME: is this sufficient for info->n_pages > 1? */
+	info->queue = kmap(info->pages);
+	if (info->queue == NULL) {
+		err = -ENOMEM;
+		goto out_alloc_pages;
+	}
+
+	/* activate the queue */
+	iowrite32(page_to_pfn(info->pages),
+		  vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
+		  
+	/* create the vring */
+	vq = vring_new_virtqueue(info->num, vdev, info->queue,
+				 vp_notify, callback);
+	if (!vq) {
+		err = -ENOMEM;
+		goto out_activate_queue;
+	}
+
+	vq->priv = info;
+	info->vq = vq;
+
+	spin_lock(&vp_dev->lock);
+	list_add(&info->node, &vp_dev->virtqueues);
+	spin_unlock(&vp_dev->lock);
+
+	return vq;
+
+out_activate_queue:
+	iowrite32(0, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
+	kunmap(info->queue);
+out_alloc_pages:
+	__free_pages(info->pages, get_order(info->n_pages));
+out_info:
+	kfree(info);
+	return ERR_PTR(err);
+}
+
+/* the config->del_vq() implementation */
+static void vp_del_vq(struct virtqueue *vq)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
+	struct virtio_pci_vq_info *info = vq->priv;
+
+	spin_lock(&vp_dev->lock);
+	list_del(&info->node);
+	spin_unlock(&vp_dev->lock);
+
+	vring_del_virtqueue(vq);
+
+	/* Select and deactivate the queue */
+	iowrite16(info->queue_index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
+	iowrite32(0, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
+
+	kunmap(info->queue);
+	__free_pages(info->pages, get_order(info->n_pages));
+	kfree(info);
+}
+
+static struct virtio_config_ops virtio_pci_config_ops = {
+	.feature	= vp_feature,
+	.get		= vp_get,
+	.set		= vp_set,
+	.get_status	= vp_get_status,
+	.set_status	= vp_set_status,
+	.find_vq	= vp_find_vq,
+	.del_vq		= vp_del_vq,
+};
+
+/* the PCI probing function */
+static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
+				      const struct pci_device_id *id)
+{
+	struct virtio_pci_device *vp_dev;
+	int err;
+
+	/* allocate our structure and fill it out */
+	vp_dev = kzalloc(sizeof(struct virtio_pci_device), GFP_KERNEL);
+	if (vp_dev == NULL)
+		return -ENOMEM;
+
+	vp_dev->pci_dev = pci_dev;
+	vp_dev->vdev.dev.parent = &virtio_pci_root;
+	vp_dev->vdev.index = dev_index++;
+	vp_dev->vdev.config = &virtio_pci_config_ops;
+	INIT_LIST_HEAD(&vp_dev->virtqueues);
+	spin_lock_init(&vp_dev->lock);
+
+	/* enable the device */
+	err = pci_enable_device(pci_dev);
+	if (err)
+		goto out;
+
+	err = pci_request_regions(pci_dev, "virtio-pci");
+	if (err)
+		goto out_enable_device;
+
+	vp_dev->ioaddr = pci_iomap(pci_dev, 0, 0);
+	if (vp_dev->ioaddr == NULL)
+		goto out_req_regions;
+
+	pci_set_drvdata(pci_dev, vp_dev);
+
+	/* we use the subsystem vendor/device id as the virtio vendor/device
+	 * id.  this allows us to use the same PCI vendor/device id for all
+	 * virtio devices and to identify the particular virtio driver by
+	 * the subsytem ids */
+	vp_dev->vdev.id.vendor = pci_dev->subsystem_vendor;
+	vp_dev->vdev.id.device = pci_dev->subsystem_device;
+
+	/* register a handler for the queue with the PCI device's interrupt */
+	err = request_irq(vp_dev->pci_dev->irq, vp_interrupt, IRQF_SHARED,
+			  pci_name(vp_dev->pci_dev), vp_dev);
+	if (err)
+		goto out_set_drvdata;
+
+	/* finally register the virtio device */
+	err = register_virtio_device(&vp_dev->vdev);
+	if (err)
+		goto out_req_irq;
+
+	return 0;
+
+out_req_irq:
+	free_irq(pci_dev->irq, vp_dev);
+out_set_drvdata:
+	pci_set_drvdata(pci_dev, NULL);
+	pci_iounmap(pci_dev, vp_dev->ioaddr);
+out_req_regions:
+	pci_release_regions(pci_dev);
+out_enable_device:
+	pci_disable_device(pci_dev);
+out:
+	kfree(vp_dev);
+	return err;
+}
+
+static void __devexit virtio_pci_remove(struct pci_dev *pci_dev)
+{
+	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
+
+	free_irq(pci_dev->irq, vp_dev);
+	pci_set_drvdata(pci_dev, NULL);
+	pci_iounmap(pci_dev, vp_dev->ioaddr);
+	pci_release_regions(pci_dev);
+	pci_disable_device(pci_dev);
+	kfree(vp_dev);
+}
+
+#ifdef CONFIG_PM
+static int virtio_pci_suspend(struct pci_dev *pci_dev, pm_message_t state)
+{
+	pci_save_state(pci_dev);
+	pci_set_power_state(pci_dev, PCI_D3hot);
+	return 0;
+}
+
+static int virtio_pci_resume(struct pci_dev *pci_dev)
+{
+	pci_restore_state(pci_dev);
+	pci_set_power_state(pci_dev, PCI_D0);
+	return 0;
+}
+#endif
+
+static struct pci_driver virtio_pci_driver = {
+	.name		= "virtio-pci",
+	.id_table	= virtio_pci_id_table,
+	.probe		= virtio_pci_probe,
+	.remove		= virtio_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= virtio_pci_suspend,
+	.resume		= virtio_pci_resume,
+#endif
+};
+
+static int __init virtio_pci_init(void)
+{
+	int err;
+
+	err = device_register(&virtio_pci_root);
+	if (err)
+		return err;
+
+	err = pci_register_driver(&virtio_pci_driver);
+	if (err)
+		device_unregister(&virtio_pci_root);
+
+	return err;
+}
+
+module_init(virtio_pci_init);
+
+static void __exit virtio_pci_exit(void)
+{
+	device_unregister(&virtio_pci_root);
+	pci_unregister_driver(&virtio_pci_driver);
+}
+
+module_exit(virtio_pci_exit);
diff --git a/include/linux/virtio_pci.h b/include/linux/virtio_pci.h
new file mode 100644
index 0000000..b1a1568
--- /dev/null
+++ b/include/linux/virtio_pci.h
@@ -0,0 +1,36 @@
+#ifndef _LINUX_VIRTIO_PCI_H
+#define _LINUX_VIRTIO_PCI_H
+
+#include <linux/virtio_config.h>
+
+/* A 32-bit r/o bitmask of the features supported by the host */
+#define VIRTIO_PCI_HOST_FEATURES	0
+
+/* A 32-bit r/w bitmask of features activated by the guest */
+#define VIRTIO_PCI_GUEST_FEATURES	4
+
+/* A 32-bit r/w PFN for the currently selected queue */
+#define VIRTIO_PCI_QUEUE_PFN		8
+
+/* A 16-bit r/o queue size for the currently selected queue */
+#define VIRTIO_PCI_QUEUE_NUM		12
+
+/* A 16-bit r/w queue selector */
+#define VIRTIO_PCI_QUEUE_SEL		14
+
+/* A 16-bit r/w queue notifier */
+#define VIRTIO_PCI_QUEUE_NOTIFY		16
+
+/* An 8-bit device status register.  */
+#define VIRTIO_PCI_STATUS		18
+
+/* An 8-bit r/o interrupt status register.  Reading the value will return the
+ * current contents of the ISR and will also clear it.  This is effectively
+ * a read-and-acknowledge. */
+#define VIRTIO_PCI_ISR			19
+
+/* The remaining space is defined by each driver as the per-driver
+ * configuration space */
+#define VIRTIO_PCI_CONFIG		20
+
+#endif
