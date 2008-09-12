Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbYILRg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbYILRg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 13:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbYILRgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 13:36:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37746 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753167AbYILRgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 13:36:49 -0400
Date: Fri, 12 Sep 2008 13:36:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
       <bogdano@mandriva.com.br>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Subject: Re: Partition check considered as error is breaking mounting in
 2.6.27
In-Reply-To: <200809121401.40158.herton@mandriva.com.br>
Message-ID: <Pine.LNX.4.44L0.0809121316460.13261-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008, Herton Ronaldo Krzesinski wrote:

> Hi,
> 
> Recently I found a problem with a buggy camera that doesn't mount anymore with 
> 2.6.27 (its memory is available via usb-storage), since commit 
> 04ebd4aee52b06a2c38127d9208546e5b96f3a19
> 
> The camera is an Olympus X-840. The original issue comes from the camera 
> itself: its format program creates a partition with an off by one error, 
> while the device reports that its memory has 42079 sectors, the partition 
> table reports also that the only partition on the disk has the size of 42079, 
> but it fails to account for the first sector in the memory that contains the 
> partition table, so in the end the partition exceeds the limit of the device 
> size (42080, first sector plus 42079 from the first partition).
> 
> In previous kernels (2.6.26 and before), I still could mount and access the 
> device (/dev/sdb1), although with the following errors:
> 
> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>  sdb: sdb1
>  sdb: p1 exceeds device capacity
> sd 6:0:0:0: [sdb] Attached SCSI removable disk
> sd 6:0:0:0: Attached scsi generic sg2 type 0
> usb-storage: device scan complete
> attempt to access beyond end of device
> sdb: rw=0, want=42080, limit=42079
> __ratelimit: 16 messages suppressed
> Buffer I/O error on device sdb1, logical block 42078
> attempt to access beyond end of device
> sdb: rw=0, want=42080, limit=42079
> 
> If you note the log snippet above the first notable thing is "p1 exceeds 
> device capacity", so looking at commit 
> 04ebd4aee52b06a2c38127d9208546e5b96f3a19 it is clear why sdb1 isn't created 
> anymore.
> 
> After formatting the camera is this you get from fdisk (display units in 
> sectors):
> 
> Disk /dev/sdb: 21 MB, 21544448 bytes
> 6 heads, 16 sectors/track, 438 cylinders, total 42079 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Disk identifier: 0x00000000
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1   *           1       42079       21039+   1  FAT12
> Partition 1 has different physical/logical endings:
>      phys=(328, 5, 16) logical=(438, 1, 16)
> 
> Note the bogus reported CHS values, both physical and logical, but they don't 
> affect anything here.
> 
> I don't know if this change of behaviour in 2.6.27 is desired (not creating 
> partition nodes if its size exceeds media size).

I have to believe that it _is_ desired.  Why else would that commit 
have been merged?

And why didn't you CC: the author of that commit?

> Anyway the device is buggy 
> itself. Until now the only way I found to mount device inside 2.6.27 is using 
> hexedit to edit directly the partition table on the device, decreasing by 1 
> the length of the first partition (42079 -> 42078). Clearing the partition 
> table and using fdisk to partition again is not an option, the camera 
> firmware seems to be lost after this, it starts to report weird media size 
> (not by 1 sector error only):

Why clear the partition table?  Just replace the bogus entry with a 
correct entry.  (Although using hexedit may be easier...)

> attempt to access beyond end of device
> sdb: rw=0, want=42042, limit=42000
> attempt to access beyond end of device
> sdb: rw=0, want=42042, limit=42000
> 
> Disk /dev/sdb: 21 MB, 21504000 bytes
> 1 heads, 42 sectors/track, 1000 cylinders, total 42000 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Disk identifier: 0x57ea65f0
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1              42       42041       21000    1  FAT12

This doesn't resemble the original partition table at all.  Did you 
create this strange table or did the camera's firmware change the data 
you entered?

> (after zeroing out the partition table I only run fdisk on the device, created 
> the a new partition with maximum size allowed and change the type to FAT12)

That is not a valid procedure.  You have to go into Expert mode and set 
the number of sectors, heads, and tracks first.  Most likely you'll 
want to set them to the same values used by the firmware; it looks like 
the firmware thinks there are 16 sectors/track, 8 heads, and 329 
tracks.

> On both cases respectively this is relevant info that I get with usb-storage 
> debugging turned on:
> 
> * With memory formatted by camera firmware:
> usb-storage: queuecommand called
> usb-storage: *** thread awakened.
> usb-storage: Command READ_CAPACITY (10 bytes)
> usb-storage:  25 00 00 00 00 00 00 00 00 00
> usb-storage: Bulk Command S 0x43425355 T 0x3 L 8 F 128 Trg 0 LUN 0 CL 10
> usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> usb-storage: Status code 0; transferred 31/31
> usb-storage: -- transfer complete
> usb-storage: Bulk command transfer result=0
> usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
> usb-storage: Status code 0; transferred 8/8
> usb-storage: -- transfer complete
> usb-storage: Bulk data transfer result 0x0
> usb-storage: Attempting to get CSW...
> usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> usb-storage: Status code 0; transferred 13/13
> usb-storage: -- transfer complete
> usb-storage: Bulk status result = 0
> usb-storage: Bulk Status S 0x53425355 T 0x3 R 0 Stat 0x0
> usb-storage: scsi cmd done, result=0x0
> usb-storage: *** thread sleeping.
> sd 4:0:0:0: [sdb] 42079 512-byte hardware sectors (22 MB)
> 
> * With partition table recreated with fdisk and formated by hand:
> usb-storage: queuecommand called
> usb-storage: *** thread awakened.
> usb-storage: Command READ_CAPACITY (10 bytes)
> usb-storage:  25 00 00 00 00 00 00 00 00 00
> usb-storage: Bulk Command S 0x43425355 T 0x3 L 8 F 128 Trg 0 LUN 0 CL 10
> usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> usb-storage: Status code 0; transferred 31/31
> usb-storage: -- transfer complete
> usb-storage: Bulk command transfer result=0
> usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
> usb-storage: Status code 0; transferred 8/8
> usb-storage: -- transfer complete
> usb-storage: Bulk data transfer result 0x0
> usb-storage: Attempting to get CSW...
> usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> usb-storage: Status code 0; transferred 13/13
> usb-storage: -- transfer complete
> usb-storage: Bulk status result = 0
> usb-storage: Bulk Status S 0x53425355 T 0x3 R 0 Stat 0x0
> usb-storage: scsi cmd done, result=0x0
> usb-storage: *** thread sleeping.
> sd 6:0:0:0: [sdb] 42000 512-byte hardware sectors (22 MB)

If you don't mind losing 79 sectors, you could just live with this.

> After looking at all this I'm in doubt on what fix could be made in this case. 
> May be reverting the fatal error when partition exceeds media size? Or adding 
> a new usb-storage quirk to report media size with one more sector (dangerous, 
> but physically I don't know what's the real media size as firmware reports a 
> way different value of media size after using fdisk), or quirk to force 
> something in partition creation to automatically trim partition size by -1.
> 
> Any ideas?

Adding quirks to alter partition sizes sounds very dangerous.  Your 
best bet is simply to write a valid partition table.

Alan Stern

