Return-Path: <linux-kernel-owner+w=401wt.eu-S1756955AbZB0DfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbZB0DfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 22:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbZB0DfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 22:35:10 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51366 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbZB0DfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 22:35:08 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] new irq tracer
Cc: kosaki.motohiro@jp.fujitsu.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>, mingo@elte.hu,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       fweisbec@gmail.com
In-Reply-To: <20090226151105.GA3122@redhat.com>
References: <20090225173412.GA14269@Krystal> <20090226151105.GA3122@redhat.com>
Message-Id: <20090227123339.1531.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 27 Feb 2009 12:35:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Using Steve's new 'DEFINE_TRACE_FMT', I can get function graph trace
> as follows using the original two tracepoints (patch below):
> 
>  3)               |                      handle_IRQ_event() {
>  3)               |                        /* (irq_handler_entry) irq=28 handler=eth0 */
>  3)               |                        e1000_intr_msi() {
>  3)   2.460 us    |                          __napi_schedule();
>  3)   9.416 us    |                        }
>  3)               |                        /* (irq_handler_exit) irq=28 handler=eth0 return=handled */
>  3) + 22.935 us   |                      }
> 
> thanks,
> 
> -Jason

OK.
I think you prove this patch is valuable enough. very thanks!

	Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> 
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
> 
>  include/trace/irq.h             |    9 +++++++++
>  include/trace/irq_event_types.h |   17 +++++++++++++++++
>  kernel/irq/handle.c             |    6 ++++++
>  kernel/trace/events.c           |    2 ++
>  4 files changed, 34 insertions(+), 0 deletions(-)
>  create mode 100644 include/trace/irq.h
>  create mode 100644 include/trace/irq_event_types.h
> 
> 
> diff --git a/include/trace/irq.h b/include/trace/irq.h
> new file mode 100644
> index 0000000..ff5d449
> --- /dev/null
> +++ b/include/trace/irq.h
> @@ -0,0 +1,9 @@
> +#ifndef _TRACE_IRQ_H
> +#define _TRACE_IRQ_H
> +
> +#include <linux/interrupt.h>
> +#include <linux/tracepoint.h>
> +
> +#include <trace/irq_event_types.h>
> +
> +#endif
> diff --git a/include/trace/irq_event_types.h b/include/trace/irq_event_types.h
> new file mode 100644
> index 0000000..5889bfd
> --- /dev/null
> +++ b/include/trace/irq_event_types.h
> @@ -0,0 +1,17 @@
> +
> +/* use <trace/irq.h> instead */
> +#ifndef DEFINE_TRACE_FMT
> +# error Do not include this file directly.
> +# error Unless you know what you are doing.
> +#endif
> +
> +DEFINE_TRACE_FMT(irq_handler_entry,
> +	TPPROTO(int irq, struct irqaction *action),
> +	TPARGS(irq, action),
> +	TPFMT("irq=%d handler=%s", irq, action->name));
> +
> +DEFINE_TRACE_FMT(irq_handler_exit,
> +	TPPROTO(int irq, struct irqaction *action, int ret),
> +	TPARGS(irq, action, ret),
> +	TPFMT("irq=%d handler=%s return=%s",
> +		irq, action->name, ret ? "handled" : "unhandled"));
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index fdff380..bcebc2e 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -18,6 +18,7 @@
>  #include <linux/rculist.h>
>  #include <linux/hash.h>
>  #include <linux/bootmem.h>
> +#include <trace/irq.h>
>  
>  #include "internals.h"
>  
> @@ -338,6 +339,9 @@ irqreturn_t no_action(int cpl, void *dev_id)
>  	return IRQ_NONE;
>  }
>  
> +DEFINE_TRACE(irq_handler_entry);
> +DEFINE_TRACE(irq_handler_exit);
> +
>  /**
>   * handle_IRQ_event - irq action chain handler
>   * @irq:	the interrupt number
> @@ -354,7 +358,9 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
>  		local_irq_enable_in_hardirq();
>  
>  	do {
> +		trace_irq_handler_entry(irq, action);
>  		ret = action->handler(irq, action->dev_id);
> +		trace_irq_handler_exit(irq, action, ret);
>  		if (ret == IRQ_HANDLED)
>  			status |= action->flags;
>  		retval |= ret;
> diff --git a/kernel/trace/events.c b/kernel/trace/events.c
> index 38c89ee..3c75623 100644
> --- a/kernel/trace/events.c
> +++ b/kernel/trace/events.c
> @@ -6,8 +6,10 @@
>  
>  /* trace/<type>.h here */
>  #include <trace/sched.h>
> +#include <trace/irq.h>
>  
>  #include "trace_events.h"
>  
>  /* trace/<type>_event_types.h here */
>  #include <trace/sched_event_types.h>
> +#include <trace/irq_event_types.h>
> 
> 
> 
> 
> 
> 



