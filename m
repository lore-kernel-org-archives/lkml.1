Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZFTVRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZFTVRT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 17:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZFTVRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 17:17:12 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:11742 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZFTVRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 17:17:10 -0400
Message-ID: <4A3D51D2.4080707@hp.com>
Date: Sat, 20 Jun 2009 17:17:06 -0400
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Kay Sievers <kay.sievers@vrfy.org>, Martin Knoblauch <knobi@knobisoft.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, efault@gmx.de,
       viro@zeniv.linux.org.uk, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, mike.miller@hp.com, linux-pci@vger.kernel.org
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
References: <20090527133125.c36381b5.akpm@linux-foundation.org> <ac3eb2510905271356n1b01f273jca1f7aa8fc65c78b@mail.gmail.com> <170150.72851.qm@web32604.mail.mud.yahoo.com> <20090616122547.1323d2d4@jbarnes-g45> <971371.70253.qm@web32604.mail.mud.yahoo.com> <4A3D104E.9060105@hp.com> <20090620165853.GL19977@parisc-linux.org> <ac3eb2510906201119r5c528a3s67cd04bdbfdd1d9c@mail.gmail.com> <20090620182617.GM19977@parisc-linux.org> <ac3eb2510906201136v4c6eac1bwffd2aed3e38c6ae1@mail.gmail.com> <20090620190630.GN19977@parisc-linux.org>
In-Reply-To: <20090620190630.GN19977@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Sat, Jun 20, 2009 at 08:36:25PM +0200, Kay Sievers wrote:
>> Ah, I see. There is no tool around udev, I know of, which does this.
>>
>> Maybe someone is still using the broken-by-design libsysfs, which
>> opens _every_ file it can find in /sys, even when not asked for
>> anything specific.
> 
> I did consider that option, but dismissed it ... I didn't think anyone
> was using something that old.

My test is a fresh RHEL 4.3 install with 2.6.30-rc8.  Whatever
scripts are running are stock redhat and I'm still in initrd
so what would I be looking for?

The initrd timeouts all seem to be triggered by the insmod and
only 1 more vpd read happens in init 3 at the end after HAL starts.

This is the BUG() I set to ID (maybe incorrectly)
that the vpd reads were comming from udev:

