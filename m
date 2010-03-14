Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab0CNKKB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:10:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:18896 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab0CNKKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 06:10:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BOk4LmmuUGlCulKEVP2ouEtTmMq06nb59GMVHfELo1zyDBpBRlaKwcYwtWdbu8l5Fa
         sZ/itAIeNni1psf7M9XnTxeGHOMBw5j55T4wbbKwAUt9ifzM4hkuMte7RKCMJm+tTjr2
         nBktkWFlmBMm43OtsIkkmQmh5qBsTc3a/w9eE=
Date: Sun, 14 Mar 2010 11:10:01 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       stable@kernel.org
Subject: Re: [PATCH 2/5] function-graph: Init curr_ret_stack with ret_stack
Message-ID: <20100314100959.GA5140@nowhere>
References: <20100313025655.104950166@goodmis.org> <20100313025854.558236650@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100313025854.558236650@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 09:56:57PM -0500, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> If the graph tracer is active, and a task is forked but the allocating of
> the processes graph stack fails, it can cause crash later on.
> 
> This is due to the temporary stack being NULL, but the curr_ret_stack
> variable is copied from the parent. If it is not -1, then in
> ftrace_graph_probe_sched_switch() the following:
> 
> 	for (index = next->curr_ret_stack; index >= 0; index--)
> 		next->ret_stack[index].calltime += timestamp;
> 
> Will cause a kernel OOPS.
> 
> Found with Li Zefan's ftrace_stress_test.
> 
> Cc: stable@kernel.org
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


Ah, well spotted!



> ---
>  kernel/trace/ftrace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index d4d1238..bb53edb 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -3349,6 +3349,7 @@ void ftrace_graph_init_task(struct task_struct *t)
>  {
>  	/* Make sure we do not use the parent ret_stack */
>  	t->ret_stack = NULL;
> +	t->curr_ret_stack = -1;
>  
>  	if (ftrace_graph_active) {
>  		struct ftrace_ret_stack *ret_stack;
> @@ -3358,7 +3359,6 @@ void ftrace_graph_init_task(struct task_struct *t)
>  				GFP_KERNEL);
>  		if (!ret_stack)
>  			return;
> -		t->curr_ret_stack = -1;
>  		atomic_set(&t->tracing_graph_pause, 0);
>  		atomic_set(&t->trace_overrun, 0);
>  		t->ftrace_timestamp = 0;
> -- 
> 1.7.0
> 
> 

