Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbYJ1FbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbYJ1FbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 01:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYJ1Faw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 01:30:52 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:53750
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbYJ1Fav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 01:30:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADZABkl8qQJT/2dsb2JhbADHIoNP
X-IronPort-AV: E=Sophos;i="4.33,496,1220198400"; 
   d="scan'208";a="393728622"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 1/2] autofs4 - make autofs type usage explicit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Tue, 28 Oct 2008 14:30:47 +0900
Message-ID: <20081028053047.29379.19919.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch further improves autofs mount type usage and provides
supplementry explanation of the changes made in the previous patch
"autofs4 - cleanup autofs mount type usage".

Changes introduced in "autofs4 - cleanup autofs mount type usage":

- the type assigned at mount when no type is given is changed
  from 0 to AUTOFS_TYPE_INDIRECT. This was done because 0 and
  AUTOFS_TYPE_INDIRECT were being treated implicitly as the same
  type.

- previously, an offset mount had it's type set to
  AUTOFS_TYPE_DIRECT|AUTOFS_TYPE_OFFSET but the mount control
  re-implementation needs to be able distinguish all three types.
  So this was changed to make the type setting explicit.

- a type AUTOFS_TYPE_ANY was added for use by the re-implementation
  when checking if a given path is a mountpoint. It's not really a
  type as we use this to ask if a given path is a mountpoint in the
  autofs_dev_ioctl_ismountpoint() function.

Changes introduced in this patch:

- functions to set and test the autofs mount types have been added to
  improve readability and make the type usage explicit.

- the mount type is used from user space for the mount control
  re-implementtion so, for consistency, all the definitions have
  been moved to the user space include file include/linux/auto_fs4.h.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---

 fs/autofs4/autofs_i.h    |    2 -
 fs/autofs4/dev-ioctl.c   |    4 +--
 fs/autofs4/expire.c      |    4 +--
 fs/autofs4/inode.c       |   14 +++++-----
 fs/autofs4/waitq.c       |    8 +++---
 include/linux/auto_fs4.h |   62 +++++++++++++++++++++++++++++++++++++++++++---
 6 files changed, 73 insertions(+), 21 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index e0f16da..a768031 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -25,8 +25,6 @@
 #define AUTOFS_DEV_IOCTL_IOC_FIRST	(AUTOFS_DEV_IOCTL_VERSION)
 #define AUTOFS_DEV_IOCTL_IOC_COUNT	(AUTOFS_IOC_COUNT - 11)
 