[    5.260664] ------------[ cut here ]------------
[    5.260667] kernel BUG at 
/root/linux-2.6.30-rc8/drivers/pci/access.c:207!
[    5.260671] invalid opcode: 0000 [#1] SMP
[    5.260675] last sysfs file: 
/sys/devices/pci0000:00/0000:00:02.0/0000:02:00.2/0000:04:03.0/msi_bus
[    5.260678] CPU 1
[    5.260681] Modules linked in: cciss(+) sd_mod scsi_mod
[    5.260689] Pid: 476, comm: udev Not tainted 2.6.30-rc8 #33 ProLiant 
DL380 G4
[    5.260692] RIP: 0010:[<ffffffff803b282f>]  [<ffffffff803b282f>] 
pci_vpd_pci22_wait+0xef/0x100
[    5.260703] RSP: 0018:ffff8801199e7dd8  EFLAGS: 00010246
[    5.260706] RAX: 0000000000000000 RBX: ffff88011ad60440 RCX: 
0000000000001001
[    5.260709] RDX: 0000000000007c7b RSI: 0000000000000001 RDI: 
ffffffff8072c160
[    5.260712] RBP: ffff8801199e7e08 R08: 0000000000000001 R09: 
0000000000000001
[    5.260715] R10: 0000000000000000 R11: 0000000000000006 R12: 
ffff88011ac8d800
[    5.260718] R13: 00000000fffee028 R14: ffff88011ac8d800 R15: 
ffff88011992e000
[    5.260722] FS:  0000000000000000(0000) GS:ffff88002edd9000(0000) 
knlGS:0000000000000000
[    5.260725] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    5.260728] CR2: 00000000022562b8 CR3: 00000001198ef000 CR4: 
00000000000006e0
[    5.260731] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[    5.260734] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[    5.260738] Process udev (pid: 476, threadinfo ffff8801199e6000, task 
ffff88011b78c3c0)
[    5.260740] Stack:
[    5.260742]  ffff8801199e7e08 0000ffff803b268d 0000000000001000 
0000000000000000
[    5.260746]  0000000000000000 ffff88011ad60440 ffff8801199e7e68 
ffffffff803b292c
[    5.260752]  ffffffff803455f6 ffff88011ad60458 0000000000001000 
0000000000001000
[    5.260757] Call Trace:
[    5.260760]  [<ffffffff803b292c>] pci_vpd_pci22_read+0xec/0x170
[    5.260765]  [<ffffffff803455f6>] ? read+0x96/0x1b0
[    5.260771]  [<ffffffff803b22a9>] pci_read_vpd+0x29/0x40
[    5.260775]  [<ffffffff803bab06>] read_vpd_attr+0x46/0x50
[    5.260780]  [<ffffffff803456fb>] read+0x19b/0x1b0
[    5.260784]  [<ffffffff80363566>] ? security_file_permission+0x16/0x20
[    5.260790]  [<ffffffff802e3f5d>] vfs_read+0xbd/0x190
[    5.260797]  [<ffffffff802e4365>] sys_read+0x55/0x90
[    5.260801]  [<ffffffff8020b71b>] system_call_fastpath+0x16/0x1b
[    5.260807] Code: c9 c3 8b 35 74 33 fe 00 31 c0 4c 89 e2 48 c7 c7 ed 
89 6a 80 e8 b3 3d e9 ff 8b 05 5d 33 fe 00 ff c0 89 05 55 33 fe 00 ff c8 
75 04 <0f> 0b eb fe b8 92 ff ff ff e9 35 ff ff ff 66 66 90 55 48 89 e5
[    5.260845] RIP  [<ffffffff803b282f>] pci_vpd_pci22_wait+0xef/0x100
[    5.260849]  RSP <ffff8801199e7dd8>
[    5.260854] ---[ end trace 37f1683404a28980 ]---


here is a single user boot with a timeout printk() and a hack
in mkinitrd to sleep before and after the insmod cciss:

