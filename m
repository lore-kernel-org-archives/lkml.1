Return-Path: <linux-kernel-owner+w=401wt.eu-S1751938Ab0ATMiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab0ATMiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 07:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481Ab0ATMiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 07:38:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128Ab0ATMh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 07:37:56 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 4/6 -mm] cpu-timers: change SIGEV_NONE timer implementation
Date: Wed, 20 Jan 2010 13:34:26 +0100
Message-Id: <1263990868-8119-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1263990868-8119-4-git-send-email-sgruszka@redhat.com>
References: <1263990868-8119-1-git-send-email-sgruszka@redhat.com>
 <1263990868-8119-2-git-send-email-sgruszka@redhat.com>
 <1263990868-8119-3-git-send-email-sgruszka@redhat.com>
 <1263990868-8119-4-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When user will setup timer without associated signal and process does
not use any other cpu timers and does not exit, tsk->signal->cputimer
is enabled and running forever, change that.

I used below program to check patch does not break current user space
visible behavior.

 #include <sys/time.h>
 #include <signal.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <time.h>
 #include <unistd.h>
 #include <assert.h>

 void consume_cpu(void)
 {
	int i = 0;
	int count = 0;

	for(i=0; i<100000000; i++)
		count++;
 }

 int main(void)
 {
	int i;
	struct sigaction act;
	struct sigevent evt = { };
	timer_t tid;
	struct itimerspec spec = { };

	evt.sigev_notify = SIGEV_NONE;
	assert(timer_create(CLOCK_PROCESS_CPUTIME_ID, &evt,  &tid) == 0);

	spec.it_value.tv_sec = 10;
	assert(timer_settime(tid, 0, &spec,  NULL) == 0);

	for (i = 0; i < 30; i++) {
		consume_cpu();
		memset(&spec, 0, sizeof(spec));
		assert(timer_gettime(tid, &spec) == 0);
		printf("%lu.%09lu\n",
			(unsigned long) spec.it_value.tv_sec,
			(unsigned long) spec.it_value.tv_nsec);
	}

	assert(timer_delete(tid) == 0);
	return 0;
 }

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/posix-cpu-timers.c |   28 ++++++----------------------
 1 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index e9aa4dc..faa0b42 100644
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

