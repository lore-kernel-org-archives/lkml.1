Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbZEGI1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbZEGI1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZEGI1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:27:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50035 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbZEGI1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:27:35 -0400
Date: Thu, 7 May 2009 10:27:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/7] ring-buffer: make moving the tail page a separate
	function
Message-ID: <20090507082717.GF12285@elte.hu>
References: <20090507031335.815354104@goodmis.org> <20090507031434.018038090@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507031434.018038090@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Ingo Molnar thought the code would be cleaner if we used a function call
> instead of a goto for moving the tail page. After implementing this,
> it seems that gcc still inlines the result and the output is pretty much
> the same. Since this is considered a cleaner approach, might as well
> implement it.
> 
> [ Impact: code clean up ]
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/ring_buffer.c |   89 ++++++++++++++++++++++++--------------------
>  1 files changed, 49 insertions(+), 40 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 03ed52b..3ae5ccf 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1154,51 +1154,18 @@ static unsigned rb_calculate_event_length(unsigned length)
>  	return length;
>  }
>  
> +
>  static struct ring_buffer_event *
> -__rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
> -		  unsigned type, unsigned long length, u64 *ts)
> +rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
> +	     unsigned long length, unsigned long tail,
> +	     struct buffer_page *commit_page,
> +	     struct buffer_page *tail_page, u64 *ts)
>  {
> -	struct buffer_page *tail_page, *head_page, *reader_page, *commit_page;
> -	struct buffer_page *next_page;
> -	unsigned long tail, write;
> +	struct buffer_page *next_page, *head_page, *reader_page;
>  	struct ring_buffer *buffer = cpu_buffer->buffer;
>  	struct ring_buffer_event *event;
> -	unsigned long flags;
>  	bool lock_taken = false;
> -
> -	commit_page = cpu_buffer->commit_page;
> -	/* we just need to protect against interrupts */
> -	barrier();
> -	tail_page = cpu_buffer->tail_page;
> -	write = local_add_return(length, &tail_page->write);
> -	tail = write - length;
> -
> -	/* See if we shot pass the end of this buffer page */
> -	if (write > BUF_PAGE_SIZE)
> -		goto next_page;
> -
> -	/* We reserved something on the buffer */
> -
> -	if (RB_WARN_ON(cpu_buffer, write > BUF_PAGE_SIZE))
> -		return NULL;
> -
> -	event = __rb_page_index(tail_page, tail);
> -	rb_update_event(event, type, length);
> -
> -	/* The passed in type is zero for DATA */
> -	if (likely(!type))
> -		local_inc(&tail_page->entries);
> -
> -	/*
> -	 * If this is a commit and the tail is zero, then update
> -	 * this page's time stamp.
> -	 */
> -	if (!tail && rb_is_commit(cpu_buffer, event))
> -		cpu_buffer->commit_page->page->time_stamp = *ts;
> -
> -	return event;
> -
> - next_page:
> +	unsigned long flags;
>  
>  	next_page = tail_page;
>  
> @@ -1318,6 +1285,48 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
>  	return NULL;
>  }
>  
> +static struct ring_buffer_event *
> +__rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
> +		  unsigned type, unsigned long length, u64 *ts)
> +{
> +	struct buffer_page *tail_page, *commit_page;
> +	struct ring_buffer_event *event;
> +	unsigned long tail, write;
> +
> +	commit_page = cpu_buffer->commit_page;
> +	/* we just need to protect against interrupts */
> +	barrier();
> +	tail_page = cpu_buffer->tail_page;
> +	write = local_add_return(length, &tail_page->write);
> +	tail = write - length;
> +
> +	/* See if we shot pass the end of this buffer page */
> +	if (write > BUF_PAGE_SIZE)
> +		return rb_move_tail(cpu_buffer, length, tail,
> +				    commit_page, tail_page, ts);

Nice! The __rb_reserve_next() fast-path logic became a lot clearer.

The above branch might be unlikely(), right? With usual record sizes 
of around 40 bytes, we'll have a 100 records for every page 
overflow. That's i think within the reach of unlikely().

Depends on how much of a mess GCC makes of it though.

	Ingo
