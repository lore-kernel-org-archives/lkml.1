Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbZCIRVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbZCIRVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 13:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZCIRV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 13:21:27 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:21767 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbZCIRV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 13:21:26 -0400
Date: Mon, 9 Mar 2009 11:21:23 -0600
From: Alex Chiang <achiang@hp.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, kay.sievers@vrfy.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: kobj refcounting weirdness
Message-ID: <20090309172123.GF32589@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
	kay.sievers@vrfy.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
References: <20090309063654.GB23137@ldl.fc.hp.com> <20090309150453.GB7627@kroah.com> <20090309165010.GB32589@ldl.fc.hp.com> <20090309165807.GU25995@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090309165807.GU25995@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Wilcox <matthew@wil.cx>:
> On Mon, Mar 09, 2009 at 10:50:10AM -0600, Alex Chiang wrote:
> > I thought about the allocators returning a pointer to the same
> > location that maybe has some valid looking data hanging around,
> > but it's not wise for someone like me to go pointing fingers at
> > the allocator before I've proven the bug isn't in my code. ;)
> 
> Slab poisoning would be the logical next thing to try to decide whether
> the allocator is wrong or you're using it wrong ;-)

Hey shiny!

Thanks, this is good -- I hopefully muddle my way through and
figure out what's going on.

[output of slab poisoning below]

/ac

