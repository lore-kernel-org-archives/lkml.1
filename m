Return-Path: <linux-kernel-owner+w=401wt.eu-S1762210AbZLKTmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762210AbZLKTmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 14:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761823AbZLKTmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 14:42:09 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:39430 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761273AbZLKTmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 14:42:08 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
Date: Fri, 11 Dec 2009 20:42:00 +0100
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0912101525230.2680-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912101525230.2680-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 9358
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912112042.02228.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 December 2009, Alan Stern wrote:
> On Thu, 10 Dec 2009, Ondrej Zary wrote:
> > Narrowed down the code to this 170-line module which reproduces my
> > "rmmod usbtouchscreen" problem. Loading this module causes EHCI to fail.
> > Looks like it fails after calling usb_kill_urb(). Can a buggy device
> > cause this?
>
> I don't think so.  But I am getting an idea of what the problem might
> be.  Try applying the patch below and see if it makes any difference
> (make sure that CONFIG_USB_DEBUG is enabled).

Thank you very much for the patch. It seems to finally solve this long
thread!

I'm running 2.6.32 now (with usbtouchscreen copied from -next) so one hunk
had to be applied manually. With patch applied and CONFIG_USB_DEBUG enabled,
usbtouchscreen stopped working - the urb failed to submit. Return value of
usb_submit_urb() was not checked (and it wasn't my code this time :) Adding
a check revealed that the urb fails to submit with -EPIPE because of
endpoint vs. pipe mismatch.

Fixing that (see the patch below) solved the rmmod problem!

>
> If the module stops messing up EHCI, try changing the source code:
> > static int crashnexio_probe(struct usb_interface *intf,
> > 			  const struct usb_device_id *id)
> > {
>
> ...
>
> > 	interface = intf->cur_altsetting;
> > 	/* find first input endpoint */
> > 	for (i = 0; i < interface->desc.bNumEndpoints; i++)
> > 		if (usb_endpoint_dir_in(&interface->endpoint[i].desc)) {
> > 			endpoint = &interface->endpoint[i].desc;
> > 			break;
> > 		}
>
> Does the interface have more than one input endpoint?  (What does
> "lsusb -v" show for the Nexio?)  If it does, how do you know the
> endpoint you want is the first one?

No, there is only one input endpoint:
Bus 001 Device 009: ID 1870:0001 Nexio Co., Ltd iNexio Touchscreen controller
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            2 Communications
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x1870 Nexio Co., Ltd
  idProduct          0x0001 iNexio Touchscreen controller
  bcdDevice            1.00
  iManufacturer           1
  iProduct                2
  iSerial                 3
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           67
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xc0
      Self Powered
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass      2 Abstract (modem)
      bInterfaceProtocol      0 None
      iInterface              0
      CDC Header:
        bcdCDC               1.10
      CDC ACM:
        bmCapabilities       0x00
      CDC Union:
        bMasterInterface        0
        bSlaveInterface         1
      CDC Call Management:
        bmCapabilities       0x00
        bDataInterface          1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval             255
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0

>
> ...
>
> > 	usb_fill_bulk_urb(crashnexio->irq, udev,
> > 			 usb_rcvintpipe(udev, endpoint->bEndpointAddress),
>
> Either change this to usb_fill_int_urb() or else use usb_rcvbulkpipe().
>
> ...
>
> > static int __init crashnexio_init(void)
> > {
> > 	return usb_register(&crashnexio_driver);
> > }
>
> You should also have an __exit routine.

As I'm bad at writing cleanup functions and the purpose was to break EHCI,
the only exit was a reboot :)


--- linux-2.6.32/drivers/input/touchscreen/usbtouchscreen.5	2009-12-11 12:50:35.000000000 +0100
+++ linux-2.6.32/drivers/input/touchscreen/usbtouchscreen.c	2009-12-11 20:15:51.000000000 +0100
@@ -1375,10 +1375,16 @@
 		input_set_abs_params(input_dev, ABS_PRESSURE, type->min_press,
 		                     type->max_press, 0, 0);
 
-	usb_fill_int_urb(usbtouch->irq, udev,
+	if (usb_endpoint_type(endpoint) == USB_ENDPOINT_XFER_INT)
+		usb_fill_int_urb(usbtouch->irq, udev,
 			 usb_rcvintpipe(udev, endpoint->bEndpointAddress),
 			 usbtouch->data, type->rept_size,
 			 usbtouch_irq, usbtouch, endpoint->bInterval);
+	else
+		usb_fill_bulk_urb(usbtouch->irq, udev,
+			 usb_rcvbulkpipe(udev, endpoint->bEndpointAddress),
+			 usbtouch->data, type->rept_size,
+			 usbtouch_irq, usbtouch);
 
 	usbtouch->irq->dev = udev;
 	usbtouch->irq->transfer_dma = usbtouch->data_dma;


-- 
Ondrej Zary
