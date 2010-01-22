Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804Ab0AVCF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab0AVCF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 21:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784Ab0AVCF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 21:05:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58809 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab0AVCFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 21:05:25 -0500
X-Authority-Analysis: v=1.0 c=1 a=6AAhZGXoe_sA:10 a=7U3hwN5JcxgA:10 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=omOdbC7AAAAA:8 a=ex75lLLrguAz9n5qXsUA:9 a=ekfgY99uOCNq_RNwB2kA:7 a=Ysap_VcPAqNg06gailirXbnhuooA:4 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH 03/10] ftrace: Drop the ftrace_profile_enabled
 checks in tracing hot path
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <1264122982-1553-4-git-send-regression-fweisbec@gmail.com>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
	 <1264122982-1553-4-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 21 Jan 2010 21:05:17 -0500
Message-ID: <1264125917.31321.312.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 02:16 +0100, Frederic Weisbecker wrote:
> Every time we enter the function profiler tracing callbacks, we first
> check if the function profiling is enabled.
> 
> This check is useless because we register the function graph
> callbacks only after the hashlist has been initialized.

Unfortunately, since the previous patch is incorrect, it makes this one
buggy too.

If you remove the check to ftrace_profile_enabled, the call to the
profiled code could have been preempted and pending to be called.

Stop machine may remove all calls to the tracing, but it only affects
new hits. Pending hits may still exist.

If you remove this check, and the user re-enables the profiling, then
all PER_CPU hashs will be reset. If in the process of this happening,
the task with the pending trace wakes up, it may access the PER_CPU list
and corrupt it.

Now for the reason I Cc'd Paul and Mathieu...

If we had a synchronize_sched() like function that would wait and return
when all preempted tasks have been scheduled again and went to either
userspace or called schedule directly, then we could actually do this.

After unregistering the function graph trace, you call this
"synchronize_tasks()" and it will guarantee that all currently preempted
tasks have either went to userspace or have called schedule() directly.
Then it would be safe to remove this check.

-- Steve

> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/trace/ftrace.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 94117ec..f258f67 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -381,13 +381,10 @@ function_profile_call(unsigned long ip, unsigned long parent_ip)
>  	struct func_node *rec;
>  	unsigned long flags;
>  
> -	if (!ftrace_profile_enabled)
> -		return;
> -
>  	local_irq_save(flags);
>  
>  	hlist = &__get_cpu_var(func_hlist_cpu);
> -	if (!hlist->hash || !ftrace_profile_enabled)
> +	if (!hlist->hash)
>  		goto out;
>  
>  	rec = function_find_hlist_node(hlist, ip);
> @@ -418,7 +415,7 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
>  
>  	local_irq_save(flags);
>  	hlist = &__get_cpu_var(func_hlist_cpu);
> -	if (!hlist->hash || !ftrace_profile_enabled)
> +	if (!hlist->hash)
>  		goto out;
>  
>  	calltime = trace->rettime - trace->calltime;


