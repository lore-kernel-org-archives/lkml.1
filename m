Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbZBIReS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbZBIReS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbZBIReD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:34:03 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:42575 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbZBIReB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:34:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FtoUe0+yi8ACzoxSVK5u2YYSJj7mcs1fw4hY9E0akIJGwakU+HvZr1uYD3JTsA4V3S
         fkW58vhmL/NP4J3ZzGbFtc5v9dmInIV7Fyseh1mwxFjland/WESPTV+zb0Fu43TyQGQB
         Fwpr1XmDVWvOYdCpfNArxCi0sdshZpy3o/XXQ=
Date: Mon, 9 Feb 2009 18:33:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/3] tracing: Move pipe waiting code out of
	tracing_read_pipe().
Message-ID: <20090209173355.GA7471@nowhere>
References: <20090209172830.087244662@goodmis.org> <20090209172956.784717880@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209172956.784717880@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 12:28:32PM -0500, Steven Rostedt wrote:
> From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> 
> This moves the pipe waiting code from tracing_read_pipe() into
> tracing_wait_pipe(), which is useful to implement other fops, like
> splice_read.
> 
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/trace.c |   69 +++++++++++++++++++++++++++++---------------------
>  1 files changed, 40 insertions(+), 29 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 9e29fdb..11fde0a 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2388,37 +2388,15 @@ tracing_poll_pipe(struct file *filp, poll_table *poll_table)
>  	}
>  }
>  
> -/*
> - * Consumer reader.
> - */
> -static ssize_t
> -tracing_read_pipe(struct file *filp, char __user *ubuf,
> -		  size_t cnt, loff_t *ppos)
> +/* Must be called with trace_types_lock mutex held. */
> +static int tracing_wait_pipe(struct file *filp)
>  {
>  	struct trace_iterator *iter = filp->private_data;
> -	ssize_t sret;
> -
> -	/* return any leftover data */
> -	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
> -	if (sret != -EBUSY)
> -		return sret;
> -
> -	trace_seq_reset(&iter->seq);
>  
> -	mutex_lock(&trace_types_lock);
> -	if (iter->trace->read) {
> -		sret = iter->trace->read(iter, filp, ubuf, cnt, ppos);
> -		if (sret)
> -			goto out;
> -	}
> -
> -waitagain:
> -	sret = 0;
>  	while (trace_empty(iter)) {
>  
>  		if ((filp->f_flags & O_NONBLOCK)) {
> -			sret = -EAGAIN;
> -			goto out;
> +			return -EAGAIN;
>  		}
>  
>  		/*
> @@ -2443,12 +2421,11 @@ waitagain:
>  		iter->tr->waiter = NULL;
>  
>  		if (signal_pending(current)) {
> -			sret = -EINTR;
> -			goto out;
> +			return -EINTR;
>  		}
>  
>  		if (iter->trace != current_trace)
> -			goto out;
> +			return 0;
>  
>  		/*
>  		 * We block until we read something and tracing is disabled.
> @@ -2465,9 +2442,43 @@ waitagain:
>  		continue;
>  	}
>  
> +	return 1;
> +}
> +
> +/*
> + * Consumer reader.
> + */
> +static ssize_t
> +tracing_read_pipe(struct file *filp, char __user *ubuf,
> +		  size_t cnt, loff_t *ppos)
> +{
> +	struct trace_iterator *iter = filp->private_data;
> +	ssize_t sret;
> +
> +	/* return any leftover data */
> +	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
> +	if (sret != -EBUSY)
> +		return sret;
> +
> +	trace_seq_reset(&iter->seq);
> +
> +	mutex_lock(&trace_types_lock);
> +	if (iter->trace->read) {
> +		sret = iter->trace->read(iter, filp, ubuf, cnt, ppos);
> +		if (sret)
> +			goto out;
> +	}
> +
> +waitagain:
> +	sret = tracing_wait_pipe(filp);
> +	if (sret <= 0)
> +		goto out;
> +
>  	/* stop when tracing is finished */
> -	if (trace_empty(iter))
> +	if (trace_empty(iter)) {
> +		sret = 0;
>  		goto out;
> +	}
>  
>  	if (cnt >= PAGE_SIZE)
>  		cnt = PAGE_SIZE - 1;
> -- 
> 1.5.6.5
> 
> -- 

Hmm, ok I will base my changes on top of your tree.
I finally chose to use the common waiting interface, with an
exception concerning sched_switch, function and function_graph.

Even if this can be racy when the tracer is switched, we have a security
inside trace_wake_up().

