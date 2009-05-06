Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbZEFOCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbZEFOCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbZEFOCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:02:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61934 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbZEFOCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:02:08 -0400
Date: Wed, 6 May 2009 10:02:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 11/11] ring-buffer: add benchmark and tester
In-Reply-To: <20090506085354.GA21680@elte.hu>
Message-ID: <alpine.DEB.2.00.0905061000020.3239@gandalf.stny.rr.com>
References: <20090506042101.231470089@goodmis.org> <20090506042335.131774566@goodmis.org> <20090506085354.GA21680@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 May 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > This patch adds code that can benchmark the ring buffer as well as 
> > test it. This code can be compiled into the kernel (not 
> > recommended) or as a module.
> 
> > [ Impact: see how changes to the ring buffer affect stability and performance ]
> 
> This triggered this lockdep assert:
> 
> [   43.242660] eth1: link down
> [   43.244570] ADDRCONF(NETDEV_UP): eth1: link is not ready
> [   43.339828] eth0: no link during initialization.
> [   43.344562] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   44.036177] Starting ring buffer hammer
> [   45.856513] 
> [   45.856513] =================================
> [   45.862366] [ INFO: inconsistent lock state ]
> [   45.866737] 2.6.30-rc4-tip-01596-g844be76-dirty #38989
> [   45.871872] ---------------------------------
> [   45.876234] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> [   45.882247] rb_consumer/519 [HC1[1]:SC0[0]:HE0:SE1] takes:
> [   45.887750]  (net/core/link_watch.c:36){?.-...}, at: [<ffffffff8044fb31>] del_timer_sync+0x0/0x88
> [   45.896691] {HARDIRQ-ON-W} state was registered at:
> [   45.901572]   [<ffffffffffffffff>] 0xffffffffffffffff
> [   45.906673] irq event stamp: 26933632
> [   45.910330] hardirqs last  enabled at (26933631): [<ffffffff80df7691>] _spin_unlock_irqrestore+0x44/0x4c
> [   45.919827] hardirqs last disabled at (26933632): [<ffffffff8040b0b7>] save_args+0x67/0x70
> [   45.928141] softirqs last  enabled at (26924896): [<ffffffff8044b9c3>] __do_softirq+0x17d/0x189
> [   45.936898] softirqs last disabled at (26924889): [<ffffffff8040c47c>] call_softirq+0x1c/0x28

Interesting,

The module does not disable interrupts nor does it grab any spin locks. 
Could be something inside the ring buffer??

> [   45.945459] 
> [   45.945459] other info that might help us debug this:
> [   45.952008] 1 lock held by rb_consumer/519:
> [   45.956193]  #0:  (&np->lock){-.....}, at: [<ffffffff809a07c4>] nv_nic_irq_optimized+0x192/0x28b
> [   45.965062] 
> [   45.965062] stack backtrace:
> [   45.969427] Pid: 519, comm: rb_consumer Not tainted 2.6.30-rc4-tip-01596-g844be76-dirty #38989
> [   45.978057] Call Trace:
> [   45.980512]  <IRQ>  [<ffffffff80467583>] print_usage_bug+0x156/0x167
> [   45.986885]  [<ffffffff804675d9>] valid_state+0x45/0x52
> [   45.992138]  [<ffffffff80467f23>] ? check_usage_forwards+0x0/0x55
> [   45.998249]  [<ffffffff8046762f>] mark_lock_irq+0x49/0xee
> [   46.003652]  [<ffffffff804677a7>] mark_lock+0xd3/0x139
> [   46.008803]  [<ffffffff80467861>] mark_irqflags+0x54/0x125
> [   46.014303]  [<ffffffff80468e26>] __lock_acquire+0x187/0x2fe
> [   46.019961]  [<ffffffff8046905e>] lock_acquire+0xc1/0xe5
> [   46.025278]  [<ffffffff8044fb31>] ? del_timer_sync+0x0/0x88
> [   46.030864]  [<ffffffff8044fb72>] del_timer_sync+0x41/0x88
> [   46.036346]  [<ffffffff8044fb31>] ? del_timer_sync+0x0/0x88
> [   46.041949]  [<ffffffff80c0ea2e>] linkwatch_schedule_work+0x82/0xa0
> [   46.048207]  [<ffffffff80c0eafa>] linkwatch_fire_event+0xae/0xb3
> [   46.054213]  [<ffffffff80c24211>] netif_carrier_on+0x2e/0x40
> [   46.059868]  [<ffffffff8099fa63>] nv_linkchange+0x2a/0x6f
> [   46.065276]  [<ffffffff8099fad1>] nv_link_irq+0x29/0x2b
> [   46.070508]  [<ffffffff809a07cc>] nv_nic_irq_optimized+0x19a/0x28b
> [   46.076690]  [<ffffffff804807be>] handle_IRQ_event+0x59/0x132
> [   46.082436]  [<ffffffff804824a8>] handle_fasteoi_irq+0x90/0xd0
> [   46.088296]  [<ffffffff8040df2a>] handle_irq+0x24/0x2e
> [   46.093436]  [<ffffffff8040d661>] do_IRQ+0x5f/0xbf
> [   46.098228]  [<ffffffff8040bc93>] ret_from_intr+0x0/0xf
> [   46.103468]  <EOI>  [<ffffffff804890ac>] ? ring_buffer_consume+0x6d/0xc3
> [   46.110196]  [<ffffffff80df7694>] ? _spin_unlock_irqrestore+0x47/0x4c
> [   46.116621]  [<ffffffff804890db>] ? ring_buffer_consume+0x9c/0xc3
> [   46.122728]  [<ffffffff8048ab18>] ? ring_buffer_consumer+0x52/0x161
> [   46.129003]  [<ffffffff8048ac27>] ? ring_buffer_consumer_thread+0x0/0x8d
> [   46.135707]  [<ffffffff8048ac48>] ? ring_buffer_consumer_thread+0x21/0x8d
> [   46.142489]  [<ffffffff80459ee4>] ? kthread+0x5b/0x88
> [   46.147550]  [<ffffffff8040c37a>] ? child_rip+0xa/0x20
> [   46.152703]  [<ffffffff8043fb2f>] ? finish_task_switch+0x40/0xf4
> [   46.158698]  [<ffffffff8040bd3c>] ? restore_args+0x0/0x30
> [   46.164095]  [<ffffffff80459e89>] ? kthread+0x0/0x88
> [   46.169066]  [<ffffffff8040c370>] ? child_rip+0x0/0x20
> [   46.174218] eth0: link up.
> [   53.664036] End ring buffer hammer
> [   53.701419] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   53.712283] Mapped at:
> [   53.714462]  [<ffffffffffffffff>] 0xffffffffffffffff
> [   53.725779] IPv4 FIB: Using LC-trie version 0.408
> 
> Config attached.

I'll try it out.

-- Steve

