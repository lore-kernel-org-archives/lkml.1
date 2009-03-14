Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbZCNC5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbZCNC5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 22:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbZCNC5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 22:57:07 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:34673 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbZCNC5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 22:57:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugFAJO2uklMQW1W/2dsb2JhbACBTc5Qg34G
Date: Fri, 13 Mar 2009 22:57:01 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fweisbec@gmail.com, fche@redhat.com,
       peterz@infradead.org
Subject: Re: [Patch 2/2] tracepoints for softirq entry/exit - tracepoints
Message-ID: <20090314025701.GC22526@Krystal>
References: <20090312183603.GC3352@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090312183603.GC3352@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:54:36 up 13 days, 23:20,  2 users,  load average: 0.47, 0.32,
	0.20
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
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

The softirq tracepoints are a good idea indeed (I have similar ones in
the LTTng tree). My main concern is about the fact that you output the
softirq name in plain text to the trace buffers. I would rather prefer
to save only the softirq (h-vec) into the trace and dump the mapping
(h-vec) to name only once, so we can save precious trace bytes.

Mathieu

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
> +
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
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