[    3.858278] NET: Registered protocol family 17
[    3.864293] Freeing unused kernel memory: 2416k freed
Red Hat nash version 4.2.1.6 starting
Mounted /proc filesystem
Mounting sysfs
Creating /dev
Starting udev
[    3.876470] udev used greatest stack depth: 5632 bytes left
Loading scsi_mod.ko module
[    3.977087] SCSI subsystem initialized
Loading sd_mod.ko module
[    3.987672] Driver 'sd' needs updating - please use bus_type methods
[    4.280095] input: AT Translated Set 2 keyboard as /class/input/input0
[    4.626432] input: PS/2 Generic Mouse as /class/input/input1
JIM sleep 1
Loading cciss.ko module
[    4.999782] HP CISS Driver (v 3.6.20)
[    5.003771] cciss 0000:04:03.0: PCI INT A -> GSI 51 (level, low) -> 
IRQ 51
[    5.052021] IRQ 51/cciss0: IRQF_DISABLED is not guaranteed on shared IRQs
[    5.059001] cciss0: <0x46> at PCI 0000:04:03.0 IRQ 51 using DAC
[    5.065800]       blocks= 71122560 block_size= 512
[    5.070602]       heads=255, sectors=32, cylinders=8716
[    5.070603]
[    5.077428]       blocks= 71122560 block_size= 512
[    5.082151]       heads=255, sectors=32, cylinders=8716
[    5.082153]
[    5.089413]  cciss/c0d0: p1
[    5.131820]       blocks= 71122560 block_size= 512
[    5.139627]       heads=255, sectors=32, cylinders=8716
[    5.139629]
[    5.146117]       blocks= 71122560 block_size= 512
[    5.150887]       heads=255, sectors=32, cylinders=8716
[    5.150889]
[    5.157577]  cciss/c0d1: p1
[    5.160261] TIMEOUT 1 ffff88011ad54800
[    5.164164]  p2 p3
[    5.208880]       blocks= 142253280 block_size= 512
[    5.215732]       heads=255, sectors=32, cylinders=17433
[    5.215734]
[    5.223191]       blocks= 142253280 block_size= 512
[    5.227965]
[    5.227966] TIMEOUT 2 ffff88011ad54800
[    5.232942]       heads=255, sectors=32, cylinders=17433
[    5.232944]
[    5.239516]  cciss/c0d2: p1 p2 p3
[    5.292263]
[    5.292265] TIMEOUT 3 ffff88011ad54800
[    5.356262]
[    5.356263] TIMEOUT 4 ffff88011ad54800
[    5.420266]
[    5.420267] TIMEOUT 5 ffff88011ad54800
[    5.484855]
[    5.484857] TIMEOUT 6 ffff88011ad54800
[    5.491980]       blocks= 71122560 block_size= 512
[    5.496991]       heads=255, sectors=32, cylinders=8716
[    5.496993]
[    5.503484]       blocks= 71122560 block_size= 512
[    5.508761]       heads=255, sectors=32, cylinders=8716
[    5.508763]
[    5.515729]  cciss/c0d3: p1
[    5.548263]
[    5.548264] TIMEOUT 7 ffff88011ad54800
[    5.610138] work_for_cpu used greatest stack depth: 4592 bytes left
[    5.612264]
[    5.612266] TIMEOUT 8 ffff88011ad54800
[    5.674223]
[    5.674224] TIMEOUT 9 ffff88011ad54800
[    5.736261]
[    5.736263] TIMEOUT 10 ffff88011ad54800
[    5.800261]
[    5.800263] TIMEOUT 11 ffff88011ad54800
[    5.864259]
[    5.864260] TIMEOUT 12 ffff88011ad54800
[    5.928259]
[    5.928260] TIMEOUT 13 ffff88011ad54800
[    5.992011]
[    5.992012] TIMEOUT 14 ffff88011ad54800
[    6.056011]
[    6.056012] TIMEOUT 15 ffff88011ad54800
[    6.120011]
[    6.120013] TIMEOUT 16 ffff88011ad54800
[    6.184011]
[    6.184012] TIMEOUT 17 ffff88011ad54800
[    6.248011]
[    6.248012] TIMEOUT 18 ffff88011ad54800
[    6.312011]
[    6.312012] TIMEOUT 19 ffff88011ad54800
[    6.376011]
[    6.376013] TIMEOUT 20 ffff88011ad54800
JIM sleep 1
Loading jbd.ko module
Loading ext3.ko module
Creating root device
Mounting root filesystem
[    6.760540] kjournald starting.  Commit interval 5 seconds
[    6.765559] EXT3-fs: mounted filesystem with writeback data mode.
Switching to new root
[    6.946395] SELinux:  Disabled at runtime.
[    6.950840] type=1404 audit(1245517131.950:2): selinux=0 
auid=4294967295 ses=4294967295
INIT: version 2.85 booting
[    7.235810] uname used greatest stack depth: 4296 bytes left
[    7.304350] awk used greatest stack depth: 3688 bytes left
		Welcome to Red Hat Enterprise Linux AS
		Press 'I' to enter interactive startup.
Starting udev:  [  OK  ]
Initializing hardware...  storage network audio done[  OK  ]
Configuring kernel parameters:  [  OK  ]
Setting clock  (utc): Sat Jun 20 12:59:02 EDT 2009 [  OK  ]
Setting hostname dl380.lnx.usa.hp.com:  [  OK  ]
Checking root filesystem
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/cciss/c0d1p3
/1: clean, 348377/4177920 files, 2477319/8351791 blocks
[  OK  ]
Remounting root filesystem in read-write mode:  [  OK  ]
No devices found
no block devices found
Setting up Logical Volume Management: [  OK  ]
Checking filesystems
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /boot] fsck.ext3 -a /dev/cciss/c0d1p1
/boot12: clean, 46/26104 files, 26042/104388 blocks
[  OK  ]
Mounting local filesystems:  [  OK  ]
Enabling local filesystem quotas:  [  OK  ]
Enabling swap space:  [  OK  ]
sh-3.00#

