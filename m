Return-Path: <linux-kernel-owner+w=401wt.eu-S1758965AbZCTK2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965AbZCTK2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762323AbZCTK01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:26:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:35264 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761232AbZCTK00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:26:26 -0400
Date: Fri, 20 Mar 2009 10:25:43 GMT
From: Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090319194234.024464535@chello.nl>
References: <20090319194234.024464535@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: powerpc: clean up perc_counter_interrupt
Message-ID: <tip-8b3229288a401f45b95c9b0aa9a551b82947a101@git.kernel.org>
Git-Commit-ID: 8b3229288a401f45b95c9b0aa9a551b82947a101
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:25:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b3229288a401f45b95c9b0aa9a551b82947a101
Gitweb:     http://git.kernel.org/tip/8b3229288a401f45b95c9b0aa9a551b82947a101
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Thu, 19 Mar 2009 20:26:20 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 11:15:14 +0100

perf_counter: powerpc: clean up perc_counter_interrupt

Impact: cleanup

This updates the powerpc perf_counter_interrupt following on from the
"perf_counter: unify irq output code" patch.  Since we now use the
generic perf_counter_output code, which sets the perf_counter_pending
flag directly, we no longer need the need_wakeup variable.

This removes need_wakeup and makes perf_counter_interrupt use
get_perf_counter_pending() instead.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090319194234.024464535@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

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
 
