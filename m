Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbYLXCT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbYLXCT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 21:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYLXCTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 21:19:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42418 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbYLXCTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 21:19:17 -0500
Date: Tue, 23 Dec 2008 21:19:15 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/ftrace: don't trace on early stage of
 secondary cpu boot
In-Reply-To: <49518535.8080105@gmail.com>
Message-ID: <alpine.DEB.1.10.0812232106080.6972@gandalf.stny.rr.com>
References: <49518535.8080105@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Dec 2008, Frederic Weisbecker wrote:

> Impact: fix a crash/hard reboot while enabling cpu on runtime
> 
> On some archs, the boot of a secondary cpu can have an early fragile state.
> On x86-64, the pda is not initialized on the first stage of a cpu boot but
> it is needed to get the cpu number and the current task pointer. These datas
> are needed during tracing. As they were dereferenced at this stage, we got a
> crash while turning on a cpu on runtime while tracing.
> 
> Some other archs like ia64 can have such kind of issue too.
> 
> This patch implements a function to verify if the cpu has been correctly initialized
> before tracing it. By default, the check does nothing but archs can override it (as does
> x86-64 in this patch).
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/x86/kernel/ftrace.c |   13 +++++++++++++
>  include/linux/ftrace.h   |    8 ++++++++
>  kernel/trace/ftrace.c    |    6 ++++++
>  kernel/trace/trace.c     |    6 +++---
>  4 files changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 1b43086..7693c53 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -24,6 +24,19 @@
>  #include <asm/nmi.h>
>  
>  
> +#ifdef CONFIG_X86_64
> +/*
> + * A cpu doesn't want to be traced if pda hasn't yet been initialized.
> + * Pda contains the cpu number and current task pointer. A lot
> + * of functions use them, not only ftrace.
> + * We use stack_smp_processor_id() here to avoid using the pda.
> + */
> +bool ftrace_in_early_cpuinit(void)
> +{
> +	return !cpu_isset(stack_smp_processor_id(), cpu_online_map);
> +}
> +#endif

Is there something lighter weight than this? This is called during the 
function tracer and that is called at ever function. I would also rather 
this be an inline function defined in asm/ftrace.h if possible.

> +
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  
>  union ftrace_code_union {
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 677432b..9a86e3d 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -78,6 +78,14 @@ void clear_ftrace_function(void);
>  
>  extern void ftrace_stub(unsigned long a0, unsigned long a1);
>  
> +/*
> + * On some archs, the secondary cpu boot is sometimes fragile.
> + * Some important datas could be not yet initialized. In such states,
> + * tracing is too dangerous and we use this function to detect these
> + * kinds of context. Archs which have this sort of issues can override it.
> + */
> +extern bool ftrace_in_early_cpuinit(void);
> +
>  #else /* !CONFIG_FUNCTION_TRACER */
>  # define register_ftrace_function(ops) do { } while (0)
>  # define unregister_ftrace_function(ops) do { } while (0)
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 2f32969..463e1eb 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1962,6 +1962,12 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
>  	return ret;
>  }
>  
> +/* Overriden by archs if needed */
> +bool __attribute__((weak)) ftrace_in_early_cpuinit(void)
> +{
> +	return false;
> +}
> +
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  
>  static atomic_t ftrace_graph_active;
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index b07e34e..1ac9b98 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1175,7 +1175,7 @@ function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
>  	int cpu, resched;
>  	int pc;
>  
> -	if (unlikely(!ftrace_function_enabled))
> +	if (unlikely(!ftrace_function_enabled || ftrace_in_early_cpuinit()))
>  		return;
>  
>  	pc = preempt_count();
> @@ -1202,7 +1202,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
>  	int cpu;
>  	int pc;
>  
> -	if (unlikely(!ftrace_function_enabled))
> +	if (unlikely(!ftrace_function_enabled || ftrace_in_early_cpuinit()))
>  		return;
>  
>  	/*
> @@ -1233,7 +1233,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
>  	int cpu;
>  	int pc;
>  
> -	if (!ftrace_trace_task(current))
> +	if (!ftrace_trace_task(current) || ftrace_in_early_cpuinit())
>  		return 0;

Actually, didn't you say current is not available either? We are testing 
current first.

I still wonder if there's a better way to find out if it is safe to run.
Perhaps the arch code can test the %gs register to see if it is actually 
something valid?

-- Steve


>  
>  	if (!ftrace_graph_addr(trace->func))
> -- 
> 1.6.0.4
> 
> 
> 
