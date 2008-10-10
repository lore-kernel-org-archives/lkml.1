Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbYJJNj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbYJJNj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 09:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755742AbYJJNjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 09:39:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40311 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbYJJNjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 09:39:18 -0400
Date: Fri, 10 Oct 2008 09:39:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] tracing/ftrace: Fix a race condition in sched_switch
 tracer
In-Reply-To: <20081010113510.A07A9D1BD59@perso1.free.fr>
Message-ID: <alpine.DEB.1.10.0810100935570.26408@gandalf.stny.rr.com>
References: <20081010113510.A07A9D1BD59@perso1.free.fr>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 10 Oct 2008, Frederic Weisbecker wrote:
> 
> This patch fixes a race condition in the sched_switch tracer.
> If several tasks (IE: concurrent initcalls) are playing with 
> tracing_start_cmdline_record() and tracing_stop_cmdline_record(),
> the following situation could happen:
> 
> 
> _ Task A and B are using the same tracepoint probe. Task A holds it. Task B is
> sleeping and doesn't hold it.
> _ Task A frees the sched tracer, then sched_ref is decremented to 0.
> _ Task A is preempted and hadn't yet unregistered its tracepoint probe,
> then B runs.
> _ B increments sched_ref, sees it's 1 and then guess it has to register its probe. But it has not been freed by task A.
> _ A lot of bad things can happen after that... 

OK, I see the issue.

> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_sched_switch.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
> index b8f56be..59de514 100644
> --- a/kernel/trace/trace_sched_switch.c
> +++ b/kernel/trace/trace_sched_switch.c
> @@ -17,6 +17,7 @@
>  static struct trace_array	*ctx_trace;
>  static int __read_mostly	tracer_enabled;
>  static atomic_t			sched_ref;
> +static DEFINE_MUTEX(tracepoint_mutex);
>  
>  static void
>  probe_sched_switch(struct rq *__rq, struct task_struct *prev,
> @@ -125,18 +126,22 @@ static void tracing_start_sched_switch(void)
>  {
>  	long ref;
>  
> +	mutex_lock(&tracepoint_mutex);
>  	ref = atomic_inc_return(&sched_ref);
>  	if (ref == 1)
>  		tracing_sched_register();

Could you make another patch to convert sched_ref to an int. With a mutex
lock, there's no reason for this to be atomic.

We can simply do:

	if (!(sched_ref++))
		tracing_sched_register();

> +	mutex_unlock(&tracepoint_mutex);
>  }
>  
>  static void tracing_stop_sched_switch(void)
>  {
>  	long ref;
>  
> +	mutex_lock(&tracepoint_mutex);
>  	ref = atomic_dec_and_test(&sched_ref);
>  	if (ref)
>  		tracing_sched_unregister();

and

	if (!(--sched_ref))
		tracing_sched_unregister();

> +	mutex_unlock(&tracepoint_mutex);

Also, lets change the name. sched_register_mutex?

>  }
>  
>  void tracing_start_cmdline_record(void)
> 

-- Steve


