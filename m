Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZK0XKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZK0XKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZK0XJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:09:24 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60471 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbZK0XGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v3 13/27] core: posix-cpu-timers, cleanup rlimits usage
Date: Sat, 28 Nov 2009 00:05:53 +0100
Message-Id: <1259363167-9347-13-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fetch rlimit (both hard and soft) values only once and work on them.
It removes many accesses through sig structure and makes the code
cleaner.

Mostly a preparation for writable resource limits support.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/posix-cpu-timers.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 102c345..a7dcce1 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -983,6 +983,7 @@ static void check_thread_timers(struct task_struct *tsk,
 	int maxfire;
 	struct list_head *timers = tsk->cpu_timers;
 	struct signal_struct *const sig = tsk->signal;
+	unsigned long soft;
 
 	maxfire = 20;
 	tsk->cputime_expires.prof_exp = cputime_zero;
@@ -1031,9 +1032,9 @@ static void check_thread_timers(struct task_struct *tsk,
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
@@ -1044,14 +1045,13 @@ static void check_thread_timers(struct task_struct *tsk,
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
@@ -1122,13 +1122,14 @@ static void check_process_timers(struct task_struct *tsk,
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
@@ -1195,10 +1196,11 @@ static void check_process_timers(struct task_struct *tsk,
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
@@ -1206,17 +1208,17 @@ static void check_process_timers(struct task_struct *tsk,
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
1.6.5.3

