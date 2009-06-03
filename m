Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbZFCVs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbZFCVs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbZFCVsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:48:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:58385 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbZFCVsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:48:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eJntMw9dkq086Gkc3MoD4ctL8GmusA2CwZyxdOYSsFrYzVgU31N/wuo53CuegE1wa0
         +sREOApDHyl5p6a5m70Vf9MBAwyoTg2j4KyRi4QgXV8Zmt+LMcFOBJYMCsXENYK4A+D1
         tGp1iSQYMtJ6XHoqpG/7IPrIlyuKuE55P5nPA=
Date: Wed, 3 Jun 2009 23:48:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2][GIT PULL] tracing: add trace_stack interface
Message-ID: <20090603214814.GA5193@nowhere>
References: <alpine.DEB.2.00.0905192043090.7816@gandalf.stny.rr.com> <alpine.DEB.2.00.0905192108560.7816@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905192108560.7816@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 09:09:40PM -0400, Steven Rostedt wrote:
> 
> Ingo,
> 
> I rebased because I forgot to add EXPORT_SYMBOL_GPL.
> 
> -- Steve
> 
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Steven Rostedt (1):
>       tracing: add trace_stack interface
> 
> ----
>  include/linux/kernel.h |    2 ++
>  kernel/trace/trace.c   |   16 ++++++++++++++++
>  2 files changed, 18 insertions(+), 0 deletions(-)
> ---------------------------
> commit 9f6b28655254b91c48f684b367ac14bfec0e180a
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Tue May 19 18:54:16 2009 -0400
> 
>     tracing: add trace_stack interface
>     
>     This patch adds the global function
>     
>       void trace_stack(void)
>     
>     This allows a developer to find where a function is called. For example,
>     if you want to know who calls __netif_reschedule, you can add
>     
>      static inline void __netif_reschedule(struct Qdisc *q)
>      {
>      	struct softnet_data *sd;
>      	unsigned long flags;
>     
>     +	trace_stack();
>      	local_irq_save(flags);
>      	sd = &__get_cpu_var(softnet_data);
>      	q->next_sched = sd->output_queue;
>     
>     And see the following in the trace output:
>     
>      <= __ftrace_trace_stack
>      <= trace_stack
>      <= __netif_schedule
>      <= dev_watchdog
>      <= run_timer_softirq
>      <= __do_softirq
>      <= call_softirq
>      <= do_softirq
>      <= irq_exit
>     
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


I wanted to use it to get the recursive locking points in reiserfs
but I can't find it.

Has it been merged in -tip ?

Thanks.


 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 883cd44..347a0f1 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -511,6 +511,7 @@ extern int
>  __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap);
>  
>  extern void ftrace_dump(void);
> +extern void trace_stack(void);
>  #else
>  static inline void
>  ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
> @@ -531,6 +532,7 @@ ftrace_vprintk(const char *fmt, va_list ap)
>  	return 0;
>  }
>  static inline void ftrace_dump(void) { }
> +static inline void trace_stack(void) { }
>  #endif /* CONFIG_TRACING */
>  
>  /*
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index dd40d23..7bfd4f2 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1046,6 +1046,22 @@ void __trace_stack(struct trace_array *tr,
>  	__ftrace_trace_stack(tr, flags, skip, pc);
>  }
>  
> +/**
> + * trace_stack - dump the stack into the trace buffer
> + *
> + * Use this to record the stack trace into the ring buffer. If you
> + * want to know a caller of a function, place a call to trace_stack
> + * and the ftrace trace file will display who the callers were.
> + */
> +void trace_stack(void)
> +{
> +	unsigned long flags;
> +
> +	local_save_flags(flags);
> +	__trace_stack(&global_trace, flags, 0, preempt_count());
> +}
> +EXPORT_SYMBOL_GPL(trace_stack);
> +
>  static void ftrace_trace_userstack(struct trace_array *tr,
>  				   unsigned long flags, int pc)
>  {
> 
> 

