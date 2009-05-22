Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbZEVNut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbZEVNut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 09:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757066AbZEVNuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 09:50:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60559 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789AbZEVNuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 09:50:21 -0400
Date: Fri, 22 May 2009 15:43:49 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH resend4 3/3] itimers: simplify arm_timer() code a bit
Message-ID: <20090522154349.396d9ea6@dhcp-lab-109.englab.brq.redhat.com>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't update values in expiration cache when new ones are equal. Add
expire_le() helper to simplify code. Make similar control flow on all
arm_timer() function.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/posix-cpu-timers.c |   46 ++++++++++++++++++++++----------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index b60d644..ce16e22 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -541,6 +541,13 @@ static void clear_dead_task(struct k_itimer *timer, union cpu_time_count now)
 					     now);
 }
 
+static inline int expires_le(cputime_t expires, cputime_t new_exp)
+{
+	if (!cputime_eq(expires, cputime_zero) && cputime_le(expires, new_exp))
+		return 1;
+	return 0;
+}
+
 /*
  * Insert the timer on the appropriate list before any timers that
  * expire later.  This must be called with the tasklist_lock held
@@ -585,31 +592,28 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
 		 */
 
 		if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
+			union cpu_time_count *exp = &nt->expires;
+
 			switch (CPUCLOCK_WHICH(timer->it_clock)) {
 			default:
 				BUG();
 			case CPUCLOCK_PROF:
-				if (cputime_eq(p->cputime_expires.prof_exp,
-					       cputime_zero) ||
-				    cputime_gt(p->cputime_expires.prof_exp,
-					       nt->expires.cpu))
-					p->cputime_expires.prof_exp =
-						nt->expires.cpu;
+				if (expires_le(p->cputime_expires.prof_exp,
+					       exp->cpu))
+					break;
+				p->cputime_expires.prof_exp = exp->cpu;
 				break;
 			case CPUCLOCK_VIRT:
-				if (cputime_eq(p->cputime_expires.virt_exp,
-					       cputime_zero) ||
-				    cputime_gt(p->cputime_expires.virt_exp,
-					       nt->expires.cpu))
-					p->cputime_expires.virt_exp =
-						nt->expires.cpu;
+				if (expires_le(p->cputime_expires.virt_exp,
+					       exp->cpu))
+					break;
+				p->cputime_expires.virt_exp = exp->cpu;
 				break;
 			case CPUCLOCK_SCHED:
-				if (p->cputime_expires.sched_exp == 0 ||
-				    p->cputime_expires.sched_exp >
-							nt->expires.sched)
-					p->cputime_expires.sched_exp =
-						nt->expires.sched;
+				if (p->cputime_expires.sched_exp == 0 &&
+				    p->cputime_expires.sched_exp <= exp->sched)
+					break;
+				p->cputime_expires.sched_exp = exp->sched;
 				break;
 			}
 		} else {
@@ -623,17 +627,13 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
 			default:
 				BUG();
 			case CPUCLOCK_VIRT:
-				if (!cputime_eq(sig->it[CPUCLOCK_VIRT].expires,
-						cputime_zero) &&
-				    cputime_lt(sig->it[CPUCLOCK_VIRT].expires,
+				if (expires_le(sig->it[CPUCLOCK_VIRT].expires,
 					       exp->cpu))
 					break;
 				sig->cputime_expires.virt_exp = exp->cpu;
 				break;
 			case CPUCLOCK_PROF:
-				if (!cputime_eq(sig->it[CPUCLOCK_PROF].expires,
-						cputime_zero) &&
-				    cputime_lt(sig->it[CPUCLOCK_PROF].expires,
+				if (expires_le(sig->it[CPUCLOCK_PROF].expires,
 					       exp->cpu))
 					break;
 				i = sig->rlim[RLIMIT_CPU].rlim_cur;
-- 
1.5.5.6

