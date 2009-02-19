Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbZBSSVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbZBSSVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZBSSUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:20:19 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:52630 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbZBSSUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:20:14 -0500
Subject: [RFC][PATCH 2/5] file c/r: expose functions to query fs support
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 19 Feb 2009 10:20:08 -0800
References: <20090219182007.B4B47C1F@kernel>
In-Reply-To: <20090219182007.B4B47C1F@kernel>
Message-Id: <20090219182008.8F45CD7E@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This pair of functions will check to see whether a given
'struct file' can be checkpointed.  If it can't be, the
"explain" function can also give a description why.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/checkpoint/ckpt_file.c     |   30 ++++++++++++++++++++++++++
 linux-2.6.git-dave/include/linux/checkpoint.h |   18 +++++++++++++++
 2 files changed, 48 insertions(+)

diff -puN checkpoint/ckpt_file.c~cr-explain-unckpt-file checkpoint/ckpt_file.c
--- linux-2.6.git/checkpoint/ckpt_file.c~cr-explain-unckpt-file	2009-02-19 10:17:24.000000000 -0800
+++ linux-2.6.git-dave/checkpoint/ckpt_file.c	2009-02-19 10:17:24.000000000 -0800
@@ -72,6 +72,36 @@ int cr_scan_fds(struct files_struct *fil
 	return n;
 }
 
+int cr_explain_file(struct file *file, char *explain, int left)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct file_system_type *fs_type = inode->i_sb->s_type;
+
+	if (!(fs_type->fs_flags & FS_CHECKPOINTABLE))
+		return snprintf(explain, left,
+				" (%s does not support checkpoint)",
+				fs_type->name);
+
+	if (special_file(inode->i_mode))
+		return snprintf(explain, left, " (special file)");
+
+	return 0;
+}
+
+int cr_file_supported(struct file *file)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct file_system_type *fs_type = inode->i_sb->s_type;
+
+	if (!(fs_type->fs_flags & FS_CHECKPOINTABLE))
+		return 0;
+
+	if (special_file(inode->i_mode))
+		return 0;
+
+	return 1;
+}
+
 /* cr_write_fd_data - dump the state of a given file pointer */
 static int cr_write_fd_data(struct cr_ctx *ctx, struct file *file, int parent)
 {
diff -puN include/linux/checkpoint.h~cr-explain-unckpt-file include/linux/checkpoint.h
--- linux-2.6.git/include/linux/checkpoint.h~cr-explain-unckpt-file	2009-02-19 10:17:24.000000000 -0800
+++ linux-2.6.git-dave/include/linux/checkpoint.h	2009-02-19 10:17:24.000000000 -0800
@@ -13,6 +13,8 @@
 #include <linux/path.h>
 #include <linux/fs.h>
 
+#ifdef CONFIG_CHECKPOINT_RESTART
+
 #define CR_VERSION  2
 
 struct cr_ctx {
@@ -99,4 +101,20 @@ extern int cr_read_files(struct cr_ctx *
 
 #define pr_fmt(fmt) "[%d:c/r:%s] " fmt, task_pid_vnr(current), __func__
 
+int cr_explain_file(struct file *file, char *explain, int left);
+int cr_file_supported(struct file *file);
+
+#else
+
+static inline int cr_explain_file(struct file *file, char *explain, int left)
+{
+	return 0;
+}
+
+int cr_file_supported(struct file *file)
+{
+	return 0;
+}
+
+#endif
 #endif /* _CHECKPOINT_CKPT_H_ */
_
