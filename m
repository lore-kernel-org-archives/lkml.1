Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbZBSSWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbZBSSWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbZBSSU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:20:26 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:36413 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbZBSSUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:20:14 -0500
Subject: [RFC][PATCH 3/5] check files for checkpointability
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 19 Feb 2009 10:20:10 -0800
References: <20090219182007.B4B47C1F@kernel>
In-Reply-To: <20090219182007.B4B47C1F@kernel>
Message-Id: <20090219182009.1A3E8860@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce a files_struct counter to indicate whether a particular
file_struct has ever contained a file which can not be
checkpointed.  This flag is a one-way trip; once it is set, it may
not be unset.

We assume at allocation that a new files_struct is clean and may
be checkpointed.  However, as soon as it has had its files filled
from its parent's, we check it for real in __scan_files_for_cr().
At that point, we mark it if it contained any uncheckpointable
files.

We also check each 'struct file' when it is installed in a fd
slot.  This way, if anyone open()s or managed to dup() an
unsuppored file, we can catch it.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/file.c                  |   19 +++++++++++++++++++
 linux-2.6.git-dave/fs/open.c                  |    5 +++++
 linux-2.6.git-dave/include/linux/checkpoint.h |   17 ++++++++++++++++-
 linux-2.6.git-dave/include/linux/fdtable.h    |    3 +++
 4 files changed, 43 insertions(+), 1 deletion(-)

diff -puN fs/file.c~deny-ckpt fs/file.c
--- linux-2.6.git/fs/file.c~deny-ckpt	2009-02-19 10:17:25.000000000 -0800
+++ linux-2.6.git-dave/fs/file.c	2009-02-19 10:17:25.000000000 -0800
@@ -15,6 +15,7 @@
 #include <linux/file.h>
 #include <linux/fdtable.h>
 #include <linux/bitops.h>
+#include <linux/checkpoint.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
@@ -285,6 +286,20 @@ static int count_open_files(struct fdtab
 	return i;
 }
 
+static void __scan_files_for_cr(struct files_struct *files)
+{
+	int i;
+
+	for (i = 0; i < files->fdtab.max_fds; i++) {
+		struct file *f = fcheck_files(files, i);
+		if (!f)
+			continue;
+		if (cr_file_supported(f))
+			continue;
+		files_deny_checkpointing(files);
+	}
+}
+
 /*
  * Allocate a new files structure and copy contents from the
  * passed in files structure.
@@ -303,6 +318,9 @@ struct files_struct *dup_fd(struct files
 		goto out;
 
 	atomic_set(&newf->count, 1);
+#ifdef CONFIG_CHECKPOINT_RESTART
+	atomic_set(&newf->may_checkpoint, 1);
+#endif
 
 	spin_lock_init(&newf->file_lock);
 	newf->next_fd = 0;
@@ -396,6 +414,7 @@ struct files_struct *dup_fd(struct files
 
 	rcu_assign_pointer(newf->fdt, new_fdt);
 
+	__scan_files_for_cr(newf);
 	return newf;
 
 out_release:
diff -puN fs/open.c~deny-ckpt fs/open.c
--- linux-2.6.git/fs/open.c~deny-ckpt	2009-02-19 10:17:25.000000000 -0800
+++ linux-2.6.git-dave/fs/open.c	2009-02-19 10:17:25.000000000 -0800
@@ -29,6 +29,7 @@
 #include <linux/rcupdate.h>
 #include <linux/audit.h>
 #include <linux/falloc.h>
+#include <linux/checkpoint.h>
 
 int vfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
@@ -998,6 +999,10 @@ void fd_install(unsigned int fd, struct 
 {
 	struct files_struct *files = current->files;
 	struct fdtable *fdt;
+
+	if (!cr_file_supported(file))
+		files_deny_checkpointing(files);
+
 	spin_lock(&files->file_lock);
 	fdt = files_fdtable(files);
 	BUG_ON(fdt->fd[fd] != NULL);
diff -puN include/linux/checkpoint.h~deny-ckpt include/linux/checkpoint.h
--- linux-2.6.git/include/linux/checkpoint.h~deny-ckpt	2009-02-19 10:17:25.000000000 -0800
+++ linux-2.6.git-dave/include/linux/checkpoint.h	2009-02-19 10:17:25.000000000 -0800
@@ -12,6 +12,7 @@
 
 #include <linux/path.h>
 #include <linux/fs.h>
+#include <linux/fdtable.h>
 
 #ifdef CONFIG_CHECKPOINT_RESTART
 
@@ -101,17 +102,31 @@ extern int cr_read_files(struct cr_ctx *
 
 #define pr_fmt(fmt) "[%d:c/r:%s] " fmt, task_pid_vnr(current), __func__
 
+static inline void __files_deny_checkpointing(struct files_struct *files,
+		char *file, int line)
+{
+	if (!atomic_dec_and_test(&files->may_checkpoint))
+		return;
+	printk(KERN_INFO "process performed an action that can not be "
+			"checkpointed at: %s:%d\n", file, line);
+	WARN_ON(1);
+}
+#define files_deny_checkpointing(f)  \
+	__files_deny_checkpointing(f, __FILE__, __LINE__)
+
 int cr_explain_file(struct file *file, char *explain, int left);
 int cr_file_supported(struct file *file);
 
 #else
 
+static inline void files_deny_checkpointing(struct files_struct *files) {}
+
 static inline int cr_explain_file(struct file *file, char *explain, int left)
 {
 	return 0;
 }
 
-int cr_file_supported(struct file *file)
+static int cr_file_supported(struct file *file)
 {
 	return 0;
 }
diff -puN include/linux/fdtable.h~deny-ckpt include/linux/fdtable.h
--- linux-2.6.git/include/linux/fdtable.h~deny-ckpt	2009-02-19 10:17:25.000000000 -0800
+++ linux-2.6.git-dave/include/linux/fdtable.h	2009-02-19 10:17:25.000000000 -0800
@@ -45,6 +45,9 @@ struct files_struct {
 	atomic_t count;
 	struct fdtable *fdt;
 	struct fdtable fdtab;
+#ifdef CONFIG_CHECKPOINT_RESTART
+	atomic_t may_checkpoint;
+#endif
   /*
    * written part on a separate cache line in SMP
    */
_
