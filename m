Return-Path: <linux-kernel-owner+w=401wt.eu-S1752296AbZGXKap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbZGXKap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 06:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZGXKap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 06:30:45 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:33072 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZGXKan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 06:30:43 -0400
Date: Fri, 24 Jul 2009 12:30:38 +0200
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org
Subject: ubifs: error unwinding trouble
Message-ID: <20090724103038.GN19257@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a recent git kernel, the error unwinding for UBIFS seems to have some
problem, most probably a double-free or something similar.

When UBI is pointed to the right mtd partition (using command line
arguments) , everything is fine. But when it's (accidentionally) set to
some very small mtd, the attach process fails. Which wouldn't be a bad
thing by itself, but it somehow messes up the slub/slab allocators then
which causes very strange memory corruption effects - see the backtrace
below.

The Ooops itself is unreleated to UBI, but it does not occur when UBI
succeeds in attaching the volume.

Any idea? I searched for awhile but couldn't see anything obvious.

Daniel


[   20.257889] Creating 4 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[   20.264047] 0x000000000000-0x0000000a0000 : "Bootloader"
[   20.272920] 0x0000000a0000-0x0000000c0000 : "BootloaderEnvironment"
[   20.282326] 0x0000000c0000-0x000000120000 : "BootloaderSplashScreen"
[   20.291861] 0x000000120000-0x000008000000 : "UBI"
[   20.302029] UBI: attaching mtd2 to ubi0
[   20.305851] UBI: physical eraseblock size:   131072 bytes (128 KiB)
[   20.312160] UBI: logical eraseblock size:    126976 bytes
[   20.317579] UBI: smallest flash I/O unit:    2048
[   20.322247] UBI: VID header offset:          2048 (aligned 2048)
[   20.328232] UBI: data offset:                4096
[   20.335309] UBI: empty MTD device detected
[   20.339716] UBI: create volume table (copy #1)
[   20.352185] UBI: create volume table (copy #2)
[   20.364691] UBI error: ubi_eba_init_scan: no enough physical eraseblocks (0, need 1)
[   20.372701] UBI error: ubi_init: cannot attach mtd2
[   20.378971] UBI error: ubi_init: UBI error: cannot initialize UBI, error -28
[   20.387002] Unable to handle kernel paging request at virtual address 69766564
[   20.394181] pgd = c0004000
[   20.396863] [69766564] *pgd=00000000
[   20.400408] Internal error: Oops: 5 [#1]
[   20.404296] Modules linked in:
[   20.407330] CPU: 0    Not tainted  (2.6.31-rc3-00875-g1f01f91-dirty #765)
[   20.414092] PC is at __kmalloc_track_caller+0x7c/0xdc
[   20.419112] LR is at __kmalloc_track_caller+0x44/0xdc
[   20.424128] pc : [<c0085d7c>]    lr : [<c0085d44>]    psr: 20000093
[   20.424138] sp : c7823d68  ip : c04a42e4  fp : 00000000
[   20.435530] r10: 000041ed  r9 : 00000000  r8 : c00ca778
[   20.440718] r7 : 00000020  r6 : 000000d0  r5 : a0000013  r4 : 69766564
[   20.447196] r3 : 00000000  r2 : c04a4000  r1 : 00000005  r0 : c04a42e4
[   20.453678] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[   20.461025] Control: 0000397f  Table: a0004018  DAC: 00000035
[   20.466726] Process swapper (pid: 1, stack limit = 0xc7822278)
[   20.472517] Stack: (0xc7823d68 to 0xc7824000)
[   20.476838] 3d60:                   ffffffff 0000006c 000000d0 00000007 c00ca778 c790f720 
[   20.485031] 3d80: c7823df4 c0072548 00000004 c7833c08 c7833c00 00000001 c790f720 c00ca778 
[   20.493224] 3da0: c7823db6 c0038e64 00000037 c7833c08 c7833c00 c7833c08 c78652d0 c7823df4 
[   20.501417] 3dc0: c7833c08 c00cac24 c785b2c0 c04c23f8 00000000 00000000 c7833c08 c7833c00 
[   20.509610] 3de0: 00000000 c785b200 c04a94e8 c00cace0 c7807248 c01603ec c7833c08 c0160518 
[   20.517803] 3e00: c7833c00 c7833c00 00000000 c785b200 c04c23f8 c0160798 c7833c00 c019eed0 
[   20.525997] 3e20: 00000000 00000000 c0443452 c04a94e0 c0443452 c0443452 00000008 000f4240 
[   20.534190] 3e40: 00000000 c7833c00 c04a94e0 00000000 c785b200 c04c23f8 00000000 00000000 
[   20.542383] 3e60: 00000000 c01eb1b8 0000000d c016408c c7833c00 c789012c 00000000 c01eb2c0 
[   20.550576] 3e80: c789012c c7890120 00000000 c01eb3d4 c0443452 c785b2c0 c785b2c0 c04a8fa8 
[   20.558770] 3ea0: 00000000 c785b200 00000000 c01eb7dc 00000000 00000000 c785b2c0 c785b2c0 
[   20.566962] 3ec0: c04a8fa8 c0017644 c04a94e0 c04a94e0 c04c2450 c04c2450 c04bf688 c01a202c 
[   20.575156] 3ee0: c04c2450 c01a1210 00000000 c04a94e0 c04a9514 c04c2450 c7823f10 c01a1348 
[   20.583349] 3f00: 00000000 c01a12e8 c04c2450 c01a0aec c78045b8 c7862c90 c04bf688 c001e474 
[   20.591543] 3f20: c04c2450 c04c2450 c78c85a0 c01a03bc c042d6d7 c032576c c78473c0 c001e474 
[   20.599736] 3f40: c04c2434 c04c2450 c00174b4 00000000 00000000 c01a1654 c001e474 c04c2434 
[   20.607929] 3f60: 00000000 c00174b4 00000000 c01a24d8 00000000 c001e474 c001e5fc c00252e8 
[   20.616122] 3f80: c04af8d8 00000179 c04af8d8 c783f180 c04af800 000000bf c04f589c c00c498c 
[   20.624315] 3fa0: c005fe50 c783df60 c7823fb6 c005fe70 c00241b8 39319a20 00000031 00000000 
[   20.632508] 3fc0: 00000000 000000c0 c04abd24 00000000 c001e474 c001e5fc 00000000 00000000 
[   20.640702] 3fe0: 00000000 c0008580 00000000 00000000 00000000 c002683c 00080100 00040000 
[   20.648911] [<c0085d7c>] (__kmalloc_track_caller+0x7c/0xdc) from [<c0072548>] (kstrdup+0x34/0x54)
[   20.657765] [<c0072548>] (kstrdup+0x34/0x54) from [<c00ca778>] (sysfs_new_dirent+0x28/0xe8)
[   20.666097] [<c00ca778>] (sysfs_new_dirent+0x28/0xe8) from [<c00cac24>] (create_dir+0x24/0xa4)
[   20.674674] [<c00cac24>] (create_dir+0x24/0xa4) from [<c00cace0>] (sysfs_create_dir+0x3c/0x5c)
[   20.683230] [<c00cace0>] (sysfs_create_dir+0x3c/0x5c) from [<c0160518>] (kobject_add_internal+0xb8/0x1b8)
[   20.692759] [<c0160518>] (kobject_add_internal+0xb8/0x1b8) from [<c0160798>] (kobject_add+0x48/0x5c)
[   20.701849] [<c0160798>] (kobject_add+0x48/0x5c) from [<c019eed0>] (device_add+0xac/0x510)
[   20.710095] [<c019eed0>] (device_add+0xac/0x510) from [<c01eb1b8>] (spi_add_device+0xe4/0x16c)
[   20.718676] [<c01eb1b8>] (spi_add_device+0xe4/0x16c) from [<c01eb2c0>] (spi_new_device+0x80/0xa0)
[   20.727504] [<c01eb2c0>] (spi_new_device+0x80/0xa0) from [<c01eb3d4>] (spi_register_master+0xf4/0x148)
[   20.736757] [<c01eb3d4>] (spi_register_master+0xf4/0x148) from [<c01eb7dc>] (spi_bitbang_start+0x114/0x150)
[   20.746441] [<c01eb7dc>] (spi_bitbang_start+0x114/0x150) from [<c0017644>] (spi_gpio_probe+0x12c/0x19c)
[   20.755781] [<c0017644>] (spi_gpio_probe+0x12c/0x19c) from [<c01a202c>] (platform_drv_probe+0x1c/0x24)
[   20.765051] [<c01a202c>] (platform_drv_probe+0x1c/0x24) from [<c01a1210>] (driver_probe_device+0xac/0x184)
[   20.774648] [<c01a1210>] (driver_probe_device+0xac/0x184) from [<c01a1348>] (__driver_attach+0x60/0x84)
[   20.783987] [<c01a1348>] (__driver_attach+0x60/0x84) from [<c01a0aec>] (bus_for_each_dev+0x4c/0x8c)
[   20.792990] [<c01a0aec>] (bus_for_each_dev+0x4c/0x8c) from [<c01a03bc>] (bus_add_driver+0x9c/0x218)
[   20.801993] [<c01a03bc>] (bus_add_driver+0x9c/0x218) from [<c01a1654>] (driver_register+0xc0/0x150)
[   20.810987] [<c01a1654>] (driver_register+0xc0/0x150) from [<c01a24d8>] (platform_driver_probe+0x14/0x68)
[   20.820507] [<c01a24d8>] (platform_driver_probe+0x14/0x68) from [<c00252e8>] (do_one_initcall+0x50/0x194)
[   20.830029] [<c00252e8>] (do_one_initcall+0x50/0x194) from [<c0008580>] (kernel_init+0x90/0x10c)
[   20.838773] [<c0008580>] (kernel_init+0x90/0x10c) from [<c002683c>] (kernel_thread_exit+0x0/0x8)
[   20.847516] Code: e59c4080 e59c7090 e3540000 159c308c (17943103) 
[   20.853736] ---[ end trace a8dfcef3f8fd5967 ]---
[   20.858374] Kernel panic - not syncing: Attempted to kill init!
[   20.864261] [<c002a45c>] (unwind_backtrace+0x0/0xdc) from [<c0325670>] (panic+0x34/0x118)
[   20.872453] [<c0325670>] (panic+0x34/0x118) from [<c003b004>] (do_exit+0x64/0x59c)
[   20.880033] [<c003b004>] (do_exit+0x64/0x59c) from [<c0029484>] (die+0x13c/0x15c)
[   20.887510] [<c0029484>] (die+0x13c/0x15c) from [<c002b694>] (__do_kernel_fault+0x68/0x80)
[   20.895728] [<c002b694>] (__do_kernel_fault+0x68/0x80) from [<c002b8bc>] (do_page_fault+0x210/0x230)
[   20.904835] [<c002b8bc>] (do_page_fault+0x210/0x230) from [<c0025234>] (do_DataAbort+0x30/0x90)
[   20.913528] [<c0025234>] (do_DataAbort+0x30/0x90) from [<c0025a0c>] (__dabt_svc+0x4c/0x60)
[   20.921790] Exception stack(0xc7823d20 to 0xc7823d68)
[   20.926826] 3d20: c04a42e4 00000005 c04a4000 00000000 69766564 a0000013 000000d0 00000020 
[   20.935019] 3d40: c00ca778 00000000 000041ed 00000000 c04a42e4 c7823d68 c0085d44 c0085d7c 
[   20.943230] 3d60: 20000093 ffffffff                                                       
[   20.951445] [<c0025a0c>] (__dabt_svc+0x4c/0x60) from [<c0085d7c>] (__kmalloc_track_caller+0x7c/0xdc)
[   20.960569] [<c0085d7c>] (__kmalloc_track_caller+0x7c/0xdc) from [<c0072548>] (kstrdup+0x34/0x54)
[   20.969443] [<c0072548>] (kstrdup+0x34/0x54) from [<c00ca778>] (sysfs_new_dirent+0x28/0xe8)
[   20.977800] [<c00ca778>] (sysfs_new_dirent+0x28/0xe8) from [<c00cac24>] (create_dir+0x24/0xa4)
[   20.986404] [<c00cac24>] (create_dir+0x24/0xa4) from [<c00cace0>] (sysfs_create_dir+0x3c/0x5c)
[   20.994976] [<c00cace0>] (sysfs_create_dir+0x3c/0x5c) from [<c0160518>] (kobject_add_internal+0xb8/0x1b8)
[   21.004524] [<c0160518>] (kobject_add_internal+0xb8/0x1b8) from [<c0160798>] (kobject_add+0x48/0x5c)
[   21.013648] [<c0160798>] (kobject_add+0x48/0x5c) from [<c019eed0>] (device_add+0xac/0x510)
[   21.021927] [<c019eed0>] (device_add+0xac/0x510) from [<c01eb1b8>] (spi_add_device+0xe4/0x16c)
[   21.030526] [<c01eb1b8>] (spi_add_device+0xe4/0x16c) from [<c01eb2c0>] (spi_new_device+0x80/0xa0)
[   21.039381] [<c01eb2c0>] (spi_new_device+0x80/0xa0) from [<c01eb3d4>] (spi_register_master+0xf4/0x148)
[   21.048671] [<c01eb3d4>] (spi_register_master+0xf4/0x148) from [<c01eb7dc>] (spi_bitbang_start+0x114/0x150)
[   21.058394] [<c01eb7dc>] (spi_bitbang_start+0x114/0x150) from [<c0017644>] (spi_gpio_probe+0x12c/0x19c)
[   21.067779] [<c0017644>] (spi_gpio_probe+0x12c/0x19c) from [<c01a202c>] (platform_drv_probe+0x1c/0x24)
[   21.077074] [<c01a202c>] (platform_drv_probe+0x1c/0x24) from [<c01a1210>] (driver_probe_device+0xac/0x184)
[   21.086714] [<c01a1210>] (driver_probe_device+0xac/0x184) from [<c01a1348>] (__driver_attach+0x60/0x84)
[   21.096086] [<c01a1348>] (__driver_attach+0x60/0x84) from [<c01a0aec>] (bus_for_each_dev+0x4c/0x8c)
[   21.105098] [<c01a0aec>] (bus_for_each_dev+0x4c/0x8c) from [<c01a03bc>] (bus_add_driver+0x9c/0x218)
[   21.114128] [<c01a03bc>] (bus_add_driver+0x9c/0x218) from [<c01a1654>] (driver_register+0xc0/0x150)
[   21.123166] [<c01a1654>] (driver_register+0xc0/0x150) from [<c01a24d8>] (platform_driver_probe+0x14/0x68)
[   21.132719] [<c01a24d8>] (platform_driver_probe+0x14/0x68) from [<c00252e8>] (do_one_initcall+0x50/0x194)
[   21.142275] [<c00252e8>] (do_one_initcall+0x50/0x194) from [<c0008580>] (kernel_init+0x90/0x10c)
[   21.151036] [<c0008580>] (kernel_init+0x90/0x10c) from [<c002683c>] (kernel_thread_exit+0x0/0x8)


