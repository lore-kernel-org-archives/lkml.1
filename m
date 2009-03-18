Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbZCRF3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbZCRF3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 01:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZCRF2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 01:28:54 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:48623 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbZCRF2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 01:28:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18880.34440.280755.729382@drongo.ozlabs.ibm.com>
Date: Wed, 18 Mar 2009 16:28:40 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 11/11] perf_counter: unify irq output code
In-Reply-To: <18880.24188.569247.425760@drongo.ozlabs.ibm.com>
References: <20090317215606.037073805@chello.nl>
	<20090317220422.026219494@chello.nl>
	<18880.24188.569247.425760@drongo.ozlabs.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:

> Nice cleanup, and thanks for updating powerpc too.  With this, I think
> we'll need to update the powerpc perf_counter_interrupt a bit: we
> might as well use get_perf_counter_pending() instead of the wakeup
> variable now.  I'll send an extra patch once I have done some testing.

This seems to work OK.

Paul.

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 88b72eb..830ca9c 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -723,8 +723,6 @@ static void perf_counter_interrupt(struct pt_regs *regs)
 			/* counter has overflowed */
 			found = 1;
 			record_and_restart(counter, val, regs);
-			if (counter->wakeup_pending)
-				need_wakeup = 1;
 		}
 	}
 
@@ -754,17 +752,14 @@ static void perf_counter_interrupt(struct pt_regs *regs)
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
 

