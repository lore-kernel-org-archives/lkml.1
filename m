Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbXLDQJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbXLDQJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbXLDQJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:09:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38633 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbXLDQJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:09:01 -0500
Date: Tue, 4 Dec 2007 17:08:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       herton@mandriva.com.br, dvgevers@xs4all.nl
Subject: Re: [local DoS] Re: Linux 2.6.24-rc4
Message-ID: <20071204160842.GA31501@elte.hu>
References: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org> <20071204120715.4ea204a8@mandriva.com.br> <alpine.LFD.0.9999.0712040751170.2981@woody.linux-foundation.org> <20071204160005.GA29783@elte.hu> <20071204140425.05b0b458@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204140425.05b0b458@mandriva.com.br>
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


* Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br> wrote:

> | The problem is on SMP: if sched_rr_get_interval() gets a task from 
> | an otherwise idle runqueue, then rq->load.weight is 0. Normally 
> | sched_slice() is only used on a busy runqueue. So the correct fixup 
> | site is not in sched_slice() but in sys_sched_rr_get_interval() - 
> | i'm working on the right fix, i hope to be able to send a pull 
> | request in a few minutes.
> 
>  Ingo, I can reproduce this w/o SMP support as well.

hm, if you run this as an RT task, right? Or can you trigger it via pure 
SCHED_OTHER tasks as well? Below is my candidate fix.

	Ingo

--------------->
Subject: sched: fix crash in sys_sched_rr_get_interval()
From: Ingo Molnar <mingo@elte.hu>

Luiz Fernando N. Capitulino reported that sched_rr_get_interval()
crashes for SCHED_OTHER tasks that are on an idle runqueue.

The fix is to return a 0 timeslice for tasks that are on an idle
runqueue. (and which are not running, obviously)

Reported-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -4850,17 +4850,21 @@ long sys_sched_rr_get_interval(pid_t pid
 	if (retval)
 		goto out_unlock;
 
-	if (p->policy == SCHED_FIFO)
-		time_slice = 0;
-	else if (p->policy == SCHED_RR)
+	/*
+	 * Time slice is 0 for SCHED_FIFO tasks and for SCHED_OTHER
+	 * tasks that are on an otherwise idle runqueue:
+	 */
+	time_slice = 0;
+	if (p->policy == SCHED_RR) {
 		time_slice = DEF_TIMESLICE;
-	else {
+	} else {
 		struct sched_entity *se = &p->se;
 		unsigned long flags;
 		struct rq *rq;
 
 		rq = task_rq_lock(p, &flags);
-		time_slice = NS_TO_JIFFIES(sched_slice(cfs_rq_of(se), se));
+		if (rq->cfs.load.weight)
+			time_slice = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
 		task_rq_unlock(rq, &flags);
 	}
 	read_unlock(&tasklist_lock);
