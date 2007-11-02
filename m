Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbXKBQ5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbXKBQ5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 12:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbXKBQ5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 12:57:47 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44989 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbXKBQ5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 12:57:46 -0400
Date: Fri, 2 Nov 2007 22:25:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix delay accounting regression
Message-ID: <20071102165559.GA5424@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20071102142220.24166.49046.sendpatchset@balbir-laptop> <20071102155358.GA32116@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102155358.GA32116@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 04:53:58PM +0100, Ingo Molnar wrote:
> 
> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > Fix the delay accounting regression introduced by commit 
> > 75d4ef16a6aa84f708188bada182315f80aab6fa. rq no longer has sched_info 
> > data associated with it. task_struct sched_info structure is used by 
> > delay accounting to provide back statistics to user space.
> 
> no, this really is broken code. sched_clock() is not a generally 
> reliable time source so at a minimum the rq->clock fix i mentioned is 
> needed. What user-space tools are utilizing delay-accounting by the way? 
> We have most of this data available under SCHEDSTATS - how about 
> consolidating CONFIG_TASK_DELAY_ACCT into CONFIG_SCHEDSTATS?
> 
> 	Ingo

Hi, Ingo,

How about this?


Changelog
1. As per Ingo Molnar's recommendation, use rq->clock instead of sched_clock().


Fix the delay accounting regression introduced by commit
75d4ef16a6aa84f708188bada182315f80aab6fa. rq no longer has sched_info
data associated with it. task_struct sched_info structure is used by delay
accounting to provide back statistics to user space.


Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 kernel/sched_stats.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN kernel/sched_stats.h~delayacct-define-bug kernel/sched_stats.h
--- linux-2.6-latest/kernel/sched_stats.h~delayacct-define-bug	2007-11-02 19:02:07.000000000 +0530
+++ linux-2.6-latest-balbir/kernel/sched_stats.h	2007-11-02 22:11:21.000000000 +0530
@@ -127,7 +127,7 @@ rq_sched_info_depart(struct rq *rq, unsi
 # define schedstat_set(var, val)	do { } while (0)
 #endif
 
-#ifdef CONFIG_SCHEDSTATS
+#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 /*
  * Called when a process is dequeued from the active array and given
  * the cpu.  We should note that with the exception of interactive
@@ -155,7 +155,7 @@ static inline void sched_info_dequeued(s
  */
 static void sched_info_arrive(struct task_struct *t)
 {
-	unsigned long long now = sched_clock(), delta = 0;
+	unsigned long long now = task_rq(t)->clock, delta = 0;
 
 	if (t->sched_info.last_queued)
 		delta = now - t->sched_info.last_queued;
@@ -186,7 +186,7 @@ static inline void sched_info_queued(str
 {
 	if (unlikely(sched_info_on()))
 		if (!t->sched_info.last_queued)
-			t->sched_info.last_queued = sched_clock();
+			t->sched_info.last_queued = task_rq(t)->clock;
 }
 
 /*
@@ -195,7 +195,8 @@ static inline void sched_info_queued(str
  */
 static inline void sched_info_depart(struct task_struct *t)
 {
-	unsigned long long delta = sched_clock() - t->sched_info.last_arrival;
+	unsigned long long delta = task_rq(t)->clock -
+					t->sched_info.last_arrival;
 
 	t->sched_info.cpu_time += delta;
 	rq_sched_info_depart(task_rq(t), delta);
@@ -231,5 +232,5 @@ sched_info_switch(struct task_struct *pr
 #else
 #define sched_info_queued(t)		do { } while (0)
 #define sched_info_switch(t, next)	do { } while (0)
-#endif /* CONFIG_SCHEDSTATS */
+#endif /* CONFIG_SCHEDSTATS || CONFIG_TASK_DELAY_ACCT */
 
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
