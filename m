Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbZHMWwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbZHMWwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 18:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZHMWwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 18:52:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:19224 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbZHMWwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 18:52:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,377,1246863600"; 
   d="scan'208";a="175625275"
Subject: [patch]  clockevents_notify() need to be called with irq's enabled
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       len.brown@intel.com
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 13 Aug 2009 15:48:01 -0700
Message-Id: <1250203681.27006.10842.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: clockevents_notify() need to be called with irq's enabled

Currently clockevents_notify() is called with interrupts enabled at some
places and interrupts disabled at some other places.

This results in a deadlock in this scenario.

cpu A holding the clockevents_lock in clockevents_notify() with irq enabled
cpu B waiting for the clockevents_lock in clockevents_notify() with irq disabled
cpu C doing set_mtrr() which will try to rendezvous of all the cpus.

This will result in C and A come to the rendezvous point and waiting for B.
B stuck forever waiting for the spinlock and thus not reaching rendezvous
point.

Fix the usage of clockevents_notify() so that it will always be called
with interrupts enabled and thus avoid the above deadlock.

This issue left us wondering if we need to change the MTRR rendezvous logic to
use stop machine logic (instead of smp_call_function) or add a check
in spinlock debug code to see if there are other spinlocks which gets
taken under both interrupts enabled/disabled conditions.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---

Index: tip/arch/x86/kernel/process.c
===================================================================
--- tip.orig/arch/x86/kernel/process.c
+++ tip/arch/x86/kernel/process.c
@@ -520,17 +520,13 @@ static void c1e_idle(void)
 			       cpu);
 			local_irq_disable();
 		}
+		local_irq_enable();
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
+		local_irq_disable();
 
 		default_idle();
 
-		/*
-		 * The switch back from broadcast mode needs to be
-		 * called with interrupts disabled.
-		 */
-		 local_irq_disable();
 		 clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
-		 local_irq_enable();
 	} else
 		default_idle();
 }
Index: tip/drivers/acpi/processor_idle.c
===================================================================
--- tip.orig/drivers/acpi/processor_idle.c
+++ tip/drivers/acpi/processor_idle.c
@@ -829,16 +829,18 @@ static int acpi_idle_enter_c1(struct cpu
 	if (unlikely(!pr))
 		return 0;
 
+	local_irq_enable();
+	lapic_timer_state_broadcast(pr, cx, 1);
 	local_irq_disable();
 
 	/* Do not access any ACPI IO ports in suspend path */
 	if (acpi_idle_suspend) {
 		local_irq_enable();
 		cpu_relax();
+		lapic_timer_state_broadcast(pr, cx, 0);
 		return 0;
 	}
 
-	lapic_timer_state_broadcast(pr, cx, 1);
 	kt1 = ktime_get_real();
 	acpi_idle_do_entry(cx);
 	kt2 = ktime_get_real();
@@ -873,6 +875,13 @@ static int acpi_idle_enter_simple(struct
 	if (acpi_idle_suspend)
 		return(acpi_idle_enter_c1(dev, state));
 
+	local_irq_enable();
+	/*
+	 * Must be done before busmaster disable as we might need to
+	 * access HPET !
+	 */
+	lapic_timer_state_broadcast(pr, cx, 1);
+
 	local_irq_disable();
 	current_thread_info()->status &= ~TS_POLLING;
 	/*
@@ -884,15 +893,10 @@ static int acpi_idle_enter_simple(struct
 	if (unlikely(need_resched())) {
 		current_thread_info()->status |= TS_POLLING;
 		local_irq_enable();
+		lapic_timer_state_broadcast(pr, cx, 0);
 		return 0;
 	}
 
-	/*
-	 * Must be done before busmaster disable as we might need to
-	 * access HPET !
-	 */
-	lapic_timer_state_broadcast(pr, cx, 1);
-
 	if (cx->type == ACPI_STATE_C3)
 		ACPI_FLUSH_CPU_CACHE();
 
@@ -957,6 +961,12 @@ static int acpi_idle_enter_bm(struct cpu
 			return 0;
 		}
 	}
+	local_irq_enable();
+	/*
+	 * Must be done before busmaster disable as we might need to
+	 * access HPET !
+	 */
+	lapic_timer_state_broadcast(pr, cx, 1);
 
 	local_irq_disable();
 	current_thread_info()->status &= ~TS_POLLING;
@@ -969,6 +979,7 @@ static int acpi_idle_enter_bm(struct cpu
 	if (unlikely(need_resched())) {
 		current_thread_info()->status |= TS_POLLING;
 		local_irq_enable();
+		lapic_timer_state_broadcast(pr, cx, 0);
 		return 0;
 	}
 
@@ -976,11 +987,6 @@ static int acpi_idle_enter_bm(struct cpu
 
 	/* Tell the scheduler that we are going deep-idle: */
 	sched_clock_idle_sleep_event();
-	/*
-	 * Must be done before busmaster disable as we might need to
-	 * access HPET !
-	 */
-	lapic_timer_state_broadcast(pr, cx, 1);
 
 	kt1 = ktime_get_real();
 	/*


