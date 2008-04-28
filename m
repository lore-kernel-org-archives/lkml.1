Return-Path: <linux-kernel-owner+w=401wt.eu-S934316AbYD1NOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316AbYD1NOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934189AbYD1NNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:13:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57895 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454AbYD1NNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:13:49 -0400
Date: Mon, 28 Apr 2008 09:13:48 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, akpm@osdl.org,
       Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/3] ftrace: add logic to record overruns
In-Reply-To: <20080426234713.4a49373d@daedalus.pq.iki.fi>
Message-ID: <Pine.LNX.4.58.0804280909250.813@gandalf.stny.rr.com>
References: <20080421210935.460817943@goodmis.org> <20080421212128.201844090@goodmis.org>
 <20080426234713.4a49373d@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 26 Apr 2008, Pekka Paalanen wrote:

> On Mon, 21 Apr 2008 17:09:36 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> ....
> > @@ -2510,6 +2511,11 @@ tracing_read_pipe(struct file *filp, cha
> >  	for_each_cpu_mask(cpu, mask) {
> >  		data = iter->tr->data[cpu];
> >  		__raw_spin_lock(&data->lock);
> > +
> > +		if (data->overrun > iter->last_overrun[cpu])
> > +			iter->overrun[cpu] +=
> > +				data->overrun - iter->last_overrun[cpu];
> > +		iter->last_overrun[cpu] = data->overrun;
>
> Option 1: move this code earlier.
> (Could also remove the `if' and make it unconditional.)

I'll move it. The condition was there because I could have sworn that
there's some way (perhaps just via an error) that lastrun could be greater
than the overrun. But perhaps it doesn't matter.

> > +++ linux-sched-devel.git/kernel/trace/trace.h	2008-04-21 14:38:09.000000000 -0400
> > @@ -102,6 +102,7 @@ struct trace_array_cpu {
> >  	void			*trace_head; /* producer */
> >  	void			*trace_tail; /* consumer */
> >  	unsigned long		trace_idx;
> > +	unsigned long		overrun;
>
> Option 2: Change this into atomic_t.

I could do that too.

> >   * results to users and which routines might sleep, etc:
> >   */
> >  struct trace_iterator {
> > -	struct trace_seq	seq;
> >  	struct trace_array	*tr;
> >  	struct tracer		*trace;
> > +	long			last_overrun[NR_CPUS];
> > +	long			overrun[NR_CPUS];
>
> The problem with these fields is that they are updated only after the read
> hook has been called in tracing_read_pipe(), which means all "N events
> lost!" entries will be one read call behind. This can be any number of
> events.
>
> If trace_array_cpu::overrun was atomic_t, I could process that in
> the read callback. But, trace_iterator::overrun would be good, because
> I could just reset it to zero every time I encounter a non-zero value.
>
> I can think of two options, the ones noted above: moving the update
> earlier, or using atomic_t. Or maybe do both, so that we don't have to
> lock the trace_array_cpu structs early and also avoid duplicating the
> overrun/last_overrun logic in a tracer.
>
> What shall we do?

I think you're right that we should move it before calling the read hook.
I didn't want to make the one value atomic because that would just add
another atomic operation in a fast path. I may wait on making that atomic.

-- Steve

