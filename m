Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbZCKHAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbZCKHAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 03:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZCKG77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 02:59:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:36785 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbZCKG76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 02:59:58 -0400
Subject: Re: [GIT PULL] tracing: use raw spinlocks for trace_vprintk
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0903102125250.16494@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0903102125250.16494@gandalf.stny.rr.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Mar 2009 07:59:24 +0100
Message-Id: <1236754764.22914.3680.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 21:26 -0400, Steven Rostedt wrote:

> commit 80370cb758e7ca2692cd9fb5e413d970b1f4b2b2
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Tue Mar 10 17:16:35 2009 -0400
> 
>     tracing: use raw spinlocks for trace_vprintk
>     
>     Impact: prevent locking up by lockdep tracer
>     
>     The lockdep tracer uses trace_vprintk and thus trace_vprintk can not
>     call back into lockdep without locking up.

Hmm, I did this when I posted the lockdep tracepoints, so someone then
did a bad copy/paste job when renaming ftrace_printk or something?

See efed792d6738964f399a508ef9e831cd60fa4657

>     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 8c6a902..4c97947 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1176,7 +1176,8 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
>   */
>  int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
>  {
> -	static DEFINE_SPINLOCK(trace_buf_lock);
> +	static raw_spinlock_t trace_buf_lock =
> +		(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
>  	static u32 trace_buf[TRACE_BUF_SIZE];
>  
>  	struct ring_buffer_event *event;
> @@ -1201,7 +1202,9 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
>  	if (unlikely(atomic_read(&data->disabled)))
>  		goto out;
>  
> -	spin_lock_irqsave(&trace_buf_lock, flags);
> +	/* Lockdep uses trace_printk for lock tracing */
> +	local_irq_save(flags);

Shouldn't you also use raw_local_irq_save() and friends?

> +	__raw_spin_lock(&trace_buf_lock);
>  	len = vbin_printf(trace_buf, TRACE_BUF_SIZE, fmt, args);
>  
>  	if (len > TRACE_BUF_SIZE || len < 0)
> @@ -1220,7 +1223,8 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
>  	ring_buffer_unlock_commit(tr->buffer, event);
>  
>  out_unlock:
> -	spin_unlock_irqrestore(&trace_buf_lock, flags);
> +	__raw_spin_unlock(&trace_buf_lock);
> +	local_irq_restore(flags);
>  
>  out:
>  	ftrace_preempt_enable(resched);
> 
