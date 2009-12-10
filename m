Return-Path: <linux-kernel-owner+w=401wt.eu-S1760928AbZLJPkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928AbZLJPkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 10:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZLJPkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 10:40:05 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:43529 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751830AbZLJPkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 10:40:03 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
Date: Thu, 10 Dec 2009 16:40:02 +0100
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0912041427550.3070-100000@iolanthe.rowland.org> <200912071607.38351.linux@rainbow-software.org>
In-Reply-To: <200912071607.38351.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912101640.02897.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 December 2009, Ondrej Zary wrote:
> On Friday 04 December 2009, Alan Stern wrote:
> > > With uhci_hcd, rmmod works fine. With ehci_hcd, rmmod hangs the bus -
> > > all urbs fail with -ENOENT:
> > > f67265e8 1428021080 S Bi:1:009:2 -115 128 <
> > > f67265e8 1431508327 C Bi:1:009:2 -108 0
> > > f6726718 1458252464 S Co:1:007:0 s 40 09 0001 0000 0000 0
> > > f6726718 1463261404 C Co:1:007:0 -2 0
> > > f6726978 1463261428 S Co:1:002:0 s 23 08 0070 0001 0000 0
> > > f6726718 1463261509 S Co:1:007:0 s 40 00 0000 0000 0000 0
> > > f6726978 1464273397 C Co:1:002:0 -2 0
> > > f6726718 1468273397 C Co:1:007:0 -2 0
> >
> > This may be a bug in ehci-hcd, a bug in your EHCI hardware, or a bug in
> > the hub.  Can you try using a different high-speed hub to see if it
> > makes any difference?
>
> Just tried another hub. Now there are two hubs connected to separate ports
> on the machine. Nexio is the only device connected to the "new" hub. No
> matter where I connect the device or the 2nd hub, it always appears on "Bus
> 001":
>
> Bus 002 Device 002: ID 041e:4068 Creative Technology, Ltd Webcam Live!
> Notebook Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 003 Device 002: ID 413c:2003 Dell Computer Corp. Keyboard
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 002: ID 0bda:0158 Realtek Semiconductor Corp. USB 2.0
> multicard reader Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root
> hub
> Bus 001 Device 010: ID 1870:0001 Nexio Co., Ltd iNexio Touchscreen
> controller Bus 001 Device 009: ID 088c:2030 Swecoin AB Ticket Printer TTP
> 2030 Bus 001 Device 008: ID 0403:6001 Future Technology Devices
> International, Ltd FT232 USB-Serial (UART) IC Bus 001 Device 007: ID
> 065a:0001 Optoelectronics Co., Ltd Barcode scanner Bus 001 Device 002: ID
> 2001:f103 D-Link Corp. [hex] DUB-H7 7-port USB 2.0 hub Bus 001 Device 001:
> ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 001 Device 005: ID 04cc:1521 Philips Semiconductors USB 2.0 Hub
>
> The problem is still the same. Removing the module causes devices on the
> other hub to fail.
>
> Disconnecting the touchscreen first and then removing the module does not
> cause any problems (with either of the hubs) - so it must be a software
> problem.

Narrowed down the code to this 170-line module which reproduces my
"rmmod usbtouchscreen" problem. Loading this module causes EHCI to fail.
Looks like it fails after calling usb_kill_urb(). Can a buggy device cause
this?

#define DEBUG

#include <linux/kernel.h>
#include <linux/slab.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/usb.h>

struct crashnexio_usb {
	unsigned char *data;
	dma_addr_t data_dma;
	struct urb *irq;
	struct usb_interface *interface;
};

static struct usb_device_id crashnexio_devices[] = {
	{USB_DEVICE_AND_INTERFACE_INFO(0x1870, 0x0001, 0x0a, 0x00, 0x00)},
	{}
};

#define NEXIO_TIMEOUT	5000
#define NEXIO_BUFSIZE	1024
#define NEXIO_THRESHOLD	50
#define NEXIO_REPT_SIZE 128

static unsigned char nexio_init_pkt[4] = { 0x82, 0x04, 0x0a, 0x0f };

