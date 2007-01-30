Return-Path: <linux-kernel-owner+w=401wt.eu-S933122AbXA3K0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122AbXA3K0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 05:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932984AbXA3K0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 05:26:23 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39371 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbXA3K0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 05:26:18 -0500
Message-Id: <20070130102909.276195000@bull.net>
References: <20070130101143.296619000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 30 Jan 2007 11:11:45 +0100
From: Nadia.Derbey@bull.net
To: akpm@osdl.org, randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 2/6] AKT - auto_tuning activation
Content-Disposition: inline; filename=auto_tuning_activation.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 02/06]

Introduces the auto-tuning activation routine

The auto-tuning routine is called by the fork kernel component


Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>


---
 include/linux/akt.h |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/exit.c       |   11 +++++++++++
 kernel/fork.c       |    2 ++
 3 files changed, 64 insertions(+)

Index: linux-2.6.20-rc4/include/linux/akt.h
===================================================================
--- linux-2.6.20-rc4.orig/include/linux/akt.h	2007-01-29 14:59:38.000000000 +0100
+++ linux-2.6.20-rc4/include/linux/akt.h	2007-01-29 15:07:54.000000000 +0100
@@ -102,12 +102,22 @@ struct auto_tune {
 /*
  * Flags for a registered tunable
  */
+#define AUTO_TUNE_ENABLE  0x01
 #define TUNABLE_REGISTERED  0x02
 
 
 /*
  * When calling this routine the tunable lock should be held
  */
+static inline int is_auto_tune_enabled(struct auto_tune *tunable)
+{
+	return (tunable->flags & AUTO_TUNE_ENABLE) == AUTO_TUNE_ENABLE;
+}
+
+
+/*
+ * When calling this routine the tunable lock should be held
+ */
 static inline int is_tunable_registered(struct auto_tune *tunable)
 {
 	return (tunable->flags & TUNABLE_REGISTERED) == TUNABLE_REGISTERED;
@@ -146,6 +156,44 @@ static inline int is_tunable_registered(
 	} while (0)
 
 
+static inline void set_autotuning_routine(struct auto_tune *tunable,
+					auto_tune_fn fn)
+{
+	if (fn != NULL)
+		tunable->auto_tune = fn;
+}
+
+
+/*
+ * direction may be one of:
+ *    AKT_UP: adjust up (i.e. increase tunable value when needed)
+ *    AKT_DOWN: adjust down (i.e. decrease tunable value when needed)
+ */
+static inline int activate_auto_tuning(int direction,
+					struct auto_tune *tunable)
+{
+	int ret = 0;
+
+	BUG_ON(direction != AKT_UP && direction != AKT_DOWN);
+
+	if (tunable == NULL)
+		return 0;
+
+	spin_lock(&tunable->tunable_lck);
+
+	if (!is_auto_tune_enabled(tunable) ||
+					!is_tunable_registered(tunable)) {
+		spin_unlock(&tunable->tunable_lck);
+		return 0;
+	}
+
+	ret = tunable->auto_tune(direction, tunable);
+
+	spin_unlock(&tunable->tunable_lck);
+	return ret;
+}
+
+
 extern int register_tunable(struct auto_tune *);
 extern int unregister_tunable(struct auto_tune *);
 
@@ -155,6 +203,9 @@ extern int unregister_tunable(struct aut
 
 #define DEFINE_TUNABLE(s, thresh, min, max, tun, chk, type)
 #define set_tunable_min_max(s, min, max)         do { } while (0)
+#define set_autotuning_routine(s, fn)            do { } while (0)
+
+#define activate_auto_tuning(direction, tunable) ( { 0; } )
 
 #define register_tunable(a)                 0
 #define unregister_tunable(a)               0
Index: linux-2.6.20-rc4/kernel/exit.c
===================================================================
--- linux-2.6.20-rc4.orig/kernel/exit.c	2007-01-29 12:39:30.000000000 +0100
+++ linux-2.6.20-rc4/kernel/exit.c	2007-01-29 15:10:22.000000000 +0100
@@ -42,12 +42,15 @@
 #include <linux/audit.h> /* for audit_free() */
 #include <linux/resource.h>
 #include <linux/blkdev.h>
+#include <linux/akt.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
+extern struct auto_tune max_threads_akt;
+
 extern void sem_exit (void);
 
 static void exit_mm(struct task_struct * tsk);
@@ -172,6 +175,14 @@ repeat:
 
 	sched_exit(p);
 	write_unlock_irq(&tasklist_lock);
+
+	/*
+	 * nr_threads has been decremented in __unhash_process: adjust
+	 * max_threads down if needed
+	 * We do it here to avoid calling activate_auto_tuning under lock
+	 */
+	activate_auto_tuning(AKT_DOWN, &max_threads_akt);
+
 	proc_flush_task(p);
 	release_thread(p);
 	call_rcu(&p->rcu, delayed_put_task_struct);
Index: linux-2.6.20-rc4/kernel/fork.c
===================================================================
--- linux-2.6.20-rc4.orig/kernel/fork.c	2007-01-29 13:41:44.000000000 +0100
+++ linux-2.6.20-rc4/kernel/fork.c	2007-01-29 15:11:07.000000000 +0100
@@ -995,6 +995,8 @@ static struct task_struct *copy_process(
 	if ((clone_flags & CLONE_SIGHAND) && !(clone_flags & CLONE_VM))
 		return ERR_PTR(-EINVAL);
 
+	activate_auto_tuning(AKT_UP, &max_threads_akt);
+
 	retval = security_task_create(clone_flags);
 	if (retval)
 		goto fork_out;

--
