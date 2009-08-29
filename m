Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbZH2TWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbZH2TWE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 15:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZH2TWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 15:22:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47234 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbZH2TWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 15:22:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 9]  PM: Measure device suspend and resume times (was: Re: [PATCH 0/6] PM: Asynchronous suspend and resume of devices)
Date: Sat, 29 Aug 2009 21:22:59 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-rjw; KDE/4.3.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200908262217.19609.rjw@sisk.pl>
In-Reply-To: <200908262217.19609.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908292122.59398.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 August 2009, Rafael J. Wysocki wrote:
> Hi,
> 
> The following patches introduce a mechanism allowing us to execute device
> drivers' suspend and resume callbacks asynchronously during system sleep
> transitions, such as suspend to RAM.
> 
> The idea is explained in the changelogs of the first two patches.
> 
> Comments welcome.

I have one more patch that adds time measurements to the code in
drivers/base/power/main.c, so that one can easily see how much these operations
take.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Measure device suspend and resume times

Measure and print the time of suspending and resuming all devices.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   56 +++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/pm.h        |    3 ++
 kernel/power/swsusp.c     |    6 ----
 3 files changed, 59 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/power/swsusp.c
===================================================================
--- linux-2.6.orig/kernel/power/swsusp.c
+++ linux-2.6/kernel/power/swsusp.c
@@ -169,14 +169,10 @@ int swsusp_swap_in_use(void)
 void swsusp_show_speed(struct timeval *start, struct timeval *stop,
 			unsigned nr_pages, char *msg)
 {
-	s64 elapsed_centisecs64;
-	int centisecs;
+	int centisecs = pm_time_elapsed(start, stop);
 	int k;
 	int kps;
 
-	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
-	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
-	centisecs = elapsed_centisecs64;
 	if (centisecs == 0)
 		centisecs = 1;	/* avoid div-by-zero */
 	k = nr_pages * (PAGE_SIZE / 1024);
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -28,6 +28,7 @@
 #include <linux/interrupt.h>
 #include <linux/async.h>
 #include <linux/completion.h>
+#include <linux/time.h>
 
 #include "../base.h"
 #include "power.h"
@@ -434,6 +435,20 @@ static bool pm_op_started(struct device 
 	return ret;
 }
 
+/**
+ * pm_time_elapsed - Compute time elapsed between two timestamps.
+ * @start: First timestamp.
+ * @stop: Second timestamp.
+ */
+int pm_time_elapsed(struct timeval *start, struct timeval *stop)
+{
+	s64 elapsed_centisecs64;
+
+	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
+	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
+	return elapsed_centisecs64;
+}
+
 static char *pm_verb(int event)
 {
 	switch (event) {
@@ -458,6 +473,16 @@ static char *pm_verb(int event)
 	}
 }
 
+static void dpm_show_time(struct timeval *start, struct timeval *stop,
+			  pm_message_t state, const char *info)
+{
+	int centisecs = pm_time_elapsed(start, stop);
+
+	printk(KERN_INFO "PM: %s%s%s of devices complete in %d.%02d seconds\n",
+		info ? info : "", info ? " " : "", pm_verb(state.event),
+		centisecs / 100, centisecs % 100);
+}
+
 static void pm_dev_dbg(struct device *dev, pm_message_t state, char *info)
 {
 	dev_dbg(dev, "%s%s%s\n", info, pm_verb(state.event),
@@ -580,6 +605,9 @@ static int device_resume_noirq(struct de
 void dpm_resume_noirq(pm_message_t state)
 {
 	struct device *dev;
+	struct timeval start, stop;
+
+	do_gettimeofday(&start);
 
 	mutex_lock(&dpm_list_mtx);
 	transition_started = false;
@@ -595,6 +623,10 @@ void dpm_resume_noirq(pm_message_t state
 		}
 	dpm_synchronize_noirq();
 	mutex_unlock(&dpm_list_mtx);
+
+	do_gettimeofday(&stop);
+	dpm_show_time(&start, &stop, state, "EARLY");
+
 	resume_device_irqs();
 }
 EXPORT_SYMBOL_GPL(dpm_resume_noirq);
@@ -740,6 +772,9 @@ static int device_resume(struct device *
 static void dpm_resume(pm_message_t state)
 {
 	struct list_head list;
+	struct timeval start, stop;
+
+	do_gettimeofday(&start);
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
@@ -770,6 +805,9 @@ static void dpm_resume(pm_message_t stat
 	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
 	dpm_synchronize();
+
+	do_gettimeofday(&stop);
+	dpm_show_time(&start, &stop, state, NULL);
 }
 
 /**
@@ -985,8 +1023,11 @@ static int device_suspend_noirq(struct d
 int dpm_suspend_noirq(pm_message_t state)
 {
 	struct device *dev;
+	struct timeval start, stop;
 	int error = 0;
 
+	do_gettimeofday(&start);
+
 	suspend_device_irqs();
 	mutex_lock(&dpm_list_mtx);
 	pm_transition = state;
@@ -1004,8 +1045,12 @@ int dpm_suspend_noirq(pm_message_t state
 	}
 	dpm_synchronize_noirq();
 	mutex_unlock(&dpm_list_mtx);
-	if (error)
+	if (error) {
 		dpm_resume_noirq(resume_event(state));
+	} else {
+		do_gettimeofday(&stop);
+		dpm_show_time(&start, &stop, state, "LATE");
+	}
 	return error;
 }
 EXPORT_SYMBOL_GPL(dpm_suspend_noirq);
@@ -1157,8 +1202,11 @@ static int device_suspend(struct device 
 static int dpm_suspend(pm_message_t state)
 {
 	struct list_head list;
+	struct timeval start, stop;
 	int error = 0;
 
+	do_gettimeofday(&start);
+
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	pm_transition = state;
@@ -1188,6 +1236,12 @@ static int dpm_suspend(pm_message_t stat
 	list_splice(&list, dpm_list.prev);
 	mutex_unlock(&dpm_list_mtx);
 	dpm_synchronize();
+
+	if (!error) {
+		do_gettimeofday(&stop);
+		dpm_show_time(&start, &stop, state, NULL);
+	}
+
 	return error;
 }
 
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -505,6 +505,9 @@ extern int sysdev_suspend(pm_message_t s
 extern int dpm_suspend_noirq(pm_message_t state);
 extern int dpm_suspend_start(pm_message_t state);
 
+struct timeval;
+extern int pm_time_elapsed(struct timeval *start, struct timeval *stop);
+
 extern void __suspend_report_result(const char *function, void *fn, int ret);
 
 #define suspend_report_result(fn, ret)					\
