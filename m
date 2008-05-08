Return-Path: <linux-kernel-owner+w=401wt.eu-S1764144AbYEHOoC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764144AbYEHOoC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 10:44:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763499AbYEHOnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:43:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46604 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762858AbYEHOni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:43:38 -0400
Date: Thu, 8 May 2008 16:43:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] speed up / fix the new generic semaphore code (fix
	AIM7 40% regression with 2.6.26-rc1)
Message-ID: <20080508144316.GA9869@elte.hu>
References: <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508122802.GA4880@elte.hu>
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

> Peter pointed it out that because sem->count is u32, the <= 0 is in 
> fact a "== 0" condition - the patch below does that. As expected gcc 
> figured out the same thing too so the resulting code output did not 
> change. (so this is just a cleanup)

a second update patch, i've further simplified the semaphore wakeup 
logic: there's no need for the wakeup to remove the task from the wait 
list. This will make them a slighly bit more fair, but more importantly, 
this closes a race in my first patch for the unlikely case of a signal 
(or a timeout) and an unlock coming in at the same time and the task not 
getting removed from the wait-list.

( my performance testing with 2000 AIM7 tasks on a quad never hit that
  race but x86.git QA actually triggered it after about 30 random kernel
  bootups and it caused a nasty crash and lockup. )

	Ingo

---------------->
Subject: sem: simplify queue management
From: Ingo Molnar <mingo@elte.hu>
Date: Tue May 06 19:32:42 CEST 2008

kernel/semaphore.o:

   text	   data	    bss	    dec	    hex	filename
   1040	      0	      0	   1040	    410	semaphore.o.before
    975	      0	      0	    975	    3cf	semaphore.o.after

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/semaphore.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

Index: linux/kernel/semaphore.c
===================================================================
--- linux.orig/kernel/semaphore.c
+++ linux/kernel/semaphore.c
@@ -202,33 +202,34 @@ static inline int __sched __down_common(
 {
 	struct task_struct *task = current;
 	struct semaphore_waiter waiter;
+	int ret = 0;
 
 	waiter.task = task;
+	list_add_tail(&waiter.list, &sem->wait_list);
 
 	for (;;) {
-		list_add_tail(&waiter.list, &sem->wait_list);
-
-		if (state == TASK_INTERRUPTIBLE && signal_pending(task))
-			goto interrupted;
-		if (state == TASK_KILLABLE && fatal_signal_pending(task))
-			goto interrupted;
-		if (timeout <= 0)
-			goto timed_out;
+		if (state == TASK_INTERRUPTIBLE && signal_pending(task)) {
+			ret = -EINTR;
+			break;
+		}
+		if (state == TASK_KILLABLE && fatal_signal_pending(task)) {
+			ret = -EINTR;
+			break;
+		}
+		if (timeout <= 0) {
+			ret = -ETIME;
+			break;
+		}
 		__set_task_state(task, state);
 		spin_unlock_irq(&sem->lock);
 		timeout = schedule_timeout(timeout);
 		spin_lock_irq(&sem->lock);
 		if (sem->count > 0)
-			return 0;
+			break;
 	}
 
- timed_out:
-	list_del(&waiter.list);
-	return -ETIME;
-
- interrupted:
 	list_del(&waiter.list);
-	return -EINTR;
+	return ret;
 }
 
 static noinline void __sched __down(struct semaphore *sem)
@@ -255,6 +256,5 @@ static noinline void __sched __up(struct
 {
 	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
 						struct semaphore_waiter, list);
-	list_del(&waiter->list);
 	wake_up_process(waiter->task);
 }