-#define AUTOFS_TYPE_TRIGGER	(AUTOFS_TYPE_DIRECT|AUTOFS_TYPE_OFFSET)
-
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/time.h>
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index e32ad6a..cd8c972 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -530,7 +530,7 @@ static int autofs_dev_ioctl_expire(struct file *fp,
 	how = param->arg1;
 	mnt = fp->f_path.mnt;
 
-	if (sbi->type & AUTOFS_TYPE_TRIGGER)
+	if (autofs_type_trigger(sbi->type))
 		dentry = autofs4_expire_direct(sbi->sb, mnt, sbi, how);
 	else
 		dentry = autofs4_expire_indirect(sbi->sb, mnt, sbi, how);
@@ -612,7 +612,7 @@ static int autofs_dev_ioctl_ismountpoint(struct file *fp,
 	param->arg2 = 0;
 
 	if (!fp || param->ioctlfd == -1) {
-		if (type == AUTOFS_TYPE_ANY) {
+		if (autofs_type_any(type)) {
 			struct super_block *sb;
 
 			err = path_lookup(path, LOOKUP_FOLLOW, &nd);
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 4b6fb3f..e3bd507 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -63,7 +63,7 @@ static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 		struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 
 		/* This is an autofs submount, we can't expire it */
-		if (sbi->type == AUTOFS_TYPE_INDIRECT)
+		if (autofs_type_indirect(sbi->type))
 			goto done;
 
 		/*
@@ -490,7 +490,7 @@ int autofs4_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 	if (arg && get_user(do_now, arg))
 		return -EFAULT;
 
-	if (sbi->type & AUTOFS_TYPE_TRIGGER)
+	if (autofs_type_trigger(sbi->type))
 		dentry = autofs4_expire_direct(sb, mnt, sbi, do_now);
 	else
 		dentry = autofs4_expire_indirect(sb, mnt, sbi, do_now);
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 9408507..eee5199 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -197,9 +197,9 @@ static int autofs4_show_options(struct seq_file *m, struct vfsmount *mnt)
 	seq_printf(m, ",minproto=%d", sbi->min_proto);
 	seq_printf(m, ",maxproto=%d", sbi->max_proto);
 
-	if (sbi->type & AUTOFS_TYPE_OFFSET)
+	if (autofs_type_offset(sbi->type))
 		seq_printf(m, ",offset");
-	else if (sbi->type & AUTOFS_TYPE_DIRECT)
+	else if (autofs_type_direct(sbi->type))
 		seq_printf(m, ",direct");
 	else
 		seq_printf(m, ",indirect");
@@ -284,13 +284,13 @@ static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
 			*maxproto = option;
 			break;
 		case Opt_indirect:
-			*type = AUTOFS_TYPE_INDIRECT;
+			set_autofs_type_indirect(type);
 			break;
 		case Opt_direct:
-			*type = AUTOFS_TYPE_DIRECT;
+			set_autofs_type_direct(type);
 			break;
 		case Opt_offset:
-			*type = AUTOFS_TYPE_OFFSET;
+			set_autofs_type_offset(type);
 			break;
 		default:
 			return 1;
@@ -338,7 +338,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	sbi->sb = s;
 	sbi->version = 0;
 	sbi->sub_version = 0;
-	sbi->type = AUTOFS_TYPE_INDIRECT;
+	set_autofs_type_indirect(&sbi->type);
 	sbi->min_proto = 0;
 	sbi->max_proto = 0;
 	mutex_init(&sbi->wq_mutex);
@@ -380,7 +380,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	}
 
 	root_inode->i_fop = &autofs4_root_operations;
-	root_inode->i_op = sbi->type & AUTOFS_TYPE_TRIGGER ?
+	root_inode->i_op = autofs_type_trigger(sbi->type) ?
 			&autofs4_direct_root_inode_operations :
 			&autofs4_indirect_root_inode_operations;
 
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 4b67c2a..acf88e8 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -337,7 +337,7 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 		 * is very similar for indirect mounts except only dentrys
 		 * in the root of the autofs file system may be negative.
 		 */
-		if (sbi->type & AUTOFS_TYPE_TRIGGER)
+		if (autofs_type_trigger(sbi->type))
 			return -ENOENT;
 		else if (!IS_ROOT(dentry->d_parent))
 			return -ENOENT;
@@ -348,7 +348,7 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 		return -ENOMEM;
 
 	/* If this is a direct mount request create a dummy name */
-	if (IS_ROOT(dentry) && sbi->type & AUTOFS_TYPE_TRIGGER)
+	if (IS_ROOT(dentry) && autofs_type_trigger(sbi->type))
 		qstr.len = sprintf(name, "%p", dentry);
 	else {
 		qstr.len = autofs4_getpath(sbi, dentry, &name);
@@ -406,11 +406,11 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 				type = autofs_ptype_expire_multi;
 		} else {
 			if (notify == NFY_MOUNT)
-				type = (sbi->type & AUTOFS_TYPE_TRIGGER) ?
+				type = autofs_type_trigger(sbi->type) ?
 					autofs_ptype_missing_direct :
 					 autofs_ptype_missing_indirect;
 			else
-				type = (sbi->type & AUTOFS_TYPE_TRIGGER) ?
+				type = autofs_type_trigger(sbi->type) ?
 					autofs_ptype_expire_direct :
 					autofs_ptype_expire_indirect;
 		}
diff --git a/include/linux/auto_fs4.h b/include/linux/auto_fs4.h
index 2253716..55fa478 100644
--- a/include/linux/auto_fs4.h
+++ b/include/linux/auto_fs4.h
@@ -29,10 +29,64 @@
 #define AUTOFS_EXP_IMMEDIATE		1
 #define AUTOFS_EXP_LEAVES		2
 
-#define AUTOFS_TYPE_ANY			0x0000
-#define AUTOFS_TYPE_INDIRECT		0x0001
-#define AUTOFS_TYPE_DIRECT		0x0002
-#define AUTOFS_TYPE_OFFSET		0x0004
+#define AUTOFS_TYPE_ANY			0U
+#define AUTOFS_TYPE_INDIRECT		1U
+#define AUTOFS_TYPE_DIRECT		2U
+#define AUTOFS_TYPE_OFFSET		4U
+
+static inline void set_autofs_type_indirect(unsigned int *type)
+{
+	*type = AUTOFS_TYPE_INDIRECT;
+	return;
+}
+
+static inline unsigned int autofs_type_indirect(unsigned int type)
+{
+	return (type == AUTOFS_TYPE_INDIRECT);
+}
+
+static inline void set_autofs_type_direct(unsigned int *type)
+{
+	*type = AUTOFS_TYPE_DIRECT;
+	return;
+}
+
+static inline unsigned int autofs_type_direct(unsigned int type)
+{
+	return (type == AUTOFS_TYPE_DIRECT);
+}
+
+static inline void set_autofs_type_offset(unsigned int *type)
+{
+	*type = AUTOFS_TYPE_OFFSET;
+	return;
+}
+
+static inline unsigned int autofs_type_offset(unsigned int type)
+{
+	return (type == AUTOFS_TYPE_OFFSET);
+}
+
+static inline unsigned int autofs_type_trigger(unsigned int type)
+{
+	return (type == AUTOFS_TYPE_DIRECT || type == AUTOFS_TYPE_OFFSET);
+}
+
+/*
+ * This isn't really a type as we use it to say "no type set" to
+ * indicate we want to search for "any" mount in the
+ * autofs_dev_ioctl_ismountpoint() device ioctl function.
+ */
+static inline void set_autofs_type_any(unsigned int *type)
+{
+	*type = AUTOFS_TYPE_ANY;
+	return;
+}
+
+static inline unsigned int autofs_type_any(unsigned int type)
+{
+	return (type == AUTOFS_TYPE_ANY);
+}
 
 /* Daemon notification packet types */
 enum autofs_notify {

