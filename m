Return-Path: <linux-kernel-owner+w=401wt.eu-S966868AbXJSXF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966868AbXJSXF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 19:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbXJSXFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 19:05:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58141 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbXJSXFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:06 -0400
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0710191303540.3755-200000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0710191303540.3755-200000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Sat, 20 Oct 2007 01:06:23 +0200
Message-Id: <1192835183.5418.6.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/9PTZjUYLdczEUyYo4LSColmbbIy544jT4z29
 I/PyHUSwqoggQ+gY1WWLymJzE5qTresLXP7SOZtXyu/iijkOWr
 XqOdn3PFYd1y2T+mVhmcrWkYZ8F6+yA
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-19 at 13:11 -0400, Alan Stern wrote:
> On Fri, 19 Oct 2007, Kay Sievers wrote:

> > > Don't you have a USB storage device?  It should be easy for you to
> test 
> > > this on your own system.
> > 
> > Sure, I have, and tried a lot of times, and all seemed correct here
> with
> > the final put. I don't say that it's the right fix, but without it,
> the
> > disk device object is never released here, it only gets removed from
> > sysfs.
> 
> Well, attached is a testing patch.  It should apply to 2.6.23
> together 
> with gregkh-all-2.6.23.  Here's the output on my system using your 
> original code:
> 
...

> As you can see, this definitely proves that the final put is done at 
> the right time.
> 
> See what the patch shows on your system.  One extra thing to check for: 
> When you plug in a USB drive, the SCSI core starts up an error-handler 
> process for it.  When you unplug the drive, the error-handler task 
> should exit.  If it doesn't then there's an extra reference somewhere 
> that never got released.

Here is what I see, the error handler hangs without the final put and
the kobject never gets cleaned up. Note the missing:
  kobject sdb: cleaning up

What is your CONFIG_SYSFS_DEPRECATED option? I have it unset, and that
may be the difference in the behavior if you have it set.

Thanks,
Kay


With device_put() - add sequence:
  sd_probe: call add_disk
  start of register_disk: 1
  kobject block: registering. parent: 9:0:0:0, set: <NULL>
  unset subsytem caused the event to drop!
  kobject sdb: registering. parent: block, set: devices
  kobject filter function caused the event to drop!
  after device_add: 3
  after sysfs_create_link: 3
  kobject holders: registering. parent: sdb, set: <NULL>
  kobject filter function caused the event to drop!
  kobject slaves: registering. parent: sdb, set: <NULL>
  kobject filter function caused the event to drop!
  after disk_sysfs_add_subdirs: 5
  after get_capacity: 5
  after bdget_disk: 5
  sd 9:0:0:0: [sdb] 127840 512-byte hardware sectors (65 MB)
  sd 9:0:0:0: [sdb] Write Protect is off
  sd 9:0:0:0: [sdb] Mode Sense: 45 00 00 08
  sd 9:0:0:0: [sdb] Assuming drive cache: write through
   sdb: sdb1
  kobject sdb1: registering. parent: sdb, set: devices
  kobject filter function caused the event to drop!
  kobject holders: registering. parent: sdb1, set: <NULL>
  kobject filter function caused the event to drop!
  after blkdev_get: 8
  after blkdev_put: 7
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0/block/sdb'
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0/block/sdb/sdb1'
  end of register_disk: 7
  kobject queue: registering. parent: sdb, set: <NULL>
  kobject filter function caused the event to drop!
  kobject iosched: registering. parent: queue, set: <NULL>
  kobject filter function caused the event to drop!
  after blk_register_queue: 9
  sd 9:0:0:0: [sdb] Attached SCSI removable disk
  kobject 9:0:0:0: registering. parent: scsi_device, set: class_obj
  fill_kobj_path: path = '/class/scsi_device/9:0:0:0'
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0'
  kobject sg2: registering. parent: scsi_generic, set: class_obj
  fill_kobj_path: path = '/class/scsi_generic/sg2'
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0'
  sd 9:0:0:0: Attached scsi generic sg2 type 0
  kobject 9:0:0:0: registering. parent: bsg, set: class_obj
  fill_kobj_path: path = '/class/bsg/9:0:0:0'
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0'
  kobject <NULL>: cleaning up
  kobject iosched: cleaning up
  kobject queue: cleaning up
  kobject target9:0:1: registering. parent: host9, set: devices
  kobject filter function caused the event to drop!
  kobject <NULL>: cleaning up
  kobject iosched: cleaning up
  kobject queue: cleaning up
  kobject filter function caused the event to drop!
  kobject target9:0:1: cleaning up
  kobject target9:0:2: registering. parent: host9, set: devices
  kobject filter function caused the event to drop!
  kobject <NULL>: cleaning up
  kobject iosched: cleaning up
  kobject queue: cleaning up
  kobject filter function caused the event to drop!
  kobject target9:0:2: cleaning up
  kobject target9:0:3: registering. parent: host9, set: devices
  kobject filter function caused the event to drop!
  kobject <NULL>: cleaning up
  kobject iosched: cleaning up
  kobject queue: cleaning up
  kobject filter function caused the event to drop!
  kobject target9:0:3: cleaning up
  kobject target9:0:4: registering. parent: host9, set: devices
  kobject filter function caused the event to drop!
  kobject <NULL>: cleaning up
  kobject iosched: cleaning up
  kobject queue: cleaning up
  kobject filter function caused the event to drop!
  kobject target9:0:4: cleaning up
  kobject target9:0:5: registering. parent: host9, set: devices
  kobject filter function caused the event to drop!
  kobject <NULL>: cleaning up
  kobject iosched: cleaning up
  kobject queue: cleaning up
  kobject filter function caused the event to drop!
  kobject target9:0:5: cleaning up
  kobject target9:0:6: registering. parent: host9, set: devices
  kobject filter function caused the event to drop!
  kobject <NULL>: cleaning up
  kobject iosched: cleaning up
  kobject queue: cleaning up
  kobject filter function caused the event to drop!
  kobject target9:0:6: cleaning up
  kobject target9:0:7: registering. parent: host9, set: devices
  kobject filter function caused the event to drop!
  kobject <NULL>: cleaning up
  kobject iosched: cleaning up
  kobject queue: cleaning up
  kobject filter function caused the event to drop!
  kobject target9:0:7: cleaning up
  usb-storage: device scan complete
  
