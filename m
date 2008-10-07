Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbYJGAzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbYJGAzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbYJGAo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:44:56 -0400
Received: from ns2.suse.de ([195.135.220.15]:60789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757586AbYJGAoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:44:55 -0400
Date: Mon, 6 Oct 2008 17:39:17 -0700
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
       alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 42/71] clockevents: prevent multiple init/shutdown
Message-ID: <20081007003917.GQ3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="timer-fix-04.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit 9c17bcda991000351cb2373f78be7e4b1c44caa3 upstream

While chasing the C1E/HPET bugreports I went through the clock events
code inch by inch and found that the broadcast device can be initialized
and shutdown multiple times. Multiple shutdowns are not critical, but
useless waste of time. Multiple initializations are simply broken. Another
CPU might have the device in use already after the first initialization and
the second init could just render it unusable again.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/tick-broadcast.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -209,7 +209,7 @@ static void tick_do_broadcast_on_off(voi
 	struct clock_event_device *bc, *dev;
 	struct tick_device *td;
 	unsigned long flags, *reason = why;
-	int cpu;
+	int cpu, bc_stopped;
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
@@ -227,6 +227,8 @@ static void tick_do_broadcast_on_off(voi
 	if (!tick_device_is_functional(dev))
 		goto out;
 
+	bc_stopped = cpus_empty(tick_broadcast_mask);
+
 	switch (*reason) {
 	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
@@ -248,9 +250,10 @@ static void tick_do_broadcast_on_off(voi
 		break;
 	}
 
-	if (cpus_empty(tick_broadcast_mask))
-		clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
-	else {
+	if (cpus_empty(tick_broadcast_mask)) {
+		if (!bc_stopped)
+			clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
+	} else if (bc_stopped) {
 		if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
 			tick_broadcast_start_periodic(bc);
 		else
@@ -500,9 +503,12 @@ static void tick_broadcast_clear_oneshot
  */
 void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
-	bc->event_handler = tick_handle_oneshot_broadcast;
-	clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
-	bc->next_event.tv64 = KTIME_MAX;
+	/* Set it up only once ! */
+	if (bc->event_handler != tick_handle_oneshot_broadcast) {
+		bc->event_handler = tick_handle_oneshot_broadcast;
+		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
+		bc->next_event.tv64 = KTIME_MAX;
+	}
 }
 
 /*

-- 
