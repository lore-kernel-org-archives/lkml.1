Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907Ab0BYVgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:36:41 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37557 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933759Ab0BYVgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:36:38 -0500
Date: Thu, 25 Feb 2010 13:36:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/21] v6 add lockdep-based diagnostics to
	rcu_dereference()
Message-ID: <20100225213633.GA5936@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100223010435.GA666@linux.vnet.ibm.com> <20100225100022.GA25261@elte.hu> <20100225100147.GA28060@elte.hu> <20100225120444.GA17623@elte.hu> <20100225181830.GC6771@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225181830.GC6771@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 10:18:30AM -0800, Paul E. McKenney wrote:
> On Thu, Feb 25, 2010 at 01:04:44PM +0100, Ingo Molnar wrote:
> > 
> > another, different warning is:
> > 
> > PM: Adding info for No Bus:vcsa6
> > ------------[ cut here ]------------
> > WARNING: at kernel/softirq.c:143 local_bh_enable_ip+0xba/0xf0()
> > Hardware name: System Product Name
> > Modules linked in:
> > Pid: 0, comm: swapper Not tainted 2.6.33-tip-00730-gacec70d-dirty #18737
> > Call Trace:
> >  [<ffffffff8104e0eb>] warn_slowpath_common+0x7b/0xc0
> >  [<ffffffff8166cd60>] ? __dst_free+0x60/0xd0
> >  [<ffffffff8104e144>] warn_slowpath_null+0x14/0x20
> >  [<ffffffff81055c7a>] local_bh_enable_ip+0xba/0xf0
> >  [<ffffffff817c16d9>] _raw_spin_unlock_bh+0x19/0x20
> >  [<ffffffff8166cd60>] __dst_free+0x60/0xd0
> >  [<ffffffff8169de14>] dst_rcu_free+0x34/0x40
> >  [<ffffffff8109c80d>] rcu_do_batch+0xcd/0x290
> >  [<ffffffff8109ca3e>] __rcu_process_callbacks+0x6e/0xe0
> >  [<ffffffff8109cbca>] rcu_needs_cpu+0x11a/0x170
> >  [<ffffffff8107c14e>] tick_nohz_stop_sched_tick+0x15e/0x440
> >  [<ffffffff81001dc9>] cpu_idle+0x79/0x120
> >  [<ffffffff817bb627>] start_secondary+0xa0/0xa2
> > ---[ end trace 155c62ea9b561096 ]---
> > 
> > Config attached.
> 
> Color me confused!
> 
> rcu_needs_cpu() is supposed to be called with irqs disabled, and
> tick_nohz_stop_sched_tick() does in fact disable them with
> local_irq_save() near the beginning of the function.  Doing a quick
> inspection, starting at that point in tick_nohz_stop_sched_tick():
> 
> o	smp_processor_id() does not mess with irq, nor does per_cpu().
> 
> o	tick_nohz_start_idle() calls a bunch of things.
> 	sched_clock_cpu() checks for irqs being disabled, but
> 	only if CONFIG_HAVE_UNSTABLE_SCHED_CLOCK.  Which you have
> 	set.  So we know irqs remained disabled at this point.
> 	
> 	And I don't see anything re-enabling irqs in the subsequent
> 	code path in this function.
> 
> o	need_resched() just checks the TIF_NEED_RESCHED flag.
> 
> o	Neither local_softirq_pending() and cpu_online() mess
> 	with irq enabling.
> 
> o	The code path containing the printk() was apparently not
> 	taken, as there is no message in your log.
> 
> o	read_seqbegin() and read_seqretry() leave irqs alone, as
> 	does timekeeping_max_deferment().
> 
> And that puts us at the call to rcu_needs_cpu().  You have the
> new CONFIG_RCU_FAST_NO_HZ config variable set, and are not running
> preemptible RCU, so we are in the one at line 993 of rcutree_plugin.c.
> The fact that __rcu_process_callbacks() is on the stack means that all
> other CPUs were in dyntick-idle mode, so we went through the loop.
> 
> o	rcu_sched_qs() doesn't mess with irqs.
> 
> o	force_quiescent_state() does mess with irqs, but puts them
> 	back the way it found them.
> 
> o	Ditto for __rcu_process_callbacks().
> 
> So I am reduced to putting together a diagnostic patch for you.  :-/

-EICANTREAD

Commit 8bd93a2c ("Accelerate grace period...") is busted.  I will work
out how to fix it.

							Thanx, Paul
