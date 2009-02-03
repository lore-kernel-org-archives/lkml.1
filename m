Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbZBCJbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbZBCJbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZBCJbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:31:09 -0500
Received: from mail-fx0-f31.google.com ([209.85.220.31]:39246 "EHLO
	mail-fx0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZBCJbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:31:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TGklMq90tzHD7VMZXCLHDaqNPvh+d43gIgDENXL+pdVTCk43z5D+bJle+3KTT0Fowu
         +A1A6GMZODdVcKMYKa1TOXjZX3EUdVbfFyslNCBjWQADme9fzJyacyv6Ezby+rmvlcsS
         gJSqlqATghryqRp3/AvtZyZPkS/QEu2LHEYns=
Date: Tue, 3 Feb 2009 10:31:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] trace: let boot trace be chosen by command line
Message-ID: <20090203093101.GC23466@nowhere>
References: <20090203023830.440860800@goodmis.org> <20090203024358.531245194@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203024358.531245194@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 09:38:33PM -0500, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Now that we have a working ftrace=<tracer> function, make the boot
> tracer get activated by it. This way we can turn it on or off without
> recompiling the kernel, as well as keeping the selftests on. The
> selftests are disabled whenever a default tracer starts running.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/Kconfig      |    7 +++----
>  kernel/trace/trace.c      |    5 +----
>  kernel/trace/trace_boot.c |   11 +++++++----
>  3 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 2780665..8115daf 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -164,9 +164,8 @@ config BOOT_TRACER
>  	  representation of the delays during initcalls - but the raw
>  	  /debug/tracing/trace text output is readable too.
>  
> -	  ( Note that tracing self tests can't be enabled if this tracer is
> -	    selected, because the self-tests are an initcall as well and that
> -	    would invalidate the boot trace. )
> +	  You must pass in ftrace=initcall to the kernel command line
> +	  to enable this on bootup.
>  
>  config TRACE_BRANCH_PROFILING
>  	bool "Trace likely/unlikely profiler"
> @@ -328,7 +327,7 @@ config FTRACE_SELFTEST
>  
>  config FTRACE_STARTUP_TEST
>  	bool "Perform a startup test on ftrace"
> -	depends on TRACING && DEBUG_KERNEL && !BOOT_TRACER
> +	depends on TRACING && DEBUG_KERNEL
>  	select FTRACE_SELFTEST
>  	help
>  	  This option performs a series of startup tests on ftrace. On bootup
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 2c720c7..40edef4 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3167,12 +3167,9 @@ __init static int tracer_alloc_buffers(void)
>  	trace_init_cmdlines();
>  
>  	register_tracer(&nop_trace);
> +	current_trace = &nop_trace;
>  #ifdef CONFIG_BOOT_TRACER
>  	register_tracer(&boot_tracer);
> -	current_trace = &boot_tracer;
> -	current_trace->init(&global_trace);
> -#else
> -	current_trace = &nop_trace;
>  #endif
>  	/* All seems OK, enable tracing */
>  	tracing_disabled = 0;
> diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
> index 0e94b3d..1f07895 100644
> --- a/kernel/trace/trace_boot.c
> +++ b/kernel/trace/trace_boot.c
> @@ -28,13 +28,13 @@ void start_boot_trace(void)
>  
>  void enable_boot_trace(void)
>  {
> -	if (pre_initcalls_finished)
> +	if (boot_trace && pre_initcalls_finished)
>  		tracing_start_sched_switch_record();
>  }
>  
>  void disable_boot_trace(void)
>  {
> -	if (pre_initcalls_finished)
> +	if (boot_trace && pre_initcalls_finished)
>  		tracing_stop_sched_switch_record();
>  }
>  
> @@ -43,6 +43,9 @@ static int boot_trace_init(struct trace_array *tr)
>  	int cpu;
>  	boot_trace = tr;
>  
> +	if (!tr)
> +		return 0;
> +
>  	for_each_cpu(cpu, cpu_possible_mask)
>  		tracing_reset(tr, cpu);
>  
> @@ -132,7 +135,7 @@ void trace_boot_call(struct boot_trace_call *bt, initcall_t fn)
>  	unsigned long irq_flags;
>  	struct trace_array *tr = boot_trace;
>  
> -	if (!pre_initcalls_finished)
> +	if (!tr || !pre_initcalls_finished)
>  		return;
>  
>  	/* Get its name now since this function could
> @@ -164,7 +167,7 @@ void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn)
>  	unsigned long irq_flags;
>  	struct trace_array *tr = boot_trace;
>  
> -	if (!pre_initcalls_finished)
> +	if (!tr || !pre_initcalls_finished)
>  		return;
>  
>  	sprint_symbol(bt->func, (unsigned long)fn);
> -- 
> 1.5.6.5
> 
> -- 

Thanks, now I should turn out the initcall_debug dependency for the boot tracer
to actually trace. I should even make it trace the async calls BTW ...

