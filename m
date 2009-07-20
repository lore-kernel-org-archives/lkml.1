Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbZGTMZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbZGTMZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 08:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZGTMZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 08:25:31 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42019 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbZGTMZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 08:25:30 -0400
Date: Mon, 20 Jul 2009 05:22:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, john stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@tglx.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       nikolag@ca.ibm.com, Darren Hart <dvhltc@us.ibm.com>,
       jatriple@us.ibm.com
Subject: Re: [RFC][PATCH] Introduce CLOCK_REALTIME_COARSE
Message-ID: <20090720122207.GB6944@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1247873945.8334.67.camel@localhost.localdomain> <alpine.LFD.2.00.0907181027510.11571@localhost.localdomain> <1247954978.14494.19.camel@work-vm> <20090718153011.1de3af8e@infradead.org> <1248088622.15751.8465.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248088622.15751.8465.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 01:17:02PM +0200, Peter Zijlstra wrote:
> On Sat, 2009-07-18 at 15:30 -0700, Arjan van de Ven wrote:
> > On Sat, 18 Jul 2009 15:09:38 -0700
> > john stultz <johnstul@us.ibm.com> wrote:
> > 
> > > After talking with some application writers who want very fast, but
> > > not fine-grained timestamps, I decided to try to implement a new
> > > clock_ids to clock_gettime(): CLOCK_REALTIME_COARSE and
> > > CLOCK_MONOTONIC_COARSE which returns the time at the last tick. This
> > > is very fast as we don't have to access any hardware (which can be
> > > very painful if you're using something like the acpi_pm clocksource),
> > > and we can even use the vdso clock_gettime() method to avoid the
> > > syscall. The only trade off is you only get low-res tick grained time
> > > resolution.
> > 
> > Does this tie us to having a tick? I still have hope that we can get
> > rid of the tick even when apps are running .... since with CFS we don't
> > really need the tick for the scheduler anymore for example....
> 
> On the hardware side to make this happen we'd need a platform that has:
> 
>   - cheap, high-res, cross-cpu synced, clocksource
>   - cheap, high-res, clockevents
> 
> Maybe power64, sparc64 and s390x qualify, but certainly nothing on x86
> does.
> 
> Furthermore, on the software side we'd need a few modifications, such as
> doing lazy accounting for things like u/s-time which currently rely on
> the tick and moving the load-balancing into a hrtimer.
> 
> Also, even with the above done, we'd probably want to tinker with the
> clockevent/hrtimer code and possibly use a second per-cpu hardware timer
> for the scheduler, since doing the whole hrtimer rb-tree dance for every
> context switch is simply way too expensive.
> 
> But even with all that manged, there's still other bits that rely on the
> tick -- RCU being one of the more interesting ones.

On alternative to the tick is to inform RCU of each transition to/from
userspace, so that RCU would treat user-mode execution as it currently
does dyntick-idle state.  If there is -never- to be any scheduling-clock
interrupts, then RCU would need to also know about transitions to/from
the idle loop -- which happens automatically if CONFIG_NO_HZ, of course.

But I expect that there would be some additional excitement elsewhere...
And given the large number of transitions to/from userspace, getting all
of them noted in the RCU case might be non-trivial as well.

							Thanx, Paul
