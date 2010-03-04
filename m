Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab0CDPmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:42:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33160 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895Ab0CDPmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:42:43 -0500
Date: Thu, 4 Mar 2010 16:36:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace events
Message-ID: <20100304153606.GA32496@elte.hu>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
 <1267599302-2886-3-git-send-regression-fweisbec@gmail.com>
 <1267632387.10871.59.camel@gandalf.stny.rr.com>
 <1267634258.25158.88.camel@laptop>
 <1267636046.10871.74.camel@gandalf.stny.rr.com>
 <1267636595.25158.93.camel@laptop>
 <20100304112531.GF21977@elte.hu>
 <1267715801.10871.191.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267715801.10871.191.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2010-03-04 at 12:25 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Wed, 2010-03-03 at 12:07 -0500, Steven Rostedt wrote:
> > > > oops, my bad :-), I thought this was in the x86 arch directory. For the
> > > > University, I was helping them with adding trace points for page faults
> > > > when I came across this in arch/x86/mm/fault.c:
> > > > 
> > > >         perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, 0, regs, address);
> > > > 
> > > > 
> > > > This is what I actually was wondering about. Why is it a "perf only" trace 
> > > > point instead of a TRACE_EVENT()?
> > > 
> > > Because I wanted to make perf usable without having to rely on funny 
> > > tracepoints. That is, I am less worried about committing software counters 
> > > to ABI than I am about TRACE_EVENT(), which still gives me a terribly 
> > > uncomfortable feeling.
> > 
> > I'd still like a much less error-prone and work-intense way of doing it.
> > 
> > I'd suggest we simply add a TRACE_EVENT_ABI() for such cases, where we 
> > really want to expose a tracepoint to tooling, programmatically. Maybe 
> > even change the usage sites to trace_foo_ABI(), to make it really clear 
> > and to make people aware of the consequences.
> 
> Would this still be available as a normal trace event?

Yeah, of course. It would not result in any usage or flexibility restriction.

( In the future we might want to add some sort of automated signature thing to 
  make sure that an event that has been declared an 'ABI' isnt changed - at 
  least as far as the record format goes. )

> > 
> > > Also, building with all CONFIG_TRACE_*=n will still yield a usable perf, 
> > > which is something the embedded people might fancy, all that TRACE stuff 
> > > adds lots of code.
> > 
> > Not a real issue i suspect when you do lock profiling ...
> > 
> > Or if it is, some debloating might be in order - and the detaching of event 
> > enumeration and ftrace TRACE_EVENT infrastructure from other ftrace bits. (i 
> > suggested an '/eventfs' special filesystem before, for nicely layed out 
> > hierarchy of ftrace/perf events.)
> 
> Actually, we already have a way to decouple it.
> 
> include/trace/define_trace.h is the file that just adds the tracepoint
> that is needed.
> 
> include/trace/ftrace.h is the file that does the magic and adds the code
> for callbacks and tracing.
> 
> The perf hooks probably should not have gone in that file and been put
> into a include/trace/perf.h file, and then in define_trace.h we would
> add:
> 
>  #ifdef CONFIG_EVENT_TRACING
>  #include <trace/ftrace.h>
>  #endif
> 
> +#ifdef CONFIG_PERF_EVENTS
> +#include <trace/perf.h>
> +#endif
> 
> This should be done anyway. But it would also let you decouple ftrace trace 
> events from perf trace events but still let the two use the same trace 
> points.

I think the main thing would be to have a decoupled /eventfs - basically 
/debug/tracing/events/ moved to "/eventfs" or maybe to "/proc/events/". This 
would make them available more widely, and in a standardized way.

Thanks,

	Ingo
