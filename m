Return-Path: <linux-kernel-owner+w=401wt.eu-S1752012AbZIXLeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbZIXLeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZIXLeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:34:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:56758 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZIXLeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:34:07 -0400
Date: Thu, 24 Sep 2009 13:34:24 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com
Subject: [PATCH] x86, timers: check for pending timers after (device)
 interrupts
Message-ID: <20090924133424.702d347e@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 33725d4939f457b12d7bc1bcbcc0dfb8b2f5bd48 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Thu, 24 Sep 2009 13:24:16 +0200
Subject: [PATCH] x86, timers: check for pending timers after (device) interrupts

Now that range timers and deferred timers are common, I found a
problem with these using the "perf timechart" tool.

It turns out that on x86, these two 'opportunistic' timers only
get checked when another "real" timer happens.
These opportunistic timers have the objective to save power by
hitchhiking on other wakeups, as to avoid CPU wakeups by themselves
as much as possible.

The change in this patch runs this check not only at timer interrupts,
but at all (device) interrupts. The effect is that
1) the deferred timers/range timers get delayed less
   (quality of implementation)
2) the range timers cause less wakeups by themselves because
   the percentage of hitchhiking on existing wakeup events goes up.

I've verified the working of the patch using "perf timechart",
the original exposed bug is gone with this patch.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/irq.c |    2 ++
 arch/x86/kernel/smp.c |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 74656d1..3912061 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -244,6 +244,7 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 				__func__, smp_processor_id(), vector, irq);
 	}
 
+	run_local_timers();
 	irq_exit();
 
 	set_irq_regs(old_regs);
@@ -268,6 +269,7 @@ void smp_generic_interrupt(struct pt_regs *regs)
 	if (generic_interrupt_extension)
 		generic_interrupt_extension();
 
+	run_local_timers();
 	irq_exit();
 
 	set_irq_regs(old_regs);
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index ec1de97..d915d95 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -198,6 +198,7 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	inc_irq_stat(irq_resched_count);
+	run_local_timers();
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
