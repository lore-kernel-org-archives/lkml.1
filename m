Return-Path: <linux-kernel-owner+w=401wt.eu-S1761024AbYBANhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761024AbYBANhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760032AbYBANfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:35:43 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:57842 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759624AbYBANfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:35:43 -0500
Date: Fri, 1 Feb 2008 16:38:05 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@sw.ru>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Toyo Abe <toyoa@mvista.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] hrtimer_nanosleep_restart: don't play with restart_block->fn
Message-ID: <20080201133805.GA25632@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hrtimer_nanosleep_restart() clears/restores restart_block->fn. This is
pointless and complicates its usage. Note that if sys_restart_syscall()
doesn't actually happen, we have a bogus "pending" restart->fn anyway,
this is harmless.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- MM/kernel/hrtimer.c~5_RESTART_FN	2008-02-01 13:56:44.000000000 +0300
+++ MM/kernel/hrtimer.c	2008-02-01 15:15:15.000000000 +0300
@@ -1338,8 +1338,6 @@ long __sched hrtimer_nanosleep_restart(s
 	struct hrtimer_sleeper t;
 	struct timespec __user  *rmtp;
 
-	restart->fn = do_no_restart_syscall;
-
 	hrtimer_init(&t.timer, restart->arg0, HRTIMER_MODE_ABS);
 	t.timer.expires.tv64 = ((u64)restart->arg3 << 32) | (u64) restart->arg2;
 
@@ -1353,8 +1351,6 @@ long __sched hrtimer_nanosleep_restart(s
 			return ret;
 	}
 
-	restart->fn = hrtimer_nanosleep_restart;
-
 	/* The other values in restart are already filled in */
 	return -ERESTART_RESTARTBLOCK;
 }
--- MM/kernel/compat.c~5_RESTART_FN	2008-02-01 15:05:28.000000000 +0300
+++ MM/kernel/compat.c	2008-02-01 15:16:01.000000000 +0300
@@ -57,10 +57,8 @@ static long compat_nanosleep_restart(str
 		if (rmtp && put_compat_timespec(&tu, rmtp))
 			return -EFAULT;
 
-		if (err == -ERESTART_RESTARTBLOCK) {
-			restart->fn = compat_nanosleep_restart;
+		if (err == -ERESTART_RESTARTBLOCK)
 			restart->arg1 = (unsigned long)rmtp;
-		}
 	}
 
 	return err;

