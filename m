Return-Path: <linux-kernel-owner+w=401wt.eu-S932498AbYDQJSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbYDQJSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758709AbYDQJLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:18 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:59024
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999AbYDQJLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:00 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 16/45] s390: KVM guest: virtio device support, and kvm hypercalls
Date: Thu, 17 Apr 2008 12:10:21 +0300
Message-Id: <1208423450-29415-17-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

This patch implements kvm guest kernel support for paravirtualized devices
and contains two parts:
o a basic virtio stub using virtio_ring and external interrupts and hypercalls
o full hypercall implementation in kvm_para.h

Currently we dont have PCI on s390. Making virtio_pci usable for s390 seems
more complicated that providing an own stub. This virtio stub is similar to
the lguest one, the memory for the descriptors and the device detection is made
via additional mapped memory on top of the guest storage. We use an external
interrupt with extint code 0x2603 for host->guest notification.

The hypercall definition uses the diag instruction for issuing a hypercall. The
parameters are written in R2-R7, the hypercall number is written in R1. This is
similar to the system call ABI (svc) which can use R1 for the number and R2-R6
for the parameters.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/s390/Makefile         |    2 +-
 drivers/s390/kvm/Makefile     |    9 +
 drivers/s390/kvm/kvm_virtio.c |  338 +++++++++++++++++++++++++++++++++++++++++
 include/asm-s390/kvm_para.h   |  124 +++++++++++++++-
 include/asm-s390/kvm_virtio.h |   53 +++++++
 5 files changed, 523 insertions(+), 3 deletions(-)
 create mode 100644 drivers/s390/kvm/Makefile
 create mode 100644 drivers/s390/kvm/kvm_virtio.c
 create mode 100644 include/asm-s390/kvm_virtio.h

diff --git a/drivers/s390/Makefile b/drivers/s390/Makefile
index 5a88870..4f4e7cf 100644
--- a/drivers/s390/Makefile
+++ b/drivers/s390/Makefile
@@ -5,7 +5,7 @@
 CFLAGS_sysinfo.o += -Iinclude/math-emu -Iarch/s390/math-emu -w
 
 obj-y += s390mach.o sysinfo.o s390_rdev.o
-obj-y += cio/ block/ char/ crypto/ net/ scsi/
+obj-y += cio/ block/ char/ crypto/ net/ scsi/ kvm/
 
 drivers-y += drivers/s390/built-in.o
 
