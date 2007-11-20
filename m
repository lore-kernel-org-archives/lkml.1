Return-Path: <linux-kernel-owner+w=401wt.eu-S1760798AbXKTTa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760798AbXKTTa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 14:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbXKTTav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 14:30:51 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:52779 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756724AbXKTTav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 14:30:51 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: [PATCH]new_TSC_based_delay_tsc()
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Cc: Ingo Molnar <mingo@elte.hu>
Date: Tue, 20 Nov 2007 21:32:27 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200711202132.27994.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please ignore the previous patch with the same subject.
It has a bug that can manifest itself in the very exotic case
when each do {} while() iteration executes on different cpu
leading to potentially infinite loop.

This is a patch based on the Ingo's idea/patch to track 
delay_tsc() migration to another cpu by comparing 
smp_processor_id(). It is against kernel-2.6.24-rc3.

What is different:
1. Using unsigned (instead of long) to unify for i386/x86_64.
2. Minimal preempt_disable/enable() critical sections
   (more room for preemption)
3. some statements have been rearranged, to account for
    possible under/overflow of left/TSC

Tested on both: 32/64 bit SMP PREEMPT kernel-2.6.24-rc3

Comments, please.

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
=========================================
--- a/arch/x86/lib/delay_32.c	2007-11-18 08:14:05.000000000 +0200
+++ b/arch/x86/lib/delay_32.c	2007-11-20 19:03:52.000000000 +0200
@@ -38,18 +38,42 @@
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
+	unsigned prev, prev_1, now;
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
+		rdtscl(prev_1);
+		cpu = smp_processor_id();
 		rdtscl(now);
-	} while ((now-bclock) < loops);
-	preempt_enable();
+		preempt_enable();
+
+		if (prev_cpu != cpu){
+			/*
+			 * We have migrated, forget prev_cpu's tsc reading
+			 */
+			prev = prev_1;
+			prev_cpu = cpu;
+		}
+	} while ((now-prev) < left);
 }
 
 /*
--- a/arch/x86/lib/delay_64.c	2007-11-18 08:14:40.000000000 +0200
+++ b/arch/x86/lib/delay_64.c	2007-11-20 19:47:29.000000000 +0200
@@ -26,18 +26,42 @@
 	return 0;
 }
 
+/* TSC based delay:
+ *
+ * We are careful about preemption as TSC's are per-CPU.
+ */
 void __delay(unsigned long loops)
 {
-	unsigned bclock, now;
+	unsigned prev, prev_1, now;
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
+		rdtscl(prev_1);
+		cpu = smp_processor_id();
 		rdtscl(now);
-	}
-	while ((now-bclock) < loops);
-	preempt_enable();
+		preempt_enable();
+
+		if (prev_cpu != cpu){
+			/*
+			 * We have migrated, forget prev_cpu's tsc reading
+			 */
+			 prev = prev_1;
+			 prev_cpu = cpu;
+		}
+	} while ((now-prev) < left);
 }
 EXPORT_SYMBOL(__delay);
 
