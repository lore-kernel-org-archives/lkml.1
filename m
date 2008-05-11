Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbYEKNBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbYEKNBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 09:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYEKNBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 09:01:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56211 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbYEKNBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 09:01:44 -0400
Date: Sun, 11 May 2008 15:01:27 +0200
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
Message-ID: <20080511130127.GA30685@elte.hu>
References: <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu> <20080511110306.GP19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511110306.GP19219@parisc-linux.org>
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

> +	/* It's possible we need to wake up the next task on the list too */
> +	if (unlikely(sem->count > 1) && !list_empty(&sem->wait_list))
> +		__up(sem);

this needs to check for ret != 0 as well, otherwise we can be woken but 
a timeout can also trigger => we lose a wakeup. I.e. like the patch 
below. Hm?

	Ingo

----------------------------->
Subject: semaphore: fix #3
From: Ingo Molnar <mingo@elte.hu>
Date: Sun May 11 09:51:07 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/semaphore.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

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
@@ -231,6 +238,10 @@ static inline int __sched __down_common(
 	}
 
 	list_del(&waiter.list);
+	if (unlikely(!list_empty(&sem->wait_list)) &&
+					((sem->count > 1) || ret))
+		__up(sem);
+
 	return ret;
 }
 
@@ -254,9 +265,10 @@ static noinline int __sched __down_timeo
 	return __down_common(sem, TASK_UNINTERRUPTIBLE, jiffies);
 }
 
-static noinline void __sched __up(struct semaphore *sem)
-{
-	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
-						struct semaphore_waiter, list);
-	wake_up_process(waiter->task);
-}
+
+	/*
+	 * Rotate sleepers - to make sure all of them get woken in case
+	 * of parallel up()s:
+	 */
+	list_move_tail(&waiter->list, &sem->wait_list);
+
