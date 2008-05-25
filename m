Return-Path: <linux-kernel-owner+w=401wt.eu-S1763377AbYEYMpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763377AbYEYMpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 08:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757890AbYEYMpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 08:45:41 -0400
Received: from www.tglx.de ([62.245.132.106]:53771 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762592AbYEYMpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 08:45:20 -0400
Date: Sun, 25 May 2008 14:44:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: enable preemption in delay
In-Reply-To: <Pine.LNX.4.58.0805242306280.3977@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0805251406260.3295@apollo.tec.linutronix.de>
References: <Pine.LNX.4.58.0805242306280.3977@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2008, Steven Rostedt wrote:
> The RT team has been searching for a nasty latency. This latency shows
> up out of the blue and has been seen to be as big as 5ms!
>
> @@ -44,12 +44,33 @@ static void delay_loop(unsigned long loo
>  static void delay_tsc(unsigned long loops)
>  {
>  	unsigned long bclock, now;
> +	int cpu;
> 
> -	preempt_disable();		/* TSC's are per-cpu */
> +	preempt_disable();
> +	cpu = smp_processor_id();
>  	rdtscl(bclock);
>  	do {
>  		rep_nop();
>  		rdtscl(now);
> +		/* Allow RT tasks to run */
> +		preempt_enable();
> +		preempt_disable();
> +		/*
> +		 * It is possible that we moved to another CPU,
> +		 * and since TSC's are per-cpu we need to
> +		 * calculate that. The delay must guarantee that
> +		 * we wait "at least" the amount of time. Being
> +		 * moved to another CPU could make the wait longer
> +		 * but we just need to make sure we waited long
> +		 * enough. Rebalance the counter for this CPU.
> +		 */
> +		if (unlikely(cpu != smp_processor_id())) {

Eeek, once you migrated you do this all the time. you need to update
cpu here.

> +			if ((now-bclock) >= loops)
> +				break;

Also this is really dangerous with unsynchronized TSCs. You might get
migrated and return immediately because the TSC on the other CPU is
far ahead.

What you really want is something like the patch below, but we should
reuse the sched_clock_cpu() thingy to make that simpler. Looking into
that right now.

Thanks,
	tglx

diff --git a/arch/x86/lib/delay_32.c b/arch/x86/lib/delay_32.c
index 4535e6d..66a3c32 100644
--- a/arch/x86/lib/delay_32.c
+++ b/arch/x86/lib/delay_32.c
@@ -40,17 +40,51 @@ static void delay_loop(unsigned long loops)
 		:"0" (loops));
 }
 
+/*
+ * 5 usec on a 1GHZ machine. Not necessarily correct, but not too long
+ * either.
+ */
+#define TSC_MIGRATE_COUNT 5000
+
 /* TSC based delay: */
 static void delay_tsc(unsigned long loops)
 {
 	unsigned long bclock, now;
+	int cpu;
 
-	preempt_disable();		/* TSC's are per-cpu */
+	preempt_disable();
+	cpu = smp_processor_id();
 	rdtscl(bclock);
 	do {
 		rep_nop();
-		rdtscl(now);
-	} while ((now-bclock) < loops);
+
+		/* Allow RT tasks to run */
+		preempt_enable();
+		preempt_disable();
+
+		/*
+		 * It is possible that we moved to another CPU, and
+		 * since TSC's are per-cpu we need to calculate
+		 * that. The delay must guarantee that we wait "at
+		 * least" the amount of time. Being moved to another
+		 * CPU could make the wait longer but we just need to
+		 * make sure we waited long enough. Rebalance the
+		 * counter for this CPU.
+		 */
+		if (unlikely(cpu != smp_processor_id())) {
+			if (loops <= TSC_MIGRATE_COUNT)
+				break;
+			cpu = smp_processor_id();
+			rdtscl(bclock);
+			loops -= TSC_MIGRATE_COUNT;
+		} else {
+			rdtscl(now);
+			if ((now - bclock) >= loops)
+				break;
+			loops -= (now - bclock);
+			bclock = now;
+		}
+	} while (loops > 0);
 	preempt_enable();
 }
