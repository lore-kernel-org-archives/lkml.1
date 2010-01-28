Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106Ab0A1WEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab0A1WEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 17:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465Ab0A1WEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 17:04:13 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:53947 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0A1WEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 17:04:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/2] core: posix-cpu-timers, cleanup rlimits usage
Date: Thu, 28 Jan 2010 23:04:07 +0100
Message-Id: <1264716248-25112-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <4B612D57.4080604@gmail.com>
References: <4B612D57.4080604@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rebased on the top of mmotm 2010-01-28-01-36. Hopefully this time it will
work out.
--

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
index ffba8f4..417fe38 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -917,6 +917,7 @@ static void check_thread_timers(struct task_struct *tsk,
 	int maxfire;
 	struct list_head *timers = tsk->cpu_timers;
 	struct signal_struct *const sig = tsk->signal;
+	unsigned long soft;
 
 	maxfire = 20;
 	tsk->cputime_expires.prof_exp = cputime_zero;
@@ -965,9 +966,9 @@ static void check_thread_timers(struct task_struct *tsk,
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
@@ -978,14 +979,13 @@ static void check_thread_timers(struct task_struct *tsk,
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
@@ -1070,6 +1070,7 @@ static void check_process_timers(struct task_struct *tsk,
 	unsigned long long sum_sched_runtime, sched_expires;
 	struct list_head *timers = sig->cpu_timers;
 	struct task_cputime cputime;
+	unsigned long soft;
 
 	/*
 	 * Collect the current process totals.
@@ -1129,11 +1130,12 @@ static void check_process_timers(struct task_struct *tsk,
 			 SIGPROF);
 	check_cpu_itimer(tsk, &sig->it[CPUCLOCK_VIRT], &virt_expires, utime,
 			 SIGVTALRM);
-
-	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
+	soft = sig->rlim[RLIMIT_CPU].rlim_cur;
+	if (soft != RLIM_INFINITY) {
 		unsigned long psecs = cputime_to_secs(ptime);
+		unsigned long hard = sig->rlim[RLIMIT_CPU].rlim_max;
 		cputime_t x;
-		if (psecs >= sig->rlim[RLIMIT_CPU].rlim_max) {
+		if (psecs >= hard) {
 			/*
 			 * At the hard limit, we just die.
 			 * No need to calculate anything else now.
@@ -1141,17 +1143,17 @@ static void check_process_timers(struct task_struct *tsk,
 			__group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);
 			return;
 		}
-		if (psecs >= sig->rlim[RLIMIT_CPU].rlim_cur) {
+		if (psecs >= soft) {
 			/*
 			 * At the soft limit, send a SIGXCPU every second.
 			 */
 			__group_send_sig_info(SIGXCPU, SEND_SIG_PRIV, tsk);
-			if (sig->rlim[RLIMIT_CPU].rlim_cur
-			    < sig->rlim[RLIMIT_CPU].rlim_max) {
-				sig->rlim[RLIMIT_CPU].rlim_cur++;
+			if (soft < hard) {
+				soft++;
+				sig->rlim[RLIMIT_CPU].rlim_cur = soft;
 			}
 		}
-		x = secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
+		x = secs_to_cputime(soft);
 		if (cputime_eq(prof_expires, cputime_zero) ||
 		    cputime_lt(x, prof_expires)) {
 			prof_expires = x;
-- 
1.6.6.1