diff --git a/drivers/s390/kvm/Makefile b/drivers/s390/kvm/Makefile
new file mode 100644
index 0000000..4a5ec39
--- /dev/null
+++ b/drivers/s390/kvm/Makefile
@@ -0,0 +1,9 @@
+# Makefile for kvm guest drivers on s390
+#
+# Copyright IBM Corp. 2008
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License (version 2 only)
+# as published by the Free Software Foundation.
+
+obj-$(CONFIG_VIRTIO) += kvm_virtio.o
diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
new file mode 100644
index 0000000..bbef376
--- /dev/null
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -0,0 +1,338 @@
+/*
+ * kvm_virtio.c - virtio for kvm on s390
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ *
+ *    Author(s): Christian Borntraeger <borntraeger@de.ibm.com>
+ */
+
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/err.h>
+#include <linux/virtio.h>
+#include <linux/virtio_config.h>
+#include <linux/interrupt.h>
+#include <linux/virtio_ring.h>
+#include <asm/io.h>
+#include <asm/kvm_para.h>
+#include <asm/kvm_virtio.h>
+#include <asm/setup.h>
+#include <asm/s390_ext.h>
+
+#define VIRTIO_SUBCODE_64 0x0D00
+
+/*
+ * The pointer to our (page) of device descriptions.
+ */
+static void *kvm_devices;
+
+/*
+ * Unique numbering for kvm devices.
+ */
+static unsigned int dev_index;
+
+struct kvm_device {
+	struct virtio_device vdev;
+	struct kvm_device_desc *desc;
+};
+
+#define to_kvmdev(vd) container_of(vd, struct kvm_device, vdev)
+
+/*
+ * memory layout:
+ * - kvm_device_descriptor
+ *        struct kvm_device_desc
+ * - configuration
+ *        struct kvm_vqconfig
+ * - feature bits
+ * - config space
+ */
+static struct kvm_vqconfig *kvm_vq_config(const struct kvm_device_desc *desc)
+{
+	return (struct kvm_vqconfig *)(desc + 1);
+}
+
+static u8 *kvm_vq_features(const struct kvm_device_desc *desc)
+{
+	return (u8 *)(kvm_vq_config(desc) + desc->num_vq);
+}
+
+static u8 *kvm_vq_configspace(const struct kvm_device_desc *desc)
+{
+	return kvm_vq_features(desc) + desc->feature_len * 2;
+}
+
+/*
+ * The total size of the config page used by this device (incl. desc)
+ */
+static unsigned desc_size(const struct kvm_device_desc *desc)
+{
+	return sizeof(*desc)
+		+ desc->num_vq * sizeof(struct kvm_vqconfig)
+		+ desc->feature_len * 2
+		+ desc->config_len;
+}
+
+/*
+ * This tests (and acknowleges) a feature bit.
+ */
+static bool kvm_feature(struct virtio_device *vdev, unsigned fbit)
+{
+	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
+	u8 *features;
+
+	if (fbit / 8 > desc->feature_len)
+		return false;
+
+	features = kvm_vq_features(desc);
+	if (!(features[fbit / 8] & (1 << (fbit % 8))))
+		return false;
+
+	/*
+	 * We set the matching bit in the other half of the bitmap to tell the
+	 * Host we want to use this feature.
+	 */
+	features[desc->feature_len + fbit / 8] |= (1 << (fbit % 8));
+	return true;
+}
+
+/*
+ * Reading and writing elements in config space
+ */
+static void kvm_get(struct virtio_device *vdev, unsigned int offset,
+		   void *buf, unsigned len)
+{
+	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
+
+	BUG_ON(offset + len > desc->config_len);
+	memcpy(buf, kvm_vq_configspace(desc) + offset, len);
+}
+
+static void kvm_set(struct virtio_device *vdev, unsigned int offset,
+		   const void *buf, unsigned len)
+{
+	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
+
+	BUG_ON(offset + len > desc->config_len);
+	memcpy(kvm_vq_configspace(desc) + offset, buf, len);
+}
+
+/*
+ * The operations to get and set the status word just access
+ * the status field of the device descriptor. set_status will also
+ * make a hypercall to the host, to tell about status changes
+ */
+static u8 kvm_get_status(struct virtio_device *vdev)
+{
+	return to_kvmdev(vdev)->desc->status;
+}
+
+static void kvm_set_status(struct virtio_device *vdev, u8 status)
+{
+	BUG_ON(!status);
+	to_kvmdev(vdev)->desc->status = status;
+	kvm_hypercall1(KVM_S390_VIRTIO_SET_STATUS,
+		       (unsigned long) to_kvmdev(vdev)->desc);
+}
+
+/*
+ * To reset the device, we use the KVM_VIRTIO_RESET hypercall, using the
+ * descriptor address. The Host will zero the status and all the
+ * features.
+ */
+static void kvm_reset(struct virtio_device *vdev)
+{
+	kvm_hypercall1(KVM_S390_VIRTIO_RESET,
+		       (unsigned long) to_kvmdev(vdev)->desc);
+}
+
+/*
+ * When the virtio_ring code wants to notify the Host, it calls us here and we
+ * make a hypercall.  We hand the address  of the virtqueue so the Host
+ * knows which virtqueue we're talking about.
+ */
+static void kvm_notify(struct virtqueue *vq)
+{
+	struct kvm_vqconfig *config = vq->priv;
+
+	kvm_hypercall1(KVM_S390_VIRTIO_NOTIFY, config->address);
+}
+
+/*
+ * This routine finds the first virtqueue described in the configuration of
+ * this device and sets it up.
+ */
+static struct virtqueue *kvm_find_vq(struct virtio_device *vdev,
+				    unsigned index,
+				    void (*callback)(struct virtqueue *vq))
+{
+	struct kvm_device *kdev = to_kvmdev(vdev);
+	struct kvm_vqconfig *config;
+	struct virtqueue *vq;
+	int err;
+
+	if (index >= kdev->desc->num_vq)
+		return ERR_PTR(-ENOENT);
+
+	config = kvm_vq_config(kdev->desc)+index;
+
+	if (add_shared_memory(config->address,
+				vring_size(config->num, PAGE_SIZE))) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	vq = vring_new_virtqueue(config->num, vdev, (void *) config->address,
+				 kvm_notify, callback);
+	if (!vq) {
+		err = -ENOMEM;
+		goto unmap;
+	}
+
+	/*
+	 * register a callback token
+	 * The host will sent this via the external interrupt parameter
+	 */
+	config->token = (u64) vq;
+
+	vq->priv = config;
+	return vq;
+unmap:
+	remove_shared_memory(config->address, vring_size(config->num,
+			     PAGE_SIZE));
+out:
+	return ERR_PTR(err);
+}
+
+static void kvm_del_vq(struct virtqueue *vq)
+{
+	struct kvm_vqconfig *config = vq->priv;
+
+	vring_del_virtqueue(vq);
+	remove_shared_memory(config->address,
+			     vring_size(config->num, PAGE_SIZE));
+}
+
+/*
+ * The config ops structure as defined by virtio config
+ */
+static struct virtio_config_ops kvm_vq_configspace_ops = {
+	.feature = kvm_feature,
+	.get = kvm_get,
+	.set = kvm_set,
+	.get_status = kvm_get_status,
+	.set_status = kvm_set_status,
+	.reset = kvm_reset,
+	.find_vq = kvm_find_vq,
+	.del_vq = kvm_del_vq,
+};
+
+/*
+ * The root device for the kvm virtio devices.
+ * This makes them appear as /sys/devices/kvm_s390/0,1,2 not /sys/devices/0,1,2.
+ */
+static struct device kvm_root = {
+	.parent = NULL,
+	.bus_id = "kvm_s390",
+};
+
+/*
+ * adds a new device and register it with virtio
+ * appropriate drivers are loaded by the device model
+ */
+static void add_kvm_device(struct kvm_device_desc *d)
+{
+	struct kvm_device *kdev;
+
+	kdev = kzalloc(sizeof(*kdev), GFP_KERNEL);
+	if (!kdev) {
+		printk(KERN_EMERG "Cannot allocate kvm dev %u\n",
+		       dev_index++);
+		return;
+	}
+
+	kdev->vdev.dev.parent = &kvm_root;
+	kdev->vdev.index = dev_index++;
+	kdev->vdev.id.device = d->type;
+	kdev->vdev.config = &kvm_vq_configspace_ops;
+	kdev->desc = d;
+
+	if (register_virtio_device(&kdev->vdev) != 0) {
+		printk(KERN_ERR "Failed to register kvm device %u\n",
+		       kdev->vdev.index);
+		kfree(kdev);
+	}
+}
+
+/*
+ * scan_devices() simply iterates through the device page.
+ * The type 0 is reserved to mean "end of devices".
+ */
+static void scan_devices(void)
+{
+	unsigned int i;
+	struct kvm_device_desc *d;
+
+	for (i = 0; i < PAGE_SIZE; i += desc_size(d)) {
+		d = kvm_devices + i;
+
+		if (d->type == 0)
+			break;
+
+		add_kvm_device(d);
+	}
+}
+
+/*
+ * we emulate the request_irq behaviour on top of s390 extints
+ */
+static void kvm_extint_handler(u16 code)
+{
+	void *data = (void *) *(long *) __LC_PFAULT_INTPARM;
+	u16 subcode = S390_lowcore.cpu_addr;
+
+	if ((subcode & 0xff00) != VIRTIO_SUBCODE_64)
+		return;
+
+	vring_interrupt(0, data);
+}
+
+/*
+ * Init function for virtio
+ * devices are in a single page above top of "normal" mem
+ */
+static int __init kvm_devices_init(void)
+{
+	int rc;
+
+	if (!MACHINE_IS_KVM)
+		return -ENODEV;
+
+	rc = device_register(&kvm_root);
+	if (rc) {
+		printk(KERN_ERR "Could not register kvm_s390 root device");
+		return rc;
+	}
+
+	if (add_shared_memory((max_pfn) << PAGE_SHIFT, PAGE_SIZE)) {
+		device_unregister(&kvm_root);
+		return -ENOMEM;
+	}
+
+	kvm_devices  = (void *) (max_pfn << PAGE_SHIFT);
+
+	ctl_set_bit(0, 9);
+	register_external_interrupt(0x2603, kvm_extint_handler);
+
+	scan_devices();
+	return 0;
+}
+
+/*
+ * We do this after core stuff, but before the drivers.
+ */
+postcore_initcall(kvm_devices_init);
diff --git a/include/asm-s390/kvm_para.h b/include/asm-s390/kvm_para.h
index e9bd3fb..2c50379 100644
--- a/include/asm-s390/kvm_para.h
+++ b/include/asm-s390/kvm_para.h
@@ -14,14 +14,134 @@
 #define __S390_KVM_PARA_H
 
 /*
- * No hypercalls for KVM on s390
+ * Hypercalls for KVM on s390. The calling convention is similar to the
+ * s390 ABI, so we use R2-R6 for parameters 1-5. In addition we use R1
+ * as hypercall number and R7 as parameter 6. The return value is
+ * written to R2. We use the diagnose instruction as hypercall. To avoid
+ * conflicts with existing diagnoses for LPAR and z/VM, we do not use
+ * the instruction encoded number, but specify the number in R1 and
+ * use 0x500 as KVM hypercall
+ *
+ * Copyright IBM Corp. 2007,2008
+ * Author(s): Christian Borntraeger <borntraeger@de.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
  */
 
