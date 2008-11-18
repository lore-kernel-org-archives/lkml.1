Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbYKRORs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbYKRORs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYKRORk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:17:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47928 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbYKRORj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:17:39 -0500
Date: Tue, 18 Nov 2008 15:17:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20081118141727.GA27292@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Adrian Knoth (1):
      sched: correct sched-rt-group.txt pathname in init/Kconfig

Ingo Molnar (1):
      sched: fix kernel warning on /proc/sched_debug access

Li Zefan (1):
      cpuset: fix regression when failed to generate sched domains

Oleg Nesterov (1):
      sched, signals: fix the racy usage of ->signal in account_group_xxx/run_posix_cpu_timers


 init/Kconfig              |    2 +-
 kernel/cpuset.c           |   12 ++++++++----
 kernel/posix-cpu-timers.c |    7 +++++--
 kernel/sched.c            |   13 +++++++------
 kernel/sched_debug.c      |    5 +++--
 kernel/sched_stats.h      |   15 +++++++++++----
 6 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 86b00c5..2f850d8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -354,7 +354,7 @@ config RT_GROUP_SCHED
 	  setting below. If enabled, it will also make it impossible to
 	  schedule realtime tasks for non-root users until you allocate
 	  realtime bandwidth for them.
-	  See Documentation/sched-rt-group.txt for more information.
+	  See Documentation/scheduler/sched-rt-group.txt for more information.
 
 choice
 	depends on GROUP_SCHED
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3e00526..81fc679 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -587,7 +587,6 @@ static int generate_sched_domains(cpumask_t **domains,
 	int ndoms;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] cpumask_t slot */
 
-	ndoms = 0;
 	doms = NULL;
 	dattr = NULL;
 	csa = NULL;
@@ -674,10 +673,8 @@ restart:
 	 * Convert <csn, csa> to <ndoms, doms> and populate cpu masks.
 	 */
 	doms = kmalloc(ndoms * sizeof(cpumask_t), GFP_KERNEL);
-	if (!doms) {
-		ndoms = 0;
+	if (!doms)
 		goto done;
-	}
 
 	/*
 	 * The rest of the code, including the scheduler, can deal with
@@ -732,6 +729,13 @@ restart:
 done:
 	kfree(csa);
 
+	/*
+	 * Fallback to the default domain if kmalloc() failed.
+	 * See comments in partition_sched_domains().
+	 */
+	if (doms == NULL)
+		ndoms = 1;
+
 	*domains    = doms;
 	*attributes = dattr;
 	return ndoms;
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 153dcb2..895337b 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1308,9 +1308,10 @@ static inline int task_cputime_expired(const struct task_cputime *sample,
  */
 static inline int fastpath_timer_check(struct task_struct *tsk)
 {
-	struct signal_struct *sig = tsk->signal;
+	struct signal_struct *sig;
 
-	if (unlikely(!sig))
+	/* tsk == current, ensure it is safe to use ->signal/sighand */
+	if (unlikely(tsk->exit_state))
 		return 0;
 
 	if (!task_cputime_zero(&tsk->cputime_expires)) {
@@ -1323,6 +1324,8 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 		if (task_cputime_expired(&task_sample, &tsk->cputime_expires))
 			return 1;
 	}
+
+	sig = tsk->signal;
 	if (!task_cputime_zero(&sig->cputime_expires)) {
 		struct task_cputime group_sample;
 
diff --git a/kernel/sched.c b/kernel/sched.c
index c94baf2..9b1e793 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7789,13 +7789,14 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
  *
  * The passed in 'doms_new' should be kmalloc'd. This routine takes
  * ownership of it and will kfree it when done with it. If the caller
- * failed the kmalloc call, then it can pass in doms_new == NULL,
- * and partition_sched_domains() will fallback to the single partition
- * 'fallback_doms', it also forces the domains to be rebuilt.
+ * failed the kmalloc call, then it can pass in doms_new == NULL &&
+ * ndoms_new == 1, and partition_sched_domains() will fallback to
+ * the single partition 'fallback_doms', it also forces the domains
+ * to be rebuilt.
  *
- * If doms_new==NULL it will be replaced with cpu_online_map.
- * ndoms_new==0 is a special case for destroying existing domains.
- * It will not create the default domain.
+ * If doms_new == NULL it will be replaced with cpu_online_map.
+ * ndoms_new == 0 is a special case for destroying existing domains,
+ * and it will not create the default domain.
  *
  * Call with hotplug lock held
  */
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 48ecc51..26ed8e3 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -423,10 +423,11 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 #undef __P
 
 	{
+		unsigned int this_cpu = raw_smp_processor_id();
 		u64 t0, t1;
 
-		t0 = sched_clock();
-		t1 = sched_clock();
+		t0 = cpu_clock(this_cpu);
+		t1 = cpu_clock(this_cpu);
 		SEQ_printf(m, "%-35s:%21Ld\n",
 			   "clock-delta", (long long)(t1-t0));
 	}
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index ee71bec..7dbf72a 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -298,9 +298,11 @@ static inline void account_group_user_time(struct task_struct *tsk,
 {
 	struct signal_struct *sig;
 
-	sig = tsk->signal;
-	if (unlikely(!sig))
+	/* tsk == current, ensure it is safe to use ->signal */
+	if (unlikely(tsk->exit_state))
 		return;
+
+	sig = tsk->signal;
 	if (sig->cputime.totals) {
 		struct task_cputime *times;
 
@@ -325,9 +327,11 @@ static inline void account_group_system_time(struct task_struct *tsk,
 {
 	struct signal_struct *sig;
 
-	sig = tsk->signal;
-	if (unlikely(!sig))
+	/* tsk == current, ensure it is safe to use ->signal */
+	if (unlikely(tsk->exit_state))
 		return;
+
+	sig = tsk->signal;
 	if (sig->cputime.totals) {
 		struct task_cputime *times;
 
@@ -353,8 +357,11 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
 	struct signal_struct *sig;
 
 	sig = tsk->signal;
+	/* see __exit_signal()->task_rq_unlock_wait() */
+	barrier();
 	if (unlikely(!sig))
 		return;
+
 	if (sig->cputime.totals) {
 		struct task_cputime *times;
 
