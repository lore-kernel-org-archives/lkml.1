Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbYARLgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbYARLgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 06:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbYARLgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 06:36:14 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:34146 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbYARLgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 06:36:13 -0500
Date: Fri, 18 Jan 2008 06:35:23 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jiri Kosina <jikos@jikos.cz>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, Kirill Korotaev <dev@sw.ru>
Subject: Re: [PATCH] printk deadlocks if called with runqueue lock held
In-Reply-To: <Pine.LNX.4.64.0801181203240.15647@twin.jikos.cz>
Message-ID: <Pine.LNX.4.58.0801180634040.7574@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0801172000430.32679@gandalf.stny.rr.com>
 <Pine.LNX.4.64.0801181203240.15647@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 18 Jan 2008, Jiri Kosina wrote:
>
> If this patch is going to be merged, you should perhaps adjust the comment
> introduced by the above mentioned commit, so that it reflects the new
> behavior.

Thanks for pointing this out. Updated patch below:

-- Steve
=========

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
