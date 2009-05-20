Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZETPlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZETPlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbZETPlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 11:41:18 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40451 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386AbZETPlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 11:41:17 -0400
Date: Wed, 20 May 2009 08:41:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: add trace_event_read_lock()
Message-ID: <20090520154117.GG6729@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4A114806.7090302@cn.fujitsu.com> <20090518135930.GC4704@nowhere> <4A1213E1.8050608@cn.fujitsu.com> <20090520002451.GE6066@nowhere> <4A136A23.8040500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A136A23.8040500@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 10:25:39AM +0800, Lai Jiangshan wrote:
> Frederic Weisbecker wrote:
> > On Tue, May 19, 2009 at 10:05:21AM +0800, Lai Jiangshan wrote:
> >> Frederic Weisbecker wrote:
> >>> On Mon, May 18, 2009 at 07:35:34PM +0800, Lai Jiangshan wrote:
> >>>> I found that there is nothing to protect event_hash in
> >>>> ftrace_find_event().
> >>>
> >>>
> >>> Actually, rcu protects it, but not enough. We have neither
> >>> synchronize_rcu() nor rcu_read_lock.
> >> We have no rcu_read_lock(), RCU can not protects it.
> >>
> >>> So we protect against concurrent hlist accesses.
> >>> But the event can be removed when a module is unloaded,
> >>> and that can happen between the time we get the event output
> >>> callback and the time we actually use it.
> >>>
> >> [...]
> >>
> >>> It could be more fine grained.
> >> I think it's fine-grained enough, write-side(modules loading/unloading)
> >> is happened rarely. trace_event_read_lock() will not sleep very likely.
> >>
> >> Thoughts?
> > 
> > 
> > Yeah, the write lock is a rare event, that's why I think
> > it's enough fine grained.
> > 
> >  
> >>> We could have a per event rwsem, and also place the
> >>> protected read section only in trace_print_entry() which is the only racy window.
> >>>
> >> print_trace_line() is the only racy window.
> >> So I just protect print_trace_line()(except __ftrace_dump())
> >>
> >> I protect loops which call print_trace_line(), it
> >> reduces invoke-times:
> >>
> >> trace_event_read_lock();
> >> while (...) {
> >> 	...
> >> 	print_trace_line();
> >> 	...
> >> }
> >> trace_event_read_unlock();
> > 
> > 
> > 
> > Yeah, I meant it could have been:
> > 
> > trace_event_read_lock();
> > print_trace_line();
> > trace_event_read_unlock();
> > 
> > It's more fine grained, but:
> > 
> > - the write lock path is rarely taken
> > - it would add more extra calls then more overhead
> > 
> > IMO this is fine as an rwsem design point of view.
> > 
> > But I have mixed feelings when I consider it could be
> > done using rcu. I will explain that in my next answer to
> > Paul and will wait for your comments.
> > 
> 
> rcu_read_lock() will disable preempt for im-preemptable RCU,
> it will add latency to kernel, because print_trace_line() is not
> a short function.
> 
> The smallest window is:
> (print_trace_line() calls ftrace_find_event() by several paths)
> 
> 	XXX_read_lock();
> 	event = ftrace_find_event(entry->type);
> 	if (event)
> 		event->YYYY();
> 	XXX_read_unlock();
> 
> but event->YYYY() is not a short function neither.

SRCU could be used instead, as noted in a separate message.

> Since write-side is rarely taken, sleep-able read-side(rwsem)
> will not block each other. So I use trace_event_read_lock()
> protects the biggest window(the loops).

But if simple locking works, I have no problem with it.  As always,
use the right tool for the job.  And even I will tell you that RCU is
not always the right tool.  ;-)

						Thanx, Paul

> In LTTng, the tracing code(trace_NAME()) accesses to
> event type list, so RCU is needed in LTTng for event type list.
> 
> But Ftrace's tracing code does not accesses to event type list,
> I don't know this logic is still true in future. Steven may
> give me an answer.
> 
> Lai.
> 
