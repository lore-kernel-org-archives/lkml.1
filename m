Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbZFZONu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbZFZONu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760444AbZFZON0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:13:26 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:61948 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760446AbZFZONZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:13:25 -0400
Subject: [PATCH 3/4] kmemleak: Do not trigger a scan when reading the
	debug/kmemleak file
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Date: Fri, 26 Jun 2009 15:12:52 +0100
Message-ID: <20090626141252.31504.62724.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090626140847.31504.79381.stgit@pc1117.cambridge.arm.com>
References: <20090626140847.31504.79381.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.387.geb0c.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2009 14:12:53.0143 (UTC) FILETIME=[31ED3270:01C9F668]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there is a kernel thread for automatically scanning the memory, it
makes sense for the debug/kmemleak file to only show its findings. This
patch also adds support for "echo scan > debug/kmemleak" to trigger an
intermediate memory scan and eliminates the kmemleak_mutex (scan_mutex
covers all the cases now).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 Documentation/kmemleak.txt |    9 +++-
 mm/kmemleak.c              |   90 ++++++++++++++++++++------------------------
 2 files changed, 47 insertions(+), 52 deletions(-)

diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
index c06f7ba..8906803 100644
--- a/Documentation/kmemleak.txt
+++ b/Documentation/kmemleak.txt
@@ -17,12 +17,16 @@ Usage
 
 CONFIG_DEBUG_KMEMLEAK in "Kernel hacking" has to be enabled. A kernel
 thread scans the memory every 10 minutes (by default) and prints the
-number of new unreferenced objects found. To trigger an intermediate
-scan and display the details of all the possible memory leaks:
+number of new unreferenced objects found. To display the details of all
+the possible memory leaks:
 
   # mount -t debugfs nodev /sys/kernel/debug/
   # cat /sys/kernel/debug/kmemleak
 
+To trigger an intermediate memory scan:
+
+  # echo scan > /sys/kernel/debug/kmemleak
+
 Note that the orphan objects are listed in the order they were allocated
 and one object at the beginning of the list may cause other subsequent
 objects to be reported as orphan.
@@ -37,6 +41,7 @@ Memory scanning parameters can be modified at run-time by writing to the
   scan=off	- stop the automatic memory scanning thread
   scan=<secs>	- set the automatic memory scanning period in seconds
 		  (default 600, 0 to stop the automatic scanning)
+  scan		- trigger a memory scan
 
 Kmemleak can also be disabled at boot-time by passing "kmemleak=off" on
 the kernel command line.
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 4130a48..e96e0ec 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -48,10 +48,10 @@
  *   scanned. This list is only modified during a scanning episode when the
  *   scan_mutex is held. At the end of a scan, the gray_list is always empty.
  *   Note that the kmemleak_object.use_count is incremented when an object is
- *   added to the gray_list and therefore cannot be freed
- * - kmemleak_mutex (mutex): prevents multiple users of the "kmemleak" debugfs
- *   file together with modifications to the memory scanning parameters
- *   including the scan_thread pointer
+ *   added to the gray_list and therefore cannot be freed. This mutex also
+ *   prevents multiple users of the "kmemleak" debugfs file together with
+ *   modifications to the memory scanning parameters including the scan_thread
+ *   pointer
  *
  * The kmemleak_object structures have a use_count incremented or decremented
  * using the get_object()/put_object() functions. When the use_count becomes
@@ -195,10 +195,8 @@ static unsigned long jiffies_min_age;
 static signed long jiffies_scan_wait;
 /* enables or disables the task stacks scanning */
 static int kmemleak_stack_scan = 1;
-/* mutex protecting the memory scanning */
+/* protects the memory scanning, parameters and debug/kmemleak file access */
 static DEFINE_MUTEX(scan_mutex);
-/* mutex protecting the access to the /sys/kernel/debug/kmemleak file */
-static DEFINE_MUTEX(kmemleak_mutex);
 
 /* number of leaks reported (for limitation purposes) */
 static int reported_leaks;
@@ -927,6 +925,7 @@ static void kmemleak_scan(void)
 	struct kmemleak_object *object, *tmp;
 	struct task_struct *task;
 	int i;
+	int new_leaks = 0;
 
 	/* prepare the kmemleak_object's */
 	rcu_read_lock();
@@ -1024,6 +1023,26 @@ static void kmemleak_scan(void)
 		object = tmp;
 	}
 	WARN_ON(!list_empty(&gray_list));
