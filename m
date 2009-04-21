Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbZDUPeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbZDUPeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 11:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZDUPd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 11:33:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54948 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbZDUPd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 11:33:58 -0400
Date: Tue, 21 Apr 2009 17:28:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] ftrace, workqueuetrace: Make
	workqueuetracepoints use TRACE_EVENT macro
Message-ID: <20090421152843.GA5402@redhat.com>
References: <20090420103612.4B4E.A69D9226@jp.fujitsu.com> <47EF9F5C609F496FBBD423EA81A00920@zhaoleiwin> <20090420104734.4B51.A69D9226@jp.fujitsu.com> <20090420084631.GA32625@elte.hu> <20090420222514.GA15680@redhat.com> <20090420234835.GC5997@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420234835.GC5997@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21, Frederic Weisbecker wrote:
>
> On Tue, Apr 21, 2009 at 12:25:14AM +0200, Oleg Nesterov wrote:
> >
> > For example, I don't understand cpu_workqueue_stats->pid. Why it is
> > needed? Why can't we just record wq_thread itself? And if we copy
> > wq_thread->comm to cpu_workqueue_stats, we don't even need get/put
> > task_struct, afaics.
>
>
> We record the pid because of a race condition that can happen
> against the stat tracing framework.
>
> For example,
>
> - the user opens the stat file
> - then the entries are loaded and sorted into memory
> - one of the workqueues is destroyed

so, its pid is freed and can be re-used,

> - the user reads the file. We try to get the task struct
>   of each workqueues that were recorded using their pid.

if it is already re-used when workqueue_stat_show() is called, we
can get a wrong a wrong tsk.

Another problem with pid_t, it needs a costly find_get_pid(). And please
note that find_get_pid() uses current->nsproxy->pid_ns, this means we
can get a wrong tsk or NULL if we read debugfs from sub-namespace, but
this is minor.

Using "struct pid* pid" is better than "pid_t pid" and solves these
problems. But I still think we don't need it at all.

>   If the task is destroyed then this is fine, we don't get
>   any struct. If we were using the task_struct as an identifier,
>   me would have derefenced a freed pointer.

Please note I said "get/put task_struct" above. probe_workqueue_creation()
does get_task_struct(), and probe_workqueue_destruction() put_task_struct().

But, unless I missed something we don't need even this. Why do we
need to dereference this task_struct? The only reason afaics is
that we read tsk->comm. But we can copy wq_thread->comm to
cpu_workqueue_stats when probe_workqueue_creation() is called . In that
case we don't need get/put, we only use cws->task (or whatever) as a
"void *", just to check "if (node->task  == wq_thread)" in
probe_workqueue_insertion/etc.

But it is very possible I missed something, please correct me.

> > probe_workqueue_destruction() does cpumask_first(cwq->cpus_allowed),
> > this doesn't look right. When workqueue_cpu_callback() calls
> > cleanup_workqueue_thread(), wq_thread is no longer affine to CPU it
> > was created on. This means probe_workqueue_destruction() can't always
> > find the correct cpu_workqueue_stats in workqueue_cpu_stat(cpu), no?
>
>
> Ah, at this stage of cpu_down() the cpu is cleared on
> tsk->cpu_allowed ?

Yes. Well not exactly...

More precisely, at this stage tsk->cpu_allowed is not bound, it has
"all CPUS", == cpu_possible_mask. This means that cpumask_first()
returns the "random" value. The fix is simple, I think you should
just add "int cpu" argument to cleanup_workqueue_thread().


Hmm... why cpu_workqueue_stats->inserted is atomic_t? We increment it
in do_workqueue_insertion() (should be static, no?), and it is always
called with cpu_workqueue_struct->lock held.

Oleg.

