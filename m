Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbZCaEMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbZCaEMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 00:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750728AbZCaEMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 00:12:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48992 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZCaEMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 00:12:15 -0400
Date: Tue, 31 Mar 2009 00:12:12 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Zhaolei <zhaolei@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ftrace: Clean up enable logic for sched_switch
In-Reply-To: <49D1956E.8080801@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0903310011380.3843@gandalf.stny.rr.com>
References: <49D1952F.4090308@cn.fujitsu.com> <49D1956E.8080801@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 31 Mar 2009, Zhaolei wrote:
> 
> diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
> index 9117cea..b6a0938 100644
> --- a/kernel/trace/trace_sched_switch.c
> +++ b/kernel/trace/trace_sched_switch.c
> @@ -29,13 +29,13 @@ probe_sched_switch(struct rq *__rq, struct task_struct *prev,
>  	int cpu;
>  	int pc;
>  
> -	if (!sched_ref || sched_stopped)
> +	if (!likely(sched_ref))

That should be:

	if (unlikely(!sched_ref))

>  		return;
>  
>  	tracing_record_cmdline(prev);
>  	tracing_record_cmdline(next);
>  
> -	if (!tracer_enabled)
> +	if (!tracer_enabled || sched_stopped)
>  		return;
>  
>  	pc = preempt_count();
> @@ -56,15 +56,15 @@ probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee, int success)
>  	unsigned long flags;
>  	int cpu, pc;
>  
> -	if (!likely(tracer_enabled))
> +	if (!likely(sched_ref))

Same here.

-- Steve

>  		return;
>  
> -	pc = preempt_count();
>  	tracing_record_cmdline(current);
>  
> -	if (sched_stopped)
> +	if (!tracer_enabled || sched_stopped)
>  		return;
>  
> +	pc = preempt_count();
>  	local_irq_save(flags);
>  	cpu = raw_smp_processor_id();
>  	data = ctx_trace->data[cpu];
> -- 
> 1.5.5.3
> 
> 
> 
