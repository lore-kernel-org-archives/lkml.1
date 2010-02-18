Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0BRSbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:31:42 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48932 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab0BRSbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:31:40 -0500
Date: Thu, 18 Feb 2010 13:33:23 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: add_timer_on: in-kernel users _all_ buggy ?
Message-ID: <20100218183323.GB16827@shamino.rdu.redhat.com>
References: <20100218142800.GB5825@Krystal>
 <20100218162128.GA16827@shamino.rdu.redhat.com>
 <20100218164118.GA12136@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100218164118.GA12136@Krystal>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -3.9 (---)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 11:41:18AM -0500, Mathieu Desnoyers wrote:
> * Neil Horman (nhorman@tuxdriver.com) wrote:
> > On Thu, Feb 18, 2010 at 09:28:00AM -0500, Mathieu Desnoyers wrote:
> > > * Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> > > > * Thomas Gleixner (tglx@linutronix.de) wrote:
> > > > > On Tue, 16 Feb 2010, Mathieu Desnoyers wrote:
> > > > > > > The function is called from an IPI. That's a LTTNG problem, not a RT one.
> > > > > > 
> > > > > > I use del_timer in IPI to delete lttng per-cpu timers on all CPUs. I
> > > > > > have to do this because timers created with add_timer_on are documented
> > > > > > to be incompatible with del_timer_sync():
> > > > > > 
> > > > > >  * Synchronization rules: Callers must prevent restarting of the timer,
> > > > > >  * otherwise this function is meaningless. It must not be called from
> > > > > >  * interrupt contexts. The caller must not hold locks which would prevent
> > > > > >  * completion of the timer's handler. The timer's handler must not call
> > > > > >  * add_timer_on(). Upon exit the timer is not queued and the handler is
> > > > > >  * not running on any CPU.
> > > > > 
> > > > > Errm. The documentation says: 
> > > > > 
> > > > >       "The timer's handler must not call add_timer_on()." 
> > > > > 
> > > > > It's not talking about a timer which was initialized with
> > > > > add_timer_on().
> > > > > 
> > > > >  And your per cpu timer handlers have no requirement to call
> > > > > add_timer_on() simply because add/mod_timer() is requeueing the timer
> > > > > on the same cpu on which the handler runs. 
> > > > > 
> > > > > So the IPI is just a solution for a non existing problem.
> > > > 
> > > > Oh, right. Thanks for the explanation. I'll look into moving LTTng to a
> > > > saner del_timer_sync() scheme to delete the timers.
> > > 
> > > Double-checking this:
> > > 
> > > add_timer_on() needs to be paired with mod_timer_pinned(), otherwise
> > > NO_HZ SMP config can rebalance the timer to a different CPU. I am fixing
> > > this in lttng 0.194. These per-cpu timers, of course, should usually be
> > > deferrable (they are in lttng).
> > > 
> > > (looking at kernel 2.6.32.4 here)
> > > Looking at the kernel/time/clocksource.c watchdog, I wonder how
> > > del_timer manages to synchronize the timer teardown. The handler,
> > > clocksource_watchdog(), uses add_timer_on(), which prohibits using
> > > del_timer_sync(). This seems rather odd. If we remove the watchdog and
> > > re-add it, it may still be in use while we initialize the timer
> > > structure.
> > > 
> > > Also, net/core/drop_monitor.c trace_drop_common usage of add_timer_on
> > > seems odd:
> > > 
> > > Executing (AFAIK) with preempt on, data points to a per-cpu timer:
> > > 
> > >        if (!timer_pending(&data->send_timer)) {
> > >                 data->send_timer.expires = jiffies + dm_delay * HZ;
> > >                 add_timer_on(&data->send_timer, smp_processor_id());
> > >        }
> > > 
> > > How is timer_pending synchronized with the target CPU timer wheel ?
> > > 
> > Hm, I think I see your point here.  You're suggesting that a call to one of the
> > tracepoint hooks in the drop monitor can race against a second call to the hook
> > from an interrupt context that pre-empted the first, leading to double add of
> > the timer?
> 
> Yes.
> 
> > I agree, in fact I think its likely worse that that, the shared data
> > on the skb that I modify there can get corrupted in that case as well.  I expect
> > a bit of refactoring paired with a local_irq_save/restore should fix that.
> 
> For this current code, you don't seem to need to delete the timer. I think
> you'll have to find a way to do the timer_pending check and the add_timer_on
> operations atomically wrt timer wheel execution on the CPU (which can be a
> remote cpu because preemption is enabled). Your case is a bit weird..  the
> typical scenario here would be to use add_timer_on directly to re-arm the timer
> for a future expiration time (removing the current pending timer
> unconditionnally at the same time). But you leave the timer at its current
> expiration time if present, and only if not present add it. I wonder if it's
> really your intent ?
> 

Yes, thats my intent.  The idea is that when I note a packet is lost, I record
that in a data buffer that is part of an skb, and schedule a timer to send that
skb a second or so later.  Other drops in that time frame are recorded within
the same skb.  Since the drop monitor isn't built as a module currently, I don't
need to worry about deleting the timer at all, I can just let it expire.

Sounds like I need to wrap up the data extract and time modifications in a
prempt_disable/enable and local_irq_save/restore set
Neil

> Thanks,
> 
> Mathieu
> 
> 
