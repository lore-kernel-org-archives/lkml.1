Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbXCFEOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbXCFEOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 23:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbXCFEOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 23:14:22 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:45743 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbXCFEOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 23:14:20 -0500
Date: Mon, 05 Mar 2007 23:13:47 -0500
From: Eric Buddington <ebuddington@verizon.net>
Subject: khubd and ent:sda1 sucking CPU with reiser4 + USB HD
To: linux-kernel@vger.kernel.org
Reply-to: ebuddington@wesleyan.edu
Message-id: <20070306041337.GA9198@pool-71-123-121-36.spfdma.east.verizon.net>
Organization: ECS Labs
MIME-version: 1.0
Content-type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Content-disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-Eric-conspiracy: there is no conspiracy
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Kernel 2.6.20-mm2 on an Athlon XP.

Caveat: I know my USB cabling may cause the initial failure, but I
think the system should be failing more gracefully.

After hours of backing up to my external USB drive, I see in dmesg:

APIC error on CPU0: 00(02)
APIC error on CPU0: 02(02)
APIC error on CPU0: 02(02)
...<repeats many times>
usb 1-6.2: reset high speed USB device using ehci_hcd and address 7
usb 1-6.2: device descriptor read/64, error -110
usb 1-6.2: device descriptor read/64, error -110
...<repeats 3x>
sd 0:0:0:0: scsi: Device offlined - not ready after error recovery
sd 0:0:0:0: SCSI error: return code = 0x00050000
end_request: I/O error, dev sda, sector 612518599
sd 0:0:0:0: rejecting I/O to offline device
sd 0:0:0:0: rejecting I/O to offline device
sd 0:0:0:0: rejecting I/O to offline device
sd 0:0:0:0: SCSI error: return code = 0x00010000
end_request: I/O error, dev sda, sector 612518839
sd 0:0:0:0: rejecting I/O to offline device
sd 0:0:0:0: rejecting I/O to offline device
...<repeats many times>
reiser4[khubd(163)]: commit_current_atom (fs/reiser4/txnmgr.c:1049)[nikita-3176]:
WARNING: Flushing like mad: 16384
reiser4[khubd(163)]: commit_current_atom (fs/reiser4/txnmgr.c:1049)[nikita-3176]:
WARNING: Flushing like mad: 32768
...<many simiar messages>

Most problematically, khubd and ent:sda1! are conspiring to suck 100%
CPU time, even after powering off the drive. A bunch of processes are
stuck in 'D' state, possibly because they're trying to access the dead
disk, which won't umount ("device is busy").

I have not been able to test this setup with the ub driver yet (is it
possible with ub as a module, and usb-storage built in?).

I don't know how repeatable this is, but the processes are still going
and I'm happy to provide more diagnostics if you tell me what's
useful. I'll reboot tomorrow to get use of the drive again.

dmesg output from alt-sysrq-[wpp] is attached.

I have the impression that reiser4 development is cool these days, and
I'll likely reformat and try ext3 if nobody asks for more tests with
reiser4.

-Eric

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

SysRq : Show Blocked State

                         free                        sibling
  task             PC    stack   pid father child younger older
kswapd0       D EB3F9BDC     0   195      6           196   165 (L-TLB)
       f7c61db4 00000046 c06fc3e0 eb3f9bdc 0001116d 00000096 db4e5f3c 00000009 
       c1b9c070 eb3fa997 0001116d 00185c88 c1b9c164 eb3f9fef 0001116d f34a9240 
       f7c61e04 c126a560 f7c61dd0 f7c61dd8 c04be097 00000001 c1b9c070 c0115fb9 
