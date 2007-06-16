Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbXFPKh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbXFPKh3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 06:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbXFPKhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 06:37:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39365 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbXFPKhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 06:37:21 -0400
Date: Sat, 16 Jun 2007 12:37:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070616103707.GA28096@elte.hu>
References: <E1HrC3W-0005SZ-00@dorka.pomaz.szeredi.hu> <20070524125453.GA7554@elte.hu> <E1HrDuQ-0005m7-00@dorka.pomaz.szeredi.hu> <20070524141059.GA19872@elte.hu> <E1HrEIp-0005qy-00@dorka.pomaz.szeredi.hu> <20070524144447.GA25068@elte.hu> <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu> <20070524210153.GB19672@elte.hu> <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> I've got some more info about this bug.  It is gathered with 
> nmi_watchdog=2 and a modified nmi_watchdog_tick(), which instead of 
> calling die_nmi() just prints a line and calls show_registers().

great!

> The pattern that emerges is that on CPU0 we have an interrupt, which 
> is trying to acquire the rq lock, but can't.
> 
> On CPU1 we have strace which is doing wait_task_inactive(), which sort 
> of spins acquiring and releasing the rq lock.  I've checked some of 
> the traces and it is just before acquiring the rq lock, or just after 
> releasing it, but is not actually holding it.
> 
> So is it possible that wait_task_inactive() could be starving the 
> other waiters of the rq spinlock?  Any ideas?

hm, this is really interesting, and indeed a smoking gun. The T60 has a 
Core2Duo and i've _never_ seen MESI starvation happen on dual-core 
single-socket CPUs! (The only known serious MESI starvation i know about 
is on multi-socket Opterons: there the trylock loop of spinlock 
debugging is known to starve some CPUs out of those locks that are being 
polled, so we had to turn off that aspect of spinlock debugging.)

wait_task_inactive(), although it busy-loops, is pretty robust: it does 
a proper spin-lock/spin-unlock sequence and has a cpu_relax() inbetween. 
Furthermore, the rep_nop() that cpu_relax() is based on is 
unconditional, so it's not like we could somehow end up not having the 
REP; NOP sequence there (which should make the lock polling even more 
fair)

could you try the quick hack below, ontop of cfs-v17? It adds two things 
to wait_task_inactive():

- a cond_resched() [in case you are running !PREEMPT]

- use MONITOR+MWAIT to monitor memory transactions to the rq->curr 
  cacheline. This should make the polling loop definitely fair.

If this solves the problem on your box then i'll do a proper fix and 
introduce a cpu_relax_memory_change(*addr) type of API to around 
monitor/mwait. This patch boots fine on my T60 - but i never saw your 
problem.

[ btw., utrace IIRC fixes ptrace to get rid of wait_task_interactive(). ]

	Ingo

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -834,6 +834,16 @@ repeat:
 		cpu_relax();
 		if (preempted)
 			yield();
+		else
+			cond_resched();
+		/*
+		 * Wait for "curr" to change:
+		 */
+		__monitor((void *)&rq->curr, 0, 0);
+		smp_mb();
+		if (rq->curr != p)
+			__mwait(0, 0);
+
 		goto repeat;
 	}
 	task_rq_unlock(rq, &flags);
