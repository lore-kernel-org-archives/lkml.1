Return-Path: <linux-kernel-owner+w=401wt.eu-S933124AbYBGANq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbYBGANq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932153AbYBFX6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:58:06 -0500
Received: from mail.suse.de ([195.135.220.2]:46158 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118AbYBFX6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:58:01 -0500
Date: Wed, 6 Feb 2008 15:53:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 40/73] clockevents: fix reprogramming decision in oneshot
	broadcast
Message-ID: <20080206235311.GO13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="clockevents-fix-reprogramming-decision-in-oneshot-broadcast.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Thomas Gleixner <tglx@linutronix.de>

patch cdc6f27d9e3c2f7ca1a3e19c6eabb1ad6a2add5d in mainline.

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

--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -387,45 +387,19 @@ int tick_resume_broadcast_oneshot(struct
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
@@ -434,19 +408,31 @@ again:
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

-- 
