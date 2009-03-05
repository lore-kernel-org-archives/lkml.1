Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbZCEQmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbZCEQmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbZCEQji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:39:38 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59888 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284AbZCEQjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:39:37 -0500
Subject: [RFC][PATCH 07/11] file c/r: expose functions to query fs support
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 05 Mar 2009 08:39:07 -0800
References: <20090305163857.0C18F3FD@kernel>
In-Reply-To: <20090305163857.0C18F3FD@kernel>
Message-Id: <20090305163907.143E9D50@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This pair of functions will check to see whether a given
'struct file' can be checkpointed.  If it can't be, the
"explain" function can also give a description why.

Note that we assume the presence of an f_op->checkpoint
implies that a file is always checkpointable.  That may
have to change in the future, but it is a fixed rule
for now.
  
Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/checkpoint/ckpt_file.c     |   26 ++++++++++++++++++++++++++
 linux-2.6.git-dave/include/linux/checkpoint.h |   18 ++++++++++++++++++
 2 files changed, 44 insertions(+)

diff -puN checkpoint/ckpt_file.c~cfcc333a1e665c38185a12ba119c32cf796dbd85 checkpoint/ckpt_file.c
--- linux-2.6.git/checkpoint/ckpt_file.c~cfcc333a1e665c38185a12ba119c32cf796dbd85	2009-03-05 08:37:03.000000000 -0800
+++ linux-2.6.git-dave/checkpoint/ckpt_file.c	2009-03-05 08:37:03.000000000 -0800
@@ -93,6 +93,32 @@ int generic_file_checkpoint(struct file 
 	return 0;
 }
 
+int cr_explain_file(struct file *file, char *explain, int left)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+
+	if (!file->f_op->checkpoint)
+		return scnprintf(explain, left, " (no checkpoint handler)");
+
+	if (special_file(inode->i_mode))
+		return scnprintf(explain, left, " (special file)");
+
+	return 0;
+}
+
+int cr_file_supported(struct file *file)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+
+	if (!file->f_op->checkpoint)
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
diff -puN include/linux/checkpoint.h~cfcc333a1e665c38185a12ba119c32cf796dbd85 include/linux/checkpoint.h
--- linux-2.6.git/include/linux/checkpoint.h~cfcc333a1e665c38185a12ba119c32cf796dbd85	2009-03-05 08:37:03.000000000 -0800
+++ linux-2.6.git-dave/include/linux/checkpoint.h	2009-03-05 08:37:03.000000000 -0800
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
+#else /* !CONFIG_CHECKPOINT_RESTART */
+
+static inline int cr_explain_file(struct file *file, char *explain, int left)
+{
+	return 0;
+}
+
+static inline int cr_file_supported(struct file *file)
+{
+	return 0;
+}
+
+#endif /* CONFIG_CHECKPOINT_RESTART */
 #endif /* _CHECKPOINT_CKPT_H_ */
_
