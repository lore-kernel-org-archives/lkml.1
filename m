Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbYBARi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbYBARi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYBARiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:38:50 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:46383 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbYBARiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:38:50 -0500
Date: Fri, 1 Feb 2008 20:41:30 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@sw.ru>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Toyo Abe <toyoa@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] hrtimer_nanosleep_restart: don't play with restart_block->fn
Message-ID: <20080201174130.GB26540@tv-sign.ru>
References: <20080201133805.GA25632@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201133805.GA25632@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-diff. Once again, my apologies to all for the noise.


[PATCH 5/5] hrtimer_nanosleep_restart: don't play with restart_block->fn

hrtimer_nanosleep_restart() clears/restores restart_block->fn. This is
pointless and complicates its usage. Note that if sys_restart_syscall()
doesn't actually happen, we have a bogus "pending" restart->fn anyway,
this is harmless.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- MM/kernel/hrtimer.c~x5_RESTART_FN	2008-02-01 18:54:30.000000000 +0300
+++ MM/kernel/hrtimer.c	2008-02-01 20:37:28.000000000 +0300
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
--- MM/kernel/compat.c~x5_RESTART_FN	2008-02-01 20:24:52.000000000 +0300
+++ MM/kernel/compat.c	2008-02-01 20:38:20.000000000 +0300
@@ -54,7 +54,6 @@ static long compat_nanosleep_restart(str
 	set_fs(oldfs);
 
 	if (ret) {
-		restart->fn = compat_nanosleep_restart;
 		restart->arg1 = (unsigned long)rmtp;
 
 		if (rmtp && put_compat_timespec(&rmt, rmtp))

