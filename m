Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYAGFd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYAGFd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 00:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYAGFdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 00:33:17 -0500
Received: from mail.gmx.net ([213.165.64.20]:52262 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754668AbYAGFdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 00:33:14 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19EhLoM7YZEGCjAQ0/2nvheyPbZzKewuKDuP5E26a
	JBYwD0WpzP5WRc
Subject: Re: [vm] writing to UDF DVD+RW (/dev/sr0) while under memory
	pressure: box ==> doorstop
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080106122954.d8f04c98.akpm@linux-foundation.org>
References: <1199447212.4529.13.camel@homer.simson.net>
	 <1199612533.4384.54.camel@homer.simson.net>
	 <1199642470.3927.12.camel@homer.simson.net>
	 <20080106122954.d8f04c98.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 07 Jan 2008 06:33:08 +0100
Message-Id: <1199683988.3718.49.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-06 at 12:29 -0800, Andrew Morton wrote: 
> On Sun, 06 Jan 2008 19:01:10 +0100 Mike Galbraith <efault@gmx.de> wrote:
> 
> > 
> > On Sun, 2008-01-06 at 10:42 +0100, Mike Galbraith wrote:
> > > FWIW, here's box having same seizure writing to /dev/pktcdvd/sr0.
> > 
> > Ugh, horrid device IO ==> horrid VM AFIKT.  I'll continue rummaging, but
> > I wonder, am I doing something _so_ stupid as to warrant zero response?
> > 
> 
> Copying linux-mm might have helped.  Bad time of year, too.

Thanks for the reply, I was getting alll paranoid that I was being
really dense, ergo the ping.

> >From the traces it looks like all IO has stopped and everyone is waiting
> (directly or indirectly) for certain IO completions.  Is that really true,
> or is IO still dribbling along?

It's dribbling along.  I drastically improved the situation by bouncing
people off the exclusion wall instead of synchronizing, but the poor sod
who acquires prune_mutex is in purgatory for a very long time.

(undoes butchery)

> >From the kswapd0 trace it would appear that UDF is doing synchronous writes
> (udf_update_inode->sync_dirty_buffer) which perhaps is making things
> mightily slow.

Even synchronous writes shouldn't cause minutes long hangs surely :)
This /dev/sr0 IO seems to be getting jammed up something terrible.  I
formatted the dvd ext2 and tried the same copy.  It didn't jam up the
whole box (well, yet, it's still zooming along at mach 0.0000000001)
doing parallel kbuilds, but when I started a bonnie, the poor thing
instantly got nailed to the floor.  I kill -9'd it about a half an hour
ago, and it has yet to respond.  Every now and again there's a burst of
activity from cp, but bonnie is stuck for the duration it seems.  I'll
find out.

<twiddle twiddle twiddle>

The 515MB cp finished after an hour and change.  When bonnie exits I'll
be able to see what the throughput was.

<twiddle++>

bonnie finally exited.  uptime is now 1:22. cp started right after
boot... throughput very bad.

I would almost swear I copied to that dvd drive when it was /dev/hdc
(before I upgraded to openSuSE 10.3 and got all modern) and it worked
well enough to not attract my attention.  I guess I need to figure out
how to reacquire /dev/hdc and try again.

[ 1687.358723] SysRq : Show Blocked State
[ 1687.358729]   task                PC stack   pid father
[ 1687.358729] pdflush       D 00000140     0   156      2
[ 1687.358729]        ee172de4 00000046 e0791550 00000140 00000008 00000000 00000000 00b00000 
[ 1687.358729]        b0d3bb78 00000188 b040d300 b040d300 ef8ab5f0 ef8ab83c b180c300 ee172000 
[ 1687.358729]        00000000 ee2c5550 ef9cb200 ee2c5550 00000003 00000000 ef871ee4 0041706e 
[ 1687.358729] Call Trace:
[ 1687.358729]  [<b02e3b7f>] io_schedule+0x4f/0x89
[ 1687.358729]  [<b01a287d>] sync_buffer+0x30/0x34
[ 1687.358729]  [<b02e3d8f>] __wait_on_bit+0x42/0x5e
[ 1687.358729]  [<b01a284d>] sync_buffer+0x0/0x34
[ 1687.358729]  [<b02e3e12>] out_of_line_wait_on_bit+0x67/0x6f
[ 1687.358729]  [<b01a284d>] sync_buffer+0x0/0x34
[ 1687.358729]  [<b013e1dd>] wake_bit_function+0x0/0x3c
[ 1687.358729]  [<b01a2814>] __wait_on_buffer+0x24/0x29
[ 1687.358729]  [<b01a4225>] __bread+0x55/0x8a
[ 1687.358729]  [<f0d5e865>] ext2_get_inode+0xbe/0x109 [ext2]
[ 1687.358729]  [<f0d5e8e9>] ext2_update_inode+0x39/0x331 [ext2]
[ 1687.358729]  [<b01a8a5e>] mpage_bio_submit+0x19/0x1d
[ 1687.358729]  [<f0d5f530>] ext2_get_block+0x0/0x761 [ext2]
[ 1687.358729]  [<b019dd1c>] __writeback_single_inode+0x228/0x306
[ 1687.358729]  [<b0104bf8>] apic_timer_interrupt+0x28/0x30
[ 1687.358729]  [<b01e6005>] _atomic_dec_and_lock+0x31/0x5c
[ 1687.358729]  [<b019e1a2>] sync_sb_inodes+0x1c3/0x294
[ 1687.358729]  [<b019e450>] writeback_inodes+0x7d/0xac
[ 1687.358729]  [<b016a086>] background_writeout+0x98/0xb7
[ 1687.358729]  [<b016a56c>] pdflush+0x0/0x1d4
[ 1687.358730]  [<b016a673>] pdflush+0x107/0x1d4
[ 1687.358730]  [<b0169fee>] background_writeout+0x0/0xb7
[ 1687.358730]  [<b013df26>] kthread+0x34/0x56
[ 1687.358730]  [<b013def2>] kthread+0x0/0x56
[ 1687.358730]  [<b0104d7b>] kernel_thread_helper+0x7/0x1c
[ 1687.358730]  =======================
[ 1687.358730] hald-addon-st D ee990bc0     0  2330   2284
[ 1687.358730]        ee990bd4 00000082 00000002 ee990bc0 ee990bb8 00000000 00000000 8334c2ad 
[ 1687.358730]        00000273 b180c300 b040d300 b040d300 ee21c8b0 ee21cafc b180c300 ee990000 
[ 1687.358730]        ee990be8 00000000 ee398740 00248b9d ee2c5550 ee2c5550 00000000 00000003 
[ 1687.358730] Call Trace:
[ 1687.358730]  [<b02e3c23>] schedule_timeout+0x69/0xa1
[ 1687.358730]  [<f084c7b4>] scsi_request_fn+0x210/0x351 [scsi_mod]
[ 1687.358730]  [<b0135051>] del_timer+0x52/0x5a
[ 1687.358730]  [<b01e4f7b>] cfq_set_request+0xc2/0x2ff
[ 1687.358730]  [<b02e30a7>] wait_for_common+0x6a/0x101
[ 1687.358730]  [<b0121b63>] default_wake_function+0x0/0xc
[ 1687.358730]  [<b01dc611>] blk_execute_rq+0x72/0xb3
[ 1687.358730]  [<b01db42e>] blk_end_sync_rq+0x0/0x23
[ 1687.358730]  [<b0121b63>] default_wake_function+0x0/0xc
[ 1687.358730]  [<b01dc702>] get_request_wait+0x1b/0x173
[ 1687.358730]  [<f084c089>] scsi_execute+0xc7/0xdb [scsi_mod]
[ 1687.358730]  [<f084c10a>] scsi_execute_req+0x6d/0xd0 [scsi_mod]
[ 1687.358730]  [<f084c1c3>] scsi_test_unit_ready+0x56/0x95 [scsi_mod]
[ 1687.358730]  [<f0b060da>] sr_media_change+0x3a/0x223 [sr_mod]
[ 1687.358730]  [<f0b07557>] sr_drive_status+0x53/0x65 [sr_mod]
[ 1687.358730]  [<f084c1c3>] scsi_test_unit_ready+0x56/0x95 [scsi_mod]
[ 1687.358730]  [<f0ae1074>] media_changed+0x47/0x7e [cdrom]
[ 1687.358730]  [<f0ae45f2>] cdrom_ioctl+0x275/0xdca [cdrom]
[ 1687.358730]  [<b018c5e7>] __link_path_walk+0x9ea/0xd06
[ 1687.358730]  [<f0ae1074>] media_changed+0x47/0x7e [cdrom]
[ 1687.358730]  [<f0b07077>] sr_block_ioctl+0x47/0x80 [sr_mod]
[ 1687.358730]  [<b01ddd7f>] blkdev_driver_ioctl+0x55/0x5e
[ 1687.358730]  [<b01ddf9f>] blkdev_ioctl+0x217/0x7c8
[ 1687.358730]  [<b0181f91>] get_unused_fd_flags+0xb5/0xce
[ 1687.358730]  [<b01e6d72>] kobject_get+0xf/0x13
[ 1687.358730]  [<b01de96d>] get_disk+0x1b/0x80
[ 1687.358730]  [<b01de9d9>] exact_lock+0x7/0xd
[ 1687.358730]  [<b02527df>] kobj_lookup+0x157/0x172
[ 1687.358730]  [<b01e6d72>] kobject_get+0xf/0x13
[ 1687.358730]  [<f0b063a1>] sr_block_open+0x70/0x81 [sr_mod]
[ 1687.358730]  [<b01a6c34>] do_open+0xb5/0x28b
[ 1687.358730]  [<b01a6fd4>] blkdev_open+0x25/0x53
[ 1687.358730]  [<b0182130>] __dentry_open+0x17f/0x1d9
[ 1687.358730]  [<b0182217>] nameidata_to_filp+0x31/0x3a
[ 1687.358730]  [<b01a6faf>] blkdev_open+0x0/0x53
[ 1687.358730]  [<b0182259>] do_filp_open+0x39/0x40
[ 1687.358730]  [<b011c0f6>] check_pgt_cache+0x1b/0x1f
[ 1687.358730]  [<b01a6414>] block_ioctl+0x18/0x1d
[ 1687.358730]  [<b01a63fc>] block_ioctl+0x0/0x1d
[ 1687.358730]  [<b018ea4f>] do_ioctl+0x1f/0x6d
[ 1687.358730]  [<b018eca0>] vfs_ioctl+0x203/0x27f
[ 1687.358730]  [<b018230b>] do_sys_open+0xab/0xc0
[ 1687.358730]  [<b018ed72>] sys_ioctl+0x56/0x68
[ 1687.358730]  [<b010412a>] sysenter_past_esp+0x5f/0x85
[ 1687.358730]  =======================
[ 1687.358730] cp            D b011fcc6     0  4301   3844
[ 1687.358730]        cc4b4b94 00200082 b180c300 b011fcc6 30cf0ee6 00000008 00000000 00000000 
[ 1687.358730]        b0d3bb7a 00000188 b040d300 b040d300 ee1b18f0 ee1b1b3c b180c300 cc4b4000 
[ 1687.358730]        b1809a40 ee2c5550 edd57740 ee2c5550 00000004 00000000 ef824558 0041706e 
[ 1687.358730] Call Trace:
[ 1687.358730]  [<b011fcc6>] hrtick_start_fair+0xa8/0x150
[ 1687.358730]  [<b02e3b7f>] io_schedule+0x4f/0x89
[ 1687.358730]  [<b01a287d>] sync_buffer+0x30/0x34
[ 1687.358730]  [<b02e3cbc>] __wait_on_bit_lock+0x3d/0x5f
[ 1687.358730]  [<b01a284d>] sync_buffer+0x0/0x34
[ 1687.358730]  [<b02e3d45>] out_of_line_wait_on_bit_lock+0x67/0x6f
[ 1687.358730]  [<b01a284d>] sync_buffer+0x0/0x34
[ 1687.358730]  [<b013e1dd>] wake_bit_function+0x0/0x3c
[ 1687.358730]  [<b01a2a1b>] __lock_buffer+0x29/0x2e
[ 1687.358730]  [<b01a4247>] __bread+0x77/0x8a
[ 1687.358730]  [<f0d5e865>] ext2_get_inode+0xbe/0x109 [ext2]
[ 1687.358730]  [<f0d5e8e9>] ext2_update_inode+0x39/0x331 [ext2]
[ 1687.358730]  [<b01a8a5e>] mpage_bio_submit+0x19/0x1d
[ 1687.358730]  [<f0d5f530>] ext2_get_block+0x0/0x761 [ext2]
[ 1687.358730]  [<b019dd1c>] __writeback_single_inode+0x228/0x306
[ 1687.358730]  [<b01e6005>] _atomic_dec_and_lock+0x31/0x5c
[ 1687.358730]  [<b019e1a2>] sync_sb_inodes+0x1c3/0x294
[ 1687.358730]  [<b019e450>] writeback_inodes+0x7d/0xac
[ 1687.358730]  [<b0169dd5>] balance_dirty_pages_ratelimited_nr+0x21f/0x33f
[ 1687.358730]  [<b0164773>] generic_file_buffered_write+0x1c1/0x655
[ 1687.358730]  [<f0a5a5df>] ext3_readpages+0x0/0x15 [ext3]
[ 1687.358730]  [<b0164eb4>] __generic_file_aio_write_nolock+0x2ad/0x50d
[ 1687.358730]  [<b0130667>] current_fs_time+0x13/0x15
[ 1687.358730]  [<b0165179>] generic_file_aio_write+0x65/0xd3
[ 1687.358730]  [<b01836ef>] do_sync_write+0xd2/0x10e
[ 1687.358730]  [<b0146d22>] tick_sched_timer+0x0/0xbf
[ 1687.358730]  [<b013e1a8>] autoremove_wake_function+0x0/0x35
[ 1687.358730]  [<b018361d>] do_sync_write+0x0/0x10e
[ 1687.358730]  [<b0183f2f>] vfs_write+0xa4/0x14a
[ 1687.358730]  [<b0184556>] sys_write+0x41/0x6a
[ 1687.358730]  [<b010412a>] sysenter_past_esp+0x5f/0x85
[ 1687.358730]  =======================
[ 1687.358730] bonnie        D eee95dcc     0  5328   3749
[ 1687.358730]        eee95de0 00200086 00000002 eee95dcc eee95dc4 00000000 00000000 b0145bda 
[ 1687.358730]        3c876200 eee95da8 b040d300 b040d300 e16c2470 e16c26bc b180c300 eee95000 
[ 1687.358730]        000004b3 ee2c5550 edd573c0 0024876a b01dc8d2 b01436cd 00000000 00000003 
[ 1687.358730] Call Trace:
[ 1687.358730]  [<b0145bda>] clockevents_program_event+0x9a/0x12e
[ 1687.358730]  [<b01dc8d2>] generic_unplug_device+0x15/0x21
[ 1687.358730]  [<b01436cd>] getnstimeofday+0x2f/0xd7
[ 1687.358730]  [<b02e3b7f>] io_schedule+0x4f/0x89
[ 1687.358730]  [<b01a287d>] sync_buffer+0x30/0x34
[ 1687.358730]  [<b02e3cbc>] __wait_on_bit_lock+0x3d/0x5f
[ 1687.358730]  [<b01a284d>] sync_buffer+0x0/0x34
[ 1687.358730]  [<b02e3d45>] out_of_line_wait_on_bit_lock+0x67/0x6f
[ 1687.358730]  [<b01a284d>] sync_buffer+0x0/0x34
[ 1687.358730]  [<b013e1dd>] wake_bit_function+0x0/0x3c
[ 1687.358730]  [<b01a2a1b>] __lock_buffer+0x29/0x2e
[ 1687.358730]  [<b01a4247>] __bread+0x77/0x8a
[ 1687.358730]  [<f0d5e865>] ext2_get_inode+0xbe/0x109 [ext2]
[ 1687.358730]  [<f0d5e8e9>] ext2_update_inode+0x39/0x331 [ext2]
[ 1687.358730]  [<b01a8a5e>] mpage_bio_submit+0x19/0x1d
[ 1687.358730]  [<f0d5f530>] ext2_get_block+0x0/0x761 [ext2]
[ 1687.358730]  [<b019dd1c>] __writeback_single_inode+0x228/0x306
[ 1687.358730]  [<b01633b8>] find_get_pages_tag+0x75/0x84
[ 1687.358730]  [<b0104b68>] reschedule_interrupt+0x28/0x30
[ 1687.358730]  [<b01e6005>] _atomic_dec_and_lock+0x31/0x5c
[ 1687.358730]  [<b019e1a2>] sync_sb_inodes+0x1c3/0x294
[ 1687.358730]  [<b019e2f1>] sync_inodes_sb+0x7e/0x8f
[ 1687.358730]  [<b019e378>] __sync_inodes+0x76/0xa5
[ 1687.358730]  [<b019e3b8>] sync_inodes+0x11/0x2c
[ 1687.358730]  [<b01a0c7a>] do_sync+0x14/0x63
[ 1687.358730]  [<b01a0cd3>] sys_sync+0xa/0x17
[ 1687.358730]  [<b010412a>] sysenter_past_esp+0x5f/0x85
[ 1687.358730]  =======================
[ 1687.358730] pdflush       D ee25dee0     0 14924      2
[ 1687.358730]        ee25def4 00000046 00000002 ee25dee0 ee25ded8 00000000 00000000 b03a53c0 
[ 1687.358730]        aadc0469 00000188 b040d300 b040d300 dc20ce30 dc20d07c b180c300 ee25d000 
[ 1687.358730]        00000202 b0443e00 ee244c80 002491c9 ee25df04 b0134a01 ffffffff 00000003 
[ 1687.358730] Call Trace:
[ 1687.358730]  [<b0134a01>] process_timeout+0x0/0x5
[ 1687.358730]  [<b02e3bfe>] schedule_timeout+0x44/0xa1
[ 1687.358730]  [<b0134a01>] process_timeout+0x0/0x5
[ 1687.358730]  [<b02e3bf9>] schedule_timeout+0x3f/0xa1
[ 1687.358730]  [<b02e3a81>] io_schedule_timeout+0x54/0x93
[ 1687.358730]  [<b016edcf>] congestion_wait+0x4d/0x61
[ 1687.358730]  [<b013e1a8>] autoremove_wake_function+0x0/0x35
[ 1687.358730]  [<b016a16b>] wb_kupdate+0x9c/0xe2
[ 1687.358730]  [<b016a56c>] pdflush+0x0/0x1d4
[ 1687.358730]  [<b016a673>] pdflush+0x107/0x1d4
[ 1687.358730]  [<b016a0cf>] wb_kupdate+0x0/0xe2
[ 1687.358730]  [<b013df26>] kthread+0x34/0x56
[ 1687.358730]  [<b013def2>] kthread+0x0/0x56
[ 1687.358730]  [<b0104d7b>] kernel_thread_helper+0x7/0x1c
[ 1687.358730]  =======================


