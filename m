Return-Path: <linux-kernel-owner+w=401wt.eu-S966758AbXHIRCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966758AbXHIRCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966710AbXHIRBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:01:50 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49482 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966700AbXHIRBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:01:48 -0400
Date: Thu, 9 Aug 2007 21:03:53 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Paul E McKenney <paulmck@us.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Subject: rt ptracer can monopolize CPU (was: Cpu-Hotplug and Real-Time)
Message-ID: <20070809170353.GA82@tv-sign.ru>
References: <20070807131216.GA20424@in.ibm.com> <20070807151336.GA507@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070807151336.GA507@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07, Oleg Nesterov wrote:
>
> On 08/07, Gautham R Shenoy wrote:
> >
> > A will now call kthread_bind(B, cpu1).
> > kthread_bind(), calls wait_task_inactive(B), to ensures that 
> > B has scheduled itself out.
> > 
> > B is still on the runqueue, so A calls yield() in wait_task_inactive().
> > But since A is the task with the highest prio, scheduler schedules it
> > back again.
> > 
> > Thus B never gets to run to schedule itself out.
> > A loops waiting for B to schedule out leading  to system hang.
> 
> But I think we have another case. An RT ptracer can share the same CPU
> with ptracee. The latter sets TASK_STOPPED, unlocks ->siglock, and takes
> a preemption. Ptracer does ptrace_check_attach(), sees TASK_STOPPED, and
> yields in wait_task_inactive.

Even simpler.

#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <sys/ptrace.h>
#include <sys/wait.h>
#define	__USE_GNU
#include <sched.h>

void die(const char *msg)
{
	printf("ERR!! %s: %m\n", msg);
        kill(0, SIGKILL);
}

void set_cpu(int cpu)
{
	unsigned cpuval = 1 << cpu;
	if (sched_setaffinity(0, 4, (void*)&cpuval) < 0)
		die("setaffinity");
}

// __wake_up_parent() does SYNC wake up, we need a handler to provoke
// signal_wake_up().
// otherwise ptrace_stop() is not preempted after read_unlock(tasklist).
static void sigchld(int sig)
{
}

int main(void)
{
	set_cpu(0);

	int pid = fork();
	if (!pid)
		for (;;)
			;

	struct sched_param sp = { 99 };
	if (sched_setscheduler(0, SCHED_FIFO, &sp))
		die("setscheduler");

	signal(SIGCHLD, sigchld);

	if (ptrace(PTRACE_ATTACH, pid, NULL, NULL))
		die("attach");

	wait(NULL);

	if (ptrace(PTRACE_DETACH, pid, NULL, NULL))
		die("detach");

	kill(pid, SIGKILL);

	return 0;
}

Locks CPU 0. Not a security problem, needs CAP_SYS_NICE and the task
could be reniced and killed, but still not good.

ptracee does ptrace_stop()->do_notify_parent_cldstop(), ptracer preempts
the child before it calls schedule(), ptrace(PTRACE_DETACH) goes to
wait_task_inactive() and yields forever.

Can we just replace yield() with schedule_timeout_uninterruptible(1) ?
wait_task_inactive() has no time-critical callers, and as it currently
used "on_rq" case is really unlikely.

Oleg.

