Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbZBTKmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbZBTKmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 05:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZBTKlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 05:41:53 -0500
Received: from os.eurotux.com ([216.75.63.6]:52540 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbZBTKlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 05:41:46 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Feb 2009 05:41:45 EST
Date: Fri, 20 Feb 2009 10:34:43 +0000
From: Luciano Miguel Ferreira Rocha <luciano@eurotux.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: ext4 locks under 2.6.28.3..6
Message-ID: <20090220103443.GA3641@bit.office.eurotux.com>
Mail-Followup-To: Luciano Miguel Ferreira Rocha <luciano@eurotux.com>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I've experienced intermittent locks on my ext4 filesystems under kernel
2.6.28.3 till 2.6.28.6.

All mounted ext4 filesystems are locked, others keep working correctly.
I can't reproduce it at will, so I've been unable to do a bisect.

My current setup:

(sda1, sdb1) -> md0 raid1 -> ext3 /boot
(sda6, sdb6) -> md1 raid0 -> ext3 /
(sda2, sdb2) -> md2 raid1 -> ext4 /home
(sda3, sdb3) -> md3 raid0 -> luks -> ext4 /stuff

Mounts:
rootfs / rootfs rw 0 0
/dev/root / ext3 rw,errors=continue,user_xattr,acl,data=ordered 0 0
/dev /dev tmpfs rw,mode=755 0 0
/proc /proc proc rw 0 0
/sys /sys sysfs rw 0 0
/proc/bus/usb /proc/bus/usb usbfs rw 0 0
devpts /dev/pts devpts rw,gid=5,mode=620 0 0
/dev/mapper/luks-9f79b26a-6593-4009-acf6-ed3c5b191aae /stuff ext4 rw,relatime,user_xattr,acl,barrier=1,data=ordered 0 0
/dev/md2 /home ext4 rw,relatime,user_xattr,acl,barrier=1,data=ordered 0 0
/dev/md0 /boot ext3 rw,errors=continue,user_xattr,acl,data=ordered 0 0
tmpfs /dev/shm tmpfs rw 0 0
none /proc/sys/fs/binfmt_misc binfmt_misc rw 0 0
gvfs-fuse-daemon /home/luciano/.gvfs fuse.gvfs-fuse-daemon rw,nosuid,nodev,user_id=500,group_id=500 0 0
/dev/sdd1 /media/strlin ext3 rw,nosuid,nodev,errors=continue,data=ordered 0 0
/dev/loop0 /mnt iso9660 ro 0 0

(loop0 is a iso file under /stuff)

Some backtraces got from SysRq:

[69485.656748] SysRq : Show backtrace of all active CPUs
[69485.657020] CPU0:
[69485.657023]  f29fbb30 00200046 c1ffc558 00000002 f29fbb68 c0405802 00000000 c08a69cf
[69485.657029]  c05fbc4a c08b57e0 00000000 f601c9e0 c043b995 c1ffc560 f29fbb68 f29fbb68
[69485.657034]  c5037800 00000000 c5037b90 f1bd3500 c040e750 c0403bb0 c5037800 00200282
[69485.657039] Call Trace:
[69485.657047]  [<c0405802>] show_stack+0x10/0x13
[69485.657050]  [<c05fbc4a>] showacpu+0x36/0x47
[69485.657055]  [<c043b995>] generic_smp_call_function_single_interrupt+0x76/0xa5
[69485.657059]  [<c040e750>] smp_call_function_single_interrupt+0x1a/0x2f
[69485.657062]  [<c0403bb0>] call_function_single_interrupt+0x28/0x30
[69485.657066]  [<c07ca327>] _spin_unlock_irqrestore+0x4/0x22
[69485.657070]  [<c05eda6b>] n_tty_chars_in_buffer+0x51/0x57
[69485.657073]  [<c05f17bc>] pty_chars_in_buffer+0x1b/0x35
[69485.657076]  [<c05ef8d6>] tty_chars_in_buffer+0x12/0x13
[69485.657079]  [<c05ee095>] n_tty_poll+0x107/0x126
[69485.657082]  [<c05edf8e>] n_tty_poll+0x0/0x126
[69485.657084]  [<c05eb2c4>] tty_poll+0x46/0x5c
[69485.657088]  [<c04752b9>] do_sys_poll+0x1ba/0x321
[69485.657091]  [<c0475df2>] __pollwait+0x0/0xae
[69485.657094]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657097]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657099]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657102]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657105]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657107]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657110]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657112]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657115]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657118]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657120]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657123]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657125]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657128]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657131]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657133]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657136]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657138]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657141]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657143]  [<c041ce18>] default_wake_function+0x0/0x8
[69485.657148]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69485.657151]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69485.657153]  [<c05f0ad6>] tty_ldisc_deref+0x4c/0x5b
[69485.657156]  [<c0407a91>] read_tsc+0x6/0x22
[69485.657160]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69485.657162]  [<c0475572>] sys_poll+0x44/0x8d
[69485.657165]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69525.335397] SysRq : Show Regs
[69536.070198] SysRq : Show Blocked State
[69536.070204]   task                PC stack   pid father
[69536.070212] kjournald2    D c09e0564     0  1902      2
[69536.070217]  f60246e0 00000046 00000002 c09e0564 c09e3780 c09e3780 f60246e0 f6024834
[69536.070222]  c2007780 00000001 f613c050 f6024834 041d5459 00000282 c0419c29 00000000
[69536.070227]  00000000 00000003 00000246 f1b2523c f613c074 f6289f38 f613c000 c04d7fc0
[69536.070232] Call Trace:
[69536.070239]  [<c0419c29>] __wake_up+0x29/0x39
[69536.070244]  [<c04d7fc0>] jbd2_journal_commit_transaction+0x11a/0xd9c
[69536.070247]  [<c041a473>] dequeue_task_fair+0x33/0x16f
[69536.070251]  [<c0418e93>] dequeue_task+0x62/0x70
[69536.070256]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69536.070261]  [<c07c9010>] schedule+0x47c/0x48c
[69536.070265]  [<c0428a9a>] lock_timer_base+0x19/0x35
[69536.070269]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69536.070272]  [<c04db874>] kjournald2+0xbf/0x1f9
[69536.070275]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69536.070278]  [<c04db7b5>] kjournald2+0x0/0x1f9
[69536.070281]  [<c04308ad>] kthread+0x38/0x5d
[69536.070283]  [<c0430875>] kthread+0x0/0x5d
[69536.070287]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69536.070309] gconfd-2      D c09e0564     0  7333      1
[69536.070313]  f50b46e0 00000082 c1320024 c09e0564 c09e3780 c09e3780 f50b46e0 f50b4834
[69536.070317]  c2007780 00000001 c04829fc f50b4834 041f20a9 c1320020 00000000 c1320020
[69536.070323]  c04522b2 f6dcd508 00000246 f1b25200 f613c000 f2835dc4 f613c000 c04d7a65
[69536.070327] Call Trace:
[69536.070332]  [<c04829fc>] __find_get_block_slow+0xe6/0xf0
[69536.070338]  [<c04522b2>] mark_page_accessed+0x56/0x60
[69536.070341]  [<c04d7a65>] start_this_handle+0x29f/0x343
[69536.070344]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69536.070347]  [<c04d7c41>] jbd2_journal_start+0x83/0xaf
[69536.070351]  [<c04b80ce>] ext4_dirty_inode+0x21/0x63
[69536.070354]  [<c047f76f>] __mark_inode_dirty+0x21/0x13e
[69536.070358]  [<c04783a7>] file_update_time+0x7c/0xa5
[69536.070361]  [<c044c67a>] __generic_file_aio_write_nolock+0x142/0x28d
[69536.070365]  [<c0452acf>] page_mapping+0x10/0x25
[69536.070367]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69536.070371]  [<c0458cd7>] handle_mm_fault+0x4d1/0x4e2
[69536.070373]  [<c044cfd3>] generic_file_aio_write+0x5d/0xb4
[69536.070376]  [<c04b5711>] ext4_file_write+0xa7/0x11e
[69536.070380]  [<c046ac20>] do_sync_write+0xc0/0x107
[69536.070383]  [<c046d503>] cp_new_stat64+0xf7/0x109
[69536.070386]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69536.070389]  [<c046da43>] sys_fstat64+0x1e/0x23
[69536.070391]  [<c046ab60>] do_sync_write+0x0/0x107
[69536.070394]  [<c046b356>] vfs_write+0x76/0xa4
[69536.070396]  [<c046b41c>] sys_write+0x3c/0x63
[69536.070399]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69536.070407] rhythmbox     D c09e0564     0  7568      1
[69536.070410]  f2be7a70 00200086 f186dea0 c09e0564 c09e3780 c09e3780 f2be7a70 f2be7bc4
[69536.070415]  c1fff780 00000000 c047139e f2be7bc4 042045e4 c07ca33b f6b28068 f6b28000
[69536.070421]  f5ec6000 c047b23b f5ec6000 f1071b4c f2be7a70 f1071b50 00000002 c07c952d
[69536.070426] Call Trace:
[69536.070430]  [<c047139e>] __link_path_walk+0xf3/0x644
[69536.070432]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69536.070435]  [<c047b23b>] mntput_no_expire+0x18/0xe6
[69536.070438]  [<c07c952d>] __mutex_lock_common+0x8f/0xe0
[69536.070441]  [<c07c95d7>] __mutex_lock_slowpath+0xf/0x11
[69536.070444]  [<c07c9476>] mutex_lock+0xa/0xb
[69536.070447]  [<c07c9476>] mutex_lock+0xa/0xb
[69536.070449]  [<c04729da>] do_filp_open+0x139/0x697
[69536.070452]  [<c06788c0>] ehci_work+0xd0/0x60a
[69536.070455]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69536.070458]  [<c067c107>] ehci_irq+0x17e/0x19f
[69536.070461]  [<c0479ef6>] alloc_fd+0xc3/0xcd
[69536.070464]  [<c0469717>] do_sys_open+0x3f/0xb2
[69536.070466]  [<c04697ce>] sys_open+0x1e/0x23
[69536.070469]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69536.070473] rhythmbox     D c09e0564     0  8157      1
[69536.070476]  f5d43a70 00200086 c1cdd4a0 c09e0564 c09e3780 c09e3780 f5d43a70 f5d43bc4
[69536.070481]  c1fff780 00000000 f6bffe60 f5d43bc4 00000000 c04bdd4f f6bffec4 f6c3da1c
[69536.070486]  f1071ad4 00000010 00200246 f1b25200 f613c000 f6bffe88 f613c000 c04d7a65
[69536.070491] Call Trace:
[69536.070494]  [<c04bdd4f>] ext4_find_entry+0x450/0x4bd
[69536.070497]  [<c04d7a65>] start_this_handle+0x29f/0x343
[69536.070501]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69536.070504]  [<c04d7c41>] jbd2_journal_start+0x83/0xaf
[69536.070507]  [<c04be326>] ext4_create+0x44/0xde
[69536.070509]  [<c04be2e2>] ext4_create+0x0/0xde
[69536.070512]  [<c0472170>] vfs_create+0x3d/0x5b
[69536.070514]  [<c0472a98>] do_filp_open+0x1f7/0x697
[69536.070518]  [<c04682c2>] kmem_cache_alloc+0x43/0x76
[69536.070521]  [<c0479ef6>] alloc_fd+0xc3/0xcd
[69536.070524]  [<c0469717>] do_sys_open+0x3f/0xb2
[69536.070526]  [<c04697ce>] sys_open+0x1e/0x23
[69536.070528]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69536.070531] gkrellm       D c09e0564     0  8421      1
[69536.070533]  f50b7a70 00200086 f5f60800 c09e0564 c09e3780 c09e3780 f50b7a70 f50b7bc4
[69536.070538]  c2007780 00000001 00000002 f50b7bc4 041d9812 00000000 ca548f00 f5f60800
[69536.070543]  c04b4f3c 59821055 00200246 f1b25200 f613c000 f1a87f1c f613c000 c04d7a65
[69536.070548] Call Trace:
[69536.070551]  [<c04b4f3c>] call_filldir+0x98/0xc5
[69536.070554]  [<c04d7a65>] start_this_handle+0x29f/0x343
[69536.070557]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69536.070560]  [<c04d7c41>] jbd2_journal_start+0x83/0xaf
[69536.070563]  [<c04b80ce>] ext4_dirty_inode+0x21/0x63
[69536.070565]  [<c047f76f>] __mark_inode_dirty+0x21/0x13e
[69536.070568]  [<c0478481>] touch_atime+0xb1/0xb6
[69536.070571]  [<c0474c63>] vfs_readdir+0x63/0x7a
[69536.070573]  [<c04749d8>] filldir64+0x0/0xc5
[69536.070575]  [<c0474ce0>] sys_getdents64+0x66/0xa5
[69536.070578]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69536.070580] firefox       D c09e0564     0  8488   8472
[69536.070583]  f2be7700 00000086 c20077bc c09e0564 c09e3780 c09e3780 f2be7700 f2be7854
[69536.070588]  c2007780 00000001 c09e3780 f2be7854 041e49e1 f2be7700 c07c9010 f70314a0
[69536.070593]  c09e0564 c09e3780 00000246 f1b25200 f613c000 f1a59e1c f613c000 c04d7a65
[69536.070598] Call Trace:
[69536.070601]  [<c07c9010>] schedule+0x47c/0x48c
[69536.070604]  [<c04d7a65>] start_this_handle+0x29f/0x343
[69536.070607]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69536.070610]  [<c04d7c41>] jbd2_journal_start+0x83/0xaf
[69536.070613]  [<c04b80ce>] ext4_dirty_inode+0x21/0x63
[69536.070615]  [<c047f76f>] __mark_inode_dirty+0x21/0x13e
[69536.070618]  [<c0478481>] touch_atime+0xb1/0xb6
[69536.070621]  [<c044ccf4>] generic_file_aio_read+0x52f/0x578
[69536.070624]  [<c046ad27>] do_sync_read+0xc0/0x107
[69536.070626]  [<c046d503>] cp_new_stat64+0xf7/0x109
[69536.070629]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69536.070632]  [<c046da43>] sys_fstat64+0x1e/0x23
[69536.070635]  [<c046ac67>] do_sync_read+0x0/0x107
[69536.070637]  [<c046b4b6>] vfs_read+0x73/0xa1
[69536.070639]  [<c046b57c>] sys_read+0x3c/0x63
[69536.070642]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69536.070645] usb-storage   D c09e0564     0 14347      2
[69536.070648]  f1aff020 00000046 c066bbd2 c09e0564 c09e3780 c09e3780 f1aff020 f1aff174
[69536.070653]  c1fff780 00000000 c09e0564 f1aff174 04207535 c16c7f20 c0466c2c 00000000
[69536.070658]  00000000 c15ccb00 c0467cc5 7fffffff 7fffffff c8f55e90 e127a428 c07c9174
[69536.070662] Call Trace:
[69536.070666]  [<c066bbd2>] usb_hcd_submit_urb+0x75b/0x821
[69536.070669]  [<c0466c2c>] unfreeze_slab+0x7a/0xed
[69536.070672]  [<c0467cc5>] __slab_alloc+0xda/0x501
[69536.070675]  [<c07c9174>] schedule_timeout+0x13/0x99
[69536.070678]  [<c04686e5>] __kmalloc+0x72/0xa5
[69536.070681]  [<c066c394>] usb_alloc_urb+0xc/0x28
[69536.070684]  [<c07c8ae6>] wait_for_common+0x90/0xe1
[69536.070687]  [<c041ce18>] default_wake_function+0x0/0x8
[69536.070690]  [<c066ca01>] usb_sg_wait+0xee/0xfb
[69536.070693]  [<c06833d7>] usb_stor_bulk_transfer_sglist+0x8b/0xcf
[69536.070696]  [<c0683487>] usb_stor_bulk_srb+0x18/0x28
[69536.070699]  [<c068359a>] usb_stor_Bulk_transport+0x103/0x23b
[69536.070702]  [<c068318b>] usb_stor_invoke_transport+0x15/0x1d6
[69536.070705]  [<c07c9174>] schedule_timeout+0x13/0x99
[69536.070708]  [<c041c79b>] check_preempt_wakeup+0xb2/0xd8
[69536.070711]  [<c041eb1e>] signal_pending_state+0x17/0x3b
[69536.070713]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69536.070716]  [<c07c8b2d>] wait_for_common+0xd7/0xe1
[69536.070719]  [<c041ce18>] default_wake_function+0x0/0x8
[69536.070722]  [<c0684585>] usb_stor_control_thread+0x11e/0x1b1
[69536.070724]  [<c0419bb4>] complete+0x28/0x36
[69536.070727]  [<c0684467>] usb_stor_control_thread+0x0/0x1b1
[69536.070730]  [<c04308ad>] kthread+0x38/0x5d
[69536.070733]  [<c0430875>] kthread+0x0/0x5d
[69536.070735]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69536.070737] kjournald     D c09e0564     0 14401      2
[69536.070740]  f2be5130 00000046 00000000 c09e0564 c09e3780 c09e3780 f2be5130 f2be5284
[69536.070745]  c1fff780 00000000 c059dccd f2be5284 c1632e40 c0467cc5 ffffffff 00000000
[69536.070750]  f1972480 ffffff10 f602ea20 c1fff780 c1fffb70 c50a7ee8 c1ff2ce8 c07c9041
[69536.070754] Call Trace:
[69536.070758]  [<c059dccd>] __make_request+0x326/0x36c
[69536.070761]  [<c0467cc5>] __slab_alloc+0xda/0x501
[69536.070764]  [<c07c9041>] io_schedule+0x21/0x2b
[69536.070767]  [<c0483789>] sync_buffer+0x30/0x33
[69536.070769]  [<c07c938a>] __wait_on_bit+0x33/0x58
[69536.070771]  [<c0483759>] sync_buffer+0x0/0x33
[69536.070774]  [<c07c9464>] out_of_line_wait_on_bit+0xb5/0xbd
[69536.070777]  [<c0483759>] sync_buffer+0x0/0x33
[69536.070780]  [<c0430b72>] wake_bit_function+0x0/0x3c
[69536.070782]  [<c0483710>] __wait_on_buffer+0x26/0x29
[69536.070785]  [<c04d2db9>] journal_commit_transaction+0x47d/0xcb8
[69536.070788]  [<c0428a9a>] lock_timer_base+0x19/0x35
[69536.070791]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69536.070794]  [<c0428afa>] try_to_del_timer_sync+0x44/0x4a
[69536.070797]  [<c04d5c60>] kjournald+0xbf/0x1f7
[69536.070800]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69536.070802]  [<c04d5ba1>] kjournald+0x0/0x1f7
[69536.070805]  [<c04308ad>] kthread+0x38/0x5d
[69536.070808]  [<c0430875>] kthread+0x0/0x5d
[69536.070810]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69536.070813] rsync         D c09e0564     0  8116   8115
[69536.070816]  f1aff700 00200082 c09e0764 c09e0564 c09e3780 c09e3780 f1aff700 f1aff854
[69536.070821]  c1fff780 00000000 00000001 f1aff854 0420729b ffffffff f73f9460 00000001
[69536.070826]  c059b201 f73f9460 c059d1b4 c1fff780 c1fffb70 f6959b04 f73f9494 c07c9041
[69536.070831] Call Trace:
[69536.070834]  [<c059b201>] elv_may_queue+0x15/0x17
[69536.070837]  [<c059d1b4>] get_request+0x83/0x221
[69536.070840]  [<c07c9041>] io_schedule+0x21/0x2b
[69536.070842]  [<c059d84f>] get_request_wait+0x8c/0x105
[69536.070845]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69536.070848]  [<c059dc2c>] __make_request+0x285/0x36c
[69536.070851]  [<c0467cc5>] __slab_alloc+0xda/0x501
[69536.070854]  [<c059cb1a>] generic_make_request+0x18a/0x1c0
[69536.070857]  [<c044d391>] mempool_alloc+0x27/0xcb
[69536.070859]  [<c044d391>] mempool_alloc+0x27/0xcb
[69536.070862]  [<c059cbce>] submit_bio+0x7e/0x85
[69536.070865]  [<c048583c>] bio_alloc_bioset+0x79/0xc2
[69536.070868]  [<c0482769>] submit_bh+0xdb/0xf7
[69536.070870]  [<c0484aca>] __block_write_full_page+0x200/0x2fb
[69536.070874]  [<c04a9396>] ext3_get_block+0x0/0xb8
[69536.070877]  [<c04d1950>] journal_stop+0x165/0x171
[69536.070879]  [<c0484c09>] block_write_full_page+0x44/0x95
[69536.070882]  [<c04a9396>] ext3_get_block+0x0/0xb8
[69536.070884]  [<c04a8469>] ext3_ordered_writepage+0xbd/0x128
[69536.070887]  [<c04a709a>] bget_one+0x0/0x7
[69536.070890]  [<c044ffb4>] __writepage+0x8/0x22
[69536.070892]  [<c045074d>] write_cache_pages+0x1c3/0x2b3
[69536.070895]  [<c044ffac>] __writepage+0x0/0x22
[69536.070898]  [<c0450857>] generic_writepages+0x1a/0x21
[69536.070900]  [<c0450887>] do_writepages+0x29/0x30
[69536.070903]  [<c047eeff>] __writeback_single_inode+0x15d/0x313
[69536.070906]  [<c0450d52>] get_dirty_limits+0x240/0x2bc
[69536.070909]  [<c047f448>] generic_sync_sb_inodes+0x212/0x367
[69536.070912]  [<c047f70d>] writeback_inodes+0x5f/0xa0
[69536.070915]  [<c045104e>] balance_dirty_pages_ratelimited_nr+0x161/0x2be
[69536.070917]  [<c04d1950>] journal_stop+0x165/0x171
[69536.070920]  [<c044c290>] generic_file_buffered_write+0x1a7/0x284
[69536.070923]  [<c044c79d>] __generic_file_aio_write_nolock+0x265/0x28d
[69536.070928]  [<c0713a4d>] sock_aio_read+0xec/0xfa
[69536.070930]  [<c044cfd3>] generic_file_aio_write+0x5d/0xb4
[69536.070933]  [<c04a6278>] ext3_file_write+0x19/0x85
[69536.070935]  [<c046ac20>] do_sync_write+0xc0/0x107
[69536.070939]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69536.070941]  [<c046ab60>] do_sync_write+0x0/0x107
[69536.070944]  [<c046b356>] vfs_write+0x76/0xa4
[69536.070946]  [<c046b41c>] sys_write+0x3c/0x63
[69536.070949]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69536.070952]  [<c07c0000>] pci_probe+0x2d5/0x362
[69536.070953] pdflush       D c09e0564     0  8119      2
[69536.070956]  f2be46e0 00000046 00000000 c09e0564 c09e3780 c09e3780 f2be46e0 f2be4834
[69536.070961]  c2007780 00000001 00000000 f2be4834 00000292 c0419c29 00000000 00000000
[69536.070966]  00000003 c1c53f40 c1c53f40 c2007780 c2007b70 f61ddda8 c1ff8330 c07c9041
[69536.070970] Call Trace:
[69536.070973]  [<c0419c29>] __wake_up+0x29/0x39
[69536.070976]  [<c07c9041>] io_schedule+0x21/0x2b
[69536.070978]  [<c044b68a>] sync_page+0x43/0x48
[69536.070981]  [<c07c9261>] __wait_on_bit_lock+0x31/0x6a
[69536.070983]  [<c044b647>] sync_page+0x0/0x48
[69536.070985]  [<c044b637>] __lock_page+0x76/0x7e
[69536.070988]  [<c0430b72>] wake_bit_function+0x0/0x3c
[69536.070991]  [<c04506de>] write_cache_pages+0x154/0x2b3
[69536.070994]  [<c04b9c92>] __mpage_da_writepage+0x0/0x12d
[69536.070997]  [<c04b9ace>] ext4_da_writepages+0x1c1/0x2de
[69536.071001]  [<c0418e93>] dequeue_task+0x62/0x70
[69536.071003]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69536.071006]  [<c041e14f>] finish_task_switch+0x1f/0x69
[69536.071008]  [<c04bab9d>] ext4_da_get_block_write+0x0/0x12c
[69536.071009]  [<c04b990d>] ext4_da_writepages+0x0/0x2de
[69536.071009]  [<c045087e>] do_writepages+0x20/0x30
[69536.071009]  [<c047eeff>] __writeback_single_inode+0x15d/0x313
[69536.071009]  [<c0450b28>] get_dirty_limits+0x16/0x2bc
[69536.071009]  [<c069d28b>] raid1_congested+0x93/0xa5
[69536.071009]  [<c047f448>] generic_sync_sb_inodes+0x212/0x367
[69536.071009]  [<c04560d6>] congestion_wait+0x5b/0x65
[69536.071009]  [<c047f70d>] writeback_inodes+0x5f/0xa0
[69536.071009]  [<c0450e46>] background_writeout+0x78/0xa7
[69536.071009]  [<c0451367>] pdflush+0x116/0x1b1
[69536.071009]  [<c0450dce>] background_writeout+0x0/0xa7
[69536.071009]  [<c0451251>] pdflush+0x0/0x1b1
[69536.071009]  [<c04308ad>] kthread+0x38/0x5d
[69536.071009]  [<c0430875>] kthread+0x0/0x5d
[69536.071009]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69536.071009] pdflush       D c09e0564     0  8123      2
[69536.071009]  f2990dc0 00000046 f70314a0 c09e0564 c09e3780 c09e3780 f2990dc0 f2990f14
[69536.071009]  c2007780 00000001 00000286 f2990f14 0420754b 042075ac f6bdff18 c07ca33b
[69536.071009]  c0428beb 042075ac 00000286 042075ac 042075ac c091f6f0 00000001 c07c91df
[69536.071009] Call Trace:
[69536.071009]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69536.071009]  [<c0428beb>] __mod_timer+0x8e/0x97
[69536.071009]  [<c07c91df>] schedule_timeout+0x7e/0x99
[69536.071009]  [<c042877e>] process_timeout+0x0/0x5
[69536.071009]  [<c07c898a>] __sched_text_start+0x22/0x2c
[69536.071009]  [<c04560cb>] congestion_wait+0x50/0x65
[69536.071009]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69536.071009]  [<c0450e6b>] background_writeout+0x9d/0xa7
[69536.071009]  [<c0451367>] pdflush+0x116/0x1b1
[69536.071009]  [<c0450dce>] background_writeout+0x0/0xa7
[69536.071009]  [<c0451251>] pdflush+0x0/0x1b1
[69536.071009]  [<c04308ad>] kthread+0x38/0x5d
[69536.071009]  [<c0430875>] kthread+0x0/0x5d
[69536.071009]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69536.071009] pdflush       D c09e0564     0  8124      2
[69536.071009]  f29906e0 00000046 c09192f0 c09e0564 c09e3780 c09e3780 f29906e0 f2990834
[69536.071009]  c1fff780 00000000 00000286 f2990834 04207535 04207595 f1ad9f20 c07ca33b
[69536.071009]  c0428beb 04207595 00000286 04207595 04207595 c091f6f0 00000001 c07c91df
[69536.071009] Call Trace:
[69536.071009]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69536.071009]  [<c0428beb>] __mod_timer+0x8e/0x97
[69536.071009]  [<c07c91df>] schedule_timeout+0x7e/0x99
[69536.071009]  [<c042877e>] process_timeout+0x0/0x5
[69536.071009]  [<c07c898a>] __sched_text_start+0x22/0x2c
[69536.071009]  [<c04560cb>] congestion_wait+0x50/0x65
[69536.071009]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69536.071009]  [<c0450998>] wb_kupdate+0x97/0xdf
[69536.071009]  [<c0451367>] pdflush+0x116/0x1b1
[69536.071009]  [<c0450901>] wb_kupdate+0x0/0xdf
[69536.071009]  [<c0451251>] pdflush+0x0/0x1b1
[69536.071009]  [<c04308ad>] kthread+0x38/0x5d
[69536.071009]  [<c0430875>] kthread+0x0/0x5d
[69536.071009]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69536.071009] mutt          D c09e0564     0  8145   8144
[69536.071009]  f5e1b020 00200082 00000000 c09e0564 c09e3780 c09e3780 f5e1b020 f5e1b174
[69536.071009]  c2007780 00000001 00000000 f5e1b174 00200282 c0419c29 00000000 00000000
[69536.071009]  00000003 c106bd60 c106bd60 c2007780 c2007b70 f1a8de00 c1ff2298 c07c9041
[69536.071009] Call Trace:
[69536.071009]  [<c0419c29>] __wake_up+0x29/0x39
[69536.071009]  [<c07c9041>] io_schedule+0x21/0x2b
[69536.071009]  [<c044b68a>] sync_page+0x43/0x48
[69536.071009]  [<c07c9261>] __wait_on_bit_lock+0x31/0x6a
[69536.071009]  [<c044b647>] sync_page+0x0/0x48
[69536.071009]  [<c044b637>] __lock_page+0x76/0x7e
[69536.071009]  [<c0430b72>] wake_bit_function+0x0/0x3c
[69536.071009]  [<c04506de>] write_cache_pages+0x154/0x2b3
[69536.071009]  [<c04b9c92>] __mpage_da_writepage+0x0/0x12d
[69536.071009]  [<c04d7aea>] start_this_handle+0x324/0x343
[69536.071009]  [<c04b9ace>] ext4_da_writepages+0x1c1/0x2de
[69536.071009]  [<c046ac20>] do_sync_write+0xc0/0x107
[69536.071009]  [<c04bab9d>] ext4_da_get_block_write+0x0/0x12c
[69536.071009]  [<c04b990d>] ext4_da_writepages+0x0/0x2de
[69536.071009]  [<c045087e>] do_writepages+0x20/0x30
[69536.071009]  [<c044c073>] __filemap_fdatawrite_range+0x54/0x60
[69536.071009]  [<c044cd65>] filemap_fdatawrite+0x12/0x16
[69536.071009]  [<c0481b26>] do_fsync+0x23/0x69
[69536.071009]  [<c0481b88>] __do_fsync+0x1c/0x2b
[69536.071009]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69536.071009]  [<c07c0000>] pci_probe+0x2d5/0x362
[69536.071009] pdflush       D c09e0564     0  8152      2
[69536.071009]  f73bf020 00000046 c09192f0 c09e0564 c09e3780 c09e3780 f73bf020 f73bf174
[69536.071009]  c1fff780 00000000 00000286 f73bf174 042074d0 0420757a f6921f18 c07ca33b
[69536.071009]  c0428beb 0420757a 00000286 0420757a 0420757a c091f6f0 00000001 c07c91df
[69536.071009] Call Trace:
[69536.071009]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69536.071009]  [<c0428beb>] __mod_timer+0x8e/0x97
[69536.071009]  [<c07c91df>] schedule_timeout+0x7e/0x99
[69536.071009]  [<c042877e>] process_timeout+0x0/0x5
[69536.071009]  [<c07c898a>] __sched_text_start+0x22/0x2c
[69536.071009]  [<c04560cb>] congestion_wait+0x50/0x65
[69536.071009]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69536.071009]  [<c0450e6b>] background_writeout+0x9d/0xa7
[69536.071009]  [<c0451367>] pdflush+0x116/0x1b1
[69536.071009]  [<c0450dce>] background_writeout+0x0/0xa7
[69536.071009]  [<c0451251>] pdflush+0x0/0x1b1
[69536.071009]  [<c04308ad>] kthread+0x38/0x5d
[69536.071009]  [<c0430875>] kthread+0x0/0x5d
[69536.071009]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69536.071009] pdflush       D c09e0564     0  8214      2
[69536.071009]  e10f1ef0 00000046 f70314a0 c09e0564 c09e3780 c09e3780 e10f1ef0 e10f2044
[69536.071009]  c2007780 00000001 00000286 e10f2044 0420752a 042075ab f6017f18 c07ca33b
[69536.071009]  c0428beb 042075ab 00000286 042075ab 042075ab c091f6f0 00000001 c07c91df
[69536.071009] Call Trace:
[69536.071009]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69536.071009]  [<c0428beb>] __mod_timer+0x8e/0x97
[69536.071009]  [<c07c91df>] schedule_timeout+0x7e/0x99
[69536.071009]  [<c042877e>] process_timeout+0x0/0x5
[69536.071009]  [<c07c898a>] __sched_text_start+0x22/0x2c
[69536.071009]  [<c04560cb>] congestion_wait+0x50/0x65
[69536.071009]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69536.071009]  [<c0450e6b>] background_writeout+0x9d/0xa7
[69536.071009]  [<c0451367>] pdflush+0x116/0x1b1
[69536.071009]  [<c0450dce>] background_writeout+0x0/0xa7
[69536.071009]  [<c0451251>] pdflush+0x0/0x1b1
[69536.071009]  [<c04308ad>] kthread+0x38/0x5d
[69536.071009]  [<c0430875>] kthread+0x0/0x5d
[69536.071009]  [<c0403d57>] kernel_thread_helper+0x7/0x10
ake_up+0x14c/0x156
[69561.927007]  [<c04192ae>] __wake_up_common+0x34/0x59
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c070b5e5>] snd_usb_pcm_pointer+0x22/0x27
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c070b5e5>] snd_usb_pcm_pointer+0x22/0x27
[69561.927007]  [<c06de0b4>] snd_pcm_update_hw_ptr_pos+0x35/0x49
[69561.927007]  [<c06de2d9>] snd_pcm_update_hw_ptr+0x20/0xac
[69561.927007]  [<c06de2d9>] snd_pcm_update_hw_ptr+0x20/0xac
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c07ca2d5>] _read_unlock_irq+0x18/0x22
[69561.927007]  [<c06dc1a8>] snd_pcm_common_ioctl1+0xb1a/0xeee
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c067e3c5>] ohci_urb_enqueue+0x6e5/0x6fb
[69561.927007]  [<c0408c2b>] save_i387_fxsave+0x52/0x67
[69561.927007]  [<c0408b36>] restore_i387_fxsave+0x4d/0x5d
[69561.927007]  [<c05a7978>] __next_cpu+0x12/0x21
[69561.927007]  [<c043172a>] thread_group_cputime+0x8b/0x95
[69561.927007]  [<c0429041>] recalc_sigpending+0x22/0x37
[69561.927007]  [<c05aab21>] rb_insert_color+0x51/0xb5
[69561.927007]  [<c0432efc>] enqueue_hrtimer+0xad/0xb7
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0433600>] hrtimer_start_range_ns+0x101/0x13a
[69561.927007]  [<c0433624>] hrtimer_start_range_ns+0x125/0x13a
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c04754b3>] sys_ppoll+0x93/0x10e
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] pulseaudio    S c09e0564     0  7421      1
[69561.927007]  f2992940 00000082 f50b4370 c09e0564 c09e3780 c09e3780 f2992940 f2992a94
[69561.927007]  c2007780 00000001 001e0b4e f2992a94 00000001 f2a6fbb0 c2004470 c07ca33b
[69561.927007]  c04334e4 00000282 f2a6fbb0 00000000 00000000 f2a6fe7c 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c04334e4>] hrtimer_try_to_cancel+0x56/0x5d
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c04330d4>] hrtimer_wakeup+0x0/0x18
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c05a7978>] __next_cpu+0x12/0x21
[69561.927007]  [<c043172a>] thread_group_cputime+0x8b/0x95
[69561.927007]  [<c04328fe>] run_posix_cpu_timers+0x6a3/0x6ee
[69561.927007]  [<c05abb3b>] number+0x126/0x1eb
[69561.927007]  [<c05abb3b>] number+0x126/0x1eb
[69561.927007]  [<c05ac4de>] vsnprintf+0x47e/0x4b9
[69561.927007]  [<c05ac4de>] vsnprintf+0x47e/0x4b9
[69561.927007]  [<c05ac01a>] string+0x27/0x6d
[69561.927007]  [<c05ac2f1>] vsnprintf+0x291/0x4b9
[69561.927007]  [<c040efbe>] flush_tlb_page+0x7f/0x8d
[69561.927007]  [<c0418b50>] update_curr+0x5f/0x13f
[69561.927007]  [<c041a6d5>] enqueue_task_fair+0x126/0x178
[69561.927007]  [<c040f12d>] xapic_wait_icr_idle+0x11/0x17
[69561.927007]  [<c040ebe4>] __send_IPI_dest_field+0x49/0x4c
[69561.927007]  [<c0419596>] resched_task+0x65/0x67
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c04192ae>] __wake_up_common+0x34/0x59
[69561.927007]  [<c0419c29>] __wake_up+0x29/0x39
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0439898>] wake_futex+0x1c/0x26
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c043995d>] futex_wake+0xbb/0xc5
[69561.927007]  [<c0429041>] recalc_sigpending+0x22/0x37
[69561.927007]  [<c042b349>] dequeue_signal+0x92/0xfa
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c042b5a5>] sys_rt_sigtimedwait+0x1f4/0x23a
[69561.927007]  [<c06d150a>] snd_card_file_remove+0xde/0xe6
[69561.927007]  [<c0432d9c>] __remove_hrtimer+0x5d/0x64
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c04334e4>] hrtimer_try_to_cancel+0x56/0x5d
[69561.927007]  [<c04754b3>] sys_ppoll+0x93/0x10e
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] pulseaudio    S c09e0564     0  7422      1
[69561.927007]  f2992cb0 00000082 f2991810 c09e0564 c09e3780 c09e3780 f2992cb0 f2992e04
[69561.927007]  c1fff780 00000000 00051075 f2992e04 00000001 f2a49bb0 c1ffc470 c07ca33b
[69561.927007]  c04334e4 00000282 f2a49bb0 00000000 00000000 f2a49e7c 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c04334e4>] hrtimer_try_to_cancel+0x56/0x5d
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c04330d4>] hrtimer_wakeup+0x0/0x18
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c040efbe>] flush_tlb_page+0x7f/0x8d
[69561.927007]  [<c0415942>] ptep_set_access_flags+0x20/0x26
[69561.927007]  [<c04578cb>] do_wp_page+0x163/0x3eb
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c0457aea>] do_wp_page+0x382/0x3eb
[69561.927007]  [<c0458c93>] handle_mm_fault+0x48d/0x4e2
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c06f470f>] azx_send_cmd+0xce/0xd5
[69561.927007]  [<c0467158>] __slab_free+0xdf/0x31d
[69561.927007]  [<c04345d1>] pm_qos_remove_requirement+0x5c/0x8f
[69561.927007]  [<c0468162>] kfree+0x76/0x7f
[69561.927007]  [<c04345d1>] pm_qos_remove_requirement+0x5c/0x8f
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0434553>] update_target+0x56/0x78
[69561.927007]  [<c06dbbe6>] snd_pcm_common_ioctl1+0x558/0xeee
[69561.927007]  [<c04135cb>] do_page_fault+0x269/0x5c2
[69561.927007]  [<c0413624>] do_page_fault+0x2c2/0x5c2
[69561.927007]  [<c040efbe>] flush_tlb_page+0x7f/0x8d
[69561.927007]  [<c0415942>] ptep_set_access_flags+0x20/0x26
[69561.927007]  [<c041a6d5>] enqueue_task_fair+0x126/0x178
[69561.927007]  [<c041c79b>] check_preempt_wakeup+0xb2/0xd8
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c04192ae>] __wake_up_common+0x34/0x59
[69561.927007]  [<c0419c29>] __wake_up+0x29/0x39
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0439898>] wake_futex+0x1c/0x26
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c043995d>] futex_wake+0xbb/0xc5
[69561.927007]  [<c043a724>] do_futex+0x98/0x714
[69561.927007]  [<c042b5a5>] sys_rt_sigtimedwait+0x1f4/0x23a
[69561.927007]  [<c0468162>] kfree+0x76/0x7f
[69561.927007]  [<c06d150a>] snd_card_file_remove+0xde/0xe6
[69561.927007]  [<c048d1a1>] eventfd_read+0x13c/0x150
[69561.927007]  [<c04754b3>] sys_ppoll+0x93/0x10e
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] pulseaudio    S c09e0564     0  7425      1
[69561.927007]  f2993020 00000082 f70314a0 c09e0564 c09e3780 c09e3780 f2993020 f2993174
[69561.927007]  c2007780 00000001 00036fd2 f2993174 00000001 f2a85bb0 c2004470 c07ca33b
[69561.927007]  c04334e4 00000282 f2a85bb0 00000000 00000000 f2a85e7c 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c04334e4>] hrtimer_try_to_cancel+0x56/0x5d
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c04330d4>] hrtimer_wakeup+0x0/0x18
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c040f12d>] xapic_wait_icr_idle+0x11/0x17
[69561.927007]  [<c040ebe4>] __send_IPI_dest_field+0x49/0x4c
[69561.927007]  [<c043b651>] generic_exec_single+0x59/0x71
[69561.927007]  [<c043b746>] smp_call_function_single+0xb0/0xc3
[69561.927007]  [<c06c5918>] smp_callback+0x0/0x1
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007]  [<c043b7d9>] smp_call_function_mask+0x80/0x181
[69561.927007]  [<c06c5918>] smp_callback+0x0/0x1
[69561.927007]  [<c0458c93>] handle_mm_fault+0x48d/0x4e2
[69561.927007]  [<c0467cc5>] __slab_alloc+0xda/0x501
[69561.927007]  [<c043b911>] smp_call_function+0x37/0x45
[69561.927007]  [<c06c592a>] cpuidle_latency_notify+0x11/0x17
[69561.927007]  [<c0433fc2>] notifier_call_chain+0x2a/0x47
[69561.927007]  [<c04341cd>] __blocking_notifier_call_chain+0x3f/0x49
[69561.927007]  [<c04341e0>] blocking_notifier_call_chain+0x9/0xc
[69561.927007]  [<c06dbbe6>] snd_pcm_common_ioctl1+0x558/0xeee
[69561.927007]  [<c067e3c5>] ohci_urb_enqueue+0x6e5/0x6fb
[69561.927007]  [<c0413624>] do_page_fault+0x2c2/0x5c2
[69561.927007]  [<c040efbe>] flush_tlb_page+0x7f/0x8d
[69561.927007]  [<c0415942>] ptep_set_access_flags+0x20/0x26
[69561.927007]  [<c041a6d5>] enqueue_task_fair+0x126/0x178
[69561.927007]  [<c040f12d>] xapic_wait_icr_idle+0x11/0x17
[69561.927007]  [<c040ebe4>] __send_IPI_dest_field+0x49/0x4c
[69561.927007]  [<c0419596>] resched_task+0x65/0x67
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c04192ae>] __wake_up_common+0x34/0x59
[69561.927007]  [<c0419c29>] __wake_up+0x29/0x39
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0439898>] wake_futex+0x1c/0x26
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c043995d>] futex_wake+0xbb/0xc5
[69561.927007]  [<c0429041>] recalc_sigpending+0x22/0x37
[69561.927007]  [<c042b349>] dequeue_signal+0x92/0xfa
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c042b5a5>] sys_rt_sigtimedwait+0x1f4/0x23a
[69561.927007]  [<c0468162>] kfree+0x76/0x7f
[69561.927007]  [<c06d150a>] snd_card_file_remove+0xde/0xe6
[69561.927007]  [<c0432d9c>] __remove_hrtimer+0x5d/0x64
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c04334e4>] hrtimer_try_to_cancel+0x56/0x5d
[69561.927007]  [<c04754b3>] sys_ppoll+0x93/0x10e
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] gvfs-hal-volu S c09e0564     0  7424      1
[69561.927007]  f50b14a0 00000086 e10f3020 c09e0564 c09e3780 c09e3780 f50b14a0 f50b15f4
[69561.927007]  c2007780 00000001 00000000 f50b15f4 c043343f ffffffff f2a83bc4 c07ca33b
[69561.927007]  c04334e4 00000282 f2a83bc4 00000000 00000000 f2a83ea8 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c043343f>] lock_hrtimer_base+0x15/0x2f
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c04334e4>] hrtimer_try_to_cancel+0x56/0x5d
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c04330d4>] hrtimer_wakeup+0x0/0x18
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c044f9d0>] get_page_from_freelist+0x353/0x402
[69561.927007]  [<c044fbab>] __alloc_pages_internal+0x98/0x391
[69561.927007]  [<c0452acf>] page_mapping+0x10/0x25
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c0458cd7>] handle_mm_fault+0x4d1/0x4e2
[69561.927007]  [<c04974c0>] task_dumpable+0x2b/0x36
[69561.927007]  [<c04135cb>] do_page_fault+0x269/0x5c2
[69561.927007]  [<c0413624>] do_page_fault+0x2c2/0x5c2
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c04b3619>] ext3_iget_acl+0x23/0x28
[69561.927007]  [<c04b3686>] ext3_get_acl+0x68/0x245
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c0477a93>] __d_lookup+0x106/0x119
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c04b3619>] ext3_iget_acl+0x23/0x28
[69561.927007]  [<c04b3686>] ext3_get_acl+0x68/0x245
[69561.927007]  [<c047a3ff>] __lookup_mnt+0xe/0x3e
[69561.927007]  [<c0476866>] dput+0x16/0xfc
[69561.927007]  [<c047181c>] __link_path_walk+0x571/0x644
[69561.927007]  [<c047b23b>] mntput_no_expire+0x18/0xe6
[69561.927007]  [<c0476866>] dput+0x16/0xfc
[69561.927007]  [<c0471aae>] path_walk+0x91/0x99
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c04737ac>] user_path_at+0x40/0x5f
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] gvfs-hal-volu S c09e0564     0  7458      1
[69561.927007]  f50b7700 00000086 c09192f0 c09e0564 c09e3780 c09e3780 f50b7700 f50b7854
[69561.927007]  c1fff780 00000000 c09745c0 f50b7854 00354a64 00000001 00000001 c0413362
[69561.927007]  f2b64c00 c07ca682 00000246 f2b64c00 00000014 f2b69e7c f2b64c00 c04700e6
[69561.927007] Call Trace:
[69561.927007]  [<c0413362>] do_page_fault+0x0/0x5c2
[69561.927007]  [<c07ca682>] error_code+0x72/0x78
[69561.927007]  [<c04700e6>] pipe_wait+0x50/0x6e
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c04707fd>] pipe_read+0x2c1/0x324
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c046ac67>] do_sync_read+0x0/0x107
[69561.927007]  [<c046ac67>] do_sync_read+0x0/0x107
[69561.927007]  [<c046b4b6>] vfs_read+0x73/0xa1
[69561.927007]  [<c046b57c>] sys_read+0x3c/0x63
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] gvfs-gphoto2- S c09e0564     0  7433      1
[69561.927007]  f2aa86e0 00000086 00000002 c09e0564 c09e3780 c09e3780 f2aa86e0 f2aa8834
[69561.927007]  c2007780 00000001 c0483710 f2aa8834 004afff2 c0485314 f2a87bfc c04a805a
[69561.927007]  f6810518 f2a87c3c 00000002 00000000 00000000 f2a87e98 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c0483710>] __wait_on_buffer+0x26/0x29
[69561.927007]  [<c0485314>] __bread+0x52/0x66
[69561.927007]  [<c04a805a>] ext3_get_branch+0x5b/0xc1
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c0466c2c>] unfreeze_slab+0x7a/0xed
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0769c0b>] unix_poll+0x14/0x86
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c059cb1a>] generic_make_request+0x18a/0x1c0
[69561.927007]  [<c0489357>] mpage_end_io_read+0x0/0x59
[69561.927007]  [<c059cbce>] submit_bio+0x7e/0x85
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c044b8e1>] add_to_page_cache_locked+0x9d/0xae
[69561.927007]  [<c0489357>] mpage_end_io_read+0x0/0x59
[69561.927007]  [<c04888af>] mpage_bio_submit+0x19/0x1d
[69561.927007]  [<c04892f2>] mpage_readpages+0xb4/0xbe
[69561.927007]  [<c04a8bb4>] ext3_readpages+0x0/0x15
[69561.927007]  [<c04515ed>] __do_page_cache_readahead+0x12c/0x19d
[69561.927007]  [<c04a9396>] ext3_get_block+0x0/0xb8
[69561.927007]  [<c044b4a8>] find_get_page+0x8f/0xa9
[69561.927007]  [<c044b76d>] find_lock_page+0x10/0x43
[69561.927007]  [<c04522b2>] mark_page_accessed+0x56/0x60
[69561.927007]  [<c044bce8>] filemap_fault+0x1df/0x319
[69561.927007]  [<c0457730>] __do_fault+0x274/0x2ac
[69561.927007]  [<c0458a4c>] handle_mm_fault+0x246/0x4e2
[69561.927007]  [<c0713a4d>] sock_aio_read+0xec/0xfa
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] gvfsd-trash   S c09e0564     0  7435      1
[69561.927007]  f2993700 00000086 f70314a0 c09e0564 c09e3780 c09e3780 f2993700 f2993854
[69561.927007]  c2007780 00000001 00000000 f2993854 0410ee3b ffffffff f2aa7bc4 c07ca33b
[69561.927007]  c04334e4 00000282 f2aa7bc4 00000000 00000000 f2aa7ec0 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c04334e4>] hrtimer_try_to_cancel+0x56/0x5d
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c04330d4>] hrtimer_wakeup+0x0/0x18
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c059d715>] __generic_unplug_device+0x27/0x29
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c044f737>] get_page_from_freelist+0xba/0x402
[69561.927007]  [<c044f97e>] get_page_from_freelist+0x301/0x402
[69561.927007]  [<c044b647>] sync_page+0x0/0x48
[69561.927007]  [<c041a473>] dequeue_task_fair+0x33/0x16f
[69561.927007]  [<c0419d1b>] set_next_entity+0x29/0x4e
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c040efbe>] flush_tlb_page+0x7f/0x8d
[69561.927007]  [<c0415942>] ptep_set_access_flags+0x20/0x26
[69561.927007]  [<c04578cb>] do_wp_page+0x163/0x3eb
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c0457aea>] do_wp_page+0x382/0x3eb
[69561.927007]  [<c0458c93>] handle_mm_fault+0x48d/0x4e2
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c043995d>] futex_wake+0xbb/0xc5
[69561.927007]  [<c043a724>] do_futex+0x98/0x714
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0430c42>] finish_wait+0x29/0x4a
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] gconf-helper  S c09e0564     0  7436   7398
[69561.927007]  f2993a70 00000086 f50b46e0 c09e0564 c09e3780 c09e3780 f2993a70 f2993bc4
[69561.927007]  c2007780 00000001 017d783f f2993bc4 00a9c52e 000000c8 f5e3a8a8 368a3080
[69561.927007]  00000c4d 477c9bf4 c20077bc 00000000 00000000 f2a4bea8 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c041a6d5>] enqueue_task_fair+0x126/0x178
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0769c0b>] unix_poll+0x14/0x86
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c063b042>] scsi_next_command+0x25/0x2f
[69561.927007]  [<c063b1cb>] scsi_end_request+0x6d/0x77
[69561.927007]  [<c063b6b6>] scsi_io_completion+0x16e/0x338
[69561.927007]  [<c063b912>] scsi_device_unbusy+0x64/0x7b
[69561.927007]  [<c0636df4>] scsi_finish_command+0x72/0x8a
[69561.927007]  [<c05a02dd>] blk_done_softirq+0x49/0x55
[69561.927007]  [<c04254b8>] __do_softirq+0x83/0x11e
[69561.927007]  [<c044b4a8>] find_get_page+0x8f/0xa9
[69561.927007]  [<c04664d9>] add_partial+0xe/0x44
[69561.927007]  [<c04664d9>] add_partial+0xe/0x44
[69561.927007]  [<c0467158>] __slab_free+0xdf/0x31d
[69561.927007]  [<c076b45b>] unix_stream_recvmsg+0x3d2/0x460
[69561.927007]  [<c076b45b>] unix_stream_recvmsg+0x3d2/0x460
[69561.927007]  [<c0468276>] kmem_cache_free+0x49/0x52
[69561.927007]  [<c076b45b>] unix_stream_recvmsg+0x3d2/0x460
[69561.927007]  [<c076a086>] scm_recv+0x19/0x65
[69561.927007]  [<c076b4ca>] unix_stream_recvmsg+0x441/0x460
[69561.927007]  [<c0458a4c>] handle_mm_fault+0x246/0x4e2
[69561.927007]  [<c0713a4d>] sock_aio_read+0xec/0xfa
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c046a92a>] fsnotify_access+0x3d/0x43
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] wnck-applet   S c09e0564     0  7443      1
[69561.927007]  f2991130 00000086 f50b5130 c09e0564 c09e3780 c09e3780 f2991130 f2991284
[69561.927007]  c1fff780 00000000 00000008 f2991284 f2ab7980 00000001 c0475a10 00000020
[69561.927007]  00000000 f2b17f64 00fff780 00000000 00000000 f2b17ed8 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c0475a10>] do_select+0x416/0x429
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0769c0b>] unix_poll+0x14/0x86
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c07169a0>] sock_alloc_send_skb+0x89/0x1ca
[69561.927007]  [<c07166c3>] sock_def_readable+0x12/0x5b
[69561.927007]  [<c07ca35c>] _read_unlock+0x17/0x21
[69561.927007]  [<c076b6f4>] unix_stream_sendmsg+0x20b/0x292
[69561.927007]  [<c076a086>] scm_recv+0x19/0x65
[69561.927007]  [<c076b4ca>] unix_stream_recvmsg+0x441/0x460
[69561.927007]  [<c041ce0e>] try_to_wake_up+0x14c/0x156
[69561.927007]  [<c0713a4d>] sock_aio_read+0xec/0xfa
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c04285de>] run_timer_softirq+0x173/0x17b
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] trashapplet   S c09e0564     0  7446      1
[69561.927007]  f50b5810 00000086 f2aab020 c09e0564 c09e3780 c09e3780 f50b5810 f50b5964
[69561.927007]  c1fff780 00000000 00000008 f50b5964 f2b1b780 00000001 c0475a10 00000020
[69561.927007]  00000000 f2b3df64 00000046 00000000 00000000 f2b3dee8 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c0475a10>] do_select+0x416/0x429
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0769c0b>] unix_poll+0x14/0x86
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c044b76d>] find_lock_page+0x10/0x43
[69561.927007]  [<c04522b2>] mark_page_accessed+0x56/0x60
[69561.927007]  [<c044bce8>] filemap_fault+0x1df/0x319
[69561.927007]  [<c076a086>] scm_recv+0x19/0x65
[69561.927007]  [<c076b4ca>] unix_stream_recvmsg+0x441/0x460
[69561.927007]  [<c0458a4c>] handle_mm_fault+0x246/0x4e2
[69561.927007]  [<c0713a4d>] sock_aio_read+0xec/0xfa
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] gvfsd-burn    S c09e0564     0  7455      1
[69561.927007]  f2aa94a0 00000082 f6024000 c09e0564 c09e3780 c09e3780 f2aa94a0 f2aa95f4
[69561.927007]  c2007780 00000001 017d783f f2aa95f4 fffccf70 f2a6dbc4 c1ffc470 c07ca33b
[69561.927007]  c04334e4 00000282 f2a6dbc4 00000000 00000000 f2a6de98 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c04334e4>] hrtimer_try_to_cancel+0x56/0x5d
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c04330d4>] hrtimer_wakeup+0x0/0x18
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0769c0b>] unix_poll+0x14/0x86
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c0458cd7>] handle_mm_fault+0x4d1/0x4e2
[69561.927007]  [<c04135cb>] do_page_fault+0x269/0x5c2
[69561.927007]  [<c0413624>] do_page_fault+0x2c2/0x5c2
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c076a086>] scm_recv+0x19/0x65
[69561.927007]  [<c076b4ca>] unix_stream_recvmsg+0x441/0x460
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c07169a0>] sock_alloc_send_skb+0x89/0x1ca
[69561.927007]  [<c0719ce3>] __alloc_skb+0x49/0xf6
[69561.927007]  [<c044b4a8>] find_get_page+0x8f/0xa9
[69561.927007]  [<c044b76d>] find_lock_page+0x10/0x43
[69561.927007]  [<c04522b2>] mark_page_accessed+0x56/0x60
[69561.927007]  [<c044bce8>] filemap_fault+0x1df/0x319
[69561.927007]  [<c0457730>] __do_fault+0x274/0x2ac
[69561.927007]  [<c0458a4c>] handle_mm_fault+0x246/0x4e2
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c046a9cc>] rw_copy_check_uvector+0x59/0xc3
[69561.927007]  [<c046a96d>] fsnotify_modify+0x3d/0x43
[69561.927007]  [<c046b18d>] do_readv_writev+0xcc/0xd6
[69561.927007]  [<c05e9abd>] write_null+0x0/0x3
[69561.927007]  [<c046a96d>] fsnotify_modify+0x3d/0x43
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] mini_commande S c09e0564     0  7470      1
[69561.927007]  f2aa9b80 00000082 f50b5130 c09e0564 c09e3780 c09e3780 f2aa9b80 f2aa9cd4
[69561.927007]  c1fff780 00000000 00000008 f2aa9cd4 f2a2a000 00000001 c0475a10 00000020
[69561.927007]  00000000 f28e9f64 00000004 00000000 00000000 f28e9ed0 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c0475a10>] do_select+0x416/0x429
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0769c0b>] unix_poll+0x14/0x86
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c0719ce3>] __alloc_skb+0x49/0xf6
[69561.927007]  [<c07169a0>] sock_alloc_send_skb+0x89/0x1ca
[69561.927007]  [<c07166c3>] sock_def_readable+0x12/0x5b
[69561.927007]  [<c07ca35c>] _read_unlock+0x17/0x21
[69561.927007]  [<c076b6f4>] unix_stream_sendmsg+0x20b/0x292
[69561.927007]  [<c076a086>] scm_recv+0x19/0x65
[69561.927007]  [<c076b4ca>] unix_stream_recvmsg+0x441/0x460
[69561.927007]  [<c0713a4d>] sock_aio_read+0xec/0xfa
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c04285de>] run_timer_softirq+0x173/0x17b
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] stickynotes_a S c09e0564     0  7473      1
[69561.927007]  f2aaa5d0 00000086 f50b5130 c09e0564 c09e3780 c09e3780 f2aaa5d0 f2aaa724
[69561.927007]  c2007780 00000001 00000008 f2aaa724 f2ac4580 00000001 c0475a10 00000020
[69561.927007]  00000000 f2ba3f64 00000046 00000000 00000000 f2ba3ee0 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c0475a10>] do_select+0x416/0x429
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0769c0b>] unix_poll+0x14/0x86
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c07166c3>] sock_def_readable+0x12/0x5b
[69561.927007]  [<c07ca35c>] _read_unlock+0x17/0x21
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c076a086>] scm_recv+0x19/0x65
[69561.927007]  [<c076b4ca>] unix_stream_recvmsg+0x441/0x460
[69561.927007]  [<c0713a4d>] sock_aio_read+0xec/0xfa
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] mixer_applet2 S c09e0564     0  7487      1
[69561.927007]  f29914a0 00000086 f50b5130 c09e0564 c09e3780 c09e3780 f29914a0 f29915f4
[69561.927007]  c1fff780 00000000 00000008 f29915f4 f2b92e00 00000001 c0475a10 00000020
[69561.927007]  00000000 f2bb5f64 001c47f0 00000000 00000000 f2bb5ed8 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c0475a10>] do_select+0x416/0x429
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c046b8a5>] fget_light+0x88/0xa0
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c07169a0>] sock_alloc_send_skb+0x89/0x1ca
[69561.927007]  [<c07166c3>] sock_def_readable+0x12/0x5b
[69561.927007]  [<c07ca35c>] _read_unlock+0x17/0x21
[69561.927007]  [<c076b6f4>] unix_stream_sendmsg+0x20b/0x292
[69561.927007]  [<c076a086>] scm_recv+0x19/0x65
[69561.927007]  [<c076b4ca>] unix_stream_recvmsg+0x441/0x460
[69561.927007]  [<c0713a4d>] sock_aio_read+0xec/0xfa
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] mixer_applet2 S c09e0564     0  7504      1
[69561.927007]  f2be4a50 00000086 f601c8e0 c09e0564 c09e3780 c09e3780 f2be4a50 f2be4ba4
[69561.927007]  c2007780 00000001 83837707 f2be4ba4 f2be4a7c c2007780 f2be4a50 c20077bc
[69561.927007]  c041a473 c2007780 00000001 00000000 00000000 f2be1e90 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c041a473>] dequeue_task_fair+0x33/0x16f
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c041e14f>] finish_task_switch+0x1f/0x69
[69561.927007]  [<c07c9010>] schedule+0x47c/0x48c
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c046f8dc>] pipe_poll+0x24/0x7c
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0428a9a>] lock_timer_base+0x19/0x35
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c05a9302>] kref_put+0x36/0x40
[69561.927007]  [<c066ccc2>] usb_start_wait_urb+0x83/0x8d
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c066ceb1>] usb_control_msg+0xd1/0xdb
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c041a6d5>] enqueue_task_fair+0x126/0x178
[69561.927007]  [<c041c79b>] check_preempt_wakeup+0xb2/0xd8
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c041ce0e>] try_to_wake_up+0x14c/0x156
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c06d4242>] snd_ctl_ioctl+0x75a/0xaab
[69561.927007]  [<c044b4a8>] find_get_page+0x8f/0xa9
[69561.927007]  [<c0405130>] do_IRQ+0x6e/0x7e
[69561.927007]  [<c044b76d>] find_lock_page+0x10/0x43
[69561.927007]  [<c041a6d5>] enqueue_task_fair+0x126/0x178
[69561.927007]  [<c0418ebe>] activate_task+0x1d/0x2b
[69561.927007]  [<c0419561>] resched_task+0x30/0x67
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c041ce0e>] try_to_wake_up+0x14c/0x156
[69561.927007]  [<c04192ae>] __wake_up_common+0x34/0x59
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c0467158>] __slab_free+0xdf/0x31d
[69561.927007]  [<c046ac20>] do_sync_write+0xc0/0x107
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c06d3566>] snd_ctl_read+0x196/0x1a5
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0474231>] vfs_ioctl+0x1c/0x5f
[69561.927007]  [<c046ab60>] do_sync_write+0x0/0x107
[69561.927007]  [<c046a96d>] fsnotify_modify+0x3d/0x43
[69561.927007]  [<c06d33d0>] snd_ctl_read+0x0/0x1a5
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] notification- S c09e0564     0  7490      1
[69561.927007]  f50b7390 00000086 f6024000 c09e0564 c09e3780 c09e3780 f50b7390 f50b74e4
[69561.927007]  c2007780 00000001 00000008 f50b74e4 f2b92000 00000001 c0475a10 00000020
[69561.927007]  00000000 f2bdff64 00000060 00000000 00000000 f2bdfed0 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c0475a10>] do_select+0x416/0x429
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0769c0b>] unix_poll+0x14/0x86
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c0719ce3>] __alloc_skb+0x49/0xf6
[69561.927007]  [<c07169a0>] sock_alloc_send_skb+0x89/0x1ca
[69561.927007]  [<c07166c3>] sock_def_readable+0x12/0x5b
[69561.927007]  [<c07ca35c>] _read_unlock+0x17/0x21
[69561.927007]  [<c076b6f4>] unix_stream_sendmsg+0x20b/0x292
[69561.927007]  [<c076a086>] scm_recv+0x19/0x65
[69561.927007]  [<c076b4ca>] unix_stream_recvmsg+0x441/0x460
[69561.927007]  [<c0713a4d>] sock_aio_read+0xec/0xfa
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] gnome-keyboar S c09e0564     0  7494      1
[69561.927007]  f2aab020 00000082 f70314a0 c09e0564 c09e3780 c09e3780 f2aab020 f2aab174
[69561.927007]  c2007780 00000001 c09e3680 f2aab174 0420c95f 00000001 00000046 00000000
[69561.927007]  f2be2800 00000046 00000046 00000000 00000000 f2bebed8 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0769c0b>] unix_poll+0x14/0x86
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c04192ae>] __wake_up_common+0x34/0x59
[69561.927007]  [<c0467158>] __slab_free+0xdf/0x31d
[69561.927007]  [<c0467158>] __slab_free+0xdf/0x31d
[69561.927007]  [<c076b45b>] unix_stream_recvmsg+0x3d2/0x460
[69561.927007]  [<c076b45b>] unix_stream_recvmsg+0x3d2/0x460
[69561.927007]  [<c0468276>] kmem_cache_free+0x49/0x52
[69561.927007]  [<c076b45b>] unix_stream_recvmsg+0x3d2/0x460
[69561.927007]  [<c076a086>] scm_recv+0x19/0x65
[69561.927007]  [<c076b4ca>] unix_stream_recvmsg+0x441/0x460
[69561.927007]  [<c041ce0e>] try_to_wake_up+0x14c/0x156
[69561.927007]  [<c0713a4d>] sock_aio_read+0xec/0xfa
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] avant-window- S c09e0564     0  7513   7374
[69561.927007]  f2aaacb0 00200086 c2004470 c09e0564 c09e3780 c09e3780 f2aaacb0 f2aaae04
[69561.927007]  c2007780 00000001 00000000 f2aaae04 0420caef f2ecbf78 00000000 004c37b7
[69561.927007]  c0433650 004c37b7 00000000 004c37b7 f2ecbf78 f2ecbbf8 004c37b7 c07c96cc
[69561.927007] Call Trace:
[69561.927007]  [<c0433650>] hrtimer_start_expires+0x17/0x1d
[69561.927007]  [<c07c96cc>] schedule_hrtimeout_range+0xc4/0xed
[69561.927007]  [<c04330d4>] hrtimer_wakeup+0x0/0x18
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041a6d5>] enqueue_task_fair+0x126/0x178
[69561.927007]  [<c0418ebe>] activate_task+0x1d/0x2b
[69561.927007]  [<c0419561>] resched_task+0x30/0x67
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c041ce0e>] try_to_wake_up+0x14c/0x156
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0462a8a>] dma_pool_alloc+0x202/0x20c
[69561.927007]  [<c067e32f>] ohci_urb_enqueue+0x64f/0x6fb
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c067e3c5>] ohci_urb_enqueue+0x6e5/0x6fb
[69561.927007]  [<c0468276>] kmem_cache_free+0x49/0x52
[69561.927007]  [<c076b45b>] unix_stream_recvmsg+0x3d2/0x460
[69561.927007]  [<c076a086>] scm_recv+0x19/0x65
[69561.927007]  [<c076b4ca>] unix_stream_recvmsg+0x441/0x460
[69561.927007]  [<c066bbd2>] usb_hcd_submit_urb+0x75b/0x821
[69561.927007]  [<c0458a4c>] handle_mm_fault+0x246/0x4e2
[69561.927007]  [<c0713a4d>] sock_aio_read+0xec/0xfa
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c067f273>] ohci_irq+0x266/0x2af
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] gnome-termina S c09e0564     0  7516      1
[69561.927007]  f2be54a0 00200086 c1ffc470 c09e0564 c09e3780 c09e3780 f2be54a0 f2be55f4
[69561.927007]  c1fff780 00000000 00000000 f2be55f4 0000c350 f29fbf78 00000000 0000c350
[69561.927007]  c0433650 0000c350 00000000 0000c350 f29fbf78 f29fbbf8 0000c350 c07c96cc
[69561.927007] Call Trace:
[69561.927007]  [<c0433650>] hrtimer_start_expires+0x17/0x1d
[69561.927007]  [<c07c96cc>] schedule_hrtimeout_range+0xc4/0xed
[69561.927007]  [<c04330d4>] hrtimer_wakeup+0x0/0x18
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c04334e4>] hrtimer_try_to_cancel+0x56/0x5d
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c04336fc>] hrtimer_nanosleep+0xa6/0x10e
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] gnome-termina S c09e0564     0  7523      1
[69561.927007]  f2aa9810 00200086 00000001 c09e0564 c09e3780 c09e3780 f2aa9810 f2aa9964
[69561.927007]  c2007780 00000001 f186be58 f2aa9964 00d80bfe 00000000 00000000 f186be7c
[69561.927007]  c0439793 00000002 00200246 f2b64e00 00000014 f186be7c f2b64e00 c04700e6
[69561.927007] Call Trace:
[69561.927007]  [<c0439793>] futex_wait+0x267/0x304
[69561.927007]  [<c04700e6>] pipe_wait+0x50/0x6e
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c04707fd>] pipe_read+0x2c1/0x324
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c046ac67>] do_sync_read+0x0/0x107
[69561.927007]  [<c046ac67>] do_sync_read+0x0/0x107
[69561.927007]  [<c046b4b6>] vfs_read+0x73/0xa1
[69561.927007]  [<c046b57c>] sys_read+0x3c/0x63
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] gnome-pty-hel S c09e0564     0  7519   7516
[69561.927007]  f2be5b80 00200086 f2be54a0 c09e0564 c09e3780 c09e3780 f2be5b80 f2be5cd4
[69561.927007]  c2007780 00000001 ffffffff f2be5cd4 00000000 00000000 00000000 00000000
[69561.927007]  f2be5b80 00000000 00000000 7fffffff 00000000 f1853e4c 00000000 c07c9174
[69561.927007] Call Trace:
[69561.927007]  [<c07c9174>] schedule_timeout+0x13/0x99
[69561.927007]  [<c0430cba>] prepare_to_wait+0x11/0x43
[69561.927007]  [<c076b2cd>] unix_stream_recvmsg+0x244/0x460
[69561.927007]  [<c0419c29>] __wake_up+0x29/0x39
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0713a4d>] sock_aio_read+0xec/0xfa
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c046b4c7>] vfs_read+0x84/0xa1
[69561.927007]  [<c046b57c>] sys_read+0x3c/0x63
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] bash          S c09e0564     0  7520   7516
[69561.927007]  f2be5ef0 00200086 00000000 c09e0564 c09e3780 c09e3780 f2be5ef0 f2be6044
[69561.927007]  c1fff780 00000000 c1fff780 f2be6044 04179690 c041e14f c09e3780 f183d500
[69561.927007]  f29fbbf8 f2be5ef0 c07c9010 7fffffff f2b8f400 f1863f40 f2b8f400 c07c9174
[69561.927007] Call Trace:
[69561.927007]  [<c041e14f>] finish_task_switch+0x1f/0x69
[69561.927007]  [<c07c9010>] schedule+0x47c/0x48c
[69561.927007]  [<c07c9174>] schedule_timeout+0x13/0x99
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c05ee885>] n_tty_read+0x3b6/0x64e
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c05ee4cf>] n_tty_read+0x0/0x64e
[69561.927007]  [<c05eb39e>] tty_read+0x6a/0xa4
[69561.927007]  [<c05eb334>] tty_read+0x0/0xa4
[69561.927007]  [<c046b4b6>] vfs_read+0x73/0xa1
[69561.927007]  [<c046b57c>] sys_read+0x3c/0x63
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] rhythmbox     D c09e0564     0  7568      1
[69561.927007]  f2be7a70 00200086 f186dea0 c09e0564 c09e3780 c09e3780 f2be7a70 f2be7bc4
[69561.927007]  c1fff780 00000000 c047139e f2be7bc4 042045e4 c07ca33b f6b28068 f6b28000
[69561.927007]  f5ec6000 c047b23b f5ec6000 f1071b4c f2be7a70 f1071b50 00000002 c07c952d
[69561.927007] Call Trace:
[69561.927007]  [<c047139e>] __link_path_walk+0xf3/0x644
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c047b23b>] mntput_no_expire+0x18/0xe6
[69561.927007]  [<c07c952d>] __mutex_lock_common+0x8f/0xe0
[69561.927007]  [<c07c95d7>] __mutex_lock_slowpath+0xf/0x11
[69561.927007]  [<c07c9476>] mutex_lock+0xa/0xb
[69561.927007]  [<c07c9476>] mutex_lock+0xa/0xb
[69561.927007]  [<c04729da>] do_filp_open+0x139/0x697
[69561.927007]  [<c06788c0>] ehci_work+0xd0/0x60a
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c067c107>] ehci_irq+0x17e/0x19f
[69561.927007]  [<c0479ef6>] alloc_fd+0xc3/0xcd
[69561.927007]  [<c0469717>] do_sys_open+0x3f/0xb2
[69561.927007]  [<c04697ce>] sys_open+0x1e/0x23
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] rhythmbox     S c09e0564     0  7613      1
[69561.927007]  f2be7390 00000086 00000001 c09e0564 c09e3780 c09e3780 f2be7390 f2be74e4
[69561.927007]  c1fff780 00000000 f2be7a9c f2be74e4 c07d2b38 f2be7a70 00000001 c07ca33b
[69561.927007]  c041ce0e f189fe58 c0a1af8c c0a1af8c 00000000 00000000 f189fe7c c043966a
[69561.927007] Call Trace:
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c041ce0e>] try_to_wake_up+0x14c/0x156
[69561.927007]  [<c043966a>] futex_wait+0x13e/0x304
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c043a6fc>] do_futex+0x70/0x714
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c046ab60>] do_sync_write+0x0/0x107
[69561.927007]  [<c043ae8c>] sys_futex+0xec/0x101
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] rhythmbox     S c09e0564     0  7657      1
[69561.927007]  f2aaba70 00000086 c0457aea c09e0564 c09e3780 c09e3780 f2aaba70 f2aabbc4
[69561.927007]  c2007780 00000001 63cb0065 f2aabbc4 00000007 c0458c93 f2abb8d0 f293509c
[69561.927007]  f28c3704 63cb0065 00000246 f2acde00 00000014 f1869e7c f2acde00 c04700e6
[69561.927007] Call Trace:
[69561.927007]  [<c0457aea>] do_wp_page+0x382/0x3eb
[69561.927007]  [<c0458c93>] handle_mm_fault+0x48d/0x4e2
[69561.927007]  [<c04700e6>] pipe_wait+0x50/0x6e
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c04707fd>] pipe_read+0x2c1/0x324
[69561.927007]  [<c0413624>] do_page_fault+0x2c2/0x5c2
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c046ac67>] do_sync_read+0x0/0x107
[69561.927007]  [<c046ac67>] do_sync_read+0x0/0x107
[69561.927007]  [<c046b4b6>] vfs_read+0x73/0xa1
[69561.927007]  [<c046b57c>] sys_read+0x3c/0x63
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] rhythmbox     S c09e0564     0  7771      1
[69561.927007]  f2be7020 00000086 c2004470 c09e0564 c09e3780 c09e3780 f2be7020 f2be7174
[69561.927007]  c2007780 00000001 00000000 f2be7174 000510df f626bf78 00000000 000510df
[69561.927007]  c0433650 000510df 00000000 000510df f626bf78 f626bbf8 000510df c07c96cc
[69561.927007] Call Trace:
[69561.927007]  [<c0433650>] hrtimer_start_expires+0x17/0x1d
[69561.927007]  [<c07c96cc>] schedule_hrtimeout_range+0xc4/0xed
[69561.927007]  [<c04330d4>] hrtimer_wakeup+0x0/0x18
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c0419ccc>] task_rq_lock+0x28/0x4e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c041ce0e>] try_to_wake_up+0x14c/0x156
[69561.927007]  [<c04192ae>] __wake_up_common+0x34/0x59
[69561.927007]  [<c071b80c>] put_cmsg+0x5f/0x8f
[69561.927007]  [<c076a0bc>] scm_recv+0x4f/0x65
[69561.927007]  [<c076b4ca>] unix_stream_recvmsg+0x441/0x460
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c07166e3>] sock_def_readable+0x32/0x5b
[69561.927007]  [<c0714524>] sock_recvmsg+0xc8/0xe3
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c041a6d5>] enqueue_task_fair+0x126/0x178
[69561.927007]  [<c041c79b>] check_preempt_wakeup+0xb2/0xd8
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c041ce0e>] try_to_wake_up+0x14c/0x156
[69561.927007]  [<c0419c29>] __wake_up+0x29/0x39
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0439898>] wake_futex+0x1c/0x26
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c043995d>] futex_wake+0xbb/0xc5
[69561.927007]  [<c043a724>] do_futex+0x98/0x714
[69561.927007]  [<c041d410>] rebalance_domains+0x6d/0x3a2
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c04285de>] run_timer_softirq+0x173/0x17b
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] rhythmbox     S c09e0564     0  7773      1
[69561.927007]  e10f25d0 00000086 f2be4370 c09e0564 c09e3780 c09e3780 e10f25d0 e10f2724
[69561.927007]  c2007780 00000001 c0a1b07c e10f2724 00001610 ca548808 32839500 00003f44
[69561.927007]  1d3d1a08 f6b15e58 c0a1b07c c0a1b07c 00000000 00000000 f6b15e7c c043966a
[69561.927007] Call Trace:
[69561.927007]  [<c043966a>] futex_wait+0x13e/0x304
[69561.927007]  [<c04192ae>] __wake_up_common+0x34/0x59
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c043a6fc>] do_futex+0x70/0x714
[69561.927007]  [<c04378f2>] clockevents_program_event+0xbb/0xc9
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c04285de>] run_timer_softirq+0x173/0x17b
[69561.927007]  [<c043ae8c>] sys_futex+0xec/0x101
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] rhythmbox     S c09e0564     0  7774      1
[69561.927007]  e10f0000 00000086 c041a6d5 c09e0564 c09e3780 c09e3780 e10f0000 e10f0154
[69561.927007]  c1fff780 00000000 e10f0000 e10f0154 c041c79b c07d2b38 f73bca50 00000001
[69561.927007]  c07ca33b f5d1fe58 c0a1b4f0 c0a1b4f0 00000000 00000000 f5d1fe7c c043966a
[69561.927007] Call Trace:
[69561.927007]  [<c041a6d5>] enqueue_task_fair+0x126/0x178
[69561.927007]  [<c041c79b>] check_preempt_wakeup+0xb2/0xd8
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c043966a>] futex_wait+0x13e/0x304
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c0439b71>] futex_requeue+0x20a/0x214
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c043a6fc>] do_futex+0x70/0x714
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c04285de>] run_timer_softirq+0x173/0x17b
[69561.927007]  [<c043ae8c>] sys_futex+0xec/0x101
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] rhythmbox     S c09e0564     0  7777      1
[69561.927007]  f2be4370 00000086 f2be7020 c09e0564 c09e3780 c09e3780 f2be4370 f2be44c4
[69561.927007]  c2007780 00000001 f2be704c f2be44c4 c07d2b38 f2be7020 00000001 00003f44
[69561.927007]  1d3cd83e f5e61e58 c0a1b770 c0a1b770 00000000 00000000 f5e61e7c c043966a
[69561.927007] Call Trace:
[69561.927007]  [<c043966a>] futex_wait+0x13e/0x304
[69561.927007]  [<c04192ae>] __wake_up_common+0x34/0x59
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c043a6fc>] do_futex+0x70/0x714
[69561.927007]  [<c043ae8c>] sys_futex+0xec/0x101
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] rhythmbox     S c09e0564     0  8101      1
[69561.927007]  f2be6940 00200086 c041a6d5 c09e0564 c09e3780 c09e3780 f2be6940 f2be6a94
[69561.927007]  c2007780 00000001 c1fff7d8 f2be6a94 f2be7a70 fdcb5187 00000000 c041a6d5
[69561.927007]  00000001 f1969e58 c0a1afb4 c0a1afb4 00000000 00000000 f1969e7c c043966a
[69561.927007] Call Trace:
[69561.927007]  [<c041a6d5>] enqueue_task_fair+0x126/0x178
[69561.927007]  [<c041a6d5>] enqueue_task_fair+0x126/0x178
[69561.927007]  [<c043966a>] futex_wait+0x13e/0x304
[69561.927007]  [<c0419c29>] __wake_up+0x29/0x39
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0439898>] wake_futex+0x1c/0x26
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c043a6fc>] do_futex+0x70/0x714
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c040f2af>] lapic_next_event+0x10/0x13
[69561.927007]  [<c04378f2>] clockevents_program_event+0xbb/0xc9
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c04285de>] run_timer_softirq+0x173/0x17b
[69561.927007]  [<c043ae8c>] sys_futex+0xec/0x101
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] rhythmbox     S c09e0564     0  8102      1
[69561.927007]  f1afcdc0 00200086 e10f0000 c09e0564 c09e3780 c09e3780 f1afcdc0 f1afcf14
[69561.927007]  c1fff780 00000000 00000003 f1afcf14 041e66ee e127a420 00000001 00000001
[69561.927007]  c04192ae f1bd1e58 c0a1ac1c c0a1ac1c 00000000 00000000 f1bd1e7c c043966a
[69561.927007] Call Trace:
[69561.927007]  [<c04192ae>] __wake_up_common+0x34/0x59
[69561.927007]  [<c043966a>] futex_wait+0x13e/0x304
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c043a6fc>] do_futex+0x70/0x714
[69561.927007]  [<c046da43>] sys_fstat64+0x1e/0x23
[69561.927007]  [<c043ae8c>] sys_futex+0xec/0x101
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] rhythmbox     S c09e0564     0  8153      1
[69561.927007]  f73bca50 00200086 e10f0000 c09e0564 c09e3780 c09e3780 f73bca50 f73bcba4
[69561.927007]  c1fff780 00000000 f73bca50 f73bcba4 c041c79b c07d2b38 e10f0000 00000001
[69561.927007]  c07ca33b f6b77e58 c0a1a640 c0a1a640 00000000 00000000 f6b77e7c c043966a
[69561.927007] Call Trace:
[69561.927007]  [<c041c79b>] check_preempt_wakeup+0xb2/0xd8
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c043966a>] futex_wait+0x13e/0x304
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c0439b71>] futex_requeue+0x20a/0x214
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c043a6fc>] do_futex+0x70/0x714
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c040f2af>] lapic_next_event+0x10/0x13
[69561.927007]  [<c04378f2>] clockevents_program_event+0xbb/0xc9
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c04285de>] run_timer_softirq+0x173/0x17b
[69561.927007]  [<c043ae8c>] sys_futex+0xec/0x101
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] rhythmbox     S c09e0564     0  8154      1
[69561.927007]  f50b6cb0 00200086 f73bca50 c09e0564 c09e3780 c09e3780 f50b6cb0 f50b6e04
[69561.927007]  c1fff780 00000000 c1fff7d8 f50b6e04 0420d9bd fdcb925d 00000000 c041a6d5
[69561.927007]  00000001 f1b13e58 c0a1a820 c0a1a820 00000000 00000000 f1b13e7c c043966a
[69561.927007] Call Trace:
[69561.927007]  [<c041a6d5>] enqueue_task_fair+0x126/0x178
[69561.927007]  [<c043966a>] futex_wait+0x13e/0x304
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0678573>] qh_completions+0xae/0x32b
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c043a6fc>] do_futex+0x70/0x714
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c040f2af>] lapic_next_event+0x10/0x13
[69561.927007]  [<c04378f2>] clockevents_program_event+0xbb/0xc9
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c04285de>] run_timer_softirq+0x173/0x17b
[69561.927007]  [<c043ae8c>] sys_futex+0xec/0x101
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] rhythmbox     D c09e0564     0  8157      1
[69561.927007]  f5d43a70 00200086 c1cdd4a0 c09e0564 c09e3780 c09e3780 f5d43a70 f5d43bc4
[69561.927007]  c1fff780 00000000 f6bffe60 f5d43bc4 00000000 c04bdd4f f6bffec4 f6c3da1c
[69561.927007]  f1071ad4 00000010 00200246 f1b25200 f613c000 f6bffe88 f613c000 c04d7a65
[69561.927007] Call Trace:
[69561.927007]  [<c04bdd4f>] ext4_find_entry+0x450/0x4bd
[69561.927007]  [<c04d7a65>] start_this_handle+0x29f/0x343
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c04d7c41>] jbd2_journal_start+0x83/0xaf
[69561.927007]  [<c04be326>] ext4_create+0x44/0xde
[69561.927007]  [<c04be2e2>] ext4_create+0x0/0xde
[69561.927007]  [<c0472170>] vfs_create+0x3d/0x5b
[69561.927007]  [<c0472a98>] do_filp_open+0x1f7/0x697
[69561.927007]  [<c04682c2>] kmem_cache_alloc+0x43/0x76
[69561.927007]  [<c0479ef6>] alloc_fd+0xc3/0xcd
[69561.927007]  [<c0469717>] do_sys_open+0x3f/0xb2
[69561.927007]  [<c04697ce>] sys_open+0x1e/0x23
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] gvfsd-http    S c09e0564     0  7677      1
[69561.927007]  f2aa8370 00000086 f2be7a70 c09e0564 c09e3780 c09e3780 f2aa8370 f2aa84c4
[69561.927007]  c1fff780 00000000 0000000c f2aa84c4 c09e05a0 c04254b8 c09e3680 c09e3680
[69561.927007]  0000000a 00000000 00000046 00000000 00000000 f1999e98 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c04254b8>] __do_softirq+0x83/0x11e
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c0405130>] do_IRQ+0x6e/0x7e
[69561.927007]  [<c07276df>] sk_run_filter+0x396/0x4fa
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0769c0b>] unix_poll+0x14/0x86
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c073cca9>] ip_local_out+0x15/0x17
[69561.927007]  [<c073d446>] ip_queue_xmit+0x2e1/0x33f
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c062a36f>] skge_poll+0x612/0x61e
[69561.927007]  [<c071ced8>] net_rx_action+0x163/0x1b5
[69561.927007]  [<c04254b8>] __do_softirq+0x83/0x11e
[69561.927007]  [<c0419ccc>] task_rq_lock+0x28/0x4e
[69561.927007]  [<c07169a0>] sock_alloc_send_skb+0x89/0x1ca
[69561.927007]  [<c0719ce3>] __alloc_skb+0x49/0xf6
[69561.927007]  [<c076a086>] scm_recv+0x19/0x65
[69561.927007]  [<c076b4ca>] unix_stream_recvmsg+0x441/0x460
[69561.927007]  [<c04257cc>] _local_bh_enable_ip+0x86/0x90
[69561.927007]  [<c0713a4d>] sock_aio_read+0xec/0xfa
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0419c29>] __wake_up+0x29/0x39
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c047b23b>] mntput_no_expire+0x18/0xe6
[69561.927007]  [<c046ba9a>] __fput+0x10b/0x12e
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] gkrellm       D c09e0564     0  8421      1
[69561.927007]  f50b7a70 00200086 f5f60800 c09e0564 c09e3780 c09e3780 f50b7a70 f50b7bc4
[69561.927007]  c2007780 00000001 00000002 f50b7bc4 041d9812 00000000 ca548f00 f5f60800
[69561.927007]  c04b4f3c 59821055 00200246 f1b25200 f613c000 f1a87f1c f613c000 c04d7a65
[69561.927007] Call Trace:
[69561.927007]  [<c04b4f3c>] call_filldir+0x98/0xc5
[69561.927007]  [<c04d7a65>] start_this_handle+0x29f/0x343
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c04d7c41>] jbd2_journal_start+0x83/0xaf
[69561.927007]  [<c04b80ce>] ext4_dirty_inode+0x21/0x63
[69561.927007]  [<c047f76f>] __mark_inode_dirty+0x21/0x13e
[69561.927007]  [<c0478481>] touch_atime+0xb1/0xb6
[69561.927007]  [<c0474c63>] vfs_readdir+0x63/0x7a
[69561.927007]  [<c04749d8>] filldir64+0x0/0xc5
[69561.927007]  [<c0474ce0>] sys_getdents64+0x66/0xa5
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] desktop_auto_ S c09e0564     0  8423      1
[69561.927007]  f50b7020 00000082 f1afac40 c09e0564 c09e3780 c09e3780 f50b7020 f50b7174
[69561.927007]  c1fff780 00000000 00000056 f50b7174 000116b1 00000000 f50b7020 00000004
[69561.927007]  c0423a13 f5fc1f6c 00000003 f50b7018 00000000 f50b7020 00000004 c0423b04
[69561.927007] Call Trace:
[69561.927007]  [<c0423a13>] do_wait+0xd3/0x2ae
[69561.927007]  [<c0423b04>] do_wait+0x1c4/0x2ae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c0423c6f>] sys_wait4+0x81/0x94
[69561.927007]  [<c0423c95>] sys_waitpid+0x13/0x17
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] run-mozilla.s S c09e0564     0  8472   8423
[69561.927007]  f29925d0 00000082 00000001 c09e0564 c09e3780 c09e3780 f29925d0 f2992724
[69561.927007]  c2007780 00000001 f2be7700 f2992724 000116ff 00000000 f29925d0 00000004
[69561.927007]  c0423a13 f1b73f6c 00000003 f29925c8 00000000 f29925d0 00000004 c0423b04
[69561.927007] Call Trace:
[69561.927007]  [<c0423a13>] do_wait+0xd3/0x2ae
[69561.927007]  [<c0423b04>] do_wait+0x1c4/0x2ae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c0423c6f>] sys_wait4+0x81/0x94
[69561.927007]  [<c0423c95>] sys_waitpid+0x13/0x17
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] firefox       D c09e0564     0  8488   8472
[69561.927007]  f2be7700 00000086 c20077bc c09e0564 c09e3780 c09e3780 f2be7700 f2be7854
[69561.927007]  c2007780 00000001 c09e3780 f2be7854 041e49e1 f2be7700 c07c9010 f70314a0
[69561.927007]  c09e0564 c09e3780 00000246 f1b25200 f613c000 f1a59e1c f613c000 c04d7a65
[69561.927007] Call Trace:
[69561.927007]  [<c07c9010>] schedule+0x47c/0x48c
[69561.927007]  [<c04d7a65>] start_this_handle+0x29f/0x343
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c04d7c41>] jbd2_journal_start+0x83/0xaf
[69561.927007]  [<c04b80ce>] ext4_dirty_inode+0x21/0x63
[69561.927007]  [<c047f76f>] __mark_inode_dirty+0x21/0x13e
[69561.927007]  [<c0478481>] touch_atime+0xb1/0xb6
[69561.927007]  [<c044ccf4>] generic_file_aio_read+0x52f/0x578
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c046d503>] cp_new_stat64+0xf7/0x109
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c046da43>] sys_fstat64+0x1e/0x23
[69561.927007]  [<c046ac67>] do_sync_read+0x0/0x107
[69561.927007]  [<c046b4b6>] vfs_read+0x73/0xa1
[69561.927007]  [<c046b57c>] sys_read+0x3c/0x63
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] firefox       S c09e0564     0  8504   8472
[69561.927007]  f2aab390 00000086 f2be7700 c09e0564 c09e3780 c09e3780 f2aab390 f2aab4e4
[69561.927007]  c2007780 00000001 00000101 f2aab4e4 041e133f 00000001 c04254b8 c09e3680
[69561.927007]  c09e3680 0000000a 00000000 00000000 00000000 f1ad1e88 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c04254b8>] __do_softirq+0x83/0x11e
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c0425719>] irq_exit+0x50/0x7d
[69561.927007]  [<c040f980>] smp_apic_timer_interrupt+0x6e/0x78
[69561.927007]  [<c0403c0c>] apic_timer_interrupt+0x28/0x30
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c046f8dc>] pipe_poll+0x24/0x7c
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c071ced8>] net_rx_action+0x163/0x1b5
[69561.927007]  [<c04254b8>] __do_softirq+0x83/0x11e
[69561.927007]  [<c07276df>] sk_run_filter+0x396/0x4fa
[69561.927007]  [<c04257cc>] _local_bh_enable_ip+0x86/0x90
[69561.927007]  [<c07651f7>] ipt_do_table+0x2ba/0x2d7
[69561.927007]  [<c04257cc>] _local_bh_enable_ip+0x86/0x90
[69561.927007]  [<c07651f7>] ipt_do_table+0x2ba/0x2d7
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c062a726>] skge_xmit_frame+0xd8/0x2c5
[69561.927007]  [<c041a473>] dequeue_task_fair+0x33/0x16f
[69561.927007]  [<c0419d1b>] set_next_entity+0x29/0x4e
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c041e14f>] finish_task_switch+0x1f/0x69
[69561.927007]  [<c07c9010>] schedule+0x47c/0x48c
[69561.927007]  [<c073cca9>] ip_local_out+0x15/0x17
[69561.927007]  [<c073d446>] ip_queue_xmit+0x2e1/0x33f
[69561.927007]  [<c0439793>] futex_wait+0x267/0x304
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c047bc98>] mnt_drop_write+0x64/0xd8
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c04787de>] destroy_inode+0x24/0x33
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0468276>] kmem_cache_free+0x49/0x52
[69561.927007]  [<c04787de>] destroy_inode+0x24/0x33
[69561.927007]  [<c046ac67>] do_sync_read+0x0/0x107
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] firefox       S c09e0564     0  8505   8472
[69561.927007]  f50b3a70 00000086 f290dbc4 c09e0564 c09e3780 c09e3780 f50b3a70 f50b3bc4
[69561.927007]  c2007780 00000001 c0433624 f50b3bc4 041ebf4d 00000000 00000282 00003f63
[69561.927007]  f1b65e94 00000000 f1b65e7c 00003f63 f1b65e94 00000000 f1b65e7c c043970d
[69561.927007] Call Trace:
[69561.927007]  [<c0433624>] hrtimer_start_range_ns+0x125/0x13a
[69561.927007]  [<c043970d>] futex_wait+0x1e1/0x304
[69561.927007]  [<c04330d4>] hrtimer_wakeup+0x0/0x18
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c043a6fc>] do_futex+0x70/0x714
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c04337f1>] ktime_get_ts+0x1d/0x3f
[69561.927007]  [<c043ae8c>] sys_futex+0xec/0x101
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] firefox       S c09e0564     0  8514   8472
[69561.927007]  f2aa8a50 00000086 00000001 c09e0564 c09e3780 c09e3780 f2aa8a50 f2aa8ba4
[69561.927007]  c2007780 00000001 f2aab3bc f2aa8ba4 c07d2b38 f2aab390 00000001 c07ca33b
[69561.927007]  c041ce0e f1b7de58 c0a1b8b0 c0a1b8b0 00000000 00000000 f1b7de7c c043966a
[69561.927007] Call Trace:
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c041ce0e>] try_to_wake_up+0x14c/0x156
[69561.927007]  [<c043966a>] futex_wait+0x13e/0x304
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c043a6fc>] do_futex+0x70/0x714
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c046ab60>] do_sync_write+0x0/0x107
[69561.927007]  [<c043ae8c>] sys_futex+0xec/0x101
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] firefox       S c09e0564     0  8515   8472
[69561.927007]  f2aa9ef0 00000086 00000000 c09e0564 c09e3780 c09e3780 f2aa9ef0 f2aaa044
[69561.927007]  c2007780 00000001 00000077 f2aaa044 00016cca 00000000 00000000 00000000
[69561.927007]  00000019 f1aa3e58 c0a1b400 c0a1b400 00000000 00000000 f1aa3e7c c043966a
[69561.927007] Call Trace:
[69561.927007]  [<c043966a>] futex_wait+0x13e/0x304
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c043a6fc>] do_futex+0x70/0x714
[69561.927007]  [<c043ae8c>] sys_futex+0xec/0x101
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] firefox       S c09e0564     0  8516   8472
[69561.927007]  f2aaa940 00000086 f2be7700 c09e0564 c09e3780 c09e3780 f2aaa940 f2aaaa94
[69561.927007]  c2007780 00000001 f2be772c f2aaaa94 c07d2b38 f2be7700 00000001 c07ca33b
[69561.927007]  c041ce0e f1a07e58 c0a1b98c c0a1b98c 00000000 00000000 f1a07e7c c043966a
[69561.927007] Call Trace:
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c041ce0e>] try_to_wake_up+0x14c/0x156
[69561.927007]  [<c043966a>] futex_wait+0x13e/0x304
[69561.927007]  [<c07ca28c>] _write_unlock_irq+0x1c/0x26
[69561.927007]  [<c0473970>] fasync_helper+0xb0/0xb9
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c043a6fc>] do_futex+0x70/0x714
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c046ab60>] do_sync_write+0x0/0x107
[69561.927007]  [<c043ae8c>] sys_futex+0xec/0x101
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] firefox       S c09e0564     0  8520   8472
[69561.927007]  f2be4dc0 00000086 f2be7734 c09e0564 c09e3780 c09e3780 f2be4dc0 f2be4f14
[69561.927007]  c2007780 00000001 c07ca319 f2be4f14 000194d2 f1afa1c0 f1a59ed0 f2be4dc0
[69561.927007]  c07c9010 f1b6de58 c0a1b70c c0a1b70c 00000000 00000000 f1b6de7c c043966a
[69561.927007] Call Trace:
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c07c9010>] schedule+0x47c/0x48c
[69561.927007]  [<c043966a>] futex_wait+0x13e/0x304
[69561.927007]  [<c04768df>] dput+0x8f/0xfc
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c043a6fc>] do_futex+0x70/0x714
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c046ab60>] do_sync_write+0x0/0x107
[69561.927007]  [<c043ae8c>] sys_futex+0xec/0x101
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] notification- S c09e0564     0 10017      1
[69561.927007]  f50b4dc0 00000086 f50b5130 c09e0564 c09e3780 c09e3780 f50b4dc0 f50b4f14
[69561.927007]  c1fff780 00000000 00000008 f50b4f14 f5c3f480 00000001 c0475a10 00000020
[69561.927007]  00000000 e11e7f64 00000001 00000000 00000000 e11e7ec0 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c0475a10>] do_select+0x416/0x429
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0769c0b>] unix_poll+0x14/0x86
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041a6d5>] enqueue_task_fair+0x126/0x178
[69561.927007]  [<c041c79b>] check_preempt_wakeup+0xb2/0xd8
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c041ce0e>] try_to_wake_up+0x14c/0x156
[69561.927007]  [<c04192ae>] __wake_up_common+0x34/0x59
[69561.927007]  [<c04664d9>] add_partial+0xe/0x44
[69561.927007]  [<c0467158>] __slab_free+0xdf/0x31d
[69561.927007]  [<c0719469>] __kfree_skb+0xf/0x6a
[69561.927007]  [<c0468162>] kfree+0x76/0x7f
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c076a086>] scm_recv+0x19/0x65
[69561.927007]  [<c076b4ca>] unix_stream_recvmsg+0x441/0x460
[69561.927007]  [<c04192ae>] __wake_up_common+0x34/0x59
[69561.927007]  [<c0713a4d>] sock_aio_read+0xec/0xfa
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] bash          S c09e0564     0 12518   7516
[69561.927007]  f2be4000 00200086 00000000 c09e0564 c09e3780 c09e3780 f2be4000 f2be4154
[69561.927007]  c2007780 00000001 c2007780 f2be4154 00d7efea c041e14f c09e3780 f183d500
[69561.927007]  f29fbbf8 f2be4000 c07c9010 7fffffff f1a44400 e7bfdf40 f1a44400 c07c9174
[69561.927007] Call Trace:
[69561.927007]  [<c041e14f>] finish_task_switch+0x1f/0x69
[69561.927007]  [<c07c9010>] schedule+0x47c/0x48c
[69561.927007]  [<c07c9174>] schedule_timeout+0x13/0x99
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c05ee885>] n_tty_read+0x3b6/0x64e
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c05ee4cf>] n_tty_read+0x0/0x64e
[69561.927007]  [<c05eb39e>] tty_read+0x6a/0xa4
[69561.927007]  [<c05eb334>] tty_read+0x0/0xa4
[69561.927007]  [<c046b4b6>] vfs_read+0x73/0xa1
[69561.927007]  [<c046b57c>] sys_read+0x3c/0x63
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] bash          S c09e0564     0 13523   7516
[69561.927007]  f50b6940 00200082 f50ac800 c09e0564 c09e3780 c09e3780 f50b6940 f50b6a94
[69561.927007]  c1fff780 00000000 f50ac800 f50b6a94 001c35df 00000000 f50b6940 0000000e
[69561.927007]  c0423a13 de685f6c 00000003 f50b6938 00000000 f50b6940 0000000e c0423b04
[69561.927007] Call Trace:
[69561.927007]  [<c0423a13>] do_wait+0xd3/0x2ae
[69561.927007]  [<c0423b04>] do_wait+0x1c4/0x2ae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c0423c6f>] sys_wait4+0x81/0x94
[69561.927007]  [<c0423c95>] sys_waitpid+0x13/0x17
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] ssh           S c09e0564     0 13568  13523
[69561.927007]  f2be5810 00000086 c1ffc470 c09e0564 c09e3780 c09e3780 f2be5810 f2be5964
[69561.927007]  c1fff780 00000000 00000000 f2be5964 0420ce1c e6b89e3c 00000000 0098967f
[69561.927007]  c0433650 0098967f 00000000 0098967f e6b89e3c e6b89b84 0098967f c07c96cc
[69561.927007] Call Trace:
[69561.927007]  [<c0433650>] hrtimer_start_expires+0x17/0x1d
[69561.927007]  [<c07c96cc>] schedule_hrtimeout_range+0xc4/0xed
[69561.927007]  [<c04330d4>] hrtimer_wakeup+0x0/0x18
[69561.927007]  [<c04759e0>] do_select+0x3e6/0x429
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c071e5cb>] dev_hard_start_xmit+0x1e1/0x24e
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c072b074>] __qdisc_run+0x110/0x1e0
[69561.927007]  [<c04257cc>] _local_bh_enable_ip+0x86/0x90
[69561.927007]  [<c071eb1c>] dev_queue_xmit+0x406/0x438
[69561.927007]  [<c073d76c>] ip_finish_output2+0x192/0x1ca
[69561.927007]  [<c073cca9>] ip_local_out+0x15/0x17
[69561.927007]  [<c073d446>] ip_queue_xmit+0x2e1/0x33f
[69561.927007]  [<c0428a9a>] lock_timer_base+0x19/0x35
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0428beb>] __mod_timer+0x8e/0x97
[69561.927007]  [<c0716731>] sk_reset_timer+0xc/0x16
[69561.927007]  [<c074a852>] tcp_event_new_data_sent+0x63/0x68
[69561.927007]  [<c074d1df>] __tcp_push_pending_frames+0x69a/0x76d
[69561.927007]  [<c071a7a3>] memcpy_toiovec+0x25/0x47
[69561.927007]  [<c071adbc>] skb_copy_datagram_iovec+0x3f/0x17c
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c07ca1c2>] _spin_lock_bh+0x8/0x28
[69561.927007]  [<c0716350>] release_sock+0x10/0x88
[69561.927007]  [<c04257cc>] _local_bh_enable_ip+0x86/0x90
[69561.927007]  [<c0742cce>] tcp_recvmsg+0x68e/0x78c
[69561.927007]  [<c0475b82>] core_sys_select+0x15f/0x1eb
[69561.927007]  [<c0413624>] do_page_fault+0x2c2/0x5c2
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c0475dd1>] sys_select+0x6e/0x8f
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] scsi_eh_7     S c09e0564     0 14346      2
[69561.927007]  f2993390 00000046 f1aff72c c09e0564 c09e3780 c09e3780 f2993390 f29934e4
[69561.927007]  c2007780 00000001 c041e14f f29934e4 f1afa700 00000040 f2993390 c07c9010
[69561.927007]  f1aff700 c09e0564 c09e3780 e127a000 e127a000 00000000 00000000 c0639c6f
[69561.927007] Call Trace:
[69561.927007]  [<c041e14f>] finish_task_switch+0x1f/0x69
[69561.927007]  [<c07c9010>] schedule+0x47c/0x48c
[69561.927007]  [<c0639c6f>] scsi_error_handler+0x40/0x293
[69561.927007]  [<c0419bb4>] complete+0x28/0x36
[69561.927007]  [<c0639c2f>] scsi_error_handler+0x0/0x293
[69561.927007]  [<c04308ad>] kthread+0x38/0x5d
[69561.927007]  [<c0430875>] kthread+0x0/0x5d
[69561.927007]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69561.927007] usb-storage   S c09e0564     0 14347      2
[69561.927007]  f1aff020 00000046 c066bbd2 c09e0564 c09e3780 c09e3780 f1aff020 f1aff174
[69561.927007]  c1fff780 00000000 c16c0aa0 f1aff174 0420da5d 7fffffff c8f55e90 e127a428
[69561.927007]  c07c9174 00000286 c0988f94 00000010 c04686e5 f6215f64 00000286 00000080
[69561.927007] Call Trace:
[69561.927007]  [<c07c9010>] schedule+0x47c/0x48c
[69561.927007]  [<c0466c2c>] unfreeze_slab+0x7a/0xed
[69561.927007]  [<c0467cc5>] __slab_alloc+0xda/0x501
[69561.927007]  [<c07c9174>] schedule_timeout+0x13/0x99
[69561.927007]  [<c04686e5>] __kmalloc+0x72/0xa5
[69561.927007]  [<c07c8ae6>] wait_for_common+0x90/0xe1
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c066ca01>] usb_sg_wait+0xee/0xfb
[69561.927007]  [<c06833d7>] usb_stor_bulk_transfer_sglist+0x8b/0xcf
[69561.927007]  [<c0683487>] usb_stor_bulk_srb+0x18/0x28
[69561.927007]  [<c068359a>] usb_stor_Bulk_transport+0x103/0x23b
[69561.927007]  [<c068318b>] usb_stor_invoke_transport+0x15/0x1d6
[69561.927007]  [<c07c9174>] schedule_timeout+0x13/0x99
[69561.927007]  [<c041c79b>] check_preempt_wakeup+0xb2/0xd8
[69561.927007]  [<c041eb1e>] signal_pending_state+0x17/0x3b
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c07c8b2d>] wait_for_common+0xd7/0xe1
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c0684585>] usb_stor_control_thread+0x11e/0x1b1
[69561.927007]  [<c0419bb4>] complete+0x28/0x36
[69561.927007]  [<c0684467>] usb_stor_control_thread+0x0/0x1b1
[69561.927007]  [<c04308ad>] kthread+0x38/0x5d
[69561.927007]  [<c0430875>] kthread+0x0/0x5d
[69561.927007]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69561.927007] hald-addon-st S c09e0564     0 14396   6457
[69561.927007]  f1aff390 00000086 c2004470 c09e0564 c09e3780 c09e3780 f1aff390 f1aff4e4
[69561.927007]  c2007780 00000001 00000000 f1aff4e4 001d2107 e81edf78 00000000 001d2107
[69561.927007]  c0433650 001d2107 00000000 001d2107 e81edf78 e81edbf8 001d2107 c07c96cc
[69561.927007] Call Trace:
[69561.927007]  [<c0433650>] hrtimer_start_expires+0x17/0x1d
[69561.927007]  [<c07c96cc>] schedule_hrtimeout_range+0xc4/0xed
[69561.927007]  [<c04330d4>] hrtimer_wakeup+0x0/0x18
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c07c9010>] schedule+0x47c/0x48c
[69561.927007]  [<c07c9174>] schedule_timeout+0x13/0x99
[69561.927007]  [<c063ae08>] scsi_request_fn+0x336/0x3db
[69561.927007]  [<c0428b57>] del_timer+0x43/0x49
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c07c8b2d>] wait_for_common+0xd7/0xe1
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c059f953>] blk_execute_rq+0x82/0x9b
[69561.927007]  [<c059f838>] blk_end_sync_rq+0x0/0x23
[69561.927007]  [<c044d391>] mempool_alloc+0x27/0xcb
[69561.927007]  [<c04664d9>] add_partial+0xe/0x44
[69561.927007]  [<c0467158>] __slab_free+0xdf/0x31d
[69561.927007]  [<c059d2d3>] get_request+0x1a2/0x221
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c059cc43>] __freed_request+0x1d/0x6d
[69561.927007]  [<c059ccad>] freed_request+0x1a/0x32
[69561.927007]  [<c059cfbf>] blk_put_request+0x1e/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c063bed4>] scsi_execute+0x10e/0x116
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c063bf50>] scsi_execute_req+0x74/0x7d
[69561.927007]  [<c063bfa7>] scsi_test_unit_ready+0x4e/0xca
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c06404aa>] sd_media_changed+0xf5/0xfc
[69561.927007]  [<c0486b07>] check_disk_change+0x16/0x3e
[69561.927007]  [<c064032c>] sd_open+0x5d/0xde
[69561.927007]  [<c048743c>] blkdev_open+0x0/0x88
[69561.927007]  [<c0487499>] blkdev_open+0x5d/0x88
[69561.927007]  [<c046992f>] __dentry_open+0x146/0x20f
[69561.927007]  [<c0469a75>] nameidata_to_filp+0x1c/0x2c
[69561.927007]  [<c0472c1d>] do_filp_open+0x37c/0x697
[69561.927007]  [<c063b1cb>] scsi_end_request+0x6d/0x77
[69561.927007]  [<c063b912>] scsi_device_unbusy+0x64/0x7b
[69561.927007]  [<c063fc8b>] scsi_disk_put+0x22/0x2e
[69561.927007]  [<c04784a7>] iput+0x21/0x4a
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] kjournald     D c09e0564     0 14401      2
[69561.927007]  f2be5130 00000046 00000000 c09e0564 c09e3780 c09e3780 f2be5130 f2be5284
[69561.927007]  c2007780 00000001 c20077bc f2be5284 c0418b50 00003f44 f73f9460 00000001
[69561.927007]  c059b201 f73f9460 c059d1b4 c2007780 c2007b70 c50a7e54 f73f9494 c07c9041
[69561.927007] Call Trace:
[69561.927007]  [<c0418b50>] update_curr+0x5f/0x13f
[69561.927007]  [<c059b201>] elv_may_queue+0x15/0x17
[69561.927007]  [<c059d1b4>] get_request+0x83/0x221
[69561.927007]  [<c07c9041>] io_schedule+0x21/0x2b
[69561.927007]  [<c059d84f>] get_request_wait+0x8c/0x105
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c059dc2c>] __make_request+0x285/0x36c
[69561.927007]  [<c0467cc5>] __slab_alloc+0xda/0x501
[69561.927007]  [<c059cb1a>] generic_make_request+0x18a/0x1c0
[69561.927007]  [<c044d391>] mempool_alloc+0x27/0xcb
[69561.927007]  [<c044d391>] mempool_alloc+0x27/0xcb
[69561.927007]  [<c059cbce>] submit_bio+0x7e/0x85
[69561.927007]  [<c048583c>] bio_alloc_bioset+0x79/0xc2
[69561.927007]  [<c0482769>] submit_bh+0xdb/0xf7
[69561.927007]  [<c04d2c90>] journal_commit_transaction+0x354/0xcb8
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0428afa>] try_to_del_timer_sync+0x44/0x4a
[69561.927007]  [<c04d5c60>] kjournald+0xbf/0x1f7
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c04d5ba1>] kjournald+0x0/0x1f7
[69561.927007]  [<c04308ad>] kthread+0x38/0x5d
[69561.927007]  [<c0430875>] kthread+0x0/0x5d
[69561.927007]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69561.927007] bash          S c09e0564     0 25329   7516
[69561.927007]  e10f0a50 00200082 e10f0a50 c09e0564 c09e3780 c09e3780 e10f0a50 e10f0ba4
[69561.927007]  c2007780 00000001 cad3b880 e10f0ba4 00009600 c05ee0b4 f6030400 bfcc6638
[69561.927007]  f199d800 00000003 c092eadc 7fffffff f199d800 f6beff40 f199d800 c07c9174
[69561.927007] Call Trace:
[69561.927007]  [<c05ee0b4>] n_tty_ioctl+0x0/0xa5
[69561.927007]  [<c07c9174>] schedule_timeout+0x13/0x99
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c05ee885>] n_tty_read+0x3b6/0x64e
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c05ee4cf>] n_tty_read+0x0/0x64e
[69561.927007]  [<c05eb39e>] tty_read+0x6a/0xa4
[69561.927007]  [<c05eb334>] tty_read+0x0/0xa4
[69561.927007]  [<c046b4b6>] vfs_read+0x73/0xa1
[69561.927007]  [<c046b57c>] sys_read+0x3c/0x63
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] bash          S c09e0564     0 16314   7516
[69561.927007]  f1afca50 00200082 f19aa800 c09e0564 c09e3780 c09e3780 f1afca50 f1afcba4
[69561.927007]  c1fff780 00000000 f19aa800 f1afcba4 04039076 00000000 f1afca50 0000000e
[69561.927007]  c0423a13 f198ff6c 00000003 f1afca48 00000000 f1afca50 0000000e c0423b04
[69561.927007] Call Trace:
[69561.927007]  [<c0423a13>] do_wait+0xd3/0x2ae
[69561.927007]  [<c0423b04>] do_wait+0x1c4/0x2ae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c0423c6f>] sys_wait4+0x81/0x94
[69561.927007]  [<c0423c95>] sys_waitpid+0x13/0x17
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] pickup        S c09e0564     0  3021   6857
[69561.927007]  e10f3390 00200082 f5e186e0 c09e0564 c09e3780 c09e3780 e10f3390 e10f34e4
[69561.927007]  c2007780 00000001 00200286 e10f34e4 f5f13f30 04224f8a f5f13f30 c07ca33b
[69561.927007]  c0428beb 04224f8a 00200286 04224f8a 04224f8a f1a10a40 00200246 c07c91df
[69561.927007] Call Trace:
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0428beb>] __mod_timer+0x8e/0x97
[69561.927007]  [<c07c91df>] schedule_timeout+0x7e/0x99
[69561.927007]  [<c042877e>] process_timeout+0x0/0x5
[69561.927007]  [<c048b89b>] sys_epoll_wait+0x18f/0x3f4
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] ssh           S c09e0564     0  7589  16314
[69561.927007]  f1afecb0 00000086 c1ffc470 c09e0564 c09e3780 c09e3780 f1afecb0 f1afee04
[69561.927007]  c1fff780 00000000 00000000 f1afee04 0420d379 f1ac1e3c 00000000 0098967f
[69561.927007]  c0433650 0098967f 00000000 0098967f f1ac1e3c f1ac1b84 0098967f c07c96cc
[69561.927007] Call Trace:
[69561.927007]  [<c0433650>] hrtimer_start_expires+0x17/0x1d
[69561.927007]  [<c07c96cc>] schedule_hrtimeout_range+0xc4/0xed
[69561.927007]  [<c04330d4>] hrtimer_wakeup+0x0/0x18
[69561.927007]  [<c04759e0>] do_select+0x3e6/0x429
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c071e5cb>] dev_hard_start_xmit+0x1e1/0x24e
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c072b074>] __qdisc_run+0x110/0x1e0
[69561.927007]  [<c04257cc>] _local_bh_enable_ip+0x86/0x90
[69561.927007]  [<c071eb1c>] dev_queue_xmit+0x406/0x438
[69561.927007]  [<c073d76c>] ip_finish_output2+0x192/0x1ca
[69561.927007]  [<c073cca9>] ip_local_out+0x15/0x17
[69561.927007]  [<c073d446>] ip_queue_xmit+0x2e1/0x33f
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c0428a9a>] lock_timer_base+0x19/0x35
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0428beb>] __mod_timer+0x8e/0x97
[69561.927007]  [<c0716731>] sk_reset_timer+0xc/0x16
[69561.927007]  [<c074a852>] tcp_event_new_data_sent+0x63/0x68
[69561.927007]  [<c074d1df>] __tcp_push_pending_frames+0x69a/0x76d
[69561.927007]  [<c04664d9>] add_partial+0xe/0x44
[69561.927007]  [<c0467158>] __slab_free+0xdf/0x31d
[69561.927007]  [<c0742bd1>] tcp_recvmsg+0x591/0x78c
[69561.927007]  [<c07ca1c2>] _spin_lock_bh+0x8/0x28
[69561.927007]  [<c0716350>] release_sock+0x10/0x88
[69561.927007]  [<c04257cc>] _local_bh_enable_ip+0x86/0x90
[69561.927007]  [<c0742cce>] tcp_recvmsg+0x68e/0x78c
[69561.927007]  [<c0475b82>] core_sys_select+0x15f/0x1eb
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0629dca>] skge_poll+0x6d/0x61e
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c0475dd1>] sys_select+0x6e/0x8f
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] pidgin        S c09e0564     0  7592      1
[69561.927007]  f1afd810 00200086 00003f29 c09e0564 c09e3780 c09e3780 f1afd810 f1afd964
[69561.927007]  c2007780 00000001 c2007780 f1afd964 041f2074 c041a473 c2007780 39adbf34
[69561.927007]  00001a64 c07d2b38 00000000 00800000 00000000 f60c9e00 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c041a473>] dequeue_task_fair+0x33/0x16f
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c041e14f>] finish_task_switch+0x1f/0x69
[69561.927007]  [<c07c9010>] schedule+0x47c/0x48c
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c046f8dc>] pipe_poll+0x24/0x7c
[69561.927007]  [<c04759e0>] do_select+0x3e6/0x429
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c0482e39>] __getblk+0x13/0x1e4
[69561.927007]  [<c04852d3>] __bread+0x11/0x66
[69561.927007]  [<c04a805a>] ext3_get_branch+0x5b/0xc1
[69561.927007]  [<c04a8cc8>] ext3_get_blocks_handle+0x89/0x757
[69561.927007]  [<c04a9373>] ext3_get_blocks_handle+0x734/0x757
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c041d410>] rebalance_domains+0x6d/0x3a2
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c04285de>] run_timer_softirq+0x173/0x17b
[69561.927007]  [<c041d770>] run_rebalance_domains+0x2b/0x90
[69561.927007]  [<c04254b8>] __do_softirq+0x83/0x11e
[69561.927007]  [<c0425719>] irq_exit+0x50/0x7d
[69561.927007]  [<c041a473>] dequeue_task_fair+0x33/0x16f
[69561.927007]  [<c040efbe>] flush_tlb_page+0x7f/0x8d
[69561.927007]  [<c0415942>] ptep_set_access_flags+0x20/0x26
[69561.927007]  [<c04578cb>] do_wp_page+0x163/0x3eb
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c0457aea>] do_wp_page+0x382/0x3eb
[69561.927007]  [<c0458c93>] handle_mm_fault+0x48d/0x4e2
[69561.927007]  [<c0475b82>] core_sys_select+0x15f/0x1eb
[69561.927007]  [<c04135cb>] do_page_fault+0x269/0x5c2
[69561.927007]  [<c0413624>] do_page_fault+0x2c2/0x5c2
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c04664d9>] add_partial+0xe/0x44
[69561.927007]  [<c0467158>] __slab_free+0xdf/0x31d
[69561.927007]  [<c047644d>] d_kill+0x3e/0x43
[69561.927007]  [<c047644d>] d_kill+0x3e/0x43
[69561.927007]  [<c0468276>] kmem_cache_free+0x49/0x52
[69561.927007]  [<c047644d>] d_kill+0x3e/0x43
[69561.927007]  [<c0475dd1>] sys_select+0x6e/0x8f
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] loop0         D c09e0564     0  7828      2
[69561.927007]  f2aab700 00000046 c059c07c c09e0564 c09e3780 c09e3780 f2aab700 f2aab854
[69561.927007]  c1fff780 00000000 c04892f2 f2aab854 c51f8e60 00000000 00000003 c11aad00
[69561.927007]  0872e111 f6b8f400 c1545b00 c1fff780 c1fffb70 f5dcfd64 c1ff102c c07c9041
[69561.927007] Call Trace:
[69561.927007]  [<c059c07c>] blk_unplug+0x9/0xa
[69561.927007]  [<c04892f2>] mpage_readpages+0xb4/0xbe
[69561.927007]  [<c07c9041>] io_schedule+0x21/0x2b
[69561.927007]  [<c044b68a>] sync_page+0x43/0x48
[69561.927007]  [<c07c9261>] __wait_on_bit_lock+0x31/0x6a
[69561.927007]  [<c044b647>] sync_page+0x0/0x48
[69561.927007]  [<c044b637>] __lock_page+0x76/0x7e
[69561.927007]  [<c0430b72>] wake_bit_function+0x0/0x3c
[69561.927007]  [<c04815fa>] __generic_file_splice_read+0x245/0x3d0
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c040f2af>] lapic_next_event+0x10/0x13
[69561.927007]  [<c04378f2>] clockevents_program_event+0xbb/0xc9
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c0418b50>] update_curr+0x5f/0x13f
[69561.927007]  [<c0418aeb>] sched_slice+0x46/0x4c
[69561.927007]  [<c0418b50>] update_curr+0x5f/0x13f
[69561.927007]  [<c0418b50>] update_curr+0x5f/0x13f
[69561.927007]  [<c0419528>] need_resched+0x11/0x1a
[69561.927007]  [<c07c908d>] _cond_resched+0x5/0x2d
[69561.927007]  [<c061f589>] transfer_none+0x72/0x79
[69561.927007]  [<c04805ed>] spd_release_page+0x0/0xa
[69561.927007]  [<c04817fa>] generic_file_splice_read+0x75/0x8f
[69561.927007]  [<c04803e3>] do_splice_to+0x4a/0x58
[69561.927007]  [<c048079d>] splice_direct_to_actor+0xcd/0x19f
[69561.927007]  [<c061f468>] lo_direct_splice_actor+0x0/0xa
[69561.927007]  [<c061f405>] loop_thread+0x38f/0x3f2
[69561.927007]  [<c061f076>] loop_thread+0x0/0x3f2
[69561.927007]  [<c04308ad>] kthread+0x38/0x5d
[69561.927007]  [<c0430875>] kthread+0x0/0x5d
[69561.927007]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69561.927007] bash          S c09e0564     0  7843   7516
[69561.927007]  f2aa9130 00200086 c5037800 c09e0564 c09e3780 c09e3780 f2aa9130 f2aa9284
[69561.927007]  c1fff780 00000000 c5037800 f2aa9284 041baa4f 00000000 f2aa9130 0000000e
[69561.927007]  c0423a13 f5ffff6c 00000003 f2aa9128 00000000 f2aa9130 0000000e c0423b04
[69561.927007] Call Trace:
[69561.927007]  [<c0423a13>] do_wait+0xd3/0x2ae
[69561.927007]  [<c0423b04>] do_wait+0x1c4/0x2ae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c0423c6f>] sys_wait4+0x81/0x94
[69561.927007]  [<c0423c95>] sys_waitpid+0x13/0x17
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] bash          S c09e0564     0  7912   7516
[69561.927007]  f1afe5d0 00200082 de654800 c09e0564 c09e3780 c09e3780 f1afe5d0 f1afe724
[69561.927007]  c2007780 00000001 de654800 f1afe724 041f3d52 00000000 f1afe5d0 0000000e
[69561.927007]  c0423a13 f6067f6c 00000003 f1afe5c8 00000000 f1afe5d0 0000000e c0423b04
[69561.927007] Call Trace:
[69561.927007]  [<c0423a13>] do_wait+0xd3/0x2ae
[69561.927007]  [<c0423b04>] do_wait+0x1c4/0x2ae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c0423c6f>] sys_wait4+0x81/0x94
[69561.927007]  [<c0423c95>] sys_waitpid+0x13/0x17
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] rsync         D c09e0564     0  8114   7843
[69561.927007]  f2be6cb0 00200082 f6b8f400 c09e0564 c09e3780 c09e3780 f2be6cb0 f2be6e04
[69561.927007]  c1fff780 00000000 c048277a f2be6e04 00000001 f604fe08 c0485219 f6b8f400
[69561.927007]  c113e8e0 f604fe50 c113e8e0 c1fff780 c1fffb70 f604fe50 c1ff0330 c07c9041
[69561.927007] Call Trace:
[69561.927007]  [<c048277a>] submit_bh+0xec/0xf7
[69561.927007]  [<c0485219>] block_read_full_page+0x213/0x224
[69561.927007]  [<c07c9041>] io_schedule+0x21/0x2b
[69561.927007]  [<c044b68a>] sync_page+0x43/0x48
[69561.927007]  [<c044b695>] sync_page_killable+0x6/0x34
[69561.927007]  [<c07c9261>] __wait_on_bit_lock+0x31/0x6a
[69561.927007]  [<c044b68f>] sync_page_killable+0x0/0x34
[69561.927007]  [<c044b5b9>] __lock_page_killable+0x79/0x81
[69561.927007]  [<c0430b72>] wake_bit_function+0x0/0x3c
[69561.927007]  [<c044cb5b>] generic_file_aio_read+0x396/0x578
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c046ac67>] do_sync_read+0x0/0x107
[69561.927007]  [<c046b4b6>] vfs_read+0x73/0xa1
[69561.927007]  [<c046b57c>] sys_read+0x3c/0x63
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] rsync         S c09e0564     0  8115   8114
[69561.927007]  f1afd4a0 00200086 c1ffc470 c09e0564 c09e3780 c09e3780 f1afd4a0 f1afd5f4
[69561.927007]  c1fff780 00000000 00000000 f1afd5f4 039386ff f5fe3e3c 00000000 039386ff
[69561.927007]  c0433650 039386ff 00000000 039386ff f5fe3e3c f5fe3b84 039386ff c07c96cc
[69561.927007] Call Trace:
[69561.927007]  [<c0433650>] hrtimer_start_expires+0x17/0x1d
[69561.927007]  [<c07c96cc>] schedule_hrtimeout_range+0xc4/0xed
[69561.927007]  [<c04330d4>] hrtimer_wakeup+0x0/0x18
[69561.927007]  [<c04759e0>] do_select+0x3e6/0x429
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c0419596>] resched_task+0x65/0x67
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c041ce0e>] try_to_wake_up+0x14c/0x156
[69561.927007]  [<c0430b52>] autoremove_wake_function+0xd/0x2d
[69561.927007]  [<c04192ae>] __wake_up_common+0x34/0x59
[69561.927007]  [<c0419c29>] __wake_up+0x29/0x39
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c042df7a>] insert_work+0x49/0x4e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0418aeb>] sched_slice+0x46/0x4c
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c041d410>] rebalance_domains+0x6d/0x3a2
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c04285de>] run_timer_softirq+0x173/0x17b
[69561.927007]  [<c041d770>] run_rebalance_domains+0x2b/0x90
[69561.927007]  [<c04254b8>] __do_softirq+0x83/0x11e
[69561.927007]  [<c0425719>] irq_exit+0x50/0x7d
[69561.927007]  [<c040f980>] smp_apic_timer_interrupt+0x6e/0x78
[69561.927007]  [<c0403c0c>] apic_timer_interrupt+0x28/0x30
[69561.927007]  [<c05ad238>] copy_from_user+0x106/0x10a
[69561.927007]  [<c0475b82>] core_sys_select+0x15f/0x1eb
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c046d503>] cp_new_stat64+0xf7/0x109
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c0475dd1>] sys_select+0x6e/0x8f
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] rsync         S c09e0564     0  8116   8115
[69561.927007]  f1aff700 00200082 c1ffc470 c09e0564 c09e3780 c09e3780 f1aff700 f1aff854
[69561.927007]  c1fff780 00000000 00000000 f1aff854 0420da4e f6959e3c 00000000 039386ff
[69561.927007]  c0433650 039386ff 00000000 039386ff f6959e3c f6959b84 039386ff c07c96cc
[69561.927007] Call Trace:
[69561.927007]  [<c0433650>] hrtimer_start_expires+0x17/0x1d
[69561.927007]  [<c07c96cc>] schedule_hrtimeout_range+0xc4/0xed
[69561.927007]  [<c04330d4>] hrtimer_wakeup+0x0/0x18
[69561.927007]  [<c04759e0>] do_select+0x3e6/0x429
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c044e8b7>] __rmqueue_smallest+0xbe/0x135
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c044f737>] get_page_from_freelist+0xba/0x402
[69561.927007]  [<c044f97e>] get_page_from_freelist+0x301/0x402
[69561.927007]  [<c04a941b>] ext3_get_block+0x85/0xb8
[69561.927007]  [<c04841ca>] __block_prepare_write+0x212/0x2b6
[69561.927007]  [<c05aa57c>] radix_tree_tag_set+0x54/0xa9
[69561.927007]  [<c041a6d5>] enqueue_task_fair+0x126/0x178
[69561.927007]  [<c0419ccc>] task_rq_lock+0x28/0x4e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c041ce0e>] try_to_wake_up+0x14c/0x156
[69561.927007]  [<c044ecc2>] __free_one_page+0xfd/0x1b6
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c0465c96>] virt_to_head_page+0x1f/0x2a
[69561.927007]  [<c076a086>] scm_recv+0x19/0x65
[69561.927007]  [<c076b4ca>] unix_stream_recvmsg+0x441/0x460
[69561.927007]  [<c0475b82>] core_sys_select+0x15f/0x1eb
[69561.927007]  [<c046ad27>] do_sync_read+0xc0/0x107
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0407a91>] read_tsc+0x6/0x22
[69561.927007]  [<c0435ab4>] getnstimeofday+0x4a/0xcd
[69561.927007]  [<c0475dd1>] sys_select+0x6e/0x8f
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] pdflush       D c09e0564     0  8119      2
[69561.927007]  f2be46e0 00000046 00000000 c09e0564 c09e3780 c09e3780 f2be46e0 f2be4834
[69561.927007]  c2007780 00000001 00000000 f2be4834 00000292 c0419c29 00000000 00000000
[69561.927007]  00000003 c1c53f40 c1c53f40 c2007780 c2007b70 f61ddda8 c1ff8330 c07c9041
[69561.927007] Call Trace:
[69561.927007]  [<c0419c29>] __wake_up+0x29/0x39
[69561.927007]  [<c07c9041>] io_schedule+0x21/0x2b
[69561.927007]  [<c044b68a>] sync_page+0x43/0x48
[69561.927007]  [<c07c9261>] __wait_on_bit_lock+0x31/0x6a
[69561.927007]  [<c044b647>] sync_page+0x0/0x48
[69561.927007]  [<c044b637>] __lock_page+0x76/0x7e
[69561.927007]  [<c0430b72>] wake_bit_function+0x0/0x3c
[69561.927007]  [<c04506de>] write_cache_pages+0x154/0x2b3
[69561.927007]  [<c04b9c92>] __mpage_da_writepage+0x0/0x12d
[69561.927007]  [<c04b9ace>] ext4_da_writepages+0x1c1/0x2de
[69561.927007]  [<c0418e93>] dequeue_task+0x62/0x70
[69561.927007]  [<c07ca319>] _spin_unlock_irq+0x17/0x21
[69561.927007]  [<c041e14f>] finish_task_switch+0x1f/0x69
[69561.927007]  [<c04bab9d>] ext4_da_get_block_write+0x0/0x12c
[69561.927007]  [<c04b990d>] ext4_da_writepages+0x0/0x2de
[69561.927007]  [<c045087e>] do_writepages+0x20/0x30
[69561.927007]  [<c047eeff>] __writeback_single_inode+0x15d/0x313
[69561.927007]  [<c0450b28>] get_dirty_limits+0x16/0x2bc
[69561.927007]  [<c069d28b>] raid1_congested+0x93/0xa5
[69561.927007]  [<c047f448>] generic_sync_sb_inodes+0x212/0x367
[69561.927007]  [<c04560d6>] congestion_wait+0x5b/0x65
[69561.927007]  [<c047f70d>] writeback_inodes+0x5f/0xa0
[69561.927007]  [<c0450e46>] background_writeout+0x78/0xa7
[69561.927007]  [<c0451367>] pdflush+0x116/0x1b1
[69561.927007]  [<c0450dce>] background_writeout+0x0/0xa7
[69561.927007]  [<c0451251>] pdflush+0x0/0x1b1
[69561.927007]  [<c04308ad>] kthread+0x38/0x5d
[69561.927007]  [<c0430875>] kthread+0x0/0x5d
[69561.927007]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69561.927007] pdflush       D c09e0564     0  8123      2
[69561.927007]  f2990dc0 00000046 f70314a0 c09e0564 c09e3780 c09e3780 f2990dc0 f2990f14
[69561.927007]  c2007780 00000001 00000286 f2990f14 f6bdff18 0420dabd f6bdff18 c07ca33b
[69561.927007]  c0428beb 0420dabd 00000286 0420dabd 0420dabd c091f6f0 00000001 c07c91df
[69561.927007] Call Trace:
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0428beb>] __mod_timer+0x8e/0x97
[69561.927007]  [<c07c91df>] schedule_timeout+0x7e/0x99
[69561.927007]  [<c042877e>] process_timeout+0x0/0x5
[69561.927007]  [<c07c898a>] __sched_text_start+0x22/0x2c
[69561.927007]  [<c04560cb>] congestion_wait+0x50/0x65
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0450e6b>] background_writeout+0x9d/0xa7
[69561.927007]  [<c0451367>] pdflush+0x116/0x1b1
[69561.927007]  [<c0450dce>] background_writeout+0x0/0xa7
[69561.927007]  [<c0451251>] pdflush+0x0/0x1b1
[69561.927007]  [<c04308ad>] kthread+0x38/0x5d
[69561.927007]  [<c0430875>] kthread+0x0/0x5d
[69561.927007]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69561.927007] pdflush       D c09e0564     0  8124      2
[69561.927007]  f29906e0 00000046 f73becb0 c09e0564 c09e3780 c09e3780 f29906e0 f2990834
[69561.927007]  c1fff780 00000000 00000286 f2990834 0420da4e 0420dabc f1ad9f18 c07ca33b
[69561.927007]  c0428beb 0420dabc 00000286 0420dabc 0420dabc c091f6f0 00000001 c07c91df
[69561.927007] Call Trace:
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0428beb>] __mod_timer+0x8e/0x97
[69561.927007]  [<c07c91df>] schedule_timeout+0x7e/0x99
[69561.927007]  [<c042877e>] process_timeout+0x0/0x5
[69561.927007]  [<c07c898a>] __sched_text_start+0x22/0x2c
[69561.927007]  [<c04560cb>] congestion_wait+0x50/0x65
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0450e6b>] background_writeout+0x9d/0xa7
[69561.927007]  [<c0451367>] pdflush+0x116/0x1b1
[69561.927007]  [<c0450dce>] background_writeout+0x0/0xa7
[69561.927007]  [<c0451251>] pdflush+0x0/0x1b1
[69561.927007]  [<c04308ad>] kthread+0x38/0x5d
[69561.927007]  [<c0430875>] kthread+0x0/0x5d
[69561.927007]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69561.927007] bash          S c09e0564     0  8144   7516
[69561.927007]  f5c45130 00200082 00000001 c09e0564 c09e3780 c09e3780 f5c45130 f5c45284
[69561.927007]  c2007780 00000001 f6026260 f5c45284 041d16ef 00000000 f5c45130 00000004
[69561.927007]  c0423a13 f5fbff6c 00000003 f5c45128 00000000 f5c45130 00000004 c0423b04
[69561.927007] Call Trace:
[69561.927007]  [<c0423a13>] do_wait+0xd3/0x2ae
[69561.927007]  [<c0423b04>] do_wait+0x1c4/0x2ae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c0423c6f>] sys_wait4+0x81/0x94
[69561.927007]  [<c0423c95>] sys_waitpid+0x13/0x17
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] mutt          D c09e0564     0  8145   8144
[69561.927007]  f5e1b020 00200082 00000000 c09e0564 c09e3780 c09e3780 f5e1b020 f5e1b174
[69561.927007]  c2007780 00000001 00000000 f5e1b174 00200282 c0419c29 00000000 00000000
[69561.927007]  00000003 c106bd60 c106bd60 c2007780 c2007b70 f1a8de00 c1ff2298 c07c9041
[69561.927007] Call Trace:
[69561.927007]  [<c0419c29>] __wake_up+0x29/0x39
[69561.927007]  [<c07c9041>] io_schedule+0x21/0x2b
[69561.927007]  [<c044b68a>] sync_page+0x43/0x48
[69561.927007]  [<c07c9261>] __wait_on_bit_lock+0x31/0x6a
[69561.927007]  [<c044b647>] sync_page+0x0/0x48
[69561.927007]  [<c044b637>] __lock_page+0x76/0x7e
[69561.927007]  [<c0430b72>] wake_bit_function+0x0/0x3c
[69561.927007]  [<c04506de>] write_cache_pages+0x154/0x2b3
[69561.927007]  [<c04b9c92>] __mpage_da_writepage+0x0/0x12d
[69561.927007]  [<c04d7aea>] start_this_handle+0x324/0x343
[69561.927007]  [<c04b9ace>] ext4_da_writepages+0x1c1/0x2de
[69561.927007]  [<c046ac20>] do_sync_write+0xc0/0x107
[69561.927007]  [<c04bab9d>] ext4_da_get_block_write+0x0/0x12c
[69561.927007]  [<c04b990d>] ext4_da_writepages+0x0/0x2de
[69561.927007]  [<c045087e>] do_writepages+0x20/0x30
[69561.927007]  [<c044c073>] __filemap_fdatawrite_range+0x54/0x60
[69561.927007]  [<c044cd65>] filemap_fdatawrite+0x12/0x16
[69561.927007]  [<c0481b26>] do_fsync+0x23/0x69
[69561.927007]  [<c0481b88>] __do_fsync+0x1c/0x2b
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] pdflush       D c09e0564     0  8151      2
[69561.927007]  f73becb0 00000046 e10f3a70 c09e0564 c09e3780 c09e3780 f73becb0 f73bee04
[69561.927007]  c1fff780 00000000 00000286 f73bee04 f29fdf18 0420dabc f29fdf18 c07ca33b
[69561.927007]  c0428beb 0420dabc 00000286 0420dabc 0420dabc c091f6f0 00000001 c07c91df
[69561.927007] Call Trace:
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0428beb>] __mod_timer+0x8e/0x97
[69561.927007]  [<c07c91df>] schedule_timeout+0x7e/0x99
[69561.927007]  [<c042877e>] process_timeout+0x0/0x5
[69561.927007]  [<c07c898a>] __sched_text_start+0x22/0x2c
[69561.927007]  [<c04560cb>] congestion_wait+0x50/0x65
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0450e6b>] background_writeout+0x9d/0xa7
[69561.927007]  [<c0451367>] pdflush+0x116/0x1b1
[69561.927007]  [<c0450dce>] background_writeout+0x0/0xa7
[69561.927007]  [<c0451251>] pdflush+0x0/0x1b1
[69561.927007]  [<c04308ad>] kthread+0x38/0x5d
[69561.927007]  [<c0430875>] kthread+0x0/0x5d
[69561.927007]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69561.927007] pdflush       D c09e0564     0  8152      2
[69561.927007]  f73bf020 00000046 f2990dc0 c09e0564 c09e3780 c09e3780 f73bf020 f73bf174
[69561.927007]  c2007780 00000001 00000286 f73bf174 f6921f18 0420dabd f6921f18 c07ca33b
[69561.927007]  c0428beb 0420dabd 00000286 0420dabd 0420dabd c091f6f0 00000001 c07c91df
[69561.927007] Call Trace:
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0428beb>] __mod_timer+0x8e/0x97
[69561.927007]  [<c07c91df>] schedule_timeout+0x7e/0x99
[69561.927007]  [<c042877e>] process_timeout+0x0/0x5
[69561.927007]  [<c07c898a>] __sched_text_start+0x22/0x2c
[69561.927007]  [<c04560cb>] congestion_wait+0x50/0x65
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0450e6b>] background_writeout+0x9d/0xa7
[69561.927007]  [<c0451367>] pdflush+0x116/0x1b1
[69561.927007]  [<c0450dce>] background_writeout+0x0/0xa7
[69561.927007]  [<c0451251>] pdflush+0x0/0x1b1
[69561.927007]  [<c04308ad>] kthread+0x38/0x5d
[69561.927007]  [<c0430875>] kthread+0x0/0x5d
[69561.927007]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69561.927007] gconftool-2   S c09e0564     0  8164   7592
[69561.927007]  e10f1810 00200082 c09192f0 c09e0564 c09e3780 c09e3780 e10f1810 e10f1964
[69561.927007]  c1fff780 00000000 017d783f e10f1964 041f2094 f5fa1bc4 c1ffc470 c07ca33b
[69561.927007]  c04334e4 00200282 f5fa1bc4 00000000 00000000 f5fa1ea0 00000000 c07c9639
[69561.927007] Call Trace:
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c04334e4>] hrtimer_try_to_cancel+0x56/0x5d
[69561.927007]  [<c07c9639>] schedule_hrtimeout_range+0x31/0xed
[69561.927007]  [<c04330d4>] hrtimer_wakeup+0x0/0x18
[69561.927007]  [<c0430d58>] add_wait_queue+0xe/0x2e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0769c0b>] unix_poll+0x14/0x86
[69561.927007]  [<c047538b>] do_sys_poll+0x28c/0x321
[69561.927007]  [<c0475df2>] __pollwait+0x0/0xae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c04d115a>] __journal_file_buffer+0xa4/0x128
[69561.927007]  [<c04d0fd9>] jbd_unlock_bh_state+0x20/0x2a
[69561.927007]  [<c04d12d4>] journal_dirty_metadata+0xb9/0xc1
[69561.927007]  [<c04d0ff6>] __journal_temp_unlink_buffer+0x13/0xd3
[69561.927007]  [<c041a6d5>] enqueue_task_fair+0x126/0x178
[69561.927007]  [<c0418ebe>] activate_task+0x1d/0x2b
[69561.927007]  [<c0419561>] resched_task+0x30/0x67
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c041ce0e>] try_to_wake_up+0x14c/0x156
[69561.927007]  [<c044f9d0>] get_page_from_freelist+0x353/0x402
[69561.927007]  [<c044fbab>] __alloc_pages_internal+0x98/0x391
[69561.927007]  [<c0452acf>] page_mapping+0x10/0x25
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c0458cd7>] handle_mm_fault+0x4d1/0x4e2
[69561.927007]  [<c0467158>] __slab_free+0xdf/0x31d
[69561.927007]  [<c0715118>] move_addr_to_user+0x50/0x68
[69561.927007]  [<c046959c>] fd_install+0x1e/0x3f
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c07156c2>] sys_accept4+0x15a/0x1b1
[69561.927007]  [<c071553d>] sys_getsockname+0x6f/0x9a
[69561.927007]  [<c046a9cc>] rw_copy_check_uvector+0x59/0xc3
[69561.927007]  [<c046a96d>] fsnotify_modify+0x3d/0x43
[69561.927007]  [<c046b18d>] do_readv_writev+0xcc/0xd6
[69561.927007]  [<c07ca3a1>] _spin_unlock+0x16/0x20
[69561.927007]  [<c0473d4c>] set_close_on_exec+0x1e/0x3b
[69561.927007]  [<c0475572>] sys_poll+0x44/0x8d
[69561.927007]  [<c0445bac>] audit_syscall_entry+0xf8/0x122
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] su            S c09e0564     0  8167   7912
[69561.927007]  e10f3020 00000086 00000001 c09e0564 c09e3780 c09e3780 e10f3020 e10f3174
[69561.927007]  c2007780 00000001 f7030dc0 e10f3174 041f3e92 00000000 e10f3020 00000006
[69561.927007]  c0423a13 f606bf6c 00000003 e10f3018 00000000 e10f3020 00000006 c0423b04
[69561.927007] Call Trace:
[69561.927007]  [<c0423a13>] do_wait+0xd3/0x2ae
[69561.927007]  [<c0423b04>] do_wait+0x1c4/0x2ae
[69561.927007]  [<c041ce18>] default_wake_function+0x0/0x8
[69561.927007]  [<c0423c6f>] sys_wait4+0x81/0x94
[69561.927007]  [<c0423c95>] sys_waitpid+0x13/0x17
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007]  [<c07c0000>] pci_probe+0x2d5/0x362
[69561.927007] bash          R running      0  8171   8167
[69561.927007]  00000000 00000006 ffffffff 00000000 ffffffff 00000006 ffffffff 00000400
[69561.927007]  c0a18b8c ffffffff c0a18f00 00000000 ffffffff ffffffff c0430b45 f5c65dd0
[69561.927007]  f5c65dd0 c0419c29 00000000 f5c65e14 de654800 7fffffff 00000001 00000082
[69561.927007] Call Trace:
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0419c29>] __wake_up+0x29/0x39
[69561.927007]  [<c0433eae>] up+0x9/0x2a
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0421b81>] release_console_sem+0x171/0x19e
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0421b81>] release_console_sem+0x171/0x19e
[69561.927007]  [<c0421b81>] release_console_sem+0x171/0x19e
[69561.927007]  [<c04052e3>] print_trace_address+0x0/0x39
[69561.927007]  [<c07c890f>] printk+0xe/0x11
[69561.927007]  [<c0405315>] print_trace_address+0x32/0x39
[69561.927007]  [<c0405315>] print_trace_address+0x32/0x39
[69561.927007]  [<c0405315>] print_trace_address+0x32/0x39
[69561.927007]  [<c042f187>] __kernel_text_address+0x30/0x39
[69561.927007]  [<c04053a2>] dump_trace+0x86/0xd4
[69561.927007]  [<c0405493>] show_stack_log_lvl+0xa3/0xab
[69561.927007]  [<c0405802>] show_stack+0x10/0x13
[69561.927007]  [<c041e5a9>] show_state_filter+0x39/0x6c
[69561.927007]  [<c05fbac6>] __handle_sysrq+0x97/0x10b
[69561.927007]  [<c05fbb3a>] write_sysrq_trigger+0x0/0x29
[69561.927007]  [<c05fbb5d>] write_sysrq_trigger+0x23/0x29
[69561.927007]  [<c04967e4>] proc_reg_write+0x60/0x73
[69561.927007]  [<c0496784>] proc_reg_write+0x0/0x73
[69561.927007]  [<c046b356>] vfs_write+0x76/0xa4
[69561.927007]  [<c046b41c>] sys_write+0x3c/0x63
[69561.927007]  [<c0402f55>] sysenter_do_call+0x12/0x21
[69561.927007] pdflush       D c09e0564     0  8213      2
[69561.927007]  e10f3a70 00000046 f73054a0 c09e0564 c09e3780 c09e3780 e10f3a70 e10f3bc4
[69561.927007]  c1fff780 00000000 00000286 e10f3bc4 f60e7f18 0420dabc f60e7f18 c07ca33b
[69561.927007]  c0428beb 0420dabc 00000286 0420dabc 0420dabc c091f6f0 00000001 c07c91df
[69561.927007] Call Trace:
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0428beb>] __mod_timer+0x8e/0x97
[69561.927007]  [<c07c91df>] schedule_timeout+0x7e/0x99
[69561.927007]  [<c042877e>] process_timeout+0x0/0x5
[69561.927007]  [<c07c898a>] __sched_text_start+0x22/0x2c
[69561.927007]  [<c04560cb>] congestion_wait+0x50/0x65
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0450e6b>] background_writeout+0x9d/0xa7
[69561.927007]  [<c0451367>] pdflush+0x116/0x1b1
[69561.927007]  [<c0450dce>] background_writeout+0x0/0xa7
[69561.927007]  [<c0451251>] pdflush+0x0/0x1b1
[69561.927007]  [<c04308ad>] kthread+0x38/0x5d
[69561.927007]  [<c0430875>] kthread+0x0/0x5d
[69561.927007]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69561.927007] pdflush       D c09e0564     0  8214      2
[69561.927007]  e10f1ef0 00000046 c09192f0 c09e0564 c09e3780 c09e3780 e10f1ef0 e10f2044
[69561.927007]  c1fff780 00000000 00000286 e10f2044 f6017f20 0420dabc f6017f20 c07ca33b
[69561.927007]  c0428beb 0420dabc 00000286 0420dabc 0420dabc c091f6f0 00000001 c07c91df
[69561.927007] Call Trace:
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0428beb>] __mod_timer+0x8e/0x97
[69561.927007]  [<c07c91df>] schedule_timeout+0x7e/0x99
[69561.927007]  [<c042877e>] process_timeout+0x0/0x5
[69561.927007]  [<c07c898a>] __sched_text_start+0x22/0x2c
[69561.927007]  [<c04560cb>] congestion_wait+0x50/0x65
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0450998>] wb_kupdate+0x97/0xdf
[69561.927007]  [<c0451367>] pdflush+0x116/0x1b1
[69561.927007]  [<c0450901>] wb_kupdate+0x0/0xdf
[69561.927007]  [<c0451251>] pdflush+0x0/0x1b1
[69561.927007]  [<c04308ad>] kthread+0x38/0x5d
[69561.927007]  [<c0430875>] kthread+0x0/0x5d
[69561.927007]  [<c0403d57>] kernel_thread_helper+0x7/0x10
[69561.927007] pdflush       D c09e0564     0  8215      2
[69561.927007]  e10f1130 00000046 f73bf020 c09e0564 c09e3780 c09e3780 e10f1130 e10f1284
[69561.927007]  c2007780 00000001 00000286 e10f1284 0420da32 0420dabd f5f8bf18 c07ca33b
[69561.927007]  c0428beb 0420dabd 00000286 0420dabd 0420dabd c091f6f0 00000001 c07c91df
[69561.927007] Call Trace:
[69561.927007]  [<c07ca33b>] _spin_unlock_irqrestore+0x18/0x22
[69561.927007]  [<c0428beb>] __mod_timer+0x8e/0x97
[69561.927007]  [<c07c91df>] schedule_timeout+0x7e/0x99
[69561.927007]  [<c042877e>] process_timeout+0x0/0x5
[69561.927007]  [<c07c898a>] __sched_text_start+0x22/0x2c
[69561.927007]  [<c04560cb>] congestion_wait+0x50/0x65
[69561.927007]  [<c0430b45>] autoremove_wake_function+0x0/0x2d
[69561.927007]  [<c0450e6b>] background_writeout+0x9d/0xa7
[69561.927007]  [<c0451367>] pdflush+0x116/0x1b1
[69561.927007]  [<c0450dce>] background_writeout+0x0/0xa7
[69561.927007]  [<c0451251>] pdflush+0x0/0x1b1
[69561.927007]  [<c04308ad>] kthread+0x38/0x5d
[69561.927007]  [<c0430875>] kthread+0x0/0x5d
[69561.927007]  [<c0403d57>] kernel_thread_helper+0x7/0x10

Regards,
Luciano Rocha

-- 
Luciano Rocha <luciano@eurotux.com>
Eurotux Informática, S.A. <http://www.eurotux.com/>
