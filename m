Return-Path: <linux-kernel-owner+w=401wt.eu-S937566AbYEBXph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937566AbYEBXph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937431AbYEBXpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:45:13 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:55132 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937398AbYEBXpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:45:11 -0400
Message-ID: <481BA784.5050908@ct.jp.nec.com>
Date: Fri, 02 May 2008 16:45:08 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_32: use per_cpu data
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

use per_cpu for per CPU data.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/nmi_32.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index 11b14bb..69bdae5 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -293,9 +293,9 @@ void stop_apic_nmi_watchdog(void *unused)
  *  here too!]
  */
 
-static unsigned int
-	last_irq_sums [NR_CPUS],
-	alert_counter [NR_CPUS];
+static DEFINE_PER_CPU(unsigned, last_irq_sum);
+static DEFINE_PER_CPU(local_t, alert_counter);
+static DEFINE_PER_CPU(int, nmi_touch);
 
 void touch_nmi_watchdog(void)
 {
@@ -303,12 +303,13 @@ void touch_nmi_watchdog(void)
 		unsigned cpu;
 
 		/*
-		 * Just reset the alert counters, (other CPUs might be
-		 * spinning on locks we hold):
+		 * Tell other CPUs to reset their alert counters. We cannot
+		 * do it ourselves because the alert count increase is not
+		 * atomic.
 		 */
 		for_each_present_cpu(cpu) {
-			if (alert_counter[cpu])
-				alert_counter[cpu] = 0;
+			if (per_cpu(nmi_touch, cpu) != 1)
+				per_cpu(nmi_touch, cpu) = 1;
 		}
 	}
 
@@ -358,22 +359,26 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 	 */
 	sum = per_cpu(irq_stat, cpu).apic_timer_irqs +
 		per_cpu(irq_stat, cpu).irq0_irqs;
+	if (__get_cpu_var(nmi_touch)) {
+		__get_cpu_var(nmi_touch) = 0;
+		touched = 1;
+	}
 
 	/* if the none of the timers isn't firing, this cpu isn't doing much */
-	if (!touched && last_irq_sums[cpu] == sum) {
+	if (!touched && __get_cpu_var(last_irq_sum) == sum) {
 		/*
 		 * Ayiee, looks like this CPU is stuck ...
 		 * wait a few IRQs (5 seconds) before doing the oops ...
 		 */
-		alert_counter[cpu]++;
-		if (alert_counter[cpu] == 5*nmi_hz)
+		local_inc(&__get_cpu_var(alert_counter));
+		if (local_read(&__get_cpu_var(alert_counter)) == 5*nmi_hz)
 			/*
 			 * die_nmi will return ONLY if NOTIFY_STOP happens..
 			 */
 			die_nmi(regs, "BUG: NMI Watchdog detected LOCKUP");
 	} else {
-		last_irq_sums[cpu] = sum;
-		alert_counter[cpu] = 0;
+		__get_cpu_var(last_irq_sum) = sum;
+		local_set(&__get_cpu_var(alert_counter), 0);
 	}
 	/* see if the nmi watchdog went off */
 	if (!__get_cpu_var(wd_enabled))
-- 
1.5.4.1

