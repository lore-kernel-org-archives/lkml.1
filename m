Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbZIIXmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbZIIXmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbZIIXml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:42:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36009 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbZIIXmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:42:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 9/9] PM: Measure suspend and resume times for individual devices
Date: Thu, 10 Sep 2009 01:40:52 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
References: <200909100127.11252.rjw@sisk.pl>
In-Reply-To: <200909100127.11252.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909100140.52270.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If verbose PM debugging is enabled, measure and print the time of
suspending and resuming of individual devices.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   50 +++++++++++++++++++++++++++++++++++++++++-----
 kernel/power/swsusp.c     |    2 -
 2 files changed, 46 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -442,11 +442,11 @@ static bool pm_op_started(struct device 
  */
 int pm_time_elapsed(struct timeval *start, struct timeval *stop)
 {
-	s64 elapsed_centisecs64;
+	s64 elapsed_msecs64;
 
-	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
-	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
-	return elapsed_centisecs64;
+	elapsed_msecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
+	do_div(elapsed_msecs64, NSEC_PER_SEC / MSEC_PER_SEC);
+	return elapsed_msecs64;
 }
 
 static char *pm_verb(int event)
@@ -476,7 +476,7 @@ static char *pm_verb(int event)
 static void dpm_show_time(struct timeval *start, struct timeval *stop,
 			  pm_message_t state, const char *info)
 {
-	int centisecs = pm_time_elapsed(start, stop);
+	int centisecs = pm_time_elapsed(start, stop) / 10;
 
 	printk(KERN_INFO "PM: %s%s%s of devices complete in %d.%02d seconds\n",
 		info ? info : "", info ? " " : "", pm_verb(state.event),
@@ -497,6 +497,32 @@ static void pm_dev_err(struct device *de
 		kobject_name(&dev->kobj), pm_verb(state.event), info, error);
 }
 
+#ifdef DEBUG
+static inline void dbg_get_time(struct timeval *start)
+{
+	do_gettimeofday(start);
+}
+
+static void dbg_show_time(struct timeval *start, struct device *dev,
+			  pm_message_t state, char *info)
+{
+	struct timeval stop;
+	int msecs;
+
+	do_gettimeofday(&stop);
+	msecs = pm_time_elapsed(start, &stop);
+	dev_dbg(dev, "PID %d: %s%s%s complete in %d.%03d seconds\n",
+		task_pid_nr(current), info ? info : "", info ? " " : "",
+		pm_verb(state.event), msecs / 1000, msecs % 1000);
+}
+
+#else /* !DEBUG */
+static void dbg_get_time(struct timeval *start) {}
+static void dbg_show_time(struct timeval *start, struct device *dev,
+			  pm_message_t state, char *info) {}
+
+#endif /* !DEBUG */
+
 /*------------------------- Resume routines -------------------------*/
 
 /**
@@ -510,7 +536,9 @@ static void pm_dev_err(struct device *de
 static int __device_resume_noirq(struct device *dev, pm_message_t state)
 {
 	int error = 0;
+	struct timeval start;
 
+	dbg_get_time(&start);
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
@@ -523,6 +551,7 @@ static int __device_resume_noirq(struct 
 	wake_up_all(&dev->power.wait_queue);
 
 	TRACE_RESUME(error);
+	dbg_show_time(&start, dev, state, "EARLY");
 	return error;
 }
 
@@ -639,7 +668,9 @@ EXPORT_SYMBOL_GPL(dpm_resume_noirq);
 static int __device_resume(struct device *dev, pm_message_t state)
 {
 	int error = 0;
+	struct timeval start;
 
+	dbg_get_time(&start);
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
@@ -681,6 +712,7 @@ static int __device_resume(struct device
 	wake_up_all(&dev->power.wait_queue);
 
 	TRACE_RESUME(error);
+	dbg_show_time(&start, dev, state, NULL);
 	return error;
 }
 
@@ -923,6 +955,9 @@ static pm_message_t resume_event(pm_mess
 static int __device_suspend_noirq(struct device *dev, pm_message_t state)
 {
 	int error = 0;
+	struct timeval start;
+
+	dbg_get_time(&start);
 
 	if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "LATE ");
@@ -932,6 +967,7 @@ static int __device_suspend_noirq(struct
 	dev->power.op_complete = true;
 	wake_up_all(&dev->power.wait_queue);
 
+	dbg_show_time(&start, dev, state, "LATE");
 	return error;
 }
 
@@ -1063,6 +1099,9 @@ EXPORT_SYMBOL_GPL(dpm_suspend_noirq);
 static int __device_suspend(struct device *dev, pm_message_t state)
 {
 	int error = 0;
+	struct timeval start;
+
+	dbg_get_time(&start);
 
 	down(&dev->sem);
 
@@ -1103,6 +1142,7 @@ static int __device_suspend(struct devic
 	dev->power.op_complete = true;
 	wake_up_all(&dev->power.wait_queue);
 
+	dbg_show_time(&start, dev, state, NULL);
 	return error;
 }
 
Index: linux-2.6/kernel/power/swsusp.c
===================================================================
--- linux-2.6.orig/kernel/power/swsusp.c
+++ linux-2.6/kernel/power/swsusp.c
@@ -169,7 +169,7 @@ int swsusp_swap_in_use(void)
 void swsusp_show_speed(struct timeval *start, struct timeval *stop,
 			unsigned nr_pages, char *msg)
 {
-	int centisecs = pm_time_elapsed(start, stop);
+	int centisecs = pm_time_elapsed(start, stop) / 10;
 	int k;
 	int kps;
 
