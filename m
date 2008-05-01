Return-Path: <linux-kernel-owner+w=401wt.eu-S1760678AbYEAAvC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678AbYEAAvC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:51:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYEAAut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:50:49 -0400
Received: from smtp.ono.com ([62.42.230.12]:14965 "EHLO resmaa04.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753354AbYEAAus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:50:48 -0400
Date: Thu, 1 May 2008 02:50:43 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problems with -git14
Message-ID: <20080501025043.5e8582f6@werewolf.home>
In-Reply-To: <Pine.LNX.4.64.0804301516580.30549@blonde.site>
References: <20080430015655.5a42f63d@werewolf.home>
	<Pine.LNX.4.64.0804301516580.30549@blonde.site>
X-Mailer: Claws Mail 3.4.0cvs16 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 16:17:46 +0100 (BST), Hugh Dickins <hugh@veritas.com> wrote:

> On Wed, 30 Apr 2008, J.A. Magallón wrote:
> > 
> > I have a couple problems with latest git (-14):
> > 
> > - It only recognises 2 processors out of 4 (dual Xeon HT)
> > - It oopses on the swapper process just on boot...
> > 
> > Difference in dmesg is below. If full correct dmesg or config is
> > needed, please ask for them. The kernel was built copying old
> > 2.6.25 config to .config && make oldconfig. I filled the missing
> > gaps like PAT and others...
> > 
> > -Brought up 4 CPUs
> > +native_cpu_up: bad cpu 2
> > +native_cpu_up: bad cpu 3
> > +Brought up 2 CPUs
> 
> Yes, I've been getting this for some days too: only 2 processors on
> dual Xeon HT in 32-bit mode; whereas x86_64 finds all 4 just fine.
> Ran lots of testing on 2.6.25-mm1 before I noticed it there.
> 
> I bisected for a while, but it got confusing (arrived at a bisect
> point which gave only 1 processor: smpboot code getting rearranged),
> so I was forced (quel horreur!) to investigate properly.  I've just
> now had success with the patch below, please give it a try:
> but it'll need an Ack from Glauber before it can go in.
> 
> > +WARNING: at include/linux/blkdev.h:427 blk_queue_init_tags+0x110/0x11f()
> 
> I presume this warning and backtrace is what you report as an oops:
> I think you'll find Linus included a fix for this one overnight, and
> it should have gone away in 2.6.25-git15 (but I didn't see it myself).
> 
> Hugh

-git16 plus your patch gives me my 4 cpus again.
But I still get the warning:

scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec 29320 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs
ACPI: PCI Interrupt 0000:03:0a.1[B] -> GSI 23 (level, low) -> IRQ 23
scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec 29320 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs
scsi 1:0:0:0: Direct-Access     SEAGATE  ST336807LW       0C01 PQ: 0 ANSI: 3
------------[ cut here ]------------
WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x110/0x11f()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-jam03 #1
 [<c011e618>] warn_on_slowpath+0x4d/0x66
 [<c0132e68>] __atomic_notifier_call_chain+0x27/0x48
 [<c0132ea0>] atomic_notifier_call_chain+0x17/0x1b
 [<c024a7be>] notify_update+0x1f/0x23
 [<c024aa07>] vt_console_print+0x1dd/0x2ab
 [<c024a82a>] vt_console_print+0x0/0x2ab
 [<c0132a2e>] up+0x9/0x2b
 [<c01f314c>] init_tag_map+0x4e/0x95
 [<c01f3271>] __blk_queue_init_tags+0x27/0x4e
 [<c01f33a8>] blk_queue_init_tags+0x110/0x11f
 [<c0285b9b>] ahd_platform_set_tags+0x177/0x1a7
 [<c0286247>] ahd_linux_slave_configure+0xcd/0x131
 [<c025e89e>] scsi_probe_and_add_lun+0x706/0x964
 [<c025ecc7>] __scsi_scan_target+0xd9/0x5d9
 [<c019ce63>] sysfs_ilookup_test+0x0/0xd
 [<c019d8ea>] sysfs_addrm_finish+0x14/0x1c7
 [<c019d16d>] sysfs_find_dirent+0x1e/0x27
 [<c019d1b1>] sysfs_add_one+0x3b/0x8b
 [<c019ccfc>] sysfs_add_file_mode+0x4d/0x76
 [<c019e4cc>] internal_create_group+0xd7/0x196
 [<c032a1b2>] klist_next+0x53/0x90
 [<c025f23f>] scsi_scan_channel+0x78/0x8d
 [<c025f2fc>] scsi_scan_host_selected+0xa8/0xd1
 [<c025f38d>] do_scsi_scan_host+0x68/0x6a
 [<c028540c>] ahd_linux_register_host+0x267/0x2db
 [<c0287a6f>] ahd_pci_map_int+0x2c/0x50
 [<c0280d5a>] ahd_pci_config+0x533/0x824
 [<c01fce96>] kobject_get+0xf/0x13
 [<c0251635>] get_device+0xe/0x14
 [<c0208da9>] pci_dev_get+0xf/0x13
 [<c0287c36>] ahd_linux_pci_dev_probe+0x139/0x17f
 [<c019d8ea>] sysfs_addrm_finish+0x14/0x1c7
 [<c019d16d>] sysfs_find_dirent+0x1e/0x27
 [<c019d1b1>] sysfs_add_one+0x3b/0x8b
 [<c019de53>] sysfs_create_link+0x89/0x106
 [<c0209049>] pci_match_device+0x9c/0xad
 [<c02090b0>] pci_device_probe+0x40/0x60
 [<c0253b73>] driver_probe_device+0x76/0x152
 [<c0253ca5>] __driver_attach+0x56/0x58
 [<c02535ad>] bus_for_each_dev+0x39/0x57
 [<c0209070>] pci_device_probe+0x0/0x60
 [<c0253a36>] driver_attach+0x16/0x1a
 [<c0253c4f>] __driver_attach+0x0/0x58
 [<c02530ba>] bus_add_driver+0x19c/0x214
 [<c0208d64>] pci_device_remove+0x0/0x36
 [<c0209070>] pci_device_probe+0x0/0x60
 [<c0253dc4>] driver_register+0x3b/0xd3
 [<c0208f7b>] __pci_register_driver+0x32/0x64
 [<c041abff>] ahd_linux_init+0x53/0x6f
 [<c0406a36>] kernel_init+0x11d/0x287
 [<c01174c2>] finish_task_switch+0x1f/0x6d
 [<c0117711>] schedule_tail+0x16/0x44
 [<c0102c62>] ret_from_fork+0x6/0x1c
 [<c0406919>] kernel_init+0x0/0x287
 [<c0406919>] kernel_init+0x0/0x287
 [<c010393f>] kernel_thread_helper+0x7/0x18
 =======================
---[ end trace e7ca32af98aeff40 ]---
scsi target1:0:0: asynchronous
scsi1:A:0:0: Tagged Queuing enabled.  Depth 32
scsi target1:0:0: Beginning Domain Validation
scsi target1:0:0: wide asynchronous
scsi target1:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM WRFLOW PCOMP (6.25 ns, offset 63)
scsi target1:0:0: Ending Domain Validation
scsi 1:0:1:0: Direct-Access     SEAGATE  ST336807LW       0C01 PQ: 0 ANSI: 3
scsi target1:0:1: asynchronous
scsi1:A:1:0: Tagged Queuing enabled.  Depth 32
scsi target1:0:1: Beginning Domain Validation
scsi target1:0:1: wide asynchronous
scsi target1:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM WRFLOW PCOMP (6.25 ns, offset 63)
scsi target1:0:1: Ending Domain Validation
Driver 'sd' needs updating - please use bus_type methods
sd 1:0:0:0: [sda] 71687372 512-byte hardware sectors (36704 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: ab 00 10 08
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 1:0:0:0: [sda] 71687372 512-byte hardware sectors (36704 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: ab 00 10 08
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda2
sd 1:0:0:0: [sda] Attached SCSI disk
sd 1:0:1:0: [sdb] 71687372 512-byte hardware sectors (36704 MB)
sd 1:0:1:0: [sdb] Write Protect is off
sd 1:0:1:0: [sdb] Mode Sense: ab 00 10 08
sd 1:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 1:0:1:0: [sdb] 71687372 512-byte hardware sectors (36704 MB)
sd 1:0:1:0: [sdb] Write Protect is off
sd 1:0:1:0: [sdb] Mode Sense: ab 00 10 08
sd 1:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdb: sdb1
sd 1:0:1:0: [sdb] Attached SCSI disk

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
