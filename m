Return-Path: <linux-kernel-owner+w=401wt.eu-S1760063AbYFOR7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063AbYFOR7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 13:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758802AbYFOR7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 13:59:15 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:55493 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758794AbYFOR7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 13:59:14 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][resubmit] x86: enable preemption in delay
Date: Sun, 15 Jun 2008 20:58:16 +0300
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi-suse@firstfloor.org>
References: <200805252108.25011.mitov@issp.bas.bg> <200806091911.21850.mitov@issp.bas.bg> <20080609161606.GA24841@elte.hu>
In-Reply-To: <20080609161606.GA24841@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806152058.17142.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 June 2008 07:16:06 pm Ingo Molnar wrote:
> > There is no principal difference between both patches. I have seen 
> > Steven's one as merged in linux-2.6.26-rc5. The only difference (if it 
> > matters of all) is that in mine patch 
> > preempt_disable()/preempt_enable() sections are shorter and protect 
> > only the code that must be protected:
> > 
> > preempt_disable()
> > rdtscl()
> > smp_processor_id()
> > preempt_enable()
> > 
> > As far as Steven's patch is already merged - let it be :-)
> 
> we could still merge your enhancements as well ontop of Steven's, if you 
> would like to pursue it. If so then please send a patch against -rc5 or 
> against -tip. Reducing the length of preempt-off sections is a fair 
> goal.
> 
> 	Ingo
> 
Well, the patch is bellow (against 2.6.26-rc6), but I would really 
appreciate your comments. 

The difference is that in Steven's version the loop is running 
mainly with preemption disabled, except for: 

		preempt_enable();
		rep_nop();
		preempt_disable();

while in the proposed version the loop is running with
preemption enabled, except for the part:

		preempt_disable();
		rdtscl(prev_1);
		cpu = smp_processor_id();
		rdtscl(now);
		preempt_enable();

I do realize that this is not a big difference as far as 
the time of loop execution is quite short.

In fact in the case of TSCs the problem is not the preemption 
itself, but the migration to another cpu after the preemption.

Why not something like that (do keep in mind I am not
an expert :-):

static void delay_tsc(unsigned long loops)
{
	get and store the mask of allowed cpus;
	/*     prevent the migration   */
	set the mask of allowed cpus to the current cpu only;
	/*     is it possible? could it be guaranteed?    */
	loop for the delay;
	restore the old mask of allowed cpus;
}

You have got the idea. Could it be realized? Is it more expensive
than the current realization? So, comments, please.

Regards,

Marin Mitov


Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

=========================================
--- a/arch/x86/lib/delay_32.c	2008-06-15 11:04:05.000000000 +0300
+++ b/arch/x86/lib/delay_32.c	2008-06-15 11:09:45.000000000 +0300
@@ -40,41 +40,42 @@ static void delay_loop(unsigned long loo
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
-	int cpu;
+	unsigned prev, prev_1, now;
+	unsigned left = loops;
+	unsigned prev_cpu, cpu;
 
 	preempt_disable();
-	cpu = smp_processor_id();
-	rdtscl(bclock);
-	for (;;) {
-		rdtscl(now);
-		if ((now - bclock) >= loops)
-			break;
+	rdtscl(prev);
+	prev_cpu = smp_processor_id();
+	preempt_enable();
+	now = prev;
 
-		/* Allow RT tasks to run */
-		preempt_enable();
+	do {
 		rep_nop();
+
+		left -= now - prev;
+		prev = now;
+
 		preempt_disable();
+		rdtscl(prev_1);
+		cpu = smp_processor_id();
+		rdtscl(now);
+		preempt_enable();
 
-		/*
-		 * It is possible that we moved to another CPU, and
-		 * since TSC's are per-cpu we need to calculate
-		 * that. The delay must guarantee that we wait "at
-		 * least" the amount of time. Being moved to another
-		 * CPU could make the wait longer but we just need to
-		 * make sure we waited long enough. Rebalance the
-		 * counter for this CPU.
-		 */
-		if (unlikely(cpu != smp_processor_id())) {
-			loops -= (now - bclock);
-			cpu = smp_processor_id();
-			rdtscl(bclock);
+		if (prev_cpu != cpu) {
+			/*
+			 * We have migrated, forget prev_cpu's tsc reading
+			 */
+			prev = prev_1;
+			prev_cpu = cpu;
 		}
-	}
-	preempt_enable();
+	} while ((now-prev) < left);
 }
 
 /*
--- a/arch/x86/lib/delay_64.c	2008-06-15 11:04:17.000000000 +0300
+++ b/arch/x86/lib/delay_64.c	2008-06-15 11:09:52.000000000 +0300
@@ -28,40 +28,42 @@ int __devinit read_current_timer(unsigne
 	return 0;
 }
 
+/* TSC based delay:
+ *
+ * We are careful about preemption as TSC's are per-CPU.
+ */
 void __delay(unsigned long loops)
 {
-	unsigned bclock, now;
-	int cpu;
+	unsigned prev, prev_1, now;
+	unsigned left = loops;
+	unsigned prev_cpu, cpu;
 
 	preempt_disable();
-	cpu = smp_processor_id();
-	rdtscl(bclock);
-	for (;;) {
-		rdtscl(now);
-		if ((now - bclock) >= loops)
-			break;
+	rdtscl(prev);
+	prev_cpu = smp_processor_id();
+	preempt_enable();
+	now = prev;
 
-		/* Allow RT tasks to run */
-		preempt_enable();
+	do {
 		rep_nop();
+
+		left -= now - prev;
+		prev = now;
+
 		preempt_disable();
+		rdtscl(prev_1);
+		cpu = smp_processor_id();
+		rdtscl(now);
+		preempt_enable();
 
-		/*
-		 * It is possible that we moved to another CPU, and
-		 * since TSC's are per-cpu we need to calculate
-		 * that. The delay must guarantee that we wait "at
-		 * least" the amount of time. Being moved to another
-		 * CPU could make the wait longer but we just need to
-		 * make sure we waited long enough. Rebalance the
-		 * counter for this CPU.
-		 */
-		if (unlikely(cpu != smp_processor_id())) {
-			loops -= (now - bclock);
-			cpu = smp_processor_id();
-			rdtscl(bclock);
+		if (prev_cpu != cpu) {
+			/*
+			 * We have migrated, forget prev_cpu's tsc reading
+			 */
+			 prev = prev_1;
+			 prev_cpu = cpu;
 		}
-	}
-	preempt_enable();
+	} while ((now-prev) < left);
 }
 EXPORT_SYMBOL(__delay);
 
