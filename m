Return-Path: <linux-kernel-owner+w=401wt.eu-S1754354AbYJDAdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbYJDAdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 20:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYJDAcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 20:32:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57862 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbYJDAcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 20:32:54 -0400
Date: Fri, 3 Oct 2008 20:32:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arjan van de Ven <arjan@infradead.org>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: Add a C-state tracer to help power
 optimization
In-Reply-To: <20081003165533.249261b1@infradead.org>
Message-ID: <alpine.DEB.1.10.0810032003140.17863@gandalf.stny.rr.com>
References: <20081003165533.249261b1@infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Arjan,

Very nice! I just have a few comments below.

On Fri, 3 Oct 2008, Arjan van de Ven wrote:
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index a921ba5..1ef1ded 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -117,6 +117,11 @@ struct trace_boot {
>  	struct boot_trace	initcall;
>  };
>  
> +struct trace_cstate {
> +	struct trace_entry	ent;
> +	struct cstate_trace	state_data;
> +};
> +

Can you please register this in the trace_assign_type macro.

	IF_ASSIGN(var, ent, struct trace_cstate, TRACE_BOOT); \



>  /*
>   * trace_flag_type is an enumeration that holds different
>   * states when a trace occurs. These are:
> diff --git a/kernel/trace/trace_cstate.c b/kernel/trace/trace_cstate.c
> new file mode 100644
> index 0000000..fcd4e6e
> --- /dev/null
> +++ b/kernel/trace/trace_cstate.c


> +static enum print_line_t cstate_print_line(struct trace_iterator *iter)
> +{
> +	int ret;
> +	struct trace_entry *entry = iter->ent;
> +	struct trace_cstate *field = (struct trace_cstate *)entry;

And here, do not typecast. Use the trace_assign_type macro below.

> +	struct cstate_trace *it = &field->state_data;
> +	struct trace_seq *s = &iter->seq;
> +	struct timespec stamp = ktime_to_timespec(it->stamp);

Also note that iter->ts holds a timestamp counter from bootup in nanosecs.
It currently uses the sched_clock to record, but may change later to 
something a bit better.

> +	struct timespec duration = ktime_to_timespec(
> +					ktime_sub(it->end, it->stamp));


	trace_assign_type(field, entry);

The above will do a typecheck to force correct types.

But, you may not need to do any of this. See below.

> +
> +	if (entry->type == TRACE_BOOT) {
> +		ret = trace_seq_printf(s, "[%5ld.%09ld] Going to C%i on cpu %i for %ld.%09ld\n",
> +					  stamp.tv_sec,
> +					  stamp.tv_nsec,
> +					  it->state, it->CPU,
> +					  duration.tv_sec,
> +					  duration.tv_nsec);
> +		if (!ret)
> +			return TRACE_TYPE_PARTIAL_LINE;
> +		return TRACE_TYPE_HANDLED;
> +	}
> +	return TRACE_TYPE_UNHANDLED;
> +}
> +
> +struct tracer cstate_tracer __read_mostly =
> +{
> +	.name		= "cstate",
> +	.init		= cstate_trace_init,
> +	.reset		= stop_cstate_trace,
> +	.ctrl_update	= cstate_trace_ctrl_update,
> +	.print_line	= cstate_print_line,

Here you bypass the print_line altogether. You really don't even need
to make a trace_cstate. You do not use any of the data in the entry field
so you can simply just store your cstate_trace data directly into the 
buffer.  The entry is only used for ftrace formatted prints.


> +};
> +
> +static int init_cstate_trace(void)
> +{
> +	return register_tracer(&cstate_tracer);
> +}
> +device_initcall(init_cstate_trace);
> +
> +void trace_cstate(struct cstate_trace *it, int level)
> +{
> +	struct ring_buffer_event *event;
> +	struct trace_cstate *entry;
> +	struct trace_array_cpu *data;
> +	unsigned long irq_flags;
> +	struct trace_array *tr = cstate_trace;
> +
> +	if (!trace_cstate_enabled)
> +		return;
> +
> +	it->state = level;
> +	preempt_disable();
> +	it->CPU = smp_processor_id();

You don't need to copy the smp_processor_id. Since all the buffers are
per_cpu, the cpu id is passed into your print_line via the iter
structure.

  iter->cpu is the cpu that this entry was recorded on.


> +	data = tr->data[smp_processor_id()];

You don't need the above 'data' structure, unless you want to use it
to prevent being reentrant. But you currently dont.

> +
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> +					 &irq_flags);
> +	if (!event)
> +		goto out;
> +	entry	= ring_buffer_event_data(event);
> +	tracing_generic_entry_update(&entry->ent, 0);
> +	entry->ent.type = TRACE_BOOT;

It doesn't look like you use any of the trace_entry structure. You can 
just store your normal structure, since you bypass the output with you 
print_line function.

	struct cstate_trace *entry;

	[...]

	entry = ring_buffer_event_data(event);
	*entry = *it;
	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
	

-- Steve

> +	entry->state_data = *it;
> +	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +
> +	trace_wake_up();
> +
> + out:
> +	preempt_enable();
> +}
> -- 
> 1.5.5.1
> 
> 
> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org
> 
