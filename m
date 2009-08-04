Return-Path: <linux-kernel-owner+w=401wt.eu-S932441AbZHDKTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441AbZHDKTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932353AbZHDKTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:19:00 -0400
Received: from ppp-153-126.adsl.restena.lu ([158.64.153.126]:43524 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbZHDKS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:18:59 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Aug 2009 06:18:58 EDT
Date: Tue, 4 Aug 2009 12:12:04 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: ecashin@coraid.com, linux-kernel@vger.kernel.org
Subject: [2.6.31-rc5 regression] Troubles with AoE and uninitialized object
Message-ID: <20090804121204.517442f0@neptune.home>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got these traces today when exposing an AoE device and then using it:
I didn't have these a few weeks ago (2.6.30 I think but could already
have been a 2.6.31-rc).

When AoE device became visible:
[ 3161.782571] aoe: 00089bb442e6 e2.0 v400c has 4194304 sectors
[ 3161.782755]  etherd/e2.0: unknown partition table
[ 3161.831201] kobject '<NULL>' (dc083948): tried to add an uninitialized object, something is seriously wrong.
[ 3161.831215] Pid: 4, comm: events/0 Tainted: G   M       2.6.31-rc5 #68
[ 3161.831222] Call Trace:
[ 3161.831240]  [<c12b70a2>] ? printk+0x18/0x1e
[ 3161.831276]  [<c10fe62d>] kobject_add+0x4d/0x60
[ 3161.831303]  [<c10f7f30>] ? exact_match+0x0/0x10
[ 3161.831313]  [<c10f46a5>] blk_register_queue+0x45/0xb0
[ 3161.831323]  [<c10f7f30>] ? exact_match+0x0/0x10
[ 3161.831333]  [<c10f89a2>] add_disk+0xe2/0x130
[ 3161.831342]  [<c10f7f30>] ? exact_match+0x0/0x10
[ 3161.831351]  [<c10f8430>] ? exact_lock+0x0/0x20
[ 3161.831364]  [<c11efa93>] aoeblk_gdalloc+0x113/0x170
[ 3161.831374]  [<c11f0e90>] ? aoecmd_sleepwork+0x0/0xa0
[ 3161.831384]  [<c11f0f27>] aoecmd_sleepwork+0x97/0xa0
[ 3161.831394]  [<c11f0e90>] ? aoecmd_sleepwork+0x0/0xa0
[ 3161.831405]  [<c1031fde>] worker_thread+0xde/0x190
[ 3161.831414]  [<c12b73c3>] ? schedule+0x203/0x340
[ 3161.831427]  [<c1035550>] ? autoremove_wake_function+0x0/0x50
[ 3161.831437]  [<c1031f00>] ? worker_thread+0x0/0x190
[ 3161.831447]  [<c1035184>] kthread+0x74/0x80
[ 3161.831477]  [<c1035110>] ? kthread+0x0/0x80
[ 3161.831489]  [<c1003673>] kernel_thread_helper+0x7/0x14

