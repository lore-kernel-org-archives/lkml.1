Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbXD1PQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbXD1PQX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 11:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbXD1PQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 11:16:23 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56276 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbXD1PQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 11:16:21 -0400
Date: Sat, 28 Apr 2007 20:53:27 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070428152327.GE14716@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070425214704.GA32572@elte.hu> <20070428124516.GA27292@in.ibm.com> <20070428135338.GA8207@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070428135338.GA8207@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 03:53:38PM +0200, Ingo Molnar wrote:
> > Won't it help if you update rq->rb_leftmost above from the value 
> > returned by rb_first(), so that subsequent calls to first_fair will be 
> > sped up?
> 
> yeah, indeed. Would you like to do a patch for that?

My pleasure :)

With the patch below applied, I ran a "time -p make -s -j10 bzImage"
test.

2.6.20 + cfs-v6			-> 186.45 (real)
2.6.20 + cfs-v6 + this_patch	-> 184.55 (real)

or about ~1% improvement in real wall-clock time. This was with the default 
sched_granularity_ns of 6000000. I suspect larger the value of
sched_granularity_ns and the number of (SCHED_NORMAL) tasks in system, better 
the benefit from this caching.


Cache value returned by rb_first(), for faster subsequent lookups.

Signed-off-by : Srivatsa Vaddagiri <vatsa@in.ibm.com>


---


diff -puN kernel/sched_fair.c~speedup kernel/sched_fair.c
--- linux-2.6.21/kernel/sched_fair.c~speedup	2007-04-28 19:28:08.000000000 +0530
+++ linux-2.6.21-vatsa/kernel/sched_fair.c	2007-04-28 19:34:55.000000000 +0530
@@ -86,7 +86,9 @@ static inline struct rb_node * first_fai
 {
 	if (rq->rb_leftmost)
 		return rq->rb_leftmost;
-	return rb_first(&rq->tasks_timeline);
+	/* Cache the value returned by rb_first() */
+	rq->rb_leftmost = rb_first(&rq->tasks_timeline);
+	return rq->rb_leftmost;
 }
 
 static struct task_struct * __pick_next_task_fair(struct rq *rq)
_




	

-- 
Regards,
vatsa
