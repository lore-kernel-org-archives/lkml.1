Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZBISYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZBISYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbZBISYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:24:38 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:43734 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbZBISYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:24:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TIPDwIt4ih9meXWWriCgJncrglPj9VzGg+wvxTiN2WioLGmW/wVa+pSYxnWs1xJQrH
         7zsvb3ECRav+wNmFhn7jRX6/uys3kFzluNCZVCz+am0nMCY4/7cdt8rxN33qLW2U1xl9
         TLi85cpF9w5M5Y0l7ufr37Ua2IUgzQrr9eyQA=
Date: Mon, 9 Feb 2009 20:25:01 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] tracing: clean up splice code
Message-ID: <20090209182500.GA5283@localhost>
References: <20090209172830.087244662@goodmis.org> <20090209172956.970104543@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209172956.970104543@goodmis.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 12:28:33PM -0500, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Ingo Molnar suggested a series of clean ups for the splice code.
> This patch implements those suggestions.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/trace.c |   96 ++++++++++++++++++++++++++++---------------------
>  1 files changed, 55 insertions(+), 41 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 11fde0a..d898212 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2537,15 +2537,49 @@ static void tracing_spd_release_pipe(struct splice_pipe_desc *spd,
>  }
>  
>  static struct pipe_buf_operations tracing_pipe_buf_ops = {
> -	.can_merge = 0,
> -	.map = generic_pipe_buf_map,
> -	.unmap = generic_pipe_buf_unmap,
> -	.confirm = generic_pipe_buf_confirm,
> -	.release = tracing_pipe_buf_release,
> -	.steal = generic_pipe_buf_steal,
> -	.get = generic_pipe_buf_get,
> +	.can_merge		= 0,
> +	.map			= generic_pipe_buf_map,
> +	.unmap			= generic_pipe_buf_unmap,
> +	.confirm		= generic_pipe_buf_confirm,
> +	.release		= tracing_pipe_buf_release,
> +	.steal			= generic_pipe_buf_steal,
> +	.get			= generic_pipe_buf_get,
>  };
>  
> +static size_t
> +tracing_fill_pipe_page(struct page *pages, size_t rem,
> +			struct trace_iterator *iter)
> +{
> +	size_t count;
> +	int ret;
> +
> +	/* Seq buffer is page-sized, exactly what we need. */
> +	for (;;) {
> +		count = iter->seq.len;
> +		ret = print_trace_line(iter);
> +		count = iter->seq.len - count;
> +		if (rem < count) {
> +			rem = 0;
> +			iter->seq.len -= count;
> +			break;
> +		}
> +		if (ret == TRACE_TYPE_PARTIAL_LINE) {
> +			iter->seq.len -= count;
> +			break;
> +		}
> +
> +		trace_consume(iter);
> +		rem -= count;
> +		if (!find_next_entry_inc(iter))	{
> +			rem = 0;
> +			iter->ent = NULL;
> +			break;
> +		}
> +	}
> +
> +	return rem;
> +}
> +
>  static ssize_t tracing_splice_read_pipe(struct file *filp,
>  					loff_t *ppos,
>  					struct pipe_inode_info *pipe,
> @@ -2556,15 +2590,15 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
>  	struct partial_page partial[PIPE_BUFFERS];
>  	struct trace_iterator *iter = filp->private_data;
>  	struct splice_pipe_desc spd = {
> -		.pages = pages,
> -		.partial = partial,
> -		.nr_pages = 0, /* This gets updated below. */
> -		.flags = flags,
> -		.ops = &tracing_pipe_buf_ops,
> -		.spd_release = tracing_spd_release_pipe,
> +		.pages		= pages,
> +		.partial	= partial,
> +		.nr_pages	= 0, /* This gets updated below. */
> +		.flags		= flags,
> +		.ops		= &tracing_pipe_buf_ops,
> +		.spd_release	= tracing_spd_release_pipe,
>  	};
>  	ssize_t ret;
> -	size_t count, rem;
> +	size_t rem;
>  	unsigned int i;
>  
>  	mutex_lock(&trace_types_lock);
> @@ -2573,45 +2607,25 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
>  		ret = iter->trace->splice_read(iter, filp,
>  					       ppos, pipe, len, flags);
>  		if (ret)
> -			goto out;
> +			goto out_err;
>  	}
>  
>  	ret = tracing_wait_pipe(filp);
>  	if (ret <= 0)
> -		goto out;
> +		goto out_err;
>  
>  	if (!iter->ent && !find_next_entry_inc(iter)) {
>  		ret = -EFAULT;
> -		goto out;
> +		goto out_err;
>  	}
>  
>  	/* Fill as many pages as possible. */
>  	for (i = 0, rem = len; i < PIPE_BUFFERS && rem; i++) {
>  		pages[i] = alloc_page(GFP_KERNEL);
> +		if (!pages[i])
> +			break;

I believe you should decrement 'i' before breaking, since we fill
spd.nr_pages just after the loop. In case the current page couldn't be
allocated, spd.nr_pages will be one too many (that is, 'i').

>  
> -		/* Seq buffer is page-sized, exactly what we need. */
> -		for (;;) {
> -			count = iter->seq.len;
> -			ret = print_trace_line(iter);
> -			count = iter->seq.len - count;
> -			if (rem < count) {
> -				rem = 0;
> -				iter->seq.len -= count;
> -				break;
> -			}
> -			if (ret == TRACE_TYPE_PARTIAL_LINE) {
> -				iter->seq.len -= count;
> -				break;
> -			}
> -
> -			trace_consume(iter);
> -			rem -= count;
> -			if (!find_next_entry_inc(iter))	{
> -				rem = 0;
> -				iter->ent = NULL;
> -				break;
> -			}
> -		}
> +		rem = tracing_fill_pipe_page(pages[i], rem, iter);
>  
>  		/* Copy the data into the page, so we can start over. */
>  		ret = trace_seq_to_buffer(&iter->seq,
> @@ -2633,7 +2647,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
>  
>  	return splice_to_pipe(pipe, &spd);
>  
> -out:
> +out_err:
>  	mutex_unlock(&trace_types_lock);
>  
>  	return ret;
> -- 
> 1.5.6.5
> 
> -- 

Otherwise, it looks okay to me.


	Thanks,
	Eduard

