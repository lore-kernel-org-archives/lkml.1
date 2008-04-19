Return-Path: <linux-kernel-owner+w=401wt.eu-S1762757AbYDSPI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762757AbYDSPI1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 11:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762260AbYDSPHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 11:07:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:11069 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762199AbYDSPHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 11:07:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=OkH7igkGz/pUNskiHbN/gIa59syf21zeZmLfciRNF+49ZArmqDLN5LJA8JxPqpfZM8/qwwyGiXvME0w9Mt3xnetd+cq0Mv9aUfTWJgHTjCdSWbzhxm73s7qeWN0ER/aZYHz+KtnP2AoApJrM10sla0wu3Y7pl8IQKvvjWnmHwKI=
References: <20080419145510.150338641@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 19 Apr 2008 23:55:16 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 06/10] x86: cleanup div_sc() usage
Content-Disposition: inline; filename=x86-clock-event-div-sc-cleanup.patch
Message-ID: <480a0a92.12da600a.609c.2994@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the magic number in the third argment of div_sc().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/apic_32.c  |    3 ++-
 arch/x86/kernel/apic_64.c  |    3 ++-
 arch/x86/kernel/hpet.c     |    2 +-
 arch/x86/kernel/i8253.c    |    3 ++-
 arch/x86/kernel/mfgpt_32.c |    3 ++-
 5 files changed, 9 insertions(+), 5 deletions(-)

Index: 2.6-git/arch/x86/kernel/apic_32.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/apic_32.c
+++ 2.6-git/arch/x86/kernel/apic_32.c
@@ -451,7 +451,8 @@ void __init setup_boot_APIC_clock(void)
 	}
 
 	/* Calculate the scaled math multiplication factor */
-	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS, 32);
+	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
+				       lapic_clockevent.shift);
 	lapic_clockevent.max_delta_ns =
 		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
 	lapic_clockevent.min_delta_ns =
Index: 2.6-git/arch/x86/kernel/apic_64.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/apic_64.c
+++ 2.6-git/arch/x86/kernel/apic_64.c
@@ -360,7 +360,8 @@ static void __init calibrate_APIC_clock(
 		result / 1000 / 1000, result / 1000 % 1000);
 
 	/* Calculate the scaled math multiplication factor */
-	lapic_clockevent.mult = div_sc(result, NSEC_PER_SEC, 32);
+	lapic_clockevent.mult = div_sc(result, NSEC_PER_SEC,
+				       lapic_clockevent.shift);
 	lapic_clockevent.max_delta_ns =
 		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
 	lapic_clockevent.min_delta_ns =
Index: 2.6-git/arch/x86/kernel/hpet.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/hpet.c
+++ 2.6-git/arch/x86/kernel/hpet.c
@@ -218,7 +218,7 @@ static void hpet_legacy_clockevent_regis
 	hpet_freq = 1000000000000000ULL;
 	do_div(hpet_freq, hpet_period);
 	hpet_clockevent.mult = div_sc((unsigned long) hpet_freq,
-				      NSEC_PER_SEC, 32);
+				      NSEC_PER_SEC, hpet_clockevent.shift);
 	/* Calculate the min / max delta */
 	hpet_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
 							   &hpet_clockevent);
Index: 2.6-git/arch/x86/kernel/i8253.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/i8253.c
+++ 2.6-git/arch/x86/kernel/i8253.c
@@ -115,7 +115,8 @@ void __init setup_pit_timer(void)
 	 * IO_APIC has been initialized.
 	 */
 	pit_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
-	pit_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, 32);
+	pit_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC,
+				     pit_clockevent.shift);
 	pit_clockevent.max_delta_ns =
 		clockevent_delta2ns(0x7FFF, &pit_clockevent);
 	pit_clockevent.min_delta_ns =
Index: 2.6-git/arch/x86/kernel/mfgpt_32.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/mfgpt_32.c
+++ 2.6-git/arch/x86/kernel/mfgpt_32.c
@@ -364,7 +364,8 @@ int __init mfgpt_timer_setup(void)
 	geode_mfgpt_write(mfgpt_event_clock, MFGPT_REG_SETUP, val);
 
 	/* Set up the clock event */
-	mfgpt_clockevent.mult = div_sc(MFGPT_HZ, NSEC_PER_SEC, 32);
+	mfgpt_clockevent.mult = div_sc(MFGPT_HZ, NSEC_PER_SEC,
+				       mfgpt_clockevent.shift);
 	mfgpt_clockevent.min_delta_ns = clockevent_delta2ns(0xF,
 			&mfgpt_clockevent);
 	mfgpt_clockevent.max_delta_ns = clockevent_delta2ns(0xFFFE,

-- 
