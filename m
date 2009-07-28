Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZG1Px3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZG1Px3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbZG1Px2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:53:28 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:53498 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbZG1Px0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:53:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MGKbR2N3LeUZNLysH7HuPAZWcjO7IU3Xl24a/AJKoaYbZJ7Cbz6SZ091yAWUfkMVyR
         Srbv026eI1k89+LoXWFRF5vHx8f3yOAvTD9t1HgFJSwvAhKfML0xUpyfctmtmNQug+h6
         7HITyKrQw8Bamj2RAABs3ejL54Sy+TdVm634s=
Date: Tue, 28 Jul 2009 17:53:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: simplify print_graph_cpu()
Message-ID: <20090728155323.GC6215@nowhere>
References: <4A6EEE5E.2000001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6EEE5E.2000001@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 08:26:06PM +0800, Lai Jiangshan wrote:
> 
> print_graph_cpu() is little over-designed.
> 
> And "log10_all" may be wrong when there are holes in cpu_online_mask:
> the max online cpu id > cpumask_weight(cpu_online_mask)
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index abf7c4a..e30472d 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -183,43 +183,19 @@ static void graph_trace_reset(struct trace_array *tr)
>  	unregister_ftrace_graph();
>  }
>  
> -static inline int log10_cpu(int nb)
> -{
> -	if (nb / 100)
> -		return 3;
> -	if (nb / 10)
> -		return 2;
> -	return 1;
> -}
> +static int max_bytes_for_cpu;
>  
>  static enum print_line_t
>  print_graph_cpu(struct trace_seq *s, int cpu)
>  {
> -	int i;
>  	int ret;
> -	int log10_this = log10_cpu(cpu);
> -	int log10_all = log10_cpu(cpumask_weight(cpu_online_mask));
> -
>  
>  	/*
>  	 * Start with a space character - to make it stand out
>  	 * to the right a bit when trace output is pasted into
>  	 * email:
>  	 */
> -	ret = trace_seq_printf(s, " ");
> -
> -	/*
> -	 * Tricky - we space the CPU field according to the max
> -	 * number of online CPUs. On a 2-cpu system it would take
> -	 * a maximum of 1 digit - on a 128 cpu system it would
> -	 * take up to 3 digits:
> -	 */
> -	for (i = 0; i < log10_all - log10_this; i++) {
> -		ret = trace_seq_printf(s, " ");
> -		if (!ret)
> -			return TRACE_TYPE_PARTIAL_LINE;
> -	}
> -	ret = trace_seq_printf(s, "%d) ", cpu);
> +	ret = trace_seq_printf(s, " %*d) ", max_bytes_for_cpu, cpu);
>  	if (!ret)
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
> @@ -919,6 +895,8 @@ static struct tracer graph_trace __read_mostly = {
>  
>  static __init int init_graph_trace(void)
>  {
> +	max_bytes_for_cpu = snprintf(NULL, 0, "%d", nr_cpu_ids - 1);


Nice trick :-)

Queued for .32, thanks!



> +
>  	return register_tracer(&graph_trace);
>  }
>  
> 
> 
> 
> 

