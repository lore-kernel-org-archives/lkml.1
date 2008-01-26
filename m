Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYAZNaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYAZNaV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 08:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYAZNaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 08:30:08 -0500
Received: from yergi.telenet-ops.be ([195.130.132.36]:40385 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbYAZNaE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 08:30:04 -0500
Subject: Re: 2.6.24 regression: pan hanging unkilleable and un-straceable
From: Frederik Himpe <fhimpe@telenet.be>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
In-Reply-To: <200801221625.58615.nickpiggin@yahoo.com.au>
References: <1200949086.6648.19.camel@Anastacia>
	 <200801221105.11413.nickpiggin@yahoo.com.au>
	 <1200978207.3944.8.camel@homer.simson.net>
	 <200801221625.58615.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 26 Jan 2008 14:29:15 +0100
Message-Id: <1201354155.6853.4.camel@Anastacia>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5-1mdv2008.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On di, 2008-01-22 at 16:25 +1100, Nick Piggin wrote:

> > > On Tuesday 22 January 2008 07:58, Frederik Himpe wrote:
> > > > With Linux 2.6.24-rc8 I often have the problem that the pan usenet
> > > > reader starts using 100% of CPU time after some time. When this
> > > > happens, kill -9 does not work, and strace just hangs when trying to
> > > > attach to the process. The same with gdb. ﻿ps shows the process as
> > > > being in the R state.
> > > >
> > > > I pressed Ctrl-Alt-SysRq-T, and this was shown for pan:
> > > > Jan 21 21:45:01 Anastacia kernel: pan           R  running task       
> > > > 0

> Nasty. The attached patch is something really simple that can sometimes help.
> sysrq+p is also an option, if you're on a UP system.
> 
> Any luck getting traces?

I just succeeded to reproduce the problem with this patch. Does this
smell like an XFS problem?

Jan 26 14:17:43 Anastacia kernel: pan           R  running task        0  7564      1
Jan 26 14:17:43 Anastacia kernel:  000000003f5b3248 0000000000001000 ffffffff880c28b0 0000000000000000
Jan 26 14:17:43 Anastacia kernel:  ffff81003f5b3248 ffff81002d1ed900 000000002d1ed900 0000000000000000
Jan 26 14:17:43 Anastacia kernel:  ffff810016050dd0 fffff000fffff000 0000000000000000 ffff81002d1eda10
Jan 26 14:17:43 Anastacia kernel: Call Trace:
Jan 26 14:17:43 Anastacia kernel:  [_end+127964408/2129947720] :xfs:xfs_get_blocks+0x0/0x10
Jan 26 14:17:43 Anastacia kernel:  [unix_poll+0/176] unix_poll+0x0/0xb0
Jan 26 14:17:43 Anastacia kernel:  [_end+127964408/2129947720] :xfs:xfs_get_blocks+0x0/0x10
Jan 26 14:17:43 Anastacia kernel:  [iov_iter_copy_from_user_atomic+65/160] iov_iter_copy_from_user_atomic+0x41/0xa0
Jan 26 14:17:43 Anastacia kernel:  [iov_iter_copy_from_user_atomic+46/160] iov_iter_copy_from_user_atomic+0x2e/0xa0
Jan 26 14:17:43 Anastacia kernel:  [generic_file_buffered_write+383/1728] generic_file_buffered_write+0x17f/0x6c0
Jan 26 14:17:43 Anastacia kernel:  [current_fs_time+30/48] current_fs_time+0x1e/0x30
Jan 26 14:17:43 Anastacia kernel:  [_end+127997742/2129947720] :xfs:xfs_write+0x676/0x910
Jan 26 14:17:43 Anastacia kernel:  [find_lock_page+61/192] find_lock_page+0x3d/0xc0
Jan 26 14:17:43 Anastacia kernel:  [_end+127981080/2129947720] :xfs:xfs_file_aio_write+0x0/0x50
Jan 26 14:17:43 Anastacia kernel:  [do_sync_readv_writev+203/272] do_sync_readv_writev+0xcb/0x110
Jan 26 14:17:43 Anastacia kernel:  [__do_fault+501/1056] __do_fault+0x1f5/0x420
Jan 26 14:17:43 Anastacia kernel:  [autoremove_wake_function+0/48] autoremove_wake_function+0x0/0x30
Jan 26 14:17:43 Anastacia kernel:  [handle_mm_fault+1344/2048] handle_mm_fault+0x540/0x800
Jan 26 14:17:43 Anastacia kernel:  [rw_copy_check_uvector+157/336] rw_copy_check_uvector+0x9d/0x150
Jan 26 14:17:43 Anastacia kernel:  [do_readv_writev+253/560] do_readv_writev+0xfd/0x230
Jan 26 14:17:43 Anastacia kernel:  [sys_writev+83/144] sys_writev+0x53/0x90
Jan 26 14:17:43 Anastacia kernel:  [system_call+126/131] system_call+0x7e/0x83
Jan 26 14:17:43 Anastacia kernel: 
Jan 26 14:17:43 Anastacia kernel: pan           S 0000000000000000     0  7565      1
Jan 26 14:17:43 Anastacia kernel:  ffff810001401c58 0000000000000086 ffff810001401bb8 ffff81003cd3a280
Jan 26 14:17:43 Anastacia kernel:  ffff81003cd3a300 ffffffff80623980 ffffffff80623980 ffffffff80623980
Jan 26 14:17:43 Anastacia kernel:  ffffffff8061fe80 ffffffff80623980 ffff810001bcc9a8 ffff8100299b34e8
Jan 26 14:17:43 Anastacia kernel: Call Trace:
Jan 26 14:17:43 Anastacia kernel:  [__qdisc_run+173/528] __qdisc_run+0xad/0x210
Jan 26 14:17:43 Anastacia kernel:  [dev_queue_xmit+216/768] dev_queue_xmit+0xd8/0x300
Jan 26 14:17:43 Anastacia kernel:  [futex_wait+838/912] futex_wait+0x346/0x390
Jan 26 14:17:43 Anastacia kernel:  [tcp_connect+851/896] tcp_connect+0x353/0x380
Jan 26 14:17:43 Anastacia kernel:  [tcp_v4_connect+914/1696] tcp_v4_connect+0x392/0x6a0
Jan 26 14:17:43 Anastacia kernel:  [default_wake_function+0/16] default_wake_function+0x0/0x10
Jan 26 14:17:43 Anastacia kernel:  [do_futex+287/3008] do_futex+0x11f/0xbc0
Jan 26 14:17:43 Anastacia kernel:  [_spin_lock_bh+9/32] _spin_lock_bh+0x9/0x20
Jan 26 14:17:43 Anastacia kernel:  [cp_new_stat+229/256] cp_new_stat+0xe5/0x100
Jan 26 14:17:43 Anastacia kernel:  [sys_futex+171/304] sys_futex+0xab/0x130
Jan 26 14:17:43 Anastacia kernel:  [system_call+126/131] system_call+0x7e/0x83
Jan 26 14:17:43 Anastacia kernel: 
Jan 26 14:17:43 Anastacia kernel: pan           S 0000000000000000     0  7566      1
Jan 26 14:17:43 Anastacia kernel:  ffff8100013fdc58 0000000000000086 0000000000a492c0 0000000000a493c8
Jan 26 14:17:43 Anastacia kernel:  0000000000a494d0 ffffffff80623980 ffffffff80623980 ffffffff80623980
Jan 26 14:17:43 Anastacia kernel:  ffffffff8061fe80 ffffffff80623980 ffff810001bcd8a8 ffff8100339756c8
Jan 26 14:17:43 Anastacia kernel: Call Trace:
Jan 26 14:17:43 Anastacia kernel:  [enqueue_entity+55/112] enqueue_entity+0x37/0x70
Jan 26 14:17:43 Anastacia kernel:  [enqueue_task_fair+56/80] enqueue_task_fair+0x38/0x50
Jan 26 14:17:43 Anastacia kernel:  [futex_wait+838/912] futex_wait+0x346/0x390
Jan 26 14:17:43 Anastacia kernel:  [__wake_up+67/112] __wake_up+0x43/0x70
Jan 26 14:17:43 Anastacia kernel:  [wake_futex+57/80] wake_futex+0x39/0x50
Jan 26 14:17:43 Anastacia kernel:  [default_wake_function+0/16] default_wake_function+0x0/0x10
Jan 26 14:17:43 Anastacia kernel:  [do_futex+287/3008] do_futex+0x11f/0xbc0
Jan 26 14:17:43 Anastacia kernel:  [__up_read+33/176] __up_read+0x21/0xb0
Jan 26 14:17:43 Anastacia kernel:  [do_page_fault+411/2000] do_page_fault+0x19b/0x7d0
Jan 26 14:17:43 Anastacia kernel:  [sys_futex+171/304] sys_futex+0xab/0x130
Jan 26 14:17:43 Anastacia kernel:  [system_call+126/131] system_call+0x7e/0x83
Jan 26 14:17:43 Anastacia kernel: 
Jan 26 14:17:43 Anastacia kernel: pan           S 0000000000000000     0  7567      1
Jan 26 14:17:43 Anastacia kernel:  ffff810001409c58 0000000000000086 0000000000a51618 0000000000a51720
Jan 26 14:17:43 Anastacia kernel:  0000000000a51828 ffffffff80623980 ffffffff80623980 ffffffff80623980
Jan 26 14:17:43 Anastacia kernel:  ffffffff8061fe80 ffffffff80623980 ffff8100339758a8 ffff810033974f48
Jan 26 14:17:43 Anastacia kernel: Call Trace:
Jan 26 14:17:43 Anastacia kernel:  [enqueue_entity+55/112] enqueue_entity+0x37/0x70
Jan 26 14:17:43 Anastacia kernel:  [enqueue_task_fair+56/80] enqueue_task_fair+0x38/0x50
Jan 26 14:17:43 Anastacia kernel:  [futex_wait+838/912] futex_wait+0x346/0x390
Jan 26 14:17:43 Anastacia kernel:  [__wake_up+67/112] __wake_up+0x43/0x70
Jan 26 14:17:43 Anastacia kernel:  [wake_futex+57/80] wake_futex+0x39/0x50
Jan 26 14:17:43 Anastacia kernel:  [default_wake_function+0/16] default_wake_function+0x0/0x10
Jan 26 14:17:43 Anastacia kernel:  [do_futex+287/3008] do_futex+0x11f/0xbc0
Jan 26 14:17:43 Anastacia kernel:  [__up_read+33/176] __up_read+0x21/0xb0
Jan 26 14:17:43 Anastacia kernel:  [do_page_fault+411/2000] do_page_fault+0x19b/0x7d0
Jan 26 14:17:43 Anastacia kernel:  [sys_futex+171/304] sys_futex+0xab/0x130
Jan 26 14:17:43 Anastacia kernel:  [system_call+126/131] system_call+0x7e/0x83
Jan 26 14:17:43 Anastacia kernel: 
Jan 26 14:17:43 Anastacia kernel: pan           S 0000000000000000     0  7568      1
Jan 26 14:17:43 Anastacia kernel:  ffff8100013fbc58 0000000000000086 00002aaaabbe4320 ffffffffffffadbc
Jan 26 14:17:43 Anastacia kernel:  0000000000000000 ffffffff80623980 ffffffff80623980 ffffffff80623980
Jan 26 14:17:43 Anastacia kernel:  ffffffff8061fe80 ffffffff80623980 ffff810033975128 0000000001137ad0
Jan 26 14:17:43 Anastacia kernel: Call Trace:
Jan 26 14:17:43 Anastacia kernel:  [futex_wait+838/912] futex_wait+0x346/0x390
Jan 26 14:17:43 Anastacia kernel:  [zone_statistics+125/128] zone_statistics+0x7d/0x80
Jan 26 14:17:43 Anastacia kernel:  [__alloc_pages+170/976] __alloc_pages+0xaa/0x3d0
Jan 26 14:17:43 Anastacia kernel:  [default_wake_function+0/16] default_wake_function+0x0/0x10
Jan 26 14:17:43 Anastacia kernel:  [do_futex+287/3008] do_futex+0x11f/0xbc0
Jan 26 14:17:43 Anastacia kernel:  [__up_read+33/176] __up_read+0x21/0xb0
Jan 26 14:17:43 Anastacia kernel:  [do_page_fault+411/2000] do_page_fault+0x19b/0x7d0
Jan 26 14:17:43 Anastacia kernel:  [sys_futex+171/304] sys_futex+0xab/0x130


SysRq : Show Regs
CPU 0:
Modules linked in: usb_storage af_packet nvidia(P) vboxdrv ipv6 fuse
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq cpufreq_ondemand
video output tc1100_wmi sbs sbshc container dock battery ac binfmt_misc
loop ext3 jbd dm_mirror sr_mod dm_mod pata_amd ata_generic sata_sil
usbmouse usbhid ff_memless floppy usblp powernow_k8 freq_table
snd_pcm_oss snd_mixer_oss snd_mpu401 snd_mpu401_uart snd_rawmidi ns558
gameport parport_pc snd_seq_device parport rtc_cmos pcspkr snd_intel8x0
k8temp snd_ac97_codec ohci1394 ac97_bus ieee1394 snd_pcm snd_timer skge
ohci_hcd ehci_hcd snd soundcore usbcore forcedeth snd_page_alloc ssb fan
pcmcia pcmcia_core i2c_nforce2 i2c_core button thermal processor sg
evdev genrtc xfs scsi_wait_scan sd_mod sata_nv libata scsi_mod
Pid: 7564, comm: pan Tainted: P        2.6.24-desktop-0.rc8.2.1mdv #1
RIP: 0010:[<ffffffff802d5a57>]  [<ffffffff802d5a57>] block_write_begin
+0x87/0xe0
RSP: 0018:ffff81002e9b5ac8  EFLAGS: 00000286
RAX: ffff81003f5b3248 RBX: 00000000fffffff4 RCX: 0000000000000000
RDX: ffff81003f5b3248 RSI: 0000000000000000 RDI: ffff81002d1eda18
RBP: ffff81003f5b3248 R08: 0000000000000000 R09: ffff81002e9b5be0
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: ffffffff880c28b0 R14: 0000000000001000 R15: 000000003f5b3248
FS:  00002b6bb3bf7960(0000) GS:ffffffff80589000(0000)
knlGS:00000000f78568d0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002b0537cf6000 CR3: 00000000391d2000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff802d5a4f>] block_write_begin+0x7f/0xe0
 [<ffffffff880c2102>] :xfs:xfs_vm_write_begin+0x22/0x30
 [<ffffffff880c28b0>] :xfs:xfs_get_blocks+0x0/0x10
 [<ffffffff80280ba9>] generic_file_buffered_write+0x149/0x6c0
 [<ffffffff80240a2e>] current_fs_time+0x1e/0x30
 [<ffffffff880caae6>] :xfs:xfs_write+0x676/0x910
 [<ffffffff8027f98d>] find_lock_page+0x3d/0xc0
 [<ffffffff880c69d0>] :xfs:xfs_file_aio_write+0x0/0x50
 [<ffffffff802aee9b>] do_sync_readv_writev+0xcb/0x110
 [<ffffffff8028eb95>] __do_fault+0x1f5/0x420
 [<ffffffff802522b0>] autoremove_wake_function+0x0/0x30
 [<ffffffff80290b90>] handle_mm_fault+0x540/0x800
 [<ffffffff802aecdd>] rw_copy_check_uvector+0x9d/0x150
 [<ffffffff802af5fd>] do_readv_writev+0xfd/0x230
 [<ffffffff802afc33>] sys_writev+0x53/0x90
 [<ffffffff8020c36e>] system_call+0x7e/0x83


-- 
Frederik Himpe <fhimpe@telenet.be>

