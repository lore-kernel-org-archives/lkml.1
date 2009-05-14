Return-Path: <linux-kernel-owner+w=401wt.eu-S1760727AbZENMk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727AbZENMk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbZENMkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:40:15 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:62015 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753892AbZENMkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:40:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqMHAPSqC0pMQW1W/2dsb2JhbACBUIEwzRuEAgU
Date: Thu, 14 May 2009 08:40:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: mingo@elte.hu, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       zhaolei@cn.fujitsu.com, laijs@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v4] ftrace: add a tracepoint for
	__raise_softirq_irqoff()
Message-ID: <20090514124013.GC21241@Krystal>
References: <49FFDF9C.7040505@cn.fujitsu.com> <20090505161604.GA15524@Krystal> <4A07D3B3.10605@cn.fujitsu.com> <20090511134019.GB10932@Krystal> <alpine.DEB.2.00.0905111003280.14976@gandalf.stny.rr.com> <20090511142734.GA12722@Krystal> <alpine.DEB.2.00.0905111039470.2492@gandalf.stny.rr.com> <20090511151353.GA14391@Krystal> <4A094677.5090900@cn.fujitsu.com> <4A0BF82A.2070208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4A0BF82A.2070208@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:37:24 up 75 days,  9:03,  3 users,  load average: 0.48, 0.54,
	0.43
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Xiao Guangrong (xiaoguangrong@cn.fujitsu.com) wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> This patch is modified from Mathieu Desnoyers' patch. The original patch
> can be found here: 
> 	http://marc.info/?l=linux-kernel&m=123791201816245&w=2
> This tracepoint can trace the time stamp when softirq action is raised. 
> 
> Changelog for v1 -> v2: 
> 1: Use TRACE_EVENT instead of DEFINE_TRACE
> 2: Move the tracepoint from raise_softirq_irqoff() to
>    __raise_softirq_irqoff()
> 
> Changelog for v2 -> v3: 
> Move the definition of __raise_softifq_irqoff() to .c file when
> CONFIG_TRACEPOINTS is enabled, to avoid recursive includes
> 
> Changelog for v3 -> v4: 
> 1: Come back to v2, and use forward declarations to avoid
>    recursive includes as Mathieu's suggestion
> 2: Modifiy the tracepoint name
> 3: Add comments for this tracepoint
> 

This is a step in the right direction, but please see my email to Lai
about the fact that this assumes correct and undocumented include
dependencies in kernel/trace/events.c. Not explicitely stating the
include dependencies is a build error waiting to happen.

Including interrupt.h under a ifdef would allow keeping track of
TRACE_EVENT specific build dependencies neatly on a per header basis.

Mathieu

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> Review-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  include/linux/interrupt.h  |    9 ++++++++-
>  include/trace/events/irq.h |   27 ++++++++++++++++++++++++++-
>  2 files changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index dd574d5..51e7909 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -18,6 +18,7 @@
>  #include <asm/atomic.h>
>  #include <asm/ptrace.h>
>  #include <asm/system.h>
> +#include <trace/events/irq.h>
>  
>  /*
>   * These correspond to the IORESOURCE_IRQ_* defines in
> @@ -361,7 +362,13 @@ asmlinkage void do_softirq(void);
>  asmlinkage void __do_softirq(void);
>  extern void open_softirq(int nr, void (*action)(struct softirq_action *));
>  extern void softirq_init(void);
> -#define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
> +
> +static inline void __raise_softirq_irqoff(unsigned int nr)
> +{
> +	trace_softirq_raise(nr);
> +	or_softirq_pending(1UL << nr);
> +}
> +
>  extern void raise_softirq_irqoff(unsigned int nr);
>  extern void raise_softirq(unsigned int nr);
>  extern void wakeup_softirqd(void);
> diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
> index 32a9f7e..08fa63b 100644
> --- a/include/trace/events/irq.h
> +++ b/include/trace/events/irq.h
> @@ -2,11 +2,13 @@
>  #define _TRACE_IRQ_H
>  
>  #include <linux/tracepoint.h>
> -#include <linux/interrupt.h>
>  
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM irq
>  
> +struct irqaction;
> +struct softirq_action;
> +
>  /**
>   * irq_handler_entry - called immediately before the irq action handler
>   * @irq: irq number
> @@ -128,6 +130,29 @@ TRACE_EVENT(softirq_exit,
>  	TP_printk("softirq=%d action=%s", __entry->vec, __get_str(name))
>  );
>  
> +/**
> + * softirq_raise - called immediately when a softirq is raised
> + * @nr: softirq vector number
> + */
> +TRACE_EVENT(softirq_raise,
> +
> +	TP_PROTO(unsigned int nr),
> +
> +	TP_ARGS(nr),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned int,	nr			)
> +		__string(	name,		softirq_to_name[nr]	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->nr	= nr;
> +		__assign_str(name, softirq_to_name[nr]);
> +	),
> +
> +	TP_printk("softirq=%u action=%s", __entry->nr, __get_str(name))
> +);
> +
>  #endif /*  _TRACE_IRQ_H */
>  
>  /* This part must be outside protection */
> -- 
> 1.6.1.2
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
