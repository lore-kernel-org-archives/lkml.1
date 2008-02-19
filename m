Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbYBSQp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbYBSQp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 11:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbYBSQps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 11:45:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57424 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbYBSQpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:45:46 -0500
Date: Tue, 19 Feb 2008 17:45:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: Linux 2.6.25-rc2
Message-ID: <20080219164525.GA4396@elte.hu>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com> <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com> <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com> <20080219140230.GA32236@Krystal> <84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com> <84144f020802190638i4a364d19o8986a457e76ec187@mail.gmail.com> <alpine.LFD.1.00.0802190806330.7833@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802190806330.7833@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So:
>  - it might be something else entirely
>  - it might still be the local cmpxchg, just Torsten didn't happen to 
>    notice it until later.
>  - it might still be the local cmpxchg, but something else changed its 
>    patterns to actually make it start triggering.
> 
> and in general I don't think we should revert it unless we have 
> stronger indications that it really is the problem (eg somebody finds 
> the actual bug, or a reporter can confirm that it goes away when the 
> local cmpxchg optimization is disabled).

yeah - my revert suggestions were all completely conditional on such 
type of test feedback.

Btw., i did trigger occasional SLUB crashes myself starting at around 
-rc1, on the order of one per 200-300 straight random bootups, and 
yesterday i did a 50-bootups series of a specific .config that crashed, 
to try to reproduce one of them but failed - so bisection was not an 
option and i had nothing concrete and repeatable to report either. I had 
a few complete lockups and only 3 usable backtraces - find them below.

Networking features in all of the backtraces - and so does the VFS. All 
of the crashes are on SMP - and given that 50% of the bootups are UP 
this gives us a 1:8 chance hint that this bug is SMP specific. (All the 
crashes are in distccd - that is what this build cluster does mainly so 
it's the main activity of the box - so they dont necessarily indicate 
anything workload specific.)

Earlier today i turned off local-cmpxchg and havent had a crash or hang 
since then - but at 200 bootups and 4-5 crashes in a week that's not 
conclusive yet. I think others might have workloads that trigger this 
bug more often.

	Ingo

