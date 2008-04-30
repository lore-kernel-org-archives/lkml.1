Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbYD3Ari@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbYD3Ari (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 20:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755895AbYD3Ar2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 20:47:28 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36578 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755891AbYD3Ar1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 20:47:27 -0400
From: Jonathan Lim <jlim@sgi.com>
Message-Id: <200804300048.m3U0m33E127608@sabah.engr.sgi.com>
Subject: [PATCH] Account for user time when updating memory integrals
To: linux-kernel@vger.kernel.org
Date: Tue, 29 Apr 2008 17:48:02 -0700 (PDT)
Cc: akpm@linux-foundation.org, randy.dunlap@oracle.com, zippel@linux-m68k.org,
       tglx@linutronix.de, jlan@sgi.com
In-Reply-To: <no.id> from "jlim" at Apr 18, 2008 02:54:30 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adapts acct_update_integrals() to include user time when calculating
the time difference.  The units of acct_rss_mem1 and acct_vm_mem1 are also
changed from pages-jiffies to pages-usecs to avoid calling jiffies_to_usecs()
in xacct_add_tsk() which might overflow.

This patch obsoletes:

  provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch

Signed-off-by: Jonathan Lim <jlim@sgi.com>


--- a/include/linux/sched.h	2008-04-07 15:54:08.000000000 -0700
+++ b/include/linux/sched.h	2008-04-18 15:17:52.996000000 -0700
@@ -940,7 +940,7 @@ struct task_struct {
 #if defined(CONFIG_TASK_XACCT)
 	u64 acct_rss_mem1;	/* accumulated rss usage */
 	u64 acct_vm_mem1;	/* accumulated virtual memory usage */
-	cputime_t acct_stimexpd;/* stime since last update */
+	cputime_t acct_timexpd;	/* stime + utime since last update */
 #endif
 #ifdef CONFIG_NUMA
   	struct mempolicy *mempolicy;
--- a/kernel/tsacct.c	2008-04-07 15:53:52.000000000 -0700
+++ b/kernel/tsacct.c	2008-04-29 16:22:35.888000000 -0700
@@ -81,9 +81,9 @@ void bacct_add_tsk(struct taskstats *sta
  */
 void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
 {
-	/* convert pages-jiffies to Mbyte-usec */
-	stats->coremem = jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
-	stats->virtmem = jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
+	/* convert pages-usec to Mbyte-usec */
+	stats->coremem = p->acct_rss_mem1 * PAGE_SIZE / MB;
+	stats->virtmem = p->acct_vm_mem1 * PAGE_SIZE / MB;
 	if (p->mm) {
 		/* adjust to KB unit */
 		stats->hiwater_rss   = p->mm->hiwater_rss * PAGE_SIZE / KB;
@@ -104,12 +104,19 @@ void xacct_add_tsk(struct taskstats *sta
 void acct_update_integrals(struct task_struct *tsk)
 {
 	if (likely(tsk->mm)) {
-		long delta = cputime_to_jiffies(
-			cputime_sub(tsk->stime, tsk->acct_stimexpd));
+		cputime_t time, dtime;
+		struct timeval value;
+		u64 delta;
+
+		time = tsk->stime + tsk->utime;
+		dtime = cputime_sub(time, tsk->acct_timexpd);
+		jiffies_to_timeval(cputime_to_jiffies(dtime), &value);
+		delta = value.tv_sec;
+		delta = delta * USEC_PER_SEC + value.tv_usec;
 
 		if (delta == 0)
 			return;
-		tsk->acct_stimexpd = tsk->stime;
+		tsk->acct_timexpd = time;
 		tsk->acct_rss_mem1 += delta * get_mm_rss(tsk->mm);
 		tsk->acct_vm_mem1 += delta * tsk->mm->total_vm;
 	}
@@ -121,7 +128,7 @@ void acct_update_integrals(struct task_s
  */
 void acct_clear_integrals(struct task_struct *tsk)
 {
-	tsk->acct_stimexpd = 0;
+	tsk->acct_timexpd = 0;
 	tsk->acct_rss_mem1 = 0;
 	tsk->acct_vm_mem1 = 0;
 }
--- a/kernel/sched.c	2008-04-07 15:54:08.000000000 -0700
+++ b/kernel/sched.c	2008-04-18 15:17:27.992000000 -0700
@@ -2531,6 +2531,8 @@ void account_user_time(struct task_struc
 		cpustat->nice = cputime64_add(cpustat->nice, tmp);
 	else
 		cpustat->user = cputime64_add(cpustat->user, tmp);
+	/* Account for user time used */
+	acct_update_integrals(p);
 }
 
 /*
