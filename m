Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbZFCPkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbZFCPkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756270AbZFCPkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:40:45 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49552 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbZFCPkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:40:45 -0400
Date: Wed, 3 Jun 2009 08:35:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 2/3] function-graph: enable the stack after
	initialization of other variables
Message-ID: <20090603153508.GC6640@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090602183036.621443366@goodmis.org> <20090602184601.206454309@goodmis.org> <20090602190227.GB6041@nowhere> <alpine.DEB.2.00.0906021528210.14994@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906021528210.14994@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 03:30:14PM -0400, Steven Rostedt wrote:
> 
> On Tue, 2 Jun 2009, Frederic Weisbecker wrote:
> > > diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> > > index d28687e..baeb5fe 100644
> > > --- a/kernel/trace/trace_functions_graph.c
> > > +++ b/kernel/trace/trace_functions_graph.c
> > > @@ -65,6 +65,12 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth)
> > >  	if (!current->ret_stack)
> > >  		return -EBUSY;
> > >  
> > > +	/*
> > > +	 * We must make sure the ret_stack is tested before we read
> > > +	 * anything else.
> > > +	 */
> > > +	smp_rmb();
> > 
> > 
> > Isn't this part a too much costly for very traced function?
> 
> I was thinking that, but otherwise we still have the problem. It is a read 
> barrier which I don't think is as costly as a write or full barrier. But 
> because we have the if statement, perhaps a "read_barrier_depends" can do?

Although this would work on some CPU architectures (x86, s390, Power,
and perhaps a few others), it would break on those weakly ordered systems
that do not respect control dependencies.

One approach would be to use another level of indirection.  If this new
pointer is NULL, you return EBUSY.  Make this new pointer reference
the updated fields (tracing_graph_pause, trace_overrun, and so on).
This could point into the same data structure -- it is not necessary to
actually allocate a new chunk of memory.

Then you can use the existing rcu_assign_pointer() and rcu_dereference()
primitives.

Does this approach help at all?

							Thanx, Paul

> [ added Paul McKenney because he's good with barriers ]
> 
> -- Steve
> 
> 
> > 
> > 
> > > +
> > >  	/* The return trace stack is full */
> > >  	if (current->curr_ret_stack == FTRACE_RETFUNC_DEPTH - 1) {
> > >  		atomic_inc(&current->trace_overrun);
> > > -- 
> > > 1.6.3.1
> > > 
> > > -- 
> > 
> > 