---------------->
mercury login: [  582.671916] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[  582.672334] 
[  582.672334] Pid: 3776, comm: distccd Not tainted (2.6.25-rc2 #5)
[  582.672334] EIP: 0060:[<c0174fda>] EFLAGS: 00010246 CPU: 0
[  582.672334] EIP is at kmem_cache_alloc+0x2a/0x90
[  582.672334] EAX: 00000000 EBX: 8000061c ECX: c069ed1c EDX: 01060002
[  582.672334] ESI: c0aeffc8 EDI: c1d11714 EBP: f6eddcdc ESP: f6eddcc4
[  582.672334]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  582.672334] Process distccd (pid: 3776, ti=f6edc000 task=f508c000 task.ti=f6edc000)
[  582.672334] Stack: c06a3d48 f6eddce4 00000020 8000061c 0000066c c0aeffc8 f6eddcf8 c069ed1c 
[  582.672334]        00000000 00000020 8000061c f7ce6580 f7ce6580 f6eddd18 c045e7bb ffffffff 
[  582.672334]        00000000 f7f683e0 8000061c f52136c0 f7ce6580 f6eddd58 c0461de5 f508c000 
[  582.672334] Call Trace:
[  582.672334]  [<c06a3d48>] ? netif_receive_skb+0x2a8/0x320
[  582.672334]  [<c069ed1c>] ? __alloc_skb+0x2c/0x110
[  582.672334]  [<c045e7bb>] ? nv_alloc_rx_optimized+0x10b/0x1a0
[  582.672334]  [<c0461de5>] ? nv_napi_poll+0x1b5/0x730
[  582.672334]  [<c06a62cb>] ? net_rx_action+0x16b/0x200
[  582.672334]  [<c06a61e8>] ? net_rx_action+0x88/0x200
[  582.672334]  [<c012d713>] ? __do_softirq+0x93/0x120
[  582.672334]  [<c012d7f7>] ? do_softirq+0x57/0x60
[  582.672334]  [<c012dcc9>] ? irq_exit+0x69/0x80
[  582.672334]  [<c0106325>] ? do_IRQ+0x45/0x80
[  582.672334]  [<c018a2a2>] ? d_instantiate+0x42/0x60
[  582.672334]  [<c0103fd8>] ? common_interrupt+0x28/0x30
[  582.672334]  [<c018a2a2>] ? d_instantiate+0x42/0x60
[  582.672334]  [<c0149e50>] ? lock_release+0xc0/0x1b0
[  582.672334]  [<c07d0816>] ? _spin_unlock+0x16/0x20
[  582.672334]  [<c018a2a2>] ? d_instantiate+0x42/0x60
[  582.672334]  [<c0202a84>] ? ext3_add_nondir+0x34/0x50
[  582.672334]  [<c0202fde>] ? ext3_create+0x9e/0xe0
[  582.672334]  [<c0181498>] ? vfs_create+0xb8/0x100
[  582.672334]  [<c01838c0>] ? open_namei+0x4d0/0x5a0
[  582.672334]  [<c0136346>] ? in_group_p+0x26/0x30
[  582.672334]  [<c020cd40>] ? ext3_permission+0x0/0x10
[  582.672334]  [<c01770c1>] ? do_filp_open+0x31/0x50
[  582.672334]  [<c07d081d>] ? _spin_unlock+0x1d/0x20
[  582.672334]  [<c0176e1b>] ? get_unused_fd_flags+0xbb/0xe0
[  582.672334]  [<c017712d>] ? do_sys_open+0x4d/0xf0
[  582.672334]  [<c0327894>] ? trace_hardirqs_on_thunk+0xc/0x10
[  582.672334]  [<c014869d>] ? trace_hardirqs_on_caller+0xbd/0x140
[  582.672334]  [<c017720c>] ? sys_open+0x1c/0x20
[  582.672334]  [<c0102fc6>] ? sysenter_past_esp+0x5f/0x99
[  582.672334]  =======================
[  582.672334] Code: c3 55 89 e5 57 56 89 c6 53 83 ec 0c 8b 4d 04 89 55 f0 64 a1 04 40 b7 c0 8b 7c 86 64 90 8d 74 26 00 8b 17 f6 c2 01 75 41 8b 47 0c <8b> 1c 82 89 d0 0f b1 1f 39 d0 89 c3 75 e8 66 83 7d f0 00 79 1f 
[  582.672334] EIP: [<c0174fda>] kmem_cache_alloc+0x2a/0x90 SS:ESP 0068:f6eddcc4
[  582.672343] Kernel panic - not syncing: Fatal exception in interrupt
[  582.673337] Pid: 3776, comm: distccd Tainted: G      D  2.6.25-rc2 #5
[  582.674342]  [<c0128516>] panic+0x46/0x120
[  582.676335]  [<c0104be4>] die+0x134/0x150
[  582.678335]  [<c01182a8>] do_page_fault+0x188/0x610
[  582.680335]  [<c06c6016>] ? ip_local_deliver+0xf6/0x1c0
[  582.682335]  [<c0118120>] ? do_page_fault+0x0/0x610
[  582.685334]  [<c07d0f82>] error_code+0x72/0x80
[  582.687334]  [<c069ed1c>] ? __alloc_skb+0x2c/0x110
[  582.689334]  [<c0174fda>] ? kmem_cache_alloc+0x2a/0x90
[  582.691333]  [<c06a3d48>] ? netif_receive_skb+0x2a8/0x320
[  582.693333]  [<c069ed1c>] __alloc_skb+0x2c/0x110
[  582.695333]  [<c045e7bb>] nv_alloc_rx_optimized+0x10b/0x1a0
[  582.697332]  [<c0461de5>] nv_napi_poll+0x1b5/0x730
[  582.699332]  [<c06a62cb>] net_rx_action+0x16b/0x200
[  582.701332]  [<c06a61e8>] ? net_rx_action+0x88/0x200
[  582.703331]  [<c012d713>] __do_softirq+0x93/0x120
[  582.705331]  [<c012d7f7>] do_softirq+0x57/0x60
[  582.707331]  [<c012dcc9>] irq_exit+0x69/0x80
[  582.709330]  [<c0106325>] do_IRQ+0x45/0x80
[  582.711330]  [<c018a2a2>] ? d_instantiate+0x42/0x60
[  582.713330]  [<c0103fd8>] common_interrupt+0x28/0x30
[  582.715336]  [<c018a2a2>] ? d_instantiate+0x42/0x60
[  582.717329]  [<c0149e50>] ? lock_release+0xc0/0x1b0
[  582.719335]  [<c07d0816>] _spin_unlock+0x16/0x20
[  582.721329]  [<c018a2a2>] d_instantiate+0x42/0x60
[  582.723335]  [<c0202a84>] ext3_add_nondir+0x34/0x50
[  582.725328]  [<c0202fde>] ext3_create+0x9e/0xe0
[  582.727334]  [<c0181498>] vfs_create+0xb8/0x100
[  582.729327]  [<c01838c0>] open_namei+0x4d0/0x5a0
[  582.731333]  [<c0136346>] ? in_group_p+0x26/0x30
[  582.733327]  [<c020cd40>] ? ext3_permission+0x0/0x10
[  582.735333]  [<c01770c1>] do_filp_open+0x31/0x50
[  582.737326]  [<c07d081d>] ? _spin_unlock+0x1d/0x20
[  582.740332]  [<c0176e1b>] ? get_unused_fd_flags+0xbb/0xe0
[  582.743325]  [<c017712d>] do_sys_open+0x4d/0xf0
[  582.745331]  [<c0327894>] ? trace_hardirqs_on_thunk+0xc/0x10
[  582.747325]  [<c014869d>] ? trace_hardirqs_on_caller+0xbd/0x140
[  582.750330]  [<c017720c>] sys_open+0x1c/0x20
[  582.752324]  [<c0102fc6>] sysenter_past_esp+0x5f/0x99
[  582.754330]  =======================
[  582.755327] Rebooting in 10 seconds..Press any key to enter the menu

