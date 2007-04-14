Return-Path: <linux-kernel-owner+w=401wt.eu-S1030801AbXDNGdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030801AbXDNGdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 02:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965407AbXDNGdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 02:33:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52544 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965356AbXDNGdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 02:33:09 -0400
Date: Sat, 14 Apr 2007 08:32:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414063254.GB14875@elte.hu>
References: <20070413202100.GA9957@elte.hu> <20070414020424.GB14544@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070414020424.GB14544@wotan.suse.de>
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


* Nick Piggin <npiggin@suse.de> wrote:

> >    The CFS patch uses a completely different approach and implementation
> >    from RSDL/SD. My goal was to make CFS's interactivity quality exceed
> >    that of RSDL/SD, which is a high standard to meet :-) Testing
> >    feedback is welcome to decide this one way or another. [ and, in any
> >    case, all of SD's logic could be added via a kernel/sched_sd.c module
> >    as well, if Con is interested in such an approach. ]
> 
> Comment about the code: shouldn't you be requeueing the task in the 
> rbtree wherever you change wait_runtime? eg. task_new_fair? [...]

yes: the task's position within the rbtree is updated every time 
wherever wait_runtime is change. task_new_fair is the method during new 
task creation, but indeed i forgot to requeue the parent. I've fixed 
this in my tree (see the delta patch below) - thanks!

	Ingo

----------->
From: Ingo Molnar <mingo@elte.hu>
Subject: [cfs] fix parent's rbtree position

Nick noticed that upon fork we change parent->wait_runtime but we do not 
requeue it within the rbtree.

Signed-off-by: Ingo Molnar <mingo@elte.hu>

Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -524,6 +524,8 @@ static void task_new_fair(struct rq *rq,
 
 	p->wait_runtime = parent->wait_runtime/2;
 	parent->wait_runtime /= 2;
+	requeue_task_fair(rq, parent);
+
 	/*
 	 * For the first timeslice we allow child threads
 	 * to move their parent-inherited fairness back