With device_put() - eh_9 created:
     23 ?        S<     0:00  \_ [scsi_eh_0]
     24 ?        S<     0:00  \_ [scsi_eh_1]
     25 ?        S<     0:00  \_ [scsi_eh_2]
     26 ?        S<     0:00  \_ [scsi_eh_3]
     27 ?        S<     0:00  \_ [scsi_eh_4]
     28 ?        S<     0:00  \_ [scsi_eh_5]
   2149 ?        S<     0:00  \_ [scsi_eh_9]
   2182 tty1     S+     0:00      \_ grep eh

  
With device_put() - remove sequence:
  sd_remove: call del_gendisk
  start of del_gendisk: 9
  kobject holders: unregistering
  kobject filter function caused the event to drop!
  kobject holders: cleaning up
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0/block/sdb/sdb1'
  kobject sdb1: cleaning up
  after deleting subpartitions: 7
  after invalidate_partition(0): 7
  kobject filter function caused the event to drop!
  kobject filter function caused the event to drop!
  after unlink_gendisk: 6
  kobject holders: unregistering
  kobject filter function caused the event to drop!
  kobject holders: cleaning up
  kobject slaves: unregistering
  kobject filter function caused the event to drop!
  kobject slaves: cleaning up
  after kobject_unregister subdirs: 4
  after sysfs_remove_link: 4
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0/block/sdb'
  after device_del: 2
  after put_device: 1
  kobject 9:0:0:0: cleaning up
  scsi_disk_release: call put_disk
  kobject sdb: cleaning up
  kobject block: cleaning up
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9/target9:0:0/9:0:0:0'
  kobject 9:0:0:0: cleaning up
  kobject iosched: cleaning up
  kobject queue: cleaning up
  kobject filter function caused the event to drop!
  kobject target9:0:0: cleaning up
  fill_kobj_path: path = '/class/scsi_host/host9'
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host9'
  kobject host9: cleaning up
  kobject filter function caused the event to drop!
  kobject host9: cleaning up
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0'
  kobject 1-2:1.0: cleaning up
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/usb_endpoint/usbdev1.6_ep00'
  kobject usbdev1.6_ep00: cleaning up
  kobject usb_endpoint: cleaning up
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2'
  kobject 1-2: cleaning up

