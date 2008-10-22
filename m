Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbYJVR21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbYJVR21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYJVR2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:28:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36154 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYJVR2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:28:17 -0400
Message-ID: <48FF628A.2080405@oracle.com>
Date: Wed, 22 Oct 2008 10:27:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] tracing/ftrace: Introduce the big kernel lock
 tracer
References: <48FF5E54.7000101@gmail.com>
In-Reply-To: <48FF5E54.7000101@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/trace/bkl.h      |   29 ++++++++
>  kernel/trace/Kconfig     |   11 +++
>  kernel/trace/Makefile    |    1 +
>  kernel/trace/trace.h     |   18 +++++
>  kernel/trace/trace_bkl.c |  170 ++++++++++++++++++++++++++++++++++++++++++++++
>  lib/kernel_lock.c        |   22 ++++++-
>  6 files changed, 249 insertions(+), 2 deletions(-)
> 
> diff --git a/include/trace/bkl.h b/include/trace/bkl.h
> new file mode 100644
> index 0000000..bed2f1b
> --- /dev/null
> +++ b/include/trace/bkl.h
> @@ -0,0 +1,29 @@
> +#ifndef _TRACE_BKL_H
> +#define _TRACE_BKL_H
> +
> +
> +/* Entry which log the time when the task tried first to acquire the bkl
> + * and the time when it acquired it.
> + * That will let us know the latency to acquire the kernel lock.
> + */

Please use the more common/accepted long-comment style:

/*
 * comment line 1
 * comment line 2
 */

like you did in some other places.

> +struct bkl_trace_acquire {
> +	unsigned long long acquire_req_time;
> +	unsigned long long acquire_time;
> +};
> +
> +/* This will log the time when the task released the bkl.
> + * So we will know the whole duration of its kernel lock.
> + */

ditto et al

> +struct bkl_trace_release {
> +	unsigned long long release_time;
> +};
> +
> +#ifdef CONFIG_BKL_TRACER
> +extern void trace_bkl_acquire(struct bkl_trace_acquire *trace);
> +extern void trace_bkl_release(struct bkl_trace_release *trace);
> +#else
> +static void trace_bkl_acquire(struct bkl_trace_acquire *trace) { }
> +static void trace_bkl_release(struct bkl_trace_release *trace) { }
> +#endif
> +
> +#endif
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 396aea1..fde7700 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -144,6 +144,17 @@ config STACK_TRACER
>  	 This tracer records the max stack of the kernel, and displays
>  	 it in debugfs/tracing/stack_trace
> 
> +config BKL_TRACER
> +	bool "Trace Big Kernel Lock latencies"
> +	depends on HAVE_FTRACE
> +	depends on DEBUG_KERNEL
> +	select FTRACE
> +	select STACKTRACE
> +	help
> +	  This tracer records the latencies issued by the Big Kernel Lock.
> +	  It traces the time when a task request the bkl, the time when it

	                                 requests

> +	  acquires it and the time when it releases it.
> +
>  config DYNAMIC_FTRACE
>  	bool "enable/disable ftrace tracepoints dynamically"
>  	depends on FTRACE

> diff --git a/kernel/trace/trace_bkl.c b/kernel/trace/trace_bkl.c
> new file mode 100644
> index 0000000..169ee01
> --- /dev/null
> +++ b/kernel/trace/trace_bkl.c
> @@ -0,0 +1,170 @@
> +/*
> + * Ring buffer based Big Kernel Lock tracer
> + * for purpose of measuring the latencies issued
> + * by the BKL.
> + *
> + * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
> + */
> +
> +#include <trace/bkl.h>
> +#include "trace.h"
> +#include <linux/ftrace.h>
> +
> +
> +static struct trace_array *bkl_trace;
> +static bool bkl_tracer_enabled;
> +
> +
> +static void bkl_trace_init(struct trace_array *tr)
> +{
> +	int cpu;
> +	bkl_trace = tr;

what is <bkl_trace> used for?  or unused?

> +
> +	for_each_cpu_mask(cpu, cpu_possible_map)
> +		tracing_reset(tr, cpu);
> +
> +	if (tr->ctrl)
> +		bkl_tracer_enabled = 1;
> +}


~Randy

