Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbZBGBWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbZBGBWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 20:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZBGBWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 20:22:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:51010 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbZBGBWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 20:22:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:x-operating-system:user-agent:
	x-gmailtapped-by:x-gmailtapped;
	b=xWDaEQoHRtR2NEHVciILFm1DcQafI3Nxvs4UfhC+M6Zci8i6edJCJdFSLuspnX0s2
	njGLrJHjQt13Ihu07ZyFA==
Date: Fri, 6 Feb 2009 15:37:47 -0800
From: Mandeep Singh Baines <msb@google.com>
To: mingo@elte.hu, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, rientjes@google.com, mbligh@google.com,
       thockin@google.com, akpm@linux-foundation.org
Subject: [PATCH] softlockup: remove timestamp checking from hung_task
Message-ID: <20090206233747.GA8747@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.28.16.76
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch against tip/core/softlockup

---
Impact: saves sizeof(long) bytes per task_struct

By guaranteeing that sysctl_hung_task_timeout_secs have elapsed between
tasklist scans we can avoid using timestamps.

Signed-off-by: Mandeep Singh Baines <msb@google.com>
---
 include/linux/sched.h |    1 -
 kernel/fork.c         |    8 +++-----
 kernel/hung_task.c    |   48 +++++++++---------------------------------------
 3 files changed, 12 insertions(+), 45 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2a2811c..e0d723f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1241,7 +1241,6 @@ struct task_struct {
 #endif
 #ifdef CONFIG_DETECT_HUNG_TASK
 /* hung task detection */
-	unsigned long last_switch_timestamp;
 	unsigned long last_switch_count;
 #endif
 /* CPU-specific state of this task */
diff --git a/kernel/fork.c b/kernel/fork.c
index fb94442..bf582f7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -639,6 +639,9 @@ static int copy_mm(unsigned long clone_flags, struct task_struct * tsk)
 
 	tsk->min_flt = tsk->maj_flt = 0;
 	tsk->nvcsw = tsk->nivcsw = 0;
+#ifdef CONFIG_DETECT_HUNG_TASK
+	tsk->last_switch_count = tsk->nvcsw + tsk->nivcsw;
+#endif
 
 	tsk->mm = NULL;
 	tsk->active_mm = NULL;
@@ -1041,11 +1044,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	p->default_timer_slack_ns = current->timer_slack_ns;
 
-#ifdef CONFIG_DETECT_HUNG_TASK
-	p->last_switch_count = 0;
-	p->last_switch_timestamp = 0;
-#endif
-
 	task_io_accounting_init(&p->ioac);
 	acct_clear_integrals(p);
 
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 3951a80..4a10756 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -34,7 +34,6 @@ unsigned long __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
  * Zero means infinite timeout - no checking done:
  */
 unsigned long __read_mostly sysctl_hung_task_timeout_secs = 120;
-static unsigned long __read_mostly hung_task_poll_jiffies;
 
 unsigned long __read_mostly sysctl_hung_task_warnings = 10;
 
@@ -69,33 +68,17 @@ static struct notifier_block panic_block = {
 	.notifier_call = hung_task_panic,
 };
 
-/*
- * Returns seconds, approximately.  We don't need nanosecond
- * resolution, and we don't need to waste time with a big divide when
- * 2^30ns == 1.074s.
- */
-static unsigned long get_timestamp(void)
-{
-	int this_cpu = raw_smp_processor_id();
-
-	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
-}
-
-static void check_hung_task(struct task_struct *t, unsigned long now,
-			    unsigned long timeout)
+static void check_hung_task(struct task_struct *t, unsigned long timeout)
 {
 	unsigned long switch_count = t->nvcsw + t->nivcsw;
 
 	if (t->flags & PF_FROZEN)
 		return;
 
-	if (switch_count != t->last_switch_count || !t->last_switch_timestamp) {
+	if (switch_count != t->last_switch_count) {
 		t->last_switch_count = switch_count;
-		t->last_switch_timestamp = now;
 		return;
 	}
-	if ((long)(now - t->last_switch_timestamp) < timeout)
-		return;
 	if (!sysctl_hung_task_warnings)
 		return;
 	sysctl_hung_task_warnings--;
@@ -111,7 +94,6 @@ static void check_hung_task(struct task_struct *t, unsigned long now,
 	sched_show_task(t);
 	__debug_show_held_locks(t);
 
-	t->last_switch_timestamp = now;
 	touch_nmi_watchdog();
 
 	if (sysctl_hung_task_panic)
@@ -145,7 +127,6 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 {
 	int max_count = sysctl_hung_task_check_count;
 	int batch_count = HUNG_TASK_BATCHING;
-	unsigned long now = get_timestamp();
 	struct task_struct *g, *t;
 
 	/*
@@ -168,19 +149,16 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 		}
 		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
 		if (t->state == TASK_UNINTERRUPTIBLE)
-			check_hung_task(t, now, timeout);
+			check_hung_task(t, timeout);
 	} while_each_thread(g, t);
  unlock:
 	rcu_read_unlock();
 }
 
-static void update_poll_jiffies(void)
+static unsigned long timeout_jiffies(unsigned long timeout)
 {
 	/* timeout of 0 will disable the watchdog */
-	if (sysctl_hung_task_timeout_secs == 0)
-		hung_task_poll_jiffies = MAX_SCHEDULE_TIMEOUT;
-	else
-		hung_task_poll_jiffies = sysctl_hung_task_timeout_secs * HZ / 2;
+	return (timeout ? timeout * HZ : MAX_SCHEDULE_TIMEOUT);
 }
 
 /*
@@ -197,8 +175,6 @@ int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
 	if (ret || !write)
 		goto out;
 
-	update_poll_jiffies();
-
 	wake_up_process(watchdog_task);
 
  out:
@@ -211,20 +187,14 @@ int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
 static int watchdog(void *dummy)
 {
 	set_user_nice(current, 0);
-	update_poll_jiffies();
 
 	for ( ; ; ) {
-		unsigned long timeout;
+		unsigned long timeout = sysctl_hung_task_timeout_secs;
 
-		while (schedule_timeout_interruptible(hung_task_poll_jiffies));
+		while (schedule_timeout_interruptible(timeout_jiffies(timeout)))
+			timeout = sysctl_hung_task_timeout_secs;
 
-		/*
-		 * Need to cache timeout here to avoid timeout being set
-		 * to 0 via sysctl while inside check_hung_*_tasks().
-		 */
-		timeout = sysctl_hung_task_timeout_secs;
-		if (timeout)
-			check_hung_uninterruptible_tasks(timeout);
+		check_hung_uninterruptible_tasks(timeout);
 	}
 
 	return 0;
-- 
1.5.4.5

