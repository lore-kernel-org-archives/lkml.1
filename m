Return-Path: <linux-kernel-owner+w=401wt.eu-S1762076AbXH1VjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762076AbXH1VjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 17:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbXH1ViO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 17:38:14 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:64975 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752938AbXH1ViJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 17:38:09 -0400
Message-Id: <20070828213802.338192076@mvista.com>
References: <20070828213748.790253419@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 14:37:56 -0700
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Content-Disposition: inline; filename=fix-idle-latency-tracing.patch
Subject: [PATCH -rt 8/8] stop critical timing in idle.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

without this the idle routine still gets traced.. This is done already
for ACPI idle , but it should also be done for other idle routines.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
 
---
 arch/i386/kernel/process.c   |    9 +++++++++
 arch/x86_64/kernel/process.c |   10 ++++++++++
 2 files changed, 19 insertions(+)

Index: linux-2.6.22/arch/i386/kernel/process.c
===================================================================
--- linux-2.6.22.orig/arch/i386/kernel/process.c
+++ linux-2.6.22/arch/i386/kernel/process.c
@@ -197,8 +197,17 @@ void cpu_idle(void)
 			if (cpu_is_offline(cpu))
 				play_dead();
 
+			/*
+			 * We have irqs disabled here, so stop latency tracing
+			 * at this point and restart it after we return:
+			 */
+			stop_critical_timing();
+
 			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
 			idle();
+
+ 			touch_critical_timing();
+
 		}
 		local_irq_disable();
 		trace_preempt_exit_idle();
Index: linux-2.6.22/arch/x86_64/kernel/process.c
===================================================================
--- linux-2.6.22.orig/arch/x86_64/kernel/process.c
+++ linux-2.6.22/arch/x86_64/kernel/process.c
@@ -223,8 +223,18 @@ void cpu_idle (void)
 			 * Otherwise, idle callbacks can misfire.
 			 */
 			local_irq_disable();
+
+			/*
+			 * We have irqs disabled here, so stop latency tracing
+			 * at this point and restart it after we return:
+			 */
+			stop_critical_timing();
+
 			enter_idle();
 			idle();
+
+			touch_critical_timing();
+
 			/* In many cases the interrupt that ended idle
 			   has already called exit_idle. But some idle
 			   loops can be woken up without interrupt. */

-- 
