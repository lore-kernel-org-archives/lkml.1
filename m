Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbYBXB4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbYBXB4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 20:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbYBXB4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 20:56:38 -0500
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:47433 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbYBXB4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 20:56:36 -0500
To: linux-kernel@vger.kernel.org
Subject: 2.6.24.2: 4KSTACKS + PCA403CD IDE CD + pcdrw + mount + PREEMPT -> stack overflow
From: Nix <nix@esperi.org.uk>
Emacs: or perhaps you'd prefer Russian Roulette, after all?
Date: Sun, 24 Feb 2008 01:56:22 +0000
Message-ID: <87wsovkth5.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC--Metrics: hades 1114; Body=1 Fuz1=1 Fuz2=1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A loop mount/umounting a pcdrw or iso9660 (through the pktcdvd device)
sees a stack overflow in four or five tries. Doing the same thing with
the same CD in a normal non-pktcdvd-mounted drive doesn't cause a crash.

Here's a couple of oopses. config follows.

(There are a wide variety. Some I couldn't collect because they appeared
to recurse, blurring past much too fast to read. Some simply didn't go
out of the netconsole logger at all for no obvious reason.)

(This may or may not be PREEMPT+PREEMPT_BKL-specific: I'll try turning
them off tomorrow and repeating.)

(The presence of dm in the first oops below must surely be attributed to
preempt: certainly my CD isn't managed by dm :) )

pktcdvd: Fixed packets, 32 blocks, Mode-2 disc
pktcdvd: Max. media speed: 4
pktcdvd: write speed 2x
pktcdvd: 551232kB available on disc
UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'LinuxUDF', timestamp 2004/02/09 07:10 (1000)
do_IRQ: stack overflow: 480
Pid: 4645, comm: mount Not tainted 2.6.24.2-dirty #4
 [<c0104171>] do_IRQ+0x66/0xc5
 [<c0102f8b>] common_interrupt+0x23/0x28
 [<c027b5da>] ide_outsl+0x5/0x9
 [<c027c540>] ata_output_data+0x4d/0x64
 [<c027b8a6>] atapi_output_bytes+0x19/0x3f
 [<c0285377>] cdrom_transfer_packet_command+0xb5/0xde
 [<c0282607>] cdrom_timer_expiry+0x0/0x51
 [<c02840c3>] cdrom_start_packet_command+0x14f/0x157
 [<c02853e9>] cdrom_do_pc_continuation+0x0/0x2c
 [<c027aa33>] ide_do_request+0x70a/0x943
 [<c0363ef3>] schedule_timeout+0x13/0x8b
 [<c021faeb>] elv_drain_elevator+0x15/0x58
 [<c0220277>] elv_insert+0xf6/0x1d9
 [<c0285377>] cdrom_transfer_packet_command+0xb5/0xde
 [<c0282607>] cdrom_timer_expiry+0x0/0x51
 [<c027b038>] ide_do_drive_cmd+0x99/0xe9
 [<c0282abe>] cdrom_queue_packet_command+0x35/0xa9
 [<c0363b2b>] schedule+0x321/0x33e
 [<c0363ef3>] schedule_timeout+0x13/0x8b
 [<c0282d11>] cdrom_read_tocentry+0x96/0xa1
 [<c02220d3>] blk_end_sync_rq+0x0/0x23
 [<c028315b>] cdrom_read_toc+0x14b/0x42e
 [<c02220d3>] blk_end_sync_rq+0x0/0x23
 [<c027b07e>] ide_do_drive_cmd+0xdf/0xe9
 [<c0283ed2>] ide_cdrom_audio_ioctl+0x13c/0x1de
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0282f42>] cdrom_check_status+0x55/0x60
 [<c02220d3>] blk_end_sync_rq+0x0/0x23
 [<c02865ba>] cdrom_count_tracks+0x64/0x16a
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c02896c4>] cdrom_open+0x190/0x8f8
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c02252d3>] get_disk+0x4e/0x65
 [<c02252f1>] exact_lock+0x7/0xd
 [<c025a2cc>] kobj_lookup+0x104/0x12e
 [<c02828e8>] idecd_open+0x72/0x86
 [<c0174458>] do_open+0x198/0x238
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c0174561>] __blkdev_get+0x69/0x74
 [<c017457e>] blkdev_get+0x12/0x14
 [<c0263333>] pkt_open+0x8d/0xc96
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c022998c>] kobject_get+0xf/0x13
 [<c02252d3>] get_disk+0x4e/0x65
 [<c02252f1>] exact_lock+0x7/0xd
 [<c025a2cc>] kobj_lookup+0x104/0x12e
 [<c0224ed0>] exact_match+0x0/0x4
 [<c0174344>] do_open+0x84/0x238
 [<c0174561>] 
