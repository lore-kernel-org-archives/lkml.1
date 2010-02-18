Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab0BROdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 09:33:12 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:40161 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753535Ab0BROdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 09:33:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGvefEtGGOLY/2dsb2JhbACbB3W+QYRnBIMVGoJe
Date: Thu, 18 Feb 2010 09:28:00 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, ltt-dev@lists.casi.polymtl.ca,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Neil Horman <nhorman@tuxdriver.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: add_timer_on: in-kernel users _all_ buggy ?
Message-ID: <20100218142800.GB5825@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:52:33 up 63 days, 22:11,  4 users,  load average: 0.11, 0.18,
	0.12
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> * Thomas Gleixner (tglx@linutronix.de) wrote:
> > On Tue, 16 Feb 2010, Mathieu Desnoyers wrote:
> > > > The function is called from an IPI. That's a LTTNG problem, not a RT one.
> > > 
> > > I use del_timer in IPI to delete lttng per-cpu timers on all CPUs. I
> > > have to do this because timers created with add_timer_on are documented
> > > to be incompatible with del_timer_sync():
> > > 
> > >  * Synchronization rules: Callers must prevent restarting of the timer,
> > >  * otherwise this function is meaningless. It must not be called from
> > >  * interrupt contexts. The caller must not hold locks which would prevent
> > >  * completion of the timer's handler. The timer's handler must not call
> > >  * add_timer_on(). Upon exit the timer is not queued and the handler is
> > >  * not running on any CPU.
> > 
> > Errm. The documentation says: 
> > 
> >       "The timer's handler must not call add_timer_on()." 
> > 
> > It's not talking about a timer which was initialized with
> > add_timer_on().
> > 
> >  And your per cpu timer handlers have no requirement to call
> > add_timer_on() simply because add/mod_timer() is requeueing the timer
> > on the same cpu on which the handler runs. 
> > 
> > So the IPI is just a solution for a non existing problem.
> 
> Oh, right. Thanks for the explanation. I'll look into moving LTTng to a
> saner del_timer_sync() scheme to delete the timers.

Double-checking this:

add_timer_on() needs to be paired with mod_timer_pinned(), otherwise
NO_HZ SMP config can rebalance the timer to a different CPU. I am fixing
this in lttng 0.194. These per-cpu timers, of course, should usually be
deferrable (they are in lttng).

(looking at kernel 2.6.32.4 here)
Looking at the kernel/time/clocksource.c watchdog, I wonder how
del_timer manages to synchronize the timer teardown. The handler,
clocksource_watchdog(), uses add_timer_on(), which prohibits using
del_timer_sync(). This seems rather odd. If we remove the watchdog and
re-add it, it may still be in use while we initialize the timer
structure.

Also, net/core/drop_monitor.c trace_drop_common usage of add_timer_on
seems odd:

Executing (AFAIK) with preempt on, data points to a per-cpu timer:

       if (!timer_pending(&data->send_timer)) {
                data->send_timer.expires = jiffies + dm_delay * HZ;
                add_timer_on(&data->send_timer, smp_processor_id());
       }

How is timer_pending synchronized with the target CPU timer wheel ?

Wait, there's more: arch/x86/kernel/cpu/mcheck/mce.c uses both
add_timer_on in its handler and del_timer_sync (which is incorrect).

arch/x86/kernel/apic/x2apic_uv_x.c almost has it right, but maybe it
should use del_timer_sync ?

arch/powerpc/platforms/chrp/setup.c should learn about
mod_timer_pinned().

Which leads to the following question: is there _any_ add_timer_on()
kernel user that's not currently buggy ? ;-) Maybe this calls for better
documentation of this interface. From what I've learn from digging into
cpufreq to debug its incorrect timer teardown last year, I fear there
are lots and lots of buggy per-cpu _and_ standard timer interface users
out there.

Maybe adding some debugging options, e.g. checking that a timer created
with add_timer_on is always modified by mod_timer_pinned, and is always
deferrable, and deleted by del_timer_sync could help discovering a
couple of outlawyer.

Thanks,

Mathieu


> 
> Thanks,
> 
> Mathieu
> 
> > 
> > Thanks,
> > 
> > 	tglx
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
