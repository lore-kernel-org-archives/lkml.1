Return-Path: <linux-kernel-owner+w=401wt.eu-S1765896AbYEGSnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765896AbYEGSnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760260AbYEGSnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:43:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51280 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760053AbYEGSnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:43:18 -0400
Date: Wed, 7 May 2008 20:43:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507184304.GA15554@elte.hu>
References: <20080506102153.5484c6ac.akpm@linux-foundation.org> <20080507163811.GY19219@parisc-linux.org> <alpine.LFD.1.10.0805070948250.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805070956060.3024@woody.linux-foundation.org> <20080507172246.GA13262@elte.hu> <alpine.LFD.1.10.0805071028400.3024@woody.linux-foundation.org> <20080507174900.GB13591@elte.hu> <alpine.LFD.1.10.0805071057280.3024@woody.linux-foundation.org> <20080507181714.GA14980@elte.hu> <alpine.LFD.1.10.0805071125090.3024@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805071125090.3024@woody.linux-foundation.org>
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

> > [ this patch should in fact be a bit worse, because there's two more
> >   atomics in the fastpath - the fastpath atomics of the old 
> >   semaphore code. ]
> 
> Well, it doesn't have the irq stuff, which is also pretty costly. 
> Also, it doesn't nest the accesses the same way (with the counts being 
> *inside* the spinlock and serialized against each other), so I'm not 
> 100% sure you'd get the same behaviour.
> 
> But yes, it certainly has the potential to show the same slowdown. But 
> it's not a very good patch, since not showing it doesn't really prove 
> much.

ok, the one below does irq ops and the counter behavior - and because 
the critical section also has the old-semaphore atomics i think this 
should definitely be a more expensive fastpath than what the new generic 
code introduces. So if this patch produces a 40% AIM7 slowdown on 
v2.6.25 it's the fastpath overhead (and its effects on slowpath 
probability) that makes the difference.

	Ingo

------------------->
Subject: add BKL atomic overhead
From: Ingo Molnar <mingo@elte.hu>
Date: Wed May 07 20:09:13 CEST 2008

NOT-Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/kernel_lock.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

Index: linux-2.6.25/lib/kernel_lock.c
===================================================================
--- linux-2.6.25.orig/lib/kernel_lock.c
+++ linux-2.6.25/lib/kernel_lock.c
@@ -24,6 +24,8 @@
  * Don't use in new code.
  */
 static DECLARE_MUTEX(kernel_sem);
+static int global_count;
+static DEFINE_SPINLOCK(global_lock);
 
 /*
  * Re-acquire the kernel semaphore.
@@ -39,6 +41,7 @@ int __lockfunc __reacquire_kernel_lock(v
 {
 	struct task_struct *task = current;
 	int saved_lock_depth = task->lock_depth;
+	unsigned long flags;
 
 	BUG_ON(saved_lock_depth < 0);
 
@@ -47,6 +50,10 @@ int __lockfunc __reacquire_kernel_lock(v
 
 	down(&kernel_sem);
 
+	spin_lock_irqsave(&global_lock, flags);
+	global_count++;
+	spin_unlock_irqrestore(&global_lock, flags);
+
 	preempt_disable();
 	task->lock_depth = saved_lock_depth;
 
@@ -55,6 +62,10 @@ int __lockfunc __reacquire_kernel_lock(v
 
 void __lockfunc __release_kernel_lock(void)
 {
+	spin_lock_irqsave(&global_lock, flags);
+	global_count--;
+	spin_unlock_irqrestore(&global_lock, flags);
+
 	up(&kernel_sem);
 }
 
@@ -66,12 +77,17 @@ void __lockfunc lock_kernel(void)
 	struct task_struct *task = current;
 	int depth = task->lock_depth + 1;
 
-	if (likely(!depth))
+	if (likely(!depth)) {
 		/*
 		 * No recursion worries - we set up lock_depth _after_
 		 */
 		down(&kernel_sem);
 
+		spin_lock_irqsave(&global_lock, flags);
+		global_count++;
+		spin_unlock_irqrestore(&global_lock, flags);
+	}
+
 	task->lock_depth = depth;
 }
 
