Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbYKHEU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbYKHEU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 23:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYKHEUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 23:20:15 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:15718 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbYKHEUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 23:20:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rFaaLgyDE9wEzapjdgnvSbLkNBLyqQzeHVAuURH0HMvfSn88MyFyNtEFmgGPsIO+wM
         Won7N34ldIiHSawSC0DsQaz/kE+BvVYsJ7N9La7Vq2QkJJlEnKt8UDrZd/5ud0G3wm3x
         HcY6jJEi9DJG1V9oouygq5Ag4NkftXunJR66g=
Message-ID: <c62985530811072020u65917088x437460f02d4700d4@mail.gmail.com>
Date: Sat, 8 Nov 2008 05:20:11 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 03/10] ftrace: fix sched_switch API
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <20081108034749.150849419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081108034605.289816911@goodmis.org>
	 <20081108034749.150849419@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/8 Steven Rostedt <rostedt@goodmis.org>:
> Impact: fix for sched_switch that broke dynamic ftrace startup
>
> The commit: tracing/fastboot: use sched switch tracer from boot tracer
> broke the API of the sched_switch trace. The use of the
> tracing_start/stop_cmdline record is for only recording the cmdline,
> NOT recording the schedule switches themselves.
>
> Seeing that the boot tracer broke the API to do something that it
> wanted, this patch adds a new interface for the API while
> puting back the original interface of the old API.
>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace.h              |    4 ++-
>  kernel/trace/trace_boot.c         |    6 ++--
>  kernel/trace/trace_sched_switch.c |   50 +++++++++++++++++++++++++++++-------
>  3 files changed, 46 insertions(+), 14 deletions(-)
>
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index db12e16..25abfc4 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -324,7 +324,9 @@ void trace_function(struct trace_array *tr,
>
>  void tracing_start_cmdline_record(void);
>  void tracing_stop_cmdline_record(void);
> -void tracing_cmdline_assign_trace(struct trace_array *tr);
> +void tracing_sched_switch_assign_trace(struct trace_array *tr);
> +void tracing_stop_sched_switch_record(void);
> +void tracing_start_sched_switch_record(void);
>  int register_tracer(struct tracer *type);
>  void unregister_tracer(struct tracer *type);
>
> diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
> index 662cb91..0203c10 100644
> --- a/kernel/trace/trace_boot.c
> +++ b/kernel/trace/trace_boot.c
> @@ -28,13 +28,13 @@ void start_boot_trace(void)
>  void enable_boot_trace(void)
>  {
>        if (pre_initcalls_finished)
> -               tracing_start_cmdline_record();
> +               tracing_start_sched_switch_record();
>  }
>
>  void disable_boot_trace(void)
>  {
>        if (pre_initcalls_finished)
> -               tracing_stop_cmdline_record();
> +               tracing_stop_sched_switch_record();
>  }
>
>  static void reset_boot_trace(struct trace_array *tr)
> @@ -55,7 +55,7 @@ static void boot_trace_init(struct trace_array *tr)
>        for_each_cpu_mask(cpu, cpu_possible_map)
>                tracing_reset(tr, cpu);
>
> -       tracing_cmdline_assign_trace(tr);
> +       tracing_sched_switch_assign_trace(tr);
>  }
>
>  static void boot_trace_ctrl_update(struct trace_array *tr)
> diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
> index fbf05df..79410db 100644
> --- a/kernel/trace/trace_sched_switch.c
> +++ b/kernel/trace/trace_sched_switch.c
> @@ -125,20 +125,16 @@ static void tracing_sched_unregister(void)
>  static void tracing_start_sched_switch(void)
>  {
>        mutex_lock(&sched_register_mutex);
> -       if (!(sched_ref++)) {
> -               tracer_enabled = 1;
> +       if (!(sched_ref++))
>                tracing_sched_register();
> -       }
>        mutex_unlock(&sched_register_mutex);
>  }
>
>  static void tracing_stop_sched_switch(void)
>  {
>        mutex_lock(&sched_register_mutex);
> -       if (!(--sched_ref)) {
> +       if (!(--sched_ref))
>                tracing_sched_unregister();
> -               tracer_enabled = 0;
> -       }
>        mutex_unlock(&sched_register_mutex);
>  }
>
> @@ -153,14 +149,48 @@ void tracing_stop_cmdline_record(void)
>  }
>
>  /**
> - * tracing_cmdline_assign_trace - assign a trace array for ctx switch
> + * tracing_start_sched_switch_record - start tracing context switches
> + *
> + * Turns on context switch tracing for a tracer.
> + */
> +void tracing_start_sched_switch_record(void)
> +{
> +       if (unlikely(!ctx_trace)) {
> +               WARN_ON(1);
> +               return;
> +       }
> +
> +       tracing_start_sched_switch();
> +
> +       mutex_lock(&sched_register_mutex);
> +       tracer_enabled++;
> +       mutex_unlock(&sched_register_mutex);
> +}
> +
> +/**
> + * tracing_stop_sched_switch_record - start tracing context switches
> + *
> + * Turns off context switch tracing for a tracer.
> + */
> +void tracing_stop_sched_switch_record(void)
> +{
> +       mutex_lock(&sched_register_mutex);
> +       tracer_enabled--;
> +       WARN_ON(tracer_enabled < 0);
> +       mutex_unlock(&sched_register_mutex);
> +
> +       tracing_stop_sched_switch();
> +}
> +
> +/**
> + * tracing_sched_switch_assign_trace - assign a trace array for ctx switch
>  * @tr: trace array pointer to assign
>  *
>  * Some tracers might want to record the context switches in their
>  * trace. This function lets those tracers assign the trace array
>  * to use.
>  */
> -void tracing_cmdline_assign_trace(struct trace_array *tr)
> +void tracing_sched_switch_assign_trace(struct trace_array *tr)
>  {
>        ctx_trace = tr;
>  }
> @@ -168,12 +198,12 @@ void tracing_cmdline_assign_trace(struct trace_array *tr)
>  static void start_sched_trace(struct trace_array *tr)
>  {
>        sched_switch_reset(tr);
> -       tracing_start_cmdline_record();
> +       tracing_start_sched_switch_record();
>  }
>
>  static void stop_sched_trace(struct trace_array *tr)
>  {
> -       tracing_stop_cmdline_record();
> +       tracing_stop_sched_switch_record();
>  }
>
>  static void sched_switch_trace_init(struct trace_array *tr)


Sorry, I misunderstood the sense of these functions and then used them only for
what they did: start/stop sched event capture.

Acked-by: Frederic Weisbecker < fweisbec@gmail.com>
