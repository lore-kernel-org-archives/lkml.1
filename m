Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbXLGMMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbXLGMMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 07:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbXLGMLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 07:11:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33358 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbXLGMLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 07:11:50 -0500
Date: Fri, 7 Dec 2007 13:11:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: stefano.brivio@polimi.it
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-ID: <20071207121107.GA21049@elte.hu>
References: <20071207021952.6f0ac922@morte> <20071207084559.GA11162@elte.hu> <200712072213.06530.nickpiggin@yahoo.com.au> <20071207122310.maqkoxlb4gsg4ggc@webmail.polimi.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207122310.maqkoxlb4gsg4ggc@webmail.polimi.it>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* stefano.brivio@polimi.it <stefano.brivio@polimi.it> wrote:

>> It's a single CPU box, so sched_clock() jumping would still be 
>> problematic, no?
>
> I guess so. Definitely, it didn't look like a printk issue. Drivers 
> don't read logs, usually. But they got confused anyway (it seems that 
> udelay's get scaled or fail or somesuch - I can't test it right now, 
> will provide more feedback in a few hours).

no, i think it's just another aspect of the broken TSC on that hardware. 
Does the patch below improve things?

	Ingo

------------------->
Subject: x86: cpu_clock() based udelay
From: Ingo Molnar <mingo@elte.hu>

use cpu_clock() for TSC based udelay - it's more reliable than raw
TSC based delay loops.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/delay_32.c |   20 ++++++++++++--------
 arch/x86/lib/delay_64.c |   27 ++++++++++++++++++---------
 2 files changed, 30 insertions(+), 17 deletions(-)

Index: linux/arch/x86/lib/delay_32.c
===================================================================
--- linux.orig/arch/x86/lib/delay_32.c
+++ linux/arch/x86/lib/delay_32.c
@@ -38,17 +38,21 @@ static void delay_loop(unsigned long loo
 		:"0" (loops));
 }
 
-/* TSC based delay: */
+/* cpu_clock() [TSC] based delay: */
 static void delay_tsc(unsigned long loops)
 {
-	unsigned long bclock, now;
+	unsigned long long start, stop, now;
+	int this_cpu;
+
+	preempt_disable();
+
+	this_cpu = smp_processor_id();
+	start = now = cpu_clock(this_cpu);
+	stop = start + loops;
+
+	while ((long long)(stop - now) > 0)
+		now = cpu_clock(this_cpu);
 
-	preempt_disable();		/* TSC's are per-cpu */
-	rdtscl(bclock);
-	do {
-		rep_nop();
-		rdtscl(now);
-	} while ((now-bclock) < loops);
 	preempt_enable();
 }
 
Index: linux/arch/x86/lib/delay_64.c
===================================================================
--- linux.orig/arch/x86/lib/delay_64.c
+++ linux/arch/x86/lib/delay_64.c
@@ -26,19 +26,28 @@ int read_current_timer(unsigned long *ti
 	return 0;
 }
 
-void __delay(unsigned long loops)
+/* cpu_clock() [TSC] based delay: */
+static void delay_tsc(unsigned long loops)
 {
-	unsigned bclock, now;
+	unsigned long long start, stop, now;
+	int this_cpu;
+
+	preempt_disable();
+
+	this_cpu = smp_processor_id();
+	start = now = cpu_clock(this_cpu);
+	stop = start + loops;
+
+	while ((long long)(stop - now) > 0)
+		now = cpu_clock(this_cpu);
 
-	preempt_disable();		/* TSC's are pre-cpu */
-	rdtscl(bclock);
-	do {
-		rep_nop(); 
-		rdtscl(now);
-	}
-	while ((now-bclock) < loops);
 	preempt_enable();
 }
+
+void __delay(unsigned long loops)
+{
+	delay_tsc(loops);
+}
 EXPORT_SYMBOL(__delay);
 
 inline void __const_udelay(unsigned long xloops)
