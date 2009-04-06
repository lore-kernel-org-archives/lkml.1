Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbZDFTxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbZDFTxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZDFTw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:52:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbZDFTw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:52:58 -0400
Date: Mon, 6 Apr 2009 15:52:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/filters: allow event filters to be set only when
 not tracing
In-Reply-To: <20090406194417.GA5936@nowhere>
Message-ID: <alpine.DEB.2.00.0904061552260.23509@gandalf.stny.rr.com>
References: <1238653371.6655.48.camel@bookworm> <20090403135956.GD8875@elte.hu> <alpine.DEB.2.00.0904031010510.965@gandalf.stny.rr.com> <1238830355.22495.55.camel@bookworm> <alpine.DEB.2.00.0904041143480.32083@gandalf.stny.rr.com> <1238916865.7989.212.camel@tropicana>
 <20090405171146.GK6893@linux.vnet.ibm.com> <alpine.DEB.2.00.0904061155120.4317@gandalf.stny.rr.com> <20090406161527.GD6988@linux.vnet.ibm.com> <alpine.DEB.2.00.0904061529370.4317@gandalf.stny.rr.com> <20090406194417.GA5936@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 6 Apr 2009, Frederic Weisbecker wrote:
> > > 
> > > > > > So assuming we can't use rcu for this, it would be nice to have a way to
> > > > > > 'pause' tracing so the current filter can be removed i.e. some version
> > > > > > of stop_trace()/start_trace() that make sure nothing is still executing
> > > > > > or can enter filter_match_preds() while the current call->preds is being
> > > > > > destroyed.  Seems like it would be straightforward to implement for the
> > > > > > event tracer, since each event maps to a tracepoint that could be
> > > > > > temporarily unregistered/reregistered, but maybe not so easy for the
> > > > > > ftrace tracers...
> > > > > 
> > > > > In principle, it would be possible to rework RCU so that instead of the
> > > > > whole idle loop being a quiescent state, there is a single quiescent state
> > > > > at one point in each idle loop.  The reason that I have been avoiding this
> > > > > is that there are a lot of idle loops out there, and it would be a bit
> > > > > annoying to (1) find them all and update them and (2) keep track of all of
> > > > > them to ensure that new ones cannot slip in without the quiescent state.
> > > > > 
> > > > > But it could be done if the need is there.  Simple enough change.
> > > > > The following patch shows the general approach, assuming that CPUs
> > > > > are never put to sleep without entering nohz mode.
> > > > > 
> > > > > Thoughts?
> > > > 
> > > > I think using synchronize_sched() should be good enough for what we need.
> > > 
> > > Again, as long as either (1) you are OK with synchronize_sched()
> > > ignoring preempt-disable sequences in the idle loop or (2) we rework RCU
> > > to add something like an rcu_idle() call in each idle loop.
> > 
> > 3) add "notrace" to the idle functions ;-)
> > 
> > But perhaps the rcu_idle might be the best idea.
> 
> 
> And tracing the idle time is also sometimes very useful :-)

Agreed. I guess choice 2 is the best answer.

-- Steve

