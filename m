Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbYHKMwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbYHKMwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 08:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbYHKMwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 08:52:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42929 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbYHKMwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 08:52:09 -0400
Date: Mon, 11 Aug 2008 14:51:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [revert] mysql+oltp regression
Message-ID: <20080811125155.GA32050@elte.hu>
References: <1218454322.25098.24.camel@marge.simson.net> <20080811114324.GA23529@elte.hu> <48A03049.202@novell.com> <20080811124857.GD10082@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811124857.GD10082@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> And given that the problem was readily reproducible for Mike, it 
> should be reproducible for you as well - so we dont actually make the 
> bug harder to fix by doing the revert.
> 
> Perhaps we should introduce the notion of "Defer-to-next-release" 
> reverts - which this really is - in contrast to "Revert-because-bad", 
> which your change definitely is not.

i've edited the commit message in the manner below to make this 
distinction more apparent.

	Ingo

---------------------->
>From 77ae651347bdd46830da8b28b1efc5e4a9d7cbd0 Mon Sep 17 00:00:00 2001
From: Mike Galbraith <efault@gmx.de>
Date: Mon, 11 Aug 2008 13:32:02 +0200
Subject: [PATCH] sched: fix mysql+oltp regression

Defer commit 6d299f1b53b84e2665f402d9bcc494800aba6386 to the next release.

Testing of the tip/sched/clock tree revealed a mysql+oltp regression
which bisection eventually traced back to this commit in mainline.

Pertinent test results:  Three run sysbench averages, throughput units
in read/write requests/sec.

clients         1     2     4     8    16    32    64
6e0534f      9646 17876 34774 33868 32230 30767 29441
2.6.26.1     9112 17936 34652 33383 31929 30665 29232
6d299f1      9112 14637 28370 33339 32038 30762 29204

Note: subsequent commits hide the majority of this regression until you
apply the clock fixes, at which time it reemerges at full magnitude.

We cannot see anything bad about the change itself so we defer it to the
next release until this problem is fully analysed.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0fe94ea..fb8994c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1442,18 +1442,23 @@ __load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
 	struct task_struct *p = NULL;
 	struct sched_entity *se;
 
-	while (next != &cfs_rq->tasks) {
+	if (next == &cfs_rq->tasks)
+		return NULL;
+
+	/* Skip over entities that are not tasks */
+	do {
 		se = list_entry(next, struct sched_entity, group_node);
 		next = next->next;
+	} while (next != &cfs_rq->tasks && !entity_is_task(se));
 
-		/* Skip over entities that are not tasks */
-		if (entity_is_task(se)) {
-			p = task_of(se);
-			break;
-		}
-	}
+	if (next == &cfs_rq->tasks)
+		return NULL;
 
 	cfs_rq->balance_iterator = next;
+
+	if (entity_is_task(se))
+		p = task_of(se);
+
 	return p;
 }
 