With device_put() - eh_9 removed:
     23 ?        S<     0:00  \_ [scsi_eh_0]
     24 ?        S<     0:00  \_ [scsi_eh_1]
     25 ?        S<     0:00  \_ [scsi_eh_2]
     26 ?        S<     0:00  \_ [scsi_eh_3]
     27 ?        S<     0:00  \_ [scsi_eh_4]
     28 ?        S<     0:00  \_ [scsi_eh_5]
   2199 tty1     S+     0:00      \_ grep eh
  
  

Without device_put() - add sequence:
  sd_probe: call add_disk
  start of register_disk: 1
  kobject block: registering. parent: 8:0:0:0, set: <NULL>
  unset subsytem caused the event to drop!
  kobject sdb: registering. parent: block, set: devices
  kobject filter function caused the event to drop!
  after device_add: 3
  after sysfs_create_link: 3
  kobject holders: registering. parent: sdb, set: <NULL>
  kobject filter function caused the event to drop!
  kobject slaves: registering. parent: sdb, set: <NULL>
  kobject filter function caused the event to drop!
  after disk_sysfs_add_subdirs: 5
  after get_capacity: 5
  after bdget_disk: 5
  sd 8:0:0:0: [sdb] 127840 512-byte hardware sectors (65 MB)
  sd 8:0:0:0: [sdb] Write Protect is off
  sd 8:0:0:0: [sdb] Mode Sense: 45 00 00 08
  sd 8:0:0:0: [sdb] Assuming drive cache: write through
   sdb: sdb1
  kobject sdb1: registering. parent: sdb, set: devices
  kobject filter function caused the event to drop!
  kobject holders: registering. parent: sdb1, set: <NULL>
  kobject filter function caused the event to drop!
  after blkdev_get: 8
  after blkdev_put: 7
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host8/target8:0:0/8:0:0:0/block/sdb'
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host8/target8:0:0/8:0:0:0/block/sdb/sdb1'
  end of register_disk: 7
  kobject queue: registering. parent: sdb, set: <NULL>
  kobject filter function caused the event to drop!
  kobject iosched: registering. parent: queue, set: <NULL>
  kobject filter function caused the event to drop!
  after blk_register_queue: 9
  sd 8:0:0:0: [sdb] Attached SCSI removable disk
  kobject 8:0:0:0: registering. parent: scsi_device, set: class_obj
  fill_kobj_path: path = '/class/scsi_device/8:0:0:0'
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host8/target8:0:0/8:0:0:0'
  kobject sg2: registering. parent: scsi_generic, set: class_obj
  fill_kobj_path: path = '/class/scsi_generic/sg2'
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host8/target8:0:0/8:0:0:0'
  sd 8:0:0:0: Attached scsi generic sg2 type 0
  kobject 8:0:0:0: registering. parent: bsg, set: class_obj
  fill_kobj_path: path = '/class/bsg/8:0:0:0'
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host8/target8:0:0/8:0:0:0'
  kobject <NULL>: cleaning up
  kobject iosched: cleaning up
  kobject queue: cleaning up
  kobject target8:0:1: registering. parent: host8, set: devices
  kobject filter function caused the event to drop!
  kobject <NULL>: cleaning up
  kobject iosched: cleaning up
  kobject queue: cleaning up
  kobject filter function caused the event to drop!
  kobject target8:0:1: cleaning up
  kobject target8:0:2: registering. parent: host8, set: devices
  kobject filter function caused the event to drop!
  kobject <NULL>: cleaning up
  kobject iosched: cleaning up
  kobject queue: cleaning up
  kobject filter function caused the event to drop!
  kobject target8:0:2: cleaning up
  kobject target8:0:3: registering. parent: host8, set: devices
  kobject filter function caused the event to drop!
  kobject <NULL>: cleaning up
  kobject iosched: cleaning up
  kobject queue: cleaning up
  kobject filter function caused the event to drop!
  kobject target8:0:3: cleaning up
  kobject target8:0:4: registering. parent: host8, set: devices
  kobject filter function caused the event to drop!
  kobject <NULL>: cleaning up
  kobject iosched: cleaning up
  kobject queue: cleaning up
  kobject filter function caused the event to drop!
  kobject target8:0:4: cleaning up
  kobject target8:0:5: registering. parent: host8, set: devices
  kobject filter function caused the event to drop!
  kobject <NULL>: cleaning up
  kobject iosched: cleaning up
  kobject queue: cleaning up
  kobject filter function caused the event to drop!
  kobject target8:0:5: cleaning up
  kobject target8:0:6: registering. parent: host8, set: devices
  kobject filter function caused the event to drop!
  kobject <NULL>: cleaning up
  kobject iosched: cleaning up
  kobject queue: cleaning up
  kobject filter function caused the event to drop!
  kobject target8:0:6: cleaning up
  kobject target8:0:7: registering. parent: host8, set: devices
  kobject filter function caused the event to drop!
  kobject <NULL>: cleaning up
  kobject iosched: cleaning up
  kobject queue: cleaning up
  kobject filter function caused the event to drop!
  kobject target8:0:7: cleaning up
  usb-storage: device scan complete
  
