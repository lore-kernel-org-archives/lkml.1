Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZCITxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZCITxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 15:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZCITwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 15:52:54 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:4673 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbZCITww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 15:52:52 -0400
Date: Mon, 9 Mar 2009 13:52:50 -0600
From: Alex Chiang <achiang@hp.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: jbarnes@virtuousgeek.org, xyzzy@speakeasy.org, djwong@us.ibm.com,
       shimada-yxb@necst.nec.co.jp, rjw@sisk.pl, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/11] PCI core learns hotplug
Message-ID: <20090309195250.GQ32589@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Vegard Nossum <vegard.nossum@gmail.com>, jbarnes@virtuousgeek.org,
	xyzzy@speakeasy.org, djwong@us.ibm.com, shimada-yxb@necst.nec.co.jp,
	rjw@sisk.pl, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20090309052933.3918.86601.stgit@bob.kio> <20090309185117.GJ32589@ldl.fc.hp.com> <19f34abd0903091230q27a04f37mdb0ba75ba170e6a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0903091230q27a04f37mdb0ba75ba170e6a@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

First, thanks for testing!

* Vegard Nossum <vegard.nossum@gmail.com>:
> 
> I got this crash:
> 
> [  279.029673] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000008
[...] 
> It reproduces reliably if I do this:
> 
> $ while true; do echo 1 > /sys/bus/pci/devices/0000\:00\:00.0/remove; done

I was going to ask for lspci -v output so that I could see what
device 0000:00:00.0 might be, but I was able to reproduce
something similar on my machine.

Can I ask why you're doing the above with a while loop? Just to
torture the code? Or something else?

I haven't started investigating too closely yet, but it looks
like I need some locking in there.

Thanks.

/ac

[root@tahitifp1 pci]# while true ; do echo 1 > devices/0000\:04\:00.0/remove  ;  done
kobject: '0000:06:00.0' (e000000181703120): kobject_uevent_env
------------[ cut here ]------------
WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x80/0x180()
Hardware name: server BL860c
sysfs group a000000101432580 not found for kobject '0000:06:00.0'
Modules linked in: binfmt_misc dm_multipath pci_slot sg shpchp pci_hotplug dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod uhci_hcd ohci_hcd ehci_hcd usbcore

Call Trace:
 [<a0000001000146d0>] show_stack+0x50/0xa0
                                sp=e00000018131fae0 bsp=e000000181311228
 [<a000000100014750>] dump_stack+0x30/0x60
                                sp=e00000018131fcb0 bsp=e000000181311210
 [<a00000010009a0f0>] warn_slowpath+0x130/0x180
                                sp=e00000018131fcb0 bsp=e0000001813111a8
 [<a0000001002336a0>] sysfs_remove_group+0x80/0x180
                                sp=e00000018131fdd0 bsp=e000000181311178
 [<a000000100513410>] dpm_sysfs_remove+0x30/0x60
                                sp=e00000018131fdd0 bsp=e000000181311158
 [<a0000001005041d0>] device_del+0x70/0x3a0
                                sp=e00000018131fdd0 bsp=e000000181311120
 [<a0000001005045d0>] device_unregister+0xd0/0x100
                                sp=e00000018131fdd0 bsp=e000000181311100
 [<a000000100409cd0>] pci_stop_dev+0x70/0x100
                                sp=e00000018131fdd0 bsp=e0000001813110d8
 [<a000000100409f40>] pci_remove_bus_device+0x80/0x180
                                sp=e00000018131fdd0 bsp=e0000001813110a8
 [<a00000010040a0a0>] pci_remove_behind_bridge+0x60/0xc0
                                sp=e00000018131fdd0 bsp=e000000181311080
 [<a000000100409f00>] pci_remove_bus_device+0x40/0x180
                                sp=e00000018131fdd0 bsp=e000000181311050
 [<a00000010040a0a0>] pci_remove_behind_bridge+0x60/0xc0
                                sp=e00000018131fdd0 bsp=e000000181311028
 [<a000000100409f00>] pci_remove_bus_device+0x40/0x180
                                sp=e00000018131fdd0 bsp=e000000181310ff0
 [<a000000100415bc0>] remove_callback+0x40/0xc0
                                sp=e00000018131fdd0 bsp=e000000181310fc8
 [<a00000010022edb0>] sysfs_schedule_callback_work+0x50/0xc0
                                sp=e00000018131fdd0 bsp=e000000181310fa0
 [<a0000001000c1150>] run_workqueue+0x1f0/0x340
                                sp=e00000018131fdd0 bsp=e000000181310f60
 [<a0000001000c13e0>] worker_thread+0x140/0x180
                                sp=e00000018131fdd0 bsp=e000000181310f38
 [<a0000001000c9ba0>] kthread+0xa0/0x120
                                sp=e00000018131fe30 bsp=e000000181310f08
 [<a000000100016690>] kernel_thread_helper+0xd0/0x100
                                sp=e00000018131fe30 bsp=e000000181310ee0
 [<a00000010000a4c0>] start_kernel_thread+0x20/0x40
                                sp=e00000018131fe30 bsp=e000000181310ee0