+static inline long kvm_hypercall0(unsigned long nr)
+{
+	register unsigned long __nr asm("1") = nr;
+	register long __rc asm("2");
+
+	asm volatile ("diag 2,4,0x500\n"
+		      : "=d" (__rc) : "d" (__nr): "memory", "cc");
+	return __rc;
+}
+
+static inline long kvm_hypercall1(unsigned long nr, unsigned long p1)
+{
+	register unsigned long __nr asm("1") = nr;
+	register unsigned long __p1 asm("2") = p1;
+	register long __rc asm("2");
+
+	asm volatile ("diag 2,4,0x500\n"
+		      : "=d" (__rc) : "d" (__nr), "0" (__p1) : "memory", "cc");
+	return __rc;
+}
+
+static inline long kvm_hypercall2(unsigned long nr, unsigned long p1,
+			       unsigned long p2)
+{
+	register unsigned long __nr asm("1") = nr;
+	register unsigned long __p1 asm("2") = p1;
+	register unsigned long __p2 asm("3") = p2;
+	register long __rc asm("2");
+
+	asm volatile ("diag 2,4,0x500\n"
+		      : "=d" (__rc) : "d" (__nr), "0" (__p1), "d" (__p2)
+		      : "memory", "cc");
+	return __rc;
+}
+
+static inline long kvm_hypercall3(unsigned long nr, unsigned long p1,
+			       unsigned long p2, unsigned long p3)
+{
+	register unsigned long __nr asm("1") = nr;
+	register unsigned long __p1 asm("2") = p1;
+	register unsigned long __p2 asm("3") = p2;
+	register unsigned long __p3 asm("4") = p3;
+	register long __rc asm("2");
+
+	asm volatile ("diag 2,4,0x500\n"
+		      : "=d" (__rc) : "d" (__nr), "0" (__p1), "d" (__p2),
+			"d" (__p3) : "memory", "cc");
+	return __rc;
+}
+
+
+static inline long kvm_hypercall4(unsigned long nr, unsigned long p1,
+			       unsigned long p2, unsigned long p3,
+			       unsigned long p4)
+{
+	register unsigned long __nr asm("1") = nr;
+	register unsigned long __p1 asm("2") = p1;
+	register unsigned long __p2 asm("3") = p2;
+	register unsigned long __p3 asm("4") = p3;
+	register unsigned long __p4 asm("5") = p4;
+	register long __rc asm("2");
+
+	asm volatile ("diag 2,4,0x500\n"
+		      : "=d" (__rc) : "d" (__nr), "0" (__p1), "d" (__p2),
+			"d" (__p3), "d" (__p4) : "memory", "cc");
+	return __rc;
+}
+
+static inline long kvm_hypercall5(unsigned long nr, unsigned long p1,
+			       unsigned long p2, unsigned long p3,
+			       unsigned long p4, unsigned long p5)
+{
+	register unsigned long __nr asm("1") = nr;
+	register unsigned long __p1 asm("2") = p1;
+	register unsigned long __p2 asm("3") = p2;
+	register unsigned long __p3 asm("4") = p3;
+	register unsigned long __p4 asm("5") = p4;
+	register unsigned long __p5 asm("6") = p5;
+	register long __rc asm("2");
+
+	asm volatile ("diag 2,4,0x500\n"
+		      : "=d" (__rc) : "d" (__nr), "0" (__p1), "d" (__p2),
+			"d" (__p3), "d" (__p4), "d" (__p5)  : "memory", "cc");
+	return __rc;
+}
+
+static inline long kvm_hypercall6(unsigned long nr, unsigned long p1,
+			       unsigned long p2, unsigned long p3,
+			       unsigned long p4, unsigned long p5,
+			       unsigned long p6)
+{
+	register unsigned long __nr asm("1") = nr;
+	register unsigned long __p1 asm("2") = p1;
+	register unsigned long __p2 asm("3") = p2;
+	register unsigned long __p3 asm("4") = p3;
+	register unsigned long __p4 asm("5") = p4;
+	register unsigned long __p5 asm("6") = p5;
+	register unsigned long __p6 asm("7") = p6;
+	register long __rc asm("2");
+
+	asm volatile ("diag 2,4,0x500\n"
+		      : "=d" (__rc) : "d" (__nr), "0" (__p1), "d" (__p2),
+			"d" (__p3), "d" (__p4), "d" (__p5), "d" (__p6)
+		      : "memory", "cc");
+	return __rc;
+}
+
+/* kvm on s390 is always paravirtualization enabled */
 static inline int kvm_para_available(void)
 {
-	return 0;
+	return 1;
 }
 