Without device_put() - eh_8 created:
     23 ?        S<     0:00  \_ [scsi_eh_0]
     24 ?        S<     0:00  \_ [scsi_eh_1]
     25 ?        S<     0:00  \_ [scsi_eh_2]
     26 ?        S<     0:00  \_ [scsi_eh_3]
     27 ?        S<     0:00  \_ [scsi_eh_4]
     28 ?        S<     0:00  \_ [scsi_eh_5]
   1965 ?        S<     0:00  \_ [scsi_eh_6]
   2014 ?        S<     0:00  \_ [scsi_eh_7]
   2066 ?        S<     0:00  \_ [scsi_eh_8]
   2098 tty1     S+     0:00      \_ grep eh
  
  
Without device_put() - remove sequence:
  sd_remove: call del_gendisk
  start of del_gendisk: 9
  kobject holders: unregistering
  kobject filter function caused the event to drop!
  kobject holders: cleaning up
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host8/target8:0:0/8:0:0:0/block/sdb/sdb1'
  kobject sdb1: cleaning up
  after deleting subpartitions: 7
  after invalidate_partition(0): 7
  kobject filter function caused the event to drop!
  kobject filter function caused the event to drop!
  after unlink_gendisk: 6
  kobject holders: unregistering
  kobject filter function caused the event to drop!
  kobject holders: cleaning up
  kobject slaves: unregistering
  kobject filter function caused the event to drop!
  kobject slaves: cleaning up
  after kobject_unregister subdirs: 4
  after sysfs_remove_link: 4
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host8/target8:0:0/8:0:0:0/block/sdb'
  after device_del: 2
  after put_device: 2
  kobject 8:0:0:0: cleaning up
  scsi_disk_release: call put_disk
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host8/target8:0:0/8:0:0:0'
  fill_kobj_path: path = '/class/scsi_host/host8'
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/host8'
  kobject host8: cleaning up
  kobject filter function caused the event to drop!
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0'
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2/usb_endpoint/usbdev1.4_ep00'
  kobject usbdev1.4_ep00: cleaning up
  kobject usb_endpoint: cleaning up
  fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.0/usb1/1-2'
  
Without device_put() - eh_8 hanging around:
     23 ?        S<     0:00  \_ [scsi_eh_0]
     24 ?        S<     0:00  \_ [scsi_eh_1]
     25 ?        S<     0:00  \_ [scsi_eh_2]
     26 ?        S<     0:00  \_ [scsi_eh_3]
     27 ?        S<     0:00  \_ [scsi_eh_4]
     28 ?        S<     0:00  \_ [scsi_eh_5]
   1965 ?        S<     0:00  \_ [scsi_eh_6]
   2014 ?        S<     0:00  \_ [scsi_eh_7]
   2066 ?        S<     0:00  \_ [scsi_eh_8]
   2118 tty1     S+     0:00      \_ grep eh
  


