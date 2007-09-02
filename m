Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbXIBPQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbXIBPQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 11:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756392AbXIBPQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 11:16:01 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4390 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360AbXIBPQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 11:16:00 -0400
Date: Sun, 2 Sep 2007 17:16:23 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       peterz@infradead.org
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
In-Reply-To: <20070902072029.GA24427@elte.hu>
Message-ID: <Pine.LNX.4.64.0709021655340.1817@scrub.home>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
 <1188694367.11196.42.camel@dhcp193.mvista.com> <20070902072029.GA24427@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2 Sep 2007, Ingo Molnar wrote:

> And if you look at the resulting code size/complexity, it actually 
> increases with Roman's patch (UP, nodebug, x86):
> 
>      text    data     bss     dec     hex filename
>     13420     228    1204   14852    3a04 sched.o.rc5
>     13554     228    1228   15010    3aa2 sched.o.rc5-roman

That's pretty easy to explain due to differences in inlining:

   text    data     bss     dec     hex filename
  15092     228    1204   16524    408c kernel/sched.o
  15444     224    1228   16896    4200 kernel/sched.o.rfs
  14708     224    1228   16160    3f20 kernel/sched.o.rfs.noinline

Sorry, but I didn't spend as much time as you on tuning these numbers.

Index: linux-2.6/kernel/sched_norm.c
===================================================================
--- linux-2.6.orig/kernel/sched_norm.c	2007-09-02 16:58:05.000000000 +0200
+++ linux-2.6/kernel/sched_norm.c	2007-09-02 16:10:58.000000000 +0200
@@ -145,7 +145,7 @@ static inline struct task_struct *task_o
 /*
  * Enqueue an entity into the rb-tree:
  */
-static inline void
+static void
 __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
@@ -192,7 +192,7 @@ __enqueue_entity(struct cfs_rq *cfs_rq, 
 	se->queued = 1;
 }
 
-static inline void
+static void
 __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	if (cfs_rq->rb_leftmost == se) {
@@ -240,7 +240,7 @@ static void verify_queue(struct cfs_rq *
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
  */
-static inline void update_curr(struct cfs_rq *cfs_rq)
+static void update_curr(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *curr = cfs_rq->curr;
 	kclock_t now = rq_of(cfs_rq)->clock;

> Although it _should_ have been a net code size win, because if you look 
> at the diff you'll see that other useful things were removed as well: 
> sleeper fairness, CPU time distribution smarts, tunings, scheduler 
> instrumentation code, etc.

Well, these are things I'd like you to explain a little, for example I 
repeatedly asked you about the sleeper fairness and I got no answer.
BTW you seemed to haved missed that I actually give a bonus to sleepers 
as well.

> > I also ran hackbench (in a haphazard way) a few times on it vs. CFS in 
> > my tree, and RFS was faster to some degree (it varied)..
> 
> here are some actual numbers for "hackbench 50" on -rc5, 10 consecutive 
> runs fresh after bootup, Core2Duo, UP:
> 
>            -rc5(cfs)           -rc5+rfs
>           -------------------------------
>           Time: 3.905         Time: 4.259
>           Time: 3.962         Time: 4.190
>           Time: 3.981         Time: 4.241
>           Time: 3.986         Time: 3.937
>           Time: 3.984         Time: 4.120
>           Time: 4.001         Time: 4.013
>           Time: 3.980         Time: 4.248
>           Time: 3.983         Time: 3.961
>           Time: 3.989         Time: 4.345
>           Time: 3.981         Time: 4.294
>           -------------------------------
>            Avg: 3.975          Avg: 4.160 (+4.6%)
>          Fluct: 0.138        Fluct: 1.671
> 
> so unmodified CFS is 4.6% faster on this box than with Roman's patch and 
> it's also more consistent/stable (10 times lower fluctuations).

Was SCHED_DEBUG enabled or disabled for these runs?

bye, Roman
