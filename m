Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbZHQQtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbZHQQtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 12:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbZHQQtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 12:49:14 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:52010 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499AbZHQQtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 12:49:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kPX5bZr5wNgRJHTD2U5gJnjBGUiR63SuNd2/lmIuPYUUxTEwN5V1nUwBSfHBhNK1eL
         SGvTbctA5/YeYWqx18PbEq6DnpUYiv3Vjj4Yg4udYbsLSSUufpEM/RPWYIkDeZzqly78
         8AUoFerdRGvSq8XOd5D7UEyGjCG3N+W/QGb7g=
Date: Mon, 17 Aug 2009 18:49:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] Add timer-source of walltime for ftrace
Message-ID: <20090817164909.GB4953@nowhere>
References: <4A698F90.90501@cn.fujitsu.com> <alpine.DEB.2.00.0907240902030.17438@gandalf.stny.rr.com> <20090728103227.D7FB.A69D9226@jp.fujitsu.com> <20090728015351.GF5147@nowhere> <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com> <4A89213C.5090109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A89213C.5090109@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 05:22:04PM +0800, Zhaolei wrote:
> We can add a timer-source for ftrace to support wall-time display.
> It is based on Steven Rostedt <rostedt@goodmis.org>'s suggestion in:
> http://lkml.org/lkml/2009/7/24/103
> 
> It needs to be applied on my patch of:
> [PATCH v4 1/2] Add function to convert between calendar time and broken-down time for universal use
> and
> [PATCH v2 2/2] ftrace: Unify effect of writing to trace_options and option/*
> 
> We can get following output:
>  # cd /mnt/debugfs/tracing/
>  # ls options/*clock
>  options/global-clock  options/local-clock  options/walltime-clock
>  # echo sched_switch > current_tracer
>  # cat trace
>  # tracer: sched_switch
>  #
>  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>  #              | |       |          |         |
>              bash-3560  [000]   694.242386:   3560:120:S   + [000]  3560:120:S bash
>              bash-3560  [000]   694.242476:   3560:120:S   + [000]  3560:120:S bash
>              bash-3560  [000]   694.242865:   3560:120:R   + [000]     5:115:S events/0
>              bash-3560  [000]   694.242912:   3560:120:R ==> [000]     5:115:R events/0
>          events/0-5     [000]   694.243015:      5:115:R   + [000]  3558:120:S sshd
>          events/0-5     [000]   694.243040:      5:115:S ==> [000]  3560:120:R bash
>              bash-3560  [000]   694.243312:   3560:120:S   + [000]  3560:120:S bash
>              bash-3560  [000]   694.243374:   3560:120:S ==> [000]  3558:120:R sshd
>  ...
>  # echo 1 > options/walltime-clock
>  # echo > trace
>  # cat trace
>  # tracer: sched_switch
>  #
>  #           TASK-PID    CPU#           TIMESTAMP  FUNCTION
>  #              | |       |                 |         |
>              bash-3560  [000] 2009-08-17 23:58:22   3560:120:S   + [000]  3560:120:S bash
>              bash-3560  [000] 2009-08-17 23:58:22   3560:120:R   + [000]     5:115:S events/0
>              bash-3560  [000] 2009-08-17 23:58:22   3560:120:R ==> [000]     5:115:R events/0
>          events/0-5     [000] 2009-08-17 23:58:22      5:115:R   + [000]  3558:120:S sshd
>          events/0-5     [000] 2009-08-17 23:58:22      5:115:S ==> [000]  3558:120:R sshd
>              sshd-3558  [000] 2009-08-17 23:58:22   3558:120:S ==> [000]  3560:120:R bash
>              bash-3560  [000] 2009-08-17 23:58:22   3560:120:S   + [000]  3560:120:S bash
>              bash-3560  [000] 2009-08-17 23:58:22   3560:120:S   + [000]  3560:120:S bash
>  ...
> 
> Note:
> It is only a prototype patch to for demostrate what is result looks like.
> There still have many works to do(bug to fix) before apply.
> For example, we need to add a hook(tracepoint) of xtime change event,
> so we can update walltime's clock base then.
> And maybe we need clear all events when changing clock-source, because old
> clock value can't displayed correctly in new clock's format.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  include/linux/trace_clock.h |    1 +
>  kernel/trace/trace.c        |   55 ++++++++++++++++++++++++++++++------------
>  kernel/trace/trace.h        |    6 +++-
>  kernel/trace/trace_clock.c  |   47 ++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_output.c |   20 ++++++++++++---
>  5 files changed, 107 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
> index 7a81303..322707e 100644
> --- a/include/linux/trace_clock.h
> +++ b/include/linux/trace_clock.h
> @@ -15,5 +15,6 @@
>  extern u64 notrace trace_clock_local(void);
>  extern u64 notrace trace_clock(void);
>  extern u64 notrace trace_clock_global(void);
> +extern u64 notrace trace_clock_walltime(void);
>  
>  #endif /* _LINUX_TRACE_CLOCK_H */
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index b7d873b..4474f7d 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -263,8 +263,8 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
>  
>  /* trace_flags holds trace_options default values */
>  unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
> -	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
> -	TRACE_ITER_GRAPH_TIME;
> +	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_LOCAL_CLK |
> +	TRACE_ITER_SLEEP_TIME | TRACE_ITER_GRAPH_TIME;
>  
>  /**
>   * trace_wake_up - wake up tasks waiting for trace input
> @@ -324,6 +324,8 @@ static const char *trace_options[] = {
>  	"context-info",
>  	"latency-format",
>  	"global-clock",
> +	"local-clock",
> +	"walltime-clock",
>  	"sleep-time",
>  	"graph-time",
>  	NULL
> @@ -1423,8 +1425,17 @@ static void print_lat_help_header(struct seq_file *m)
>  
>  static void print_func_help_header(struct seq_file *m)
>  {
> -	seq_puts(m, "#           TASK-PID    CPU#    TIMESTAMP  FUNCTION\n");
> -	seq_puts(m, "#              | |       |          |         |\n");
> +	if (trace_flags & TRACE_ITER_WALLTIME_CLK) {
> +		seq_puts(m, "#           TASK-PID    CPU# "
> +			"          TIMESTAMP  FUNCTION\n");
> +		seq_puts(m, "#              | |       |   "
> +			"              |         |\n");
> +	} else {
> +		seq_puts(m, "#           TASK-PID    CPU# "
> +			"   TIMESTAMP  FUNCTION\n");
> +		seq_puts(m, "#              | |       |   "
> +			"       |         |\n");
> +	}
>  }
>  
>  
> @@ -2151,30 +2162,42 @@ static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
>  
>  static void set_tracer_flags(unsigned int mask, int enabled)
>  {
> +	u64 (*clkfunc)(void) = NULL;
> +
>  	/* do nothing if flag is already set */
>  	if (!!(trace_flags & mask) == !!enabled)
>  		return;
>  
> -	if (enabled)
> -		trace_flags |= mask;
> -	else
> -		trace_flags &= ~mask;
> +	if (mask == TRACE_ITER_GLOBAL_CLK)
> +		clkfunc = trace_clock_global;
> +	if (mask == TRACE_ITER_LOCAL_CLK)
> +		clkfunc = trace_clock_local;
> +	if (mask == TRACE_ITER_WALLTIME_CLK)
> +		clkfunc = trace_clock_walltime;
>  
> -	if (mask == TRACE_ITER_GLOBAL_CLK) {
> -		u64 (*func)(void);
> +	if (clkfunc) {
> +		if (!enabled)
> +			return;



If the user set a clock option file to 0, then it means he
was expecting something, probably reset the default clock
which is clock_local.

But what if the user set 0 to the local_clock...hmm..


