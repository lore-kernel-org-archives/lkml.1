Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYICXfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYICXfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 19:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYICXfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 19:35:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbYICXfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 19:35:21 -0400
Date: Wed, 3 Sep 2008 19:34:59 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [stable][patch 2.6.26] x86-32: AMD c1e force timer broadcast late
Message-ID: <20080903193459.67d9eb87@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86-32: AMD c1e force timer broadcast late

This patch is not needed in 2.6.27 because it has new c1e-aware idle code.

In kernel 2.6.26 the 32-bit x86 timers are started earlier than before.
This breaks AMD c1e detection trying to force timer broadcast for the
local apic timer. Copy the code from the 64-bit kernel to force timer
broadcast late.

Reference:
http://bugzilla.kernel.org/show_bug.cgi?id=11427

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>

--- linux-2.6.26.noarch.orig/arch/x86/kernel/apic_32.c
+++ linux-2.6.26.noarch/arch/x86/kernel/apic_32.c
@@ -552,8 +552,31 @@ void __init setup_boot_APIC_clock(void)
 	setup_APIC_timer();
 }
 
-void __devinit setup_secondary_APIC_clock(void)
+/*
+ * AMD C1E enabled CPUs have a real nasty problem: Some BIOSes set the
+ * C1E flag only in the secondary CPU, so when we detect the wreckage
+ * we already have enabled the boot CPU local apic timer. Check, if
+ * disable_apic_timer is set and the DUMMY flag is cleared. If yes,
+ * set the DUMMY flag again and force the broadcast mode in the
+ * clockevents layer.
+ */
+static void __cpuinit check_boot_apic_timer_broadcast(void)
+{
+	if (!local_apic_timer_disabled ||
+	    (lapic_clockevent.features & CLOCK_EVT_FEAT_DUMMY))
+		return;
+
+	lapic_clockevent.features |= CLOCK_EVT_FEAT_DUMMY;
+
+	local_irq_enable();
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_FORCE,
+			   &boot_cpu_physical_apicid);
+	local_irq_disable();
+}
+
+void __cpuinit setup_secondary_APIC_clock(void)
 {
+	check_boot_apic_timer_broadcast();
 	setup_APIC_timer();
 }
 
