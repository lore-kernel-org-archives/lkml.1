Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbXKSHXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbXKSHXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 02:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbXKSHXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 02:23:39 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:53585 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbXKSHXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 02:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ISqVK95F5em7HtKrshVB7XDjiwIX/OQjSIAbkc/ZNJK6aIpDDZ/IBnW1aAnaqxvIjAIil9qbgI+x2WGdvUTlMjH5hO/Si0NPv9WI9f81SJiD0aylVPZ70krrqyJXkx3t61B0B9IzgXUubys8KrbI94A0OTe7cnNgl/iePZ5Bd9Q=
Message-ID: <64bb37e0711182323v1e2a1341tfc7f20df771b988@mail.gmail.com>
Date: Mon, 19 Nov 2007 08:23:36 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc2-mm1: kcryptd vs lockdep
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trying the last NFSv4 patch (but that patch is only the cause, why I
had lockdep enabled) I got this:
[   64.550203]
[   64.550205] =========================
[   64.552213] [ BUG: held lock freed! ]
[   64.553633] -------------------------
[   64.555055] kcryptd/1022 is freeing memory
FFFF81011EBEFB00-FFFF81011EBEFB3F, with a lock still held there!
[   64.558809]  (kcryptd){--..}, at: [<ffffffff80247dd9>]
run_workqueue+0x129/0x210
[   64.561743] 2 locks held by kcryptd/1022:
[   64.563296]  #0:  (kcryptd){--..}, at: [<ffffffff80247dd9>]
run_workqueue+0x129/0x210
[   64.566409]  #1:  (&io->work#2){--..}, at: [<ffffffff80247dd9>]
run_workqueue+0x129/0x210
[   64.569672]
[   64.569672] stack backtrace:
[   64.571375]
[   64.571375] Call Trace:
[   64.572913]  [<ffffffff8025a5f0>] debug_check_no_locks_freed+0x190/0x1b0
[   64.575764]  [<ffffffff8026f192>] mempool_free_slab+0x12/0x20
[   64.577986]  [<ffffffff80296bb9>] kmem_cache_free+0x79/0xe0
[   64.580140]  [<ffffffff8026f192>] mempool_free_slab+0x12/0x20
[   64.582362]  [<ffffffff8026f22a>] mempool_free+0x8a/0xa0
[   64.584415]  [<ffffffff802c76af>] bio_free+0x2f/0x50
[   64.586337]  [<ffffffff802c76e0>] bio_fs_destructor+0x10/0x20
[   64.588558]  [<ffffffff802c7436>] bio_put+0x26/0x30
[   64.590446]  [<ffffffff803834d9>] xfs_buf_bio_end_io+0x99/0x120
[   64.592734]  [<ffffffff802c72a9>] bio_endio+0x19/0x40
[   64.594687]  [<ffffffff804e3827>] dec_pending+0x107/0x210
[   64.596775]  [<ffffffff804e3ae0>] clone_endio+0x70/0xb0
[   64.598793]  [<ffffffff804eb880>] kcryptd_do_crypt+0x0/0x290
[   64.600978]  [<ffffffff802c72a9>] bio_endio+0x19/0x40
[   64.602931]  [<ffffffff804eb382>] crypt_dec_pending+0x32/0x50
[   64.605149]  [<ffffffff804eb8e4>] kcryptd_do_crypt+0x64/0x290
[   64.607368]  [<ffffffff804eb880>] kcryptd_do_crypt+0x0/0x290
[   64.609553]  [<ffffffff804eb880>] kcryptd_do_crypt+0x0/0x290
[   64.611739]  [<ffffffff80247e25>] run_workqueue+0x175/0x210
[   64.613892]  [<ffffffff80248af1>] worker_thread+0x71/0xb0
[   64.615981]  [<ffffffff8024c830>] autoremove_wake_function+0x0/0x40
[   64.618402]  [<ffffffff80248a80>] worker_thread+0x0/0xb0
[   64.620454]  [<ffffffff8024c43d>] kthread+0x4d/0x80
[   64.622340]  [<ffffffff8020cbc8>] child_rip+0xa/0x12
[   64.624262]  [<ffffffff8020c2df>] restore_args+0x0/0x30
[   64.626281]  [<ffffffff8024c3f0>] kthread+0x0/0x80
[   64.628134]  [<ffffffff8020cbbe>] child_rip+0x0/0x12
[   64.630052]
[   64.630637] INFO: lockdep is turned off.

