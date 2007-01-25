Return-Path: <linux-kernel-owner+w=401wt.eu-S965766AbXAYLGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965766AbXAYLGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 06:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965756AbXAYLGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 06:06:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45646 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965766AbXAYLGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 06:06:47 -0500
Date: Thu, 25 Jan 2007 12:05:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@osdl.org>, Greg KH <gregkh@suse.de>
Subject: [patch] suspend/resume debugging: device filter
Message-ID: <20070125110501.GA25151@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch] suspend/resume debugging: device filter
From: Ingo Molnar <mingo@elte.hu>

this patch implements the /sys/power/filter attribute, which takes a 
string. If a device's name matches the filter string (exactly), then 
that device is excluded from suspend/resume.

this can be helpful in a number of ways when debugging suspend and 
resume problems:

 - if CONFIG_DISABLE_CONSOLE_SUSPEND is used then the serial
   console is still suspended after which point there's no
   log output. Doing "echo serial > /sys/power/filter" keeps
   the serial port active, so any messages (and crash info)
   after that point is displayed.

 - if a device is suspected to be the reason of resume failure
   then it can be excluded via the filter. That device obviously
   wont work, but users can thus help us debug resume problems
   in combination with pm_trace, without having to hack the kernel.

(note that you can obvious break suspend/resume via the filter, by 
excluding a vital device - so it is only to be used when suspend or 
resume is broken to begin with.)

it might be better to do this centrally in sysfs, via a per-device 
attribute, to individually enable suspend and resume on a per device 
basis, but my sysfs-fu is not strong enough for that now ;-)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/base/power/resume.c  |    6 ++++
 drivers/base/power/suspend.c |    3 +-
 include/linux/resume-trace.h |    6 ++++
 kernel/power/main.c          |   58 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 72 insertions(+), 1 deletion(-)

Index: linux/drivers/base/power/resume.c
===================================================================
--- linux.orig/drivers/base/power/resume.c
+++ linux/drivers/base/power/resume.c
@@ -24,6 +24,9 @@ int resume_device(struct device * dev)
 {
 	int error = 0;
 
+	if (power_filter(dev))
+		return 0;
+
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 	down(&dev->sem);
@@ -52,6 +55,9 @@ static int resume_device_early(struct de
 {
 	int error = 0;
 
+	if (power_filter(dev))
+		return 0;
+
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 	if (dev->bus && dev->bus->resume_early) {
Index: linux/drivers/base/power/suspend.c
===================================================================
--- linux.orig/drivers/base/power/suspend.c
+++ linux/drivers/base/power/suspend.c
@@ -10,6 +10,7 @@
 
 #include <linux/device.h>
 #include <linux/kallsyms.h>
+#include <linux/resume-trace.h>
 #include <linux/pm.h>
 #include "../base.h"
 #include "power.h"
@@ -78,7 +79,7 @@ int suspend_device(struct device * dev, 
 		suspend_report_result(dev->class->suspend, error);
 	}
 
-	if (!error && dev->bus && dev->bus->suspend && !dev->power.power_state.event) {
+	if (!error && dev->bus && dev->bus->suspend && !dev->power.power_state.event && !power_filter(dev)) {
 		dev_dbg(dev, "%s%s\n",
 			suspend_verb(state.event),
 			((state.event == PM_EVENT_SUSPEND)
Index: linux/include/linux/resume-trace.h
===================================================================
--- linux.orig/include/linux/resume-trace.h
+++ linux/include/linux/resume-trace.h
@@ -9,6 +9,8 @@ struct device;
 extern void set_trace_device(struct device *);
 extern void generate_resume_trace(void *tracedata, unsigned int user);
 
+extern int power_filter(struct device *dev);
+
 #define TRACE_DEVICE(dev) set_trace_device(dev)
 #define TRACE_RESUME(user) do {					\
 	if (pm_trace_enabled) {					\
@@ -28,6 +30,10 @@ extern void generate_resume_trace(void *
 
 #define TRACE_DEVICE(dev) do { } while (0)
 #define TRACE_RESUME(dev) do { } while (0)
+static inline int power_filter(struct device *dev)
+{
+	return 0;
+}
 
 #endif
 
Index: linux/kernel/power/main.c
===================================================================
--- linux.orig/kernel/power/main.c
+++ linux/kernel/power/main.c
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/device.h>
 #include <linux/pm.h>
 #include <linux/console.h>
 #include <linux/cpu.h>
@@ -306,9 +307,66 @@ pm_trace_store(struct subsystem * subsys
 
 power_attr(pm_trace);
 
+/**
+ *	filter - exclude drivers from suspend and resume
+ *
+ *	show() returns the current filter
+ *
+ *	store() accepts a new filter (up to 128 chars long)
+ *
+ *	Do "echo serial > /sys/power/filter" to exclude the
+ *	serial driver from suspension - this can be useful to
+ *	get kernel messages out after the serial console, or to
+ *	see which device causes a resume failure.
+ */
+
+#define FILTER_LEN 128
+
+static char power_filter_str[FILTER_LEN+1] = "<none>";
+
+int power_filter(struct device *dev)
+{
+	const char *str = dev_driver_string(dev);
+
+	if (!strcmp(str, power_filter_str)) {
+		printk(KERN_INFO "power filter match for device: %s\n", str);
+		return 1;
+	}
+	return 0;
+}
+
+static ssize_t filter_show(struct subsystem * subsys, char * buf)
+{
+	char *s = buf;
+
+	s += sprintf(s, "%s\n", power_filter_str);
+
+	return (s - buf);
+}
+
+static ssize_t
+filter_store(struct subsystem * subsys, const char * buf, size_t n)
+{
+	unsigned int len;
+
+	strncpy(power_filter_str, buf, FILTER_LEN);
+
+	len = strlen(power_filter_str);
+	/*
+	 * Strip off any trailing '\n':
+	 */
+	if (len && power_filter_str[len-1] == '\n')
+		power_filter_str[len-1] = 0;
+
+	return len;
+}
+
+power_attr(filter);
+
 static struct attribute * g[] = {
 	&state_attr.attr,
 	&pm_trace_attr.attr,
+	&filter_attr.attr,
 	NULL,
 };
 #else
