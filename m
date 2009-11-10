Return-Path: <linux-kernel-owner+w=401wt.eu-S1757824AbZKJTMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824AbZKJTMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbZKJTMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:12:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:54687 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659AbZKJTMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:12:13 -0500
Subject: [PATCH -v2] sched: Make sure task has correct sched_class after
 policy change
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Williams <pwil3058@bigpond.net.au>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1257179120.10173.50.camel@marge.simson.net>
References: <1256814753.7300.1.camel@marge.simson.net>
	 <20091102162056.GC15423@elte.hu>
	 <1257179120.10173.50.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 20:12:01 +0100
Message-ID: <1257880321.4108.457.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2009-11-02 at 17:20 +0100, Ingo Molnar wrote:

> > i zapped the buggy patch from sched/urgent already - mind sending a 
> > full, fixed patch? (with lkml and everyone involved cc-ed)

Updated patch below... 

 git branch -a --contains 67d08dfed042855431dc99c9e0e6f6f7e85737ef

doesn't actually tell me anything other than tip/master, which is
strange... I'd expect one of the tip/sched branches to have it too.

Will you rebase whatever tree its in, getting rid of the initial commit
and revert?

---
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: sched: Make sure task has correct sched_class after policy change

>From the code in rt_mutex_setprio(), it is evident that the
intention is that task's with a RT 'prio' value as a consequence of
receiving a PI boost also have their 'sched_class' field set to
'&rt_sched_class'.

However, Peter noticed that the code in __setscheduler() could
result in this intention being frustrated. Fix it.

Reported-by: Peter Williams <pwil3058@bigpond.net.au>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6188,22 +6188,14 @@ __setscheduler(struct rq *rq, struct tas
 	BUG_ON(p->se.on_rq);
 
 	p->policy = policy;
-	switch (p->policy) {
-	case SCHED_NORMAL:
-	case SCHED_BATCH:
-	case SCHED_IDLE:
-		p->sched_class = &fair_sched_class;
-		break;
-	case SCHED_FIFO:
-	case SCHED_RR:
-		p->sched_class = &rt_sched_class;
-		break;
-	}
-
 	p->rt_priority = prio;
 	p->normal_prio = normal_prio(p);
 	/* we are holding p->pi_lock already */
 	p->prio = rt_mutex_getprio(p);
+	if (rt_prio(p->prio))
+		p->sched_class = &rt_sched_class;
+	else
+		p->sched_class = &fair_sched_class;
 	set_load_weight(p);
 }
 


