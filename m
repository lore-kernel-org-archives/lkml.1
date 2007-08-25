Return-Path: <linux-kernel-owner+w=401wt.eu-S934501AbXHYTCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501AbXHYTCv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 15:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965008AbXHYTCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 15:02:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46268 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964980AbXHYTCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 15:02:30 -0400
Date: Sat, 25 Aug 2007 21:02:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthias Hensler <matthias@wspse.de>
Cc: Christian Hesse <mail@earthworm.de>, suspend2-devel@lists.tuxonice.net,
       Suspend2-users@lists.suspend2.net, linux-kernel@vger.kernel.org,
       suspend2-devel <suspend2-devel@lists.suspend2.net>,
       David Rodriguez <livuxman@gmail.com>
Subject: Re: [Suspend2-devel] Problem with CFS V20 and Suspend2/tuxonice
Message-ID: <20070825190223.GC15888@elte.hu>
References: <1946b54f0708250423k75d5797fuc5b032be7e143f26@mail.gmail.com> <1946b54f0708250429y570a1620y2796d0ff8abb02eb@mail.gmail.com> <b637ec0b0708250554m35decdb3ic8db88787fc3c0c9@mail.gmail.com> <200708251852.28698.mail@earthworm.de> <20070825184917.GA7945@kobayashi-maru.wspse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070825184917.GA7945@kobayashi-maru.wspse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthias Hensler <matthias@wspse.de> wrote:

> > Same problem here: Core Duo, Kernel 2.6.22.5, Suspend 2.2.10, CFS 
> > v20.2.
> 
> Me too for 2.6.22.5, TuxOnIce 2.2.10 and Centrino based notebook.

possible bugfix below.

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

