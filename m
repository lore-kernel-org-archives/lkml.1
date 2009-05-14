Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbZENPuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbZENPuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZENPtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:49:53 -0400
Received: from vena.lwn.net ([206.168.112.25]:51584 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbZENPtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:49:52 -0400
Date: Thu, 14 May 2009 09:49:51 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc kills my box hard - and lockdep chains
Message-ID: <20090514094951.36fd7333@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So...every now and then I return to my system (a dual-core 64-bit
x86 box) only to find it totally dead.  Lights are on but there's no
disk activity, no ping responses, no alternative to simply pulling the
plug.  It happens fairly reliably about once a day with the 2.6.30-rc
kernels; it does not happen with 2.6.29.

I'm at a bit of a loss for how to try to track this one down.  "System
disappears without a trace" isn't much to go on.  I can't reproduce it
at will; even the "maintain an unsaved editor buffer with hours' worth
of work" trick doesn't seem to work this time.  

One clue might be found here, perhaps: I didn't have lockdep enabled but I do
now.  First time gave me:

	BUG: MAX_LOCKDEP_ENTRIES too low!

So I doubled it.  Now I get:

May 14 01:06:55 bike kernel: [38730.804833] BUG: MAX_LOCKDEP_CHAINS too low!
May 14 01:06:55 bike kernel: [38730.804838] turning off the locking correctness validator.
May 14 01:06:55 bike kernel: [38730.804843] Pid: 5321, comm: tar Tainted: G        W  2.6.30-rc5 #11
May 14 01:06:55 bike kernel: [38730.804846] Call Trace:
May 14 01:06:55 bike kernel: [38730.804854]  [<ffffffff8025df59>] __lock_acquire+0x57f/0xbc9
May 14 01:06:55 bike kernel: [38730.804860]  [<ffffffff8020f3a9>] ? print_context_stack+0xfa/0x119
May 14 01:06:55 bike kernel: [38730.804866]  [<ffffffff80394da9>] ? get_hash_bucket+0x28/0x34
May 14 01:06:55 bike kernel: [38730.804870]  [<ffffffff8025e660>] lock_acquire+0xbd/0xe1
May 14 01:06:55 bike kernel: [38730.804874]  [<ffffffff80394da9>] ? get_hash_bucket+0x28/0x34
May 14 01:06:55 bike kernel: [38730.804880]  [<ffffffff804fdc24>] _spin_lock_irqsave+0x3c/0x50
May 14 01:06:55 bike kernel: [38730.804883]  [<ffffffff80394da9>] ? get_hash_bucket+0x28/0x34
May 14 01:06:55 bike kernel: [38730.804888]  [<ffffffff8025cfe9>] ? trace_hardirqs_on_caller+0x10f/0x154
May 14 01:06:55 bike kernel: [38730.804892]  [<ffffffff80394da9>] get_hash_bucket+0x28/0x34
May 14 01:06:55 bike kernel: [38730.804896]  [<ffffffff80395509>] add_dma_entry+0x15/0x3b
May 14 01:06:55 bike kernel: [38730.804900]  [<ffffffff80395e26>] ? dma_entry_alloc+0xa3/0xab
May 14 01:06:55 bike kernel: [38730.804904]  [<ffffffff803960d9>] debug_dma_map_page+0xe4/0xf3
May 14 01:06:55 bike kernel: [38730.804909]  [<ffffffff804902d2>] skb_dma_map+0x192/0x230
May 14 01:06:55 bike kernel: [38730.804923]  [<ffffffffa005c5b6>] e1000_xmit_frame+0x618/0x901 [e1000e]
May 14 01:06:55 bike kernel: [38730.804928]  [<ffffffff804a006d>] ? compat_sys_getsockopt+0x10d/0x1ac
May 14 01:06:55 bike kernel: [38730.804933]  [<ffffffff804935ae>] dev_hard_start_xmit+0x228/0x297
May 14 01:06:55 bike kernel: [38730.804937]  [<ffffffff804a1aac>] __qdisc_run+0xf2/0x1fd
May 14 01:06:55 bike kernel: [38730.804941]  [<ffffffff80493977>] dev_queue_xmit+0x241/0x382
May 14 01:06:55 bike kernel: [38730.804945]  [<ffffffff804938a4>] ? dev_queue_xmit+0x16e/0x382
May 14 01:06:55 bike kernel: [38730.804950]  [<ffffffff8049b1bd>] neigh_resolve_output+0x210/0x261
May 14 01:06:55 bike kernel: [38730.804954]  [<ffffffff8025e594>] ? __lock_acquire+0xbba/0xbc9
May 14 01:06:55 bike kernel: [38730.804959]  [<ffffffff804ade6d>] ip_finish_output2+0x1b0/0x1f2
May 14 01:06:55 bike kernel: [38730.804962]  [<ffffffff804adf10>] ip_finish_output+0x61/0x63
May 14 01:06:55 bike kernel: [38730.804966]  [<ffffffff804adf6c>] ip_output+0x5a/0x5c
May 14 01:06:55 bike kernel: [38730.804970]  [<ffffffff804ac504>] dst_output+0x10/0x12
May 14 01:06:55 bike kernel: [38730.804974]  [<ffffffff804acc56>] ip_local_out+0x61/0x63
May 14 01:06:55 bike kernel: [38730.804978]  [<ffffffff804adb1e>] ip_queue_xmit+0x2c2/0x31a
May 14 01:06:55 bike kernel: [38730.804982]  [<ffffffff8025d03b>] ? trace_hardirqs_on+0xd/0xf
May 14 01:06:55 bike kernel: [38730.804986]  [<ffffffff8025cb02>] ? mark_lock+0x2d/0x22f
May 14 01:06:55 bike kernel: [38730.804991]  [<ffffffff804be219>] tcp_transmit_skb+0x5fe/0x63c
May 14 01:06:55 bike kernel: [38730.804996]  [<ffffffff804c0691>] tcp_write_xmit+0x7cd/0x8bd
May 14 01:06:55 bike kernel: [38730.805000]  [<ffffffff804c07e6>] __tcp_push_pending_frames+0x2f/0x5d
May 14 01:06:55 bike kernel: [38730.805005]  [<ffffffff804b3bab>] tcp_push+0x88/0x8a
May 14 01:06:55 bike kernel: [38730.805009]  [<ffffffff804b5cb1>] tcp_sendmsg+0x746/0x841
May 14 01:06:55 bike kernel: [38730.805014]  [<ffffffff8048458a>] __sock_sendmsg+0x61/0x6c
May 14 01:06:55 bike kernel: [38730.805018]  [<ffffffff80484e2c>] sock_sendmsg+0xcc/0xe5
May 14 01:06:55 bike kernel: [38730.805024]  [<ffffffff8024e49d>] ? autoremove_wake_function+0x0/0x39
May 14 01:06:55 bike kernel: [38730.805028]  [<ffffffff804fd9cf>] ? _spin_unlock_irq+0x30/0x36
May 14 01:06:55 bike kernel: [38730.805032]  [<ffffffff8025cb02>] ? mark_lock+0x2d/0x22f
May 14 01:06:55 bike kernel: [38730.805036]  [<ffffffff8025e594>] ? __lock_acquire+0xbba/0xbc9
May 14 01:06:55 bike kernel: [38730.805041]  [<ffffffff802433ae>] ? lock_timer_base+0x2c/0x52
May 14 01:06:55 bike kernel: [38730.805046]  [<ffffffff804851df>] kernel_sendmsg+0x39/0x4e
May 14 01:06:55 bike kernel: [38730.805064]  [<ffffffffa01e04ed>] xs_send_kvec+0x75/0x77 [sunrpc]
May 14 01:06:55 bike kernel: [38730.805068]  [<ffffffff8025d003>] ? trace_hardirqs_on_caller+0x129/0x154
May 14 01:06:55 bike kernel: [38730.805083]  [<ffffffffa01e0564>] xs_sendpages+0x75/0x1a6 [sunrpc]
May 14 01:06:55 bike kernel: [38730.805098]  [<ffffffffa01e079a>] xs_tcp_send_request+0x52/0x149 [sunrpc]
May 14 01:06:55 bike kernel: [38730.805102]  [<ffffffff80243885>] ? del_timer_sync+0x0/0x8b
May 14 01:06:55 bike kernel: [38730.805116]  [<ffffffffa01df4e9>] xprt_transmit+0x169/0x22d [sunrpc]
May 14 01:06:55 bike kernel: [38730.805129]  [<ffffffffa01dcdcd>] call_transmit+0x210/0x251 [sunrpc]
May 14 01:06:55 bike kernel: [38730.805144]  [<ffffffffa01e358d>] __rpc_execute+0x8f/0x250 [sunrpc]
May 14 01:06:55 bike kernel: [38730.805160]  [<ffffffffa01e3774>] rpc_execute+0x26/0x2a [sunrpc]
May 14 01:06:55 bike kernel: [38730.805173]  [<ffffffffa01dd6c4>] rpc_run_task+0x55/0x5d [sunrpc]
May 14 01:06:55 bike kernel: [38730.805185]  [<ffffffffa01dd7b9>] rpc_call_sync+0x44/0x62 [sunrpc]
May 14 01:06:55 bike kernel: [38730.805201]  [<ffffffffa02394fb>] nfs3_rpc_wrapper.clone.0+0x1f/0x58 [nfs]
May 14 01:06:55 bike kernel: [38730.805215]  [<ffffffffa023a0c0>] nfs3_proc_readdir+0xf6/0x137 [nfs]
May 14 01:06:55 bike kernel: [38730.805219]  [<ffffffff8025cb02>] ? mark_lock+0x2d/0x22f
May 14 01:06:55 bike kernel: [38730.805223]  [<ffffffff8025e594>] ? __lock_acquire+0xbba/0xbc9
May 14 01:06:55 bike kernel: [38730.805228]  [<ffffffff8025cb02>] ? mark_lock+0x2d/0x22f
May 14 01:06:55 bike kernel: [38730.805232]  [<ffffffff804fd9cf>] ? _spin_unlock_irq+0x30/0x36
May 14 01:06:55 bike kernel: [38730.805236]  [<ffffffff8025d03b>] ? trace_hardirqs_on+0xd/0xf
May 14 01:06:55 bike kernel: [38730.805247]  [<ffffffffa022ac9a>] nfs_readdir_filler+0xc9/0x172 [nfs]
May 14 01:06:55 bike kernel: [38730.805252]  [<ffffffff8028c989>] ? find_get_page+0x0/0xc5
May 14 01:06:55 bike kernel: [38730.805263]  [<ffffffffa022abd1>] ? nfs_readdir_filler+0x0/0x172 [nfs]
May 14 01:06:55 bike kernel: [38730.805267]  [<ffffffff8028d096>] read_cache_page_async+0x9a/0x129
May 14 01:06:55 bike kernel: [38730.805271]  [<ffffffff8028d137>] read_cache_page+0x12/0x49
May 14 01:06:55 bike kernel: [38730.805282]  [<ffffffffa022bd18>] nfs_readdir+0x259/0x738 [nfs]
May 14 01:06:55 bike kernel: [38730.805294]  [<ffffffffa022f50c>] ? nfs_open+0x15f/0x19b [nfs]
May 14 01:06:55 bike kernel: [38730.805299]  [<ffffffff802c2741>] ? filldir+0x0/0xc4
May 14 01:06:55 bike kernel: [38730.805304]  [<ffffffff8025e594>] ? __lock_acquire+0xbba/0xbc9
May 14 01:06:55 bike kernel: [38730.805308]  [<ffffffff8025cd56>] ? mark_held_locks+0x52/0x70
May 14 01:06:55 bike kernel: [38730.805312]  [<ffffffff804fc430>] ? __mutex_lock_common+0x2e1/0x336
May 14 01:06:55 bike kernel: [38730.805317]  [<ffffffff8025d003>] ? trace_hardirqs_on_caller+0x129/0x154
May 14 01:06:55 bike kernel: [38730.805331]  [<ffffffffa023bb89>] ? nfs3_decode_dirent+0x0/0x137 [nfs]
May 14 01:06:55 bike kernel: [38730.805336]  [<ffffffff802c2741>] ? filldir+0x0/0xc4
May 14 01:06:55 bike kernel: [38730.805340]  [<ffffffff802c2741>] ? filldir+0x0/0xc4
May 14 01:06:55 bike kernel: [38730.805344]  [<ffffffff802c293d>] vfs_readdir+0x79/0xb6
May 14 01:06:55 bike kernel: [38730.805348]  [<ffffffff802c2ac3>] sys_getdents+0x81/0xd1
May 14 01:06:55 bike kernel: [38730.805353]  [<ffffffff8020bcdb>] system_call_fastpath+0x16/0x1b

That's quite the call stack...  and, evidently, a lot of lock chains...  

Suggestions, anybody?

Thanks,

jon
