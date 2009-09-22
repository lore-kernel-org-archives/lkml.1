Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbZIVUeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbZIVUeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 16:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZIVUeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 16:34:17 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:18929 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZIVUeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 16:34:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FbtmcB+fCOdLp4SLacYcIqj66zY7bRnVaumsPBnqBLyX754AXXJE26GM87Q95Az8/k
         mMs8mbfZUKk5aLIILxtZZ5d2SBEHWZRHDqXJufw7LPKvYu1skAAlVcZT0NLSmd1txN0Q
         rgaJeImwKjctdbaSv9VYNPGTm2I2TniDtV4NA=
Date: Tue, 22 Sep 2009 22:34:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Anton Blanchard <anton@samba.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing/workqueue: Rename workqueue_execute to
	worklet_entry and add worklet_exit
Message-ID: <20090922203414.GA5059@nowhere>
References: <20090922023920.GA31801@kryten> <20090922024033.GB31801@kryten> <20090922024232.GC31801@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922024232.GC31801@kryten>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 12:42:32PM +1000, Anton Blanchard wrote:
> 
> Keep a common naming convention for tracing the latency of events such as
> softirq_entry/softirq_exit.
> 
> Based on a patch from KOSAKI Motohiro.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>


Ah. Kosaki Motohiro sent a very similar patch few monthes ago:

http://git.kernel.org/?p=linux/kernel/git/frederic/random-tracing.git;a=commit;h=5c11f399da166ff3bd8cf823add5fff7d036b67e

I haven't proposed it because of the debate about workqueue profiling at this
time.

But now I think this should make its way, as only the trace events are necessary
for the kernel part of such profiling.

Some comments below:

> ---
> 
> Index: linux.trees.git/kernel/workqueue.c
> ===================================================================
> --- linux.trees.git.orig/kernel/workqueue.c	2009-09-14 09:43:00.000000000 +1000
> +++ linux.trees.git/kernel/workqueue.c	2009-09-14 09:45:45.000000000 +1000
> @@ -279,7 +279,6 @@ static void run_workqueue(struct cpu_wor
>  		 */
>  		struct lockdep_map lockdep_map = work->lockdep_map;
>  #endif
> -		trace_workqueue_execution(cwq->thread, work);
>  		cwq->current_work = work;
>  		list_del_init(cwq->worklist.next);
>  		spin_unlock_irq(&cwq->lock);
> @@ -288,7 +287,9 @@ static void run_workqueue(struct cpu_wor
>  		work_clear_pending(work);
>  		lock_map_acquire(&cwq->wq->lockdep_map);
>  		lock_map_acquire(&lockdep_map);
> +		trace_worklet_entry(cwq->thread, work);
>  		f(work);
> +		trace_worklet_exit(cwq->thread, work);
>  		lock_map_release(&lockdep_map);
>  		lock_map_release(&cwq->wq->lockdep_map);
>  
> Index: linux.trees.git/include/trace/events/workqueue.h
> ===================================================================
> --- linux.trees.git.orig/include/trace/events/workqueue.h	2009-09-14 09:45:41.000000000 +1000
> +++ linux.trees.git/include/trace/events/workqueue.h	2009-09-14 09:45:45.000000000 +1000
> @@ -30,7 +30,7 @@ TRACE_EVENT(workqueue_insertion,
>  		__entry->thread_pid, __entry->func)
>  );
>  
> -TRACE_EVENT(workqueue_execution,
> +TRACE_EVENT(worklet_entry,


In Kosaki's patch, it's named workqueue_handler_entry, but worklet_entry
looks sufficient and more concise.


>  
>  	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
>  
> @@ -52,6 +52,27 @@ TRACE_EVENT(workqueue_execution,
>  		__entry->thread_pid, __entry->func)
>  );
>  
> +/* Declare work as void *, because we can't use work->... in after f(work) */
> +TRACE_EVENT(worklet_exit,
> +
> +	TP_PROTO(struct task_struct *wq_thread, void *work),
> +
> +	TP_ARGS(wq_thread, work),
> +
> +	TP_STRUCT__entry(
> +		__array(char,		thread_comm,	TASK_COMM_LEN)
> +		__field(pid_t,		thread_pid)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
> +		__entry->thread_pid	= wq_thread->pid;
> +	),
> +
> +	TP_printk("thread=%s:%d", __entry->thread_comm,
> +		  __entry->thread_pid)



In Kosaki's patch, we had the work struct address displayed too.
Your version is supposed to be sufficient because we know a workqueue
serializes its works. Then we know that an exit event will always follow
and match the previous entry event from the same workqueue thread.
The workqueue pid then provides a sufficient key for that.

That said, we should worry about possible lost events from
perf in some circumstances. And userspace profiling needs something
to ensure the accuracy about this entry/exit pair.

We could have:
	entry work1
	exit work 1 <--- lost event
	entry work2 <--- lost event
	exit work2

And then the pair would be misinterpreted.

(Although we could have even other misinterpretation
with other kind of scenarios, even if we have this work
address. But that's still more safety).

So I'd prefer to keep Kosaki's idea about these keys.
But I prefer your event naming.

May be I can unearth Kosaki's patch, change it with your naming
and add your Signed-off-by?

Kosaki, no problem about it?

Thanks,
Frederic.

