Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677Ab0ATSA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab0ATSA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 13:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875Ab0ATSA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 13:00:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:62418 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab0ATSAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 13:00:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xAUPAcSb1RkUxlGfuIL6CBc9OURL6L4LwK4axfv1Da9kN2SvKebSKt9bPwH6jZDCnL
         K7U8n0ymGd3GaZFr4wMaNoI/UiAHL3Ab7g7CPqiSyMHCiOrXmvWNKBKZoB5ZEUDVq1wy
         +7DoTfDoy7dyl68gh5xxoLQsf14QYZrdd0AjA=
Date: Wed, 20 Jan 2010 19:00:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/6] tracing: tracing_stats_read() uses simple buffer
	instead of trace_seq
Message-ID: <20100120180019.GB5017@nowhere>
References: <4B556070.6000204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B556070.6000204@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 03:34:08PM +0800, Lai Jiangshan wrote:
> 
> It seems that struct trace_seq is too heavy for tracing_stats_read().
> we use simple buffer instead of struct trace_seq.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 27fecf8..aa1cd92 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3807,27 +3807,22 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
>  {
>  	unsigned long cpu = (unsigned long)filp->private_data;
>  	struct trace_array *tr = &global_trace;
> -	struct trace_seq *s;
>  	unsigned long cnt;
>  
> -	s = kmalloc(sizeof(*s), GFP_KERNEL);
> -	if (!s)
> -		return -ENOMEM;
> -
> -	trace_seq_init(s);
> +	unsigned char buf[128];



No problem with the conversion. But perhaps keep using a dynamic
buffer as 128 is a bit big for a kernel stack.


> +	int len = 0;
>  
>  	cnt = ring_buffer_entries_cpu(tr->buffer, cpu);
> -	trace_seq_printf(s, "entries: %ld\n", cnt);
> +	len += sprintf(buf + len, "entries: %ld\n", cnt);
>  
>  	cnt = ring_buffer_overrun_cpu(tr->buffer, cpu);
> -	trace_seq_printf(s, "overrun: %ld\n", cnt);
> +	len += sprintf(buf + len, "overrun: %ld\n", cnt);
>  
>  	cnt = ring_buffer_commit_overrun_cpu(tr->buffer, cpu);
> -	trace_seq_printf(s, "commit overrun: %ld\n", cnt);
> -
> -	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
> +	len += sprintf(buf + len, "commit overrun: %ld\n", cnt);
>  
> -	kfree(s);
> +	BUG_ON(len >= sizeof(buf)); /* should not happen, 128 is enough. */
> +	count = simple_read_from_buffer(ubuf, count, ppos, buf, len);
>  
>  	return count;
>  }
> 

