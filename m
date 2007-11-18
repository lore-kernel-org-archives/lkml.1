Return-Path: <linux-kernel-owner+w=401wt.eu-S1752533AbXKRJTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbXKRJTH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 04:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbXKRJSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 04:18:55 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:39585 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbXKRJSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 04:18:53 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: [PATCH]new_TSC_based_delay_tsc()
Date: Sun, 18 Nov 2007 11:20:27 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711181120.27459.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

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

Hope it is correct. Comments, please.

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
=========================================
--- a/arch/x86/lib/delay_32.c	2007-11-18 10:20:45.000000000 +0200
+++ b/arch/x86/lib/delay_32.c	2007-11-18 10:20:44.000000000 +0200
@@ -38,18 +38,41 @@
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
+		if (prev_cpu != cpu){
+			/*
+			 * We have migrated, we skip this small amount of time:
+			 */
+			prev = now;
+			prev_cpu = cpu;
+		}
+	} while ((now-prev) < left);
 }
 
 /*
--- a/arch/x86/lib/delay_64.c	2007-11-18 10:20:44.000000000 +0200
+++ b/arch/x86/lib/delay_64.c	2007-11-18 10:20:44.000000000 +0200
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
+		if (prev_cpu != cpu){
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
 

 
