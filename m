Return-Path: <linux-kernel-owner+w=401wt.eu-S934125AbXJOSgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125AbXJOSgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933679AbXJOSdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:33:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:47555 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933844AbXJOSdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:33:31 -0400
Message-ID: <4713B245.5080403@windriver.com>
Date: Mon, 15 Oct 2007 13:32:37 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tglx@linutronix.de
Subject: [PATCH 2/21] KGDB: Add clocksource_touch_watchdog
Content-Type: multipart/mixed;
 boundary="------------020601070800030906060506"
X-OriginalArrivalTime: 15 Oct 2007 18:33:20.0733 (UTC) FILETIME=[DC9530D0:01C80F59]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020601070800030906060506
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

--------------020601070800030906060506
Content-Type: text/x-patch;
 name="clocksource_watchdog.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="clocksource_watchdog.patch"

clocksource_watchdog.patch

From: Jason Wessel <jason.wessel@windriver.com>
CC: tglx@linutronix.de
Subject: [PATCH] Add clocksource_touch_watchdog

Add a call to the clocksource watchdog API for touching the watchdog
such that the watchdog does not trip on a context resume from a kernel
debugger.

Add in the hooks to KGDB to make use of the API.

Original implementation by Konstantin Baydarov <kbaidarov@ru.mvista.com>

Signed-off-by: Konstantin Baydarov <kbaidarov@ru.mvista.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 include/linux/clocksource.h |    1 +
 kernel/kgdb.c               |    4 ++++
 kernel/time/clocksource.c   |   12 ++++++++++++
 3 files changed, 17 insertions(+)

--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -218,6 +218,7 @@ extern int clocksource_register(struct c
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_resume(void);
+extern void clocksource_touch_watchdog(void);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -51,6 +51,7 @@
 #include <linux/sched.h>
 #include <linux/pid_namespace.h>
 #include <asm/byteorder.h>
+#include <linux/clocksource.h>
 
 extern int pid_max;
 /* How many times to count all of the waiting CPUs */
@@ -662,6 +663,7 @@ static void kgdb_wait(struct pt_regs *re
 	/* Signal the master processor that we are done */
 	atomic_set(&procindebug[processor], 0);
 	spin_unlock(&slavecpulocks[processor]);
+	clocksource_touch_watchdog();
 	local_irq_restore(flags);
 }
 #endif
@@ -1002,6 +1004,7 @@ int kgdb_handle_exception(int ex_vector,
 	    atomic_read(&cpu_doing_single_step) != procid) {
 		atomic_set(&debugger_active, 0);
 		atomic_set(&kgdb_sync, -1);
+		clocksource_touch_watchdog();
 		local_irq_restore(flags);
 		goto acquirelock;
 	}
@@ -1549,6 +1552,7 @@ default_handle:
 	/* Free debugger_active */
 	atomic_set(&debugger_active, 0);
 	atomic_set(&kgdb_sync, -1);
+	clocksource_touch_watchdog();
 	local_irq_restore(flags);
 
 	return error;
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -226,6 +226,18 @@ void clocksource_resume(void)
 }
 
 /**
+ * clocksource_touch_watchdog - Update watchdog
+ *
+ * Update the watchdog after exception contexts such as kgdb so as not
+ * to incorrectly trip the watchdog.
+ *
+ */
+void clocksource_touch_watchdog(void)
+{
+	clocksource_resume_watchdog();
+}
+
+/**
  * clocksource_get_next - Returns the selected clocksource
  *
  */

--------------020601070800030906060506--
