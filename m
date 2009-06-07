Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbZFGWp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbZFGWp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 18:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbZFGWpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 18:45:22 -0400
Received: from woodchuck.wormnet.eu ([77.75.105.223]:47490 "EHLO
	woodchuck.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbZFGWpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 18:45:20 -0400
Date: Sun, 7 Jun 2009 23:45:20 +0100
From: Alexander Clouter <alex@digriz.org.uk>
To: linux-kernel@vger.kernel.org
Subject: driver model advice
Message-ID: <20090607224519.GO2014@woodchuck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: alex@digriz.org.uk
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For a while I have been maintaining the TS-7800 mainline support[1] and 
decided to attempt to properly address support for the FPGA on the 
board.

Currently the solution I'm using[2] is not very flexible and scalable as 
for every device that is added the platform code grows with it.  I also 
think it's just not very pretty.

I have been reading various sources of documentation regarding the 
driver model and relevant sections in the LDD tomb and felt that making 
the FPGA behave as a bus seemed a neat way to do things.

A quick overview of the approach I'm using is that the bus code adds and 
removes the devices depending on the bus's state ('online' or 
'offline').  When going online (or as new drivers are insmod'ed) the bus 
decides if the 'discover' function should be executed depending on the 
FPGA bitstream magic number and then if the driver's discover() function 
decides the device is present it is added to the bus.

The code for my amendments can be found (it's 30kB hence why it's not 
inline), it's been written against 2.6.30-rc7:

http://stuff.digriz.org.uk/ts78xx-fpga/fpga-device-work.diff

and the my .config file is:

http://stuff.digriz.org.uk/ts78xx-fpga/ts78xx.config

One thing that might make people 'queasy' is that there is some wrapper 
code for platform drivers.  Although all the examples I have coded up 
use platform drivers and create platform devices, there are some drivers 
that are non-platform based in the works (GPIO, AVR, ISA bus, etc).  I 
felt the appropriate approach was (bearing in mind that different FPGA 
bitstreams implement possibly overlapping/partial duplicate 
functionality) to use a platform wrapper, the platform device being a 
child of my ts78xx-fgpa device.

The problem with my code is that it deadlocks, attached inline below,
when drivers are rmmod'd and also when the FPGA bus attempts to remove 
all the devices attached to the bus.  Seems to be linked generally to 
recursive calling of device_del() which I cannot see a way of 
preventing.

I have been hammering away at these deadlocking issues for weeks and 
would greatly appreciate it if anyone can take a moment to explain what 
(probably trivial) thing I have been missing.  I'm really stumped :-/

Cheers

Alex

[1] http://armlinux.simtec.co.uk/kautobuild/2.6.30-rc8-git4/index.html#machine_1653
[2] http://git.marvell.com/?p=orion.git;a=blob;f=arch/arm/mach-orion5x/ts78xx-setup.c;hb=HEAD

----
# insmod ts78xx-fpga-ts-nand.ko 
Registering ts78xx-fpga device 'ts-nand'
NAND device: Manufacturer ID: 0x2c, Chip ID: 0xdc (Micron NAND 512MiB 3,3V 8-bit)
Creating 4 MTD partitions on "gen_nand":
0x000000000000-0x000000020000 : "mbr"
0x000000020000-0x000000420000 : "kernel"
0x000000420000-0x000000820000 : "initrd"
0x000000820000-0x000020000000 : "rootfs"

rmmod
--------------------------
# rmmod ts78xx-fpga-ts-nand
unwind: Index not found bf0000e8
unwind: Index not found bf0000e8
unwind: Index not found bf0000e8
unwind: Index not found bf0000e8
unwind: Index not found bf0000e8
unwind: Index not found bf0000e8
unwind: Index not found bf0000e8
unwind: Index not found bf0000e8
unwind: Index not found bf0000e8
unwind: Index not found bf0000e8
unwind: Index not found bf0000e8
unwind: Index not found bf0000e8
INFO: task rmmod:282 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rmmod         D c03b8048     0   282    263
[<c03b8048>] (__schedule+0x454/0x498) from [<c03b80a8>] (schedule+0x1c/0x2c)
[<c03b80a8>] (schedule+0x1c/0x2c) from [<c03b8250>] (schedule_timeout+0x24/0x188)
[<c03b8250>] (schedule_timeout+0x24/0x188) from [<c03b98fc>] (__down+0x70/0xa4)
[<c03b98fc>] (__down+0x70/0xa4) from [<c0131750>] (down+0x34/0x44)
[<c0131750>] (down+0x34/0x44) from [<c02a7710>] (device_release_driver+0x1c/0x30)
[<c02a7710>] (device_release_driver+0x1c/0x30) from [<c02a6a40>] (bus_remove_device+0xf0/0x13c)
[<c02a6a40>] (bus_remove_device+0xf0/0x13c) from [<c02a46f0>] (device_del+0x114/0x194)
[<c02a46f0>] (device_del+0x114/0x194) from [<c02a47cc>] (device_unregister+0x5c/0x90)
[<c02a47cc>] (device_unregister+0x5c/0x90) from [<c010c930>] (ts78xx_fpga_device_unregister+0x84/0x8c)
[<c010c930>] (ts78xx_fpga_device_unregister+0x84/0x8c) from [<bf0000b0>] (ts_nand_remove+0x10/0x18 [ts78xx_fpg)
[<bf0000b0>] (ts_nand_remove+0x10/0x18 [ts78xx_fpga_ts_nand]) from [<c010c4c4>] (ts78xx_fpga_device_remove+0x4)
[<c010c4c4>] (ts78xx_fpga_device_remove+0x40/0x48) from [<c02a7618>] (__device_release_driver+0x88/0xac)
[<c02a7618>] (__device_release_driver+0x88/0xac) from [<c02a76cc>] (driver_detach+0x90/0xb8)
[<c02a76cc>] (driver_detach+0x90/0xb8) from [<c02a65dc>] (bus_remove_driver+0xd8/0x138)
[<c02a65dc>] (bus_remove_driver+0xd8/0x138) from [<c02a7eec>] (driver_unregister+0x48/0x4c)
[<c02a7eec>] (driver_unregister+0x48/0x4c) from [<c010c80c>] (ts78xx_fpga_driver_unregister+0x2c/0x34)
[<c010c80c>] (ts78xx_fpga_driver_unregister+0x2c/0x34) from [<bf0000e8>] (ts_nand_exit+0x14/0x38 [ts78xx_fpga_)
unwind: Index not found bf0000e8
no locks held by rmmod/282.

--------------------------

offline
--------------------------
# echo offline > /sys/bus/ts78xx-fpga/state 
Unable to handle kernel NULL pointer dereference at virtual address 00000028
pgd = c71c4000
[00000028] *pgd=071d9031, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1]
Modules linked in: ts78xx_fpga_ts_nand
CPU: 0    Not tainted  (2.6.30-rc7-25789-gd9abd69 #543)
PC is at klist_put+0x20/0x8c
LR is at klist_del+0x14/0x18
pc : [<c03b1fe0>]    lr : [<c03b2094>]    psr: a0000013
sp : c72bdd10  ip : c72bdd30  fp : c72bdd2c
r10: c72bdf70  r9 : c7158918  r8 : c04e7d1c
r7 : 00000000  r6 : bf000960  r5 : c784df8c  r4 : 00000001
r3 : 00000000  r2 : c7149208  r1 : 00000001  r0 : 00000000
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: b005317f  Table: 071c4000  DAC: 00000015
Process echo (pid: 282, stack limit = 0xc72bc268)
Stack: (0xc72bdd10 to 0xc72be000)
dd00:                                     c7149208 bf000960 bf000960 c72bdeb8 
dd20: c72bdd3c c72bdd30 c03b2094 c03b1fd0 c72bdd5c c72bdd40 c02a4628 c03b2090 
dd40: 00000000 00000000 bf000960 c7149200 c72bdd7c c72bdd60 c02a91a0 c02a45ec 
dd60: c72bdd60 c7149200 bf000960 bf000958 c72bdd94 c72bdd80 c02a9618 c02a918c 
dd80: c7158918 bf000968 c72bddb4 c72bdd98 c010c8e8 c02a9610 c71d60f0 bf000968 
dda0: bf000960 bf00090c c72bddc4 c72bddb8 bf0000b0 c010c8bc c72bddd4 c72bddc8 
ddc0: c010c4c4 bf0000b0 c72bddf4 c72bddd8 c02a7618 c010c494 c013175c bf000960 
dde0: bf000994 c04d4b40 c72bde0c c72bddf8 c02a7718 c02a75a0 bf000960 bf000960 
de00: c72bde2c c72bde10 c02a6a40 c02a7704 c7835500 bf000960 bf000968 c7835500 
de20: c72bde4c c72bde30 c02a46f0 c02a6960 c03ba72c bf000960 00000038 bf000958 
de40: c72bde64 c72bde50 c02a47cc c02a45ec c0140374 00000003 c72bde84 c72bde68 
de60: c010c930 c02a4780 c02a6474 00000000 c010c570 00000000 c72bde94 c72bde88 
de80: bf0000b0 c010c8bc c72bdea4 c72bde98 c010c4c4 bf0000b0 c72bdeb4 c72bdea8 
dea0: c010c580 c010c494 c72bdedc c72bdeb8 c02a7038 c010c580 c7835654 c70eeacc 
dec0: c04d4b30 00000000 00000008 c7835624 c72bdf04 c72bdee0 c010c7a4 c02a6ff0 
dee0: 40020000 c7158900 c715e900 00000008 c784e900 c7158900 c72bdf14 c72bdf08 
df00: c02a60d0 c010c6ec c72bdf44 c72bdf18 c01c21c0 c02a60b0 c0130fa8 c715e900 
df20: 40020000 00000008 c72bdf70 40020000 c72bc000 40025000 c72bdf6c c72bdf48 
df40: c017e914 c01c20bc c72bdfb0 00000000 00000000 00000000 c715e900 00000008 
df60: c72bdfa4 c72bdf70 c017ea58 c017e870 00000000 00000000 c0109830 00000000 
df80: ffffffff 00000008 40020000 401f65e0 00000004 c0102fc4 00000000 c72bdfa8 
dfa0: c0102e40 c017ea24 00000008 40020000 00000001 40020000 00000008 00000000 
dfc0: 00000008 40020000 401f65e0 00000004 00000008 00000000 40025000 00000000 
dfe0: 40020000 bed24ce0 40136c9c 40186c9c 60000010 00000001 a5425aa4 a7df56ac 
[<c03b1fe0>] (klist_put+0x20/0x8c) from [<c03b2094>] (klist_del+0x14/0x18)
[<c03b2094>] (klist_del+0x14/0x18) from [<c02a4628>] (device_del+0x4c/0x194)
[<c02a4628>] (device_del+0x4c/0x194) from [<c02a91a0>] (platform_device_del+0x24/0x64)
[<c02a91a0>] (platform_device_del+0x24/0x64) from [<c02a9618>] (platform_device_unregister+0x18/0x24)
[<c02a9618>] (platform_device_unregister+0x18/0x24) from [<c010c8e8>] (ts78xx_fpga_device_unregister+0x3c/0x8c)
[<c010c8e8>] (ts78xx_fpga_device_unregister+0x3c/0x8c) from [<bf0000b0>] (ts_nand_remove+0x10/0x18 [ts78xx_fpg)
[<bf0000b0>] (ts_nand_remove+0x10/0x18 [ts78xx_fpga_ts_nand]) from [<c010c4c4>] (ts78xx_fpga_device_remove+0x4)
[<c010c4c4>] (ts78xx_fpga_device_remove+0x40/0x48) from [<c02a7618>] (__device_release_driver+0x88/0xac)
[<c02a7618>] (__device_release_driver+0x88/0xac) from [<c02a7718>] (device_release_driver+0x24/0x30)
[<c02a7718>] (device_release_driver+0x24/0x30) from [<c02a6a40>] (bus_remove_device+0xf0/0x13c)
[<c02a6a40>] (bus_remove_device+0xf0/0x13c) from [<c02a46f0>] (device_del+0x114/0x194)
[<c02a46f0>] (device_del+0x114/0x194) from [<c02a47cc>] (device_unregister+0x5c/0x90)
[<c02a47cc>] (device_unregister+0x5c/0x90) from [<c010c930>] (ts78xx_fpga_device_unregister+0x84/0x8c)
[<c010c930>] (ts78xx_fpga_device_unregister+0x84/0x8c) from [<bf0000b0>] (ts_nand_remove+0x10/0x18 [ts78xx_fpg)
[<bf0000b0>] (ts_nand_remove+0x10/0x18 [ts78xx_fpga_ts_nand]) from [<c010c4c4>] (ts78xx_fpga_device_remove+0x4)
[<c010c4c4>] (ts78xx_fpga_device_remove+0x40/0x48) from [<c010c580>] (ts78xx_fpga_device_detach+0x10/0x14)
[<c010c580>] (ts78xx_fpga_device_detach+0x10/0x14) from [<c02a7038>] (bus_for_each_dev+0x58/0x98)
[<c02a7038>] (bus_for_each_dev+0x58/0x98) from [<c010c7a4>] (ts78xx_fpga_store+0xc8/0x104)
[<c010c7a4>] (ts78xx_fpga_store+0xc8/0x104) from [<c02a60d0>] (bus_attr_store+0x30/0x34)
[<c02a60d0>] (bus_attr_store+0x30/0x34) from [<c01c21c0>] (sysfs_write_file+0x114/0x14c)
[<c01c21c0>] (sysfs_write_file+0x114/0x14c) from [<c017e914>] (vfs_write+0xb4/0x134)
[<c017e914>] (vfs_write+0xb4/0x134) from [<c017ea58>] (sys_write+0x44/0x70)
[<c017ea58>] (sys_write+0x44/0x70) from [<c0102e40>] (ret_fast_syscall+0x0/0x2c)
Code: e1a04001 e1a05000 e3c37001 e1a00007 (e5976028) 
---[ end trace 92e6ea2ce7509152 ]---
Segmentation fault
# 
--------------------------

offline (CONFIG_PM)
--------------------------
# echo offline > /sys/bus/ts78xx-fpga/state 
Unable to handle kernel NULL pointer dereference at virtual address 00000018
pgd = c71e8000
[00000018] *pgd=071dc031, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1]
Modules linked in: ts78xx_fpga_ts_nand
CPU: 0    Not tainted  (2.6.30-rc7-25789-gd9abd69 #545)
PC is at sysfs_find_dirent+0x10/0x40
LR is at sysfs_get_dirent+0x2c/0x80
pc : [<c01c3224>]    lr : [<c01c3344>]    psr: 40000013
sp : c7871cd8  ip : c7871cf0  fp : c7871cec
r10: c7871f70  r9 : c714b918  r8 : c04eddac
r7 : c7871eb8  r6 : c04ee054  r5 : c0444892  r4 : 00000000
r3 : 22222222  r2 : ffffffd0  r1 : c0444892  r0 : 00000000
Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: b005317f  Table: 071e8000  DAC: 00000015
Process echo (pid: 283, stack limit = 0xc7870268)
Stack: (0xc7871cd8 to 0xc7872000)
1cc0:                                                       00000000 c0444892 
1ce0: c7871d04 c7871cf0 c01c3344 c01c3224 00000000 c7148210 c7871d2c c7871d08 
1d00: c01c5340 c01c3328 bf000960 bf000960 c7148208 bf000960 bf000960 c7871eb8 
1d20: c7871d3c c7871d30 c02ab6b0 c01c5320 c7871d5c c7871d40 c02a4b8c c02ab6a8 
1d40: 00000000 00000000 bf000960 c7148200 c7871d7c c7871d60 c02a9730 c02a4b5c 
1d60: c7871d60 c7148200 bf000960 bf000958 c7871d94 c7871d80 c02a9ba8 c02a971c 
1d80: c714b918 bf000968 c7871db4 c7871d98 c010c8e8 c02a9ba0 c71dd330 bf000968 
1da0: bf000960 bf00090c c7871dc4 c7871db8 bf0000b0 c010c8bc c7871dd4 c7871dc8 
1dc0: c010c4c4 bf0000b0 c7871df4 c7871dd8 c02a7ba8 c010c494 c0131758 bf000960 
1de0: bf000994 c04dab40 c7871e0c c7871df8 c02a7ca8 c02a7b30 bf000960 bf000960 
1e00: c7871e2c c7871e10 c02a6fd0 c02a7c94 c7835500 bf000960 bf000968 c7835500 
1e20: c7871e4c c7871e30 c02a4c68 c02a6ef0 c03bdebc bf000960 00000038 bf000958 
1e40: c7871e64 c7871e50 c02a4d44 c02a4b5c c0140370 00000003 c7871e84 c7871e68 
1e60: c010c930 c02a4cf8 c02a6a04 00000000 c010c570 00000000 c7871e94 c7871e88 
1e80: bf0000b0 c010c8bc c7871ea4 c7871e98 c010c4c4 bf0000b0 c7871eb4 c7871ea8 
1ea0: c010c580 c010c494 c7871edc c7871eb8 c02a75c8 c010c580 c7835654 c70eaa0c 
1ec0: c04dab30 00000000 00000008 c7835624 c7871f04 c7871ee0 c010c7a4 c02a7580 
1ee0: 40020000 c714b900 c7163180 00000008 c784eea0 c714b900 c7871f14 c7871f08 
1f00: c02a6660 c010c6ec c7871f44 c7871f18 c01c2558 c02a6640 00000000 c7163180 
1f20: 40020000 00000008 c7871f70 40020000 c7870000 40025000 c7871f6c c7871f48 
1f40: c017ecb8 c01c2454 c0131ee8 c0131e40 00000000 00000000 c7163180 00000008 
1f60: c7871fa4 c7871f70 c017edfc c017ec14 00000000 00000000 40020000 00000000 
1f80: c7870000 00000008 40020000 401f65e0 00000004 c0102fc4 00000000 c7871fa8 
1fa0: c0102e40 c017edc8 00000008 40020000 00000001 40020000 00000008 00000000 
1fc0: 00000008 40020000 401f65e0 00000004 00000008 00000000 40025000 00000000 
1fe0: 40020000 bec9ece0 40136c9c 40186c9c 60000010 00000001 00000000 00000000
[<c01c3224>] (sysfs_find_dirent+0x10/0x40) from [<c01c3344>] (sysfs_get_dirent+0x2c/0x80)
[<c01c3344>] (sysfs_get_dirent+0x2c/0x80) from [<c01c5340>] (sysfs_remove_group+0x30/0x114)
[<c01c5340>] (sysfs_remove_group+0x30/0x114) from [<c02ab6b0>] (dpm_sysfs_remove+0x18/0x20)
[<c02ab6b0>] (dpm_sysfs_remove+0x18/0x20) from [<c02a4b8c>] (device_del+0x40/0x19c)
[<c02a4b8c>] (device_del+0x40/0x19c) from [<c02a9730>] (platform_device_del+0x24/0x64)
[<c02a9730>] (platform_device_del+0x24/0x64) from [<c02a9ba8>] (platform_device_unregister+0x18/0x24)
[<c02a9ba8>] (platform_device_unregister+0x18/0x24) from [<c010c8e8>] (ts78xx_fpga_device_unregister+0x3c/0x8c)
[<c010c8e8>] (ts78xx_fpga_device_unregister+0x3c/0x8c) from [<bf0000b0>] (ts_nand_remove+0x10/0x18 [ts78xx_fpg)
[<bf0000b0>] (ts_nand_remove+0x10/0x18 [ts78xx_fpga_ts_nand]) from [<c010c4c4>] (ts78xx_fpga_device_remove+0x4)
[<c010c4c4>] (ts78xx_fpga_device_remove+0x40/0x48) from [<c02a7ba8>] (__device_release_driver+0x88/0xac)
[<c02a7ba8>] (__device_release_driver+0x88/0xac) from [<c02a7ca8>] (device_release_driver+0x24/0x30)
[<c02a7ca8>] (device_release_driver+0x24/0x30) from [<c02a6fd0>] (bus_remove_device+0xf0/0x13c)
[<c02a6fd0>] (bus_remove_device+0xf0/0x13c) from [<c02a4c68>] (device_del+0x11c/0x19c)
[<c02a4c68>] (device_del+0x11c/0x19c) from [<c02a4d44>] (device_unregister+0x5c/0x90)
[<c02a4d44>] (device_unregister+0x5c/0x90) from [<c010c930>] (ts78xx_fpga_device_unregister+0x84/0x8c)
[<c010c930>] (ts78xx_fpga_device_unregister+0x84/0x8c) from [<bf0000b0>] (ts_nand_remove+0x10/0x18 [ts78xx_fpg)
[<bf0000b0>] (ts_nand_remove+0x10/0x18 [ts78xx_fpga_ts_nand]) from [<c010c4c4>] (ts78xx_fpga_device_remove+0x4)
[<c010c4c4>] (ts78xx_fpga_device_remove+0x40/0x48) from [<c010c580>] (ts78xx_fpga_device_detach+0x10/0x14)
[<c010c580>] (ts78xx_fpga_device_detach+0x10/0x14) from [<c02a75c8>] (bus_for_each_dev+0x58/0x98)
[<c02a75c8>] (bus_for_each_dev+0x58/0x98) from [<c010c7a4>] (ts78xx_fpga_store+0xc8/0x104)
[<c010c7a4>] (ts78xx_fpga_store+0xc8/0x104) from [<c02a6660>] (bus_attr_store+0x30/0x34)
[<c02a6660>] (bus_attr_store+0x30/0x34) from [<c01c2558>] (sysfs_write_file+0x114/0x14c)
[<c01c2558>] (sysfs_write_file+0x114/0x14c) from [<c017ecb8>] (vfs_write+0xb4/0x134)
[<c017ecb8>] (vfs_write+0xb4/0x134) from [<c017edfc>] (sys_write+0x44/0x70)
[<c017edfc>] (sys_write+0x44/0x70) from [<c0102e40>] (ret_fast_syscall+0x0/0x2c)
Code: e1a0c00d e92dd830 e24cb004 e1a05001 (e5904018) 
---[ end trace 126bba8f531acfcb ]---
Segmentation fault
# 
--------------------------

-- 
Alexander Clouter
.sigmonster says: Prices subject to change without notice.
