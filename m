Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbZEOGSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbZEOGSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 02:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZEOGSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 02:18:32 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:16871 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbZEOGSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 02:18:31 -0400
Date: Fri, 15 May 2009 02:18:25 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Janne Kulmala <janne.t.kulmala@tut.fi>, Frans Pop <elendil@planet.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       johnstul@us.ibm.com, linux-acpi@vger.kernel.org
Subject: [PATCH] ACPI: idle: rename lapic timer workaround routines
In-reply-to: <alpine.LFD.2.00.0905150138001.10065@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0905150217220.4995@localhost.localdomain>
References: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com>
 <200905110226.50115.elendil@planet.nl>
 <alpine.LFD.2.00.0905111614570.3561@localhost.localdomain>
 <4A0855A5.8040109@tut.fi>
 <alpine.LFD.2.00.0905141545280.24833@localhost.localdomain>
 <alpine.LFD.2.00.0905141608070.24833@localhost.localdomain>
 <alpine.LFD.2.00.0905142217340.3561@localhost.localdomain>
 <alpine.LFD.2.00.0905141750100.24833@localhost.localdomain>
 <alpine.LFD.2.00.0905150138001.10065@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

cosmetic only.  The lapic_timer workaround routines
are specific to the lapic_timer, and are not acpi-generic.

old:

acpi_timer_check_state()
acpi_propagate_timer_broadcast()
acpi_state_timer_broadcast()

new:

lapic_timer_check_state()
lapic_timer_propagate_broadcast()
lapic_timer_state_broadcast()

also, simplify the code in acpi_processor_power_verify()
so that lapic_timer_check_state() is simply called
from one place for all valid C-states, including C1.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_idle.c |   35 ++++++++++++++++-------------------
 1 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index e65476f..60c3bcd 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -139,7 +139,7 @@ static void acpi_safe_halt(void)
  * are affected too. We pick the most conservative approach: we assume
  * that the local APIC stops in both C2 and C3.
  */
-static void acpi_timer_check_state(int state, struct acpi_processor *pr,
+static void lapic_timer_check_state(int state, struct acpi_processor *pr,
 				   struct acpi_processor_cx *cx)
 {
 	struct acpi_processor_power *pwr = &pr->power;
@@ -159,7 +159,7 @@ static void acpi_timer_check_state(int state, struct acpi_processor *pr,
 		pr->power.timer_broadcast_on_state = state;
 }
 
-static void acpi_propagate_timer_broadcast(struct acpi_processor *pr)
+static void lapic_timer_propagate_broadcast(struct acpi_processor *pr)
 {
 	unsigned long reason;
 
@@ -170,7 +170,7 @@ static void acpi_propagate_timer_broadcast(struct acpi_processor *pr)
 }
 
 /* Power(C) State timer broadcast control */
-static void acpi_state_timer_broadcast(struct acpi_processor *pr,
+static void lapic_timer_state_broadcast(struct acpi_processor *pr,
 				       struct acpi_processor_cx *cx,
 				       int broadcast)
 {
@@ -187,10 +187,10 @@ static void acpi_state_timer_broadcast(struct acpi_processor *pr,
 
 #else
 
-static void acpi_timer_check_state(int state, struct acpi_processor *pr,
+static void lapic_timer_check_state(int state, struct acpi_processor *pr,
 				   struct acpi_processor_cx *cstate) { }
-static void acpi_propagate_timer_broadcast(struct acpi_processor *pr) { }
-static void acpi_state_timer_broadcast(struct acpi_processor *pr,
+static void lapic_timer_propagate_broadcast(struct acpi_processor *pr) { }
+static void lapic_timer_state_broadcast(struct acpi_processor *pr,
 				       struct acpi_processor_cx *cx,
 				       int broadcast)
 {
@@ -592,24 +592,21 @@ static int acpi_processor_power_verify(struct acpi_processor *pr)
 
 		case ACPI_STATE_C2:
 			acpi_processor_power_verify_c2(cx);
-			if (cx->valid)
-				acpi_timer_check_state(i, pr, cx);
 			break;
 
 		case ACPI_STATE_C3:
 			acpi_processor_power_verify_c3(pr, cx);
-			if (cx->valid)
-				acpi_timer_check_state(i, pr, cx);
 			break;
 		}
-		if (cx->valid)
-			tsc_check_state(cx->type);
+		if (!cx->valid)
+			continue;
 
-		if (cx->valid)
-			working++;
+		lapic_timer_check_state(i, pr, cx);
+		tsc_check_state(cx->type);
+		working++;
 	}
 
-	acpi_propagate_timer_broadcast(pr);
+	lapic_timer_propagate_broadcast(pr);
 
 	return (working);
 }
@@ -863,7 +860,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	 * Must be done before busmaster disable as we might need to
 	 * access HPET !
 	 */
-	acpi_state_timer_broadcast(pr, cx, 1);
+	lapic_timer_state_broadcast(pr, cx, 1);
 
 	if (cx->type == ACPI_STATE_C3)
 		ACPI_FLUSH_CPU_CACHE();
@@ -885,7 +882,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 
 	cx->usage++;
 
-	acpi_state_timer_broadcast(pr, cx, 0);
+	lapic_timer_state_broadcast(pr, cx, 0);
 	cx->time += sleep_ticks;
 	return idle_time;
 }
@@ -952,7 +949,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	 * Must be done before busmaster disable as we might need to
 	 * access HPET !
 	 */
-	acpi_state_timer_broadcast(pr, cx, 1);
+	lapic_timer_state_broadcast(pr, cx, 1);
 
 	kt1 = ktime_get_real();
 	/*
@@ -997,7 +994,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 
 	cx->usage++;
 
-	acpi_state_timer_broadcast(pr, cx, 0);
+	lapic_timer_state_broadcast(pr, cx, 0);
 	cx->time += sleep_ticks;
 	return idle_time;
 }
-- 
1.6.3.1.9.g95405b


