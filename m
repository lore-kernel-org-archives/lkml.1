Return-Path: <linux-kernel-owner+w=401wt.eu-S1161184AbXBUKA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161184AbXBUKA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161187AbXBUKA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:00:27 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:13064 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161184AbXBUKAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:00:23 -0500
Date: Wed, 21 Feb 2007 11:00:22 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [S390] prevent softirqs if delay is called disabled
Message-ID: <20070221100022.GB13419@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

[S390] prevent softirqs if delay is called disabled

The new delay implementation uses the clock comparator and an external
interrupt even if it is called disabled for interrupts. To do this
all external interrupt source except clock comparator are switched of
before enabling external interrupts. The external interrupt at the
end of the delay period may not execute softirqs or we can end up in a
dead-lock.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/lib/delay.c |    7 +++++++
 1 files changed, 7 insertions(+)

diff -urpN linux-2.6/arch/s390/lib/delay.c linux-2.6-patched/arch/s390/lib/delay.c
--- linux-2.6/arch/s390/lib/delay.c	2007-02-21 10:47:06.000000000 +0100
+++ linux-2.6-patched/arch/s390/lib/delay.c	2007-02-21 10:47:23.000000000 +0100
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <linux/timex.h>
 #include <linux/irqflags.h>
+#include <linux/interrupt.h>
 
 void __delay(unsigned long loops)
 {
@@ -35,7 +36,11 @@ void __udelay(unsigned long usecs)
 {
 	u64 end, time, jiffy_timer = 0;
 	unsigned long flags, cr0, mask, dummy;
+	int irq_context;
 
+	irq_context = in_interrupt();
+	if (!irq_context)
+		local_bh_disable();
 	local_irq_save(flags);
 	if (raw_irqs_disabled_flags(flags)) {
 		jiffy_timer = S390_lowcore.jiffy_timer;
@@ -62,6 +67,8 @@ void __udelay(unsigned long usecs)
 		__ctl_load(cr0, 0, 0);
 		S390_lowcore.jiffy_timer = jiffy_timer;
 	}
+	if (!irq_context)
+		_local_bh_enable();
 	set_clock_comparator(S390_lowcore.jiffy_timer);
 	local_irq_restore(flags);
 }
-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher 
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294
   
"Reality continues to ruin my life." - Calvin.

