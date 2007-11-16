Return-Path: <linux-kernel-owner+w=401wt.eu-S1760414AbXKPKv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760414AbXKPKv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 05:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbXKPKvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 05:51:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59230 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbXKPKvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 05:51:18 -0500
Date: Fri, 16 Nov 2007 11:50:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@qumranet.com>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [patch] x86: make delay_tsc() preemptible again
Message-ID: <20071116105056.GC5453@elte.hu>
References: <200711150400.lAF40lIr020160@hera.kernel.org> <20071115194116.12c7a0f6@laptopd505.fenrus.org> <473D5016.4000105@qumranet.com> <20071116083627.GA18225@elte.hu> <20071116084741.GA20011@elte.hu> <1195205942.3059.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195205942.3059.1.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> > +		prev_cpu = smp_processor_id();
> >  		rep_nop();
> > +		preempt_enable();
> 
> Why not have the rep_nop() here between the enable, and disable ?

yes, indeed - fixed.

> > +		/*
> > +		 * If we preempted we skip this small amount of time:
>                            ^ migrated, perhaps?

yeah, fixed.

updated patch below.

	Ingo

---------------->
Subject: x86: make delay_tsc() preemptible again
From: Ingo Molnar <mingo@elte.hu>

make delay_tsc() preemptible again.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/lib/delay_32.c |   27 ++++++++++++++++++++++-----
 arch/x86/lib/delay_64.c |   29 +++++++++++++++++++++++------
 2 files changed, 45 insertions(+), 11 deletions(-)

Index: linux/arch/x86/lib/delay_32.c
===================================================================
--- linux.orig/arch/x86/lib/delay_32.c
+++ linux/arch/x86/lib/delay_32.c
@@ -38,17 +38,34 @@ static void delay_loop(unsigned long loo
 		:"0" (loops));
 }
 
-/* TSC based delay: */
+/*
+ * TSC based delay:
+ *
+ * We are careful about preemption as TSC's are per-CPU.
+ */
 static void delay_tsc(unsigned long loops)
 {
-	unsigned long bclock, now;
+	unsigned long prev, now;
+	long left = loops;
+	int prev_cpu, cpu;
 
-	preempt_disable();		/* TSC's are per-cpu */
-	rdtscl(bclock);
+	preempt_disable();
+	rdtscl(prev);
 	do {
+		prev_cpu = smp_processor_id();
+		preempt_enable();
 		rep_nop();
+		preempt_disable();
+		cpu = smp_processor_id();
 		rdtscl(now);
-	} while ((now-bclock) < loops);
+		/*
+		 * If we migrated we skip this small amount of time:
+		 */
+		if (prev_cpu != cpu)
+			prev = now;
+		left -= now - prev;
+		prev = now;
+	} while (left > 0);
 	preempt_enable();
 }
 
Index: linux/arch/x86/lib/delay_64.c
===================================================================
--- linux.orig/arch/x86/lib/delay_64.c
+++ linux/arch/x86/lib/delay_64.c
@@ -26,17 +26,34 @@ int read_current_timer(unsigned long *ti
 	return 0;
 }
 
+/*
+ * TSC based delay:
+ *
+ * We are careful about preemption as TSC's are per-CPU.
+ */
 void __delay(unsigned long loops)
 {
-	unsigned bclock, now;
+	unsigned long prev, now;
+	long left = loops;
+	int prev_cpu, cpu;
 
-	preempt_disable();		/* TSC's are pre-cpu */
-	rdtscl(bclock);
+	preempt_disable();
+	rdtscl(prev);
 	do {
-		rep_nop(); 
+		prev_cpu = smp_processor_id();
+		preempt_enable();
+		rep_nop();
+		preempt_disable();
+		cpu = smp_processor_id();
 		rdtscl(now);
-	}
-	while ((now-bclock) < loops);
+		/*
+		 * If we migrated we skip this small amount of time:
+		 */
+		if (prev_cpu != cpu)
+			prev = now;
+		left -= now - prev;
+		prev = now;
+	} while (left > 0);
 	preempt_enable();
 }
 EXPORT_SYMBOL(__delay);
