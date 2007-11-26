Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbXKZXS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbXKZXS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757373AbXKZXSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:18:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40849 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757324AbXKZXSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:18:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/6] Hibernation: Move low level resume to disk.c
Date: Tue, 27 Nov 2007 00:29:10 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200711270025.08128.rjw@sisk.pl>
In-Reply-To: <200711270025.08128.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711270029.11185.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Move the low level restore code to kernel/power/disk.c , since the
corresponding low level hibernation code is already there.

Make restore fail if device_power_down(PMSG_PRETHAW) returns an
error.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c   |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/power/power.h  |    1 -
 kernel/power/swsusp.c |   35 -----------------------------------
 3 files changed, 46 insertions(+), 37 deletions(-)

Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -275,6 +275,51 @@ int hibernation_snapshot(int platform_mo
 }
 
 /**
+ *	resume_target_kernel - prepare devices that need to be suspended with
+ *	interrupts off, restore the contents of highmem that have not been
+ *	restored yet from the image and run the low level code that will restore
+ *	the remaining contents of memory and switch to the just restored target
+ *	kernel.
+ */
+
+static int resume_target_kernel(void)
+{
+	int error;
+
+	local_irq_disable();
+	error = device_power_down(PMSG_PRETHAW);
+	if (error) {
+		printk(KERN_ERR "Some devices failed to power down, "
+			KERN_ERR "aborting resume\n");
+		goto Enable_irqs;
+	}
+	/* We'll ignore saved state, but this gets preempt count (etc) right */
+	save_processor_state();
+	error = restore_highmem();
+	if (!error) {
+		error = swsusp_arch_resume();
+		/* The code below is only ever reached in case of a failure.
+		 * Otherwise execution continues at place where
+		 * swsusp_arch_suspend() was called
+        	 */
+		BUG_ON(!error);
+		/* This call to restore_highmem() undos the previous one */
+		restore_highmem();
+	}
+	/* The only reason why swsusp_arch_resume() can fail is memory being
+	 * very tight, so we have to free it as soon as we can to avoid
+	 * subsequent failures
+	 */
+	swsusp_free();
+	restore_processor_state();
+	touch_softlockup_watchdog();
+	device_power_up();
+ Enable_irqs:
+	local_irq_enable();
+	return error;
+}
+
+/**
  *	hibernation_restore - quiesce devices and restore the hibernation
  *	snapshot image.  If successful, control returns in hibernation_snaphot()
  *	@platform_mode - if set, use the platform driver, if available, to
@@ -297,7 +342,7 @@ int hibernation_restore(int platform_mod
 	if (!error) {
 		error = disable_nonboot_cpus();
 		if (!error)
-			error = swsusp_resume();
+			error = resume_target_kernel();
 		enable_nonboot_cpus();
 	}
 	platform_restore_cleanup(platform_mode);
Index: linux-2.6/kernel/power/swsusp.c
===================================================================
--- linux-2.6.orig/kernel/power/swsusp.c
+++ linux-2.6/kernel/power/swsusp.c
@@ -261,38 +261,3 @@ int swsusp_shrink_memory(void)
 
 	return 0;
 }
-
-int swsusp_resume(void)
-{
-	int error;
-
-	local_irq_disable();
-	/* NOTE:  device_power_down() is just a suspend() with irqs off;
-	 * it has no special "power things down" semantics
-	 */
-	if (device_power_down(PMSG_PRETHAW))
-		printk(KERN_ERR "Some devices failed to power down, very bad\n");
-	/* We'll ignore saved state, but this gets preempt count (etc) right */
-	save_processor_state();
-	error = restore_highmem();
-	if (!error) {
-		error = swsusp_arch_resume();
-		/* The code below is only ever reached in case of a failure.
-		 * Otherwise execution continues at place where
-		 * swsusp_arch_suspend() was called
-        	 */
-		BUG_ON(!error);
-		/* This call to restore_highmem() undos the previous one */
-		restore_highmem();
-	}
-	/* The only reason why swsusp_arch_resume() can fail is memory being
-	 * very tight, so we have to free it as soon as we can to avoid
-	 * subsequent failures
-	 */
-	swsusp_free();
-	restore_processor_state();
-	touch_softlockup_watchdog();
-	device_power_up();
-	local_irq_enable();
-	return error;
-}
Index: linux-2.6/kernel/power/power.h
===================================================================
--- linux-2.6.orig/kernel/power/power.h
+++ linux-2.6/kernel/power/power.h
@@ -154,7 +154,6 @@ extern int swsusp_swap_in_use(void);
 extern int swsusp_check(void);
 extern int swsusp_shrink_memory(void);
 extern void swsusp_free(void);
-extern int swsusp_resume(void);
 extern int swsusp_read(unsigned int *flags_p);
 extern int swsusp_write(unsigned int flags);
 extern void swsusp_close(void);

