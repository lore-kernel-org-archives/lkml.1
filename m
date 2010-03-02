Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0CBGbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 01:31:37 -0500
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:43451 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751991Ab0CBGbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 01:31:36 -0500
Date: Tue, 2 Mar 2010 17:31:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Subject: BUG: spinlock lockup on task_rq_lock in 2.6.33
Message-ID: <20100302063132.GF18369@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

I just locked up a machine with the following trace:

[ 5247.149256] BUG: spinlock lockup on CPU#1, dd/7018, ffff8800059d4380
[ 5247.150009] BUG: spinlock lockup on CPU#0, dd/6211, ffff8800059d4380
[ 5247.150009] Pid: 6211, comm: dd Not tainted 2.6.33-dgc #86
[ 5247.150009] Call Trace:
[ 5247.150009]  [<ffffffff8140ad40>] do_raw_spin_lock+0x160/0x170
[ 5247.150009]  [<ffffffff8170fec6>] _raw_spin_lock+0x56/0x70
[ 5247.150009]  [<ffffffff8103d092>] ? task_rq_lock+0x52/0x90
[ 5247.150009]  [<ffffffff8103d092>] task_rq_lock+0x52/0x90
[ 5247.150009]  [<ffffffff81044a70>] try_to_wake_up+0x40/0x3d0
[ 5247.150009]  [<ffffffff81044e55>] wake_up_process+0x15/0x20
[ 5247.150009]  [<ffffffff8131f553>] xfsbufd_wakeup+0x53/0x90
[ 5247.150009]  [<ffffffff810e7928>] shrink_slab+0x88/0x180
[ 5247.150009]  [<ffffffff810e895b>] do_try_to_free_pages+0x1eb/0x350
[ 5247.150009]  [<ffffffff810e8c17>] try_to_free_pages+0x77/0x80
[ 5247.150009]  [<ffffffff810e5220>] ? isolate_pages_global+0x0/0x240
[ 5247.150009]  [<ffffffff810df553>] __alloc_pages_nodemask+0x413/0x750
[ 5247.150009]  [<ffffffff8110e28c>] alloc_pages_current+0x8c/0xe0
[ 5247.150009]  [<ffffffff810d98d7>] __page_cache_alloc+0x67/0x70
[ 5247.150009]  [<ffffffff810dab9f>] grab_cache_page_write_begin+0x7f/0xc0
[ 5247.150009]  [<ffffffff8107191b>] ? up_read+0x2b/0x40
[ 5247.150009]  [<ffffffff811496ec>] block_write_begin+0x8c/0xf0
[ 5247.150009]  [<ffffffff8131ca1a>] xfs_vm_write_begin+0x2a/0x30
[ 5247.150009]  [<ffffffff8131cd70>] ? xfs_get_blocks+0x0/0x20
[ 5247.150009]  [<ffffffff810d89ee>] generic_file_buffered_write+0x10e/0x250
[ 5247.150009]  [<ffffffff813249c5>] xfs_file_aio_write+0x845/0x8e0
[ 5247.150009]  [<ffffffff810822ad>] ? lock_release_holdtime+0x3d/0x210
[ 5247.150009]  [<ffffffff810850c0>] ? lock_release_non_nested+0x380/0x390
[ 5247.150009]  [<ffffffff8111d8b1>] do_sync_write+0xd1/0x120
[ 5247.150009]  [<ffffffff810f40d5>] ? might_fault+0xa5/0xb0
[ 5247.150009]  [<ffffffff810f408c>] ? might_fault+0x5c/0xb0
[ 5247.150009]  [<ffffffff813cae06>] ? security_file_permission+0x16/0x20
[ 5247.150009]  [<ffffffff8111ddeb>] vfs_write+0xcb/0x180
[ 5247.150009]  [<ffffffff8111df95>] sys_write+0x55/0x90
[ 5247.150009]  [<ffffffff8100301b>] system_call_fastpath+0x16/0x1b
[ 5247.150009] sending NMI to all CPUs:
[ 5247.149256] NMI backtrace for cpu 1
[ 5247.149256] CPU 1
[ 5247.149256] Pid: 7018, comm: dd Not tainted 2.6.33-dgc #86 MS-9166/IBM eServer 326m -[796955M]-
[ 5247.149256] RIP: 0010:[<ffffffff814f6646>]  [<ffffffff814f6646>] io_serial_in+0x16/0x20
[ 5247.149256] RSP: 0018:ffff8800ad9f15c8  EFLAGS: 00000002
[ 5247.149256] RAX: 0000000000000701 RBX: ffffffff82694c20 RCX: 0000000000000000
[ 5247.149256] RDX: 00000000000003fd RSI: 0000000000000005 RDI: ffffffff82694c20
[ 5247.149256] RBP: ffff8800ad9f15c8 R08: 00000000fc10a82b R09: 0000000000000001
[ 5247.149256] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[ 5247.149256] R13: 0000000000002707 R14: 0000000000000020 R15: ffffffff82694c20
[ 5247.149256] FS:  00007f41dc52e6f0(0000) GS:ffff880005800000(0000) knlGS:0000000000000000
[ 5247.149256] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 5247.149256] CR2: 000000000060d000 CR3: 0000000081e07000 CR4: 00000000000006e0
[ 5247.149256] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5247.149256] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5247.149256] Process dd (pid: 7018, threadinfo ffff88007a8f6000, task ffff880099bc93e0)
[ 5247.149256] Stack:
[ 5247.149256]  ffff8800ad9f15f8 ffffffff814f6cf3 ffffffff82694c20 000000000000002f
[ 5247.149256] <0> ffffffff81d46993 0000000000000048 ffff8800ad9f1618 ffffffff814f6d86
[ 5247.149256] <0> 0000000000000031 ffffffff814f6d60 ffff8800ad9f1658 ffffffff814f2a1c
[ 5247.149256] Call Trace:
[ 5247.149256] Code: 0f 1f 44 00 00 be 01 00 00 00 4c 89 c7 41 ff 50 50 c9 c3 66 90 55 48 89 e5 0f 1f 44 00 00 0f b6 4f 79 0f b7 57 40 d3 e
[ 5247.149256] Call Trace:
[ 5247.149256]  <#DB[1]>  <<EOE>> Pid: 7018, comm: dd Not tainted 2.6.33-dgc #86
[ 5247.149256] Call Trace:
[ 5247.149256]  <NMI>  [<ffffffff81001d9b>] ? show_regs+0x2b/0x40
[ 5247.149256]  [<ffffffff817125a5>] nmi_watchdog_tick+0x1b5/0x1e0
[ 5247.149256]  [<ffffffff817115e9>] do_nmi+0x1b9/0x2e0
[ 5247.149256]  [<ffffffff8171116a>] nmi+0x1a/0x2c
[ 5247.149256]  [<ffffffff814f6646>] ? io_serial_in+0x16/0x20
[ 5247.149256]  <<EOE>>
[ 5247.150009] NMI backtrace for cpu 0
[ 5247.150009] CPU 0
[ 5247.150009] Pid: 6211, comm: dd Not tainted 2.6.33-dgc #86 MS-9166/IBM eServer 326m -[796955M]-
[ 5247.150009] RIP: 0010:[<ffffffff8101fafc>]  [<ffffffff8101fafc>] arch_trigger_all_cpu_backtrace+0x5c/0x70
[ 5247.150009] RSP: 0018:ffff88008feab7a8  EFLAGS: 00000092
[ 5247.150009] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
[ 5247.150009] RDX: ffff8800b229cf80 RSI: 0000000000000001 RDI: ffffffff81023130
[ 5247.150009] RBP: ffff88008feab7b8 R08: 0000000000000002 R09: 0000000000000000
[ 5247.150009] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000076e30f00
[ 5247.150009] R13: 0000000076e30f00 R14: 0000000000000000 R15: ffff8800b229cf80
[ 5247.150009] FS:  00007ff7e6fc36f0(0000) GS:ffff880005600000(0000) knlGS:0000000000000000
[ 5247.150009] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 5247.150009] CR2: 000000000060d000 CR3: 0000000078af9000 CR4: 00000000000006f0
[ 5247.150009] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5247.150009] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5247.150009] Process dd (pid: 6211, threadinfo ffff88008feaa000, task ffff8800b229cf80)
[ 5247.150009] Stack:
[ 5247.150009]  ffff8800059d4380 ffff8800059d4380 ffff88008feab7f8 ffffffff8140ad45
[ 5247.150009] <0> ffff8800b229d440 ffff8800059d4380 ffff8800059d4398 ffff8800b7be8000
[ 5247.150009] <0> ffff88008feab888 0000000000000000 ffff88008feab828 ffffffff8170fec6
[ 5247.150009] Call Trace:
[ 5247.150009]  [<ffffffff8140ad45>] do_raw_spin_lock+0x165/0x170
[ 5247.150009]  [<ffffffff8170fec6>] _raw_spin_lock+0x56/0x70
[ 5247.150009]  [<ffffffff8103d092>] ? task_rq_lock+0x52/0x90
[ 5247.150009]  [<ffffffff8103d092>] task_rq_lock+0x52/0x90
[ 5247.150009]  [<ffffffff81044a70>] try_to_wake_up+0x40/0x3d0
[ 5247.150009]  [<ffffffff81044e55>] wake_up_process+0x15/0x20
[ 5247.150009]  [<ffffffff8131f553>] xfsbufd_wakeup+0x53/0x90
[ 5247.150009]  [<ffffffff810e7928>] shrink_slab+0x88/0x180
[ 5247.150009]  [<ffffffff810e895b>] do_try_to_free_pages+0x1eb/0x350
[ 5247.150009]  [<ffffffff810e8c17>] try_to_free_pages+0x77/0x80
[ 5247.150009]  [<ffffffff810e5220>] ? isolate_pages_global+0x0/0x240
[ 5247.150009]  [<ffffffff810df553>] __alloc_pages_nodemask+0x413/0x750
[ 5247.150009]  [<ffffffff8110e28c>] alloc_pages_current+0x8c/0xe0
[ 5247.150009]  [<ffffffff810d98d7>] __page_cache_alloc+0x67/0x70
[ 5247.150009]  [<ffffffff810dab9f>] grab_cache_page_write_begin+0x7f/0xc0
[ 5247.150009]  [<ffffffff8107191b>] ? up_read+0x2b/0x40
[ 5247.150009]  [<ffffffff811496ec>] block_write_begin+0x8c/0xf0
[ 5247.150009]  [<ffffffff8131ca1a>] xfs_vm_write_begin+0x2a/0x30
[ 5247.150009]  [<ffffffff8131cd70>] ? xfs_get_blocks+0x0/0x20
[ 5247.150009]  [<ffffffff810d89ee>] generic_file_buffered_write+0x10e/0x250
[ 5247.150009]  [<ffffffff813249c5>] xfs_file_aio_write+0x845/0x8e0
[ 5247.150009]  [<ffffffff810822ad>] ? lock_release_holdtime+0x3d/0x210
[ 5247.150009]  [<ffffffff810850c0>] ? lock_release_non_nested+0x380/0x390
[ 5247.150009]  [<ffffffff8111d8b1>] do_sync_write+0xd1/0x120
[ 5247.150009]  [<ffffffff810f40d5>] ? might_fault+0xa5/0xb0
[ 5247.150009]  [<ffffffff810f408c>] ? might_fault+0x5c/0xb0
[ 5247.150009]  [<ffffffff813cae06>] ? security_file_permission+0x16/0x20
[ 5247.150009]  [<ffffffff8111ddeb>] vfs_write+0xcb/0x180
[ 5247.150009]  [<ffffffff8111df95>] sys_write+0x55/0x90
[ 5247.150009]  [<ffffffff8100301b>] system_call_fastpath+0x16/0x1b
[ 5247.150009] Code: 05 ca 18 a4 00 bf 02 00 00 00 ff 90 f8 00 00 00 eb 19 0f 1f 44 00 00 bf 58 89 41 00 ff c3 e8 3c 5c 3e 00 81 fb 10 27 0
[ 5247.150009] Call Trace:
[ 5247.150009]  <#DB[1]>  <<EOE>> Pid: 6211, comm: dd Not tainted 2.6.33-dgc #86
[ 5247.150009] Call Trace:
[ 5247.150009]  <NMI>  [<ffffffff81001d9b>] ? show_regs+0x2b/0x40
[ 5247.150009]  [<ffffffff817125a5>] nmi_watchdog_tick+0x1b5/0x1e0
[ 5247.150009]  [<ffffffff817115e9>] do_nmi+0x1b9/0x2e0
[ 5247.150009]  [<ffffffff8171116a>] nmi+0x1a/0x2c
[ 5247.150009]  [<ffffffff81023130>] ? flat_send_IPI_all+0xc0/0xd0
[ 5247.150009]  [<ffffffff8101fafc>] ? arch_trigger_all_cpu_backtrace+0x5c/0x70
[ 5247.150009]  <<EOE>>  [<ffffffff8140ad45>] do_raw_spin_lock+0x165/0x170
[ 5247.150009]  [<ffffffff8170fec6>] _raw_spin_lock+0x56/0x70
[ 5247.150009]  [<ffffffff8103d092>] ? task_rq_lock+0x52/0x90
[ 5247.150009]  [<ffffffff8103d092>] task_rq_lock+0x52/0x90
[ 5247.150009]  [<ffffffff81044a70>] try_to_wake_up+0x40/0x3d0
[ 5247.150009]  [<ffffffff81044e55>] wake_up_process+0x15/0x20
[ 5247.150009]  [<ffffffff8131f553>] xfsbufd_wakeup+0x53/0x90
[ 5247.150009]  [<ffffffff810e7928>] shrink_slab+0x88/0x180
[ 5247.150009]  [<ffffffff810e895b>] do_try_to_free_pages+0x1eb/0x350
[ 5247.150009]  [<ffffffff810e8c17>] try_to_free_pages+0x77/0x80
[ 5247.150009]  [<ffffffff810e5220>] ? isolate_pages_global+0x0/0x240
[ 5247.150009]  [<ffffffff810df553>] __alloc_pages_nodemask+0x413/0x750
[ 5247.150009]  [<ffffffff8110e28c>] alloc_pages_current+0x8c/0xe0
[ 5247.150009]  [<ffffffff810d98d7>] __page_cache_alloc+0x67/0x70
[ 5247.150009]  [<ffffffff810dab9f>] grab_cache_page_write_begin+0x7f/0xc0
[ 5247.150009]  [<ffffffff8107191b>] ? up_read+0x2b/0x40
[ 5247.150009]  [<ffffffff811496ec>] block_write_begin+0x8c/0xf0
[ 5247.150009]  [<ffffffff8131ca1a>] xfs_vm_write_begin+0x2a/0x30
[ 5247.150009]  [<ffffffff8131cd70>] ? xfs_get_blocks+0x0/0x20
[ 5247.150009]  [<ffffffff810d89ee>] generic_file_buffered_write+0x10e/0x250
[ 5247.150009]  [<ffffffff813249c5>] xfs_file_aio_write+0x845/0x8e0
[ 5247.150009]  [<ffffffff810822ad>] ? lock_release_holdtime+0x3d/0x210
[ 5247.150009]  [<ffffffff810850c0>] ? lock_release_non_nested+0x380/0x390
[ 5247.150009]  [<ffffffff8111d8b1>] do_sync_write+0xd1/0x120
[ 5247.150009]  [<ffffffff810f40d5>] ? might_fault+0xa5/0xb0
[ 5247.150009]  [<ffffffff810f408c>] ? might_fault+0x5c/0xb0
[ 5247.150009]  [<ffffffff813cae06>] ? security_file_permission+0x16/0x20
[ 5247.150009]  [<ffffffff8111ddeb>] vfs_write+0xcb/0x180
[ 5247.150009]  [<ffffffff8111df95>] sys_write+0x55/0x90
[ 5247.150009]  [<ffffffff8100301b>] system_call_fastpath+0x16/0x1b
[ 5247.149256] Pid: 7018, comm: dd Not tainted 2.6.33-dgc #86
[ 5247.149256] Call Trace:
[ 5247.149256] sending NMI to all CPUs:
[ 5247.149256] NMI backtrace for cpu 1
[ 5247.149256] CPU 1
[ 5247.149256] Pid: 7018, comm: dd Not tainted 2.6.33-dgc #86 MS-9166/IBM eServer 326m -[796955M]-
[ 5247.149256] RIP: 0010:[<ffffffff8101fafc>]  [<ffffffff8101fafc>] arch_trigger_all_cpu_backtrace+0x5c/0x70
[ 5247.149256] RSP: 0018:ffff8800ad9f18b8  EFLAGS: 00000096
[ 5247.149256] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
[ 5247.149256] RDX: ffff880099bc93e0 RSI: 0000000000000001 RDI: ffffffff81023130
[ 5247.149256] RBP: ffff8800ad9f18c8 R08: 0000000000000002 R09: 0000000000000000
[ 5247.149256] R10: 0000000000000000 R11: 0000000000000006 R12: 0000000076e30f00
[ 5247.149256] R13: 0000000076e30f00 R14: 0000000000000000 R15: ffff880099bc93e0
[ 5247.149256] FS:  00007f41dc52e6f0(0000) GS:ffff880005800000(0000) knlGS:0000000000000000
[ 5247.149256] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 5247.149256] CR2: 000000000060d000 CR3: 0000000081e07000 CR4: 00000000000006e0
[ 5247.149256] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5247.149256] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5247.149256] Process dd (pid: 7018, threadinfo ffff88007a8f6000, task ffff880099bc93e0)
[ 5247.149256] Stack:
[ 5247.149256]  ffff8800059d4380 ffff8800059d4380 ffff8800ad9f1908 ffffffff8140ad45
[ 5247.149256] <0> ffff880099bc98a0 ffff8800059d4398 ffff8800059d4380 ffffffff818bc0a3
[ 5247.149256] <0> 0000000000000001 ffff8800b7be8390 ffff8800ad9f1938 ffffffff8170ffcd
[ 5247.149256] Call Trace:
[ 5247.149256] Code: 05 ca 18 a4 00 bf 02 00 00 00 ff 90 f8 00 00 00 eb 19 0f 1f 44 00 00 bf 58 89 41 00 ff c3 e8 3c 5c 3e 00 81 fb 10 27 0
[ 5247.149256] Call Trace:
[ 5247.149256]  <#DB[1]>  <<EOE>> Pid: 7018, comm: dd Not tainted 2.6.33-dgc #86
[ 5247.149256] Call Trace:
[ 5247.149256]  <NMI>  [<ffffffff81001d9b>] ? show_regs+0x2b/0x40
[ 5247.149256]  [<ffffffff817125a5>] nmi_watchdog_tick+0x1b5/0x1e0
[ 5247.149256]  [<ffffffff817115e9>] do_nmi+0x1b9/0x2e0
[ 5247.149256]  [<ffffffff8171116a>] nmi+0x1a/0x2c
[ 5247.149256]  [<ffffffff81023130>] ? flat_send_IPI_all+0xc0/0xd0
[ 5247.149256]  [<ffffffff8101fafc>] ? arch_trigger_all_cpu_backtrace+0x5c/0x70
[ 5247.149256]  <<EOE>>
[ 5247.150009] NMI backtrace for cpu 0
[ 5247.150009] CPU 0
[ 5247.150009] Pid: 6211, comm: dd Not tainted 2.6.33-dgc #86 MS-9166/IBM eServer 326m -[796955M]-
[ 5247.150009] RIP: 0010:[<ffffffff8140ace0>]  [<ffffffff8140ace0>] do_raw_spin_lock+0x100/0x170
[ 5247.150009] RSP: 0018:ffff88008feab7c8  EFLAGS: 00000002
[ 5247.150009] RAX: 000000000000001b RBX: ffff8800059d4380 RCX: 000000006cbb1f4e
[ 5247.150009] RDX: 00000000000009cb RSI: 0000000000000000 RDI: 0000000000000001
[ 5247.150009] RBP: ffff88008feab7f8 R08: 000000006cbb1f33 R09: 0000000000000000
[ 5247.150009] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000001960514
[ 5247.150009] R13: 0000000076e30f00 R14: 0000000000000000 R15: ffff8800b229cf80
[ 5247.150009] FS:  00007ff7e6fc36f0(0000) GS:ffff880005600000(0000) knlGS:0000000000000000
[ 5247.150009] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 5247.150009] CR2: 000000000060d000 CR3: 0000000078af9000 CR4: 00000000000006f0
[ 5247.150009] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5247.150009] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5247.150009] Process dd (pid: 6211, threadinfo ffff88008feaa000, task ffff8800b229cf80)
[ 5247.150009] Stack:
[ 5247.150009]  ffff8800b229d440 ffff8800059d4380 ffff8800059d4398 ffff8800b7be8000
[ 5247.150009] <0> ffff88008feab888 0000000000000000 ffff88008feab828 ffffffff8170fec6
[ 5247.150009] <0> ffffffff8103d092 0000000000000246 ffff8800059d4380 00000000001d4380
[ 5247.150009] Call Trace:
[ 5247.150009]  [<ffffffff8170fec6>] _raw_spin_lock+0x56/0x70
[ 5247.150009]  [<ffffffff8103d092>] ? task_rq_lock+0x52/0x90
[ 5247.150009]  [<ffffffff8103d092>] task_rq_lock+0x52/0x90
[ 5247.150009]  [<ffffffff81044a70>] try_to_wake_up+0x40/0x3d0
[ 5247.150009]  [<ffffffff81044e55>] wake_up_process+0x15/0x20
[ 5247.150009]  [<ffffffff8131f553>] xfsbufd_wakeup+0x53/0x90
[ 5247.150009]  [<ffffffff810e7928>] shrink_slab+0x88/0x180
[ 5247.150009]  [<ffffffff810e895b>] do_try_to_free_pages+0x1eb/0x350
[ 5247.150009]  [<ffffffff810e8c17>] try_to_free_pages+0x77/0x80
[ 5247.150009]  [<ffffffff810e5220>] ? isolate_pages_global+0x0/0x240
[ 5247.150009]  [<ffffffff810df553>] __alloc_pages_nodemask+0x413/0x750
[ 5247.150009]  [<ffffffff8110e28c>] alloc_pages_current+0x8c/0xe0
[ 5247.150009]  [<ffffffff810d98d7>] __page_cache_alloc+0x67/0x70
[ 5247.150009]  [<ffffffff810dab9f>] grab_cache_page_write_begin+0x7f/0xc0
[ 5247.150009]  [<ffffffff8107191b>] ? up_read+0x2b/0x40
[ 5247.150009]  [<ffffffff811496ec>] block_write_begin+0x8c/0xf0
[ 5247.150009]  [<ffffffff8131ca1a>] xfs_vm_write_begin+0x2a/0x30
[ 5247.150009]  [<ffffffff8131cd70>] ? xfs_get_blocks+0x0/0x20
[ 5247.150009]  [<ffffffff810d89ee>] generic_file_buffered_write+0x10e/0x250
[ 5247.150009]  [<ffffffff813249c5>] xfs_file_aio_write+0x845/0x8e0
[ 5247.150009]  [<ffffffff810822ad>] ? lock_release_holdtime+0x3d/0x210
[ 5247.150009]  [<ffffffff810850c0>] ? lock_release_non_nested+0x380/0x390
[ 5247.150009]  [<ffffffff8111d8b1>] do_sync_write+0xd1/0x120
[ 5247.150009]  [<ffffffff810f40d5>] ? might_fault+0xa5/0xb0
[ 5247.150009]  [<ffffffff810f408c>] ? might_fault+0x5c/0xb0
[ 5247.150009]  [<ffffffff813cae06>] ? security_file_permission+0x16/0x20
[ 5247.150009]  [<ffffffff8111ddeb>] vfs_write+0xcb/0x180
[ 5247.150009]  [<ffffffff8111df95>] sys_write+0x55/0x90
[ 5247.150009]  [<ffffffff8100301b>] system_call_fastpath+0x16/0x1b
[ 5247.150009] Code: 01 00 00 00 65 4c 8b 3c 25 40 b5 00 00 4c 69 e8 e8 03 00 00 49 8d 87 c0 04 00 00 48 89 45 d0 eb 07 66 90 45 85 f6 75 3
[ 5247.150009] Call Trace:
[ 5247.150009]  <#DB[1]>  <<EOE>> Pid: 6211, comm: dd Not tainted 2.6.33-dgc #86
[ 5247.150009] Call Trace:
[ 5247.150009]  <NMI>  [<ffffffff81001d9b>] ? show_regs+0x2b/0x40
[ 5247.150009]  [<ffffffff817125a5>] nmi_watchdog_tick+0x1b5/0x1e0
[ 5247.150009]  [<ffffffff817115e9>] do_nmi+0x1b9/0x2e0
[ 5247.150009]  [<ffffffff8171116a>] nmi+0x1a/0x2c
[ 5247.150009]  [<ffffffff8140ace0>] ? do_raw_spin_lock+0x100/0x170
[ 5247.150009]  <<EOE>>  [<ffffffff8170fec6>] _raw_spin_lock+0x56/0x70
[ 5247.150009]  [<ffffffff8103d092>] ? task_rq_lock+0x52/0x90
[ 5247.150009]  [<ffffffff8103d092>] task_rq_lock+0x52/0x90
[ 5247.150009]  [<ffffffff81044a70>] try_to_wake_up+0x40/0x3d0
[ 5247.150009]  [<ffffffff81044e55>] wake_up_process+0x15/0x20
[ 5247.150009]  [<ffffffff8131f553>] xfsbufd_wakeup+0x53/0x90
[ 5247.150009]  [<ffffffff810e7928>] shrink_slab+0x88/0x180
[ 5247.150009]  [<ffffffff810e895b>] do_try_to_free_pages+0x1eb/0x350
[ 5247.150009]  [<ffffffff810e8c17>] try_to_free_pages+0x77/0x80
[ 5247.150009]  [<ffffffff810e5220>] ? isolate_pages_global+0x0/0x240
[ 5247.150009]  [<ffffffff810df553>] __alloc_pages_nodemask+0x413/0x750
[ 5247.150009]  [<ffffffff8110e28c>] alloc_pages_current+0x8c/0xe0
[ 5247.150009]  [<ffffffff810d98d7>] __page_cache_alloc+0x67/0x70
[ 5247.150009]  [<ffffffff810dab9f>] grab_cache_page_write_begin+0x7f/0xc0
[ 5247.150009]  [<ffffffff8107191b>] ? up_read+0x2b/0x40
[ 5247.150009]  [<ffffffff811496ec>] block_write_begin+0x8c/0xf0
[ 5247.150009]  [<ffffffff8131ca1a>] xfs_vm_write_begin+0x2a/0x30
[ 5247.150009]  [<ffffffff8131cd70>] ? xfs_get_blocks+0x0/0x20
[ 5247.150009]  [<ffffffff810d89ee>] generic_file_buffered_write+0x10e/0x250
[ 5247.150009]  [<ffffffff813249c5>] xfs_file_aio_write+0x845/0x8e0
[ 5247.150009]  [<ffffffff810822ad>] ? lock_release_holdtime+0x3d/0x210
[ 5247.150009]  [<ffffffff810850c0>] ? lock_release_non_nested+0x380/0x390
[ 5247.150009]  [<ffffffff8111d8b1>] do_sync_write+0xd1/0x120
[ 5247.150009]  [<ffffffff810f40d5>] ? might_fault+0xa5/0xb0
[ 5247.150009]  [<ffffffff810f408c>] ? might_fault+0x5c/0xb0
[ 5247.150009]  [<ffffffff813cae06>] ? security_file_permission+0x16/0x20
[ 5247.150009]  [<ffffffff8111ddeb>] vfs_write+0xcb/0x180
[ 5247.150009]  [<ffffffff8111df95>] sys_write+0x55/0x90
[ 5247.150009]  [<ffffffff8100301b>] system_call_fastpath+0x16/0x1b


