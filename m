Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZFKRwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZFKRwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZFKRwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:52:42 -0400
Received: from fmailhost06.isp.att.net ([204.127.217.106]:64039 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZFKRwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:52:41 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A314467.1070707@lwfinger.net>
Date: Thu, 11 Jun 2009 12:52:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, bfields@fieldses.org, neilb@suse.de
Subject: Locking problem with kswapd in kernel 2.6.30-rc8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem looks to be arising from NFS. I hope it is going to the
right places.

The kernel is from the wireless-testing tree of Linville. The base
kernel matches the mainline tree with the newest wireless material.

The following was logged:

=================================
[ INFO: inconsistent lock state ]
2.6.30-rc8-wl #166
---------------------------------
inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
kswapd0/229 [HC0[0]:SC0[1]:HE1:SE0] takes:
 (sk_lock-AF_INET-RPC){+.+.?.}, at: [<ffffffff80416cc2>]
tcp_sendmsg+0x22/0x9fe
{RECLAIM_FS-ON-W} state was registered at:
  [<ffffffff8025cc08>] mark_held_locks+0x4d/0x6b
  [<ffffffff8025ccc6>] lockdep_trace_alloc+0xa0/0xb9
  [<ffffffff802b6997>] kmem_cache_alloc_node+0x29/0x12d
  [<ffffffff803e870a>] __alloc_skb+0x42/0x143
  [<ffffffff80422f8d>] tcp_send_fin+0x65/0x18c
  [<ffffffff8041588c>] tcp_close+0x17c/0x3dd
  [<ffffffff80431f74>] inet_release+0x50/0x57
  [<ffffffff803e13b2>] sock_release+0x1a/0x6c
  [<ffffffffa05471fa>] xs_reset_transport+0xa9/0xb2 [sunrpc]
  [<ffffffffa0547231>] xs_close+0x2e/0x59 [sunrpc]
  [<ffffffffa054729f>] xs_destroy+0x43/0x8d [sunrpc]
  [<ffffffffa0545269>] xprt_destroy+0x7f/0x83 [sunrpc]
  [<ffffffff80337a65>] kref_put+0x43/0x4f
  [<ffffffffa05451e8>] xprt_put+0x10/0x12 [sunrpc]
  [<ffffffffa05448d4>] rpc_free_client+0xd3/0xe4 [sunrpc]
  [<ffffffff80337a65>] kref_put+0x43/0x4f
  [<ffffffffa054492d>] rpc_free_auth+0x48/0x4c [sunrpc]
  [<ffffffff80337a65>] kref_put+0x43/0x4f
  [<ffffffffa05447fd>] rpc_release_client+0x57/0x5b [sunrpc]
  [<ffffffffa0549dfd>] rpc_put_task+0x47/0xc1 [sunrpc]
  [<ffffffffa054aa59>] __rpc_execute+0x238/0x244 [sunrpc]
  [<ffffffffa054aaa1>] rpc_async_schedule+0x10/0x12 [sunrpc]
  [<ffffffff8024af37>] worker_thread+0x1fa/0x30a
  [<ffffffff8024ec25>] kthread+0x56/0x83
  [<ffffffff8020cb7a>] child_rip+0xa/0x20
  [<ffffffffffffffff>] 0xffffffffffffffff
irq event stamp: 13218008
hardirqs last  enabled at (13218007): [<ffffffff80460190>]
_spin_unlock_irqrestore+0x3f/0x47
hardirqs last disabled at (13218006): [<ffffffff8046034b>]
_spin_lock_irqsave+0x17/0x4b
softirqs last  enabled at (13218002): [<ffffffffa05463b2>]
xprt_transmit+0xba/0x234 [sunrpc]
softirqs last disabled at (13218008): [<ffffffff804602c9>]
_spin_lock_bh+0x11/0x3d

other info that might help us debug this:
no locks held by kswapd0/229.

stack backtrace:
Pid: 229, comm: kswapd0 Not tainted 2.6.30-rc8-wl #166
Call Trace:
 [<ffffffff8025c67b>] print_usage_bug+0x1b2/0x1c3
 [<ffffffff8025d226>] ? check_usage_forwards+0x0/0x9d
 [<ffffffff8025c986>] mark_lock+0x2fa/0x52f
 [<ffffffff8025e2a5>] __lock_acquire+0x7a7/0x1607
 [<ffffffff8028ffd7>] ? __rmqueue_smallest+0xa4/0x128
 [<ffffffff8025f1be>] lock_acquire+0xb9/0xdd
 [<ffffffff80416cc2>] ? tcp_sendmsg+0x22/0x9fe
 [<ffffffff803e34b2>] lock_sock_nested+0xe1/0xf5
 [<ffffffff80416cc2>] ? tcp_sendmsg+0x22/0x9fe
 [<ffffffff8025be2a>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80416cc2>] tcp_sendmsg+0x22/0x9fe
 [<ffffffff8025b459>] ? find_usage_forwards+0x82/0xa6
 [<ffffffff8025b459>] ? find_usage_forwards+0x82/0xa6
 [<ffffffff803e0f8e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024eff0>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff803e1217>] kernel_sendmsg+0x34/0x49
 [<ffffffffa05473f0>] xs_send_kvec+0x7a/0x83 [sunrpc]
 [<ffffffffa0547486>] xs_sendpages+0x8d/0x1af [sunrpc]
 [<ffffffffa05476b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa0546470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05ba9c3>] ? nfs3_xdr_writeargs+0x0/0x87 [nfs]
 [<ffffffffa0543d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054a8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054aa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054463c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa05b6774>] nfs_write_rpcsetup+0x215/0x237 [nfs]
 [<ffffffff8025ceac>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa05b8257>] nfs_flush_one+0xa2/0xd9 [nfs]
 [<ffffffffa05b32d9>] nfs_pageio_doio+0x32/0x5b [nfs]
 [<ffffffffa05b33ec>] nfs_pageio_complete+0x9/0xb [nfs]
 [<ffffffffa05b6a3c>] nfs_writepage_locked+0x8b/0xaa [nfs]
 [<ffffffffa05b81b5>] ? nfs_flush_one+0x0/0xd9 [nfs]
 [<ffffffff8025ce7b>] ? trace_hardirqs_on_caller+0x10b/0x12f
 [<ffffffffa05b6f16>] nfs_writepage+0xf/0x22 [nfs]
 [<ffffffff8029700f>] shrink_page_list+0x3b0/0x69f
 [<ffffffff8029793b>] shrink_list+0x2a1/0x5b6
 [<ffffffff80460190>] ? _spin_unlock_irqrestore+0x3f/0x47
 [<ffffffff80297edb>] shrink_zone+0x28b/0x335
 [<ffffffff8033a0f4>] ? __up_read+0x92/0x9a
 [<ffffffff802980c7>] ? shrink_slab+0x142/0x154
 [<ffffffff8029883b>] kswapd+0x4b1/0x692
 [<ffffffff8023695d>] ? finish_task_switch+0x3b/0xdc
 [<ffffffff802960ed>] ? isolate_pages_global+0x0/0x219
 [<ffffffff8024eff0>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8025ceac>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8029838a>] ? kswapd+0x0/0x692
 [<ffffffff8029838a>] ? kswapd+0x0/0x692
 [<ffffffff8024ec25>] kthread+0x56/0x83
 [<ffffffff8020cb7a>] child_rip+0xa/0x20
 [<ffffffff8020c57c>] ? restore_args+0x0/0x30
 [<ffffffff8024ebcf>] ? kthread+0x0/0x83
 [<ffffffff8020cb70>] ? child_rip+0x0/0x20

Thanks,

Larry
