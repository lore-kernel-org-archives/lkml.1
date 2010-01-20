Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988Ab0ATTWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab0ATTWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762Ab0ATTWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:22:33 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:52648 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab0ATTWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:22:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jn/3ZFtwDTZsDV644BvoTueP/ig9ealdt9x57aW3dAnoCxLbB1F2RHoMmrw1Dpvr7Q
         yaonHf8pllKV36MCRHVX6ILkn4cKc+87zspAOPOayuRwYcQ7vAsKObodbItImAJQxGZc
         AundMCKYR8tXKK21oVAAJVM9h574AXU2gRfjE=
Date: Wed, 20 Jan 2010 20:22:27 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/6] tracing: reduce latency and remove percpu trace_seq
Message-ID: <20100120192225.GC6194@nowhere>
References: <4B55607E.8070403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B55607E.8070403@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 03:34:22PM +0800, Lai Jiangshan wrote:
> 
> __print_flags() and __print_symbolic() use percpu trace_seq:
> 
> 1) Its memory is preallocated, it wastes memory when we don't use tracing.
> 2) It wastes memory for multi-cpus system.
> 3) It disables preemption when it executes its core routine
>    "trace_seq_printf(s, "%s: ", #call);" and introduce latency
>    for more important process.
> 
> So we move this trace_seq to struct trace_iterator.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index be9ece5..348500d 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -12,9 +12,6 @@ struct dentry;
>  
>  #define FTRACE_SEQ_BUFSIZE PAGE_SIZE
>  
> -DECLARE_PER_CPU(struct trace_seq, ftrace_event_seq);
> -DECLARE_PER_CPU(unsigned char[FTRACE_SEQ_BUFSIZE], ftrace_event_buffer);
> -
>  struct trace_print_flags {
>  	unsigned long		mask;
>  	const char		*name;
> @@ -60,6 +57,10 @@ struct trace_iterator {
>  	struct trace_seq	seq;
>  	unsigned char		buffer[FTRACE_SEQ_BUFSIZE];
>  
> +	/* trace_seq for __print_flags() and __print_symbolic() */
> +	struct trace_seq	tmp_seq;
> +	unsigned char 		tmp_buffer[FTRACE_SEQ_BUFSIZE];




Well, I don't like much that because it's a temporary buffer
in trace iter only used by few events.
But the problem is indeed tricky.

May be should we use a kmalloc in raw_output?

We could pass a trace_seq without buffer in ftrace_print_flags_seq
which can alloc the buffer and then free it after?

