Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbXHRM4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbXHRM4q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 08:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbXHRM4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 08:56:39 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46623 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbXHRM4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 08:56:38 -0400
Date: Sat, 18 Aug 2007 16:59:26 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + proc-export-a-processes-resource-limits-via-proc-pid.patch added to -mm tree
Message-ID: <20070818125926.GA74@tv-sign.ru>
References: <20070817222228.GA783@tv-sign.ru> <20070818115816.GA23555@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070818115816.GA23555@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18, Neil Horman wrote:
>
> On Sat, Aug 18, 2007 at 02:22:28AM +0400, Oleg Nesterov wrote:
> > Neil Horman wrote:
> > > 
> > > +static int proc_pid_limits(struct task_struct *task, char *buffer)
> > > +{
> > > +	unsigned int i;
> > > +	int count = 0;
> > > +	char *bufptr = buffer;
> > > +
> > > +	struct rlimit rlim[RLIM_NLIMITS];
> > > +
> > > +	read_lock(&tasklist_lock);
> > > +	memcpy(rlim, task->signal->rlim, sizeof(struct rlimit) * RLIM_NLIMITS);
> > > +	read_unlock(&tasklist_lock);
> > 
> > Please don't re-introduce tasklist_lock unless strictly needed. And in this case
> > it doesn't help, sys_getrlimit() changes ->rlim[] under task_lock().
> > 
> > Hovewer, I think the whole patch is not right. The "tsk" itself is pinned, but its
> > ->signal is not stable and can be == NULL.
> > 
> > You can use lock_task_sighand() to access ->signal.
> > 
> You're right about the use of task_lock rather than tasklist_lock in getrlimit,
> but the comment from lock_task_sighand indicates that its use is predicated on
> the prerequisite of locking tasklist_lock,

or rcu_read_lock(),

> so I think the situation is not that
> much of an issue.  From what I see the use of lock_task_sighand is used when
> modifying values in the signal struct, not when removing it entirely (IIRC it
> needs to exist until such time as all sharing processes exit.

yes, it needs to exist until the whole process exits, but no, __exit_signal()
sets ->signal == NULL under sighand->siglock. This btw happens per thread.

> The fact that we
> have an outstanding task struct we are using here guarantees its continued
> existence).

No. proc_info_read() finds a "pid_alive()" task with a valid signal, and bumps
its ->usage. But nothing prevent this thread from exiting (in fact, it may be
already dead), after that the parent can reap that task, or it can reap itself
if it was detached thread.

This means that proc_read() can assume nothing about the task, except that its
task_struct can't disappear.

> Since we are only reading signal->rlimit, which is only written to
> from sys_setrlimit, we should be safe from corrupted limit reads, which at worst
> would cause an erroneous transient data read, rather than any sort of
> panic/crash.

->signal == NULL leads to panic().

Oleg.

