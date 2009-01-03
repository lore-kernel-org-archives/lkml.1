Return-Path: <linux-kernel-owner+w=401wt.eu-S1759924AbZACNVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924AbZACNVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 08:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbZACNVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 08:21:21 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:60776 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZACNVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 08:21:16 -0500
Date: Sat, 3 Jan 2009 18:51:00 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Unsafe lock order detected with &fbc->lock
Message-ID: <20090103132100.GA5610@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I am hitting this with git of yesterday or maybe day before yeseterday.
(top SHA is b58602a4bac012b5f4fc12fe6b46ab237b610d5d)

I am still not sure how to reproduce it.

thanks,
 
======================================================
[ INFO: soft-safe -> soft-unsafe lock order detected ]
2.6.28 #2
------------------------------------------------------
firefox/3695 [HC0[0]:SC0[1]:HE1:SE0] is trying to acquire:
 (&fbc->lock){--..}, at: [<c0548cf7>] __percpu_counter_add+0x52/0x7a

and this task is already holding:
 (slock-AF_INET){-+..}, at: [<c06adb82>] tcp_close+0x1a4/0x347
which would create a new lock dependency:
 (slock-AF_INET){-+..} -> (&fbc->lock){--..}

but this new dependency connects a soft-irq-safe lock:
 (slock-AF_INET){-+..}
