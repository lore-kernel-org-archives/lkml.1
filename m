Return-Path: <linux-kernel-owner+w=401wt.eu-S933326AbXBBIji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbXBBIji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 03:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933322AbXBBIjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 03:39:37 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52340 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933324AbXBBIjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 03:39:35 -0500
Date: Fri, 2 Feb 2007 10:39:32 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: lirc@bartelmus.de
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] lirc: remove backwards compatibility macro obfuscation (Was:
 Free Linux Driver Development!)
Message-ID: <Pine.LNX.4.64.0702021038270.21422@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

On 02 Feb 2007 05:54:00 +0100, Christoph Bartelmus <lirc@bartelmus.de> wrote:
> I just made clear that I don't have the time to do the merging of LIRC
> drivers to the kernel myself. In fact a lot of work still needs to be
> done before LIRC drivers are ready to be included into the kernel.

[snip]

On 02 Feb 2007 05:54:00 +0100, Christoph Bartelmus <lirc@bartelmus.de> wrote:
> Any help welcome.

Here's a start. You really should run Lindent on the sources too.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---

 drivers/lirc_atiusb/lirc_atiusb.c           |  102 -----------------
 drivers/lirc_bt829/lirc_bt829.c             |    9 -
 drivers/lirc_cmdir/lirc_cmdir.c             |    9 -
 drivers/lirc_dev/lirc_dev.c                 |   19 ---
 drivers/lirc_gpio/lirc_gpio.c               |   16 --
 drivers/lirc_i2c/lirc_i2c.c                 |    5 
 drivers/lirc_igorplugusb/lirc_igorplugusb.c |   69 ------------
 drivers/lirc_imon/lirc_imon.c               |  159 ----------------------------
 drivers/lirc_mceusb/lirc_mceusb.c           |  103 ------------------
 drivers/lirc_mceusb2/lirc_mceusb2.c         |   25 ----
 drivers/lirc_parallel/lirc_parallel.c       |   29 -----
 drivers/lirc_sasem/lirc_sasem.c             |  153 --------------------------
 drivers/lirc_serial/lirc_serial.c           |    5 
 drivers/lirc_sir/lirc_sir.c                 |    5 
 drivers/lirc_streamzap/lirc_streamzap.c     |   97 -----------------
 15 files changed, 6 insertions(+), 799 deletions(-)

Index: lirc-0.8.1/drivers/lirc_dev/lirc_dev.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_dev/lirc_dev.c
+++ lirc-0.8.1/drivers/lirc_dev/lirc_dev.c
@@ -26,11 +26,6 @@
 #endif
  
 #include <linux/version.h>
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 2, 18)
-#error "**********************************************************"
-#error " Sorry, this driver needs kernel version 2.2.18 or higher "
-#error "**********************************************************"
-#endif
 
 #include <linux/autoconf.h>
 #include <linux/module.h>
@@ -44,9 +39,6 @@
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
 #include <asm/errno.h>
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-#include <linux/wrapper.h>
-#endif
 #define __KERNEL_SYSCALLS__
 #include <linux/unistd.h>
 
@@ -403,9 +395,6 @@ int lirc_register_plugin(struct lirc_plu
  * Recent kernels should handle this autmatically by increasing/decreasing
  * use count when a dependant module is loaded/unloaded.
  */
-#ifndef KERNEL_2_5
-	MOD_INC_USE_COUNT;
-#endif
 	dprintk("lirc_dev: plugin %s registered at minor number = %d\n",
 		ir->p.name, ir->p.minor);
 	p->minor = minor;
@@ -457,17 +446,12 @@ int lirc_unregister_plugin(int minor)
 		ir->t_notify = &tn;
 		ir->t_notify2 = &tn2;
 		ir->shutdown = 1;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 		{
 			struct task_struct *p;
 			
 			p = find_task_by_pid(ir->tpid);
 			wake_up_process(p);
 		}
-#else
-		/* 2.2.x does not export wake_up_process() */
-		wake_up_interruptible(ir->p.get_queue(ir->p.data));
-#endif
 		up(&tn2);
 		down(&tn);
 		ir->t_notify = NULL;
@@ -497,9 +481,6 @@ int lirc_unregister_plugin(int minor)
  * Recent kernels should handle this autmatically by increasing/decreasing
  * use count when a dependant module is loaded/unloaded.
  */
-#ifndef KERNEL_2_5
-	MOD_DEC_USE_COUNT;
-#endif
 
 	return SUCCESS;
 }
Index: lirc-0.8.1/drivers/lirc_mceusb/lirc_mceusb.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_mceusb/lirc_mceusb.c
+++ lirc-0.8.1/drivers/lirc_mceusb/lirc_mceusb.c
@@ -96,17 +96,8 @@
 #include <linux/module.h>
 #include <linux/smp_lock.h>
 #include <linux/usb.h>
-#ifdef KERNEL_2_5
 #include <linux/completion.h>
 #include <asm/uaccess.h>
-#else
-#include <linux/spinlock.h>
-#include <linux/list.h>
-#include <linux/fcntl.h>
-#include <linux/poll.h>
-#include <linux/sched.h>
-#include <linux/signal.h>
-#endif
 
 #ifdef CONFIG_USB_DEBUG
 	static int debug = 1;
@@ -186,24 +177,16 @@ struct usb_skel {
 	 */
 	int    last_space;
 	
-#ifdef KERNEL_2_5
 	dma_addr_t dma_in;
 	dma_addr_t dma_out;
-#endif
 };
 
 #define MCE_TIME_UNIT 50
 
 /* driver api */
-#ifdef KERNEL_2_5
 static int mceusb_probe		(struct usb_interface *interface, const struct usb_device_id *id);
 static void mceusb_disconnect	(struct usb_interface *interface);
 static void mceusb_write_bulk_callback	(struct urb *urb, struct pt_regs *regs);
-#else
-static void * mceusb_probe	(struct usb_device *dev, unsigned int ifnum, const struct usb_device_id *id);
-static void mceusb_disconnect	(struct usb_device *dev, void *ptr);
-static void mceusb_write_bulk_callback	(struct urb *urb);
-#endif
 
 /* read data from the usb bus; convert to mode2 */
 static int msir_fetch_more_data( struct usb_skel* dev, int dont_block );
