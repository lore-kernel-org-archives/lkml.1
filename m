Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbZBFOBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbZBFOBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZBFOBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:01:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49765 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbZBFOBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:01:42 -0500
Date: Fri, 6 Feb 2009 15:01:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86-tip.today: flood of WARNING: at include/linux/sched.h:2238
	run_posix_cpu_timers+0xea/0x79f()
Message-ID: <20090206140134.GC3415@elte.hu>
References: <1233910614.23431.18.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233910614.23431.18.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> Greetings,
> 
> Futzing with kerneltop this morning, I fired up amarok to give it
> something light to monitor while I hunt missing events.  Something bad
> happened, and when I finally (SysRq-E took minutes) got control of box
> back, dmesg was full of a steady stream of the below.
> 
> That warning can be kinda unfriendly.
> 
> 
> [ 9964.600004] ------------[ cut here ]------------
> [ 9964.600006] WARNING: at include/linux/sched.h:2238 run_posix_cpu_timers+0xea/0x79f()

ah, that's Peter's stuff:

 4cd4c1b: timers: split process wide cpu clocks/timers
 32bd671: signal: re-add dead task accumulation stats.

The discussion with Oleg resulted in the conclusion i 
think that the warning is spurious and should be removed.

I've commited the minimal fix below to tip:master. There's
more fixes needed too but this should solve the warning
flood at least.

	Ingo

------------------------>
>From 7d8e23df69820e6be42bcc41d441f4860e8c76f7 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 6 Feb 2009 14:57:51 +0100
Subject: [PATCH] timers: split process wide cpu clocks/timers, remove spurious warning

Mike Galbraith reported that the new warning in thread_group_cputimer()
triggers en masse with Amarok running.

Oleg Nesterov observed:

  Can't fastpath_timer_check()->thread_group_cputimer() have the
  false warning too? Suppose we had the timer, then posix_cpu_timer_del()
  removes this timer, but task_cputime_zero(&sig->cputime_expires) still
  not true.

Remove the spurious debug warning.

Reported-by: Mike Galbraith <efault@gmx.de>
Explained-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 082d761..7939291 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2208,8 +2208,6 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 	unsigned long flags;
 
-	WARN_ON(!cputimer->running);
-
 	spin_lock_irqsave(&cputimer->lock, flags);
 	*times = cputimer->cputime;
 	spin_unlock_irqrestore(&cputimer->lock, flags);
