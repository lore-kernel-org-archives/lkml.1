Return-Path: <linux-kernel-owner+w=401wt.eu-S1757166AbZCXSes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbZCXSes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZCXSej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:34:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56231 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbZCXSeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:34:37 -0400
Date: Tue, 24 Mar 2009 19:33:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 7/9] LTTng instrumentation - kernel
Message-ID: <20090324183313.GH31117@elte.hu>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.872305963@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324160148.872305963@polymtl.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Rusty Cc:-ed - for the module.c tracepoints below)

* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Instrument the core kernel : module load/free and printk events. It helps the
> tracer to keep track of module related events and to export valuable printk
> information into the traces.
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
> CC: 'Ingo Molnar' <mingo@elte.hu>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Masami Hiramatsu <mhiramat@redhat.com>
> CC: 'Peter Zijlstra' <peterz@infradead.org>
> CC: "Frank Ch. Eigler" <fche@redhat.com>
> CC: 'Hideo AOKI' <haoki@redhat.com>
> CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
> CC: 'Steven Rostedt' <rostedt@goodmis.org>
> CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  include/trace/kernel.h |   19 +++++++++++++++++++
>  kernel/module.c        |    8 ++++++++
>  kernel/printk.c        |    7 +++++++
>  3 files changed, 34 insertions(+)
> 
> Index: linux-2.6-lttng/kernel/printk.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/printk.c	2009-03-24 09:09:52.000000000 -0400
> +++ linux-2.6-lttng/kernel/printk.c	2009-03-24 09:31:53.000000000 -0400
> @@ -32,6 +32,7 @@
>  #include <linux/security.h>
>  #include <linux/bootmem.h>
>  #include <linux/syscalls.h>
> +#include <trace/kernel.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -59,6 +60,7 @@ int console_printk[4] = {
>  	MINIMUM_CONSOLE_LOGLEVEL,	/* minimum_console_loglevel */
>  	DEFAULT_CONSOLE_LOGLEVEL,	/* default_console_loglevel */
>  };
> +EXPORT_SYMBOL_GPL(console_printk);
>  
>  /*
>   * Low level drivers may need that to know if they can schedule in
> @@ -128,6 +130,9 @@ EXPORT_SYMBOL(console_set_on_cmdline);
>  /* Flag: console code may call schedule() */
>  static int console_may_schedule;
>  
> +DEFINE_TRACE(kernel_printk);
> +DEFINE_TRACE(kernel_vprintk);
> +
>  #ifdef CONFIG_PRINTK
>  
>  static char __log_buf[__LOG_BUF_LEN];
> @@ -560,6 +565,7 @@ asmlinkage int printk(const char *fmt, .
>  	int r;
>  
>  	va_start(args, fmt);
> +	trace_kernel_printk(_RET_IP_);
>  	r = vprintk(fmt, args);
>  	va_end(args);
>
> @@ -667,6 +673,7 @@ asmlinkage int vprintk(const char *fmt, 
>  	printed_len += vscnprintf(printk_buf + printed_len,
>  				  sizeof(printk_buf) - printed_len, fmt, args);
>  
> +	trace_kernel_vprintk(_RET_IP_, printk_buf, printed_len);

So here we pass in the formatted output. What sense does it make to 
have the above printk tracepoint? Little i think.

Also, i'm not entirely convinced about the wiseness of instrumenting 
an essential debug facility like printk(). Lets keep this one at the 
tail portion of the patch-queue, ok?

> Index: linux-2.6-lttng/kernel/module.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/module.c	2009-03-24 09:09:59.000000000 -0400
> +++ linux-2.6-lttng/kernel/module.c	2009-03-24 09:31:53.000000000 -0400
> @@ -51,6 +51,7 @@
>  #include <linux/tracepoint.h>
>  #include <linux/ftrace.h>
>  #include <linux/async.h>
> +#include <trace/kernel.h>
>  
>  #if 0
>  #define DEBUGP printk
> @@ -78,6 +79,9 @@ static BLOCKING_NOTIFIER_HEAD(module_not
>  /* Bounds of module allocation, for speeding __module_text_address */
>  static unsigned long module_addr_min = -1UL, module_addr_max = 0;
>  
> +DEFINE_TRACE(kernel_module_load);
> +DEFINE_TRACE(kernel_module_free);

I believe that to have a complete picture of module usage, module 
refcount get/put events should be included as well, beyond the basic 
load/free events.

These both have performance impact (a module get/put in a fastpath 
hurts scalability), and are informative in terms of establishing the 
module dependency graph.

Another thing that is iteresting and which is not covered here are 
module request events and usermode helper callouts. These too have 
instrumentation and performance analysis uses.

Plus, here too it would be desired to put in default probes as well, 
via TRACE_EVENT().

Thanks,

	Ingo
