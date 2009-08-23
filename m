Return-Path: <linux-kernel-owner+w=401wt.eu-S933442AbZHWJK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442AbZHWJK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 05:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbZHWJK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 05:10:29 -0400
Received: from ppp-136-251.adsl.restena.lu ([158.64.136.251]:55152 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbZHWJK1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 05:10:27 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Aug 2009 05:10:26 EDT
Date: Sun, 23 Aug 2009 11:00:21 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andy Whitcroft <apw@canonical.com>, "Ed L. Cashin" <ecashin@coraid.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/1] aoe: ensure we initialise the request_queue
 correctly
Message-ID: <20090823110021.28fc40dc@neptune.home>
In-Reply-To: <200908222352.07482.rjw@sisk.pl>
References: <1250872904-10993-1-git-send-email-apw@canonical.com>
	<20090822112103.49174d6b@neptune.home>
	<200908222352.07482.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 August 2009 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> On Saturday 22 August 2009, Bruno Prémont wrote:
> > Rafael, this matches regression bug #13942 "Troubles with AoE and
> > uninitialized object".
> > 
> > Will test and report how it works out here.
> 
> Great, thanks for the information.
> 
> Rafael
> 
For me this makes the kobject <NULL> message go away when new AoE
device is discovered.
At least this uninitialized object warning already existed with
2.6.31-rc1. More bisect-like details later today.


It does not fix the BUG(), WARN() triggered when unmounting XFS from
an AoE device as visible below. (linux-2.6.31-rc7 + patch of this thread)

Jens, is bio->bi_io_vec allowed to be NULL? AoE BUG()s in that case.



