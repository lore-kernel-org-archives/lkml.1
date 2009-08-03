Return-Path: <linux-kernel-owner+w=401wt.eu-S932128AbZHCNZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbZHCNZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 09:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbZHCNZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 09:25:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:52080 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbZHCNZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 09:25:39 -0400
Date: Mon, 3 Aug 2009 13:25:02 GMT
From: tip-bot for Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, benh@kernel.crashing.org,
       akpm@linux-foundation.org, tglx@linutronix.de, oleg@redhat.com,
       sgruszka@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       benh@kernel.crashing.org, akpm@linux-foundation.org, tglx@linutronix.de,
       oleg@redhat.com, sgruszka@redhat.com, mingo@elte.hu
In-Reply-To: <1248862529-6063-4-git-send-email-sgruszka@redhat.com>
References: <1248862529-6063-4-git-send-email-sgruszka@redhat.com>
Subject: [tip:timers/posixtimers] itimers: Simplify arm_timer() code a bit
Message-ID: <tip-d1e3b6d195770bd422e3229b88edfc154b6a27dd@git.kernel.org>
Git-Commit-ID: d1e3b6d195770bd422e3229b88edfc154b6a27dd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 03 Aug 2009 13:25:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1e3b6d195770bd422e3229b88edfc154b6a27dd
Gitweb:     http://git.kernel.org/tip/d1e3b6d195770bd422e3229b88edfc154b6a27dd
Author:     Stanislaw Gruszka <sgruszka@redhat.com>
AuthorDate: Wed, 29 Jul 2009 12:15:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 3 Aug 2009 14:48:36 +0200

itimers: Simplify arm_timer() code a bit

Don't update values in expiration cache when new ones are
equal. Add expire_le() and expire_gt() helpers to simplify the
code.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
LKML-Reference: <1248862529-6063-4-git-send-email-sgruszka@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/posix-cpu-timers.c |   44 +++++++++++++++++++++++---------------------
 1 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index b60d644..69c9237 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -541,6 +541,17 @@ static void clear_dead_task(struct k_itimer *timer, union cpu_time_count now)
 					     now);
 }
 
+static inline int expires_gt(cputime_t expires, cputime_t new_exp)
+{
+	return cputime_eq(expires, cputime_zero) ||
+	       cputime_gt(expires, new_exp);
+}
+
+static inline int expires_le(cputime_t expires, cputime_t new_exp)
+{
+	return !cputime_eq(expires, cputime_zero) &&
+	       cputime_le(expires, new_exp);
+}
 /*
  * Insert the timer on the appropriate list before any timers that
  * expire later.  This must be called with the tasklist_lock held
@@ -585,31 +596,26 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
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
+				if (expires_gt(p->cputime_expires.prof_exp,
+					       exp->cpu))
+					p->cputime_expires.prof_exp = exp->cpu;
 				break;
 			case CPUCLOCK_VIRT:
-				if (cputime_eq(p->cputime_expires.virt_exp,
-					       cputime_zero) ||
-				    cputime_gt(p->cputime_expires.virt_exp,
-					       nt->expires.cpu))
-					p->cputime_expires.virt_exp =
-						nt->expires.cpu;
+				if (expires_gt(p->cputime_expires.virt_exp,
+					       exp->cpu))
+					p->cputime_expires.virt_exp = exp->cpu;
 				break;
 			case CPUCLOCK_SCHED:
 				if (p->cputime_expires.sched_exp == 0 ||
-				    p->cputime_expires.sched_exp >
-							nt->expires.sched)
+				    p->cputime_expires.sched_exp > exp->sched)
 					p->cputime_expires.sched_exp =
-						nt->expires.sched;
+								exp->sched;
 				break;
 			}
 		} else {
@@ -623,17 +629,13 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
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
