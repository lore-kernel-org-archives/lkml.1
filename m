Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbXJUTBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbXJUTBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 15:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbXJUTBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 15:01:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:59200 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbXJUTBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 15:01:46 -0400
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0710192156460.23656-200000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0710192156460.23656-200000@netrider.rowland.org>
Content-Type: text/plain
Date: Sun, 21 Oct 2007 21:03:16 +0200
Message-Id: <1192993396.3661.1.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18S3ajVsg3hFrcgK1rRt6J+5YNf5/U1gwS4BoL
 xn0H6YNnFvPfwRvtck6ttovn85T024zJLud40LyABpkl3jCsvZ
 rtVxoK6Gyuml/Pn8YcC2MJdj8o6wPLS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-20 at 21:33 -0400, Alan Stern wrote: 
> On Sat, 20 Oct 2007, Kay Sievers wrote:
> 
> > Here is what I see, the error handler hangs without the final put and
> > the kobject never gets cleaned up. Note the missing:
> >   kobject sdb: cleaning up
> > 
> > What is your CONFIG_SYSFS_DEPRECATED option? I have it unset, and that
> > may be the difference in the behavior if you have it set.
> 
> It's unset in my config also.  No, the difference lies somewhere else.
> The plug-in parts are the same, but we differ in the remove parts.  On 
> your system, unlink_gendisk ends up dropping only one reference instead 
> of two.  This suggests that something strange is happening to the 
> request_queue on your machine.
> 
> Can you try running the attached patch (without the previous patch)?  
> It traces the various release routines.  The idea is that both the
> scsi_disk and the scsi_device hold references to the request_queue,
> and these references get dropped in their respective release routines.

Here is the output. I used a device with a partition now, like your
setup, but it's still the same difference to the behavior you see.
What's your event sequence?

Here is the output of "udevmonitor -k":

UEVENT[1192992135.385043] add      /devices/pci0000:00/0000:00:1d.7/usb2/2-2 (usb)
UEVENT[1192992135.385088] add      /devices/pci0000:00/0000:00:1d.7/usb2/2-2/usb_endpoint/usbdev2.7_ep00 (usb_endpoint)
UEVENT[1192992135.385244] add      /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0 (usb)
UEVENT[1192992135.385761] add      /class/scsi_host/host8 (scsi_host)
UEVENT[1192992135.386199] add      /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0/usb_endpoint/usbdev2.7_ep02 (usb_endpoint)
UEVENT[1192992135.386212] add      /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0/usb_endpoint/usbdev2.7_ep86 (usb_endpoint)
UEVENT[1192992135.386220] add      /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0/usb_endpoint/usbdev2.7_ep81 (usb_endpoint)
UEVENT[1192992140.387147] add      /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0/host8/target8:0:0/8:0:0:0 (scsi)
UEVENT[1192992140.387181] add      /class/scsi_disk/8:0:0:0 (scsi_disk)
UEVENT[1192992140.441760] add      /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0/host8/target8:0:0/8:0:0:0/block/sdb (block)
UEVENT[1192992140.441776] add      /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0/host8/target8:0:0/8:0:0:0/block/sdb/sdb1 (block)
UEVENT[1192992140.441785] add      /class/scsi_device/8:0:0:0 (scsi_device)
UEVENT[1192992140.441792] add      /class/scsi_generic/sg2 (scsi_generic)
UEVENT[1192992140.441800] add      /class/bsg/8:0:0:0 (bsg)

