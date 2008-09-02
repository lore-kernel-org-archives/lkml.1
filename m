Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbYIBEcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbYIBEcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 00:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbYIBEcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 00:32:06 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:58019 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYIBEcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 00:32:04 -0400
Message-ID: <48BCC1B6.5030901@nttdata.co.jp>
Date: Tue, 02 Sep 2008 13:31:50 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.16) Gecko/20080708 Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: viro@ZenIV.linux.org.uk
CC: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       akpm@linux-foundation.org, Toshiharu Harada <haradats@nttdata.co.jp>
Subject: (repost) Confirmation of methods for calculating requested pathname.
References: <48AA49DE.6000006@nttdata.co.jp>
In-Reply-To: <48AA49DE.6000006@nttdata.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Sep 2008 04:31:51.0400 (UTC) FILETIME=[D2059E80:01C90CB4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al, could you answer the following question?


The current Linux kernel is not designed to pass vfsmount parameter
that is crucial for pathname-based security including AppArmor and
TOMOYO Linux, to LSM. Though both projects have been proposing
patches to calculate pathname, none of them have been accepted as
you know.

To find the reason for NACK, we examined past proposals and the
threads. And we came to understand that you oppose accessing vfsmount
inside vfs helper functions. Is our understanding correct?

If our understanding is correct, we would like to propose a new
method that does not require modifications to vfs helper functions.
Attached patch is a trial of this method.

vfs helper functions are surrounded by mnt_want_write() and
mnt_drop_write() pairs which receive "struct vfsmount" parameter
since 2.6.26. So, by remembering the absolute pathname of "struct
vfsmount" of the moment, LSM module can calculate an absolute
pathname of the given "struct dentry" parameter inside vfs_*
functions, without passing "struct vfsmount" parameter to vfs_*
functions.

This approach doesn't access vfsmount inside vfs helper functions,
and modification of existing kernel is only in task_struct and
mnt_want/drop_write().

We would like to hear your comments as fs maintainer.

Regards,

---
Subject: Remembering previously referenced vfsmount's pathname.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/Kconfig                |   18 ++++++++++++++++++
 fs/namespace.c            |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/init_task.h |    7 +++++++
 include/linux/sched.h     |    3 +++
 kernel/fork.c             |    8 ++++++++
 5 files changed, 82 insertions(+)

--- linux-2.6.27-rc5.orig/fs/Kconfig
+++ linux-2.6.27-rc5/fs/Kconfig
@@ -2093,4 +2093,22 @@ endif
 source "fs/nls/Kconfig"
 source "fs/dlm/Kconfig"
 
+config REMEMBER_VFSMOUNT_PATH
+	bool "Remember previously referenced vfsmount's pathname."
+	help
+	  The vfs_* functions (e.g. vfs_mkdir) don't receive "struct vfsmount"
+	  parameter, making it impossible to calculate an absolute pathname of
+	  the given "struct dentry" parameter inside vfs_* functions.
+	
+	  If someone wants to get an absolute pathname of the given
+	  "struct dentry" parameter, he/she must calculate it outside
+	  vfs_* functions.
+	
+	  However, vfs_* functions are surrounded by mnt_want_write() and
+	  mnt_drop_write() pairs which receive "struct vfsmount" parameter.
+	  So, by remembering the absolute pathname of "struct vfsmount" of
+	  the moment, he/she can calculate an absolute pathname of the given
+	  "struct dentry" parameter inside vfs_* functions, without passing
+	  "struct vfsmount" parameter to vfs_* functions.
+
 endmenu
--- linux-2.6.27-rc5.orig/fs/namespace.c
+++ linux-2.6.27-rc5/fs/namespace.c
@@ -231,6 +231,41 @@ static inline void use_cpu_writer_for_mo
 	cpu_writer->mnt = mnt;
 }
 
