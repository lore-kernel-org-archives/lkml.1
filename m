Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbYEKMvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbYEKMvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 08:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbYEKMvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 08:51:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53724 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517AbYEKMvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 08:51:08 -0400
Date: Sun, 11 May 2008 14:50:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080511125049.GA22513@elte.hu>
References: <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu> <20080511110306.GP19219@parisc-linux.org> <20080511114803.GA8289@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511114803.GA8289@parisc-linux.org>
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


* Matthew Wilcox <matthew@wil.cx> wrote:

> So I deem my fix "proven by thought experiment".  I haven't tried 
> booting it or anything.

i actually have two fixes, made earlier today. The 'fix3' one has been 
confirmed by Sven to fix the regression - but i think we need the 'fix 
#2' one below as well to make it complete.

	Ingo

-------------------->
Subject: semaphore: fix3
From: Ingo Molnar <mingo@elte.hu>
Date: Sun May 11 09:51:07 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/semaphore.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux/kernel/semaphore.c
===================================================================
--- linux.orig/kernel/semaphore.c
+++ linux/kernel/semaphore.c
@@ -258,5 +258,12 @@ static noinline void __sched __up(struct
 {
 	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
 						struct semaphore_waiter, list);
+
+	/*
+	 * Rotate sleepers - to make sure all of them get woken in case
+	 * of parallel up()s:
+	 */
+	list_move_tail(&waiter->list, &sem->wait_list);
+
 	wake_up_process(waiter->task);
 }

---------------->
Subject: semaphore: fix #2
From: Ingo Molnar <mingo@elte.hu>
Date: Thu May 08 11:53:48 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/semaphore.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

Index: linux/kernel/semaphore.c
===================================================================
--- linux.orig/kernel/semaphore.c
+++ linux/kernel/semaphore.c
@@ -194,6 +194,13 @@ struct semaphore_waiter {
 	struct task_struct *task;
 };
 
+static noinline void __sched __up(struct semaphore *sem)
+{
+	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
+						struct semaphore_waiter, list);
+	wake_up_process(waiter->task);
+}
+
 /*
  * Because this function is inlined, the 'state' parameter will be
  * constant, and thus optimised away by the compiler.  Likewise the
@@ -231,6 +238,9 @@ static inline int __sched __down_common(
 	}
 
 	list_del(&waiter.list);
+	if (unlikely(!list_empty(&sem->wait_list)) && sem->count)
+		__up(sem);
+
 	return ret;
 }
 
@@ -254,9 +264,3 @@ static noinline int __sched __down_timeo
 	return __down_common(sem, TASK_UNINTERRUPTIBLE, jiffies);
 }
 
-static noinline void __sched __up(struct semaphore *sem)
-{
-	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
-						struct semaphore_waiter, list);
-	wake_up_process(waiter->task);
-}
