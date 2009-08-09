Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbZHIXr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbZHIXr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 19:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbZHIXr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 19:47:26 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:40250 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZHIXrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 19:47:25 -0400
Message-ID: <4A7F600A.6090901@gmail.com>
Date: Mon, 10 Aug 2009 02:47:22 +0300
From: Anssi Hannula <anssi.hannula@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090731)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Galtor <galtor@gmail.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: USBHID bug, claiming all devices, ignoring quirks.
References: <87d884f60908050123m4520f7e5o43fdd6d2c52137ca@mail.gmail.com> <4A7F3AAA.1040704@gmail.com>
In-Reply-To: <4A7F3AAA.1040704@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 08/05/2009 10:23 AM, Galtor wrote:
>> Hi all.
> 
> Hi, you should have posted this at least to the input mailing list.
> 
>> I have a Antec Veris USB IR receiver, with USB ID 15c2:0043,
>> identifying itself as "SoundGraph iMON MultiMedia IR/Display". Below
>> is the ls -vvv.
>>
>> In 2.6.30.4 kernel source this device is in hid_ignore_list[] :
>>
>> ... hid-core.c ...
>>  { HID_USB_DEVICE(USB_VENDOR_ID_SOUNDGRAPH,
>> USB_DEVICE_ID_SOUNDGRAPH_IMON_LCD3) },
>> ...
> 
> I see
> #define USB_DEVICE_ID_SOUNDGRAPH_IMON_LCD3      0x0034
> but you have 0x43.
> 
> I suppose it doesn't work with the generic hid driver?

If it is in any way similar to 0x0038 that I have (and looking at LIRC
driver, its likely), only partially. Some remote buttons get delivered
to the first interface as standard hid input events. However, others are
delivered to the second interface as vendor-defined reports.

>> But the usbhid is ignoring the list and claiming for the device:
>>
>> ...dmesg...
>> [ 3366.731928] usbcore: registered new interface driver hiddev
>> [ 3366.745603] input: HID 15c2:0043 as
>> /devices/pci0000:00/0000:00:04.0/usb3/3-3/3-3:1.0/input/input3
>> [ 3366.746195] generic-usb 0003:15C2:0043.000D: input,hidraw0: USB HID
>> v1.01 Mouse [HID 15c2:0043] on usb-0000:00:04.0-3/input0
>> [ 3366.759332] generic-usb 0003:15C2:0043.000E: hiddev96,hidraw1: USB
>> HID v1.00 Device [HID 15c2:0043] on usb-0000:00:04.0-3/input1
>> [ 3366.759416] usbcore: registered new interface driver usbhid
>> ...
>>
>> Using "quirks" module parameter changes the behavior in dmesg:
>>
>> ...dmesg...
>> [ 5180.060952] usbcore: registered new interface driver hiddev
>> [ 5180.061211] usbcore: registered new interface driver usbhid
>> [ 5180.061220] usbhid: v2.6:USB HID core driver
>> ...
>>
>> but the driver is claiming for the device anyway:
>>
>> ...ls /sys/bus/usb/drivers/usbhid/...
>> 3-3:1.0  3-3:1.1  bind  module  new_id  uevent  unbind
>> ...
>>
>> The only "fix" i have is to load the lirc_imon driver before the
>> usbhid driver to get all hardware correctly initialized
>>
>> Any ideas of what's happening?
>>
>> Best regards.
>>
>> -- Galtor
>>
>> -----------------------------------------------
>>
>> Bus 003 Device 002: ID 15c2:0043 SoundGraph Inc.
>> Device Descriptor:
>>   bLength                18
>>   bDescriptorType         1
>>   bcdUSB               1.10
>>   bDeviceClass            0 (Defined at Interface level)
>>   bDeviceSubClass         0
>>   bDeviceProtocol         0
>>   bMaxPacketSize0         8
>>   idVendor           0x15c2 SoundGraph Inc.
>>   idProduct          0x0043
>>   bcdDevice            0.02
>>   iManufacturer           0
>>   iProduct                0
>>   iSerial                 0
>>   bNumConfigurations      1
>>   Configuration Descriptor:
>>     bLength                 9
>>     bDescriptorType         2
>>     wTotalLength           59
>>     bNumInterfaces          2
>>     bConfigurationValue     1
>>     iConfiguration          0
>>     bmAttributes         0x80
>>       (Bus Powered)
>>     MaxPower              100mA
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        0
>>       bAlternateSetting       0
>>       bNumEndpoints           1
>>       bInterfaceClass         3 Human Interface Device
>>       bInterfaceSubClass      0 No Subclass
>>       bInterfaceProtocol      2 Mouse
>>       iInterface              0
>>       ** UNRECOGNIZED:  09 21 01 01 00 01 22 79 00
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x81  EP 1 IN
>>         bmAttributes            3
>>           Transfer Type            Interrupt
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0008  1x 8 bytes
>>         bInterval              10
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        1
>>       bAlternateSetting       0
>>       bNumEndpoints           1
>>       bInterfaceClass         3 Human Interface Device
>>       bInterfaceSubClass      0 No Subclass
>>       bInterfaceProtocol      0 None
>>       iInterface              0
>>       ** UNRECOGNIZED:  09 21 00 01 00 01 22 32 00
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x82  EP 2 IN
>>         bmAttributes            3
>>           Transfer Type            Interrupt
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0008  1x 8 bytes
>>         bInterval              10
>> Device Status:     0x0002
>>   (Bus Powered)
>>   Remote Wakeup Enabled
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Anssi Hannula
