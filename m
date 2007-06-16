Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbXFPKZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbXFPKZk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 06:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbXFPKYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 06:24:14 -0400
Received: from www.osadl.org ([213.239.205.134]:37135 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752547AbXFPKYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 06:24:09 -0400
Message-Id: <20070616101636.556333444@inhelltoy.tec.linutronix.de>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 16 Jun 2007 10:36:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, Len Brown <lenb@kernel.org>,
       Dave Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch-mm 01/25] NOHZ: Fix nox x86 dyntick idle handling
Content-Disposition: inline; filename=cpuidle-fix-sparc-arm-sh-idle.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The cpuidle patches moved the tick nohz handling from irq_exit into
the inner idle loop. The change is correct as it covers non interrupt
based wakeups (e.g DMA) on x86 as well, but the move breaks ARM, SH
and SPARC64. 

Keep the original implementation and deselet the irq exit code for
those architectures which have non irq idle wakeups.

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
--- linux-2.6.22-rc4-mm.orig/arch/i386/Kconfig	2007-06-16 12:10:22.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/i386/Kconfig	2007-06-16 12:10:22.000000000 +0200
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
--- linux-2.6.22-rc4-mm.orig/kernel/softirq.c	2007-06-16 12:10:22.000000000 +0200
+++ linux-2.6.22-rc4-mm/kernel/softirq.c	2007-06-16 12:10:22.000000000 +0200
@@ -304,6 +304,11 @@ void irq_exit(void)
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
+#if defined(CONFIG_NO_HZ) && !defined(CONFIG_NONIRQ_WAKEUP)
+	/* Make sure that timer wheel updates are propagated */
+	if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
+		tick_nohz_stop_sched_tick();a
+#endif
 	preempt_enable_no_resched();
 }
 

-- 

