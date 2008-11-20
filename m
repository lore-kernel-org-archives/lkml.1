Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbYKTOnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbYKTOnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbYKTOmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:42:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40975 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbYKTOmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:42:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/45] Make the slow work pool configurable [ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:41:55 +0000
Message-ID: <20081120144155.10667.38747.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the slow work pool configurable through /proc/sys/kernel/slow-work.

 (*) /proc/sys/kernel/slow-work/min-threads

     The minimum number of threads that should be in the pool as long as it is
     in use.  This may be anywhere between 2 and max-threads.

 (*) /proc/sys/kernel/slow-work/max-threads

     The maximum number of threads that should in the pool.  This may be
     anywhere between min-threads and 255 or NR_CPUS * 2, whichever is greater.

 (*) /proc/sys/kernel/slow-work/vslow-percentage

     The percentage of active threads in the pool that may be used to execute
     very slow work items.  This may be between 1 and 99.  The resultant number
     is bounded to between 1 and one fewer than the number of active threads.
     This ensures there is always at least one thread that can process very
     slow work items, and always at least one thread that won't.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/slow-work.h |    5 ++
 kernel/slow-work.c        |  115 ++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sysctl.c           |    9 ++++
 3 files changed, 127 insertions(+), 2 deletions(-)


diff --git a/include/linux/slow-work.h b/include/linux/slow-work.h
index 16c3ea8..3be8aea 100644
--- a/include/linux/slow-work.h
+++ b/include/linux/slow-work.h
@@ -14,6 +14,8 @@
 
 #ifdef CONFIG_SLOW_WORK
 
+#include <linux/sysctl.h>
+
 struct slow_work;
 
 /*
@@ -83,6 +85,9 @@ extern int slow_work_enqueue(struct slow_work *work);
 extern int slow_work_register_user(void);
 extern void slow_work_unregister_user(void);
 
+#ifdef CONFIG_SYSCTL
+extern ctl_table slow_work_sysctls[];
+#endif
 
 #endif /* CONFIG_SLOW_WORK */
 #endif /* _LINUX_SLOW_WORK_H */
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index 313640c..3d6ce3b 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -14,7 +14,6 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/wait.h>
-#include <asm/system.h>
 
 #define SLOW_WORK_CULL_TIMEOUT (5 * HZ)	/* cull threads 5s after running out of
 					 * things to do */
@@ -24,6 +23,14 @@
 static void slow_work_cull_timeout(unsigned long);
 static void slow_work_oom_timeout(unsigned long);
 
+#ifdef CONFIG_SYSCTL
+static int slow_work_min_threads_sysctl(struct ctl_table *table, int write, struct file *filp,
+					void __user *buffer, size_t *lenp, loff_t *ppos);
+
+static int slow_work_max_threads_sysctl(struct ctl_table *table, int write, struct file *filp,
+					void __user *buffer, size_t *lenp, loff_t *ppos);
+#endif
+
 /*
  * The pool of threads has at least min threads in it as long as someone is
  * using the facility, and may have as many as max.
@@ -34,6 +41,52 @@ static unsigned slow_work_min_threads = 2;
 static unsigned slow_work_max_threads = (NR_CPUS > 4) ? NR_CPUS : 4;
 static unsigned vslow_work_proportion = 50; /* % of threads that may process
 					     * very slow work */
+
+#ifdef CONFIG_SYSCTL
+static const int slow_work_min_min_threads = 2;
+static const int slow_work_max_max_threads =
+	(NR_CPUS * 2 > 255) ? NR_CPUS * 2 : 255;
+static const int slow_work_min_vslow = 1;
+static const int slow_work_max_vslow = 99;
+
+ctl_table slow_work_sysctls[] = {
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "min-threads",
+		.data		= &slow_work_min_threads,
+		.maxlen		= sizeof(unsigned),
+		.mode		= 0644,
+		.proc_handler	= slow_work_min_threads_sysctl,
+		.extra1		= (void *) &slow_work_min_min_threads,
+		.extra2		= &slow_work_max_threads,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "max-threads",
+		.data		= &slow_work_max_threads,
+		.maxlen		= sizeof(unsigned),
+		.mode		= 0644,
+		.proc_handler	= slow_work_max_threads_sysctl,
+		.extra1		= &slow_work_min_threads,
+		.extra2		= (void *) &slow_work_max_max_threads,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "vslow-percentage",
+		.data		= &vslow_work_proportion,
+		.maxlen		= sizeof(unsigned),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.extra1		= (void *) &slow_work_min_vslow,
+		.extra2		= (void *) &slow_work_max_vslow,
+	},
+	{ .ctl_name = 0 }
+};
+#endif
+
+/*
+ * The active state of the thread pool
+ */
 static atomic_t slow_work_thread_count;
 static atomic_t vslow_work_executing_count;
 
