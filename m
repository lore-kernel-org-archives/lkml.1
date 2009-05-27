Return-Path: <linux-kernel-owner+w=401wt.eu-S933355AbZE0SRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355AbZE0SRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933206AbZE0SQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:16:53 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:61215 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933240AbZE0SQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:16:51 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: [RFC v16][PATCH 08/43] c/r: introduce '->checkpoint()' method in 'struct file_operations'
Date: Wed, 27 May 2009 13:32:34 -0400
Message-Id: <1243445589-32388-9-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1243445589-32388-1-git-send-email-orenl@cs.columbia.edu>
References: <1243445589-32388-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While we assume all normal files and directories can be checkpointed,
there are, as usual in the VFS, specialized places that will always
need an ability to override these defaults. Although we could do this
completely in the checkpoint code, that would bitrot quickly.

This adds a new 'file_operations' function for checkpointing a file.
It is assumed that there should be a dirt-simple way to make something
(un)checkpointable that fits in with current code.

As you can see in the ext[234] patches down the road, all that we have
to do to make something simple be supported is add a single "generic"
f_op entry.

Also introduce vfs_fcntl() so that it can be called from restart (see
patch adding restart of files).

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
---
 fs/fcntl.c                       |   21 +++++++++++++--------
 include/linux/checkpoint_types.h |    2 ++
 include/linux/fs.h               |    6 ++++++
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 1ad7031..17020a9 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -337,6 +337,18 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 	return err;
 }
 
+int vfs_fcntl(int fd, unsigned int cmd, unsigned long arg, struct file *filp)
+{
+	int err;
+
+	err = security_file_fcntl(filp, cmd, arg);
+	if (err)
+		goto out;
+	err = do_fcntl(fd, cmd, arg, filp);
+ out:
+	return err;
+}
+
 SYSCALL_DEFINE3(fcntl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
 {	
 	struct file *filp;
@@ -346,14 +358,7 @@ SYSCALL_DEFINE3(fcntl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
 	if (!filp)
 		goto out;
 
-	err = security_file_fcntl(filp, cmd, arg);
-	if (err) {
-		fput(filp);
-		return err;
-	}
-
-	err = do_fcntl(fd, cmd, arg, filp);
-
+	err = vfs_fcntl(fd, cmd, arg, filp);
  	fput(filp);
 out:
 	return err;
diff --git a/include/linux/checkpoint_types.h b/include/linux/checkpoint_types.h
index c1032fa..9c14034 100644
--- a/include/linux/checkpoint_types.h
+++ b/include/linux/checkpoint_types.h
@@ -15,6 +15,8 @@
 
 #ifdef __KERNEL__
 
+#include <linux/sched.h>
+
 struct ckpt_ctx {
 	int crid;		/* unique checkpoint id */
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9c4348a..60d9229 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -8,6 +8,7 @@
 
 #include <linux/limits.h>
 #include <linux/ioctl.h>
+#include <linux/checkpoint_types.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -1082,6 +1083,8 @@ struct file_lock {
 
 #include <linux/fcntl.h>
 
+extern int vfs_fcntl(int fd, unsigned cmd, unsigned long arg, struct file *fp);
+
 extern void send_sigio(struct fown_struct *fown, int fd, int band);
 
 /* fs/sync.c */
@@ -1508,6 +1511,7 @@ struct file_operations {
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
 	int (*setlease)(struct file *, long, struct file_lock **);
+	int (*checkpoint)(struct ckpt_ctx *, struct file *);
 };
 
 struct inode_operations {
@@ -2306,6 +2310,8 @@ void inode_sub_bytes(struct inode *inode, loff_t bytes);
 loff_t inode_get_bytes(struct inode *inode);
 void inode_set_bytes(struct inode *inode, loff_t bytes);
 
+#define generic_file_checkpoint NULL
+
 extern int vfs_readdir(struct file *, filldir_t, void *);
 
 extern int vfs_stat(char __user *, struct kstat *);
-- 
1.6.0.4

