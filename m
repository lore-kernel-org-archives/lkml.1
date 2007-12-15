Return-Path: <linux-kernel-owner+w=401wt.eu-S933556AbXLOIKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556AbXLOIKr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 03:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbXLOIKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 03:10:39 -0500
Received: from www.tglx.de ([62.245.132.106]:46811 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbXLOIKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 03:10:38 -0500
Date: Sat, 15 Dec 2007 09:10:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Parag Warudkar <parag.warudkar@gmail.com>
cc: Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
In-Reply-To: <82e4877d0712141651j3965fd85ged2cefed5336e1ef@mail.gmail.com>
Message-ID: <alpine.LFD.0.99999.0712150907180.6933@localhost.localdomain>
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>  <alpine.LFD.0.99999.0712101117300.11977@localhost.localdomain>  <82e4877d0712102049g4830a573n86b7f72f31a42f11@mail.gmail.com>  <200712141817.47581.lenb@kernel.org>
 <82e4877d0712141651j3965fd85ged2cefed5336e1ef@mail.gmail.com>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007, Parag Warudkar wrote:

> On Dec 14, 2007 6:17 PM, Len Brown <lenb@kernel.org> wrote:
> > does processor.max_cstate=1 make the failing configuration work?
> > If yes, how about processor.max_cstate=2?
> 
> Until now 2 things were necessary to reproduce the problem -
> 1) CPU_IDLE=y and
> 2) Wakeups from Idle = 5-7 Per second (== Longer/deeper C state residency)
> 
> If I left the wakeups to high number (50-60) - there were no lockups
> but it was very jerky over ssh.
> (Typing keys had no effect for seconds etc.)
> 
> CPU_IDLE=y
> 
> With max_cstate=1 and CPU_IDLE=y things are pretty smooth - no lockups
> for the last hour. (Soft lockups used to appear in minutes
> previously.)
> 
> With max_cstate=2 - old story repeats - it's very jerky and soft
> lockups appear in under a minute after going to 3-5 wakeups from idle
> per sec.

I have a patch staged for Linus, which fixes a thinko in the broadcast
code. It might be related to your problem. Can you give it a try ?

Thanks,

	tglx

------>

Subject: clockevents: fix reprogramming decision in oneshot broadcast
From: Thomas Gleixner <tglx@linutronix.de>

A previous version of the code did the reprogramming of the broadcast
device in the return from idle code. This was removed, but the logic in
tick_handle_oneshot_broadcast() was kept the same.

When a broadcast interrupt happens we signal the expiry to all CPUs
which have an expired event. If none of the CPUs has an expired event,
which can happen in dyntick mode, then we reprogram the broadcast
device. We do not reprogram otherwise, but this is only correct if all
CPUs, which are in the idle broadcast state have been woken up.

The code ignores, that there might be pending not yet expired events on
other CPUs, which are in the idle broadcast state. So the delivery of
those events can be delayed for quite a time.

Change the tick_handle_oneshot_broadcast() function to check for CPUs,
which are in broadcast state and are not woken up by the current event,
and enforce the rearming of the broadcast device for those CPUs.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/time/tick-broadcast.c |   56 ++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 35 deletions(-)

Index: linux-x86.q/kernel/time/tick-broadcast.c
===================================================================
--- linux-x86.q.orig/kernel/time/tick-broadcast.c
+++ linux-x86.q/kernel/time/tick-broadcast.c
@@ -384,45 +384,19 @@ int tick_resume_broadcast_oneshot(struct
 }
 
 /*
- * Reprogram the broadcast device:
- *
- * Called with tick_broadcast_lock held and interrupts disabled.
- */
-static int tick_broadcast_reprogram(void)
-{
-	ktime_t expires = { .tv64 = KTIME_MAX };
-	struct tick_device *td;
-	int cpu;
-
-	/*
-	 * Find the event which expires next:
-	 */
-	for (cpu = first_cpu(tick_broadcast_oneshot_mask); cpu != NR_CPUS;
-	     cpu = next_cpu(cpu, tick_broadcast_oneshot_mask)) {
-		td = &per_cpu(tick_cpu_device, cpu);
-		if (td->evtdev->next_event.tv64 < expires.tv64)
-			expires = td->evtdev->next_event;
-	}
-
-	if (expires.tv64 == KTIME_MAX)
-		return 0;
-
-	return tick_broadcast_set_event(expires, 0);
-}
-
-/*
  * Handle oneshot mode broadcasting
  */
 static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
 {
 	struct tick_device *td;
 	cpumask_t mask;
-	ktime_t now;
+	ktime_t now, next_event;
 	int cpu;
 
 	spin_lock(&tick_broadcast_lock);
 again:
 	dev->next_event.tv64 = KTIME_MAX;
+	next_event.tv64 = KTIME_MAX;
 	mask = CPU_MASK_NONE;
 	now = ktime_get();
 	/* Find all expired events */
@@ -431,19 +405,31 @@ again:
 		td = &per_cpu(tick_cpu_device, cpu);
 		if (td->evtdev->next_event.tv64 <= now.tv64)
 			cpu_set(cpu, mask);
+		else if (td->evtdev->next_event.tv64 < next_event.tv64)
+			next_event.tv64 = td->evtdev->next_event.tv64;
 	}
 
 	/*
-	 * Wakeup the cpus which have an expired event. The broadcast
-	 * device is reprogrammed in the return from idle code.
+	 * Wakeup the cpus which have an expired event.
+	 */
+	tick_do_broadcast(mask);
+
+	/*
+	 * Two reasons for reprogram:
+	 *
+	 * - The global event did not expire any CPU local
+	 * events. This happens in dyntick mode, as the maximum PIT
+	 * delta is quite small.
+	 *
+	 * - There are pending events on sleeping CPUs which were not
+	 * in the event mask
 	 */
-	if (!tick_do_broadcast(mask)) {
+	if (next_event.tv64 != KTIME_MAX) {
 		/*
-		 * The global event did not expire any CPU local
-		 * events. This happens in dyntick mode, as the
-		 * maximum PIT delta is quite small.
+		 * Rearm the broadcast device. If event expired,
+		 * repeat the above
 		 */
-		if (tick_broadcast_reprogram())
+		if (tick_broadcast_set_event(next_event, 0))
 			goto again;
 	}
 	spin_unlock(&tick_broadcast_lock);
