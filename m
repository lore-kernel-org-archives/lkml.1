Return-Path: <linux-kernel-owner+w=401wt.eu-S935073AbYEBM5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935073AbYEBM5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764363AbYEBM4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:56:50 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50093 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761650AbYEBM4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:56:46 -0400
Date: Fri, 2 May 2008 07:56:44 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] Fix softlockup_thresh unaligned access and disable detection at runtime
Message-ID: <20080502125644.GA31059@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix unaligned access errors when setting softlockup_thresh on
64 bit platforms.

Allow softlockup detection to be disabled by setting
softlockup_thresh <= 0.

Detect that boot time softlockup detection has been disabled
earlier in softlockup_tick.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>


---
 include/linux/sched.h |    2 +-
 kernel/softlockup.c   |   12 ++++++++++--
 kernel/sysctl.c       |    9 +++++----
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 03c2380..d61e9b7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -292,10 +292,10 @@ extern void softlockup_tick(void);
 extern void spawn_softlockup_task(void);
 extern void touch_softlockup_watchdog(void);
 extern void touch_all_softlockup_watchdogs(void);
-extern unsigned long  softlockup_thresh;
 extern unsigned long sysctl_hung_task_check_count;
 extern unsigned long sysctl_hung_task_timeout_secs;
 extern unsigned long sysctl_hung_task_warnings;
+extern int softlockup_thresh;
 #else
 static inline void softlockup_tick(void)
 {
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 01b6522..ef60e7c 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -25,7 +25,7 @@ static DEFINE_PER_CPU(unsigned long, print_timestamp);
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
 
 static int __read_mostly did_panic;
-unsigned long __read_mostly softlockup_thresh = 60;
+int __read_mostly softlockup_thresh = 60;
 
 static int
 softlock_panic(struct notifier_block *this, unsigned long event, void *ptr)
@@ -79,6 +79,14 @@ void softlockup_tick(void)
 	struct pt_regs *regs = get_irq_regs();
 	unsigned long now;
 
+	/* Is detection switched off? */
+	if (!per_cpu(watchdog_task, this_cpu) || softlockup_thresh <= 0) {
+		/* Be sure we don't false trigger if switched back on */
+		if (touch_timestamp)
+			per_cpu(touch_timestamp, this_cpu) = 0;
+		return;
+	}
+
 	if (touch_timestamp == 0) {
 		touch_softlockup_watchdog();
 		return;
@@ -89,7 +97,7 @@ void softlockup_tick(void)
 	/* report at most once a second */
 	if ((print_timestamp >= touch_timestamp &&
 			print_timestamp < (touch_timestamp + 1)) ||
-			did_panic || !per_cpu(watchdog_task, this_cpu)) {
+			did_panic) {
 		return;
 	}
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d7ffdc5..d68c77a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -83,12 +83,13 @@ extern int sysctl_stat_interval;
 extern int latencytop_enabled;
 
 /* Constants used for minimum and  maximum */
-#if defined(CONFIG_DETECT_SOFTLOCKUP) || defined(CONFIG_HIGHMEM)
+#ifdef CONFIG_HIGHMEM
 static int one = 1;
 #endif
 
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 static int sixty = 60;
+static int neg_one = -1;
 #endif
 
 #ifdef CONFIG_MMU
@@ -730,11 +731,11 @@ static struct ctl_table kern_table[] = {
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "softlockup_thresh",
 		.data		= &softlockup_thresh,
-		.maxlen		= sizeof(unsigned long),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= &proc_dointvec_minmax,
 		.strategy	= &sysctl_intvec,
-		.extra1		= &one,
+		.extra1		= &neg_one,
 		.extra2		= &sixty,
 	},
 	{
-- 
1.5.4.rc3