UEVENT[1192992143.163514] remove   /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0/usb_endpoint/usbdev2.7_ep02 (usb_endpoint)
UEVENT[1192992143.163529] remove   /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0/usb_endpoint/usbdev2.7_ep86 (usb_endpoint)
UEVENT[1192992143.163537] remove   /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0/usb_endpoint/usbdev2.7_ep81 (usb_endpoint)
UEVENT[1192992143.163544] remove   /class/bsg/8:0:0:0 (bsg)
UEVENT[1192992143.163551] remove   /class/scsi_generic/sg2 (scsi_generic)
UEVENT[1192992143.163559] remove   /class/scsi_device/8:0:0:0 (scsi_device)
UEVENT[1192992143.163846] remove   /class/scsi_disk/8:0:0:0 (scsi_disk)
UEVENT[1192992143.163858] remove   /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0/host8/target8:0:0/8:0:0:0/block/sdb/sdb1 (block)
UEVENT[1192992143.163866] remove   /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0/host8/target8:0:0/8:0:0:0/block/sdb (block)
UEVENT[1192992143.163873] remove   /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0/host8/target8:0:0/8:0:0:0 (scsi)
UEVENT[1192992143.163881] remove   /class/scsi_host/host8 (scsi_host)
UEVENT[1192992143.163889] remove   /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0 (usb)
UEVENT[1192992143.163996] remove   /devices/pci0000:00/0000:00:1d.7/usb2/2-2/usb_endpoint/usbdev2.7_ep00 (usb_endpoint)
UEVENT[1192992143.164290] remove   /devices/pci0000:00/0000:00:1d.7/usb2/2-2 (usb)

> Just for the record, here's what happens with this patch on my system,
> without the put_device call in del_gendisk (the patch comments it out).  
> I plugged in a USB drive and let things settle down.  Then unplugging
> the drive gave this:
> 
> [  457.916995] usb 6-4: USB disconnect, address 3
> [  457.918459] usb 6-4: unregistering device
> [  457.920570] usb 6-4: usb_disable_device nuking all URBs
> [  457.920859] usb 6-4: unregistering interface 6-4:1.0
> [  457.958990] disk_release: kobj cedcda50
> 
> The line above refers to the /dev/sda1 partition.  Ignore it.
> 
> [  458.012317] del_gendisk sda, kobj ce8be990, queue cd9b2000, refcount before put_device 2
> 
> 2 references: one from the scsi_disk and one from the request_queue.
> 
> [  458.013133] scsi_disk_release: disk sda, kobj ce8be990, refcount before put_disk 2
> [  458.032420] scsi_device_dev_release: rq cd9b2000

Hmm, I still don't see this without the final put.

> These lines show where the two references to the request_queue get 
> dropped.  As a result the queue is released, causing the gendisk to be 
> released as well:
> 
> [  458.032766] blk_release_queue: rq cd9b2000, parent ce8be990
> [  458.032973] disk_release: kobj ce8be990
> [  458.051641] usb 6-4:1.0: uevent
> [  458.052001] usb 6-4:1.0: uevent
> [  458.068665] usb 6-4: uevent
> 
> If you don't get a similar sequence of events, it must indicate that 
> something on your system continues to hold an outstanding reference.  
> Maybe an automounter program, or something like that.

I killed all userspace while catching that output.


kobject <NULL>: cleaning up
usb 1-2: new full speed USB device using uhci_hcd and address 4
kobject 1-2: registering. parent: usb1, set: devices
kobject_uevent_env
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2'
kobject usb_endpoint: registering. parent: 1-2, set: <NULL>
kobject_uevent_env
unset subsystem caused the event to drop!
kobject usbdev1.4_ep00: registering. parent: usb_endpoint, set: devices
kobject_uevent_env
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/usb_endpoint/usbdev1.4_ep00'
usb 1-2: configuration #1 chosen from 1 choice
kobject 1-2:1.0: registering. parent: 1-2, set: devices
kobject_uevent_env
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0'
scsi9 : SCSI emulation for USB Mass Storage devices
kobject host9: registering. parent: 1-2:1.0, set: devices
kobject_uevent_env
kobject filter function caused the event to drop!
kobject host9: registering. parent: scsi_host, set: class_obj
kobject_uevent_env
fill_kobj_path: path = '/class/scsi_host/host9'
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9'
kobject usb_endpoint: registering. parent: 1-2:1.0, set: <NULL>
kobject_uevent_env
unset subsystem caused the event to drop!
kobject usbdev1.4_ep82: registering. parent: usb_endpoint, set: devices
kobject_uevent_env
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/usb_endpoint/usbdev1.4_ep82'
kobject usbdev1.4_ep01: registering. parent: usb_endpoint, set: devices
kobject_uevent_env
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/usb_endpoint/usbdev1.4_ep01'
usb 1-2: new device found, idVendor=08ec, idProduct=0011
usb 1-2: new device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-2: Product: USB 2.0 Memory Key
usb 1-2: Manufacturer: IBM
usb 1-2: SerialNumber: 0218B301030027E8
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
kobject target9:0:0: registering. parent: host9, set: devices
kobject_uevent_env
kobject filter function caused the event to drop!
scsi 9:0:0:0: Direct-Access     IBM      Memory Key       3.04 PQ: 0 ANSI: 0 CCS
kobject 9:0:0:0: registering. parent: target9:0:0, set: devices
kobject_uevent_env
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0'
kobject 9:0:0:0: registering. parent: scsi_disk, set: class_obj
kobject_uevent_env
fill_kobj_path: path = '/class/scsi_disk/9:0:0:0'
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0'
sd 9:0:0:0: [sdb] 127840 512-byte hardware sectors (65 MB)
sd 9:0:0:0: [sdb] Write Protect is off
sd 9:0:0:0: [sdb] Mode Sense: 45 00 00 08
sd 9:0:0:0: [sdb] Assuming drive cache: write through
kobject block: registering. parent: 9:0:0:0, set: <NULL>
kobject_uevent_env
unset subsystem caused the event to drop!
kobject sdb: registering. parent: block, set: devices
kobject_uevent_env
kobject filter function caused the event to drop!
kobject holders: registering. parent: sdb, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
kobject slaves: registering. parent: sdb, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
sd 9:0:0:0: [sdb] 127840 512-byte hardware sectors (65 MB)
sd 9:0:0:0: [sdb] Write Protect is off
sd 9:0:0:0: [sdb] Mode Sense: 45 00 00 08
sd 9:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
kobject sdb1: registering. parent: sdb, set: devices
kobject_uevent_env
kobject filter function caused the event to drop!
kobject holders: registering. parent: sdb1, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
kobject_uevent_env
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0/block/sdb'
kobject_uevent_env
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0/block/sdb/sdb1'
kobject queue: registering. parent: sdb, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
kobject iosched: registering. parent: queue, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
sd 9:0:0:0: [sdb] Attached SCSI removable disk
kobject 9:0:0:0: registering. parent: scsi_device, set: class_obj
kobject_uevent_env
fill_kobj_path: path = '/class/scsi_device/9:0:0:0'
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0'
kobject sg2: registering. parent: scsi_generic, set: class_obj
kobject_uevent_env
fill_kobj_path: path = '/class/scsi_generic/sg2'
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0'
sd 9:0:0:0: Attached scsi generic sg2 type 0
kobject 9:0:0:0: registering. parent: bsg, set: class_obj
kobject_uevent_env
fill_kobj_path: path = '/class/bsg/9:0:0:0'
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0'
kobject <NULL>: cleaning up
scsi_device_dev_release: rq ffff810005518690
kobject iosched: cleaning up
kobject queue: cleaning up
blk_release_queue: rq ffff810005518690, parent 0000000000000000
kobject target9:0:1: registering. parent: host9, set: devices
kobject_uevent_env
kobject filter function caused the event to drop!
kobject <NULL>: cleaning up
scsi_device_dev_release: rq ffff810005518690
kobject iosched: cleaning up
kobject queue: cleaning up
blk_release_queue: rq ffff810005518690, parent 0000000000000000
kobject_uevent_env
kobject filter function caused the event to drop!
kobject target9:0:1: cleaning up
kobject target9:0:2: registering. parent: host9, set: devices
kobject_uevent_env
kobject filter function caused the event to drop!
kobject <NULL>: cleaning up
scsi_device_dev_release: rq ffff810005518690
kobject iosched: cleaning up
kobject queue: cleaning up
blk_release_queue: rq ffff810005518690, parent 0000000000000000
kobject_uevent_env
kobject filter function caused the event to drop!
kobject target9:0:2: cleaning up
kobject target9:0:3: registering. parent: host9, set: devices
kobject_uevent_env
kobject filter function caused the event to drop!
kobject <NULL>: cleaning up
scsi_device_dev_release: rq ffff810005518690
kobject iosched: cleaning up
kobject queue: cleaning up
blk_release_queue: rq ffff810005518690, parent 0000000000000000
kobject_uevent_env
kobject filter function caused the event to drop!
kobject target9:0:3: cleaning up
kobject target9:0:4: registering. parent: host9, set: devices
kobject_uevent_env
kobject filter function caused the event to drop!
kobject <NULL>: cleaning up
scsi_device_dev_release: rq ffff810005518690
kobject iosched: cleaning up
kobject queue: cleaning up
blk_release_queue: rq ffff810005518690, parent 0000000000000000
kobject_uevent_env
kobject filter function caused the event to drop!
kobject target9:0:4: cleaning up
kobject target9:0:5: registering. parent: host9, set: devices
kobject_uevent_env
kobject filter function caused the event to drop!
kobject <NULL>: cleaning up
scsi_device_dev_release: rq ffff810005518690
kobject iosched: cleaning up
kobject queue: cleaning up
blk_release_queue: rq ffff810005518690, parent 0000000000000000
kobject_uevent_env
kobject filter function caused the event to drop!
kobject target9:0:5: cleaning up
kobject target9:0:6: registering. parent: host9, set: devices
kobject_uevent_env
kobject filter function caused the event to drop!
kobject <NULL>: cleaning up
scsi_device_dev_release: rq ffff810005518690
kobject iosched: cleaning up
kobject queue: cleaning up
blk_release_queue: rq ffff810005518690, parent 0000000000000000
kobject_uevent_env
kobject filter function caused the event to drop!
kobject target9:0:6: cleaning up
kobject target9:0:7: registering. parent: host9, set: devices
kobject_uevent_env
kobject filter function caused the event to drop!
kobject <NULL>: cleaning up
scsi_device_dev_release: rq ffff810005518690
kobject iosched: cleaning up
kobject queue: cleaning up
blk_release_queue: rq ffff810005518690, parent 0000000000000000
kobject_uevent_env
kobject filter function caused the event to drop!
kobject target9:0:7: cleaning up
usb-storage: device scan complete

