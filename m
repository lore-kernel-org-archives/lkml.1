Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbYGIQle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbYGIQle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbYGIQl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:41:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbYGIQl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:41:26 -0400
Message-ID: <4874E9A8.2020803@redhat.com>
Date: Wed, 09 Jul 2008 12:39:04 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 04/15] LTTng instrumentation - irq
References: <20080709145929.352201601@polymtl.ca> <20080709150044.698254444@polymtl.ca>
In-Reply-To: <20080709150044.698254444@polymtl.ca>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Instrumentation of IRQ related events : irq, softirq, tasklet entry and exit and
> softirq "raise" events.
> 
> It allows tracers to perform latency analysis on those various types of
> interrupts and to detect interrupts with max/min/avg duration. It helps
> detecting driver or hardware problems which cause an ISR to take ages to
> execute. It has been shown to be the case with bogus hardware causing an mmio
> read to take a few milliseconds.
> 
> Those tracepoints are used by LTTng.
> 
> About the performance impact of tracepoints (which is comparable to markers),
> even without immediate values optimizations, tests done by Hideo Aoki on ia64
> show no regression. His test case was using hackbench on a kernel where
> scheduler instrumentation (about 5 events in code scheduler code) was added.
> See the "Tracepoints" patch header for performance result detail.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Russell King <rmk+lkml@arm.linux.org.uk>
> CC: Masami Hiramatsu <mhiramat@redhat.com>
> CC: 'Peter Zijlstra' <peterz@infradead.org>
> CC: "Frank Ch. Eigler" <fche@redhat.com>
> CC: 'Ingo Molnar' <mingo@elte.hu>
> CC: 'Hideo AOKI' <haoki@redhat.com>
> CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
> CC: 'Steven Rostedt' <rostedt@goodmis.org>
> CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  kernel/irq-trace.h  |   36 ++++++++++++++++++++++++++++++++++++
>  kernel/irq/handle.c |    6 ++++++
>  kernel/softirq.c    |    8 ++++++++
>  3 files changed, 50 insertions(+)
> 
> Index: linux-2.6-lttng/kernel/irq/handle.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/irq/handle.c	2008-07-09 10:57:33.000000000 -0400
> +++ linux-2.6-lttng/kernel/irq/handle.c	2008-07-09 10:57:35.000000000 -0400
> @@ -15,6 +15,7 @@
>  #include <linux/random.h>
>  #include <linux/interrupt.h>
>  #include <linux/kernel_stat.h>
> +#include "../irq-trace.h"
>  
>  #include "internals.h"
>  
> @@ -130,6 +131,9 @@ irqreturn_t handle_IRQ_event(unsigned in
>  {
>  	irqreturn_t ret, retval = IRQ_NONE;
>  	unsigned int status = 0;
> +	struct pt_regs *regs = get_irq_regs();
> +
> +	trace_irq_entry(irq, regs);
>  
>  	handle_dynamic_tick(action);
>  
> @@ -148,6 +152,8 @@ irqreturn_t handle_IRQ_event(unsigned in
>  		add_interrupt_randomness(irq);
>  	local_irq_disable();
>  
> +	trace_irq_exit();
> +

Hi Mathieu,
What would you think tracing return value of irq handlers here?
like:
 trace_irq_exit(retval);

So, we can check the irq was handled correctly or not.

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

