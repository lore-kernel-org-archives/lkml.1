Return-Path: <linux-kernel-owner+w=401wt.eu-S1761125AbZCSTqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125AbZCSTqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759383AbZCSTn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:43:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:46796 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124AbZCSTnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:43:21 -0400
Message-Id: <20090319194234.024464535@chello.nl>
References: <20090319192610.660857280@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 20:26:20 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/10] perf_counter: powerpc: clean up perc_counter_interrupt
Content-Disposition: inline; filename=paulus_perf_counter_unify_irq_output_code.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>

> Nice cleanup, and thanks for updating powerpc too.  With this, I think
> we'll need to update the powerpc perf_counter_interrupt a bit: we
> might as well use get_perf_counter_pending() instead of the wakeup
> variable now.  I'll send an extra patch once I have done some testing.

This seems to work OK.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/kernel/perf_counter.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_counter.c
+++ linux-2.6/arch/powerpc/kernel/perf_counter.c
@@ -723,8 +723,6 @@ static void perf_counter_interrupt(struc
 			/* counter has overflowed */
 			found = 1;
 			record_and_restart(counter, val, regs);
-			if (counter->wakeup_pending)
-				need_wakeup = 1;
 		}
 	}
 
@@ -754,17 +752,14 @@ static void perf_counter_interrupt(struc
 	/*
 	 * If we need a wakeup, check whether interrupts were soft-enabled
 	 * when we took the interrupt.  If they were, we can wake stuff up
-	 * immediately; otherwise we'll have to set a flag and do the
-	 * wakeup when interrupts get soft-enabled.
+	 * immediately; otherwise we'll have do the wakeup when interrupts
+	 * get soft-enabled.
 	 */
-	if (need_wakeup) {
-		if (regs->softe) {
-			irq_enter();
-			perf_counter_do_pending();
-			irq_exit();
-		} else {
-			set_perf_counter_pending();
-		}
+	if (get_perf_counter_pending() && regs->softe) {
+		irq_enter();
+		clear_perf_counter_pending();
+		perf_counter_do_pending();
+		irq_exit();
 	}
 }
 

-- 