EIP: 0060:[<c01033d2>] EFLAGS: 00010093 CPU: 0
EIP is at dump_trace+0x52/0x8b
EAX: 0000082a EBX: 00000046 ECX: 0000020a EDX: 00000000
ESI: 00000000 EDI: 00000000 EBP: 00000ffc ESP: eeede1c4
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
rocess mount (pid: 4645, ti=eeede000 task=ee537320 task.ti=eeede000)v<tack:  00001000 c03f6c0c 00000000 c0523b64 00000000 c0103423 c036e79c c03f6c0c 
       00000002 c0103bf2 c03f6c0c c0103f85 c03ccd19 00001225 ee5375d0 c0505178 
       c0429436 00000002 c0429477 eeede220 0000000d c0104171 c03cce23 000001e0 
Call Trace:
 [<c0103423>] show_trace_log_lvl+0x18/0x2c
 [<c0103bf2>] show_trace+0xf/0x11
 [<c0103f85>] dump_stack+0x68/0x6d
 [<c0104171>] do_IRQ+0x66/0xc5
 [<c0102f8b>] common_interrupt+0x23/0x28
 [<c027b5da>] ide_outsl+0x5/0x9
 [<c027c540>] ata_output_data+0x4d/0x64
 [<c027b8a6>] atapi_output_bytes+0x19/0x3f
 [<c0285377>] cdrom_transfer_packet_command+0xb5/0xde
 [<c0282607>] cdrom_timer_expiry+0x0/0x51
 [<c02840c3>] cdrom_start_packet_command+0x14f/0x157
 [<c02853e9>] cdrom_do_pc_continuation+0x0/0x2c
 [<c027aa33>] ide_do_request+0x70a/0x943
 [<c0363ef3>] schedule_timeout+0x13/0x8b
 [<c021faeb>] elv_drain_elevator+0x15/0x58
 [<c0220277>] elv_insert+0xf6/0x1d9
 [<c0285377>] cdrom_transfer_packet_command+0xb5/0xde
 [<c0282607>] cdrom_timer_expiry+0x0/0x51
 [<c027b038>] ide_do_drive_cmd+0x99/0xe9
 [<c0282abe>] cdrom_queue_packet_command+0x35/0xa9
 [<c0363b2b>] schedule+0x321/0x33e
 [<c0363ef3>] schedule_timeout+0x13/0x8b
 [<c0282d11>] cdrom_read_tocentry+0x96/0xa1
 [<c02220d3>] blk_end_sync_rq+0x0/0x23
 [<c028315b>] cdrom_read_toc+0x14b/0x42e
 [<c02220d3>] blk_end_sync_rq+0x0/0x23
 [<c027b07e>] ide_do_drive_cmd+0xdf/0xe9
 [<c0283ed2>] ide_cdrom_audio_ioctl+0x13c/0x1de
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0282f42>] cdrom_check_status+0x55/0x60
 [<c02220d3>] blk_end_sync_rq+0x0/0x23
 [<c02865ba>] cdrom_count_tracks+0x64/0x16a
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c02896c4>] cdrom_open+0x190/0x8f8
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c02252d3>] get_disk+0x4e/0x65
 [<c02252f1>] exact_lock+0x7/0xd
 [<c025a2cc>] kobj_lookup+0x104/0x12e
 [<c02828e8>] idecd_open+0x72/0x86
 [<c0174458>] do_open+0x198/0x238
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c0174561>] __blkdev_get+0x69/0x74
 [<c017457e>] blkdev_get+0x12/0x14
 [<c0263333>] pkt_open+0x8d/0xc96
 [<c017162c>] dump_trace+0x52/0x8b
 [<c0103423>] show_trace_log_lvl+0x18/0x2c
 [<c0103bf2>] show_trace+0xf/0x11
 [<c0103f85>] dump_stack+0x68/0x6d
 [<c0104171>] do_IRQ+0x66/0xc5
 [<c0102f8b>] common_interrupt+0x23/0x28
 [<c027b5da>] ide_outsl+0x5/0x9
 [<c027c540>] ata_output_data+0x4d/0x64
 [<c027b8a6>] atapi_output_bytes+0x19/0x3f
 [<c0285377>] cdrom_transfer_packet_command+0xb5/0xde
 [<c0282607>] cdrom_timer_expiry+0x0/0x51
 [<c02840c3>] cdrom_start_packet_command+0x14f/0x157
 [<c02853e9>] cdrom_do_pc_continuation+0x0/0x2c
 [<c027aa33>] ide_do_request+0x70a/0x943
 [<c0363ef3>] schedule_timeout+0x13/0x8b
 [<c021faeb>] elv_drain_elevator+0x15/0x58
 [<c0220277>] elv_insert+0xf6/0x1d9
 [<c0285377>] cdrom_transfer_packet_command+0xb5/0xde
 [<c0282607>] cdrom_timer_expiry+0x0/0x51
 [<c027b038>] ide_do_drive_cmd+0x99/0xe9
 [<c0282abe>] cdrom_queue_packet_command+0x35/0xa9
 [<c0363b2b>] schedule+0x321/0x33e
 [<c0363ef3>] schedule_timeout+0x13/0x8b
 [<c0282d11>] cdrom_read_tocentry+0x96/0xa1
 [<c02220d3>] blk_end_sync_rq+0x0/0x23
 [<c028315b>] cdrom_read_toc+0x14b/0x42e
 [<c02220d3>] blk_end_sync_rq+0x0/0x23
 [<c027b07e>] ide_do_drive_cmd+0xdf/0xe9
 [<c0283ed2>] ide_cdrom_audio_ioctl+0x13c/0x1de
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0282f42>] cdrom_check_status+0x55/0x60
 [<c02220d3>] blk_end_sync_rq+0x0/0x23
 [<c02865ba>] cdrom_count_tracks+0x64/0x16a
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c02896c4>] cdrom_open+0x190/0x8f8
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c02afbd9>] console [netcon0] enabled


