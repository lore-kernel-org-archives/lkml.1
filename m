Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYAWQLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYAWQLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbYAWQFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:05:23 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:55000 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbYAWQE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:04:56 -0500
Message-Id: <20080123160441.236562634@goodmis.org>
References: <20080123160236.969334052@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 23 Jan 2008 11:02:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 01/20 -v5] printk - dont wakeup klogd with interrupts disabled
Content-Disposition: inline; filename=printk-no-klogd-on-irqs-disabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ This patch is added to the series since the wakeup timings trace
  may lockup without it. ]

I thought that one could place a printk anywhere without worrying.
But it seems that it is not wise to place a printk where the runqueue
lock is held.

I just spent two hours debugging why some of my code was locking up,
to find that the lockup was caused by some debugging printk's that
I had in the scheduler.  The printk's were only in rare paths so
they shouldn't be too much of a problem, but after I hit the printk
the system locked up.

Thinking that it was locking up on my code I went looking down the
wrong path. I finally found (after examining an NMI dump) that
the lockup happened because printk was trying to wakeup the klogd
daemon, which caused a deadlock when the try_to_wakeup code tries
to grab the runqueue lock.

Since printks are seldom called with interrupts disabled, we can
hold off the waking of klogd if they are. We don't have access to
the runqueue locks from printk, but those locks need interrupts
disabled in order to be held. 

Calling printk with interrupts disabled should only be done for
emergencies and debugging anyway.

And with this patch, my code ran fine ;-)

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/printk.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

Index: linux-mcount.git/kernel/printk.c
===================================================================
--- linux-mcount.git.orig/kernel/printk.c	2008-01-18 06:29:15.000000000 -0500
+++ linux-mcount.git/kernel/printk.c	2008-01-18 06:32:38.000000000 -0500
@@ -595,9 +595,11 @@ static int have_callable_console(void)
  * @fmt: format string
  *
  * This is printk().  It can be called from any context.  We want it to work.
- * Be aware of the fact that if oops_in_progress is not set, we might try to
- * wake klogd up which could deadlock on runqueue lock if printk() is called
- * from scheduler code.
+ *
+ * Note: if printk() is called with interrupts disabled, it will not wake
+ * up the klogd. This is to avoid a deadlock from calling printk() in schedule
+ * with the runqueue lock held and having the wake_up grab the runqueue lock
+ * as well.
  *
  * We try to grab the console_sem.  If we succeed, it's easy - we log the output and
  * call the console drivers.  If we fail to get the semaphore we place the output
@@ -978,7 +980,13 @@ void release_console_sem(void)
 	console_locked = 0;
 	up(&console_sem);
 	spin_unlock_irqrestore(&logbuf_lock, flags);
-	if (wake_klogd)
+	/*
+	 * If we try to wake up klogd while printing with the runqueue lock
+	 * held, this will deadlock. We don't have access to the runqueue
+	 * lock from here, but just checking for interrupts disabled
+	 * should be enough.
+	 */
+	if (!irqs_disabled() && wake_klogd)
 		wake_up_klogd();
 }
 EXPORT_SYMBOL(release_console_sem);

-- 
