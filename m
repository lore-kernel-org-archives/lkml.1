Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652Ab0AYGTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab0AYGTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 01:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525Ab0AYGTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 01:19:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52432 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab0AYGTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 01:19:23 -0500
Message-ID: <4B5D3779.2040807@cn.fujitsu.com>
Date: Mon, 25 Jan 2010 14:17:29 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC PATCH 05/10] ftrace: Drop buffer check in function profiler
 callbacks
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com> <1264122982-1553-6-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1264122982-1553-6-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Drop the null check on hlist->hash. It is wasteful because
> we don't register the tracer if the buffer allocation failed,
> and the memory barrier in register_ftrace_graph() ensure it
> is visible to the callbacks right away.
> 

When it is on a cpu which is just came up, hlist->hash is not
allocated either.

See ftrace_profile_init().

function_profile_call(), profile_graph_entry() and profile_graph_return()
on a just online cpu are wasteful. I think we need call
ftrace_profile_init_cpu()(if ftrace_profile_enabled=1) when CPU_UP_PREPARE.

> Also we know the tracing callbacks won't be called after
> register_ftrace_graph(), so subsequent buffer resets are safe
> too.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/trace/ftrace.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 3cdb35e..dfd8f7c 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -384,8 +384,6 @@ function_profile_call(unsigned long ip, unsigned long parent_ip)
>  	local_irq_save(flags);
>  
>  	hlist = &__get_cpu_var(func_hlist_cpu);
> -	if (!hlist->hash)
> -		goto out;
>  
>  	rec = function_find_hlist_node(hlist, ip);
>  	if (!rec) {
> @@ -415,8 +413,6 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
>  
>  	local_irq_save(flags);
>  	hlist = &__get_cpu_var(func_hlist_cpu);
> -	if (!hlist->hash)
> -		goto out;
>  
>  	calltime = trace->rettime - trace->calltime;
>  
> @@ -439,7 +435,6 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
>  	if (rec)
>  		rec->time += calltime;
>  
> - out:
>  	local_irq_restore(flags);
>  }
>  

