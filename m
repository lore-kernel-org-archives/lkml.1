Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbXKARbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbXKARbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbXKARbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:31:11 -0400
Received: from smtp105.biz.mail.mud.yahoo.com ([68.142.200.253]:22758 "HELO
	smtp105.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750897AbXKARbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:31:09 -0400
X-YMail-OSG: 4qo6hSYVM1n5sUzDuEr2dlW7O3C75363eWbHTUolXdqeooF_5R0jiPlH_GIb5hzYQpYxK7dY3Q--
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] ti_usb_3410_5052 breakage in 2.6.24-rc1
Date: Thu, 1 Nov 2007 10:31:04 -0700
User-Agent: KMail/1.9.7
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       linux-usb-devel@lists.sourceforge.net
References: <Pine.LNX.4.44L0.0711011049140.4146-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0711011049140.4146-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711011031.04620.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2007 7:51:25 Alan Stern wrote:
> On Thu, 1 Nov 2007, Steven King wrote:
> > Per a suggestion by David Brownwell, rebuilt with CONFIG_USB_DEBUG
> > enabled and loading usbserial and ti_usb_3410_5052 with debug=1, I see in
> > 'dmesg'
> >
> > 'drivers/usb/serial/usb-serial.c: wrong number of endpoints'
> >
> >  which is pretty much what I expected, throwing some more printk's in
> > usb-serial gives:
> >
> > drivers/usb/serial/usb-serial.c: num_interrupt_in = 0, expected 1
> > drivers/usb/serial/usb-serial.c: num_interrupt_out = 0, expected 0
> > drivers/usb/serial/usb-serial.c: num_bulk_in = 0, expected 1
> > drivers/usb/serial/usb-serial.c: num_bulk_out = 1, expected 1
> >
> > Okay, so
> > ---
> >
> > Changing num_interrupt_in and num_bulk_in from 1 to NUM_DONT_CARE makes
> > ti_usb_3410_5052 work again, but is it the right thing to do?
>
> It may or may not be the right thing to do, but it definitely isn't
> the correct way to solve your problem.
>
> The real question is why 2.6.24-rc1 doesn't like the second
> configuration descriptor.  To answer it, you should see what shows up
> in the dmesg log when you first plug in the device on a kernel with
> CONFIG_USB_DEBUG enabled.

?!? As I wrote at the top of the message you quoted, I rebuilt with 
CONFIG_USB_DEBUG enabled and loaded the modules with debug=1, thats how I was 
able to see the 'wrong number of endpoints' message.

Given that the dongle works correctly with a stock 2.6.24-rc1 with commit 
063a2da8f01806906f7d7b1a1424b9afddebc443 reversed, I'm reasonably confident 
that with that commit in place, the usb core is working correctly (or atleast 
as expected) in initially parsing the device descriptor, then usb-serial 
attempts to match the interface descriptor on the first configuration, and 
using the new more strict matching code, fails when the device reports for 
the only interface on the first configuration it has only a single bulk_out 
endpoint while the ti_usb_3410_5052 driver is expecting an interrupt_in and a 
bulk_in.  It never gets to the second configuration descriptor.

#2.6.23.1 lsusb -vvv:

Bus 007 Device 005: ID 0451:f430 Texas Instruments, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x0451 Texas Instruments, Inc.
  idProduct          0xf430 
  bcdDevice            1.01
  iManufacturer           1 Texas Instruments
  iProduct                2 MSP-FET430UIF JTAG Tool
  iSerial                 3 TUSB341010398282E658FFD7
  bNumConfigurations      2
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
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
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     2
    iConfiguration          0 
    bmAttributes         0xa0
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
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
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval               1

#2.6.24-rc1 lsusb -vvv

Bus 007 Device 004: ID 0451:f430 Texas Instruments, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x0451 Texas Instruments, Inc.
  idProduct          0xf430 
  bcdDevice            1.01
  iManufacturer           1 Texas Instruments
  iProduct                2 MSP-FET430UIF JTAG Tool
  iSerial                 3 TUSB341010398282E658FFD7
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
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

for me the only question is whether ti_usb_3410_5052 should 
have .num_interrupt_in and .num_bulk_in set to NUM_DONT_CARE or set to 0.
Are there versions of the dongle that have different device descriptors?  
Before I bricked (sticked?) my TI eZ430-rf2500 dongle, it reported a 
different idProduct even though as far as I can tell they are almost the 
exact same hardware, so that shouldnt be a problem...

-- 
Steven King -- sfking at fdwdc dot com
