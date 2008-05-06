Return-Path: <linux-kernel-owner+w=401wt.eu-S932793AbYEFRn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793AbYEFRn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932131AbYEFRjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:39:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54122 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbYEFRjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:39:19 -0400
Date: Tue, 6 May 2008 19:39:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080506173900.GA9014@elte.hu>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <20080506102153.5484c6ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506102153.5484c6ac.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Finally: how come we regressed by swapping the semaphore 
> implementation anyway?  We went from one sleeping lock implementation 
> to another - I'd have expected performance to be pretty much the same.
> 
> <looks at the implementation>
> 
> down(), down_interruptible() and down_try() should use 
> spin_lock_irq(), not irqsave.
> 
> up() seems to be doing wake-one, FIFO which is nice.  Did the 
> implementation which we just removed also do that?  Was it perhaps 
> accidentally doing LIFO or something like that?

i just checked the old implementation on x86. It used 
lib/semaphore-sleepers.c which does one weird thing:

  - __down() when it returns wakes up yet another task via 
    wake_up_locked().

i.e. we'll always keep yet another task in flight. This can mask wakeup 
latencies especially when it takes time.

The patch (hack) below tries to emulate this weirdness - it 'kicks' 
another task as well and keeps it busy. Most of the time this just 
causes extra scheduling, but if AIM7 is _just_ saturating the number of 
CPUs, it might make a difference. Yanmin, does the patch below make any 
difference to the AIM7 results?

( it would be useful data to get a meaningful context switch trace from 
  the whole regressed workload, and compare it to a context switch trace 
  with the revert added. )

	Ingo

---
 kernel/semaphore.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux/kernel/semaphore.c
===================================================================
--- linux.orig/kernel/semaphore.c
+++ linux/kernel/semaphore.c
@@ -261,4 +261,14 @@ static noinline void __sched __up(struct
 	list_del(&waiter->list);
 	waiter->up = 1;
 	wake_up_process(waiter->task);
+
+	if (likely(list_empty(&sem->wait_list)))
+		return;
+	/*
+	 * Opportunistically wake up another task as well but do not
+	 * remove it from the list:
+	 */
+	waiter = list_first_entry(&sem->wait_list,
+				  struct semaphore_waiter, list);
+	wake_up_process(waiter->task);
 }
