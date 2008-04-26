Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbYD0KA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbYD0KA5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 06:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbYD0KAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 06:00:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:65477 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbYD0KAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 06:00:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=LBsmrGettG+7aPV8NZWcaywcR4iwpI+87xhDUOLRMFZSPbnHEXfhspN2XIpGhVOVv9zLrV6IFCW27060EN9H5vJNDoPrcFTXZQKH0NnjDo8z6cXEJrYFo+o7Upvcfzp8FIGkXUIkEzmNQqe6qJMHL786wpP8PSDUyLfk9ALr+oE=
Date: Sat, 26 Apr 2008 23:47:13 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, akpm@osdl.org,
       Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/3] ftrace: add logic to record overruns
Message-ID: <20080426234713.4a49373d@daedalus.pq.iki.fi>
In-Reply-To: <20080421212128.201844090@goodmis.org>
References: <20080421210935.460817943@goodmis.org>
	<20080421212128.201844090@goodmis.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008 17:09:36 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> This patch sets up the infrastructure to record overruns of the tracing
> buffer.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/trace.c |   16 +++++++++++-----
>  kernel/trace/trace.h |    6 +++++-
>  2 files changed, 16 insertions(+), 6 deletions(-)
> 
> Index: linux-sched-devel.git/kernel/trace/trace.c
> ===================================================================
> --- linux-sched-devel.git.orig/kernel/trace/trace.c	2008-04-21 13:47:30.000000000 -0400
> +++ linux-sched-devel.git/kernel/trace/trace.c	2008-04-21 14:39:43.000000000 -0400
> @@ -612,6 +612,7 @@ void unregister_tracer(struct tracer *ty
>  void tracing_reset(struct trace_array_cpu *data)
>  {
>  	data->trace_idx = 0;
> +	data->overrun = 0;
>  	data->trace_head = data->trace_tail = head_page(data);
>  	data->trace_head_idx = 0;
>  	data->trace_tail_idx = 0;
> @@ -753,6 +754,7 @@ tracing_get_trace_entry(struct trace_arr
>  	if (data->trace_head == data->trace_tail &&
>  	    idx_next == data->trace_tail_idx) {
>  		/* overrun */
> +		data->overrun++;
>  		data->trace_tail_idx++;
>  		if (data->trace_tail_idx >= ENTRIES_PER_PAGE) {
>  			data->trace_tail =
...
> @@ -2510,6 +2511,11 @@ tracing_read_pipe(struct file *filp, cha
>  	for_each_cpu_mask(cpu, mask) {
>  		data = iter->tr->data[cpu];
>  		__raw_spin_lock(&data->lock);
> +
> +		if (data->overrun > iter->last_overrun[cpu])
> +			iter->overrun[cpu] +=
> +				data->overrun - iter->last_overrun[cpu];
> +		iter->last_overrun[cpu] = data->overrun;

Option 1: move this code earlier.
(Could also remove the `if' and make it unconditional.)

>  	}
>  
>  	while (find_next_entry_inc(iter) != NULL) {
> Index: linux-sched-devel.git/kernel/trace/trace.h
> ===================================================================
> --- linux-sched-devel.git.orig/kernel/trace/trace.h	2008-04-21 13:47:30.000000000 -0400
> +++ linux-sched-devel.git/kernel/trace/trace.h	2008-04-21 14:38:09.000000000 -0400
> @@ -102,6 +102,7 @@ struct trace_array_cpu {
>  	void			*trace_head; /* producer */
>  	void			*trace_tail; /* consumer */
>  	unsigned long		trace_idx;
> +	unsigned long		overrun;

Option 2: Change this into atomic_t.

>  	unsigned long		saved_latency;
>  	unsigned long		critical_start;
>  	unsigned long		critical_end;
> @@ -162,10 +163,13 @@ struct trace_seq {
>   * results to users and which routines might sleep, etc:
>   */
>  struct trace_iterator {
> -	struct trace_seq	seq;
>  	struct trace_array	*tr;
>  	struct tracer		*trace;
> +	long			last_overrun[NR_CPUS];
> +	long			overrun[NR_CPUS];

The problem with these fields is that they are updated only after the read
hook has been called in tracing_read_pipe(), which means all "N events
lost!" entries will be one read call behind. This can be any number of
events.

If trace_array_cpu::overrun was atomic_t, I could process that in
the read callback. But, trace_iterator::overrun would be good, because
I could just reset it to zero every time I encounter a non-zero value.

I can think of two options, the ones noted above: moving the update
earlier, or using atomic_t. Or maybe do both, so that we don't have to
lock the trace_array_cpu structs early and also avoid duplicating the
overrun/last_overrun logic in a tracer.

What shall we do?


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
