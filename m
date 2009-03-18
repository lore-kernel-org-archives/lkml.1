Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbZCRBVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbZCRBVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 21:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbZCRBVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 21:21:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58994 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbZCRBVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 21:21:05 -0400
Date: Tue, 17 Mar 2009 21:21:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tom Zanussi <tzanussi@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [RFC][PATCH 2/4] tracing: add rb_event_discard() hack
In-Reply-To: <1237271018.8033.150.camel@charm-linux>
Message-ID: <alpine.DEB.2.00.0903172108160.10610@gandalf.stny.rr.com>
References: <1237271018.8033.150.camel@charm-linux>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Mar 2009, Tom Zanussi wrote:

> This patch overloads RINGBUF_TYPE_PADDING to provide a way to discard
> events from the ring buffer, for the event-filtering mechanism
> introduced in a subsequent patch.
> 
> NOTE: this patch is a true hack and will likely either eventually crash
> your machine or result in an endless loop of printed events.  But it
> sometimes works, enough to show that the filtering apparently does what
> it should.
> 
> I'm posting it only to solicit comments from any ringbuffer gurus who
> might know know how to do it correctly, or more likely could suggest a
> better approach.

Actually, we can make this work. Just some tweaks. I may take this patch, 
and massage it up to something that will work.

> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> 
> ---
>  include/linux/ring_buffer.h |    9 ++++-
>  kernel/trace/ring_buffer.c  |   73 ++++++++++++++++++++++++++++++-------------
>  2 files changed, 58 insertions(+), 24 deletions(-)
> 
> diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
> index b237e20..4292774 100644
> --- a/include/linux/ring_buffer.h
> +++ b/include/linux/ring_buffer.h
> @@ -22,10 +22,13 @@ struct ring_buffer_event {
>  /**
>   * enum ring_buffer_type - internal ring buffer types
>   *
> - * @RINGBUF_TYPE_PADDING:	Left over page padding
> + * @RINGBUF_TYPE_PADDING:	Left over page padding or discarded event
>   *				 array is ignored
> - *				 size is variable depending on how much
> + *				 If time_delta is 0:
> + *				  size is variable depending on how much
>   *				  padding is needed
> + *				 If time_delta is 1:
> + *				  everything else same as RINGBUF_TYPE_DATA

I would make array not ignored, unless all is zero, then everything
would be ignored. That is, the true padding would just be zeroed out.

>   *
>   * @RINGBUF_TYPE_TIME_EXTEND:	Extend the time delta
>   *				 array[0] = time delta (28 .. 59)
> @@ -69,6 +72,8 @@ ring_buffer_event_time_delta(struct ring_buffer_event *event)
>  	return event->time_delta;
>  }
>  
> +void rb_event_discard(struct ring_buffer_event *event);

Note, the "rb_" prefix is only used for static functions since we can get
into name space collisions with rbtree. Functions that are global outside
this file have the "ring_buffer_" prefix.

> +
>  /*
>   * size is in bytes for each per CPU buffer.
>   */
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 1d3b07d..c59e910 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -213,16 +213,50 @@ enum {
>  	RB_LEN_TIME_STAMP = 16,
>  };
>  
> -/* inline for ring buffer fast paths */
> +static inline int rb_null_event(struct ring_buffer_event *event)
> +{
> +	return event->type == RINGBUF_TYPE_PADDING && event->time_delta == 0;
> +}
> +
> +static inline int rb_discarded_event(struct ring_buffer_event *event)
> +{
> +	return event->type == RINGBUF_TYPE_PADDING && event->time_delta == 1;
> +}
> +
> +static void rb_event_set_padding(struct ring_buffer_event *event)
> +{
> +	event->type = RINGBUF_TYPE_PADDING;
> +	event->time_delta = 0;
> +}

the above seems reasonable, and should work fine.

> +
> +void rb_event_discard(struct ring_buffer_event *event)
> +{
> +	event->type = RINGBUF_TYPE_PADDING;
> +	event->time_delta = 1;
> +}
> +
>  static unsigned
> -rb_event_length(struct ring_buffer_event *event)
> +rb_event_data_length(struct ring_buffer_event *event)
>  {
>  	unsigned length;
>  
> +	if (event->len)
> +		length = event->len * RB_ALIGNMENT;
> +	else
> +		length = event->array[0];
> +	return length + RB_EVNT_HDR_SIZE;
> +}
> +
> +/* inline for ring buffer fast paths */
> +static unsigned
> +rb_event_length(struct ring_buffer_event *event)
> +{
>  	switch (event->type) {
>  	case RINGBUF_TYPE_PADDING:
> -		/* undefined */
> -		return -1;
> +		if (rb_null_event(event))
> +			/* undefined */
> +			return -1;
> +		return rb_event_data_length(event);
>  
>  	case RINGBUF_TYPE_TIME_EXTEND:
>  		return RB_LEN_TIME_EXTEND;
> @@ -231,11 +265,7 @@ rb_event_length(struct ring_buffer_event *event)
>  		return RB_LEN_TIME_STAMP;
>  
>  	case RINGBUF_TYPE_DATA:
> -		if (event->len)
> -			length = event->len * RB_ALIGNMENT;
> -		else
> -			length = event->array[0];
> -		return length + RB_EVNT_HDR_SIZE;
> +		return rb_event_data_length(event);

This is all reasonable.

>  	default:
>  		BUG();
>  	}
> @@ -828,11 +858,6 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
>  }
>  EXPORT_SYMBOL_GPL(ring_buffer_resize);
>  
> -static inline int rb_null_event(struct ring_buffer_event *event)
> -{
> -	return event->type == RINGBUF_TYPE_PADDING;
> -}
> -
>  static inline void *
>  __rb_data_page_index(struct buffer_data_page *bpage, unsigned index)
>  {
> @@ -1203,7 +1228,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
>  			/* Mark the rest of the page with padding */
>  			event = __rb_page_index(tail_page, tail);
>  			kmemcheck_annotate_bitfield(event->bitfield);
> -			event->type = RINGBUF_TYPE_PADDING;
> +			rb_event_set_padding(event);
>  		}
>  
>  		if (tail <= BUF_PAGE_SIZE)
> @@ -1954,7 +1979,7 @@ static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
>  
>  	event = rb_reader_event(cpu_buffer);
>  
> -	if (event->type == RINGBUF_TYPE_DATA)
> +	if (event->type == RINGBUF_TYPE_DATA || rb_discarded_event(event))
>  		cpu_buffer->entries--;

Actually, we should decrement the entries counter at time of discard.

>  
>  	rb_update_read_stamp(cpu_buffer, event);
> @@ -2026,8 +2051,8 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
>  	 * can have.  Nesting 10 deep of interrupts is clearly
>  	 * an anomaly.
>  	 */
> -	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
> -		return NULL;
> +//	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
> +//		return NULL;

Were you hitting this? If so, we need to investigate.

>  
>  	reader = rb_get_reader_page(cpu_buffer);
>  	if (!reader)
> @@ -2037,7 +2062,8 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
>  
>  	switch (event->type) {
>  	case RINGBUF_TYPE_PADDING:
> -		RB_WARN_ON(cpu_buffer, 1);
> +		if (rb_null_event(event))
> +			RB_WARN_ON(cpu_buffer, 1);
>  		rb_advance_reader(cpu_buffer);
>  		return NULL;

Actually, we want to simply skip over the discarded event. This will cause
the above loops to hit more often. We should make the warning count be
BUFFER_PAGE_SIZE, if we hit it that many times, we know we are in trouble.

In other words, we do not want to return NULL, but we want to goto again.


>  
> @@ -2089,8 +2115,8 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
>  	 * can have. Nesting 10 deep of interrupts is clearly
>  	 * an anomaly.
>  	 */
> -	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
> -		return NULL;
> +//	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
> +//		return NULL;
>  
>  	if (rb_per_cpu_empty(cpu_buffer))
>  		return NULL;
> @@ -2099,7 +2125,10 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
>  
>  	switch (event->type) {
>  	case RINGBUF_TYPE_PADDING:
> -		rb_inc_iter(iter);
> +		if (rb_null_event(event))
> +			rb_inc_iter(iter);
> +		else
> +			rb_advance_iter(iter);
>  		goto again;

This should work.

>  
>  	case RINGBUF_TYPE_TIME_EXTEND:
> -- 
> 1.5.6.3

I'll take a look at your patch and see if I can get it to work.

Thanks,

-- Steve