+/* No feature bits are currently assigned for kvm on s390 */
 static inline unsigned int kvm_arch_para_features(void)
 {
 	return 0;
diff --git a/include/asm-s390/kvm_virtio.h b/include/asm-s390/kvm_virtio.h
new file mode 100644
index 0000000..5c871a9
--- /dev/null
+++ b/include/asm-s390/kvm_virtio.h
@@ -0,0 +1,53 @@
+/*
+ * kvm_virtio.h - definition for virtio for kvm on s390
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ *
+ *    Author(s): Christian Borntraeger <borntraeger@de.ibm.com>
+ */
+
+#ifndef __KVM_S390_VIRTIO_H
+#define __KVM_S390_VIRTIO_H
+
+#include <linux/types.h>
+
+struct kvm_device_desc {
+	/* The device type: console, network, disk etc.  Type 0 terminates. */
+	__u8 type;
+	/* The number of virtqueues (first in config array) */
+	__u8 num_vq;
+	/*
+	 * The number of bytes of feature bits.  Multiply by 2: one for host
+	 * features and one for guest acknowledgements.
+	 */
+	__u8 feature_len;
+	/* The number of bytes of the config array after virtqueues. */
+	__u8 config_len;
+	/* A status byte, written by the Guest. */
+	__u8 status;
+	__u8 config[0];
+};
+
+/*
+ * This is how we expect the device configuration field for a virtqueue
+ * to be laid out in config space.
+ */
+struct kvm_vqconfig {
+	/* The token returned with an interrupt. Set by the guest */
+	__u64 token;
+	/* The address of the virtio ring */
+	__u64 address;
+	/* The number of entries in the virtio_ring */
+	__u16 num;
+
+};
+
+#define KVM_S390_VIRTIO_NOTIFY		0
+#define KVM_S390_VIRTIO_RESET		1
+#define KVM_S390_VIRTIO_SET_STATUS	2
+
+#endif
-- 
1.5.5

