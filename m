Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbYESSF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbYESSF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 14:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761358AbYESSEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 14:04:52 -0400
Received: from 66-189-124-104.dhcp.oxfr.ma.charter.com ([66.189.124.104]:48394
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760967AbYESSEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 14:04:47 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 5/8] add a timeout mechanism to adaptive-locking
To: mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, dsingleton@mvista.com,
       dwalker@mvista.com, npiggin@suse.de, pavel@ucw.cz, acme@redhat.com,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com,
       ghaskins@novell.com
Date: Mon, 19 May 2008 13:07:39 -0400
Message-ID: <20080519170738.6820.79683.stgit@novell1.haskins.net>
In-Reply-To: <20080519170356.6820.5274.stgit@novell1.haskins.net>
References: <20080519170356.6820.5274.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sven Dietrich <sdietrich@novell.com>

The timeout is useful to eliminate excessive CPU utilization when
waiting for long-held critical sections.

Signed-off-by: Sven Dietrich <sdietrich@novell.com>
Signed-off-by: Peter Morreale <pmorreale@novell.com>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 init/main.c               |    6 ++++++
 kernel/Kconfig.preempt    |    2 ++
 kernel/Makefile           |    1 +
 kernel/rtmutex_adaptive.c |   47 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/rtmutex_adaptive.h |   17 +++++++++++++++-
 kernel/sysctl.c           |   20 +++++++++++++++++++
 6 files changed, 92 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index d64287a..9e3fd5e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -104,6 +104,11 @@ extern void alloc_rtsj_mem_early_setup(void);
 #else
 static inline void alloc_rtsj_mem_early_setup(void) { }
 #endif
+#ifdef CONFIG_ADAPTIVE_RTLOCK
+extern void adaptive_init(void);
+#else
+static inline void adaptive_init(void) { }
+#endif
 
 
 #ifdef CONFIG_TC
@@ -753,6 +758,7 @@ static void __init do_basic_setup(void)
 	driver_init();
 	init_irq_proc();
 	do_initcalls();
+	adaptive_init();
 }
 
 static int __initdata nosoftlockup;
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 45d00dc..1650711 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -179,5 +179,7 @@ config ADAPTIVE_RTLOCK
 	  offers a best of both worlds solution since we achieve both
 	  high-throughput and low-latency.
 
+	  The spin time is tuned via: /proc/sys/kernel/rtlock_timeout
+
 	  If unsure, say Y.
 
diff --git a/kernel/Makefile b/kernel/Makefile
index 9e37671..f37901e 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -35,6 +35,7 @@ ifeq ($(CONFIG_COMPAT),y)
 obj-$(CONFIG_FUTEX) += futex_compat.o
 endif
 obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
+obj-$(CONFIG_ADAPTIVE_RTLOCK) += rtmutex_adaptive.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_PREEMPT_RT) += rt.o
diff --git a/kernel/rtmutex_adaptive.c b/kernel/rtmutex_adaptive.c
new file mode 100644
index 0000000..93e33b9
--- /dev/null
+++ b/kernel/rtmutex_adaptive.c
@@ -0,0 +1,47 @@
+/*
+ * Adaptive RT lock support
+ *
+ * See Documentation/adaptive-locks.txt
+ *
+ * Copyright (C) 2008 Novell, Inc.,
+ *          Sven Dietrich, Peter Morreale, and Gregory Haskins
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; version 2
+ *  of the License.
+ */
+
+#include <linux/sched.h>
+#include "rtmutex_adaptive.h"
+
+unsigned long rtlock_timeout __read_mostly = RTLOCK_DELAY;
+unsigned long rtlock_loops   __read_mostly = 0;
+
+/*
+ * Convert nanoseconds to estimated loops
+ */
+static inline void refresh_adaptive_loops(void)
+{
+	rtlock_loops = ((u64) loops_per_jiffy * rtlock_timeout * HZ) >> 30;
+}
+
+void __init adaptive_init(void)
+{
+	refresh_adaptive_loops();
+}
+
+int proc_adaptive_timeout(struct ctl_table *table, int write,
+			  struct file *file, void __user *buffer,
+			  size_t *length, loff_t *ppos)
+{
+	proc_doulongvec_minmax(table, write, file, buffer, length, ppos);
+
+	refresh_adaptive_loops();
+
+	return 0;
+}
+
+
+
+
diff --git a/kernel/rtmutex_adaptive.h b/kernel/rtmutex_adaptive.h
index 8329e3c..0b53e31 100644
--- a/kernel/rtmutex_adaptive.h
+++ b/kernel/rtmutex_adaptive.h
@@ -15,12 +15,14 @@
 #ifndef __KERNEL_RTMUTEX_ADAPTIVE_H
 #define __KERNEL_RTMUTEX_ADAPTIVE_H
 
+#include <linux/sysctl.h>
 #include "rtmutex_common.h"
 
 
 #ifdef CONFIG_ADAPTIVE_RTLOCK
 struct adaptive_waiter {
 	struct task_struct *owner;
+	unsigned long timeout;
 };
 
 /*
@@ -42,7 +44,7 @@ adaptive_wait(struct rt_mutex *lock, struct rt_mutex_waiter *waiter,
 {
 	int sleep = 0;
 
-	for (;;) {
+	for (; adaptive->timeout > 0; adaptive->timeout--) {
 		/*
 		 * If the task was re-awoken, break out completely so we can
 		 * reloop through the lock-acquisition code.
@@ -71,6 +73,9 @@ adaptive_wait(struct rt_mutex *lock, struct rt_mutex_waiter *waiter,
 		cpu_relax();
 	}
 
+	if (adaptive->timeout <= 0)
+		sleep = 1;
+
 	put_task_struct(adaptive->owner);
 
 	return sleep;
@@ -88,9 +93,19 @@ prepare_adaptive_wait(struct rt_mutex *lock, struct adaptive_waiter *adaptive)
 	get_task_struct(adaptive->owner);
 }
 
+extern int proc_adaptive_timeout(struct ctl_table *table, int write,
+				struct file *file, void __user *buffer,
+				size_t *length, loff_t *ppos);
+
+extern unsigned long rtlock_loops;
+extern unsigned long rtlock_timeout;
+
+#define RTLOCK_DELAY	4000 /* Default delay in nanoseconds */
+
 #define DECLARE_ADAPTIVE_WAITER(name)                       \
      struct adaptive_waiter name = {                        \
 	.owner = NULL,                                      \
+	.timeout = rtlock_loops,                            \
 }
 
 #else
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4cf02a8..63e1325 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -57,6 +57,8 @@
 #include <asm/io.h>
 #endif
 
+#include "rtmutex_adaptive.h"
+
 static int deprecated_sysctl_warning(struct __sysctl_args *args);
 
 #if defined(CONFIG_SYSCTL)
@@ -882,6 +884,24 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_ADAPTIVE_RTLOCK
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "rtlock_timeout",
+		.data		= &rtlock_timeout,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= &proc_adaptive_timeout,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "rtlock_loops",
+		.data		= &rtlock_loops,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0444,
+		.proc_handler	= &proc_doulongvec_minmax,
+	},
+#endif
 #ifdef CONFIG_PROC_FS
 	{
 		.ctl_name       = CTL_UNNUMBERED,

