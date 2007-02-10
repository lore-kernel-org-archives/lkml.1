Return-Path: <linux-kernel-owner+w=401wt.eu-S1946670AbXBJLxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946670AbXBJLxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933437AbXBJLx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:53:26 -0500
Received: from ns1.suse.de ([195.135.220.2]:50383 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933441AbXBJLwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:52:42 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101252.033732000@suse.de>
In-Reply-To: <200702101252.033732000@suse.de>
To: Zachary Amsden <zach@vmware.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review II] [9/10] VMI: Vmi timer race
Message-Id: <20070210115237.8BF6813E04@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:52:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Zachary Amsden <zach@vmware.com>
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

