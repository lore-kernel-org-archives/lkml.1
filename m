Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbZEXUmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbZEXUmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 16:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZEXUmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 16:42:42 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:36939 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZEXUml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 16:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=yIQ2a5jLpG+Zig6IChlYoRXEzwWXHC7kp3lec0lNAjUGRQBsi6JXZo3EcAToxvXhyd
         izI1V2lkjmkiHcbdyfD2D5RQ8D0biE+JlOBBtjzGwQO5R5U7bFur1pM2beQutI3hulnp
         uwxWF3M/l4oAxfU0aCwDUk/3v/y+ij5mxneZU=
Date: Sun, 24 May 2009 22:42:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ftrace: Add task_comm support for trace_event
Message-ID: <20090524204240.GB6471@nowhere>
References: <4A14FDFE.2080402@cn.fujitsu.com> <4A16788F.2060802@cn.fujitsu.com> <4A1678F1.1060706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1678F1.1060706@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Fri, May 22, 2009 at 06:05:37PM +0800, Zhaolei wrote:
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


Thanks!
This is fine but I think it can be factorized.

You could call start_cmdline_record() from

ftrace_raw_reg_event_##call()

and the stop in

ftrace_raw_unreg_event_##call()

No?

Frederic.


> ---
>  kernel/trace/Kconfig        |    1 +
>  kernel/trace/trace_events.c |    6 ++++++
>  2 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index f61be30..dffbb77 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -187,6 +187,7 @@ config CONTEXT_SWITCH_TRACER
>  config ENABLE_EVENT_TRACING
>  	bool "Trace various events in the kernel"
>  	select TRACING
> +	select CONTEXT_SWITCH_TRACER
>  	help
>  	  This tracer hooks to various trace points in the kernel
>  	  allowing the user to pick and choose which trace point they
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 0eec0c5..df35e5e 100644
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




