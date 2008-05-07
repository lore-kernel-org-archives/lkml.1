Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbYEGRPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbYEGRPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYEGRPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:15:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43438 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbYEGRO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:14:59 -0400
Date: Wed, 7 May 2008 19:14:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507171443.GA12072@elte.hu>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang> <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > But my preferred option would indeed be just turning it back into a 
> > spinlock - and screw latency and BKL preemption - and having the RT 
> > people who care deeply just work on removing the BKL in the long 
> > run.
> 
> Here's a trial balloon patch to do that.

here's a simpler trial baloon test-patch (well, hack) that is also 
reasonably well tested. It turns the BKL into a "spin-semaphore". If 
this resolves the performance problem then it's all due to the BKL's 
scheduling/preemption properties.

this approach is ugly (it's just a more expensive spinlock), but has an 
advantage: the code logic is obviously correct, and it would also make 
it much easier later on to turn the BKL back into a sleeping lock again 
- once the TTY code's BKL use is fixed. (i think Alan said it might 
happen in the next few months) The BKL is more expensive than a simple 
spinlock anyway.

	Ingo

------------->
Subject: BKL: spin on acquire
From: Ingo Molnar <mingo@elte.hu>
Date: Wed May 07 19:05:40 CEST 2008

NOT-Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/kernel_lock.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux/lib/kernel_lock.c
===================================================================
--- linux.orig/lib/kernel_lock.c
+++ linux/lib/kernel_lock.c
@@ -46,7 +46,8 @@ int __lockfunc __reacquire_kernel_lock(v
 	task->lock_depth = -1;
 	preempt_enable_no_resched();
 
-	down(&kernel_sem);
+	while (down_trylock(&kernel_sem))
+		cpu_relax();
 
 	preempt_disable();
 	task->lock_depth = saved_lock_depth;
@@ -67,11 +68,13 @@ void __lockfunc lock_kernel(void)
 	struct task_struct *task = current;
 	int depth = task->lock_depth + 1;
 
-	if (likely(!depth))
+	if (likely(!depth)) {
 		/*
 		 * No recursion worries - we set up lock_depth _after_
 		 */
-		down(&kernel_sem);
+		while (down_trylock(&kernel_sem))
+			cpu_relax();
+	}
 
 	task->lock_depth = depth;
 }