usb 1-2: USB disconnect, address 4
kobject_uevent_env
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/usb_endpoint/usbdev1.4_ep82'
kobject usbdev1.4_ep82: cleaning up
kobject_uevent_env
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/usb_endpoint/usbdev1.4_ep01'
kobject usbdev1.4_ep01: cleaning up
kobject usb_endpoint: cleaning up
kobject_uevent_env
fill_kobj_path: path = '/class/bsg/9:0:0:0'
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0'
kobject 9:0:0:0: cleaning up
kobject_uevent_env
fill_kobj_path: path = '/class/scsi_generic/sg2'
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0'
kobject sg2: cleaning up
kobject <NULL>: cleaning up
kobject <NULL>: cleaning up
disk_release: kobj ffff810003bcbd58
kobject_uevent_env
fill_kobj_path: path = '/class/scsi_device/9:0:0:0'
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0'
kobject 9:0:0:0: cleaning up
kobject_uevent_env
fill_kobj_path: path = '/class/scsi_disk/9:0:0:0'
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0'
kobject holders: unregistering
kobject_uevent_env
kobject filter function caused the event to drop!
kobject holders: cleaning up
kobject_uevent_env
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0/block/sdb/sdb1'
kobject sdb1: cleaning up
kobject_uevent_env
kobject filter function caused the event to drop!
kobject_uevent_env
kobject filter function caused the event to drop!
kobject holders: unregistering
kobject_uevent_env
kobject filter function caused the event to drop!
kobject holders: cleaning up
kobject slaves: unregistering
kobject_uevent_env
kobject filter function caused the event to drop!
kobject slaves: cleaning up
kobject_uevent_env
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0/block/sdb'
del_gendisk sdb, kobj ffff810004825158, queue ffff810005518000, refcount before put_device 2
kobject 9:0:0:0: cleaning up
scsi_disk_release: disk sdb, kobj ffff810004825158, refcount before put_disk 2
kobject_uevent_env
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0'
kobject_uevent_env
fill_kobj_path: path = '/class/scsi_host/host9'
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9'
kobject host9: cleaning up
kobject_uevent_env
kobject filter function caused the event to drop!
kobject_uevent_env
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0'
kobject_uevent_env
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/usb_endpoint/usbdev1.4_ep00'
kobject usbdev1.4_ep00: cleaning up
kobject usb_endpoint: cleaning up
kobject_uevent_env
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2'


Thanks,
Kay

