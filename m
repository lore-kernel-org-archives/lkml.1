Return-Path: <linux-kernel-owner+w=401wt.eu-S934438AbXHYTCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934438AbXHYTCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 15:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761258AbXHYTBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 15:01:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59141 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759010AbXHYTBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 15:01:49 -0400
Date: Sat, 25 Aug 2007 21:01:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Rodriguez <livuxman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem with CFS V20 and Suspend2/tuxonice
Message-ID: <20070825190142.GA15888@elte.hu>
References: <1946b54f0708250423k75d5797fuc5b032be7e143f26@mail.gmail.com> <1946b54f0708250429y570a1620y2796d0ff8abb02eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1946b54f0708250429y570a1620y2796d0ff8abb02eb@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4489]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rodriguez <livuxman@gmail.com> wrote:

> I'm using 2.6.22.5 with cfs v20.3 and suspend2 2.2.10.2. With that 
> combination, suspend is not working anymore (with cfs v19 was 
> working). Stops on suspend in "Suspending tasks" Looking at cfs patch, 
> I managed to change the migration_thread, adding again the 
> try_to_freeze() removed in last patch and now the suspend finished, 
> but resume not work. Of course I don't know why that was removed, and 
> rewriting it is not a solution, but I want to report it.

could you try the patch below, does it fix this problem?

	Ingo

Index: linux-cfs-2.6.22.5.q/kernel/sched.c
===================================================================
--- linux-cfs-2.6.22.5.q.orig/kernel/sched.c
+++ linux-cfs-2.6.22.5.q/kernel/sched.c
@@ -5043,6 +5043,8 @@ static int migration_thread(void *data)
 		struct migration_req *req;
 		struct list_head *head;
 
+		try_to_freeze();
+
 		spin_lock_irq(&rq->lock);
 
 		if (cpu_is_offline(cpu)) {
@@ -5399,6 +5401,7 @@ migration_call(struct notifier_block *nf
 		p = kthread_create(migration_thread, hcpu, "migration/%d", cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
+		p->flags |= PF_NOFREEZE;
 		kthread_bind(p, cpu);
 		/* Must be high prio: stop_machine expects to yield to it. */
 		rq = task_rq_lock(p, &flags);
