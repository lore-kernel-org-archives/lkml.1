Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbZCOGtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbZCOGtG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 02:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbZCOGsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 02:48:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39164 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbZCOGsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 02:48:51 -0400
Date: Sun, 15 Mar 2009 07:48:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: SLOB lockup (was: Re: [tip:core/locking] lockdep: annotate reclaim
	context (__GFP_NOFS), fix SLOB)
Message-ID: <20090315064818.GA1193@elte.hu>
References: <20090128135457.350751756@chello.nl> <tip-bf722c9d324864b4256edaa330751b77f2a19861@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-bf722c9d324864b4256edaa330751b77f2a19861@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Commit-ID:  bf722c9d324864b4256edaa330751b77f2a19861
> Gitweb:     http://git.kernel.org/tip/bf722c9d324864b4256edaa330751b77f2a19861
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Sun, 15 Mar 2009 06:03:11 +0100
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun, 15 Mar 2009 06:03:11 +0100
> 
> lockdep: annotate reclaim context (__GFP_NOFS), fix SLOB
> 
> Impact: build fix
> 
> fix typo in mm/slob.c:
> 
>  mm/slob.c:469: error: ‘flags’ undeclared (first use in this function)
>  mm/slob.c:469: error: (Each undeclared identifier is reported only once
>  mm/slob.c:469: error: for each function it appears in.)
> 
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <20090128135457.350751756@chello.nl>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

and with this fixed, and with SLOB now being tested in -tip, the 
new lockdep assert attached below (followed by a real lockup) 
pops up.

Seems like a genuine SLOB bug, probably present upstream as 
well.

	Ingo

--------------------------->