+
+	/*
+	 * Scanning result reporting.
+	 */
+	rcu_read_lock();
+	list_for_each_entry_rcu(object, &object_list, object_list) {
+		spin_lock_irqsave(&object->lock, flags);
+		if (unreferenced_object(object) &&
+		    !(object->flags & OBJECT_REPORTED)) {
+			object->flags |= OBJECT_REPORTED;
+			new_leaks++;
+		}
+		spin_unlock_irqrestore(&object->lock, flags);
+	}
+	rcu_read_unlock();
+
+	if (new_leaks)
+		pr_info("%d new suspected memory leaks (see "
+			"/sys/kernel/debug/kmemleak)\n", new_leaks);
+
 }
 
 /*
@@ -1045,33 +1064,12 @@ static int kmemleak_scan_thread(void *arg)
 	}
 
 	while (!kthread_should_stop()) {
-		struct kmemleak_object *object;
 		signed long timeout = jiffies_scan_wait;
-		int new_leaks = 0;
 
 		mutex_lock(&scan_mutex);
-
 		kmemleak_scan();
-
-		rcu_read_lock();
-		list_for_each_entry_rcu(object, &object_list, object_list) {
-			unsigned long flags;
-
-			spin_lock_irqsave(&object->lock, flags);
-			if (unreferenced_object(object) &&
-			    !(object->flags & OBJECT_REPORTED)) {
-				object->flags |= OBJECT_REPORTED;
-				new_leaks++;
-			}
-			spin_unlock_irqrestore(&object->lock, flags);
-		}
-		rcu_read_unlock();
-
-		if (new_leaks)
-			pr_info("%d new suspected memory leaks (see "
-				"/sys/kernel/debug/kmemleak)\n", new_leaks);
-
 		mutex_unlock(&scan_mutex);
+
 		/* wait before the next scan */
 		while (timeout && !kthread_should_stop())
 			timeout = schedule_timeout_interruptible(timeout);
@@ -1084,7 +1082,7 @@ static int kmemleak_scan_thread(void *arg)
 
 /*
  * Start the automatic memory scanning thread. This function must be called
- * with the kmemleak_mutex held.
+ * with the scan_mutex held.
  */
 void start_scan_thread(void)
 {
@@ -1099,7 +1097,7 @@ void start_scan_thread(void)
 
 /*
  * Stop the automatic memory scanning thread. This function must be called
- * with the kmemleak_mutex held.
+ * with the scan_mutex held.
  */
 void stop_scan_thread(void)
 {
@@ -1119,10 +1117,8 @@ static void *kmemleak_seq_start(struct seq_file *seq, loff_t *pos)
 	struct kmemleak_object *object;
 	loff_t n = *pos;
 
-	if (!n) {
-		kmemleak_scan();
+	if (!n)
 		reported_leaks = 0;
-	}
 	if (reported_leaks >= REPORTS_NR)
 		return NULL;
 
@@ -1206,13 +1202,10 @@ static int kmemleak_open(struct inode *inode, struct file *file)
 	if (!atomic_read(&kmemleak_enabled))
 		return -EBUSY;
 
-	ret = mutex_lock_interruptible(&kmemleak_mutex);
+	ret = mutex_lock_interruptible(&scan_mutex);
 	if (ret < 0)
 		goto out;
 	if (file->f_mode & FMODE_READ) {
-		ret = mutex_lock_interruptible(&scan_mutex);
-		if (ret < 0)
-			goto kmemleak_unlock;
 		ret = seq_open(file, &kmemleak_seq_ops);
 		if (ret < 0)
 			goto scan_unlock;
@@ -1221,8 +1214,6 @@ static int kmemleak_open(struct inode *inode, struct file *file)
 
 scan_unlock:
 	mutex_unlock(&scan_mutex);
-kmemleak_unlock:
-	mutex_unlock(&kmemleak_mutex);
 out:
 	return ret;
 }
@@ -1231,11 +1222,9 @@ static int kmemleak_release(struct inode *inode, struct file *file)
 {
 	int ret = 0;
 
-	if (file->f_mode & FMODE_READ) {
+	if (file->f_mode & FMODE_READ)
 		seq_release(inode, file);
-		mutex_unlock(&scan_mutex);
-	}
-	mutex_unlock(&kmemleak_mutex);
+	mutex_unlock(&scan_mutex);
 
 	return ret;
 }
@@ -1250,6 +1239,7 @@ static int kmemleak_release(struct inode *inode, struct file *file)
  *   scan=off	- stop the automatic memory scanning thread
  *   scan=...	- set the automatic memory scanning period in seconds (0 to
  *		  disable it)
+ *   scan	- trigger a memory scan
  */
 static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
 			      size_t size, loff_t *ppos)
@@ -1287,7 +1277,9 @@ static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
 			jiffies_scan_wait = msecs_to_jiffies(secs * 1000);
 			start_scan_thread();
 		}
-	} else
+	} else if (strncmp(buf, "scan", 4) == 0)
+		kmemleak_scan();
+	else
 		return -EINVAL;
 
 	/* ignore the rest of the buffer, only one command at a time */
@@ -1312,11 +1304,9 @@ static int kmemleak_cleanup_thread(void *arg)
 {
 	struct kmemleak_object *object;
 
-	mutex_lock(&kmemleak_mutex);
+	mutex_lock(&scan_mutex);
 	stop_scan_thread();
-	mutex_unlock(&kmemleak_mutex);
 
-	mutex_lock(&scan_mutex);
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list)
 		delete_object(object->pointer);
@@ -1458,9 +1448,9 @@ static int __init kmemleak_late_init(void)
 				     &kmemleak_fops);
 	if (!dentry)
 		pr_warning("Failed to create the debugfs kmemleak file\n");
-	mutex_lock(&kmemleak_mutex);
+	mutex_lock(&scan_mutex);
 	start_scan_thread();
-	mutex_unlock(&kmemleak_mutex);
+	mutex_unlock(&scan_mutex);
 
 	pr_info("Kernel memory leak detector initialized\n");
 

