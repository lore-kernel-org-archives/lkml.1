Return-Path: <linux-kernel-owner+w=401wt.eu-S1762349AbXJQOW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762349AbXJQOW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 10:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbXJQOWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 10:22:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33270 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbXJQOWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 10:22:19 -0400
Date: Wed, 17 Oct 2007 16:21:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.23-git8 kernel oops at __rb_rotate_left+0x7/0x70
Message-ID: <20071017142140.GA8634@elte.hu>
References: <47144B4F.3050108@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47144B4F.3050108@linux.vnet.ibm.com>
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


* Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> While running kernbench with the 2.6.23-git8 following oops is 
> produced

Dmitry found something that might explain the crash: could you check 
whether the patch below fixes it?

	Ingo

---------------------->
Subject: sched: fix new task startup crash
From: Ingo Molnar <mingo@elte.hu>

this should fix the put_prev_task crashes that were reported,
Dmitry Adamushko noticed that it's not valid to call into
task_new_fair() if this_cpu != task_cpu(p).

Reported-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Reported-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -1712,7 +1712,8 @@ void fastcall wake_up_new_task(struct ta
 
 	p->prio = effective_prio(p);
 
-	if (!p->sched_class->task_new || !current->se.on_rq || !rq->cfs.curr) {
+	if (!p->sched_class->task_new || smp_processor_id() != task_cpu(p) ||
+			!current->se.on_rq || !rq->cfs.curr) {
 		activate_task(rq, p, 0);
 	} else {
 		/*
