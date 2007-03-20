Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbXCTNWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbXCTNWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 09:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932806AbXCTNWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 09:22:05 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:1337 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932796AbXCTNWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 09:22:04 -0400
Message-ID: <45FFDFF8.2090208@rtr.ca>
Date: Tue, 20 Mar 2007 09:22:00 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Xavier Bestel <xavier.bestel@free.fr>, Al Boldi <a1426z@gawab.com>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RSDL v0.31
References: <200703042335.26785.a1426z@gawab.com>  <200703172048.46267.kernel@kolivas.org>  <1174125534.7734.2.camel@Homer.simpson.net>  <200703172355.30989.a1426z@gawab.com>  <45FEB54A.3040602@rtr.ca>  <1174321617.30876.69.camel@frg-rhel40-em64t-04>  <45FEBBF5.9060002@rtr.ca> <1174322580.30876.72.camel@frg-rhel40-em64t-04> <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Quite frankly, I was *planning* on merging RSDL very early after 2.6.21, 
> but there is one thing that has turned me completely off the whole thing:
> 
>  - the people involved seem to be totally unwilling to even admit there 
>    might be a problem.

Not to mention that it seems to only be tested thus far
by a very vocal and supportive core.  It needs much wider
exposure for much longer before risking it in mainline.
It likely will get there, eventually, just not yet.

I've droppped it from my machine -- interactive response is much
more important for my primary machine right now.

I believe Ingo's much simpler hack produces as good/bad results
as this RSDL thingie, and with one important extra:
it can be switched on/off at runtime.

----->forwarded message:

Subject: [patch] CFS scheduler: Completely Fair Scheduler
From: Ingo Molnar <mingo@elte.hu>

add the CONFIG_SCHED_FAIR option (default: off): this turns the Linux 
scheduler into a completely fair scheduler for SCHED_OTHER tasks: with 
perfect roundrobin scheduling, fair distribution of timeslices combined 
with no interactivity boosting and no heuristics.

a /proc/sys/kernel/sched_fair option is also available to turn
this behavior on/off.

if this option establishes itself amongst leading distributions then we
could in the future remove the interactivity estimator altogether.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h  |    1 +
 kernel/Kconfig.preempt |    9 +++++++++
 kernel/sched.c         |    8 ++++++++
 kernel/sysctl.c        |   10 ++++++++++
 4 files changed, 28 insertions(+)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -119,6 +119,7 @@ extern unsigned long avenrun[];		/* Load
 	load += n*(FIXED_1-exp); \
 	load >>= FSHIFT;
 
+extern unsigned int sched_fair;
 extern unsigned long total_forks;
 extern int nr_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
Index: linux/kernel/Kconfig.preempt
===================================================================
--- linux.orig/kernel/Kconfig.preempt
+++ linux/kernel/Kconfig.preempt
@@ -63,3 +63,12 @@ config PREEMPT_BKL
 	  Say Y here if you are building a kernel for a desktop system.
 	  Say N if you are unsure.
 
+config SCHED_FAIR
+	bool "Completely Fair Scheduler"
+	help
+	  This option turns the Linux scheduler into a completely fair
+	  scheduler. User-space workloads will round-robin fairly, and
+	  they have to be prioritized using nice levels.
+
+	  Say N if you are unsure.
+
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -4040,6 +4040,10 @@ static inline struct task_struct *find_p
 	return pid ? find_task_by_pid(pid) : current;
 }
 
+#ifdef CONFIG_SCHED_FAIR
+unsigned int sched_fair = 1;
+#endif
+
 /* Actually do priority change: must hold rq lock. */
 static void __setscheduler(struct task_struct *p, int policy, int prio)
 {
@@ -4055,6 +4059,10 @@ static void __setscheduler(struct task_s
 	 */
 	if (policy == SCHED_BATCH)
 		p->sleep_avg = 0;
+#ifdef CONFIG_SCHED_FAIR
+	if (policy == SCHED_NORMAL && sched_fair)
+		p->sleep_avg = 0;
+#endif
 	set_load_weight(p);
 }
 
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -205,6 +205,16 @@ static ctl_table root_table[] = {
 };
 
 static ctl_table kern_table[] = {
+#ifdef CONFIG_SCHED_FAIR
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_fair",
+		.data		= &sched_fair,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 	{
 		.ctl_name	= KERN_PANIC,
 		.procname	= "panic",
