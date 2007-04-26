Return-Path: <linux-kernel-owner+w=401wt.eu-S1031221AbXDZM6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031221AbXDZM6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 08:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031222AbXDZM6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 08:58:51 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38468 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031221AbXDZM6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 08:58:49 -0400
Date: Thu, 26 Apr 2007 18:28:38 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc7-mm1: BUG_ON in kthread_bind during _cpu_down
Message-ID: <20070426125838.GC12892@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200704260110.22224.rjw@sisk.pl> <20070425165410.b73443b4.akpm@linux-foundation.org> <20070426100922.GB12892@in.ibm.com> <20070426101547.GA97@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426101547.GA97@tv-sign.ru>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 02:15:47PM +0400, Oleg Nesterov wrote:
> 
> I can't understand why do we need to re-bind this thread. We are doing
> kthread_stop()->wake_up() below, at this point move_task_off_dead_cpu()
> has already cared about this task, no?
> 
> > We only need to ensure in kthread_bind that the task which is being
> > bound is not running or exiting. Doesn't matter if it's sleeping in 
> > TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE state.
> 
> We need to ensure that this task can't be woken after return from
> wait_task_inactive(k), otherwise set_task_cpu() after that is not safe.
> 
> TASK_INTERRUPTIBLE doesn't protect us from freezing.
> 
> Couldn't we just remove this kthread_bind() ?

Fair enough. We are anyway kthread_stop()ping other per-cpu kernel threads
after move_task_off_dead_cpu(), so we can do it with the stop_machine_run
thread as well.

I just checked with Vatsa if there was any subtle reason why they
had put in the kthread_bind() in cpu.c. Vatsa cannot seem to recollect
any and I can't see any. So let us just remove the kthread_bind.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 kernel/cpu.c |    4 ----
 1 files changed, 4 deletions(-)

Index: linux-2.6.21-rc7/kernel/cpu.c
===================================================================
--- linux-2.6.21-rc7.orig/kernel/cpu.c
+++ linux-2.6.21-rc7/kernel/cpu.c
@@ -176,10 +176,6 @@ static int _cpu_down(unsigned int cpu, i
 	/* This actually kills the CPU. */
 	__cpu_die(cpu);
 
-	/* Move it here so it can run. */
-	kthread_bind(p, get_cpu());
-	put_cpu();
-
 	/* CPU is completely dead: tell everyone.  Too late to complain. */
 	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD | mod,
 				    hcpu) == NOTIFY_BAD)
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
