Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab0CFCQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 21:16:05 -0500
Received: from relay4-v.mail.gandi.net ([217.70.178.78]:41302 "EHLO
	relay4-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab0CFCQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 21:16:03 -0500
Date: Fri, 5 Mar 2010 18:15:48 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH tip/core/rcu 1/3] ftrace: replace
 read_barrier_depends() with rcu_dereference_raw()
Message-ID: <20100306021548.GB13858@feather>
References: <20100305230256.GA9410@linux.vnet.ibm.com>
 <1267830207-9474-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1267838945.10871.1786.camel@gandalf.stny.rr.com>
 <20100306014513.GA13858@feather>
 <1267840669.10871.1790.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267840669.10871.1790.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 08:57:49PM -0500, Steven Rostedt wrote:
> On Fri, 2010-03-05 at 17:45 -0800, Josh Triplett wrote:
> 
> > > #define rcu_assign_pointer(p, v) \
> > > 	({ \
> > > 		if (!__builtin_constant_p(v) || \
> > > 		    ((v) != NULL)) \
> > > 			smp_wmb(); \
> > > 		(p) = (v); \
> > > 	})
> > > 
> > > My question is, why that crazy if? The only time that will fail is if we
> > > are assigning the constant NULL to p. What makes NULL so important here?
> > > Can't there be a case when assigning NULL to p will require that wmb()?
> > 
> > The barrier ensures that the reader can't see the new p and the old
> > *p.  Since you can't look at *NULL, that concern doesn't apply.
> 
> Thanks for the explanation.
> 
> Question 2)
> 
> Then why the !__builtin_constant_p(v)?
> 
> If v is NULL, then the same should apply even if it is not a constant?
> What am I missing?

Checking for __builtin_constant_p(v) ensures that this test happens at
compile time, and thus no conditional occurs at runtime.  Together with
the assumption of compiler constant folding and dead code elimination,
this test means "if you can tell at compile time that the call assigns
NULL, emit no barrier, otherwise emit a barrier".  Under no
circumstances will this macro actually emit conditional code.

- Josh Triplett
