Return-Path: <linux-kernel-owner+w=401wt.eu-S1760773AbYEHIqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbYEHIqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYEHIqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:46:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56037 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbYEHIqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:46:19 -0400
Date: Thu, 8 May 2008 10:46:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
Message-ID: <20080508084607.GA31515@elte.hu>
References: <1210136148.3453.59.camel@ymzhang> <1210177575.6525.4.camel@lappy.programming.kicks-ass.net> <1210228531.3453.124.camel@ymzhang> <1210233617.4895.6.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210233617.4895.6.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> > With the patch, oltp testing result is about 50% worse than the one 
> > of pure 2.6.26-rc1.
> 
> Hm.  I was doing some sysbench+postgress(oltp, ro) testing on my 
> little Q6600 box this morning, and saw a different picture.
> 
> In attached pdf, .bkl refers to Linus' BKL patch, .weight is the 
> weight fix, both are applied to git.today.  The script I used is also 
> attached.

nice numbers. I'm curious about the following detail related to Linus's 
BKL-spinlock patch: am i correct that it shows a small but systematic 
improvement with many clients? sysbench has not shown sensitivity to any 
BKL detail before.

Could you perhaps try the hack below that uses /proc/sys/kernel/panic as 
a flag whether the BKL should cause us to block or should be spun upon.

Can you confirm that with that patch too sysbench shows sensitivity to 
the value of the panic flag? [this is the surest way to measure such 
effects as flipping the sysctl only minimally impacts the system.]

if sysbench truly is dependent on the BKL then that's another argument 
in favor of Linus's patch.

	Ingo

-------------------------->
Subject: BKL: spin on acquire
From: Ingo Molnar <mingo@elte.hu>
Date: Wed May 07 19:05:40 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/kernel_lock.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: linux/lib/kernel_lock.c
===================================================================
--- linux.orig/lib/kernel_lock.c
+++ linux/lib/kernel_lock.c
@@ -46,7 +46,10 @@ int __lockfunc __reacquire_kernel_lock(v
 	task->lock_depth = -1;
 	preempt_enable_no_resched();
 
-	down(&kernel_sem);
+	if (panic_timeout) {
+		while (down_trylock(&kernel_sem))
+			cpu_relax();
+	}
 
 	preempt_disable();
 	task->lock_depth = saved_lock_depth;
@@ -67,11 +70,15 @@ void __lockfunc lock_kernel(void)
 	struct task_struct *task = current;
 	int depth = task->lock_depth + 1;
 
-	if (likely(!depth))
+	if (likely(!depth)) {
 		/*
 		 * No recursion worries - we set up lock_depth _after_
 		 */
-		down(&kernel_sem);
+		if (panic_timeout) {
+			while (down_trylock(&kernel_sem))
+				cpu_relax();
+		}
+	}
 
 	task->lock_depth = depth;
 }
