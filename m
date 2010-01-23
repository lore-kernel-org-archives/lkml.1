Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070Ab0AWLiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0AWLiv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 06:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480Ab0AWLir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 06:38:47 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43103 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab0AWLip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 06:38:45 -0500
Message-ID: <4B5ADFC1.6030909@canonical.com>
Date: Sat, 23 Jan 2010 12:38:41 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [28/29] perf events: Dont report side-band events
 on each cpu for per-task-per-cpu events
References: <20100123001113.778789298@mini.kroah.org>
In-Reply-To: <20100123001113.778789298@mini.kroah.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> commit 5d27c23df09b702868d9a3bff86ec6abd22963ac upstream.
> 
> Acme noticed that his FORK/MMAP numbers were inflated by about
> the same factor as his cpu-count.
> 
> This led to the discovery of a few more sites that need to
> respect the event->cpu filter.
> 
> Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> LKML-Reference: <20091217121830.215333434@chello.nl>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  kernel/perf_event.c |   20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -1359,6 +1359,9 @@ static void perf_ctx_adjust_freq(struct 
>  		if (event->state != PERF_EVENT_STATE_ACTIVE)
>  			continue;
>  
> +		if (event->cpu != -1 && event->cpu != smp_processor_id())
> +			continue;
> +
>  		hwc = &event->hw;
>  
>  		interrupts = hwc->interrupts;
> @@ -3226,6 +3229,9 @@ static void perf_event_task_output(struc
>  
>  static int perf_event_task_match(struct perf_event *event)
>  {
> +	if (event->cpu != -1 && event->cpu != smp_processor_id())
> +		return 0;
> +
>  	if (event->attr.comm || event->attr.mmap || event->attr.task)
>  		return 1;
>  

> @@ -3262,6 +3268,7 @@ static void perf_event_task_event(struct
>  		ctx = rcu_dereference(task_event->task->perf_event_ctxp);
>  	if (ctx)
>  		perf_event_task_ctx(ctx, task_event);
> +	put_cpu_var(perf_cpu_context);
>  	rcu_read_unlock();
>  }

I believe this hunk drops the move of put_cpu_var. The upstream hunk looks like
this:

@ -3290,12 +3296,11 @@ static void perf_event_task_event(struct perf_task_event
        rcu_read_lock();
        cpuctx = &get_cpu_var(perf_cpu_context);
        perf_event_task_ctx(&cpuctx->ctx, task_event);
-       put_cpu_var(perf_cpu_context);
-
        if (!ctx)
                ctx = rcu_dereference(task_event->task->perf_event_ctxp);
        if (ctx)
                perf_event_task_ctx(ctx, task_event);
+       put_cpu_var(perf_cpu_context);
        rcu_read_unlock();
 }

> @@ -3338,6 +3345,9 @@ static void perf_event_comm_output(struc
>  
>  static int perf_event_comm_match(struct perf_event *event)
>  {
> +	if (event->cpu != -1 && event->cpu != smp_processor_id())
> +		return 0;
> +
>  	if (event->attr.comm)
>  		return 1;
>  
> @@ -3378,7 +3388,6 @@ static void perf_event_comm_event(struct
>  
>  	cpuctx = &get_cpu_var(perf_cpu_context);
>  	perf_event_comm_ctx(&cpuctx->ctx, comm_event);
> -	put_cpu_var(perf_cpu_context);
>  
>  	rcu_read_lock();
>  	/*
> @@ -3388,6 +3397,7 @@ static void perf_event_comm_event(struct
>  	ctx = rcu_dereference(current->perf_event_ctxp);
>  	if (ctx)
>  		perf_event_comm_ctx(ctx, comm_event);
> +	put_cpu_var(perf_cpu_context);
>  	rcu_read_unlock();
>  }
>  
> @@ -3462,6 +3472,9 @@ static void perf_event_mmap_output(struc
>  static int perf_event_mmap_match(struct perf_event *event,
>  				   struct perf_mmap_event *mmap_event)
>  {
> +	if (event->cpu != -1 && event->cpu != smp_processor_id())
> +		return 0;
> +
>  	if (event->attr.mmap)
>  		return 1;
>  
> @@ -3539,7 +3552,6 @@ got_name:
>  
>  	cpuctx = &get_cpu_var(perf_cpu_context);
>  	perf_event_mmap_ctx(&cpuctx->ctx, mmap_event);
> -	put_cpu_var(perf_cpu_context);
>  
>  	rcu_read_lock();
>  	/*
> @@ -3549,6 +3561,7 @@ got_name:
>  	ctx = rcu_dereference(current->perf_event_ctxp);
>  	if (ctx)
>  		perf_event_mmap_ctx(ctx, mmap_event);
> +	put_cpu_var(perf_cpu_context);
>  	rcu_read_unlock();
>  
>  	kfree(buf);
> @@ -3811,6 +3824,9 @@ static int perf_swevent_match(struct per
>  				enum perf_type_id type,
>  				u32 event_id, struct pt_regs *regs)
>  {
> +	if (event->cpu != -1 && event->cpu != smp_processor_id())
> +		return 0;
> +
>  	if (!perf_swevent_is_counting(event))
>  		return 0;
>  
> 
> 
> _______________________________________________
> Stable-review mailing list
> Stable-review@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable-review

