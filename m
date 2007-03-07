Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbXCGLxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbXCGLxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932266AbXCGLxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:53:05 -0500
Received: from mx0.karneval.cz ([81.27.192.123]:3669 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179AbXCGLxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:53:03 -0500
X-Greylist: delayed 988 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2007 06:53:03 EST
Message-id: <2460126662758025813@fi.muni.cz>
Subject: [PATCH 1/1] Input: add sensable phantom driver
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <dtor@mail.ru>
Cc: <linux-input@atrey.karlin.mff.cuni.cz>
Date: Wed,  7 Mar 2007 12:36:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

add sensable phantom driver

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit bb9798e15d86ada19f4d15e31124dc240df78899
tree 06d0ac31976d92128b4e43b4d009810292bdf7a0
parent 551535195b52a4d02b476bbbdf5ca613b8e1afa2
author Jiri Slaby <jirislaby@gmail.com> Wed, 07 Mar 2007 12:29:27 +0100
committer Jiri Slaby <jirislaby@gmail.com> Wed, 07 Mar 2007 12:29:27 +0100

 Documentation/ioctl-number.txt |    1 
 MAINTAINERS                    |    5 
 drivers/input/misc/Kconfig     |    9 +
 drivers/input/misc/Makefile    |    1 
 drivers/input/misc/phantom.c   |  447 ++++++++++++++++++++++++++++++++++++++++
 include/linux/phantom.h        |   48 ++++
 6 files changed, 511 insertions(+), 0 deletions(-)

diff --git a/Documentation/ioctl-number.txt b/Documentation/ioctl-number.txt
index 8f750c0..38da829 100644
--- a/Documentation/ioctl-number.txt
+++ b/Documentation/ioctl-number.txt
@@ -128,6 +128,7 @@ Code	Seq#	Include File		Comments
 					<mailto:zapman@interlan.net>
 'i'	00-3F	linux/i2o.h
 'j'	00-3F	linux/joystick.h
+'k'	00-0F	linux/phantom.h		Sensable PHANToM
 'l'	00-3F	linux/tcfs_fs.h		transparent cryptographic file system
 					<http://mikonos.dia.unisa.it/tcfs>
 'l'	40-7F	linux/udf_fs_i.h	in development:
diff --git a/MAINTAINERS b/MAINTAINERS
index 00fa7f1..d4ee114 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3076,6 +3076,11 @@ L: 	selinux@tycho.nsa.gov (subscribers-only, general discussion)
 W:	http://www.nsa.gov/selinux
 S:	Supported
 
+SENSABLE PHANTOM
+P:	Jiri Slaby
+M:	jirislaby@gmail.com
+S:	Maintained
+
 SERIAL ATA (SATA) SUBSYSTEM:
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 5694115..68fed97 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -98,4 +98,13 @@ config HP_SDC_RTC
 	  Say Y here if you want to support the built-in real time clock
 	  of the HP SDC controller.
 
+config PHANTOM
+	tristate "Sensable PHANToM"
+	depends on PCI
+	help
+	  Say Y here if you want to build a driver for Sensable PHANToM device.
+
+	  If you choose to build module, its name will be phantom. If unsure,
+	  say N here.
+
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 9f08f27..3ab3cc2 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
 obj-$(CONFIG_INPUT_ATLAS_BTNS)		+= atlas_btns.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
+obj-$(CONFIG_PHANTOM)			+= phantom.o
diff --git a/drivers/input/misc/phantom.c b/drivers/input/misc/phantom.c
new file mode 100644
index 0000000..1dcf775
--- /dev/null
+++ b/drivers/input/misc/phantom.c
@@ -0,0 +1,447 @@
+/*
+ *  Copyright (C) 2005-2007 Jiri Slaby <jirislaby@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  You need an userspace library to cooperate with this library. It may be
+ *  obtained here:
+ *  http://www.fi.muni.cz/~xslaby/phantom.html
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/pci.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/interrupt.h>
+#include <linux/cdev.h>
+#include <linux/rtc.h>
+
+#include <asm/io.h>
+
+#include <linux/phantom.h>
+
+#define PHANTOM_VERSION		"n0.9.1"
+
+#define PHANTOM_MAX_MINORS	8
+
+#define phantom_write_cfgl(p, val, off) do {	\
+	writel(val, (p)->caddr + (off));	\
+	readl((p)->caddr + PHN_IRQCTL);	\
+} while (0)
+
+#define phantom_write_inl(p, val, off) do {	\
+	outl(val, (p)->ibase + (off));		\
+	inl((p)->ibase);			\
+} while (0)
+
+static struct class *phantom_class;
+static int phantom_major;
+
+struct phantom_device {
+	unsigned int opened;
+	void __iomem *caddr;
+	unsigned long ibase;
+	unsigned long obase;
+	struct phantom_status *stat;
+	unsigned long status;
+	unsigned int tCu[3];
+	unsigned int tFe[3];
+
+	wait_queue_head_t wait;
+	struct cdev cdev;
+
+	struct mutex open_lock;
+};
+
+static unsigned char phantom_devices[PHANTOM_MAX_MINORS];
+
+/*
+ * Update status of phantom; turn off and/or start task if necessary
+ *
+ * spinlock should be here for safety
+ */
+static int phantom_status(struct phantom_device *dev, unsigned long newstat)
+{
+	pr_debug("phantom_status %lx %lx\n", dev->status, newstat);
+
+	if (!(dev->status & PHB_RUNNING) && (newstat & PHB_RUNNING))
+		phantom_write_cfgl(dev, 0x43, PHN_IRQCTL);
+	else if ((dev->status & PHB_RUNNING) && !(newstat & PHB_RUNNING))
+		phantom_write_cfgl(dev, 0, PHN_IRQCTL);
+
+	dev->status = newstat;
+
+	return 0;
+}
+
+/******************************************************************************
+ * File ops
+ */
+
+static int phantom_ioctl(struct inode *inode, struct file *file, u_int cmd,
+	u_long arg)
+{
+	struct phantom_device *dev = file->private_data;
+
+	if (_IOC_TYPE(cmd) != PH_IOC_MAGIC ||
+			_IOC_NR(cmd) > PH_IOC_MAXNR)
+		return -ENOTTY;
+
+	switch (cmd) {
+	case PH_IOCSTART:
+		return phantom_status(dev, dev->status | PHB_RUNNING);
+	case PH_IOCSTOP:
+		return phantom_status(dev, dev->status & ~PHB_RUNNING);
+	case PH_IOCGET_STATUS:
+		if (put_user(dev->status, (int __user *)arg))
+			return -EFAULT;
+		break;
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
+static int phantom_open(struct inode *inode, struct file *file)
+{
+	struct phantom_device *dev = container_of(inode->i_cdev,
+			struct phantom_device, cdev);
+
+	if (mutex_lock_interruptible(&dev->open_lock))
+		return -ERESTARTSYS;
+
+	if (dev->opened) {
+		mutex_unlock(&dev->open_lock);
+		return -EINVAL;
+	}
+
+	memset(dev->stat, 0, PAGE_ALIGN(sizeof(*dev->stat)));
+	memcpy(dev->stat->tCu, dev->tCu, sizeof(dev->tCu));
+	memcpy(dev->stat->tFe, dev->tFe, sizeof(dev->tFe));
+	dev->stat->reset = !!(dev->status & PHB_RESET);
+
+	file->private_data = dev;
+
+	dev->opened++;
+	mutex_unlock(&dev->open_lock);
+
+	return 0;
+}
+
+static int phantom_release(struct inode *inode, struct file *file)
+{
+	struct phantom_device *dev = file->private_data;
+
+	if (mutex_lock_interruptible(&dev->open_lock))
+		return -ERESTARTSYS;
+
+	dev->opened = 0;
+	phantom_status(dev, dev->status & ~PHB_RUNNING);
+	memcpy(dev->tCu, dev->stat->tCu, sizeof(dev->tCu));
+	memcpy(dev->tFe, dev->stat->tFe, sizeof(dev->tFe));
+	if (dev->stat->reset)
+		dev->status |= PHB_RESET;
+
+	mutex_unlock(&dev->open_lock);
+
+	return 0;
+}
+
+static unsigned int phantom_poll(struct file *file, poll_table *wait)
+{
+	struct phantom_device *dev = file->private_data;
+	unsigned int mask = 0;
+
+	pr_debug("phantom_poll: %u\n", dev->stat->counter);
+	poll_wait(file, &dev->wait, wait);
+	if (dev->stat->counter)
+		mask = POLLIN | POLLRDNORM;
+	else if ((dev->status & PHB_RUNNING) == 0)
+		mask = POLLIN | POLLRDNORM | POLLERR;
+	pr_debug("phantom_poll end: %x/%u\n", mask, dev->stat->counter);
+
+	return mask;
+}
+
+#define phantom_remap(io, vma, addr)	({				\
+	vma->vm_pgoff = (addr) >> PAGE_SHIFT;				\
+	io ## remap_pfn_range(vma, (vma)->vm_start, (vma)->vm_pgoff,	\
+		(vma)->vm_end - (vma)->vm_start, (vma)->vm_page_prot);	\
+})
+
+static int phantom_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct phantom_device *dev = file->private_data;
+	int retval;
+
+	switch (vma->vm_pgoff) {
+	case 0:
+		retval = phantom_remap(, vma, virt_to_phys(dev->stat));
+		break;
+	case 1:
+		retval = phantom_remap(io_, vma, dev->ibase);
+		break;
+	default:
+		retval = phantom_remap(io_, vma, dev->obase);
+	}
+
+	return retval ? -EINVAL : 0;
+}
+
+static struct file_operations phantom_file_ops = {
+	.open = phantom_open,
+	.release = phantom_release,
+	.ioctl = phantom_ioctl,
+	.poll = phantom_poll,
+	.mmap = phantom_mmap,
+};
+
+static irqreturn_t phantom_isr(int irq, void *data)
+{
+	static unsigned int cnt;
+	struct phantom_device *dev = data;
+
+	if (!(inl(dev->ibase + PHN_CONTROL) & 0x10))
+		return IRQ_NONE;
+
+	phantom_write_inl(dev, 0, 0);
+	phantom_write_inl(dev, 0xc0, 0);
+	if (++cnt >= 22) { /* 22 times ~ 2kHz */
+		dev->stat->counter++;
+		wake_up_interruptible(&dev->wait);
+		cnt = 0;
+	}
+
+	return IRQ_HANDLED;
+}
+
+/******************************************************************************
+ * Init and deinit driver
+ */
+
+static unsigned int __devinit phantom_get_free(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < PHANTOM_MAX_MINORS; i++)
+		if (phantom_devices[i] == 0)
+			break;
+
+	return i;
+}
+
+static int __devinit phantom_probe(struct pci_dev *pdev,
+	const struct pci_device_id *pci_id)
+{
+	struct phantom_device *pht;
+	unsigned int minor;
+	int retval;
+
+	retval = pci_enable_device(pdev);
+	if (retval)
+		goto err;
+
+	minor = phantom_get_free();
+	if (minor == PHANTOM_MAX_MINORS) {
+		dev_err(&pdev->dev, "too many devices found!\n");
+		retval = -EIO;
+		goto err;
+	}
+
+	phantom_devices[minor] = 1;
+
+	retval = pci_request_regions(pdev, "phantom");
+	if (retval)
+		goto err_null;
+
+	retval = -ENOMEM;
+	pht = kzalloc(sizeof(*pht), GFP_KERNEL);
+	if (pht == NULL) {
+		dev_err(&pdev->dev, "unable to allocate device\n");
+		goto err_reg;
+	}
+
+	pht->stat = (void *)__get_free_page(GFP_KERNEL | __GFP_WAIT);
+	if (pht->stat == NULL)
+		goto err_fr;
+
+	pht->caddr = pci_iomap(pdev, 0, 0);
+	if (pht->caddr == NULL) {
+		dev_err(&pdev->dev, "can't remap conf space\n");
+		goto err_frp;
+	}
+	pht->ibase = pci_resource_start(pdev, 2);
+	pht->obase = pci_resource_start(pdev, 3);
+
+	mutex_init(&pht->open_lock);
+	init_waitqueue_head(&pht->wait);
+
+	phantom_write_cfgl(pht, 0, PHN_IRQCTL);
+	retval = request_irq(pdev->irq, phantom_isr,
+			IRQF_SHARED | IRQF_DISABLED, "phantom", pht);
+	if (retval) {
+		dev_err(&pdev->dev, "can't establish ISR\n");
+		goto err_unm;
+	}
+
+	cdev_init(&pht->cdev, &phantom_file_ops);
+	pht->cdev.owner = THIS_MODULE;
+	retval = cdev_add(&pht->cdev, MKDEV(phantom_major, minor), 1);
+	if (retval) {
+		dev_err(&pdev->dev, "chardev registration failed\n");
+		goto err_irq;
+	}
+
+	device_create(phantom_class, &pdev->dev, MKDEV(phantom_major, minor),
+			"phantom%u", minor);
+
+	pci_set_drvdata(pdev, pht);
+
+	return 0;
+err_irq:
+	free_irq(pdev->irq, pht);
+err_unm:
+	pci_iounmap(pdev, pht->caddr);
+err_frp:
+	free_page((unsigned long)pht->stat);
+err_fr:
+	kfree(pht);
+err_reg:
+	pci_release_regions(pdev);
+err_null:
+	phantom_devices[minor] = 0;
+err:
+	return retval;
+}
+
+static void __devexit phantom_remove(struct pci_dev *pdev)
+{
+	struct phantom_device *pht = pci_get_drvdata(pdev);
+	unsigned int minor = MINOR(pht->cdev.dev);
+
+	device_destroy(phantom_class, MKDEV(phantom_major, minor));
+
+	cdev_del(&pht->cdev);
+
+	phantom_write_cfgl(pht, 0, PHN_IRQCTL);
+	free_irq(pdev->irq, pht);
+
+	pci_iounmap(pdev, pht->caddr);
+
+	free_page((unsigned long)pht->stat);
+
+	phantom_devices[minor] = 0;
+	kfree(pht);
+
+	pci_release_regions(pdev);
+}
+
+static int phantom_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct phantom_device *dev = pci_get_drvdata(pdev);
+
+	phantom_write_cfgl(dev, 0, PHN_IRQCTL);
+
+	return 0;
+}
+
+static int phantom_resume(struct pci_dev *pdev)
+{
+	struct phantom_device *dev = pci_get_drvdata(pdev);
+
+	phantom_write_cfgl(dev, 0, PHN_IRQCTL);
+
+	return 0;
+}
+
+static struct pci_device_id phantom_pci_tbl[] __devinitdata = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050),
+		.class = PCI_CLASS_BRIDGE_OTHER << 8, .class_mask = 0xffff00 },
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, phantom_pci_tbl);
+
+static struct pci_driver phantom_pci_driver = {
+	.name = "phantom",
+	.id_table = phantom_pci_tbl,
+	.probe = phantom_probe,
+	.remove = __devexit_p(phantom_remove),
+	.suspend = phantom_suspend,
+	.resume = phantom_resume
+};
+
+static ssize_t phantom_show_version(struct class *cls, char *buf)
+{
+	return sprintf(buf, PHANTOM_VERSION "\n");
+}
+
+static CLASS_ATTR(version, 0444, phantom_show_version, NULL);
+
+static int __init phantom_init(void)
+{
+	int retval;
+	dev_t dev;
+
+	phantom_class = class_create(THIS_MODULE, "phantom");
+	if (IS_ERR(phantom_class)) {
+		retval = PTR_ERR(phantom_class);
+		printk(KERN_ERR "phantom: can't register phantom class\n");
+		goto err;
+	}
+	retval = class_create_file(phantom_class, &class_attr_version);
+	if (retval) {
+		printk(KERN_ERR "phantom: can't create sysfs version file\n");
+		goto err_class;
+	}
+
+	retval = alloc_chrdev_region(&dev, 0, PHANTOM_MAX_MINORS, "phantom");
+	if (retval) {
+		printk(KERN_ERR "phantom: can't register character device\n");
+		goto err_attr;
+	}
+	phantom_major = MAJOR(dev);
+
+	retval = pci_register_driver(&phantom_pci_driver);
+	if (retval) {
+		printk(KERN_ERR "phantom: can't register pci driver\n");
+		goto err_unchr;
+	}
+
+	printk(KERN_INFO "Phantom Linux Driver, version " PHANTOM_VERSION ", "
+			"init OK\n");
+
+	return 0;
+err_unchr:
+	unregister_chrdev_region(dev, PHANTOM_MAX_MINORS);
+err_attr:
+	class_remove_file(phantom_class, &class_attr_version);
+err_class:
+	class_destroy(phantom_class);
+err:
+	return retval;
+}
+
+static void __exit phantom_exit(void)
+{
+	pci_unregister_driver(&phantom_pci_driver);
+
+	unregister_chrdev_region(MKDEV(phantom_major, 0), PHANTOM_MAX_MINORS);
+
+	class_remove_file(phantom_class, &class_attr_version);
+	class_destroy(phantom_class);
+
+	pr_debug(KERN_INFO "phantom: module successfully removed\n");
+}
+
+module_init(phantom_init);
+module_exit(phantom_exit);
+
+MODULE_AUTHOR("Jiri Slaby <jirislaby@gmail.com>");
+MODULE_DESCRIPTION("Sensable Phantom driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/phantom.h b/include/linux/phantom.h
new file mode 100644
index 0000000..57a8616
--- /dev/null
+++ b/include/linux/phantom.h
@@ -0,0 +1,48 @@
+/*
+ *  Copyright (C) 2005-2007 Jiri Slaby <jirislaby@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ */
+
+#ifndef __PHANTOM_H
+#define __PHANTOM_H
+
+/* some common public defines & structures */
+#define PH_IOC_MAGIC		'k'
+#define PH_IOCSTOP		_IO (PH_IOC_MAGIC, 1)
+#define PH_IOCSTART		_IO (PH_IOC_MAGIC, 2)
+#define PH_IOCGET_STATUS	_IOR(PH_IOC_MAGIC, 3, int)
+#define PH_IOC_MAXNR		3
+
+#define PHB_RUNNING		1
+#define PHB_RESET		2
+
+#define PHN_BUTTON_BIT		2
+#define PHN_CONTROL		6
+#define PHN_IRQCTL		0x4c
+#define PHN_ZERO_FORCE		2048
+
+/* pointer for location of shared memory - its useful to put
+ * shared memory to some special address - especially for debugging :-)
+ *
+ * process mmap-ing phantom memory should use this constant;
+ */
+
+struct phantom_status {
+	unsigned int counter;
+	unsigned int tCu[3];
+	unsigned int tFe[3];
+	unsigned int reset:1;
+};
+
+#define PHANTOM_MMAP_OFF_STAT	0x00000000
+#define PHANTOM_MMAP_LEN_STAT	sizeof(struct phantom_status)
+#define PHANTOM_MMAP_OFF_IBASE	0x00001000
+#define PHANTOM_MMAP_LEN_IBASE	0x00000020
+#define PHANTOM_MMAP_OFF_OBASE	0x00002000
+#define PHANTOM_MMAP_LEN_OBASE	0x00000020
+
+#endif
