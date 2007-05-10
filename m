Return-Path: <linux-kernel-owner+w=401wt.eu-S1762066AbXEJRMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762066AbXEJRMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 13:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761793AbXEJRLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 13:11:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761753AbXEJRLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 13:11:42 -0400
Date: Thu, 10 May 2007 19:10:25 +0200
From: Tomas Janousek <tjanouse@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       tsmetana@redhat.com, riel@redhat.com
Subject: [PATCH] Introduce boot based time
Message-ID: <3108b4e2c91097ec9469420b3f0836f0499068a6.1178816485.git.tomi@nomi.cz>
References: <1178302732.5929.23.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178302732.5929.23.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The commits
  411187fb05cd11676b0979d9fbf3291db69dbce2 (GTOD: persistent clock support)
  c1d370e167d66b10bca3b602d3740405469383de (i386: use GTOD persistent clock
    support)
changed the monotonic time so that it no longer jumps after resume, but it's
not possible to use it for boot time and process start time calculations then.
Also, the uptime no longer increases during suspend.

I add a variable to track the wall_to_monotonic changes, a function to get the
real boot time and a function to get the boot based time from the monotonic
one.

Signed-off-by: Tomas Janousek <tjanouse@redhat.com>
Cc: Tomas Smetana <tsmetana@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
---
 include/linux/time.h      |    2 ++
 kernel/time/timekeeping.c |   41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 8997b61..06f3eaf 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -116,6 +116,8 @@ extern int do_setitimer(int which, struct itimerval *value,
 extern unsigned int alarm_setitimer(unsigned int seconds);
 extern int do_getitimer(int which, struct itimerval *value);
 extern void getnstimeofday(struct timespec *tv);
+extern void getboottime(struct timespec *ts);
+extern void monotonic_to_bootbased(struct timespec *ts);
 
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_is_continuous(void);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f9217bf..dd9647a 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -36,9 +36,17 @@ EXPORT_SYMBOL(xtime_lock);
  * at zero at system boot time, so wall_to_monotonic will be negative,
  * however, we will ALWAYS keep the tv_nsec part positive so we can use
  * the usual normalization.
+ *
+ * wall_to_monotonic is moved after resume from suspend for the monotonic
+ * time not to jump. We need to add total_sleep_time to wall_to_monotonic
+ * to get the real boot based time offset.
+ *
+ * - wall_to_monotonic is no longer the boot time, getboottime must be
+ * used instead.
  */
 struct timespec xtime __attribute__ ((aligned (16)));
 struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
+static unsigned long total_sleep_time;
 
 EXPORT_SYMBOL(xtime);
 
@@ -251,6 +259,7 @@ void __init timekeeping_init(void)
 	xtime.tv_nsec = 0;
 	set_normalized_timespec(&wall_to_monotonic,
 		-xtime.tv_sec, -xtime.tv_nsec);
+	total_sleep_time = 0;
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 }
@@ -280,6 +289,7 @@ static int timekeeping_resume(struct sys_device *dev)
 
 		xtime.tv_sec += sleep_length;
 		wall_to_monotonic.tv_sec -= sleep_length;
+		total_sleep_time += sleep_length;
 	}
 	/* re-base the last cycle value */
 	clock->cycle_last = clocksource_read(clock);
@@ -474,3 +484,34 @@ void update_wall_time(void)
 	change_clocksource();
 	update_vsyscall(&xtime, clock);
 }
+
+/**
+ * getboottime - Return the real time of system boot.
+ * @ts:		pointer to the timespec to be set
+ *
+ * Returns the time of day in a timespec.
+ *
+ * This is based on the wall_to_monotonic offset and the total suspend
+ * time. Calls to settimeofday will affect the value returned (which
+ * basically means that however wrong your real time clock is at boot time,
+ * you get the right time here).
+ */
+void getboottime(struct timespec *ts)
+{
+	set_normalized_timespec(ts,
+		- (wall_to_monotonic.tv_sec + total_sleep_time),
+		- wall_to_monotonic.tv_nsec);
+}
+
+EXPORT_SYMBOL(getboottime);
+
+/**
+ * monotonic_to_bootbased - Convert the monotonic time to boot based.
+ * @ts:		pointer to the timespec to be converted
+ */
+void monotonic_to_bootbased(struct timespec *ts)
+{
+	ts->tv_sec += total_sleep_time;
+}
+
+EXPORT_SYMBOL(monotonic_to_bootbased);
-- 
1.5.1.4


-- 
TJ. (Brno, CZ), BaseOS, Red Hat
