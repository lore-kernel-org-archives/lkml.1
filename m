Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbZCYERk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbZCYERk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 00:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757473AbZCYERD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 00:17:03 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:15766 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbZCYEQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 00:16:58 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [RFC PATCH 2/3] sysfs: add blocking notifier to prohibit module unload
To: htejun@gmail.com, greg@kroah.com, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org, rusty@rustcorp.com.au,
       ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 24 Mar 2009 22:16:56 -0600
Message-ID: <20090325041656.15921.38194.stgit@bob.kio>
In-Reply-To: <20090325035707.15921.42150.stgit@bob.kio>
References: <20090325035707.15921.42150.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As its name suggests, module_inhibit_unload() inhibits all module
unloading till the matching module_allow_unload() is called.  This
unload inhibition doesn't affect whether a module can be unloaded or
not.  It just stalls the final module free till the inhibition is
lifted.

This sledgehammer mechanism is to be used briefly in obscure cases
where identifying or getting the module to prevent from unloading is
difficult or not worth the effort.  Note that module unloading is
siberia-cold path.  If the inhibtion is relatively brief in human
scale, that is, upto a few secs at maximum, it should be fine.

Even if something goes wrong with unload inhibition (e.g. someone
forgets to lift the inhibition), it doesn't prevent modules from being
loaded.

Originally written by Tejun Heo. Refreshed and implemented as a
blocking notifier that registers with the module core.

Cc: Tejun Heo <htejun@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 fs/sysfs/file.c  |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/sysfs/mount.c |    8 ++++++
 fs/sysfs/sysfs.h |    2 ++
 3 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 7cc4dc0..bf93b58 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -21,6 +21,7 @@
 #include <linux/mutex.h>
 #include <linux/limits.h>
 #include <asm/uaccess.h>
+#include <asm/atomic.h>
 
 #include "sysfs.h"
 
@@ -60,6 +61,74 @@ struct sysfs_buffer {
 	struct list_head	list;
 };
 
+static atomic_t module_unload_inhibit_cnt = ATOMIC_INIT(0);
+static DECLARE_WAIT_QUEUE_HEAD(module_unload_wait);
+
+/**
+ *	sysfs_module_callback - block until module unload allowed again
+ *
+ *	(ab)use the blocking notifier call chain in delete_module()
+ *	and prevent module unload for our own purposes, namely a
+ *	suicidal sysfs attribute has finished killing itself.
+ *
+ *	This prevents a module from freeing its code section before
+ *	we are done accessing it.
+ */
+int sysfs_module_callback(struct notifier_block *self, unsigned long val,
+			  void *data)
+{
+	DECLARE_WAITQUEUE(wait, current);
+
+	if (val == MODULE_STATE_COMING)
+		return NOTIFY_DONE;
+
+	add_wait_queue(&module_unload_wait, &wait);
+	set_current_state(TASK_UNINTERRUPTIBLE);
+	if (atomic_read(&module_unload_inhibit_cnt))
+		schedule();
+	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&module_unload_wait, &wait);
+
+	return NOTIFY_DONE;
+}
+
+/**
+ *	module_inhibit_unload - inhibit module unload
+ *
+ *	Inhibit module unload until allowed again.  All module unload
+ *	operations which reach zero reference count after this call
+ *	has returned are guaranteed to be stalled till inhibition is
+ *	lifted.
+ *
+ *	This is a simple mechanism to prevent premature unload while
+ *	code on a to-be-unloaded module is still executing.  Unload
+ *	inhibitions must be finite and relatively short.
+ *
+ *	LOCKING:
+ *	None.
+ */
+static void module_inhibit_unload(void)
+{
+	atomic_inc(&module_unload_inhibit_cnt);
+}
+
+/**
+ *	module_allow_unload - allow module unload
+ *
+ *	Allow module unload.  Must be balanced with calls to
+ *	module_inhibit_unload().
+ *
+ *	LOCKING:
+ *	None.
+ */
+static void module_allow_unload(void)
+{
+	if (atomic_dec_and_test(&module_unload_inhibit_cnt))
+		wake_up_all(&module_unload_wait);
+
+	BUG_ON(atomic_read(&module_unload_inhibit_cnt) < 0);
+}
+
 /**
  *	fill_read_buffer - allocate and fill buffer from object.
  *	@dentry:	dentry pointer.
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index ab343e3..c805bec 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -83,6 +83,11 @@ static struct file_system_type sysfs_fs_type = {
 	.kill_sb	= kill_anon_super,
 };
 
+static struct notifier_block sysfs_module_nb = {
+	.notifier_call = sysfs_module_callback,
+	.priority = 0
+};
+
 int __init sysfs_init(void)
 {
 	int err = -ENOMEM;
@@ -109,6 +114,9 @@ int __init sysfs_init(void)
 		}
 	} else
 		goto out_err;
+
+	register_module_notifier(&sysfs_module_nb);
+
 out:
 	return err;
 out_err:
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index cb8ac65..5d9b340 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -153,6 +153,8 @@ int sysfs_inode_init(void);
  * file.c
  */
 extern const struct file_operations sysfs_file_operations;
+extern int sysfs_module_callback(struct notifier_block *self, unsigned long val,
+				 void *data);
 
 int sysfs_add_file(struct sysfs_dirent *dir_sd,
 		   const struct attribute *attr, int type);

