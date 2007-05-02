Return-Path: <linux-kernel-owner+w=401wt.eu-S2993420AbXEBP4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993420AbXEBP4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993419AbXEBP4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:56:15 -0400
Received: from av7.karneval.cz ([81.27.192.15]:56124 "EHLO av6.karneval.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993420AbXEBP4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:56:08 -0400
Message-id: <219403193181341921@karneval.cz>
Subject: [PATCH -v2 1/1] Misc: add sensable phantom driver
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed,  2 May 2007 17:56:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm attaching the phantom driver -v2. Please drop

input-ff-add-ff_raw-effect.patch
input-phantom-add-a-new-driver.patch

before applying this patch. Thanks.

--
add sensable phantom driver

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit d8cb58f904b80e250383e68832204fafaf02da8b
tree f3d95c2a3b0283d651799a2db797d133263b5a95
parent 3947dc9399ee9a24d293bf2d7ab92e434e2756fb
author Jiri Slaby <jirislaby@gmail.com> Wed, 02 May 2007 17:52:50 +0200
committer Jiri Slaby <jirislaby@gmail.com> Wed, 02 May 2007 17:52:50 +0200

 Documentation/ioctl-number.txt |    3 
 MAINTAINERS                    |    5 
 drivers/misc/Kconfig           |    9 +
 drivers/misc/Makefile          |    1 
 drivers/misc/phantom.c         |  459 ++++++++++++++++++++++++++++++++++++++++
 include/linux/phantom.h        |   42 ++++
 6 files changed, 518 insertions(+), 1 deletions(-)

diff --git a/Documentation/ioctl-number.txt b/Documentation/ioctl-number.txt
index 8f750c0..3de7d37 100644
--- a/Documentation/ioctl-number.txt
+++ b/Documentation/ioctl-number.txt
@@ -138,7 +138,8 @@ Code	Seq#	Include File		Comments
 'm'	00-1F	net/irda/irmod.h	conflict!
 'n'	00-7F	linux/ncp_fs.h
 'n'	E0-FF	video/matrox.h          matroxfb
-'p'	00-3F	linux/mc146818rtc.h
+'p'	00-0F	linux/phantom.h		conflict! (OpenHaptics needs this)
+'p'	00-3F	linux/mc146818rtc.h	conflict!
 'p'	40-7F	linux/nvram.h
 'p'	80-9F				user-space parport
 					<mailto:tim@cyberelk.net>
diff --git a/MAINTAINERS b/MAINTAINERS
index 6fda30d..af24ba3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3092,6 +3092,11 @@ L: 	selinux@tycho.nsa.gov (subscribers-only, general discussion)
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
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index bfb02c1..ce74306 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -186,5 +186,14 @@ config BLINK
 	  output something to the screen like kexec kernels to give the user
 	  a visual indication that the kernel is doing something.
 
+config PHANTOM
+	tristate "Sensable PHANToM"
+	depends on PCI
+	help
+	  Say Y here if you want to build a driver for Sensable PHANToM device.
+
+	  If you choose to build module, its name will be phantom. If unsure,
+	  say N here.
+
 
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index ece6baf..b54420c 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7xx1.o
 obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
 obj-$(CONFIG_SONY_LAPTOP)	+= sony-laptop.o
 obj-$(CONFIG_THINKPAD_ACPI)	+= thinkpad_acpi.o
+obj-$(CONFIG_PHANTOM)		+= phantom.o
diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
new file mode 100644
index 0000000..bca00a0
--- /dev/null
+++ b/drivers/misc/phantom.c
@@ -0,0 +1,459 @@
+/*
+ *  Copyright (C) 2005-2007 Jiri Slaby <jirislaby@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  You need an userspace library to cooperate with this driver. It (and other
+ *  info) may be obtained here:
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
+#include <linux/phantom.h>
+
+#include <asm/io.h>
+
+#define PHANTOM_VERSION		"n0.9.5"
+
+#define PHANTOM_MAX_MINORS	8
+
+#define PHN_IRQCTL		0x4c    /* irq control in caddr space */
+
+#define PHB_RUNNING		1
+
+static struct class *phantom_class;
+static int phantom_major;
+
+struct phantom_device {
+	unsigned int opened;
+	void __iomem *caddr;
+	u32 __iomem *iaddr;
+	u32 __iomem *oaddr;
+	unsigned long status;
+	unsigned int counter;
+
+	wait_queue_head_t wait;
+	struct cdev cdev;
+
+	struct mutex open_lock;
+};
+
+static unsigned char phantom_devices[PHANTOM_MAX_MINORS];
+
+static int phantom_status(struct phantom_device *dev, unsigned long newstat)
+{
+	pr_debug("phantom_status %lx %lx\n", dev->status, newstat);
+
+	if (!(dev->status & PHB_RUNNING) && (newstat & PHB_RUNNING)) {
+		iowrite32(PHN_CTL_IRQ, dev->iaddr + PHN_CONTROL);
+		iowrite32(0x43, dev->caddr + PHN_IRQCTL);
+	} else if ((dev->status & PHB_RUNNING) && !(newstat & PHB_RUNNING))
+		iowrite32(0, dev->caddr + PHN_IRQCTL);
+
+	dev->status = newstat;
+
+	return 0;
+}
+
+/*
+ * File ops
+ */
+
+static int phantom_ioctl(struct inode *inode, struct file *file, u_int cmd,
+	u_long arg)
+{
+	struct phantom_device *dev = file->private_data;
+	struct phm_regs rs;
+	struct phm_reg r;
+	void __user *argp = (void __user *)arg;
+	unsigned int i;
+
+	if (_IOC_TYPE(cmd) != PH_IOC_MAGIC ||
+			_IOC_NR(cmd) > PH_IOC_MAXNR)
+		return -ENOTTY;
+
+	switch (cmd) {
+	case PHN_SET_REG:
+		if (copy_from_user(&r, argp, sizeof(r)))
+			return -EFAULT;
+
+		if (r.reg > 7)
+			return -EINVAL;
+
+		if (r.reg == PHN_CONTROL && (r.value & PHN_CTL_IRQ) &&
+				phantom_status(dev, dev->status | PHB_RUNNING))
+			return -ENODEV;
+
+		pr_debug("phantom: writing %x to %u\n", r.value, r.reg);
+		iowrite32(r.value, dev->iaddr + r.reg);
+
+		if (r.reg == PHN_CONTROL && !(r.value & PHN_CTL_IRQ))
+			phantom_status(dev, dev->status & ~PHB_RUNNING);
+		break;
+	case PHN_SET_REGS:
+		if (copy_from_user(&rs, argp, sizeof(rs)))
+			return -EFAULT;
+
+		pr_debug("phantom: SRS %u regs %x\n", rs.count, rs.mask);
+		for (i = 0; i < min(rs.count, 8U); i++)
+			if ((1 << i) & rs.mask)
+				iowrite32(rs.values[i], dev->oaddr + i);
+		break;
+	case PHN_GET_REG:
+		if (copy_from_user(&r, argp, sizeof(r)))
+			return -EFAULT;
+
+		if (r.reg > 7)
+			return -EINVAL;
+
+		r.value = ioread32(dev->iaddr + r.reg);
+
+		if (copy_to_user(argp, &r, sizeof(r)))
+			return -EFAULT;
+		break;
+	case PHN_GET_REGS:
+		if (copy_from_user(&rs, argp, sizeof(rs)))
+			return -EFAULT;
+
+		pr_debug("phantom: GRS %u regs %x\n", rs.count, rs.mask);
+		for (i = 0; i < min(rs.count, 8U); i++)
+			if ((1 << i) & rs.mask)
+				rs.values[i] = ioread32(dev->iaddr + i);
+
+		if (copy_to_user(argp, &rs, sizeof(rs)))
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
+	pr_debug("phantom_poll: %u\n", dev->counter);
+	poll_wait(file, &dev->wait, wait);
+	if (dev->counter) {
+		mask = POLLIN | POLLRDNORM;
+		dev->counter--;
+	} else if ((dev->status & PHB_RUNNING) == 0)
+		mask = POLLIN | POLLRDNORM | POLLERR;
+	pr_debug("phantom_poll end: %x/%u\n", mask, dev->counter);
+
+	return mask;
+}
+
+static struct file_operations phantom_file_ops = {
+	.open = phantom_open,
+	.release = phantom_release,
+	.ioctl = phantom_ioctl,
+	.poll = phantom_poll,
+};
+
+static irqreturn_t phantom_isr(int irq, void *data)
+{
+	struct phantom_device *dev = data;
+
+	if (!(ioread32(dev->iaddr + PHN_CONTROL) & PHN_CTL_IRQ))
+		return IRQ_NONE;
+
+	iowrite32(0, dev->iaddr);
+	iowrite32(0xc0, dev->iaddr);
+
+	dev->counter++;
+	wake_up_interruptible(&dev->wait);
+
+	return IRQ_HANDLED;
+}
+
+/*
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
+		goto err_dis;
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
+	pht->caddr = pci_iomap(pdev, 0, 0);
+	if (pht->caddr == NULL) {
+		dev_err(&pdev->dev, "can't remap conf space\n");
+		goto err_fr;
+	}
+	pht->iaddr = pci_iomap(pdev, 2, 0);
+	if (pht->iaddr == NULL) {
+		dev_err(&pdev->dev, "can't remap input space\n");
+		goto err_unmc;
+	}
+	pht->oaddr = pci_iomap(pdev, 3, 0);
+	if (pht->oaddr == NULL) {
+		dev_err(&pdev->dev, "can't remap output space\n");
+		goto err_unmi;
+	}
+
+	mutex_init(&pht->open_lock);
+	init_waitqueue_head(&pht->wait);
+	cdev_init(&pht->cdev, &phantom_file_ops);
+	pht->cdev.owner = THIS_MODULE;
+
+	iowrite32(0, pht->caddr + PHN_IRQCTL);
+	retval = request_irq(pdev->irq, phantom_isr,
+			IRQF_SHARED | IRQF_DISABLED, "phantom", pht);
+	if (retval) {
+		dev_err(&pdev->dev, "can't establish ISR\n");
+		goto err_unmo;
+	}
+
+	retval = cdev_add(&pht->cdev, MKDEV(phantom_major, minor), 1);
+	if (retval) {
+		dev_err(&pdev->dev, "chardev registration failed\n");
+		goto err_irq;
+	}
+
+	if (IS_ERR(device_create(phantom_class, &pdev->dev, MKDEV(phantom_major,
+			minor), "phantom%u", minor)))
+		dev_err(&pdev->dev, "can't create device\n");
+
+	pci_set_drvdata(pdev, pht);
+
+	return 0;
+err_irq:
+	free_irq(pdev->irq, pht);
+err_unmo:
+	pci_iounmap(pdev, pht->oaddr);
+err_unmi:
+	pci_iounmap(pdev, pht->iaddr);
+err_unmc:
+	pci_iounmap(pdev, pht->caddr);
+err_fr:
+	kfree(pht);
+err_reg:
+	pci_release_regions(pdev);
+err_null:
+	phantom_devices[minor] = 0;
+err_dis:
+	pci_disable_device(pdev);
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
+	iowrite32(0, pht->caddr + PHN_IRQCTL);
+	free_irq(pdev->irq, pht);
+
+	pci_iounmap(pdev, pht->oaddr);
+	pci_iounmap(pdev, pht->iaddr);
+	pci_iounmap(pdev, pht->caddr);
+
+	kfree(pht);
+
+	pci_release_regions(pdev);
+
+	phantom_devices[minor] = 0;
+
+	pci_disable_device(pdev);
+}
+
+#ifdef CONFIG_PM
+static int phantom_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct phantom_device *dev = pci_get_drvdata(pdev);
+
+	iowrite32(0, dev->caddr + PHN_IRQCTL);
+
+	return 0;
+}
+
+static int phantom_resume(struct pci_dev *pdev)
+{
+	struct phantom_device *dev = pci_get_drvdata(pdev);
+
+	iowrite32(0, dev->caddr + PHN_IRQCTL);
+
+	return 0;
+}
+#endif
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
+#ifdef CONFIG_PM
+	.suspend = phantom_suspend,
+	.resume = phantom_resume
+#endif
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
+	pr_debug("phantom: module successfully removed\n");
+}
+
+module_init(phantom_init);
+module_exit(phantom_exit);
+
+MODULE_AUTHOR("Jiri Slaby <jirislaby@gmail.com>");
+MODULE_DESCRIPTION("Sensable Phantom driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(PHANTOM_VERSION);
diff --git a/include/linux/phantom.h b/include/linux/phantom.h
new file mode 100644
index 0000000..d3ebbfa
--- /dev/null
+++ b/include/linux/phantom.h
@@ -0,0 +1,42 @@
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
+#include <asm/types.h>
+
+/* PHN_(G/S)ET_REG param */
+struct phm_reg {
+	__u32 reg;
+	__u32 value;
+};
+
+/* PHN_(G/S)ET_REGS param */
+struct phm_regs {
+	__u32 count;
+	__u32 mask;
+	__u32 values[8];
+};
+
+#define PH_IOC_MAGIC		'p'
+#define PHN_GET_REG		_IOWR(PH_IOC_MAGIC, 0, struct phm_reg *)
+#define PHN_SET_REG		_IOW (PH_IOC_MAGIC, 1, struct phm_reg *)
+#define PHN_GET_REGS		_IOWR(PH_IOC_MAGIC, 2, struct phm_regs *)
+#define PHN_SET_REGS		_IOW (PH_IOC_MAGIC, 3, struct phm_regs *)
+#define PH_IOC_MAXNR		3
+
+#define PHN_CONTROL		0x6     /* control byte in iaddr space */
+#define PHN_CTL_AMP		0x1     /*   switch after torques change */
+#define PHN_CTL_BUT		0x2     /*   is button switched */
+#define PHN_CTL_IRQ		0x10    /*   is irq enabled */
+
+#define PHN_ZERO_FORCE		2048	/* zero torque on motor */
+
+#endif
