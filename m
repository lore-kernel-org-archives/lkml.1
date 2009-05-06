Return-Path: <linux-kernel-owner+w=401wt.eu-S1759190AbZEFWRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190AbZEFWRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761620AbZEFVzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:55:18 -0400
Received: from kroah.org ([198.145.64.141]:57418 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761579AbZEFVzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:55:05 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:02 2009
Message-Id: <20090506214802.554117318@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:20 -0700
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
       alan@lxorguk.ukuu.org.uk, John Stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 52/58] clockevents: prevent endless loop in tick_handle_periodic()
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=clockevents-prevent-endless-loop-in-tick_handle_periodic.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: john stultz <johnstul@us.ibm.com>

commit 74a03b69d1b5ce00a568e142ca97e76b7f5239c6 upstream.

tick_handle_periodic() can lock up hard when a one shot clock event
device is used in combination with jiffies clocksource.

Avoid an endless loop issue by requiring that a highres valid
clocksource be installed before we call tick_periodic() in a loop when
using ONESHOT mode. The result is we will only increment jiffies once
per interrupt until a continuous hardware clocksource is available.

Without this, we can run into a endless loop, where each cycle through
the loop, jiffies is updated which increments time by tick_period or
more (due to clock steering), which can cause the event programming to
think the next event was before the newly incremented time and fail
causing tick_periodic() to be called again and the whole process loops
forever.

[ Impact: prevent hard lock up ]

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -93,7 +93,17 @@ void tick_handle_periodic(struct clock_event_device *dev)
 	for (;;) {
 		if (!clockevents_program_event(dev, next, ktime_get()))
 			return;
-		tick_periodic(cpu);
+		/*
+		 * Have to be careful here. If we're in oneshot mode,
+		 * before we call tick_periodic() in a loop, we need
+		 * to be sure we're using a real hardware clocksource.
+		 * Otherwise we could get trapped in an infinite
+		 * loop, as the tick_periodic() increments jiffies,
+		 * when then will increment time, posibly causing
+		 * the loop to trigger again and again.
+		 */
+		if (timekeeping_valid_for_hres())
+			tick_periodic(cpu);
 		next = ktime_add(next, tick_period);
 	}
 }


