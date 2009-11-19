Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZKSRUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZKSRUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZKSRUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:20:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbZKSRUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:20:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/28] SLOW_WORK: Wait for outstanding work items belonging to
	a module to clear
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:20:39 +0000
Message-ID: <20091119172039.1679.7892.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wait for outstanding slow work items belonging to a module to clear when
unregistering that module as a user of the facility.  This prevents the put_ref
code of a work item from being taken away before it returns.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/slow-work.txt |   13 +++-
 fs/fscache/main.c           |    6 +-
 fs/fscache/object.c         |    1 
 fs/fscache/operation.c      |    1 
 fs/gfs2/main.c              |    4 +
 fs/gfs2/recovery.c          |    1 
 include/linux/slow-work.h   |    8 ++-
 kernel/slow-work.c          |  132 +++++++++++++++++++++++++++++++++++++++++--
 8 files changed, 150 insertions(+), 16 deletions(-)

diff --git a/Documentation/slow-work.txt b/Documentation/slow-work.txt
index ebc50f8..f12fda3 100644
--- a/Documentation/slow-work.txt
+++ b/Documentation/slow-work.txt
@@ -64,9 +64,11 @@ USING SLOW WORK ITEMS
 Firstly, a module or subsystem wanting to make use of slow work items must
 register its interest:
 
-	 int ret = slow_work_register_user();
+	 int ret = slow_work_register_user(struct module *module);
 
-This will return 0 if successful, or a -ve error upon failure.
+This will return 0 if successful, or a -ve error upon failure.  The module
+pointer should be the module interested in using this facility (almost
+certainly THIS_MODULE).
 
 
 Slow work items may then be set up by:
@@ -110,7 +112,12 @@ operation.  When all a module's slow work items have been processed, and the
 module has no further interest in the facility, it should unregister its
 interest:
 
-	slow_work_unregister_user();
+	slow_work_unregister_user(struct module *module);
+
+The module pointer is used to wait for all outstanding work items for that
+module before completing the unregistration.  This prevents the put_ref() code
+from being taken away before it completes.  module should almost certainly be
+THIS_MODULE.
 
 
 ===============
diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 4de41b5..add6bdb 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -48,7 +48,7 @@ static int __init fscache_init(void)
 {
 	int ret;
 
-	ret = slow_work_register_user();
+	ret = slow_work_register_user(THIS_MODULE);
 	if (ret < 0)
 		goto error_slow_work;
 
@@ -80,7 +80,7 @@ error_kobj:
 error_cookie_jar:
 	fscache_proc_cleanup();
 error_proc:
-	slow_work_unregister_user();
+	slow_work_unregister_user(THIS_MODULE);
 error_slow_work:
 	return ret;
 }
@@ -97,7 +97,7 @@ static void __exit fscache_exit(void)
 	kobject_put(fscache_root);
 	kmem_cache_destroy(fscache_cookie_jar);
 	fscache_proc_cleanup();
-	slow_work_unregister_user();
+	slow_work_unregister_user(THIS_MODULE);
 	printk(KERN_NOTICE "FS-Cache: Unloaded\n");
 }
 
diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index 392a41b..d236eb1 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -45,6 +45,7 @@ static void fscache_enqueue_dependents(struct fscache_object *);
 static void fscache_dequeue_object(struct fscache_object *);
 
 const struct slow_work_ops fscache_object_slow_work_ops = {
+	.owner		= THIS_MODULE,
 	.get_ref	= fscache_object_slow_work_get_ref,
 	.put_ref	= fscache_object_slow_work_put_ref,
 	.execute	= fscache_object_slow_work_execute,
diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index e7f8d53..f1a2857 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -453,6 +453,7 @@ static void fscache_op_execute(struct slow_work *work)
 }
 
 const struct slow_work_ops fscache_op_slow_work_ops = {
+	.owner		= THIS_MODULE,
 	.get_ref	= fscache_op_get_ref,
 	.put_ref	= fscache_op_put_ref,
 	.execute	= fscache_op_execute,
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index eacd78a..5b31f77 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -114,7 +114,7 @@ static int __init init_gfs2_fs(void)
 	if (error)
 		goto fail_unregister;
 
-	error = slow_work_register_user();
+	error = slow_work_register_user(THIS_MODULE);
 	if (error)
 		goto fail_slow;
 
@@ -163,7 +163,7 @@ static void __exit exit_gfs2_fs(void)
 	gfs2_unregister_debugfs();
 	unregister_filesystem(&gfs2_fs_type);
 	unregister_filesystem(&gfs2meta_fs_type);
-	slow_work_unregister_user();
+	slow_work_unregister_user(THIS_MODULE);
 
 	kmem_cache_destroy(gfs2_quotad_cachep);
 	kmem_cache_destroy(gfs2_rgrpd_cachep);
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 59d2695..b2bb779 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -593,6 +593,7 @@ fail:
 }
 
 struct slow_work_ops gfs2_recover_ops = {
+	.owner	 = THIS_MODULE,
 	.get_ref = gfs2_recover_get_ref,
 	.put_ref = gfs2_recover_put_ref,
 	.execute = gfs2_recover_work,
diff --git a/include/linux/slow-work.h b/include/linux/slow-work.h
index b65c888..9adb2b3 100644
--- a/include/linux/slow-work.h
+++ b/include/linux/slow-work.h
@@ -24,6 +24,9 @@ struct slow_work;
  * The operations used to support slow work items
  */
 struct slow_work_ops {
+	/* owner */
+	struct module *owner;
+
 	/* get a ref on a work item
 	 * - return 0 if successful, -ve if not
 	 */
@@ -42,6 +45,7 @@ struct slow_work_ops {
  *   queued
  */
 struct slow_work {
+	struct module		*owner;	/* the owning module */
 	unsigned long		flags;
 #define SLOW_WORK_PENDING	0	/* item pending (further) execution */
 #define SLOW_WORK_EXECUTING	1	/* item currently executing */
@@ -84,8 +88,8 @@ static inline void vslow_work_init(struct slow_work *work,
 }
 
 extern int slow_work_enqueue(struct slow_work *work);
-extern int slow_work_register_user(void);
-extern void slow_work_unregister_user(void);
+extern int slow_work_register_user(struct module *owner);
+extern void slow_work_unregister_user(struct module *owner);
 
 #ifdef CONFIG_SYSCTL
 extern ctl_table slow_work_sysctls[];
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index 0d31135..dd08f37 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -22,6 +22,8 @@
 #define SLOW_WORK_OOM_TIMEOUT (5 * HZ)	/* can't start new threads for 5s after
 					 * OOM */
 
+#define SLOW_WORK_THREAD_LIMIT	255	/* abs maximum number of slow-work threads */
+
 static void slow_work_cull_timeout(unsigned long);
 static void slow_work_oom_timeout(unsigned long);
 
@@ -46,7 +48,7 @@ static unsigned vslow_work_proportion = 50; /* % of threads that may process
 
 #ifdef CONFIG_SYSCTL
 static const int slow_work_min_min_threads = 2;
-static int slow_work_max_max_threads = 255;
+static int slow_work_max_max_threads = SLOW_WORK_THREAD_LIMIT;
 static const int slow_work_min_vslow = 1;
 static const int slow_work_max_vslow = 99;
 
@@ -98,6 +100,23 @@ static DEFINE_TIMER(slow_work_oom_timer, slow_work_oom_timeout, 0, 0);
 static struct slow_work slow_work_new_thread; /* new thread starter */
 
 /*
+ * slow work ID allocation (use slow_work_queue_lock)
+ */
+static DECLARE_BITMAP(slow_work_ids, SLOW_WORK_THREAD_LIMIT);
+
+/*
+ * Unregistration tracking to prevent put_ref() from disappearing during module
+ * unload
+ */
+#ifdef CONFIG_MODULES
+static struct module *slow_work_thread_processing[SLOW_WORK_THREAD_LIMIT];
+static struct module *slow_work_unreg_module;
+static struct slow_work *slow_work_unreg_work_item;
+static DECLARE_WAIT_QUEUE_HEAD(slow_work_unreg_wq);
+static DEFINE_MUTEX(slow_work_unreg_sync_lock);
+#endif
+
+/*
  * The queues of work items and the lock governing access to them.  These are
  * shared between all the CPUs.  It doesn't make sense to have per-CPU queues
  * as the number of threads bears no relation to the number of CPUs.
@@ -149,8 +168,11 @@ static unsigned slow_work_calc_vsmax(void)
  * Attempt to execute stuff queued on a slow thread.  Return true if we managed
  * it, false if there was nothing to do.
  */
-static bool slow_work_execute(void)
+static bool slow_work_execute(int id)
 {
+#ifdef CONFIG_MODULES
+	struct module *module;
+#endif
 	struct slow_work *work = NULL;
 	unsigned vsmax;
 	bool very_slow;
@@ -186,6 +208,12 @@ static bool slow_work_execute(void)
 	} else {
 		very_slow = false; /* avoid the compiler warning */
 	}
+
+#ifdef CONFIG_MODULES
+	if (work)
+		slow_work_thread_processing[id] = work->owner;
+#endif
+
 	spin_unlock_irq(&slow_work_queue_lock);
 
 	if (!work)
@@ -219,7 +247,18 @@ static bool slow_work_execute(void)
 		spin_unlock_irq(&slow_work_queue_lock);
 	}
 
+	/* sort out the race between module unloading and put_ref() */
 	work->ops->put_ref(work);
+
+#ifdef CONFIG_MODULES
+	module = slow_work_thread_processing[id];
+	slow_work_thread_processing[id] = NULL;
+	smp_mb();
+	if (slow_work_unreg_work_item == work ||
+	    slow_work_unreg_module == module)
+		wake_up_all(&slow_work_unreg_wq);
+#endif
+
 	return true;
 
 auto_requeue:
@@ -232,6 +271,7 @@ auto_requeue:
 	else
 		list_add_tail(&work->link, &slow_work_queue);
 	spin_unlock_irq(&slow_work_queue_lock);
+	slow_work_thread_processing[id] = NULL;
 	return true;
 }
 
@@ -368,13 +408,22 @@ static inline bool slow_work_available(int vsmax)
  */
 static int slow_work_thread(void *_data)
 {
-	int vsmax;
+	int vsmax, id;
 
 	DEFINE_WAIT(wait);
 
 	set_freezable();
 	set_user_nice(current, -5);
 
+	/* allocate ourselves an ID */
+	spin_lock_irq(&slow_work_queue_lock);
+	id = find_first_zero_bit(slow_work_ids, SLOW_WORK_THREAD_LIMIT);
+	BUG_ON(id < 0 || id >= SLOW_WORK_THREAD_LIMIT);
+	__set_bit(id, slow_work_ids);
+	spin_unlock_irq(&slow_work_queue_lock);
+
+	sprintf(current->comm, "kslowd%03u", id);
+
 	for (;;) {
 		vsmax = vslow_work_proportion;
 		vsmax *= atomic_read(&slow_work_thread_count);
@@ -395,7 +444,7 @@ static int slow_work_thread(void *_data)
 		vsmax *= atomic_read(&slow_work_thread_count);
 		vsmax /= 100;
 
-		if (slow_work_available(vsmax) && slow_work_execute()) {
+		if (slow_work_available(vsmax) && slow_work_execute(id)) {
 			cond_resched();
 			if (list_empty(&slow_work_queue) &&
 			    list_empty(&vslow_work_queue) &&
@@ -412,6 +461,10 @@ static int slow_work_thread(void *_data)
 			break;
 	}
 
+	spin_lock_irq(&slow_work_queue_lock);
+	__clear_bit(id, slow_work_ids);
+	spin_unlock_irq(&slow_work_queue_lock);
+
 	if (atomic_dec_and_test(&slow_work_thread_count))
 		complete_and_exit(&slow_work_last_thread_exited, 0);
 	return 0;
@@ -475,6 +528,7 @@ static void slow_work_new_thread_execute(struct slow_work *work)
 }
 
 static const struct slow_work_ops slow_work_new_thread_ops = {
+	.owner		= THIS_MODULE,
 	.get_ref	= slow_work_new_thread_get_ref,
 	.put_ref	= slow_work_new_thread_put_ref,
 	.execute	= slow_work_new_thread_execute,
@@ -546,12 +600,13 @@ static int slow_work_max_threads_sysctl(struct ctl_table *table, int write,
 
 /**
  * slow_work_register_user - Register a user of the facility
+ * @module: The module about to make use of the facility
  *
  * Register a user of the facility, starting up the initial threads if there
  * aren't any other users at this point.  This will return 0 if successful, or
  * an error if not.
  */
-int slow_work_register_user(void)
+int slow_work_register_user(struct module *module)
 {
 	struct task_struct *p;
 	int loop;
@@ -598,14 +653,79 @@ error:
 }
 EXPORT_SYMBOL(slow_work_register_user);
 
+/*
+ * wait for all outstanding items from the calling module to complete
+ * - note that more items may be queued whilst we're waiting
+ */
+static void slow_work_wait_for_items(struct module *module)
+{
+	DECLARE_WAITQUEUE(myself, current);
+	struct slow_work *work;
+	int loop;
+
+	mutex_lock(&slow_work_unreg_sync_lock);
+	add_wait_queue(&slow_work_unreg_wq, &myself);
+
+	for (;;) {
+		spin_lock_irq(&slow_work_queue_lock);
+
+		/* first of all, we wait for the last queued item in each list
+		 * to be processed */
+		list_for_each_entry_reverse(work, &vslow_work_queue, link) {
+			if (work->owner == module) {
+				set_current_state(TASK_UNINTERRUPTIBLE);
+				slow_work_unreg_work_item = work;
+				goto do_wait;
+			}
+		}
+		list_for_each_entry_reverse(work, &slow_work_queue, link) {
+			if (work->owner == module) {
+				set_current_state(TASK_UNINTERRUPTIBLE);
+				slow_work_unreg_work_item = work;
+				goto do_wait;
+			}
+		}
+
+		/* then we wait for the items being processed to finish */
+		slow_work_unreg_module = module;
+		smp_mb();
+		for (loop = 0; loop < SLOW_WORK_THREAD_LIMIT; loop++) {
+			if (slow_work_thread_processing[loop] == module)
+				goto do_wait;
+		}
+		spin_unlock_irq(&slow_work_queue_lock);
+		break; /* okay, we're done */
+
+	do_wait:
+		spin_unlock_irq(&slow_work_queue_lock);
+		schedule();
+		slow_work_unreg_work_item = NULL;
+		slow_work_unreg_module = NULL;
+	}
+
+	remove_wait_queue(&slow_work_unreg_wq, &myself);
+	mutex_unlock(&slow_work_unreg_sync_lock);
+}
+
 /**
  * slow_work_unregister_user - Unregister a user of the facility
+ * @module: The module whose items should be cleared
  *
  * Unregister a user of the facility, killing all the threads if this was the
  * last one.
+ *
+ * This waits for all the work items belonging to the nominated module to go
+ * away before proceeding.
  */
-void slow_work_unregister_user(void)
+void slow_work_unregister_user(struct module *module)
 {
+	/* first of all, wait for all outstanding items from the calling module
+	 * to complete */
+	if (module)
+		slow_work_wait_for_items(module);
+
+	/* then we can actually go about shutting down the facility if need
+	 * be */
 	mutex_lock(&slow_work_user_lock);
 
 	BUG_ON(slow_work_user_count <= 0);

