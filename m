Return-Path: <linux-kernel-owner+w=401wt.eu-S1752266AbZHMKWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbZHMKWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZHMKWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:22:30 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:44720 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbZHMKW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:22:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=kGfbQNk1Gj2blpPwRNP0A0r9QO1iWTXiXRubOrqXiGsBH7jT0myQAEccghGcmRzHR3
         AAyGZRgYQ5GYXf7G/OoVWbG60DLMUIXSqX5kaVKZFB+fQs39dUPPcyA1sP6kKytYDZTm
         jrvoiNUBMqB1ybVgUwhmizIGsFDoz7EiAHT+Q=
MIME-Version: 1.0
Date: Thu, 13 Aug 2009 12:17:01 +0200
Message-ID: <8447d6730908130317j2ac1ae07s1ecbd5bdd835f8b8@mail.gmail.com>
Subject: [PATCH] Jtag bitbang driver proposal
From: Davide Rizzo <elpa.rizzo@gmail.com>
To: linux-kernel@vger.kernel.org, rubini@vision.unipv.it
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe this is not the right place / list to propose this, I searched
for misc drivers in maintainer list. Could you otherwise address me ?
Grazie Alessandro.

Generic bitbang driver to drive jtag chains

Signed-off-by: Davide Rizzo <elpa.rizzo@gmail.com>
---
diff -urNp linux-2.6.30.4/drivers/misc/jtag.c
linux-2.6.30.4.elpa/drivers/misc/jtag.c
--- linux-2.6.30.4/drivers/misc/jtag.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.30.4.elpa/drivers/misc/jtag.c	2009-08-13 09:33:02.000000000 +0200
@@ -0,0 +1,454 @@
+/*
+ * drivers/misc/jtag.c - More infos in include/linux/jtag.h
+ *
+ * Written Aug 2009 by Davide Rizzo <elpa.rizzo@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/autoconf.h>
+
+#include <linux/cdev.h>
+#include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/platform_device.h>
+#include <linux/jtag.h>
+#include <mach/gpio.h>
+
+#define VERSION_MAJ 1
+#define VERSION_MIN 0
+
+/* Max devices in the jtag chain */
+#define MAX_DEVICES 16
+
+static LIST_HEAD(device_list);
+static DEFINE_MUTEX(device_list_lock);
+
+struct jtag_info {
+	struct jtag_platdata *pdata;
+	struct cdev cdev;
+	dev_t devt;
+	unsigned int devices; /* Number of devices found in the jtag chain */
+	int users;
+	struct mutex lock;
+	struct list_head device_entry;
+	/* Instruction register length of every device in the chain */
+	unsigned int ir_len[];	/* [devices] */
+	/* unsigned long id[devices]; */
+};
+
+static const unsigned long bypass = 0xFFFFFFFF;
+
+static void pulseTMS0(const struct jtag_platdata *pdata)
+{
+	gpio_set_value(pdata->pin_tms, 0);
+	gpio_set_value(pdata->pin_tclk, 0);
+	gpio_set_value(pdata->pin_tclk, 1);
+}
+
+static void pulseTMS1(const struct jtag_platdata *pdata)
+{
+	gpio_set_value(pdata->pin_tms, 1);
+	gpio_set_value(pdata->pin_tclk, 0);
+	gpio_set_value(pdata->pin_tclk, 1);
+}
+
+static void jtag_reset(const struct jtag_platdata *pdata)
+{
+	gpio_set_value(pdata->pin_tms, 1);
+	gpio_set_value(pdata->pin_tclk, 0);
+	gpio_set_value(pdata->pin_tclk, 1);
+	gpio_set_value(pdata->pin_tclk, 0);
+	gpio_set_value(pdata->pin_tclk, 1);
+	gpio_set_value(pdata->pin_tclk, 0);
+	gpio_set_value(pdata->pin_tclk, 1);
+	gpio_set_value(pdata->pin_tclk, 0);
+	gpio_set_value(pdata->pin_tclk, 1);
+	gpio_set_value(pdata->pin_tclk, 0);
+	gpio_set_value(pdata->pin_tclk, 1);
+}
+
+static void jtag_output(const struct jtag_platdata *pdata,
+	const unsigned long *data, unsigned int bitlen, int notlast)
+{
+	unsigned int a;
+	unsigned long mask;
+	gpio_set_value(pdata->pin_tms, 0);
+	while (bitlen > 0) {
+		for (a = *data++, mask = 0x00000001; mask != 0 && bitlen > 0;
+		      mask <<= 1, bitlen--) {
+			gpio_set_value(pdata->pin_tdo, (a & mask) ? 1 : 0);
+			if ((bitlen == 1) && !notlast)
+				gpio_set_value(pdata->pin_tms, 1);
+			gpio_set_value(pdata->pin_tclk, 0);
+			gpio_set_value(pdata->pin_tclk, 1);
+		}
+	}
+}
+
+static int jtag_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
+	unsigned long arg)
+{
+	int ret = 0;
+	struct jtag_info *info = (struct jtag_info *)filp->private_data;
+	int devices = info->devices;
+	struct jtag_cmd *jcmd = (struct jtag_cmd *)arg;
+	struct jtag_platdata *pdata = info->pdata;
+
+	mutex_lock(&info->lock);
+
+	switch (cmd) {
+
+	case JTAG_GET_DEVICES:
+		/* Returns how many devices found in the chain */
+		ret = info->devices;
+		break;
+
+	case JTAG_GET_ID:
+		/* Returns ID register of selected device */
+		if ((((struct jtag_rd_id *)arg)->device < 0) ||
+			(((struct jtag_rd_id *)arg)->device >= devices)) {
+			ret = -EINVAL;
+			break;
+		}
+		jtag_reset(pdata);
+		pulseTMS0(pdata);
+		pulseTMS1(pdata);
+		pulseTMS0(pdata);
+		pulseTMS0(pdata);
+		while (devices-- > 0) {
+			unsigned long id = 0;
+			pulseTMS0(pdata);
+			if (gpio_get_value(pdata->pin_tdi)) {
+				unsigned long mask;
+				for (id = 1, mask = 0x00000002; (mask != 0);
+				      mask <<= 1) {
+					pulseTMS0(pdata);
+					if (gpio_get_value(pdata->pin_tdi))
+						id |= mask;
+				}
+			}
+			if (devices == ((struct jtag_rd_id *)arg)->device) {
+				((struct jtag_rd_id *)arg)->id = id;
+				ret = 0;
+				break;
+			}
+		}
+		jtag_reset(pdata);
+		break;
+
+	case JTAG_SET_IR_LENGTH:
+		/* Sets up IR length of one device */
+		if ((jcmd->device >= 0) && (jcmd->device < devices))
+			info->ir_len[jcmd->device] = jcmd->bitlen;
+		else
+			ret = -EINVAL;
+		break;
+
+	case JTAG_RESET:
+		/* Resets all JTAG states */
+		jtag_reset(pdata);
+		break;
+
+	case JTAG_IR_WR:
+		/* Writes Instruction Register
+		If device == -1 writes same Instruction Register in all devices
+		If device >= 0 writes Instruction Register in selected device
+		 and loads BYPASS instruction in all others */
+		if ((jcmd->device < -1) || (jcmd->device >= devices)) {
+			ret = -EINVAL;
+			break;
+		}
+		pulseTMS0(pdata);
+		pulseTMS1(pdata);
+		pulseTMS1(pdata);
+		pulseTMS0(pdata);
+		pulseTMS0(pdata);
+		while (devices-- > 0) {
+			if ((jcmd->device == -1) || (jcmd->device == devices))
+				/* Loads desired instruction */
+				jtag_output(pdata, jcmd->data,
+					info->ir_len[devices], devices);
+			else
+				/* Loads BYPASS instruction */
+				jtag_output(pdata, &bypass,
+					info->ir_len[devices], devices);
+		}
+		pulseTMS1(pdata);
+		pulseTMS0(pdata);
+		break;
+
+	case JTAG_DR_WR:
+		/* Writes Data Register of all devices
+		If device == -1 writes same Data Register in all devices
+		If device >= 0 writes Data Register in selected device
+		 and loads BYPASS instruction in all others */
+		if ((jcmd->device < -1) || (jcmd->device >= devices)) {
+			ret = -EINVAL;
+			break;
+		}
+		pulseTMS0(pdata);
+		pulseTMS1(pdata);
+		pulseTMS0(pdata);
+		pulseTMS0(pdata);
+		while (devices-- > 0) {
+			if ((jcmd->device == -1) || (devices == jcmd->device))
+				/* Loads desired data */
+				jtag_output(pdata, jcmd->data, jcmd->bitlen,
+					devices);
+			else
+				/* Loads 1 dummy bit in BYPASS data register */
+				jtag_output(pdata, &bypass, 1, devices);
+		}
+		pulseTMS1(pdata);
+		pulseTMS0(pdata);
+		break;
+
+	case JTAG_DR_RD:
+		/* Reads data register of selected device */
+		if ((jcmd->device < 0) || (jcmd->device >= devices))
+			ret = -EINVAL;
+		else {
+			unsigned long mask;
+			int bitlen = jcmd->bitlen;
+			unsigned long *data = jcmd->data;
+			pulseTMS0(pdata);
+			pulseTMS1(pdata);
+			pulseTMS0(pdata);
+			pulseTMS0(pdata);
+			devices -= (jcmd->device + 1);
+			while (devices-- > 0)
+				pulseTMS0(pdata);
+			while (bitlen > 0) {
+				for (*data = 0, mask = 0x00000001;
+				      (mask != 0) && (bitlen > 0);
+				      mask <<= 1, bitlen--) {
+					if (bitlen == 1)
+						pulseTMS1(pdata);
+					else
+						pulseTMS0(pdata);
+					if (gpio_get_value(pdata->pin_tdi))
+						*data |= mask;
+				}
+				data++;
+			}
+			pulseTMS1(pdata);
+			pulseTMS0(pdata);
+		}
+		break;
+
+	case JTAG_CLK:
+		/* Generates arg clock pulses */
+		gpio_set_value(pdata->pin_tms, 0);
+		while (arg--) {
+			gpio_set_value(pdata->pin_tclk, 0);
+			gpio_set_value(pdata->pin_tclk, 1);
+		}
+		break;
+
+	default:
+		ret = -EFAULT;
+	}
+
+	mutex_unlock(&info->lock);
+
+	return ret;
+}
+
+static int jtag_open(struct inode *inode, struct file *filp)
+{
+	int status = -ENXIO;
+	struct jtag_info *info;
+
+	mutex_lock(&device_list_lock);
+
+	list_for_each_entry(info, &device_list, device_entry) {
+		if (info->devt == inode->i_rdev) {
+			status = 0;
+			break;
+		}
+	}
+	if (status == 0) {
+		info->users++;
+		filp->private_data = info;
+		nonseekable_open(inode, filp);
+	}
+
+	mutex_unlock(&device_list_lock);
+	return status;
+}
+
+static int jtag_release(struct inode *inode, struct file *filp)
+{
+	mutex_lock(&device_list_lock);
+	((struct jtag_info *)filp->private_data)->users--;
+	filp->private_data = NULL;
+	mutex_unlock(&device_list_lock);
+	return 0;
+}
+
+static const struct file_operations jtag_operations = {
+	.owner = THIS_MODULE,
+	.ioctl = jtag_ioctl,
+	.open = jtag_open,
+	.release = jtag_release,
+};
+
+static struct class_attribute jtag_class_attrs[] = {
+	__ATTR_NULL,
+};
+
+static struct class jtag_class = {
+	.name =		JTAG_NAME,
+	.owner =	THIS_MODULE,
+	.class_attrs =	jtag_class_attrs,
+};
+
+static int jtag_probe(struct platform_device *pdev)
+{
+	int i, ret;
+	struct device *dev;
+	struct jtag_info *info;
+	struct jtag_platdata *pdata = pdev->dev.platform_data;
+
+	/* Setup gpio pins */
+	gpio_request(pdata->pin_tms, "tms");
+	gpio_request(pdata->pin_tclk, "tclk");
+	gpio_request(pdata->pin_tdo, "tdo");
+	gpio_request(pdata->pin_tdi, "tdi");
+	gpio_direction_output(pdata->pin_tms, 0);
+	gpio_direction_output(pdata->pin_tclk, 1);
+	gpio_direction_output(pdata->pin_tdo, 0);
+	gpio_direction_input(pdata->pin_tdi);
+	if (pdata->use_pin_trst) {
+		/* Keep fixed at 1 because some devices in the chain could
+			not use it, to reset chain use jtag_reset() */
+		gpio_request(pdata->pin_trst, "trst");
+		gpio_direction_output(pdata->pin_trst, 1);
+	}
+
+	/* Find how many devices in chain */
+	jtag_reset(pdata);
+	pulseTMS0(pdata);
+	pulseTMS1(pdata);
+	pulseTMS1(pdata);
+	pulseTMS0(pdata);
+	pulseTMS0(pdata);
+	gpio_set_value(pdata->pin_tdo, 1);
+	/* Fills all IR with bypass instruction */
+	for (i = 0; i < 32 * MAX_DEVICES; i++)
+		pulseTMS0(pdata);
+	pulseTMS1(pdata);
+	pulseTMS1(pdata);
+	pulseTMS1(pdata);
+	pulseTMS0(pdata);
+	pulseTMS0(pdata);
+	gpio_set_value(pdata->pin_tdo, 0);
+	/* Fills all 1-bit bypass register with 0 */
+	for (i = 0; i < MAX_DEVICES + 2; i++)
+		pulseTMS0(pdata);
+	gpio_set_value(pdata->pin_tdo, 1);
+	/* Counts chain's bit length */
+	for (i = 0; i < MAX_DEVICES + 1; i++) {
+		pulseTMS0(pdata);
+		if (gpio_get_value(pdata->pin_tdi))
+			break;
+	}
+	dev_notice(&pdev->dev, "%d devices found in chain\n", i);
+
+	/* Allocate structure with chain specific infos */
+	info = kzalloc(sizeof(struct jtag_info) +
+		sizeof(info->ir_len[0]) * i, GFP_KERNEL);
+	if (!info) {
+		dev_err(&pdev->dev, "out of kernel memory\n");
+		return -ENOMEM;
+	}
+	info->devices = i;
+	mutex_init(&info->lock);
+	INIT_LIST_HEAD(&info->device_entry);
+	list_add(&info->device_entry, &device_list);
+	info->pdata = pdata;
+	platform_set_drvdata(pdev, info);
+	ret = alloc_chrdev_region(&info->devt, 0, 1, JTAG_NAME);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Couldn't alloc_chrdev_region\n");
+		goto fail_chrdev;
+	}
+	cdev_init(&info->cdev, &jtag_operations);
+	if (cdev_add(&info->cdev, info->devt, 1)) {
+		dev_err(&pdev->dev, "Unable to register driver\n");
+		ret = -EIO;
+		goto fail_cdev_add;
+	}
+	dev = device_create(&jtag_class, NULL, info->devt, NULL, JTAG_NAME);
+	if (IS_ERR(dev)) {
+		ret = PTR_ERR(dev);
+		goto fail_dev_create;
+	}
+	return 0;
+
+fail_dev_create:
+	cdev_del(&info->cdev);
+fail_cdev_add:
+	unregister_chrdev_region(info->devt, 1);
+fail_chrdev:
+	platform_set_drvdata(pdev, NULL);
+	kfree(info);
+	return ret;
+}
+
+static int jtag_remove(struct platform_device *pdev)
+{
+	struct jtag_info *info = (struct jtag_info *)platform_get_drvdata(pdev);
+	mutex_lock(&device_list_lock);
+	list_del(&info->device_entry);
+	device_destroy(&jtag_class, info->devt);
+	cdev_del(&info->cdev);
+	unregister_chrdev_region(info->devt, 1);
+	platform_set_drvdata(pdev, NULL);
+	mutex_unlock(&device_list_lock);
+	kfree(info);
+	dev_notice(&pdev->dev, "Device removed\n");
+	return 0;
+}
+
+static struct platform_driver jtag_driver = {
+	.probe = jtag_probe,
+	.remove = jtag_remove,
+	.driver = {
+		.name = JTAG_NAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+int __devinit jtag_module_init(void)
+{
+	class_register(&jtag_class);
+	platform_driver_register(&jtag_driver);
+	return 0;
+}
+
+void __exit jtag_module_exit(void)
+{
+	platform_driver_unregister(&jtag_driver);
+	class_unregister(&jtag_class);
+}
+
+module_init(jtag_module_init);
+module_exit(jtag_module_exit);
+
+MODULE_AUTHOR("Davide Rizzo <elpa.rizzo@gmail.com>");
+MODULE_DESCRIPTION("Jtag bitbang driver");
+MODULE_LICENSE("GPL");
diff -urNp linux-2.6.30.4/drivers/misc/Kconfig
linux-2.6.30.4.elpa/drivers/misc/Kconfig
--- linux-2.6.30.4/drivers/misc/Kconfig	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30.4.elpa/drivers/misc/Kconfig	2009-08-08 16:43:30.000000000 +0200
@@ -236,4 +236,16 @@ config ISL29003
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"

+config JTAG
+	tristate "Jtag Bitbang driver"
+	depends on GPIOLIB
+	default n
+	---help---
+	Controls jtag chains connected to I/O pins
+
+	This driver can also be built as a module.  If so, the module
+	  will be called jtag.
+
+	If unsure, say N.
+
 endif # MISC_DEVICES
diff -urNp linux-2.6.30.4/drivers/misc/Makefile
linux-2.6.30.4.elpa/drivers/misc/Makefile
--- linux-2.6.30.4/drivers/misc/Makefile	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30.4.elpa/drivers/misc/Makefile	2009-08-08
16:37:07.000000000 +0200
@@ -20,4 +20,5 @@ obj-$(CONFIG_SGI_GRU)		+= sgi-gru/
 obj-$(CONFIG_HP_ILO)		+= hpilo.o
 obj-$(CONFIG_ISL29003)		+= isl29003.o
 obj-$(CONFIG_C2PORT)		+= c2port/
+obj-$(CONFIG_JTAG) += jtag.o
 obj-y				+= eeprom/
diff -urNp linux-2.6.30.4/include/linux/jtag.h
linux-2.6.30.4.elpa/include/linux/jtag.h
--- linux-2.6.30.4/include/linux/jtag.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.30.4.elpa/include/linux/jtag.h	2009-08-13 09:33:18.000000000 +0200
@@ -0,0 +1,106 @@
+/*
+ * include/linux/jtag.h
+ *
+ * Written Aug 2009 by Davide Rizzo <elpa.rizzo@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+/*
+ * This driver manages one or more jtag chains controlled by host pins.
+ * Jtag chains must be defined during setup using jtag_platdata structs.
+ * All operations must be done from user programs using ioctls to /dev/jtag
+ * Typical operation sequence is:
+ * - open() the device (normally /dev/jtag)
+ * - ioctl JTAG_GET_DEVICES reads how many devices in the chain
+ * (repeat for each chip in the chain)
+ * - ioctl JTAG_GET_ID identifies the chip
+ * - ioctl JTAG_SET_IR_LENGTH sets the instruction register length
+ * Before accessing the data registers, instruction registers' lenghtes
+ *  MUST be programmed for all chips.
+ * After this initialization, you can execute JTAG_IR_WR, JTAG_DR_RD,
JTAG_DR_WR
+ *  commands in any sequence.
+ */
+
+#ifndef __JTAG_H__
+#define __JTAG_H__
+
+#ifdef __KERNEL__
+/* Controller's pin_tdi must be connected to last device's pin_tdo */
+/* Controller's pin_tdo must be connected to first device's pin_tdi */
+struct jtag_platdata {
+	unsigned int pin_tclk;
+	unsigned int pin_tms;
+	unsigned int pin_tdi;
+	unsigned int pin_tdo;
+	unsigned int pin_trst;
+	int use_pin_trst;
+};
+#endif /* __KERNEL__ */
+
+/* ioctl commands */
+
+/* Resets jtag chain status, arg is ignored */
+#define JTAG_RESET         0
+
+/* Returns the number of devices in the jtag chain, arg is ignored. */
+#define JTAG_GET_DEVICES   1
+
+/* arg must point to a jtag_rd_id structure.
+   Fills up the id field with ID of selected device */
+#define JTAG_GET_ID        2
+
+/* arg must point to a struct jtag_cmd.
+   Programs the Instruction Register length of specified device at
bitlen value.
+   *data is ignored. */
+#define JTAG_SET_IR_LENGTH 3
+
+/* arg must point to a struct jtag_cmd.
+   Writes *data in the Instruction Register of selected device, and BYPASS
+    instruction into Instruction Registers of all other devices in the chain.
+   If device == -1, the Instruction Registers of all devices are programmed
+    to the same value.
+   bitlen is always ignored, before using this command you have to program all
+    Instruction Register's lengthes with JTAG_SET_IR_LENGTH command. */
+#define JTAG_IR_WR         4
+
+/* arg must point to a struct jtag_cmd.
+   Reads data register of selected device, with length bitlen */
+#define JTAG_DR_RD         5
+
+/* arg must point to a struct jtag_cmd.
+   Writes data register of selected device, with length bitlen.
+   If device == -1, writes same data on all devices. */
+#define JTAG_DR_WR         6
+
+/* Generates arg pulses on TCLK pin */
+#define JTAG_CLK           7
+
+#define JTAG_NAME "jtag"
+
+/* structures used for passing arguments to ioctl */
+
+struct jtag_rd_id {
+	int device; /* Device in the chain */
+	unsigned long id;
+};
+
+struct jtag_cmd {
+	int device; /* Device in the chain (-1 = all devices) */
+	unsigned int bitlen; /* Bit length of the register to be transfered */
+	unsigned long *data; /* Data to be transfered */
+};
+
+#endif /* __JTAG_H__ */
