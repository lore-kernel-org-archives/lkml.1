Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYEDPI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYEDPI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYEDPIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:08:48 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:45571 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847AbYEDPIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:08:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As8EAKZuHUhMROPA/2dsb2JhbACBU6gM
Date: Sun, 4 May 2008 11:08:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/37] Linux Kernel Markers instrumentation for
	sched-devel.git
Message-ID: <20080504150840.GC23137@Krystal>
References: <20080424150324.802695381@polymtl.ca> <1209238735.6441.4.camel@lappy> <20080426201114.GA24798@Krystal> <1209290413.6503.8.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1209290413.6503.8.camel@lappy>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:05:41 up 65 days, 11:16,  3 users,  load average: 0.99, 0.86,
	0.91
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Sat, 2008-04-26 at 16:11 -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > > On Thu, 2008-04-24 at 11:03 -0400, Mathieu Desnoyers wrote:
> > > > Hi Ingo,
> > > > 
> > > > Here is a rather large patchset applying kernel instrumentation to
> > > > sched-devel.git. It includes, mainly :
> > > 
> > > I saw this land in sched-devel, how about this:
> > > 
> > 
> > I think the main reason why those markers are ugly is they have
> > information meant for use by a general purpose tracer (it will only take
> > the parameters before the ## signs).
> > 
> > The other way around is to start specializing the general purpose tracer
> > to extract the information it needs from the task and rq pointers and
> > put that in the traces. Actually, that's the approach I use currently
> > use in LTTng, but Ingo seemed interested to have the union of parameters
> > needed by specialized and GP tracers, so this is what I did.
> > 
> > The only thing I dislike with the approach of putting everything in a
> > separatered header is that it adds a layer of indirection when one try
> > to to quickly grep for trace_mark() in the kernel tree to see where the
> > conceptual tracing points are. Therefore, it might be interesting to
> > simply remove the parameters meant for the general purpose tracer and
> > let this GP tracer create specialized probes for these instrumentation
> > sites. It would therefore remove the ugliness without creating a
> > supplementary indirection layer.
> 
> In part its the extra parameters, but to a large part its that darn
> string. I'm still not getting why we can't just live with trace marks
> like 'regular' functions much like the ones I used to wrap trace_mark().
> 
> > > Index: linux-2.6-2/kernel/sched_trace.h
> > > ===================================================================
> > > --- /dev/null
> > > +++ linux-2.6-2/kernel/sched_trace.h
> > > @@ -0,0 +1,41 @@
> > > +#include <linux/marker.h>
> > > +
> > > +static inline void trace_kernel_sched_wait(struct task_struct *p)
> > > +{
> > > +	trace_mark(kernel_sched_wait_task, "pid %d state %ld",
> > > +			p->pid, p->state);
> > > +}
> > > +
> > > +static inline
> > > +void trace_kernel_sched_wakeup(struct rq *rq, struct task_struct *p)
> > > +{
> > > +	trace_mark(kernel_sched_wakeup,
> > > +			"pid %d state %ld ## rq %p task %p rq->curr %p",
> > > +			p->pid, p->state, rq, p, rq->curr);
> > > +}
> > > +
> > > +static inline
> > > +void trace_kernel_sched_wakeup_new(struct rq *rq, struct task_struct *p)
> > > +{
> > > +	trace_mark(kernel_sched_wakeup_new,
> > > +			"pid %d state %ld ## rq %p task %p rq->curr %p",
> > > +			p->pid, p->state, rq, p, rq->curr);
> > > +}
> > > +
> > > +static inline void trace_kernel_sched_switch(struct rq *rq,
> > > +		struct task_struct *prev, struct task_struct *next)
> > > +{
> > > +	trace_mark(kernel_sched_schedule,
> > > +			"prev_pid %d next_pid %d prev_state %ld "
> > > +			"## rq %p prev %p next %p",
> > > +			prev->pid, next->pid, prev->state,
> > > +			rq, prev, next);
> > > +}
> > > +
> > > +static inline void
> > > +trace_kernel_sched_migrate_task(struct task_struct *p, int src, int dst)
> > > +{
> > > +	trace_mark(kernel_sched_migrate_task,
> > > +			"pid %d state %ld dest_cpu %d",
> > > +			p->pid, p->state, dst);
> > > +}
> 
> One advantage of having these things close together would be that it
> stimulates consistency between the various trace points. Something that
> would be sorely needed with such a  free form mechanism.
> 

I was thinking of the possibility of per-subsystem list of
instrumentation sites, which would become more or less fixed, anyway,
which is what you seem to propose here. Given that it also cleans up the
scheduler code, I think it's interesting to do.

Do you have an updated version following Andrew's comments I could Ack ?
:)

Mathieu


> Peter
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
