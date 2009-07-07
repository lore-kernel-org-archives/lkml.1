Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbZGGMHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbZGGMHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 08:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbZGGMH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 08:07:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:56250 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365AbZGGMHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 08:07:24 -0400
Date: Tue, 7 Jul 2009 12:07:04 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:timers/core] timekeeping: Move ktime_get() functions to timekeeping.c
Message-ID: <tip-a40f262cc21fbfd781bbddcc40b16b83a75f5f34@git.kernel.org>
Git-Commit-ID: a40f262cc21fbfd781bbddcc40b16b83a75f5f34
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Jul 2009 12:07:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a40f262cc21fbfd781bbddcc40b16b83a75f5f34
Gitweb:     http://git.kernel.org/tip/a40f262cc21fbfd781bbddcc40b16b83a75f5f34
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Jul 2009 13:00:31 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 7 Jul 2009 13:00:31 +0200

timekeeping: Move ktime_get() functions to timekeeping.c

The ktime_get() functions for GENERIC_TIME=n are still located in
hrtimer.c. Move them to time/timekeeping.c where they belong.

LKML-Reference: <new-submission>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/hrtimer.c          |   60 ---------------------------------------------
 kernel/time/timekeeping.c |   59 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 57 insertions(+), 62 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 829e066..43d151f 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -48,39 +48,6 @@
 
 #include <asm/uaccess.h>
 
-#ifndef CONFIG_GENERIC_TIME
-/**
- * ktime_get - get the monotonic time in ktime_t format
- *
- * returns the time in ktime_t format
- */
-ktime_t ktime_get(void)
-{
-	struct timespec now;
-
-	ktime_get_ts(&now);
-
-	return timespec_to_ktime(now);
-}
-EXPORT_SYMBOL_GPL(ktime_get);
-#endif
-
-/**
- * ktime_get_real - get the real (wall-) time in ktime_t format
- *
- * returns the time in ktime_t format
- */
-ktime_t ktime_get_real(void)
-{
-	struct timespec now;
-
-	getnstimeofday(&now);
-
-	return timespec_to_ktime(now);
-}
-
-EXPORT_SYMBOL_GPL(ktime_get_real);
-
 /*
  * The timer bases:
  *
@@ -108,33 +75,6 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 	}
 };
 
-#ifndef CONFIG_GENERIC_TIME
-/**
- * ktime_get_ts - get the monotonic clock in timespec format
- * @ts:		pointer to timespec variable
- *
- * The function calculates the monotonic clock from the realtime
- * clock and the wall_to_monotonic offset and stores the result
- * in normalized timespec format in the variable pointed to by @ts.
- */
-void ktime_get_ts(struct timespec *ts)
-{
-	struct timespec tomono;
-	unsigned long seq;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		getnstimeofday(ts);
-		tomono = wall_to_monotonic;
-
-	} while (read_seqretry(&xtime_lock, seq));
-
-	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
-				ts->tv_nsec + tomono.tv_nsec);
-}
-EXPORT_SYMBOL_GPL(ktime_get_ts);
-#endif
-
 /*
  * Get the coarse grained time at the softirq based on xtime and
  * wall_to_monotonic.
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 7a24813..02c0b2c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -290,10 +290,65 @@ static void change_clocksource(void)
 	       clock->name);
 	 */
 }
-#else
+#else /* GENERIC_TIME */
 static inline void clocksource_forward_now(void) { }
 static inline void change_clocksource(void) { }
-#endif
+
+/**
+ * ktime_get - get the monotonic time in ktime_t format
+ *
+ * returns the time in ktime_t format
+ */
+ktime_t ktime_get(void)
+{
+	struct timespec now;
+
+	ktime_get_ts(&now);
+
+	return timespec_to_ktime(now);
+}
+EXPORT_SYMBOL_GPL(ktime_get);
+
+/**
+ * ktime_get_ts - get the monotonic clock in timespec format
+ * @ts:		pointer to timespec variable
+ *
+ * The function calculates the monotonic clock from the realtime
+ * clock and the wall_to_monotonic offset and stores the result
+ * in normalized timespec format in the variable pointed to by @ts.
+ */
+void ktime_get_ts(struct timespec *ts)
+{
+	struct timespec tomono;
+	unsigned long seq;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		getnstimeofday(ts);
+		tomono = wall_to_monotonic;
+
+	} while (read_seqretry(&xtime_lock, seq));
+
+	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
+				ts->tv_nsec + tomono.tv_nsec);
+}
+EXPORT_SYMBOL_GPL(ktime_get_ts);
+#endif /* !GENERIC_TIME */
+
+/**
+ * ktime_get_real - get the real (wall-) time in ktime_t format
+ *
+ * returns the time in ktime_t format
+ */
+ktime_t ktime_get_real(void)
+{
+	struct timespec now;
+
+	getnstimeofday(&now);
+
+	return timespec_to_ktime(now);
+}
+EXPORT_SYMBOL_GPL(ktime_get_real);
 
 /**
  * getrawmonotonic - Returns the raw monotonic time in a timespec
