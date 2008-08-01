Return-Path: <linux-kernel-owner+w=401wt.eu-S1762245AbYHAVSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762245AbYHAVSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760997AbYHAVKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:10:54 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51308 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760649AbYHAVKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:10:50 -0400
Date: Fri, 1 Aug 2008 14:10:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 02/17] Kernel Tracepoints
Message-ID: <20080801211047.GX14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080715222604.331269462@polymtl.ca> <20080715222746.361289615@polymtl.ca> <Pine.LNX.4.58.0807241105280.14946@gandalf.stny.rr.com> <20080724201800.GA23818@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724201800.GA23818@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 04:18:00PM -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
> > [Added Paul McKenney to CC]
> > 
> > On Tue, 15 Jul 2008, Mathieu Desnoyers wrote:
> > > +++ linux-2.6-lttng/include/linux/tracepoint.h	2008-07-15 17:35:19.000000000 -0400
> > > @@ -0,0 +1,127 @@
> > > +#ifndef _LINUX_TRACEPOINT_H
> > > +#define _LINUX_TRACEPOINT_H
> > > +
> > > +/*
> > > + * Kernel Tracepoint API.
> > > + *
> > > + * See Documentation/tracepoint.txt.
> > > + *
> > > + * (C) Copyright 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > > + *
> > > + * Heavily inspired from the Linux Kernel Markers.
> > > + *
> > > + * This file is released under the GPLv2.
> > > + * See the file COPYING for more details.
> > > + */
> > > +
> > > +#include <linux/types.h>
> > > +#include <linux/rcupdate.h>
> > > +
> > > +struct module;
> > > +struct tracepoint;
> > > +
> > > +struct tracepoint {
> > > +	const char *name;		/* Tracepoint name */
> > > +	int state;			/* State. */
> > > +	void **funcs;
> > > +} __attribute__((aligned(8)));
> > > +
> > > +
> > > +#define TPPROTO(args...)	args
> > > +#define TPARGS(args...)		args
> > > +
> > > +#ifdef CONFIG_TRACEPOINTS
> > > +
> > > +/*
> > > + * it_func[0] is never NULL because there is at least one element in the array
> > > + * when the array itself is non NULL.
> > > + */
> > > +#define __DO_TRACE(tp, proto, args)					\
> > > +	do {								\
> > > +		void **it_func;						\
> > > +									\
> > > +		rcu_read_lock_sched();					\
> > > +		it_func = rcu_dereference((tp)->funcs);			\
> > > +		if (it_func) {						\
> > > +			do {						\
> > > +				((void(*)(proto))(*it_func))(args);	\
> > > +			} while (*(++it_func));				\
> > 
> > OK, I still don't understand the concept of the rcu_dereference, but why
> > is it needed for the first assignment of it_func but not the ++? Is it
> > only needed with the (tp)->funcs?
> > 
> 
> rcu_dereference copies the tp->funcs pointer on the local stack and then
> puts a smp_read_barrier_depends() to make sure that the tp->funcs read
> occurs before the actual use of the data (here, it is the array
> elements) where the tp->funcs pointer copy points to.
> 
> What happens here is that the tp->funcs pointer, pointing to the
> beginning of the array, is only read once. Afterward, the iterator is
> located on the stack and therefore incrementing it does not need to be
> protected by any other kind of barrier whatsoever because only the
> original tp->funcs read was a RCU pointer read.
> 
> Then, as you probably know, the update side performs a
> rcu_assign_pointer which does a smp_wmb before the pointer assignment to
> make sure the array data has been populated before the pointer
> assignment.

So the update side inserts a whole new array, rather than just the
first entry, correct?  If so, I am happy.

							Thanx, Paul

> Mathieu
> 
> > -- Steve
> > 
> > 
> > > +		}							\
> > > +		rcu_read_unlock_sched();				\
> > > +	} while (0)
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
