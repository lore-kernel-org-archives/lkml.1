Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZLMWoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZLMWoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 17:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZLMWnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 17:43:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42409 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbZLMWnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 17:43:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/5] PM: Measure device suspend and resume times
Date: Sun, 13 Dec 2009 23:40:13 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <200912132338.30921.rjw@sisk.pl>
In-Reply-To: <200912132338.30921.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912132340.13764.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Measure and print the time of suspending and resuming all devices.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -383,6 +383,19 @@ static void pm_dev_err(struct device *de
 		kobject_name(&dev->kobj), pm_verb(state.event), info, error);
 }
 
+static void dpm_show_time(ktime_t starttime, pm_message_t state, char *info)
+{
+	ktime_t calltime, delta;
+	unsigned long long usecs;
+
+	calltime = ktime_get();
+	delta = ktime_sub(calltime, starttime);
+	usecs = (unsigned long long)ktime_to_ns(delta) >> 10;
+	pr_info("PM: %s%s%s of devices complete after %Lu.%03Lu msecs\n",
+		info ?: "", info ? " " : "", pm_verb(state.event),
+		usecs / USEC_PER_MSEC, usecs % USEC_PER_MSEC);
+}
+
 /*------------------------- Resume routines -------------------------*/
 
 /**
@@ -419,6 +432,7 @@ static int device_resume_noirq(struct de
 void dpm_resume_noirq(pm_message_t state)
 {
 	struct device *dev;
+	ktime_t starttime = ktime_get();
 
 	mutex_lock(&dpm_list_mtx);
 	transition_started = false;
@@ -432,6 +446,7 @@ void dpm_resume_noirq(pm_message_t state
 				pm_dev_err(dev, state, " early", error);
 		}
 	mutex_unlock(&dpm_list_mtx);
+	dpm_show_time(starttime, state, "early");
 	resume_device_irqs();
 }
 EXPORT_SYMBOL_GPL(dpm_resume_noirq);
@@ -524,6 +539,7 @@ static int device_resume(struct device *
 static void dpm_resume(pm_message_t state)
 {
 	struct list_head list;
+	ktime_t starttime = ktime_get();
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
@@ -554,6 +570,7 @@ static void dpm_resume(pm_message_t stat
 	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
 	async_synchronize_full();
+	dpm_show_time(starttime, state, NULL);
 }
 
 /**
@@ -686,6 +703,7 @@ static int device_suspend_noirq(struct d
 int dpm_suspend_noirq(pm_message_t state)
 {
 	struct device *dev;
+	ktime_t starttime = ktime_get();
 	int error = 0;
 
 	suspend_device_irqs();
@@ -701,6 +719,8 @@ int dpm_suspend_noirq(pm_message_t state
 	mutex_unlock(&dpm_list_mtx);
 	if (error)
 		dpm_resume_noirq(resume_event(state));
+	else
+		dpm_show_time(starttime, state, "late");
 	return error;
 }
 EXPORT_SYMBOL_GPL(dpm_suspend_noirq);
@@ -800,6 +820,7 @@ static int device_suspend(struct device 
 static int dpm_suspend(pm_message_t state)
 {
 	struct list_head list;
+	ktime_t starttime = ktime_get();
 	int error = 0;
 
 	INIT_LIST_HEAD(&list);
@@ -831,6 +852,8 @@ static int dpm_suspend(pm_message_t stat
 	async_synchronize_full();
 	if (!error)
 		error = async_error;
+	if (!error)
+		dpm_show_time(starttime, state, NULL);
 	return error;
 }
 

