Return-Path: <linux-kernel-owner+w=401wt.eu-S1760709AbXK1PLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709AbXK1PLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbXK1PK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:10:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56635 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbXK1PKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:10:54 -0500
Date: Wed, 28 Nov 2007 16:10:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler fixes
Message-ID: <20071128151037.GA25751@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

5 commits: a fix from Thomas for a softlockup-detector false positive, 
and 4 small scheduler cleanups.

[ "scripts/checkpatch.pl --file kernel/sched*.[ch]" is now error and 
  warning free in its entirety - using v12 checkpatch.pl. (v11 had a few
  false positives that are fixed in v12) Yay. ]

	Ingo

------------------>
Ingo Molnar (4):
      sched: clean up sd_alloc_ctl_cpu_table() definition
      sched: clean up, move __sched_text_start/end to sched.h
      sched: clean up overlong line in kernel/sched_debug.c
      sched: clean up kernel/sched_stat.h

Thomas Gleixner (1):
      softlockup: fix false positives on CONFIG_NOHZ

 include/linux/sched.h    |    4 ++++
 kernel/sched.c           |    5 +----
 kernel/sched_debug.c     |    8 +++++---
 kernel/sched_stats.h     |    3 ++-
 kernel/time/tick-sched.c |    2 ++
 5 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ee800e7..ac3d496 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -282,6 +282,10 @@ static inline void touch_all_softlockup_watchdogs(void)
 
 /* Attach to any functions which should be ignored in wchan output. */
 #define __sched		__attribute__((__section__(".sched.text")))
+
+/* Linker adds these: start and end of __sched functions */
+extern char __sched_text_start[], __sched_text_end[];
+
 /* Is this address in the __sched functions? */
 extern int in_sched_functions(unsigned long addr);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 38933ca..98dcdf2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5466,7 +5466,7 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 	return table;
 }
 
-static ctl_table * sd_alloc_ctl_cpu_table(int cpu)
+static ctl_table *sd_alloc_ctl_cpu_table(int cpu)
 {
 	struct ctl_table *entry, *table;
 	struct sched_domain *sd;
@@ -6708,9 +6708,6 @@ void __init sched_init_smp(void)
 
 int in_sched_functions(unsigned long addr)
 {
-	/* Linker adds these: start and end of __sched functions */
-	extern char __sched_text_start[], __sched_text_end[];
-
 	return in_lock_functions(addr) ||
 		(addr >= (unsigned long)__sched_text_start
 		&& addr < (unsigned long)__sched_text_end);
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 5d0d623..d30467b 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -327,10 +327,12 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 			avg_atom = -1LL;
 
 		avg_per_cpu = p->se.sum_exec_runtime;
-		if (p->se.nr_migrations)
-			avg_per_cpu = div64_64(avg_per_cpu, p->se.nr_migrations);
-		else
+		if (p->se.nr_migrations) {
+			avg_per_cpu = div64_64(avg_per_cpu,
+					       p->se.nr_migrations);
+		} else {
 			avg_per_cpu = -1LL;
+		}
 
 		__PN(avg_atom);
 		__PN(avg_per_cpu);
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 630178e..5b32433 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -52,7 +52,8 @@ static int show_schedstat(struct seq_file *seq, void *v)
 				    sd->lb_nobusyq[itype],
 				    sd->lb_nobusyg[itype]);
 			}
-			seq_printf(seq, " %u %u %u %u %u %u %u %u %u %u %u %u\n",
+			seq_printf(seq,
+				   " %u %u %u %u %u %u %u %u %u %u %u %u\n",
 			    sd->alb_count, sd->alb_failed, sd->alb_pushed,
 			    sd->sbe_count, sd->sbe_balanced, sd->sbe_pushed,
 			    sd->sbf_count, sd->sbf_balanced, sd->sbf_pushed,
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 27a2338..cb89fa8 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -133,6 +133,8 @@ void tick_nohz_update_jiffies(void)
 	if (!ts->tick_stopped)
 		return;
 
+	touch_softlockup_watchdog();
+
 	cpu_clear(cpu, nohz_cpu_mask);
 	now = ktime_get();
 