I only have only seen this once, booting the same kernel build a
second time, it did not happen again.
Also I got two other oopses when trying to shut the system down after
the above happend. So it might be possible that kcryptd only was the
victim of an other corruption, but then I don't know what subsystem
was to blame.

The other oopses:
[  108.613851] Unable to handle kernel paging request at 00000a6425203a72 RIP:
[  108.618485]  [<00000a6425203a72>]
[  108.624339] PGD 0
[  108.626416] Oops: 0010 [1] SMP
[  108.629657] last sysfs file:
/sys/devices/pci0000:00/0000:00:0f.0/0000:01:00.1/resource
[  108.637675] CPU 3
[  108.639749] Modules linked in: radeon drm nfsd exportfs ipv6 tuner
tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple mt20xx tea5761
tvaudio msp3400 bttv ir_common compat_ioctl32 videobuf_dma_sg
videobuf_core btcx_risc tveeprom videodev usbhid v4l2_common
v4l1_compat hid pata_amd sg
[  108.665913] Pid: 8715, comm: reboot Not tainted 2.6.24-rc2-mm1 #14
[  108.672103] RIP: 0010:[<00000a6425203a72>]  [<00000a6425203a72>]
[  108.678164] RSP: 0018:ffff81011d4a1e10  EFLAGS: 00010206
[  108.683491] RAX: 00000a6425203a72 RBX: ffffffff8077f9a0 RCX: 000000000000000a
[  108.690635] RDX: ffffffff8077fb40 RSI: 000000000000000a RDI: ffff81011ff0f870
[  108.697779] RBP: ffff81011d4a1e28 R08: 00000000000007d0 R09: 0000000000000001
[  108.704922] R10: ffffffff804bf40a R11: 2222222222222222 R12: 00000000fee1dead
[  108.712066] R13: 0000000001234567 R14: 0000000000000000 R15: 0000000000000001
[  108.719210] FS:  00007f217607f6f0(0000) GS:ffff81011ff11780(0000)
knlGS:0000000000000000
[  108.727312] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  108.733071] CR2: 00000a6425203a72 CR3: 000000011e182000 CR4: 00000000000006e0
[  108.740215] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  108.747358] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  108.754501] Process reboot (pid: 8715, threadinfo FFFF81011D4A0000,
task FFFF81011EC20EC0)
[  108.762776] Stack:  ffffffff8042c4ac ffff81011d4a1e28
0000000000000000 ffff81011d4a1e48
[  108.770993]  ffffffff802451ff 0000000028121969 0000000028121969
ffff81011d4a1f78
[  108.778561]  ffffffff802453d5 ffff81011f9ec078 ffff81011f97e780
ffff81011d4a1e88
[  108.785911] Call Trace:
[  108.788601]  [<ffffffff8042c4ac>] device_shutdown+0x4c/0xa0
[  108.794192]  [<ffffffff802451ff>] kernel_restart+0x2f/0x70
[  108.799696]  [<ffffffff802453d5>] sys_reboot+0x185/0x1d0
[  108.805028]  [<ffffffff802b0289>] d_free+0x49/0x50
[  108.809832]  [<ffffffff802b02e0>] d_kill+0x50/0x70
[  108.814641]  [<ffffffff802b6880>] mntput_no_expire+0x20/0xe0
[  108.820314]  [<ffffffff8029e2bd>] __fput+0x17d/0x230
[  108.825295]  [<ffffffff8029e726>] fput+0x16/0x20
[  108.829933]  [<ffffffff805cfe43>] trace_hardirqs_on_thunk+0x35/0x3a
[  108.836219]  [<ffffffff8020bc8e>] system_call+0x7e/0x83
[  108.841459]
[  108.842979] INFO: lockdep is turned off.
[  108.846922]
[  108.846922] Code:  Bad RIP value.
[  108.851852] RIP  [<00000a6425203a72>]
[  108.855570]  RSP <ffff81011d4a1e10>
[  108.859081] CR2: 00000a6425203a72
[  110.859331] md: stopping all md devices.
[  110.863297] md: md1 still in use.
[  111.865229] sd 8:0:1:0: [sdd] Synchronizing SCSI cache
[  112.064924] sd 2:0:0:0: [sdc] Synchronizing SCSI cache
[  112.066951] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
[  112.068961] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  112.071007] Unable to handle kernel paging request at 00000a6425203a72 RIP:
[  112.072794]  [<00000a6425203a72>]
[  112.075053] PGD 0
[  112.075857] Oops: 0010 [2] SMP
[  112.077111] last sysfs file:
/sys/devices/pci0000:00/0000:00:0f.0/0000:01:00.1/resource
[  112.080199] CPU 2
[  112.081003] Modules linked in: radeon drm nfsd exportfs ipv6 tuner
tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple mt20xx tea5761
tvaudio msp3400 bttv ir_common compat_ioctl32 videobuf_dma_sg
videobuf_core btcx_risc tveeprom videodev usbhid v4l2_common
v4l1_compat hid pata_amd sg
[  112.091136] Pid: 8716, comm: reboot Tainted: G      D 2.6.24-rc2-mm1 #14
[  112.093723] RIP: 0010:[<00000a6425203a72>]  [<00000a6425203a72>]
[  112.096060] RSP: 0018:ffff81011dc71e10  EFLAGS: 00010206
[  112.098113] RAX: 00000a6425203a72 RBX: ffffffff8077f9a0 RCX: 000000000000000a
[  112.100867] RDX: ffffffff8077fb40 RSI: 000000000000000a RDI: ffff81011ff0f870
[  112.103621] RBP: ffff81011dc71e28 R08: 0000000000000001 R09: 0000000000000001
[  112.106375] R10: ffffffff804bf40a R11: 2222222222222222 R12: 00000000fee1dead
[  112.109126] R13: 0000000001234567 R14: 0000000000000000 R15: 0000000000000000
[  112.111881] FS:  00007fe4ba0c96f0(0000) GS:ffff81011ff11300(0000)
knlGS:0000000000000000
[  112.115000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  112.117218] CR2: 00000a6425203a72 CR3: 000000011e405000 CR4: 00000000000006e0
[  112.119972] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  112.122727] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  112.125481] Process reboot (pid: 8716, threadinfo FFFF81011DC70000,
task FFFF81011EC20000)
[  112.128666] Stack:  ffffffff8042c4ac ffff81011dc71e28
0000000000000000 ffff81011dc71e48
[  112.131846]  ffffffff802451ff 0000000028121969 0000000028121969
ffff81011dc71f78
[  112.134774]  ffffffff802453d5 ffff81011dc71f48 0000000000000001
ffff81011dc71f28
[  112.137614] Call Trace:
[  112.138657]  [<ffffffff8042c4ac>] device_shutdown+0x4c/0xa0
[  112.140814]  [<ffffffff802451ff>] kernel_restart+0x2f/0x70
[  112.142934]  [<ffffffff802453d5>] sys_reboot+0x185/0x1d0
[  112.144990]  [<ffffffff8024fcf2>] hrtimer_nanosleep+0x72/0x130
[  112.147244]  [<ffffffff8024f470>] hrtimer_wakeup+0x0/0x30
[  112.149331]  [<ffffffff805cf137>] do_nanosleep+0x57/0x90
[  112.151386]  [<ffffffff80240e36>] sigprocmask+0x86/0xf0
[  112.153409]  [<ffffffff805cfe43>] trace_hardirqs_on_thunk+0x35/0x3a
[  112.155830]  [<ffffffff8024f97c>] lock_hrtimer_base+0x2c/0x60
[  112.158052]  [<ffffffff8020bc8e>] system_call+0x7e/0x83
[  112.160074]
[  112.160662] INFO: lockdep is turned off.
[  112.162181]
[  112.162182] Code:  Bad RIP value.
[  112.164090] RIP  [<00000a6425203a72>]
[  112.165528]  RSP <ffff81011dc71e10>
[  112.166881] CR2: 00000a6425203a72
[  128.836239] SysRq : Resetting

I had never seen this oops at shutdown before...
Torsten
