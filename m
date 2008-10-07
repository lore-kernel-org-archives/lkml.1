Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbYJGAzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbYJGAzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757710AbYJGAos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:44:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:46933 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229AbYJGAor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:44:47 -0400
Date: Mon, 6 Oct 2008 17:39:12 -0700
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
Subject: [patch 40/71] clockevents: prevent endless loop in periodic
	broadcast handler
Message-ID: <20081007003912.GO3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="timer-fix-02.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit d4496b39559c6d43f83e4c08b899984f8b8089b5 upstream

The reprogramming of the periodic broadcast handler was broken,
when the first programming returned -ETIME. The clockevents code
stores the new expiry value in the clock events device next_event field
only when the programming time has not been elapsed yet. The loop in
question calculates the new expiry value from the next_event value
and therefor never increases.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/tick-broadcast.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -174,6 +174,8 @@ static void tick_do_periodic_broadcast(v
  */
 static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 {
+	ktime_t next;
+
 	tick_do_periodic_broadcast();
 
 	/*
@@ -184,10 +186,13 @@ static void tick_handle_periodic_broadca
 
 	/*
 	 * Setup the next period for devices, which do not have
-	 * periodic mode:
+	 * periodic mode. We read dev->next_event first and add to it
+	 * when the event alrady expired. clockevents_program_event()
+	 * sets dev->next_event only when the event is really
+	 * programmed to the device.
 	 */
-	for (;;) {
-		ktime_t next = ktime_add(dev->next_event, tick_period);
+	for (next = dev->next_event; ;) {
+		next = ktime_add(next, tick_period);
 
 		if (!clockevents_program_event(dev, next, ktime_get()))
 			return;

-- 
