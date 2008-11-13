Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbYKMTo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbYKMTo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYKMTed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:33 -0500
Received: from gw.goop.org ([64.81.55.164]:34388 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbYKMTeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:13 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 38 of 38] xen: make sure that softirqs get handled at the end
	of event processing
X-Mercurial-Node: f69c183aaff7e76572440d25feeafed424455c5c
Message-Id: <f69c183aaff7e7657244.1226603436@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:36 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that irq_enter()/irq_exit() wrap the entire event processing
loop, rather than each individual event invokation.  This make sure
that softirq processing is deferred until the of event processing,
rather than in the middle with interrupts disabled.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -806,25 +806,6 @@
 	return IRQ_HANDLED;
 }
 
-
-static void xen_do_irq(unsigned irq, struct pt_regs *regs)
-{
-	struct pt_regs *old_regs = set_irq_regs(regs);
-
-	if (WARN_ON(irq == -1))
-		return;
-
-	exit_idle();
-	irq_enter();
-
-	//printk("cpu %d handling irq %d\n", smp_processor_id(), info->irq);
-	handle_irq(irq, regs);
-
-	irq_exit();
-
-	set_irq_regs(old_regs);
-}
-
 /*
  * Search the CPUs pending events bitmasks.  For each one found, map
  * the event number to an irq, and feed it into do_IRQ() for
@@ -837,11 +818,15 @@
 void xen_evtchn_do_upcall(struct pt_regs *regs)
 {
 	int cpu = get_cpu();
+	struct pt_regs *old_regs = set_irq_regs(regs);
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct vcpu_info *vcpu_info = __get_cpu_var(xen_vcpu);
 	static DEFINE_PER_CPU(unsigned, nesting_count);
  	unsigned count;
 
+	exit_idle();
+	irq_enter();
+
 	do {
 		unsigned long pending_words;
 
@@ -865,7 +850,8 @@
 				int port = (word_idx * BITS_PER_LONG) + bit_idx;
 				int irq = evtchn_to_irq[port];
 
-				xen_do_irq(irq, regs);
+				if (irq != -1)
+					handle_irq(irq, regs);
 			}
 		}
 
@@ -876,6 +862,9 @@
 	} while(count != 1);
 
 out:
+	irq_exit();
+	set_irq_regs(old_regs);
+
 	put_cpu();
 }
 