... which became soft-irq-safe at:
  [<c04508b1>] __lock_acquire+0x272/0xb4a
  [<c04511f9>] lock_acquire+0x70/0x97
  [<c06f5f91>] _spin_lock+0x23/0x53
  [<c06c091d>] udp_queue_rcv_skb+0x123/0x1a3
  [<c06c0cfb>] __udp4_lib_rcv+0x35e/0x517
  [<c06c0ecb>] udp_rcv+0x17/0x19
  [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
  [<c06a4a87>] ip_local_deliver+0x66/0x6f
  [<c06a4685>] ip_rcv_finish+0x241/0x257
  [<c06a488d>] ip_rcv+0x1f2/0x21c
  [<c0682464>] netif_receive_skb+0x322/0x355
  [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
  [<c068288b>] process_backlog+0x8e/0xca
  [<c0680fc7>] net_rx_action+0x70/0x16b
  [<c043653a>] __do_softirq+0x9d/0x157
  [<ffffffff>] 0xffffffff

to a soft-irq-unsafe lock:
 (&fbc->lock){--..}
... which became soft-irq-unsafe at:
...  [<c045092c>] __lock_acquire+0x2ed/0xb4a
  [<c04511f9>] lock_acquire+0x70/0x97
  [<c06f5f91>] _spin_lock+0x23/0x53
  [<c0548c68>] __percpu_counter_sum+0xd/0x4a
  [<c04f383d>] ext3_statfs+0xbf/0x163
  [<c04a75b2>] vfs_statfs+0x4e/0x67
  [<c04a769f>] sys_statfs64+0x49/0x85
  [<c0403b6b>] sysenter_do_call+0x12/0x3f
  [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by firefox/3695:
 #0:  (slock-AF_INET){-+..}, at: [<c06adb82>] tcp_close+0x1a4/0x347

the soft-irq-safe lock's dependencies:
-> (slock-AF_INET){-+..} ops: 67148 {
   initial-use  at:
                        [<c0450941>] __lock_acquire+0x302/0xb4a
                        [<c04511f9>] lock_acquire+0x70/0x97
                        [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                        [<c0679230>] lock_sock_nested+0x31/0xd0
                        [<c06ad9f8>] tcp_close+0x1a/0x347
                        [<c06c7106>] inet_release+0x4e/0x54
                        [<c0677608>] sock_release+0x19/0x65
                        [<c0677675>] sock_close+0x21/0x25
                        [<c04a8e00>] __fput+0xd4/0x164
                        [<c04a8eac>] fput+0x1c/0x1e
                        [<c04a64c8>] filp_close+0x55/0x5f
                        [<c04a654a>] sys_close+0x78/0xb2
                        [<c0403b6b>] sysenter_do_call+0x12/0x3f
                        [<ffffffff>] 0xffffffff
   in-softirq-W at:
                        [<c04508b1>] __lock_acquire+0x272/0xb4a
                        [<c04511f9>] lock_acquire+0x70/0x97
                        [<c06f5f91>] _spin_lock+0x23/0x53
                        [<c06c091d>] udp_queue_rcv_skb+0x123/0x1a3
                        [<c06c0cfb>] __udp4_lib_rcv+0x35e/0x517
                        [<c06c0ecb>] udp_rcv+0x17/0x19
                        [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
                        [<c06a4a87>] ip_local_deliver+0x66/0x6f
                        [<c06a4685>] ip_rcv_finish+0x241/0x257
                        [<c06a488d>] ip_rcv+0x1f2/0x21c
                        [<c0682464>] netif_receive_skb+0x322/0x355
                        [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
                        [<c068288b>] process_backlog+0x8e/0xca
                        [<c0680fc7>] net_rx_action+0x70/0x16b
                        [<c043653a>] __do_softirq+0x9d/0x157
                        [<ffffffff>] 0xffffffff
   hardirq-on-W at:
                        [<c045090b>] __lock_acquire+0x2cc/0xb4a
                        [<c04511f9>] lock_acquire+0x70/0x97
                        [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                        [<c0679230>] lock_sock_nested+0x31/0xd0
                        [<c06ad9f8>] tcp_close+0x1a/0x347
                        [<c06c7106>] inet_release+0x4e/0x54
                        [<c0677608>] sock_release+0x19/0x65
                        [<c0677675>] sock_close+0x21/0x25
                        [<c04a8e00>] __fput+0xd4/0x164
                        [<c04a8eac>] fput+0x1c/0x1e
                        [<c04a64c8>] filp_close+0x55/0x5f
                        [<c04a654a>] sys_close+0x78/0xb2
                        [<c0403b6b>] sysenter_do_call+0x12/0x3f
                        [<ffffffff>] 0xffffffff
 }
 ... key      at: [<c0ff9404>] af_family_slock_keys+0x10/0x120
 -> (&list->lock){-+..} ops: 10858 {
    initial-use  at:
                          [<c0450941>] __lock_acquire+0x302/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                          [<c067c08e>] skb_queue_tail+0x19/0x37
                          [<c0696f28>] netlink_broadcast+0x1be/0x29f
                          [<c053f01b>] kobject_uevent_env+0x263/0x2fd
                          [<c053f0bf>] kobject_uevent+0xa/0xc
                          [<c05bdcab>] device_add+0x313/0x475
                          [<c063aa1f>] input_register_device+0xae/0x181
                          [<c06416d0>] psmouse_connect+0x181/0x239
                          [<c0636fe4>] serio_connect_driver+0x25/0x35
                          [<c063700f>] serio_driver_probe+0x1b/0x1d
                          [<c05bf710>] driver_probe_device+0xa7/0x143
                          [<c05bf800>] __driver_attach+0x54/0x76
                          [<c05bf0c4>] bus_for_each_dev+0x43/0x6d
                          [<c05bf596>] driver_attach+0x19/0x1b
                          [<c06379bc>] serio_thread+0x16a/0x2e7
                          [<c0442ae0>] kthread+0x40/0x66
                          [<c040453f>] kernel_thread_helper+0x7/0x10
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c04508b1>] __lock_acquire+0x272/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                          [<c067c08e>] skb_queue_tail+0x19/0x37
                          [<c067ac0a>] sock_queue_rcv_skb+0xb1/0xd3
                          [<c06bfa49>] __udp_queue_rcv_skb+0x17/0x8b
                          [<c06c092c>] udp_queue_rcv_skb+0x132/0x1a3
                          [<c06c0cfb>] __udp4_lib_rcv+0x35e/0x517
                          [<c06c0ecb>] udp_rcv+0x17/0x19
                          [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
                          [<c06a4a87>] ip_local_deliver+0x66/0x6f
                          [<c06a4685>] ip_rcv_finish+0x241/0x257
                          [<c06a488d>] ip_rcv+0x1f2/0x21c
                          [<c0682464>] netif_receive_skb+0x322/0x355
                          [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
                          [<c068288b>] process_backlog+0x8e/0xca
                          [<c0680fc7>] net_rx_action+0x70/0x16b
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
    hardirq-on-W at:
                          [<c045090b>] __lock_acquire+0x2cc/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                          [<c06bfe8a>] udp_poll+0x58/0xec
                          [<c06763e9>] sock_poll+0x17/0x1a
                          [<c04b3690>] do_sys_poll+0x21a/0x3cd
                          [<c04b3992>] sys_poll+0x45/0x8f
                          [<c0403b6b>] sysenter_do_call+0x12/0x3f
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c0ff92a0>] __key.25807+0x0/0x8
 ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<c067c08e>] skb_queue_tail+0x19/0x37
   [<c067ac0a>] sock_queue_rcv_skb+0xb1/0xd3
   [<c06bfa49>] __udp_queue_rcv_skb+0x17/0x8b
   [<c06c092c>] udp_queue_rcv_skb+0x132/0x1a3
   [<c06c0cfb>] __udp4_lib_rcv+0x35e/0x517
   [<c06c0ecb>] udp_rcv+0x17/0x19
   [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
   [<c06a4a87>] ip_local_deliver+0x66/0x6f
   [<c06a4685>] ip_rcv_finish+0x241/0x257
   [<c06a488d>] ip_rcv+0x1f2/0x21c
   [<c0682464>] netif_receive_skb+0x322/0x355
   [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
   [<c068288b>] process_backlog+0x8e/0xca
   [<c0680fc7>] net_rx_action+0x70/0x16b
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

 -> (&q->lock){++..} ops: 12122994 {
    initial-use  at:
                          [<c0450941>] __lock_acquire+0x302/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f604b>] _spin_lock_irq+0x32/0x62
                          [<c06f4278>] wait_for_common+0x34/0xde
                          [<c06f43ad>] wait_for_completion+0x17/0x19
                          [<c0442ca0>] kthread_create+0x6e/0x96
                          [<c06f19ac>] migration_call+0x39/0x41b
                          [<c08e2436>] migration_init+0x1d/0x4b
                          [<c0401137>] _stext+0x4f/0x127
                          [<c08cd257>] kernel_init+0x53/0x150
                          [<c040453f>] kernel_thread_helper+0x7/0x10
                          [<ffffffff>] 0xffffffff
    in-hardirq-W at:
                          [<c045088e>] __lock_acquire+0x24f/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                          [<c04250ac>] __wake_up+0x1a/0x40
                          [<c0585354>] acpi_ec_gpe_handler+0x5b/0xcb
                          [<c0571b3f>] acpi_ev_gpe_dispatch+0x51/0x10f
                          [<c0571c9c>] acpi_ev_gpe_detect+0x9f/0xe6
                          [<c05701ed>] acpi_ev_sci_xrupt_handler+0x1a/0x20
                          [<c056ac6b>] acpi_irq+0x13/0x28
                          [<c046fb98>] handle_IRQ_event+0x1f/0x54
                          [<c0470db1>] handle_fasteoi_irq+0x7d/0xb6
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c04508b1>] __lock_acquire+0x272/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                          [<c04250ac>] __wake_up+0x1a/0x40
                          [<c0585354>] acpi_ec_gpe_handler+0x5b/0xcb
                          [<c0571b3f>] acpi_ev_gpe_dispatch+0x51/0x10f
                          [<c0571c9c>] acpi_ev_gpe_detect+0x9f/0xe6
                          [<c05701ed>] acpi_ev_sci_xrupt_handler+0x1a/0x20
                          [<c056ac6b>] acpi_irq+0x13/0x28
                          [<c046fb98>] handle_IRQ_event+0x1f/0x54
                          [<c0470db1>] handle_fasteoi_irq+0x7d/0xb6
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c0bc4440>] __key.17929+0x0/0x8
  -> (&rq->lock){++..} ops: 14736567 {
     initial-use  at:
                            [<c0450941>] __lock_acquire+0x302/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                            [<c0424f3e>] rq_attach_root+0x17/0x9b
                            [<c08e26c2>] sched_init+0x25e/0x3c8
                            [<c08cd648>] start_kernel+0x112/0x329
                            [<c08cd085>] __init_begin+0x85/0x8d
                            [<ffffffff>] 0xffffffff
     in-hardirq-W at:
                            [<c045088e>] __lock_acquire+0x24f/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f5f91>] _spin_lock+0x23/0x53
                            [<c042ed34>] scheduler_tick+0x3f/0x17d
                            [<c0439c10>] update_process_times+0x47/0x53
                            [<c044bb2d>] tick_periodic+0x6b/0x77
                            [<c044bb57>] tick_handle_periodic+0x1e/0x6f
                            [<c04059c6>] timer_interrupt+0x46/0x4d
                            [<c046fb98>] handle_IRQ_event+0x1f/0x54
                            [<c0470e56>] handle_level_irq+0x6c/0xb4
                            [<ffffffff>] 0xffffffff
     in-softirq-W at:
                            [<c04508b1>] __lock_acquire+0x272/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f5f91>] _spin_lock+0x23/0x53
                            [<c042ed34>] scheduler_tick+0x3f/0x17d
                            [<c0439c10>] update_process_times+0x47/0x53
                            [<c044bb2d>] tick_periodic+0x6b/0x77
                            [<c044bb57>] tick_handle_periodic+0x1e/0x6f
                            [<c06f93fc>] __irqentry_text_start+0x74/0x87
                            [<c04043e1>] apic_timer_interrupt+0x2d/0x34
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c0ac11e4>] __key.45378+0x0/0x8
   -> (&vec->lock){.+..} ops: 271976 {
      initial-use  at:
                              [<c0450941>] __lock_acquire+0x302/0xb4a
                              [<c04511f9>] lock_acquire+0x70/0x97
                              [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                              [<c04802f8>] cpupri_set+0xb8/0x112
                              [<c0429179>] rq_online_rt+0x61/0x64
                              [<c0423a60>] set_rq_online+0x43/0x4d
                              [<c0424fb2>] rq_attach_root+0x8b/0x9b
                              [<c08e26c2>] sched_init+0x25e/0x3c8
                              [<c08cd648>] start_kernel+0x112/0x329
                              [<c08cd085>] __init_begin+0x85/0x8d
                              [<ffffffff>] 0xffffffff
      in-softirq-W at:
                              [<c04508b1>] __lock_acquire+0x272/0xb4a
                              [<c04511f9>] lock_acquire+0x70/0x97
                              [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                              [<c04802a6>] cpupri_set+0x66/0x112
                              [<c0429281>] __enqueue_rt_entity+0x105/0x1f0
                              [<c0429726>] enqueue_rt_entity+0x39/0x44
                              [<c0429758>] enqueue_task_rt+0x27/0x38
                              [<c0422d69>] enqueue_task+0x51/0x5d
                              [<c0422eb0>] activate_task+0x1e/0x24
                              [<c042b61b>] try_to_wake_up+0x1ab/0x238
                              [<c042b6df>] wake_up_process+0x14/0x16
                              [<c042ba1b>] rebalance_domains+0x33a/0x42c
                              [<c042bb40>] run_rebalance_domains+0x33/0x9d
                              [<c043653a>] __do_softirq+0x9d/0x157
                              [<ffffffff>] 0xffffffff
    }
    ... key      at: [<c0fc7564>] __key.14666+0x0/0x1c
   ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<c04802f8>] cpupri_set+0xb8/0x112
   [<c0429179>] rq_online_rt+0x61/0x64
   [<c0423a60>] set_rq_online+0x43/0x4d
   [<c0424fb2>] rq_attach_root+0x8b/0x9b
   [<c08e26c2>] sched_init+0x25e/0x3c8
   [<c08cd648>] start_kernel+0x112/0x329
   [<c08cd085>] __init_begin+0x85/0x8d
   [<ffffffff>] 0xffffffff

   -> (&rt_b->rt_runtime_lock){.+..} ops: 615 {
      initial-use  at:
                              [<c0450941>] __lock_acquire+0x302/0xb4a
                              [<c04511f9>] lock_acquire+0x70/0x97
                              [<c06f5f91>] _spin_lock+0x23/0x53
                              [<c0429303>] __enqueue_rt_entity+0x187/0x1f0
                              [<c0429726>] enqueue_rt_entity+0x39/0x44
                              [<c0429758>] enqueue_task_rt+0x27/0x38
                              [<c0422d69>] enqueue_task+0x51/0x5d
                              [<c0422eb0>] activate_task+0x1e/0x24
                              [<c042b61b>] try_to_wake_up+0x1ab/0x238
                              [<c042b6df>] wake_up_process+0x14/0x16
                              [<c06f1a2c>] migration_call+0xb9/0x41b
                              [<c08e2454>] migration_init+0x3b/0x4b
                              [<c0401137>] _stext+0x4f/0x127
                              [<c08cd257>] kernel_init+0x53/0x150
                              [<c040453f>] kernel_thread_helper+0x7/0x10
                              [<ffffffff>] 0xffffffff
      in-softirq-W at:
                              [<c04508b1>] __lock_acquire+0x272/0xb4a
                              [<c04511f9>] lock_acquire+0x70/0x97
                              [<c06f5f91>] _spin_lock+0x23/0x53
                              [<c0429303>] __enqueue_rt_entity+0x187/0x1f0
                              [<c0429726>] enqueue_rt_entity+0x39/0x44
                              [<c0429758>] enqueue_task_rt+0x27/0x38
                              [<c0422d69>] enqueue_task+0x51/0x5d
                              [<c0422eb0>] activate_task+0x1e/0x24
                              [<c042b61b>] try_to_wake_up+0x1ab/0x238
                              [<c042b6df>] wake_up_process+0x14/0x16
                              [<c042ba1b>] rebalance_domains+0x33a/0x42c
                              [<c042bb40>] run_rebalance_domains+0x33/0x9d
                              [<c043653a>] __do_softirq+0x9d/0x157
                              [<ffffffff>] 0xffffffff
    }
    ... key      at: [<c0ac11d0>] __key.36757+0x0/0x8
    -> (&cpu_base->lock){++..} ops: 8754644 {
       initial-use  at:
                                [<c0450941>] __lock_acquire+0x302/0xb4a
                                [<c04511f9>] lock_acquire+0x70/0x97
                                [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                                [<c04458cc>] lock_hrtimer_base+0x1d/0x38
                                [<c04459d1>] hrtimer_start_range_ns+0x1e/0x140
                                [<c04257ea>] hrtimer_start_expires+0x1f/0x27
                                [<c042932f>] __enqueue_rt_entity+0x1b3/0x1f0
                                [<c0429726>] enqueue_rt_entity+0x39/0x44
                                [<c0429758>] enqueue_task_rt+0x27/0x38
                                [<c0422d69>] enqueue_task+0x51/0x5d
                                [<c0422eb0>] activate_task+0x1e/0x24
                                [<c042b61b>] try_to_wake_up+0x1ab/0x238
                                [<c042b6df>] wake_up_process+0x14/0x16
                                [<c06f1a2c>] migration_call+0xb9/0x41b
                                [<c08e2454>] migration_init+0x3b/0x4b
                                [<c0401137>] _stext+0x4f/0x127
                                [<c08cd257>] kernel_init+0x53/0x150
                                [<c040453f>] kernel_thread_helper+0x7/0x10
                                [<ffffffff>] 0xffffffff
       in-hardirq-W at:
                                [<c045088e>] __lock_acquire+0x24f/0xb4a
                                [<c04511f9>] lock_acquire+0x70/0x97
                                [<c06f5f91>] _spin_lock+0x23/0x53
                                [<c04455b3>] hrtimer_run_queues+0xd4/0x11e
                                [<c0439b73>] run_local_timers+0xd/0x1e
                                [<c0439bf2>] update_process_times+0x29/0x53
                                [<c044bb2d>] tick_periodic+0x6b/0x77
                                [<c044bb57>] tick_handle_periodic+0x1e/0x6f
                                [<c06f93fc>] __irqentry_text_start+0x74/0x87
                                [<c04043e1>] apic_timer_interrupt+0x2d/0x34
                                [<c0485e1c>] __alloc_pages_internal+0xb5/0x3a3
                                [<c048614e>] __get_free_pages+0x19/0x29
                                [<c047a01e>] ring_buffer_alloc+0x1a1/0x2d0
                                [<c08e5645>] tracer_alloc_buffers+0x1e/0x15d
                                [<c0401137>] _stext+0x4f/0x127
                                [<c08cd257>] kernel_init+0x53/0x150
                                [<c040453f>] kernel_thread_helper+0x7/0x10
                                [<ffffffff>] 0xffffffff
       in-softirq-W at:
                                [<c04508b1>] __lock_acquire+0x272/0xb4a
                                [<c04511f9>] lock_acquire+0x70/0x97
                                [<c06f5f91>] _spin_lock+0x23/0x53
                                [<c04455b3>] hrtimer_run_queues+0xd4/0x11e
                                [<c0439b73>] run_local_timers+0xd/0x1e
                                [<c0439bf2>] update_process_times+0x29/0x53
                                [<c044bb2d>] tick_periodic+0x6b/0x77
                                [<c044bb57>] tick_handle_periodic+0x1e/0x6f
                                [<c06f93fc>] __irqentry_text_start+0x74/0x87
                                [<c04043e1>] apic_timer_interrupt+0x2d/0x34
                                [<ffffffff>] 0xffffffff
     }
     ... key      at: [<c0bc4468>] __key.20157+0x0/0x8
    ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<c04458cc>] lock_hrtimer_base+0x1d/0x38
   [<c04459d1>] hrtimer_start_range_ns+0x1e/0x140
   [<c04257ea>] hrtimer_start_expires+0x1f/0x27
   [<c042932f>] __enqueue_rt_entity+0x1b3/0x1f0
   [<c0429726>] enqueue_rt_entity+0x39/0x44
   [<c0429758>] enqueue_task_rt+0x27/0x38
   [<c0422d69>] enqueue_task+0x51/0x5d
   [<c0422eb0>] activate_task+0x1e/0x24
   [<c042b61b>] try_to_wake_up+0x1ab/0x238
   [<c042b6df>] wake_up_process+0x14/0x16
   [<c06f1a2c>] migration_call+0xb9/0x41b
   [<c08e2454>] migration_init+0x3b/0x4b
   [<c0401137>] _stext+0x4f/0x127
   [<c08cd257>] kernel_init+0x53/0x150
   [<c040453f>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

    -> (&rt_rq->rt_runtime_lock){++..} ops: 138664 {
       initial-use  at:
                                [<c0450941>] __lock_acquire+0x302/0xb4a
                                [<c04511f9>] lock_acquire+0x70/0x97
                                [<c06f5f91>] _spin_lock+0x23/0x53
                                [<c0429501>] update_curr_rt+0x141/0x21e
                                [<c04296d1>] dequeue_task_rt+0x13/0x2f
                                [<c0422e80>] dequeue_task+0x10b/0x11d
                                [<c0422ed4>] deactivate_task+0x1e/0x24
                                [<c06f3bee>] schedule+0x160/0x6a9
                                [<c042e891>] migration_thread+0x15b/0x1ed
                                [<c0442ae0>] kthread+0x40/0x66
                                [<c040453f>] kernel_thread_helper+0x7/0x10
                                [<ffffffff>] 0xffffffff
       in-hardirq-W at:
                                [<c045088e>] __lock_acquire+0x24f/0xb4a
                                [<c04511f9>] lock_acquire+0x70/0x97
                                [<c06f5f91>] _spin_lock+0x23/0x53
                                [<c0429850>] sched_rt_period_timer+0xe7/0x23d
                                [<c0445290>] __run_hrtimer+0x70/0xa2
                                [<c0445e14>] hrtimer_interrupt+0xc8/0x122
                                [<c06f93fc>] __irqentry_text_start+0x74/0x87
                                [<c04043e1>] apic_timer_interrupt+0x2d/0x34
                                [<c08d156b>] inflate_dynamic+0x4c0/0x4f0
                                [<c08d2352>] unpack_to_rootfs+0x520/0x961
                                [<c08d28a8>] populate_rootfs+0x76/0xcd
                                [<c0401137>] _stext+0x4f/0x127
                                [<c08cd306>] kernel_init+0x102/0x150
                                [<c040453f>] kernel_thread_helper+0x7/0x10
                                [<ffffffff>] 0xffffffff
       in-softirq-W at:
                                [<c04508b1>] __lock_acquire+0x272/0xb4a
                                [<c04511f9>] lock_acquire+0x70/0x97
                                [<c06f5f91>] _spin_lock+0x23/0x53
                                [<c0429850>] sched_rt_period_timer+0xe7/0x23d
                                [<c0445290>] __run_hrtimer+0x70/0xa2
                                [<c0445e14>] hrtimer_interrupt+0xc8/0x122
                                [<c06f93fc>] __irqentry_text_start+0x74/0x87
                                [<c04043e1>] apic_timer_interrupt+0x2d/0x34
                                [<c0471ec9>] cpu_quiet+0x43/0x72
                                [<c047257a>] __rcu_process_callbacks+0x66/0x207
                                [<c0472756>] rcu_process_callbacks+0x3b/0x42
                                [<c043653a>] __do_softirq+0x9d/0x157
                                [<ffffffff>] 0xffffffff
     }
     ... key      at: [<c0ac11d8>] __key.45309+0x0/0x8
    ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c0427db2>] __enable_runtime+0x4a/0xb1
   [<c042915f>] rq_online_rt+0x47/0x64
   [<c0423a60>] set_rq_online+0x43/0x4d
   [<c06f1a66>] migration_call+0xf3/0x41b
   [<c06f847f>] notifier_call_chain+0x2b/0x4a
   [<c0446833>] raw_notifier_call_chain+0x11/0x13
   [<c06f1fc0>] _cpu_up+0xbd/0xfc
   [<c06f204f>] cpu_up+0x50/0x65
   [<c08cd29d>] kernel_init+0x99/0x150
   [<c040453f>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

   ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c0429303>] __enqueue_rt_entity+0x187/0x1f0
   [<c0429726>] enqueue_rt_entity+0x39/0x44
   [<c0429758>] enqueue_task_rt+0x27/0x38
   [<c0422d69>] enqueue_task+0x51/0x5d
   [<c0422eb0>] activate_task+0x1e/0x24
   [<c042b61b>] try_to_wake_up+0x1ab/0x238
   [<c042b6df>] wake_up_process+0x14/0x16
   [<c06f1a2c>] migration_call+0xb9/0x41b
   [<c08e2454>] migration_init+0x3b/0x4b
   [<c0401137>] _stext+0x4f/0x127
   [<c08cd257>] kernel_init+0x53/0x150
   [<c040453f>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

   ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c0429501>] update_curr_rt+0x141/0x21e
   [<c04296d1>] dequeue_task_rt+0x13/0x2f
   [<c0422e80>] dequeue_task+0x10b/0x11d
   [<c0422ed4>] deactivate_task+0x1e/0x24
   [<c06f3bee>] schedule+0x160/0x6a9
   [<c042e891>] migration_thread+0x15b/0x1ed
   [<c0442ae0>] kthread+0x40/0x66
   [<c040453f>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

   -> (&rq->lock/1){.+..} ops: 106313 {
      initial-use  at:
                              [<c0450941>] __lock_acquire+0x302/0xb4a
                              [<c04511f9>] lock_acquire+0x70/0x97
                              [<c06f5f3e>] _spin_lock_nested+0x21/0x51
                              [<c0429b41>] double_rq_lock+0x53/0x65
                              [<c0429ba2>] __migrate_task+0x4f/0xc5
                              [<c042e8c4>] migration_thread+0x18e/0x1ed
                              [<c0442ae0>] kthread+0x40/0x66
                              [<c040453f>] kernel_thread_helper+0x7/0x10
                              [<ffffffff>] 0xffffffff
      in-softirq-W at:
                              [<c04508b1>] __lock_acquire+0x272/0xb4a
                              [<c04511f9>] lock_acquire+0x70/0x97
                              [<c06f5f3e>] _spin_lock_nested+0x21/0x51
                              [<c0429b41>] double_rq_lock+0x53/0x65
                              [<c042b89c>] rebalance_domains+0x1bb/0x42c
                              [<c042bb40>] run_rebalance_domains+0x33/0x9d
                              [<c043653a>] __do_softirq+0x9d/0x157
                              [<ffffffff>] 0xffffffff
    }
    ... key      at: [<c0ac11e5>] __key.45378+0x1/0x8
   ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f3e>] _spin_lock_nested+0x21/0x51
   [<c0429b41>] double_rq_lock+0x53/0x65
   [<c0429ba2>] __migrate_task+0x4f/0xc5
   [<c042e8c4>] migration_thread+0x18e/0x1ed
   [<c0442ae0>] kthread+0x40/0x66
   [<c040453f>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

  ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c0425311>] task_rq_lock+0x4e/0x78
   [<c042b4e0>] try_to_wake_up+0x70/0x238
   [<c042b6b8>] default_wake_function+0x10/0x12
   [<c042343a>] __wake_up_common+0x3a/0x60
   [<c0425036>] complete+0x30/0x43
   [<c0442ac4>] kthread+0x24/0x66
   [<c040453f>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

  -> (&ep->lock){.+..} ops: 165035 {
     initial-use  at:
                            [<c0450941>] __lock_acquire+0x302/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                            [<c04cd20d>] sys_epoll_ctl+0x259/0x432
                            [<c0403b6b>] sysenter_do_call+0x12/0x3f
                            [<ffffffff>] 0xffffffff
     in-softirq-W at:
                            [<c04508b1>] __lock_acquire+0x272/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                            [<c04cc85f>] ep_poll_callback+0x1b/0xb9
                            [<c042343a>] __wake_up_common+0x3a/0x60
                            [<c042507f>] __wake_up_sync+0x36/0x49
                            [<c067960e>] sock_def_readable+0x3d/0x68
                            [<c06bd1d8>] tcp_child_process+0x4c/0x9a
                            [<c06bbf0c>] tcp_v4_do_rcv+0x249/0x2ad
                            [<c06bc2d6>] tcp_v4_rcv+0x366/0x553
                            [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
                            [<c06a4a87>] ip_local_deliver+0x66/0x6f
                            [<c06a4685>] ip_rcv_finish+0x241/0x257
                            [<c06a488d>] ip_rcv+0x1f2/0x21c
                            [<c0682464>] netif_receive_skb+0x322/0x355
                            [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
                            [<c068288b>] process_backlog+0x8e/0xca
                            [<c0680fc7>] net_rx_action+0x70/0x16b
                            [<c043653a>] __do_softirq+0x9d/0x157
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c0fd2b24>] __key.22330+0x0/0x8
   ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c0425311>] task_rq_lock+0x4e/0x78
   [<c042b4e0>] try_to_wake_up+0x70/0x238
   [<c042b6b8>] default_wake_function+0x10/0x12
   [<c042343a>] __wake_up_common+0x3a/0x60
   [<c0423476>] __wake_up_locked+0x16/0x1a
   [<c04cc8bf>] ep_poll_callback+0x7b/0xb9
   [<c042343a>] __wake_up_common+0x3a/0x60
   [<c042507f>] __wake_up_sync+0x36/0x49
   [<c067960e>] sock_def_readable+0x3d/0x68
   [<c06d92c8>] unix_stream_connect+0x33d/0x381
   [<c0677db7>] sys_connect+0x65/0x82
   [<c0678470>] sys_socketcall+0x93/0x192
   [<c0403b6b>] sysenter_do_call+0x12/0x3f
   [<ffffffff>] 0xffffffff

  ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<c04cc85f>] ep_poll_callback+0x1b/0xb9
   [<c042343a>] __wake_up_common+0x3a/0x60
   [<c042507f>] __wake_up_sync+0x36/0x49
   [<c067960e>] sock_def_readable+0x3d/0x68
   [<c06d92c8>] unix_stream_connect+0x33d/0x381
   [<c0677db7>] sys_connect+0x65/0x82
   [<c0678470>] sys_socketcall+0x93/0x192
   [<c0403b6b>] sysenter_do_call+0x12/0x3f
   [<ffffffff>] 0xffffffff

 ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<c0425067>] __wake_up_sync+0x1e/0x49
   [<c067960e>] sock_def_readable+0x3d/0x68
   [<c067ac22>] sock_queue_rcv_skb+0xc9/0xd3
   [<c06bfa49>] __udp_queue_rcv_skb+0x17/0x8b
   [<c06c092c>] udp_queue_rcv_skb+0x132/0x1a3
   [<c06c0cfb>] __udp4_lib_rcv+0x35e/0x517
   [<c06c0ecb>] udp_rcv+0x17/0x19
   [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
   [<c06a4a87>] ip_local_deliver+0x66/0x6f
   [<c06a4685>] ip_rcv_finish+0x241/0x257
   [<c06a488d>] ip_rcv+0x1f2/0x21c
   [<c0682464>] netif_receive_skb+0x322/0x355
   [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
   [<c068288b>] process_backlog+0x8e/0xca
   [<c0680fc7>] net_rx_action+0x70/0x16b
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

 -> (&tcp_hashinfo.bhash[i].lock){-+..} ops: 446 {
    initial-use  at:
                          [<c0450941>] __lock_acquire+0x302/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5f91>] _spin_lock+0x23/0x53
                          [<c06ac39b>] inet_csk_get_port+0xe2/0x1eb
                          [<c06c701c>] inet_bind+0xfb/0x197
                          [<c0677e33>] sys_bind+0x5f/0x7e
                          [<c067845c>] sys_socketcall+0x7f/0x192
                          [<c0403b6b>] sysenter_do_call+0x12/0x3f
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c04508b1>] __lock_acquire+0x272/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5f91>] _spin_lock+0x23/0x53
                          [<c06aac08>] inet_put_port+0x35/0x76
                          [<c06ad682>] tcp_set_state+0xaa/0xe1
                          [<c06ad6f2>] tcp_done+0x39/0x65
                          [<c06b63b7>] tcp_rcv_state_process+0x7b5/0x892
                          [<c06bbf27>] tcp_v4_do_rcv+0x264/0x2ad
                          [<c06bc2d6>] tcp_v4_rcv+0x366/0x553
                          [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
                          [<c06a4a87>] ip_local_deliver+0x66/0x6f
                          [<c06a4685>] ip_rcv_finish+0x241/0x257
                          [<c06a488d>] ip_rcv+0x1f2/0x21c
                          [<c0682464>] netif_receive_skb+0x322/0x355
                          [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
                          [<c068288b>] process_backlog+0x8e/0xca
                          [<c0680fc7>] net_rx_action+0x70/0x16b
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
    hardirq-on-W at:
                          [<c045090b>] __lock_acquire+0x2cc/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5f91>] _spin_lock+0x23/0x53
                          [<c06ac39b>] inet_csk_get_port+0xe2/0x1eb
                          [<c06c701c>] inet_bind+0xfb/0x197
                          [<c0677e33>] sys_bind+0x5f/0x7e
                          [<c067845c>] sys_socketcall+0x7f/0x192
                          [<c0403b6b>] sysenter_do_call+0x12/0x3f
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c0ffaa00>] __key.44731+0x0/0x8
  -> (&hashinfo->ehash_locks[i]){-+..} ops: 758 {
     initial-use  at:
                            [<c0450941>] __lock_acquire+0x302/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f5f91>] _spin_lock+0x23/0x53
                            [<c06aa452>] __inet_hash_nolisten+0x7e/0xb3
                            [<c06aae2d>] __inet_hash_connect+0x193/0x22b
                            [<c06aaf00>] inet_hash_connect+0x3b/0x43
                            [<c06bd019>] tcp_v4_connect+0x34b/0x4be
                            [<c06c6dae>] inet_stream_connect+0x8f/0x202
                            [<c0677db7>] sys_connect+0x65/0x82
                            [<c0678470>] sys_socketcall+0x93/0x192
                            [<c0403b6b>] sysenter_do_call+0x12/0x3f
                            [<ffffffff>] 0xffffffff
     in-softirq-W at:
                            [<c04508b1>] __lock_acquire+0x272/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                            [<c06aa7b1>] inet_unhash+0x4b/0x8a
                            [<c06ad66c>] tcp_set_state+0x94/0xe1
                            [<c06ad6f2>] tcp_done+0x39/0x65
                            [<c06b63b7>] tcp_rcv_state_process+0x7b5/0x892
                            [<c06bbf27>] tcp_v4_do_rcv+0x264/0x2ad
                            [<c06bc2d6>] tcp_v4_rcv+0x366/0x553
                            [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
                            [<c06a4a87>] ip_local_deliver+0x66/0x6f
                            [<c06a4685>] ip_rcv_finish+0x241/0x257
                            [<c06a488d>] ip_rcv+0x1f2/0x21c
                            [<c0682464>] netif_receive_skb+0x322/0x355
                            [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
                            [<c068288b>] process_backlog+0x8e/0xca
                            [<c0680fc7>] net_rx_action+0x70/0x16b
                            [<c043653a>] __do_softirq+0x9d/0x157
                            [<ffffffff>] 0xffffffff
     hardirq-on-W at:
                            [<c045090b>] __lock_acquire+0x2cc/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f5f91>] _spin_lock+0x23/0x53
                            [<c06aa452>] __inet_hash_nolisten+0x7e/0xb3
                            [<c06aae2d>] __inet_hash_connect+0x193/0x22b
                            [<c06aaf00>] inet_hash_connect+0x3b/0x43
                            [<c06bd019>] tcp_v4_connect+0x34b/0x4be
                            [<c06c6dae>] inet_stream_connect+0x8f/0x202
                            [<c0677db7>] sys_connect+0x65/0x82
                            [<c0678470>] sys_socketcall+0x93/0x192
                            [<c0403b6b>] sysenter_do_call+0x12/0x3f
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c0ffaa08>] __key.37899+0x0/0x8
  ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c06aa452>] __inet_hash_nolisten+0x7e/0xb3
   [<c06aae2d>] __inet_hash_connect+0x193/0x22b
   [<c06aaf00>] inet_hash_connect+0x3b/0x43
   [<c06bd019>] tcp_v4_connect+0x34b/0x4be
   [<c06c6dae>] inet_stream_connect+0x8f/0x202
   [<c0677db7>] sys_connect+0x65/0x82
   [<c0678470>] sys_socketcall+0x93/0x192
   [<c0403b6b>] sysenter_do_call+0x12/0x3f
   [<ffffffff>] 0xffffffff

 ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c06aac08>] inet_put_port+0x35/0x76
   [<c06bb532>] tcp_v4_destroy_sock+0x1ac/0x1e1
   [<c06abaad>] inet_csk_destroy_sock+0x8c/0xbd
   [<c06adcfc>] tcp_close+0x31e/0x347
   [<c06c7106>] inet_release+0x4e/0x54
   [<c0677608>] sock_release+0x19/0x65
   [<c0677675>] sock_close+0x21/0x25
   [<c04a8e00>] __fput+0xd4/0x164
   [<c04a8eac>] fput+0x1c/0x1e
   [<c04a64c8>] filp_close+0x55/0x5f
   [<c04a654a>] sys_close+0x78/0xb2
   [<c0403b6b>] sysenter_do_call+0x12/0x3f
   [<ffffffff>] 0xffffffff

 -> (tcp_lock){-+..} ops: 15510 {
    initial-use  at:
                          [<c0450941>] __lock_acquire+0x302/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f61a5>] _write_lock_bh+0x28/0x58
                          [<c069d8d0>] tcp_packet+0x7d/0xa31
                          [<c069b37d>] nf_conntrack_in+0x3f9/0x478
                          [<c06d2bda>] ipv4_conntrack_local+0x52/0x59
                          [<c0698c60>] nf_iterate+0x34/0x67
                          [<c0698e1c>] nf_hook_slow+0x5e/0xca
                          [<c06a7c74>] __ip_local_out+0x8c/0x96
                          [<c06a7c8e>] ip_local_out+0x10/0x20
                          [<c06a8427>] ip_queue_xmit+0x2b1/0x2f2
                          [<c06b7316>] tcp_transmit_skb+0x5a8/0x5df
                          [<c06b79ea>] tcp_connect+0x32a/0x389
                          [<c06bd132>] tcp_v4_connect+0x464/0x4be
                          [<c06c6dae>] inet_stream_connect+0x8f/0x202
                          [<c0677db7>] sys_connect+0x65/0x82
                          [<c0678470>] sys_socketcall+0x93/0x192
                          [<c0403b6b>] sysenter_do_call+0x12/0x3f
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c04508b1>] __lock_acquire+0x272/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f61a5>] _write_lock_bh+0x28/0x58
                          [<c069d8d0>] tcp_packet+0x7d/0xa31
                          [<c069b37d>] nf_conntrack_in+0x3f9/0x478
                          [<c06d2bda>] ipv4_conntrack_local+0x52/0x59
                          [<c0698c60>] nf_iterate+0x34/0x67
                          [<c0698e1c>] nf_hook_slow+0x5e/0xca
                          [<c06a7c74>] __ip_local_out+0x8c/0x96
                          [<c06a7c8e>] ip_local_out+0x10/0x20
                          [<c06a7f09>] ip_push_pending_frames+0x26b/0x2c6
                          [<c06a8157>] ip_send_reply+0x1f3/0x212
                          [<c06ba66e>] tcp_v4_send_reset+0x186/0x1b7
                          [<c06bc494>] tcp_v4_rcv+0x524/0x553
                          [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
                          [<c06a4a87>] ip_local_deliver+0x66/0x6f
                          [<c06a4685>] ip_rcv_finish+0x241/0x257
                          [<c06a488d>] ip_rcv+0x1f2/0x21c
                          [<c0682464>] netif_receive_skb+0x322/0x355
                          [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
                          [<c068288b>] process_backlog+0x8e/0xca
                          [<c0680fc7>] net_rx_action+0x70/0x16b
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
    hardirq-on-W at:
                          [<c045090b>] __lock_acquire+0x2cc/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f61a5>] _write_lock_bh+0x28/0x58
                          [<c069d8d0>] tcp_packet+0x7d/0xa31
                          [<c069b37d>] nf_conntrack_in+0x3f9/0x478
                          [<c06d2bda>] ipv4_conntrack_local+0x52/0x59
                          [<c0698c60>] nf_iterate+0x34/0x67
                          [<c0698e1c>] nf_hook_slow+0x5e/0xca
                          [<c06a7c74>] __ip_local_out+0x8c/0x96
                          [<c06a7c8e>] ip_local_out+0x10/0x20
                          [<c06a8427>] ip_queue_xmit+0x2b1/0x2f2
                          [<c06b7316>] tcp_transmit_skb+0x5a8/0x5df
                          [<c06b79ea>] tcp_connect+0x32a/0x389
                          [<c06bd132>] tcp_v4_connect+0x464/0x4be
                          [<c06c6dae>] inet_stream_connect+0x8f/0x202
                          [<c0677db7>] sys_connect+0x65/0x82
                          [<c0678470>] sys_socketcall+0x93/0x192
                          [<c0403b6b>] sysenter_do_call+0x12/0x3f
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c08874e8>] tcp_lock+0x10/0x24
 ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f61a5>] _write_lock_bh+0x28/0x58
   [<c069d8d0>] tcp_packet+0x7d/0xa31
   [<c069b37d>] nf_conntrack_in+0x3f9/0x478
   [<c06d2bda>] ipv4_conntrack_local+0x52/0x59
   [<c0698c60>] nf_iterate+0x34/0x67
   [<c0698e1c>] nf_hook_slow+0x5e/0xca
   [<c06a7c74>] __ip_local_out+0x8c/0x96
   [<c06a7c8e>] ip_local_out+0x10/0x20
   [<c06a7f09>] ip_push_pending_frames+0x26b/0x2c6
   [<c06a8157>] ip_send_reply+0x1f3/0x212
   [<c06ba66e>] tcp_v4_send_reset+0x186/0x1b7
   [<c06bc494>] tcp_v4_rcv+0x524/0x553
   [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
   [<c06a4a87>] ip_local_deliver+0x66/0x6f
   [<c06a4685>] ip_rcv_finish+0x241/0x257
   [<c06a488d>] ip_rcv+0x1f2/0x21c
   [<c0682464>] netif_receive_skb+0x322/0x355
   [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
   [<c068288b>] process_backlog+0x8e/0xca
   [<c0680fc7>] net_rx_action+0x70/0x16b
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

 -> (nf_conntrack_lock){-+..} ops: 19763 {
    initial-use  at:
                          [<c0450941>] __lock_acquire+0x302/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                          [<c069b188>] nf_conntrack_in+0x204/0x478
                          [<c06d2bda>] ipv4_conntrack_local+0x52/0x59
                          [<c0698c60>] nf_iterate+0x34/0x67
                          [<c0698e1c>] nf_hook_slow+0x5e/0xca
                          [<c06a7c74>] __ip_local_out+0x8c/0x96
                          [<c06a7c8e>] ip_local_out+0x10/0x20
                          [<c06a7f09>] ip_push_pending_frames+0x26b/0x2c6
                          [<c06c0333>] udp_push_pending_frames+0x2ad/0x2ff
                          [<c06c174a>] udp_sendmsg+0x481/0x561
                          [<c06c6497>] inet_sendmsg+0x40/0x4d
                          [<c0676b49>] __sock_sendmsg+0x4a/0x53
                          [<c0677379>] sock_sendmsg+0xbd/0xd3
                          [<c0677d14>] sys_sendto+0xa9/0xc8
                          [<c06784d4>] sys_socketcall+0xf7/0x192
                          [<c0403b6b>] sysenter_do_call+0x12/0x3f
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c04508b1>] __lock_acquire+0x272/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                          [<c069b188>] nf_conntrack_in+0x204/0x478
                          [<c06d2bda>] ipv4_conntrack_local+0x52/0x59
                          [<c0698c60>] nf_iterate+0x34/0x67
                          [<c0698e1c>] nf_hook_slow+0x5e/0xca
                          [<c06a7c74>] __ip_local_out+0x8c/0x96
                          [<c06a7c8e>] ip_local_out+0x10/0x20
                          [<c06c8b03>] igmpv3_sendpack+0x42/0x49
                          [<c06c90f9>] igmp_ifc_timer_expire+0x1f0/0x21a
                          [<c0439858>] run_timer_softirq+0x140/0x1a0
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
    hardirq-on-W at:
                          [<c045090b>] __lock_acquire+0x2cc/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                          [<c069b188>] nf_conntrack_in+0x204/0x478
                          [<c06d2bda>] ipv4_conntrack_local+0x52/0x59
                          [<c0698c60>] nf_iterate+0x34/0x67
                          [<c0698e1c>] nf_hook_slow+0x5e/0xca
                          [<c06a7c74>] __ip_local_out+0x8c/0x96
                          [<c06a7c8e>] ip_local_out+0x10/0x20
                          [<c06a7f09>] ip_push_pending_frames+0x26b/0x2c6
                          [<c06c0333>] udp_push_pending_frames+0x2ad/0x2ff
                          [<c06c174a>] udp_sendmsg+0x481/0x561
                          [<c06c6497>] inet_sendmsg+0x40/0x4d
                          [<c0676b49>] __sock_sendmsg+0x4a/0x53
                          [<c0677379>] sock_sendmsg+0xbd/0xd3
                          [<c0677d14>] sys_sendto+0xa9/0xc8
                          [<c06784d4>] sys_socketcall+0xf7/0x192
                          [<c0403b6b>] sysenter_do_call+0x12/0x3f
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c088721c>] nf_conntrack_lock+0x10/0x24
  -> (&base->lock){++..} ops: 3594202 {
     initial-use  at:
                            [<c0450941>] __lock_acquire+0x302/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                            [<c0439df6>] lock_timer_base+0x24/0x43
                            [<c0439f4a>] __mod_timer+0x2c/0xac
                            [<c043a051>] mod_timer+0x35/0x39
                            [<c08f0dee>] con_init+0xa3/0x1db
                            [<c08f06ec>] console_init+0x12/0x20
                            [<c08cd734>] start_kernel+0x1fe/0x329
                            [<c08cd085>] __init_begin+0x85/0x8d
                            [<ffffffff>] 0xffffffff
     in-hardirq-W at:
                            [<c045088e>] __lock_acquire+0x24f/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                            [<c0439df6>] lock_timer_base+0x24/0x43
                            [<c0439f4a>] __mod_timer+0x2c/0xac
                            [<c043a051>] mod_timer+0x35/0x39
                            [<c05e1aad>] e1000_intr_msi+0xb4/0x111
                            [<c046fb98>] handle_IRQ_event+0x1f/0x54
                            [<c0470cf3>] handle_edge_irq+0xb1/0xf2
                            [<ffffffff>] 0xffffffff
     in-softirq-W at:
                            [<c04508b1>] __lock_acquire+0x272/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f604b>] _spin_lock_irq+0x32/0x62
                            [<c043974f>] run_timer_softirq+0x37/0x1a0
                            [<c043653a>] __do_softirq+0x9d/0x157
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c0bc408c>] __key.22801+0x0/0x8
  ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<c0439df6>] lock_timer_base+0x24/0x43
   [<c0439f4a>] __mod_timer+0x2c/0xac
   [<c069a871>] __nf_conntrack_confirm+0x13d/0x1f9
   [<c06d2b6a>] ipv4_confirm+0xc2/0xe0
   [<c0698c60>] nf_iterate+0x34/0x67
   [<c0698e1c>] nf_hook_slow+0x5e/0xca
   [<c06a883d>] ip_output+0x74/0x88
   [<c06a7c9b>] ip_local_out+0x1d/0x20
   [<c06a7f09>] ip_push_pending_frames+0x26b/0x2c6
   [<c06c0333>] udp_push_pending_frames+0x2ad/0x2ff
   [<c06c174a>] udp_sendmsg+0x481/0x561
   [<c06c6497>] inet_sendmsg+0x40/0x4d
   [<c0676b49>] __sock_sendmsg+0x4a/0x53
   [<c0677379>] sock_sendmsg+0xbd/0xd3
   [<c0677d14>] sys_sendto+0xa9/0xc8
   [<c06784d4>] sys_socketcall+0xf7/0x192
   [<c0403b6b>] sysenter_do_call+0x12/0x3f
   [<ffffffff>] 0xffffffff

 ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5fe9>] _spin_lock_bh+0x28/0x58
   [<c069a587>] __nf_ct_kill_acct+0x25/0x95
   [<c069e207>] tcp_packet+0x9b4/0xa31
   [<c069b37d>] nf_conntrack_in+0x3f9/0x478
   [<c06d2bda>] ipv4_conntrack_local+0x52/0x59
   [<c0698c60>] nf_iterate+0x34/0x67
   [<c0698e1c>] nf_hook_slow+0x5e/0xca
   [<c06a7c74>] __ip_local_out+0x8c/0x96
   [<c06a7c8e>] ip_local_out+0x10/0x20
   [<c06a7f09>] ip_push_pending_frames+0x26b/0x2c6
   [<c06a8157>] ip_send_reply+0x1f3/0x212
   [<c06ba66e>] tcp_v4_send_reset+0x186/0x1b7
   [<c06bc494>] tcp_v4_rcv+0x524/0x553
   [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
   [<c06a4a87>] ip_local_deliver+0x66/0x6f
   [<c06a4685>] ip_rcv_finish+0x241/0x257
   [<c06a488d>] ip_rcv+0x1f2/0x21c
   [<c0682464>] netif_receive_skb+0x322/0x355
   [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
   [<c068288b>] process_backlog+0x8e/0xca
   [<c0680fc7>] net_rx_action+0x70/0x16b
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

 ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<c0439df6>] lock_timer_base+0x24/0x43
   [<c0439ead>] del_timer+0x27/0x5a
   [<c069a5e2>] __nf_ct_kill_acct+0x80/0x95
   [<c069e207>] tcp_packet+0x9b4/0xa31
   [<c069b37d>] nf_conntrack_in+0x3f9/0x478
   [<c06d2bda>] ipv4_conntrack_local+0x52/0x59
   [<c0698c60>] nf_iterate+0x34/0x67
   [<c0698e1c>] nf_hook_slow+0x5e/0xca
   [<c06a7c74>] __ip_local_out+0x8c/0x96
   [<c06a7c8e>] ip_local_out+0x10/0x20
   [<c06a7f09>] ip_push_pending_frames+0x26b/0x2c6
   [<c06a8157>] ip_send_reply+0x1f3/0x212
   [<c06ba66e>] tcp_v4_send_reset+0x186/0x1b7
   [<c06bc494>] tcp_v4_rcv+0x524/0x553
   [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
   [<c06a4a87>] ip_local_deliver+0x66/0x6f
   [<c06a4685>] ip_rcv_finish+0x241/0x257
   [<c06a488d>] ip_rcv+0x1f2/0x21c
   [<c0682464>] netif_receive_skb+0x322/0x355
   [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
   [<c068288b>] process_backlog+0x8e/0xca
   [<c0680fc7>] net_rx_action+0x70/0x16b
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

 -> (&n->list_lock){++..} ops: 141701 {
    initial-use  at:
                          [<c0450941>] __lock_acquire+0x302/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5f91>] _spin_lock+0x23/0x53
                          [<c04a1f57>] add_partial+0x16/0x40
                          [<c04a3887>] __slab_free+0x87/0x293
                          [<c04a4e0b>] kmem_cache_free+0x85/0xbb
                          [<c053de35>] ida_get_new_above+0x157/0x171
                          [<c053de5b>] ida_get_new+0xc/0xe
                          [<c04a9193>] set_anon_super+0x43/0xa7
                          [<c04a9910>] sget+0x2cc/0x340
                          [<c04a9ff8>] get_sb_single+0x24/0x8d
                          [<c04e842f>] sysfs_get_sb+0x18/0x1a
                          [<c04a9e85>] vfs_kern_mount+0x89/0x102
                          [<c04a9f13>] kern_mount_data+0x15/0x17
                          [<c08e9835>] sysfs_init+0x50/0xa0
                          [<c08e82d2>] mnt_init+0x89/0x184
                          [<c08e7fb6>] vfs_caches_init+0xd6/0xe8
                          [<c08cd81e>] start_kernel+0x2e8/0x329
                          [<c08cd085>] __init_begin+0x85/0x8d
                          [<ffffffff>] 0xffffffff
    in-hardirq-W at:
                          [<c045088e>] __lock_acquire+0x24f/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5f91>] _spin_lock+0x23/0x53
                          [<c04a1f57>] add_partial+0x16/0x40
                          [<c04a2738>] unfreeze_slab+0x84/0xbc
                          [<c04a27d4>] flush_slab+0x64/0x69
                          [<c04a2801>] flush_cpu_slab+0x28/0x2a
                          [<c0456576>] generic_smp_call_function_single_interrupt+0x6c/0x9b
                          [<c0414812>] smp_call_function_single_interrupt+0x22/0x39
                          [<c040437d>] call_function_single_interrupt+0x2d/0x34
                          [<c0402c3d>] cpu_idle+0x2b/0xae
                          [<c06f119d>] start_secondary+0x1d1/0x1d9
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c04508b1>] __lock_acquire+0x272/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5f91>] _spin_lock+0x23/0x53
                          [<c04a1f57>] add_partial+0x16/0x40
                          [<c04a3887>] __slab_free+0x87/0x293
                          [<c04a4e0b>] kmem_cache_free+0x85/0xbb
                          [<c0447cee>] put_cred_rcu+0x79/0x7f
                          [<c0472651>] __rcu_process_callbacks+0x13d/0x207
                          [<c047273f>] rcu_process_callbacks+0x24/0x42
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c0fd1270>] __key.25082+0x0/0x8
 ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c04a349b>] __slab_alloc+0x101/0x466
   [<c04a3b17>] kmem_cache_alloc+0x84/0xe3
   [<c067d41b>] __alloc_skb+0x2e/0xfd
   [<c067986e>] sock_wmalloc+0x30/0x5b
   [<c06a704a>] ip_append_data+0x43e/0x7af
   [<c06a8102>] ip_send_reply+0x19e/0x212
   [<c06ba66e>] tcp_v4_send_reset+0x186/0x1b7
   [<c06bc494>] tcp_v4_rcv+0x524/0x553
   [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
   [<c06a4a87>] ip_local_deliver+0x66/0x6f
   [<c06a4685>] ip_rcv_finish+0x241/0x257
   [<c06a488d>] ip_rcv+0x1f2/0x21c
   [<c0682464>] netif_receive_skb+0x322/0x355
   [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
   [<c068288b>] process_backlog+0x8e/0xca
   [<c0680fc7>] net_rx_action+0x70/0x16b
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

 -> (&list->lock#5){-+..} ops: 25742 {
    initial-use  at:
                          [<c0450941>] __lock_acquire+0x302/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                          [<c0690529>] dev_deactivate+0x83/0xd3
                          [<c068c174>] __linkwatch_run_queue+0x150/0x180
                          [<c068c1c4>] linkwatch_event+0x20/0x27
                          [<c043f898>] run_workqueue+0xdb/0x1a9
                          [<c043fa37>] worker_thread+0xd1/0xdd
                          [<c0442ae0>] kthread+0x40/0x66
                          [<c040453f>] kernel_thread_helper+0x7/0x10
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c04508b1>] __lock_acquire+0x272/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5f91>] _spin_lock+0x23/0x53
                          [<c068318f>] dev_queue_xmit+0x364/0x4d1
                          [<c06881de>] neigh_resolve_output+0x206/0x250
                          [<f88bf769>] ip6_output_finish+0x97/0xe0 [ipv6]
                          [<f88c140b>] ip6_output2+0x1d7/0x1df [ipv6]
                          [<f88c1e53>] ip6_output+0xa40/0xa4d [ipv6]
                          [<f88d4e79>] mld_sendpack+0x194/0x289 [ipv6]
                          [<f88d5996>] mld_ifc_timer_expire+0x1dd/0x20c [ipv6]
                          [<c0439858>] run_timer_softirq+0x140/0x1a0
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
    hardirq-on-W at:
                          [<c045090b>] __lock_acquire+0x2cc/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                          [<c0690529>] dev_deactivate+0x83/0xd3
                          [<c068c174>] __linkwatch_run_queue+0x150/0x180
                          [<c068c1c4>] linkwatch_event+0x20/0x27
                          [<c043f898>] run_workqueue+0xdb/0x1a9
                          [<c043fa37>] worker_thread+0xd1/0xdd
                          [<c0442ae0>] kthread+0x40/0x66
                          [<c040453f>] kernel_thread_helper+0x7/0x10
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c0ffa258>] __key.21533+0x0/0x8
 ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c068318f>] dev_queue_xmit+0x364/0x4d1
   [<c06a8736>] ip_finish_output2+0x191/0x1cb
   [<c06a87c7>] ip_finish_output+0x57/0x59
   [<c06a884c>] ip_output+0x83/0x88
   [<c06a7c9b>] ip_local_out+0x1d/0x20
   [<c06a8427>] ip_queue_xmit+0x2b1/0x2f2
   [<c06b7316>] tcp_transmit_skb+0x5a8/0x5df
   [<c06b74cc>] tcp_send_ack+0xd6/0xde
   [<c06b9b68>] tcp_delack_timer+0x15a/0x1b1
   [<c0439858>] run_timer_softirq+0x140/0x1a0
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

 -> (_xmit_ETHER#2){-+..} ops: 5689 {
    initial-use  at:
                          [<c0450941>] __lock_acquire+0x302/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5f91>] _spin_lock+0x23/0x53
                          [<c06902a6>] netif_tx_lock+0x40/0x6f
                          [<c06904e3>] dev_deactivate+0x3d/0xd3
                          [<c068c174>] __linkwatch_run_queue+0x150/0x180
                          [<c068c1c4>] linkwatch_event+0x20/0x27
                          [<c043f898>] run_workqueue+0xdb/0x1a9
                          [<c043fa37>] worker_thread+0xd1/0xdd
                          [<c0442ae0>] kthread+0x40/0x66
                          [<c040453f>] kernel_thread_helper+0x7/0x10
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c04508b1>] __lock_acquire+0x272/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5f91>] _spin_lock+0x23/0x53
                          [<c069093c>] __qdisc_run+0xc3/0x1f7
                          [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
                          [<c06881de>] neigh_resolve_output+0x206/0x250
                          [<f88bf769>] ip6_output_finish+0x97/0xe0 [ipv6]
                          [<f88c140b>] ip6_output2+0x1d7/0x1df [ipv6]
                          [<f88c1e53>] ip6_output+0xa40/0xa4d [ipv6]
                          [<f88d4e79>] mld_sendpack+0x194/0x289 [ipv6]
                          [<f88d5996>] mld_ifc_timer_expire+0x1dd/0x20c [ipv6]
                          [<c0439858>] run_timer_softirq+0x140/0x1a0
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
    hardirq-on-W at:
                          [<c045090b>] __lock_acquire+0x2cc/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5f91>] _spin_lock+0x23/0x53
                          [<c06902a6>] netif_tx_lock+0x40/0x6f
                          [<c06904e3>] dev_deactivate+0x3d/0xd3
                          [<c068c174>] __linkwatch_run_queue+0x150/0x180
                          [<c068c1c4>] linkwatch_event+0x20/0x27
                          [<c043f898>] run_workqueue+0xdb/0x1a9
                          [<c043fa37>] worker_thread+0xd1/0xdd
                          [<c0442ae0>] kthread+0x40/0x66
                          [<c040453f>] kernel_thread_helper+0x7/0x10
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c0ff9b8c>] netdev_xmit_lock_key+0x8/0x1c8
  -> (&sta->flaglock){.+..} ops: 40738 {
     initial-use  at:
                            [<c0450941>] __lock_acquire+0x302/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                            [<f7de5889>] set_sta_flags+0x19/0x2a [mac80211]
                            [<f7de60e9>] ieee80211_rx_mgmt_assoc_resp+0x2f8/0xad7 [mac80211]
                            [<f7de6fa3>] ieee80211_sta_rx_queued_mgmt+0x6db/0x831 [mac80211]
                            [<f7de716d>] ieee80211_sta_work+0x74/0x5d0 [mac80211]
                            [<c043f898>] run_workqueue+0xdb/0x1a9
                            [<c043fa37>] worker_thread+0xd1/0xdd
                            [<c0442ae0>] kthread+0x40/0x66
                            [<c040453f>] kernel_thread_helper+0x7/0x10
                            [<ffffffff>] 0xffffffff
     in-softirq-W at:
                            [<c04508b1>] __lock_acquire+0x272/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                            [<f7deaeb0>] test_sta_flags+0x19/0x2c [mac80211]
                            [<f7deb59a>] ieee80211_invoke_rx_handlers+0x24b/0x1707 [mac80211]
                            [<f7deceed>] __ieee80211_rx_handle_packet+0x497/0x4a9 [mac80211]
                            [<f7ded60a>] __ieee80211_rx+0x4f7/0x559 [mac80211]
                            [<f7e869f4>] ath5k_tasklet_rx+0x4f7/0x53b [ath5k]
                            [<c0435dba>] tasklet_action+0x84/0xef
                            [<c043653a>] __do_softirq+0x9d/0x157
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<f7e08950>] __key.35891+0x0/0xffff066d [mac80211]
  ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<f7deda38>] get_sta_flags+0x16/0x28 [mac80211]
   [<f7defa47>] ieee80211_subif_start_xmit+0x4ba/0x7e7 [mac80211]
   [<c0682cd2>] dev_hard_start_xmit+0x219/0x288
   [<c069096d>] __qdisc_run+0xf4/0x1f7
   [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
   [<c06881de>] neigh_resolve_output+0x206/0x250
   [<f88bf769>] ip6_output_finish+0x97/0xe0 [ipv6]
   [<f88c140b>] ip6_output2+0x1d7/0x1df [ipv6]
   [<f88c1e53>] ip6_output+0xa40/0xa4d [ipv6]
   [<f88d4e79>] mld_sendpack+0x194/0x289 [ipv6]
   [<f88d5996>] mld_ifc_timer_expire+0x1dd/0x20c [ipv6]
   [<c0439858>] run_timer_softirq+0x140/0x1a0
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

  ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c068318f>] dev_queue_xmit+0x364/0x4d1
   [<f7defd59>] ieee80211_subif_start_xmit+0x7cc/0x7e7 [mac80211]
   [<c0682cd2>] dev_hard_start_xmit+0x219/0x288
   [<c069096d>] __qdisc_run+0xf4/0x1f7
   [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
   [<c06881de>] neigh_resolve_output+0x206/0x250
   [<f88bf769>] ip6_output_finish+0x97/0xe0 [ipv6]
   [<f88c140b>] ip6_output2+0x1d7/0x1df [ipv6]
   [<f88c1e53>] ip6_output+0xa40/0xa4d [ipv6]
   [<f88d4e79>] mld_sendpack+0x194/0x289 [ipv6]
   [<f88d5996>] mld_ifc_timer_expire+0x1dd/0x20c [ipv6]
   [<c0439858>] run_timer_softirq+0x140/0x1a0
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

  -> (_xmit_IEEE80211#2){-+..} ops: 6251 {
     initial-use  at:
                            [<c0450941>] __lock_acquire+0x302/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f5f91>] _spin_lock+0x23/0x53
                            [<c069093c>] __qdisc_run+0xc3/0x1f7
                            [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
                            [<f7df0eeb>] ieee80211_tx_skb+0x4d/0x50 [mac80211]
                            [<f7de500a>] ieee80211_send_probe_req+0x1c3/0x1cb [mac80211]
                            [<f7de20ee>] ieee80211_scan_work+0x134/0x154 [mac80211]
                            [<c043f898>] run_workqueue+0xdb/0x1a9
                            [<c043fa37>] worker_thread+0xd1/0xdd
                            [<c0442ae0>] kthread+0x40/0x66
                            [<c040453f>] kernel_thread_helper+0x7/0x10
                            [<ffffffff>] 0xffffffff
     in-softirq-W at:
                            [<c04508b1>] __lock_acquire+0x272/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f5f91>] _spin_lock+0x23/0x53
                            [<c069093c>] __qdisc_run+0xc3/0x1f7
                            [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
                            [<f7defd59>] ieee80211_subif_start_xmit+0x7cc/0x7e7 [mac80211]
                            [<c0682cd2>] dev_hard_start_xmit+0x219/0x288
                            [<c069096d>] __qdisc_run+0xf4/0x1f7
                            [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
                            [<c06881de>] neigh_resolve_output+0x206/0x250
                            [<f88bf769>] ip6_output_finish+0x97/0xe0 [ipv6]
                            [<f88c140b>] ip6_output2+0x1d7/0x1df [ipv6]
                            [<f88c1e53>] ip6_output+0xa40/0xa4d [ipv6]
                            [<f88d4e79>] mld_sendpack+0x194/0x289 [ipv6]
                            [<f88d5996>] mld_ifc_timer_expire+0x1dd/0x20c [ipv6]
                            [<c0439858>] run_timer_softirq+0x140/0x1a0
                            [<c043653a>] __do_softirq+0x9d/0x157
                            [<ffffffff>] 0xffffffff
     hardirq-on-W at:
                            [<c045090b>] __lock_acquire+0x2cc/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f5f91>] _spin_lock+0x23/0x53
                            [<c069093c>] __qdisc_run+0xc3/0x1f7
                            [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
                            [<f7df0eeb>] ieee80211_tx_skb+0x4d/0x50 [mac80211]
                            [<f7de500a>] ieee80211_send_probe_req+0x1c3/0x1cb [mac80211]
                            [<f7de20ee>] ieee80211_scan_work+0x134/0x154 [mac80211]
                            [<c043f898>] run_workqueue+0xdb/0x1a9
                            [<c043fa37>] worker_thread+0xd1/0xdd
                            [<c0442ae0>] kthread+0x40/0x66
                            [<c040453f>] kernel_thread_helper+0x7/0x10
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c0ff9d14>] netdev_xmit_lock_key+0x190/0x1c8
   -> (&sc->txbuflock){-+..} ops: 12464 {
      initial-use  at:
                              [<c0450941>] __lock_acquire+0x302/0xb4a
                              [<c04511f9>] lock_acquire+0x70/0x97
                              [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                              [<f7e85c52>] ath5k_tx+0x106/0x41e [ath5k]
                              [<f7deed3a>] __ieee80211_tx+0x47/0x12e [mac80211]
                              [<f7def486>] ieee80211_master_start_xmit+0x38a/0x491 [mac80211]
                              [<c0682cd2>] dev_hard_start_xmit+0x219/0x288
                              [<c069096d>] __qdisc_run+0xf4/0x1f7
                              [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
                              [<f7df0eeb>] ieee80211_tx_skb+0x4d/0x50 [mac80211]
                              [<f7de500a>] ieee80211_send_probe_req+0x1c3/0x1cb [mac80211]
                              [<f7de20ee>] ieee80211_scan_work+0x134/0x154 [mac80211]
                              [<c043f898>] run_workqueue+0xdb/0x1a9
                              [<c043fa37>] worker_thread+0xd1/0xdd
                              [<c0442ae0>] kthread+0x40/0x66
                              [<c040453f>] kernel_thread_helper+0x7/0x10
                              [<ffffffff>] 0xffffffff
      in-softirq-W at:
                              [<c04508b1>] __lock_acquire+0x272/0xb4a
                              [<c04511f9>] lock_acquire+0x70/0x97
                              [<c06f5f91>] _spin_lock+0x23/0x53
                              [<f7e8647a>] ath5k_tasklet_tx+0x1e2/0x265 [ath5k]
                              [<c0435dba>] tasklet_action+0x84/0xef
                              [<c043653a>] __do_softirq+0x9d/0x157
                              [<ffffffff>] 0xffffffff
      hardirq-on-W at:
                              [<c045090b>] __lock_acquire+0x2cc/0xb4a
                              [<c04511f9>] lock_acquire+0x70/0x97
                              [<c06f5f91>] _spin_lock+0x23/0x53
                              [<f7e8647a>] ath5k_tasklet_tx+0x1e2/0x265 [ath5k]
                              [<c0435dba>] tasklet_action+0x84/0xef
                              [<c043653a>] __do_softirq+0x9d/0x157
                              [<ffffffff>] 0xffffffff
    }
    ... key      at: [<f7e97f88>] __key.35053+0x0/0xffff0aef [ath5k]
   ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<f7e85c52>] ath5k_tx+0x106/0x41e [ath5k]
   [<f7deed3a>] __ieee80211_tx+0x47/0x12e [mac80211]
   [<f7def486>] ieee80211_master_start_xmit+0x38a/0x491 [mac80211]
   [<c0682cd2>] dev_hard_start_xmit+0x219/0x288
   [<c069096d>] __qdisc_run+0xf4/0x1f7
   [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
   [<f7df0eeb>] ieee80211_tx_skb+0x4d/0x50 [mac80211]
   [<f7de500a>] ieee80211_send_probe_req+0x1c3/0x1cb [mac80211]
   [<f7de20ee>] ieee80211_scan_work+0x134/0x154 [mac80211]
   [<c043f898>] run_workqueue+0xdb/0x1a9
   [<c043fa37>] worker_thread+0xd1/0xdd
   [<c0442ae0>] kthread+0x40/0x66
   [<c040453f>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

   -> (&txq->lock){-+..} ops: 19001 {
      initial-use  at:
                              [<c0450941>] __lock_acquire+0x302/0xb4a
                              [<c04511f9>] lock_acquire+0x70/0x97
                              [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                              [<f7e83d07>] ath5k_txq_cleanup+0x1d1/0x267 [ath5k]
                              [<f7e83e83>] ath5k_stop_locked+0xa6/0xd7 [ath5k]
                              [<f7e84b0f>] ath5k_init+0xa8/0x14e [ath5k]
                              [<f7e84bc7>] ath5k_start+0x12/0x14 [ath5k]
                              [<f7de8395>] ieee80211_open+0x29e/0x6a8 [mac80211]
                              [<c0683c69>] dev_open+0x7c/0xbb
                              [<c06836a7>] dev_change_flags+0xaa/0x15d
                              [<c068a5ba>] do_setlink+0x2aa/0x362
                              [<c068a749>] rtnl_setlink+0xd7/0xdb
                              [<c068b52e>] rtnetlink_rcv_msg+0x19d/0x1b7
                              [<c0697712>] netlink_rcv_skb+0x35/0x7b
                              [<c068b389>] rtnetlink_rcv+0x23/0x2b
                              [<c0697300>] netlink_unicast+0xf6/0x14c
                              [<c0697599>] netlink_sendmsg+0x243/0x250
                              [<c0676b49>] __sock_sendmsg+0x4a/0x53
                              [<c0677379>] sock_sendmsg+0xbd/0xd3
                              [<c06774d3>] sys_sendmsg+0x144/0x197
                              [<c067853f>] sys_socketcall+0x162/0x192
                              [<c0403b6b>] sysenter_do_call+0x12/0x3f
                              [<ffffffff>] 0xffffffff
      in-softirq-W at:
                              [<c04508b1>] __lock_acquire+0x272/0xb4a
                              [<c04511f9>] lock_acquire+0x70/0x97
                              [<c06f5f91>] _spin_lock+0x23/0x53
                              [<f7e862cd>] ath5k_tasklet_tx+0x35/0x265 [ath5k]
                              [<c0435dba>] tasklet_action+0x84/0xef
                              [<c043653a>] __do_softirq+0x9d/0x157
                              [<ffffffff>] 0xffffffff
      hardirq-on-W at:
                              [<c045090b>] __lock_acquire+0x2cc/0xb4a
                              [<c04511f9>] lock_acquire+0x70/0x97
                              [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                              [<f7e83d07>] ath5k_txq_cleanup+0x1d1/0x267 [ath5k]
                              [<f7e83e83>] ath5k_stop_locked+0xa6/0xd7 [ath5k]
                              [<f7e84b0f>] ath5k_init+0xa8/0x14e [ath5k]
                              [<f7e84bc7>] ath5k_start+0x12/0x14 [ath5k]
                              [<f7de8395>] ieee80211_open+0x29e/0x6a8 [mac80211]
                              [<c0683c69>] dev_open+0x7c/0xbb
                              [<c06836a7>] dev_change_flags+0xaa/0x15d
                              [<c068a5ba>] do_setlink+0x2aa/0x362
                              [<c068a749>] rtnl_setlink+0xd7/0xdb
                              [<c068b52e>] rtnetlink_rcv_msg+0x19d/0x1b7
                              [<c0697712>] netlink_rcv_skb+0x35/0x7b
                              [<c068b389>] rtnetlink_rcv+0x23/0x2b
                              [<c0697300>] netlink_unicast+0xf6/0x14c
                              [<c0697599>] netlink_sendmsg+0x243/0x250
                              [<c0676b49>] __sock_sendmsg+0x4a/0x53
                              [<c0677379>] sock_sendmsg+0xbd/0xd3
                              [<c06774d3>] sys_sendmsg+0x144/0x197
                              [<c067853f>] sys_socketcall+0x162/0x192
                              [<c0403b6b>] sysenter_do_call+0x12/0x3f
                              [<ffffffff>] 0xffffffff
    }
    ... key      at: [<f7e97fa0>] __key.35719+0x0/0xffff0ad7 [ath5k]
    ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<f7e8647a>] ath5k_tasklet_tx+0x1e2/0x265 [ath5k]
   [<c0435dba>] tasklet_action+0x84/0xef
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

    ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<c0425067>] __wake_up_sync+0x1e/0x49
   [<c0679596>] sock_def_write_space+0x4d/0x88
   [<c0679eda>] sock_wfree+0x31/0x46
   [<f7ddddb6>] ieee80211_tx_status+0x243/0x3fb [mac80211]
   [<f7e86468>] ath5k_tasklet_tx+0x1d0/0x265 [ath5k]
   [<c0435dba>] tasklet_action+0x84/0xef
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

    ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c04a1f57>] add_partial+0x16/0x40
   [<c04a3887>] __slab_free+0x87/0x293
   [<c04a4e0b>] kmem_cache_free+0x85/0xbb
   [<c067c795>] __kfree_skb+0x6f/0x72
   [<c067c7cb>] kfree_skb+0x33/0x35
   [<f7dddf66>] ieee80211_tx_status+0x3f3/0x3fb [mac80211]
   [<f7e86468>] ath5k_tasklet_tx+0x1d0/0x265 [ath5k]
   [<c0435dba>] tasklet_action+0x84/0xef
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

    ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5fe9>] _spin_lock_bh+0x28/0x58
   [<c069adbf>] destroy_conntrack+0x8b/0x10b
   [<c0698ccc>] nf_conntrack_destroy+0x39/0x52
   [<c067c827>] skb_release_head_state+0x5a/0x8f
   [<c067c736>] __kfree_skb+0x10/0x72
   [<c067c7cb>] kfree_skb+0x33/0x35
   [<f7dddf66>] ieee80211_tx_status+0x3f3/0x3fb [mac80211]
   [<f7e86468>] ath5k_tasklet_tx+0x1d0/0x265 [ath5k]
   [<c0435dba>] tasklet_action+0x84/0xef
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

    -> (nf_nat_lock){-+..} ops: 836 {
       initial-use  at:
                                [<c0450941>] __lock_acquire+0x302/0xb4a
                                [<c04511f9>] lock_acquire+0x70/0x97
                                [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                                [<f8f98078>] 0xf8f98078
                                [<c0401137>] _stext+0x4f/0x127
                                [<c0459ace>] sys_init_module+0x8e/0x183
                                [<c0403b6b>] sysenter_do_call+0x12/0x3f
                                [<ffffffff>] 0xffffffff
       in-softirq-W at:
                                [<c04508b1>] __lock_acquire+0x272/0xb4a
                                [<c04511f9>] lock_acquire+0x70/0x97
                                [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                                [<f8f91150>] nf_nat_cleanup_conntrack+0x33/0x55 [nf_nat]
                                [<c069e910>] __nf_ct_ext_destroy+0x51/0x76
                                [<c069ad21>] nf_conntrack_free+0x19/0x2c
                                [<c069ae38>] destroy_conntrack+0x104/0x10b
                                [<c0698ccc>] nf_conntrack_destroy+0x39/0x52
                                [<c06bc163>] tcp_v4_rcv+0x1f3/0x553
                                [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
                                [<c06a4a87>] ip_local_deliver+0x66/0x6f
                                [<c06a4685>] ip_rcv_finish+0x241/0x257
                                [<c06a488d>] ip_rcv+0x1f2/0x21c
                                [<c0682464>] netif_receive_skb+0x322/0x355
                                [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
                                [<c068288b>] process_backlog+0x8e/0xca
                                [<c0680fc7>] net_rx_action+0x70/0x16b
                                [<c043653a>] __do_softirq+0x9d/0x157
                                [<ffffffff>] 0xffffffff
       hardirq-on-W at:
                                [<c045090b>] __lock_acquire+0x2cc/0xb4a
                                [<c04511f9>] lock_acquire+0x70/0x97
                                [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                                [<f8f98078>] 0xf8f98078
                                [<c0401137>] _stext+0x4f/0x127
                                [<c0459ace>] sys_init_module+0x8e/0x183
                                [<c0403b6b>] sysenter_do_call+0x12/0x3f
                                [<ffffffff>] 0xffffffff
     }
     ... key      at: [<f8f94298>] nf_nat_lock+0x10/0xffffe68e [nf_nat]
    ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5fe9>] _spin_lock_bh+0x28/0x58
   [<f8f91150>] nf_nat_cleanup_conntrack+0x33/0x55 [nf_nat]
   [<c069e910>] __nf_ct_ext_destroy+0x51/0x76
   [<c069ad21>] nf_conntrack_free+0x19/0x2c
   [<c069ae38>] destroy_conntrack+0x104/0x10b
   [<c0698ccc>] nf_conntrack_destroy+0x39/0x52
   [<c067c827>] skb_release_head_state+0x5a/0x8f
   [<c067c736>] __kfree_skb+0x10/0x72
   [<c067c7cb>] kfree_skb+0x33/0x35
   [<f7dddf66>] ieee80211_tx_status+0x3f3/0x3fb [mac80211]
   [<f7e86468>] ath5k_tasklet_tx+0x1d0/0x265 [ath5k]
   [<c0435dba>] tasklet_action+0x84/0xef
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

    -> (&rnp->lock){.+..} ops: 2066483 {
       initial-use  at:
                                [<c0450941>] __lock_acquire+0x302/0xb4a
                                [<c04511f9>] lock_acquire+0x70/0x97
                                [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                                [<c0471f1a>] rcu_init_percpu_data+0x22/0x124
                                [<c06f29b6>] rcu_cpu_notify+0x53/0x90
                                [<c08e4fa5>] __rcu_init+0xed/0x11d
                                [<c08e335b>] rcu_init+0x8/0xa
                                [<c08cd6cf>] start_kernel+0x199/0x329
                                [<c08cd085>] __init_begin+0x85/0x8d
                                [<ffffffff>] 0xffffffff
       in-softirq-W at:
                                [<c04508b1>] __lock_acquire+0x272/0xb4a
                                [<c04511f9>] lock_acquire+0x70/0x97
                                [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                                [<c0471ea2>] cpu_quiet+0x1c/0x72
                                [<c047257a>] __rcu_process_callbacks+0x66/0x207
                                [<c047273f>] rcu_process_callbacks+0x24/0x42
                                [<c043653a>] __do_softirq+0x9d/0x157
                                [<ffffffff>] 0xffffffff
     }
     ... key      at: [<c0fa3038>] __key.17652+0x0/0x8
    ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<c04723f2>] __call_rcu+0x7a/0xf5
   [<c0472493>] call_rcu+0x12/0x14
   [<c069ad31>] nf_conntrack_free+0x29/0x2c
   [<c069ae38>] destroy_conntrack+0x104/0x10b
   [<c0698ccc>] nf_conntrack_destroy+0x39/0x52
   [<c067c827>] skb_release_head_state+0x5a/0x8f
   [<c067c736>] __kfree_skb+0x10/0x72
   [<c067c7cb>] kfree_skb+0x33/0x35
   [<f7dddf66>] ieee80211_tx_status+0x3f3/0x3fb [mac80211]
   [<f7e86468>] ath5k_tasklet_tx+0x1d0/0x265 [ath5k]
   [<c0435dba>] tasklet_action+0x84/0xef
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

   ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5fe9>] _spin_lock_bh+0x28/0x58
   [<f7e85eae>] ath5k_tx+0x362/0x41e [ath5k]
   [<f7deed3a>] __ieee80211_tx+0x47/0x12e [mac80211]
   [<f7def486>] ieee80211_master_start_xmit+0x38a/0x491 [mac80211]
   [<c0682cd2>] dev_hard_start_xmit+0x219/0x288
   [<c069096d>] __qdisc_run+0xf4/0x1f7
   [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
   [<f7df0eeb>] ieee80211_tx_skb+0x4d/0x50 [mac80211]
   [<f7de500a>] ieee80211_send_probe_req+0x1c3/0x1cb [mac80211]
   [<f7de20ee>] ieee80211_scan_work+0x134/0x154 [mac80211]
   [<c043f898>] run_workqueue+0xdb/0x1a9
   [<c043fa37>] worker_thread+0xd1/0xdd
   [<c0442ae0>] kthread+0x40/0x66
   [<c040453f>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

   ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c04a349b>] __slab_alloc+0x101/0x466
   [<c04a4214>] __kmalloc+0xb6/0x118
   [<c067cb48>] pskb_expand_head+0x54/0x140
   [<f7def0c5>] ieee80211_skb_resize+0x69/0xa0 [mac80211]
   [<f7def360>] ieee80211_master_start_xmit+0x264/0x491 [mac80211]
   [<c0682cd2>] dev_hard_start_xmit+0x219/0x288
   [<c069096d>] __qdisc_run+0xf4/0x1f7
   [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
   [<f7df0eeb>] ieee80211_tx_skb+0x4d/0x50 [mac80211]
   [<f7de500a>] ieee80211_send_probe_req+0x1c3/0x1cb [mac80211]
   [<f7de20ee>] ieee80211_scan_work+0x134/0x154 [mac80211]
   [<c043f898>] run_workqueue+0xdb/0x1a9
   [<c043fa37>] worker_thread+0xd1/0xdd
   [<c0442ae0>] kthread+0x40/0x66
   [<c040453f>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

   -> (&zone->lock){.+..} ops: 155675 {
      initial-use  at:
                              [<c0450941>] __lock_acquire+0x302/0xb4a
                              [<c04511f9>] lock_acquire+0x70/0x97
                              [<c06f5f91>] _spin_lock+0x23/0x53
                              [<c0484cf4>] free_pages_bulk+0x23/0x6c
                              [<c0485649>] free_hot_cold_page+0x113/0x17c
                              [<c04856ff>] free_hot_page+0xf/0x11
                              [<c0485721>] __free_pages+0x20/0x2b
                              [<c08f9d66>] __free_pages_bootmem+0x59/0x5d
                              [<c08e5f36>] free_all_bootmem_core+0xd5/0x17b
                              [<c08e5fe9>] free_all_bootmem+0xd/0xf
                              [<c08e15d3>] mem_init+0x26/0x2b4
                              [<c08cd7b0>] start_kernel+0x27a/0x329
                              [<c08cd085>] __init_begin+0x85/0x8d
                              [<ffffffff>] 0xffffffff
      in-softirq-W at:
                              [<c04508b1>] __lock_acquire+0x272/0xb4a
                              [<c04511f9>] lock_acquire+0x70/0x97
                              [<c06f5f91>] _spin_lock+0x23/0x53
                              [<c0485486>] __free_pages_ok+0xca/0x150
                              [<c048572a>] __free_pages+0x29/0x2b
                              [<c04a2675>] __free_slab+0xaf/0xb7
                              [<c04a26b2>] discard_slab+0x35/0x37
                              [<c04a38e6>] __slab_free+0xe6/0x293
                              [<c04a4e0b>] kmem_cache_free+0x85/0xbb
                              [<c042fcf2>] free_task+0x38/0x3b
                              [<c0431122>] __put_task_struct+0xa6/0xab
                              [<c0432bb6>] delayed_put_task_struct+0x41/0x45
                              [<c0472651>] __rcu_process_callbacks+0x13d/0x207
                              [<c047273f>] rcu_process_callbacks+0x24/0x42
                              [<c043653a>] __do_softirq+0x9d/0x157
                              [<ffffffff>] 0xffffffff
    }
    ... key      at: [<c0fc75c0>] __key.30392+0x0/0x8
   ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<c04859dc>] get_page_from_freelist+0x258/0x41f
   [<c0485e1c>] __alloc_pages_internal+0xb5/0x3a3
   [<c04a3390>] alloc_slab_page+0x25/0x2f
   [<c04a3531>] __slab_alloc+0x197/0x466
   [<c04a4214>] __kmalloc+0xb6/0x118
   [<c067cb48>] pskb_expand_head+0x54/0x140
   [<f7def0c5>] ieee80211_skb_resize+0x69/0xa0 [mac80211]
   [<f7def360>] ieee80211_master_start_xmit+0x264/0x491 [mac80211]
   [<c0682cd2>] dev_hard_start_xmit+0x219/0x288
   [<c069096d>] __qdisc_run+0xf4/0x1f7
   [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
   [<f7df0eeb>] ieee80211_tx_skb+0x4d/0x50 [mac80211]
   [<f7de500a>] ieee80211_send_probe_req+0x1c3/0x1cb [mac80211]
   [<f7de20ee>] ieee80211_scan_work+0x134/0x154 [mac80211]
   [<c043f898>] run_workqueue+0xdb/0x1a9
   [<c043fa37>] worker_thread+0xd1/0xdd
   [<c0442ae0>] kthread+0x40/0x66
   [<c040453f>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

   ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<f7ded9ba>] __ieee80211_tx_prepare+0x21a/0x282 [mac80211]
   [<f7def435>] ieee80211_master_start_xmit+0x339/0x491 [mac80211]
   [<c0682cd2>] dev_hard_start_xmit+0x219/0x288
   [<c069096d>] __qdisc_run+0xf4/0x1f7
   [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
   [<f7defd59>] ieee80211_subif_start_xmit+0x7cc/0x7e7 [mac80211]
   [<c0682cd2>] dev_hard_start_xmit+0x219/0x288
   [<c069096d>] __qdisc_run+0xf4/0x1f7
   [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
   [<c06881de>] neigh_resolve_output+0x206/0x250
   [<f88bf769>] ip6_output_finish+0x97/0xe0 [ipv6]
   [<f88c140b>] ip6_output2+0x1d7/0x1df [ipv6]
   [<f88c1e53>] ip6_output+0xa40/0xa4d [ipv6]
   [<f88d4e79>] mld_sendpack+0x194/0x289 [ipv6]
   [<f88d5996>] mld_ifc_timer_expire+0x1dd/0x20c [ipv6]
   [<c0439858>] run_timer_softirq+0x140/0x1a0
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

  ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c069093c>] __qdisc_run+0xc3/0x1f7
   [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
   [<f7defd59>] ieee80211_subif_start_xmit+0x7cc/0x7e7 [mac80211]
   [<c0682cd2>] dev_hard_start_xmit+0x219/0x288
   [<c069096d>] __qdisc_run+0xf4/0x1f7
   [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
   [<c06881de>] neigh_resolve_output+0x206/0x250
   [<f88bf769>] ip6_output_finish+0x97/0xe0 [ipv6]
   [<f88c140b>] ip6_output2+0x1d7/0x1df [ipv6]
   [<f88c1e53>] ip6_output+0xa40/0xa4d [ipv6]
   [<f88d4e79>] mld_sendpack+0x194/0x289 [ipv6]
   [<f88d5996>] mld_ifc_timer_expire+0x1dd/0x20c [ipv6]
   [<c0439858>] run_timer_softirq+0x140/0x1a0
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

  ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c04a349b>] __slab_alloc+0x101/0x466
   [<c04a3b17>] kmem_cache_alloc+0x84/0xe3
   [<c067c70e>] skb_clone+0x3f/0x57
   [<c0682b54>] dev_hard_start_xmit+0x9b/0x288
   [<c069096d>] __qdisc_run+0xf4/0x1f7
   [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
   [<c06881de>] neigh_resolve_output+0x206/0x250
   [<f88bf769>] ip6_output_finish+0x97/0xe0 [ipv6]
   [<f88c140b>] ip6_output2+0x1d7/0x1df [ipv6]
   [<f88c1e53>] ip6_output+0xa40/0xa4d [ipv6]
   [<f88ce8e0>] ndisc_send_skb+0xfb/0x1d6 [ipv6]
   [<f88ce9fa>] __ndisc_send+0x3f/0x4a [ipv6]
   [<f88cfbfb>] ndisc_send_ns+0x68/0x73 [ipv6]
   [<f88c59c3>] addrconf_dad_timer+0xed/0xfe [ipv6]
   [<c0439858>] run_timer_softirq+0x140/0x1a0
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

  ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<c04859dc>] get_page_from_freelist+0x258/0x41f
   [<c0485e1c>] __alloc_pages_internal+0xb5/0x3a3
   [<c04a3390>] alloc_slab_page+0x25/0x2f
   [<c04a3531>] __slab_alloc+0x197/0x466
   [<c04a4214>] __kmalloc+0xb6/0x118
   [<c067cb48>] pskb_expand_head+0x54/0x140
   [<f7def0c5>] ieee80211_skb_resize+0x69/0xa0 [mac80211]
   [<f7defbd3>] ieee80211_subif_start_xmit+0x646/0x7e7 [mac80211]
   [<c0682cd2>] dev_hard_start_xmit+0x219/0x288
   [<c069096d>] __qdisc_run+0xf4/0x1f7
   [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
   [<c06a8736>] ip_finish_output2+0x191/0x1cb
   [<c06a87c7>] ip_finish_output+0x57/0x59
   [<c06a884c>] ip_output+0x83/0x88
   [<c06a7c9b>] ip_local_out+0x1d/0x20
   [<c06a8427>] ip_queue_xmit+0x2b1/0x2f2
   [<c06b7316>] tcp_transmit_skb+0x5a8/0x5df
   [<c06b9466>] tcp_write_xmit+0x78a/0x858
   [<c06b9561>] tcp_push_one+0x2d/0x31
   [<c06af2f6>] tcp_sendmsg+0x5b1/0x6dc
   [<c0676b49>] __sock_sendmsg+0x4a/0x53
   [<c0677379>] sock_sendmsg+0xbd/0xd3
   [<c0677d14>] sys_sendto+0xa9/0xc8
   [<c0677d50>] sys_send+0x1d/0x1f
   [<c06784bc>] sys_socketcall+0xdf/0x192
   [<c0403b6b>] sysenter_do_call+0x12/0x3f
   [<ffffffff>] 0xffffffff

 ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c069093c>] __qdisc_run+0xc3/0x1f7
   [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
   [<c06a8736>] ip_finish_output2+0x191/0x1cb
   [<c06a87c7>] ip_finish_output+0x57/0x59
   [<c06a884c>] ip_output+0x83/0x88
   [<c06a7c9b>] ip_local_out+0x1d/0x20
   [<c06a8427>] ip_queue_xmit+0x2b1/0x2f2
   [<c06b7316>] tcp_transmit_skb+0x5a8/0x5df
   [<c06b74cc>] tcp_send_ack+0xd6/0xde
   [<c06b9b68>] tcp_delack_timer+0x15a/0x1b1
   [<c0439858>] run_timer_softirq+0x140/0x1a0
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

 -> (&rt_hash_locks[i]){-+..} ops: 620 {
    initial-use  at:
                          [<c0450941>] __lock_acquire+0x302/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                          [<c06a1f11>] rt_intern_hash+0x84/0x407
                          [<c06a29f2>] __ip_route_output_key+0x718/0x74b
                          [<c06a2a38>] ip_route_output_flow+0x13/0x47
                          [<c06c15a8>] udp_sendmsg+0x2df/0x561
                          [<c06c6497>] inet_sendmsg+0x40/0x4d
                          [<c0676b49>] __sock_sendmsg+0x4a/0x53
                          [<c0677379>] sock_sendmsg+0xbd/0xd3
                          [<c0677d14>] sys_sendto+0xa9/0xc8
                          [<c06784d4>] sys_socketcall+0xf7/0x192
                          [<c0403b6b>] sysenter_do_call+0x12/0x3f
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c04508b1>] __lock_acquire+0x272/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                          [<c06a1f11>] rt_intern_hash+0x84/0x407
                          [<c06a29f2>] __ip_route_output_key+0x718/0x74b
                          [<c06a2a38>] ip_route_output_flow+0x13/0x47
                          [<c06a2a7d>] ip_route_output_key+0x11/0x13
                          [<c06c8952>] igmpv3_newpack+0x76/0x17c
                          [<c06c8a7c>] add_grhead+0x24/0x69
                          [<c06c8e12>] add_grec+0x308/0x335
                          [<c06c90ca>] igmp_ifc_timer_expire+0x1c1/0x21a
                          [<c0439858>] run_timer_softirq+0x140/0x1a0
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
    hardirq-on-W at:
                          [<c045090b>] __lock_acquire+0x2cc/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                          [<c06a1f11>] rt_intern_hash+0x84/0x407
                          [<c06a29f2>] __ip_route_output_key+0x718/0x74b
                          [<c06a2a38>] ip_route_output_flow+0x13/0x47
                          [<c06c15a8>] udp_sendmsg+0x2df/0x561
                          [<c06c6497>] inet_sendmsg+0x40/0x4d
                          [<c0676b49>] __sock_sendmsg+0x4a/0x53
                          [<c0677379>] sock_sendmsg+0xbd/0xd3
                          [<c0677d14>] sys_sendto+0xa9/0xc8
                          [<c06784d4>] sys_socketcall+0xf7/0x192
                          [<c0403b6b>] sysenter_do_call+0x12/0x3f
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c0ffa390>] __key.43061+0x0/0x8
  ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c04a349b>] __slab_alloc+0x101/0x466
   [<c04a3b17>] kmem_cache_alloc+0x84/0xe3
   [<c0689628>] neigh_create+0x14b/0x401
   [<c06c213c>] arp_bind_neighbour+0x61/0x77
   [<c06a21bf>] rt_intern_hash+0x332/0x407
   [<c06a29f2>] __ip_route_output_key+0x718/0x74b
   [<c06a2a38>] ip_route_output_flow+0x13/0x47
   [<c06a2a7d>] ip_route_output_key+0x11/0x13
   [<c06c8952>] igmpv3_newpack+0x76/0x17c
   [<c06c8a7c>] add_grhead+0x24/0x69
   [<c06c8e12>] add_grec+0x308/0x335
   [<c06c90ca>] igmp_ifc_timer_expire+0x1c1/0x21a
   [<c0439858>] run_timer_softirq+0x140/0x1a0
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

  ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<c04723f2>] __call_rcu+0x7a/0xf5
   [<c047247f>] call_rcu_bh+0x12/0x14
   [<c06a1436>] rt_worker_func+0x1d5/0x263
   [<c043f898>] run_workqueue+0xdb/0x1a9
   [<c043fa37>] worker_thread+0xd1/0xdd
   [<c0442ae0>] kthread+0x40/0x66
   [<c040453f>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

 ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5fe9>] _spin_lock_bh+0x28/0x58
   [<c06a1f11>] rt_intern_hash+0x84/0x407
   [<c06a29f2>] __ip_route_output_key+0x718/0x74b
   [<c06c4052>] icmp_send+0x26f/0x369
   [<c06d46c1>] reject_tg+0x40/0x2cb
   [<c06d4544>] ipt_do_table+0x262/0x2b2
   [<c06d4639>] ipt_local_in_hook+0x1d/0x24
   [<c0698c60>] nf_iterate+0x34/0x67
   [<c0698e1c>] nf_hook_slow+0x5e/0xca
   [<c06a4a76>] ip_local_deliver+0x55/0x6f
   [<c06a4685>] ip_rcv_finish+0x241/0x257
   [<c06a488d>] ip_rcv+0x1f2/0x21c
   [<c0682464>] netif_receive_skb+0x322/0x355
   [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
   [<c068288b>] process_backlog+0x8e/0xca
   [<c0680fc7>] net_rx_action+0x70/0x16b
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

 -> (rt_peer_lock){-+..} ops: 3 {
    initial-use  at:
                          [<c0450941>] __lock_acquire+0x302/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                          [<c06a3d11>] rt_bind_peer+0x23/0x4d
                          [<c06a3d69>] __ip_select_ident+0x2e/0xa9
                          [<c06a7ea6>] ip_push_pending_frames+0x208/0x2c6
                          [<c06c3746>] icmp_push_reply+0xd1/0xdc
                          [<c06c412a>] icmp_send+0x347/0x369
                          [<c06d46c1>] reject_tg+0x40/0x2cb
                          [<c06d4544>] ipt_do_table+0x262/0x2b2
                          [<c06d4639>] ipt_local_in_hook+0x1d/0x24
                          [<c0698c60>] nf_iterate+0x34/0x67
                          [<c0698e1c>] nf_hook_slow+0x5e/0xca
                          [<c06a4a76>] ip_local_deliver+0x55/0x6f
                          [<c06a4685>] ip_rcv_finish+0x241/0x257
                          [<c06a488d>] ip_rcv+0x1f2/0x21c
                          [<c0682464>] netif_receive_skb+0x322/0x355
                          [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
                          [<c068288b>] process_backlog+0x8e/0xca
                          [<c0680fc7>] net_rx_action+0x70/0x16b
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c04508b1>] __lock_acquire+0x272/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                          [<c06a3d11>] rt_bind_peer+0x23/0x4d
                          [<c06a3d69>] __ip_select_ident+0x2e/0xa9
                          [<c06a7ea6>] ip_push_pending_frames+0x208/0x2c6
                          [<c06c3746>] icmp_push_reply+0xd1/0xdc
                          [<c06c412a>] icmp_send+0x347/0x369
                          [<c06d46c1>] reject_tg+0x40/0x2cb
                          [<c06d4544>] ipt_do_table+0x262/0x2b2
                          [<c06d4639>] ipt_local_in_hook+0x1d/0x24
                          [<c0698c60>] nf_iterate+0x34/0x67
                          [<c0698e1c>] nf_hook_slow+0x5e/0xca
                          [<c06a4a76>] ip_local_deliver+0x55/0x6f
                          [<c06a4685>] ip_rcv_finish+0x241/0x257
                          [<c06a488d>] ip_rcv+0x1f2/0x21c
                          [<c0682464>] netif_receive_skb+0x322/0x355
                          [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
                          [<c068288b>] process_backlog+0x8e/0xca
                          [<c0680fc7>] net_rx_action+0x70/0x16b
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
    hardirq-on-W at:
                          [<c045090b>] __lock_acquire+0x2cc/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                          [<c06a3d11>] rt_bind_peer+0x23/0x4d
                          [<c06a3d69>] __ip_select_ident+0x2e/0xa9
                          [<c06a7ea6>] ip_push_pending_frames+0x208/0x2c6
                          [<c06c3746>] icmp_push_reply+0xd1/0xdc
                          [<c06c412a>] icmp_send+0x347/0x369
                          [<c06d46c1>] reject_tg+0x40/0x2cb
                          [<c06d4544>] ipt_do_table+0x262/0x2b2
                          [<c06d4639>] ipt_local_in_hook+0x1d/0x24
                          [<c0698c60>] nf_iterate+0x34/0x67
                          [<c0698e1c>] nf_hook_slow+0x5e/0xca
                          [<c06a4a76>] ip_local_deliver+0x55/0x6f
                          [<c06a4685>] ip_rcv_finish+0x241/0x257
                          [<c06a488d>] ip_rcv+0x1f2/0x21c
                          [<c0682464>] netif_receive_skb+0x322/0x355
                          [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
                          [<c068288b>] process_backlog+0x8e/0xca
                          [<c0680fc7>] net_rx_action+0x70/0x16b
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c0887ac0>] rt_peer_lock.43875+0x10/0x24
 ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5fe9>] _spin_lock_bh+0x28/0x58
   [<c06a3d11>] rt_bind_peer+0x23/0x4d
   [<c06a3d69>] __ip_select_ident+0x2e/0xa9
   [<c06a7ea6>] ip_push_pending_frames+0x208/0x2c6
   [<c06c3746>] icmp_push_reply+0xd1/0xdc
   [<c06c412a>] icmp_send+0x347/0x369
   [<c06d46c1>] reject_tg+0x40/0x2cb
   [<c06d4544>] ipt_do_table+0x262/0x2b2
   [<c06d4639>] ipt_local_in_hook+0x1d/0x24
   [<c0698c60>] nf_iterate+0x34/0x67
   [<c0698e1c>] nf_hook_slow+0x5e/0xca
   [<c06a4a76>] ip_local_deliver+0x55/0x6f
   [<c06a4685>] ip_rcv_finish+0x241/0x257
   [<c06a488d>] ip_rcv+0x1f2/0x21c
   [<c0682464>] netif_receive_skb+0x322/0x355
   [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
   [<c068288b>] process_backlog+0x8e/0xca
   [<c0680fc7>] net_rx_action+0x70/0x16b
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

 -> (inet_peer_idlock){-+..} ops: 59 {
    initial-use  at:
                          [<c0450941>] __lock_acquire+0x302/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                          [<c06a3d7d>] __ip_select_ident+0x42/0xa9
                          [<c06a7ea6>] ip_push_pending_frames+0x208/0x2c6
                          [<c06c3746>] icmp_push_reply+0xd1/0xdc
                          [<c06c412a>] icmp_send+0x347/0x369
                          [<c06d46c1>] reject_tg+0x40/0x2cb
                          [<c06d4544>] ipt_do_table+0x262/0x2b2
                          [<c06d4639>] ipt_local_in_hook+0x1d/0x24
                          [<c0698c60>] nf_iterate+0x34/0x67
                          [<c0698e1c>] nf_hook_slow+0x5e/0xca
                          [<c06a4a76>] ip_local_deliver+0x55/0x6f
                          [<c06a4685>] ip_rcv_finish+0x241/0x257
                          [<c06a488d>] ip_rcv+0x1f2/0x21c
                          [<c0682464>] netif_receive_skb+0x322/0x355
                          [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
                          [<c068288b>] process_backlog+0x8e/0xca
                          [<c0680fc7>] net_rx_action+0x70/0x16b
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c04508b1>] __lock_acquire+0x272/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                          [<c06a3d7d>] __ip_select_ident+0x42/0xa9
                          [<c06a7ea6>] ip_push_pending_frames+0x208/0x2c6
                          [<c06c3746>] icmp_push_reply+0xd1/0xdc
                          [<c06c412a>] icmp_send+0x347/0x369
                          [<c06d46c1>] reject_tg+0x40/0x2cb
                          [<c06d4544>] ipt_do_table+0x262/0x2b2
                          [<c06d4639>] ipt_local_in_hook+0x1d/0x24
                          [<c0698c60>] nf_iterate+0x34/0x67
                          [<c0698e1c>] nf_hook_slow+0x5e/0xca
                          [<c06a4a76>] ip_local_deliver+0x55/0x6f
                          [<c06a4685>] ip_rcv_finish+0x241/0x257
                          [<c06a488d>] ip_rcv+0x1f2/0x21c
                          [<c0682464>] netif_receive_skb+0x322/0x355
                          [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
                          [<c068288b>] process_backlog+0x8e/0xca
                          [<c0680fc7>] net_rx_action+0x70/0x16b
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
    hardirq-on-W at:
                          [<c045090b>] __lock_acquire+0x2cc/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5fe9>] _spin_lock_bh+0x28/0x58
                          [<c06a3d7d>] __ip_select_ident+0x42/0xa9
                          [<c06a7ea6>] ip_push_pending_frames+0x208/0x2c6
                          [<c06c3746>] icmp_push_reply+0xd1/0xdc
                          [<c06c412a>] icmp_send+0x347/0x369
                          [<c06d46c1>] reject_tg+0x40/0x2cb
                          [<c06d4544>] ipt_do_table+0x262/0x2b2
                          [<c06d4639>] ipt_local_in_hook+0x1d/0x24
                          [<c0698c60>] nf_iterate+0x34/0x67
                          [<c0698e1c>] nf_hook_slow+0x5e/0xca
                          [<c06a4a76>] ip_local_deliver+0x55/0x6f
                          [<c06a4685>] ip_rcv_finish+0x241/0x257
                          [<c06a488d>] ip_rcv+0x1f2/0x21c
                          [<c0682464>] netif_receive_skb+0x322/0x355
                          [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
                          [<c068288b>] process_backlog+0x8e/0xca
                          [<c0680fc7>] net_rx_action+0x70/0x16b
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c0887dd0>] inet_peer_idlock+0x10/0x24
 ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5fe9>] _spin_lock_bh+0x28/0x58
   [<c06a3d7d>] __ip_select_ident+0x42/0xa9
   [<c06a7ea6>] ip_push_pending_frames+0x208/0x2c6
   [<c06c3746>] icmp_push_reply+0xd1/0xdc
   [<c06c412a>] icmp_send+0x347/0x369
   [<c06d46c1>] reject_tg+0x40/0x2cb
   [<c06d4544>] ipt_do_table+0x262/0x2b2
   [<c06d4639>] ipt_local_in_hook+0x1d/0x24
   [<c0698c60>] nf_iterate+0x34/0x67
   [<c0698e1c>] nf_hook_slow+0x5e/0xca
   [<c06a4a76>] ip_local_deliver+0x55/0x6f
   [<c06a4685>] ip_rcv_finish+0x241/0x257
   [<c06a488d>] ip_rcv+0x1f2/0x21c
   [<c0682464>] netif_receive_skb+0x322/0x355
   [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
   [<c068288b>] process_backlog+0x8e/0xca
   [<c0680fc7>] net_rx_action+0x70/0x16b
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

 -> (&n->lock){-+-+} ops: 375 {
    initial-use  at:
                          [<c0450941>] __lock_acquire+0x302/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f61a5>] _write_lock_bh+0x28/0x58
                          [<c0688073>] neigh_resolve_output+0x9b/0x250
                          [<c06a8745>] ip_finish_output2+0x1a0/0x1cb
                          [<c06a87c7>] ip_finish_output+0x57/0x59
                          [<c06a884c>] ip_output+0x83/0x88
                          [<c06a7c9b>] ip_local_out+0x1d/0x20
                          [<c06a7f09>] ip_push_pending_frames+0x26b/0x2c6
                          [<c06c0333>] udp_push_pending_frames+0x2ad/0x2ff
                          [<c06c174a>] udp_sendmsg+0x481/0x561
                          [<c06c6497>] inet_sendmsg+0x40/0x4d
                          [<c0676b49>] __sock_sendmsg+0x4a/0x53
                          [<c0677379>] sock_sendmsg+0xbd/0xd3
                          [<c0677d14>] sys_sendto+0xa9/0xc8
                          [<c06784d4>] sys_socketcall+0xf7/0x192
                          [<c0403b6b>] sysenter_do_call+0x12/0x3f
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c04508b1>] __lock_acquire+0x272/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f61a5>] _write_lock_bh+0x28/0x58
                          [<c0688073>] neigh_resolve_output+0x9b/0x250
                          [<f88bf769>] ip6_output_finish+0x97/0xe0 [ipv6]
                          [<f88c140b>] ip6_output2+0x1d7/0x1df [ipv6]
                          [<f88c1e53>] ip6_output+0xa40/0xa4d [ipv6]
                          [<f88d4e79>] mld_sendpack+0x194/0x289 [ipv6]
                          [<f88d5996>] mld_ifc_timer_expire+0x1dd/0x20c [ipv6]
                          [<c0439858>] run_timer_softirq+0x140/0x1a0
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
    hardirq-on-W at:
                          [<c045090b>] __lock_acquire+0x2cc/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f61a5>] _write_lock_bh+0x28/0x58
                          [<c0688073>] neigh_resolve_output+0x9b/0x250
                          [<c06a8745>] ip_finish_output2+0x1a0/0x1cb
                          [<c06a87c7>] ip_finish_output+0x57/0x59
                          [<c06a884c>] ip_output+0x83/0x88
                          [<c06a7c9b>] ip_local_out+0x1d/0x20
                          [<c06a7f09>] ip_push_pending_frames+0x26b/0x2c6
                          [<c06c0333>] udp_push_pending_frames+0x2ad/0x2ff
                          [<c06c174a>] udp_sendmsg+0x481/0x561
                          [<c06c6497>] inet_sendmsg+0x40/0x4d
                          [<c0676b49>] __sock_sendmsg+0x4a/0x53
                          [<c0677379>] sock_sendmsg+0xbd/0xd3
                          [<c0677d14>] sys_sendto+0xa9/0xc8
                          [<c06784d4>] sys_socketcall+0xf7/0x192
                          [<c0403b6b>] sysenter_do_call+0x12/0x3f
                          [<ffffffff>] 0xffffffff
    in-softirq-R at:
                          [<c04508b1>] __lock_acquire+0x272/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f630e>] _read_lock_bh+0x28/0x58
                          [<c06876df>] neigh_fill_info+0xa0/0x182
                          [<c0687cc4>] __neigh_notify+0x3d/0xa7
                          [<c0688ba4>] neigh_cleanup_and_release+0x27/0x31
                          [<c0688d0f>] neigh_periodic_timer+0xe5/0x14d
                          [<c0439858>] run_timer_softirq+0x140/0x1a0
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
    hardirq-on-R at:
                          [<c04508de>] __lock_acquire+0x29f/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f630e>] _read_lock_bh+0x28/0x58
                          [<c06876df>] neigh_fill_info+0xa0/0x182
                          [<c0687cc4>] __neigh_notify+0x3d/0xa7
                          [<c0688ba4>] neigh_cleanup_and_release+0x27/0x31
                          [<c0688d0f>] neigh_periodic_timer+0xe5/0x14d
                          [<c0439858>] run_timer_softirq+0x140/0x1a0
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c0ffa0c4>] __key.33760+0x0/0x8
  ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<c0439df6>] lock_timer_base+0x24/0x43
   [<c0439f4a>] __mod_timer+0x2c/0xac
   [<c043a051>] mod_timer+0x35/0x39
   [<c0687e7b>] neigh_add_timer+0x1a/0x39
   [<c0687f44>] __neigh_event_send+0xaa/0x13e
   [<c068803b>] neigh_resolve_output+0x63/0x250
   [<c06a8745>] ip_finish_output2+0x1a0/0x1cb
   [<c06a87c7>] ip_finish_output+0x57/0x59
   [<c06a884c>] ip_output+0x83/0x88
   [<c06a7c9b>] ip_local_out+0x1d/0x20
   [<c06a7f09>] ip_push_pending_frames+0x26b/0x2c6
   [<c06c0333>] udp_push_pending_frames+0x2ad/0x2ff
   [<c06c174a>] udp_sendmsg+0x481/0x561
   [<c06c6497>] inet_sendmsg+0x40/0x4d
   [<c0676b49>] __sock_sendmsg+0x4a/0x53
   [<c0677379>] sock_sendmsg+0xbd/0xd3
   [<c0677d14>] sys_sendto+0xa9/0xc8
   [<c0677d50>] sys_send+0x1d/0x1f
   [<c06784bc>] sys_socketcall+0xdf/0x192
   [<c0403b6b>] sysenter_do_call+0x12/0x3f
   [<ffffffff>] 0xffffffff

  -> (&list->lock#7){.+..} ops: 12 {
     initial-use  at:
                            [<c0450941>] __lock_acquire+0x302/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                            [<c067c14b>] skb_dequeue+0x17/0x51
                            [<c067c923>] skb_queue_purge+0x19/0x20
                            [<c0688b1e>] neigh_destroy+0xba/0xfb
                            [<c0688b7b>] neigh_release+0x1c/0x1e
                            [<c0688bab>] neigh_cleanup_and_release+0x2e/0x31
                            [<c0688d0f>] neigh_periodic_timer+0xe5/0x14d
                            [<c0439858>] run_timer_softirq+0x140/0x1a0
                            [<c043653a>] __do_softirq+0x9d/0x157
                            [<ffffffff>] 0xffffffff
     in-softirq-W at:
                            [<c04508b1>] __lock_acquire+0x272/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                            [<c067c14b>] skb_dequeue+0x17/0x51
                            [<c067c923>] skb_queue_purge+0x19/0x20
                            [<c0688b1e>] neigh_destroy+0xba/0xfb
                            [<c0688b7b>] neigh_release+0x1c/0x1e
                            [<c0688bab>] neigh_cleanup_and_release+0x2e/0x31
                            [<c0688d0f>] neigh_periodic_timer+0xe5/0x14d
                            [<c0439858>] run_timer_softirq+0x140/0x1a0
                            [<c043653a>] __do_softirq+0x9d/0x157
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c0ffa0b4>] __key.18732+0x0/0x8
  ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<c067c14b>] skb_dequeue+0x17/0x51
   [<c067c923>] skb_queue_purge+0x19/0x20
   [<c06890e4>] neigh_update+0x338/0x38b
   [<c06c3030>] arp_process+0x4ca/0x4fe
   [<c06c3152>] arp_rcv+0xdf/0xf2
   [<c0682464>] netif_receive_skb+0x322/0x355
   [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
   [<c068288b>] process_backlog+0x8e/0xca
   [<c0680fc7>] net_rx_action+0x70/0x16b
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

 ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f61a5>] _write_lock_bh+0x28/0x58
   [<c0688073>] neigh_resolve_output+0x9b/0x250
   [<c06a8745>] ip_finish_output2+0x1a0/0x1cb
   [<c06a87c7>] ip_finish_output+0x57/0x59
   [<c06a884c>] ip_output+0x83/0x88
   [<c06a7c9b>] ip_local_out+0x1d/0x20
   [<c06a7f09>] ip_push_pending_frames+0x26b/0x2c6
   [<c06c3746>] icmp_push_reply+0xd1/0xdc
   [<c06c412a>] icmp_send+0x347/0x369
   [<c06d46c1>] reject_tg+0x40/0x2cb
   [<c06d4544>] ipt_do_table+0x262/0x2b2
   [<c06d4639>] ipt_local_in_hook+0x1d/0x24
   [<c0698c60>] nf_iterate+0x34/0x67
   [<c0698e1c>] nf_hook_slow+0x5e/0xca
   [<c06a4a76>] ip_local_deliver+0x55/0x6f
   [<c06a4685>] ip_rcv_finish+0x241/0x257
   [<c06a488d>] ip_rcv+0x1f2/0x21c
   [<c0682464>] netif_receive_skb+0x322/0x355
   [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
   [<c068288b>] process_backlog+0x8e/0xca
   [<c0680fc7>] net_rx_action+0x70/0x16b
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

 ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c06aa452>] __inet_hash_nolisten+0x7e/0xb3
   [<c06bc922>] tcp_v4_syn_recv_sock+0x196/0x1dd
   [<c06bd424>] tcp_check_req+0x1b4/0x340
   [<c06bbe87>] tcp_v4_do_rcv+0x1c4/0x2ad
   [<c06bc2d6>] tcp_v4_rcv+0x366/0x553
   [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
   [<c06a4a87>] ip_local_deliver+0x66/0x6f
   [<c06a4685>] ip_rcv_finish+0x241/0x257
   [<c06a488d>] ip_rcv+0x1f2/0x21c
   [<c0682464>] netif_receive_skb+0x322/0x355
   [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
   [<c068288b>] process_backlog+0x8e/0xca
   [<c0680fc7>] net_rx_action+0x70/0x16b
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

 -> (&queue->syn_wait_lock){-+-.} ops: 205 {
    initial-use  at:
                          [<c0450941>] __lock_acquire+0x302/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f61a5>] _write_lock_bh+0x28/0x58
                          [<c067adbb>] reqsk_queue_alloc+0xba/0xcf
                          [<c06ab982>] inet_csk_listen_start+0x1d/0xbc
                          [<c06c7445>] inet_listen+0x43/0x67
                          [<c0677126>] sys_listen+0x48/0x62
                          [<c0678479>] sys_socketcall+0x9c/0x192
                          [<c0403b6b>] sysenter_do_call+0x12/0x3f
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c04508b1>] __lock_acquire+0x272/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f614d>] _write_lock+0x23/0x53
                          [<c06abeb4>] inet_csk_reqsk_queue_hash_add+0x69/0xaf
                          [<c06bbba3>] tcp_v4_conn_request+0x3f7/0x42c
                          [<c06b5c64>] tcp_rcv_state_process+0x62/0x892
                          [<c06bbf27>] tcp_v4_do_rcv+0x264/0x2ad
                          [<c06bc2d6>] tcp_v4_rcv+0x366/0x553
                          [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
                          [<c06a4a87>] ip_local_deliver+0x66/0x6f
                          [<c06a4685>] ip_rcv_finish+0x241/0x257
                          [<c06a488d>] ip_rcv+0x1f2/0x21c
                          [<c0682464>] netif_receive_skb+0x322/0x355
                          [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
                          [<c068288b>] process_backlog+0x8e/0xca
                          [<c0680fc7>] net_rx_action+0x70/0x16b
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
    hardirq-on-W at:
                          [<c045090b>] __lock_acquire+0x2cc/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f61a5>] _write_lock_bh+0x28/0x58
                          [<c067adbb>] reqsk_queue_alloc+0xba/0xcf
                          [<c06ab982>] inet_csk_listen_start+0x1d/0xbc
                          [<c06c7445>] inet_listen+0x43/0x67
                          [<c0677126>] sys_listen+0x48/0x62
                          [<c0678479>] sys_socketcall+0x9c/0x192
                          [<c0403b6b>] sysenter_do_call+0x12/0x3f
                          [<ffffffff>] 0xffffffff
    hardirq-on-R at:
                          [<c04508de>] __lock_acquire+0x29f/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f630e>] _read_lock_bh+0x28/0x58
                          [<c06bb1a0>] listening_get_next+0x11b/0x1b0
                          [<c06bb25f>] tcp_get_idx+0x2a/0x79
                          [<c06bb309>] tcp_seq_next+0x1d/0x5f
                          [<c04bc3cf>] seq_read+0x1d2/0x2b0
                          [<c04dc4fc>] proc_reg_read+0x65/0x79
                          [<c04a8750>] vfs_read+0x86/0xe1
                          [<c04a884e>] sys_read+0x40/0x65
                          [<c0403b6b>] sysenter_do_call+0x12/0x3f
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c0ff963c>] __key.33787+0x0/0x8
 ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f614d>] _write_lock+0x23/0x53
   [<c06bd493>] tcp_check_req+0x223/0x340
   [<c06bbe87>] tcp_v4_do_rcv+0x1c4/0x2ad
   [<c06bc2d6>] tcp_v4_rcv+0x366/0x553
   [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
   [<c06a4a87>] ip_local_deliver+0x66/0x6f
   [<c06a4685>] ip_rcv_finish+0x241/0x257
   [<c06a488d>] ip_rcv+0x1f2/0x21c
   [<c0682464>] netif_receive_skb+0x322/0x355
   [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
   [<c068288b>] process_backlog+0x8e/0xca
   [<c0680fc7>] net_rx_action+0x70/0x16b
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

 -> (_xmit_NONE#2){-+..} ops: 933 {
    initial-use  at:
                          [<c0450941>] __lock_acquire+0x302/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5f91>] _spin_lock+0x23/0x53
                          [<c069093c>] __qdisc_run+0xc3/0x1f7
                          [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
                          [<c06a8745>] ip_finish_output2+0x1a0/0x1cb
                          [<c06a87c7>] ip_finish_output+0x57/0x59
                          [<c06a884c>] ip_output+0x83/0x88
                          [<c06a7c9b>] ip_local_out+0x1d/0x20
                          [<c06a7f09>] ip_push_pending_frames+0x26b/0x2c6
                          [<c06c0333>] udp_push_pending_frames+0x2ad/0x2ff
                          [<c06c174a>] udp_sendmsg+0x481/0x561
                          [<c06c6497>] inet_sendmsg+0x40/0x4d
                          [<c0676b49>] __sock_sendmsg+0x4a/0x53
                          [<c0677379>] sock_sendmsg+0xbd/0xd3
                          [<c0677d14>] sys_sendto+0xa9/0xc8
                          [<c06784d4>] sys_socketcall+0xf7/0x192
                          [<c0403b6b>] sysenter_do_call+0x12/0x3f
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c04508b1>] __lock_acquire+0x272/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5f91>] _spin_lock+0x23/0x53
                          [<c069093c>] __qdisc_run+0xc3/0x1f7
                          [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
                          [<c06a8745>] ip_finish_output2+0x1a0/0x1cb
                          [<c06a87c7>] ip_finish_output+0x57/0x59
                          [<c06a884c>] ip_output+0x83/0x88
                          [<c06a7c9b>] ip_local_out+0x1d/0x20
                          [<c06a8427>] ip_queue_xmit+0x2b1/0x2f2
                          [<c06b7316>] tcp_transmit_skb+0x5a8/0x5df
                          [<c06b74cc>] tcp_send_ack+0xd6/0xde
                          [<c06b5fab>] tcp_rcv_state_process+0x3a9/0x892
                          [<c06bbf27>] tcp_v4_do_rcv+0x264/0x2ad
                          [<c06bc2d6>] tcp_v4_rcv+0x366/0x553
                          [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
                          [<c06a4a87>] ip_local_deliver+0x66/0x6f
                          [<c06a4685>] ip_rcv_finish+0x241/0x257
                          [<c06a488d>] ip_rcv+0x1f2/0x21c
                          [<c0682464>] netif_receive_skb+0x322/0x355
                          [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
                          [<c068288b>] process_backlog+0x8e/0xca
                          [<c0680fc7>] net_rx_action+0x70/0x16b
                          [<c043653a>] __do_softirq+0x9d/0x157
                          [<ffffffff>] 0xffffffff
    hardirq-on-W at:
                          [<c045090b>] __lock_acquire+0x2cc/0xb4a
                          [<c04511f9>] lock_acquire+0x70/0x97
                          [<c06f5f91>] _spin_lock+0x23/0x53
                          [<c069093c>] __qdisc_run+0xc3/0x1f7
                          [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
                          [<c06a8745>] ip_finish_output2+0x1a0/0x1cb
                          [<c06a87c7>] ip_finish_output+0x57/0x59
                          [<c06a884c>] ip_output+0x83/0x88
                          [<c06a7c9b>] ip_local_out+0x1d/0x20
                          [<c06a7f09>] ip_push_pending_frames+0x26b/0x2c6
                          [<c06c0333>] udp_push_pending_frames+0x2ad/0x2ff
                          [<c06c174a>] udp_sendmsg+0x481/0x561
                          [<c06c6497>] inet_sendmsg+0x40/0x4d
                          [<c0676b49>] __sock_sendmsg+0x4a/0x53
                          [<c0677379>] sock_sendmsg+0xbd/0xd3
                          [<c0677d14>] sys_sendto+0xa9/0xc8
                          [<c06784d4>] sys_socketcall+0xf7/0x192
                          [<c0403b6b>] sysenter_do_call+0x12/0x3f
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c0ff9d44>] netdev_xmit_lock_key+0x1c0/0x1c8
  -> (&list->lock#8){.+..} ops: 1866 {
     initial-use  at:
                            [<c0450941>] __lock_acquire+0x302/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                            [<c067c08e>] skb_queue_tail+0x19/0x37
                            [<f7d32427>] tun_net_xmit+0xf8/0x14f [tun]
                            [<c0682cd2>] dev_hard_start_xmit+0x219/0x288
                            [<c069096d>] __qdisc_run+0xf4/0x1f7
                            [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
                            [<c06a8745>] ip_finish_output2+0x1a0/0x1cb
                            [<c06a87c7>] ip_finish_output+0x57/0x59
                            [<c06a884c>] ip_output+0x83/0x88
                            [<c06a7c9b>] ip_local_out+0x1d/0x20
                            [<c06a7f09>] ip_push_pending_frames+0x26b/0x2c6
                            [<c06c0333>] udp_push_pending_frames+0x2ad/0x2ff
                            [<c06c174a>] udp_sendmsg+0x481/0x561
                            [<c06c6497>] inet_sendmsg+0x40/0x4d
                            [<c0676b49>] __sock_sendmsg+0x4a/0x53
                            [<c0677379>] sock_sendmsg+0xbd/0xd3
                            [<c0677d14>] sys_sendto+0xa9/0xc8
                            [<c06784d4>] sys_socketcall+0xf7/0x192
                            [<c0403b6b>] sysenter_do_call+0x12/0x3f
                            [<ffffffff>] 0xffffffff
     in-softirq-W at:
                            [<c04508b1>] __lock_acquire+0x272/0xb4a
                            [<c04511f9>] lock_acquire+0x70/0x97
                            [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
                            [<c067c08e>] skb_queue_tail+0x19/0x37
                            [<f7d32427>] tun_net_xmit+0xf8/0x14f [tun]
                            [<c0682cd2>] dev_hard_start_xmit+0x219/0x288
                            [<c069096d>] __qdisc_run+0xf4/0x1f7
                            [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
                            [<c06a8745>] ip_finish_output2+0x1a0/0x1cb
                            [<c06a87c7>] ip_finish_output+0x57/0x59
                            [<c06a884c>] ip_output+0x83/0x88
                            [<c06a7c9b>] ip_local_out+0x1d/0x20
                            [<c06a8427>] ip_queue_xmit+0x2b1/0x2f2
                            [<c06b7316>] tcp_transmit_skb+0x5a8/0x5df
                            [<c06b74cc>] tcp_send_ack+0xd6/0xde
                            [<c06b5fab>] tcp_rcv_state_process+0x3a9/0x892
                            [<c06bbf27>] tcp_v4_do_rcv+0x264/0x2ad
                            [<c06bc2d6>] tcp_v4_rcv+0x366/0x553
                            [<c06a4998>] ip_local_deliver_finish+0xe1/0x16a
                            [<c06a4a87>] ip_local_deliver+0x66/0x6f
                            [<c06a4685>] ip_rcv_finish+0x241/0x257
                            [<c06a488d>] ip_rcv+0x1f2/0x21c
                            [<c0682464>] netif_receive_skb+0x322/0x355
                            [<c06827f5>] napi_gro_receive+0x1bf/0x1c7
                            [<c068288b>] process_backlog+0x8e/0xca
                            [<c0680fc7>] net_rx_action+0x70/0x16b
                            [<c043653a>] __do_softirq+0x9d/0x157
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<f7d35800>] __key.24574+0x0/0xffffda91 [tun]
  ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<c067c08e>] skb_queue_tail+0x19/0x37
   [<f7d32427>] tun_net_xmit+0xf8/0x14f [tun]
   [<c0682cd2>] dev_hard_start_xmit+0x219/0x288
   [<c069096d>] __qdisc_run+0xf4/0x1f7
   [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
   [<c06a8745>] ip_finish_output2+0x1a0/0x1cb
   [<c06a87c7>] ip_finish_output+0x57/0x59
   [<c06a884c>] ip_output+0x83/0x88
   [<c06a7c9b>] ip_local_out+0x1d/0x20
   [<c06a7f09>] ip_push_pending_frames+0x26b/0x2c6
   [<c06c0333>] udp_push_pending_frames+0x2ad/0x2ff
   [<c06c174a>] udp_sendmsg+0x481/0x561
   [<c06c6497>] inet_sendmsg+0x40/0x4d
   [<c0676b49>] __sock_sendmsg+0x4a/0x53
   [<c0677379>] sock_sendmsg+0xbd/0xd3
   [<c0677d14>] sys_sendto+0xa9/0xc8
   [<c06784d4>] sys_socketcall+0xf7/0x192
   [<c0403b6b>] sysenter_do_call+0x12/0x3f
   [<ffffffff>] 0xffffffff

  ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<c04250ac>] __wake_up+0x1a/0x40
   [<f7d32466>] tun_net_xmit+0x137/0x14f [tun]
   [<c0682cd2>] dev_hard_start_xmit+0x219/0x288
   [<c069096d>] __qdisc_run+0xf4/0x1f7
   [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
   [<c06a8745>] ip_finish_output2+0x1a0/0x1cb
   [<c06a87c7>] ip_finish_output+0x57/0x59
   [<c06a884c>] ip_output+0x83/0x88
   [<c06a7c9b>] ip_local_out+0x1d/0x20
   [<c06a7f09>] ip_push_pending_frames+0x26b/0x2c6
   [<c06c0333>] udp_push_pending_frames+0x2ad/0x2ff
   [<c06c174a>] udp_sendmsg+0x481/0x561
   [<c06c6497>] inet_sendmsg+0x40/0x4d
   [<c0676b49>] __sock_sendmsg+0x4a/0x53
   [<c0677379>] sock_sendmsg+0xbd/0xd3
   [<c0677d14>] sys_sendto+0xa9/0xc8
   [<c06784d4>] sys_socketcall+0xf7/0x192
   [<c0403b6b>] sysenter_do_call+0x12/0x3f
   [<ffffffff>] 0xffffffff

 ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f5f91>] _spin_lock+0x23/0x53
   [<c069093c>] __qdisc_run+0xc3/0x1f7
   [<c06831cc>] dev_queue_xmit+0x3a1/0x4d1
   [<c06a8745>] ip_finish_output2+0x1a0/0x1cb
   [<c06a87c7>] ip_finish_output+0x57/0x59
   [<c06a884c>] ip_output+0x83/0x88
   [<c06a7c9b>] ip_local_out+0x1d/0x20
   [<c06a8427>] ip_queue_xmit+0x2b1/0x2f2
   [<c06b7316>] tcp_transmit_skb+0x5a8/0x5df
   [<c06b74cc>] tcp_send_ack+0xd6/0xde
   [<c06b9b68>] tcp_delack_timer+0x15a/0x1b1
   [<c0439858>] run_timer_softirq+0x140/0x1a0
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff

 ... acquired at:
   [<c0451003>] __lock_acquire+0x9c4/0xb4a
   [<c04511f9>] lock_acquire+0x70/0x97
   [<c06f60ba>] _spin_lock_irqsave+0x3f/0x72
   [<c04723f2>] __call_rcu+0x7a/0xf5
   [<c0472493>] call_rcu+0x12/0x14
   [<c069ad31>] nf_conntrack_free+0x29/0x2c
   [<c069b15f>] nf_conntrack_in+0x1db/0x478
   [<c06d2bda>] ipv4_conntrack_local+0x52/0x59
   [<c0698c60>] nf_iterate+0x34/0x67
   [<c0698e1c>] nf_hook_slow+0x5e/0xca
   [<c06a7c74>] __ip_local_out+0x8c/0x96
   [<c06a7c8e>] ip_local_out+0x10/0x20
   [<c06a8427>] ip_queue_xmit+0x2b1/0x2f2
   [<c06b7316>] tcp_transmit_skb+0x5a8/0x5df
   [<c06b89e5>] tcp_retransmit_skb+0x49b/0x594
   [<c06ba06d>] tcp_write_timer+0x3ce/0x575
   [<c0439858>] run_timer_softirq+0x140/0x1a0
   [<c043653a>] __do_softirq+0x9d/0x157
   [<ffffffff>] 0xffffffff


the soft-irq-unsafe lock's dependencies:
-> (&fbc->lock){--..} ops: 2626 {
   initial-use  at:
                        [<c0450941>] __lock_acquire+0x302/0xb4a
                        [<c04511f9>] lock_acquire+0x70/0x97
                        [<c06f5f91>] _spin_lock+0x23/0x53
                        [<c0548c68>] __percpu_counter_sum+0xd/0x4a
                        [<c04f383d>] ext3_statfs+0xbf/0x163
                        [<c04a75b2>] vfs_statfs+0x4e/0x67
                        [<c04a769f>] sys_statfs64+0x49/0x85
                        [<c0403b6b>] sysenter_do_call+0x12/0x3f
                        [<ffffffff>] 0xffffffff
   softirq-on-W at:
                        [<c045092c>] __lock_acquire+0x2ed/0xb4a
                        [<c04511f9>] lock_acquire+0x70/0x97
                        [<c06f5f91>] _spin_lock+0x23/0x53
                        [<c0548c68>] __percpu_counter_sum+0xd/0x4a
                        [<c04f383d>] ext3_statfs+0xbf/0x163
                        [<c04a75b2>] vfs_statfs+0x4e/0x67
                        [<c04a769f>] sys_statfs64+0x49/0x85
                        [<c0403b6b>] sysenter_do_call+0x12/0x3f
                        [<ffffffff>] 0xffffffff
   hardirq-on-W at:
                        [<c045090b>] __lock_acquire+0x2cc/0xb4a
                        [<c04511f9>] lock_acquire+0x70/0x97
                        [<c06f5f91>] _spin_lock+0x23/0x53
                        [<c0548c68>] __percpu_counter_sum+0xd/0x4a
                        [<c04f383d>] ext3_statfs+0xbf/0x163
                        [<c04a75b2>] vfs_statfs+0x4e/0x67
                        [<c04a769f>] sys_statfs64+0x49/0x85
                        [<c0403b6b>] sysenter_do_call+0x12/0x3f
                        [<ffffffff>] 0xffffffff
 }
 ... key      at: [<c0fdc974>] __key.11891+0x0/0x8

stack backtrace:
Pid: 3695, comm: firefox Not tainted 2.6.28 #2
Call Trace:
 [<c06f391c>] ? printk+0x14/0x18
 [<c045062e>] check_usage+0x1fb/0x20c
 [<c0450f40>] __lock_acquire+0x901/0xb4a
 [<c04511f9>] lock_acquire+0x70/0x97
 [<c0548cf7>] ? __percpu_counter_add+0x52/0x7a
 [<c06f5f91>] _spin_lock+0x23/0x53
 [<c0548cf7>] ? __percpu_counter_add+0x52/0x7a
 [<c0548cf7>] __percpu_counter_add+0x52/0x7a
 [<c06adbb0>] tcp_close+0x1d2/0x347
 [<c06c7106>] inet_release+0x4e/0x54
 [<c0677608>] sock_release+0x19/0x65
 [<c0677675>] sock_close+0x21/0x25
 [<c04a8e00>] __fput+0xd4/0x164
 [<c04a8eac>] fput+0x1c/0x1e
 [<c04a64c8>] filp_close+0x55/0x5f
 [<c04a654a>] sys_close+0x78/0xb2
 [<c0403b6b>] sysenter_do_call+0x12/0x3f
-- 
regards,
Dhaval
