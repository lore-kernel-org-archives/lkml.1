Return-Path: <linux-kernel-owner+w=401wt.eu-S1752820AbXDQI1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752820AbXDQI1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbXDQI1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:27:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60345 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752820AbXDQI1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:27:05 -0400
Date: Tue, 17 Apr 2007 10:26:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Gene Heskett <gene.heskett@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Message-ID: <20070417082628.GD5076@elte.hu>
References: <20070416220715.GA4071@elte.hu> <200704170053.58611.gene.heskett@gmail.com> <20070417061849.GA12385@elte.hu> <Pine.LNX.4.64.0704170053410.30516@alien.or.mcafeemobile.com> <20070417081857.GD20026@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417081857.GD20026@wotan.suse.de>
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


* Nick Piggin <npiggin@suse.de> wrote:

> Actually I think this is something that makes sense to add, even if 
> just for debugging, but maybe also for production, depending on how 
> much it impacts things. Child runs first is an heuristic optimisation 
> that exploits a VM detail (however fundamental). But for things that 
> don't exec right after forking (and maybe some things that do), it can 
> be nicer to reduce context switches, improve cache patterns, and allow 
> children to be load balanced away before touching memory, if 
> child_runs_first is turned off.

yeah, the primary intent was debug. Nick, am i confused to conclude that 
mainline in fact runs the _parent_ first, despite all the elaborate 
runqueue juggling we do there? This piece of code in wake_up_new_task() 
caught my eyes:

                                p->prio = current->prio;
                                p->normal_prio = current->normal_prio;
                                list_add_tail(&p->run_list, &current->run_list);
                                p->array = current->array;
                                p->array->nr_active++;
                                inc_nr_running(p, rq);

shouldnt the list_add_tail() be list_add(), so that task pickup sees the 
child first? Maybe we still do child-runs-first in practice, due to the 
timeslice and sleep average fixups that happen if the parent preempts, 
but the above piece of code seems a quite elaborate way of doing 
activate_task(). To have the child _before_ the parent we'd need the 
add-on patch below. But ... i could be wrong, this is just a quick 
thought.

	Ingo

---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -1685,7 +1685,7 @@ void fastcall wake_up_new_task(struct ta
 			else {
 				p->prio = current->prio;
 				p->normal_prio = current->normal_prio;
-				list_add_tail(&p->run_list, &current->run_list);
+				list_add(&p->run_list, &current->run_list);
 				p->array = current->array;
 				p->array->nr_active++;
 				inc_nr_running(p, rq);
