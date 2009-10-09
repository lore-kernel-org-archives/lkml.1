Return-Path: <linux-kernel-owner+w=401wt.eu-S1760943AbZJIOYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943AbZJIOYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760933AbZJIOYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:24:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:42843 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760906AbZJIOYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:24:48 -0400
Date: Fri, 9 Oct 2009 14:23:35 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, arjan@linux.intel.com, efault@gmx.de,
       elendil@planet.nl, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, torvalds@linux-foundation.org,
       peterz@infradead.org, elendil@planet.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091008064041.67219b13@infradead.org>
References: <20091008064041.67219b13@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] Revert "x86, timers: Check for pending timers after (device) interrupts"
Message-ID: <tip-e7ab0f7b50bc4688fb5cf65de5d42e3b882fb8d1@git.kernel.org>
Git-Commit-ID: e7ab0f7b50bc4688fb5cf65de5d42e3b882fb8d1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 09 Oct 2009 14:23:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7ab0f7b50bc4688fb5cf65de5d42e3b882fb8d1
Gitweb:     http://git.kernel.org/tip/e7ab0f7b50bc4688fb5cf65de5d42e3b882fb8d1
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 9 Oct 2009 15:58:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Oct 2009 15:58:20 +0200

Revert "x86, timers: Check for pending timers after (device) interrupts"

This reverts commit 9bcbdd9c58617f1301dd4f17c738bb9bc73aca70.

The real bug producing LatencyTop latencies has been fixed in:

  f5dc375: sched: Update the clock of runqueue select_task_rq() selected

And the commit being reverted here triggers local timer processing
from every device IRQ. If device IRQs come in at a high frequency,
this could cause a performance regression.

The commit being reverted here purely 'fixed' the reported latency
as a side effect, because CPUs were being moved out of idle more
often.

Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Frans Pop <elendil@planet.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091008064041.67219b13@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/irq.c |    2 --
 arch/x86/kernel/smp.c |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3912061..74656d1 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -244,7 +244,6 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 				__func__, smp_processor_id(), vector, irq);
 	}
 
-	run_local_timers();
 	irq_exit();
 
 	set_irq_regs(old_regs);
@@ -269,7 +268,6 @@ void smp_generic_interrupt(struct pt_regs *regs)
 	if (generic_interrupt_extension)
 		generic_interrupt_extension();
 
-	run_local_timers();
 	irq_exit();
 
 	set_irq_regs(old_regs);
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index d915d95..ec1de97 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -198,7 +198,6 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	inc_irq_stat(irq_resched_count);
-	run_local_timers();
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
