Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbXCGPdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbXCGPdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXCGPdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:33:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:36449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbXCGPdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:33:53 -0500
Date: Wed, 7 Mar 2007 16:33:49 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [rfc][patch] futex: restartable futex_wait?
Message-ID: <20070307153349.GA32404@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I'm seeing an LTP test fail for ltp test sigaction_16_24. Basically,
it tests whether the SA_RESTART flag works for the sem_wait operation.

I see sem_wait is implemented with futex_wait, so I wonder whether we
can make it restartable? Am I going about it the right way? (Seems to
fix the testcase here).

Thanks,
Nick

--
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
