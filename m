Return-Path: <linux-kernel-owner+w=401wt.eu-S1764997AbYCGUTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764997AbYCGUTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 15:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757436AbYCGUTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 15:19:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756839AbYCGUTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 15:19:13 -0500
Date: Fri, 7 Mar 2008 12:18:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Cc: ego@in.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, yi.y.yang@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, tglx@linutronix.de
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are
 dealocked when cpu is set to offline
Message-Id: <20080307121822.54b8c2fb.akpm@linux-foundation.org>
In-Reply-To: <b647ffbd0803070502m28355751rd526ed8ca4dd90a@mail.gmail.com>
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com>
	<20080303153154.GA11288@in.ibm.com>
	<1204555505.3842.4.camel@yangyi-dev.bj.intel.com>
	<20080304052613.GA28632@in.ibm.com>
	<20080304150107.GA564@tv-sign.ru>
	<20080306134400.GA1915@in.ibm.com>
	<20080307025451.GA201@tv-sign.ru>
	<20080307091049.GA8827@in.ibm.com>
	<20080307105138.GA10576@in.ibm.com>
	<b647ffbd0803070502m28355751rd526ed8ca4dd90a@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008 14:02:20 +0100
"Dmitry Adamushko" <dmitry.adamushko@gmail.com> wrote:

> Hi,
> 
> 'watchdog' is of SCHED_FIFO class. The standard load-balancer doesn't
> move RT tasks between cpus anymore and there is a special mechanism in
> scher_rt.c instead (I think, it's .25 material).
> 
> So I wonder, whether __migrate_task() is still capable of properly
> moving a RT task to another CPU (e.g. for the case when it's in
> TASK_RUNNING state) without breaking something in the rt migration
> mechanism (or whatever else) that would leave us with a runqueue in
> the 'inconsistent' state...
> (I've taken a quick look at the relevant code so can't confirm it yet)
> 
> maybe it'd be faster if somebody could do a quick test now with the
> following line commented out in kernel/softlockup.c :: watchdog()
> 
> -         sched_setscheduler(current, SCHED_FIFO, &param);
> 

Yup, thanks.  This:


 kernel/softirq.c      |    2 +-
 kernel/softlockup.c   |    2 +-
 kernel/stop_machine.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/softlockup.c~a kernel/softlockup.c
--- a/kernel/softlockup.c~a
+++ a/kernel/softlockup.c
@@ -211,7 +211,7 @@ static int watchdog(void *__bind_cpu)
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 	int this_cpu = (long)__bind_cpu;
 
-	sched_setscheduler(current, SCHED_FIFO, &param);
+//	sched_setscheduler(current, SCHED_FIFO, &param);
 
 	/* initialize timestamp */
 	touch_softlockup_watchdog();
diff -puN kernel/stop_machine.c~a kernel/stop_machine.c
--- a/kernel/stop_machine.c~a
+++ a/kernel/stop_machine.c
@@ -188,7 +188,7 @@ struct task_struct *__stop_machine_run(i
 		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
 		/* One high-prio thread per cpu.  We'll do this one. */
-		sched_setscheduler(p, SCHED_FIFO, &param);
+//		sched_setscheduler(p, SCHED_FIFO, &param);
 		kthread_bind(p, cpu);
 		wake_up_process(p);
 		wait_for_completion(&smdata.done);
diff -puN kernel/softirq.c~a kernel/softirq.c
--- a/kernel/softirq.c~a
+++ a/kernel/softirq.c
@@ -622,7 +622,7 @@ static int __cpuinit cpu_callback(struct
 
 		p = per_cpu(ksoftirqd, hotcpu);
 		per_cpu(ksoftirqd, hotcpu) = NULL;
-		sched_setscheduler(p, SCHED_FIFO, &param);
+//		sched_setscheduler(p, SCHED_FIFO, &param);
 		kthread_stop(p);
 		takeover_tasklets(hotcpu);
 		break;
_

fixes the wont-power-off regression.

But 2.6.24 runs the watchdog threads SCHED_FIFO too.  Are you saying that
it's the migration code which changed? 
