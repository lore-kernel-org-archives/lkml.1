Return-Path: <linux-kernel-owner+w=401wt.eu-S937664AbXGUL5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937664AbXGUL5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 07:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758492AbXGUL47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 07:56:59 -0400
Received: from mail.screens.ru ([213.234.233.54]:42767 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757466AbXGUL47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 07:56:59 -0400
Date: Sat, 21 Jul 2007 15:57:12 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] pi-futex: set PF_EXITING without taking ->pi_lock
Message-ID: <20070721115712.GA871@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is a bit annoying that do_exit() takes ->pi_lock to set PF_EXITING.
All we need is to synchronize with lookup_pi_state() which saw this task
without PF_EXITING under ->pi_lock.

Change do_exit() to use spin_unlock_wait().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/exit.c~PF_EXIT	2007-06-19 17:09:15.000000000 +0400
+++ t/kernel/exit.c	2007-07-21 15:34:13.000000000 +0400
@@ -908,13 +908,13 @@ fastcall NORET_TYPE void do_exit(long co
 		schedule();
 	}
 
+	tsk->flags |= PF_EXITING;
 	/*
 	 * tsk->flags are checked in the futex code to protect against
 	 * an exiting task cleaning up the robust pi futexes.
 	 */
-	spin_lock_irq(&tsk->pi_lock);
-	tsk->flags |= PF_EXITING;
-	spin_unlock_irq(&tsk->pi_lock);
+	smp_mb();
+	spin_unlock_wait(&tsk->pi_lock);
 
 	if (unlikely(in_atomic()))
 		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",