Call Trace:
 [<c04be097>] wait_for_completion+0x5a/0x83
 [<c0115fb9>] default_wake_function+0x0/0xc
 [<c01bf9ac>] write_page_by_ent+0xdc/0xe6
 [<c0143658>] shrink_inactive_list+0x38a/0x712
 [<c0142d1d>] isolate_lru_pages+0x4e/0x195
 [<c01431d7>] shrink_active_list+0x2fd/0x305
 [<c0143a9e>] shrink_zone+0xbe/0xdf
 [<c0143f3f>] kswapd+0x26e/0x391
 [<c0126000>] autoremove_wake_function+0x0/0x35
 [<c0143cd1>] kswapd+0x0/0x391
 [<c0125ea3>] kthread+0xa0/0xc9
 [<c0125e03>] kthread+0x0/0xc9
 [<c01056ab>] kernel_thread_helper+0x7/0x10
 =======================
X             D D44363E0     0  3946   3244          4146       (NOTLB)
       f3bc3d0c 00003082 1502a8c0 d44363e0 00003286 f4218800 d1593934 00000009 
       f3ba6ad0 f67dce8a 000111e7 0006cd95 f3ba6bc4 f67dce8a 000111e7 f3cbe140 
       f3bc3d5c c137acc0 f3bc3d28 f3bc3d30 c04be097 00000001 f3ba6ad0 c0115fb9 
Call Trace:
 [<c04be097>] wait_for_completion+0x5a/0x83
 [<c0115fb9>] default_wake_function+0x0/0xc
 [<c01bf9ac>] write_page_by_ent+0xdc/0xe6
 [<c0143658>] shrink_inactive_list+0x38a/0x712
 [<c01431d7>] shrink_active_list+0x2fd/0x305
 [<c0143a9e>] shrink_zone+0xbe/0xdf
 [<c0144420>] try_to_free_pages+0x148/0x240
 [<c013fa7a>] __alloc_pages+0x18f/0x28c
 [<c0146ab9>] __pte_alloc+0xd/0x58
 [<c014ab3e>] move_page_tables+0x92/0x1e6
 [<c014b027>] do_mremap+0x395/0x502
 [<c014b1c9>] sys_mremap+0x35/0x50
 [<c0104b28>] sysenter_past_esp+0x5d/0x81
 =======================
gtk-gnutella  D 2C679F64     0  4162   4158  4184    4166  4161 (NOTLB)
       f2881cfc 00000086 f2881cdc 2c679f64 f2881cdc c06f5220 00000000 00000009 
       f41f1540 01d88b49 00011179 00007a0b f41f1634 00011197 c06f5220 f39d6ba0 
       f2881d4c c122f520 f2881d18 f2881d20 c04be097 00000001 f41f1540 c0115fb9 
Call Trace:
 [<c04be097>] wait_for_completion+0x5a/0x83
 [<c0115fb9>] default_wake_function+0x0/0xc
 [<c01bf9ac>] write_page_by_ent+0xdc/0xe6
 [<c0143658>] shrink_inactive_list+0x38a/0x712
 [<c014b4e5>] page_referenced_one+0x9b/0xb2
 [<c014bd04>] page_referenced+0x63/0xc7
 [<c01431d7>] shrink_active_list+0x2fd/0x305
 [<c0143a9e>] shrink_zone+0xbe/0xdf
 [<c0144420>] try_to_free_pages+0x148/0x240
 [<c013fa7a>] __alloc_pages+0x18f/0x28c
 [<c0149745>] vma_merge+0xf8/0x17f
 [<c0146e7c>] __handle_mm_fault+0x378/0x772
 [<c04c04fb>] do_page_fault+0x20a/0x512
 [<c04c02f1>] do_page_fault+0x0/0x512
 [<c04bf104>] error_code+0x74/0x7c
 =======================
mkzftree      D 00000012     0  7247      1          7589  7854 (NOTLB)
       e5c75ad8 00000086 00000046 00000012 00000000 00000046 c226f960 00000009 
       e62a2030 e4fe6a99 0001116e 00000bf6 e62a2124 2967d2dd 0001116e e8775c60 
       dde78344 d2a36d80 dde7836c c226f960 c01af79c 00000000 e62a2030 c0126000 