..............

Kernel 2.6.25-rc1 on an i686

mercury login: [   96.080075] Oops: 0000 [#1] SMP 
[   96.083484] Modules linked in:
[   96.086680] 
[   96.088225] Pid: 3414, comm: distccd Not tainted (2.6.25-rc1 #640)
[   96.090000] EIP: 0060:[<8015a5fc>] EFLAGS: 00010246 CPU: 0
[   96.090000] EIP is at kmem_cache_alloc+0x3a/0x78
[   96.090000] EAX: 00000000 EBX: 00000110 ECX: 8056aaae EDX: 01060002
[   96.090000] ESI: 808e6de8 EDI: 819071a4 EBP: 9f13dd20 ESP: 9f13dd10
[   96.090000]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   96.090000] Process distccd (pid: 3414, ti=9f13c000 task=9f0eae00 task.ti=9f13c000)
[   96.090000] Stack: 00000020 00000110 00000020 9f2dccc0 9f13dd44 8056aaae 9ed86480 00000000 
[   96.090000]        808e6de8 8056c0a6 9ed86480 9ed86480 9f2dccc0 9f13dd58 805a093b ffffffff 
[   96.090000]        9ed86480 00000000 9f13dd68 8059e40b 9f2dcce0 9ed86480 9f13dda0 8059f6d3 
[   96.090000] Call Trace:
[   96.090000]  [<8056aaae>] ? __alloc_skb+0x29/0x107
[   96.090000]  [<8056c0a6>] ? skb_copy_datagram_iovec+0x4a/0x196
[   96.090000]  [<805a093b>] ? tcp_send_ack+0x25/0xb6
[   96.090000]  [<8059e40b>] ? __tcp_ack_snd_check+0x5e/0x73
[   96.090000]  [<8059f6d3>] ? tcp_rcv_established+0x3ad/0x66a
[   96.090000]  [<801442a5>] ? generic_file_buffered_write+0x14b/0x4cb
[   96.090000]  [<805a4a7d>] ? tcp_v4_do_rcv+0x255/0x3c3
[   96.090000]  [<80567c59>] ? sk_wait_data+0x89/0x98
[   96.090000]  [<80596da7>] ? tcp_prequeue_process+0x56/0x6b
[   96.090000]  [<80598d3f>] ? tcp_recvmsg+0x36c/0x6b3
[   96.090000]  [<80566ea7>] ? sock_common_recvmsg+0x31/0x4a
[   96.090000]  [<80565318>] ? sock_aio_read+0xce/0xd8
[   96.090000]  [<80144a8b>] ? generic_file_aio_write+0x62/0xb4
[   96.090000]  [<8015e1ee>] ? do_sync_read+0xbe/0xfc
[   96.090000]  [<8012d8c5>] ? autoremove_wake_function+0x0/0x30
[   96.090000]  [<8015ce82>] ? do_filp_open+0x2e/0x35
[   96.090000]  [<802f5575>] ? security_file_permission+0xf/0x11
[   96.090000]  [<8015e7e2>] ? vfs_read+0x7d/0x91
[   96.090000]  [<8015eb5e>] ? sys_read+0x3b/0x60
[   96.090000]  [<801029d2>] ? sysenter_past_esp+0x5f/0x85
[   96.090000]  =======================
[   96.090000] Code: 55 f0 64 a1 04 b0 93 80 8b 7c 86 74 8b 17 f6 c2 01 74 15 8b 55 f0 89 f0 57 51 83 c9 ff e8 25 fa ff ff 5e 89 c3 58 eb 11 8b 47 0c <8b> 1c 82 89 d0 0f b1 1f 39 d0 89 c3 75 d3 66 83 7d f0 00 79 1f 
[   96.090000] EIP: [<8015a5fc>] kmem_cache_alloc+0x3a/0x78 SS:ESP 0068:9f13dd10
[   96.090008] Kernel panic - not syncing: Fatal exception in interrupt
[   96.096472] Rebooting in 10 seconds..Press any key to enter the menu

..............

Kernel 2.6.25-rc1 on an i686

mercury login: [   65.446421] Oops: 0000 [#1] SMP 
[   65.448090] Modules linked in:
[   65.448090] 
[   65.448090] Pid: 3650, comm: distccd Not tainted (2.6.25-rc1 #15)
[   65.448090] EIP: 0060:[<7816f4fa>] EFLAGS: 00010246 CPU: 0
[   65.448090] EIP is at kmem_cache_alloc+0x3a/0x80
[   65.448090] EAX: 00000000 EBX: 0000066c ECX: 78420580 EDX: 00000000
[   65.448090] ESI: 78757d48 EDI: 79e57880 EBP: 787ebf3c ESP: 787ebf2c
[   65.448090]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   65.448090] Process distccd (pid: 3650, ti=787eb000 task=b5e90000 task.ti=b5e64000)
[   65.448090] Stack: 00000020 0000066c 78757d48 00000000 787ebf60 78420580 b0d17f00 00000000 
[   65.448090]        00000020 787ebf64 b73454a0 b737c610 00000000 787ebf74 782fe022 ffffffff 
[   65.448090]        8000061c b7b13cc0 787ebfa8 78301176 00000040 b73454c4 b73454a0 b7345000 
[   65.448090] Call Trace:
[   65.448090]  [<78420580>] ? __alloc_skb+0x30/0x110
[   65.448090]  [<782fe022>] ? nv_alloc_rx_optimized+0x42/0x140
[   65.448090]  [<78301176>] ? nv_napi_poll+0x526/0x5f0
[   65.448090]  [<78426a7d>] ? net_rx_action+0xbd/0x1f0
[   65.448090]  [<7812684b>] ? __do_softirq+0x7b/0x100
[   65.448090]  [<781062ba>] ? do_softirq+0x5a/0xa0
[   65.448090]  [<78151510>] ? handle_level_irq+0x0/0xd0
[   65.448090]  [<781267c4>] ? irq_exit+0x44/0x50
[   65.448090]  [<7810639e>] ? do_IRQ+0x9e/0xc0
[   65.448090]  [<78104b68>] ? common_interrupt+0x28/0x30
[   65.448090]  [<78122503>] ? release_console_sem+0x1a3/0x1c0
[   65.448090]  [<78122a32>] ? vprintk+0x322/0x350
[   65.448090]  [<78122a75>] ? printk+0x15/0x20
[   65.448090]  [<781136a1>] ? dump_pagetable+0x21/0x80
[   65.448090]  [<785313bb>] ? do_page_fault+0x46b/0x540
[   65.448090]  [<78530f50>] ? do_page_fault+0x0/0x540
[   65.448090]  [<7852faa2>] ? error_code+0x72/0x80
[   65.448090]  [<78171a2f>] ? sys_close+0x5f/0xb0
[   65.448090]  [<781a0511>] ? dnotify_flush+0x11/0x80
[   65.448090]  [<781706d0>] ? filp_close+0x40/0x60
[   65.448090]  [<78171a38>] ? sys_close+0x68/0xb0
[   65.448090]  [<78103b26>] ? sysenter_past_esp+0x5f/0x99
[   65.448090]  =======================
[   65.448090] Code: 4d 04 64 a1 04 90 79 78 8b 7c 86 64 8b 17 f6 c2 01 74 15 57 51 83 c9 ff 8b 55 f0 89 f0 e8 7f fc ff ff 89 c3 58 5a eb 11 8b 47 0c <8b> 1c 82 89 d0 0f b1 1f 89 c3 39 d0 75 d3 66 83 7d f0 00 79 1f 
[   65.448090] EIP: [<7816f4fa>] kmem_cache_alloc+0x3a/0x80 SS:ESP 0068:787ebf2c
[   65.448101] Kernel panic - not syncing: Fatal exception in interrupt
[   65.452102] Rebooting in 10 seconds..Press any key to enter the menu