Second oops:

netconsole: network logging started
pktcdvd: Fixed packets, 32 blocks, Mode-2 disc
pktcdvd: Max. media speed: 4
pktcdvd: write speed 2x
pktcdvd: 551232kB available on disc
UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'LinuxUDF', timestamp 2004/05/03 13:03 (1000)
do_IRQ: stack overflow: 388
Pid: 1515, comm: mount Not tainted 2.6.24.2-dirty #4
 [<c0104171>] do_IRQ+0x66/0xc5
 [<c027c540>] ata_output_data+0x4d/0x64
 [<c0102f8b>] common_interrupt+0x23/0x28
 [<c027c60d>] ide_outb+0x1/0x2
 [<c0284015>] cdrom_start_packet_command+0xa1/0x157
 [<c02853e9>] cdrom_do_pc_continuation+0x0/0x2c
 [<c027aa33>] ide_do_request+0x70a/0x943
 [<c0363ef3>] schedule_timeout+0x13/0x8b
 [<c0363ef3>] schedule_timeout+0x13/0x8b
 [<c027c540>] ata_output_data+0x4d/0x64
 [<c021faeb>] elv_drain_elevator+0x15/0x58
 [<c0220277>] elv_insert+0xf6/0x1d9
 [<c0363d78>] wait_for_common+0xb6/0x12f
 [<c0221ee4>] __blk_put_request+0x1e/0x6f
 [<c027b038>] ide_do_drive_cmd+0x99/0xe9
 [<c0282abe>] cdrom_queue_packet_command+0x35/0xa9
 [<c0282abe>] cdrom_queue_packet_command+0x35/0xa9
 [<c0363ef3>] schedule_timeout+0x13/0x8b
 [<c0285b5b>] ide_cdrom_packet+0x80/0xa1
 [<c02220d3>] blk_end_sync_rq+0x0/0x23
 [<c0286be0>] cdrom_get_track_info+0x91/0x9e
 [<c0286c49>] cdrom_get_last_written+0x5c/0x107
 [<c02220d3>] blk_end_sync_rq+0x0/0x23
 [<c02833f7>] cdrom_read_toc+0x3e7/0x42e
 [<c02220d3>] blk_end_sync_rq+0x0/0x23
 [<c0283ed2>] ide_cdrom_audio_ioctl+0x13c/0x1de
 [<c0282f42>] cdrom_check_status+0x55/0x60
 [<c02220d3>] blk_end_sync_rq+0x0/0x23
 [<c02865ba>] cdrom_count_tracks+0x64/0x16a
 [<c02896c4>] cdrom_open+0x190/0x8f8
 [<c02252d3>] get_disk+0x4e/0x65
 [<c02252f1>] exact_lock+0x7/0xd
 [<c025a2cc>] kobj_lookup+0x104/0x12e
 [<c02828e8>] idecd_open+0x72/0x86
 [<c0174458>] do_open+0x198/0x238
 [<c0174561>] __blkdev_get+0x69/0x74
 [<c017457e>]  [<c02252d3>] get_disk+0x4e/0x65
 [<c02252f1>] exact_lock+0x7/0xd
 [<c025a2cc>] kobj_lookup+0x104/0x12e
 [<c0224ed0>] exact_match+0x0/0x4
 [<c0174344>] do_open+0x84/0x238
 [<c0174561>] __blkdev_get+0x69/0x74
 [<c017457e>] blkdev_get+0x12/0x14
 [<c0174894>] open_bdev_excl+0x2b/0x65
 [<c0155f20>] get_sb_bdev+0x14/0x108
 [<c021182c>] udf_get_sb+0x20/0x25
 [<c0213197>] udf_fill_super+0x0/0xb63
 [<c0155e04>] vfs_kern_mount+0x40/0x79
 [<c0155e86>] do_kern_mount+0x35/0xbb
 [<c0167b7d>] do_mount+0x5da/0x621
 [<c01669e9>] mntput_no_expire+0x13/0x7c
 [<c015c6a4>] link_path_walk+0xa5/0xaf
 [<c01445e9>] handle_mm_fault+0x263/0x531
 [<c01383b8>] find_lock_page+0x1f/0x96
 [<c013a485>] filemap_fault+0x21d/0x37d
 [<c015d140>] __user_walk_fd+0x3d/0x45
 [<c013cb08>] __alloc_pages+0x5d/0x2d9
 [<c013cdb6>] __get_free_pages+0x32/0x4d
 [<c0166669>] copy_mount_options+0x26/0x10d
 [<c0167c3b>] sys_mount+0x77/0xb3
 [<c010257a>] sysenter_past_esp+0x5f/0x85
 [<c031ffff>] __ip_route_output_key+0x257/0x733
