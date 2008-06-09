Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbYFIMNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbYFIMNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 08:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbYFIMNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 08:13:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46380 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317AbYFIMNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 08:13:36 -0400
Date: Mon, 9 Jun 2008 14:13:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [PATCH][resubmit] x86: enable preemption in delay
Message-ID: <20080609121309.GA13610@elte.hu>
References: <200805252108.25011.mitov@issp.bas.bg> <alpine.LFD.1.10.0805260006110.3295@apollo.tec.linutronix.de> <200806011901.23619.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806011901.23619.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Marin Mitov <mitov@issp.bas.bg> wrote:

> Hi all,
> 
> This is a resubmit of the patch proposed by Ingo and me few month ago:
> 
> http://lkml.org/lkml/2007/11/20/343
> 
> It was in -mm for a while and then removed due to a move into the 
> mainline, but it never appeared in it.

hm, we've got this overlapping commit in -tip for the same general 
problem:

|  # x86/urgent: e71e716: x86: enable preemption in delay
|
|  From: Steven Rostedt <rostedt@goodmis.org>
|  Date: Sun, 25 May 2008 11:13:32 -0400
|  Subject: [PATCH] x86: enable preemption in delay

i think Thomas had a concern with the original fix - forgot the details.

	Ingo

------------------>
commit e71e716c531557308895598002bee24c431d3be1
Author: Steven Rostedt <rostedt@goodmis.org>
Date:   Sun May 25 11:13:32 2008 -0400

    x86: enable preemption in delay
    
    The RT team has been searching for a nasty latency. This latency shows
    up out of the blue and has been seen to be as big as 5ms!
    
    Using ftrace I found the cause of the latency.
    
       pcscd-2995  3dNh1 52360300us : irq_exit (smp_apic_timer_interrupt)
       pcscd-2995  3dN.2 52360301us : idle_cpu (irq_exit)
       pcscd-2995  3dN.2 52360301us : rcu_irq_exit (irq_exit)
       pcscd-2995  3dN.1 52360771us : smp_apic_timer_interrupt (apic_timer_interrupt
    )
       pcscd-2995  3dN.1 52360771us : exit_idle (smp_apic_timer_interrupt)
    
    Here's an example of a 400 us latency. pcscd took a timer interrupt and
    returned with "need resched" enabled, but did not reschedule until after
    the next interrupt came in at 52360771us 400us later!
    
    At first I thought we somehow missed a preemption check in entry.S. But
    I also noticed that this always seemed to happen during a __delay call.
    
       pcscd-2995  3dN.2 52360836us : rcu_irq_exit (irq_exit)
       pcscd-2995  3.N.. 52361265us : preempt_schedule (__delay)
    
    Looking at the x86 delay, I found my problem.
    
    In git commit 35d5d08a085c56f153458c3f5d8ce24123617faf, Andrew Morton
    placed preempt_disable around the entire delay due to TSC's not working
    nicely on SMP.  Unfortunately for those that care about latencies this
    is devastating! Especially when we have callers to mdelay(8).
    
    Here I enable preemption during the loop and account for anytime the task
    migrates to a new CPU. The delay asked for may be extended a bit by
    the migration, but delay only guarantees that it will delay for that minimum
    time. Delaying longer should not be an issue.
    
    [
      Thanks to Thomas Gleixner for spotting that cpu wasn't updated,
        and to place the rep_nop between preempt_enabled/disable.
    ]
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>
    Cc: akpm@osdl.org
    Cc: Clark Williams <clark.williams@gmail.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
    Cc: Gregory Haskins <ghaskins@novell.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Andi Kleen <andi-suse@firstfloor.org>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/x86/lib/delay_32.c b/arch/x86/lib/delay_32.c
index 4535e6d..d710f2d 100644
--- a/arch/x86/lib/delay_32.c
+++ b/arch/x86/lib/delay_32.c
@@ -44,13 +44,36 @@ static void delay_loop(unsigned long loops)
 static void delay_tsc(unsigned long loops)
 {
 	unsigned long bclock, now;
+	int cpu;
 
-	preempt_disable();		/* TSC's are per-cpu */
+	preempt_disable();
+	cpu = smp_processor_id();
 	rdtscl(bclock);
-	do {
-		rep_nop();
+	for (;;) {
 		rdtscl(now);
-	} while ((now-bclock) < loops);
+		if ((now - bclock) >= loops)
+			break;
+
+		/* Allow RT tasks to run */
+		preempt_enable();
+		rep_nop();
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
+			loops -= (now - bclock);
+			cpu = smp_processor_id();
+			rdtscl(bclock);
+		}
+	}
 	preempt_enable();
 }
 
diff --git a/arch/x86/lib/delay_64.c b/arch/x86/lib/delay_64.c
index bbc6105..4c441be 100644
--- a/arch/x86/lib/delay_64.c
+++ b/arch/x86/lib/delay_64.c
@@ -31,14 +31,36 @@ int __devinit read_current_timer(unsigned long *timer_value)
 void __delay(unsigned long loops)
 {
 	unsigned bclock, now;
+	int cpu;
 
-	preempt_disable();		/* TSC's are pre-cpu */
+	preempt_disable();
+	cpu = smp_processor_id();
 	rdtscl(bclock);
-	do {
-		rep_nop(); 
+	for (;;) {
 		rdtscl(now);
+		if ((now - bclock) >= loops)
+			break;
+
+		/* Allow RT tasks to run */
+		preempt_enable();
+		rep_nop();
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
+			loops -= (now - bclock);
+			cpu = smp_processor_id();
+			rdtscl(bclock);
+		}
 	}
-	while ((now-bclock) < loops);
 	preempt_enable();
 }
 EXPORT_SYMBOL(__delay);
