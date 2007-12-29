Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbXL2Te0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbXL2Te0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 14:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXL2TeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 14:34:18 -0500
Received: from po-out-1718.google.com ([72.14.252.153]:3461 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbXL2TeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 14:34:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=mihtbQ4+9j3dKsujpwFRpTaWGAQtPmkm59OhulXc3iWAye2Zf17dncp17lAxgtYpL+PIJ4RP6W5v/HoKQxntZuZI6g8ec8JMEWZLCy8TBUX4oRvPdjssGg+A1odRvfbAtrwif27v6I/vQl6woUeoQKdiejViF1OlumnigH2xHI8=
Date: Sat, 29 Dec 2007 11:34:09 -0800
From: mgross <640e9920@gmail.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [RFC] USB driver for talking to the Microchip PIC18 boot loader
Message-ID: <20071229193409.GA20188@mgross-t43>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm playing around with a PIC based project at home (not an Intel
activity) and found I needed a usb driver to talk to the boot loader
so I can program my USB Bitwhacker with new custom firmware.  The
following adds the pic18bl driver to the kernel.  Its pretty simple
and is somewhat based on bits of a libusb driver that does some of
what this driver does.

What do you think?

--mgross


Singed-off-by: Mark Gross  <640e9920@gmail.com>
---


Index: linux-2.6.24-rc6/drivers/usb/misc/pic18bl.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.24-rc6/drivers/usb/misc/pic18bl.c	2007-12-29 11:21:14.000000000 -0800
@@ -0,0 +1,627 @@
+/*
+ * PIC18 usb boot loader driver based on the MicroChip firmware, and a user
+ * mode libusb driver that does some of the same operations only different.
+ * Based on the skeleton driver
+ *
+ * --mgross
+ *
+ * USB Skeleton driver - 2.2
+ *
+ * Copyright (C) 2001-2004 Greg Kroah-Hartman (greg@kroah.com)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ * This driver is based on the 2.6.3 version of drivers/usb/usb-pic18bleton.c
+ * but has been rewritten to be easier to read and use.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/kref.h>
+#include <asm/uaccess.h>
+#include <linux/usb.h>
+#include <linux/mutex.h>
+
+/* Define these values to match your devices */
+#define USB_PIC18BL_VENDOR_ID	0x04d8
+#define USB_PIC18BL_PRODUCT_ID	0x000b
+
+/* table of devices that work with this driver */
+static struct usb_device_id pic18bl_table [] = {
+	{ USB_DEVICE(USB_PIC18BL_VENDOR_ID, USB_PIC18BL_PRODUCT_ID) },
+	{ }					/* Terminating entry */
+};
+MODULE_DEVICE_TABLE(usb, pic18bl_table);
+
+
+/* Get a minor range for your devices from the usb maintainer */
+#define USB_PIC18BL_MINOR_BASE	192
+
+/* our private defines. if this grows any larger, use your own .h file */
+#define MAX_TRANSFER		(PAGE_SIZE - 512)
+/* MAX_TRANSFER is chosen so that the VM is not stressed by
+   allocations > PAGE_SIZE and the number of packets in a page
+   is an integer 512 is the largest possible packet on EHCI */
+#define WRITES_IN_FLIGHT	8
+/* arbitrarily chosen */
+
+/* structs and information based on boot loader firmware */
+#define BOOT_EP_SIZE 64
+#define OVER_HEAD   5           /*Overhead: <CMD_CODE><LEN><ADDR:3>*/
+#define DATA_SIZE   (BOOT_EP_SIZE - OVER_HEAD)
+
+#define	READ_VERSION     0x00
+#define	READ_FLASH       0x01
+#define	WRITE_FLASH      0x02
+#define	ERASE_FLASH      0x03
+#define	READ_EEDATA      0x04
+#define	WRITE_EEDATA     0x05
+#define	READ_CONFIG      0x06
+#define	WRITE_CONFIG     0x07
+#define	UPDATE_LED       0x32
+#define	RESET            0xFF
+
+struct address {
+	u8 low;
+	u8 high;
+	u8 upper;
+} __attribute__ ((packed));
+
+union boot_data_buffer {
+	u8 buffer[BOOT_EP_SIZE];
+	struct {
+		u8 cmd;
+		u8 len;
+		struct address addr;
+		u8 data[DATA_SIZE];
+	} __attribute__ ((packed)) data;
+	struct {
+		u8 cmd; /* should always == 32 */
+		u8 led_num; /* should only be 3 or 4 */
+		u8 led_status;
+	} __attribute__ ((packed)) led;
+};
+
+
+/* Structure to hold all of our device specific stuff */
+struct usb_pic18bl {
+	struct usb_device	*udev;
+	struct usb_interface	*interface;
+	struct semaphore	limit_sem;
+	struct usb_anchor	submitted;
+	unsigned char           *bulk_in_buffer;
+	size_t			bulk_in_size;
+	__u8			bulk_in_endpointAddr;
+	__u8			bulk_out_endpointAddr;
+	int			errors;
+	int			open_count;
+	spinlock_t		err_lock;
+	struct kref		kref;
+	struct mutex		io_mutex;
+};
+#define to_pic18bl_dev(d) container_of(d, struct usb_pic18bl, kref)
+
+static struct usb_driver pic18bl_driver;
+static void pic18bl_draw_down(struct usb_pic18bl *dev);
+
+static void pic18bl_delete(struct kref *kref)
+{
+	struct usb_pic18bl *dev = to_pic18bl_dev(kref);
+
+	usb_put_dev(dev->udev);
+	kfree(dev->bulk_in_buffer);
+	kfree(dev);
+}
+
+static int pic18bl_open(struct inode *inode, struct file *file)
+{
+	struct usb_pic18bl *dev;
+	struct usb_interface *interface;
+	int subminor;
+	int retval = 0;
+
+	subminor = iminor(inode);
+
+	interface = usb_find_interface(&pic18bl_driver, subminor);
+	if (!interface) {
+		err("%s - error, can't find device for minor %d",
+		     __FUNCTION__, subminor);
+		retval = -ENODEV;
+		goto exit;
+	}
+
+	dev = usb_get_intfdata(interface);
+	if (!dev) {
+		retval = -ENODEV;
+		goto exit;
+	}
+
+	/* increment our usage count for the device */
+	kref_get(&dev->kref);
+
+	/* lock the device to allow correctly handling errors
+	 * in resumption */
+	mutex_lock(&dev->io_mutex);
+
+	if (!dev->open_count++) {
+		retval = usb_autopm_get_interface(interface);
+			if (retval) {
+				dev->open_count--;
+				mutex_unlock(&dev->io_mutex);
+				kref_put(&dev->kref, pic18bl_delete);
+				goto exit;
+			}
+	} else {
+		retval = -EBUSY;
+		dev->open_count--;
+		mutex_unlock(&dev->io_mutex);
+		kref_put(&dev->kref, pic18bl_delete);
+		goto exit;
+	}
+	/* prevent the device from being autosuspended */
+	/* save our object in the file's private structure */
+	file->private_data = dev;
+
+	mutex_unlock(&dev->io_mutex);
+exit:
+	return retval;
+}
+
+static int pic18bl_release(struct inode *inode, struct file *file)
+{
+	struct usb_pic18bl *dev;
+
+	dev = (struct usb_pic18bl *)file->private_data;
+	if (dev == NULL)
+		return -ENODEV;
+
+	/* allow the device to be autosuspended */
+	mutex_lock(&dev->io_mutex);
+	if (!--dev->open_count && dev->interface)
+		usb_autopm_put_interface(dev->interface);
+	mutex_unlock(&dev->io_mutex);
+
+	/* decrement the count on our device */
+	kref_put(&dev->kref, pic18bl_delete);
+	return 0;
+}
+
+static int pic18bl_flush(struct file *file, fl_owner_t id)
+{
+	struct usb_pic18bl *dev;
+	int res;
+
+	dev = (struct usb_pic18bl *)file->private_data;
+	if (dev == NULL)
+		return -ENODEV;
+
+	/* wait for io to stop */
+	mutex_lock(&dev->io_mutex);
+	pic18bl_draw_down(dev);
+
+	/* read out errors, leave subsequent opens a clean slate */
+	spin_lock_irq(&dev->err_lock);
+	res = dev->errors ? (dev->errors == -EPIPE ? -EPIPE : -EIO) : 0;
+	dev->errors = 0;
+	spin_unlock_irq(&dev->err_lock);
+
+	mutex_unlock(&dev->io_mutex);
+
+	return res;
+}
+
+static ssize_t pic18bl_read(struct file *file, char *buffer, size_t count,
+			loff_t *ppos)
+{
+	struct usb_pic18bl *dev;
+	int retval;
+	int bytes_read;
+
+	dev = (struct usb_pic18bl *)file->private_data;
+
+	mutex_lock(&dev->io_mutex);
+	if (!dev->interface) {
+		/* disconnect() was called */
+		retval = -ENODEV;
+		goto exit;
+	}
+
+	/* do a blocking bulk read to get data from the device */
+	retval = usb_bulk_msg(dev->udev,
+			usb_rcvbulkpipe(dev->udev, dev->bulk_in_endpointAddr),
+			dev->bulk_in_buffer,
+			min(dev->bulk_in_size, count),
+			&bytes_read, 10000);
+
+	/* if the read was successful, copy the data to userspace */
+	if (!retval) {
+		if (copy_to_user(buffer, dev->bulk_in_buffer, bytes_read))
+			retval = -EFAULT;
+		else
+			retval = bytes_read;
+	}
+
+exit:
+	mutex_unlock(&dev->io_mutex);
+	return retval;
+}
+
+static void pic18bl_write_bulk_callback(struct urb *urb)
+{
+	struct usb_pic18bl *dev;
+
+	dev = (struct usb_pic18bl *)urb->context;
+
+	/* sync/async unlink faults aren't errors */
+	if (urb->status) {
+		if (!(urb->status == -ENOENT ||
+		    urb->status == -ECONNRESET ||
+		    urb->status == -ESHUTDOWN))
+			err("%s - nonzero write bulk status received: %d",
+			    __FUNCTION__, urb->status);
+
+		spin_lock(&dev->err_lock);
+		dev->errors = urb->status;
+		spin_unlock(&dev->err_lock);
+	}
+
+	/* free up our allocated buffer */
+	usb_buffer_free(urb->dev, urb->transfer_buffer_length,
+			urb->transfer_buffer, urb->transfer_dma);
+	up(&dev->limit_sem);
+}
+
+static ssize_t pic18bl_write(struct file *file, const char *user_buffer,
+			size_t count, loff_t *ppos)
+{
+	struct usb_pic18bl *dev;
+	int retval = -1;
+	struct urb *urb = NULL;
+	union boot_data_buffer *buf = NULL;
+	size_t writesize = min(count, sizeof(union boot_data_buffer));
+	int address = 0;
+
+	dev = (struct usb_pic18bl *)file->private_data;
+
+	/* verify that we actually have some data to write */
+	if (count == 0 || count > sizeof(union boot_data_buffer))
+		goto exit;
+
+	/* limit the number of URBs in flight to stop a user from using up all
+	 * RAM
+	 */
+	if (down_interruptible(&dev->limit_sem)) {
+		retval = -ERESTARTSYS;
+		goto exit;
+	}
+
+	spin_lock_irq(&dev->err_lock);
+	retval = dev->errors;
+	if (retval < 0) {
+		/* any error is reported once */
+		dev->errors = 0;
+		/* to preserve notifications about reset */
+		retval = (retval == -EPIPE) ? retval : -EIO;
+	}
+	spin_unlock_irq(&dev->err_lock);
+	if (retval < 0)
+		goto error;
+
+	/* create a urb, and a buffer for it, and copy the data to the urb */
+	urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!urb) {
+		retval = -ENOMEM;
+		goto error;
+	}
+
+	buf = usb_buffer_alloc(dev->udev, writesize, GFP_KERNEL,
+			&urb->transfer_dma);
+	if (!buf) {
+		retval = -ENOMEM;
+		goto error;
+	}
+
+	if (copy_from_user(buf, user_buffer, writesize)) {
+		retval = -EFAULT;
+		goto error;
+	}
+	/* check buffer for invalid noise */
+	address = buf->data.addr.low +
+		256*(buf->data.addr.high + 256 * buf->data.addr.upper);
+	printk(KERN_ERR "pic18bl_write: writesize = %d cmd = %d, len = %d,\
+		add = 0x%02x%02x%02x\n",writesize, buf->data.cmd, buf->data.len,
+		buf->data.addr.upper, buf->data.addr.high, buf->data.addr.low);
+
+	switch (buf->data.cmd) {
+	/*TODO add more checks for bogus data */
+	/* TODO add code to make read / write transactions impossible to
+	 * step on each other.  i.e. starting a write transaction while
+	 * a read is in flight would be bad.
+	 */
+	case READ_VERSION:
+	case RESET:
+		if (buf->data.len + 5 != writesize) {
+			retval = -EINVAL;
+			goto error;
+		}
+		break;
+	case WRITE_FLASH:
+	case ERASE_FLASH:
+		if (address < 0x800) {
+			printk(KERN_ERR "pic18bl: attempt to step on boot "
+				"loader memory blocked by driver \n");
+			retval = -EINVAL;
+			goto error;
+		}
+	case READ_EEDATA:
+	case WRITE_EEDATA:
+	case WRITE_CONFIG:
+	case READ_FLASH:
+	case READ_CONFIG:
+		break;
+	case UPDATE_LED:
+	/* boot.c in the fw code looks like this
+	 * command is somewhat of a no-op.  perhaps
+	 * i should remove this guy????
+	 */
+		if (buf->led.led_num != 3 ||
+			buf->led.led_num != 4)
+			goto error;
+
+	default:
+		/*free buf */
+		goto error;
+	}
+
+	/* this lock makes sure we don't submit URBs to gone devices */
+	mutex_lock(&dev->io_mutex);
+	if (!dev->interface) {
+		/* disconnect() was called */
+		mutex_unlock(&dev->io_mutex);
+		retval = -ENODEV;
+		goto error;
+	}
+
+	/* initialize the urb properly */
+	usb_fill_bulk_urb(urb, dev->udev,
+			usb_sndbulkpipe(dev->udev, dev->bulk_out_endpointAddr),
+			buf, writesize, pic18bl_write_bulk_callback, dev);
+	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+	usb_anchor_urb(urb, &dev->submitted);
+
+	/* send the data out the bulk port */
+	retval = usb_submit_urb(urb, GFP_KERNEL);
+	mutex_unlock(&dev->io_mutex);
+	if (retval) {
+		err("%s - failed submitting write urb, error %d", __FUNCTION__,
+			retval);
+		goto error_unanchor;
+	}
+
+	/* release our reference to this urb, the USB core will eventually free
+	 * it entirely */
+	usb_free_urb(urb);
+
+
+	return writesize;
+
+error_unanchor:
+	usb_unanchor_urb(urb);
+error:
+	if (urb) {
+		usb_buffer_free(dev->udev, writesize, buf, urb->transfer_dma);
+		usb_free_urb(urb);
+	}
+	up(&dev->limit_sem);
+
+exit:
+	return retval;
+}
+
+static const struct file_operations pic18bl_fops = {
+	.owner =	THIS_MODULE,
+	.read =		pic18bl_read,
+	.write =	pic18bl_write,
+	.open =		pic18bl_open,
+	.release =	pic18bl_release,
+	.flush =	pic18bl_flush,
+};
+
+/*
+ * usb class driver info in order to get a minor number from the usb core,
+ * and to have the device registered with the driver core
+ */
+static struct usb_class_driver pic18bl_class = {
+	.name =		"pic18bl%d",
+	.fops =		&pic18bl_fops,
+	.minor_base =	USB_PIC18BL_MINOR_BASE,
+};
+
+static int pic18bl_probe(struct usb_interface *interface,
+			const struct usb_device_id *id)
+{
+	struct usb_pic18bl *dev;
+	struct usb_host_interface *iface_desc;
+	struct usb_endpoint_descriptor *endpoint;
+	size_t buffer_size;
+	int i;
+	int retval = -ENOMEM;
+
+	/* allocate memory for our device state and initialize it */
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		err("Out of memory");
+		goto error;
+	}
+	kref_init(&dev->kref);
+	sema_init(&dev->limit_sem, WRITES_IN_FLIGHT);
+	mutex_init(&dev->io_mutex);
+	spin_lock_init(&dev->err_lock);
+	init_usb_anchor(&dev->submitted);
+
+	dev->udev = usb_get_dev(interface_to_usbdev(interface));
+	dev->interface = interface;
+
+	/* set up the endpoint information */
+	/* use only the first bulk-in and bulk-out endpoints */
+	iface_desc = interface->cur_altsetting;
+	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
+		endpoint = &iface_desc->endpoint[i].desc;
+
+		if (!dev->bulk_in_endpointAddr &&
+		    usb_endpoint_is_bulk_in(endpoint)) {
+			/* we found a bulk in endpoint */
+			buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
+			dev->bulk_in_size = buffer_size;
+			dev->bulk_in_endpointAddr = endpoint->bEndpointAddress;
+			dev->bulk_in_buffer = kmalloc(buffer_size, GFP_KERNEL);
+			if (!dev->bulk_in_buffer) {
+				err("Could not allocate bulk_in_buffer");
+				goto error;
+			}
+		}
+
+		if (!dev->bulk_out_endpointAddr &&
+		    usb_endpoint_is_bulk_out(endpoint)) {
+			/* we found a bulk out endpoint */
+			dev->bulk_out_endpointAddr = endpoint->bEndpointAddress;
+		}
+	}
+	if (!(dev->bulk_in_endpointAddr && dev->bulk_out_endpointAddr)) {
+		err("Could not find both bulk-in and bulk-out endpoints");
+		goto error;
+	}
+
+	/* save our data pointer in this interface device */
+	usb_set_intfdata(interface, dev);
+
+	/* we can register the device now, as it is ready */
+	retval = usb_register_dev(interface, &pic18bl_class);
+	if (retval) {
+		/* something prevented us from registering this driver */
+		err("Not able to get a minor for this device.");
+		usb_set_intfdata(interface, NULL);
+		goto error;
+	}
+
+	/* let the user know what node this device is now attached to */
+	info("USB bit whaker device now attached to pic18bl-%d",
+			interface->minor);
+	return 0;
+
+error:
+	if (dev)
+		/* this frees allocated memory */
+		kref_put(&dev->kref, pic18bl_delete);
+	return retval;
+}
+
+static void pic18bl_disconnect(struct usb_interface *interface)
+{
+	struct usb_pic18bl *dev;
+	int minor = interface->minor;
+
+	dev = usb_get_intfdata(interface);
+	usb_set_intfdata(interface, NULL);
+
+	/* give back our minor */
+	usb_deregister_dev(interface, &pic18bl_class);
+
+	/* prevent more I/O from starting */
+	mutex_lock(&dev->io_mutex);
+	dev->interface = NULL;
+	mutex_unlock(&dev->io_mutex);
+
+	usb_kill_anchored_urbs(&dev->submitted);
+
+	/* decrement our usage count */
+	kref_put(&dev->kref, pic18bl_delete);
+
+	info("USB pic18bl #%d now disconnected", minor);
+}
+
+static void pic18bl_draw_down(struct usb_pic18bl *dev)
+{
+	int time;
+
+	time = usb_wait_anchor_empty_timeout(&dev->submitted, 1000);
+	if (!time)
+		usb_kill_anchored_urbs(&dev->submitted);
+}
+
+static int pic18bl_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct usb_pic18bl *dev = usb_get_intfdata(intf);
+
+	if (!dev)
+		return 0;
+	pic18bl_draw_down(dev);
+	return 0;
+}
+
+static int pic18bl_resume(struct usb_interface *intf)
+{
+	return 0;
+}
+
+static int pic18bl_pre_reset(struct usb_interface *intf)
+{
+	struct usb_pic18bl *dev = usb_get_intfdata(intf);
+
+	mutex_lock(&dev->io_mutex);
+	pic18bl_draw_down(dev);
+
+	return 0;
+}
+
+static int pic18bl_post_reset(struct usb_interface *intf)
+{
+	struct usb_pic18bl *dev = usb_get_intfdata(intf);
+
+	/* we are sure no URBs are active - no locking needed */
+	dev->errors = -EPIPE;
+	mutex_unlock(&dev->io_mutex);
+
+	return 0;
+}
+
+static struct usb_driver pic18bl_driver = {
+	.name =		"pic18bl",
+	.probe =	pic18bl_probe,
+	.disconnect =	pic18bl_disconnect,
+	.suspend =	pic18bl_suspend,
+	.resume =	pic18bl_resume,
+	.pre_reset =	pic18bl_pre_reset,
+	.post_reset =	pic18bl_post_reset,
+	.id_table =	pic18bl_table,
+	.supports_autosuspend = 0,
+};
+
+static int __init usb_pic18bl_init(void)
+{
+	int result;
+
+	/* register this driver with the USB subsystem */
+	result = usb_register(&pic18bl_driver);
+	if (result)
+		err("usb_register failed. Error number %d", result);
+
+	return result;
+}
+
+static void __exit usb_pic18bl_exit(void)
+{
+	/* deregister this driver with the USB subsystem */
+	usb_deregister(&pic18bl_driver);
+}
+
+module_init(usb_pic18bl_init);
+module_exit(usb_pic18bl_exit);
+
+MODULE_LICENSE("GPL");
Index: linux-2.6.24-rc6/MAINTAINERS
===================================================================
--- linux-2.6.24-rc6.orig/MAINTAINERS	2007-12-29 11:04:05.000000000 -0800
+++ linux-2.6.24-rc6/MAINTAINERS	2007-12-29 11:14:19.000000000 -0800
@@ -3906,6 +3906,13 @@
 W:	http://pegasus2.sourceforge.net/
 S:	Maintained
 
