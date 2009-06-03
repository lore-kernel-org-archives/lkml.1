Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZFCU4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZFCU4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 16:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbZFCU4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 16:56:36 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:14041 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbZFCU4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 16:56:35 -0400
X-SpamScore: -25
X-BigFish: VPS-25(zz1432R98dR1805Mzz1202hzzz2fh6bh17ch)
X-FB-SS: 5,13,
Message-ID: <4A26E358.4030508@am.sony.com>
Date: Wed, 3 Jun 2009 13:55:52 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/3] ring-buffer: try to discard unneeded timestamps
References: <20090603141605.001049251@goodmis.org> <20090603141651.231310727@goodmis.org>
In-Reply-To: <20090603141651.231310727@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2009 20:55:53.0142 (UTC) FILETIME=[AED3FD60:01C9E48D]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve,

See my last comment for an important fix.

Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> There are times that a race may happen that we add a timestamp in a
> nested write. This timestamp would just contain a zero delta and serves
> no purpose.
> 
> Now that we have a way to discard events, this patch will try to discard
> the timestamp instead of just wasting the space in the ring buffer.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/ring_buffer.c |   67 +++++++++++++++++++++++++++-----------------
>  1 files changed, 41 insertions(+), 26 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 9453023..5092660 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1335,6 +1335,38 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
>  	return event;
>  }
>  
> +static inline int
> +rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
> +		  struct ring_buffer_event *event)

It might be worth using the terminology 'rb_try_to_free' (or something else)
to distinguish the case of backing up the write pointer from the
case of marking an event as discarded (pad) in the log.

> +{
> +	unsigned long new_index, old_index;
> +	struct buffer_page *bpage;
> +	unsigned long index;
> +	unsigned long addr;
> +
> +	new_index = rb_event_index(event);
> +	old_index = new_index + rb_event_length(event);
> +	addr = (unsigned long)event;
> +	addr &= PAGE_MASK;
> +
> +	bpage = cpu_buffer->tail_page;
> +
> +	if (bpage->page == (void *)addr && rb_page_write(bpage) == old_index) {
> +		/*
> +		 * This is on the tail page. It is possible that
> +		 * a write could come in and move the tail page
> +		 * and write to the next page. That is fine
> +		 * because we just shorten what is on this page.
> +		 */
> +		index = local_cmpxchg(&bpage->write, old_index, new_index);
> +		if (index == old_index)
> +			return 1;
> +	}
> +
> +	/* could not discard */
> +	return 0;
> +}
> +
>  static int
>  rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
>  		  u64 *ts, u64 *delta)
> @@ -1384,10 +1416,13 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
>  		/* let the caller know this was the commit */
>  		ret = 1;
>  	} else {
> -		/* Darn, this is just wasted space */
> -		event->time_delta = 0;
> -		event->array[0] = 0;
> -		ret = 0;
> +		/* Try to discard the event */
> +		if (!rb_try_to_discard(cpu_buffer, event)) {
> +			/* Darn, this is just wasted space */
> +			event->time_delta = 0;
> +			event->array[0] = 0;
> +			ret = 0;
> +		}
>  	}
>  
>  	*delta = 0;
> @@ -1682,10 +1717,6 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
>  				struct ring_buffer_event *event)
>  {
>  	struct ring_buffer_per_cpu *cpu_buffer;
> -	unsigned long new_index, old_index;
> -	struct buffer_page *bpage;
> -	unsigned long index;
> -	unsigned long addr;
>  	int cpu;
>  
>  	/* The event is discarded regardless */
> @@ -1701,24 +1732,8 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
>  	cpu = smp_processor_id();
>  	cpu_buffer = buffer->buffers[cpu];
>  
> -	new_index = rb_event_index(event);
> -	old_index = new_index + rb_event_length(event);
> -	addr = (unsigned long)event;
> -	addr &= PAGE_MASK;
> -
> -	bpage = cpu_buffer->tail_page;
> -
> -	if (bpage->page == (void *)addr && rb_page_write(bpage) == old_index) {
> -		/*
> -		 * This is on the tail page. It is possible that
> -		 * a write could come in and move the tail page
> -		 * and write to the next page. That is fine
> -		 * because we just shorten what is on this page.
> -		 */
> -		index = local_cmpxchg(&bpage->write, old_index, new_index);
> -		if (index == old_index)
> -			goto out;
> -	}
> +	if (!rb_try_to_discard(cpu_buffer, event))
> +		goto out;

The sense of this test is wrong.  It should be:

	if (rb_try_to_discard(cpu_buffer, event))
		goto out;

You want to go to 'out' (skipping the increment of entries)
if you successfully freed the event.

In my testing, rb_try_to_discard was almost alway successful.
Since only one statement is jumped over by the goto, the
following might be better:

	if (unlikely(!rb_try_to_discard(cpu_buffer, event)))
		/*
		 * The commit is still visible by the reader, so we
		 * must increment entries.
		 */
		local_inc(&cpu_buffer->entries);
	

>  	/*
>  	 * The commit is still visible by the reader, so we
> -- 1.6.3.1
> -- 


-- 
=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

