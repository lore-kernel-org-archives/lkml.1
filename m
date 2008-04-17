Return-Path: <linux-kernel-owner+w=401wt.eu-S934572AbYDQQRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934572AbYDQQRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 12:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934393AbYDQQRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 12:17:33 -0400
Received: from sacred.ru ([62.205.161.221]:35194 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934311AbYDQQRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 12:17:32 -0400
Message-ID: <480771DC.5040002@openvz.org>
Date: Thu, 17 Apr 2008 19:50:52 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Ingo Molnar <mingo@elte.hu>, Jesper Juhl <jesper.juhl@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: fork_idle && pid problems ?
References: <alpine.LNX.1.00.0804162336480.9837@dragon.funnycrock.com> <20080417115718.GC103@tv-sign.ru> <20080417130252.GB6640@elte.hu> <20080417140246.GA257@tv-sign.ru>
In-Reply-To: <20080417140246.GA257@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 17 Apr 2008 19:52:16 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 04/17, Ingo Molnar wrote:
>> * Oleg Nesterov <oleg@tv-sign.ru> wrote:
>>
>>>> 1331 		if (likely(p->pid)) {
>>>> 1351 		}
>>>> Event leaked_storage: Returned without freeing storage "pid" Also 
>>>> see events: [alloc_fn][var_assign][pass_arg]
>>> this looks like a false alarm.
>>>
>>> p->pid == pid->numbers[0].nr. If "struct pid *pid" was allocated, its 
>>> .nr can't be 0.
>>>
>>> IOW, !p->pid means that pid == init_struct_pid, it wasn't allocated 
>>> but was passed from the caller.
>> should we perhaps codify this rule via adding something like this to the 
>> else branch:
>>
>>    WARN_ON_ONCE(task_pid(p) != &init_struct_pid);
>>
>> ?
> 
> Perhaps yes, I don't know...
> 
> But please note that we heavily rely on the fact that nobody except idle
> threads can have pid_nr == 0, and more importantly, each "struct pid" must
> have the unique .nr withing the same namespace (init_pid_ns in this case).
> I'd suggest to just add a small comment.
> 
> 
> But wait... What _is_ the task_pid() after fork_idle() ???

It is NULL, but every code getting one can handle such case :)

> fork_idle() doesn't really attach the new thread to the init_struct_pid,
> so ->pids[PIDTYPE_PID].pid just points the parent's pid, no?
> 
> As for x86, the parent is /sbin/init (kernel_init->smp_prepare_cpus),
> not so bad, it can't exit.
> 
> But what about HOTPLUG_CPU? Suppose we add CPU, use some non-idle
> kernel thread (workqueue) to fork the idle thread. CPU goes down,
> parent exits and frees the pid. Now, if this CPU goes up again, the
> idle thread runs with its ->pid pointing to the freed memory, not
> good.

Nope - it will be NULL.

> Not serious perhaps, afaics we only need this ->pid to ensure that
> swapper can safely fork /sbin/init, but still.
> 
> Pavel, Eric, Sukadev? Please say I missed something! ;)
> 
> Otherwise, we can change init_idle() to do attach_pid(init_struct_pid),
> afaics we can do this lockless. In that case we should also change
> INIT_STRUCT_PID() and remove the initialization of .tasks.

Well, these was some request to make tasks always have pid link
point to not NULL (from Matt?) so we'll need this :)

> Oleg.
> 
> 

Thanks,
Pavel