+USB PIC18 BOOT LOADER DRIVER
+P:	Mark Gross
+M:	640e9920@gmail.com
+L:      linux-usb@vger.kernel.org
+W:	http://www.thegnar.org/bitwhacker/bitwhacker.html
+S:	Maintained
+
 USB PRINTER DRIVER (usblp)
 P:	Pete Zaitcev
 M:	zaitcev@redhat.com
Index: linux-2.6.24-rc6/drivers/usb/misc/Kconfig
===================================================================
--- linux-2.6.24-rc6.orig/drivers/usb/misc/Kconfig	2007-12-29 11:04:05.000000000 -0800
+++ linux-2.6.24-rc6/drivers/usb/misc/Kconfig	2007-12-29 11:19:54.000000000 -0800
@@ -258,6 +258,16 @@
 	  To compile this driver as a module, choose M here: the
 	  module will be called iowarrior.
 
+config USB_PIC18_BOOTLOADER
+	tristate "PIC 18 boot load driver support"
+	depends on USB
+	help
+	  Say Y here if you want to support the programming PIC18 usb
+	  devices that have the Microchip boot loader firmware on them.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called pic18bl.
+
 config USB_TEST
 	tristate "USB testing driver (DEVELOPMENT)"
 	depends on USB && USB_DEVICEFS && EXPERIMENTAL
Index: linux-2.6.24-rc6/drivers/usb/misc/Makefile
===================================================================
--- linux-2.6.24-rc6.orig/drivers/usb/misc/Makefile	2007-12-29 11:04:05.000000000 -0800
+++ linux-2.6.24-rc6/drivers/usb/misc/Makefile	2007-12-29 11:18:46.000000000 -0800
@@ -22,6 +22,7 @@
 obj-$(CONFIG_USB_PHIDGETKIT)	+= phidgetkit.o
 obj-$(CONFIG_USB_PHIDGETMOTORCONTROL)	+= phidgetmotorcontrol.o
 obj-$(CONFIG_USB_PHIDGETSERVO)	+= phidgetservo.o
+obj-$(CONFIG_USB_PIC18_BOOTLOADER)	+= pic18bl.o
 obj-$(CONFIG_USB_RIO500)	+= rio500.o
 obj-$(CONFIG_USB_TEST)		+= usbtest.o
 obj-$(CONFIG_USB_TRANCEVIBRATOR)	+= trancevibrator.o
