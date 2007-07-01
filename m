Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbXGAPhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbXGAPhs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 11:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbXGAPhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 11:37:39 -0400
Received: from mail.screens.ru ([213.234.233.54]:35706 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbXGAPhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 11:37:38 -0400
Date: Sun, 1 Jul 2007 19:37:49 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Jarek Poplawski <jarkao2@o2.pl>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tty_io.c: don't use flush_scheduled_work()
Message-ID: <20070701153749.GA111@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know how to test this patch, the ack/nack from maintainer is wanted.

flush_scheduled_work() is evil and should be avoided. Change tty_set_ldisc()
and release_dev() to use cancel_delayed_work_sync/cancel_work_sync.

I am not sure we really need to call do_tty_hangup() when cancel_work_sync()
returns true, but this matches the current behaviour.

Also, some whitespace fixes.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/drivers/char/tty_io.c~	2007-07-01 18:00:10.000000000 +0400
+++ t/drivers/char/tty_io.c	2007-07-01 19:22:25.000000000 +0400
@@ -162,6 +162,8 @@ static void release_tty(struct tty_struc
 static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 
+static void do_tty_hangup(struct work_struct *work);
+
 /**
  *	alloc_tty_struct	-	allocate a tty object
  *
@@ -1038,12 +1040,10 @@ restart:
 	 *	we say so later on.
 	 */
 
-	work = cancel_delayed_work(&tty->buf.work);
-	/*
-	 * Wait for ->hangup_work and ->buf.work handlers to terminate
-	 */
-	 
-	flush_scheduled_work();
+	work = cancel_delayed_work_sync(&tty->buf.work);
+	if (cancel_work_sync(&tty->hangup_work))
+		do_tty_hangup(&tty->hangup_work);
+
 	/* Shutdown the current discipline. */
 	if (tty->ldisc.close)
 		(tty->ldisc.close)(tty);
@@ -1074,23 +1074,22 @@ restart:
 		}
 	}
 	/* At this point we hold a reference to the new ldisc and a
-	   a reference to the old ldisc. If we ended up flipping back
-	   to the existing ldisc we have two references to it */
-	
+	 * a reference to the old ldisc. If we ended up flipping back
+	 * to the existing ldisc we have two references to it
+	 */
 	if (tty->ldisc.num != o_ldisc.num && tty->driver->set_ldisc)
 		tty->driver->set_ldisc(tty);
-		
+
 	tty_ldisc_put(o_ldisc.num);
-	
+
 	/*
 	 *	Allow ldisc referencing to occur as soon as the driver
 	 *	ldisc callback completes.
 	 */
-	 
 	tty_ldisc_enable(tty);
 	if (o_tty)
 		tty_ldisc_enable(o_tty);
-	
+
 	/* Restart it in case no characters kick it off. Safe if
 	   already running */
 	if (work)
@@ -2457,7 +2456,7 @@ static void release_dev(struct file * fi
 	/* check whether both sides are closing ... */
 	if (!tty_closing || (o_tty && !o_tty_closing))
 		return;
-	
+
 #ifdef TTY_DEBUG_HANGUP
 	printk(KERN_DEBUG "freeing tty structure...");
 #endif
@@ -2467,15 +2466,11 @@ static void release_dev(struct file * fi
 	 * race with the set_ldisc code path.
 	 */
 	clear_bit(TTY_LDISC, &tty->flags);
-	cancel_delayed_work(&tty->buf.work);
+	cancel_delayed_work_sync(&tty->buf.work);
+	if (cancel_work_sync(&tty->hangup_work))
+		do_tty_hangup(&tty->hangup_work);
 
 	/*
-	 * Wait for ->hangup_work and ->buf.work handlers to terminate
-	 */
-	 
-	flush_scheduled_work();
-	
-	/*
 	 * Wait for any short term users (we know they are just driver
 	 * side waiters as the file is closing so user count on the file
 	 * side is zero.
@@ -2497,7 +2492,7 @@ static void release_dev(struct file * fi
 	if (tty->ldisc.close)
 		(tty->ldisc.close)(tty);
 	tty_ldisc_put(tty->ldisc.num);
-	
+
 	/*
 	 *	Switch the line discipline back
 	 */

