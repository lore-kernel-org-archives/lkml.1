Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbXBFDxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbXBFDxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbXBFDxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:53:17 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:40374 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752673AbXBFDxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:53:11 -0500
Date: Mon, 5 Feb 2007 19:53:09 -0800
Message-Id: <200702060353.l163r9ec000751@zach-dev.vmware.com>
Subject: [PATCH 6/11] Vmi timer no idle hz fixes.patch
From: Zachary Amsden <zach@vmware.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 06 Feb 2007 03:53:09.0292 (UTC) FILETIME=[50D38EC0:01C749A2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the VMI-Timer no-idle-hz code.

Do not setup a one shot alarm if we are keeping the periodic alarm
armed.  Additionally, since the periodic alarm can be run at a lower
rate than HZ, let's fixup the guard to the no-idle-hz mode appropriately.
This fixes the bug where the no-idle-hz mode might have a higher interrupt
rate than the non-idle case.

Signed-off-by: Dan Hecht <dhecht@vmware.com>

diff -r 9d107b81bb7d arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c	Thu Feb 01 23:43:37 2007 -0800
+++ b/arch/i386/kernel/vmitime.c	Thu Feb 01 23:52:59 2007 -0800
@@ -374,7 +374,6 @@ int vmi_stop_hz_timer(void)
 	unsigned long seq, next;
 	unsigned long long real_cycles_expiry;
 	int cpu = smp_processor_id();
-	int idle;
 
 	BUG_ON(!irqs_disabled());
 	if (sysctl_hz_timer != 0)
@@ -382,13 +381,13 @@ int vmi_stop_hz_timer(void)
 
 	cpu_set(cpu, nohz_cpu_mask);
 	smp_mb();
+
 	if (rcu_needs_cpu(cpu) || local_softirq_pending() ||
-	    (next = next_timer_interrupt(), time_before_eq(next, jiffies))) {
+	    (next = next_timer_interrupt(), 
+	     time_before_eq(next, jiffies + HZ/CONFIG_VMI_ALARM_HZ))) {
 		cpu_clear(cpu, nohz_cpu_mask);
-		next = jiffies;
-		idle = 0;
-	} else
-		idle = 1;
+		return 0;
+	}
 
 	/* Convert jiffies to the real cycle counter. */
 	do {
@@ -398,17 +397,13 @@ int vmi_stop_hz_timer(void)
 	} while (read_seqretry(&xtime_lock, seq));
 
 	/* This cpu is going idle. Disable the periodic alarm. */
-	if (idle) {
-		vmi_timer_ops.cancel_alarm(VMI_CYCLES_AVAILABLE);
-		per_cpu(idle_start_jiffies, cpu) = jiffies;
-	}
-
+	vmi_timer_ops.cancel_alarm(VMI_CYCLES_AVAILABLE);
+	per_cpu(idle_start_jiffies, cpu) = jiffies;
 	/* Set the real time alarm to expire at the next event. */
 	vmi_timer_ops.set_alarm(
-		      VMI_ALARM_WIRING | VMI_ALARM_IS_ONESHOT | VMI_CYCLES_REAL,
-		      real_cycles_expiry, 0);
-
-	return idle;
+		VMI_ALARM_WIRING | VMI_ALARM_IS_ONESHOT | VMI_CYCLES_REAL,
+		real_cycles_expiry, 0);
+	return 1;
 }
 
 static void vmi_reenable_hz_timer(int cpu)
diff -r 9d107b81bb7d kernel/sysctl.c
--- a/kernel/sysctl.c	Thu Feb 01 23:43:37 2007 -0800
+++ b/kernel/sysctl.c	Thu Feb 01 23:52:59 2007 -0800
@@ -440,17 +440,7 @@ static ctl_table kern_table[] = {
 		.extra1		= &minolduid,
 		.extra2		= &maxolduid,
 	},
-#ifdef CONFIG_S390
-#ifdef CONFIG_MATHEMU
-	{
-		.ctl_name	= KERN_IEEE_EMULATION_WARNINGS,
-		.procname	= "ieee_emulation_warnings",
-		.data		= &sysctl_ieee_emulation_warnings,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-#endif
+#if defined(CONFIG_S390) || defined(CONFIG_VMI)
 #ifdef CONFIG_NO_IDLE_HZ
 	{
 		.ctl_name       = KERN_HZ_TIMER,
@@ -459,6 +449,18 @@ static ctl_table kern_table[] = {
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
 		.proc_handler   = &proc_dointvec,
+	},
+#endif
+#endif
+#ifdef CONFIG_S390
+#ifdef CONFIG_MATHEMU
+	{
+		.ctl_name	= KERN_IEEE_EMULATION_WARNINGS,
+		.procname	= "ieee_emulation_warnings",
+		.data		= &sysctl_ieee_emulation_warnings,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
 	},
 #endif
 	{
