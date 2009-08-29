Return-Path: <linux-kernel-owner+w=401wt.eu-S1751544AbZH2JpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbZH2JpL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 05:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbZH2JpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 05:45:10 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:47370 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZH2JpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 05:45:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mxbbG/ArU1YKc5rVEv//ME9lYeZ7GKId8/UQRZtDZyU9x3osL6Rl3pa85cgCyYihrK
         kDFPf+en959ClYsLfpEQ6rypb0CNpRJBn+4mubtmo9l9OQog0eAWP1SlRkDwE8P8yvbt
         NfJF9GCiUZk7XeJXLjpBQsX0tEOplG6a9T7BQ=
Date: Sat, 29 Aug 2009 11:45:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing: make splice_read work when data is
	sufficient
Message-ID: <20090829094503.GA6418@nowhere>
References: <4A95F743.2090101@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A95F743.2090101@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 11:02:27AM +0800, Lai Jiangshan wrote:
> 
> If a cpu ring_buffer has some pages which can be consumed,
> but when a piece of the reader page is consumed, splice_read()
> on per_cpu/cpu#/trace_pipe_raw will read nothing.
> 
> It's a incorrect behavior. A usespace tool which uses
> splice_read() can't work when this situation occurs.
> 
> This patch changes the meaning of "full". It's not required
> the reader page is full with data. It's just required
> the reader page is full written/full committed.
> 
> So when a piece of data is consumed, the splice_read()
> still works.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index da2c59d..f1e1533 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -2782,7 +2782,7 @@ rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
>  }
>  
>  static struct buffer_page *
> -rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
> +rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer, int full)
>  {
>  	struct buffer_page *reader = NULL;
>  	unsigned long flags;
> @@ -2799,20 +2799,20 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
>  	 * a case where we will loop three times. There should be no
>  	 * reason to loop four times (that I know of).
>  	 */
> -	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 3)) {
> -		reader = NULL;
> +	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 3))
> +		goto out;
> +
> +	if (full && cpu_buffer->commit_page == cpu_buffer->reader_page)
>  		goto out;
> -	}
>  
>  	reader = cpu_buffer->reader_page;
>  
>  	/* If there's more to read, return this page */
> -	if (cpu_buffer->reader_page->read < rb_page_size(reader))
> +	if (reader->read < rb_page_size(reader))
>  		goto out;
>  
>  	/* Never should we have an index greater than the size */
> -	if (RB_WARN_ON(cpu_buffer,
> -		       cpu_buffer->reader_page->read > rb_page_size(reader)))
> +	if (RB_WARN_ON(cpu_buffer, reader->read > rb_page_size(reader)))
>  		goto out;
>  
>  	/* check if we caught up to the tail */
> @@ -2823,6 +2823,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
>  	/*
>  	 * Reset the reader page to size zero.
>  	 */
> +	cpu_buffer->reader_page->read = 0;



Wasn't this reset done before?



>  	local_set(&cpu_buffer->reader_page->write, 0);
>  	local_set(&cpu_buffer->reader_page->entries, 0);
>  	local_set(&cpu_buffer->reader_page->page->commit, 0);
> @@ -2832,6 +2833,11 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
>  	 * Splice the empty reader page into the list around the head.
>  	 */
>  	reader = rb_set_head_page(cpu_buffer);
> +	if (full && cpu_buffer->commit_page == reader) {
> +		reader = NULL;
> +		goto out;
> +	}
> +
>  	cpu_buffer->reader_page->list.next = reader->list.next;
>  	cpu_buffer->reader_page->list.prev = reader->list.prev;
>  
> @@ -2891,7 +2897,7 @@ static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
>  	struct buffer_page *reader;
>  	unsigned length;
>  
> -	reader = rb_get_reader_page(cpu_buffer);
> +	reader = rb_get_reader_page(cpu_buffer, 0);
>  
>  	/* This function should not be called when buffer is empty */
>  	if (RB_WARN_ON(cpu_buffer, !reader))
> @@ -2973,7 +2979,7 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
>  	if (RB_WARN_ON(cpu_buffer, ++nr_loops > RB_TIMESTAMPS_PER_PAGE))
>  		return NULL;
>  
> -	reader = rb_get_reader_page(cpu_buffer);
> +	reader = rb_get_reader_page(cpu_buffer, 0);
>  	if (!reader)
>  		return NULL;
>  
> @@ -3642,7 +3648,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
>  
>  	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
>  
> -	reader = rb_get_reader_page(cpu_buffer);
> +	reader = rb_get_reader_page(cpu_buffer, full);
>  	if (!reader)
>  		goto out_unlock;
>  
> @@ -3665,9 +3671,6 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
>  		unsigned int pos = 0;
>  		unsigned int size;
>  
> -		if (full)
> -			goto out_unlock;
> -
>  		if (len > (commit - read))
>  			len = (commit - read);
>  


Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>

