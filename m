Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbYJGA4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbYJGA4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757847AbYJGApI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:45:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:60854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757839AbYJGApG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:45:06 -0400
Date: Mon, 6 Oct 2008 17:39:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 45/71] clockevents: broadcast fixup possible waiters
Message-ID: <20081007003925.GT3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="timer-fix-07.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit 7300711e8c6824fcfbd42a126980ff50439d8dd0 upstream

Until the C1E patches arrived there where no users of periodic broadcast
before switching to oneshot mode. Now we need to trigger a possible
waiter for a periodic broadcast when switching to oneshot mode.
Otherwise we can starve them for ever.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/tick-broadcast.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -490,6 +490,18 @@ static void tick_broadcast_clear_oneshot
 	cpu_clear(cpu, tick_broadcast_oneshot_mask);
 }
 
+static void tick_broadcast_init_next_event(cpumask_t *mask, ktime_t expires)
+{
+	struct tick_device *td;
+	int cpu;
+
+	for_each_cpu_mask_nr(cpu, *mask) {
+		td = &per_cpu(tick_cpu_device, cpu);
+		if (td->evtdev)
+			td->evtdev->next_event = expires;
+	}
+}
+
 /**
  * tick_broadcast_setup_oneshot - setup the broadcast device
  */
@@ -497,9 +509,32 @@ void tick_broadcast_setup_oneshot(struct
 {
 	/* Set it up only once ! */
 	if (bc->event_handler != tick_handle_oneshot_broadcast) {
+		int was_periodic = bc->mode == CLOCK_EVT_MODE_PERIODIC;
+		int cpu = smp_processor_id();
+		cpumask_t mask;
+
 		bc->event_handler = tick_handle_oneshot_broadcast;
 		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
-		bc->next_event.tv64 = KTIME_MAX;
+
+		/* Take the do_timer update */
+		tick_do_timer_cpu = cpu;
+
+		/*
+		 * We must be careful here. There might be other CPUs
+		 * waiting for periodic broadcast. We need to set the
+		 * oneshot_mask bits for those and program the
+		 * broadcast device to fire.
+		 */
+		mask = tick_broadcast_mask;
+		cpu_clear(cpu, mask);
+		cpus_or(tick_broadcast_oneshot_mask,
+			tick_broadcast_oneshot_mask, mask);
+
+		if (was_periodic && !cpus_empty(mask)) {
+			tick_broadcast_init_next_event(&mask, tick_next_period);
+			tick_broadcast_set_event(tick_next_period, 1);
+		} else
+			bc->next_event.tv64 = KTIME_MAX;
 	}
 }
 

-- 