I was stressing some ENOSPC conditions on XFS when this happened
(as I've been doing all day). I was using the following test:

#!/bin/bash

for i in `seq 0 1 1000`; do
	(sleep 5; dd if=/dev/zero of=testfile.$i bs=4k ) &
done
wait

And an XFS filesystem only 1GB in size. The expected result is that the
dd's all eventually fail with ENOSPC, and this has been the case
when I've run the test with all 3GB of RAM available. I'd run this
about 50 times in a loop before I stopped it and reduced the amount
of available memory by using memlock.

The above hang occurred the first time I locked 2GB of RAM
with mlock and then ran the script. Before the entire 1GB of
filesystem space could be cached in the page cache (i.e. before
ENOSPC was hit), memory ran out and reclaim started. Then the
machine hung - no response at all until the above spinlock lockups
were detected.

I've tried to reproduce the BUG but haven't had much luck - I can
trigger long periods where the machine is completely unresponsive,
though. Doing "while [ true ]; do sleep 1; date; done" is showing
reproducable hangs of around 1-1.5minutes in length. e.g:

Tue Mar  2 17:14:08 EST 2010
Tue Mar  2 17:14:09 EST 2010
Tue Mar  2 17:14:10 EST 2010
Tue Mar  2 17:14:11 EST 2010
Tue Mar  2 17:14:12 EST 2010
Tue Mar  2 17:14:13 EST 2010
Tue Mar  2 17:14:14 EST 2010
Tue Mar  2 17:14:15 EST 2010
Tue Mar  2 17:14:16 EST 2010
Tue Mar  2 17:14:17 EST 2010    <=======
Tue Mar  2 17:15:11 EST 2010    <=======
Tue Mar  2 17:15:12 EST 2010
Tue Mar  2 17:15:14 EST 2010
Tue Mar  2 17:15:15 EST 2010
Tue Mar  2 17:15:16 EST 2010
.....
Tue Mar  2 17:27:18 EST 2010
Tue Mar  2 17:27:19 EST 2010
Tue Mar  2 17:27:20 EST 2010
Tue Mar  2 17:27:21 EST 2010
Tue Mar  2 17:27:23 EST 2010    <=======
Tue Mar  2 17:28:48 EST 2010    <=======
Tue Mar  2 17:28:50 EST 2010
Tue Mar  2 17:28:51 EST 2010
Tue Mar  2 17:28:52 EST 2010
Tue Mar  2 17:28:53 EST 2010

This does seem pretty reproducable (not 100% but at least 50%), and
it seems to require the filesystem to be near ENOSPC to trigger the
bad behaviour - if I increase the filesystem size to 30GB, then
everything is just fine.

Anyone got any ideas on how to track this down further?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
