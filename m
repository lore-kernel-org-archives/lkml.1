Return-Path: <linux-kernel-owner+w=401wt.eu-S933783AbZKXSAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783AbZKXSAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933772AbZKXSAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:00:50 -0500
Received: from h3281.serverkompetenz.net ([81.169.158.52]:57444 "EHLO
	h3281.serverkompetenz.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933770AbZKXSAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:00:45 -0500
Message-ID: <4B0C1F41.2060101@hillier.de>
Date: Tue, 24 Nov 2009 19:00:33 +0100
From: Gernot Hillier <gernot@hillier.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Matthias Urlichs <smurf@smurf.noris.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support for Mobilcom Debitel USB UMTS Surf-Stick
 to option driver
References: <4B08F18C.3040904@hillier.de> <200911220920.16717.oliver@neukum.org>
In-Reply-To: <200911220920.16717.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Oliver Neukum schrieb:
> Am Sonntag, 22. November 2009 09:08:44 schrieb Gernot Hillier:
>> In addition, this device seems to ignore setting of RTS/DTR by option_send_
>> setup and doesn't answer the usb_control_msg leading to a 5 s timeout
>> (USB_CTRL_SET_TIMEOUT) in userspace open() and other operations. As this
>> confused several impatient userspace applications like Minicom and
>>  ModemManager, I decided to reduce the timeout to more reasonable 1000 ms.
>>  I don't think the usual USB GSM stick needs longer, so this should be
>>  safe.
> 
> Unfortunately the 5s timeout comes from the USB spec for control
> messages. So reducing it is a serious matter. In this case I'd prefer
> if you introduce a special case for these devices and fail the operation
> without doing any IO.

Thanks for the answer and suggestion. I looked into that - but 
unfortunately (again), it isn't that easy. The device accepts the 
option_set_setup triggered control message on *one* of its three 
interfaces while it silently ignores it on the other two. :-(

I do see /dev/ttyUSB[0-2] - and on /dev/ttyUSB2, everything works as 
expected (i.e. the control message *is* handled correctly) while ttyUSB0 
and ttyUSB1 exhibit this strange timeout issue.

As you might have expected, I have no detailed spec about the device 
which could explain this. I can only say that the device reacts on AT 
commands on ttyUSB1 and ttyUSB2 while ttyUSB0 seems to serve other purposes.

What do you think - shall I disable sending the usb control message 
depending on bInterfaceNumber? Any better ideas?

Here's the "lsusb -v" output in case this helps:

Bus 002 Device 007: ID 1c9e:9603
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x1c9e
   idProduct          0x9603
   bcdDevice            0.00
   iManufacturer           2 USB Modem
   iProduct                1 Modem Configuration
   iSerial                 3 1234567890ABCDEF
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength          108
     bNumInterfaces          4
     bConfigurationValue     1
     iConfiguration          1 Modem Configuration
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower              500mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass    255 Vendor Specific Subclass
       bInterfaceProtocol    255 Vendor Specific Protocol
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval              32
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval              32
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass    255 Vendor Specific Subclass
       bInterfaceProtocol    255 Vendor Specific Protocol
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval              32
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval              32
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       0
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass    255 Vendor Specific Subclass
       bInterfaceProtocol    255 Vendor Specific Protocol
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               5
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval              32
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval              32
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        3
       bAlternateSetting       0
       bNumEndpoints           2
       bInterfaceClass         8 Mass Storage
       bInterfaceSubClass      6 SCSI
       bInterfaceProtocol     80 Bulk (Zip)
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x04  EP 4 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x85  EP 5 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0000
   (Bus Powered)

--
Gernot
