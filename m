Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYDWUQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYDWUQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 16:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbYDWUQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 16:16:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:60914 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752272AbYDWUQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 16:16:16 -0400
Date: Wed, 23 Apr 2008 15:16:13 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] disable softlockup detection at boottime
Message-ID: <20080423201613.GA8546@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows softlockup detection to be disabled by specifying
a boottime parameter.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

Index: linux/kernel/softlockup.c
===================================================================
--- linux.orig/kernel/softlockup.c	2008-04-23 13:50:06.000000000 -0500
+++ linux/kernel/softlockup.c	2008-04-23 14:39:36.267398531 -0500
@@ -24,6 +24,7 @@ static DEFINE_PER_CPU(unsigned long, tou
 static DEFINE_PER_CPU(unsigned long, print_timestamp);
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
 
+static int __read_mostly softlockup_off;
 static int __read_mostly did_panic;
 unsigned long __read_mostly softlockup_thresh = 60;
 
@@ -53,7 +54,8 @@ void touch_softlockup_watchdog(void)
 {
 	int this_cpu = raw_smp_processor_id();
 
-	__raw_get_cpu_var(touch_timestamp) = get_timestamp(this_cpu);
+	if (!softlockup_off)
+		__raw_get_cpu_var(touch_timestamp) = get_timestamp(this_cpu);
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -61,6 +63,9 @@ void touch_all_softlockup_watchdogs(void
 {
 	int cpu;
 
+	if (softlockup_off)
+		return;
+
 	/* Cause each CPU to re-update its timestamp rather than complain */
 	for_each_online_cpu(cpu)
 		per_cpu(touch_timestamp, cpu) = 0;
@@ -79,6 +84,9 @@ void softlockup_tick(void)
 	struct pt_regs *regs = get_irq_regs();
 	unsigned long now;
 
+	if (softlockup_off)
+		return;
+
 	if (touch_timestamp == 0) {
 		touch_softlockup_watchdog();
 		return;
@@ -306,9 +314,19 @@ __init void spawn_softlockup_task(void)
 	void *cpu = (void *)(long)smp_processor_id();
 	int err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
 
+	if (softlockup_off)
+		return;
+
 	BUG_ON(err == NOTIFY_BAD);
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
 
 	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
 }
+
+static int __init disable_softlockup_detection(char *str)
+{
+	softlockup_off = 1;
+	return 1;
+}
+__setup("nosoftlockup", disable_softlockup_detection);
