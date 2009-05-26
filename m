Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbZEZApD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbZEZApD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 20:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZEZAoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 20:44:54 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:37826 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbZEZAoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 20:44:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aqiJ8Nv9unZP+XO/RNyUzpkZygk6IO9e/H0aDL45hbWXudD1NuQBX9odHEa4tJFW6w
         EahQLNdGR/Mnav9bl5RjIpOTYiVhD5MAwUs6AJQVTeFm+TT1lanvG+WZcGayL0y6jqcU
         dwaUcpulk23/4zqtey8T2edqxjBbKJ8yENzdE=
Date: Tue, 26 May 2009 02:44:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] ftrace: Add task_comm support for trace_event
Message-ID: <20090526004451.GF7879@nowhere>
References: <4A14FDFE.2080402@cn.fujitsu.com> <4A16788F.2060802@cn.fujitsu.com> <20090522115108.GA10992@elte.hu> <4A1A6CE8.2050100@cn.fujitsu.com> <4A1A6EEF.2090902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1A6EEF.2090902@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 06:11:59PM +0800, Zhaolei wrote:
> If we use trace_event alone(without function trace, .etc),
> it can't output enough task command information.
> 
> Before patch:
>  # echo 1 > debugfs/tracing/events/sched/sched_switch/enable
>  # cat debugfs/tracing/trace
>  # tracer: nop
>  #
>  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>  #              | |       |          |         |
>             <...>-2289  [000] 526276.724790: sched_switch: task bash:2289 [120] ==> sshd:2287 [120]
>             <...>-2287  [000] 526276.725231: sched_switch: task sshd:2287 [120] ==> bash:2289 [120]
>             <...>-2289  [000] 526276.725452: sched_switch: task bash:2289 [120] ==> sshd:2287 [120]
>             <...>-2287  [000] 526276.727181: sched_switch: task sshd:2287 [120] ==> swapper:0 [140]
>            <idle>-0     [000] 526277.032734: sched_switch: task swapper:0 [140] ==> events/0:5 [115]
>             <...>-5     [000] 526277.032782: sched_switch: task events/0:5 [115] ==> swapper:0 [140]
>  ...
> 
> After patch:
>  # tracer: nop
>  #
>  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>  #              | |       |          |         |
>              bash-2269  [000] 527347.989229: sched_switch: task bash:2269 [120] ==> sshd:2267 [120]
>              sshd-2267  [000] 527347.990960: sched_switch: task sshd:2267 [120] ==> bash:2269 [120]
>              bash-2269  [000] 527347.991143: sched_switch: task bash:2269 [120] ==> sshd:2267 [120]
>              sshd-2267  [000] 527347.992959: sched_switch: task sshd:2267 [120] ==> swapper:0 [140]
>            <idle>-0     [000] 527348.531989: sched_switch: task swapper:0 [140] ==> events/0:5 [115]
>          events/0-5     [000] 527348.532115: sched_switch: task events/0:5 [115] ==> swapper:0 [140]
>  ...
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  kernel/trace/Kconfig        |    9 +++++++--
>  kernel/trace/trace_events.c |    6 ++++++
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index f61be30..a508b9d 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -49,6 +49,11 @@ config FTRACE_NMI_ENTER
>         default y
>  
>  config EVENT_TRACING
> +	select CONTEXT_SWITCH_TRACER
> +	bool
> +
> +config CONTEXT_SWITCH_TRACER
> +	select MARKERS
>  	bool
>  
>  config TRACING
> @@ -176,10 +181,10 @@ config SCHED_TRACER
>  	  This tracer tracks the latency of the highest priority task
>  	  to be scheduled in, starting from the point it has woken up.
>  
> -config CONTEXT_SWITCH_TRACER
> +config ENABLE_CONTEXT_SWITCH_TRACER
>  	bool "Trace process context switches"
>  	select TRACING
> -	select MARKERS
> +	select CONTEXT_SWITCH_TRACER



I didn't like this part at a first glance.
But actually that makes sense.

I don't think it would be that worth to separate the cmdline record
from the sched switch tracer because they are both too tight in essence.

So this new ENABLE_CONTEXT_SWITCH_TRACER seems to me a good way
to solve this problem.

Thanks,
Frederic.



>  	help
>  	  This tracer gets called from the context switch and records
>  	  all switching of tasks.
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 9e91c4a..9b246eb 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -85,6 +85,7 @@ static void ftrace_clear_events(void)
>  
>  		if (call->enabled) {
>  			call->enabled = 0;
> +			tracing_stop_cmdline_record();
>  			call->unregfunc();
>  		}
>  	}
> @@ -99,12 +100,14 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
>  	case 0:
>  		if (call->enabled) {
>  			call->enabled = 0;
> +			tracing_stop_cmdline_record();
>  			call->unregfunc();
>  		}
>  		break;
>  	case 1:
>  		if (!call->enabled) {
>  			call->enabled = 1;
> +			tracing_start_cmdline_record();
>  			call->regfunc();
>  		}
>  		break;
> @@ -1058,6 +1061,7 @@ static void trace_module_remove_events(struct module *mod)
>  			found = true;
>  			if (call->enabled) {
>  				call->enabled = 0;
> +				tracing_stop_cmdline_record();
>  				call->unregfunc();
>  			}
>  			if (call->event)
> @@ -1262,11 +1266,13 @@ static __init void event_trace_self_tests(void)
>  		}
>  
>  		call->enabled = 1;
> +		tracing_start_cmdline_record();
>  		call->regfunc();
>  
>  		event_test_stuff();
>  
>  		call->unregfunc();
> +		tracing_stop_cmdline_record();
>  		call->enabled = 0;
>  
>  		pr_cont("OK\n");
> -- 
> 1.5.5.3
> 

