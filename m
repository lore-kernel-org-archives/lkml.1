Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZCFG6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZCFG6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZCFG6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:58:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59883 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbZCFG6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:58:38 -0500
Message-ID: <49B0C94E.6020300@cn.fujitsu.com>
Date: Fri, 06 Mar 2009 14:57:18 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH for tip][bugfix] ftrace: fix deadlock when setting set_ftrace_pid
References: <20090306151155.0778.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090306151155.0778.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Impact: fix deadlock bug
> 
> reproduce way:
> 	# cd /sys/kernel/debug/tracing
> 	# echo $$ > set_ftrace_pid
> 
> 	then, console become hangup.
> 
> detail:
> when writing set_ftracepid, kernel callstack is following
> 
> 	ftrace_pid_write()
> 		mutex_lock(&ftrace_lock);
> 		ftrace_update_pid_func()
> 			mutex_lock(&ftrace_lock);
> 			mutex_unlock(&ftrace_lock);
> 		mutex_unlock(&ftrace_lock);
> 
> then, system alaways deadlock when ftrace_pid_write() is called.
> 
> In past days, ftrace_pid_write() use ftrace_start_lock, but
> commit e6ea44e9b4c12325337cd1c06103cd515a1c02b2 consolidate
> ftrace_start_lock to ftrace_lock.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 5a3a06b..0d3b393 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -218,10 +218,8 @@ static void ftrace_update_pid_func(void)
>  {
>  	ftrace_func_t func;
>  
> -	mutex_lock(&ftrace_lock);
> -
>  	if (ftrace_trace_function == ftrace_stub)
> -		goto out;
> +		return;
>  
>  	func = ftrace_trace_function;
>  
> @@ -238,9 +236,6 @@ static void ftrace_update_pid_func(void)
>  #else
>  	__ftrace_trace_function = func;
>  #endif
> -
> - out:
> -	mutex_unlock(&ftrace_lock);
>  }
>  
>  /* set when tracing only a pid */
> 
> 

Reviewed-By: Lai Jiangshan <laijs@cn.fujitsu.com>


