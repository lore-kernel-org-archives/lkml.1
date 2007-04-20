Return-Path: <linux-kernel-owner+w=401wt.eu-S2992551AbXDTIur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992551AbXDTIur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992642AbXDTIur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:50:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48959 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992551AbXDTIuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:50:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH(experimental) 2/2] Fix freezer-kthread_stop race
Date: Fri, 20 Apr 2007 10:54:36 +0200
User-Agent: KMail/1.9.5
Cc: ego@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@in.ibm.com,
       paulmck@us.ibm.com, pavel@ucw.cz
References: <20070419120131.GB13435@in.ibm.com> <20070419120419.GB17069@in.ibm.com> <20070419143133.a6c82ef8.akpm@linux-foundation.org>
In-Reply-To: <20070419143133.a6c82ef8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704201054.38037.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 19 April 2007 23:31, Andrew Morton wrote:
> On Thu, 19 Apr 2007 17:34:19 +0530
> Gautham R Shenoy <ego@in.ibm.com> wrote:
> 
> > Threads which wait for completion on a frozen thread might result in 
> > causing the freezer to fail, if the waiting thread is freezeable.
> > 
> > There are some well known cases where it's preferable to temporarily thaw
> > the frozen process, finish the wait for completion and allow both the 
> > processes to call try_to_freeze. 
> > 
> > kthread_stop is one such case.
> 
> hm.
> 
> > flush_workqueue might be another. 
> 
> flush_workqueue() just needs to die.  I think there are (almost) no
> legitimate users of it once cancel_work_sync() is merged.
> 
> > This patch attempts to address such a situation with a fix for kthread_stop.
> 
> Via wholly undescribed means :(

Yeah, I have the same problem with it. :-)

> > Strictly experimental. Compile tested on i386.
> 
> Rather than doing <whatever you did>, perhaps we could make the freezing
> process a dual-pass thing.  On pass 1, mark all the threads as "we'll be
> freezing you soon" and on the second pass, do the actual freezing.  Then,
> in problematic places such as kthread_stop() we can look to see if we'll
> soon be asked to freeze and if so, run try_to_freeze().
> 
> Of course, running try_to_freeze() in kthread_stop() would be very wrong,
> so we'd actually need to do it in callers, preferably via a new
> kthread_stop_freezeable() wrapper.
> 
> And the two-pass-freeze thing is of course racy.  It's also unnecessary:
> setting a flag on every task in the machine is equivalent to setting a
> global variable.  So perhaps just use a global variable?
> 
> int kthread_stop_freezeable(struct task_struct *k)
> {
> 	if (freeze_state == ABOUT_TO_START) {
> 		wait_for(freeze_state == STARTED);
> 		try_to_freeze();
> 	}
> 	kthread_stop(k);
> }
> 
> which is theoretically racy if another freeze_processes() starts
> immediately.  Anyway - please have a think about it ;)

Hmm, can't we do something like this instead:

---
 kernel/kthread.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6.21-rc7/kernel/kthread.c
===================================================================
--- linux-2.6.21-rc7.orig/kernel/kthread.c
+++ linux-2.6.21-rc7/kernel/kthread.c
@@ -13,6 +13,7 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 #include <asm/semaphore.h>
 
 /*
@@ -232,6 +233,15 @@ int kthread_stop(struct task_struct *k)
 
 	/* Now set kthread_should_stop() to true, and wake it up. */
 	kthread_stop_info.k = k;
+	if (!(current->flags & PF_NOFREEZE)) {
+		/* If we are freezable, the freezer will wait for us */
+		task_lock(k);
+		k->flags |= PF_NOFREEZE;
+		if (frozen(k))
+			k->flags &= ~PF_FROZEN;
+
+		task_unlock(k);
+	}
 	wake_up_process(k);
 	put_task_struct(k);
 
