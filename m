Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbYJFX0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbYJFX0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbYJFXWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:22:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484AbYJFXWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:22:12 -0400
Date: Mon, 6 Oct 2008 16:17:27 -0700
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
Subject: [patch 13/28] clockevents: enforce reprogram in oneshot setup
Message-ID: <20081006231727.GN20567@suse.de>
References: <20081006225949.357365087@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="timer-fix-03.patch"
In-Reply-To: <20081006231639.GA20567@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit 7205656ab48da29a95d7f55e43a81db755d3cb3a upstream

In tick_oneshot_setup we program the device to the given next_event,
but we do not check the return value. We need to make sure that the
device is programmed enforced so the interrupt handler engine starts
working. Split out the reprogramming function from tick_program_event()
and call it with the device, which was handed in to tick_setup_oneshot().
Set the force argument, so the devices is firing an interrupt.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/tick-oneshot.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -23,11 +23,11 @@
 #include "tick-internal.h"
 
 /**
- * tick_program_event
+ * tick_program_event internal worker function
  */
-int tick_program_event(ktime_t expires, int force)
+static int __tick_program_event(struct clock_event_device *dev,
+				ktime_t expires, int force)
 {
-	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	ktime_t now = ktime_get();
 
 	while (1) {
@@ -41,6 +41,16 @@ int tick_program_event(ktime_t expires, 
 }
 
 /**
+ * tick_program_event
+ */
+int tick_program_event(ktime_t expires, int force)
+{
+	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
+
+	return __tick_program_event(dev, expires, force);
+}
+
+/**
  * tick_resume_onshot - resume oneshot mode
  */
 void tick_resume_oneshot(void)
@@ -61,7 +71,7 @@ void tick_setup_oneshot(struct clock_eve
 {
 	newdev->event_handler = handler;
 	clockevents_set_mode(newdev, CLOCK_EVT_MODE_ONESHOT);
-	clockevents_program_event(newdev, next_event, ktime_get());
+	__tick_program_event(newdev, next_event, 1);
 }
 
 /**

-- 