When attempting to unmount XFS filesystem lying on the AoE device:
[ 5259.349897] aoe: bi_io_vec is NULL
[ 5259.349940] ------------[ cut here ]------------
[ 5259.349958] kernel BUG at /usr/src/linux-2.6/drivers/block/aoe/aoeblk.c:177!
[ 5259.349990] invalid opcode: 0000 [#1] 
[ 5259.350002] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
[ 5259.350070] Modules linked in: ftdi_sio usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd nsc_ircc snd_page_alloc i2c_i801 ehci_hcd pcspkr irda uhci_hcd usbcore crc_ccitt
[ 5259.350399] 
[ 5259.350426] Pid: 4016, comm: umount Tainted: G   M       (2.6.31-rc5 #68) TravelMate 660
[ 5259.350437] EIP: 0060:[<c11efcb7>] EFLAGS: 00010296 CPU: 0
[ 5259.350456] EIP is at aoeblk_make_request+0x1c7/0x1e0
[ 5259.350503] EAX: 0000002c EBX: 00000000 ECX: ffffffff EDX: c13c6564
[ 5259.350513] ESI: dc083800 EDI: dc315b00 EBP: da95fdac ESP: da95fd84
[ 5259.350539]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[ 5259.350551] Process umount (pid: 4016, ti=da95f000 task=dd951dd0 task.ti=da95f000)
[ 5259.350591] Stack:
[ 5259.350597]  c1395e3f dd80a258 da95fd94 dc315b00 00000246 00000400 dc315b00 000000ff
[ 5259.350694] <0> dd402540 dc315b00 da95fe54 c10f2a3d c13c5fdc 00000578 dd951dfc c13c5fdc
[ 5259.350796] <0> da95fdf8 c101df0e 000004c8 89ad9613 66752982 00000000 00000578 00000000
[ 5259.350902] Call Trace:
[ 5259.350941]  [<c10f2a3d>] ? generic_make_request+0x28d/0x360
[ 5259.350956]  [<c101df0e>] ? update_curr+0x12e/0x160
[ 5259.350987]  [<c101f72e>] ? set_next_entity+0x2e/0x70
[ 5259.351003]  [<c12b73c3>] ? schedule+0x203/0x340
[ 5259.351035]  [<c1050b1e>] ? mempool_alloc_slab+0xe/0x10
[ 5259.351047]  [<c1050b1e>] ? mempool_alloc_slab+0xe/0x10
[ 5259.351077]  [<c10f2b52>] ? submit_bio+0x42/0xb0
[ 5259.351089]  [<c12b75a5>] ? _cond_resched+0x25/0x40
[ 5259.351119]  [<c1096a5b>] ? bio_alloc_bioset+0x2b/0xe0
[ 5259.351132]  [<c10f4c74>] ? blkdev_issue_flush+0x74/0xb0
[ 5259.351245]  [<df3eb73d>] ? xfs_blkdev_issue_flush+0xd/0x10 [xfs]
[ 5259.351314]  [<df3e4c0d>] ? xfs_free_buftarg+0x2d/0x60 [xfs]
[ 5259.351400]  [<df3eb3f0>] ? xfs_close_devices+0x50/0x60 [xfs]
[ 5259.351468]  [<df3eb481>] ? xfs_fs_put_super+0x81/0xc0 [xfs]
[ 5259.351520]  [<c107661b>] ? generic_shutdown_super+0x4b/0xd0
[ 5259.351532]  [<c10766c5>] ? kill_block_super+0x25/0x40
[ 5259.351561]  [<c10769d7>] ? deactivate_super+0x37/0x50
[ 5259.351577]  [<c1089510>] ? mntput_no_expire+0x50/0x60
[ 5259.351606]  [<c108978f>] ? sys_umount+0x4f/0x2d0
[ 5259.351619]  [<c1089a27>] ? sys_oldumount+0x17/0x20
[ 5259.351648]  [<c1002e08>] ? sysenter_do_call+0x12/0x26
[ 5259.351657] Code: ff c7 04 24 08 08 38 c1 e8 f1 73 0c 00 8b 45 e4 ba f4 ff ff ff e8 5a 67 ea ff e9 7a ff ff ff c7 04 24 3f 5e 39 c1 e8 d3 73 0c 00 <0f> 0b eb fe 90 8d 74 26 00 c7 04 24 e0 07 38 c1 e8 be 73 0c 00 
[ 5259.352253] EIP: [<c11efcb7>] aoeblk_make_request+0x1c7/0x1e0 SS:ESP 0068:da95fd84
[ 5259.352294] ---[ end trace 8b656d4496e367a0 ]---
[ 5259.352319] ------------[ cut here ]------------
[ 5259.352334] WARNING: at /usr/src/linux-2.6/kernel/exit.c:895 do_exit+0x5a7/0x630()
[ 5259.352375] Hardware name: TravelMate 660
[ 5259.352382] Modules linked in: ftdi_sio usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd nsc_ircc snd_page_alloc i2c_i801 ehci_hcd pcspkr irda uhci_hcd usbcore crc_ccitt
[ 5259.352730] Pid: 4016, comm: umount Tainted: G   M  D    2.6.31-rc5 #68
[ 5259.352756] Call Trace:
[ 5259.352767]  [<c12b70a2>] ? printk+0x18/0x1e
[ 5259.352795]  [<c1026637>] ? do_exit+0x5a7/0x630
[ 5259.352808]  [<c102350c>] warn_slowpath_common+0x6c/0xc0
[ 5259.352837]  [<c1026637>] ? do_exit+0x5a7/0x630
[ 5259.352849]  [<c1023575>] warn_slowpath_null+0x15/0x20
[ 5259.352879]  [<c1026637>] do_exit+0x5a7/0x630
[ 5259.352891]  [<c12b70a2>] ? printk+0x18/0x1e
[ 5259.352920]  [<c102343f>] ? oops_exit+0x2f/0x40
[ 5259.352933]  [<c10060d5>] oops_end+0x85/0x90
[ 5259.352962]  [<c1006250>] die+0x50/0x70
[ 5259.352973]  [<c10039a1>] do_trap+0x91/0xd0
[ 5259.353001]  [<c1003da0>] ? do_invalid_op+0x0/0xa0
[ 5259.353013]  [<c1003e27>] do_invalid_op+0x87/0xa0
[ 5259.353043]  [<c11efcb7>] ? aoeblk_make_request+0x1c7/0x1e0
[ 5259.353059]  [<c12b8b4e>] error_code+0x5e/0x64
[ 5259.353088]  [<c1003da0>] ? do_invalid_op+0x0/0xa0
[ 5259.353101]  [<c11efcb7>] ? aoeblk_make_request+0x1c7/0x1e0
[ 5259.353132]  [<c10f2a3d>] generic_make_request+0x28d/0x360
[ 5259.353144]  [<c101df0e>] ? update_curr+0x12e/0x160
[ 5259.353174]  [<c101f72e>] ? set_next_entity+0x2e/0x70
[ 5259.353186]  [<c12b73c3>] ? schedule+0x203/0x340
[ 5259.353215]  [<c1050b1e>] ? mempool_alloc_slab+0xe/0x10
[ 5259.353227]  [<c1050b1e>] ? mempool_alloc_slab+0xe/0x10
[ 5259.353258]  [<c10f2b52>] submit_bio+0x42/0xb0
[ 5259.353269]  [<c12b75a5>] ? _cond_resched+0x25/0x40
[ 5259.353298]  [<c1096a5b>] ? bio_alloc_bioset+0x2b/0xe0
[ 5259.353310]  [<c10f4c74>] blkdev_issue_flush+0x74/0xb0
[ 5259.353396]  [<df3eb73d>] xfs_blkdev_issue_flush+0xd/0x10 [xfs]
[ 5259.353463]  [<df3e4c0d>] xfs_free_buftarg+0x2d/0x60 [xfs]
[ 5259.353566]  [<df3eb3f0>] xfs_close_devices+0x50/0x60 [xfs]
[ 5259.353634]  [<df3eb481>] xfs_fs_put_super+0x81/0xc0 [xfs]
[ 5259.353665]  [<c107661b>] generic_shutdown_super+0x4b/0xd0
[ 5259.353677]  [<c10766c5>] kill_block_super+0x25/0x40
[ 5259.353706]  [<c10769d7>] deactivate_super+0x37/0x50
[ 5259.353719]  [<c1089510>] mntput_no_expire+0x50/0x60
[ 5259.353748]  [<c108978f>] sys_umount+0x4f/0x2d0
[ 5259.353761]  [<c1089a27>] sys_oldumount+0x17/0x20
[ 5259.353789]  [<c1002e08>] sysenter_do_call+0x12/0x26
[ 5259.353798] ---[ end trace 8b656d4496e367a1 ]---

Is some of this already known?

Bruno
