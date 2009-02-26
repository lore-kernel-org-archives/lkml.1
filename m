Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbZBZPcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbZBZPcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 10:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbZBZPcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 10:32:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50989 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbZBZPcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 10:32:42 -0500
Date: Thu, 26 Feb 2009 10:32:38 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jason Baron <jbaron@redhat.com>
cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>, mingo@elte.hu,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fweisbec@gmail.com
Subject: Re: [PATCH] new irq tracer
In-Reply-To: <20090226151105.GA3122@redhat.com>
Message-ID: <alpine.DEB.2.00.0902261031460.26792@gandalf.stny.rr.com>
References: <1234995035.4799.14.camel@laptop> <20090220195236.GB3104@redhat.com> <20090222123543.359C.A69D9226@jp.fujitsu.com> <49A5765C.2020001@redhat.com> <20090225165747.GC3123@redhat.com> <20090225173412.GA14269@Krystal>
 <20090226151105.GA3122@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Feb 2009, Jason Baron wrote:
> 
> maybe...although that would require re-arranging the 'while' loop in
> 'handle_IRQ_event' from a do..while loop to a 'while' loop, which will
> require an extra branch check, and then we still have to record the last 'ret'
> value. I'm not that keen on re-arranging this for trace data...
> 
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

Looks good, one minor note:

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


I've renamed DEFINE_TRACE_FMT to TRACE_FORMAT. I believe that is already 
in Ingo's tree.

Other than that:

Acked-by: Steven Rostedt <srostedt@redhat.com>

Thanks,

-- Steve


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
> 
> 
