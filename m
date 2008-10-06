Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbYJFX1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbYJFX1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756886AbYJFXWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:22:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:55113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881AbYJFXWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:22:21 -0400
Date: Mon, 6 Oct 2008 16:17:31 -0700
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
Subject: [patch 15/28] clockevents: prevent endless loop lockup
Message-ID: <20081006231731.GP20567@suse.de>
References: <20081006225949.357365087@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="timer-fix-05.patch"
In-Reply-To: <20081006231639.GA20567@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit 1fb9b7d29d8e85ba3196eaa7ab871bf76fc98d36 upstream

The C1E/HPET bug reports on AMDX2/RS690 systems where tracked down to a
too small value of the HPET minumum delta for programming an event.

The clockevents code needs to enforce an interrupt event on the clock event
device in some cases. The enforcement code was stupid and naive, as it just
added the minimum delta to the current time and tried to reprogram the device.
When the minimum delta is too small, then this loops forever.

Add a sanity check. Allow reprogramming to fail 3 times, then print a warning
and double the minimum delta value to make sure, that this does not happen again.
Use the same function for both tick-oneshot and tick-broadcast code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/tick-broadcast.c |   10 +---------
 kernel/time/tick-internal.h  |    2 ++
 kernel/time/tick-oneshot.c   |   36 ++++++++++++++++++++++++++++++------
 3 files changed, 33 insertions(+), 15 deletions(-)

--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -370,16 +370,8 @@ cpumask_t *tick_get_broadcast_oneshot_ma
 static int tick_broadcast_set_event(ktime_t expires, int force)
 {
 	struct clock_event_device *bc = tick_broadcast_device.evtdev;
-	ktime_t now = ktime_get();
-	int res;
 
-	for(;;) {
-		res = clockevents_program_event(bc, expires, now);
-		if (!res || !force)
-			return res;
-		now = ktime_get();
-		expires = ktime_add(now, ktime_set(0, bc->min_delta_ns));
-	}
+	return tick_dev_program_event(bc, expires, force);
 }
 
 int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -17,6 +17,8 @@ extern void tick_handle_periodic(struct 
 extern void tick_setup_oneshot(struct clock_event_device *newdev,
 			       void (*handler)(struct clock_event_device *),
 			       ktime_t nextevt);
+extern int tick_dev_program_event(struct clock_event_device *dev,
+				  ktime_t expires, int force);
 extern int tick_program_event(ktime_t expires, int force);
 extern void tick_oneshot_notify(void);
 extern int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *));
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -25,18 +25,42 @@
 /**
  * tick_program_event internal worker function
  */
-static int __tick_program_event(struct clock_event_device *dev,
-				ktime_t expires, int force)
+int tick_dev_program_event(struct clock_event_device *dev, ktime_t expires,
+			   int force)
 {
 	ktime_t now = ktime_get();
+	int i;
 
-	while (1) {
+	for (i = 0;;) {
 		int ret = clockevents_program_event(dev, expires, now);
 
 		if (!ret || !force)
 			return ret;
+
+		/*
+		 * We tried 2 times to program the device with the given
+		 * min_delta_ns. If that's not working then we double it
+		 * and emit a warning.
+		 */
+		if (++i > 2) {
+			printk(KERN_WARNING "CE: __tick_program_event of %s is "
+			       "stuck %llx %llx\n", dev->name ? dev->name : "?",
+			       now.tv64, expires.tv64);
+			printk(KERN_WARNING
+			       "CE: increasing min_delta_ns %ld to %ld nsec\n",
+			       dev->min_delta_ns, dev->min_delta_ns << 1);
+			WARN_ON(1);
+
+			/* Double the min. delta and try again */
+			if (!dev->min_delta_ns)
+				dev->min_delta_ns = 5000;
+			else
+				dev->min_delta_ns <<= 1;
+			i = 0;
+		}
+
 		now = ktime_get();
-		expires = ktime_add(now, ktime_set(0, dev->min_delta_ns));
+		expires = ktime_add_ns(now, dev->min_delta_ns);
 	}
 }
 
@@ -47,7 +71,7 @@ int tick_program_event(ktime_t expires, 
 {
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 
-	return __tick_program_event(dev, expires, force);
+	return tick_dev_program_event(dev, expires, force);
 }
 
 /**
@@ -71,7 +95,7 @@ void tick_setup_oneshot(struct clock_eve
 {
 	newdev->event_handler = handler;
 	clockevents_set_mode(newdev, CLOCK_EVT_MODE_ONESHOT);
-	__tick_program_event(newdev, next_event, 1);
+	tick_dev_program_event(newdev, next_event, 1);
 }
 
 /**

-- 
