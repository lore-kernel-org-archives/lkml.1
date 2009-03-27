Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbZC0ALl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbZC0ALl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbZC0AKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:10:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44013 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899AbZC0AKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:10:39 -0400
Date: Fri, 27 Mar 2009 01:06:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Lojkin <ia6432@inbox.ru>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH 1/2] posix-timers: fix RLIMIT_CPU && fork()
Message-ID: <20090327000607.GA10104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See http://bugzilla.kernel.org/show_bug.cgi?id=12911

copy_signal() copies signal->rlim, but RLIMIT_CPU is "lost". Because
posix_cpu_timers_init_group() sets cputime_expires.prof_exp = 0 and thus
fastpath_timer_check() returns false unless we have other expired cpu timers.

Change copy_signal() to set cputime_expires.prof_exp if we have RLIMIT_CPU.
Also, set cputimer.running = 1 in that case. This is not strictly necessary,
but imho makes sense.

Reported-by: Peter Lojkin <ia6432@inbox.ru>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29/kernel/fork.c~1_FORK	2009-03-23 18:14:34.000000000 +0100
+++ 6.29/kernel/fork.c	2009-03-27 00:25:52.000000000 +0100
@@ -808,6 +808,12 @@ static void posix_cpu_timers_init_group(
 	sig->cputime_expires.virt_exp = cputime_zero;
 	sig->cputime_expires.sched_exp = 0;
 
+	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
+		sig->cputime_expires.prof_exp =
+			secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
+		sig->cputimer.running = 1;
+	}
+
 	/* The timer lists. */
 	INIT_LIST_HEAD(&sig->cpu_timers[0]);
 	INIT_LIST_HEAD(&sig->cpu_timers[1]);
@@ -823,11 +829,8 @@ static int copy_signal(unsigned long clo
 		atomic_inc(&current->signal->live);
 		return 0;
 	}
-	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
-
-	if (sig)
-		posix_cpu_timers_init_group(sig);
 
+	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
 	tsk->signal = sig;
 	if (!sig)
 		return -ENOMEM;
@@ -865,6 +868,8 @@ static int copy_signal(unsigned long clo
 	memcpy(sig->rlim, current->signal->rlim, sizeof sig->rlim);
 	task_unlock(current->group_leader);
 
+	posix_cpu_timers_init_group(sig);
+
 	acct_init_pacct(&sig->pacct);
 
 	tty_audit_fork(sig);