[root@tahitifp1 pci]# echo 1 > devices/0000\:04\:00.0/remove 
kobject: '0000:06:00.0' (e0000001818153f0): kobject_uevent_env
kobject: '0000:06:00.0' (e0000001818153f0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:06:00.0'
kobject: '0000:06:00.0' (e0000001818153f0): kobject_cleanup
kobject: '0000:06:00.0' (e0000001818153f0): calling ktype release
kobject: '0000:06:00.0': free name
kobject: '0000:06:00.1' (e000000181815c38): kobject_uevent_env
kobject: '0000:06:00.1' (e000000181815c38): fill_kobj_path: path = '/devices/pci
0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:06:00.1'
kobject: '0000:06:00.1' (e000000181815c38): kobject_cleanup
kobject: '0000:06:00.1' (e000000181815c38): calling ktype release
kobject: '0000:06:00.1': free name
kobject: '0000:06' (e000000180186430): kobject_uevent_env
kobject: '0000:06' (e000000180186430): fill_kobj_path: path = '/class/pci_bus/00
00:06'
kobject: '0000:05:02.0' (e000000181814360): fill_kobj_path: path = '/devices/pci
0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0'
kobject: '0000:06' (e000000180186430): kobject_cleanup
kobject: '0000:06' (e000000180186430): calling ktype release
kobject: '0000:06': free name
aer 0000:05:02.0:pcie22: unloading service driver aer
kobject: '0000:05:02.0:pcie22' (e000000183350788): kobject_uevent_env
kobject: '0000:05:02.0:pcie22' (e000000183350788): fill_kobj_path: path = '/devi
ces/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:05:02.0:pcie22'
kobject: '0000:05:02.0:pcie22' (e000000183350788): kobject_cleanup
kobject: '0000:05:02.0:pcie22' (e000000183350788): calling ktype release
kobject: '0000:05:02.0:pcie22': free name
kobject: '0000:05:02.0:pcie28' (e0000001833509d0): kobject_uevent_env
kobject: '0000:05:02.0:pcie28' (e0000001833509d0): fill_kobj_path: path = '/devi
ces/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:05:02.0:pcie28'
kobject: '0000:05:02.0:pcie28' (e0000001833509d0): kobject_cleanup
kobject: '0000:05:02.0:pcie28' (e0000001833509d0): calling ktype release
kobject: '0000:05:02.0:pcie28': free name
=============================================================================
BUG kmalloc-8: Object already free
-----------------------------------------------------------------------------

INFO: Allocated in pcie_port_device_register+0x60/0x920 age=56269 cpu=7 pid=1
INFO: Freed in pcie_port_device_remove+0xb0/0xe0 age=0 cpu=0 pid=28
INFO: Slab 0xa07fffffc81cb0f8 objects=819 used=812 fp=0xe000000183291770 flags=0
x10000000000083
INFO: Object 0xe000000183291770 @offset=6000 fp=0xe000000183291860

Bytes b4 0xe000000183291760:  3d ef ff ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a =�
....ZZZZZZZZ
  Object 0xe000000183291770:  6b 6b 6b 6b 6b 6b 6b a5                         kk
kkkkk�        
 Redzone 0xe000000183291778:  bb bb bb bb bb bb bb bb                         ��
������        
 Padding 0xe0000001832917b8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZ
ZZZZZZ        

Call Trace:
 [<a0000001000146d0>] show_stack+0x50/0xa0
                                sp=e0000001813efc00 bsp=e0000001813e1308
 [<a000000100014750>] dump_stack+0x30/0x60
                                sp=e0000001813efdd0 bsp=e0000001813e12f0
 [<a000000100175fe0>] print_trailer+0x220/0x240
                                sp=e0000001813efdd0 bsp=e0000001813e12b0
 [<a000000100176050>] object_err+0x50/0x80
                                sp=e0000001813efdd0 bsp=e0000001813e1278
 [<a000000100179c70>] __slab_free+0x5b0/0x7a0
                                sp=e0000001813efdd0 bsp=e0000001813e1230
 [<a00000010017b750>] kfree+0x250/0x2a0
                                sp=e0000001813efdd0 bsp=e0000001813e11e8
 [<a0000001004226a0>] pcie_portdrv_remove+0x40/0x60
                                sp=e0000001813efdd0 bsp=e0000001813e11c8
 [<a000000100417b20>] pci_device_remove+0x80/0x100
                                sp=e0000001813efdd0 bsp=e0000001813e11a0
 [<a00000010050f920>] __device_release_driver+0x100/0x160
                                sp=e0000001813efdd0 bsp=e0000001813e1168
 [<a00000010050f9b0>] device_release_driver+0x30/0x60
                                sp=e0000001813efdd0 bsp=e0000001813e1140
 [<a00000010050d350>] bus_remove_device+0x1d0/0x220
                                sp=e0000001813efdd0 bsp=e0000001813e1100
 [<a0000001005080e0>] device_del+0x2c0/0x3a0
                                sp=e0000001813efdd0 bsp=e0000001813e10c8
 [<a000000100508290>] device_unregister+0xd0/0x100
                                sp=e0000001813efdd0 bsp=e0000001813e10a8
 [<a00000010040d990>] pci_stop_dev+0x70/0x100
                                sp=e0000001813efdd0 bsp=e0000001813e1080
 [<a00000010040dc00>] pci_remove_bus_device+0x80/0x180
                                sp=e0000001813efdd0 bsp=e0000001813e1050
 [<a00000010040dd60>] pci_remove_behind_bridge+0x60/0xc0
                                sp=e0000001813efdd0 bsp=e0000001813e1028
 [<a00000010040dbc0>] pci_remove_bus_device+0x40/0x180
                                sp=e0000001813efdd0 bsp=e0000001813e0ff0
 [<a000000100419880>] remove_callback+0x40/0xa0
                                sp=e0000001813efdd0 bsp=e0000001813e0fc8
 [<a000000100232970>] sysfs_schedule_callback_work+0x50/0xc0
                                sp=e0000001813efdd0 bsp=e0000001813e0fa0
 [<a0000001000c12b0>] run_workqueue+0x1f0/0x340
                                sp=e0000001813efdd0 bsp=e0000001813e0f60
 [<a0000001000c1540>] worker_thread+0x140/0x180
                                sp=e0000001813efdd0 bsp=e0000001813e0f38
 [<a0000001000c9d00>] kthread+0xa0/0x120
                                sp=e0000001813efe30 bsp=e0000001813e0f08
 [<a000000100016690>] kernel_thread_helper+0xd0/0x100
                                sp=e0000001813efe30 bsp=e0000001813e0ee0
 [<a00000010000a4c0>] start_kernel_thread+0x20/0x40
                                sp=e0000001813efe30 bsp=e0000001813e0ee0
FIX kmalloc-8: Object at 0xe000000183291770 not freed

