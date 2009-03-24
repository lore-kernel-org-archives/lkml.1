Return-Path: <linux-kernel-owner+w=401wt.eu-S1762168AbZCXT75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762168AbZCXT75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760350AbZCXT7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:59:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:7416 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759880AbZCXT7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:59:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tDDFFMcDxHjbS97l9SP7yCYoigCD4od685uhpEBdffXWGjPmQD3gpQeGgyivUHZBok
         BsArn1jU0l1HinR2VNL8KoDinHUgr/8flual03SH7h8XmOhEtXz/A8+O7FAfaVZNOVyS
         4tpQHygBGah3fyLeJ9LH8xyTVy7gevfRSzWSw=
Date: Tue, 24 Mar 2009 20:59:40 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH][GIT PULL] function-graph: add option for include sleep
	times
Message-ID: <20090324195939.GA5975@nowhere>
References: <20090324135422.026619569@goodmis.org> <20090324135610.441707783@goodmis.org> <20090324135833.GB32043@elte.hu> <alpine.DEB.2.00.0903241127290.22830@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903241127290.22830@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 11:28:09AM -0400, Steven Rostedt wrote:
> 
> Ingo,
> 
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Steven Rostedt (1):
>       function-graph: add option for include sleep times
> 
> ----
>  kernel/trace/ftrace.c |    7 +++++++
>  kernel/trace/trace.c  |    3 ++-
>  kernel/trace/trace.h  |    1 +
>  3 files changed, 10 insertions(+), 1 deletions(-)
> ---------------------------
> commit be6f164a02f394675e2ac2077dd354cebef5b4c0
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Tue Mar 24 11:06:24 2009 -0400
> 
>     function-graph: add option for include sleep times
>     
>     Impact: give user a choice to show times spent while sleeping
>     
>     The user may want to see the time a function spent sleeping.
>     This patch adds the trace option "sleep-time" to allow that.
>     The "sleep-time" option is default on.
>     
>      echo sleep-time > /debug/tracing/trace_options


Yeah, I thinks it's better to let it be chosen.
Thanks for this series!

Frederic.


     
>     produces:
>     
>      ------------------------------------------
>      2)  avahi-d-3428  =>    <idle>-0
>      ------------------------------------------
>     
>      2)               |      finish_task_switch() {
>      2)   0.621 us    |        _spin_unlock_irq();
>      2)   2.202 us    |      }
>      2) ! 1002.197 us |    }
>      2) ! 1003.521 us |  }
>     
>     where as,
>     
>      echo nosleep-time > /debug/tracing/trace_options
>     
>     produces:
>     
>      0)    <idle>-0    =>  yum-upd-3416
>      ------------------------------------------
>     
>      0)               |              finish_task_switch() {
>      0)   0.643 us    |                _spin_unlock_irq();
>      0)   2.342 us    |              }
>      0) + 41.302 us   |            }
>      0) + 42.453 us   |          }
>     
>     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 0b90364..02d2de9 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2599,6 +2599,13 @@ ftrace_graph_probe_sched_switch(struct rq *__rq, struct task_struct *prev,
>  	unsigned long long timestamp;
>  	int index;
>  
> +	/*
> +	 * Does the user want to count the time a function was asleep.
> +	 * If so, do not update the time stamps.
> +	 */
> +	if (trace_flags & TRACE_ITER_SLEEP_TIME)
> +		return;
> +
>  	timestamp = trace_clock_local();
>  
>  	prev->ftrace_timestamp = timestamp;
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index f0e1337..67c6a21 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -255,7 +255,7 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
>  
>  /* trace_flags holds trace_options default values */
>  unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
> -	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO;
> +	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME;
>  
>  /**
>   * trace_wake_up - wake up tasks waiting for trace input
> @@ -316,6 +316,7 @@ static const char *trace_options[] = {
>  	"context-info",
>  	"latency-format",
>  	"global-clock",
> +	"sleep-time",
>  	NULL
>  };
>  
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 7cfb741..d7410bb 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -683,6 +683,7 @@ enum trace_iterator_flags {
>  	TRACE_ITER_CONTEXT_INFO		= 0x20000, /* Print pid/cpu/time */
>  	TRACE_ITER_LATENCY_FMT		= 0x40000,
>  	TRACE_ITER_GLOBAL_CLK		= 0x80000,
> +	TRACE_ITER_SLEEP_TIME		= 0x100000,
>  };
>  
>  /*
> 
> 

