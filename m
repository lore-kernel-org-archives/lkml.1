Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703Ab0ATMiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab0ATMiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 07:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481Ab0ATMiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 07:38:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab0ATMhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 07:37:51 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/6 -mm] cpu-timers: return correct previous timer reload value
Date: Wed, 20 Jan 2010 13:34:25 +0100
Message-Id: <1263990868-8119-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1263990868-8119-3-git-send-email-sgruszka@redhat.com>
References: <1263990868-8119-1-git-send-email-sgruszka@redhat.com>
 <1263990868-8119-2-git-send-email-sgruszka@redhat.com>
 <1263990868-8119-3-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According POSIX we need to correctly set old timer it_interval value
when user request that in timer_settime(). Tested using below program.

 #include <sys/time.h>
 #include <signal.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <time.h>
 #include <unistd.h>
 #include <assert.h>

 int main(void)
 {
	struct sigaction act;
	struct sigevent evt = { };
	timer_t tid;
	struct itimerspec spec, u_spec, k_spec;

	evt.sigev_notify = SIGEV_SIGNAL;
	evt.sigev_signo = SIGPROF;
	assert(timer_create(CLOCK_PROCESS_CPUTIME_ID, &evt,  &tid) == 0);

	spec.it_value.tv_sec = 1;
	spec.it_value.tv_nsec = 2;
	spec.it_interval.tv_sec = 3;
	spec.it_interval.tv_nsec = 4;
	u_spec = spec;
	assert(timer_settime(tid, 0, &spec,  NULL) == 0);

	spec.it_value.tv_sec = 5;
	spec.it_value.tv_nsec = 6;
	spec.it_interval.tv_sec = 7;
	spec.it_interval.tv_nsec = 8;
	assert(timer_settime(tid, 0, &spec,  &k_spec) == 0);

 #define PRT(val) printf(#val ":\t%d/%d\n", (int) u_spec.val, (int) k_spec.val)
	PRT(it_value.tv_sec);
	PRT(it_value.tv_nsec);
	PRT(it_interval.tv_sec);
	PRT(it_interval.tv_nsec);

	return 0;
 }

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/posix-cpu-timers.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 1039501..e9aa4dc 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -675,7 +675,7 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 			struct itimerspec *new, struct itimerspec *old)
 {
 	struct task_struct *p = timer->it.cpu.task;
-	union cpu_time_count old_expires, new_expires, val;
+	union cpu_time_count old_expires, new_expires, old_incr, val;
 	int ret;
 
 	if (unlikely(p == NULL)) {
@@ -706,6 +706,7 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	BUG_ON(!irqs_disabled());
 
 	ret = 0;
+	old_incr = timer->it.cpu.incr;
 	spin_lock(&p->sighand->siglock);
 	old_expires = timer->it.cpu.expires;
 	if (unlikely(timer->it.cpu.firing)) {
@@ -821,7 +822,7 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
  out:
 	if (old) {
 		sample_to_timespec(timer->it_clock,
-				   timer->it.cpu.incr, &old->it_interval);
+				   old_incr, &old->it_interval);
 	}
 	return ret;
 }
-- 
1.6.2.5