[  104.703175] aoe: 00089bb442e6 e0.0 v400c has 6291456 sectors
[  104.703321]  etherd/e0.0: unknown partition table
[  223.687021] XFS mounting filesystem etherd/e0.0
[  224.858261] Ending clean XFS mount for filesystem: etherd/e0.0
[  373.566294] aoe: bi_io_vec is NULL
[  373.566334] ------------[ cut here ]------------
[  373.568919] kernel BUG at /usr/src/linux-2.6/drivers/block/aoe/aoeblk.c:177!
[  373.571672] invalid opcode: 0000 [#1] 
[  373.574484] last sysfs file: /sys/devices/virtual/hwmon/hwmon0/temp1_input
[  373.576194] Modules linked in: squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs usb_storage loop nsc_ircc snd_intel8x0 irda ehci_hcd snd_ac97_codec ac97_bus uhci_hcd snd_pcm snd_timer usbcore snd snd_page_alloc i2c_i801 pcspkr crc_ccitt
[  373.576194] 
[  373.576194] Pid: 2205, comm: umount Not tainted (2.6.31-rc7 #2) TravelMate 660
[  373.576194] EIP: 0060:[<c11eff07>] EFLAGS: 00010296 CPU: 0
[  373.576194] EIP is at aoeblk_make_request+0x1b7/0x1d0
[  373.576194] EAX: 0000002c EBX: 00000000 ECX: ffffffff EDX: c13c6584
[  373.576194] ESI: da531000 EDI: dd394580 EBP: db7fcdac ESP: db7fcd84
[  373.576194]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  373.576194] Process umount (pid: 2205, ti=db7fc000 task=dd91b850 task.ti=db7fc000)
[  373.576194] Stack:
[  373.576194]  c1396425 dd80a258 db7fcd94 dd394580 00000246 00000400 dd394580 000000ff
[  373.576194] <0> dd402540 dd394580 db7fce54 c10f2dcd dd115480 00000000 dd394580 00000056
[  373.576194] <0> fa4273d3 4aff5460 00000056 fa483f4b 4aff5460 00000000 00000488 00000000
[  373.576194] Call Trace:
[  373.576194]  [<c10f2dcd>] ? generic_make_request+0x28d/0x360
[  373.576194]  [<c101f93e>] ? set_next_entity+0x2e/0x70
[  373.576194]  [<c12b7463>] ? schedule+0x203/0x340
[  373.576194]  [<c1050d8e>] ? mempool_alloc_slab+0xe/0x10
[  373.576194]  [<c1050d8e>] ? mempool_alloc_slab+0xe/0x10
[  373.576194]  [<c10f2ee2>] ? submit_bio+0x42/0xb0
[  373.576194]  [<c1096d2b>] ? bio_alloc_bioset+0x2b/0xe0
[  373.576194]  [<c10f5004>] ? blkdev_issue_flush+0x74/0xb0
[  373.576194]  [<e0c2a8cd>] ? xfs_blkdev_issue_flush+0xd/0x10 [xfs]
[  373.576194]  [<e0c23d8d>] ? xfs_free_buftarg+0x2d/0x60 [xfs]
[  373.576194]  [<e0c2a570>] ? xfs_close_devices+0x50/0x60 [xfs]
[  373.576194]  [<e0c2a601>] ? xfs_fs_put_super+0x81/0xc0 [xfs]
[  373.576194]  [<c107687b>] ? generic_shutdown_super+0x4b/0xd0
[  373.576194]  [<c1076925>] ? kill_block_super+0x25/0x40
[  373.576194]  [<c1076c37>] ? deactivate_super+0x37/0x50
[  373.576194]  [<c10897d0>] ? mntput_no_expire+0x50/0x60
[  373.576194]  [<c1089a4f>] ? sys_umount+0x4f/0x2d0
[  373.576194]  [<c1089ce7>] ? sys_oldumount+0x17/0x20
[  373.576194]  [<c1002e08>] ? sysenter_do_call+0x12/0x26
[  373.576194] Code: ff c7 04 24 fc 0e 38 c1 e8 41 72 0c 00 8b 45 e4 ba f4 ff ff ff e8 da 67 ea ff e9 77 ff ff ff c7 04 24 25 64 39 c1 e8 23 72 0c 00 <0f> 0b eb fe 90 8d 74 26 00 c7 04 24 d4 0e 38 c1 e8 0e 72 0c 00 
[  373.576194] EIP: [<c11eff07>] aoeblk_make_request+0x1b7/0x1d0 SS:ESP 0068:db7fcd84
[  373.776694] ---[ end trace 1449bb87303f798f ]---
[  373.783838] ------------[ cut here ]------------
[  373.791050] WARNING: at /usr/src/linux-2.6/kernel/exit.c:895 do_exit+0x5a7/0x630()
[  373.798475] Hardware name: TravelMate 660
[  373.805987] Modules linked in: squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs usb_storage loop nsc_ircc snd_intel8x0 irda ehci_hcd snd_ac97_codec ac97_bus uhci_hcd snd_pcm snd_timer usbcore snd snd_page_alloc i2c_i801 pcspkr crc_ccitt
[  373.823149] Pid: 2205, comm: umount Tainted: G      D    2.6.31-rc7 #2
[  373.831726] Call Trace:
[  373.840265]  [<c12b7142>] ? printk+0x18/0x1e
[  373.848886]  [<c1026847>] ? do_exit+0x5a7/0x630
[  373.857585]  [<c102371c>] warn_slowpath_common+0x6c/0xc0
[  373.866349]  [<c1026847>] ? do_exit+0x5a7/0x630
[  373.875122]  [<c1023785>] warn_slowpath_null+0x15/0x20
[  373.883949]  [<c1026847>] do_exit+0x5a7/0x630
[  373.892826]  [<c10034ca>] ? apic_timer_interrupt+0x2a/0x30
[  373.901834]  [<c12b7142>] ? printk+0x18/0x1e
[  373.910890]  [<c102364f>] ? oops_exit+0x2f/0x40
[  373.919964]  [<c10060d5>] oops_end+0x85/0x90
[  373.929114]  [<c1006250>] die+0x50/0x70
[  373.938284]  [<c10039a1>] do_trap+0x91/0xd0
[  373.947465]  [<c1003da0>] ? do_invalid_op+0x0/0xa0
[  373.956718]  [<c1003e27>] do_invalid_op+0x87/0xa0
[  373.965984]  [<c11eff07>] ? aoeblk_make_request+0x1b7/0x1d0
[  373.975343]  [<c12b8bee>] error_code+0x5e/0x64
[  373.984644]  [<c1003da0>] ? do_invalid_op+0x0/0xa0
[  373.993877]  [<c11eff07>] ? aoeblk_make_request+0x1b7/0x1d0
[  374.003202]  [<c10f2dcd>] generic_make_request+0x28d/0x360
[  374.012341]  [<c101f93e>] ? set_next_entity+0x2e/0x70
[  374.021191]  [<c12b7463>] ? schedule+0x203/0x340
[  374.029675]  [<c1050d8e>] ? mempool_alloc_slab+0xe/0x10
[  374.038047]  [<c1050d8e>] ? mempool_alloc_slab+0xe/0x10
[  374.046294]  [<c10f2ee2>] submit_bio+0x42/0xb0
[  374.054450]  [<c1096d2b>] ? bio_alloc_bioset+0x2b/0xe0
[  374.062617]  [<c10f5004>] blkdev_issue_flush+0x74/0xb0
[  374.070794]  [<e0c2a8cd>] xfs_blkdev_issue_flush+0xd/0x10 [xfs]
[  374.078994]  [<e0c23d8d>] xfs_free_buftarg+0x2d/0x60 [xfs]
[  374.087187]  [<e0c2a570>] xfs_close_devices+0x50/0x60 [xfs]
[  374.095304]  [<e0c2a601>] xfs_fs_put_super+0x81/0xc0 [xfs]
[  374.103296]  [<c107687b>] generic_shutdown_super+0x4b/0xd0
[  374.111242]  [<c1076925>] kill_block_super+0x25/0x40
[  374.119071]  [<c1076c37>] deactivate_super+0x37/0x50
[  374.126875]  [<c10897d0>] mntput_no_expire+0x50/0x60
[  374.134570]  [<c1089a4f>] sys_umount+0x4f/0x2d0
[  374.142222]  [<c1089ce7>] sys_oldumount+0x17/0x20
[  374.149826]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  374.157463] ---[ end trace 1449bb87303f7990 ]---

Note: after these a clean shutdown is no more possible as some tasks
of the shutdown process en up in D state (some lock around umount?)...

Bruno
