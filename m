Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbXKURMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbXKURMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 12:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXKURMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 12:12:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbXKURMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 12:12:05 -0500
Message-ID: <47446690.5090808@redhat.com>
Date: Wed, 21 Nov 2007 12:10:40 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jordan Russell <jr-list-2007@quo.to>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: 2.6.23.1: Random hangs during boot with "tsc" clocksource
References: <472B59E8.3080709@quo.to> <20071106221548.c8d7b41b.akpm@linux-foundation.org> <47436BA0.5050809@quo.to>
In-Reply-To: <47436BA0.5050809@quo.to>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2007 06:20 PM, Jordan Russell wrote:
>>> On Fri, 02 Nov 2007 12:10:00 -0500 Jordan Russell <jr-list-2007@quo.to> wrote:
>>> Hi,
>>>
>>> With 2.6.23.1 (stock and Fedora), roughly 50% of the time my system
>>> hangs indefinitely during the kernel boot process. The hangs occur in
>>> places where normally a brief delay is seen, such as when detecting
>>> serial ports, ATA devices, and USB hubs. SysRq+W, when it works, shows
>>> tasks stuck inside schedule_timeout and lock_timer_base.
> 
> Same problem with 2.6.23.8.
> 
> Are there any specific (TSC related?) patches I should try reverting?
> 
> Would it help if I captured the dmesg/SysRq output from one of the
> hanging boots?
> 
> Any other information that might be useful in getting to the bottom of this?
> 

Did you try this one? You are seeing problems with preemption disabled,
but it's at least worth trying.



From: Marin Mitov <mitov@issp.bas.bg>
To: linux-kernel@vger.kernel.org
Subject: [PATCH]new_TSC_based_delay_tsc()
Cc: Ingo Molnar <mingo@elte.hu>
Date: 	Tue, 20 Nov 2007 21:32:27 +0200

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
 
