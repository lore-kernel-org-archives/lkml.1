Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbZAEPJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbZAEPJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbZAEPJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:09:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57711 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbZAEPJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:09:45 -0500
Subject: Re: [PATCH] Fix race in ring_buffer_consume(): Replace
	ring_buffer_consume and ring_buffer_peek with ring_buffer_get_event
From: Steven Rostedt <srostedt@redhat.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1230536044-14847-1-git-send-email-indan@nul.nu>
References: <54882.124.179.251.206.1230523141.squirrel@secure.greenhost.nl>
	 <1230536044-14847-1-git-send-email-indan@nul.nu>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 05 Jan 2009 10:09:36 -0500
Message-Id: <1231168176.15476.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-12-29 at 18:34 +1100, Indan Zupancic wrote:
> Original mail was mangled, patch resent via git.
> 

Indan,

I like the patch except for one thing. Could you make the
ring_buffer_get_event into a static function called rb_get_event. And
then you could have:

struct ring_buffer_event *
ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
{
	rb_get_event(buffer, cpu, ts, 0);
}

struct ring_buffer_event *
ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
{
	rb_get_event(buffer, cpu, ts, 1);
}

I just hate public functions that have flags that can get confusing.
Looking at code where I see:

	ring_buffer_get_event(buffer, cpu, ts, 0);

I find it hard to know if the ",0" is correct or should be a ",1"
instead.

This would also make the patch only need to touch ring_buffer.c and not
all the places that use it.

Thanks,

-- Steve


> Signed-off-by: Indan Zupancic <indan@nul.nu>
> ---
>  include/linux/ring_buffer.h   |    4 +---
>  kernel/trace/ring_buffer.c    |   39 ++++++++-------------------------------
>  kernel/trace/trace.c          |   15 ++++++++-------
>  kernel/trace/trace_selftest.c |    2 +-
>  4 files changed, 18 insertions(+), 42 deletions(-)
> 
> diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
> index e097c2e..d9320bd 100644
> --- a/include/linux/ring_buffer.h
> +++ b/include/linux/ring_buffer.h
> @@ -83,9 +83,7 @@ int ring_buffer_write(struct ring_buffer *buffer,
>  		      unsigned long length, void *data);
>  
>  struct ring_buffer_event *
> -ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts);
> -struct ring_buffer_event *
> -ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts);
> +ring_buffer_get_event(struct ring_buffer *buffer, int cpu, u64 *ts, int consume);
>  
>  struct ring_buffer_iter *
>  ring_buffer_read_start(struct ring_buffer *buffer, int cpu);
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 668bbb5..d4e5dbc 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1727,16 +1727,18 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
>  }
>  
>  /**
> - * ring_buffer_peek - peek at the next event to be read
> + * ring_buffer_get_event - get the next event to be read
>   * @buffer: The ring buffer to read
>   * @cpu: The cpu to peak at
>   * @ts: The timestamp counter of this event.
> + * @consume: Whether the event should be consumed.
> + * If true, sequential reads will keep returning a different event,
> + * and eventually empty the ring buffer if the producer is slower.
>   *
> - * This will return the event that will be read next, but does
> - * not consume the data.
> + * This will return the event that will be read next.
>   */
>  struct ring_buffer_event *
> -ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
> +ring_buffer_get_event(struct ring_buffer *buffer, int cpu, u64 *ts, int consume)
>  {
>  	struct ring_buffer_per_cpu *cpu_buffer;
>  	struct ring_buffer_event *event;
> @@ -1789,6 +1791,8 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
>  			*ts = cpu_buffer->read_stamp + event->time_delta;
>  			ring_buffer_normalize_time_stamp(cpu_buffer->cpu, ts);
>  		}
> +		if (consume)
> +			rb_advance_reader(cpu_buffer);
>  		return event;
>  
>  	default:
> @@ -1869,33 +1873,6 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
>  }
>  
>  /**
> - * ring_buffer_consume - return an event and consume it
> - * @buffer: The ring buffer to get the next event from
> - *
> - * Returns the next event in the ring buffer, and that event is consumed.
> - * Meaning, that sequential reads will keep returning a different event,
> - * and eventually empty the ring buffer if the producer is slower.
> - */
> -struct ring_buffer_event *
> -ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
> -{
> -	struct ring_buffer_per_cpu *cpu_buffer;
> -	struct ring_buffer_event *event;
> -
> -	if (!cpu_isset(cpu, buffer->cpumask))
> -		return NULL;
> -
> -	event = ring_buffer_peek(buffer, cpu, ts);
> -	if (!event)
> -		return NULL;
> -
> -	cpu_buffer = buffer->buffers[cpu];
> -	rb_advance_reader(cpu_buffer);
> -
> -	return event;
> -}
> -
> -/**
>   * ring_buffer_read_start - start a non consuming read of the buffer
>   * @buffer: The ring buffer to read from
>   * @cpu: The cpu buffer to iterate over
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index d86e325..f1329ed 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -938,7 +938,7 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
>  	if (buf_iter)
>  		event = ring_buffer_iter_peek(buf_iter, ts);
>  	else
> -		event = ring_buffer_peek(iter->tr->buffer, cpu, ts);
> +		event = ring_buffer_get_event(iter->tr->buffer, cpu, ts, 0);
>  
>  	ftrace_enable_cpu();
>  
> @@ -1002,7 +1002,7 @@ static void trace_consume(struct trace_iterator *iter)
>  {
>  	/* Don't allow ftrace to trace into the ring buffers */
>  	ftrace_disable_cpu();
> -	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts);
> +	ring_buffer_get_event(iter->tr->buffer, iter->cpu, &iter->ts, 1);
>  	ftrace_enable_cpu();
>  }
>  
> @@ -1310,8 +1310,9 @@ void trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
>  	struct trace_entry *ent;
>  	struct trace_field_cont *cont;
>  	bool ok = true;
> +	int cpu = iter->cpu;
>  
> -	ent = peek_next_entry(iter, iter->cpu, NULL);
> +	ent = peek_next_entry(iter, cpu, NULL);
>  	if (!ent || ent->type != TRACE_CONT) {
>  		trace_seq_putc(s, '\n');
>  		return;
> @@ -1324,14 +1325,14 @@ void trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
>  
>  		ftrace_disable_cpu();
>  
> -		if (iter->buffer_iter[iter->cpu])
> -			ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
> +		if (iter->buffer_iter[cpu])
> +			ring_buffer_read(iter->buffer_iter[cpu], NULL);
>  		else
> -			ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL);
> +			ring_buffer_get_event(iter->tr->buffer, cpu, NULL, 1);
>  
>  		ftrace_enable_cpu();
>  
> -		ent = peek_next_entry(iter, iter->cpu, NULL);
> +		ent = peek_next_entry(iter, cpu, NULL);
>  	} while (ent && ent->type == TRACE_CONT);
>  
>  	if (!ok)
> diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> index 90bc752..3894989 100644
> --- a/kernel/trace/trace_selftest.c
> +++ b/kernel/trace/trace_selftest.c
> @@ -23,7 +23,7 @@ static int trace_test_buffer_cpu(struct trace_array *tr, int cpu)
>  	struct ring_buffer_event *event;
>  	struct trace_entry *entry;
>  
> -	while ((event = ring_buffer_consume(tr->buffer, cpu, NULL))) {
> +	while ((event = ring_buffer_get_event(tr->buffer, cpu, NULL, 1))) {
>  		entry = ring_buffer_event_data(event);
>  
>  		if (!trace_valid_entry(entry)) {

