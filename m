Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbXKWPkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbXKWPkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 10:40:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756121AbXKWPjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 10:39:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45368 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164AbXKWPjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 10:39:54 -0500
Date: Fri, 23 Nov 2007 16:38:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dave Jones <davej@redhat.com>
Subject: [bug] xfrm_state_lock: possible circular locking dependency
	detected
Message-ID: <20071123153851.GA26308@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
X-Mailing-List: linux-kernel@vger.kernel.org


DaveJ's Fedora 8 rpm for 2.6.24 works petty well, except for the 
neworking related lockdep assert attached below, which happened while 
starting up ipsec. Let me know if you need any more info - it's a pretty 
stock setup.

	Ingo

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.24-0.39.rc3.git1.fc9 #1
-------------------------------------------------------
ip/25091 is trying to acquire lock:
 (&x->lock){-+..}, at: [<c06330d6>] copy_to_user_state_extra+0x1a/0x156

but task is already holding lock:
 (xfrm_state_lock){-+..}, at: [<c06308d2>] xfrm_state_walk+0x1e/0xb9

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (xfrm_state_lock){-+..}:
       [<c044dc17>] __lock_acquire+0xa7c/0xc4d
       [<c044e262>] lock_acquire+0x7b/0x9e
       [<c064147d>] _spin_lock_bh+0x33/0x5d
       [<c062eabf>] xfrm_state_lookup+0x1e/0x45
       [<c06317c0>] xfrm_alloc_spi+0xbc/0x17c
       [<c063505d>] xfrm_alloc_userspi+0xe5/0x168
       [<c0633de7>] xfrm_user_rcv_msg+0xba/0xcd
       [<c05ee161>] netlink_rcv_skb+0x30/0x82
       [<c06338d7>] xfrm_netlink_rcv+0x1e/0x2b
       [<c05edf35>] netlink_unicast+0x19f/0x208
       [<c05ee762>] netlink_sendmsg+0x279/0x285
       [<c05cd303>] sock_aio_write+0xe8/0xf4
       [<c049360e>] do_sync_write+0xc5/0x102
       [<c0493e2a>] vfs_write+0xbc/0x15c
       [<c049447d>] sys_write+0x3d/0x61
       [<c0405252>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

-> #0 (&x->lock){-+..}:
       [<c044db07>] __lock_acquire+0x96c/0xc4d
       [<c044e262>] lock_acquire+0x7b/0x9e
       [<c064147d>] _spin_lock_bh+0x33/0x5d
       [<c06330d6>] copy_to_user_state_extra+0x1a/0x156
       [<c06337c4>] dump_one_state+0xb9/0x138
       [<c063090d>] xfrm_state_walk+0x59/0xb9
       [<c0633bbf>] xfrm_dump_sa+0x3f/0x4f
       [<c05ed306>] netlink_dump+0x52/0x16a
       [<c05ef1ae>] netlink_dump_start+0x104/0x141
       [<c0633d99>] xfrm_user_rcv_msg+0x6c/0xcd
       [<c05ee161>] netlink_rcv_skb+0x30/0x82
       [<c06338d7>] xfrm_netlink_rcv+0x1e/0x2b
       [<c05edf35>] netlink_unicast+0x19f/0x208
       [<c05ee762>] netlink_sendmsg+0x279/0x285
       [<c05cda10>] sock_sendmsg+0xe0/0xfd
       [<c05ce34b>] sys_sendto+0xcc/0xec
       [<c05ceb98>] sys_socketcall+0x16b/0x241
       [<c0405252>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

3 locks held by ip/25091:
 #0:  (xfrm_cfg_mutex){--..}, at: [<c06338cb>] xfrm_netlink_rcv+0x12/0x2b
 #1:  (nlk->cb_mutex){--..}, at: [<c05ed2ee>] netlink_dump+0x3a/0x16a
 #2:  (xfrm_state_lock){-+..}, at: [<c06308d2>] xfrm_state_walk+0x1e/0xb9

stack backtrace:
 [<c040649a>] show_trace_log_lvl+0x1a/0x2f
 [<c0406d46>] show_trace+0x12/0x14
 [<c0406e51>] dump_stack+0x16/0x18
 [<c044c069>] print_circular_bug_tail+0x5f/0x68
 [<c044db07>] __lock_acquire+0x96c/0xc4d
 [<c044e262>] lock_acquire+0x7b/0x9e
 [<c064147d>] _spin_lock_bh+0x33/0x5d
 [<c06330d6>] copy_to_user_state_extra+0x1a/0x156
 [<c06337c4>] dump_one_state+0xb9/0x138
 [<c063090d>] xfrm_state_walk+0x59/0xb9
 [<c0633bbf>] xfrm_dump_sa+0x3f/0x4f
 [<c05ed306>] netlink_dump+0x52/0x16a
 [<c05ef1ae>] netlink_dump_start+0x104/0x141
 [<c0633d99>] xfrm_user_rcv_msg+0x6c/0xcd
 [<c05ee161>] netlink_rcv_skb+0x30/0x82
 [<c06338d7>] xfrm_netlink_rcv+0x1e/0x2b
 [<c05edf35>] netlink_unicast+0x19f/0x208
 [<c05ee762>] netlink_sendmsg+0x279/0x285
 [<c05cda10>] sock_sendmsg+0xe0/0xfd
 [<c05ce34b>] sys_sendto+0xcc/0xec
 [<c05ceb98>] sys_socketcall+0x16b/0x241
 [<c0405252>] syscall_call+0x7/0xb
 =======================
NET: Unregistered protocol family 15
NET: Registered protocol family 15
