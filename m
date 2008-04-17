Return-Path: <linux-kernel-owner+w=401wt.eu-S934584AbYDQQa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934584AbYDQQa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 12:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763098AbYDQQas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 12:30:48 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:40904 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbYDQQar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 12:30:47 -0400
Date: Thu, 17 Apr 2008 19:36:44 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jesper Juhl <jesper.juhl@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: fork_idle && pid problems ?
Message-ID: <20080417153644.GA69@tv-sign.ru>
References: <alpine.LNX.1.00.0804162336480.9837@dragon.funnycrock.com> <20080417115718.GC103@tv-sign.ru> <20080417130252.GB6640@elte.hu> <20080417140246.GA257@tv-sign.ru> <480771DC.5040002@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480771DC.5040002@openvz.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17, Pavel Emelyanov wrote:
>
> Oleg Nesterov wrote:
> > 
> > But wait... What _is_ the task_pid() after fork_idle() ???
> 
> It is NULL, but every code getting one can handle such case :)
> 
> > fork_idle() doesn't really attach the new thread to the init_struct_pid,
> > so ->pids[PIDTYPE_PID].pid just points the parent's pid, no?
> > 
> > As for x86, the parent is /sbin/init (kernel_init->smp_prepare_cpus),
> > not so bad, it can't exit.
> > 
> > But what about HOTPLUG_CPU? Suppose we add CPU, use some non-idle
> > kernel thread (workqueue) to fork the idle thread. CPU goes down,
> > parent exits and frees the pid. Now, if this CPU goes up again, the
> > idle thread runs with its ->pid pointing to the freed memory, not
> > good.
> 
> Nope - it will be NULL.

How so? I bet it won't be NULL...

	dup_task_struct:

		*tsk = *orig;

After that the child's ->pids[PIDTYPE_MAX] is a copy of parent's.
But the task is not attached to these pids.

> > Not serious perhaps, afaics we only need this ->pid to ensure that
> > swapper can safely fork /sbin/init, but still.
> > 
> > Pavel, Eric, Sukadev? Please say I missed something! ;)
> > 
> > Otherwise, we can change init_idle() to do attach_pid(init_struct_pid),
> > afaics we can do this lockless. In that case we should also change
> > INIT_STRUCT_PID() and remove the initialization of .tasks.
> 
> Well, these was some request to make tasks always have pid link
> point to not NULL (from Matt?) so we'll need this :)

For now I'd suggest the patch below. If contrary to our expectations
there is any usage of idle_task->pids, we will notice ;)

Oleg.

--- kernel/fork.c~	2008-03-07 18:11:27.000000000 +0300
+++ kernel/fork.c	2008-04-17 19:34:10.000000000 +0400
@@ -1420,6 +1420,9 @@ struct task_struct * __cpuinit fork_idle
 	if (!IS_ERR(task))
 		init_idle(task, cpu);
 
+	/* COMMENT */
+	memset(task->pids, 0, sizeof task->pids);
+
 	return task;
 }
 

