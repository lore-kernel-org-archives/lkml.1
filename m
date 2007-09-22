Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbXIVW3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbXIVW3b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 18:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbXIVW3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 18:29:09 -0400
Received: from www.osadl.org ([213.239.205.134]:35556 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753578AbXIVW3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 18:29:07 -0400
Message-Id: <20070922222118.882356049@linutronix.de>
References: <20070922220347.586903979@linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 22 Sep 2007 22:29:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 1/2] ACPI: disable lower idle C-states across suspend/resume
Content-Disposition: inline; filename=acpi-ignore-cstates-during-suspend.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

device_suspend() calls ACPI suspend functions, which seems to have undesired
side effects on lower idle C-states. It took me some time to realize that
especially the VAIO BIOSes (both Andrews jinxed UP and my elfstruck SMP one)
show this effect. I'm quite sure that other bug reports against suspend/resume
about turning the system into a brick have the same root cause.

After fishing in the dark for quite some time, I realized that removing the ACPI
processor module before suspend (this removes the lower C-state functionality)
made the problem disappear. Interestingly enough the propability of having a
bricked box is influenced by various factors (interrupts, size of the ram image,
...). Even adding a bunch of printks in the wrong places made the problem go
away. The previous periodic tick implementation simply pampered over the
problem, which explains why the dyntick / clockevents changes made this more
prominent.

We avoid complex functionality during the boot process and we have to do the
same during suspend/resume. It is a similar scenario and equaly fragile.

Add suspend / resume functions to the ACPI processor code and disable the lower
idle C-states across suspend/resume. Fall back to the default idle
implementation (halt) instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>

---
 drivers/acpi/processor_core.c |    2 ++
 drivers/acpi/processor_idle.c |   19 ++++++++++++++++++-
 include/acpi/processor.h      |    2 ++
 3 files changed, 22 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/processor_core.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_core.c	2007-09-23 00:01:00.000000000 +0200
+++ linux-2.6/drivers/acpi/processor_core.c	2007-09-23 00:01:00.000000000 +0200
@@ -102,6 +102,8 @@ static struct acpi_driver acpi_processor
 		.add = acpi_processor_add,
 		.remove = acpi_processor_remove,
 		.start = acpi_processor_start,
+		.suspend = acpi_processor_suspend,
+		.resume = acpi_processor_resume,
 		},
 };
 
Index: linux-2.6/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_idle.c	2007-09-23 00:01:00.000000000 +0200
+++ linux-2.6/drivers/acpi/processor_idle.c	2007-09-23 00:01:00.000000000 +0200
@@ -325,6 +325,23 @@ static void acpi_state_timer_broadcast(s
 
 #endif
 
+/*
+ * Suspend / resume control
+ */
+static int acpi_idle_suspend;
+
+int acpi_processor_suspend(struct acpi_device * device, pm_message_t state)
+{
+	acpi_idle_suspend = 1;
+	return 0;
+}
+
+int acpi_processor_resume(struct acpi_device * device)
+{
+	acpi_idle_suspend = 0;
+	return 0;
+}
+
 static void acpi_processor_idle(void)
 {
 	struct acpi_processor *pr = NULL;
@@ -355,7 +372,7 @@ static void acpi_processor_idle(void)
 	}
 
 	cx = pr->power.state;
-	if (!cx) {
+	if (!cx || acpi_idle_suspend) {
 		if (pm_idle_save)
 			pm_idle_save();
 		else
Index: linux-2.6/include/acpi/processor.h
===================================================================
--- linux-2.6.orig/include/acpi/processor.h	2007-09-23 00:01:00.000000000 +0200
+++ linux-2.6/include/acpi/processor.h	2007-09-23 00:01:00.000000000 +0200
@@ -320,6 +320,8 @@ int acpi_processor_power_init(struct acp
 int acpi_processor_cst_has_changed(struct acpi_processor *pr);
 int acpi_processor_power_exit(struct acpi_processor *pr,
 			      struct acpi_device *device);
+int acpi_processor_suspend(struct acpi_device * device, pm_message_t state);
+int acpi_processor_resume(struct acpi_device * device);
 
 /* in processor_thermal.c */
 int acpi_processor_get_limit_info(struct acpi_processor *pr);

-- 