@@ -255,15 +238,10 @@ static inline void mceusb_delete (struct
 {
 	dprintk("%s", __func__);
 	minor_table[dev->minor] = NULL;
-#ifdef KERNEL_2_5
+
 	usb_buffer_free(dev->udev, dev->bulk_in_size, dev->bulk_in_buffer, dev->dma_in);
 	usb_buffer_free(dev->udev, dev->bulk_out_size, dev->bulk_out_buffer, dev->dma_out);
-#else
-	if (dev->bulk_in_buffer != NULL)
-		kfree (dev->bulk_in_buffer);
-	if (dev->bulk_out_buffer != NULL)
-		kfree (dev->bulk_out_buffer);
-#endif
+
 	if (dev->write_urb != NULL)
 		usb_free_urb (dev->write_urb);
 	kfree (dev);
@@ -654,11 +632,7 @@ static int mceusb_add_to_buf(void* data,
 /**
  *	mceusb_write_bulk_callback
  */
-#ifdef KERNEL_2_5 
 static void mceusb_write_bulk_callback (struct urb *urb, struct pt_regs *regs)
-#else
-static void mceusb_write_bulk_callback (struct urb *urb)
-#endif
 {
 	struct usb_skel *dev = (struct usb_skel *)urb->context;
 
@@ -680,18 +654,10 @@ static void mceusb_write_bulk_callback (
  *	Called by the usb core when a new device is connected that it 
  *	thinks this driver might be interested in.
  */
-#ifdef KERNEL_2_5 
 static int mceusb_probe(struct usb_interface *interface, const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(interface);
 	struct usb_host_interface *iface_desc;
-#else
-static void * mceusb_probe(struct usb_device *udev, unsigned int ifnum,
-			   const struct usb_device_id *id)
-{
-	struct usb_interface *interface = &udev->actconfig->interface[ifnum];
-	struct usb_interface_descriptor *iface_desc;	
-#endif
 	struct usb_skel *dev = NULL;
 	struct usb_endpoint_descriptor *endpoint;
 	
@@ -707,11 +673,7 @@ static void * mceusb_probe(struct usb_de
 	if ((cpu_to_le16(udev->descriptor.idVendor) != USB_MCEUSB_VENDOR_ID) ||
 	    (cpu_to_le16(udev->descriptor.idProduct) != USB_MCEUSB_PRODUCT_ID)) {
 	    	dprintk("Wrong Vendor/Product IDs");
-#ifdef KERNEL_2_5
 		return -ENODEV;
-#else
-		return NULL;
-#endif
 	}
 
 	/* select a "subminor" number (part of a minor number) */
@@ -730,9 +692,7 @@ static void * mceusb_probe(struct usb_de
 	dev = kmalloc (sizeof(struct usb_skel), GFP_KERNEL);
 	if (dev == NULL) {
 		err ("Out of memory");
-#ifdef KERNEL_2_5
 		retval = -ENOMEM;
-#endif
 		goto error;
 	}
 	minor_table[minor] = dev;
@@ -746,19 +706,10 @@ static void * mceusb_probe(struct usb_de
 	/* set up the endpoint information */
 	/* check out the endpoints */
 	/* use only the first bulk-in and bulk-out endpoints */
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,4)
 	iface_desc = interface->cur_altsetting;
-#else
-	iface_desc = &interface->altsetting[0];
-#endif
 
-#ifdef KERNEL_2_5
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
 		endpoint = &iface_desc->endpoint[i].desc;
-#else
-	for (i = 0; i < iface_desc->bNumEndpoints; ++i) {
-		endpoint = &iface_desc->endpoint[i];
-#endif
 		if ((endpoint->bEndpointAddress & USB_ENDPOINT_DIR_MASK) &&
 		    ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
 		     USB_ENDPOINT_XFER_BULK)) {
@@ -766,12 +717,8 @@ static void * mceusb_probe(struct usb_de
 			buffer_size = endpoint->wMaxPacketSize;
 			dev->bulk_in_size = buffer_size;
 			dev->bulk_in_endpointAddr = endpoint->bEndpointAddress;
-#ifdef KERNEL_2_5
 			dev->bulk_in_buffer = usb_buffer_alloc
 				(udev, buffer_size, SLAB_ATOMIC, &dev->dma_in);
-#else
-			dev->bulk_in_buffer = kmalloc(buffer_size, GFP_KERNEL);
-#endif
 			if (!dev->bulk_in_buffer) {
 				err("Couldn't allocate bulk_in_buffer");
 				goto error;
@@ -782,11 +729,7 @@ static void * mceusb_probe(struct usb_de
 		    ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
 		     USB_ENDPOINT_XFER_BULK)) {
 			dprintk("we found a bulk out endpoint");
-#ifdef KERNEL_2_5
 			dev->write_urb = usb_alloc_urb(0, GFP_KERNEL);
-#else
-			dev->write_urb = usb_alloc_urb(0);
-#endif
 			if (!dev->write_urb) {
 				err("No free urbs available");
 				goto error;
@@ -794,28 +737,16 @@ static void * mceusb_probe(struct usb_de
 			buffer_size = endpoint->wMaxPacketSize;
 			dev->bulk_out_size = buffer_size;
 			dev->bulk_out_endpointAddr = endpoint->bEndpointAddress;
-#ifdef KERNEL_2_5
 			dev->bulk_out_buffer = usb_buffer_alloc(udev, buffer_size, SLAB_ATOMIC, &dev->dma_out);
-#else
-			dev->bulk_out_buffer = kmalloc (buffer_size, GFP_KERNEL);
-#endif
 			if (!dev->bulk_out_buffer) {
 				err("Couldn't allocate bulk_out_buffer");
 				goto error;
 			}
-#ifdef KERNEL_2_5
 			usb_fill_bulk_urb(dev->write_urb, udev, 
 				      usb_sndbulkpipe
 				      (udev, endpoint->bEndpointAddress),
 				      dev->bulk_out_buffer, buffer_size,
 				      mceusb_write_bulk_callback, dev);
-#else
-			FILL_BULK_URB(dev->write_urb, udev,
-				      usb_sndbulkpipe
-				      (udev, endpoint->bEndpointAddress),
-				      dev->bulk_out_buffer, buffer_size,
-				      mceusb_write_bulk_callback, dev);
-#endif 
 		}
 	}
 
@@ -891,28 +822,18 @@ static void * mceusb_probe(struct usb_de
 	msir_cleanup( dev );
 	mceusb_setup( udev );
 	
-#ifdef KERNEL_2_5
 	/* we can register the device now, as it is ready */
 	usb_set_intfdata (interface, dev);
-#endif	
 	/* let the user know what node this device is now attached to */
 	//info ("USB Microsoft IR Transceiver device now attached to msir%d", dev->minor);
 	up (&minor_table_mutex);
-#ifdef KERNEL_2_5
 	return 0;
-#else
-	return dev;
-#endif
  error:
 	mceusb_delete (dev);
 	dev = NULL;
 	dprintk("%s: retval = %x", __func__, retval);
 	up (&minor_table_mutex);
-#ifdef KERNEL_2_5
 	return retval;
-#else
-	return NULL;
-#endif
 }
 
 /**
@@ -926,20 +847,13 @@ static void * mceusb_probe(struct usb_de
  *	not provide any way to do this.  But at least we can cancel an active
  *	write.
  */
-#ifdef KERNEL_2_5 
 static void mceusb_disconnect(struct usb_interface *interface)
-#else
-static void mceusb_disconnect(struct usb_device *udev, void *ptr)
-#endif
 {
 	struct usb_skel *dev;
 	int minor;
-#ifdef KERNEL_2_5
+
 	dev = usb_get_intfdata (interface);
 	usb_set_intfdata (interface, NULL);
-#else
-	dev = (struct usb_skel *)ptr;
-#endif
 	
 	down (&minor_table_mutex);
 	down (&dev->sem);
@@ -950,7 +864,7 @@ static void mceusb_disconnect(struct usb
 	lirc_buffer_free( dev->plugin->rbuf );
 	kfree( dev->plugin->rbuf );
 	kfree( dev->plugin );
-#ifdef KERNEL_2_5
+
 	/* terminate an ongoing write */
 	if (atomic_read (&dev->write_busy)) {
 		usb_kill_urb (dev->write_urb);
@@ -959,7 +873,6 @@ static void mceusb_disconnect(struct usb
 
 	/* prevent device read, write and ioctl */
 	dev->present = 0;
-#endif
 	
 	mceusb_delete (dev);
 	
@@ -979,17 +892,9 @@ static int __init usb_mceusb_init(void)
 
 	/* register this driver with the USB subsystem */
 	result = usb_register(&mceusb_driver);
-#ifdef KERNEL_2_5	
 	if ( result ) {
-#else
-	if ( result < 0 ) {
-#endif
 		err("usb_register failed for the " DRIVER_NAME " driver. error number %d",result);
-#ifdef KERNEL_2_5
 		return result;
-#else
-		return -1;
-#endif
 	}
 
 	info(DRIVER_DESC " " DRIVER_VERSION);
Index: lirc-0.8.1/drivers/lirc_sasem/lirc_sasem.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_sasem/lirc_sasem.c
+++ lirc-0.8.1/drivers/lirc_sasem/lirc_sasem.c
@@ -54,10 +54,6 @@
 
 #include <linux/version.h>
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,22)
-#error "*** Sorry, this driver requires kernel version 2.4.22 or higher"
-#endif
-
 #include <linux/autoconf.h>
 
 #include <linux/errno.h>
@@ -97,19 +93,11 @@
  */
 
 /* USB Callback prototypes */
-#ifdef KERNEL_2_5
 static int sasem_probe (struct usb_interface *interface,
 			const struct usb_device_id *id);
 static void sasem_disconnect (struct usb_interface *interface);
 static void usb_rx_callback (struct urb *urb, struct pt_regs *regs);
 static void usb_tx_callback (struct urb *urb, struct pt_regs *regs);
-#else
-static void * sasem_probe (struct usb_device * dev, unsigned int intf,
-				const struct usb_device_id *id);
-static void sasem_disconnect (struct usb_device *dev, void *data);
-static void usb_rx_callback (struct urb *urb);
-static void usb_tx_callback (struct urb *urb);
-#endif
 
 /* VFD file_operations function prototypes */
 static int vfd_open (struct inode *inode, struct file *file);
@@ -137,10 +125,6 @@ struct sasem_context {
 	struct usb_device *dev;
 	int vfd_isopen;			/* VFD port has been opened       */
 	unsigned int vfd_contrast;	/* VFD contrast                   */
-#if !defined (KERNEL_2_5)
-	int subminor;			/* index into minor_table         */
-	devfs_handle_t devfs;
-#endif
 	int ir_isopen;			/* IR port has been opened        */
 	int dev_present;		/* USB device presence            */
 	struct semaphore sem;		/* to lock this object            */
@@ -193,38 +177,19 @@ static struct usb_driver sasem_driver = 
 	.probe 		= sasem_probe,
 	.disconnect 	= sasem_disconnect,
 	.id_table 	= sasem_usb_id_table,
-#if !defined(KERNEL_2_5)
-	.fops		= &vfd_fops,
-	.minor		= VFD_MINOR_BASE,
-#endif
 };
 
-#ifdef KERNEL_2_5
 static struct usb_class_driver sasem_class = {
 	.name 		= DEVFS_NAME,
 	.fops		= &vfd_fops,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 15)
-	.mode		= DEVFS_MODE,
-#endif
 	.minor_base	= VFD_MINOR_BASE,
 };
-#endif
 
 /* to prevent races between open() and disconnect() */
 static DECLARE_MUTEX (disconnect_sem);
 
 static int debug = 0;
 
-#if !defined(KERNEL_2_5)
-
-#define MAX_DEVICES	4	/* In case there's more than one Sasem device */
-static struct sasem_context * minor_table [MAX_DEVICES];
-
-/* the global usb devfs handle */
-extern devfs_handle_t usb_devfs_handle;
-
-#endif
-
 /* ------------------------------------------------------------
  *                     M O D U L E   C O D E
  * ------------------------------------------------------------
@@ -269,9 +234,7 @@ static inline void deregister_from_lirc 
  */
 static int vfd_open (struct inode *inode, struct file *file)
 {
-#ifdef KERNEL_2_5
 	struct usb_interface *interface;
-#endif
 	struct sasem_context *context = NULL;
 	int subminor;
 	int retval = SUCCESS;
@@ -279,7 +242,6 @@ static int vfd_open (struct inode *inode
 	/* prevent races with disconnect */
 	down (&disconnect_sem);
 	
-#ifdef KERNEL_2_5
 	subminor = iminor (inode);
 	interface = usb_find_interface (&sasem_driver, subminor);
 	if (!interface) {
@@ -288,15 +250,6 @@ static int vfd_open (struct inode *inode
 		goto exit;
 	}
 	context = usb_get_intfdata (interface);
-#else
-	subminor = MINOR (inode ->i_rdev) - VFD_MINOR_BASE;
-	if (subminor < 0 || subminor >= MAX_DEVICES) {
-		err ("%s: no record of minor %d", __FUNCTION__, subminor);
-		retval = -ENODEV;
-		goto exit;
-	}
-	context = minor_table [subminor];
-#endif
 
 	if (!context) {
 		err ("%s: no context found for minor %d", 
@@ -410,9 +363,7 @@ static inline int send_packet (struct sa
 
 	pipe = usb_sndintpipe (context ->dev,
 			context-> tx_endpoint ->bEndpointAddress);
-#ifdef KERNEL_2_5
 	interval = context ->tx_endpoint ->bInterval;
-#endif	/* Use 0 for 2.4 kernels */
 
 	usb_fill_int_urb (context ->tx_urb, context ->dev, pipe,
 		context ->usb_tx_buf, sizeof (context ->usb_tx_buf),
@@ -423,11 +374,7 @@ static inline int send_packet (struct sa
 	init_completion (&context ->tx.finished);
 	atomic_set (&(context ->tx.busy), 1);
 
-#ifdef KERNEL_2_5
 	retval =  usb_submit_urb (context ->tx_urb, GFP_KERNEL);
-#else
-	retval =  usb_submit_urb (context ->tx_urb);
-#endif
 	if (retval != SUCCESS) {
 		atomic_set (&(context ->tx.busy), 0);
 		err ("%s: error submitting urb (%d)", __FUNCTION__, retval);
@@ -517,11 +464,7 @@ exit:
 /**
  * Callback function for USB core API: transmit data
  */
-#ifdef KERNEL_2_5
 static void usb_tx_callback (struct urb *urb, struct pt_regs *regs)
-#else
-static void usb_tx_callback (struct urb *urb)
-#endif
 {
 	struct sasem_context *context;
 
@@ -564,11 +507,7 @@ static int ir_open (void *data)
 		context ->usb_rx_buf, sizeof (context ->usb_rx_buf),
 		usb_rx_callback, context, context ->rx_endpoint ->bInterval);
 
-#ifdef KERNEL_2_5
 	retval = usb_submit_urb (context ->rx_urb, GFP_KERNEL);
-#else
-	retval = usb_submit_urb (context ->rx_urb);
-#endif
 
 	if (retval) {
 		err ("%s: usb_submit_urb failed for ir_open (%d)", __FUNCTION__, retval);
@@ -692,11 +631,7 @@ static inline void incoming_packet (stru
 /**
  * Callback function for USB core API: receive data
  */
-#ifdef KERNEL_2_5
 static void usb_rx_callback (struct urb *urb, struct pt_regs *regs)
-#else
-static void usb_rx_callback (struct urb *urb)
-#endif
 {
 	struct sasem_context *context;
 
@@ -719,9 +654,7 @@ static void usb_rx_callback (struct urb 
 			break;
 	}
 
-#ifdef KERNEL_2_5
 	usb_submit_urb (context ->rx_urb, GFP_ATOMIC);
-#endif
 	return;
 }
 
@@ -730,23 +663,11 @@ static void usb_rx_callback (struct urb 
 /**
  * Callback function for USB core API: Probe
  */
-#ifdef KERNEL_2_5
 static int sasem_probe (struct usb_interface *interface,
 			const struct usb_device_id *id)
-#else
-static void * sasem_probe (struct usb_device * dev, unsigned int intf,
-			const struct usb_device_id *id)
-#endif
 {
-#ifdef KERNEL_2_5
 	struct usb_device *dev = NULL;
 	struct usb_host_interface *iface_desc = NULL;
-#else
-	struct usb_interface *interface = NULL;
-	struct usb_interface_descriptor *iface_desc = NULL;
-	char name [10];
-	int subminor = 0;
-#endif
 	struct usb_endpoint_descriptor *rx_endpoint = NULL;
 	struct usb_endpoint_descriptor *tx_endpoint = NULL;
 	struct urb *rx_urb = NULL;
@@ -764,28 +685,9 @@ static void * sasem_probe (struct usb_de
 
 	info ("%s: found Sasem device", __FUNCTION__);
 
-#if !defined(KERNEL_2_5)
-	for (subminor = 0; subminor < MAX_DEVICES; ++subminor) {
-		if (minor_table [subminor] == NULL)
-			break;
-	}
-	if (subminor == MAX_DEVICES) {
-	
-		err ("%s: allowed number of devices already present", __FUNCTION__);
-		retval = -ENOMEM;
-		goto exit;
-	}
-#endif
-
-#ifdef KERNEL_2_5
 	dev = usb_get_dev (interface_to_usbdev (interface));
 	iface_desc = interface ->cur_altsetting;
 	num_endpoints = iface_desc ->desc.bNumEndpoints;
-#else
-	interface = &dev ->actconfig ->interface [intf];
-	iface_desc = &interface ->altsetting [interface ->act_altsetting];
-	num_endpoints = iface_desc ->bNumEndpoints;
-#endif
 
 	/*
 	 * Scan the endpoint list and set:
@@ -800,11 +702,7 @@ static void * sasem_probe (struct usb_de
 		struct usb_endpoint_descriptor *ep;
 		int ep_dir;
 		int ep_type;
-#ifdef KERNEL_2_5
 		ep = &iface_desc ->endpoint [i].desc;
-#else
-		ep = &iface_desc ->endpoint [i];
-#endif
 		ep_dir = ep ->bEndpointAddress & USB_ENDPOINT_DIR_MASK;
 		ep_type = ep ->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
 
@@ -861,19 +759,11 @@ static void * sasem_probe (struct usb_de
 		err ("%s: lirc_buffer_init failed", __FUNCTION__);
 		alloc_status = 4;
 	}
-#ifdef KERNEL_2_5
 	else if (!(rx_urb = usb_alloc_urb (0, GFP_KERNEL))) {
-#else
-	else if (!(rx_urb = usb_alloc_urb (0))) {
-#endif
 		err ("%s: usb_alloc_urb failed for IR urb", __FUNCTION__);
 		alloc_status = 5;
 	}
-#ifdef KERNEL_2_5
 	else if (vfd_ep_found && !(tx_urb = usb_alloc_urb (0, GFP_KERNEL))) {
-#else
-	else if (vfd_ep_found && !(tx_urb = usb_alloc_urb (0))) {
-#endif
 		err ("%s: usb_alloc_urb failed for VFD urb", __FUNCTION__);
 		alloc_status = 6;
 	}
@@ -936,35 +826,17 @@ static void * sasem_probe (struct usb_de
 	}
 	context ->plugin = plugin;
 
-#ifdef KERNEL_2_5
 	usb_set_intfdata (interface, context);
-#else
-	minor_table [subminor] = context;
-	context ->subminor = subminor;
-#endif
 
 	if (vfd_ep_found) {
 
 		if (debug) info ("Registering VFD with devfs");
-#ifdef KERNEL_2_5
 		if (usb_register_dev (interface, &sasem_class)) {
 
 			// Not a fatal error, so ignore
 			info ("%s: could not get a minor number for VFD", 
 				__FUNCTION__);
 		}
-#else
-		sprintf (name, DEVFS_NAME, subminor);
-		if (!(context ->devfs = devfs_register (usb_devfs_handle, name, 
-					DEVFS_FL_DEFAULT,
-					USB_MAJOR, VFD_MINOR_BASE + subminor,
-					DEVFS_MODE, &vfd_fops, NULL))) {
-
-			// not a fatal error so ignore
-			info ("%s: devfs register failed for VFD",
-					__FUNCTION__);
-		}
-#endif
 	}
 
 	info ("%s: Sasem device on usb<%d:%d> initialized",
@@ -972,41 +844,25 @@ static void * sasem_probe (struct usb_de
 
 	UNLOCK_CONTEXT;
 exit:
-#ifdef KERNEL_2_5
 	return retval;
-#else
-	return (retval == SUCCESS) ? context : NULL;
-#endif
 }
 
 /**
  * Callback function for USB core API: disonnect
  */
-#ifdef KERNEL_2_5
 static void sasem_disconnect (struct usb_interface *interface)
-#else
-static void sasem_disconnect (struct usb_device *dev, void *data)
-#endif
 {
 	struct sasem_context *context;
 
 	/* prevent races with ir_open()/vfd_open() */
 	down (&disconnect_sem);
 
-#ifdef KERNEL_2_5
 	context = usb_get_intfdata (interface);
-#else
-	context = (struct sasem_context *)data;
-#endif
 	LOCK_CONTEXT;
 
 	info ("%s: Sasem device disconnected", __FUNCTION__);
 
-#ifdef KERNEL_2_5
 	usb_set_intfdata (interface, NULL);
-#else
-	minor_table [context ->subminor] = NULL;
-#endif
 	context ->dev_present = FALSE;
 
 	/* Stop reception */
@@ -1023,12 +879,7 @@ static void sasem_disconnect (struct usb
 	if (!context ->ir_isopen)
 		deregister_from_lirc (context);
 
-#ifdef KERNEL_2_5
 	usb_deregister_dev (interface, &sasem_class);
-#else
-	if (context ->devfs)
-		devfs_unregister (context ->devfs);
-#endif
 
 	UNLOCK_CONTEXT;
 
@@ -1061,7 +912,3 @@ static void __exit sasem_exit (void)
 
 module_init (sasem_init);
 module_exit (sasem_exit);
-
-#if !defined(KERNEL_2_5)
-EXPORT_NO_SYMBOLS;
-#endif
Index: lirc-0.8.1/drivers/lirc_serial/lirc_serial.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_serial/lirc_serial.c
+++ lirc-0.8.1/drivers/lirc_serial/lirc_serial.c
@@ -55,11 +55,6 @@
 #endif
  
 #include <linux/version.h>
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 2, 18)
-#error "**********************************************************"
-#error " Sorry, this driver needs kernel version 2.2.18 or higher "
-#error "**********************************************************"
-#endif
 
 #include <linux/autoconf.h>
 
Index: lirc-0.8.1/drivers/lirc_streamzap/lirc_streamzap.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_streamzap/lirc_streamzap.c
+++ lirc-0.8.1/drivers/lirc_streamzap/lirc_streamzap.c
@@ -32,11 +32,6 @@
  */
 
 #include	<linux/version.h>
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 4, 0)
-#error "*******************************************************"
-#error "Sorry, this driver needs kernel version 2.4.0 or higher"
-#error "*******************************************************"
-#endif
 
 #include <linux/autoconf.h>
 #include <linux/kernel.h>
@@ -159,25 +154,16 @@ struct usb_streamzap {
 
 
 /* local function prototypes */
-#ifdef KERNEL_2_5
 static int streamzap_probe(struct usb_interface *interface,
 			   const struct usb_device_id *id);
 static void streamzap_disconnect(struct usb_interface *interface);
 static void usb_streamzap_irq(struct urb *urb, struct pt_regs *regs);
-#else
-static void *streamzap_probe(struct usb_device *udev, unsigned int ifnum,
-			     const struct usb_device_id *id);
-static void streamzap_disconnect(struct usb_device *dev, void *ptr);
-static void usb_streamzap_irq(struct urb *urb);
-#endif
 static int streamzap_use_inc( void *data );
 static void streamzap_use_dec( void *data );
 static int streamzap_ioctl(struct inode *node, struct file *filep,
 			   unsigned int cmd, unsigned long arg);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 0)
 static int streamzap_suspend(struct usb_interface *intf, pm_message_t message);
 static int streamzap_resume(struct usb_interface *intf);
-#endif
 
 /* usb specific object needed to register this driver with the usb subsystem */
 
@@ -186,10 +172,8 @@ static struct usb_driver streamzap_drive
 	.name =		DRIVER_NAME,
 	.probe =	streamzap_probe,
 	.disconnect =	streamzap_disconnect,
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 0)
 	.suspend =	streamzap_suspend,
 	.resume =	streamzap_resume,
-#endif
 	.id_table =	streamzap_table,
 };
 
@@ -367,11 +351,7 @@ static inline void push_half_space(struc
  * This procedure is invoked on reception of data from
  * the usb remote.
  */
-#ifdef KERNEL_2_5
 static void usb_streamzap_irq(struct urb *urb, struct pt_regs *regs) 
-#else
-static void usb_streamzap_irq(struct urb *urb) 
-#endif
 {
 	struct usb_streamzap *sz;
 	int		len;
@@ -456,10 +436,7 @@ static void usb_streamzap_irq(struct urb
 		}
 	}
 
-#ifdef KERNEL_2_5
-	/* resubmit only for 2.6 */
 	usb_submit_urb( urb, SLAB_ATOMIC );
-#endif
 
 	return;
 }
@@ -471,18 +448,10 @@ static void usb_streamzap_irq(struct urb
  *	On any failure the return value is the ERROR
  *	On success return 0
  */
-#ifdef KERNEL_2_5
 static int streamzap_probe( struct usb_interface *interface, const struct usb_device_id *id )
 {
 	struct usb_device *udev = interface_to_usbdev(interface);
 	struct usb_host_interface *iface_host;
-#else
-static void *streamzap_probe(struct usb_device *udev, unsigned int ifnum,
-			     const struct usb_device_id *id)
-{
-	struct usb_interface *interface = &udev->actconfig->interface[ifnum];
-	struct usb_interface_descriptor *iface_host;
-#endif
 	int retval = -ENOMEM;
 	struct usb_streamzap *sz = NULL;
 	char buf[63], name[128] = "";
@@ -500,33 +469,16 @@ static void *streamzap_probe(struct usb_
 	/***************************************************
 	 * Check to ensure endpoint information matches requirements
 	 */
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,4)
 	iface_host = interface->cur_altsetting;
-#else
-	iface_host = &interface->altsetting[interface->act_altsetting];
-#endif
 
-#ifdef KERNEL_2_5
         if (iface_host->desc.bNumEndpoints != 1) {
-#else
-	if(iface_host->bNumEndpoints != 1) {
-#endif
-#ifdef KERNEL_2_5
                 err("%s: Unexpected desc.bNumEndpoints (%d)", __FUNCTION__,
 		    iface_host->desc.bNumEndpoints);
-#else
-                err("%s: Unexpected desc.bNumEndpoints (%d)", __FUNCTION__,
-		    iface_host->bNumEndpoints);
-#endif
 		retval = -ENODEV;
                 goto error;
         }
 
-#ifdef KERNEL_2_5
 	sz->endpoint = &(iface_host->endpoint[0].desc);
-#else
-	sz->endpoint = &(iface_host->endpoint[0]);
-#endif
         if (( sz->endpoint->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
 	    != USB_DIR_IN) {
                 err("%s: endpoint doesn't match input device 02%02x",
@@ -554,7 +506,6 @@ static void *streamzap_probe(struct usb_
 	 */
 
 	sz->buf_in_len = sz->endpoint->wMaxPacketSize;
-#ifdef KERNEL_2_5
         if((sz->buf_in = usb_buffer_alloc(sz->udev, sz->buf_in_len,
 					  SLAB_ATOMIC, &sz->dma_in)) == NULL )
 	{
@@ -562,17 +513,7 @@ static void *streamzap_probe(struct usb_
 	}
 	if (!( sz->urb_in = usb_alloc_urb(0, GFP_KERNEL)))
 		goto error;
-#else
-	if( (sz->buf_in = kmalloc(sz->buf_in_len, GFP_KERNEL))
-	    == NULL)
-	{
-		goto error;
-	}
-	if( (sz->urb_in = usb_alloc_urb(0)) == NULL)
-	{
-		goto error;
-	}
-#endif
+
 	/***************************************************
 	 * Connect this device to the LIRC sub-system
 	 */
@@ -639,9 +580,7 @@ static void *streamzap_probe(struct usb_
 	       sz->plugin.minor, name,
 	       udev->bus->busnum, sz->udev->devnum);
 
-#ifdef KERNEL_2_5
 	usb_set_intfdata( interface , sz );
-#endif
 
 	if(lirc_register_plugin(&sz->plugin) < 0)
 	{
@@ -650,11 +589,7 @@ static void *streamzap_probe(struct usb_
 		goto error;
 	}
 
-#ifdef KERNEL_2_5
 	return 0;
-#else
-	return sz;
-#endif
 
 error:
 
@@ -674,21 +609,13 @@ error:
 
 		if ( sz->buf_in )
 		{
-#ifdef KERNEL_2_5
 			usb_buffer_free(udev, sz->buf_in_len,
 					sz->buf_in, sz->dma_in);
-#else
-			kfree(sz->buf_in);
-#endif
 		}
 		kfree( sz );
 	}
 
-#ifdef KERNEL_2_5
 	return retval;
-#else
-	return NULL;
-#endif
 }
 
 static int streamzap_use_inc(void *data)
@@ -714,11 +641,7 @@ static int streamzap_use_inc(void *data)
 	add_timer(&sz->flush_timer);
 
 	sz->urb_in->dev = sz->udev;
-#ifdef KERNEL_2_5
 	if (usb_submit_urb(sz->urb_in, SLAB_ATOMIC))
-#else
-	if (usb_submit_urb(sz->urb_in))
-#endif
 	{
 		dprintk("open result = -EIO error submitting urb",
 			sz->plugin.minor);
@@ -781,21 +704,13 @@ static int streamzap_ioctl(struct inode 
  *	active urbs.  Unfortunately, usb_bulk_msg(), used in streamzap_read(), does
  *	not provide any way to do this.
  */
-#ifdef KERNEL_2_5
 static void streamzap_disconnect( struct usb_interface *interface )
-#else
-static void streamzap_disconnect(struct usb_device *dev, void *ptr)
-#endif
 {
 	struct usb_streamzap *sz;
 	int errnum;
 	int minor;
 
-#ifdef KERNEL_2_5
 	sz = usb_get_intfdata( interface );
-#else
-	sz = ptr;
-#endif
 
 	/*
 	 * unregister from the LIRC sub-system
@@ -816,11 +731,7 @@ static void streamzap_disconnect(struct 
 
 	usb_free_urb( sz->urb_in );
 
-#ifdef KERNEL_2_5
         usb_buffer_free( sz->udev , sz->buf_in_len, sz->buf_in, sz->dma_in );
-#else
-	kfree(sz->buf_in);
-#endif
 
 	minor = sz->plugin.minor;
 	kfree( sz );
@@ -828,7 +739,6 @@ static void streamzap_disconnect(struct 
         printk(KERN_INFO DRIVER_NAME "[%d]: disconnected\n", minor);
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 0)
 static int streamzap_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct usb_streamzap *sz = usb_get_intfdata(intf);
@@ -865,11 +775,7 @@ static int streamzap_resume(struct usb_i
 		add_timer(&sz->flush_timer);
 
 		sz->urb_in->dev = sz->udev;
-#ifdef KERNEL_2_5
 		if (usb_submit_urb(sz->urb_in, SLAB_ATOMIC))
-#else
-		if (usb_submit_urb(sz->urb_in))
-#endif
 		{
 			dprintk("open result = -EIO error submitting urb",
 				sz->plugin.minor);
@@ -879,7 +785,6 @@ static int streamzap_resume(struct usb_i
 	}
 	return 0;
 }
-#endif
 
 #ifdef MODULE
 
Index: lirc-0.8.1/drivers/lirc_sir/lirc_sir.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_sir/lirc_sir.c
+++ lirc-0.8.1/drivers/lirc_sir/lirc_sir.c
@@ -35,11 +35,6 @@
 
 
 #include <linux/version.h>
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 2, 18)
-#error "**********************************************************"
-#error " Sorry, this driver needs kernel version 2.2.18 or higher "
-#error "**********************************************************"
-#endif
 #include <linux/module.h>
 
 #ifdef HAVE_CONFIG_H
Index: lirc-0.8.1/drivers/lirc_parallel/lirc_parallel.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_parallel/lirc_parallel.c
+++ lirc-0.8.1/drivers/lirc_parallel/lirc_parallel.c
@@ -34,11 +34,6 @@
 #endif
 
 #include <linux/version.h>
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 2, 18)
-#error "**********************************************************"
-#error " Sorry, this driver needs kernel version 2.2.18 or higher "
-#error "**********************************************************"
-#endif
 
 #include <linux/autoconf.h>
 
@@ -61,9 +56,7 @@
 #include <asm/io.h>
 #include <asm/signal.h>
 #include <asm/irq.h>
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 4, 0)
 #include <asm/div64.h>
-#endif
 
 #include <asm/uaccess.h>
 #include <linux/poll.h>
@@ -349,15 +342,11 @@ static void irq_handler(int i,void *blah
 	if(signal!=0)
 	{
 		/* ajust value to usecs */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 4, 0)
 		unsigned long long helper;
 		
 		helper = ((unsigned long long) signal)*1000000;
 		do_div(helper, timer);
 		signal = (long) helper;
-#else
-		signal=(long) ((((double) signal)*1000000)/timer);
-#endif
 
 		if(signal>LIRC_SFH506_DELAY)
 		{
@@ -467,15 +456,11 @@ static ssize_t lirc_write(struct file *f
 	/* ajust values from usecs */
 	for(i=0;i<count;i++)
 	{
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 4, 0)
 		unsigned long long helper;
 		
 		helper = ((unsigned long long) wbuf[i])*timer;
 		do_div(helper, 1000000);
 		wbuf[i] = (lirc_t) helper;
-#else
-		wbuf[i]=(lirc_t) (((double) wbuf[i])*timer/1000000);
-#endif
 	}
 	
 	local_irq_save(flags);
@@ -697,19 +682,7 @@ static void kf(void *handle)
 
 int init_module(void)
 {
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 3)
 	pport=parport_find_base(io);
-#else
-	pport=parport_enumerate();
-	while(pport!=NULL)
-	{
-		if(pport->base==io)
-		{
-			break;
-		}
-		pport=pport->next;
-	}
-#endif
 	if(pport==NULL)
 	{
 		printk(KERN_NOTICE "%s: no port at %x found\n",
@@ -718,9 +691,7 @@ int init_module(void)
 	}
 	ppdevice=parport_register_device(pport,LIRC_DRIVER_NAME,
 					 pf,kf,irq_handler,0,NULL);
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 3)
 	parport_put_port(pport);
-#endif
 	if(ppdevice==NULL)
 	{
 		printk(KERN_NOTICE "%s: parport_register_device() failed\n",
Index: lirc-0.8.1/drivers/lirc_atiusb/lirc_atiusb.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_atiusb/lirc_atiusb.c
+++ lirc-0.8.1/drivers/lirc_atiusb/lirc_atiusb.c
@@ -33,11 +33,6 @@
  */
 
 #include <linux/version.h>
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 4, 0)
-#error "*******************************************************"
-#error "Sorry, this driver needs kernel version 2.4.0 or higher"
-#error "*******************************************************"
-#endif
 
 #include <linux/autoconf.h>
 
@@ -163,9 +158,7 @@ struct in_endpt {
 	/* buffers and dma */
 	unsigned char *buf;
 	unsigned int len;
-#ifdef KERNEL_2_5
 	dma_addr_t dma;
-#endif
 
 	/* handle repeats */
 	unsigned char old[CODE_LENGTH];
@@ -179,9 +172,7 @@ struct out_endpt {
 
 	/* buffers and dma */
 	unsigned char *buf;
-#ifdef KERNEL_2_5
 	dma_addr_t dma;
-#endif
 
 	/* handle sending (init strings) */
 	int send_flags;
@@ -250,11 +241,7 @@ static void send_packet(struct out_endpt
 	set_current_state(TASK_INTERRUPTIBLE);
 	add_wait_queue(&oep->wait, &wait);
 
-#ifdef KERNEL_2_5
 	if (usb_submit_urb(oep->urb, SLAB_ATOMIC)) {
-#else
-	if (usb_submit_urb(oep->urb)) {
-#endif
 		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&oep->wait, &wait);
 		IRUNLOCK;
@@ -272,9 +259,7 @@ static void send_packet(struct out_endpt
 
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&oep->wait, &wait);
-#ifdef KERNEL_2_5
 	oep->urb->transfer_flags |= URB_ASYNC_UNLINK;
-#endif
 	usb_unlink_urb(oep->urb);
 }
 
@@ -322,11 +307,7 @@ static int set_use_inc(void *data)
 			iep = get_iep_from_link(pos);
 			iep->urb->dev = ir->usbdev;
 			dprintk(DRIVER_NAME "[%d]: linking iep 0x%02x (%p)\n", ir->devnum, iep->ep->bEndpointAddress, iep);
-#ifdef KERNEL_2_5
 			if ((rtn = usb_submit_urb(iep->urb, SLAB_ATOMIC)) < 0) {
-#else
-			if ((rtn = usb_submit_urb(iep->urb)) < 0) {
-#endif
 				printk(DRIVER_NAME "[%d]: open result = %d error "
 					"submitting urb\n", ir->devnum, rtn);
 				IRUNLOCK;
@@ -599,11 +580,7 @@ static int code_check_ati2(struct in_end
 }
 
 
-#ifdef KERNEL_2_5
 static void usb_remote_recv(struct urb *urb, struct pt_regs *regs)
-#else
-static void usb_remote_recv(struct urb *urb)
-#endif
 {
 	struct in_endpt *iep;
 	int len, result;
@@ -611,9 +588,7 @@ static void usb_remote_recv(struct urb *
 	if (!urb)
 		return;
 	if (!(iep = urb->context)) {
-#ifdef KERNEL_2_5
 		urb->transfer_flags |= URB_ASYNC_UNLINK;
-#endif
 		usb_unlink_urb(urb);
 		return;
 	}
@@ -646,9 +621,7 @@ static void usb_remote_recv(struct urb *
 	case -ECONNRESET:
 	case -ENOENT:
 	case -ESHUTDOWN:
-#ifdef KERNEL_2_5
 		urb->transfer_flags |= URB_ASYNC_UNLINK;
-#endif
 		usb_unlink_urb(urb);
 		return;
 
@@ -658,25 +631,17 @@ static void usb_remote_recv(struct urb *
 	}
 
 	/* resubmit urb */
-#ifdef KERNEL_2_5
 	usb_submit_urb(urb, SLAB_ATOMIC);
-#endif
 }
 
-#ifdef KERNEL_2_5
 static void usb_remote_send(struct urb *urb, struct pt_regs *regs)
-#else
-static void usb_remote_send(struct urb *urb)
-#endif
 {
 	struct out_endpt *oep;
 
 	if (!urb)
 		return;
 	if (!(oep = urb->context)) {
-#ifdef KERNEL_2_5
 		urb->transfer_flags |= URB_ASYNC_UNLINK;
-#endif
 		usb_unlink_urb(urb);
 		return;
 	}
@@ -722,9 +687,7 @@ static void free_in_endpt(struct in_endp
 		dprintk(DRIVER_NAME "[%d]: free_in_endpt removing ep=0x%0x from list\n", ir->devnum, iep->ep->bEndpointAddress);
 	case 4:
 		if (iep->urb) {
-#ifdef KERNEL_2_5
 			iep->urb->transfer_flags |= URB_ASYNC_UNLINK;
-#endif
 			usb_unlink_urb(iep->urb);
 			usb_free_urb(iep->urb);
 			iep->urb = 0;
@@ -732,11 +695,7 @@ static void free_in_endpt(struct in_endp
 			dprintk(DRIVER_NAME "[%d]: free_in_endpt null urb!\n", ir->devnum);
 		}
 	case 3:
-#ifdef KERNEL_2_5
 		usb_buffer_free(iep->ir->usbdev, iep->len, iep->buf, iep->dma);
-#else
-		kfree(iep->buf);
-#endif
 		iep->buf = 0;
 	case 2:
 		kfree(iep);
@@ -774,19 +733,11 @@ static struct in_endpt *new_in_endpt(str
 		iep->ep = ep;
 		iep->len = len;
 
-#ifdef KERNEL_2_5
 		if ( !(iep->buf = usb_buffer_alloc(dev, len, SLAB_ATOMIC, &iep->dma)) ) {
 			mem_failure = 2;
 		} else if ( !(iep->urb = usb_alloc_urb(0, GFP_KERNEL)) ) {
 			mem_failure = 3;
 		}
-#else
-		if ( !(iep->buf = kmalloc(len, GFP_KERNEL)) ) {
-			mem_failure = 2;
-		} else if ( !(iep->urb = usb_alloc_urb(0)) ) {
-			mem_failure = 3;
-		}
-#endif
 	}
 	if (mem_failure) {
 		free_in_endpt(iep, mem_failure);
@@ -816,9 +767,7 @@ static void free_out_endpt(struct out_en
 	case FREE_ALL:
 	case 4:
 		if (oep->urb) {
-#ifdef KERNEL_2_5
 			oep->urb->transfer_flags |= URB_ASYNC_UNLINK;
-#endif
 			usb_unlink_urb(oep->urb);
 			usb_free_urb(oep->urb);
 			oep->urb = 0;
@@ -826,11 +775,7 @@ static void free_out_endpt(struct out_en
 			dprintk(DRIVER_NAME "[%d]: free_out_endpt: null urb!\n", ir->devnum);
 		}
 	case 3:
-#ifdef KERNEL_2_5
 		usb_buffer_free(oep->ir->usbdev, USB_OUTLEN, oep->buf, oep->dma);
-#else
-		kfree(oep->buf);
-#endif
 		oep->buf = 0;
 	case 2:
 		kfree(oep);
@@ -855,19 +800,11 @@ static struct out_endpt *new_out_endpt(s
 		oep->ep = ep;
 		init_waitqueue_head(&oep->wait);
 
-#ifdef KERNEL_2_5
 		if ( !(oep->buf = usb_buffer_alloc(dev, USB_OUTLEN, SLAB_ATOMIC, &oep->dma)) ) {
 			mem_failure = 2;
 		} else if ( !(oep->urb = usb_alloc_urb(0, GFP_KERNEL)) ) {
 			mem_failure = 3;
 		}
-#else
-		if ( !(oep->buf = kmalloc(USB_OUTLEN, GFP_KERNEL)) ) {
-			mem_failure = 2;
-		} else if ( !(oep->urb = usb_alloc_urb(0)) ) {
-			mem_failure = 3;
-		}
-#endif
 	}
 	if (mem_failure) {
 		free_out_endpt(oep, mem_failure);
@@ -1053,19 +990,11 @@ static void log_usb_dev_info(struct usb_
 }
 
 
-#ifdef KERNEL_2_5
 static int usb_remote_probe(struct usb_interface *intf,
 				const struct usb_device_id *id)
 {
 	struct usb_device *dev = interface_to_usbdev(intf);
 	struct usb_host_interface *idesc;
-#else
-static void *usb_remote_probe(struct usb_device *dev, unsigned int ifnum,
-				const struct usb_device_id *id)
-{
-	struct usb_interface *intf = &dev->actconfig->interface[ifnum];
-	struct usb_interface_descriptor *idesc;
-#endif
 	struct usb_endpoint_descriptor *ep;
 	struct in_endpt *iep;
 	struct irctl *ir;
@@ -1074,33 +1003,20 @@ static void *usb_remote_probe(struct usb
 	dprintk(DRIVER_NAME "[%d]: usb_remote_probe: dev:%p, intf:%p, id:%p)\n",
 		dev->devnum, dev, intf, id);
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,4)
 	idesc = intf->cur_altsetting;
-#else
-	idesc = &intf->altsetting[intf->act_altsetting];
-#endif
 
 	/* Check if a usb remote has already been registered for this device */
 	ir = get_prior_reg_ir(dev);
 
 	if ( !ir && !(ir = new_irctl(dev)) ) {
-#ifdef KERNEL_2_5
 		return -ENOMEM;
-#else
-		return NULL;
-#endif
 	}
 	type = ir->remote_type;
 
 	// step through the endpoints to find first in and first out endpoint
 	// of type interrupt transfer
-#ifdef KERNEL_2_5
 	for (i = 0; i < idesc->desc.bNumEndpoints; ++i) {
 		ep = &idesc->endpoint[i].desc;
-#else
-	for (i = 0; i < idesc->bNumEndpoints; ++i) {
-		ep = &idesc->endpoint[i];
-#endif
 		dprintk(DRIVER_NAME "[%d]: processing endpoint %d\n", dev->devnum, i);
 		if ( ((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_IN)
 			&& ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_INT)) {
@@ -1122,20 +1038,12 @@ static void *usb_remote_probe(struct usb
 	if (list_empty(&ir->iep_listhead)) {
 		printk(DRIVER_NAME "[%d]: inbound endpoint not found\n", ir->devnum);
 		free_irctl(ir, FREE_ALL);
-#ifdef KERNEL_2_5
 		return -ENODEV;
-#else
-		return NULL;
-#endif
 	}
 	if (ir->dev_refcount == 1) {
 		if ((ir->p->minor = lirc_register_plugin(ir->p)) < 0) {
 			free_irctl(ir, FREE_ALL);
-#ifdef KERNEL_2_5
 			return -ENODEV;
-#else
-			return NULL;
-#endif
 		}
 
 		/* Note new driver registration in kernel logs */
@@ -1145,25 +1053,15 @@ static void *usb_remote_probe(struct usb
 		send_outbound_init(ir);
 	}
 
-#ifdef KERNEL_2_5
 	usb_set_intfdata(intf, ir);
 	return SUCCESS;
-#else
-	return ir;
-#endif
 }
 
-#ifdef KERNEL_2_5
 static void usb_remote_disconnect(struct usb_interface *intf)
 {
 //	struct usb_device *dev = interface_to_usbdev(intf);
 	struct irctl *ir = usb_get_intfdata(intf);
 	usb_set_intfdata(intf, NULL);
-#else
-static void usb_remote_disconnect(struct usb_device *dev, void *ptr)
-{
-	struct irctl *ir = ptr;
-#endif
 
 	dprintk(DRIVER_NAME ": disconnecting remote %d:\n", (ir? ir->devnum: -1));
 	if (!ir || !ir->p)
Index: lirc-0.8.1/drivers/lirc_mceusb2/lirc_mceusb2.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_mceusb2/lirc_mceusb2.c
+++ lirc-0.8.1/drivers/lirc_mceusb2/lirc_mceusb2.c
@@ -34,11 +34,6 @@
  */
 
 #include <linux/version.h>
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 5)
-#error "*******************************************************"
-#error "Sorry, this driver needs kernel version 2.6.5 or higher"
-#error "*******************************************************"
-#endif
 
 #include <linux/autoconf.h>
 
@@ -169,22 +164,6 @@ struct irctl {
 static char init1[] = {0x00, 0xff, 0xaa, 0xff, 0x0b};
 static char init2[] = {0xff, 0x18};
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 11)
-static inline unsigned long usecs_to_jiffies(const unsigned int u)
-{
-	if (u > jiffies_to_usecs(MAX_JIFFY_OFFSET))
-		return MAX_JIFFY_OFFSET;
-#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
-	return (u + (USEC_PER_SEC / HZ) - 1) / (USEC_PER_SEC / HZ);
-#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
-	return u * (HZ / USEC_PER_SEC);
-#else
-	return (u * HZ + USEC_PER_SEC - 1) / USEC_PER_SEC;
-#endif
-}
-#endif
-
-
 static void usb_remote_printdata(struct irctl *ir, char *buf, int len)
 {
 	char codes[USB_BUFLEN*3 + 1];
@@ -818,7 +797,6 @@ static void usb_remote_disconnect(struct
 	unregister_from_lirc(ir);
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 0)
 static int usb_remote_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct irctl *ir = usb_get_intfdata(intf);
@@ -837,17 +815,14 @@ static int usb_remote_resume(struct usb_
 	}
 	return 0;
 }
-#endif
 
 static struct usb_driver usb_remote_driver = {
 	LIRC_THIS_MODULE(.owner = THIS_MODULE)
 	.name =		DRIVER_NAME,
 	.probe =	usb_remote_probe,
 	.disconnect =	usb_remote_disconnect,
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 0)
 	.suspend =	usb_remote_suspend,
 	.resume =	usb_remote_resume,
-#endif
 	.id_table =	usb_remote_table
 };
 
Index: lirc-0.8.1/drivers/lirc_imon/lirc_imon.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_imon/lirc_imon.c
+++ lirc-0.8.1/drivers/lirc_imon/lirc_imon.c
@@ -45,10 +45,6 @@
  */
 #include <linux/version.h>
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,22)
-#error "*** Sorry, this driver requires kernel version 2.4.22 or higher"
-#endif
-
 #include <linux/autoconf.h>
 
 #include <linux/errno.h>
@@ -89,19 +85,11 @@
  */
 
 /* USB Callback prototypes */
-#ifdef KERNEL_2_5
 static int imon_probe (struct usb_interface *interface,
 			const struct usb_device_id *id);
 static void imon_disconnect (struct usb_interface *interface);
 static void usb_rx_callback (struct urb *urb, struct pt_regs *regs);
 static void usb_tx_callback (struct urb *urb, struct pt_regs *regs);
-#else
-static void * imon_probe (struct usb_device * dev, unsigned int intf,
-				const struct usb_device_id *id);
-static void imon_disconnect (struct usb_device *dev, void *data);
-static void usb_rx_callback (struct urb *urb);
-static void usb_tx_callback (struct urb *urb);
-#endif
 
 /* VFD file_operations function prototypes */
 static int vfd_open (struct inode *inode, struct file *file);
@@ -127,10 +115,6 @@ struct imon_context {
 	struct usb_device *dev;
 	int vfd_supported;		/* not all controllers do         */
 	int vfd_isopen;			/* VFD port has been opened       */
-#if !defined (KERNEL_2_5)
-	int subminor;			/* index into minor_table         */
-	devfs_handle_t devfs;
-#endif
 	int ir_isopen;			/* IR port has been opened        */
 	int dev_present;		/* USB device presence            */
 	struct semaphore sem;		/* to lock this object            */
@@ -205,44 +189,19 @@ static struct usb_driver imon_driver = {
 	.probe 		= imon_probe,
 	.disconnect 	= imon_disconnect,
 	.id_table 	= imon_usb_id_table,
-#if !defined(KERNEL_2_5)
-	.fops		= &vfd_fops,
-	.minor		= VFD_MINOR_BASE,
-#endif
 };
 
-#ifdef KERNEL_2_5
 static struct usb_class_driver imon_class = {
 	.name 		= DEVFS_NAME,
 	.fops		= &vfd_fops,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 15)
-	.mode		= DEVFS_MODE,
-#endif
 	.minor_base	= VFD_MINOR_BASE,
 };
-#endif
 
 /* to prevent races between open() and disconnect() */
 static DECLARE_MUTEX (disconnect_sem);
 
 static int debug = 0;
 
-#if !defined(KERNEL_2_5)
-
-#define MAX_DEVICES	4	/* In case there's more than one iMON device */
-static struct imon_context * minor_table [MAX_DEVICES];
-
-/*
-static DECLARE_MUTEX (minor_table_sem);
-#define LOCK_MINOR_TABLE	down (&minor_table_sem)
-#define UNLOCK_MINOR_TABLE	up (&minor_table_sem)
-*/
-
-/* the global usb devfs handle */
-extern devfs_handle_t usb_devfs_handle;
-
-#endif
-
 /* ------------------------------------------------------------
  *                     M O D U L E   C O D E
  * ------------------------------------------------------------
@@ -288,9 +247,7 @@ static inline void deregister_from_lirc 
  */
 static int vfd_open (struct inode *inode, struct file *file)
 {
-#ifdef KERNEL_2_5
 	struct usb_interface *interface;
-#endif
 	struct imon_context *context = NULL;
 	int subminor;
 	int retval = SUCCESS;
@@ -298,7 +255,6 @@ static int vfd_open (struct inode *inode
 	/* prevent races with disconnect */
 	down (&disconnect_sem);
 	
-#ifdef KERNEL_2_5
 	subminor = iminor (inode);
 	interface = usb_find_interface (&imon_driver, subminor);
 	if (!interface) {
@@ -307,15 +263,6 @@ static int vfd_open (struct inode *inode
 		goto exit;
 	}
 	context = usb_get_intfdata (interface);
-#else
-	subminor = MINOR (inode ->i_rdev) - VFD_MINOR_BASE;
-	if (subminor < 0 || subminor >= MAX_DEVICES) {
-		err ("%s: no record of minor %d", __FUNCTION__, subminor);
-		retval = -ENODEV;
-		goto exit;
-	}
-	context = minor_table [subminor];
-#endif
 
 	if (!context) {
 		err ("%s: no context found for minor %d", 
@@ -404,9 +351,7 @@ static inline int send_packet (struct im
 
 	pipe = usb_sndintpipe (context ->dev,
 			context-> tx_endpoint ->bEndpointAddress);
-#ifdef KERNEL_2_5
 	interval = context ->tx_endpoint ->bInterval;
-#endif	/* Use 0 for 2.4 kernels */
 
 	usb_fill_int_urb (context ->tx_urb, context ->dev, pipe,
 		context ->usb_tx_buf, sizeof (context ->usb_tx_buf),
@@ -417,11 +362,7 @@ static inline int send_packet (struct im
 	init_completion (&context ->tx.finished);
 	atomic_set (&(context ->tx.busy), 1);
 
-#ifdef KERNEL_2_5
 	retval =  usb_submit_urb (context ->tx_urb, GFP_KERNEL);
-#else
-	retval =  usb_submit_urb (context ->tx_urb);
-#endif
 	if (retval != SUCCESS) {
 		atomic_set (&(context ->tx.busy), 0);
 		err ("%s: error submitting urb (%d)", __FUNCTION__, retval);
@@ -528,11 +469,7 @@ exit:
 /**
  * Callback function for USB core API: transmit data
  */
-#ifdef KERNEL_2_5
 static void usb_tx_callback (struct urb *urb, struct pt_regs *regs)
-#else
-static void usb_tx_callback (struct urb *urb)
-#endif
 {
 	struct imon_context *context;
 
@@ -580,11 +517,7 @@ static int ir_open (void *data)
 		context ->usb_rx_buf, sizeof (context ->usb_rx_buf),
 		usb_rx_callback, context, context ->rx_endpoint ->bInterval);
 
-#ifdef KERNEL_2_5
 	retval = usb_submit_urb (context ->rx_urb, GFP_KERNEL);
-#else
-	retval = usb_submit_urb (context ->rx_urb);
-#endif
 
 	if (retval) {
 		err ("%s: usb_submit_urb failed for ir_open (%d)", __FUNCTION__, retval);
@@ -765,11 +698,7 @@ static inline void incoming_packet (stru
 /**
  * Callback function for USB core API: receive data
  */
-#ifdef KERNEL_2_5
 static void usb_rx_callback (struct urb *urb, struct pt_regs *regs)
-#else
-static void usb_rx_callback (struct urb *urb)
-#endif
 {
 	struct imon_context *context;
 
@@ -792,9 +721,7 @@ static void usb_rx_callback (struct urb 
 			break;
 	}
 
-#ifdef KERNEL_2_5
 	usb_submit_urb (context ->rx_urb, GFP_ATOMIC);
-#endif
 	return;
 }
 
@@ -803,23 +730,11 @@ static void usb_rx_callback (struct urb 
 /**
  * Callback function for USB core API: Probe
  */
-#ifdef KERNEL_2_5
 static int imon_probe (struct usb_interface *interface,
 			const struct usb_device_id *id)
-#else
-static void * imon_probe (struct usb_device * dev, unsigned int intf,
-			const struct usb_device_id *id)
-#endif
 {
-#ifdef KERNEL_2_5
 	struct usb_device *dev = NULL;
 	struct usb_host_interface *iface_desc = NULL;
-#else
-	struct usb_interface *interface = NULL;
-	struct usb_interface_descriptor *iface_desc = NULL;
-	char name [10];
-	int subminor = 0;
-#endif
 	struct usb_endpoint_descriptor *rx_endpoint = NULL;
 	struct usb_endpoint_descriptor *tx_endpoint = NULL;
 	struct urb *rx_urb = NULL;
@@ -839,28 +754,9 @@ static void * imon_probe (struct usb_dev
 
 	info ("%s: found IMON device", __FUNCTION__);
 
-#if !defined(KERNEL_2_5)
-	for (subminor = 0; subminor < MAX_DEVICES; ++subminor) {
-		if (minor_table [subminor] == NULL)
-			break;
-	}
-	if (subminor == MAX_DEVICES) {
-	
-		err ("%s: allowed number of devices already present", __FUNCTION__);
-		retval = -ENOMEM;
-		goto exit;
-	}
-#endif
-
-#ifdef KERNEL_2_5
 	dev = usb_get_dev (interface_to_usbdev (interface));
 	iface_desc = interface ->cur_altsetting;
 	num_endpoints = iface_desc ->desc.bNumEndpoints;
-#else
-	interface = &dev ->actconfig ->interface [intf];
-	iface_desc = &interface ->altsetting [interface ->act_altsetting];
-	num_endpoints = iface_desc ->bNumEndpoints;
-#endif
 
 	/*
 	 * Scan the endpoint list and set:
@@ -875,11 +771,7 @@ static void * imon_probe (struct usb_dev
 		struct usb_endpoint_descriptor *ep;
 		int ep_dir;
 		int ep_type;
-#ifdef KERNEL_2_5
 		ep = &iface_desc ->endpoint [i].desc;
-#else
-		ep = &iface_desc ->endpoint [i];
-#endif
 		ep_dir = ep ->bEndpointAddress & USB_ENDPOINT_DIR_MASK;
 		ep_type = ep ->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
 
@@ -972,19 +864,11 @@ static void * imon_probe (struct usb_dev
 		err ("%s: lirc_buffer_init failed", __FUNCTION__);
 		alloc_status = 4;
 	}
-#ifdef KERNEL_2_5
 	else if (!(rx_urb = usb_alloc_urb (0, GFP_KERNEL))) {
-#else
-	else if (!(rx_urb = usb_alloc_urb (0))) {
-#endif
 		err ("%s: usb_alloc_urb failed for IR urb", __FUNCTION__);
 		alloc_status = 5;
 	}
-#ifdef KERNEL_2_5
 	else if (vfd_ep_found && !(tx_urb = usb_alloc_urb (0, GFP_KERNEL))) {
-#else
-	else if (vfd_ep_found && !(tx_urb = usb_alloc_urb (0))) {
-#endif
 		err ("%s: usb_alloc_urb failed for VFD urb", __FUNCTION__);
 		alloc_status = 6;
 	}
@@ -1052,35 +936,17 @@ static void * imon_probe (struct usb_dev
 	}
 	context ->plugin = plugin;
 
-#ifdef KERNEL_2_5
 	usb_set_intfdata (interface, context);
-#else
-	minor_table [subminor] = context;
-	context ->subminor = subminor;
-#endif
 
 	if (vfd_ep_found) {
 
 		if (debug) info ("Registering VFD with devfs");
-#ifdef KERNEL_2_5
 		if (usb_register_dev (interface, &imon_class)) {
 
 			// Not a fatal error, so ignore
 			info ("%s: could not get a minor number for VFD", 
 				__FUNCTION__);
 		}
-#else
-		sprintf (name, DEVFS_NAME, subminor);
-		if (!(context ->devfs = devfs_register (usb_devfs_handle, name, 
-					DEVFS_FL_DEFAULT,
-					USB_MAJOR, VFD_MINOR_BASE + subminor,
-					DEVFS_MODE, &vfd_fops, NULL))) {
-
-			// not a fatal error so ignore
-			info ("%s: devfs register failed for VFD",
-					__FUNCTION__);
-		}
-#endif
 	}
 
 	info ("%s: iMON device on usb<%d:%d> initialized",
@@ -1088,41 +954,25 @@ static void * imon_probe (struct usb_dev
 
 	UNLOCK_CONTEXT;
 exit:
-#ifdef KERNEL_2_5
 	return retval;
-#else
-	return (retval == SUCCESS) ? context : NULL;
-#endif
 }
 
 /**
  * Callback function for USB core API: disonnect
  */
-#ifdef KERNEL_2_5
 static void imon_disconnect (struct usb_interface *interface)
-#else
-static void imon_disconnect (struct usb_device *dev, void *data)
-#endif
 {
 	struct imon_context *context;
 
 	/* prevent races with ir_open()/vfd_open() */
 	down (&disconnect_sem);
 
-#ifdef KERNEL_2_5
 	context = usb_get_intfdata (interface);
-#else
-	context = (struct imon_context *)data;
-#endif
 	LOCK_CONTEXT;
 
 	info ("%s: iMON device disconnected", __FUNCTION__);
 
-#ifdef KERNEL_2_5
 	usb_set_intfdata (interface, NULL);
-#else
-	minor_table [context ->subminor] = NULL;
-#endif
 	context ->dev_present = FALSE;
 
 	/* Stop reception */
@@ -1140,12 +990,7 @@ static void imon_disconnect (struct usb_
 		deregister_from_lirc (context);
 
 	if (context ->vfd_supported) {
-#ifdef KERNEL_2_5
 		usb_deregister_dev (interface, &imon_class);
-#else
-		if (context ->devfs)
-			devfs_unregister (context ->devfs);
-#endif
 	}
 
 	UNLOCK_CONTEXT;
@@ -1179,7 +1024,3 @@ static void __exit imon_exit (void)
 
 module_init (imon_init);
 module_exit (imon_exit);
-
-#if !defined(KERNEL_2_5)
-EXPORT_NO_SYMBOLS;
-#endif
Index: lirc-0.8.1/drivers/lirc_igorplugusb/lirc_igorplugusb.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_igorplugusb/lirc_igorplugusb.c
+++ lirc-0.8.1/drivers/lirc_igorplugusb/lirc_igorplugusb.c
@@ -41,11 +41,6 @@
  */
 
 #include <linux/version.h>
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 4, 0)
-#error "*******************************************************"
-#error "Sorry, this driver needs kernel version 2.4.0 or higher"
-#error "*******************************************************"
-#endif
 
 #include <linux/autoconf.h>
 #include <linux/module.h>
@@ -63,10 +58,6 @@
 #include "drivers/lirc.h"
 #include "drivers/lirc_dev/lirc_dev.h"
 
-#if !defined(KERNEL_2_5)
-#        define USB_CTRL_GET_TIMEOUT    5
-#endif
-
 /* lock irctl structure */
 #define IRLOCK			down_interruptible(&ir->lock)
 #define IRUNLOCK		up(&ir->lock)
@@ -240,9 +231,7 @@ struct irctl {
         int in_space;
 	struct timeval last_time;
 
-#if defined(KERNEL_2_5)
 	dma_addr_t dma_in;
-#endif
 
 	/* lirc */
 	struct lirc_plugin *p;
@@ -403,21 +392,12 @@ static int usb_remote_poll(void* data, s
 
 
 
-#if defined(KERNEL_2_5)
 static int usb_remote_probe(struct usb_interface *intf,
 				const struct usb_device_id *id)
 {
 	struct usb_device *dev = NULL;
 	struct usb_host_interface *idesc = NULL;
 	struct usb_host_endpoint *ep_ctl2;
-#else
-static void *usb_remote_probe(struct usb_device *dev, unsigned int ifnum,
-				const struct usb_device_id *id)
-{
-	struct usb_interface *intf;
-	struct usb_interface_descriptor *idesc;
-	struct usb_endpoint_descriptor *ep_ctl2;
-#endif
 	struct irctl *ir = NULL;
 	struct lirc_plugin *plugin = NULL;
 	struct lirc_buffer *rbuf = NULL;
@@ -429,14 +409,9 @@ static void *usb_remote_probe(struct usb
 
 	dprintk(DRIVER_NAME ": usb probe called.\n");
 
-#if defined(KERNEL_2_5)
 	dev = interface_to_usbdev(intf);
 
-#  if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 5)
-	idesc = &intf->altsetting[intf->act_altsetting];  /* in 2.6.4 */
-#  else
-	idesc = intf->cur_altsetting;  /* in 2.6.6 */
-#  endif
+	idesc = intf->cur_altsetting;
 
 	if (idesc->desc.bNumEndpoints != 1)
 		return -ENODEV;
@@ -446,18 +421,6 @@ static void *usb_remote_probe(struct usb
 		!= USB_ENDPOINT_XFER_CONTROL)
 		return -ENODEV;
 	pipe = usb_rcvctrlpipe(dev, ep_ctl2->desc.bEndpointAddress);
-#else
-	intf = &dev->actconfig->interface[ifnum];
-	idesc = &intf->altsetting[intf->act_altsetting];
-	if (idesc->bNumEndpoints != 1)
-		return NULL;
-	ep_ctl2 = idesc->endpoint;
-	if (((ep_ctl2->bEndpointAddress & USB_ENDPOINT_DIR_MASK) != USB_DIR_IN)
-		|| (ep_ctl2->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
-		!= USB_ENDPOINT_XFER_CONTROL)
-		return NULL;
-	pipe = usb_rcvctrlpipe(dev, ep_ctl2->bEndpointAddress);
-#endif
 	devnum = dev->devnum;
 	maxp = usb_maxpacket(dev, pipe, usb_pipeout(pipe));
 
@@ -481,16 +444,10 @@ static void *usb_remote_probe(struct usb
 		} else if (lirc_buffer_init(rbuf, bytes_in_key, 
                 		DEVICE_BUFLEN+ADDITIONAL_LIRC_BYTES)) {
 			mem_failure = 4;
-#if defined(KERNEL_2_5)
 		} else if (!(ir->buf_in = usb_buffer_alloc(dev, 
 				DEVICE_BUFLEN+DEVICE_HEADERLEN, 
                                 SLAB_ATOMIC, &ir->dma_in))) {
 			mem_failure = 5;
-#else
-		} else if (!(ir->buf_in = kmalloc(
-				DEVICE_BUFLEN+DEVICE_HEADERLEN, GFP_KERNEL))) {
-			mem_failure = 5;
-#endif
 		} else {
 
 			memset(plugin, 0, sizeof(struct lirc_plugin));
@@ -519,12 +476,8 @@ static void *usb_remote_probe(struct usb
 	/* free allocated memory in case of failure */
 	switch (mem_failure) {
 	case 9:
-#if defined(KERNEL_2_5)
 		usb_buffer_free(dev, DEVICE_BUFLEN+DEVICE_HEADERLEN, 
                 	ir->buf_in, ir->dma_in);
-#else
-		kfree(ir->buf_in);
-#endif
 	case 5:
 		lirc_buffer_free(rbuf);
 	case 4:
@@ -536,11 +489,7 @@ static void *usb_remote_probe(struct usb
 	case 1:
 		printk(DRIVER_NAME "[%d]: out of memory (code=%d)\n",
 			devnum, mem_failure);
-#if defined(KERNEL_2_5)
 		return -ENOMEM;
-#else
-		return NULL;
-#endif
 	}
 
 	plugin->minor = minor;
@@ -571,26 +520,16 @@ static void *usb_remote_probe(struct usb
 			devnum, ret);
 	}
 
-#if defined(KERNEL_2_5)
 	usb_set_intfdata(intf, ir);
 	return SUCCESS;
-#else
-	return ir;
-#endif
 }
 
 
-#if defined(KERNEL_2_5)
 static void usb_remote_disconnect(struct usb_interface *intf)
 {
 	struct usb_device *dev = interface_to_usbdev(intf);
 	struct irctl *ir = usb_get_intfdata(intf);
 	usb_set_intfdata(intf, NULL);
-#else
-static void usb_remote_disconnect(struct usb_device *dev, void *ptr)
-{
-	struct irctl *ir = ptr;
-#endif
 
 	if (!ir || !ir->p)
 		return;
@@ -599,11 +538,7 @@ static void usb_remote_disconnect(struct
 	wake_up_all(&ir->wait_out);
 
 	IRLOCK;
-#if defined(KERNEL_2_5)
 	usb_buffer_free(dev, ir->len_in, ir->buf_in, ir->dma_in);
-#else
-	kfree(ir->buf_in);
-#endif
 	IRUNLOCK;
 
 	unregister_from_lirc(ir);
@@ -648,10 +583,8 @@ static void __exit usb_remote_exit(void)
 module_init(usb_remote_init);
 module_exit(usb_remote_exit);
 
-#if defined(KERNEL_2_5)
 #include <linux/vermagic.h>
 MODULE_INFO(vermagic, VERMAGIC_STRING);
-#endif
 
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_AUTHOR(DRIVER_AUTHOR);
Index: lirc-0.8.1/drivers/lirc_bt829/lirc_bt829.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_bt829/lirc_bt829.c
+++ lirc-0.8.1/drivers/lirc_bt829/lirc_bt829.c
@@ -19,9 +19,6 @@
 */
 
 #include <linux/version.h>
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 4, 0)
-#error "This driver needs kernel version 2.4.0 or higher"
-#endif
 
 #include <linux/autoconf.h>
 #include <linux/kernel.h>
@@ -73,12 +70,6 @@ static struct lirc_plugin atir_plugin;
 static int do_pci_probe(void)
 {
 	struct pci_dev *my_dev;
-#ifndef KERNEL_2_5
-	/* unnecessary with recent kernels */
-	if ( !pci_present() ) {
-		printk(KERN_ERR "ATIR: no pci in this kernel\n");
-	}
-#endif
 	my_dev = (struct pci_dev *)pci_find_device(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_264VT,NULL);
 	if ( my_dev ) {
 		printk(KERN_ERR "ATIR: Using device: %s\n",
Index: lirc-0.8.1/drivers/lirc_cmdir/lirc_cmdir.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_cmdir/lirc_cmdir.c
+++ lirc-0.8.1/drivers/lirc_cmdir/lirc_cmdir.c
@@ -29,11 +29,6 @@
 #endif
  
 #include <linux/version.h>
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 2, 18)
-#error "**********************************************************"
-#error " Sorry, this driver needs kernel version 2.2.18 or higher "
-#error "**********************************************************"
-#endif
 
 #include <linux/autoconf.h>
 #include <linux/module.h>
@@ -583,10 +578,6 @@ MODULE_DESCRIPTION("InnovationOne driver
 MODULE_LICENSE("GPL");
 #endif
 
-#ifndef KERNEL_2_5
-EXPORT_NO_SYMBOLS;
-#endif
-
 int init_module(void)
 {
 	plugin.features = hardware.features;
Index: lirc-0.8.1/drivers/lirc_gpio/lirc_gpio.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_gpio/lirc_gpio.c
+++ lirc-0.8.1/drivers/lirc_gpio/lirc_gpio.c
@@ -30,31 +30,15 @@
  */
 
 #include <linux/version.h>
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 2, 4)
-#error "*******************************************************"
-#error "Sorry, this driver needs kernel version 2.2.4 or higher"
-#error "*******************************************************"
-#endif
 
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kmod.h>
 #include <linux/sched.h>
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-#include <linux/wrapper.h>
-#endif
 #include <linux/errno.h>
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0)
-#include "../drivers/char/bttv.h"
-#include "../drivers/char/bttvp.h"
-#elif LINUX_VERSION_CODE < KERNEL_VERSION(2,6,17)
-#include "../drivers/media/video/bttv.h"
-#include "../drivers/media/video/bttvp.h"
-#else
 #include "../drivers/media/video/bt8xx/bttv.h"
 #include "../drivers/media/video/bt8xx/bttvp.h"
-#endif
 
 #if BTTV_VERSION_CODE < KERNEL_VERSION(0,7,45)
 #error "*******************************************************"
Index: lirc-0.8.1/drivers/lirc_i2c/lirc_i2c.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_i2c/lirc_i2c.c
+++ lirc-0.8.1/drivers/lirc_i2c/lirc_i2c.c
@@ -360,15 +360,10 @@ static int ir_probe(struct i2c_adapter *
 static int ir_command(struct i2c_client *client, unsigned int cmd, void *arg);
 
 static struct i2c_driver driver = {
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 16)
-        name:           "i2c ir driver",
-        flags:          I2C_DF_NOTIFY,
-#else
 	.driver = {
 		owner:  THIS_MODULE,
 		name:   "i2c ir driver",
 	},
-#endif
         id:             I2C_DRIVERID_EXP3, /* FIXME */
         attach_adapter: ir_probe,
         detach_client:  ir_detach,
