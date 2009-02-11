Return-Path: <linux-kernel-owner+w=401wt.eu-S1760905AbZBKAt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905AbZBKAt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758204AbZBKAbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:31:46 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:38747 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758390AbZBKAbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:31:44 -0500
Subject: [PATCH 1/3] Create arch_gettimeoffset infrastructure for use in
 the generic timekeeping core.
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       chris@zankel.net, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1234312149.7801.26.camel@localhost>
References: <1234312149.7801.26.camel@localhost>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 16:31:39 -0800
Message-Id: <1234312299.7801.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, please consider for inclusion in -mm in preparation for 2.6.30.

Some arches don't supply their own clocksource. This is mainly the case
in architectures that get their inter-tick times by reading the counter
on their interval timer. Since these timers wrap every tick, they're not
really useful as clocksources. Wrapping them to act like one is possible
but not very efficient. So we provide a callout these arches  can
implement for use with the jiffies clocksource to provide finer then
tick granular time.

Signed-off-by: John Stultz <johnstul@us.ibm.com>


diff --git a/include/linux/time.h b/include/linux/time.h
index fbbd2a1..4768f16 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -113,6 +113,21 @@ struct timespec current_kernel_time(void);
 #define CURRENT_TIME		(current_kernel_time())
 #define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
 
+/* Some architectures do not supply their own clocksource.
+ * This is mainly the case in architectures that get their
+ * inter-tick times by reading the counter on their interval
+ * timer. Since these timers wrap every tick, they're not really
+ * useful as clocksources. Wrapping them to act like one is possible
+ * but not very efficient. So we provide a callout these arches
+ * can implement for use with the jiffies clocksource to provide
+ * finer then tick granular time.
+ */
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
+extern u32 arch_gettimeoffset(void);
+#else
+#define arch_gettimeoffset() (0)
+#endif
+
 extern void do_gettimeofday(struct timeval *tv);
 extern int do_settimeofday(struct timespec *tv);
 extern int do_sys_settimeofday(struct timespec *tv, struct timezone *tz);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 900f1b6..45d777f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -77,6 +77,10 @@ static void clocksource_forward_now(void)
 	clock->cycle_last = cycle_now;
 
 	nsec = cyc2ns(clock, cycle_delta);
+
+	/* If arch requires, add in gettimeoffset() */
+	nsec += arch_gettimeoffset();
+
 	timespec_add_ns(&xtime, nsec);
 
 	nsec = ((s64)cycle_delta * clock->mult_orig) >> clock->shift;
@@ -111,6 +115,9 @@ void getnstimeofday(struct timespec *ts)
 		/* convert to nanoseconds: */
 		nsecs = cyc2ns(clock, cycle_delta);
 
+		/* If arch requires, add in gettimeoffset() */
+		nsecs += arch_gettimeoffset();
+
 	} while (read_seqretry(&xtime_lock, seq));
 
 	timespec_add_ns(ts, nsecs);


