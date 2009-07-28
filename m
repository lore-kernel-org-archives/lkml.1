Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbZG1RSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbZG1RSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbZG1RSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:13 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:17993
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751428AbZG1RSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:03 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h87h43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DP-03-BM1-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 10/26] oprofile: Grouping multiplexing code in oprof.c
Date: Tue, 28 Jul 2009 19:07:10 +0200
Message-ID: <1248800846-25422-11-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:48.0634 (UTC) FILETIME=[5492C3A0:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves multiplexing code to a single section of code. This
reduces the use of #ifdefs especially within functions.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/oprof.c |  100 ++++++++++++++++++++++-----------------------
 1 files changed, 49 insertions(+), 51 deletions(-)

diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index fa6cccd..a48294a 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -29,13 +29,6 @@ unsigned long oprofile_backtrace_depth;
 static unsigned long is_setup;
 static DEFINE_MUTEX(start_mutex);
 
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-
-static void switch_worker(struct work_struct *work);
-static DECLARE_DELAYED_WORK(switch_work, switch_worker);
-
-#endif
-
 /* timer
    0 - use performance monitoring hardware if available
    1 - use the timer int mechanism regardless
@@ -98,9 +91,18 @@ out:
 
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
 
+static void switch_worker(struct work_struct *work);
+static DECLARE_DELAYED_WORK(switch_work, switch_worker);
+
 static void start_switch_worker(void)
 {
-	schedule_delayed_work(&switch_work, oprofile_time_slice);
+	if (oprofile_ops.switch_events)
+		schedule_delayed_work(&switch_work, oprofile_time_slice);
+}
+
+static void stop_switch_worker(void)
+{
+	cancel_delayed_work_sync(&switch_work);
 }
 
 static void switch_worker(struct work_struct *work)
@@ -109,6 +111,43 @@ static void switch_worker(struct work_struct *work)
 		start_switch_worker();
 }
 
+/* User inputs in ms, converts to jiffies */
+int oprofile_set_timeout(unsigned long val_msec)
+{
+	int err = 0;
+	unsigned long time_slice;
+
+	mutex_lock(&start_mutex);
+
+	if (oprofile_started) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	if (!oprofile_ops.switch_events) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	time_slice = msecs_to_jiffies(val_msec);
+	if (time_slice == MAX_JIFFY_OFFSET) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	oprofile_time_slice = time_slice;
+
+out:
+	mutex_unlock(&start_mutex);
+	return err;
+
+}
+
+#else
+
+static inline void start_switch_worker(void) { }
+static inline void stop_switch_worker(void) { }
+
 #endif
 
 /* Actually start profiling (echo 1>/dev/oprofile/enable) */
@@ -131,10 +170,7 @@ int oprofile_start(void)
 	if ((err = oprofile_ops.start()))
 		goto out;
 
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-	if (oprofile_ops.switch_events)
-		start_switch_worker();
-#endif
+	start_switch_worker();
 
 	oprofile_started = 1;
 out:
@@ -152,9 +188,7 @@ void oprofile_stop(void)
 	oprofile_ops.stop();
 	oprofile_started = 0;
 
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-	cancel_delayed_work_sync(&switch_work);
-#endif
+	stop_switch_worker();
 
 	/* wake up the daemon to read what remains */
 	wake_up_buffer_waiter();
@@ -188,42 +222,6 @@ post_sync:
 	mutex_unlock(&start_mutex);
 }
 
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-
-/* User inputs in ms, converts to jiffies */
-int oprofile_set_timeout(unsigned long val_msec)
-{
-	int err = 0;
-	unsigned long time_slice;
-
-	mutex_lock(&start_mutex);
-
-	if (oprofile_started) {
-		err = -EBUSY;
-		goto out;
-	}
-
-	if (!oprofile_ops.switch_events) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	time_slice = msecs_to_jiffies(val_msec);
-	if (time_slice == MAX_JIFFY_OFFSET) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	oprofile_time_slice = time_slice;
-
-out:
-	mutex_unlock(&start_mutex);
-	return err;
-
-}
-
-#endif
-
 int oprofile_set_backtrace(unsigned long val)
 {
 	int err = 0;
-- 
1.6.3.3