---[ end trace 9397c0de832fd5ba ]---
Unable to handle kernel NULL pointer dereference (address 0000000000000020)
events/4[32]: Oops 8813272891392 [1]
Modules linked in: binfmt_misc dm_multipath pci_slot sg shpchp pci_hotplug dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod uhci_hcd ohci_hcd ehci_hcd usbcore

Pid: 32, CPU 4, comm:             events/4
psr : 00001010085a6010 ifs : 800000000000038a ip  : [<a0000001009059a0>]    Tainted: G        W  (2.6.29-rc4)
ip is at klist_put+0x40/0x160
unat: 0000000000000000 pfs : 000000000000038a rsc : 0000000000000003
rnat: e00000018131fcb0 bsps: 9397c0de832fd5ba pr  : 0000000000005a41
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a000000100905990 b6  : a000000100044250 b7  : a00000010000cd10
f6  : 000000000000000000000 f7  : 1003e9e3779b97f4a7c16
f8  : 1003e0a00000010000a4c f9  : 1003e0000000000000056
f10 : 1003e000000000000025a f11 : 1003e6db6db6db6db6db7
r1  : a0000001016d1360 r2  : a0000001014f5f50 r3  : a0000001014f5188
r8  : 0000000000000000 r9  : 0000000000000000 r10 : 0000000000000200
r11 : 0000000000000000 r12 : e00000018131fdd0 r13 : e000000181310000
r14 : 0000000000000020 r15 : 0000000000000009 r16 : 0000000000000000
r17 : a0000001014f5f50 r18 : 0000000000000200 r19 : 000000000007aca1
r20 : fffffffffff7aca1 r21 : a0000001014f5f90 r22 : a0000001014f5f94
r23 : 000000000000000a r24 : 000000000000000a r25 : a000000102b76a98
r26 : 000000000007aca0 r27 : 00000010085a2010 r28 : 00000000000fffff
r29 : a0000001014f4e58 r30 : 0000000000000000 r31 : a000000101409818

Call Trace:
 [<a0000001000146d0>] show_stack+0x50/0xa0
                                sp=e00000018131f9a0 bsp=e0000001813112c0
 [<a000000100014fb0>] show_regs+0x830/0x860
                                sp=e00000018131fb70 bsp=e000000181311278
 [<a000000100039bc0>] die+0x1c0/0x2c0
                                sp=e00000018131fb70 bsp=e000000181311230
 [<a000000100063e50>] ia64_do_page_fault+0x830/0x960
                                sp=e00000018131fb70 bsp=e0000001813111c8
 [<a00000010000c700>] ia64_native_leave_kernel+0x0/0x270
                                sp=e00000018131fc00 bsp=e0000001813111c8
 [<a0000001009059a0>] klist_put+0x40/0x160
                                sp=e00000018131fdd0 bsp=e000000181311178
 [<a000000100905af0>] klist_del+0x30/0x60
                                sp=e00000018131fdd0 bsp=e000000181311158
 [<a0000001005041f0>] device_del+0x90/0x3a0
                                sp=e00000018131fdd0 bsp=e000000181311120
 [<a0000001005045d0>] device_unregister+0xd0/0x100
                                sp=e00000018131fdd0 bsp=e000000181311100
 [<a000000100409cd0>] pci_stop_dev+0x70/0x100
                                sp=e00000018131fdd0 bsp=e0000001813110d8
 [<a000000100409f40>] pci_remove_bus_device+0x80/0x180
                                sp=e00000018131fdd0 bsp=e0000001813110a8
 [<a00000010040a0a0>] pci_remove_behind_bridge+0x60/0xc0
                                sp=e00000018131fdd0 bsp=e000000181311080
 [<a000000100409f00>] pci_remove_bus_device+0x40/0x180
                                sp=e00000018131fdd0 bsp=e000000181311050
 [<a00000010040a0a0>] pci_remove_behind_bridge+0x60/0xc0
                                sp=e00000018131fdd0 bsp=e000000181311028
 [<a000000100409f00>] pci_remove_bus_device+0x40/0x180
                                sp=e00000018131fdd0 bsp=e000000181310ff0
 [<a000000100415bc0>] remove_callback+0x40/0xc0
                                sp=e00000018131fdd0 bsp=e000000181310fc8
 [<a00000010022edb0>] sysfs_schedule_callback_work+0x50/0xc0
                                sp=e00000018131fdd0 bsp=e000000181310fa0
 [<a0000001000c1150>] run_workqueue+0x1f0/0x340
                                sp=e00000018131fdd0 bsp=e000000181310f60
 [<a0000001000c13e0>] worker_thread+0x140/0x180
                                sp=e00000018131fdd0 bsp=e000000181310f38
 [<a0000001000c9ba0>] kthread+0xa0/0x120
                                sp=e00000018131fe30 bsp=e000000181310f08
 [<a000000100016690>] kernel_thread_helper+0xd0/0x100
                                sp=e00000018131fe30 bsp=e000000181310ee0
 [<a00000010000a4c0>] start_kernel_thread+0x20/0x40
                                sp=e00000018131fe30 bsp=e000000181310ee0
kobject: '0000:06:00.0' (e000000181703120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:06:00.0'