Remounting root filesystem in read-write mode:  [  137.292031] EXT3 FS on sda6, internal journal
[  OK  ]
[  137.324031] 
[  137.324031] =============================================
[  137.324031] [ INFO: possible recursive locking detected ]
[  137.324031] 2.6.29-rc8-tip #35362
[  137.324031] ---------------------------------------------
[  137.324031] rc.sysinit/5461 is trying to acquire lock:
[  137.324031]  (slob_lock){-.-.-.}, at: [<ffffffff8031d446>] slob_free+0x66/0x290
[  137.324031] 
[  137.324031] but task is already holding lock:
[  137.324031]  (slob_lock){-.-.-.}, at: [<ffffffff8031d446>] slob_free+0x66/0x290
[  137.324031] 
[  137.324031] other info that might help us debug this:
[  137.324031] 3 locks held by rc.sysinit/5461:
[  137.324031]  #0:  (&sb->s_type->i_mutex_key#6){+.+.+.}, at: [<ffffffff80320f0e>] do_truncate+0x5e/0x90
[  137.324031]  #1:  (&sb->s_type->i_alloc_sem_key#3){+.+...}, at: [<ffffffff80338815>] notify_change+0x245/0x320
[  137.324031]  #2:  (slob_lock){-.-.-.}, at: [<ffffffff8031d446>] slob_free+0x66/0x290
[  137.324031] 
[  137.324031] stack backtrace:
[  137.324031] Pid: 5461, comm: rc.sysinit Not tainted 2.6.29-rc8-tip #35362
[  137.324031] Call Trace:
[  137.324031]  <IRQ>  [<ffffffff802a24c0>] validate_chain+0xbd0/0x12c0
[  137.324031]  [<ffffffff802a1dc9>] ? validate_chain+0x4d9/0x12c0
[  137.324031]  [<ffffffff802a2f36>] __lock_acquire+0x386/0xb40
[  137.324031]  [<ffffffff802a378f>] lock_acquire+0x9f/0x140
[  137.324031]  [<ffffffff8031d446>] ? slob_free+0x66/0x290
[  137.324031]  [<ffffffff80f05553>] _spin_lock_irqsave+0x53/0x90
[  137.324031]  [<ffffffff8031d446>] ? slob_free+0x66/0x290
[  137.324031]  [<ffffffff8031d446>] slob_free+0x66/0x290
[  137.324031]  [<ffffffff8031d6a5>] __kmem_cache_free+0x35/0x40
[  137.324031]  [<ffffffff8031d6d4>] kmem_cache_free+0x24/0x70
[  137.324031]  [<ffffffff806b97ec>] free_object+0x6c/0xd0
[  137.324031]  [<ffffffff806b99e3>] __debug_check_no_obj_freed+0x193/0x1d0
[  137.324031]  [<ffffffff8029dcad>] ? trace_hardirqs_off+0xd/0x10
[  137.324031]  [<ffffffff806b9a37>] debug_check_no_obj_freed+0x17/0x20
[  137.324031]  [<ffffffff802f3619>] free_hot_cold_page+0x109/0x2b0
[  137.324031]  [<ffffffff802f3830>] free_hot_page+0x10/0x20
[  137.324031]  [<ffffffff802f3865>] __free_pages+0x25/0x40
[  137.324031]  [<ffffffff802f38cf>] free_pages+0x4f/0x60
[  137.324031]  [<ffffffff8031d530>] slob_free+0x150/0x290
[  137.324031]  [<ffffffff8031d6a5>] __kmem_cache_free+0x35/0x40
[  137.324031]  [<ffffffff8031d6d4>] kmem_cache_free+0x24/0x70
[  137.324031]  [<ffffffff80333765>] __d_free+0x45/0x70
[  137.324031]  [<ffffffff80333da5>] d_callback+0x15/0x20
[  137.324031]  [<ffffffff802cdd92>] rcu_process_callbacks+0x82/0xd0
[  137.324031]  [<ffffffff8027cfd2>] __do_softirq+0xa2/0x220
[  137.324031]  [<ffffffff8022f21c>] call_softirq+0x1c/0x30
[  137.324031]  [<ffffffff8023138a>] do_softirq+0x6a/0xb0
[  137.324031]  [<ffffffff8027ceb7>] irq_exit+0x97/0xa0
[  137.324031]  [<ffffffff80248104>] smp_apic_timer_interrupt+0x74/0xb0
[  137.324031]  [<ffffffff8022ec13>] apic_timer_interrupt+0x13/0x20
[  137.324031]  <EOI>  [<ffffffff802a37a4>] ? lock_acquire+0xb4/0x140
[  137.324031]  [<ffffffff80338815>] ? notify_change+0x245/0x320
[  137.324031]  [<ffffffff80f039b8>] ? down_write+0x48/0x80
[  137.324031]  [<ffffffff80338815>] ? notify_change+0x245/0x320
[  137.324031]  [<ffffffff806610e9>] ? cap_inode_setattr+0x9/0x10
[  137.324031]  [<ffffffff80338815>] ? notify_change+0x245/0x320
[  137.324031]  [<ffffffff80320f1a>] ? do_truncate+0x6a/0x90
[  137.324031]  [<ffffffff8026bcbe>] ? sub_preempt_count+0xae/0xf0
[  137.324031]  [<ffffffff80661209>] ? cap_path_truncate+0x9/0x10
[  137.324031]  [<ffffffff8032dc34>] ? may_open+0x224/0x2b0
[  137.324031]  [<ffffffff8032e18c>] ? do_filp_open+0x17c/0x980
[  137.324031]  [<ffffffff8029dd2e>] ? put_lock_stats+0xe/0x30
[  137.324031]  [<ffffffff8026bcbe>] ? sub_preempt_count+0xae/0xf0
[  137.324031]  [<ffffffff80339236>] ? alloc_fd+0x116/0x140
[  137.324031]  [<ffffffff803203a3>] ? do_sys_open+0x63/0xf0
[  137.324031]  [<ffffffff80320470>] ? sys_open+0x20/0x30
[  137.324031]  [<ffffffff8022dfbb>] ? system_call_fastpath+0x16/0x1b
[  137.324031] BUG: spinlock lockup on CPU#1, rcu_torture_rea/697, ffffffff813bf440
[  137.324031] Pid: 697, comm: rcu_torture_rea Not tainted 2.6.29-rc8-tip #35362
[  137.324031] Call Trace:
[  137.324031]  <IRQ>  [<ffffffff806a8ed9>] ? delay_loop+0x9/0x40
[  137.324031]  [<ffffffff806b91be>] _raw_spin_lock+0x17e/0x190
[  137.324031]  [<ffffffff80f05573>] _spin_lock_irqsave+0x73/0x90
[  137.324031]  [<ffffffff8031d878>] ? slob_alloc+0x58/0x200
[  137.324031]  [<ffffffff8031d878>] slob_alloc+0x58/0x200
[  137.324031]  [<ffffffff8031dcde>] kmem_cache_alloc_node+0xbe/0xf0
[  137.324031]  [<ffffffff80d0f74e>] __alloc_skb+0x4e/0x150
[  137.324031]  [<ffffffff80d0a677>] sock_alloc_send_skb+0x1a7/0x200
[  137.324031]  [<ffffffff802cdc70>] ? __rcu_read_unlock+0x20/0xc0
[  137.324031]  [<ffffffff80d71a57>] ip_append_data+0x6f7/0xa60
[  137.324031]  [<ffffffff80d95d20>] ? icmp_glue_bits+0x0/0x70
[  137.324031]  [<ffffffff80d95c68>] icmp_push_reply+0x58/0x110
[  137.324031]  [<ffffffff80d95f0f>] icmp_reply+0x17f/0x1e0
[  137.324031]  [<ffffffff80e8f74a>] ? csum_partial+0xa/0x180
[  137.324031]  [<ffffffff80d9642d>] icmp_echo+0x5d/0x60
[  137.324031] BUG: spinlock lockup on CPU#0, rc.sysinit/5461, ffffffff813bf440
[  137.324031] Pid: 5461, comm: rc.sysinit Not tainted 2.6.29-rc8-tip #35362
[  137.324031] Call Trace:
[  137.324031]  <IRQ>  [<ffffffff806a8ed9>] ? delay_loop+0x9/0x40
[  137.324031]  [<ffffffff806b91be>] _raw_spin_lock+0x17e/0x190
[  137.324031]  [<ffffffff80f05573>] _spin_lock_irqsave+0x73/0x90
[  137.324031]  [<ffffffff8031d446>] ? slob_free+0x66/0x290
[  137.324031]  [<ffffffff8031d446>] slob_free+0x66/0x290
[  137.324031]  [<ffffffff8031d6a5>] __kmem_cache_free+0x35/0x40
[  137.324031]  [<ffffffff8031d6d4>] kmem_cache_free+0x24/0x70
[  137.324031]  [<ffffffff806b97ec>] free_object+0x6c/0xd0
[  137.324031]  [<ffffffff806b99e3>] __debug_check_no_obj_freed+0x193/0x1d0
[  137.324031]  [<ffffffff8029dcad>] ? trace_hardirqs_off+0xd/0x10
[  137.324031]  [<ffffffff806b9a37>] debug_check_no_obj_freed+0x17/0x20
[  137.324031]  [<ffffffff802f3619>] free_hot_cold_page+0x109/0x2b0
[  137.324031]  [<ffffffff802f3830>] free_hot_page+0x10/0x20
[  137.324031]  [<ffffffff802f3865>] __free_pages+0x25/0x40
[  137.324031]  [<ffffffff802f38cf>] free_pages+0x4f/0x60
[  137.324031]  [<ffffffff8031d530>] slob_free+0x150/0x290
[  137.324031]  [<ffffffff8031d6a5>] __kmem_cache_free+0x35/0x40
[  137.324031]  [<ffffffff8031d6d4>] kmem_cache_free+0x24/0x70
[  137.324031]  [<ffffffff80333765>] __d_free+0x45/0x70
[  137.324031]  [<ffffffff80333da5>] d_callback+0x15/0x20
[  137.324031]  [<ffffffff802cdd92>] rcu_process_callbacks+0x82/0xd0
[  137.324031]  [<ffffffff8027cfd2>] __do_softirq+0xa2/0x220
[  137.324031]  [<ffffffff8022f21c>] call_softirq+0x1c/0x30
[  137.324031]  [<ffffffff8023138a>] do_softirq+0x6a/0xb0
[  137.324031]  [<ffffffff8027ceb7>] irq_exit+0x97/0xa0
[  137.324031]  [<ffffffff80248104>] smp_apic_timer_interrupt+0x74/0xb0
[  137.324031]  [<ffffffff8022ec13>] apic_timer_interrupt+0x13/0x20
[  137.324031]  <EOI>  [<ffffffff802a37a4>] ? lock_acquire+0xb4/0x140
[  137.324031]  [<ffffffff80338815>] ? notify_change+0x245/0x320
[  137.324031]  [<ffffffff80f039b8>] ? down_write+0x48/0x80
[  137.324031]  [<ffffffff80338815>] ? notify_change+0x245/0x320
[  137.324031]  [<ffffffff806610e9>] ? cap_inode_setattr+0x9/0x10
[  137.324031]  [<ffffffff80338815>] ? notify_change+0x245/0x320
[  137.324031]  [<ffffffff80320f1a>] ? do_truncate+0x6a/0x90
[  137.324031]  [<ffffffff8026bcbe>] ? sub_preempt_count+0xae/0xf0
[  137.324031]  [<ffffffff80661209>] ? cap_path_truncate+0x9/0x10
[  137.324031]  [<ffffffff8032dc34>] ? may_open+0x224/0x2b0
[  137.324031]  [<ffffffff8032e18c>] ? do_filp_open+0x17c/0x980
[  137.324031]  [<ffffffff8029dd2e>] ? put_lock_stats+0xe/0x30
[  137.324031]  [<ffffffff8026bcbe>] ? sub_preempt_count+0xae/0xf0
[  137.324031]  [<ffffffff80339236>] ? alloc_fd+0x116/0x140
[  137.324031]  [<ffffffff803203a3>] ? do_sys_open+0x63/0xf0
[  137.324031]  [<ffffffff80320470>] ? sys_open+0x20/0x30
[  137.324031]  [<ffffffff8022dfbb>] ? system_call_fastpath+0x16/0x1b
[  137.324031]  [<ffffffff80d11c9b>] ? __skb_checksum_complete_head+0x1b/0x70
[  137.324031]  [<ffffffff80d11d01>] ? __skb_checksum_complete+0x11/0x20
[  137.324031]  [<ffffffff80d960a2>] icmp_rcv+0x132/0x2e0
[  137.324031]  [<ffffffff80d6e526>] ip_local_deliver_finish+0x76/0x1e0
[  137.324031]  [<ffffffff80d6eb30>] ip_local_deliver+0x40/0xa0
[  137.324031]  [<ffffffff80d6e219>] ip_rcv_finish+0x129/0x3c0
[  137.324031]  [<ffffffff80d6ea0c>] ip_rcv+0x23c/0x320
[  137.324031]  [<ffffffff80d16c9c>] netif_receive_skb+0x2dc/0x540
[  137.324031]  [<ffffffff808f3efd>] nv_napi_poll+0x3cd/0x6c0
[  137.324031]  [<ffffffff80d19d5e>] net_rx_action+0x13e/0x210
[  137.324031]  [<ffffffff8024a071>] ? irq_complete_move+0x21/0x240
[  137.324031]  [<ffffffff8027cfd2>] __do_softirq+0xa2/0x220
[  137.324031]  [<ffffffff8022f21c>] call_softirq+0x1c/0x30
[  137.324031]  [<ffffffff8023138a>] do_softirq+0x6a/0xb0
[  137.324031]  [<ffffffff8027ceb7>] irq_exit+0x97/0xa0
[  137.324031]  [<ffffffff802306a5>] do_IRQ+0x95/0x110
[  137.324031]  [<ffffffff8022ea13>] ret_from_intr+0x0/0xf
[  137.324031]  <EOI>  [<ffffffff80f05a26>] ? _spin_unlock_irq+0x36/0x60
[  137.324031]  [<ffffffff80f0186d>] ? thread_return+0x1e3/0x916
[  137.324031]  [<ffffffff8022eac0>] ? restore_args+0x0/0x30
[  137.324031]  [<ffffffff802cbff8>] ? rcu_torture_reader+0x188/0x2e0
[  137.324031]  [<ffffffff8029fc9d>] ? trace_hardirqs_on+0xd/0x10
[  137.324031]  [<ffffffff802cbff8>] ? rcu_torture_reader+0x188/0x2e0
[  137.324031]  [<ffffffff802cc9a0>] ? rcu_torture_timer+0x0/0x150
[  137.324031]  [<ffffffff80f059b7>] ? _spin_unlock_irqrestore+0x47/0x80
[  137.324031]  [<ffffffff802cbe70>] ? rcu_torture_reader+0x0/0x2e0
[  137.324031]  [<ffffffff8028e213>] ? kthread+0x53/0x80
[  137.324031]  [<ffffffff8022f11a>] ? child_rip+0xa/0x20
[  137.324031]  [<ffffffff8026bb68>] ? finish_task_switch+0x98/0x140
[  137.324031]  [<ffffffff80f05a2b>] ? _spin_unlock_irq+0x3b/0x60
[  137.324031]  [<ffffffff8022eac0>] ? restore_args+0x0/0x30
[  137.324031]  [<ffffffff8028e1c0>] ? kthread+0x0/0x80
[  137.324031]  [<ffffffff8022f110>] ? child_rip+0x0/0x20

