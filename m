Return-Path: <linux-kernel-owner+w=401wt.eu-S1031153AbXDSG37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031153AbXDSG37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 02:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031155AbXDSG37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 02:29:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48680 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031153AbXDSG36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 02:29:58 -0400
Date: Thu, 19 Apr 2007 08:29:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bob Picco <bob.picco@hp.com>
Cc: Christian Hesse <mail@earthworm.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, suspend2-devel@lists.suspend2.net
Subject: Re: CFS and suspend2: hang in atomic copy
Message-ID: <20070419062936.GE18894@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <20070418225652.GC10564@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418225652.GC10564@localhost>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bob Picco <bob.picco@hp.com> wrote:

> I had hoped to collect more data with CFS V2. It crashes in 
> scale_nice_down for s2ram when attempting to disable_nonboot_cpus. So 
> part of traceback looks like (typed by hand with obvious omissions):
> 
> scale_nice_down
> update_stats_wait_end - not shown in traceback because inlined
> pick_next_task_fair
> migration_call
> task_rq_lock
> notifier_call_chain
> _cpu_down
> disable_nonboot_cpus

ok, this looks similar to the jpeg Christian did. Does the patch below 
fix the crash for you?

	Ingo

---
 kernel/sched.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -4425,6 +4425,8 @@ static void migrate_dead_tasks(unsigned 
 	struct task_struct *next;
 
 	for (;;) {
+		if (!rq->nr_running)
+			break;
 		next = pick_next_task(rq, rq->curr);
 		if (!next)
 			break;
