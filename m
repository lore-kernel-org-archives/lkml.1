Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbYFAQEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbYFAQEa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYFAQEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:04:20 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:43825 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbYFAQEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:04:16 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH][resubmit] x86: enable preemption in delay
Date: Sun, 1 Jun 2008 19:01:23 +0300
User-Agent: KMail/1.9.9
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi-suse@firstfloor.org>
References: <200805252108.25011.mitov@issp.bas.bg> <alpine.LFD.1.10.0805260006110.3295@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805260006110.3295@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806011901.23619.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is a resubmit of the patch proposed by Ingo and me
few month ago:

http://lkml.org/lkml/2007/11/20/343

It was in -mm for a while and then removed due to a move into
the mainline, but it never appeared in it.

As recently a new discussion started on the subject I decided
to resubmit it again.

Now it is against 2.6.25.4, but as far as there are no changes 
in the modified files it should apply to 2.6.26-rc4 too.

Comments/critics are wellcome.

Marin Mitov


Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

=========================================
--- a/arch/x86/lib/delay_32.c	2007-11-18 08:14:05.000000000 +0200
+++ b/arch/x86/lib/delay_32.c	2007-11-20 19:03:52.000000000 +0200
@@ -40,18 +40,42 @@
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
+		if (prev_cpu != cpu) {
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
@@ -28,18 +28,42 @@
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
+		if (prev_cpu != cpu) {
+			/*
+			 * We have migrated, forget prev_cpu's tsc reading
+			 */
+			 prev = prev_1;
+			 prev_cpu = cpu;
+		}
+	} while ((now-prev) < left);
 }
 EXPORT_SYMBOL(__delay);
 
-