+#ifdef CONFIG_REMEMBER_VFSMOUNT_PATH
+static void forget_vfsmount_path(void)
+{
+	struct task_struct *task = current;
+	kfree(task->current_vfsmount_path);
+	task->current_vfsmount_path = NULL;
+}
+
+static bool remember_vfsmount_path(struct vfsmount *mnt)
+{
+	struct task_struct *task = current;
+	struct path path = { mnt, mnt->mnt_root };
+	char *page;
+	char *ret;
+	if (task->current_vfsmount_path)
+		forget_vfsmount_path();
+	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!page)
+		goto out;
+	ret = d_path(&path, page, PAGE_SIZE);
+	if (IS_ERR(ret))
+		goto out_free;
+	ret = kstrdup(ret, GFP_KERNEL);
+	if (!ret)
+		goto out_free;
+	kfree(page);
+	task->current_vfsmount_path = ret;
+	return 1;
+ out_free:
+	kfree(page);
+ out:
+	return 0;
+}
+#endif
+
 /*
  * Most r/o checks on a fs are for operations that take
  * discrete amounts of time, like a write() or unlink().
@@ -253,6 +288,10 @@ int mnt_want_write(struct vfsmount *mnt)
 {
 	int ret = 0;
 	struct mnt_writer *cpu_writer;
+#ifdef CONFIG_REMEMBER_VFSMOUNT_PATH
+	if (!remember_vfsmount_path(mnt))
+		return -ENOMEM;
+#endif
 
 	cpu_writer = &get_cpu_var(mnt_writers);
 	spin_lock(&cpu_writer->lock);
@@ -265,6 +304,10 @@ int mnt_want_write(struct vfsmount *mnt)
 out:
 	spin_unlock(&cpu_writer->lock);
 	put_cpu_var(mnt_writers);
+#ifdef CONFIG_REMEMBER_VFSMOUNT_PATH
+	if (ret)
+		forget_vfsmount_path();
+#endif
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mnt_want_write);
@@ -362,6 +405,9 @@ void mnt_drop_write(struct vfsmount *mnt
 	 * we could theoretically wrap __mnt_writers.
 	 */
 	put_cpu_var(mnt_writers);
+#ifdef CONFIG_REMEMBER_VFSMOUNT_PATH
+	forget_vfsmount_path();
+#endif
 }
 EXPORT_SYMBOL_GPL(mnt_drop_write);
 
--- linux-2.6.27-rc5.orig/include/linux/init_task.h
+++ linux-2.6.27-rc5/include/linux/init_task.h
@@ -113,6 +113,12 @@ extern struct group_info init_groups;
 # define CAP_INIT_BSET  CAP_INIT_EFF_SET
 #endif
 
+#ifdef CONFIG_REMEMBER_VFSMOUNT_PATH
+#define INIT_VFSMOUNT_PATH .current_vfsmount_path = NULL,
+#else
+#define INIT_VFSMOUNT_PATH
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -179,6 +185,7 @@ extern struct group_info init_groups;
 	INIT_IDS							\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
+	INIT_VFSMOUNT_PATH                                              \
 }
 
 
--- linux-2.6.27-rc5.orig/include/linux/sched.h
+++ linux-2.6.27-rc5/include/linux/sched.h
@@ -1301,6 +1301,9 @@ struct task_struct {
 	int latency_record_count;
 	struct latency_record latency_record[LT_SAVECOUNT];
 #endif
+#ifdef CONFIG_REMEMBER_VFSMOUNT_PATH
+	const char *current_vfsmount_path;
+#endif
 };
 
 /*
--- linux-2.6.27-rc5.orig/kernel/fork.c
+++ linux-2.6.27-rc5/kernel/fork.c
@@ -1051,6 +1051,14 @@ static struct task_struct *copy_process(
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
 
+#ifdef CONFIG_REMEMBER_VFSMOUNT_PATH
+	/*
+	 * It seems to me that this function is called between mnt_want_write()
+	 * and mnt_drop_write(). I don't know why.
+	 */
+	p->current_vfsmount_path = NULL;
+#endif
+
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);
 


