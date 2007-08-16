Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbXHPMGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbXHPMGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 08:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbXHPMGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 08:06:32 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60035 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbXHPMGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 08:06:30 -0400
Date: Thu, 16 Aug 2007 17:36:27 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Paul E McKenney <paulmck@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: rt ptracer can monopolize CPU (was: Cpu-Hotplug and Real-Time)
Message-ID: <20070816120627.GA26789@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070807131216.GA20424@in.ibm.com> <20070807151336.GA507@tv-sign.ru> <20070809170353.GA82@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809170353.GA82@tv-sign.ru>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 09:03:53PM +0400, Oleg Nesterov wrote:
> On 08/07, Oleg Nesterov wrote:
> >
> > On 08/07, Gautham R Shenoy wrote:
> > >
> > > A will now call kthread_bind(B, cpu1).
> > > kthread_bind(), calls wait_task_inactive(B), to ensures that 
> > > B has scheduled itself out.
> > > 
> > > B is still on the runqueue, so A calls yield() in wait_task_inactive().
> > > But since A is the task with the highest prio, scheduler schedules it
> > > back again.
> > > 
> > > Thus B never gets to run to schedule itself out.
> > > A loops waiting for B to schedule out leading  to system hang.
> > 
> > But I think we have another case. An RT ptracer can share the same CPU
> > with ptracee. The latter sets TASK_STOPPED, unlocks ->siglock, and takes
> > a preemption. Ptracer does ptrace_check_attach(), sees TASK_STOPPED, and
> > yields in wait_task_inactive.
> 
> Even simpler.
> 
> #include <stdio.h>
> #include <signal.h>
> #include <unistd.h>
> #include <sys/ptrace.h>
> #include <sys/wait.h>
> #define	__USE_GNU
> #include <sched.h>
> 
> void die(const char *msg)
> {
> 	printf("ERR!! %s: %m\n", msg);
>         kill(0, SIGKILL);
> }
> 
> void set_cpu(int cpu)
> {
> 	unsigned cpuval = 1 << cpu;
> 	if (sched_setaffinity(0, 4, (void*)&cpuval) < 0)
> 		die("setaffinity");
> }
> 
> // __wake_up_parent() does SYNC wake up, we need a handler to provoke
> // signal_wake_up().
> // otherwise ptrace_stop() is not preempted after read_unlock(tasklist).
> static void sigchld(int sig)
> {
> }
> 
> int main(void)
> {
> 	set_cpu(0);
> 
> 	int pid = fork();
> 	if (!pid)
> 		for (;;)
> 			;
> 
> 	struct sched_param sp = { 99 };
> 	if (sched_setscheduler(0, SCHED_FIFO, &sp))
> 		die("setscheduler");
> 
> 	signal(SIGCHLD, sigchld);
> 
> 	if (ptrace(PTRACE_ATTACH, pid, NULL, NULL))
> 		die("attach");
> 
> 	wait(NULL);
> 
> 	if (ptrace(PTRACE_DETACH, pid, NULL, NULL))
> 		die("detach");
> 
> 	kill(pid, SIGKILL);
> 
> 	return 0;
> }
> 
> Locks CPU 0. Not a security problem, needs CAP_SYS_NICE and the task
> could be reniced and killed, but still not good.
> 
> ptracee does ptrace_stop()->do_notify_parent_cldstop(), ptracer preempts
> the child before it calls schedule(), ptrace(PTRACE_DETACH) goes to
> wait_task_inactive() and yields forever.
> 
> Can we just replace yield() with schedule_timeout_uninterruptible(1) ?
> wait_task_inactive() has no time-critical callers, and as it currently
> used "on_rq" case is really unlikely.

schedule_timeout_uninterruptible(1) works fine, in my case.
It makes sense to have it there instead of yield. Like you pointed out, 
it gets called only in "unlikely" case.

patch below.
Thanks and Regards
gautham.

-->
yield() in wait_task_inactive(), can cause a high priority thread to be
scheduled back in, and there by loop forever while it is waiting for some
lower priority thread which is unfortunately still on the runqueue. 

Use schedule_timeout_uninterruptible(1) instead.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Credit: Oleg Nesterov <oleg@tv-sign.ru>

---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-rc2/kernel/sched.c
===================================================================
--- linux-2.6.23-rc2.orig/kernel/sched.c
+++ linux-2.6.23-rc2/kernel/sched.c
@@ -1106,7 +1106,7 @@ repeat:
 	 * yield - it could be a while.
 	 */
 	if (unlikely(on_rq)) {
-		yield();
+		schedule_timeout_uninterruptible(1);
 		goto repeat;
 	}
 

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
