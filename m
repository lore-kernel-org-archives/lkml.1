Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbXBFDz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbXBFDz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbXBFDzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:55:39 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:40381 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752700AbXBFDxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:53:17 -0500
Date: Mon, 5 Feb 2007 19:53:16 -0800
Message-Id: <200702060353.l163rGFV000757@zach-dev.vmware.com>
Subject: [PATCH 7/11] Vmi timer race
From: Zachary Amsden <zach@vmware.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 06 Feb 2007 03:53:16.0399 (UTC) FILETIME=[550FFFF0:01C749A2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Because timer code moves around, and we might eventually move our init to a
late_time_init hook, save and restore IRQs around this code because it is
definitely not interrupt safe.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r dd4d4324a5b3 arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c	Thu Feb 01 23:53:06 2007 -0800
+++ b/arch/i386/kernel/vmitime.c	Fri Feb 02 00:03:05 2007 -0800
@@ -178,7 +178,9 @@ void __init vmi_time_init(void)
 void __init vmi_time_init(void)
 {
 	unsigned long long cycles_per_sec, cycles_per_msec;
-
+	unsigned long flags;
+
+	local_irq_save(flags);
 	setup_irq(0, &vmi_timer_irq);
 #ifdef CONFIG_X86_LOCAL_APIC
 	set_intr_gate(LOCAL_TIMER_VECTOR, apic_vmi_timer_interrupt);
@@ -222,6 +224,8 @@ void __init vmi_time_init(void)
 		      VMI_ALARM_WIRED_IRQ0 | VMI_ALARM_IS_PERIODIC | VMI_CYCLES_AVAILABLE,
 		      per_cpu(process_times_cycles_accounted_cpu, 0) + cycles_per_alarm,
 		      cycles_per_alarm);
+
+	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
