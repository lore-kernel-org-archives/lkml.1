Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773Ab0AFPYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab0AFPYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 10:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563Ab0AFPYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 10:24:45 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:40170 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab0AFPYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 10:24:43 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] core: posix-cpu-timers, cleanup rlimits usage
Date: Wed,  6 Jan 2010 16:24:29 +0100
Message-Id: <1262791479-26594-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fetch rlimit (both hard and soft) values only once and work on them.
It removes many accesses through sig structure and makes the code
cleaner.

Mostly a preparation for writable resource limits support.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/posix-cpu-timers.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 438ff45..de7bdb3 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -982,6 +982,7 @@ static void check_thread_timers(struct task_struct *tsk,
 	int maxfire;
 	struct list_head *timers = tsk->cpu_timers;
 	struct signal_struct *const sig = tsk->signal;
+	unsigned long soft;
 
 	maxfire = 20;
 	tsk->cputime_expires.prof_exp = cputime_zero;
@@ -1030,9 +1031,9 @@ static void check_thread_timers(struct task_struct *tsk,
 	/*
 	 * Check for the special case thread timers.
 	 */
-	if (sig->rlim[RLIMIT_RTTIME].rlim_cur != RLIM_INFINITY) {
+	soft = sig->rlim[RLIMIT_RTTIME].rlim_cur;
+	if (soft != RLIM_INFINITY) {
 		unsigned long hard = sig->rlim[RLIMIT_RTTIME].rlim_max;
-		unsigned long *soft = &sig->rlim[RLIMIT_RTTIME].rlim_cur;
 
 		if (hard != RLIM_INFINITY &&
 		    tsk->rt.timeout > DIV_ROUND_UP(hard, USEC_PER_SEC/HZ)) {
@@ -1043,14 +1044,13 @@ static void check_thread_timers(struct task_struct *tsk,
 			__group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);
 			return;
 		}
-		if (tsk->rt.timeout > DIV_ROUND_UP(*soft, USEC_PER_SEC/HZ)) {
+		if (tsk->rt.timeout > DIV_ROUND_UP(soft, USEC_PER_SEC/HZ)) {
 			/*
 			 * At the soft limit, send a SIGXCPU every second.
 			 */
-			if (sig->rlim[RLIMIT_RTTIME].rlim_cur
-			    < sig->rlim[RLIMIT_RTTIME].rlim_max) {
-				sig->rlim[RLIMIT_RTTIME].rlim_cur +=
-								USEC_PER_SEC;
+			if (soft < hard) {
+				soft += USEC_PER_SEC;
+				sig->rlim[RLIMIT_RTTIME].rlim_cur = soft;
 			}
 			printk(KERN_INFO
 				"RT Watchdog Timeout: %s[%d]\n",
@@ -1121,13 +1121,14 @@ static void check_process_timers(struct task_struct *tsk,
 	unsigned long long sum_sched_runtime, sched_expires;
 	struct list_head *timers = sig->cpu_timers;
 	struct task_cputime cputime;
+	unsigned long cpu_cur_lim = sig->rlim[RLIMIT_CPU].rlim_cur;
 
 	/*
 	 * Don't sample the current process CPU clocks if there are no timers.
 	 */
 	if (list_empty(&timers[CPUCLOCK_PROF]) &&
 	    cputime_eq(sig->it[CPUCLOCK_PROF].expires, cputime_zero) &&
-	    sig->rlim[RLIMIT_CPU].rlim_cur == RLIM_INFINITY &&
+	    cpu_cur_lim == RLIM_INFINITY &&
 	    list_empty(&timers[CPUCLOCK_VIRT]) &&
 	    cputime_eq(sig->it[CPUCLOCK_VIRT].expires, cputime_zero) &&
 	    list_empty(&timers[CPUCLOCK_SCHED])) {
@@ -1194,10 +1195,11 @@ static void check_process_timers(struct task_struct *tsk,
 	check_cpu_itimer(tsk, &sig->it[CPUCLOCK_VIRT], &virt_expires, utime,
 			 SIGVTALRM);
 
-	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
+	if (cpu_cur_lim != RLIM_INFINITY) {
 		unsigned long psecs = cputime_to_secs(ptime);
+		unsigned long hard = sig->rlim[RLIMIT_CPU].rlim_max;
 		cputime_t x;
-		if (psecs >= sig->rlim[RLIMIT_CPU].rlim_max) {
+		if (psecs >= hard) {
 			/*
 			 * At the hard limit, we just die.
 			 * No need to calculate anything else now.
@@ -1205,17 +1207,17 @@ static void check_process_timers(struct task_struct *tsk,
 			__group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);
 			return;
 		}
-		if (psecs >= sig->rlim[RLIMIT_CPU].rlim_cur) {
+		if (psecs >= cpu_cur_lim) {
 			/*
 			 * At the soft limit, send a SIGXCPU every second.
 			 */
 			__group_send_sig_info(SIGXCPU, SEND_SIG_PRIV, tsk);
-			if (sig->rlim[RLIMIT_CPU].rlim_cur
-			    < sig->rlim[RLIMIT_CPU].rlim_max) {
-				sig->rlim[RLIMIT_CPU].rlim_cur++;
+			if (cpu_cur_lim < hard) {
+				cpu_cur_lim++;
+				sig->rlim[RLIMIT_CPU].rlim_cur = cpu_cur_lim;
 			}
 		}
-		x = secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
+		x = secs_to_cputime(cpu_cur_lim);
 		if (cputime_eq(prof_expires, cputime_zero) ||
 		    cputime_lt(x, prof_expires)) {
 			prof_expires = x;
-- 
1.6.5.7

