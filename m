Return-Path: <linux-kernel-owner+w=401wt.eu-S932632AbYDQPDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632AbYDQPDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757778AbYDQPDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:03:07 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51408 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758806AbYDQPDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:03:05 -0400
Date: Thu, 17 Apr 2008 18:02:46 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: fork_idle && pid problems ? (was: Possible mem leak in copy_process())
Message-ID: <20080417140246.GA257@tv-sign.ru>
References: <alpine.LNX.1.00.0804162336480.9837@dragon.funnycrock.com> <20080417115718.GC103@tv-sign.ru> <20080417130252.GB6640@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417130252.GB6640@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17, Ingo Molnar wrote:
> 
> * Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > > 1331 		if (likely(p->pid)) {
> 
> > > 1351 		}
> 
> > > Event leaked_storage: Returned without freeing storage "pid" Also 
> > > see events: [alloc_fn][var_assign][pass_arg]
> > 
> > this looks like a false alarm.
> > 
> > p->pid == pid->numbers[0].nr. If "struct pid *pid" was allocated, its 
> > .nr can't be 0.
> > 
> > IOW, !p->pid means that pid == init_struct_pid, it wasn't allocated 
> > but was passed from the caller.
> 
> should we perhaps codify this rule via adding something like this to the 
> else branch:
> 
>    WARN_ON_ONCE(task_pid(p) != &init_struct_pid);
> 
> ?

Perhaps yes, I don't know...

But please note that we heavily rely on the fact that nobody except idle
threads can have pid_nr == 0, and more importantly, each "struct pid" must
have the unique .nr withing the same namespace (init_pid_ns in this case).
I'd suggest to just add a small comment.


But wait... What _is_ the task_pid() after fork_idle() ???

fork_idle() doesn't really attach the new thread to the init_struct_pid,
so ->pids[PIDTYPE_PID].pid just points the parent's pid, no?

As for x86, the parent is /sbin/init (kernel_init->smp_prepare_cpus),
not so bad, it can't exit.

But what about HOTPLUG_CPU? Suppose we add CPU, use some non-idle
kernel thread (workqueue) to fork the idle thread. CPU goes down,
parent exits and frees the pid. Now, if this CPU goes up again, the
idle thread runs with its ->pid pointing to the freed memory, not
good.

Not serious perhaps, afaics we only need this ->pid to ensure that
swapper can safely fork /sbin/init, but still.

Pavel, Eric, Sukadev? Please say I missed something! ;)

Otherwise, we can change init_idle() to do attach_pid(init_struct_pid),
afaics we can do this lockless. In that case we should also change
INIT_STRUCT_PID() and remove the initialization of .tasks.

Oleg.