Call Trace:
 [<c01af79c>] reiser4_go_to_sleep+0x52/0x6b
 [<c0126000>] autoremove_wake_function+0x0/0x35
 [<c01b3f7d>] capture_fuse_wait+0x80/0xd5
 [<c01b38ee>] wait_for_fusion+0x0/0x17
 [<c01b45e1>] reiser4_try_capture+0x40a/0x461
 [<c01afe08>] longterm_lock_znode+0x1df/0x28b
 [<c01ba878>] coord_by_handle+0xee/0x981
 [<c011e1ec>] getnstimeofday+0x2b/0xac
 [<c012b660>] tick_program_event+0x36/0x6e
 [<c011e46b>] run_timer_softirq+0x11/0x12f
 [<c013833d>] __rcu_process_callbacks+0xd0/0x120
 [<c011e1ec>] getnstimeofday+0x2b/0xac
 [<c01bb308>] reiser4_object_lookup+0xc6/0xd1
 [<c01c5e86>] find_file_item_nohint+0x50/0x56
 [<c01c64bb>] find_file_item+0xda/0x104
 [<c01dbd5f>] update_extents+0x8b/0x1c6
 [<c01dc4ec>] reiser4_write_extent+0x523/0x5bc
 [<c011ebee>] do_timer+0x4f6/0x6e1
 [<c01b3b60>] reiser4_txn_begin+0x1c/0x2e
 [<c01dbfc9>] reiser4_write_extent+0x0/0x5bc
 [<c01c7d4c>] write_unix_file+0x27e/0x4c0
 [<c012abb2>] clockevents_program_event+0x9c/0xa3
 [<c01c7ace>] write_unix_file+0x0/0x4c0
 [<c0156e24>] vfs_write+0x8a/0x10c
 [<c01572b5>] sys_write+0x41/0x67
 [<c0104b28>] sysenter_past_esp+0x5d/0x81
 =======================
mkzftree      D A79BE66E     0  7589      1          9679  7247 (NOTLB)
       db641ad8 00000086 3f9bdbc0 a79be66e 00011186 00000000 d2a36d80 0000000a 
       f2a92070 e4fde455 0001116e 00002d18 f2a92164 b65371f1 00011169 e8775100 
       c21ffe64 d2a36d80 c21ffe8c f79fea60 c01af79c 00000000 f2a92070 c0126000 
Call Trace:
 [<c01af79c>] reiser4_go_to_sleep+0x52/0x6b
 [<c0126000>] autoremove_wake_function+0x0/0x35
 [<c01b3f7d>] capture_fuse_wait+0x80/0xd5
 [<c01b38ee>] wait_for_fusion+0x0/0x17
 [<c01b45e1>] reiser4_try_capture+0x40a/0x461
 [<c01afe08>] longterm_lock_znode+0x1df/0x28b
 [<c01ba878>] coord_by_handle+0xee/0x981
 [<c01b3b27>] capture_assign_txnh_nolock+0x1a/0x37
 [<c01b43f1>] reiser4_try_capture+0x21a/0x461
 [<c01152fb>] __activate_task+0x1c/0x28
 [<c01b2df3>] grabbed2flush_reserved_nolock+0x26/0x51
 [<c01afb45>] longterm_unlock_znode+0x82/0x14f
 [<c01c545d>] write_sd_by_inode_common+0x511/0x597
 [<c028e635>] elv_insert+0x90/0x104
 [<c011e1ec>] getnstimeofday+0x2b/0xac
 [<c012abb2>] clockevents_program_event+0x9c/0xa3
 [<c01bb308>] reiser4_object_lookup+0xc6/0xd1
 [<c01c5e86>] find_file_item_nohint+0x50/0x56
 [<c01c64bb>] find_file_item+0xda/0x104
 [<c01dbd5f>] update_extents+0x8b/0x1c6
 [<c01dc4ec>] reiser4_write_extent+0x523/0x5bc
 [<c011ebee>] do_timer+0x4f6/0x6e1
 [<c01288b3>] hrtimer_interrupt+0x196/0x1be
 [<c01b3b60>] reiser4_txn_begin+0x1c/0x2e
 [<c01dbfc9>] reiser4_write_extent+0x0/0x5bc
 [<c01c7d4c>] write_unix_file+0x27e/0x4c0
 [<c012abb2>] clockevents_program_event+0x9c/0xa3
 [<c01c7ace>] write_unix_file+0x0/0x4c0
 [<c0156e24>] vfs_write+0x8a/0x10c
 [<c01572b5>] sys_write+0x41/0x67
 [<c0104b28>] sysenter_past_esp+0x5d/0x81
 =======================