BUG: unable to handle kernel paging request at virtual address 83c70a74
printing eip: c01033d2 *pde = 00000000 
Oops: 0000 [#1] PREEMPT 
Modules linked in: netconsole

Pid: 1515, comm: mount Not tainted (2.6.24.2-dirty #4)
EIP: 0060:[<c01033d2>] EFLAGS: 00010097 CPU: 0
EIP is at dump_trace+0x52/0x8b
EAX: 00000114 EBX: 83c70a74 ECX: 00000045 EDX: 00000000
ESI: 470a2c47 EDI: 83c70000 EBP: 83c70ffc ESP: ee401168
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process mount (pid: 1515, ti=ee401000 task=eef86680 task.ti=ee401000)
Stack: 63736e2f c03f6c0c 00000000 0000001c 00000000 c0103423 c036e79c c03f6c0c 
       00000002 c0103bf2 c03f6c0c c0103f85 c03ccd19 000005eb eef86930 c0505178 
       c0429436 00000002 c0429477 ee4011c4 c0523bbc c0104171 c03cce23 00000184 
Call Trace:
 [<c0103423>] show_trace_log_lvl+0x18/0x2c
 [<c0103bf2>] show_trace+0xf/0x11
 [<c0103f85>] dump_stack+0x68/0x6d
 [<c0104171>] do_IRQ+0x66/0xc5
 [<c027c540>] ata_output_data+0x4d/0x64
 [<c0102f8b>] common_interrupt+0x23/0x28
 [<c027c60d>] ide_outb+0x1/0x2
 [<c0284015>] cdrom_start_packet_command+0xa1/0x157
 [<c02853e9>] cdrom_do_pc_continuation+0x0/0x2c
 [<c027aa33>] ide_do_request+0x70a/0x943
 [<c0363ef3>] schedule_timeout+0x13/0x8b
 [<c0363ef3>] schedule_timeout+0x13/0x8b
 [<c027c540>] ata_output_data+0x4d/0x64
 [<c021faeb>] elv_drain_elevator+0x15/0x58
 [<c0220277>] elv_insert+0xf6/0x1d9
 [<c0363d78>] wait_for_common+0xb6/0x12f
 [<c0221ee4>] __blk_put_request+0x1e/0x6f
 [<c027b038>] ide_do_drive_cmd+0x99/0xe9
idecd_open+0x72/0x86
do_open+0x198/0x238
 [<c0174561>] __blkdev_get+0x69/0x74
 [<c017457e>] blkdev_get+0x12/0x14
 [<c0263333>] pkt_open+0x8d/0xc96
 [<c022998c>] kobject_get+0xf/0x13
 [<c02252d3>] get_disk+0x4e/0x65
 [<c02252f1>] exact_lock+0x7/0xd
 [<c025a2cc>] kobj_lookup+0x104/0x12e
 [<c0224ed0>] exact_match+0x0/0x4
 [<c0174344>] do_open+0x84/0x238
 [<c0174561>] __blkdev_get+0x69/0x74
 [<c017457e>] blkdev_get+0x12/0x14
 [<c0174894>] open_bdev_excl+0x2b/0x65
 [<c0155f20>] get_sb_bdev+0x14/0x108
 [<c021182c>] udf_get_sb+0x20/0x25
 [<c0213197>] udf_fill_super+0x0/0xb63
 [<c0155e04>] vfs_kern_mount+0x40/0x79
 [<c0155e86>] do_kern_mount+0x35/0xbb
 [<c0167b7d>] do_mount+0x5da/0x621
 [<c01669e9>] mntput_no_expire+0x13/0x7c
 [<c015c6a4>] link_path_walk+0xa5/0xaf
 [<c01445e9>] handle_mm_fault+0x263/0x531
 [<c01383b8>] find_lock_page+0x1f/0x96
 [<c013a485>] filemap_fault+0x21d/0x37d
 [<c015d140>] __user_walk_fd+0x3d/0x45
 [<c013cb08>] __alloc_pages+0x5d/0x2d9
 [<c013cdb6>] __get_free_pages+0x32/0x4d
 [<c0166669>] copy_mount_options+0x26/0x10d
 [<c0167c3b>] sys_mount+0x77/0xb3
 [<c010257a>] sysenter_past_esp+0x5f/0x85
 [<c03117eb>] dev_ethtool+0x5f2/0xbdf
BUG: unable to handle kernel paging request at virtual address 0f742024
printing eip: c01033d2 *pde = 00000000 
Recursive die() failure, output suppressed
---[ end trace b1006dcd2ea53f36 ]---
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000069
printing eip: c0116289 *pde = 00000000 
Oops: 0000 [#3] PREEMPT 
Modules linked in: netconsole

Pid: 1515, comm: mount Tainted: G      D (2.6.24.2-dirty #4)
EIP: 0060:[<c0116289>] EFLAGS: 00010246 CPU: 0
EIP is at do_exit+0x20f/0x658
EAX: 00000045 EBX: 00000001 ECX: eef86c78 EDX: 00000000
ESI: eef86680 EDI: 0000000b EBP: 00000046 ESP: ee400e2c
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process mount (pid: 1515, ti=ee400000 task=eef86680 task.ti=ee401000)
Stack: 00000093 ee400ed0 00000000 c03d103b 00000046 c01141d4 c03d12cf ee400e58 
       ee400e58 ee400ed0 00000000 c03d103b 00000046 c010383d c03cca34 eef3d200 
       eef86680 0f742024 00000000 eef3d200 eef86680 0f742024 c0366770 c03e5efb 
Call Trace:
 [<c01141d4>] printk+0x1b/0x1f
 [<c010383d>] die+0x1a8/0x1b0
 [<c0366770>] do_page_fault+0x502/0x5e2
 [<c036626e>] do_page_fault+0x0/0x5e2
 [<c0365032>] error_code+0x6a/0x70
 [<c01033d2>] dump_trace+0x52/0x8b
 [<c01141d4>] printk+0x1b/0x1f
 [<c0103423>] show_trace_log_lvl+0x18/0x2c
 [<c01034d2>] show_stack_log_lvl+0x9b/0xa3
 [<c0103579>] show_registers+0x9f/0x1bb
 [<c01264ee>] notify_die+0x30/0x34
 [<c0103783>] die+0xee/0x1b0
 [<c0366770>] do_page_fault+0x502/0x5e2
 [<c036626e>] do_page_fault+0x0/0x5e2
 [<c0365032>] error_code+0x6a/0x70
 =======================
Code: 00 89 f0 e8 ae cd 01 00 85 db 74 19 8b 86 


CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_SUPPORTS_OPROFILE=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_LOG_BUF_SHIFT=14
CONFIG_CGROUPS=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_FAIR_CGROUP_SCHED=y
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE="usr/initramfs.hades"
CONFIG_INITRAMFS_ROOT_UID=99
CONFIG_INITRAMFS_ROOT_GID=101
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_KMOD=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=m
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_TICK_ONESHOT=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_X86_PC=y
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
CONFIG_MK7=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_USE_3DNOW=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_VM86=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_NOHIGHMEM=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_PROC_MM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
CONFIG_MTRR=y
CONFIG_SECCOMP=y
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_PHYSICAL_START=0x100000
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_PM=y
CONFIG_PM_LEGACY=y
CONFIG_SUSPEND_UP_POSSIBLE=y
CONFIG_HIBERNATION_UP_POSSIBLE=y
CONFIG_PCI=y
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_ISA_DMA_API=y
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_MISC=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_FIB_HASH=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_1284=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=16
CONFIG_MISC_DEVICES=y
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y
CONFIG_BLK_DEV_IDEDISK=y
CONFIG_IDEDISK_MULTI_MODE=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_SHARE_IRQ=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_IDE_ARCH_OBSOLETE_INIT=y
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_BLK_DEV_SD=m
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m
CONFIG_SCSI_LOWLEVEL=y
CONFIG_MD=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
CONFIG_DM_ZERO=y
CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
CONFIG_INPUT=y
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_INPUT_MISC=y
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_LIBPS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_SERIAL_8250=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_CORE=y
CONFIG_UNIX98_PTYS=y
CONFIG_PRINTER=m
CONFIG_RTC=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_VIAPRO=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SSB_POSSIBLE=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_SN9C102=y
CONFIG_AGP=y
CONFIG_AGP_VIA=y
CONFIG_DRM=m
CONFIG_DRM_RADEON=m
CONFIG_VGA_CONSOLE=y
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=y
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_MPU401=m
CONFIG_SND_EMU10K1=y
CONFIG_SND_INTEL8X0=y
CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_PRINTER=y
CONFIG_USB_STORAGE=m
CONFIG_AUXDISPLAY=y
CONFIG_DMIID=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_JBD=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_FS_POSIX_ACL=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_DNOTIFY=y
CONFIG_FUSE_FS=y
CONFIG_GENERIC_ACL=y
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_PROC_FS=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_PARTITION_ADVANCED=y
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_UTF8=m
CONFIG_INSTRUMENTATION=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_MARKERS=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_4KSTACKS=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_CBC=y
CONFIG_BITREVERSE=y
CONFIG_CRC32=y
CONFIG_ZLIB_INFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
