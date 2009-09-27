Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbZI0Fty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbZI0Fty (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 01:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZI0Fty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 01:49:54 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:58020 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbZI0Ftx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 01:49:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=bQy9GaH0iQW1haeGt/deu0hfkI+Wwd3YArOSYP4+P7B2BfVM7fyfGv9qHcLIZv9DnK
         ZH6FRWJ97C2UimL8C49ldcgT2XLH5MRPIpNBrLfLy+2wmWfLlIfArFIXO1JiskgYkOSA
         JJv/+nrip2zm7qjK4qkiYuYax1Erav76IV3sE=
Message-ID: <4ABEFCFE.3080500@gmail.com>
Date: Sun, 27 Sep 2009 13:49:50 +0800
From: Jia Zhang <jia.zhang2008@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] softlockup: keep current softlockup period before touching
 timestamp
Content-Type: text/plain; charset=x-gbk
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jia Zhang <jia.zhang2008@gmail.com>

Imaging such a scenario, softlockup deadline is 60s and a softirq runs
at most 65s. Assume that currently that softirq runs 50s. At this moment,
issue a "echo 40 > /proc/sys/kernel/softlockup_thresh" and thus lead to
recounting the timeout. The remaining time for that softirq is 15s less
than new threshold 40s, which means the warning will be depressed after
15s. It is not what we expected because softlockup actually feeds
100s(old+new) for that softirq. To fix this problem, softlockup should
keep current softlockup period before touching timestamp.

Signed-off-by: Jia Zhang <jia.zhang2008@gmail.com>
---
 include/linux/sched.h |    5 +----
 kernel/softlockup.c   |   26 ++++++++++++++------------
 kernel/sysctl.c       |    2 +-
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 848d1f2..6583f6a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -308,10 +308,7 @@ extern void sched_show_task(struct task_struct *p);
 extern void softlockup_tick(void);
 extern void touch_softlockup_watchdog(void);
 extern void touch_all_softlockup_watchdogs(void);
-extern int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
-				    struct file *filp, void __user *buffer,
-				    size_t *lenp, loff_t *ppos);
-extern unsigned int  softlockup_panic;
+extern unsigned int softlockup_panic;
 extern int softlockup_thresh;
 #else
 static inline void softlockup_tick(void)
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 88796c3..2ffd34b 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -4,7 +4,7 @@
  * started by Ingo Molnar, Copyright (C) 2005, 2006 Red Hat, Inc.
  *
  * this code detects soft lockups: incidents in where on a CPU
- * the kernel does not reschedule for 10 seconds or more.
+ * the kernel does not reschedule for at most 60 seconds.
  */
 #include <linux/mm.h>
 #include <linux/cpu.h>
@@ -22,6 +22,7 @@
 
 static DEFINE_SPINLOCK(print_lock);
 
+static DEFINE_PER_CPU(int, softlockup_thresh);
 static DEFINE_PER_CPU(unsigned long, touch_timestamp);
 static DEFINE_PER_CPU(unsigned long, print_timestamp);
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
@@ -71,6 +72,7 @@ static void __touch_softlockup_watchdog(void)
 	int this_cpu = raw_smp_processor_id();
 
 	__raw_get_cpu_var(touch_timestamp) = get_timestamp(this_cpu);
+	__raw_get_cpu_var(softlockup_thresh) = softlockup_thresh;
 }
 
 void touch_softlockup_watchdog(void)
@@ -89,14 +91,6 @@ void touch_all_softlockup_watchdogs(void)
 }
 EXPORT_SYMBOL(touch_all_softlockup_watchdogs);
 
-int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
-			     struct file *filp, void __user *buffer,
-			     size_t *lenp, loff_t *ppos)
-{
-	touch_all_softlockup_watchdogs();
-	return proc_dointvec_minmax(table, write, filp, buffer, lenp, ppos);
-}
-
 /*
  * This callback runs from the timer interrupt, and checks
  * whether the watchdog thread has hung or not:
@@ -108,9 +102,16 @@ void softlockup_tick(void)
 	unsigned long print_timestamp;
 	struct pt_regs *regs = get_irq_regs();
 	unsigned long now;
+	int new_thresh = softlockup_thresh;
+	int cur_thresh = per_cpu(softlockup_thresh, this_cpu);
 
+	if (unlikely(new_thresh > cur_thresh)) {
+		cur_thresh = new_thresh;	
+		per_cpu(softlockup_thresh, this_cpu) = new_thresh;
+	}
+	
 	/* Is detection switched off? */
-	if (!per_cpu(watchdog_task, this_cpu) || softlockup_thresh <= 0) {
+	if (unlikely(!per_cpu(watchdog_task, this_cpu) || cur_thresh <= 0)) {
 		/* Be sure we don't false trigger if switched back on */
 		if (touch_timestamp)
 			per_cpu(touch_timestamp, this_cpu) = 0;
@@ -140,11 +141,11 @@ void softlockup_tick(void)
 	 * Wake up the high-prio watchdog task twice per
 	 * threshold timespan.
 	 */
-	if (now > touch_timestamp + softlockup_thresh/2)
+	if (now > touch_timestamp + cur_thresh/2)
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
 
 	/* Warn about unreasonable delays: */
-	if (now <= (touch_timestamp + softlockup_thresh))
+	if (now <= (touch_timestamp + cur_thresh))
 		return;
 
 	per_cpu(print_timestamp, this_cpu) = touch_timestamp;
@@ -215,6 +216,7 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			printk(KERN_ERR "watchdog for %i failed\n", hotcpu);
 			return NOTIFY_BAD;
 		}
+		per_cpu(softlockup_thresh, hotcpu) = softlockup_thresh;
 		per_cpu(touch_timestamp, hotcpu) = 0;
 		per_cpu(watchdog_task, hotcpu) = p;
 		kthread_bind(p, hotcpu);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 7f4f57b..89bfadd 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -876,7 +876,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &softlockup_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dosoftlockup_thresh,
+		.proc_handler	= &proc_dointvec_minmax,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &neg_one,
 		.extra2		= &sixty,
-- 
1.6.0.4
