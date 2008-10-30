Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbYJ3Squ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbYJ3Squ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYJ3Sql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:46:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36142 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbYJ3Sqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:46:40 -0400
Date: Thu, 30 Oct 2008 19:45:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ring-buffer: add paranoid checks for loops
Message-ID: <20081030184552.GC17822@elte.hu>
References: <alpine.DEB.1.10.0810291439460.13214@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810291439460.13214@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> [ for 2.6.28 ]
> 
> While writing a new tracer, I had a bug where I caused the 
> ring-buffer to recurse in a bad way. The bug was with the tracer I 
> was writing and not the ring-buffer itself. But it took a long time 
> to find the problem.
> 
> This patch adds paranoid checks into the ring-buffer infrastructure
> that will catch bugs of this nature.
> 
> Note: I put the bug back in the tracer and this patch showed the error
>       nicely and prevented the lockup.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/ring_buffer.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> Index: linux-tip.git/kernel/trace/ring_buffer.c
> ===================================================================
> --- linux-tip.git.orig/kernel/trace/ring_buffer.c	2008-10-29 12:38:54.000000000 -0400
> +++ linux-tip.git/kernel/trace/ring_buffer.c	2008-10-29 16:11:00.000000000 -0400
> @@ -1022,8 +1022,20 @@ rb_reserve_next_event(struct ring_buffer
>  	struct ring_buffer_event *event;
>  	u64 ts, delta;
>  	int commit = 0;
> +	int paranoid = 0;
>  
>   again:
> +	/*
> +	 * If we loop here 1,000 times, that means we are either
> +	 * in an interrupt storm, or we have something buggy.
> +	 * Bail!
> +	 */
> +	if (unlikely(paranoid > 1000)) {
> +		RB_WARN_ON(cpu_buffer, 1);
> +		return NULL;
> +	}
> +	paranoid++;
> +
>  	ts = ring_buffer_time_stamp(cpu_buffer->cpu);
>  
>  	/*
> @@ -1532,10 +1544,21 @@ rb_get_reader_page(struct ring_buffer_pe
>  {
>  	struct buffer_page *reader = NULL;
>  	unsigned long flags;
> +	int paranoid = 0;
>  
>  	spin_lock_irqsave(&cpu_buffer->lock, flags);
>  
>   again:
> +	/*
> +	 * We can call here a couple of times, lets only allow 5.
> +	 */
> +	if (unlikely(paranoid > 4)) {
> +		RB_WARN_ON(cpu_buffer, 1);
> +		reader = NULL;
> +		goto out;
> +	}
> +	paranoid++;
> +
>  	reader = cpu_buffer->reader_page;
>  
>  	/* If there's more to read, return this page */
> @@ -1665,6 +1688,7 @@ ring_buffer_peek(struct ring_buffer *buf
>  	struct ring_buffer_per_cpu *cpu_buffer;
>  	struct ring_buffer_event *event;
>  	struct buffer_page *reader;
> +	int paranoid = 0;
>  
>  	if (!cpu_isset(cpu, buffer->cpumask))
>  		return NULL;
> @@ -1672,6 +1696,16 @@ ring_buffer_peek(struct ring_buffer *buf
>  	cpu_buffer = buffer->buffers[cpu];
>  
>   again:
> +	/*
> +	 * This could happen a few times, but if more than
> +	 * 10 times, then something is probably wrong.
> +	 */
> +	if (unlikely(paranoid > 10)) {
> +		RB_WARN_ON(cpu_buffer, 1);
> +		return NULL;
> +	}
> +	paranoid++;
> +
>  	reader = rb_get_reader_page(cpu_buffer);
>  	if (!reader)
>  		return NULL;
> @@ -1722,6 +1756,7 @@ ring_buffer_iter_peek(struct ring_buffer
>  	struct ring_buffer *buffer;
>  	struct ring_buffer_per_cpu *cpu_buffer;
>  	struct ring_buffer_event *event;
> +	int paranoid = 0;
>  
>  	if (ring_buffer_iter_empty(iter))
>  		return NULL;
> @@ -1730,6 +1765,16 @@ ring_buffer_iter_peek(struct ring_buffer
>  	buffer = cpu_buffer->buffer;
>  
>   again:
> +	/*
> +	 * This could happen a few times, but if more than
> +	 * 10 times, then something is probably wrong.
> +	 */
> +	if (unlikely(paranoid > 10)) {
> +		RB_WARN_ON(cpu_buffer, 1);
> +		return NULL;
> +	}
> +	paranoid++;
> +

hm, all those magic constants look a bit like voodoo and make the 
patch ugly, and people who read this will be confused about the 
purpose for sure.

But the checks are still worth having in practice. So could you please 
improve the comments, to come up with some tangible calculation that 
leads to these constants?

For example the '1000' constant, how did you come to that? Could you 
estimate what type of interrupt storm is needed to trigger it falsely? 
So instead of this comment:

> +	 * If we loop here 1,000 times, that means we are either
> +	 * in an interrupt storm, or we have something buggy.
> +	 * Bail!

something like this might look more acceptable:

> +	 * If we loop here 1,000 times, that means we are either
> +	 * in an interrupt storm that preempted the same trace-entry
> +	 * attempt 1000 times in a row, or we have a bug in the tracer.
> +	 * Bail!

i.e. please exaplain every single magic number there so that it can be 
followed how you got to that number, and what precise effects that 
number has.

In the cases where you just guessed a number based on experiments, 
please think it through and insert an analysis about the effects of 
that number.

Would this be doable?

	Ingo
