Return-Path: <linux-kernel-owner+w=401wt.eu-S1767737AbXCJDiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767737AbXCJDiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 22:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767738AbXCJDiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 22:38:10 -0500
Received: from ns2.suse.de ([195.135.220.15]:36007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767737AbXCJDiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 22:38:09 -0500
Date: Sat, 10 Mar 2007 04:37:53 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] futex: restartable futex_wait
Message-ID: <20070310033753.GA13299@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

LTP test sigaction_16_24 fails, because it expects sem_wait to be restarted
if SA_RESTART is set. sem_wait is implemented with futex_wait, that currently
doesn't support being restarted. Ulrich confirms that the call should be
restartable.

Implement a restart_block method to handle the relative timeout, and allow
restarts.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -978,6 +978,7 @@ static void unqueue_me_pi(struct futex_q
 	drop_futex_key_refs(&q->key);
 }
 
+static long futex_wait_restart(struct restart_block *restart);
 static int futex_wait(u32 __user *uaddr, u32 val, unsigned long time)
 {
 	struct task_struct *curr = current;
@@ -1077,11 +1078,22 @@ static int futex_wait(u32 __user *uaddr,
 		return 0;
 	if (time == 0)
 		return -ETIMEDOUT;
+
 	/*
 	 * We expect signal_pending(current), but another thread may
 	 * have handled it for us already.
 	 */
-	return -EINTR;
+	if (time == MAX_SCHEDULE_TIMEOUT)
+		return -ERESTARTSYS;
+	else {
+		struct restart_block *restart;
+		restart = &current_thread_info()->restart_block;
+		restart->fn = futex_wait_restart;
+		restart->arg0 = (unsigned long)uaddr;
+		restart->arg1 = (unsigned long)val;
+		restart->arg2 = time;
+		return -ERESTART_RESTARTBLOCK;
+	}
 
  out_unlock_release_sem:
 	queue_unlock(&q, hb);
@@ -1091,6 +1103,17 @@ static int futex_wait(u32 __user *uaddr,
 	return ret;
 }
 
+static long futex_wait_restart(struct restart_block *restart)
+{
+	u32 __user *uaddr = (u32 __user *)restart->arg0;
+	u32 val = (u32)restart->arg1;
+	unsigned long time = restart->arg2;
+
+	restart->fn = do_no_restart_syscall;
+	return (long)futex_wait(uaddr, val, time);
+}
+
+
 /*
  * Userspace tried a 0 -> TID atomic transition of the futex value
  * and failed. The kernel side here does the whole locking operation:
