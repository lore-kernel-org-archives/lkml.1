Return-Path: <linux-kernel-owner+w=401wt.eu-S1756333AbYIIELX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbYIIELX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 00:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbYIIEIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 00:08:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42576 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbYIIEIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 00:08:00 -0400
From: Jarod Wilson <jwilson@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jarod Wilson <jwilson@redhat.com>, Jarod Wilson <jarod@redhat.com>,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>
Subject: [PATCH 08/18] lirc driver for the Soundgraph IMON IR Receivers
Date: Tue,  9 Sep 2008 00:05:53 -0400
Message-Id: <1220933164-10160-9-git-send-email-jwilson@redhat.com>
In-Reply-To: <1220933164-10160-8-git-send-email-jwilson@redhat.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
 <1220933164-10160-2-git-send-email-jwilson@redhat.com>
 <1220933164-10160-3-git-send-email-jwilson@redhat.com>
 <1220933164-10160-4-git-send-email-jwilson@redhat.com>
 <1220933164-10160-5-git-send-email-jwilson@redhat.com>
 <1220933164-10160-6-git-send-email-jwilson@redhat.com>
 <1220933164-10160-7-git-send-email-jwilson@redhat.com>
 <1220933164-10160-8-git-send-email-jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Successfully tested earlier tonight, see:
	https://bugzilla.redhat.com/show_bug.cgi?id=459523

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Janne Grunau <j@jannau.net>
CC: Christoph Bartelmus <lirc@bartelmus.de>
Tested-by: Tom Horsley <tom.horsley@att.net>
---
 drivers/input/lirc/Kconfig     |    7 +
 drivers/input/lirc/Makefile    |    1 +
 drivers/input/lirc/lirc_imon.c | 1280 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1288 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/lirc/lirc_imon.c

diff --git a/drivers/input/lirc/Kconfig b/drivers/input/lirc/Kconfig
index 67802fe..7e37b2d 100644
--- a/drivers/input/lirc/Kconfig
+++ b/drivers/input/lirc/Kconfig
@@ -40,6 +40,13 @@ config LIRC_I2C
 	  Driver for I2C-based IR receivers, such as those commonly
 	  found onboard Hauppauge PVR-150/250/350 video capture cards
 
+config LIRC_IMON
+	tristate "Soundgraph IMON Receiver"
+	default n
+	depends on LIRC_DEV
+	help
+	  Driver for the Soundgraph IMON IR Receiver
+
 config LIRC_MCEUSB
 	tristate "Microsoft Media Center Ed. Receiver, v1"
 	default n
diff --git a/drivers/input/lirc/Makefile b/drivers/input/lirc/Makefile
index 86df97d..f39fa06 100644
--- a/drivers/input/lirc/Makefile
+++ b/drivers/input/lirc/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_LIRC_DEV)		+= lirc_dev.o
 obj-$(CONFIG_LIRC_ATIUSB)	+= lirc_atiusb.o
 obj-$(CONFIG_LIRC_CMDIR)	+= lirc_cmdir.o
 obj-$(CONFIG_LIRC_I2C)		+= lirc_i2c.o
+obj-$(CONFIG_LIRC_IMON)		+= lirc_imon.o
 obj-$(CONFIG_LIRC_MCEUSB)	+= lirc_mceusb.o
 obj-$(CONFIG_LIRC_MCEUSB2)	+= lirc_mceusb2.o
 obj-$(CONFIG_LIRC_SERIAL)	+= lirc_serial.o
