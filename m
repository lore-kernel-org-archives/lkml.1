Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbXFWNWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbXFWNWa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbXFWNVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:21:55 -0400
Received: from www.osadl.org ([213.239.205.134]:59157 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752657AbXFWNVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:21:54 -0400
Message-Id: <20070623124030.169946934@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Len Brown <lenb@kernel.org>, Dave Miller <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch -mm 01/28] NOHZ: Fix nox x86 dyntick idle handling
Content-Disposition: inline; filename=cpuidle-fix-sparc-arm-sh-idle.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The cpuidle patches moved the tick nohz handling from irq_exit into
the inner idle loop. The change is correct as it covers non interrupt
based wakeups (e.g DMA) on x86 as well, but the move breaks ARM, SH
and SPARC64. 

Keep the original implementation and deselet the irq exit code for
those architectures which have idle wakeups without interrupts.

This way the non affected architectures are not burdened with the
extra changes in the idle implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Adam Belay <abelay@novell.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Dave Miller <davem@davemloft.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>

---
 arch/i386/Kconfig |    4 ++++
 kernel/softirq.c  |    5 +++++
 2 files changed, 9 insertions(+)

Index: linux-2.6.22-rc4-mm/arch/i386/Kconfig
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/i386/Kconfig	2007-06-23 14:38:57.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/i386/Kconfig	2007-06-23 14:38:57.000000000 +0200
@@ -31,6 +31,10 @@ config GENERIC_CLOCKEVENTS_BROADCAST
 	default y
 	depends on X86_LOCAL_APIC
 
+config NONIRQ_WAKEUP
+	bool
+	default y
+
 config LOCKDEP_SUPPORT
 	bool
 	default y
Index: linux-2.6.22-rc4-mm/kernel/softirq.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/kernel/softirq.c	2007-06-23 14:38:57.000000000 +0200
+++ linux-2.6.22-rc4-mm/kernel/softirq.c	2007-06-23 14:38:57.000000000 +0200
@@ -304,6 +304,11 @@ void irq_exit(void)
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
+#if defined(CONFIG_NO_HZ) && !defined(CONFIG_NONIRQ_WAKEUP)
+	/* Make sure that timer wheel updates are propagated */
+	if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
+		tick_nohz_stop_sched_tick();
+#endif
 	preempt_enable_no_resched();
 }
 

-- 

