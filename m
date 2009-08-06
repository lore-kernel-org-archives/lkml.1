Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbZHFGZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbZHFGZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 02:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZHFGZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 02:25:50 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:41439 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753890AbZHFGZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 02:25:49 -0400
X-IronPort-AV: E=Sophos;i="4.43,331,1246831200"; 
   d="scan'208";a="30838049"
Message-ID: <4A7A7778.7000000@inria.fr>
Date: Thu, 06 Aug 2009 08:26:00 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [perf/rc5] oops running perf record -s with multiple -e
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo

I finally managed to test the threaded perfcounter statistics (thanks a
lot for implementing it). I am running 2.6.31-rc5 (with the AMD
magny-cours patches but I don't think they matter here). I am trying to
measure local/remote memory accesses per thread during the well-known
stream benchmark. It's compiled with OpenMP using 16 threads on a
quad-socket quad-core barcelona machine.

Command line is:
 /mnt/scratch/bgoglin/cpunode/linux-2.6.31/tools/perf/perf record -f -s
-e r1000001e0 -e r1000002e0 -e r1000004e0 -e r1000008e0 ./stream

It seems to work fine with a single -e <counter> on the command line
while it crashes when there are at least 2 of them.
It seems to work fine without -s as well.

Here's the oops:

[   45.837033] BUG: unable to handle kernel paging request at 0000000000001c0c
[   45.848148] IP: [<ffffffff8109cc6d>] put_ctx+0x10/0x5b
[   45.856140] PGD 3f583f067 PUD 436599067 PMD 0 
[   45.856140] Oops: 0002 [#1] SMP 
[   45.856140] last sysfs file: /sys/devices/pci0000:08/0000:08:02.0/0000:0a:03.1/class
[   45.856140] CPU 0 
[   45.856140] Modules linked in: nfs lockd nfs_acl auth_rpcgss sunrpc autofs4 dm_snapshot dm_mirror dm_region_hash dm_log dm_mod loop i2c_nforce2 sg shpchp i2c_core pcspkr processor joydev evdev sr_mod serio_raw pci_hotplug amd64_edac_mod edac_core ext3 jbd mbcache ide_cd_mod sd_mod cdrom ata_generic usbhid hid usb_storage sata_nv libata ohci_hcd e1000 scsi_mod amd74xx ide_pci_generic ehci_hcd ide_core floppy thermal fan thermal_sys
[   45.856140] Pid: 4687, comm: stream Not tainted 2.6.31-rc5-cpunode #1 H8QM8
[   45.856140] RIP: 0010:[<ffffffff8109cc6d>]  [<ffffffff8109cc6d>] put_ctx+0x10/0x5b
[   45.856140] RSP: 0000:ffff8801f1543c78  EFLAGS: 00010096
[   45.856140] RAX: 0000000000001c0c RBX: 0000000000001bb4 RCX: 0000fffffffe8910
[   45.856140] RDX: 0000000000000000 RSI: ffffc9000000fa00 RDI: 0000000000001bb4
[   45.856140] RBP: ffff8801f1543c88 R08: 0000000000000000 R09: ffff8801f0942a80
[   45.856140] R10: ffff8801f1543cc8 R11: ffff8801f0942a80 R12: ffff8801f0942a80
[   45.856140] R13: ffff8801f0942a80 R14: ffff8801f240c600 R15: ffff8801f0942a80
[   45.856140] FS:  00007f3af2e27950(0000) GS:ffffc90000000000(0000) knlGS:00000000f7427b90
[   45.856140] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   45.856140] CR2: 0000000000001c0c CR3: 0000000436187000 CR4: 00000000000006f0
[   45.856140] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   45.856140] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   45.856140] Process stream (pid: 4687, threadinfo ffff8801f1542000, task ffff8801f0942a80)
[   45.856140] Stack:
[   45.856140]  ffff8801f1543cc8 0000000000000286 ffff8801f1543d68 ffffffff8109e832
[   45.856140] <0> 0000000000000000 ffffffff81065d7a ffff8801f1543d08 0000000000000000
[   45.856140] <0> ffffffffffffffe0 0000000081086c01 0000000000000000 ffff8801f0942a80
[   45.856140] Call Trace:
[   45.856140]  [<ffffffff8109e832>] perf_counter_exit_task+0x66/0x33d
[   45.856140]  [<ffffffff81065d7a>] ? exit_robust_list+0x61/0x113
[   45.856140]  [<ffffffff8116ca07>] ? __up_read+0x92/0x9b
[   45.856140]  [<ffffffff8104708c>] do_exit+0x264/0x6d1
[   45.856140]  [<ffffffff8109b2a2>] ? counter_sched_in+0x2f/0x9c
[   45.856140]  [<ffffffff81047571>] do_group_exit+0x78/0xa5
[   45.856140]  [<ffffffff810518ec>] get_signal_to_deliver+0x306/0x32a
[   45.856140]  [<ffffffff8109c587>] ? __perf_counter_sched_in+0x1d2/0x1e2
[   45.856140]  [<ffffffff8100b010>] do_notify_resume+0x8c/0x6f8
[   45.856140]  [<ffffffff8103d0fd>] ? finish_task_switch+0x5d/0xf3
[   45.856140]  [<ffffffff8127fe42>] ? thread_return+0x3e/0xc4
[   45.856140]  [<ffffffff8102a418>] ? do_page_fault+0x230/0x262
[   45.856140]  [<ffffffff8100c61c>] retint_signal+0x48/0x8c
[   45.856140] Code: 81 74 0c 48 c7 c6 46 77 07 81 e8 fd d7 0c 00 48 89 df e8 67 0d 03 00 59 5b c9 c3 55 48 8d 47 58 48 89 e5 53 48 89 fb 48 83 ec 08 <f0> ff 08 0f 94 c2 84 d2 74 3d 48 8b 7f 78 48 85 ff 74 05 e8 d8 
[   45.856140] RIP  [<ffffffff8109cc6d>] put_ctx+0x10/0x5b
[   45.856140]  RSP <ffff8801f1543c78>
[   45.856140] CR2: 0000000000001c0c
[   45.856140] ---[ end trace 565ba3def8994fce ]---
[   45.840501] BUG: unable to handle kernel NULL pointer dereference at 0000000000000926
[   45.840501] IP: [<ffffffff8109cc6d>] put_ctx+0x10/0x5b
[   45.840501] PGD 3f583f067 PUD 436599067 PMD 0 
[   45.840501] Oops: 0002 [#2] SMP 
[   45.840501] last sysfs file: /sys/devices/pci0000:08/0000:08:02.0/0000:0a:03.1/class
[   45.840501] CPU 4 
[   45.840501] Modules linked in: nfs lockd nfs_acl auth_rpcgss sunrpc autofs4 dm_snapshot dm_mirror dm_region_hash dm_log dm_mod loop i2c_nforce2 sg shpchp i2c_core pcspkr processor joydev evdev sr_mod serio_raw pci_hotplug amd64_edac_mod edac_core ext3 jbd mbcache ide_cd_mod sd_mod cdrom ata_generic usbhid hid usb_storage sata_nv libata ohci_hcd e1000 scsi_mod amd74xx ide_pci_generic ehci_hcd ide_core floppy thermal fan thermal_sys
[   45.840501] Pid: 4690, comm: stream Tainted: G      D    2.6.31-rc5-cpunode #1 H8QM8
[   45.840501] RIP: 0010:[<ffffffff8109cc6d>]  [<ffffffff8109cc6d>] put_ctx+0x10/0x5b
[   45.840501] RSP: 0000:ffff8803f593dc78  EFLAGS: 00010096
[   45.840501] RAX: 0000000000000926 RBX: 00000000000008ce RCX: 0000fffffffe8e10
[   45.840501] RDX: 0000000000000000 RSI: ffffc9000080fa00 RDI: 00000000000008ce
[   45.840501] RBP: ffff8803f593dc88 R08: 0000000000000000 R09: ffff88043725a480
[   45.840501] R10: ffff8803f593dcc8 R11: ffff88043725a480 R12: ffff88043725a480
[   45.840501] R13: ffff88043725a480 R14: ffff8801f240c180 R15: ffff88043725a480
[   45.840501] FS:  00007f3af1624950(0000) GS:ffffc90000800000(0000) knlGS:0000000000000000
[   45.840501] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   45.840501] CR2: 0000000000000926 CR3: 0000000436187000 CR4: 00000000000006e0
[   45.840501] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   45.840501] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   45.840501] Process stream (pid: 4690, threadinfo ffff8803f593c000, task ffff88043725a480)
[   45.840501] Stack:
[   45.840501]  ffff8803f593dcc8 0000000000000282 ffff8803f593dd68 ffffffff8109e832
[   45.840501] <0> 0000000100000000 ffffffff81065d7a ffff8803f593dd08 0000000000000000
[   45.840501] <0> ffffffffffffffe0 0000000081086c01 0000000000000000 ffff88043725a480
[   45.840501] Call Trace:
[   45.840501]  [<ffffffff8109e832>] perf_counter_exit_task+0x66/0x33d
[   45.840501]  [<ffffffff81065d7a>] ? exit_robust_list+0x61/0x113
[   45.840501]  [<ffffffff8116ca07>] ? __up_read+0x92/0x9b
[   45.840501]  [<ffffffff8104708c>] do_exit+0x264/0x6d1
[   45.840501]  [<ffffffff8109b2a2>] ? counter_sched_in+0x2f/0x9c
[   45.840501]  [<ffffffff81047571>] do_group_exit+0x78/0xa5
[   45.840501]  [<ffffffff810518ec>] get_signal_to_deliver+0x306/0x32a
[   45.840501]  [<ffffffff8109c587>] ? __perf_counter_sched_in+0x1d2/0x1e2
[   45.840501]  [<ffffffff8100b010>] do_notify_resume+0x8c/0x6f8
[   45.840501]  [<ffffffff8103d0fd>] ? finish_task_switch+0x5d/0xf3
[   45.840501]  [<ffffffff8127fe42>] ? thread_return+0x3e/0xc4
[   45.840501]  [<ffffffff8116ca07>] ? __up_read+0x92/0x9b
[   45.840501]  [<ffffffff8102a418>] ? do_page_fault+0x230/0x262
[   45.840501]  [<ffffffff8100c61c>] retint_signal+0x48/0x8c
[   45.840501] Code: 81 74 0c 48 c7 c6 46 77 07 81 e8 fd d7 0c 00 48 89 df e8 67 0d 03 00 59 5b c9 c3 55 48 8d 47 58 48 89 e5 53 48 89 fb 48 83 ec 08 <f0> ff 08 0f 94 c2 84 d2 74 3d 48 8b 7f 78 48 85 ff 74 05 e8 d8 
[   45.840501] RIP  [<ffffffff8109cc6d>] put_ctx+0x10/0x5b
[   45.840501]  RSP <ffff8803f593dc78>
[   45.840501] CR2: 0000000000000926
[   45.840501] ---[ end trace 565ba3def8994fcf ]---
[   45.840501] Fixing recursive fault but reboot is needed!
[   45.856140] Fixing recursive fault but reboot is needed!
[   47.111224] BUG: unable to handle kernel NULL pointer dereference at 0000000000000779
[   47.115182] IP: [<ffffffff8109cc6d>] put_ctx+0x10/0x5b
[   47.115182] PGD 0 
[   47.115182] Oops: 0002 [#3] SMP 
[   47.115182] last sysfs file: /sys/devices/pci0000:08/0000:08:02.0/0000:0a:03.1/class
[   47.115182] CPU 9 
[   47.115182] Modules linked in: nfs lockd nfs_acl auth_rpcgss sunrpc autofs4 dm_snapshot dm_mirror dm_region_hash dm_log dm_mod loop i2c_nforce2 sg shpchp i2c_core pcspkr processor joydev evdev sr_mod serio_raw pci_hotplug amd64_edac_mod edac_core ext3 jbd mbcache ide_cd_mod sd_mod cdrom ata_generic usbhid hid usb_storage sata_nv libata ohci_hcd e1000 scsi_mod amd74xx ide_pci_generic ehci_hcd ide_core floppy thermal fan thermal_sys
[   47.115182] Pid: 4693, comm: stream Tainted: G      D    2.6.31-rc5-cpunode #1 H8QM8
[   47.115182] RIP: 0010:[<ffffffff8109cc6d>]  [<ffffffff8109cc6d>] put_ctx+0x10/0x5b
[   47.115182] RSP: 0000:ffff8805f593fc78  EFLAGS: 00010096
[   47.115182] RAX: 0000000000000779 RBX: 0000000000000721 RCX: 0000fffffffeae10
[   47.115182] RDX: 0000000000000000 RSI: ffffc9000120fa00 RDI: 0000000000000721
[   47.115182] RBP: ffff8805f593fc88 R08: 0000000000000000 R09: ffff8805f5d67780
[   47.115182] R10: ffff8805f593fc98 R11: ffff8805f5d67780 R12: ffff8805f5d67780
[   47.115182] R13: ffff8805f5d67780 R14: ffff8804364058c0 R15: ffff8805f5d67780
[   47.115182] FS:  00007f3aefe21950(0000) GS:ffffc90001200000(0000) knlGS:00000000f688bb90
[   47.115182] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   47.115182] CR2: 0000000000000779 CR3: 0000000001001000 CR4: 00000000000006e0
[   47.115182] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   47.115182] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   47.115182] Process stream (pid: 4693, threadinfo ffff8805f593e000, task ffff8805f5d67780)
[   47.115182] Stack:
[   47.115182]  ffff8805f593fc98 0000000000000286 ffff8805f593fd68 ffffffff8109e832
[   47.115182] <0> ffff8805f593fcc8 ffff8801f60edc00 0000000000000000 ffff8801f639a180
[   47.115182] <0> ffff8805f593fd18 0000000000000292 ffff8805f593fcf8 ffff8802370aa900
[   47.115182] Call Trace:
[   47.115182]  [<ffffffff8109e832>] perf_counter_exit_task+0x66/0x33d
[   47.115182]  [<ffffffff810f207a>] ? free_fs_struct+0x2d/0x31
[   47.115182]  [<ffffffff8104708c>] do_exit+0x264/0x6d1
[   47.115182]  [<ffffffff81047571>] do_group_exit+0x78/0xa5
[   47.115182]  [<ffffffff810518ec>] get_signal_to_deliver+0x306/0x32a
[   47.115182]  [<ffffffff8109c587>] ? __perf_counter_sched_in+0x1d2/0x1e2
[   47.115182]  [<ffffffff8100b010>] do_notify_resume+0x8c/0x6f8
[   47.115182]  [<ffffffff8103d0fd>] ? finish_task_switch+0x5d/0xf3
[   47.115182]  [<ffffffff8127fe42>] ? thread_return+0x3e/0xc4
[   47.115182]  [<ffffffff8106780f>] ? sys_futex+0x10e/0x12c
[   47.115182]  [<ffffffff8102a418>] ? do_page_fault+0x230/0x262
[   47.115182]  [<ffffffff8100c61c>] retint_signal+0x48/0x8c
[   47.115182] Code: 81 74 0c 48 c7 c6 46 77 07 81 e8 fd d7 0c 00 48 89 df e8 67 0d 03 00 59 5b c9 c3 55 48 8d 47 58 48 89 e5 53 48 89 fb 48 83 ec 08 <f0> ff 08 0f 94 c2 84 d2 74 3d 48 8b 7f 78 48 85 ff 74 05 e8 d8 
[   47.115182] RIP  [<ffffffff8109cc6d>] put_ctx+0x10/0x5b
[   47.115182]  RSP <ffff8805f593fc78>
[   47.115182] CR2: 0000000000000779
[   47.115182] ---[ end trace 565ba3def8994fd0 ]---
[   47.115182] Fixing recursive fault but reboot is needed!


