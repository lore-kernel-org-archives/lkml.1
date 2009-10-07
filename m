Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbZJGXNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbZJGXNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 19:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbZJGXNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 19:13:36 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:46817 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754882AbZJGXNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 19:13:36 -0400
Date: Wed, 7 Oct 2009 19:04:29 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>
Subject: [Patch vs. percpu-next] Use this_cpu_xx in nmi handling
Message-ID: <alpine.DEB.1.10.0910071856400.3379@gentwo.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux-foundation.org>
Subject: Use this_cpu_xx in nmi handling

this_cpu_inc/dec reduces the number of instructions needed.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>


---
 arch/sparc/kernel/nmi.c    |    8 ++++----
 arch/x86/kernel/apic/nmi.c |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/sparc/kernel/nmi.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/nmi.c	2009-10-07 16:58:11.000000000 -0500
+++ linux-2.6/arch/sparc/kernel/nmi.c	2009-10-07 17:12:35.000000000 -0500
@@ -47,7 +47,7 @@ static DEFINE_PER_CPU(short, wd_enabled)
 static int endflag __initdata;

 static DEFINE_PER_CPU(unsigned int, last_irq_sum);
-static DEFINE_PER_CPU(local_t, alert_counter);
+static DEFINE_PER_CPU(long, alert_counter);
 static DEFINE_PER_CPU(int, nmi_touch);

 void touch_nmi_watchdog(void)
@@ -112,13 +112,13 @@ notrace __kprobes void perfctr_irq(int i
 		touched = 1;
 	}
 	if (!touched && __get_cpu_var(last_irq_sum) == sum) {
-		local_inc(&__get_cpu_var(alert_counter));
-		if (local_read(&__get_cpu_var(alert_counter)) == 30 * nmi_hz)
+		__this_cpu_inc(per_cpu_var(alert_counter));
+		if (__this_cpu_read(per_cpu_var(alert_counter)) == 30 * nmi_hz)
 			die_nmi("BUG: NMI Watchdog detected LOCKUP",
 				regs, panic_on_timeout);
 	} else {
 		__get_cpu_var(last_irq_sum) = sum;
-		local_set(&__get_cpu_var(alert_counter), 0);
+		__this_cpu_write(per_cpu_var(alert_counter), 0);
 	}
 	if (__get_cpu_var(wd_enabled)) {
 		write_pic(picl_value(nmi_hz));
Index: linux-2.6/arch/x86/kernel/apic/nmi.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/nmi.c	2009-10-07 16:56:39.000000000 -0500
+++ linux-2.6/arch/x86/kernel/apic/nmi.c	2009-10-07 16:58:02.000000000 -0500
@@ -360,7 +360,7 @@ void stop_apic_nmi_watchdog(void *unused
  */

 static DEFINE_PER_CPU(unsigned, last_irq_sum);
-static DEFINE_PER_CPU(local_t, alert_counter);
+static DEFINE_PER_CPU(long, alert_counter);
 static DEFINE_PER_CPU(int, nmi_touch);

 void touch_nmi_watchdog(void)
@@ -437,8 +437,8 @@ nmi_watchdog_tick(struct pt_regs *regs,
 		 * Ayiee, looks like this CPU is stuck ...
 		 * wait a few IRQs (5 seconds) before doing the oops ...
 		 */
-		local_inc(&__get_cpu_var(alert_counter));
-		if (local_read(&__get_cpu_var(alert_counter)) == 5 * nmi_hz)
+		__this_cpu_inc(per_cpu_var(alert_counter));
+		if (__this_cpu_read(per_cpu_var(alert_counter)) == 5 * nmi_hz)
 			/*
 			 * die_nmi will return ONLY if NOTIFY_STOP happens..
 			 */
@@ -446,7 +446,7 @@ nmi_watchdog_tick(struct pt_regs *regs,
 				regs, panic_on_timeout);
 	} else {
 		__get_cpu_var(last_irq_sum) = sum;
-		local_set(&__get_cpu_var(alert_counter), 0);
+		__this_cpu_write(per_cpu_var(alert_counter), 0);
 	}

 	/* see if the nmi watchdog went off */
