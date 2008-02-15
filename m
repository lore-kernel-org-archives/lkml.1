Return-Path: <linux-kernel-owner+w=401wt.eu-S1764276AbYBOU4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764276AbYBOU4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761837AbYBOUzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:55:46 -0500
Received: from mail.windriver.com ([147.11.1.11]:55870 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761587AbYBOUzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:55:45 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/7] kgdb-light-v10: clocksource watchdog
Date: Fri, 15 Feb 2008 14:55:54 -0600
Message-Id: <1203108958-1818-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1203108958-1818-3-git-send-email-jason.wessel@windriver.com>
References: <1203108958-1818-1-git-send-email-jason.wessel@windriver.com>
 <1203108958-1818-2-git-send-email-jason.wessel@windriver.com>
 <1203108958-1818-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 15 Feb 2008 20:55:34.0531 (UTC) FILETIME=[1BEEAD30:01C87015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to not trip the clocksource watchdog, kgdb must touch the
clocksource watchdog on the return to normal system run state.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/clocksource.h |    1 +
 kernel/kgdb.c               |    4 ++++
 kernel/time/clocksource.c   |   12 ++++++++++++
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 85778a4..3509447 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -216,6 +216,7 @@ static inline void clocksource_calculate_interval(struct clocksource *c,
 /* used to install a new clocksource */
 extern int clocksource_register(struct clocksource*);
 extern void clocksource_unregister(struct clocksource*);
+extern void clocksource_touch_watchdog(void);
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_resume(void);
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 21d30cf..9d42e0a 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -28,6 +28,7 @@
  * kind, whether express or implied.
  */
 #include <linux/pid_namespace.h>
+#include <linux/clocksource.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
 #include <linux/console.h>
@@ -556,6 +557,7 @@ static void kgdb_wait(struct pt_regs *regs)
 
 	/* Signal the primary CPU that we are done: */
 	atomic_set(&cpu_in_kgdb[cpu], 0);
+	clocksource_touch_watchdog();
 	local_irq_restore(flags);
 }
 #endif
@@ -1378,6 +1380,7 @@ acquirelock:
 	    atomic_read(&kgdb_cpu_doing_single_step) != cpu) {
 
 		atomic_set(&kgdb_active, -1);
+		clocksource_touch_watchdog();
 		local_irq_restore(flags);
 
 		goto acquirelock;
@@ -1469,6 +1472,7 @@ acquirelock:
 kgdb_restore:
 	/* Free kgdb_active */
 	atomic_set(&kgdb_active, -1);
+	clocksource_touch_watchdog();
 	local_irq_restore(flags);
 
 	return error;
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 548c436..ace23d3 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -228,6 +228,18 @@ void clocksource_resume(void)
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
-- 
1.5.4

