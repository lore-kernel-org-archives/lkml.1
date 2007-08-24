Return-Path: <linux-kernel-owner+w=401wt.eu-S1763179AbXHXNp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763179AbXHXNp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 09:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbXHXNpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 09:45:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39948 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbXHXNpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 09:45:20 -0400
Date: Fri, 24 Aug 2007 15:45:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Boldi <a1426z@gawab.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070824134510.GA21382@elte.hu>
References: <200708111344.42934.a1426z@gawab.com> <200708122243.05191.a1426z@gawab.com> <20070821105858.GC26598@elte.hu> <200708220127.30698.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708220127.30698.a1426z@gawab.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Boldi <a1426z@gawab.com> wrote:

> > > The problem is that consecutive runs don't give consistent results 
> > > and sometimes stalls.  You may want to try that.
> >
> > well, there's a natural saturation point after a few hundred tasks 
> > (depending on your CPU's speed), at which point there's no idle time 
> > left. From that point on things get slower progressively (and the 
> > ability of the shell to start new ping tasks is impacted as well), 
> > but that's expected on an overloaded system, isnt it?
> 
> Of course, things should get slower with higher load, but it should be 
> consistent without stalls.
> 
> To see this problem, make sure you boot into /bin/sh with the normal 
> VGA console (ie. not fb-console).  Then try each loop a few times to 
> show different behaviour; loops like:
> 
> # for ((i=0; i<3333; i++)); do ping 10.1 -A > /dev/null & done
> 
> # for ((i=0; i<3333; i++)); do nice -99 ping 10.1 -A > /dev/null & done
> 
> # { for ((i=0; i<3333; i++)); do
>         ping 10.1 -A > /dev/null &
>     done } > /dev/null 2>&1
> 
> Especially the last one sometimes causes a complete console lock-up, 
> while the other two sometimes stall then surge periodically.

ok. I think i might finally have found the bug causing this. Could you 
try the fix below, does your webserver thread-startup test work any 
better?

	Ingo

--------------------------->
Subject: sched: fix startup penalty calculation
From: Ingo Molnar <mingo@elte.hu>

fix task startup penalty miscalculation: sysctl_sched_granularity is
unsigned int and wait_runtime is long so we first have to convert it
to long before turning it negative ...

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -1048,7 +1048,7 @@ static void task_new_fair(struct rq *rq,
 	 * -granularity/2, so initialize the task with that:
 	 */
 	if (sysctl_sched_features & SCHED_FEAT_START_DEBIT)
-		p->se.wait_runtime = -(sysctl_sched_granularity / 2);
+		p->se.wait_runtime = -((long)sysctl_sched_granularity / 2);
 
 	__enqueue_entity(cfs_rq, se);
 }
