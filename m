Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbYCMJmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbYCMJmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 05:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYCMJly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 05:41:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44735 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYCMJlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 05:41:53 -0400
Date: Thu, 13 Mar 2008 02:40:19 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, mingo@elte.hu,
       ego@in.ibm.com, hugh@veritas.com, dada1@cosmosbay.com
Subject: Re: [PATCH 2/2] lockdep: fix fib_hash softirq inversion
Message-ID: <20080313024019.6ee36721@laptopd505.fenrus.org>
In-Reply-To: <20080312.230843.114525346.davem@davemloft.net>
References: <20080312120920.929901000@chello.nl>
	<20080312121323.959513000@chello.nl>
	<20080312.230843.114525346.davem@davemloft.net>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 23:08:43 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed, 12 Mar 2008 13:09:22 +0100
> 
> > =========================================================
> > [ INFO: possible irq lock inversion dependency detected ]
> > 2.6.25-rc4-sched-devel.git #56
> > ---------------------------------------------------------
> > swapper/0 just changed the state of lock:
> >  (&rt_hash_locks[i]){-+..}, at: [<ffffffff804721ac>]
> > rt_intern_hash+0x8c/0x3b0 but this lock took another,
> > soft-read-irq-unsafe lock in the past: (fib_hash_lock){-.-?}
> > 
> > and interrupts could create inverse lock ordering between them.
> 
> I tried to figure out what lockdep doesn't like here.
> 
> Could you show me the specific code path that could cause
> the lock conflict?
> 
> Adding BH disabling to fib_hash_lock will add non-trivial
> costs to these code paths, so I'd like to avoid this if
> possible.

from what I can see the backtrace is the following:



Abstracted form of the deadlock:

There is a lock A that is used in process and irq context
There is a lock B that is used only in process context

There is a case where, in user context, lock A is taken (irqs off), and then lock B is taken,
and there a case where lock B is taken without disabling irqs.

This can lead to the following deadlock:

cpu 0                      cpu 1			note
..                         spin_lock_irq(lockA)
spin_lock(lockB)           ....
... interrupt hits ...     .....
spin_lock_irq(lockA)       .....                        in the irq handler; spins
...                        spin_lock(lockB)		AB-BA deadlock



This case:

for this case it's about BH's not strict irqs, but for all intents and purposes that's the same

lock A is rt_intern_hash
lock B is fib_hash_lock

previously, lockdep has observed that 
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
this call chain creates the relationship from cpu1 above (but at this point, lockdep doesn't know yet
that rt_intern_hash lock is ever taken in irq context, so it cannot complain yet)

And now lockdep is observing ip_rcv calling iproute_input calling rt_intern_hash from irq context,
 [<ffffffff804721ac>] rt_intern_hash+0x8c/0x3b0
 [<ffffffff80473a4e>] ip_route_input+0x8fe/0x1250
 [<ffffffff804769a8>] ip_rcv+0x518/0x650
 [<ffffffff8045a8f9>] netif_receive_skb+0x269/0x350
 [<ffffffff80405529>] e1000_clean_rx_irq+0x1a9/0x5a0
 [<ffffffff8040072b>] e1000_clean+0x1fb/0x5b0
 [<ffffffff8045d18f>] net_rx_action+0xbf/0x180
 [<ffffffff80255c55>] __do_softirq+0x75/0x100
 [<ffffffff8022173c>] call_softirq+0x1c/0x30
 [<ffffffff80223505>] do_softirq+0x65/0xa0
 [<ffffffff80255b67>] irq_exit+0x97/0xa0
 [<ffffffff80223618>] do_IRQ+0xa8/0x130
which creates the irq part of the relationship between lock A and lock B in the
scenario above, and lockdep complains that the abstracted deadlock scenario from
above now becomes real.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
