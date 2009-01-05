Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbZAELob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbZAELob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZAELm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:42:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:55624 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbZAELm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:42:58 -0500
Message-Id: <20090105103136.092137470@chello.nl>
References: <20090105102818.829119334@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 05 Jan 2009 11:28:19 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/5] hrtimer: splitout peek ahead functionality
Content-Disposition: inline; filename=hrtimers-splitout-peek-ahead-functionality.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Provide a peek ahead function that assumes irqs disabled, allows for micro
optimizations.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/hrtimer.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

Index: linux-2.6-tip/kernel/hrtimer.c
===================================================================
--- linux-2.6-tip.orig/kernel/hrtimer.c
+++ linux-2.6-tip/kernel/hrtimer.c
@@ -1244,6 +1244,22 @@ void hrtimer_interrupt(struct clock_even
 	}
 }
 
+/*
+ * local version of hrtimer_peek_ahead_timers() called with interrupts
+ * disabled.
+ */
+static void __hrtimer_peek_ahead_timers(void)
+{
+	struct tick_device *td;
+
+	if (!hrtimer_hres_active())
+		return;
+
+	td = &__get_cpu_var(tick_cpu_device);
+	if (td && td->evtdev)
+		hrtimer_interrupt(td->evtdev);
+}
+
 /**
  * hrtimer_peek_ahead_timers -- run soft-expired timers now
  *
@@ -1255,16 +1271,10 @@ void hrtimer_interrupt(struct clock_even
  */
 void hrtimer_peek_ahead_timers(void)
 {
-	struct tick_device *td;
 	unsigned long flags;
 
-	if (!hrtimer_hres_active())
-		return;
-
 	local_irq_save(flags);
-	td = &__get_cpu_var(tick_cpu_device);
-	if (td && td->evtdev)
-		hrtimer_interrupt(td->evtdev);
+	__hrtimer_peek_ahead_timers();
 	local_irq_restore(flags);
 }
 

-- 

