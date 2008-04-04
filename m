Return-Path: <linux-kernel-owner+w=401wt.eu-S1760097AbYDDUS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097AbYDDUS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 16:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbYDDUSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 16:18:14 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:25398 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097AbYDDURz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 16:17:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GtKW0hMk9a+59UD1gAI+iVQo6awZvYOiZYb4vnS3ToGJAVy6Et55kFgg+qD+0DXnv6E4OC4OgytoPfEhoV7AHh2npTzx+WmhxmN2LulkqUlRDz60ZsLtUWtXvfKTTsgPhgtlHbrzMN/rpgJ8/L8oSRYCK3Z+LQbo2WhIzslLqQ8=
Message-ID: <47F68CA0.7090007@gmail.com>
Date: Fri, 04 Apr 2008 22:16:32 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       linux-usb@vger.kernel.org
Subject: usb unbind/bind => WARNING at fs/sysfs/dir.c [Was: 2.6.25-rc8-mm1]
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
In-Reply-To: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2008 06:32 AM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm1/

After
$ echo -n 4-1.2 >/sys/bus/usb/drivers/usb/unbind
$ echo -n 4-1.2 >/sys/bus/usb/drivers/usb/bind

I have this in logs:

sysfs: duplicate filename 'usbdev4.12_ep81' can not be created
------------[ cut here ]------------
WARNING: at /home/l/latest/xxx/fs/sysfs/dir.c:425 sysfs_add_one+0x99/0xc0()
Modules linked in: usbhid hid nls_cp437 vfat fat usb_storage tun bitrev ipv6 
arc4 ecb crypto_blkcipher cryptomgr crypto_algapi ath5k mac80211 sr_mod crc32 
ohci1394 rtc_cmos cfg80211 ieee1394 floppy rtc_core ehci_hcd rtc_lib ff_memless 
cdrom [last unloaded: hid]
Pid: 539, comm: bash Tainted: G        W 2.6.25-rc8-mm1_64 #395

Call Trace:
  [<ffffffff8022f07f>] warn_on_slowpath+0x5f/0x80
  [<ffffffff80230197>] ? printk+0x67/0x70
  [<ffffffff802d9bd0>] ? sysfs_ilookup_test+0x0/0x20
  [<ffffffff802a12e8>] ? ifind+0x58/0xc0
  [<ffffffff802d9bd0>] ? sysfs_ilookup_test+0x0/0x20
  [<ffffffff802d9f49>] sysfs_add_one+0x99/0xc0
  [<ffffffff802daf68>] sysfs_create_link+0xa8/0x130
  [<ffffffff8038ebda>] device_add+0x2aa/0x4d0
  [<ffffffff80310c26>] ? kobject_init+0x36/0x80
  [<ffffffff8038ee19>] device_register+0x19/0x20
  [<ffffffff803dbbec>] usb_create_ep_files+0x19c/0x320
  [<ffffffff803dadb3>] usb_create_sysfs_intf_files+0xd3/0x100
  [<ffffffff803d630c>] usb_set_configuration+0x3ac/0x5f0
  [<ffffffff803df81a>] generic_probe+0x7a/0xb0
  [<ffffffff803d83fa>] usb_probe_device+0x3a/0x40
  [<ffffffff80390ceb>] driver_probe_device+0x9b/0x1a0
  [<ffffffff803901b3>] driver_bind+0xb3/0x100
  [<ffffffff8038f8a7>] drv_attr_store+0x27/0x30
  [<ffffffff802d94ab>] sysfs_write_file+0xeb/0x140
  [<ffffffff8028cc57>] vfs_write+0xc7/0x170
  [<ffffffff8028d2f0>] sys_write+0x50/0x90
  [<ffffffff8020b5eb>] system_call_after_swapgs+0x7b/0x80

---[ end trace 6ee6d593d4e510b4 ]---




I think, this is a 2.6.25-rc5-mm1 regression, there
while :; do
   echo -n 4-1.2 >/sys/bus/usb/drivers/usb/unbind
   echo -n 4-1.2 >/sys/bus/usb/drivers/usb/bind
   usleep 10000
done
went just fine for about 2000 times. Also real disconnect/connect works just 
fine (on disconnect the link disappears). Do you need kobject debug output?




The dir looks like:
...
usbdev4.10_ep83 -> 
../../devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.3/4-1.3:1.0/usb_endpoint/usbdev4.10_ep83
usbdev4.12_ep81 -> 
../../devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.2/4-1.2:1.0/usb_endpoint/usbdev4.12_ep81

^^^^
this is the unbound, the link is broken, there is no such device even after 
binding it back.

usbdev4.1_ep00 -> 
../../devices/pci0000:00/0000:00:1d.0/usb4/usb_endpoint/usbdev4.1_ep00
usbdev4.1_ep81 -> 
../../devices/pci0000:00/0000:00:1d.0/usb4/4-0:1.0/usb_endpoint/usbdev4.1_ep81
usbdev4.5_ep00 -> 
../../devices/pci0000:00/0000:00:1d.0/usb4/4-1/usb_endpoint/usbdev4.5_ep00
...


The device is:
Bus 004 Device 012: ID 045e:00f0 Microsoft Corp.
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         8
   idVendor           0x045e Microsoft Corp.
   idProduct          0x00f0
   bcdDevice            1.01
   iManufacturer           1 Microsoft Corporation
   iProduct                2 Microsoft � Laser Mouse 6000
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           34
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              100mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         3 Human Interface Devices
       bInterfaceSubClass      1 Boot Interface Subclass
       bInterfaceProtocol      2 Mouse
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.11
           bCountryCode           33 US
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength      59
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval              10
Device Status:     0x0000
   (Bus Powered)
