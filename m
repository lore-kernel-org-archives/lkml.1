Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbYLSKrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbYLSKrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 05:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYLSKrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 05:47:09 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:60432 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbYLSKrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 05:47:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gaKIh1dbXkKwoVV2N1bW9XMbcchAFUicFtVjewyMBloS3PEfOPOW1t86B41p2ZdpIJ
         WDpKPdv77UL4jQ56eAcbvgI013FifRoqorRqMWLIFbYanc9WBMprNxcvqn6jKsumM3Gn
         9lm7+0yBO5ClzloE+/6LlqYkwjAjLvpMyx4fM=
Message-ID: <c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com>
Date: Fri, 19 Dec 2008 11:47:06 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka J Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] ftrace: introduce tracing_reset_online_cpus() helper
Cc: rostedt@goodmis.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       "Pekka Paalanen" <pq@iki.fi>,
       "Markus Metzger" <markus.t.metzger@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/19 Pekka J Enberg <penberg@cs.helsinki.fi>:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
>
> This patch factors out common code from multiple tracers into a
> tracing_reset_online_cpus() function and converts the tracers to use it.
>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  kernel/trace/trace.c              |   10 ++++++++++
>  kernel/trace/trace.h              |    1 +
>  kernel/trace/trace_boot.c         |   12 +-----------
>  kernel/trace/trace_functions.c    |   14 ++------------
>  kernel/trace/trace_hw_branches.c  |   14 ++------------
>  kernel/trace/trace_mmiotrace.c    |    6 +-----
>  kernel/trace/trace_sched_switch.c |   14 ++------------
>  kernel/trace/trace_sysprof.c      |   12 +-----------
>  8 files changed, 20 insertions(+), 63 deletions(-)
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 1a3d6b3..c39a0d8 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -679,6 +679,16 @@ void tracing_reset(struct trace_array *tr, int cpu)
>        ftrace_enable_cpu();
>  }
>
> +void tracing_reset_online_cpus(struct trace_array *tr)
> +{
> +       int cpu;
> +
> +       tr->time_start = ftrace_now(tr->cpu);
> +
> +       for_each_online_cpu(cpu)
> +               tracing_reset(tr, cpu);
> +}
> +
>  #define SAVED_CMDLINES 128
>  static unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
>  static unsigned map_cmdline_to_pid[SAVED_CMDLINES];
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index fc75dce..cc7a4f8 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -374,6 +374,7 @@ struct trace_iterator {
>  int tracing_is_enabled(void);
>  void trace_wake_up(void);
>  void tracing_reset(struct trace_array *tr, int cpu);
> +void tracing_reset_online_cpus(struct trace_array *tr);
>  int tracing_open_generic(struct inode *inode, struct file *filp);
>  struct dentry *tracing_init_dentry(void);
>  void init_tracer_sysprof_debugfs(struct dentry *d_tracer);
> diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
> index a4fa2c5..3ccebde 100644
> --- a/kernel/trace/trace_boot.c
> +++ b/kernel/trace/trace_boot.c
> @@ -37,16 +37,6 @@ void disable_boot_trace(void)
>                tracing_stop_sched_switch_record();
>  }
>
> -static void reset_boot_trace(struct trace_array *tr)
> -{
> -       int cpu;
> -
> -       tr->time_start = ftrace_now(tr->cpu);
> -
> -       for_each_online_cpu(cpu)
> -               tracing_reset(tr, cpu);
> -}
> -
>  static int boot_trace_init(struct trace_array *tr)
>  {
>        int cpu;
> @@ -130,7 +120,7 @@ struct tracer boot_tracer __read_mostly =
>  {
>        .name           = "initcall",
>        .init           = boot_trace_init,
> -       .reset          = reset_boot_trace,
> +       .reset          = tracing_reset_online_cpus,
>        .print_line     = initcall_print_line,
>  };
>
> diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> index e74f6d0..9236d7e 100644
> --- a/kernel/trace/trace_functions.c
> +++ b/kernel/trace/trace_functions.c
> @@ -16,20 +16,10 @@
>
>  #include "trace.h"
>
> -static void function_reset(struct trace_array *tr)
> -{
> -       int cpu;
> -
> -       tr->time_start = ftrace_now(tr->cpu);
> -
> -       for_each_online_cpu(cpu)
> -               tracing_reset(tr, cpu);
> -}
> -
>  static void start_function_trace(struct trace_array *tr)
>  {
>        tr->cpu = get_cpu();
> -       function_reset(tr);
> +       tracing_reset_online_cpus(tr);
>        put_cpu();
>
>        tracing_start_cmdline_record();
> @@ -55,7 +45,7 @@ static void function_trace_reset(struct trace_array *tr)
>
>  static void function_trace_start(struct trace_array *tr)
>  {
> -       function_reset(tr);
> +       tracing_reset_online_cpus(tr);
>  }
>
>  static struct tracer function_trace __read_mostly =
> diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
> index ee29e01..b6a3e20 100644
> --- a/kernel/trace/trace_hw_branches.c
> +++ b/kernel/trace/trace_hw_branches.c
> @@ -25,16 +25,6 @@ static DEFINE_PER_CPU(unsigned char[SIZEOF_BTS], buffer);
>  #define this_buffer per_cpu(buffer, smp_processor_id())
>
>
> -static void bts_trace_reset(struct trace_array *tr)
> -{
> -       int cpu;
> -
> -       tr->time_start = ftrace_now(tr->cpu);
> -
> -       for_each_online_cpu(cpu)
> -               tracing_reset(tr, cpu);
> -}
> -
>  static void bts_trace_start_cpu(void *arg)
>  {
>        if (this_tracer)
> @@ -54,7 +44,7 @@ static void bts_trace_start(struct trace_array *tr)
>  {
>        int cpu;
>
> -       bts_trace_reset(tr);
> +       tracing_reset_online_cpus(tr);
>
>        for_each_cpu_mask(cpu, cpu_possible_map)
>                smp_call_function_single(cpu, bts_trace_start_cpu, NULL, 1);
> @@ -78,7 +68,7 @@ static void bts_trace_stop(struct trace_array *tr)
>
>  static int bts_trace_init(struct trace_array *tr)
>  {
> -       bts_trace_reset(tr);
> +       tracing_reset_online_cpus(tr);
>        bts_trace_start(tr);
>
>        return 0;
> diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
> index 2fb6da6..fffcb06 100644
> --- a/kernel/trace/trace_mmiotrace.c
> +++ b/kernel/trace/trace_mmiotrace.c
> @@ -22,14 +22,10 @@ static unsigned long prev_overruns;
>
>  static void mmio_reset_data(struct trace_array *tr)
>  {
> -       int cpu;
> -
>        overrun_detected = false;
>        prev_overruns = 0;
> -       tr->time_start = ftrace_now(tr->cpu);
>
> -       for_each_online_cpu(cpu)
> -               tracing_reset(tr, cpu);
> +       tracing_reset_online_cpus(tr);
>  }
>
>  static int mmio_trace_init(struct trace_array *tr)
> diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
> index 8633905..7f59f91 100644
> --- a/kernel/trace/trace_sched_switch.c
> +++ b/kernel/trace/trace_sched_switch.c
> @@ -72,16 +72,6 @@ probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee)
>        local_irq_restore(flags);
>  }
>
> -static void sched_switch_reset(struct trace_array *tr)
> -{
> -       int cpu;
> -
> -       tr->time_start = ftrace_now(tr->cpu);
> -
> -       for_each_online_cpu(cpu)
> -               tracing_reset(tr, cpu);
> -}
> -
>  static int tracing_sched_register(void)
>  {
>        int ret;
> @@ -197,7 +187,7 @@ void tracing_sched_switch_assign_trace(struct trace_array *tr)
>
>  static void start_sched_trace(struct trace_array *tr)
>  {
> -       sched_switch_reset(tr);
> +       tracing_reset_online_cpus(tr);
>        tracing_start_sched_switch_record();
>  }
>
> @@ -221,7 +211,7 @@ static void sched_switch_trace_reset(struct trace_array *tr)
>
>  static void sched_switch_trace_start(struct trace_array *tr)
>  {
> -       sched_switch_reset(tr);
> +       tracing_reset_online_cpus(tr);
>        tracing_start_sched_switch();
>  }
>
> diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
> index 54960ed..01becf1 100644
> --- a/kernel/trace/trace_sysprof.c
> +++ b/kernel/trace/trace_sysprof.c
> @@ -234,20 +234,10 @@ static void stop_stack_timers(void)
>                stop_stack_timer(cpu);
>  }
>
> -static void stack_reset(struct trace_array *tr)
> -{
> -       int cpu;
> -
> -       tr->time_start = ftrace_now(tr->cpu);
> -
> -       for_each_online_cpu(cpu)
> -               tracing_reset(tr, cpu);
> -}
> -
>  static void start_stack_trace(struct trace_array *tr)
>  {
>        mutex_lock(&sample_timer_lock);
> -       stack_reset(tr);
> +       tracing_reset_online_cpus(tr);
>        start_stack_timers();
>        tracer_enabled = 1;
>        mutex_unlock(&sample_timer_lock);


That's looks good.
By the past, I also suggested Steven to automatically reset the traces
buffer each time a tracer is started, that
would factor out the code a bit more. I don't think one tracer would
avoid to reset the buffer once it is started, and
I don't think it is needed to reset twice on tracer switching: on stop
of the old tracer and on start on the new. Only
on start should be enough.
