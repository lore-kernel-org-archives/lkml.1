Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbXDRPsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbXDRPsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 11:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbXDRPsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 11:48:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34004 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbXDRPsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 11:48:22 -0400
Date: Wed, 18 Apr 2007 17:48:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: Christoph Pfister <christophpfister@gmail.com>,
       linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Christophe Thommeret <hftom@free.fr>, Jurgen Kofler <kaffeine@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: Kaffeine problem with CFS
Message-ID: <20070418154811.GA16842@elte.hu>
References: <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com> <19a3b7a80704180555q4e0b26d5x54bbf34b4cd9d33e@mail.gmail.com> <19a3b7a80704180621m1b343b4eif02a7930a5edf2fc@mail.gmail.com> <200704181625.51389.caglar@pardus.org.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704181625.51389.caglar@pardus.org.tr>
User-Agent: Mutt/1.4.2.2i
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


* S.Çağlar Onur <caglar@pardus.org.tr> wrote:

> -       schedule();
> +       msleep(1);

> which Ingo sends me to try also has the same effect on me. I cannot 
> reproduce hangs anymore with that patch applied top of CFS while one 
> console checks out SVN repos and other one compiles a small test 
> software.

great! Could you please unapply the hack above and try the proper fix 
below, does this one solve the hangs too?

	Ingo

Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -264,15 +264,26 @@ static void dequeue_task_fair(struct rq 
 
 /*
  * sched_yield() support is very simple via the rbtree, we just
- * dequeue and enqueue the task, which causes the task to
- * roundrobin to the end of the tree:
+ * dequeue the task and move it to the rightmost position, which
+ * causes the task to roundrobin to the end of the tree.
  */
 static void requeue_task_fair(struct rq *rq, struct task_struct *p)
 {
 	dequeue_task_fair(rq, p);
 	p->on_rq = 0;
-	enqueue_task_fair(rq, p);
+	/*
+	 * Temporarily insert at the last position of the tree:
+	 */
+	p->fair_key = LLONG_MAX;
+	__enqueue_task_fair(rq, p);
 	p->on_rq = 1;
+
+	/*
+	 * Update the key to the real value, so that when all other
+	 * tasks from before the rightmost position have executed,
+	 * this task is picked up again:
+	 */
+	p->fair_key = rq->fair_clock - p->wait_runtime + p->nice_offset;
 }
 
 /*
@@ -380,7 +391,10 @@ static void task_tick_fair(struct rq *rq
 	 * Dequeue and enqueue the task to update its
 	 * position within the tree:
 	 */
-	requeue_task_fair(rq, curr);
+	dequeue_task_fair(rq, curr);
+	curr->on_rq = 0;
+	enqueue_task_fair(rq, curr);
+	curr->on_rq = 1;
 
 	/*
 	 * Reschedule if another task tops the current one.
