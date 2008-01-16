Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYAPDWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYAPDWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 22:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755868AbYAPDWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 22:22:35 -0500
Received: from tomts22.bellnexxia.net ([209.226.175.184]:49607 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754436AbYAPDWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 22:22:34 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAOoGjUdMROHU/2dsb2JhbACBWKs4
Date: Tue, 15 Jan 2008 22:17:30 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
Message-ID: <20080116031730.GA2164@Krystal>
References: <20080109232914.676624725@goodmis.org> <20080109233044.777564395@goodmis.org> <20080115214636.GD17439@Krystal> <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com> <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:01:53 up 73 days,  8:07,  3 users,  load average: 1.46, 1.62,
	1.10
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Tue, 15 Jan 2008, Mathieu Desnoyers wrote:
> >
> > Ok, but what actually insures that the clock->cycle_* reads won't be
> > reordered across the clocksource_read() ?
> 
> <looks at code>
> 
> Hmm, interesting.I didn't notice that clocksource_read() is a static
> inline.  I was thinking that since it was passing a pointer to a function,
> gcc could not assume that it could move that code across it. But now
> looking to see that clocksource_read is simply a static inline that does:
> 
>   cs->read();
> 
> But still, can gcc assume that it can push loads of unknown origin
> variables across function calls? So something like:
> 
> static int *glob;
> 
> void foo(void) {
> 	int x;
> 
> 	x = *glob;
> 
> 	bar();
> 
> 	if (x != *glob)
> 		/* ... */
> }
> 
> I can't see how any compiler could honestly move the loading of the first
> x after the calling of bar(). With glob pointing to some unknown
> variable, that may be perfectly fine for bar to modify.
> 
> 
> > > >
> > > > > +		cycle_raw = clock->cycle_raw;
> > > > > +		cycle_last = clock->cycle_last;
> > > > > +
> > > > > +		/* read clocksource: */
> > > > > +		cycle_now = clocksource_read(clock);
> 
> So the question here is,can cycle_raw and cycle_last be loaded from
> the unknown source that clock points to after the call to
> clocksource_read()?
> 
>  I'm thinking not.
> 

I agree with you that I don't see how the compiler could reorder this.
So we forget about compiler barriers. Also, the clock source used is a
synchronized clock source (get_cycles_sync on x86_64), so it should make
sure the TSC is read at the right moment.

However, what happens if the clock source is, say, the jiffies ?

Is this case, we have :

static cycle_t jiffies_read(void)
{
        return (cycle_t) jiffies;
}

Which is nothing more than a memory read of 

extern unsigned long volatile __jiffy_data jiffies;

I think it is wrong to assume that reads from clock->cycle_raw and from
jiffies will be ordered correctly in SMP. I am tempted to think that
ordering memory writes to clock->cycle_raw vs jiffies is also needed in this
case (where clock->cycle_raw is updated, or where jiffies is updated).

We can fall in the same kind of issue if we read the HPET, which is
memory I/O based. It does not seems correct to assume that MMIO vs
normal memory reads are ordered. (pointing back to this article :
http://lwn.net/Articles/198988/)

Mathieu


> > > > > +
> > > > > +		/* calculate the delta since the last update_wall_time: */
> > > > > +		cycle_delta = (cycle_now - cycle_last) & clock->mask;
> > > > > +
> > > > > +	} while (cycle_raw != clock->cycle_raw ||
> > > > > +		 cycle_last != clock->cycle_last);
> > > > > +
> > > > > +	return cycle_raw + cycle_delta;
> > > > > +}
> 
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
