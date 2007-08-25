Return-Path: <linux-kernel-owner+w=401wt.eu-S964990AbXHYTCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964990AbXHYTCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 15:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934151AbXHYTCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 15:02:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59202 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934366AbXHYTCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 15:02:15 -0400
Date: Sat, 25 Aug 2007 21:02:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Hesse <mail@earthworm.de>
Cc: suspend2-devel@lists.tuxonice.net, Fabio Comolli <fabio.comolli@gmail.com>,
       linux-kernel@vger.kernel.org, Suspend2-users@lists.suspend2.net,
       suspend2-devel <suspend2-devel@lists.suspend2.net>,
       David Rodriguez <livuxman@gmail.com>
Subject: Re: [Suspend2-devel] Problem with CFS V20 and Suspend2/tuxonice
Message-ID: <20070825190205.GB15888@elte.hu>
References: <1946b54f0708250423k75d5797fuc5b032be7e143f26@mail.gmail.com> <1946b54f0708250429y570a1620y2796d0ff8abb02eb@mail.gmail.com> <b637ec0b0708250554m35decdb3ic8db88787fc3c0c9@mail.gmail.com> <200708251852.28698.mail@earthworm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708251852.28698.mail@earthworm.de>
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


* Christian Hesse <mail@earthworm.de> wrote:

> > Reproduced on a Intel Centrino based laptop with gentoo kamikaze7
> > sources (http://forums.gentoo.org/viewtopic-t-577970.html)
> 
> Same problem here: Core Duo, Kernel 2.6.22.5, Suspend 2.2.10, CFS v20.2.

please try the patch below - does it fix the problem?

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
