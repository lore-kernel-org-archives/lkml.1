Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbZFBTaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbZFBTaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 15:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZFBTaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 15:30:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51487 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbZFBTaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 15:30:15 -0400
Date: Tue, 2 Jun 2009 15:30:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] function-graph: enable the stack after initialization
 of other variables
In-Reply-To: <20090602190227.GB6041@nowhere>
Message-ID: <alpine.DEB.2.00.0906021528210.14994@gandalf.stny.rr.com>
References: <20090602183036.621443366@goodmis.org> <20090602184601.206454309@goodmis.org> <20090602190227.GB6041@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2 Jun 2009, Frederic Weisbecker wrote:
> > diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> > index d28687e..baeb5fe 100644
> > --- a/kernel/trace/trace_functions_graph.c
> > +++ b/kernel/trace/trace_functions_graph.c
> > @@ -65,6 +65,12 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth)
> >  	if (!current->ret_stack)
> >  		return -EBUSY;
> >  
> > +	/*
> > +	 * We must make sure the ret_stack is tested before we read
> > +	 * anything else.
> > +	 */
> > +	smp_rmb();
> 
> 
> Isn't this part a too much costly for very traced function?

I was thinking that, but otherwise we still have the problem. It is a read 
barrier which I don't think is as costly as a write or full barrier. But 
because we have the if statement, perhaps a "read_barrier_depends" can do?

[ added Paul McKenney because he's good with barriers ]

-- Steve


> 
> 
> > +
> >  	/* The return trace stack is full */
> >  	if (current->curr_ret_stack == FTRACE_RETFUNC_DEPTH - 1) {
> >  		atomic_inc(&current->trace_overrun);
> > -- 
> > 1.6.3.1
> > 
> > -- 
> 
> 