static int nexio_init(struct crashnexio_usb *crashnexio)
{
	struct usb_device *dev = interface_to_usbdev(crashnexio->interface);
	int ret = -ENOMEM;
	int actual_len;
	unsigned char *buf;
	int input_ep = 0x82, output_ep = 0x01;

	printk("%s\n", __func__);

	buf = kmalloc(NEXIO_BUFSIZE, GFP_KERNEL);
	if (!buf)
		goto out_buf;
	/* send init command */
	memcpy(buf, nexio_init_pkt, sizeof(nexio_init_pkt));
	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, output_ep),
			   buf, sizeof(nexio_init_pkt), &actual_len,
			   NEXIO_TIMEOUT);
	if (ret < 0)
		goto out_buf;
	/* read reply */
	memset(buf, 0, NEXIO_BUFSIZE);
	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, input_ep),
			   buf, NEXIO_BUFSIZE, &actual_len,
			   NEXIO_TIMEOUT);
out_buf:
	kfree(buf);
	return ret;
}

static void crashnexio_irq(struct urb *urb)
{
	int retval;

	printk("%s\n", __func__);

	switch (urb->status) {
	case 0:
		/* success */
		break;
	case -ETIME:
		/* this urb is timing out */
		dbg("%s - urb timed out - was the device unplugged?",
		    __func__);
		return;
	case -ECONNRESET:
	case -ENOENT:
	case -ESHUTDOWN:
	case -EPIPE:
		/* this urb is terminated, clean up */
		dbg("%s - urb shutting down with status: %d",
		    __func__, urb->status);
		return;
	default:
		dbg("%s - nonzero urb status received: %d",
		    __func__, urb->status);
		goto exit;
	}

exit:
	retval = usb_submit_urb(urb, GFP_ATOMIC);
	if (retval)
		err("%s - usb_submit_urb failed with result: %d",
		    __func__, retval);
}

static int crashnexio_probe(struct usb_interface *intf,
			  const struct usb_device_id *id)
{
	struct crashnexio_usb *crashnexio;
	struct usb_host_interface *interface;
	struct usb_endpoint_descriptor *endpoint = NULL;
	struct usb_device *udev = interface_to_usbdev(intf);
	int err = -ENOMEM;
	int i;

	printk("%s\n", __func__);

	interface = intf->cur_altsetting;
	/* find first input endpoint */
	for (i = 0; i < interface->desc.bNumEndpoints; i++)
		if (usb_endpoint_dir_in(&interface->endpoint[i].desc)) {
			endpoint = &interface->endpoint[i].desc;
			break;
		}
	if (!endpoint)
		return -ENXIO;

	crashnexio = kzalloc(sizeof(struct crashnexio_usb), GFP_KERNEL);
	if (!crashnexio)
		goto out_free;

	crashnexio->data = usb_buffer_alloc(udev, NEXIO_REPT_SIZE,
	                                  GFP_KERNEL, &crashnexio->data_dma);
	if (!crashnexio->data)
		goto out_free;

	crashnexio->irq = usb_alloc_urb(0, GFP_KERNEL);
	if (!crashnexio->irq) {
		dbg("%s - usb_alloc_urb failed: crashnexio->irq", __func__);
		goto out_free_buffers;
	}

	crashnexio->interface = intf;

	usb_fill_bulk_urb(crashnexio->irq, udev,
			 usb_rcvintpipe(udev, endpoint->bEndpointAddress),
			 crashnexio->data, NEXIO_REPT_SIZE,
			 crashnexio_irq, crashnexio);

	usb_set_intfdata(intf, crashnexio);

	nexio_init(crashnexio);

	usb_submit_urb(crashnexio->irq, GFP_KERNEL);
	/* This will crash all EHCI communication */
	usb_kill_urb(crashnexio->irq);

	return 0;

out_free_buffers:
	usb_buffer_free(udev, NEXIO_REPT_SIZE, crashnexio->data, crashnexio->data_dma);
out_free:
	kfree(crashnexio);
	return err;
}

MODULE_DEVICE_TABLE(usb, crashnexio_devices);

static struct usb_driver crashnexio_driver = {
	.name		= "crashnexio",
	.probe		= crashnexio_probe,
	.id_table	= crashnexio_devices,
};

static int __init crashnexio_init(void)
{
	return usb_register(&crashnexio_driver);
}

module_init(crashnexio_init);

MODULE_LICENSE("GPL");



dmesg when loaded:
[   29.504260] usb 1-1.7: New USB device found, idVendor=1870, idProduct=0001
[   29.504277] usb 1-1.7: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   29.504290] usb 1-1.7: Product: iNexio USB
[   29.504299] usb 1-1.7: Manufacturer: iNexio
[   29.504529] usb 1-1.7: configuration #1 chosen from 1 choice
[   29.783276] crashnexio_probe
[   29.783289] nexio_init
[   29.783941] crashnexio_irq
[   29.783954] drivers/input/touchscreen/crashnexio.c: crashnexio_irq - urb shutting down with status: -2
[   29.784123] usbcore: registered new interface driver crashnexio
[   46.328105] ftdi_sio ttyUSB0: Unable to write latency timer: -110
...more USB errors


