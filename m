Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbZD0GBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbZD0GBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 02:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbZD0GBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 02:01:46 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:35323 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753520AbZD0GBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 02:01:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar8HAEfm9ElMQW1W/2dsb2JhbACBUIEwx0WDdAU
Date: Mon, 27 Apr 2009 02:01:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       zhaolei@cn.fujitsu.com, laijs@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, tzanussi@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ftrace: add a tracepoint for
	__raise_softirq_irqoff()
Message-ID: <20090427060137.GA13182@Krystal>
References: <49F548D0.9030500@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49F548D0.9030500@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 01:56:38 up 58 days,  2:22,  4 users,  load average: 0.84, 0.50,
	0.33
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
> Change log for v1 -> v2: 
> 1: Use TRACE_EVENT instead of DEFINE_TRACE
> 2: Move the tracepoint from raise_softirq_irqoff() to __raise_softirq_irqoff()
> 

Hi Xiao,

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> 
> ---
>  include/linux/interrupt.h  |    9 ++++++++-
>  include/trace/events/irq.h |   18 ++++++++++++++++++
>  2 files changed, 26 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 912c52c..86bae89 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -361,7 +361,14 @@ asmlinkage void do_softirq(void);
>  asmlinkage void __do_softirq(void);
>  extern void open_softirq(int nr, void (*action)(struct softirq_action *));
>  extern void softirq_init(void);
> -#define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
> +
> +#include <trace/events/irq.h>

Includes are usually at the beginning of the files.

Besides that, the patch looks good.

Which tree is it for ? mainline 2.6.30-rc or Ingo's tip tree ?

Working with Ingo on -tip is probably better so the work can be
synchronized with Steven's work more easily.

Thanks a lot !

Mathieu

> +static inline void __raise_softirq_irqoff(unsigned int nr)
> +{
> +	trace_irq_softirq_raise(nr);
> +	or_softirq_pending(1UL << nr);
> +}
> +
>  extern void raise_softirq_irqoff(unsigned int nr);
>  extern void raise_softirq(unsigned int nr);
>  extern void wakeup_softirqd(void);
> diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
> index 7686864..2628e08 100644
> --- a/include/trace/events/irq.h
> +++ b/include/trace/events/irq.h
> @@ -90,6 +90,24 @@ TRACE_EVENT(softirq_exit,
>  	TP_printk("softirq=%d action=%s", __entry->vec, __get_str(name))
>  );
>  
> +TRACE_EVENT(irq_softirq_raise,
> +
> +	TP_PROTO(unsigned int nr),
> +
> +	TP_ARGS(nr),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned int,	nr	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->nr	= nr;
> +	),
> +
> +	TP_printk("softirq=%d action=%s is raised",
> +		__entry->nr, softirq_to_name[__entry->nr])
> +);
> +
>  #endif /*  _TRACE_IRQ_H */
>  
>  /* This part must be outside protection */
> -- 
> 1.6.1.2
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
