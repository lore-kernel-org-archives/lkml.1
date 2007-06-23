Return-Path: <linux-kernel-owner+w=401wt.eu-S1761388AbXFWN3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761388AbXFWN3m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758487AbXFWNW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:22:29 -0400
Received: from www.osadl.org ([213.239.205.134]:59292 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758193AbXFWNWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:22:17 -0400
Message-Id: <20070623124031.166196651@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch -mm 23/28] ACPI: Remove the useless ifdef code
Content-Disposition: inline; filename=acpi-remove-now-useless-ifdef-code.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The conversion of x86-64 to clock events makes the 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 n the timer broadcast functions useless. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 drivers/acpi/processor_idle.c |   12 ------------
 1 file changed, 12 deletions(-)

Index: linux-2.6.22-rc4-mm/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/drivers/acpi/processor_idle.c	2007-06-23 14:38:57.000000000 +0200
+++ linux-2.6.22-rc4-mm/drivers/acpi/processor_idle.c	2007-06-23 14:39:00.000000000 +0200
@@ -203,21 +203,12 @@ static void acpi_timer_check_state(int s
 
 static void acpi_propagate_timer_broadcast(struct acpi_processor *pr)
 {
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
 	unsigned long reason;
 
 	reason = pr->power.timer_broadcast_on_state < INT_MAX ?
 		CLOCK_EVT_NOTIFY_BROADCAST_ON : CLOCK_EVT_NOTIFY_BROADCAST_OFF;
 
 	clockevents_notify(reason, &pr->id);
-#else
-	cpumask_t mask = cpumask_of_cpu(pr->id);
-
-	if (pr->power.timer_broadcast_on_state < INT_MAX)
-		on_each_cpu(switch_APIC_timer_to_ipi, &mask, 1, 1);
-	else
-		on_each_cpu(switch_ipi_to_APIC_timer, &mask, 1, 1);
-#endif
 }
 
 /* Power(C) State timer broadcast control */
@@ -225,8 +216,6 @@ static void acpi_state_timer_broadcast(s
 				       struct acpi_processor_cx *cx,
 				       int broadcast)
 {
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
-
 	int state = cx - pr->power.states;
 
 	if (state >= pr->power.timer_broadcast_on_state) {
@@ -236,7 +225,6 @@ static void acpi_state_timer_broadcast(s
 			CLOCK_EVT_NOTIFY_BROADCAST_EXIT;
 		clockevents_notify(reason, &pr->id);
 	}
-#endif
 }
 
 #else

-- 

