Return-Path: <linux-kernel-owner+w=401wt.eu-S2993144AbXCIVTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993144AbXCIVTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993145AbXCIVTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:19:39 -0500
Received: from mail33.syd.optusnet.com.au ([211.29.132.104]:42422 "EHLO
	mail33.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993144AbXCIVTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:19:38 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Date: Sat, 10 Mar 2007 08:19:18 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070309053931.GA10459@waste.org> <20070309204623.GE10394@waste.org> <200703100807.43582.kernel@kolivas.org>
In-Reply-To: <200703100807.43582.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703100819.18354.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2007 08:07, Con Kolivas wrote:
> On Saturday 10 March 2007 07:46, Matt Mackall wrote:
> > My suspicion is the problem lies in giving too much quanta to
> > newly-started processes.
>
> Ah that's some nice detective work there. Mainline does some rather complex
> accounting on sched_fork including (possibly) a whole timer tick which rsdl
> does not do. make forks off continuously so what you say may well be
> correct. I'll see if I can try to revert to the mainline behaviour in
> sched_fork (which was obviously there for a reason).

Wow! Thanks Matt. You've found a real bug too. This seems to fix the qemu
 misbehaviour and bitmap errors so far too! Now can you please try this to see
 if it fixes your problem?

---
 kernel/sched.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6.21-rc3-mm1/kernel/sched.c
===================================================================
--- linux-2.6.21-rc3-mm1.orig/kernel/sched.c	2007-03-10 08:08:11.000000000 +1100
+++ linux-2.6.21-rc3-mm1/kernel/sched.c	2007-03-10 08:13:57.000000000 +1100
@@ -1560,7 +1560,7 @@ int fastcall wake_up_state(struct task_s
 	return try_to_wake_up(p, state, 0);
 }
 
-static void task_expired_entitlement(struct rq *rq, struct task_struct *p);
+static void task_running_tick(struct rq *rq, struct task_struct *p);
 /*
  * Perform scheduler related setup for a newly forked process p.
  * p is forked by current.
@@ -1621,10 +1621,8 @@ void fastcall sched_fork(struct task_str
 		 * left from its timeslice. Taking the runqueue lock is not
 		 * a problem.
 		 */
-		struct rq *rq = __task_rq_lock(current);
-
-		task_expired_entitlement(rq, current);
-		__task_rq_unlock(rq);
+		current->time_slice = 1;
+		task_running_tick(cpu_rq(cpu), current);
 	}
 	local_irq_enable();
 out:

-- 
-ck
