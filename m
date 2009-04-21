Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbZDUTm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbZDUTm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbZDUTmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:42:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42604 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295AbZDUTmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:42:49 -0400
Date: Tue, 21 Apr 2009 21:37:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] ftrace, workqueuetrace: Make
	workqueuetracepoints use TRACE_EVENT macro
Message-ID: <20090421193724.GA18296@redhat.com>
References: <20090420103612.4B4E.A69D9226@jp.fujitsu.com> <47EF9F5C609F496FBBD423EA81A00920@zhaoleiwin> <20090420104734.4B51.A69D9226@jp.fujitsu.com> <20090420084631.GA32625@elte.hu> <20090420222514.GA15680@redhat.com> <20090420234835.GC5997@nowhere> <20090421152843.GA5402@redhat.com> <20090421182803.GB6001@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421182803.GB6001@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21, Frederic Weisbecker wrote:
>
> On Tue, Apr 21, 2009 at 05:28:43PM +0200, Oleg Nesterov wrote:
> > More precisely, at this stage tsk->cpu_allowed is not bound, it has
> > "all CPUS", == cpu_possible_mask. This means that cpumask_first()
> > returns the "random" value. The fix is simple, I think you should
> > just add "int cpu" argument to cleanup_workqueue_thread().
>
> Ok.
> But where is it done? I mean, by looking at workqueue_cpu_callback()
> in workqueue.c, I only see this part related to _cpu_down():
>
> case CPU_POST_DEAD:
> 	cleanup_workqueue_thread(cwq);
> 	break;

There are two case. Please note that create_workqueue_thread() does not
bind the thread, we delay kthread_bind() untill start_workqueue_thread().
So, if we have CPU_UP_CANCELED (after CPU_UP_PREPARE) we call
cleanup_workqueue_thread() but the thread still has ->cpu_allowed ==
cpu_all_mask.

Another case is a normal cpu_down(). When CPU_POST_DEAD happens, this
CPU is really dead. All tasks were alredy moved from the dead cpu.
And since wq_thread was affine to that CPU, it gets the "full" cpu mask.

OK, I don't think it is possible to parse the text above ;) Please
look at  /* No more Mr. Nice Guy. */ in move_task_off_dead_cpu().

Oleg.