@@ -157,7 +210,7 @@ static bool slow_work_execute(void)
 	 */
 	if (test_bit(SLOW_WORK_PENDING, &work->flags)) {
 		spin_lock_irq(&slow_work_queue_lock);
-			
+
 		if (!test_bit(SLOW_WORK_EXECUTING, &work->flags) &&
 		    test_and_clear_bit(SLOW_WORK_ENQ_DEFERRED, &work->flags))
 			goto auto_requeue;
@@ -404,6 +457,64 @@ static void slow_work_oom_timeout(unsigned long data)
 	slow_work_may_not_start_new_thread = false;
 }
 
+#ifdef CONFIG_SYSCTL
+/*
+ * Handle adjustment of the minimum number of threads
+ */
+static int slow_work_min_threads_sysctl(struct ctl_table *table, int write,
+					struct file *filp, void __user *buffer,
+					size_t *lenp, loff_t *ppos)
+{
+	int ret = proc_dointvec_minmax(table, write, filp, buffer, lenp, ppos);
+	int n;
+
+	if (ret == 0) {
+		mutex_lock(&slow_work_user_lock);
+		if (slow_work_user_count > 0) {
+			/* see if we need to start or stop threads */
+			n = atomic_read(&slow_work_thread_count) -
+				slow_work_min_threads;
+
+			if (n < 0 && !slow_work_may_not_start_new_thread)
+				slow_work_enqueue(&slow_work_new_thread);
+			else if (n > 0)
+				mod_timer(&slow_work_cull_timer,
+					  jiffies + SLOW_WORK_CULL_TIMEOUT);
+		}
+		mutex_unlock(&slow_work_user_lock);
+	}
+
+	return ret;
+}
+
+/*
+ * Handle adjustment of the maximum number of threads
+ */
+static int slow_work_max_threads_sysctl(struct ctl_table *table, int write,
+					struct file *filp, void __user *buffer,
+					size_t *lenp, loff_t *ppos)
+{
+	int ret = proc_dointvec_minmax(table, write, filp, buffer, lenp, ppos);
+	int n;
+
+	if (ret == 0) {
+		mutex_lock(&slow_work_user_lock);
+		if (slow_work_user_count > 0) {
+			/* see if we need to stop threads */
+			n = slow_work_max_threads -
+				atomic_read(&slow_work_thread_count);
+
+			if (n < 0)
+				mod_timer(&slow_work_cull_timer,
+					  jiffies + SLOW_WORK_CULL_TIMEOUT);
+		}
+		mutex_unlock(&slow_work_user_lock);
+	}
+
+	return ret;
+}
+#endif /* CONFIG_SYSCTL */
+
 /**
  * slow_work_register_user - Register a user of the facility
  *
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 5110313..81f4654 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -48,6 +48,7 @@
 #include <linux/acpi.h>
 #include <linux/reboot.h>
 #include <linux/ftrace.h>
+#include <linux/slow-work.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -853,6 +854,14 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &scan_unevictable_handler,
 	},
 #endif
+#ifdef CONFIG_SLOW_WORK
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "slow-work",
+		.mode		= 0555,
+		.child		= slow_work_sysctls,
+	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt

