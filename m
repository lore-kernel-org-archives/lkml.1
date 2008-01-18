Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbYARBF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbYARBF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYARBFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:05:19 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:52011 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242AbYARBFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:05:18 -0500
Date: Thu, 17 Jan 2008 20:04:27 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, Kirill Korotaev <dev@sw.ru>
Subject: [PATCH] printk deadlocks if called with runqueue lock held
Message-ID: <Pine.LNX.4.58.0801172000430.32679@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
 kernel/printk.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-mcount.git/kernel/printk.c
===================================================================
--- linux-mcount.git.orig/kernel/printk.c	2008-01-17 09:06:23.000000000 -0500
+++ linux-mcount.git/kernel/printk.c	2008-01-17 19:56:59.000000000 -0500
@@ -978,7 +978,13 @@ void release_console_sem(void)
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

