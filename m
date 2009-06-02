Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbZFBTCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbZFBTCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 15:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZFBTCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 15:02:32 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:47283 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZFBTCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 15:02:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J0VnAOwHKiDv1L8vAlN5Fxd7XIcE8XPgqhAzW0xbuYiDsZVHwBlmbc2M3IDUr2XXyQ
         hkYLDklj3Tfrm5pAiDyt9GcdlPsJS10CTj53tY79vu2eYK8KxlF8zhREhn4wdcqJS66I
         M2mh2qeVeuCpas3ngFGpKSu6qgTv2Vg1cM9P4=
Date: Tue, 2 Jun 2009 21:02:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 2/3] function-graph: enable the stack after
	initialization of other variables
Message-ID: <20090602190227.GB6041@nowhere>
References: <20090602183036.621443366@goodmis.org> <20090602184601.206454309@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602184601.206454309@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 02:30:38PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The function graph tracer checks if the task_struct has ret_stack defined
> to know if it is OK or not to use it. The initialization is done for
> all tasks by one process, but the idle tasks use the same initialization
> used by new tasks.
> 
> If an interrupt happens on an idle task that just had the ret_stack
> created, but before the rest of the initialization took place, then
> we can corrupt the return address of the functions.
> 
> This patch moves the setting of the task_struct's ret_stack to after
> the other variables have been initialized.
> 
> [ Impact: prevent kernel panic on idle task when starting function graph ]
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/ftrace.c                |    9 +++++++--
>  kernel/trace/trace_functions_graph.c |    6 ++++++
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index ebff62e..20e0660 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2739,15 +2739,20 @@ void unregister_ftrace_graph(void)
>  void ftrace_graph_init_task(struct task_struct *t)
>  {
>  	if (atomic_read(&ftrace_graph_active)) {
> -		t->ret_stack = kmalloc(FTRACE_RETFUNC_DEPTH
> +		struct ftrace_ret_stack *ret_stack;
> +
> +		ret_stack = kmalloc(FTRACE_RETFUNC_DEPTH
>  				* sizeof(struct ftrace_ret_stack),
>  				GFP_KERNEL);
> -		if (!t->ret_stack)
> +		if (!ret_stack)
>  			return;
>  		t->curr_ret_stack = -1;
>  		atomic_set(&t->tracing_graph_pause, 0);
>  		atomic_set(&t->trace_overrun, 0);
>  		t->ftrace_timestamp = 0;
> +		/* make curr_ret_stack visable before we add the ret_stack */
> +		smp_wmb();
> +		t->ret_stack = ret_stack;
>  	} else
>  		t->ret_stack = NULL;
>  }


Thanks for fixing this.


> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index d28687e..baeb5fe 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -65,6 +65,12 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth)
>  	if (!current->ret_stack)
>  		return -EBUSY;
>  
> +	/*
> +	 * We must make sure the ret_stack is tested before we read
> +	 * anything else.
> +	 */
> +	smp_rmb();


Isn't this part a too much costly for very traced function?


> +
>  	/* The return trace stack is full */
>  	if (current->curr_ret_stack == FTRACE_RETFUNC_DEPTH - 1) {
>  		atomic_inc(&current->trace_overrun);
> -- 
> 1.6.3.1
> 
> -- 

