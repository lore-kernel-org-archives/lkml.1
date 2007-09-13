Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbXIMOi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbXIMOi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbXIMOiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:38:19 -0400
Received: from www.osadl.org ([213.239.205.134]:49084 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751668AbXIMOiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:38:18 -0400
Subject: [PATCH] timekeeping: Prevent time going backwards on resume (V2)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Marcelo Tosatti <marcelo@kvack.org>
In-Reply-To: <20070913023519.2fea026b.akpm@linux-foundation.org>
References: <1189550194.5235.99.camel@chaos>
	 <20070913023519.2fea026b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 13 Sep 2007 16:38:15 +0200
Message-Id: <1189694295.3049.2.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timekeeping resume adjusts xtime by adding the slept time in seconds and
resets the reference value of the clock source (clock->cycle_last).
clock->cycle last is used to calculate the delta between the last xtime
update and the readout of the clock source in __get_nsec_offset(). xtime
plus the offset is the current time. The resume code ignores the delta
which had already elapsed between the last xtime update and the actual
time of suspend. If the suspend time is short, then we can see time
going backwards on resume.

Suspend:
offs_s = clock->read() - clock->cycle_last;
now = xtime + offs_s;
timekeeping_suspend_time = read_rtc();

Resume:
sleep_time = read_rtc() - timekeeping_suspend_time;
xtime.tv_sec += sleep_time;
clock->cycle_last = clock->read();
offs_r = clock->read() - clock->cycle_last;
now = xtime + offs_r;

if sleep_time_seconds == 0 and offs_r < offs_s, then time goes
backwards.

Fix this by storing the offset from the last xtime update and add it to
xtime during resume, when we reset clock->cycle_last:

sleep_time = read_rtc() - timekeeping_suspend_time;
xtime.tv_sec += sleep_time;
xtime += offs_s;        /* Fixup xtime offset at suspend time */
clock->cycle_last = clock->read();
offs_r = clock->read() - clock->cycle_last;
now = xtime + offs_r;

Thanks to Marcelo for tracking this down on the OLPC and providing the
necessary details to analyze the root cause.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index acc417b..a9cce59 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -217,6 +217,7 @@ static void change_clocksource(void)
 }
 #else
 static inline void change_clocksource(void) { }
+static inline s64 __get_nsec_offset(void) { return 0; }
 #endif
 
 /**
@@ -280,6 +281,8 @@ void __init timekeeping_init(void)
 static int timekeeping_suspended;
 /* time in seconds when suspend began */
 static unsigned long timekeeping_suspend_time;
+/* xtime offset when we went into suspend */
+static s64 timekeeping_suspend_nsecs;
 
 /**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
@@ -305,6 +308,8 @@ static int timekeeping_resume(struct sys_device *dev)
 		wall_to_monotonic.tv_sec -= sleep_length;
 		total_sleep_time += sleep_length;
 	}
+	/* Make sure that we have the correct xtime reference */
+	timespec_add_ns(&xtime, timekeeping_suspend_nsecs);
 	/* re-base the last cycle value */
 	clock->cycle_last = clocksource_read(clock);
 	clock->error = 0;
@@ -326,6 +331,8 @@ static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
 	unsigned long flags;
 
 	write_seqlock_irqsave(&xtime_lock, flags);
+	/* Get the current xtime offset */
+	timekeeping_suspend_nsecs = __get_nsec_offset();
 	timekeeping_suspended = 1;
 	timekeeping_suspend_time = read_persistent_clock();
 	write_sequnlock_irqrestore(&xtime_lock, flags);