sftp-server   D 2C679EE8     0  9679      1          9735  7589 (NOTLB)
       d1a99a3c 00000082 d1a99a1c 2c679ee8 d1a99a1c c06f5220 00000000 00000009 
       dead9580 f2ec6329 00011178 00010170 dead9674 c011e1ec d1a99a4c f3a998e0 
       d1a99a8c c13b9da0 d1a99a58 d1a99a60 c04be097 00000001 dead9580 c0115fb9 
Call Trace:
 [<c011e1ec>] getnstimeofday+0x2b/0xac
 [<c04be097>] wait_for_completion+0x5a/0x83
 [<c0115fb9>] default_wake_function+0x0/0xc
 [<c01bf9ac>] write_page_by_ent+0xdc/0xe6
 [<c0143658>] shrink_inactive_list+0x38a/0x712
 [<c014b4e5>] page_referenced_one+0x9b/0xb2
 [<c014bd04>] page_referenced+0x63/0xc7
 [<c01431d7>] shrink_active_list+0x2fd/0x305
 [<c0143a9e>] shrink_zone+0xbe/0xdf
 [<c0144420>] try_to_free_pages+0x148/0x240
 [<c013fa7a>] __alloc_pages+0x18f/0x28c
 [<c0141168>] __do_page_cache_readahead+0x94/0x1cd
 [<c0136c76>] handle_IRQ_event+0x1a/0x3f
 [<c014133d>] ra_submit+0x9c/0xa8
 [<c0141aa9>] page_cache_readahead_adaptive+0x2d3/0x4a4
 [<c013c0f8>] do_generic_mapping_read+0x1c7/0x4cd
 [<c013e031>] generic_file_aio_read+0x172/0x1a5
 [<c013b90b>] file_read_actor+0x0/0xd1
 [<c01567cb>] do_sync_read+0xc7/0x10a
 [<c0126035>] wake_bit_function+0x0/0x44
 [<c01c8229>] read_unix_file+0x0/0x403
 [<c01c82e9>] read_unix_file+0xc0/0x403
 [<c012abb2>] clockevents_program_event+0x9c/0xa3
 [<c012b660>] tick_program_event+0x36/0x6e
 [<c04be6cc>] mutex_lock+0xb/0x19
 [<c015703c>] generic_file_llseek+0x8c/0x97
 [<c01c8229>] read_unix_file+0x0/0x403
 [<c0156f2e>] vfs_read+0x88/0x10a
 [<c015724e>] sys_read+0x41/0x67
 [<c0104b28>] sysenter_past_esp+0x5d/0x81
 =======================
sftp-server   D C011EBEE     0  9735      1          9785  9679 (NOTLB)
       e8e4fa3c 00000086 00000046 c011ebee 00000001 c07617bc e8e4fa70 0000000a 
       dead9a90 e2f7f754 000111da 000e35a0 dead9b84 e2ee25ad 000111da f3b9f7c0 
       e8e4fa8c c1555e40 e8e4fa58 e8e4fa60 c04be097 00000001 dead9a90 c0115fb9 
