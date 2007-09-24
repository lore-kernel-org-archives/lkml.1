Return-Path: <linux-kernel-owner+w=401wt.eu-S1761269AbXIXWYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761269AbXIXWYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760528AbXIXWYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:24:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35265 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760323AbXIXWYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:24:21 -0400
Date: Tue, 25 Sep 2007 00:24:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: 2.6.23-rc7-mm1:  panic in scheduler
Message-ID: <20070924222409.GA28997@elte.hu>
References: <1190668373.5030.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190668373.5030.10.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> Taking a quick look at [__]{en|de|queue_entity() and the functions 
> they call, I see something suspicious in set_leftmost() in 
> sched_fair.c:
> 
> static inline void
> set_leftmost(struct cfs_rq *cfs_rq, struct rb_node *leftmost)
> {
>         struct sched_entity *se;
> 
>         cfs_rq->rb_leftmost = leftmost;
>         if (leftmost)
>                 se = rb_entry(leftmost, struct sched_entity, run_node);
> }
> 
> Missing code?  corrupt patch?

could you pull this git tree ontop of a -rc7 (or later) upstream tree:

  git-pull git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git

does the solve the crash?

the above set_leftmost() code used to be larger and now indeed those 
bits are mostly dead code. I've queued up a clean-up patch for that - 
see the patch below. It should not impact correctness though, so if you 
can still trigger the crash with the latest sched-devel.git tree we'd 
like to know about it.

	Ingo

------------------->
Subject: sched: remove set_leftmost()
From: Ingo Molnar <mingo@elte.hu>

Lee Schermerhorn noticed that set_leftmost() contains dead code,
remove this.

Reported-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -124,16 +124,6 @@ max_vruntime(u64 min_vruntime, u64 vrunt
 	return min_vruntime;
 }
 
-static inline void
-set_leftmost(struct cfs_rq *cfs_rq, struct rb_node *leftmost)
-{
-	struct sched_entity *se;
-
-	cfs_rq->rb_leftmost = leftmost;
-	if (leftmost)
-		se = rb_entry(leftmost, struct sched_entity, run_node);
-}
-
 static inline s64
 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
@@ -175,7 +165,7 @@ __enqueue_entity(struct cfs_rq *cfs_rq, 
 	 * used):
 	 */
 	if (leftmost)
-		set_leftmost(cfs_rq, &se->run_node);
+		cfs_rq->rb_leftmost = &se->run_node;
 
 	rb_link_node(&se->run_node, parent, link);
 	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
@@ -185,7 +175,7 @@ static void
 __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	if (cfs_rq->rb_leftmost == &se->run_node)
-		set_leftmost(cfs_rq, rb_next(&se->run_node));
+		cfs_rq->rb_leftmost = rb_next(&se->run_node);
 
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
 }
