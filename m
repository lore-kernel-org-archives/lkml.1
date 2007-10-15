Return-Path: <linux-kernel-owner+w=401wt.eu-S933893AbXJOSez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893AbXJOSez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933358AbXJOSd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:33:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:47509 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932954AbXJOSd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:33:26 -0400
Message-ID: <4713B24A.9050700@windriver.com>
Date: Mon, 15 Oct 2007 13:32:42 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/21] KGDB: Soft lockup fixes to kgdb core
Content-Type: multipart/mixed;
 boundary="------------050305090106060206090609"
X-OriginalArrivalTime: 15 Oct 2007 18:33:26.0015 (UTC) FILETIME=[DFBB28F0:01C80F59]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050305090106060206090609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

--------------050305090106060206090609
Content-Type: text/x-patch;
 name="softlockup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="softlockup.patch"

softlockup.patch

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] Soft lockup fixes to kgdb core

Modify the softlockup code not to trap when the debugger exits after
having had the system running with the interrupts off for more than
the number of cycles that trip the softlockup detection.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 include/linux/kgdb.h |    1 +
 kernel/kgdb.c        |    4 ++++
 kernel/softlockup.c  |    9 +++++++++
 3 files changed, 14 insertions(+)

--- linux-2.6-kgdb.orig/include/linux/kgdb.h
+++ linux-2.6-kgdb/include/linux/kgdb.h
@@ -45,6 +45,7 @@ extern struct tasklet_struct kgdb_taskle
 
 extern atomic_t kgdb_setting_breakpoint;
 extern atomic_t cpu_doing_single_step;
+extern int kgdb_softlock_skip[NR_CPUS];
 
 extern struct task_struct *kgdb_usethread, *kgdb_contthread;
 
--- linux-2.6-kgdb.orig/kernel/kgdb.c
+++ linux-2.6-kgdb/kernel/kgdb.c
@@ -136,6 +136,7 @@ struct debuggerinfo_struct {
 
 /* to keep track of the CPU which is doing the single stepping*/
 atomic_t cpu_doing_single_step = ATOMIC_INIT(-1);
+int kgdb_softlock_skip[NR_CPUS];
 
 /* reboot notifier block */
 static struct notifier_block kgdb_reboot_notifier = {
@@ -664,6 +665,7 @@ static void kgdb_wait(struct pt_regs *re
 	atomic_set(&procindebug[processor], 0);
 	spin_unlock(&slavecpulocks[processor]);
 	clocksource_touch_watchdog();
+	kgdb_softlock_skip[processor] = 1;
 	local_irq_restore(flags);
 }
 #endif
@@ -1005,6 +1007,7 @@ int kgdb_handle_exception(int ex_vector,
 		atomic_set(&debugger_active, 0);
 		atomic_set(&kgdb_sync, -1);
 		clocksource_touch_watchdog();
+		kgdb_softlock_skip[procid] = 1;
 		local_irq_restore(flags);
 		goto acquirelock;
 	}
@@ -1553,6 +1556,7 @@ default_handle:
 	atomic_set(&debugger_active, 0);
 	atomic_set(&kgdb_sync, -1);
 	clocksource_touch_watchdog();
+	kgdb_softlock_skip[processor] = 1;
 	local_irq_restore(flags);
 
 	return error;
--- linux-2.6-kgdb.orig/kernel/softlockup.c
+++ linux-2.6-kgdb/kernel/softlockup.c
@@ -14,6 +14,7 @@
 #include <linux/kthread.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
+#include <linux/kgdb.h>
 
 static DEFINE_SPINLOCK(print_lock);
 
@@ -47,6 +48,10 @@ static unsigned long get_timestamp(void)
 
 void touch_softlockup_watchdog(void)
 {
+#ifdef CONFIG_KGDB
+	if (unlikely(kgdb_softlock_skip[smp_processor_id()]))
+		kgdb_softlock_skip[smp_processor_id()] = 0;
+#endif
 	__raw_get_cpu_var(touch_timestamp) = get_timestamp();
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
@@ -99,6 +104,10 @@ void softlockup_tick(void)
 
 	/* Warn about unreasonable 10+ seconds delays: */
 	if (now > (touch_timestamp + 10)) {
+#ifdef CONFIG_KGDB
+		if (unlikely(kgdb_softlock_skip[this_cpu]))
+			return;
+#endif
 		per_cpu(print_timestamp, this_cpu) = touch_timestamp;
 
 		spin_lock(&print_lock);

--------------050305090106060206090609--
