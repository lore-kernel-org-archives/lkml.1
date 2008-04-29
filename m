Return-Path: <linux-kernel-owner+w=401wt.eu-S1761804AbYD2NBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761804AbYD2NBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758200AbYD2NA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:00:26 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:39092 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760884AbYD2NAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:00:19 -0400
Date: Tue, 29 Apr 2008 18:30:06 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3/8] lockdep: fix fib_hash softirq inversion
Message-ID: <20080429130006.GD23562@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080429125659.GA23562@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429125659.GA23562@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: lockdep: fix fib_hash softirq inversion

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.25-rc4-sched-devel.git #56
---------------------------------------------------------
swapper/0 just changed the state of lock:
 (&rt_hash_locks[i]){-+..}, at: [<ffffffff804721ac>] rt_intern_hash+0x8c/0x3b0
but this lock took another, soft-read-irq-unsafe lock in the past:
 (fib_hash_lock){-.-?}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
1 lock held by swapper/0:
 #0:  (rcu_read_lock){..--}, at: [<ffffffff8045a706>] netif_receive_skb+0x76/0x350

the first lock's dependencies:
-> (&rt_hash_locks[i]){-+..} ops: 0 {
   initial-use  at:
                                       [<ffffffff80275900>] __lock_acquire+0x150/0x1080
                                       [<ffffffff80276895>] lock_acquire+0x65/0x90
                                       [<ffffffff804e99a6>] _spin_lock_bh+0x36/0x70
                                       [<ffffffff804721ac>] rt_intern_hash+0x8c/0x3b0
                                       [<ffffffff80472acd>] __ip_route_output_key+0x5fd/0xb10
                                       [<ffffffff80472ffc>] ip_route_output_flow+0x1c/0x70
                                       [<ffffffff8049b49d>] udp_sendmsg+0x5dd/0x760
                                       [<ffffffff804a2235>] inet_sendmsg+0x45/0x80
                                       [<ffffffff8044d677>] sock_sendmsg+0x127/0x140
                                       [<ffffffff8044e43a>] sys_sendto+0xea/0x120
                                       [<ffffffff8022044b>] system_call_after_swapgs+0x7b/0x80
                                       [<ffffffffffffffff>] 0xffffffffffffffff
   in-softirq-W at:
                                       [<ffffffffffffffff>] 0xffffffffffffffff
   hardirq-on-W at:
                                       [<ffffffff80275e72>] __lock_acquire+0x6c2/0x1080
                                       [<ffffffff80276895>] lock_acquire+0x65/0x90
                                       [<ffffffff804e99a6>] _spin_lock_bh+0x36/0x70
                                       [<ffffffff804721ac>] rt_intern_hash+0x8c/0x3b0
                                       [<ffffffff80472acd>] __ip_route_output_key+0x5fd/0xb10
                                       [<ffffffff80472ffc>] ip_route_output_flow+0x1c/0x70
                                       [<ffffffff8049b49d>] udp_sendmsg+0x5dd/0x760
                                       [<ffffffff804a2235>] inet_sendmsg+0x45/0x80
                                       [<ffffffff8044d677>] sock_sendmsg+0x127/0x140
                                       [<ffffffff8044e43a>] sys_sendto+0xea/0x120
                                       [<ffffffff8022044b>] system_call_after_swapgs+0x7b/0x80
                                       [<ffffffffffffffff>] 0xffffffffffffffff
 }
 ... key      at: [<ffffffff80b96b14>] __key.37724+0x0/0x8
 -> (&tbl->lock){-+-+} ops: 0 {
    initial-use  at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    in-softirq-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    hardirq-on-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    in-softirq-R at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    hardirq-on-R at:
                                         [<ffffffff80275bf0>] __lock_acquire+0x440/0x1080
                                         [<ffffffff80276895>] lock_acquire+0x65/0x90
                                         [<ffffffff804e9b59>] _read_lock_bh+0x39/0x70
                                         [<ffffffff80461a46>] neigh_lookup+0x76/0x150
                                         [<ffffffff8049c5a2>] arp_bind_neighbour+0x72/0xb0
                                         [<ffffffff8047223a>] rt_intern_hash+0x11a/0x3b0
                                         [<ffffffff80472acd>] __ip_route_output_key+0x5fd/0xb10
                                         [<ffffffff80472ffc>] ip_route_output_flow+0x1c/0x70
                                         [<ffffffff8049b49d>] udp_sendmsg+0x5dd/0x760
                                         [<ffffffff804a2235>] inet_sendmsg+0x45/0x80
                                         [<ffffffff8044d677>] sock_sendmsg+0x127/0x140
                                         [<ffffffff8044e43a>] sys_sendto+0xea/0x120
                                         [<ffffffff8022044b>] system_call_after_swapgs+0x7b/0x80
                                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff80b967f8>] __key.29558+0x0/0x8
  -> (base_lock_keys + cpu){++..} ops: 0 {
     initial-use  at:
                                           [<ffffffff80275900>] __lock_acquire+0x150/0x1080
                                           [<ffffffff80276895>] lock_acquire+0x65/0x90
                                           [<ffffffff804e9d27>] _spin_lock_irqsave+0x47/0x80
                                           [<ffffffff8025a946>] lock_timer_base+0x36/0x70
                                           [<ffffffff8025aaab>] __mod_timer+0x3b/0xf0
                                           [<ffffffff8025adbe>] mod_timer+0x2e/0x50
                                           [<ffffffff806ccc6b>] con_init+0x26b/0x290
                                           [<ffffffff806cc0f2>] console_init+0x32/0x50
                                           [<ffffffff806abbc0>] start_kernel+0x1e0/0x330
                                           [<ffffffff806ab1b2>] _sinittext+0x1b2/0x200
                                           [<ffffffffffffffff>] 0xffffffffffffffff
     in-hardirq-W at:
                                           [<ffffffffffffffff>] 0xffffffffffffffff
     in-softirq-W at:
                                           [<ffffffffffffffff>] 0xffffffffffffffff
   }
   ... key      at: [<ffffffff807a7400>] base_lock_keys+0x0/0x40
  ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffff80276734>] __lock_acquire+0xf84/0x1080
   [<ffffffff80276895>] lock_acquire+0x65/0x90
   [<ffffffff804e9b59>] _read_lock_bh+0x39/0x70
   [<ffffffff80461a46>] neigh_lookup+0x76/0x150
   [<ffffffff8049c5a2>] arp_bind_neighbour+0x72/0xb0
   [<ffffffff8047223a>] rt_intern_hash+0x11a/0x3b0
   [<ffffffff80472acd>] __ip_route_output_key+0x5fd/0xb10
   [<ffffffff80472ffc>] ip_route_output_flow+0x1c/0x70
   [<ffffffff8049b49d>] udp_sendmsg+0x5dd/0x760
   [<ffffffff804a2235>] inet_sendmsg+0x45/0x80
   [<ffffffff8044d677>] sock_sendmsg+0x127/0x140
   [<ffffffff8044e43a>] sys_sendto+0xea/0x120
   [<ffffffff8022044b>] system_call_after_swapgs+0x7b/0x80
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (fib_hash_lock){-.-?} ops: 0 {
    initial-use  at:
                                         [<ffffffff80275900>] __lock_acquire+0x150/0x1080
                                         [<ffffffff80276895>] lock_acquire+0x65/0x90
                                         [<ffffffff804e9a76>] _write_lock_bh+0x36/0x70
                                         [<ffffffff804ad443>] fn_hash_insert+0x5a3/0x720
                                         [<ffffffff804a88ef>] fib_magic+0x10f/0x120
                                         [<ffffffff804a8973>] fib_add_ifaddr+0x73/0x170
                                         [<ffffffff804a8b7b>] fib_inetaddr_event+0x4b/0x280
                                         [<ffffffff804ed193>] notifier_call_chain+0x53/0x80
                                         [<ffffffff8026b998>] __blocking_notifier_call_chain+0x58/0x80
                                         [<ffffffff8026b9d1>] blocking_notifier_call_chain+0x11/0x20
                                         [<ffffffff8049fa44>] __inet_insert_ifa+0xd4/0x170
                                         [<ffffffff8049faed>] inet_insert_ifa+0xd/0x10
                                         [<ffffffff804a0eff>] inetdev_event+0x3df/0x480
                                         [<ffffffff804ed193>] notifier_call_chain+0x53/0x80
                                         [<ffffffff8026b739>] __raw_notifier_call_chain+0x9/0x10
                                         [<ffffffff8026b751>] raw_notifier_call_chain+0x11/0x20
                                         [<ffffffff8045b3a6>] call_netdevice_notifiers+0x16/0x20
                                         [<ffffffff8045ce52>] dev_open+0x82/0x90
                                         [<ffffffff8045b529>] dev_change_flags+0x99/0x1b0
                                         [<ffffffff804a171e>] devinet_ioctl+0x5ce/0x780
                                         [<ffffffff804a205c>] inet_ioctl+0x5c/0x80
                                         [<ffffffff8044c8b5>] sock_ioctl+0x65/0x250
                                         [<ffffffff802d5241>] vfs_ioctl+0x31/0x90
                                         [<ffffffff802d5313>] do_vfs_ioctl+0x73/0x2d0
                                         [<ffffffff802d55f2>] sys_ioctl+0x82/0xa0
                                         [<ffffffff8022044b>] system_call_after_swapgs+0x7b/0x80
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    hardirq-on-W at:
                                         [<ffffffff80275e72>] __lock_acquire+0x6c2/0x1080
                                         [<ffffffff80276895>] lock_acquire+0x65/0x90
                                         [<ffffffff804e9a76>] _write_lock_bh+0x36/0x70
                                         [<ffffffff804ad443>] fn_hash_insert+0x5a3/0x720
                                         [<ffffffff804a88ef>] fib_magic+0x10f/0x120
                                         [<ffffffff804a8973>] fib_add_ifaddr+0x73/0x170
                                         [<ffffffff804a8b7b>] fib_inetaddr_event+0x4b/0x280
                                         [<ffffffff804ed193>] notifier_call_chain+0x53/0x80
                                         [<ffffffff8026b998>] __blocking_notifier_call_chain+0x58/0x80
                                         [<ffffffff8026b9d1>] blocking_notifier_call_chain+0x11/0x20
                                         [<ffffffff8049fa44>] __inet_insert_ifa+0xd4/0x170
                                         [<ffffffff8049faed>] inet_insert_ifa+0xd/0x10
                                         [<ffffffff804a0eff>] inetdev_event+0x3df/0x480
                                         [<ffffffff804ed193>] notifier_call_chain+0x53/0x80
                                         [<ffffffff8026b739>] __raw_notifier_call_chain+0x9/0x10
                                         [<ffffffff8026b751>] raw_notifier_call_chain+0x11/0x20
                                         [<ffffffff8045b3a6>] call_netdevice_notifiers+0x16/0x20
                                         [<ffffffff8045ce52>] dev_open+0x82/0x90
                                         [<ffffffff8045b529>] dev_change_flags+0x99/0x1b0
                                         [<ffffffff804a171e>] devinet_ioctl+0x5ce/0x780
                                         [<ffffffff804a205c>] inet_ioctl+0x5c/0x80
                                         [<ffffffff8044c8b5>] sock_ioctl+0x65/0x250
                                         [<ffffffff802d5241>] vfs_ioctl+0x31/0x90
                                         [<ffffffff802d5313>] do_vfs_ioctl+0x73/0x2d0
                                         [<ffffffff802d55f2>] sys_ioctl+0x82/0xa0
                                         [<ffffffff8022044b>] system_call_after_swapgs+0x7b/0x80
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    in-softirq-R at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    softirq-on-R at:
                                         [<ffffffff80275c1b>] __lock_acquire+0x46b/0x1080
                                         [<ffffffff80276895>] lock_acquire+0x65/0x90
                                         [<ffffffff804e9bc4>] _read_lock+0x34/0x70
                                         [<ffffffff804acdd7>] fn_hash_lookup+0x27/0xf0
                                         [<ffffffff804a855d>] inet_addr_type+0x6d/0xf0
                                         [<ffffffff804aada2>] fib_create_info+0x5a2/0xbf0
                                         [<ffffffff804acf0b>] fn_hash_insert+0x6b/0x720
                                         [<ffffffff804a88ef>] fib_magic+0x10f/0x120
                                         [<ffffffff804a89c8>] fib_add_ifaddr+0xc8/0x170
                                         [<ffffffff804a8b7b>] fib_inetaddr_event+0x4b/0x280
                                         [<ffffffff804ed193>] notifier_call_chain+0x53/0x80
                                         [<ffffffff8026b998>] __blocking_notifier_call_chain+0x58/0x80
                                         [<ffffffff8026b9d1>] blocking_notifier_call_chain+0x11/0x20
                                         [<ffffffff8049fa44>] __inet_insert_ifa+0xd4/0x170
                                         [<ffffffff8049faed>] inet_insert_ifa+0xd/0x10
                                         [<ffffffff804a0eff>] inetdev_event+0x3df/0x480
                                         [<ffffffff804ed193>] notifier_call_chain+0x53/0x80
                                         [<ffffffff8026b739>] __raw_notifier_call_chain+0x9/0x10
                                         [<ffffffff8026b751>] raw_notifier_call_chain+0x11/0x20
                                         [<ffffffff8045b3a6>] call_netdevice_notifiers+0x16/0x20
                                         [<ffffffff8045ce52>] dev_open+0x82/0x90
                                         [<ffffffff8045b529>] dev_change_flags+0x99/0x1b0
                                         [<ffffffff804a171e>] devinet_ioctl+0x5ce/0x780
                                         [<ffffffff804a205c>] inet_ioctl+0x5c/0x80
                                         [<ffffffff8044c8b5>] sock_ioctl+0x65/0x250
                                         [<ffffffff802d5241>] vfs_ioctl+0x31/0x90
                                         [<ffffffff802d5313>] do_vfs_ioctl+0x73/0x2d0
                                         [<ffffffff802d55f2>] sys_ioctl+0x82/0xa0
                                         [<ffffffff8022044b>] system_call_after_swapgs+0x7b/0x80
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    hardirq-on-R at:
                                         [<ffffffff80275bf0>] __lock_acquire+0x440/0x1080
                                         [<ffffffff80276895>] lock_acquire+0x65/0x90
                                         [<ffffffff804e9bc4>] _read_lock+0x34/0x70
                                         [<ffffffff804acdd7>] fn_hash_lookup+0x27/0xf0
                                         [<ffffffff804a855d>] inet_addr_type+0x6d/0xf0
                                         [<ffffffff804aada2>] fib_create_info+0x5a2/0xbf0
                                         [<ffffffff804acf0b>] fn_hash_insert+0x6b/0x720
                                         [<ffffffff804a88ef>] fib_magic+0x10f/0x120
                                         [<ffffffff804a89c8>] fib_add_ifaddr+0xc8/0x170
                                         [<ffffffff804a8b7b>] fib_inetaddr_event+0x4b/0x280
                                         [<ffffffff804ed193>] notifier_call_chain+0x53/0x80
                                         [<ffffffff8026b998>] __blocking_notifier_call_chain+0x58/0x80
                                         [<ffffffff8026b9d1>] blocking_notifier_call_chain+0x11/0x20
                                         [<ffffffff8049fa44>] __inet_insert_ifa+0xd4/0x170
                                         [<ffffffff8049faed>] inet_insert_ifa+0xd/0x10
                                         [<ffffffff804a0eff>] inetdev_event+0x3df/0x480
                                         [<ffffffff804ed193>] notifier_call_chain+0x53/0x80
                                         [<ffffffff8026b739>] __raw_notifier_call_chain+0x9/0x10
                                         [<ffffffff8026b751>] raw_notifier_call_chain+0x11/0x20
                                         [<ffffffff8045b3a6>] call_netdevice_notifiers+0x16/0x20
                                         [<ffffffff8045ce52>] dev_open+0x82/0x90
                                         [<ffffffff8045b529>] dev_change_flags+0x99/0x1b0
                                         [<ffffffff804a171e>] devinet_ioctl+0x5ce/0x780
                                         [<ffffffff804a205c>] inet_ioctl+0x5c/0x80
                                         [<ffffffff8044c8b5>] sock_ioctl+0x65/0x250
                                         [<ffffffff802d5241>] vfs_ioctl+0x31/0x90
                                         [<ffffffff802d5313>] do_vfs_ioctl+0x73/0x2d0
                                         [<ffffffff802d55f2>] sys_ioctl+0x82/0xa0
                                         [<ffffffff8022044b>] system_call_after_swapgs+0x7b/0x80
                                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff806799b8>] fib_hash_lock+0x18/0x40
 ... acquired at:
   [<ffffffff80276734>] __lock_acquire+0xf84/0x1080
   [<ffffffff80276895>] lock_acquire+0x65/0x90
   [<ffffffff804e9bc4>] _read_lock+0x34/0x70
   [<ffffffff804acdd7>] fn_hash_lookup+0x27/0xf0
   [<ffffffff804a855d>] inet_addr_type+0x6d/0xf0
   [<ffffffff8049dcc6>] arp_constructor+0x86/0x280
   [<ffffffff8046272f>] neigh_create+0x19f/0x5b0
   [<ffffffff8049c5cf>] arp_bind_neighbour+0x9f/0xb0
   [<ffffffff8047223a>] rt_intern_hash+0x11a/0x3b0
   [<ffffffff80472acd>] __ip_route_output_key+0x5fd/0xb10
   [<ffffffff804947ec>] tcp_v4_connect+0x10c/0x550
   [<ffffffff804a343a>] inet_stream_connect+0x23a/0x2d0
   [<ffffffff8044e530>] sys_connect+0xa0/0xc0
   [<ffffffff8022044b>] system_call_after_swapgs+0x7b/0x80
   [<ffffffffffffffff>] 0xffffffffffffffff


