Return-Path: <linux-kernel-owner+w=401wt.eu-S1760257AbZEZWtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257AbZEZWtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760096AbZEZWsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:48:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33506 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760094AbZEZWsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:48:35 -0400
Subject: [PATCH] x86: fix cpufreq tsc scaling
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: lkml <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
Content-Type: text/plain
Date: Wed, 27 May 2009 00:48:25 +0200
Message-Id: <1243378105.6600.28.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: x86: fix cpufreq tsc scaling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed May 27 00:32:23 CEST 2009

For freqency dependent TSCs we only scale the cycles, we do not account
for the discrepancy in absolute value. Add a constant factor so that:

  c1 + f1*cyc == c2 + f2*cyc

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Chucked-on-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/timer.h |    6 +++++-
 arch/x86/kernel/tsc.c        |    8 ++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/include/asm/timer.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/timer.h
+++ linux-2.6/arch/x86/include/asm/timer.h
@@ -45,12 +45,16 @@ extern int no_timer_check;
  */
 
 DECLARE_PER_CPU(unsigned long, cyc2ns);
+DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
 
 #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
 static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
 {
-	return cyc * per_cpu(cyc2ns, smp_processor_id()) >> CYC2NS_SCALE_FACTOR;
+	int cpu = smp_processor_id();
+	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
+	ns += cyc * per_cpu(cyc2ns, cpu) >> CYC2NS_SCALE_FACTOR;
+	return ns;
 }
 
 static inline unsigned long long cycles_2_ns(unsigned long long cyc)
Index: linux-2.6/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc.c
+++ linux-2.6/arch/x86/kernel/tsc.c
@@ -589,22 +589,26 @@ EXPORT_SYMBOL(recalibrate_cpu_khz);
  */
 
 DEFINE_PER_CPU(unsigned long, cyc2ns);
+DEFINE_PER_CPU(unsigned long long, cyc2ns_offset);
 
 static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
-	unsigned long long tsc_now, ns_now;
+	unsigned long long tsc_now, ns_now, *offset;
 	unsigned long flags, *scale;
 
 	local_irq_save(flags);
 	sched_clock_idle_sleep_event();
 
 	scale = &per_cpu(cyc2ns, cpu);
+	offset = &per_cpu(cyc2ns_offset, cpu);
 
 	rdtscll(tsc_now);
 	ns_now = __cycles_2_ns(tsc_now);
 
-	if (cpu_khz)
+	if (cpu_khz) {
 		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
+		*offset = ns_now - (tsc_now * *scale >> CYC2NS_SCALE_FACTOR);
+	}
 
 	sched_clock_idle_wakeup_event(0);
 	local_irq_restore(flags);


