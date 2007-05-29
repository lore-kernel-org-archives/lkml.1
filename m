Return-Path: <linux-kernel-owner+w=401wt.eu-S1764277AbXE2KZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764277AbXE2KZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 06:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbXE2KZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 06:25:09 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:40355 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbXE2KZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 06:25:07 -0400
Date: Tue, 29 May 2007 15:53:56 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, pranith-kumar_d@mentorg.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] CFS scheduler, -v14
Message-ID: <20070529102356.GB12620@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20070523120616.GA23407@elte.hu> <20070524064235.GA2386@linux.vnet.ibm.com> <20070524080959.GA29151@elte.hu> <20070525124652.GA24038@elte.hu> <4657128F.7000600@linux.vnet.ibm.com> <20070528110748.GG25331@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528110748.GG25331@elte.hu>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 01:07:48PM +0200, Ingo Molnar wrote:
> 
> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > Ingo Molnar wrote:
> > > i found an accounting bug in this: it didnt sum up threads correctly. 
> > > The patch below fixes this. The stime == 0 problem is still there 
> > > though.
> > > 
> > > 	Ingo
> > > 
> > 
> > Thanks! I'll test the code on Monday. I do not understand the 
> > sysctl_sched_smoothing functionality, so I do not understand its 
> > impact on accounting. I'll take a look more closely
> 
> basically sysctl_sched_smoothing is more of a 'experimental features 
> flag' kind of thing. I'll remove it soon, you should only need to 
> concentrate on the functionality that it enables by default.
> 
> 	Ingo

Hi, Ingo,

I hope this patch addresses the stime == 0 problem.

This patch improves accounting of the CFS scheduler. We have the executed
run time in sum_exec_runtime field of the task. This patch splits the
sum_exec_runtime in the ratio of task->utime and task->stime to obtain
the user and system time of the task. 

TODO's:

1. Migrate getrusage() to use sum_exec_runtime so that the output in /proc
   is consistent with the data by running time(1).


Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 fs/proc/array.c |   27 ++++++++++++++++++++++++---
 linux/sched.h   |    0 
 2 files changed, 24 insertions(+), 3 deletions(-)

diff -puN fs/proc/array.c~cfs-distribute-accounting fs/proc/array.c
--- linux-2.6.22-rc2/fs/proc/array.c~cfs-distribute-accounting	2007-05-29 13:47:47.000000000 +0530
+++ linux-2.6.22-rc2-balbir/fs/proc/array.c	2007-05-29 15:35:22.000000000 +0530
@@ -332,7 +332,6 @@ static clock_t task_stime(struct task_st
 	return cputime_to_clock_t(p->stime);
 }
 
-
 static int do_task_stat(struct task_struct *task, char * buffer, int whole)
 {
 	unsigned long vsize, eip, esp, wchan = ~0UL;
@@ -400,8 +399,13 @@ static int do_task_stat(struct task_stru
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			utime += cputime_to_clock_t(sig->utime);
-			stime += cputime_to_clock_t(sig->stime);
+			if (!has_rt_policy(t))
+				utime += nsec_to_clock_t(
+						sig->sum_sched_runtime);
+			else {
+				utime += cputime_to_clock_t(sig->utime);
+				stime += cputime_to_clock_t(sig->stime);
+			}
 		}
 
 		sid = signal_session(sig);
@@ -421,6 +425,23 @@ static int do_task_stat(struct task_stru
 		stime = task_stime(task);
 	}
 
+	if (!has_rt_policy(task)) {
+		clock_t sum_us_time = utime + stime;
+		clock_t tu_time = cputime_to_clock_t(task->utime);
+		clock_t ts_time = cputime_to_clock_t(task->stime);
+		clock_t total_time = utime;
+
+		/*
+		 * Split up sched_exec_time according to the utime and
+		 * stime ratio. At this point utime contains the summed
+		 * sched_exec_runtime and stime is zero
+		 */
+		if (sum_us_time) {
+			utime = ((tu_time * total_time) / sum_us_time);
+			stime = ((ts_time * total_time) / sum_us_time);
+		}
+	}
+
 	/* scale priority and nice values from timeslices to -20..20 */
 	/* to make it look like a "normal" Unix priority/nice value  */
 	priority = task_prio(task);
diff -puN kernel/sys.c~cfs-distribute-accounting kernel/sys.c
diff -puN include/linux/sched.h~cfs-distribute-accounting include/linux/sched.h
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
