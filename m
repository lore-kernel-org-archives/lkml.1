Return-Path: <linux-kernel-owner+w=401wt.eu-S965530AbXAWWEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965530AbXAWWEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965525AbXAWWEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:04:50 -0500
Received: from www.osadl.org ([213.239.205.134]:35934 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965520AbXAWWBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:01:22 -0500
Message-Id: <20070123211209.237368000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 40/46] i386 prepare nmi watchdog for dynticks
Content-Disposition: inline; filename=dynticks-i386-prepare-nmi-watchdog.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The NMI watchdog implementation assumes that the local APIC timer
interrupt is happening.  This assumption is not longer true when high
resolution timers and dynamic ticks come into play, as they may switch
off the local APIC timer completely.  Take the PIT/HPET interrupts into
account too, to avoid false positives.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: Zachary Amsden <zach@vmware.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rohit Seth <rohitseth@google.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/nmi.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/nmi.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/arch/i386/kernel/nmi.c
+++ linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/nmi.c
@@ -23,6 +23,7 @@
 #include <linux/dmi.h>
 #include <linux/kprobes.h>
 #include <linux/cpumask.h>
+#include <linux/kernel_stat.h>
 
 #include <asm/smp.h>
 #include <asm/nmi.h>
@@ -971,9 +972,13 @@ __kprobes int nmi_watchdog_tick(struct p
 		cpu_clear(cpu, backtrace_mask);
 	}
 
-	sum = per_cpu(irq_stat, cpu).apic_timer_irqs;
+	/*
+	 * Take the local apic timer and PIT/HPET into account. We don't
+	 * know which one is active, when we have highres/dyntick on
+	 */
+	sum = per_cpu(irq_stat, cpu).apic_timer_irqs + kstat_irqs(0);
 
-	/* if the apic timer isn't firing, this cpu isn't doing much */
+	/* if the none of the timers isn't firing, this cpu isn't doing much */
 	if (!touched && last_irq_sums[cpu] == sum) {
 		/*
 		 * Ayiee, looks like this CPU is stuck ...

--