diff --git a/drivers/input/lirc/lirc_imon.c b/drivers/input/lirc/lirc_imon.c
new file mode 100644
index 0000000..bdfd953
--- /dev/null
+++ b/drivers/input/lirc/lirc_imon.c
@@ -0,0 +1,1280 @@
+/*
+ *   lirc_imon.c:  LIRC plugin/VFD driver for Ahanix/Soundgraph IMON IR/VFD
+ *
+ *   Version 0.3
+ *		Supports newer iMON models that send decoded IR signals.
+ *			This includes the iMON PAD model.
+ *		Removed module option for vfd_proto_6p. This driver supports
+ *			multiple iMON devices so it is meaningless to have
+ *			a global option to set protocol variants.
+ *
+ *   Version 0.2 beta 2 [January 31, 2005]
+ *		USB disconnect/reconnect no longer causes problems for lircd
+ *
+ *   Version 0.2 beta 1 [January 29, 2005]
+ *		Added support for original iMON receiver(ext USB)
+ *
+ *   Version 0.2 alpha 2 [January 24, 2005]
+ *		Added support for VFDs with 6-packet protocol
+ *
+ *   Version 0.2 alpha 1 [January 23, 2005]
+ *		Added support for 2.6 kernels
+ *		Reworked disconnect handling
+ *		Incorporated Changwoo Ryu's algorithm
+ *
+ *   Version 0.1 alpha 1[July 5, 2004]
+ *
+ *   Copyright(C) 2004  Venky Raju(dev@venky.ws)
+ *
+ *   lirc_imon is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+#include <linux/version.h>
+#include <linux/autoconf.h>
+
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/usb.h>
+
+#include "lirc.h"
+#include "lirc_dev.h"
+
+
+#define MOD_AUTHOR	"Venky Raju <dev@venky.ws>"
+#define MOD_DESC	"Driver for Soundgraph iMON MultiMedia IR/VFD"
+#define MOD_NAME	"lirc_imon"
+#define MOD_VERSION	"0.3"
+
+#define VFD_MINOR_BASE	144	/* Same as LCD */
+#define DEVICE_NAME	"lcd%d"
+
+#define BUF_CHUNK_SIZE	4
+#define BUF_SIZE	128
+
+#define BIT_DURATION	250	/* each bit received is 250us */
+
+#define SUCCESS		0
+#define	TRUE		1
+#define FALSE		0
+
+
+/* ------------------------------------------------------------
+ *		     P R O T O T Y P E S
+ * ------------------------------------------------------------
+ */
+
+/* USB Callback prototypes */
+static int imon_probe(struct usb_interface *interface,
+		      const struct usb_device_id *id);
+static void imon_disconnect(struct usb_interface *interface);
+static void usb_rx_callback(struct urb *urb);
+static void usb_tx_callback(struct urb *urb);
+
+/* VFD file_operations function prototypes */
+static int vfd_open(struct inode *inode, struct file *file);
+static int vfd_close(struct inode *inode, struct file *file);
+static ssize_t vfd_write(struct file *file, const char *buf,
+			 size_t n_bytes, loff_t *pos);
+
+/* LCD file_operations override function prototypes */
+static ssize_t lcd_write(struct file *file, const char *buf,
+			 size_t n_bytes, loff_t *pos);
+
+/* LIRC plugin function prototypes */
+static int ir_open(void *data);
+static void ir_close(void *data);
+
+/* Driver init/exit prototypes */
+static int __init imon_init(void);
+static void __exit imon_exit(void);
+
+/* ------------------------------------------------------------
+ *		     G L O B A L S
+ * ------------------------------------------------------------
+ */
+
+struct imon_context {
+	struct usb_device *dev;
+	int vfd_supported;		/* not all controllers do */
+	int vfd_isopen;			/* VFD port has been opened */
+	int ir_isopen;			/* IR port open	*/
+	int ir_isassociating;		/* IR port open for association */
+	int dev_present;		/* USB device presence */
+	struct mutex lock;		/* to lock this object */
+	wait_queue_head_t remove_ok;	/* For unexpected USB disconnects */
+
+	int vfd_proto_6p;		/* VFD requires 6th packet */
+	int ir_onboard_decode;		/* IR signals decoded onboard */
+
+	struct lirc_plugin *plugin;
+	struct usb_endpoint_descriptor *rx_endpoint;
+	struct usb_endpoint_descriptor *tx_endpoint;
+	struct urb *rx_urb;
+	struct urb *tx_urb;
+	int tx_control;
+	unsigned char usb_rx_buf[8];
+	unsigned char usb_tx_buf[8];
+
+	struct rx_data {
+		int count;		/* length of 0 or 1 sequence */
+		int prev_bit;		/* logic level of sequence */
+		int initial_space;	/* initial space flag */
+	} rx;
+
+	struct tx_t {
+		unsigned char data_buf[35];	/* user data buffer */
+		struct completion finished;	/* wait for write to finish */
+		atomic_t busy;			/* write in progress */
+		int status;			/* status of tx completion */
+	} tx;
+};
+
+#define LOCK_CONTEXT	mutex_lock(&context->lock)
+#define UNLOCK_CONTEXT	mutex_unlock(&context->lock)
+
+/* VFD file operations */
+static struct file_operations vfd_fops = {
+	.owner		= THIS_MODULE,
+	.open		= &vfd_open,
+	.write		= &vfd_write,
+	.release	= &vfd_close
+};
+
+/* USB Device ID for IMON USB Control Board */
+static struct usb_device_id imon_usb_id_table[] = {
+	/* IMON USB Control Board (IR & VFD) */
+	{ USB_DEVICE(0x0aa8, 0xffda) },
+	/* IMON USB Control Board (IR only) */
+	{ USB_DEVICE(0x0aa8, 0x8001) },
+	/* IMON USB Control Board (IR & VFD) */
+	{ USB_DEVICE(0x15c2, 0xffda) },
+	/* IMON USB Control Board (IR & VFD) */
+	{ USB_DEVICE(0x15c2, 0xffdc) },
+	/* IMON USB Control Board (IR & LCD) */
+	{ USB_DEVICE(0x15c2, 0x0038) },
+	/* IMON USB Control Board (ext IR only) */
+	{ USB_DEVICE(0x04e8, 0xff30) },
+	{}
+};
+
+/* Some iMON VFD models requires a 6th packet */
+static struct usb_device_id vfd_proto_6p_list[] = {
+	{ USB_DEVICE(0x15c2, 0xffda) },
+	{ USB_DEVICE(0x15c2, 0xffdc) },
+	{ USB_DEVICE(0x15c2, 0x0038) },
+	{}
+};
+static unsigned char vfd_packet6[] = {
+	0x01, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF };
+
+/* Some iMON LCD models use control endpoint */
+static struct usb_device_id lcd_control_endpoint_list[] = {
+	{ USB_DEVICE(0x15c2, 0x0038) },
+	{}
+};
+
+/* Newer iMON models decode the signal onboard */
+static struct usb_device_id ir_onboard_decode_list[] = {
+	{ USB_DEVICE(0x15c2, 0xffdc) },
+	{ USB_DEVICE(0x15c2, 0x0038) },
+	{}
+};
+
+/* USB Device data */
+static struct usb_driver imon_driver = {
+	.name		= MOD_NAME,
+	.probe		= imon_probe,
+	.disconnect	= imon_disconnect,
+	.id_table	= imon_usb_id_table,
+};
+
+static struct usb_class_driver imon_class = {
+	.name		= DEVICE_NAME,
+	.fops		= &vfd_fops,
+	.minor_base	= VFD_MINOR_BASE,
+};
+
+/* to prevent races between open() and disconnect() */
+static DECLARE_MUTEX(disconnect_sem);
+
+static int debug;
+
+/* lcd or vfd? */
+static int is_lcd;
+
+
+/* ------------------------------------------------------------
+ *		     M O D U L E   C O D E
+ * ------------------------------------------------------------
+ */
+
+MODULE_AUTHOR(MOD_AUTHOR);
+MODULE_DESCRIPTION(MOD_DESC);
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(usb, imon_usb_id_table);
+module_param(debug, int, 0);
+MODULE_PARM_DESC(debug, "Debug messages: 0=no, 1=yes(default: no)");
+module_param(is_lcd, int, 0);
+MODULE_PARM_DESC(is_lcd, "The device is an LCD: 0=no (it's a VFD), "
+		 "1=yes (default: no)");
+
+static inline void delete_context(struct imon_context *context)
+{
+	if (context->vfd_supported)
+		usb_free_urb(context->tx_urb);
+	usb_free_urb(context->rx_urb);
+	lirc_buffer_free(context->plugin->rbuf);
+	kfree(context->plugin->rbuf);
+	kfree(context->plugin);
+	kfree(context);
+
+	if (debug)
+		info("%s: context deleted", __func__);
+}
+
+static inline void deregister_from_lirc(struct imon_context *context)
+{
+	int retval;
+	int minor = context->plugin->minor;
+
+	retval = lirc_unregister_plugin(minor);
+	if (retval)
+		err("%s: unable to deregister from lirc(%d)",
+			__func__, retval);
+	else
+		info("Deregistered iMON plugin(minor:%d)", minor);
+
+}
+
+/**
+ * Called when the VFD device(e.g. /dev/usb/lcd)
+ * is opened by the application.
+ */
+static int vfd_open(struct inode *inode, struct file *file)
+{
+	struct usb_interface *interface;
+	struct imon_context *context = NULL;
+	int subminor;
+	int retval = SUCCESS;
+
+	/* prevent races with disconnect */
+	down(&disconnect_sem);
+
+	subminor = iminor(inode);
+	interface = usb_find_interface(&imon_driver, subminor);
+	if (!interface) {
+		err("%s: could not find interface for minor %d",
+		    __func__, subminor);
+		retval = -ENODEV;
+		goto exit;
+	}
+	context = usb_get_intfdata(interface);
+
+	if (!context) {
+		err("%s: no context found for minor %d",
+					__func__, subminor);
+		retval = -ENODEV;
+		goto exit;
+	}
+
+	LOCK_CONTEXT;
+
+	if (!context->vfd_supported) {
+		err("%s: VFD not supported by device", __func__);
+		retval = -ENODEV;
+	} else if (context->vfd_isopen) {
+		err("%s: VFD port is already open", __func__);
+		retval = -EBUSY;
+	} else {
+		context->vfd_isopen = TRUE;
+		file->private_data = context;
+		info("VFD port opened");
+	}
+
+	UNLOCK_CONTEXT;
+
+exit:
+	up(&disconnect_sem);
+	return retval;
+}
+
+/**
+ * Called when the VFD device(e.g. /dev/usb/lcd)
+ * is closed by the application.
+ */
+static int vfd_close(struct inode *inode, struct file *file)
+{
+	struct imon_context *context = NULL;
+	int retval = SUCCESS;
+
+	context = (struct imon_context *) file->private_data;
+
+	if (!context) {
+		err("%s: no context for device", __func__);
+		return -ENODEV;
+	}
+
+	LOCK_CONTEXT;
+
+	if (!context->vfd_supported) {
+		err("%s: VFD not supported by device", __func__);
+		retval = -ENODEV;
+	} else if (!context->vfd_isopen) {
+		err("%s: VFD is not open", __func__);
+		retval = -EIO;
+	} else {
+		context->vfd_isopen = FALSE;
+		info("VFD port closed");
+		if (!context->dev_present && !context->ir_isopen) {
+			/* Device disconnected before close and IR port is not
+			 * open. If IR port is open, context will be deleted by
+			 * ir_close. */
+			UNLOCK_CONTEXT;
+			delete_context(context);
+			return retval;
+		}
+	}
+
+	UNLOCK_CONTEXT;
+	return retval;
+}
+
+/**
+ * Sends a packet to the VFD.
+ */
+static inline int send_packet(struct imon_context *context)
+{
+	unsigned int pipe;
+	int interval = 0;
+	int retval = SUCCESS;
+	struct usb_ctrlrequest *control_req = NULL;
+
+	/* Check if we need to use control or interrupt urb */
+	if (!context->tx_control) {
+		pipe = usb_sndintpipe(context->dev,
+				      context->tx_endpoint->bEndpointAddress);
+		interval = context->tx_endpoint->bInterval;
+
+		usb_fill_int_urb(context->tx_urb, context->dev, pipe,
+				 context->usb_tx_buf,
+				 sizeof(context->usb_tx_buf),
+				 usb_tx_callback, context, interval);
+
+		context->tx_urb->actual_length = 0;
+	} else {
+		/* fill request into kmalloc'ed space: */
+		control_req = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
+		if (control_req == NULL)
+			return -ENOMEM;
+
+		/* setup packet is '21 09 0200 0001 0008' */
+		control_req->bRequestType = 0x21;
+		control_req->bRequest = 0x09;
+		control_req->wValue = cpu_to_le16(0x0002);
+		control_req->wIndex = cpu_to_le16(0x0100);
+		control_req->wLength = cpu_to_le16(0x0800);
+
+		/* control pipe is endpoint 0x00 */
+		pipe = usb_sndctrlpipe(context->dev, 0);
+
+		/* build the control urb */
+		usb_fill_control_urb(context->tx_urb, context->dev, pipe,
+				     (unsigned char *)control_req,
+				     context->usb_tx_buf,
+				     sizeof(context->usb_tx_buf),
+				     usb_tx_callback, context);
+		context->tx_urb->actual_length = 0;
+	}
+
+	init_completion(&context->tx.finished);
+	atomic_set(&(context->tx.busy), 1);
+
+	retval =  usb_submit_urb(context->tx_urb, GFP_KERNEL);
+	if (retval != SUCCESS) {
+		atomic_set(&(context->tx.busy), 0);
+		err("%s: error submitting urb(%d)", __func__, retval);
+	} else {
+		/* Wait for tranmission to complete(or abort) */
+		UNLOCK_CONTEXT;
+		wait_for_completion(&context->tx.finished);
+		LOCK_CONTEXT;
+
+		retval = context->tx.status;
+		if (retval != SUCCESS)
+			err("%s: packet tx failed(%d)", __func__, retval);
+	}
+
+	kfree(control_req);
+
+	return retval;
+}
+
+/**
+ * Sends an associate packet to the iMON 2.4G.
+ *
+ * This might not be such a good idea, since it has an id
+ * collition with some versions of the "IR & VFD" combo.
+ * The only way to determine if it is a RF version is to look
+ * at the product description string.(Which we currently do
+ * not fetch).
+ */
+static inline int send_associate_24g(struct imon_context *context)
+{
+	int retval;
+	const unsigned char packet[8] = { 0x01, 0x00, 0x00, 0x00,
+					  0x00, 0x00, 0x00, 0x20 };
+
+	if (!context) {
+		err("%s: no context for device", __func__);
+		return -ENODEV;
+	}
+
+	LOCK_CONTEXT;
+
+	if (!context->dev_present) {
+		err("%s: no iMON device present", __func__);
+		retval = -ENODEV;
+		goto exit;
+	}
+
+	memcpy(context->usb_tx_buf, packet, sizeof(packet));
+	retval = send_packet(context);
+
+exit:
+	UNLOCK_CONTEXT;
+
+	return retval;
+}
+
+/**
+ * This is the sysfs functions to handle the association og the iMON 2.4G LT.
+ *
+ *
+ */
+
+static ssize_t show_associate_remote(struct device *d,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct imon_context *context = dev_get_drvdata(d);
+
+	if (!context)
+		return -ENODEV;
+
+	if (context->ir_isassociating) {
+		strcpy(buf, "The device it associating press some button "
+			    "on the remote.\n");
+	} else if (context->ir_isopen) {
+		strcpy(buf, "Device is open and ready to associate.\n"
+			    "Echo something into this file to start "
+			    "the process.\n");
+	} else {
+		strcpy(buf, "Device is closed, you need to open it to "
+			    "associate the remote(you can use irw).\n");
+	}
+	return strlen(buf);
+}
+
+static ssize_t store_associate_remote(struct device *d,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct imon_context *context;
+
+	context = dev_get_drvdata(d);
+
+	if (!context)
+		return -ENODEV;
+
+	if (!context->ir_isopen)
+		return -EINVAL;
+
+	if (context->ir_isopen) {
+		context->ir_isassociating = TRUE;
+		send_associate_24g(context);
+	}
+
+	return count;
+}
+
+static DEVICE_ATTR(associate_remote, S_IWUSR | S_IRUGO, show_associate_remote,
+		   store_associate_remote);
+
+static struct attribute *imon_sysfs_entries[] = {
+	&dev_attr_associate_remote.attr,
+	NULL
+};
+
+static struct attribute_group imon_attribute_group = {
+	.attrs = imon_sysfs_entries
+};
+
+
+
+
+/**
+ * Writes data to the VFD.  The IMON VFD is 2x16 characters
+ * and requires data in 5 consecutive USB interrupt packets,
+ * each packet but the last carrying 7 bytes.
+ *
+ * I don't know if the VFD board supports features such as
+ * scrolling, clearing rows, blanking, etc. so at
+ * the caller must provide a full screen of data.  If fewer
+ * than 32 bytes are provided spaces will be appended to
+ * generate a full screen.
+ */
+static ssize_t vfd_write(struct file *file, const char *buf,
+			 size_t n_bytes, loff_t *pos)
+{
+	int i;
+	int offset;
+	int seq;
+	int retval = SUCCESS;
+	struct imon_context *context;
+
+	context = (struct imon_context *) file->private_data;
+	if (!context) {
+		err("%s: no context for device", __func__);
+		return -ENODEV;
+	}
+
+	LOCK_CONTEXT;
+
+	if (!context->dev_present) {
+		err("%s: no iMON device present", __func__);
+		retval = -ENODEV;
+		goto exit;
+	}
+
+	if (n_bytes <= 0 || n_bytes > 32) {
+		err("%s: invalid payload size", __func__);
+		retval = -EINVAL;
+		goto exit;
+	}
+
+	if (copy_from_user(context->tx.data_buf, buf, n_bytes)) {
+		retval = -EFAULT;
+		goto exit;
+	}
+
+	/* Pad with spaces */
+	for (i = n_bytes; i < 32; ++i)
+		context->tx.data_buf[i] = ' ';
+
+	for (i = 32; i < 35; ++i)
+		context->tx.data_buf[i] = 0xFF;
+
+	offset = 0;
+	seq = 0;
+
+	do {
+		memcpy(context->usb_tx_buf, context->tx.data_buf + offset, 7);
+		context->usb_tx_buf[7] = (unsigned char) seq;
+
+		retval = send_packet(context);
+		if (retval != SUCCESS) {
+			err("%s: send packet failed for packet #%d",
+					__func__, seq/2);
+			goto exit;
+		} else {
+			seq += 2;
+			offset += 7;
+		}
+
+	} while (offset < 35);
+
+	if (context->vfd_proto_6p) {
+		/* Send packet #6 */
+		memcpy(context->usb_tx_buf, vfd_packet6, 7);
+		context->usb_tx_buf[7] = (unsigned char) seq;
+		retval = send_packet(context);
+		if (retval != SUCCESS)
+			err("%s: send packet failed for packet #%d",
+					__func__, seq/2);
+	}
+
+exit:
+	UNLOCK_CONTEXT;
+
+	return (retval == SUCCESS) ? n_bytes : retval;
+}
+
+/**
+ * Writes data to the LCD.  The iMON OEM LCD screen excepts 8-byte
+ * packets. We accept data as 16 hexadecimal digits, followed by a
+ * newline (to make it easy to drive the device from a command-line
+ * -- even though the actual binary data is a bit complicated).
+ *
+ * The device itself is not a "traditional" text-mode display. It's
+ * actually a 16x96 pixel bitmap display. That means if you want to
+ * display text, you've got to have your own "font" and translate the
+ * text into bitmaps for display. This is really flexible (you can
+ * display whatever diacritics you need, and so on), but it's also
+ * a lot more complicated than most LCDs...
+ */
+static ssize_t lcd_write(struct file *file, const char *buf,
+			 size_t n_bytes, loff_t *pos)
+{
+	int retval = SUCCESS;
+	struct imon_context *context;
+
+	context = (struct imon_context *) file->private_data;
+	if (!context) {
+		err("%s: no context for device", __func__);
+		return -ENODEV;
+	}
+
+	LOCK_CONTEXT;
+
+	if (!context->dev_present) {
+		err("%s: no iMON device present", __func__);
+		retval = -ENODEV;
+		goto exit;
+	}
+
+	if (n_bytes != 8) {
+		err("%s: invalid payload size: %d (expecting 8)",
+		    __func__, (int) n_bytes);
+		retval = -EINVAL;
+		goto exit;
+	}
+
+	if (copy_from_user(context->usb_tx_buf, buf, 8)) {
+		retval = -EFAULT;
+		goto exit;
+	}
+
+	retval = send_packet(context);
+	if (retval != SUCCESS) {
+		err("%s: send packet failed!", __func__);
+		goto exit;
+	} else if (debug) {
+		info("%s: write %d bytes to LCD", __func__, (int) n_bytes);
+	}
+exit:
+	UNLOCK_CONTEXT;
+	return (retval == SUCCESS) ? n_bytes : retval;
+}
+
+/**
+ * Callback function for USB core API: transmit data
+ */
+static void usb_tx_callback(struct urb *urb)
+{
+	struct imon_context *context;
+
+	if (!urb)
+		return;
+	context = (struct imon_context *) urb->context;
+	if (!context)
+		return;
+
+	context->tx.status = urb->status;
+
+	/* notify waiters that write has finished */
+	atomic_set(&context->tx.busy, 0);
+	complete(&context->tx.finished);
+
+	return;
+}
+
+/**
+ * Called by lirc_dev when the application opens /dev/lirc
+ */
+static int ir_open(void *data)
+{
+	int retval = SUCCESS;
+	struct imon_context *context;
+
+	/* prevent races with disconnect */
+	down(&disconnect_sem);
+
+	context = (struct imon_context *) data;
+
+	LOCK_CONTEXT;
+
+	if (context->ir_isopen) {
+		err("%s: IR port is already open", __func__);
+		retval = -EBUSY;
+		goto exit;
+	}
+
+	/* initial IR protocol decode variables */
+	context->rx.count = 0;
+	context->rx.initial_space = 1;
+	context->rx.prev_bit = 0;
+
+	usb_fill_int_urb(context->rx_urb, context->dev,
+		usb_rcvintpipe(context->dev,
+				context->rx_endpoint->bEndpointAddress),
+		context->usb_rx_buf, sizeof(context->usb_rx_buf),
+		usb_rx_callback, context, context->rx_endpoint->bInterval);
+
+	retval = usb_submit_urb(context->rx_urb, GFP_KERNEL);
+
+	if (retval)
+		err("%s: usb_submit_urb failed for ir_open(%d)",
+		    __func__, retval);
+	else {
+		context->ir_isopen = TRUE;
+		info("IR port opened");
+	}
+
+exit:
+	UNLOCK_CONTEXT;
+
+	up(&disconnect_sem);
+	return SUCCESS;
+}
+
+/**
+ * Called by lirc_dev when the application closes /dev/lirc
+ */
+static void ir_close(void *data)
+{
+	struct imon_context *context;
+
+	context = (struct imon_context *)data;
+	if (!context) {
+		err("%s: no context for device", __func__);
+		return;
+	}
+
+	LOCK_CONTEXT;
+
+	usb_kill_urb(context->rx_urb);
+	context->ir_isopen = FALSE;
+	context->ir_isassociating = FALSE;
+	info("IR port closed");
+
+	if (!context->dev_present) {
+		/* Device disconnected while IR port was
+		 * still open. Plugin was not deregistered
+		 * at disconnect time, so do it now. */
+		deregister_from_lirc(context);
+
+		if (!context->vfd_isopen) {
+			UNLOCK_CONTEXT;
+			delete_context(context);
+			return;
+		}
+		/* If VFD port is open, context will be deleted by vfd_close */
+	}
+
+	UNLOCK_CONTEXT;
+	return;
+}
+
+/**
+ * Convert bit count to time duration(in us) and submit
+ * the value to lirc_dev.
+ */
+static inline void submit_data(struct imon_context *context)
+{
+	unsigned char buf[4];
+	int value = context->rx.count;
+	int i;
+
+	if (debug)
+		info("submitting data to LIRC\n");
+
+	value *= BIT_DURATION;
+	value &= PULSE_MASK;
+	if (context->rx.prev_bit)
+		value |= PULSE_BIT;
+
+	for (i = 0; i < 4; ++i)
+		buf[i] = value>>(i*8);
+
+	lirc_buffer_write_1(context->plugin->rbuf, buf);
+	wake_up(&context->plugin->rbuf->wait_poll);
+	return;
+}
+
+/**
+ * Process the incoming packet
+ */
+static inline void incoming_packet(struct imon_context *context,
+				   struct urb *urb)
+{
+	int len = urb->actual_length;
+	unsigned char *buf = urb->transfer_buffer;
+	int octet, bit;
+	unsigned char mask;
+	int chunk_num;
+#ifdef DEBUG
+	int i;
+#endif
+
+	if (len != 8) {
+		warn("%s: invalid incoming packet size(%d)",
+		     __func__, len);
+		return;
+	}
+
+	/* iMON 2.4G associate frame */
+	if (buf[0] == 0x00 &&
+	    buf[2] == 0xFF &&				/* REFID */
+	    buf[3] == 0xFF &&
+	    buf[4] == 0xFF &&
+	    buf[5] == 0xFF &&				/* iMON 2.4G */
+	   ((buf[6] == 0x4E && buf[7] == 0xDF) ||	/* LT */
+	    (buf[6] == 0x5E && buf[7] == 0xDF))) {	/* DT */
+		warn("%s: remote associated refid=%02X", __func__, buf[1]);
+		context->ir_isassociating = FALSE;
+	}
+
+	chunk_num = buf[7];
+
+	if (chunk_num == 0xFF)
+		return;		/* filler frame, no data here */
+
+	if (buf[0] == 0xFF &&
+	    buf[1] == 0xFF &&
+	    buf[2] == 0xFF &&
+	    buf[3] == 0xFF &&
+	    buf[4] == 0xFF &&
+	    buf[5] == 0xFF &&				/* iMON 2.4G */
+	    ((buf[6] == 0x4E && buf[7] == 0xAF) ||	/* LT */
+	     (buf[6] == 0x5E && buf[7] == 0xAF)))	/* DT */
+		return;		/* filler frame, no data here */
+
+#ifdef DEBUG
+	for (i = 0; i < 8; ++i)
+		printk(KERN_INFO "%02x ", buf[i]);
+	printk(KERN_INFO "\n");
+#endif
+
+	if (context->ir_onboard_decode) {
+		/* The signals have been decoded onboard the iMON controller */
+		lirc_buffer_write_1(context->plugin->rbuf, buf);
+		wake_up(&context->plugin->rbuf->wait_poll);
+		return;
+	}
+
+	/* Translate received data to pulse and space lengths.
+	 * Received data is active low, i.e. pulses are 0 and
+	 * spaces are 1.
+	 *
+	 * My original algorithm was essentially similar to
+	 * Changwoo Ryu's with the exception that he switched
+	 * the incoming bits to active high and also fed an
+	 * initial space to LIRC at the start of a new sequence
+	 * if the previous bit was a pulse.
+	 *
+	 * I've decided to adopt his algorithm. */
+
+	if (chunk_num == 1 && context->rx.initial_space) {
+		/* LIRC requires a leading space */
+		context->rx.prev_bit = 0;
+		context->rx.count = 4;
+		submit_data(context);
+		context->rx.count = 0;
+	}
+
+	for (octet = 0; octet < 5; ++octet) {
+		mask = 0x80;
+		for (bit = 0; bit < 8; ++bit) {
+			int curr_bit = !(buf[octet] & mask);
+			if (curr_bit != context->rx.prev_bit) {
+				if (context->rx.count) {
+					submit_data(context);
+					context->rx.count = 0;
+				}
+				context->rx.prev_bit = curr_bit;
+			}
+			++context->rx.count;
+			mask >>= 1;
+		}
+	}
+
+	if (chunk_num == 10) {
+		if (context->rx.count) {
+			submit_data(context);
+			context->rx.count = 0;
+		}
+		context->rx.initial_space = context->rx.prev_bit;
+	}
+}
+
+/**
+ * Callback function for USB core API: receive data
+ */
+static void usb_rx_callback(struct urb *urb)
+{
+	struct imon_context *context;
+
+	if (!urb)
+		return;
+	context = (struct imon_context *) urb->context;
+	if (!context)
+		return;
+
+	switch (urb->status) {
+	case -ENOENT:		/* usbcore unlink successful! */
+		return;
+	case SUCCESS:
+		if (context->ir_isopen)
+			incoming_packet(context, urb);
+		break;
+	default:
+		warn("%s: status(%d): ignored", __func__, urb->status);
+		break;
+	}
+
+	usb_submit_urb(context->rx_urb, GFP_ATOMIC);
+	return;
+}
+
+
+
+/**
+ * Callback function for USB core API: Probe
+ */
+static int imon_probe(struct usb_interface *interface,
+		      const struct usb_device_id *id)
+{
+	struct usb_device *dev = NULL;
+	struct usb_host_interface *iface_desc = NULL;
+	struct usb_endpoint_descriptor *rx_endpoint = NULL;
+	struct usb_endpoint_descriptor *tx_endpoint = NULL;
+	struct urb *rx_urb = NULL;
+	struct urb *tx_urb = NULL;
+	struct lirc_plugin *plugin = NULL;
+	struct lirc_buffer *rbuf = NULL;
+	int lirc_minor = 0;
+	int num_endpoints;
+	int retval = SUCCESS;
+	int vfd_ep_found;
+	int ir_ep_found;
+	int alloc_status;
+	int vfd_proto_6p = FALSE;
+	int ir_onboard_decode = FALSE;
+	int tx_control = FALSE;
+	struct imon_context *context = NULL;
+	int i;
+
+	info("%s: found IMON device", __func__);
+
+	/*
+	 * If it's the LCD, as opposed to the VFD, we just need to replace
+	 * the "write" file op.
+	 */
+	if (is_lcd)
+		vfd_fops.write = &lcd_write;
+
+	dev = usb_get_dev(interface_to_usbdev(interface));
+	iface_desc = interface->cur_altsetting;
+	num_endpoints = iface_desc->desc.bNumEndpoints;
+
+	/*
+	 * Scan the endpoint list and set:
+	 *	first input endpoint = IR endpoint
+	 *	first output endpoint = VFD endpoint
+	 */
+
+	ir_ep_found = FALSE;
+	vfd_ep_found = FALSE;
+
+	for (i = 0; i < num_endpoints && !(ir_ep_found && vfd_ep_found); ++i) {
+		struct usb_endpoint_descriptor *ep;
+		int ep_dir;
+		int ep_type;
+		ep = &iface_desc->endpoint[i].desc;
+		ep_dir = ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK;
+		ep_type = ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
+
+		if (!ir_ep_found &&
+			ep_dir == USB_DIR_IN &&
+			ep_type == USB_ENDPOINT_XFER_INT) {
+
+			rx_endpoint = ep;
+			ir_ep_found = TRUE;
+			if (debug)
+				info("%s: found IR endpoint", __func__);
+
+		} else if (!vfd_ep_found &&
+			   ep_dir == USB_DIR_OUT &&
+			   ep_type == USB_ENDPOINT_XFER_INT) {
+			tx_endpoint = ep;
+			vfd_ep_found = TRUE;
+			if (debug)
+				info("%s: found VFD endpoint", __func__);
+		}
+	}
+
+	/*
+	 * If we didn't find a vfd endpoint, and we have a next-gen LCD,
+	 * use control urb instead of interrupt
+	 */
+	if (!vfd_ep_found) {
+		if (usb_match_id(interface, lcd_control_endpoint_list)) {
+			tx_control = 1;
+			vfd_ep_found = TRUE;
+			if (debug)
+				info("%s: LCD device uses control endpoint, "
+				     "not interface OUT endpoint", __func__);
+		}
+	}
+
+	/* Input endpoint is mandatory */
+	if (!ir_ep_found) {
+		err("%s: no valid input(IR) endpoint found.", __func__);
+		retval = -ENODEV;
+		goto exit;
+	} else {
+		/* Determine if the IR signals are decoded onboard */
+		if (usb_match_id(interface, ir_onboard_decode_list))
+			ir_onboard_decode = TRUE;
+
+		if (debug)
+			info("ir_onboard_decode: %d", ir_onboard_decode);
+	}
+
+	/* Determine if VFD requires 6 packets */
+	if (vfd_ep_found) {
+		if (usb_match_id(interface, vfd_proto_6p_list))
+			vfd_proto_6p = TRUE;
+
+		if (debug)
+			info("vfd_proto_6p: %d", vfd_proto_6p);
+	}
+
+
+	/* Allocate memory */
+
+	alloc_status = SUCCESS;
+
+	context = kmalloc(sizeof(struct imon_context), GFP_KERNEL);
+	if (!context) {
+		err("%s: kmalloc failed for context", __func__);
+		alloc_status = 1;
+		goto alloc_status_switch;
+	}
+	plugin = kmalloc(sizeof(struct lirc_plugin), GFP_KERNEL);
+	if (!plugin) {
+		err("%s: kmalloc failed for lirc_plugin", __func__);
+		alloc_status = 2;
+		goto alloc_status_switch;
+	}
+	rbuf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
+	if (!rbuf) {
+		err("%s: kmalloc failed for lirc_buffer", __func__);
+		alloc_status = 3;
+		goto alloc_status_switch;
+	}
+	if (lirc_buffer_init(rbuf, BUF_CHUNK_SIZE, BUF_SIZE)) {
+		err("%s: lirc_buffer_init failed", __func__);
+		alloc_status = 4;
+		goto alloc_status_switch;
+	}
+	rx_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!rx_urb) {
+		err("%s: usb_alloc_urb failed for IR urb", __func__);
+		alloc_status = 5;
+		goto alloc_status_switch;
+	}
+	if (vfd_ep_found) {
+		tx_urb = usb_alloc_urb(0, GFP_KERNEL);
+		if (!tx_urb) {
+			err("%s: usb_alloc_urb failed for VFD urb",
+			    __func__);
+			alloc_status = 6;
+			goto alloc_status_switch;
+		}
+	}
+
+	/* clear all members of imon_context and lirc_plugin */
+	memset(context, 0, sizeof(struct imon_context));
+	mutex_init(&context->lock);
+	context->vfd_proto_6p = vfd_proto_6p;
+	context->ir_onboard_decode = ir_onboard_decode;
+
+	memset(plugin, 0, sizeof(struct lirc_plugin));
+
+	strcpy(plugin->name, MOD_NAME);
+	plugin->minor = -1;
+	plugin->code_length = (ir_onboard_decode) ?
+		32 : sizeof(int) * 8;
+	plugin->sample_rate = 0;
+	plugin->features = (ir_onboard_decode) ?
+		LIRC_CAN_REC_LIRCCODE : LIRC_CAN_REC_MODE2;
+	plugin->data = context;
+	plugin->rbuf = rbuf;
+	plugin->set_use_inc = ir_open;
+	plugin->set_use_dec = ir_close;
+	plugin->dev = &dev->dev;
+	plugin->owner = THIS_MODULE;
+
+	LOCK_CONTEXT;
+
+	lirc_minor = lirc_register_plugin(plugin);
+	if (lirc_minor < 0) {
+		err("%s: lirc_register_plugin failed", __func__);
+		alloc_status = 7;
+		UNLOCK_CONTEXT;
+		goto alloc_status_switch;
+	} else
+		info("%s: Registered iMON plugin(minor:%d)",
+		     __func__, lirc_minor);
+
+	/* Needed while unregistering! */
+	plugin->minor = lirc_minor;
+
+	context->dev = dev;
+	context->dev_present = TRUE;
+	context->rx_endpoint = rx_endpoint;
+	context->rx_urb = rx_urb;
+	if (vfd_ep_found) {
+		context->vfd_supported = TRUE;
+		context->tx_endpoint = tx_endpoint;
+		context->tx_urb = tx_urb;
+		context->tx_control = tx_control;
+	}
+	context->plugin = plugin;
+
+	usb_set_intfdata(interface, context);
+
+	if (cpu_to_le16(dev->descriptor.idProduct) == 0xffdc) {
+		int err;
+
+		err = sysfs_create_group(&interface->dev.kobj,
+					 &imon_attribute_group);
+		if (err)
+			err("%s: Could not create sysfs entries(%d)",
+			    __func__, err);
+	}
+
+	if (vfd_ep_found) {
+		if (debug)
+			info("Registering VFD with sysfs");
+		if (usb_register_dev(interface, &imon_class)) {
+			/* Not a fatal error, so ignore */
+			info("%s: could not get a minor number for VFD",
+				__func__);
+		}
+	}
+
+	info("%s: iMON device on usb<%d:%d> initialized",
+			__func__, dev->bus->busnum, dev->devnum);
+
+	UNLOCK_CONTEXT;
+
+alloc_status_switch:
+
+	switch (alloc_status) {
+	case 7:
+		if (vfd_ep_found)
+			usb_free_urb(tx_urb);
+	case 6:
+		usb_free_urb(rx_urb);
+	case 5:
+		lirc_buffer_free(rbuf);
+	case 4:
+		kfree(rbuf);
+	case 3:
+		kfree(plugin);
+	case 2:
+		kfree(context);
+		context = NULL;
+	case 1:
+		retval = -ENOMEM;
+	case SUCCESS:
+		;
+	}
+
+exit:
+	return retval;
+}
+
+/**
+ * Callback function for USB core API: disonnect
+ */
+static void imon_disconnect(struct usb_interface *interface)
+{
+	struct imon_context *context;
+
+	/* prevent races with ir_open()/vfd_open() */
+	down(&disconnect_sem);
+
+	context = usb_get_intfdata(interface);
+	LOCK_CONTEXT;
+
+	info("%s: iMON device disconnected", __func__);
+
+	/* sysfs_remove_group is safe to call even if sysfs_create_group
+	 * hasn't been called */
+	sysfs_remove_group(&interface->dev.kobj,
+			   &imon_attribute_group);
+	usb_set_intfdata(interface, NULL);
+	context->dev_present = FALSE;
+
+	/* Stop reception */
+	usb_kill_urb(context->rx_urb);
+
+	/* Abort ongoing write */
+	if (atomic_read(&context->tx.busy)) {
+		usb_kill_urb(context->tx_urb);
+		wait_for_completion(&context->tx.finished);
+	}
+
+	/* De-register from lirc_dev if IR port is not open */
+	if (!context->ir_isopen)
+		deregister_from_lirc(context);
+
+	if (context->vfd_supported)
+		usb_deregister_dev(interface, &imon_class);
+
+	UNLOCK_CONTEXT;
+
+	if (!context->ir_isopen && !context->vfd_isopen)
+		delete_context(context);
+
+	up(&disconnect_sem);
+}
+
+static int __init imon_init(void)
+{
+	int rc;
+
+	info(MOD_DESC ", v" MOD_VERSION);
+	info(MOD_AUTHOR);
+
+	rc = usb_register(&imon_driver);
+	if (rc) {
+		err("%s: usb register failed(%d)", __func__, rc);
+		return -ENODEV;
+	}
+	return SUCCESS;
+}
+
+static void __exit imon_exit(void)
+{
+	usb_deregister(&imon_driver);
+	info("module removed. Goodbye!");
+}
+
+#ifdef MODULE
+module_init(imon_init);
+module_exit(imon_exit);
+
+#else
+subsys_initcall(imon_init);
+
+#endif /* MODULE */
-- 
1.6.0.1

