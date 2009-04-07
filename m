Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZDGJYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZDGJYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZDGJYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:24:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44496 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbZDGJYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:24:05 -0400
Date: Tue, 7 Apr 2009 05:24:00 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tom Zanussi <tzanussi@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/4] tracing/filters: use ring_buffer_discard_commit for
 discarded events
In-Reply-To: <1239083209.7220.42.camel@tropicana>
Message-ID: <alpine.DEB.2.00.0904070521510.22758@gandalf.stny.rr.com>
References: <20090402052721.013878388@goodmis.org>  <20090402053522.834546042@goodmis.org> <1238663187.6621.13.camel@bookworm>  <alpine.DEB.2.00.0904021033080.965@gandalf.stny.rr.com> <1239083209.7220.42.camel@tropicana>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 7 Apr 2009, Tom Zanussi wrote:
> 
> > The bug does not stick out in this patch set. Perhaps it is part of the 
> > original too?  But something somewhere is calling the discard outside the 
> > reserve and commit.
> > 
> 
> It doesn't stick out to me either - the funny thing is that it only
> happens with CONFIG_PREEMPT_VOLUNTARY - with CONFIG_PREEMPT it's fine.
> 
> In fact, with CONFIG_PREEMPT_VOLUNTARY, an RB_WARN_ON(!preempt_count())
> right after frace_preempt_disable() triggers immediately, which unless
> I'm missing something, should never happen.  Is there a bug in
> PREEMPT_VOLUNTARY?
> 
> Tom
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 7a6209f..bac9ab7 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1494,6 +1494,8 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
>  	/* If we are tracing schedule, we don't want to recurse */
>  	resched = ftrace_preempt_disable();
>  
> +	RB_WARN_ON(buffer, !preempt_count());

Ug, I'm an idiot ;-)

PREEMPT_VOLUNTARY will always have preempt_count return zero. We need a:

	RB_WARN_ON_PREEMPT(buffer);

macro, so that we can define it to warn on CONFIG_PREEMPT but have it be a
nop for all else.

Note, I'm currently traveling so my response times will be limited.

-- Steve

> +
>  	cpu = raw_smp_processor_id();
>  
>  	if (!cpumask_test_cpu(cpu, buffer->cpumask))
> 
> 
