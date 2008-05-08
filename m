Return-Path: <linux-kernel-owner+w=401wt.eu-S1761963AbYEHJ0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761963AbYEHJ0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 05:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757086AbYEHJ0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 05:26:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41009 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912AbYEHJ0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 05:26:00 -0400
Date: Thu, 8 May 2008 11:25:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
Message-ID: <20080508092547.GA32574@elte.hu>
References: <1210136148.3453.59.camel@ymzhang> <1210177575.6525.4.camel@lappy.programming.kicks-ass.net> <1210228531.3453.124.camel@ymzhang> <1210233617.4895.6.camel@marge.simson.net> <20080508084607.GA31515@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508084607.GA31515@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> -	down(&kernel_sem);
> +	if (panic_timeout) {
> +		while (down_trylock(&kernel_sem))
> +			cpu_relax();

updated one below - this will work fine in the !panic_timeout case too 
;-)

	Ingo

Index: linux/lib/kernel_lock.c
===================================================================
--- linux.orig/lib/kernel_lock.c
+++ linux/lib/kernel_lock.c
@@ -46,7 +46,12 @@ int __lockfunc __reacquire_kernel_lock(v
 	task->lock_depth = -1;
 	preempt_enable_no_resched();
 
-	down(&kernel_sem);
+	if (panic_timeout) {
+		while (down_trylock(&kernel_sem))
+			cpu_relax();
+	} else {
+		down(&kernel_sem);
+	}
 
 	preempt_disable();
 	task->lock_depth = saved_lock_depth;
@@ -67,11 +72,17 @@ void __lockfunc lock_kernel(void)
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
+		} else {
+			down(&kernel_sem);
+		}
+	}
 
 	task->lock_depth = depth;
 }
