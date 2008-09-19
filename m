Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbYISKsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbYISKsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 06:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYISKsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 06:48:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:53184 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbYISKsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 06:48:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YxSTiR9rCsZ5yV6ALSTBDxom5MlUHElZxTyq6sob5MGCmemt7UlIqtY1HUU9VGKng4
         /zG33/kZQz0nM3EbUHax2U84WKC9jJdN9uN+HVRIUScRLgMbFCaJsa83KxDB8FFiufG2
         lJyPJWbn0+iZiRWIEE3lBUhNocLnRjPKgMl8U=
Message-ID: <c62985530809190348h3a74de3aqd0ca2e893b11bb8c@mail.gmail.com>
Date: Fri, 19 Sep 2008 12:48:16 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [PATCH -tip FIXED] ftrace: add nop tracer
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <1221818803-9616-1-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221818803-9616-1-git-send-email-steven@uplinklabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/19 Steven Noonan <steven@uplinklabs.net>:
> A no-op tracer which can serve two purposes:
>  1. A template for development of a new tracer.
>  2. A convenient way to see ftrace_printk() calls without
>    an irrelevant trace making the output messy.
>
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> ---
>  kernel/trace/Kconfig          |   10 ++++++
>  kernel/trace/Makefile         |    1 +
>  kernel/trace/trace.h          |    4 ++
>  kernel/trace/trace_nop.c      |   65 +++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_selftest.c |    9 ++++++
>  5 files changed, 89 insertions(+), 0 deletions(-)
>  create mode 100644 kernel/trace/trace_nop.c
>
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 16e5bb5..d7b2de7 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -101,6 +101,16 @@ config SCHED_TRACER
>          This tracer tracks the latency of the highest priority task
>          to be scheduled in, starting from the point it has woken up.
>
> +config NOP_TRACER
> +       bool "NOP Tracer"
> +       depends on HAVE_FTRACE
> +       depends on DEBUG_KERNEL
> +       select TRACING
> +       help
> +         This tracer does nothing. The primary purpose for it is to
> +         politely print the output of ftrace_printk() calls without
> +         the overhead of an irrelevant trace taking place.
> +
>  config CONTEXT_SWITCH_TRACER
>        bool "Trace process context switches"
>        depends on HAVE_FTRACE
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index 58ec61c..73ba13f 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -19,6 +19,7 @@ obj-$(CONFIG_FTRACE) += trace_functions.o
>  obj-$(CONFIG_IRQSOFF_TRACER) += trace_irqsoff.o
>  obj-$(CONFIG_PREEMPT_TRACER) += trace_irqsoff.o
>  obj-$(CONFIG_SCHED_TRACER) += trace_sched_wakeup.o
> +obj-$(CONFIG_NOP_TRACER) += trace_nop.o
>  obj-$(CONFIG_STACK_TRACER) += trace_stack.o
>  obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
>
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 42f65d0..447d4b9 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -339,6 +339,10 @@ extern int trace_selftest_startup_preemptirqsoff(struct tracer *trace,
>  extern int trace_selftest_startup_wakeup(struct tracer *trace,
>                                         struct trace_array *tr);
>  #endif
> +#ifdef CONFIG_NOP_TRACER
> +extern int trace_selftest_startup_nop(struct tracer *trace,
> +                                        struct trace_array *tr);
> +#endif
>  #ifdef CONFIG_CONTEXT_SWITCH_TRACER
>  extern int trace_selftest_startup_sched_switch(struct tracer *trace,
>                                               struct trace_array *tr);
> diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
> new file mode 100644
> index 0000000..dafaefb
> --- /dev/null
> +++ b/kernel/trace/trace_nop.c
> @@ -0,0 +1,65 @@
> +/*
> + * nop tracer
> + *
> + * Copyright (C) 2008 Steven Noonan <steven@uplinklabs.net>
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +#include <linux/debugfs.h>
> +#include <linux/ftrace.h>
> +
> +#include "trace.h"
> +
> +static struct trace_array      *ctx_trace;
> +
> +static void start_nop_trace(struct trace_array *tr)
> +{
> +       /* Nothing to do! */
> +}
> +
> +static void stop_nop_trace(struct trace_array *tr)
> +{
> +       /* Nothing to do! */
> +}
> +
> +static void nop_trace_init(struct trace_array *tr)
> +{
> +       ctx_trace = tr;
> +
> +       if (tr->ctrl)
> +               start_nop_trace(tr);
> +}
> +
> +static void nop_trace_reset(struct trace_array *tr)
> +{
> +       if (tr->ctrl)
> +               stop_nop_trace(tr);
> +}
> +
> +static void nop_trace_ctrl_update(struct trace_array *tr)
> +{
> +       /* When starting a new trace, reset the buffers */
> +       if (tr->ctrl)
> +               start_nop_trace(tr);
> +       else
> +               stop_nop_trace(tr);
> +}
> +
> +static struct tracer nop_trace __read_mostly =
> +{
> +       .name           = "nop",
> +       .init           = nop_trace_init,
> +       .reset          = nop_trace_reset,
> +       .ctrl_update    = nop_trace_ctrl_update,
> +#ifdef CONFIG_FTRACE_SELFTEST
> +       .selftest       = trace_selftest_startup_nop,
> +#endif
> +};
> +
> +__init static int init_nop_trace(void)
> +{
> +       return register_tracer(&nop_trace);
> +}
> +device_initcall(init_nop_trace);
> diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> index 630715b..82db910 100644
> --- a/kernel/trace/trace_selftest.c
> +++ b/kernel/trace/trace_selftest.c
> @@ -418,6 +418,15 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
>  }
>  #endif /* CONFIG_IRQSOFF_TRACER && CONFIG_PREEMPT_TRACER */
>
> +#ifdef CONFIG_NOP_TRACER
> +int
> +trace_selftest_startup_nop(struct tracer *trace, struct trace_array *tr)
> +{
> +       /* What could possibly go wrong? */
> +       return 0;
> +}
> +#endif
> +
>  #ifdef CONFIG_SCHED_TRACER
>  static int trace_wakeup_test_thread(void *data)
>  {
> --
> 1.6.0.2
>

Hi Steven and Ingo!

It seems we have two "none" tracers now.
Why not seeing this nop tracer as an improvment of the current "none tracer" ?

As a result the none tracer contained in trace.c could be replaced by
this new one as the default tracer. And that's said, that will enable
trace_printk by default even when no tracer is selected by the user.

What do you think about it?
