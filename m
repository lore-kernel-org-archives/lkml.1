Return-Path: <linux-kernel-owner+w=401wt.eu-S1752049AbZHSQOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbZHSQOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbZHSQOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:14:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55882 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751049AbZHSQOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:14:40 -0400
Date: Wed, 19 Aug 2009 12:13:25 -0400
From: Jason Baron <jbaron@redhat.com>
To: Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH] tracing: Move tracepoint callbacks into DEFINE
Message-ID: <20090819161324.GB2649@redhat.com>
References: <1250580227-24363-1-git-send-email-jistone@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250580227-24363-1-git-send-email-jistone@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 12:23:47AM -0700, Josh Stone wrote:
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -243,6 +243,11 @@ static void set_tracepoint(struct tracepoint_entry **entry,
>  {
>  	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
>  
> +	if (elem->regfunc && !elem->state && active)
> +		elem->regfunc();
> +	else if (elem->unregfunc && elem->state && !active)
> +		elem->unregfunc();
> +
>  	/*
>  	 * rcu_assign_pointer has a smp_wmb() which makes sure that the new
>  	 * probe callbacks array is consistent before setting a pointer to it.
> @@ -262,6 +267,9 @@ static void set_tracepoint(struct tracepoint_entry **entry,
>   */
>  static void disable_tracepoint(struct tracepoint *elem)
>  {
> +	if (elem->unregfunc && elem->state)
> +		elem->unregfunc();
> +
>  	elem->state = 0;
>  	rcu_assign_pointer(elem->funcs, NULL);
>  }
> @@ -581,15 +589,13 @@ __initcall(init_tracepoints);
>  
>  #ifdef CONFIG_FTRACE_SYSCALLS
>  
> -static DEFINE_MUTEX(regfunc_mutex);
> -static int sys_tracepoint_refcount;
> +static int sys_tracepoint_refcount; /* guarded by tracepoints_mutex */
>  
>  void syscall_regfunc(void)
>  {
>  	unsigned long flags;
>  	struct task_struct *g, *t;
>  
> -	mutex_lock(&regfunc_mutex);
>  	if (!sys_tracepoint_refcount) {
>  		read_lock_irqsave(&tasklist_lock, flags);
>  		do_each_thread(g, t) {
> @@ -598,7 +604,6 @@ void syscall_regfunc(void)
>  		read_unlock_irqrestore(&tasklist_lock, flags);
>  	}
>  	sys_tracepoint_refcount++;
> -	mutex_unlock(&regfunc_mutex);
>  }
>  
>  void syscall_unregfunc(void)
> @@ -606,7 +611,6 @@ void syscall_unregfunc(void)
>  	unsigned long flags;
>  	struct task_struct *g, *t;
>  
> -	mutex_lock(&regfunc_mutex);
>  	sys_tracepoint_refcount--;
>  	if (!sys_tracepoint_refcount) {
>  		read_lock_irqsave(&tasklist_lock, flags);
> @@ -615,6 +619,5 @@ void syscall_unregfunc(void)
>  		} while_each_thread(g, t);
>  		read_unlock_irqrestore(&tasklist_lock, flags);
>  	}
> -	mutex_unlock(&regfunc_mutex);
>  }
>  #endif

if we disable,  CONFIG_FTRACE_SYSCALLS, then we get undefined references
to syscall_regfunc, and syscall_unregfunc. So, i think we just need to
remove the 'CONFIG_FTRACE_SYSCALLS' ifdef here.

thanks,

-Jason