usbmon output:
f60f1d40 1250266541 S Ci:1:009:0 s 80 06 0100 0000 0012 18 <
f60f1d40 1250266801 C Ci:1:009:0 0 18 = 12011001 02000008 70180100 00010102 0301
f60f1d40 1250266844 S Ci:1:009:0 s 80 06 0200 0000 0009 9 <
f60f1d40 1250267057 C Ci:1:009:0 0 9 = 09024300 020100c0 fa
f60f1d40 1250267107 S Ci:1:009:0 s 80 06 0200 0000 0043 67 <
f60f1d40 1250267423 C Ci:1:009:0 0 67 = 09024300 020100c0 fa090400 00010202 00000524 00100104 24020005 24060001
f60f1d40 1250267478 S Ci:1:009:0 s 80 06 0300 0000 00ff 255 <
f60f1d40 1250267673 C Ci:1:009:0 0 6 = 06030904 1204
f60f1d40 1250267734 S Ci:1:009:0 s 80 06 0302 0409 00ff 255 <
f60f1d40 1250267923 C Ci:1:009:0 0 22 = 16036900 4e006500 78006900 6f002000 55005300 4200
f60f1d40 1250267984 S Ci:1:009:0 s 80 06 0301 0409 00ff 255 <
f60f1d40 1250268171 C Ci:1:009:0 0 14 = 0e036900 4e006500 78006900 6f00
f60f1d40 1250268217 S Ci:1:009:0 s 80 06 0303 0409 00ff 255 <
f60f1d40 1255266704 C Ci:1:009:0 -2 0
f60f1d40 1255266822 S Ci:1:009:0 s 80 06 0303 0409 0002 2 <
f60f1c40 1255266840 S Co:1:002:0 s 23 08 8090 0001 0000 0
f60f1c40 1255266930 C Co:1:002:0 0 0
f6527c40 1259050204 S Bo:1:004:1 -115 31 = 55534243 24000000 00000000 00000600 00000000 00000000 00000000 000000
f6527c40 1259050331 C Bo:1:004:1 0 31 >
f6527c40 1259050351 S Bi:1:004:2 -115 13 <
f6527c40 1259050936 C Bi:1:004:2 0 13 = 55534253 24000000 00000000 01
f6527c40 1259050962 S Bo:1:004:1 -115 31 = 55534243 25000000 12000000 80000603 00000012 00000000 00000000 000000
f6527c40 1259051073 C Bo:1:004:1 0 31 >
f64b1f40 1259051111 S Bi:1:004:2 -115 18 <
f64b1f40 1259051960 C Bi:1:004:2 0 18 = 70000200 0000000a 00000000 3a000000 0000
f6527c40 1259052025 S Bi:1:004:2 -115 13 <
f6527c40 1259052320 C Bi:1:004:2 0 13 = 55534253 25000000 00000000 00
f6527c40 1259052471 S Bo:1:004:1 -115 31 = 55534243 26000000 00000000 00000600 00000000 00000000 00000000 000000
f6527c40 1259052573 C Bo:1:004:1 0 31 >
f6527c40 1259052605 S Bi:1:004:2 -115 13 <
f6527c40 1259053074 C Bi:1:004:2 0 13 = 55534253 26000000 00000000 01
f6527c40 1259053116 S Bo:1:004:1 -115 31 = 55534243 27000000 12000000 80000603 00000012 00000000 00000000 000000
f6527c40 1259053186 C Bo:1:004:1 0 31 >
f64b1f40 1259053227 S Bi:1:004:2 -115 18 <
f64b1f40 1259054208 C Bi:1:004:2 0 18 = 70000200 0000000a 00000000 3a000000 0000
f6527c40 1259054264 S Bi:1:004:2 -115 13 <
f6527c40 1259054561 C Bi:1:004:2 0 13 = 55534253 27000000 00000000 00
f60f1d40 1260266607 C Ci:1:009:0 -2 0
f60f1d40 1260266987 S Co:1:009:0 s 00 09 0001 0000 0000 0
f60f1c40 1260267046 S Co:1:002:0 s 23 08 8090 0001 0000 0
f60f1c40 1260267201 C Co:1:002:0 0 0
f60f1d40 1260267449 C Co:1:009:0 0 0
f60f1d40 1260267925 S Ci:1:002:0 s a3 00 0000 0007 0004 4 <


-- 
Ondrej Zary