the second lock's dependencies:
-> (fib_hash_lock){-.-?} ops: 0 {
   initial-use  at:
                                       [<ffffffff80275900>] __lock_acquire+0x150/0x1080
                                       [<ffffffff80276895>] lock_acquire+0x65/0x90
                                       [<ffffffff804e9a76>] _write_lock_bh+0x36/0x70
                                       [<ffffffff804ad443>] fn_hash_insert+0x5a3/0x720
                                       [<ffffffff804a88ef>] fib_magic+0x10f/0x120
                                       [<ffffffff804a8973>] fib_add_ifaddr+0x73/0x170
                                       [<ffffffff804a8b7b>] fib_inetaddr_event+0x4b/0x280
                                       [<ffffffff804ed193>] notifier_call_chain+0x53/0x80
                                       [<ffffffff8026b998>] __blocking_notifier_call_chain+0x58/0x80
                                       [<ffffffff8026b9d1>] blocking_notifier_call_chain+0x11/0x20
                                       [<ffffffff8049fa44>] __inet_insert_ifa+0xd4/0x170
                                       [<ffffffff8049faed>] inet_insert_ifa+0xd/0x10
                                       [<ffffffff804a0eff>] inetdev_event+0x3df/0x480
                                       [<ffffffff804ed193>] notifier_call_chain+0x53/0x80
                                       [<ffffffff8026b739>] __raw_notifier_call_chain+0x9/0x10
                                       [<ffffffff8026b751>] raw_notifier_call_chain+0x11/0x20
                                       [<ffffffff8045b3a6>] call_netdevice_notifiers+0x16/0x20
                                       [<ffffffff8045ce52>] dev_open+0x82/0x90
                                       [<ffffffff8045b529>] dev_change_flags+0x99/0x1b0
                                       [<ffffffff804a171e>] devinet_ioctl+0x5ce/0x780
                                       [<ffffffff804a205c>] inet_ioctl+0x5c/0x80
                                       [<ffffffff8044c8b5>] sock_ioctl+0x65/0x250
                                       [<ffffffff802d5241>] vfs_ioctl+0x31/0x90
                                       [<ffffffff802d5313>] do_vfs_ioctl+0x73/0x2d0
                                       [<ffffffff802d55f2>] sys_ioctl+0x82/0xa0
                                       [<ffffffff8022044b>] system_call_after_swapgs+0x7b/0x80
                                       [<ffffffffffffffff>] 0xffffffffffffffff
   hardirq-on-W at:
                                       [<ffffffff80275e72>] __lock_acquire+0x6c2/0x1080
                                       [<ffffffff80276895>] lock_acquire+0x65/0x90
                                       [<ffffffff804e9a76>] _write_lock_bh+0x36/0x70
                                       [<ffffffff804ad443>] fn_hash_insert+0x5a3/0x720
                                       [<ffffffff804a88ef>] fib_magic+0x10f/0x120
                                       [<ffffffff804a8973>] fib_add_ifaddr+0x73/0x170
                                       [<ffffffff804a8b7b>] fib_inetaddr_event+0x4b/0x280
                                       [<ffffffff804ed193>] notifier_call_chain+0x53/0x80
                                       [<ffffffff8026b998>] __blocking_notifier_call_chain+0x58/0x80
                                       [<ffffffff8026b9d1>] blocking_notifier_call_chain+0x11/0x20
                                       [<ffffffff8049fa44>] __inet_insert_ifa+0xd4/0x170
                                       [<ffffffff8049faed>] inet_insert_ifa+0xd/0x10
                                       [<ffffffff804a0eff>] inetdev_event+0x3df/0x480
                                       [<ffffffff804ed193>] notifier_call_chain+0x53/0x80
                                       [<ffffffff8026b739>] __raw_notifier_call_chain+0x9/0x10
                                       [<ffffffff8026b751>] raw_notifier_call_chain+0x11/0x20
                                       [<ffffffff8045b3a6>] call_netdevice_notifiers+0x16/0x20
                                       [<ffffffff8045ce52>] dev_open+0x82/0x90
                                       [<ffffffff8045b529>] dev_change_flags+0x99/0x1b0
                                       [<ffffffff804a171e>] devinet_ioctl+0x5ce/0x780
                                       [<ffffffff804a205c>] inet_ioctl+0x5c/0x80
                                       [<ffffffff8044c8b5>] sock_ioctl+0x65/0x250
                                       [<ffffffff802d5241>] vfs_ioctl+0x31/0x90
                                       [<ffffffff802d5313>] do_vfs_ioctl+0x73/0x2d0
                                       [<ffffffff802d55f2>] sys_ioctl+0x82/0xa0
                                       [<ffffffff8022044b>] system_call_after_swapgs+0x7b/0x80
                                       [<ffffffffffffffff>] 0xffffffffffffffff
   in-softirq-R at:
                                       [<ffffffffffffffff>] 0xffffffffffffffff
   softirq-on-R at:
                                       [<ffffffff80275c1b>] __lock_acquire+0x46b/0x1080
                                       [<ffffffff80276895>] lock_acquire+0x65/0x90
                                       [<ffffffff804e9bc4>] _read_lock+0x34/0x70
                                       [<ffffffff804acdd7>] fn_hash_lookup+0x27/0xf0
                                       [<ffffffff804a855d>] inet_addr_type+0x6d/0xf0
                                       [<ffffffff804aada2>] fib_create_info+0x5a2/0xbf0
                                       [<ffffffff804acf0b>] fn_hash_insert+0x6b/0x720
                                       [<ffffffff804a88ef>] fib_magic+0x10f/0x120
                                       [<ffffffff804a89c8>] fib_add_ifaddr+0xc8/0x170
                                       [<ffffffff804a8b7b>] fib_inetaddr_event+0x4b/0x280
                                       [<ffffffff804ed193>] notifier_call_chain+0x53/0x80
                                       [<ffffffff8026b998>] __blocking_notifier_call_chain+0x58/0x80
                                       [<ffffffff8026b9d1>] blocking_notifier_call_chain+0x11/0x20
                                       [<ffffffff8049fa44>] __inet_insert_ifa+0xd4/0x170
                                       [<ffffffff8049faed>] inet_insert_ifa+0xd/0x10
                                       [<ffffffff804a0eff>] inetdev_event+0x3df/0x480
                                       [<ffffffff804ed193>] notifier_call_chain+0x53/0x80
                                       [<ffffffff8026b739>] __raw_notifier_call_chain+0x9/0x10
                                       [<ffffffff8026b751>] raw_notifier_call_chain+0x11/0x20
                                       [<ffffffff8045b3a6>] call_netdevice_notifiers+0x16/0x20
                                       [<ffffffff8045ce52>] dev_open+0x82/0x90
                                       [<ffffffff8045b529>] dev_change_flags+0x99/0x1b0
                                       [<ffffffff804a171e>] devinet_ioctl+0x5ce/0x780
                                       [<ffffffff804a205c>] inet_ioctl+0x5c/0x80
                                       [<ffffffff8044c8b5>] sock_ioctl+0x65/0x250
                                       [<ffffffff802d5241>] vfs_ioctl+0x31/0x90
                                       [<ffffffff802d5313>] do_vfs_ioctl+0x73/0x2d0
                                       [<ffffffff802d55f2>] sys_ioctl+0x82/0xa0
                                       [<ffffffff8022044b>] system_call_after_swapgs+0x7b/0x80
                                       [<ffffffffffffffff>] 0xffffffffffffffff
   hardirq-on-R at:
                                       [<ffffffff80275bf0>] __lock_acquire+0x440/0x1080
                                       [<ffffffff80276895>] lock_acquire+0x65/0x90
                                       [<ffffffff804e9bc4>] _read_lock+0x34/0x70
                                       [<ffffffff804acdd7>] fn_hash_lookup+0x27/0xf0
                                       [<ffffffff804a855d>] inet_addr_type+0x6d/0xf0
                                       [<ffffffff804aada2>] fib_create_info+0x5a2/0xbf0
                                       [<ffffffff804acf0b>] fn_hash_insert+0x6b/0x720
                                       [<ffffffff804a88ef>] fib_magic+0x10f/0x120
                                       [<ffffffff804a89c8>] fib_add_ifaddr+0xc8/0x170
                                       [<ffffffff804a8b7b>] fib_inetaddr_event+0x4b/0x280
                                       [<ffffffff804ed193>] notifier_call_chain+0x53/0x80
                                       [<ffffffff8026b998>] __blocking_notifier_call_chain+0x58/0x80
                                       [<ffffffff8026b9d1>] blocking_notifier_call_chain+0x11/0x20
                                       [<ffffffff8049fa44>] __inet_insert_ifa+0xd4/0x170
                                       [<ffffffff8049faed>] inet_insert_ifa+0xd/0x10
                                       [<ffffffff804a0eff>] inetdev_event+0x3df/0x480
                                       [<ffffffff804ed193>] notifier_call_chain+0x53/0x80
                                       [<ffffffff8026b739>] __raw_notifier_call_chain+0x9/0x10
                                       [<ffffffff8026b751>] raw_notifier_call_chain+0x11/0x20
                                       [<ffffffff8045b3a6>] call_netdevice_notifiers+0x16/0x20
                                       [<ffffffff8045ce52>] dev_open+0x82/0x90
                                       [<ffffffff8045b529>] dev_change_flags+0x99/0x1b0
                                       [<ffffffff804a171e>] devinet_ioctl+0x5ce/0x780
                                       [<ffffffff804a205c>] inet_ioctl+0x5c/0x80
                                       [<ffffffff8044c8b5>] sock_ioctl+0x65/0x250
                                       [<ffffffff802d5241>] vfs_ioctl+0x31/0x90
                                       [<ffffffff802d5313>] do_vfs_ioctl+0x73/0x2d0
                                       [<ffffffff802d55f2>] sys_ioctl+0x82/0xa0
                                       [<ffffffff8022044b>] system_call_after_swapgs+0x7b/0x80
                                       [<ffffffffffffffff>] 0xffffffffffffffff
 }
 ... key      at: [<ffffffff806799b8>] fib_hash_lock+0x18/0x40

stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.25-rc4-sched-devel.git #56

Call Trace:
 <IRQ>  [<ffffffff80273a4c>] print_irq_inversion_bug+0x13c/0x160
 [<ffffffff80274a9d>] check_usage_forwards+0x4d/0x60
 [<ffffffff80274c46>] mark_lock+0x196/0x5e0
 [<ffffffff80275d15>] __lock_acquire+0x565/0x1080
 [<ffffffff80276895>] lock_acquire+0x65/0x90
 [<ffffffff804721ac>] ? rt_intern_hash+0x8c/0x3b0
 [<ffffffff804e99a6>] _spin_lock_bh+0x36/0x70
 [<ffffffff804721ac>] rt_intern_hash+0x8c/0x3b0
 [<ffffffff80473a4e>] ip_route_input+0x8fe/0x1250
 [<ffffffff8027530d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8027530d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff804769a8>] ip_rcv+0x518/0x650
 [<ffffffff8045a8f9>] netif_receive_skb+0x269/0x350
 [<ffffffff80405529>] e1000_clean_rx_irq+0x1a9/0x5a0
 [<ffffffff8040072b>] e1000_clean+0x1fb/0x5b0
 [<ffffffff8027268d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8045d18f>] net_rx_action+0xbf/0x180
 [<ffffffff80255c55>] __do_softirq+0x75/0x100
 [<ffffffff8022173c>] call_softirq+0x1c/0x30
 [<ffffffff80223505>] do_softirq+0x65/0xa0
 [<ffffffff80255b67>] irq_exit+0x97/0xa0
 [<ffffffff80223618>] do_IRQ+0xa8/0x130
 [<ffffffff80220a06>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8021ef83>] ? default_idle+0x43/0x80
 [<ffffffff8021ef81>] ? default_idle+0x41/0x80
 [<ffffffff8021ef40>] ? default_idle+0x0/0x80
 [<ffffffff8021f02d>] ? cpu_idle+0x6d/0x120
 [<ffffffff804e3edb>] ? start_secondary+0x31b/0x420

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Eric Dumazet <dada1@cosmosbay.com>
CC: David S. Miller <davem@davemloft.net>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 net/ipv4/fib_hash.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/fib_hash.c b/net/ipv4/fib_hash.c
index 8d58d85..9b48b18 100644
--- a/net/ipv4/fib_hash.c
+++ b/net/ipv4/fib_hash.c
@@ -251,7 +251,7 @@ fn_hash_lookup(struct fib_table *tb, const struct flowi *flp, struct fib_result
 	struct fn_zone *fz;
 	struct fn_hash *t = (struct fn_hash*)tb->tb_data;
 
-	read_lock(&fib_hash_lock);
+	read_lock_bh(&fib_hash_lock);
 	for (fz = t->fn_zone_list; fz; fz = fz->fz_next) {
 		struct hlist_head *head;
 		struct hlist_node *node;
@@ -273,7 +273,7 @@ fn_hash_lookup(struct fib_table *tb, const struct flowi *flp, struct fib_result
 	}
 	err = 1;
 out:
-	read_unlock(&fib_hash_lock);
+	read_unlock_bh(&fib_hash_lock);
 	return err;
 }
 
@@ -295,7 +295,7 @@ fn_hash_select_default(struct fib_table *tb, const struct flowi *flp, struct fib
 	last_resort = NULL;
 	order = -1;
 
-	read_lock(&fib_hash_lock);
+	read_lock_bh(&fib_hash_lock);
 	hlist_for_each_entry(f, node, &fz->fz_hash[0], fn_hash) {
 		struct fib_alias *fa;
 
@@ -343,7 +343,7 @@ fn_hash_select_default(struct fib_table *tb, const struct flowi *flp, struct fib
 		fib_result_assign(res, last_resort);
 	tb->tb_default = last_idx;
 out:
-	read_unlock(&fib_hash_lock);
+	read_unlock_bh(&fib_hash_lock);
 }
 
 /* Insert node F to FZ. */
@@ -753,18 +753,18 @@ static int fn_hash_dump(struct fib_table *tb, struct sk_buff *skb, struct netlin
 	struct fn_hash *table = (struct fn_hash*)tb->tb_data;
 
 	s_m = cb->args[2];
-	read_lock(&fib_hash_lock);
+	read_lock_bh(&fib_hash_lock);
 	for (fz = table->fn_zone_list, m=0; fz; fz = fz->fz_next, m++) {
 		if (m < s_m) continue;
 		if (fn_hash_dump_zone(skb, cb, tb, fz) < 0) {
 			cb->args[2] = m;
-			read_unlock(&fib_hash_lock);
+			read_unlock_bh(&fib_hash_lock);
 			return -1;
 		}
 		memset(&cb->args[3], 0,
 		       sizeof(cb->args) - 3*sizeof(cb->args[0]));
 	}
-	read_unlock(&fib_hash_lock);
+	read_unlock_bh(&fib_hash_lock);
 	cb->args[2] = m;
 	return skb->len;
 }
@@ -962,7 +962,7 @@ static void *fib_seq_start(struct seq_file *seq, loff_t *pos)
 	struct fib_iter_state *iter = seq->private;
 	void *v = NULL;
 
-	read_lock(&fib_hash_lock);
+	read_lock_bh(&fib_hash_lock);
 	if (fib_get_table(iter->p.net, RT_TABLE_MAIN))
 		v = *pos ? fib_get_idx(seq, *pos - 1) : SEQ_START_TOKEN;
 	return v;
@@ -977,7 +977,7 @@ static void *fib_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 static void fib_seq_stop(struct seq_file *seq, void *v)
 	__releases(fib_hash_lock)
 {
-	read_unlock(&fib_hash_lock);
+	read_unlock_bh(&fib_hash_lock);
 }
 
 static unsigned fib_flag_trans(int type, __be32 mask, struct fib_info *fi)
-- 
Thanks and Regards
gautham
