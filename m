Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbYILQ47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbYILQ47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 12:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYILQ4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 12:56:39 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:59062 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818AbYILQ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 12:56:37 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: linux-kernel@vger.kernel.org
Subject: Partition check considered as error is breaking mounting in 2.6.27
Date: Fri, 12 Sep 2008 13:56:49 -0300
User-Agent: KMail/1.9.10
Cc: inux-usb@vger.kernel.org, bogdano@mandriva.com.br,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121356.50628.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently I found a problem with a buggy camera that doesn't mount anymore with 
2.6.27 (its memory is available via usb-storage), since commit 
04ebd4aee52b06a2c38127d9208546e5b96f3a19

The camera is an Olympus X-840. The original issue comes from the camera 
itself: its format program creates a partition with an off by one error, 
while the device reports that its memory has 42079 sectors, the partition 
table reports also that the only partition on the disk has the size of 42079, 
but it fails to account for the first sector in the memory that contains the 
partition table, so in the end the partition exceeds the limit of the device 
size (42080, first sector plus 42079 from the first partition).

In previous kernels (2.6.26 and before), I still could mount and access the 
device (/dev/sdb1), although with the following errors:

sd 6:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
 sdb: p1 exceeds device capacity
sd 6:0:0:0: [sdb] Attached SCSI removable disk
sd 6:0:0:0: Attached scsi generic sg2 type 0
usb-storage: device scan complete
attempt to access beyond end of device
sdb: rw=0, want=42080, limit=42079
__ratelimit: 16 messages suppressed
Buffer I/O error on device sdb1, logical block 42078
attempt to access beyond end of device
sdb: rw=0, want=42080, limit=42079

If you note the log snippet above the first notable thing is "p1 exceeds 
device capacity", so looking at commit 
04ebd4aee52b06a2c38127d9208546e5b96f3a19 it is clear why sdb1 isn't created 
anymore.

After formatting the camera is this you get from fdisk (display units in 
sectors):

Disk /dev/sdb: 21 MB, 21544448 bytes
6 heads, 16 sectors/track, 438 cylinders, total 42079 sectors
Units = sectors of 1 * 512 = 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1       42079       21039+   1  FAT12
Partition 1 has different physical/logical endings:
     phys=(328, 5, 16) logical=(438, 1, 16)

Note the bogus reported CHS values, both physical and logical, but they don't 
affect anything here.

I don't know if this change of behaviour in 2.6.27 is desired (not creating 
partition nodes if its size exceeds media size). Anyway the device is buggy 
itself. Until now the only way I found to mount device inside 2.6.27 is using 
hexedit to edit directly the partition table on the device, decreasing by 1 
the length of the first partition (42079 -> 42078). Clearing the partition 
table and using fdisk to partition again is not an option, the camera 
firmware seems to be lost after this, it starts to report weird media size 
(not by 1 sector error only):

attempt to access beyond end of device
sdb: rw=0, want=42042, limit=42000
attempt to access beyond end of device
sdb: rw=0, want=42042, limit=42000

Disk /dev/sdb: 21 MB, 21504000 bytes
1 heads, 42 sectors/track, 1000 cylinders, total 42000 sectors
Units = sectors of 1 * 512 = 512 bytes
Disk identifier: 0x57ea65f0

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1              42       42041       21000    1  FAT12

(after zeroing out the partition table I only run fdisk on the device, created 
the a new partition with maximum size allowed and change the type to FAT12)

On both cases respectively this is relevant info that I get with usb-storage 
debugging turned on:

* With memory formatted by camera firmware:
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command READ_CAPACITY (10 bytes)
usb-storage:  25 00 00 00 00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x3 L 8 F 128 Trg 0 LUN 0 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
usb-storage: Status code 0; transferred 8/8
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x3 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
sd 4:0:0:0: [sdb] 42079 512-byte hardware sectors (22 MB)

* With partition table recreated with fdisk and formated by hand:
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command READ_CAPACITY (10 bytes)
usb-storage:  25 00 00 00 00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x3 L 8 F 128 Trg 0 LUN 0 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
usb-storage: Status code 0; transferred 8/8
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x3 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
sd 6:0:0:0: [sdb] 42000 512-byte hardware sectors (22 MB)

After looking at all this I'm in doubt on what fix could be made in this case. 
May be reverting the fatal error when partition exceeds media size? Or adding 
a new usb-storage quirk to report media size with one more sector (dangerous, 
but physically I don't know what's the real media size as firmware reports a 
way different value of media size after using fdisk), or quirk to force 
something in partition creation to automatically trim partition size by -1.

Any ideas?

More info about the device, may be it's useful:

T:  Bus=03 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  2 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=07b4 ProdID=0109 Rev= 1.00
S:  Manufacturer=OLYMPUS
S:  Product=FE310,X840,C530
S:  SerialNumber=Y31013411
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms

Bus 003 Device 003: ID 07b4:0109 Olympus Optical Co., Ltd C-370Z/D-535Z/X-450
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x07b4 Olympus Optical Co., Ltd
  idProduct          0x0109 C-370Z/D-535Z/X-450
  bcdDevice            1.00
  iManufacturer           1 OLYMPUS
  iProduct                2 FE310,X840,C530
  iSerial                 3 Y31013411
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xc0
      Self Powered
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
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
Device Status:     0x0001
  Self Powered

-- 
[]'s
Herton
