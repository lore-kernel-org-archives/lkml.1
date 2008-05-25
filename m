Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbYEYPNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbYEYPNn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 11:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbYEYPNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 11:13:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62240 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYEYPNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 11:13:34 -0400
Date: Sun, 25 May 2008 11:13:32 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: [PATCH -v4] x86: enable preemption in delay
In-Reply-To: <Pine.LNX.4.58.0805250948000.22651@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.58.0805251112010.23300@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805242306280.3977@gandalf.stny.rr.com>
 <alpine.LFD.1.10.0805251406260.3295@apollo.tec.linutronix.de>
 <Pine.LNX.4.58.0805250931160.20625@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0805250943010.22651@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0805250948000.22651@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
---
 arch/x86/lib/delay_32.c |   31 +++++++++++++++++++++++++++----
 arch/x86/lib/delay_64.c |   30 ++++++++++++++++++++++++++----
 2 files changed, 53 insertions(+), 8 deletions(-)

Index: linux-tip.git/arch/x86/lib/delay_32.c
===================================================================
--- linux-tip.git.orig/arch/x86/lib/delay_32.c	2008-05-22 14:51:02.000000000 -0400
+++ linux-tip.git/arch/x86/lib/delay_32.c	2008-05-25 11:09:57.000000000 -0400
@@ -44,13 +44,36 @@ static void delay_loop(unsigned long loo
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

Index: linux-tip.git/arch/x86/lib/delay_64.c
===================================================================
--- linux-tip.git.orig/arch/x86/lib/delay_64.c	2008-05-25 09:25:22.000000000 -0400
+++ linux-tip.git/arch/x86/lib/delay_64.c	2008-05-25 11:05:23.000000000 -0400
@@ -31,14 +31,36 @@ int __devinit read_current_timer(unsigne
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


