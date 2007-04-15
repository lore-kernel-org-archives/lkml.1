Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbXDOTVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbXDOTVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 15:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbXDOTVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 15:21:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48331 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbXDOTVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 15:21:11 -0400
Date: Sun, 15 Apr 2007 21:20:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415192046.GA7504@elte.hu>
References: <20070414130101.GA2538@1wt.eu> <20070414132732.GA22103@1wt.eu> <20070414161927.GD3099@elte.hu> <m1abxanahn.fsf@ebiederm.dsl.xmission.com> <20070414172920.GA2433@1wt.eu> <m1647yn956.fsf@ebiederm.dsl.xmission.com> <20070414175433.GA17527@elte.hu> <20070414181854.GA5826@1wt.eu> <20070415175555.GA28524@elte.hu> <20070415180604.GA550@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415180604.GA550@1wt.eu>
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


* Willy Tarreau <w@1wt.eu> wrote:

> > to debug this, could you try to apply this add-on as well:
> > 
> >   http://redhat.com/~mingo/cfs-scheduler/sched-fair-print.patch
> > 
> > with this patch applied you should have a /proc/sched_debug file 
> > that prints all runnable tasks and other interesting info from the 
> > runqueue.
> 
> I don't know if you have seen my mail from yesterday evening (here). I 
> found that changing keventd prio fixed the problem. You may be 
> interested in the description. I sent it at 21:01 (+200).

ah, indeed i missed that mail - the response to the patches was quite 
overwhelming (and i naively thought people dont do Linux hacking over 
the weekends anymore ;).

so Linus was right: this was caused by scheduler starvation. I can see 
one immediate problem already: the 'nice offset' is not divided by 
nr_running as it should. The patch below should fix this but i have yet 
to test it accurately, this change might as well render nice levels 
unacceptably ineffective under high loads.

	Ingo

--------->
---
 kernel/sched_fair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -31,7 +31,9 @@ static void __enqueue_task_fair(struct r
 	int leftmost = 1;
 	long long key;
 
-	key = rq->fair_clock - p->wait_runtime + p->nice_offset;
+	key = rq->fair_clock - p->wait_runtime;
+	if (unlikely(p->nice_offset))
+		key += p->nice_offset / rq->nr_running;
 
 	p->fair_key = key;
 
