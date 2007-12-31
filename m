Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbXLaJ2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbXLaJ2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 04:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbXLaJ16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 04:27:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33874 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbXLaJ15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 04:27:57 -0500
Date: Mon, 31 Dec 2007 10:27:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC/PATCH 0/3] sched: hrtick and rt group scheduling
Message-ID: <20071231092738.GA30380@elte.hu>
References: <20071231001137.147986000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071231001137.147986000@chello.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> I spend xmas implementing group scheduling for the realtime scheduling 
> classes. Its a tad raw, but seems to work for the trivial test cases I 
> threw at it.
> 
> The hrtick stuff is unrelated but was still stuck in my sched queue.

thanks Peter, this is really cool stuff! I have picked up all 3 patches 
into sched-devel.git - let's see how they work out.

(btw., i had to do the fixes below. Are you sure you sent the right 
version of the patches?)

	Ingo

Index: linux/kernel/sched_rt.c
===================================================================
--- linux.orig/kernel/sched_rt.c
+++ linux/kernel/sched_rt.c
@@ -337,7 +337,6 @@ static void dequeue_rt_entity(struct sch
 {
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	struct rt_prio_array *array = &rt_rq->active;
-	struct rt_rq *group_rq = group_rt_rq(rt_se);
 
 	list_del_init(&rt_se->run_list);
 	if (list_empty(array->queue + rt_se_prio(rt_se)))
@@ -527,10 +526,8 @@ static struct task_struct *pick_next_tas
 
 	do {
 		rt_se = pick_next_rt_entity(rq, rt_rq);
-		if (unlikely(!rt_se)) {
-			foo = 1;
+		if (unlikely(!rt_se))
 			goto retry;
-		}
 		rt_rq = group_rt_rq(rt_se);
 	} while (rt_rq);
 
