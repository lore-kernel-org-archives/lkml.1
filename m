Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0CETgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:36:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:46343 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754833Ab0CETgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:36:38 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX199e3Ze8wh9XyGgIKmoMds88Afbe1SK58cH7dpR3A
	YkZ9MwDvXkQM7O
Subject: Re: [patch 1/2] sched: check for prev_cpu == this_cpu in
 wake_affine()
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <20100305184213.829832580@sbs-t61.sc.intel.com>
References: <20100305184213.829832580@sbs-t61.sc.intel.com>
Content-Type: text/plain
Date: Fri, 05 Mar 2010 20:36:32 +0100
Message-Id: <1267817792.6384.37.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 10:39 -0800, Suresh Siddha wrote:
> plain text document attachment (fix_wake_affine.patch)
> On a single cpu system with SMT, in the scenario of one SMT thread being
> idle with another SMT thread running a task and doing a non sync wakeup of
> another task, we see (from the traces) that the woken up task ends up running
> on the busy thread instead of the idle thread. Idle balancing that comes
> in little bit later is fixing the scernaio.

Yup, wake_affine() fails for non sync wakeup when 1 task is running.
That's annoying, but making it succeed globally worries me.  We need a
high quality hint, and avg_overlap ain't it unfortunately, because to
get accurate overlap info cross cpu, you have to double clock and
update_curr() overhead.  We need dirt cheap.

> But fixing this wake balance and running the woken up task directly on the
> idle SMT thread improved the performance (phoronix 7zip compression workload)
> by ~9% on an atom platform.

So there is profit to be had.
  
> During the process wakeup, select_task_rq_fair() and wake_affine() makes
> the decision to wakeup the task either on the previous cpu that the task
> ran or the cpu that the task is currently woken up.
> 
> select_task_rq_fair() also goes through to see if there are any idle siblings
> for the cpu that the task is woken up on. This is to ensure that we select
> any idle sibling rather than choose a busy cpu.

Yeah, but with the 1 task + non-sync wakeup scenario, we miss the boat
because select_idle_sibling() uses wake_affine() success as it's
enabler.  I did that because I couldn't think up something else which
did not harm multiple buddy pairs.  You can globally say sibling is
idle, go for it, but that _does_ cause throughput loss during ramp up.

Best alternative I've found is to only check for an idle sibling/cache
when there is exactly one task on the current cpu (ie put some faith in
load balancing), then force idle sibling selection.  Also not optimal.
 
> In the above load scenario, it so happens that the prev_cpu (that the
> task ran before) and this_cpu (where it is woken up currently) are the same. And
> in this case, it looks like wake_affine() returns 0 and ultimately not selecting
> the idle sibling chosen by select_idle_sibling() in select_task_rq_fair().
> Further down the path of select_task_rq_fair(), we ultimately select
> the currently running cpu (busy SMT thread instead of the idle SMT thread).
> 
> Check for prev_cpu == this_cpu in wake_affine() and no need to do
> any fancy stuff(and ultimately taking wrong decisions) in this case.

I have a slightly different patch for that in my tree.  There's no need
to even call wake_affine() since the result is meaningless.

---
 kernel/sched_fair.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6.34.git/kernel/sched_fair.c
===================================================================
--- linux-2.6.34.git.orig/kernel/sched_fair.c
+++ linux-2.6.34.git/kernel/sched_fair.c
@@ -1547,8 +1547,14 @@ static int select_task_rq_fair(struct ta
 	}
 #endif
 
-	if (affine_sd && wake_affine(affine_sd, p, sync))
-		return cpu;
+	if (affine_sd) {
+		if (cpu == prev_cpu)
+			return cpu;
+		if (wake_affine(affine_sd, p, sync))
+			return cpu;
+		if (!(affine_sd->flags & SD_BALANCE_WAKE))
+			return prev_cpu;
+	}
 
 	while (sd) {
 		int load_idx = sd->forkexec_idx;


