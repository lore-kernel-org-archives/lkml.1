Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbZBZQee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbZBZQee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbZBZQeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:34:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50313 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757713AbZBZQeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:34:19 -0500
Message-ID: <49A6C489.9050600@redhat.com>
Date: Thu, 26 Feb 2009 11:34:17 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: acme@redhat.com, fche@redhat.com, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
       compudj@krystal.dyndns.org, tglx@linutronix.de, jbaron@redhat.com,
       mhiramat@redhat.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/ftrace] tracing, genirq: add irq enter and exit
 trace events
References: <tip-c115e399a330558bd38640663dfc6d36928ce4b8@kernel.org>
In-Reply-To: <tip-c115e399a330558bd38640663dfc6d36928ce4b8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> Author:     Jason Baron <jbaron@redhat.com>
> AuthorDate: Thu, 26 Feb 2009 10:11:05 -0500
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 26 Feb 2009 16:36:42 +0100
> 
> tracing, genirq: add irq enter and exit trace events
> 
> Impact: add new tracepoints
> 
> Add them to the generic IRQ code, that way every architecture
> gets these new tracepoints, not just x86.
> 
> Using Steve's new 'TRACE_FORMAT', I can get function graph
> trace as follows using the original two IRQ tracepoints:
> 
>  3)               |    handle_IRQ_event() {
>  3)               |    /* (irq_handler_entry) irq=28 handler=eth0 */
>  3)               |    e1000_intr_msi() {
>  3)   2.460 us    |      __napi_schedule();
>  3)   9.416 us    |    }
>  3)               |    /* (irq_handler_exit) irq=28 handler=eth0 return=handled */
>  3) + 22.935 us   |  }
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>
> Cc: "Frank Ch. Eigler" <fche@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Looks good for me,
Thank you!

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>


> 
> 
> ---
>  include/trace/irq.h             |    9 +++++++++
>  include/trace/irq_event_types.h |   17 +++++++++++++++++
>  kernel/irq/handle.c             |    6 ++++++
>  kernel/trace/events.c           |    2 ++
>  4 files changed, 34 insertions(+), 0 deletions(-)
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
> index 0000000..5d0919f
> --- /dev/null
> +++ b/include/trace/irq_event_types.h
> @@ -0,0 +1,17 @@
> +
> +/* use <trace/irq.h> instead */
> +#ifndef TRACE_FORMAT
> +# error Do not include this file directly.
> +# error Unless you know what you are doing.
> +#endif
> +
> +TRACE_FORMAT(irq_handler_entry,
> +	TPPROTO(int irq, struct irqaction *action),
> +	TPARGS(irq, action),
> +	TPFMT("irq=%d handler=%s", irq, action->name));
> +
> +TRACE_FORMAT(irq_handler_exit,
> +	TPPROTO(int irq, struct irqaction *action, int ret),
> +	TPARGS(irq, action, ret),
> +	TPFMT("irq=%d handler=%s return=%s",
> +		irq, action->name, ret ? "handled" : "unhandled"));
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index 3aba8d1..4709a7c 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -17,6 +17,7 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/rculist.h>
>  #include <linux/hash.h>
> +#include <trace/irq.h>
>  
>  #include "internals.h"
>  
> @@ -316,6 +317,9 @@ irqreturn_t no_action(int cpl, void *dev_id)
>  	return IRQ_NONE;
>  }
>  
> +DEFINE_TRACE(irq_handler_entry);
> +DEFINE_TRACE(irq_handler_exit);
> +
>  /**
>   * handle_IRQ_event - irq action chain handler
>   * @irq:	the interrupt number
> @@ -332,7 +336,9 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
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

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