Call Trace:
 [<c011ebee>] do_timer+0x4f6/0x6e1
 [<c04be097>] wait_for_completion+0x5a/0x83
 [<c0115fb9>] default_wake_function+0x0/0xc
 [<c01bf9ac>] write_page_by_ent+0xdc/0xe6
 [<c0143658>] shrink_inactive_list+0x38a/0x712
 [<c01431d7>] shrink_active_list+0x2fd/0x305
 [<c0143a9e>] shrink_zone+0xbe/0xdf
 [<c0144420>] try_to_free_pages+0x148/0x240
 [<c013fa7a>] __alloc_pages+0x18f/0x28c
 [<c0141168>] __do_page_cache_readahead+0x94/0x1cd
 [<c01288b3>] hrtimer_interrupt+0x196/0x1be
 [<c014133d>] ra_submit+0x9c/0xa8
 [<c0141aa9>] page_cache_readahead_adaptive+0x2d3/0x4a4
 [<c013c0f8>] do_generic_mapping_read+0x1c7/0x4cd
 [<c013e031>] generic_file_aio_read+0x172/0x1a5
 [<c013b90b>] file_read_actor+0x0/0xd1
 [<c01567cb>] do_sync_read+0xc7/0x10a
 [<c0126035>] wake_bit_function+0x0/0x44
 [<c01c8229>] read_unix_file+0x0/0x403
 [<c01c82e9>] read_unix_file+0xc0/0x403
 [<c012abb2>] clockevents_program_event+0x9c/0xa3
 [<c012b660>] tick_program_event+0x36/0x6e
 [<c04be6cc>] mutex_lock+0xb/0x19
 [<c015703c>] generic_file_llseek+0x8c/0x97
 [<c01c8229>] read_unix_file+0x0/0x403
 [<c0156f2e>] vfs_read+0x88/0x10a
 [<c015724e>] sys_read+0x41/0x67
 [<c0104b28>] sysenter_past_esp+0x5d/0x81
 =======================
sftp-server   D D72A5E88     0  9785      1                9735 (NOTLB)
       d72a5ec4 00000082 d72a5e34 d72a5e88 00000000 00000000 d72a5f64 0000000a 
       f64dcab0 eab914f6 0001136a 000114c9 f64dcba4 eab87c20 0001136a f652ac20 
       d72a5ef0 d4af2bf4 f39f7ce0 f64dcab0 c029b47b 00000000 d72a5ef0 d4af2bf8 
Call Trace:
 [<c029b47b>] rwsem_down_failed_common+0x15b/0x175
 [<c04bee6e>] rwsem_down_write_failed+0x18/0x1f
 [<c04beeda>] call_rwsem_down_write_failed+0x6/0x8
 [<c0128a01>] down_write+0x1b/0x1d
 [<c01c8850>] get_exclusive_access+0xf/0x18
 [<c01c7997>] release_unix_file+0x65/0x19c
 [<c0432cf2>] dev_hard_start_xmit+0x1ae/0x207
 [<c0157585>] __fput+0xa5/0x14d
 [<c01552fe>] filp_close+0x51/0x58
 [<c015626c>] sys_close+0x55/0x8a
 [<c0104b28>] sysenter_past_esp+0x5d/0x81
 =======================
netstat       D 32000004     0 10048   9548                     (NOTLB)
       c4b8de98 00000082 00000000 32000004 f3b0c1a0 b7f8f34c 00000005 00000007 
       c82e2540 6dfc1f36 00011385 0031dc60 c82e2634 00000000 f39ed1c0 f39d6040 
       c4b8dec4 f3cbe174 00000000 c82e2540 c029b47b c0157773 c4b8dec4 f3cbe178 
Call Trace:
 [<c029b47b>] rwsem_down_failed_common+0x15b/0x175
 [<c0157773>] get_empty_filp+0x4f/0xcc
 [<c04bee8f>] rwsem_down_read_failed+0x1a/0x23
 [<c04beecf>] call_rwsem_down_read_failed+0x7/0xc
 [<c0128a16>] down_read+0x13/0x15
 [<c0147fa4>] access_process_vm+0x39/0x165
 [<c01555bb>] do_filp_open+0x32/0x39
 [<c017e207>] proc_pid_cmdline+0x57/0xe7
 [<c017e7bb>] proc_info_read+0x4a/0xb3
 [<c017e771>] proc_info_read+0x0/0xb3
 [<c0156f2e>] vfs_read+0x88/0x10a
 [<c015724e>] sys_read+0x41/0x67
 [<c0104b28>] sysenter_past_esp+0x5d/0x81
 =======================
SysRq : Show Regs
SysRq : Show Regs

--J2SCkAp4GZ/dPZZf--
