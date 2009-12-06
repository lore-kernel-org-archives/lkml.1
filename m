Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbZLFUdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbZLFUdn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757766AbZLFUdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:33:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:44763 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607AbZLFUdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:33:40 -0500
Date: Sun, 6 Dec 2009 12:35:52 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] suspend: add initcall_debug style timing for suspend/resume
Message-ID: <20091206123552.7be316b2@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From fcd52b97aa02f19baa570e4a62dfdfab0faed976 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 6 Dec 2009 12:32:28 -0800
Subject: [PATCH] suspend: add initcall_debug style timing for suspend/resume

In order to diagnose overall suspend/resume times, we need
basic instrumentation to break down the total time into per
device timing, similar to initcall_debug.

This patch adds the basic timing instrumentation, needed
for a scritps/bootgraph.pl equivalent or humans.
The bootgraph.pl program is still a work in progress, but
is far enough along to know that this patch is sufficient.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/base/power/main.c |   29 +++++++++++++++++++++++++++++
 include/linux/init.h      |    2 ++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 8aa2443..2ad345c 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -25,6 +25,7 @@
 #include <linux/resume-trace.h>
 #include <linux/rwsem.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 
 #include "../base.h"
 #include "power.h"
@@ -172,6 +173,12 @@ static int pm_op(struct device *dev,
 		 pm_message_t state)
 {
 	int error = 0;
+	ktime_t calltime, delta, rettime;
+
+	if (initcall_debug) {
+		printk("calling  %s+ @ %i\n", dev_name(dev), task_pid_nr(current));
+		calltime = ktime_get();
+	}
 
 	switch (state.event) {
 #ifdef CONFIG_SUSPEND
@@ -219,6 +226,14 @@ static int pm_op(struct device *dev,
 	default:
 		error = -EINVAL;
 	}
+
+	if (initcall_debug) {
+		rettime = ktime_get();
+		delta = ktime_sub(rettime, calltime);
+		printk("initcall %s+ returned %d after %Ld usecs\n", dev_name(dev),
+			error, (unsigned long long) ktime_to_ns(delta) >> 10);
+	}
+
 	return error;
 }
 
@@ -236,6 +251,12 @@ static int pm_noirq_op(struct device *dev,
 			pm_message_t state)
 {
 	int error = 0;
+	ktime_t calltime, delta, rettime;
+
+	if (initcall_debug) {
+		printk("calling  %s_i+ @ %i\n", dev_name(dev), task_pid_nr(current));
+		calltime = ktime_get();
+	}
 
 	switch (state.event) {
 #ifdef CONFIG_SUSPEND
@@ -283,6 +304,14 @@ static int pm_noirq_op(struct device *dev,
 	default:
 		error = -EINVAL;
 	}
+
+	if (initcall_debug) {
+		rettime = ktime_get();
+		delta = ktime_sub(rettime, calltime);
+		printk("initcall %s_i+ returned %d after %Ld usecs\n", dev_name(dev),
+			error, (unsigned long long) ktime_to_ns(delta) >> 10);
+	}
+
 	return error;
 }
 
diff --git a/include/linux/init.h b/include/linux/init.h
index ff8bde5..ab1d31f 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -149,6 +149,8 @@ void prepare_namespace(void);
 
 extern void (*late_time_init)(void);
 
+extern int initcall_debug;
+
 #endif
   
 #ifndef MODULE
-- 
1.6.2.5


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
