Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZDFQPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZDFQPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759104AbZDFQPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:15:34 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55638 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759076AbZDFQPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:15:32 -0400
Date: Mon, 6 Apr 2009 09:15:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
Subject: Re: [PATCH] tracing/filters: allow event filters to be set only
	when not tracing
Message-ID: <20090406161527.GD6988@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1238390546.6368.65.camel@bookworm> <20090401122408.GG12966@elte.hu> <1238653371.6655.48.camel@bookworm> <20090403135956.GD8875@elte.hu> <alpine.DEB.2.00.0904031010510.965@gandalf.stny.rr.com> <1238830355.22495.55.camel@bookworm> <alpine.DEB.2.00.0904041143480.32083@gandalf.stny.rr.com> <1238916865.7989.212.camel@tropicana> <20090405171146.GK6893@linux.vnet.ibm.com> <alpine.DEB.2.00.0904061155120.4317@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904061155120.4317@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 11:59:30AM -0400, Steven Rostedt wrote:
> On Sun, 5 Apr 2009, Paul E. McKenney wrote:
> > > Basically the problem is that the tracing functions call
> > > filter_match_preds(call,...) where call->preds is an array of predicates
> > > that get checked to determine whether the current event matches or not.
> > > When an existing filter is deleted (or an old one replaced), the
> > > call->preds array is freed and set to NULL (which happens only via a
> > > write to the 'filter' debugfs file).  So without any protection, while
> > > one cpu is freeing the preds array, the others may still be using it,
> > > and if so, it will crash the box.  You can easily see the problem with
> > > e.g. the function tracer:
> > > 
> > > # echo function > /debug/tracing/current_tracer
> > > 
> > > Function tracing is now live
> > > 
> > > # echo 'common_pid == 0' > /debug/tracing/events/ftrace/function/filter
> > > 
> > > No problem, no preds are freed the first time
> > > 
> > > # echo 0 > /debug/tracing/events/ftrace/function/filter
> > > 
> > > Crash.
> > > 
> > > My first patch took the safe route and completely disallowed filters
> > > from being set when any tracing was live i.e. you had to for example
> > > echo 0 > tracing_enabled or echo 0 > enable for a particular event, etc.
> > > 
> > > This wasn't great for usability, though - it would be much nicer to be
> > > able to remove or set new filters on the fly, while tracing is active,
> > > which rcu seemed perfect for - the preds wouldn't actually be destroyed
> > > until all the current users were finished with them.  My second patch
> > > implemented that and it seemed to nicely fix the problem, but it
> > > apparently can cause other problems...
> 
> The proble is that function tracing also traces the rcu calls. Even though 
> the function trace protects against recursion, by adding rcu locks to the
> function tracer, we have just doubled the overhead for it. Every function 
> trace will call rcu_read_lock, then that would be traced too, and the 
> function tracer would see that it is recursive and return. All this is 
> added overhead to _every_ function!
> 
> I do not understand why my recommendation is not used. All tracers require 
> preemption to be disabled. By simply removing the pred from the list, do a 
> synchronize_sched(), then set it to NULL. The update is done by userland, 
> synchronizing a schedule should not be that noticeable.

The only caution is that synchronize_sched() ignores preempt-disable
sequences in the idle loop.  The reason for this is that synchronize_sched()
maps to synchronize_rcu() for rcuclassic and rcutree.

So, if you need to make synchronize_sched() pay attention to
preempt-disable sequences in the idle loop, something similar to the
patch to RCU that I sent earlier (adding explicit rcu_idle() call to
each idle loop) would be required.

> > > So assuming we can't use rcu for this, it would be nice to have a way to
> > > 'pause' tracing so the current filter can be removed i.e. some version
> > > of stop_trace()/start_trace() that make sure nothing is still executing
> > > or can enter filter_match_preds() while the current call->preds is being
> > > destroyed.  Seems like it would be straightforward to implement for the
> > > event tracer, since each event maps to a tracepoint that could be
> > > temporarily unregistered/reregistered, but maybe not so easy for the
> > > ftrace tracers...
> > 
> > In principle, it would be possible to rework RCU so that instead of the
> > whole idle loop being a quiescent state, there is a single quiescent state
> > at one point in each idle loop.  The reason that I have been avoiding this
> > is that there are a lot of idle loops out there, and it would be a bit
> > annoying to (1) find them all and update them and (2) keep track of all of
> > them to ensure that new ones cannot slip in without the quiescent state.
> > 
> > But it could be done if the need is there.  Simple enough change.
> > The following patch shows the general approach, assuming that CPUs
> > are never put to sleep without entering nohz mode.
> > 
> > Thoughts?
> 
> I think using synchronize_sched() should be good enough for what we need.

Again, as long as either (1) you are OK with synchronize_sched()
ignoring preempt-disable sequences in the idle loop or (2) we rework RCU
to add something like an rcu_idle() call in each idle loop.

							Thanx, Paul
