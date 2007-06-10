Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbXFJJb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbXFJJb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbXFJJa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:30:59 -0400
Received: from www.osadl.org ([213.239.205.134]:43015 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752369AbXFJJax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:30:53 -0400
Message-Id: <20070610092446.402212606@inhelltoy.tec.linutronix.de>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 10 Jun 2007 09:43:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>, Adam Belay <abelay@novell.com>,
       Len Brown <lenb@kernel.org>, Dave Miller <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch-mm 01/23] NOHZ: Fix ARM,SH,SPARC64 idle nohz handling
Content-Disposition: inline; filename=cpuidle-fix-sparc-arm-sh-idle.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The cpuidle patches moved the tick nohz handling from irq_exit into
the inner idle loop. The change is correct as it covers non interrupt
based wakeups (e.g DMA) as well, but the move was only done for i386
and breaks ARM,SH and SPARC64. 

Fix it up.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Adam Belay <abelay@novell.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Dave Miller <davem@davemloft.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>

---
 arch/arm/kernel/process.c     |    2 +-
 arch/sh/kernel/process.c      |    5 +++--
 arch/sparc64/kernel/process.c |    5 +++--
 3 files changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6.22-rc4-mm/arch/arm/kernel/process.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/arm/kernel/process.c	2007-06-10 10:44:38.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/arm/kernel/process.c	2007-06-10 10:44:38.000000000 +0200
@@ -130,6 +130,7 @@ static void default_idle(void)
 	else {
 		local_irq_disable();
 		if (!need_resched()) {
+			tick_nohz_stop_sched_tick();
 			timer_dyn_reprogram();
 			arch_idle();
 		}
@@ -160,7 +161,6 @@ void cpu_idle(void)
 		if (!idle)
 			idle = default_idle;
 		leds_event(led_idle_start);
-		tick_nohz_stop_sched_tick();
 		while (!need_resched())
 			idle();
 		leds_event(led_idle_end);
Index: linux-2.6.22-rc4-mm/arch/sh/kernel/process.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/sh/kernel/process.c	2007-06-10 10:44:38.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/sh/kernel/process.c	2007-06-10 10:44:38.000000000 +0200
@@ -62,8 +62,10 @@ void default_idle(void)
 		clear_thread_flag(TIF_POLLING_NRFLAG);
 		smp_mb__after_clear_bit();
 		set_bl_bit();
-		while (!need_resched())
+		while (!need_resched()) {
+			tick_nohz_stop_sched_tick();
 			cpu_sleep();
+		}
 		clear_bl_bit();
 		set_thread_flag(TIF_POLLING_NRFLAG);
 	} else
@@ -82,7 +84,6 @@ void cpu_idle(void)
 		if (!idle)
 			idle = default_idle;
 
-		tick_nohz_stop_sched_tick();
 		while (!need_resched())
 			idle();
 		tick_nohz_restart_sched_tick();
Index: linux-2.6.22-rc4-mm/arch/sparc64/kernel/process.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/sparc64/kernel/process.c	2007-06-10 10:44:38.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/sparc64/kernel/process.c	2007-06-10 10:44:38.000000000 +0200
@@ -89,9 +89,10 @@ void cpu_idle(void)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while(1) {
-		tick_nohz_stop_sched_tick();
-		while (!need_resched())
+		while (!need_resched()) {
+			tick_nohz_stop_sched_tick();
 			sparc64_yield();
+		}
 		tick_nohz_restart_sched_tick();
 
 		preempt_enable_no_resched();

-- 

