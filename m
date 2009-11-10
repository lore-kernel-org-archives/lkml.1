Return-Path: <linux-kernel-owner+w=401wt.eu-S1751181AbZKJKeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181AbZKJKeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:34:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbZKJKeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:34:06 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48430 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZKJKeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:34:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tszZf6h98v78+96jz/MV6QDQktUMVLCO7u7Ul3I/LbhFvqtNon9wY/AY2z0AltyW8A
         1EzpDwFzeME+bw036aFZ/5XxGiSVhofhtEVz4y5uyOLokwbrt4xmuA5/ajaCQYGftgu+
         eCtJQ1dzMxs6lHbgphlKW1mRdZk3auel8Wasg=
Date: Tue, 10 Nov 2009 11:34:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 4/4] perf/core: Schedule every pinned events before
	the the non-pinned
Message-ID: <20091110103411.GD5255@nowhere>
References: <1257711206-12243-1-git-send-email-fweisbec@gmail.com> <1257711206-12243-5-git-send-email-fweisbec@gmail.com> <1257847813.4648.31.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257847813.4648.31.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 11:10:13AM +0100, Peter Zijlstra wrote:
> On Sun, 2009-11-08 at 21:13 +0100, Frederic Weisbecker wrote:
> 
> > +static void
> > +__perf_event_sched_in_all(struct perf_event_context *ctx,
> > +			  struct perf_cpu_context *cpuctx, int cpu)
> > +{
> > +	struct perf_event_context *cpu_ctx = &cpuctx->ctx;
> > +
> > +	/* May require different classes between cpu and task lock */
> > +	spin_lock(&cpu_ctx->lock);
> > +	spin_lock(&ctx->lock);
> 
> Would be good to know for sure, running with lockdep enabled ought to
> tell you that pretty quick ;-)



That's about sure I guess :)
I just wanted to take care of that after your comments.


 
> > +	cpu_ctx->is_active = ctx->is_active = 1;
> > +
> > +	ctx->timestamp = cpu_ctx->timestamp = perf_clock();
> > +
> > +	perf_disable();
> > +
> > +	if (cpu_ctx->nr_events)
> > +		__perf_event_sched_in_pinned(cpu_ctx, cpuctx, cpu);
> > +
> > +	if (ctx->nr_events)
> > +		__perf_event_sched_in_pinned(cpu_ctx, cpuctx, cpu);
> > +
> > +	if (cpu_ctx->nr_events)
> > +		__perf_event_sched_in_volatile(cpu_ctx, cpuctx, cpu);
> > +
> > +	if (ctx->nr_events)
> > +		__perf_event_sched_in_volatile(cpu_ctx, cpuctx, cpu);
> > +
> > +	cpuctx->task_ctx = ctx;
> > +
> > +	perf_enable();
> > +
> > +	spin_unlock(&ctx->lock);
> > +	spin_lock(&cpu_ctx->lock);
> 
> I'm pretty sure that ought to be spin_unlock() ;-)


Indeed :)


> > +}
> 
> 
> Like Ingo I don't really like the volatile name.
> 
> Can't we simply have 2 lists per cpu a pinned and normal list, and first
> schedule all the pinned and RR the normal events?
> 
> I guess one could implement that by adding the task context events to
> the cpu context events on sched_in and removing them on sched_out. That
> would clear up a lot of funny scheduling details.


I thought about doing that, but didn't expand the idea that much,
because of the list manipulation that induces.

But you're right, that would be be indeed more proper.
I can just save the "real" cpu event group tail in the
struct perf_cpu_context so that I can keep track of the real
state and (un)glue the queues easily.

Yeah, I'll try that, thanks!

