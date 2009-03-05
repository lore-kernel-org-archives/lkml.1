Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbZCEQkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbZCEQkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbZCEQjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:39:18 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40316 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbZCEQjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:39:17 -0500
Subject: [RFC][PATCH 09/11] check files for checkpointability
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 05 Mar 2009 08:39:10 -0800
References: <20090305163857.0C18F3FD@kernel>
In-Reply-To: <20090305163857.0C18F3FD@kernel>
Message-Id: <20090305163910.5960D190@kernel>
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
 linux-2.6.git-dave/include/linux/checkpoint.h |   13 +++++++++++++
 linux-2.6.git-dave/include/linux/fdtable.h    |    3 +++
 4 files changed, 40 insertions(+)

diff -puN fs/file.c~242c7afafb1a81c0d9a41085536f2197d81146e7 fs/file.c
--- linux-2.6.git/fs/file.c~242c7afafb1a81c0d9a41085536f2197d81146e7	2009-03-05 08:37:04.000000000 -0800
+++ linux-2.6.git-dave/fs/file.c	2009-03-05 08:37:04.000000000 -0800
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
+	newf->may_checkpoint = 1;
+#endif
 
 	spin_lock_init(&newf->file_lock);
 	newf->next_fd = 0;
@@ -396,6 +414,7 @@ struct files_struct *dup_fd(struct files
 
 	rcu_assign_pointer(newf->fdt, new_fdt);
 
+	__scan_files_for_cr(newf);
 	return newf;
 
 out_release:
diff -puN fs/open.c~242c7afafb1a81c0d9a41085536f2197d81146e7 fs/open.c
--- linux-2.6.git/fs/open.c~242c7afafb1a81c0d9a41085536f2197d81146e7	2009-03-05 08:37:04.000000000 -0800
+++ linux-2.6.git-dave/fs/open.c	2009-03-05 08:37:04.000000000 -0800
@@ -29,6 +29,7 @@
 #include <linux/rcupdate.h>
 #include <linux/audit.h>
 #include <linux/falloc.h>
+#include <linux/checkpoint.h>
 
 int vfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
@@ -1015,6 +1016,10 @@ void fd_install(unsigned int fd, struct 
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
diff -puN include/linux/checkpoint.h~242c7afafb1a81c0d9a41085536f2197d81146e7 include/linux/checkpoint.h
--- linux-2.6.git/include/linux/checkpoint.h~242c7afafb1a81c0d9a41085536f2197d81146e7	2009-03-05 08:37:04.000000000 -0800
+++ linux-2.6.git-dave/include/linux/checkpoint.h	2009-03-05 08:37:04.000000000 -0800
@@ -12,6 +12,7 @@
 
 #include <linux/path.h>
 #include <linux/fs.h>
+#include <linux/fdtable.h>
 
 #ifdef CONFIG_CHECKPOINT_RESTART
 
@@ -101,11 +102,23 @@ extern int cr_read_files(struct cr_ctx *
 
 #define pr_fmt(fmt) "[%d:c/r:%s] " fmt, task_pid_vnr(current), __func__
 
+static inline void __files_deny_checkpointing(struct files_struct *files,
+		char *file, int line)
+{
+	if (!test_and_clear_bit(0, &files->may_checkpoint))
+		return;
+	printk(KERN_INFO "process performed an action that can not be "
+			"checkpointed at: %s:%d\n", file, line);
+}
+#define files_deny_checkpointing(f)  \
+	__files_deny_checkpointing(f, __FILE__, __LINE__)
+
 int cr_explain_file(struct file *file, char *explain, int left);
 int cr_file_supported(struct file *file);
 
 #else /* !CONFIG_CHECKPOINT_RESTART */
 
+static inline void files_deny_checkpointing(struct files_struct *files) {}
 static inline int cr_explain_file(struct file *file, char *explain, int left)
 {
 	return 0;
diff -puN include/linux/fdtable.h~242c7afafb1a81c0d9a41085536f2197d81146e7 include/linux/fdtable.h
--- linux-2.6.git/include/linux/fdtable.h~242c7afafb1a81c0d9a41085536f2197d81146e7	2009-03-05 08:37:04.000000000 -0800
+++ linux-2.6.git-dave/include/linux/fdtable.h	2009-03-05 08:37:04.000000000 -0800
@@ -45,6 +45,9 @@ struct files_struct {
 	atomic_t count;
 	struct fdtable *fdt;
 	struct fdtable fdtab;
+#ifdef CONFIG_CHECKPOINT_RESTART
+	unsigned long may_checkpoint;
+#endif
   /*
    * written part on a separate cache line in SMP
    */
_
