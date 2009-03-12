Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbZCLTDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbZCLTDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 15:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbZCLTC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 15:02:56 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:35420 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZCLTCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 15:02:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bzjmF1JLCiDj+RI9tdYWfk8osKWaaHYeHNyHUtdvpjFo1P2rke8vnAg8k/5+xFaZ1Y
         QlCw+Q/bbe+5YaHM7thY8+C7X9X9HeHIr8R9rNfM57W6IPxTfOiev6upCF64npo96gz9
         aWAxqU5xziaH408zB/MZOpsLLCtH+e+bpTw48=
Date: Thu, 12 Mar 2009 20:02:50 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fche@redhat.com, peterz@infradead.org,
       compudj@krystal.dyndns.org
Subject: Re: [Patch 2/2] tracepoints for softirq entry/exit - tracepoints
Message-ID: <20090312190243.GC11045@nowhere>
References: <20090312183603.GC3352@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312183603.GC3352@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 02:36:03PM -0400, Jason Baron wrote:
> 
> introduce softirq entry/exit tracepoints. These are useful for
> augmenting existing tracers, and to figure out softirq frequencies and
> timings.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
> 
>  include/trace/irq_event_types.h |   12 ++++++++++++
>  kernel/softirq.c                |    7 ++++++-
>  2 files changed, 18 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/include/trace/irq_event_types.h b/include/trace/irq_event_types.h
> index 214bb92..38b4bdd 100644
> --- a/include/trace/irq_event_types.h
> +++ b/include/trace/irq_event_types.h
> @@ -40,4 +40,16 @@ TRACE_EVENT(irq_handler_exit,
>  		  __entry->irq, __entry->ret ? "handled" : "unhandled")
>  );
>  
> +TRACE_FORMAT(irq_softirq_entry,
> +	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
> +	TP_ARGS(h, vec),
> +	TP_FMT("softirq=%d action=%s", h - vec, softirq_to_name[h-vec])
> +	);
> +
> +TRACE_FORMAT(irq_softirq_exit,
> +	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
> +	TP_ARGS(h, vec),
> +	TP_FMT("softirq=%d action=%s", h - vec, softirq_to_name[h-vec])
> +	);
> +
>  #undef TRACE_SYSTEM
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index ba1511f..c378d53 100644
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
> @@ -186,6 +187,9 @@ EXPORT_SYMBOL(local_bh_enable_ip);
>   */
>  #define MAX_SOFTIRQ_RESTART 10
>  
> +DEFINE_TRACE(irq_softirq_entry);
> +DEFINE_TRACE(irq_softirq_exit);


Just one nit here. The "irq_" prefix seems to me too much.
On the trace we have:

/* irq_softirq_entry: softirq=nb action=nb_to_logical_name */

It's even too much words that says the same things.
Moreover, we have the logical name, the number seems not very useful
because we have its logical translation just after.

I would suggest to have just:

/* softirq_entry: nb_to_logical_name */

ie:

/* softirq_entry: SCHED_SOFTIRQ */

Don't you think it's more clear and obvious?

Other than that, I think these tracepoints are a good idea.


>  asmlinkage void __do_softirq(void)
>  {
>  	struct softirq_action *h;
> @@ -212,8 +216,9 @@ restart:
>  		if (pending & 1) {
>  			int prev_count = preempt_count();
>  
> +			trace_irq_softirq_entry(h, softirq_vec);
>  			h->action(h);
> -
> +			trace_irq_softirq_exit(h, softirq_vec);
>  			if (unlikely(prev_count != preempt_count())) {
>  				printk(KERN_ERR "huh, entered softirq %td %s %p"
>  				       "with preempt_count %08x,"

