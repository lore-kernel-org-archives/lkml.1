Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbXDOTiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbXDOTiP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 15:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbXDOTiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 15:38:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51739 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbXDOTiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 15:38:14 -0400
Date: Sun, 15 Apr 2007 21:37:47 +0200
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
Message-ID: <20070415193747.GA11257@elte.hu>
References: <20070414132732.GA22103@1wt.eu> <20070414161927.GD3099@elte.hu> <m1abxanahn.fsf@ebiederm.dsl.xmission.com> <20070414172920.GA2433@1wt.eu> <m1647yn956.fsf@ebiederm.dsl.xmission.com> <20070414175433.GA17527@elte.hu> <20070414181854.GA5826@1wt.eu> <20070415175555.GA28524@elte.hu> <20070415180604.GA550@1wt.eu> <20070415192046.GA7504@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415192046.GA7504@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> so Linus was right: this was caused by scheduler starvation. I can see 
> one immediate problem already: the 'nice offset' is not divided by 
> nr_running as it should. The patch below should fix this but i have 
> yet to test it accurately, this change might as well render nice 
> levels unacceptably ineffective under high loads.

erm, rather the updated patch below if you want to use this on a 32-bit 
system. But ... i think you should wait until i have all this re-tested.

	Ingo

---
 include/linux/sched.h |    2 +-
 kernel/sched_fair.c   |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -839,7 +839,7 @@ struct task_struct {
 
 	s64 wait_runtime;
 	u64 exec_runtime, fair_key;
-	s64 nice_offset, hog_limit;
+	s32 nice_offset, hog_limit;
 
 	unsigned long policy;
 	cpumask_t cpus_allowed;
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
+		key += p->nice_offset / (rq->nr_running + 1);
 
 	p->fair_key = key;
 
