Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab0BXM3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 07:29:10 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:38529 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab0BXM2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 07:28:55 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: linuxpps@ml.enneenne.com, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
       stas@lvk.cs.msu.su, Rodolfo Giometti <giometti@enneenne.com>,
       john stultz <johnstul@us.ibm.com>,
       Alexander Gordeev <lasaine@lvk.cs.msu.su>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCHv2 3/6] pps: capture MONOTONIC_RAW timestamps as well
Date: Wed, 24 Feb 2010 15:28:14 +0300
Message-Id: <0f803a7b9dfbe3dc5024afab7c2c4ca2c839b98e.1267008049.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
References: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MONOTONIC_RAW clock timestamps are ideally suited for frequency
calculation and also fit well into the original NTP hardpps design. Now
phase and frequency can be adjusted separately: the former based on
REALTIME clock and the latter based on MONOTONIC_RAW clock.
A new function getnstime_raw_and_real is added to timekeeping subsystem
to capture both timestamps at the same time and atomically.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 include/linux/pps_kernel.h |    3 ++-
 include/linux/time.h       |    2 ++
 kernel/time/timekeeping.c  |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
index a2804c1..9bda892 100644
--- a/include/linux/pps_kernel.h
+++ b/include/linux/pps_kernel.h
@@ -41,6 +41,7 @@ struct pps_source_info {
 };
 
 struct pps_event_time {
+	struct timespec ts_raw;
 	struct pps_ktime ts_real;
 };
 
@@ -104,7 +105,7 @@ static inline void pps_get_ts(struct pps_event_time *ts)
 {
 	struct timespec ts_real;
 
-	getnstimeofday(&ts_real);
+	getnstime_raw_and_real(&ts->ts_raw, &ts_real);
 	timespec_to_pps_ktime(&ts->ts_real, ts_real);
 }
 
diff --git a/include/linux/time.h b/include/linux/time.h
index 6e026e4..edf7eb7 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -143,6 +143,8 @@ extern unsigned int alarm_setitimer(unsigned int seconds);
 extern int do_getitimer(int which, struct itimerval *value);
 extern void getnstimeofday(struct timespec *tv);
 extern void getrawmonotonic(struct timespec *ts);
+extern void getnstime_raw_and_real(struct timespec *ts_raw,
+		struct timespec *ts_real);
 extern void getboottime(struct timespec *ts);
 extern void monotonic_to_bootbased(struct timespec *ts);
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 8b709de..0ca8336 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -293,6 +293,40 @@ void ktime_get_ts(struct timespec *ts)
 EXPORT_SYMBOL_GPL(ktime_get_ts);
 
 /**
+ * getnstime_raw_and_real - Returns both the time of day an raw
+ * monotonic time in a timespec format
+ * @ts_mono_raw:	pointer to the timespec to be set to raw
+ * 			monotonic time
+ * @ts_real:		pointer to the timespec to be set to the time
+ * 			of day
+ */
+void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
+{
+	unsigned long seq;
+	s64 nsecs_raw, nsecs_real;
+
+	WARN_ON(timekeeping_suspended);
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+
+		*ts_raw = raw_time;
+		*ts_real = xtime;
+
+		nsecs_raw = timekeeping_get_ns_raw();
+		nsecs_real = timekeeping_get_ns();
+
+		/* If arch requires, add in gettimeoffset() */
+		nsecs_real += arch_gettimeoffset();
+
+	} while (read_seqretry(&xtime_lock, seq));
+
+	timespec_add_ns(ts_raw, nsecs_raw);
+	timespec_add_ns(ts_real, nsecs_real);
+}
+EXPORT_SYMBOL(getnstime_raw_and_real);
+
+/**
  * do_gettimeofday - Returns the time of day in a timeval
  * @tv:		pointer to the timeval to be set
  *
-- 
1.6.6.1

