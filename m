Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbYEHGom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbYEHGom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 02:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756389AbYEHGoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 02:44:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34849 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757127AbYEHGoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 02:44:05 -0400
Date: Thu, 8 May 2008 08:43:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080508064340.GA27452@elte.hu>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang> <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210214696.3453.87.camel@ymzhang>
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


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> > Here's a trial balloon patch to do that.
> > 
> > Yanmin - this is not well tested, but the code is fairly obvious, 
> > and it would be interesting to hear if this fixes the performance 
> > regression. Because if it doesn't, then it's not the BKL, or 
> > something totally different is going on.
>
> Congratulations! The patch really fixes the regression completely! 
> vmstat showed cpu idle is 0%, just like 2.6.25's.

great! Yanmin, could you please also check the other patch i sent (also 
attached below), does it solve the regression similarly?

	Ingo

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
