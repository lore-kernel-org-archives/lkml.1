Return-Path: <linux-kernel-owner+w=401wt.eu-S1763529AbXKTViS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763529AbXKTViS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbXKTViI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:38:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58677 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbXKTViG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:38:06 -0500
Date: Tue, 20 Nov 2007 22:37:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] new TSC based delay_tsc()
Message-ID: <20071120213746.GA21411@elte.hu>
References: <200711202132.27994.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711202132.27994.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


hi Marin,

here's the patch we are carrying in x86.git at the moment - could you 
please update it with v3 of your code, and send us the patch (with the 
patch metadata kept intact, like you see it below)? Thanks,

	Ingo

----------------->
From: Marin Mitov <mitov@issp.bas.bg>
Subject: new TSC based delay_tsc()

This is a patch based on the Ingo's idea/patch to track
delay_tsc() migration to another cpu by comparing
smp_processor_id().

What is different:
1. Using unsigned (instead of long) to unify for i386/x86_64.
2. Minimal preempt_disable/enable() critical sections
   (more room for preemption)
3. some statements have been rearranged, to account for
    possible under/overflow of left/TSC

Tested on both: 32/64 bit SMP PREEMPT kernel-2.6.24-rc3

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/lib/delay_32.c |   35 +++++++++++++++++++++++++++++------
 arch/x86/lib/delay_64.c |   36 ++++++++++++++++++++++++++++++------
 2 files changed, 59 insertions(+), 12 deletions(-)

Index: linux/arch/x86/lib/delay_32.c
===================================================================
--- linux.orig/arch/x86/lib/delay_32.c
+++ linux/arch/x86/lib/delay_32.c
@@ -38,18 +38,41 @@ static void delay_loop(unsigned long loo
 		:"0" (loops));
 }
 
-/* TSC based delay: */
+/* TSC based delay:
+ *
+ * We are careful about preemption as TSC's are per-CPU.
+ */
 static void delay_tsc(unsigned long loops)
 {
-	unsigned long bclock, now;
+	unsigned prev, now;
+	unsigned left = loops;
+	unsigned prev_cpu, cpu;
+
+	preempt_disable();
+	rdtscl(prev);
+	prev_cpu = smp_processor_id();
+	preempt_enable();
+	now = prev;
 
-	preempt_disable();		/* TSC's are per-cpu */
-	rdtscl(bclock);
 	do {
 		rep_nop();
+
+		left -= now - prev;
+		prev = now;
+
+		preempt_disable();
 		rdtscl(now);
-	} while ((now-bclock) < loops);
-	preempt_enable();
+		cpu = smp_processor_id();
+		preempt_enable();
+
+		if (prev_cpu != cpu) {
+			/*
+			 * We have migrated, we skip this small amount of time:
+			 */
+			prev = now;
+			prev_cpu = cpu;
+		}
+	} while ((now-prev) < left);
 }
 
 /*
Index: linux/arch/x86/lib/delay_64.c
===================================================================
--- linux.orig/arch/x86/lib/delay_64.c
+++ linux/arch/x86/lib/delay_64.c
@@ -26,18 +26,42 @@ int read_current_timer(unsigned long *ti
 	return 0;
 }
 
+/* TSC based delay:
+ *
+ * We are careful about preemption as TSC's are per-CPU.
+ */
 void __delay(unsigned long loops)
 {
-	unsigned bclock, now;
+	unsigned prev, now;
+	unsigned left = loops;
+	unsigned prev_cpu, cpu;
+
+	preempt_disable();
+	rdtscl(prev);
+	prev_cpu = smp_processor_id();
+	preempt_enable();
+	now = prev;
 
-	preempt_disable();		/* TSC's are pre-cpu */
-	rdtscl(bclock);
 	do {
-		rep_nop(); 
+		rep_nop();
+
+		left -= now - prev;
+		prev = now;
+
+		preempt_disable();
 		rdtscl(now);
+		cpu = smp_processor_id();
+		preempt_enable();
+
+		if (prev_cpu != cpu) {
+			/*
+			 * We have migrated, we skip this small amount of time:
+			 */
+			 prev = now;
+			 prev_cpu = cpu;
+		}
 	}
-	while ((now-bclock) < loops);
-	preempt_enable();
+	while ((now-prev) < left);
 }
 EXPORT_SYMBOL(__delay);
 
