Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbYBYQbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbYBYQbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 11:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbYBYQ3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 11:29:35 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53947
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754672AbYBYQ3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 11:29:33 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [(RT RFC) PATCH v2 6/9] add a loop counter based timeout mechanism
To: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, pavel@ucw.cz,
       acme@redhat.com, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com, ghaskins@novell.com
Date: Mon, 25 Feb 2008 11:01:08 -0500
Message-ID: <20080225160108.11268.1451.stgit@novell1.haskins.net>
In-Reply-To: <20080225155959.11268.35541.stgit@novell1.haskins.net>
References: <20080225155959.11268.35541.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sven Dietrich <sdietrich@novell.com>

Signed-off-by: Sven Dietrich <sdietrich@novell.com>
---

 kernel/Kconfig.preempt    |   11 +++++++++++
 kernel/rtmutex.c          |    4 ++++
 kernel/rtmutex_adaptive.h |   11 +++++++++--
 kernel/sysctl.c           |   12 ++++++++++++
 4 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index d2432fa..ac1cbad 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -203,6 +203,17 @@ config ADAPTIVE_RTLOCK
 
           If unsure, say Y.
 
+config RTLOCK_DELAY
+	int "Default delay (in loops) for adaptive rtlocks"
+	range 0 1000000000
+	depends on ADAPTIVE_RTLOCK
+	default "10000"
+        help
+         This allows you to specify the maximum attempts a task will spin
+	 attempting to acquire an rtlock before sleeping.  The value is
+	 tunable at runtime via a sysctl.  A setting of 0 (zero) disables
+	 the adaptive algorithm entirely.
+
 config SPINLOCK_BKL
 	bool "Old-Style Big Kernel Lock"
 	depends on (PREEMPT || SMP) && !PREEMPT_RT
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 3802ef8..4a16b13 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -25,6 +25,10 @@
 int rtmutex_lateral_steal __read_mostly = 1;
 #endif
 
+#ifdef CONFIG_ADAPTIVE_RTLOCK
+int rtlock_timeout __read_mostly = CONFIG_RTLOCK_DELAY;
+#endif
+
 /*
  * lock->owner state tracking:
  *
diff --git a/kernel/rtmutex_adaptive.h b/kernel/rtmutex_adaptive.h
index 862c088..60c6328 100644
--- a/kernel/rtmutex_adaptive.h
+++ b/kernel/rtmutex_adaptive.h
@@ -43,6 +43,7 @@
 #ifdef CONFIG_ADAPTIVE_RTLOCK
 struct adaptive_waiter {
 	struct task_struct *owner;
+	int timeout;
 };
 
 /*
@@ -64,7 +65,7 @@ adaptive_wait(struct rt_mutex *lock, struct rt_mutex_waiter *waiter,
 {
 	int sleep = 0;
 
-	for (;;) {
+	for (; adaptive->timeout > 0; adaptive->timeout--) {
 		/*
 		 * If the task was re-awoken, break out completely so we can
 		 * reloop through the lock-acquisition code.
@@ -105,6 +106,9 @@ adaptive_wait(struct rt_mutex *lock, struct rt_mutex_waiter *waiter,
 		cpu_relax();
 	}
 
+	if (adaptive->timeout <= 0)
+		sleep = 1;
+
 	put_task_struct(adaptive->owner);
 
 	return sleep;
@@ -122,8 +126,11 @@ prepare_adaptive_wait(struct rt_mutex *lock, struct adaptive_waiter *adaptive)
 	get_task_struct(adaptive->owner);
 }
 
+extern int rtlock_timeout;
+
 #define DECLARE_ADAPTIVE_WAITER(name) \
-     struct adaptive_waiter name = { .owner = NULL, }
+     struct adaptive_waiter name = { .owner = NULL,               \
+                                     .timeout = rtlock_timeout, }
 
 #else
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c24c53d..55189ea 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -56,6 +56,8 @@
 #include <asm/stacktrace.h>
 #endif
 
+#include "rtmutex_adaptive.h"
+
 static int deprecated_sysctl_warning(struct __sysctl_args *args);
 
 #if defined(CONFIG_SYSCTL)
@@ -850,6 +852,16 @@ static struct ctl_table kern_table[] = {
 		.proc_handler   = &proc_dointvec,
        },
 #endif
+#ifdef CONFIG_ADAPTIVE_RTLOCK
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "rtlock_timeout",
+		.data		= &rtlock_timeout,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 #ifdef CONFIG_PROC_FS
 	{
 		.ctl_name       = CTL_UNNUMBERED,

