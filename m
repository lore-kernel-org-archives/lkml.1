Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbZLIJnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbZLIJnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbZLIJnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:43:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbZLIJnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:43:05 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC PATCH 5/6] cpu-timers: change arm_timer() locking
Date: Wed,  9 Dec 2009 10:39:57 +0100
Message-Id: <1260351598-4203-6-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1260351598-4203-5-git-send-email-sgruszka@redhat.com>
References: <1260351598-4203-1-git-send-email-sgruszka@redhat.com>
 <1260351598-4203-2-git-send-email-sgruszka@redhat.com>
 <1260351598-4203-3-git-send-email-sgruszka@redhat.com>
 <1260351598-4203-4-git-send-email-sgruszka@redhat.com>
 <1260351598-4203-5-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spread p->sighand->siglock locking scope to assure signal->cputimer
is always running when we are setuping signal->cputime_expires.

This further assure we do not iterate over all threads in
fastpath_timer_check() when calling thread_group_cputimer().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/posix-cpu-timers.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 08506ff..68d4045 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -549,7 +549,7 @@ static inline int expires_gt(cputime_t expires, cputime_t new_exp)
 /*
  * Insert the timer on the appropriate list before any timers that
  * expire later.  This must be called with the tasklist_lock held
- * for reading, and interrupts disabled.
+ * for reading, interrupts disabled and p->sighand->siglock taken.
  */
 static void arm_timer(struct k_itimer *timer)
 {
@@ -568,9 +568,6 @@ static void arm_timer(struct k_itimer *timer)
 	}
 	head += CPUCLOCK_WHICH(timer->it_clock);
 
-	BUG_ON(!irqs_disabled());
-	spin_lock(&p->sighand->siglock);
-
 	listpos = head;
 	list_for_each_entry(next, head, entry) {
 		if (cpu_time_before(timer->it_clock, nt->expires, next->expires))
@@ -605,8 +602,6 @@ static void arm_timer(struct k_itimer *timer)
 			break;
 		}
 	}
-
-	spin_unlock(&p->sighand->siglock);
 }
 
 /*
@@ -719,7 +714,6 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 		ret = TIMER_RETRY;
 	} else
 		list_del_init(&timer->it.cpu.entry);
-	spin_unlock(&p->sighand->siglock);
 
 	/*
 	 * We need to sample the current value to convert the new
@@ -773,6 +767,7 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 		 * disable this firing since we are already reporting
 		 * it as an overrun (thanks to bump_cpu_timer above).
 		 */
+		spin_unlock(&p->sighand->siglock);
 		read_unlock(&tasklist_lock);
 		goto out;
 	}
@@ -792,6 +787,7 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 		arm_timer(timer);
 	}
 
+	spin_unlock(&p->sighand->siglock);
 	read_unlock(&tasklist_lock);
 
 	/*
@@ -1201,6 +1197,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			goto out;
 		}
 		read_lock(&tasklist_lock); /* arm_timer needs it.  */
+		spin_lock(&p->sighand->siglock);
 	} else {
 		read_lock(&tasklist_lock);
 		if (unlikely(p->signal == NULL)) {
@@ -1221,6 +1218,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			clear_dead_task(timer, now);
 			goto out_unlock;
 		}
+		spin_lock(&p->sighand->siglock);
 		cpu_timer_sample_group(timer->it_clock, p, &now);
 		bump_cpu_timer(timer, now);
 		/* Leave the tasklist_lock locked for the call below.  */
@@ -1229,7 +1227,9 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 	/*
 	 * Now re-arm for the new expiry time.
 	 */
+	BUG_ON(!irqs_disabled());
 	arm_timer(timer);
+	spin_unlock(&p->sighand->siglock);
 
 out_unlock:
 	read_unlock(&tasklist_lock);
-- 
1.6.2.5

