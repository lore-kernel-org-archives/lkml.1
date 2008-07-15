Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbYGOOqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbYGOOqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYGOOqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:46:34 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:47491 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbYGOOqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:46:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEACdTfEhMRKxB/2dsb2JhbACBWq0T
Date: Tue, 15 Jul 2008 10:46:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 01/15] Kernel Tracepoints
Message-ID: <20080715144628.GD20037@Krystal>
References: <20080709145929.352201601@polymtl.ca> <20080709150043.693920317@polymtl.ca> <1216108237.12595.122.camel@twins> <20080715132543.GB20037@Krystal> <1216130593.12595.189.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1216130593.12595.189.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:36:11 up 40 days, 19:17,  5 users,  load average: 0.89, 1.73,
	1.25
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2008-07-15 at 09:25 -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > On Wed, 2008-07-09 at 10:59 -0400, Mathieu Desnoyers wrote:
> 
> > > > +#define __DO_TRACE(tp, proto, args)					\
> > > > +	do {								\
> > > > +		int i;							\
> > > > +		void **funcs;						\
> > > > +		preempt_disable();					\
> > > > +		funcs = (tp)->funcs;					\
> > > > +		smp_read_barrier_depends();				\
> > > > +		if (funcs) {						\
> > > > +			for (i = 0; funcs[i]; i++) {			\
> > > 
> > > Also, why is the preempt_disable needed?
> > > 
> > 
> > Addition and removal of tracepoints is synchronized by RCU using the
> > scheduler (and preempt_disable) as guarantees to find a quiescent state
> > (this is really RCU "classic"). The update side uses rcu_barrier_sched()
> > with call_rcu_sched() and the read/execute side uses
> > "preempt_disable()/preempt_enable()".
> 
> > > > +static void tracepoint_entry_free_old(struct tracepoint_entry *entry, void *old)
> > > > +{
> > > > +	if (!old)
> > > > +		return;
> > > > +	entry->oldptr = old;
> > > > +	entry->rcu_pending = 1;
> > > > +	/* write rcu_pending before calling the RCU callback */
> > > > +	smp_wmb();
> > > > +#ifdef CONFIG_PREEMPT_RCU
> > > > +	synchronize_sched();	/* Until we have the call_rcu_sched() */
> > > > +#endif
> > > 
> > > Does this have something to do with the preempt_disable above?
> > > 
> > 
> > Yes, it does. We make sure the previous array containing probes, which
> > has been scheduled for deletion by the rcu callback, is indeed freed
> > before we proceed to the next update. It therefore limits the rate of
> > modification of a single tracepoint to one update per RCU period. The
> > objective here is to permit fast batch add/removal of probes on
> > _different_ tracepoints.
> > 
> > This use of "synchronize_sched()" can be changed for call_rcu_sched() in
> > linux-next, I'll fix this.
> 
> Right, I thought as much, its just that the raw preempt_disable()
> without comments leaves one wondering if there is anything else going
> on.
> 
> Would it make sense to add:
> 
> rcu_read_sched_lock()
> rcu_read_sched_unlock()
> 
> to match:
> 
> call_rcu_sched()
> rcu_barrier_sched()
> synchronize_sched()
> 
> ?
> 

Yes, I would add them to include/linux/rcupdate.h. I'll include it with
my next release.

Talking about headers, I have noticed that placing headers with the code
may not be as clean as I would hope. For instance, the kernel/irq-trace.h
header, when included from kernel/irq/handle.c, has to be included with:

#include "../irq-trace.h"

Which is not _that_ bad, but we we want to instrument the irq handler
found in arch/x86/kernel/cpu/mcheck/mce_intel_64.c, including
#include "../../../../../kernel/irq-trace.h" makes me go "yeeeek!"

How about creating include/trace/irq.h and friends ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
