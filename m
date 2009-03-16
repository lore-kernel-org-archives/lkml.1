Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbZCPTRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbZCPTRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZCPTRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:17:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58732 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZCPTRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:17:12 -0400
Date: Mon, 16 Mar 2009 15:17:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jason Baron <jbaron@redhat.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       fweisbec@gmail.com, fche@redhat.com, peterz@infradead.org,
       compudj@krystal.dyndns.org
Subject: Re: [Patch 2/2] tracepoints for softirq entry/exit - tracepoints
In-Reply-To: <20090316190047.GB3111@redhat.com>
Message-ID: <alpine.DEB.2.00.0903161514590.27978@gandalf.stny.rr.com>
References: <20090312183603.GC3352@redhat.com> <20090316190047.GB3111@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 16 Mar 2009, Jason Baron wrote:

> hi,
> 
> ok, below is a re-spun patch 2/2 which converts to the TRACE_EVENT
> format.

Thanks, some comments though.

> 
> thanks,
> 
> -Jason
> 
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
> 
>  include/trace/irq_event_types.h |   36 ++++++++++++++++++++++++++++++++++++
>  kernel/softirq.c                |    7 ++++++-
>  2 files changed, 42 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/include/trace/irq_event_types.h b/include/trace/irq_event_types.h
> index 214bb92..de1f2a9 100644
> --- a/include/trace/irq_event_types.h
> +++ b/include/trace/irq_event_types.h
> @@ -40,4 +40,40 @@ TRACE_EVENT(irq_handler_exit,
>  		  __entry->irq, __entry->ret ? "handled" : "unhandled")
>  );
>  
> +TRACE_EVENT(softirq_action_entry,
> +
> +	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
> +
> +	TP_ARGS(h, vec),
> +
> +	TP_STRUCT__entry(
> +		__array(	char,	softirq_name,	MAX_SOFTIRQ_NAME_LEN )
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->softirq_name, softirq_to_name[h-vec],
> +			MAX_SOFTIRQ_NAME_LEN);

memcpy isn't fast ;-)

What you want is this:

	TP_STRUCT__entry(
		__field(	int,	vec	)
	),

	TP_fast_assign(
		__entry->vec = h - vec;
> +	),
> +
> +	TP_printk("softirq entry: %s", __entry->softirq_name)

	TP_printk("softirq entry: %s", softirq_to_name[__entry->vec])

> +);
> +
> +TRACE_EVENT(softirq_action_exit,
> +
> +	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
> +
> +	TP_ARGS(h, vec),
> +
> +	TP_STRUCT__entry(
> +		__array(	char,	softirq_name,	MAX_SOFTIRQ_NAME_LEN )
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->softirq_name, softirq_to_name[h-vec],
> +			MAX_SOFTIRQ_NAME_LEN);
> +	),
> +
> +	TP_printk("softirq exit: %s", __entry->softirq_name)


And do the same here.

-- Steve

> +);
> +
>  #undef TRACE_SYSTEM
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 8f3ae57..5e96c77 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -24,6 +24,7 @@
>  #include <linux/ftrace.h>
>  #include <linux/smp.h>
>  #include <linux/tick.h>
> +#include <trace/irq.h>
>  
>  #include <asm/irq.h>
>  /*
> @@ -185,6 +186,9 @@ EXPORT_SYMBOL(local_bh_enable_ip);
>   */
>  #define MAX_SOFTIRQ_RESTART 10
>  
> +DEFINE_TRACE(softirq_action_entry);
> +DEFINE_TRACE(softirq_action_exit);
> +
>  asmlinkage void __do_softirq(void)
>  {
>  	struct softirq_action *h;
> @@ -211,8 +215,9 @@ restart:
>  		if (pending & 1) {
>  			int prev_count = preempt_count();
>  
> +			trace_softirq_action_entry(h, softirq_vec);
>  			h->action(h);
> -
> +			trace_softirq_action_exit(h, softirq_vec);
>  			if (unlikely(prev_count != preempt_count())) {
>  				printk(KERN_ERR "huh, entered softirq %td %s %p"
>  				       "with preempt_count %08x,"
> 
