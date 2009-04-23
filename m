Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbZDWHrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbZDWHrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbZDWHcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:32:32 -0400
Received: from sous-sol.org ([216.99.217.87]:50756 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756950AbZDWHcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:32:31 -0400
Message-Id: <20090423072700.322939119@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:17 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Peter Lojkin <ia6432@inbox.ru>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 057/100] posix-timers: fix RLIMIT_CPU && fork()
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=posix-timers-fix-rlimit_cpu-fork.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Oleg Nesterov <oleg@redhat.com>

upstream commit: 6279a751fe096a21dc7704e918d570d3ff06e769

See http://bugzilla.kernel.org/show_bug.cgi?id=12911

copy_signal() copies signal->rlim, but RLIMIT_CPU is "lost". Because
posix_cpu_timers_init_group() sets cputime_expires.prof_exp = 0 and thus
fastpath_timer_check() returns false unless we have other expired cpu timers.

Change copy_signal() to set cputime_expires.prof_exp if we have RLIMIT_CPU.
Also, set cputimer.running = 1 in that case. This is not strictly necessary,
but imho makes sense.

Reported-by: Peter Lojkin <ia6432@inbox.ru>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Peter Lojkin <ia6432@inbox.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: stable@kernel.org
LKML-Reference: <20090327000607.GA10104@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 kernel/fork.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
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

