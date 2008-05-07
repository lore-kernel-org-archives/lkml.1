Return-Path: <linux-kernel-owner+w=401wt.eu-S1763549AbYEGSRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763549AbYEGSRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbYEGSRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:17:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59785 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495AbYEGSRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:17:31 -0400
Date: Wed, 7 May 2008 20:17:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507181714.GA14980@elte.hu>
References: <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <20080506102153.5484c6ac.akpm@linux-foundation.org> <20080507163811.GY19219@parisc-linux.org> <alpine.LFD.1.10.0805070948250.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805070956060.3024@woody.linux-foundation.org> <20080507172246.GA13262@elte.hu> <alpine.LFD.1.10.0805071028400.3024@woody.linux-foundation.org> <20080507174900.GB13591@elte.hu> <alpine.LFD.1.10.0805071057280.3024@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805071057280.3024@woody.linux-foundation.org>
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

> On Wed, 7 May 2008, Ingo Molnar wrote:
> > 
> > another idea: my trial-baloon patch should test your theory too, 
> > because the generic down_trylock() is still the 'fat' version, it 
> > does:
> 
> I agree that your trial-balloon should likely get rid of the big 
> regression, since it avoids the scheduler.
> 
> So with your patch, lock_kernel() ends up being just a rather 
> expensive spinlock. And yes, I'd expect that it should get rid of the 
> 40% cost, because while it makes lock_kernel() more expensive than a 
> spinlock and you might end up having a few more cacheline bounces on 
> the lock due to that, that's still the "small" expense compared to 
> going through the whole scheduler on conflicts.
> 
> So I'd expect that realistically the performance difference between 
> your version and just plain spinlocks shouldn't be *that* big. I'd 
> expect it to be visible, but in the (low) single-digit percentage 
> range rather than in any 40% range. That's just a guess.

third attempt - the patch below ontop of v2.6.25 should be quite similar 
fastpath atomic overhead to what generic semaphores do? So if Yanmin 
tests this patch ontop of v2.6.25, we should see the direct fastpath 
overhead - without any changes to the semaphore wakeup/scheduling logic 
otherwise.

[ this patch should in fact be a bit worse, because there's two more 
  atomics in the fastpath - the fastpath atomics of the old semaphore 
  code. ]

	Ingo

------------------>
Subject: v2.6.25 BKL: add atomic overhead
From: Ingo Molnar <mingo@elte.hu>
Date: Wed May 07 20:09:13 CEST 2008

---
 lib/kernel_lock.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: linux-2.6.25/lib/kernel_lock.c
===================================================================
--- linux-2.6.25.orig/lib/kernel_lock.c
+++ linux-2.6.25/lib/kernel_lock.c
@@ -24,6 +24,7 @@
  * Don't use in new code.
  */
 static DECLARE_MUTEX(kernel_sem);
+static DEFINE_SPINLOCK(global_lock);
 
 /*
  * Re-acquire the kernel semaphore.
@@ -47,6 +48,9 @@ int __lockfunc __reacquire_kernel_lock(v
 
 	down(&kernel_sem);
 
+	spin_lock(&global_lock);
+	spin_unlock(&global_lock);
+
 	preempt_disable();
 	task->lock_depth = saved_lock_depth;
 
@@ -55,6 +59,9 @@ int __lockfunc __reacquire_kernel_lock(v
 
 void __lockfunc __release_kernel_lock(void)
 {
+	spin_lock(&global_lock);
+	spin_unlock(&global_lock);
+
 	up(&kernel_sem);
 }
 
@@ -66,12 +73,16 @@ void __lockfunc lock_kernel(void)
 	struct task_struct *task = current;
 	int depth = task->lock_depth + 1;
 
-	if (likely(!depth))
+	if (likely(!depth)) {
 		/*
 		 * No recursion worries - we set up lock_depth _after_
 		 */
 		down(&kernel_sem);
 
+		spin_lock(&global_lock);
+		spin_unlock(&global_lock);
+	}
+
 	task->lock_depth = depth;
 }
 
