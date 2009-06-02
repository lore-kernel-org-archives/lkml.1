Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZFBWY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZFBWY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZFBWYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:24:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:36195 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZFBWYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:24:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eT5v068he0mdtxM9fBHtaRs3lESeS78nIP74b9HGIKdACug4p92HLGFrFe24MoB8E+
         g5hWdwmla5JZju37cn4ux+9DyzmGZR+2A1tYzAz1+i8oPEo5YqIcCRsLuF5OTST2dT7n
         h7swWR9FH+fHui2njo8rgXK1aHhERCkUItdHo=
Date: Wed, 3 Jun 2009 00:24:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/2] function-graph: move initialization of new tasks
	up in fork
Message-ID: <20090602222443.GC6041@nowhere>
References: <20090602220212.894951549@goodmis.org> <20090602220309.575197235@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602220309.575197235@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 06:02:13PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> When the function graph tracer is enabled, all new tasks must allocate
> a ret_stack to place the return address of functions. This is because
> the function graph tracer will replace the real return address with a
> call to the tracing of the exit function.
> 
> This initialization happens in fork, but it happens too late. If fork
> fails, then it will call free_task and that calls the freeing of this
> ret_stack. But before initialization happens, the new (failed) task
> points to its parents ret_stack. If a fork failure happens during
> the function trace, it would be catastrophic for the parent.
> 
> Also, there's no need to call ftrace_graph_exit_task from fork, since
> it is called by free_task which fork calls on failure.
> 
> [ Impact: prevent crash during failed fork running function graph tracer ]
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


Ah, thanks a lot. It was on my TODO list.
Oleg Nesterov reported me that problem...

Frederic.


> ---
>  kernel/fork.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b9e2edd..c4b1e35 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -982,6 +982,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	if (!p)
>  		goto fork_out;
>  
> +	ftrace_graph_init_task(p);
> +
>  	rt_mutex_init_task(p);
>  
>  #ifdef CONFIG_PROVE_LOCKING
> @@ -1131,8 +1133,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  		}
>  	}
>  
> -	ftrace_graph_init_task(p);
> -
>  	p->pid = pid_nr(pid);
>  	p->tgid = p->pid;
>  	if (clone_flags & CLONE_THREAD)
> @@ -1141,7 +1141,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	if (current->nsproxy != p->nsproxy) {
>  		retval = ns_cgroup_clone(p, pid);
>  		if (retval)
> -			goto bad_fork_free_graph;
> +			goto bad_fork_free_pid;
>  	}
>  
>  	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
> @@ -1233,7 +1233,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  		spin_unlock(&current->sighand->siglock);
>  		write_unlock_irq(&tasklist_lock);
>  		retval = -ERESTARTNOINTR;
> -		goto bad_fork_free_graph;
> +		goto bad_fork_free_pid;
>  	}
>  
>  	if (clone_flags & CLONE_THREAD) {
> @@ -1268,8 +1268,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	cgroup_post_fork(p);
>  	return p;
>  
> -bad_fork_free_graph:
> -	ftrace_graph_exit_task(p);
>  bad_fork_free_pid:
>  	if (pid != &init_struct_pid)
>  		free_pid(pid);
> -- 
> 1.6.3.1
> 
> -- 

