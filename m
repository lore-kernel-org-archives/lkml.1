Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZLIJmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZLIJmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZLIJme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:42:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbZLIJm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:42:29 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC PATCH 4/6] cpu-timers: change SIGEV_NONE timer handling
Date: Wed,  9 Dec 2009 10:39:56 +0100
Message-Id: <1260351598-4203-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1260351598-4203-4-git-send-email-sgruszka@redhat.com>
References: <1260351598-4203-1-git-send-email-sgruszka@redhat.com>
 <1260351598-4203-2-git-send-email-sgruszka@redhat.com>
 <1260351598-4203-3-git-send-email-sgruszka@redhat.com>
 <1260351598-4203-4-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when user setup timer without associated signal and process
not use any other cpu timers, we are running tsk->signal->cputimer
forewer, change that.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/posix-cpu-timers.c |   28 ++++++----------------------
 1 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 4716c8c..08506ff 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -614,7 +614,12 @@ static void arm_timer(struct k_itimer *timer)
  */
 static void cpu_timer_fire(struct k_itimer *timer)
 {
-	if (unlikely(timer->sigq == NULL)) {
+	if ((timer->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE) {
+		/*
+		 * User don't want any signal.
+		 */
+		timer->it.cpu.expires.sched = 0;
+	} else if (unlikely(timer->sigq == NULL)) {
 		/*
 		 * This a special case for clock_nanosleep,
 		 * not a normal timer from sys_timer_create.
@@ -783,7 +788,6 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	 */
 	timer->it.cpu.expires = new_expires;
 	if (new_expires.sched != 0 &&
-	    (timer->it_sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_NONE &&
 	    cpu_time_before(timer->it_clock, val, new_expires)) {
 		arm_timer(timer);
 	}
@@ -808,7 +812,6 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	timer->it_overrun = -1;
 
 	if (new_expires.sched != 0 &&
-	    (timer->it_sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_NONE &&
 	    !cpu_time_before(timer->it_clock, val, new_expires)) {
 		/*
 		 * The designated time already passed, so we notify
@@ -882,25 +885,6 @@ void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 		read_unlock(&tasklist_lock);
 	}
 
-	if ((timer->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE) {
-		if (timer->it.cpu.incr.sched == 0 &&
-		    cpu_time_before(timer->it_clock,
-				    timer->it.cpu.expires, now)) {
-			/*
-			 * Do-nothing timer expired and has no reload,
-			 * so it's as if it was never set.
-			 */
-			timer->it.cpu.expires.sched = 0;
-			itp->it_value.tv_sec = itp->it_value.tv_nsec = 0;
-			return;
-		}
-		/*
-		 * Account for any expirations and reloads that should
-		 * have happened.
-		 */
-		bump_cpu_timer(timer, now);
-	}
-
 	if (unlikely(clear_dead)) {
 		/*
 		 * We've noticed that the thread is dead, but
-- 
1.6.2.5

