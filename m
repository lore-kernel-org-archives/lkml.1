Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbYD0KBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbYD0KBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 06:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbYD0KBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 06:01:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33269 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbYD0KBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 06:01:01 -0400
Subject: Re: [patch 00/37] Linux Kernel Markers instrumentation for
	sched-devel.git
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080426201114.GA24798@Krystal>
References: <20080424150324.802695381@polymtl.ca>
	 <1209238735.6441.4.camel@lappy>  <20080426201114.GA24798@Krystal>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 12:00:13 +0200
Message-Id: <1209290413.6503.8.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-26 at 16:11 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > On Thu, 2008-04-24 at 11:03 -0400, Mathieu Desnoyers wrote:
> > > Hi Ingo,
> > > 
> > > Here is a rather large patchset applying kernel instrumentation to
> > > sched-devel.git. It includes, mainly :
> > 
> > I saw this land in sched-devel, how about this:
> > 
> 
> I think the main reason why those markers are ugly is they have
> information meant for use by a general purpose tracer (it will only take
> the parameters before the ## signs).
> 
> The other way around is to start specializing the general purpose tracer
> to extract the information it needs from the task and rq pointers and
> put that in the traces. Actually, that's the approach I use currently
> use in LTTng, but Ingo seemed interested to have the union of parameters
> needed by specialized and GP tracers, so this is what I did.
> 
> The only thing I dislike with the approach of putting everything in a
> separatered header is that it adds a layer of indirection when one try
> to to quickly grep for trace_mark() in the kernel tree to see where the
> conceptual tracing points are. Therefore, it might be interesting to
> simply remove the parameters meant for the general purpose tracer and
> let this GP tracer create specialized probes for these instrumentation
> sites. It would therefore remove the ugliness without creating a
> supplementary indirection layer.

In part its the extra parameters, but to a large part its that darn
string. I'm still not getting why we can't just live with trace marks
like 'regular' functions much like the ones I used to wrap trace_mark().

> > Index: linux-2.6-2/kernel/sched_trace.h
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6-2/kernel/sched_trace.h
> > @@ -0,0 +1,41 @@
> > +#include <linux/marker.h>
> > +
> > +static inline void trace_kernel_sched_wait(struct task_struct *p)
> > +{
> > +	trace_mark(kernel_sched_wait_task, "pid %d state %ld",
> > +			p->pid, p->state);
> > +}
> > +
> > +static inline
> > +void trace_kernel_sched_wakeup(struct rq *rq, struct task_struct *p)
> > +{
> > +	trace_mark(kernel_sched_wakeup,
> > +			"pid %d state %ld ## rq %p task %p rq->curr %p",
> > +			p->pid, p->state, rq, p, rq->curr);
> > +}
> > +
> > +static inline
> > +void trace_kernel_sched_wakeup_new(struct rq *rq, struct task_struct *p)
> > +{
> > +	trace_mark(kernel_sched_wakeup_new,
> > +			"pid %d state %ld ## rq %p task %p rq->curr %p",
> > +			p->pid, p->state, rq, p, rq->curr);
> > +}
> > +
> > +static inline void trace_kernel_sched_switch(struct rq *rq,
> > +		struct task_struct *prev, struct task_struct *next)
> > +{
> > +	trace_mark(kernel_sched_schedule,
> > +			"prev_pid %d next_pid %d prev_state %ld "
> > +			"## rq %p prev %p next %p",
> > +			prev->pid, next->pid, prev->state,
> > +			rq, prev, next);
> > +}
> > +
> > +static inline void
> > +trace_kernel_sched_migrate_task(struct task_struct *p, int src, int dst)
> > +{
> > +	trace_mark(kernel_sched_migrate_task,
> > +			"pid %d state %ld dest_cpu %d",
> > +			p->pid, p->state, dst);
> > +}

One advantage of having these things close together would be that it
stimulates consistency between the various trace points. Something that
would be sorely needed with such a  free form mechanism.

Peter

