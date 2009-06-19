Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbZFSI3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbZFSI3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 04:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZFSI3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 04:29:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63339 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbZFSI3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 04:29:31 -0400
Message-ID: <4A3B4CCD.5080308@cn.fujitsu.com>
Date: Fri, 19 Jun 2009 16:31:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, bligh@google.com,
       roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 4/7] add syscall tracepoints
References: <cover.1244837725.git.jbaron@redhat.com> <46da2de326aa9ea1a9764cd421dd2ded70218c47.1244837725.git.jbaron@redhat.com>
In-Reply-To: <46da2de326aa9ea1a9764cd421dd2ded70218c47.1244837725.git.jbaron@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  /*
>   * A syscall entry in the ftrace syscalls array.
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 1ef5d3a..5b34ff9 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -24,6 +24,7 @@
>  #include <linux/tracepoint.h>
>  #include <linux/err.h>
>  #include <linux/slab.h>
> +#include <linux/sched.h>
>  
>  extern struct tracepoint __start___tracepoints[];
>  extern struct tracepoint __stop___tracepoints[];
> @@ -577,3 +578,40 @@ static int init_tracepoints(void)
>  __initcall(init_tracepoints);
>  
>  #endif /* CONFIG_MODULES */
> +
> +DEFINE_MUTEX(regfunc_mutex);

static?

> +int sys_tracepoint_refcount;

static?

and atomic_t should be fine as Frederic pointed out.

> +
> +void syscall_regfunc(void)
> +{
> +	unsigned long flags;
> +	struct task_struct *g, *t;
> +
> +	mutex_lock(&regfunc_mutex);
> +	if (!sys_tracepoint_refcount) {
> +		read_lock_irqsave(&tasklist_lock, flags);
> +		do_each_thread(g, t) {
> +			set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> +		} while_each_thread(g, t);
> +		read_unlock_irqrestore(&tasklist_lock, flags);
> +	}
> +	sys_tracepoint_refcount++;
> +	mutex_unlock(&regfunc_mutex);
> +}
> +
> +void syscall_unregfunc(void)
> +{
> +	unsigned long flags;
> +	struct task_struct *g, *t;
> +
> +	mutex_lock(&regfunc_mutex);
> +	sys_tracepoint_refcount--;
> +	if (!sys_tracepoint_refcount) {
> +		read_lock_irqsave(&tasklist_lock, flags);
> +		do_each_thread(g, t) {
> +			clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> +		} while_each_thread(g, t);
> +		read_unlock_irqrestore(&tasklist_lock, flags);
> +	}
> +	mutex_unlock(&regfunc_mutex);
> +}

