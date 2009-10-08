Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbZJHPcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbZJHPcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 11:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758569AbZJHPcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 11:32:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:32933 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758498AbZJHPcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 11:32:06 -0400
Date: Thu, 8 Oct 2009 15:30:52 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, arjan@linux.intel.com, efault@gmx.de,
       peterz@infradead.org, elendil@planet.nl, arjan@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, torvalds@linux-foundation.org, elendil@planet.nl,
       peterz@infradead.org, efault@gmx.de, arjan@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091008064041.67219b13@infradead.org>
References: <20091008064041.67219b13@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] x86, timers: Check for pending timers after (device) interrupts
Message-ID: <tip-9bcbdd9c58617f1301dd4f17c738bb9bc73aca70@git.kernel.org>
Git-Commit-ID: 9bcbdd9c58617f1301dd4f17c738bb9bc73aca70
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 08 Oct 2009 15:30:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9bcbdd9c58617f1301dd4f17c738bb9bc73aca70
Gitweb:     http://git.kernel.org/tip/9bcbdd9c58617f1301dd4f17c738bb9bc73aca70
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Thu, 8 Oct 2009 06:40:41 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 8 Oct 2009 17:27:27 +0200

x86, timers: Check for pending timers after (device) interrupts

Now that range timers and deferred timers are common, I found a
problem with these using the "perf timechart" tool. Frans Pop also
reported high scheduler latencies via LatencyTop, when using
iwlagn.

It turns out that on x86, these two 'opportunistic' timers only get
checked when another "real" timer happens. These opportunistic
timers have the objective to save power by hitchhiking on other
wakeups, as to avoid CPU wakeups by themselves as much as possible.

The change in this patch runs this check not only at timer
interrupts, but at all (device) interrupts. The effect is that:

 1) the deferred timers/range timers get delayed less

 2) the range timers cause less wakeups by themselves because
    the percentage of hitchhiking on existing wakeup events goes up.

I've verified the working of the patch using "perf timechart", the
original exposed bug is gone with this patch. Frans also reported
success - the latencies are now down in the expected ~10 msec
range.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Tested-by: Frans Pop <elendil@planet.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091008064041.67219b13@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
