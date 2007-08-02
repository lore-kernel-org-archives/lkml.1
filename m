Return-Path: <linux-kernel-owner+w=401wt.eu-S1760183AbXHBVhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbXHBVhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbXHBVhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:37:10 -0400
Received: from mail.screens.ru ([213.234.233.54]:53645 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbXHBVhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:37:08 -0400
Date: Fri, 3 Aug 2007 01:37:30 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH, RESEND] pi-futex: set PF_EXITING without taking ->pi_lock
Message-ID: <20070802213730.GA554@tv-sign.ru>
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
Acked-by: Ingo Molnar <mingo@elte.hu>

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

