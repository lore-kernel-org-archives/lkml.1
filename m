Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZKJKKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZKJKKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZKJKKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:10:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45483 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbZKJKKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:10:21 -0500
Subject: Re: [RFC PATCH 4/4] perf/core: Schedule every pinned events before
 the the non-pinned
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1257711206-12243-5-git-send-email-fweisbec@gmail.com>
References: <1257711206-12243-1-git-send-email-fweisbec@gmail.com>
	 <1257711206-12243-5-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 10 Nov 2009 11:10:13 +0100
Message-ID: <1257847813.4648.31.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-08 at 21:13 +0100, Frederic Weisbecker wrote:

> +static void
> +__perf_event_sched_in_all(struct perf_event_context *ctx,
> +			  struct perf_cpu_context *cpuctx, int cpu)
> +{
> +	struct perf_event_context *cpu_ctx = &cpuctx->ctx;
> +
> +	/* May require different classes between cpu and task lock */
> +	spin_lock(&cpu_ctx->lock);
> +	spin_lock(&ctx->lock);

Would be good to know for sure, running with lockdep enabled ought to
tell you that pretty quick ;-)

> +	cpu_ctx->is_active = ctx->is_active = 1;
> +
> +	ctx->timestamp = cpu_ctx->timestamp = perf_clock();
> +
> +	perf_disable();
> +
> +	if (cpu_ctx->nr_events)
> +		__perf_event_sched_in_pinned(cpu_ctx, cpuctx, cpu);
> +
> +	if (ctx->nr_events)
> +		__perf_event_sched_in_pinned(cpu_ctx, cpuctx, cpu);
> +
> +	if (cpu_ctx->nr_events)
> +		__perf_event_sched_in_volatile(cpu_ctx, cpuctx, cpu);
> +
> +	if (ctx->nr_events)
> +		__perf_event_sched_in_volatile(cpu_ctx, cpuctx, cpu);
> +
> +	cpuctx->task_ctx = ctx;
> +
> +	perf_enable();
> +
> +	spin_unlock(&ctx->lock);
> +	spin_lock(&cpu_ctx->lock);

I'm pretty sure that ought to be spin_unlock() ;-)

> +}


Like Ingo I don't really like the volatile name.

Can't we simply have 2 lists per cpu a pinned and normal list, and first
schedule all the pinned and RR the normal events?

I guess one could implement that by adding the task context events to
the cpu context events on sched_in and removing them on sched_out. That
would clear up a lot of funny scheduling details.
