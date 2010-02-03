Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab0BCVH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 16:07:29 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:40339 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab0BCVHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 16:07:16 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: linuxpps@ml.enneenne.com, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
       stas@lvk.cs.msu.su, Alexander Gordeev <lasaine@lvk.cs.msu.su>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Rodolfo Giometti <giometti@linux.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       "William S\. Brasher" <billb958@door.net>,
       Reg Clemens <clemens@dwf.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H\. Peter Anvin" <hpa@linux.intel.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 2/5] pps: capture MONOTONIC_RAW timestamps as well
Date: Wed,  3 Feb 2010 23:56:48 +0300
Message-Id: <67507a9818993cfcf0139668c11569a6f3ff1981.1265228858.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <cover.1265228858.git.lasaine@lvk.cs.msu.su>
References: <cover.1265228858.git.lasaine@lvk.cs.msu.su>
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
 drivers/pps/kapi.c         |   17 +++++++++++------
 include/linux/pps_kernel.h |   33 +++++++++++++++++++++++++++++++--
 include/linux/time.h       |    2 ++
 kernel/time/timekeeping.c  |   34 ++++++++++++++++++++++++++++++++++
 4 files changed, 78 insertions(+), 8 deletions(-)

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index 2d414e2..8a77102 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -267,7 +267,7 @@ EXPORT_SYMBOL(pps_unregister_source);
  *	pps->info.echo(source, event, data);
  */
 
-void pps_event(int source, struct pps_ktime *ts, int event, void *data)
+void pps_event(int source, struct pps_event_time *ts, int event, void *data)
 {
 	struct pps_device *pps;
 	unsigned long flags;
@@ -284,7 +284,8 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
 		return;
 
 	pr_debug("PPS event on source %d at %llu.%06u\n",
-			pps->id, (unsigned long long) ts->sec, ts->nsec);
+			pps->id, (unsigned long long) ts->ts_real.sec,
+			ts->ts_real.nsec);
 
 	spin_lock_irqsave(&pps->lock, flags);
 
@@ -298,10 +299,12 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
 			(pps->params.mode & PPS_CAPTUREASSERT)) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETASSERT)
-			pps_add_offset(ts, &pps->params.assert_off_tu);
+			pps_add_offset(&ts->ts_real,
+					&pps->params.assert_off_tu);
 
 		/* Save the time stamp */
-		pps->assert_tu = *ts;
+		pps->assert_tu = ts->ts_real;
+		pps->assert_tu_raw = ts->ts_raw;
 		pps->assert_sequence++;
 		pr_debug("capture assert seq #%u for source %d\n",
 			pps->assert_sequence, source);
@@ -312,10 +315,12 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
 			(pps->params.mode & PPS_CAPTURECLEAR)) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETCLEAR)
-			pps_add_offset(ts, &pps->params.clear_off_tu);
+			pps_add_offset(&ts->ts_real,
+					&pps->params.clear_off_tu);
 
 		/* Save the time stamp */
-		pps->clear_tu = *ts;
+		pps->clear_tu = ts->ts_real;
+		pps->clear_tu_raw = ts->ts_raw;
 		pps->clear_sequence++;
 		pr_debug("capture clear seq #%u for source %d\n",
 			pps->clear_sequence, source);
diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
index e0a193f..0d36a6f 100644
--- a/include/linux/pps_kernel.h
+++ b/include/linux/pps_kernel.h
@@ -18,6 +18,10 @@
  *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#ifndef LINUX_PPS_KERNEL_H
+#define LINUX_PPS_KERNEL_H
+
+
 #include <linux/pps.h>
 
 #include <linux/cdev.h>
@@ -40,6 +44,11 @@ struct pps_source_info {
 	struct device *dev;
 };
 
+struct pps_event_time {
+	struct timespec ts_raw;
+	struct pps_ktime ts_real;
+};
+
 /* The main struct */
 struct pps_device {
 	struct pps_source_info info;		/* PSS source info */
@@ -48,6 +57,8 @@ struct pps_device {
 
 	__u32 assert_sequence;			/* PPS' assert event seq # */
 	__u32 clear_sequence;			/* PPS' clear event seq # */
+	struct timespec assert_tu_raw;
+	struct timespec clear_tu_raw;
 	struct pps_ktime assert_tu;
 	struct pps_ktime clear_tu;
 	int current_mode;			/* PPS mode at event time */
@@ -71,7 +82,6 @@ struct pps_device {
 
 extern spinlock_t pps_idr_lock;
 extern struct idr pps_idr;
-extern struct timespec pps_irq_ts[];
 
 extern struct device_attribute pps_attrs[];
 
@@ -86,4 +96,23 @@ extern int pps_register_source(struct pps_source_info *info,
 extern void pps_unregister_source(int source);
 extern int pps_register_cdev(struct pps_device *pps);
 extern void pps_unregister_cdev(struct pps_device *pps);
-extern void pps_event(int source, struct pps_ktime *ts, int event, void *data);
+extern void pps_event(int source, struct pps_event_time *ts, int event,
+		void *data);
+
+static inline void timespec_to_pps_ktime(struct pps_ktime *kt,
+		struct timespec ts)
+{
+	kt->sec = ts.tv_sec;
+	kt->nsec = ts.tv_nsec;
+}
+
+static inline void pps_get_ts(struct pps_event_time *ts)
+{
+	struct timespec ts_real;
+
+	getnstime_raw_and_real(&ts->ts_raw, &ts_real);
+	timespec_to_pps_ktime(&ts->ts_real, ts_real);
+}
+
+#endif /* LINUX_PPS_KERNEL_H */
+
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
index 66d090e..647bf35 100644
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
1.6.5

