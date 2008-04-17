Return-Path: <linux-kernel-owner+w=401wt.eu-S934427AbYDQRI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934427AbYDQRI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760151AbYDQRIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:08:16 -0400
Received: from sacred.ru ([62.205.161.221]:44941 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759059AbYDQRIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:08:15 -0400
Message-ID: <48077D65.1090207@openvz.org>
Date: Thu, 17 Apr 2008 20:40:05 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Ingo Molnar <mingo@elte.hu>, Jesper Juhl <jesper.juhl@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: fork_idle && pid problems ?
References: <alpine.LNX.1.00.0804162336480.9837@dragon.funnycrock.com> <20080417115718.GC103@tv-sign.ru> <20080417130252.GB6640@elte.hu> <20080417140246.GA257@tv-sign.ru> <480771DC.5040002@openvz.org> <20080417153644.GA69@tv-sign.ru>
In-Reply-To: <20080417153644.GA69@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 17 Apr 2008 20:41:33 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 04/17, Pavel Emelyanov wrote:
>> Oleg Nesterov wrote:
>>> But wait... What _is_ the task_pid() after fork_idle() ???
>> It is NULL, but every code getting one can handle such case :)
>>
>>> fork_idle() doesn't really attach the new thread to the init_struct_pid,
>>> so ->pids[PIDTYPE_PID].pid just points the parent's pid, no?
>>>
>>> As for x86, the parent is /sbin/init (kernel_init->smp_prepare_cpus),
>>> not so bad, it can't exit.
>>>
>>> But what about HOTPLUG_CPU? Suppose we add CPU, use some non-idle
>>> kernel thread (workqueue) to fork the idle thread. CPU goes down,
>>> parent exits and frees the pid. Now, if this CPU goes up again, the
>>> idle thread runs with its ->pid pointing to the freed memory, not
>>> good.
>> Nope - it will be NULL.
> 
> How so? I bet it won't be NULL...
> 
> 	dup_task_struct:
> 
> 		*tsk = *orig;
> 
> After that the child's ->pids[PIDTYPE_MAX] is a copy of parent's.
> But the task is not attached to these pids.

Ouch... Indeed.

>>> Not serious perhaps, afaics we only need this ->pid to ensure that
>>> swapper can safely fork /sbin/init, but still.
>>>
>>> Pavel, Eric, Sukadev? Please say I missed something! ;)
>>>
>>> Otherwise, we can change init_idle() to do attach_pid(init_struct_pid),
>>> afaics we can do this lockless. In that case we should also change
>>> INIT_STRUCT_PID() and remove the initialization of .tasks.
>> Well, these was some request to make tasks always have pid link
>> point to not NULL (from Matt?) so we'll need this :)
> 
> For now I'd suggest the patch below. If contrary to our expectations
> there is any usage of idle_task->pids, we will notice ;)
> 
> Oleg.
> 
> --- kernel/fork.c~	2008-03-07 18:11:27.000000000 +0300
> +++ kernel/fork.c	2008-04-17 19:34:10.000000000 +0400
> @@ -1420,6 +1420,9 @@ struct task_struct * __cpuinit fork_idle
>  	if (!IS_ERR(task))
>  		init_idle(task, cpu);
>  
> +	/* COMMENT */
> +	memset(task->pids, 0, sizeof task->pids);
> +

Hm... Looks ok, but I'd suggest such patch instead:

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1348,6 +1348,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		}
 		attach_pid(p, PIDTYPE_PID, pid);
 		nr_threads++;
+	} else {
+		p->pids[PIDTYPE_PID].pid = NULL;
+		p->pids[PIDTYPE_SID].pid = NULL;
+		p->pids[PIDTYPE_PGID].pid = NULL;
 	}
 
 	total_forks++;

it will cover cases, when we (if ever) call the copy_process from
other place. Oh, well...

>  	return task;
>  }
>  
> 
> 

