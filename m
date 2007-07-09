Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbXGIC5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbXGIC5z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 22:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758680AbXGIC5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 22:57:34 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:37734 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495AbXGIC5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 22:57:33 -0400
Date: Sun, 8 Jul 2007 22:57:30 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] selinux: add selinuxfs structure for object class
 discovery
In-Reply-To: <Line.LNX.4.64.0707082253040.12256@d.namei>
Message-ID: <Line.LNX.4.64.0707082256590.12256@d.namei>
References: <Line.LNX.4.64.0707082253040.12256@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christopher J. PeBenito <cpebenito@tresys.com>

The structure is as follows (relative to selinuxfs root):

/class/file/index
/class/file/perms/read
/class/file/perms/write
...

Each class is allocated 33 inodes, 1 for the class index and 32 for
permissions.  Relative to SEL_CLASS_INO_OFFSET, the inode of the index file
DIV 33 is the class number.  The inode of the permission file % 33 is the
index of the permission for that class.

Signed-off-by: Christopher J. PeBenito <cpebenito@tresys.com>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/include/security.h |    1 +
 security/selinux/selinuxfs.c        |  249 +++++++++++++++++++++++++++++++++++
 2 files changed, 250 insertions(+), 0 deletions(-)

diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 731a173..83bdd4d 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -41,6 +41,7 @@ extern int selinux_mls_enabled;
 
 int security_load_policy(void * data, size_t len);
 
+#define SEL_VEC_MAX 32
 struct av_decision {
 	u32 allowed;
 	u32 decided;
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index cf1acde..c9e92da 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -67,6 +67,10 @@ static struct dentry *bool_dir = NULL;
 static int bool_num = 0;
 static int *bool_pending_values = NULL;
 
+/* global data for classes */
+static struct dentry *class_dir = NULL;
+static unsigned long last_class_ino;
+
 extern void selnl_notify_setenforce(int val);
 
 /* Check whether a task is allowed to use a security operation. */
@@ -106,6 +110,7 @@ static unsigned long sel_last_ino = SEL_INO_NEXT - 1;
 
 #define SEL_INITCON_INO_OFFSET 	0x01000000
 #define SEL_BOOL_INO_OFFSET	0x02000000
+#define SEL_CLASS_INO_OFFSET	0x04000000
 #define SEL_INO_MASK		0x00ffffff
 
 #define TMPBUFLEN	12
@@ -237,6 +242,11 @@ static const struct file_operations sel_policyvers_ops = {
 
 /* declaration for sel_write_load */
 static int sel_make_bools(void);
+static int sel_make_classes(void);
+
+/* declaration for sel_make_class_dirs */
+static int sel_make_dir(struct inode *dir, struct dentry *dentry,
+			unsigned long *ino);
 
 static ssize_t sel_read_mls(struct file *filp, char __user *buf,
 				size_t count, loff_t *ppos)
@@ -287,10 +297,18 @@ static ssize_t sel_write_load(struct file * file, const char __user * buf,
 		goto out;
 
 	ret = sel_make_bools();
+	if (ret) {
+		length = ret;
+		goto out1;
+	}
+
+	ret = sel_make_classes();
 	if (ret)
 		length = ret;
 	else
 		length = count;
+
+out1:
 	audit_log(current->audit_context, GFP_KERNEL, AUDIT_MAC_POLICY_LOAD,
 		"policy loaded auid=%u",
 		audit_get_loginuid(current->audit_context));
@@ -1293,6 +1311,225 @@ out:
 	return ret;
 }
 
+static inline unsigned int sel_div(unsigned long a, unsigned long b)
+{
+	return a / b - (a % b < 0);
+}
+
+static inline unsigned long sel_class_to_ino(u16 class)
+{
+	return (class * (SEL_VEC_MAX + 1)) | SEL_CLASS_INO_OFFSET;
+}
+
+static inline u16 sel_ino_to_class(unsigned long ino)
+{
+	return sel_div(ino & SEL_INO_MASK, SEL_VEC_MAX + 1);
+}
+
+static inline unsigned long sel_perm_to_ino(u16 class, u32 perm)
+{
+	return (class * (SEL_VEC_MAX + 1) + perm) | SEL_CLASS_INO_OFFSET;
+}
+
+static inline u32 sel_ino_to_perm(unsigned long ino)
+{
+	return (ino & SEL_INO_MASK) % (SEL_VEC_MAX + 1);
+}
+
+static ssize_t sel_read_class(struct file * file, char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	ssize_t rc, len;
+	char *page;
+	unsigned long ino = file->f_path.dentry->d_inode->i_ino;
+
+	page = (char *)__get_free_page(GFP_KERNEL);
+	if (!page) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	len = snprintf(page, PAGE_SIZE, "%d", sel_ino_to_class(ino));
+	rc = simple_read_from_buffer(buf, count, ppos, page, len);
+	free_page((unsigned long)page);
+out:
+	return rc;
+}
+
+static const struct file_operations sel_class_ops = {
+	.read		= sel_read_class,
+};
+
+static ssize_t sel_read_perm(struct file * file, char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	ssize_t rc, len;
+	char *page;
+	unsigned long ino = file->f_path.dentry->d_inode->i_ino;
+
+	page = (char *)__get_free_page(GFP_KERNEL);
+	if (!page) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	len = snprintf(page, PAGE_SIZE,"%d", sel_ino_to_perm(ino));
+	rc = simple_read_from_buffer(buf, count, ppos, page, len);
+	free_page((unsigned long)page);
+out:
+	return rc;
+}
+
+static const struct file_operations sel_perm_ops = {
+	.read		= sel_read_perm,
+};
+
+static int sel_make_perm_files(char *objclass, int classvalue,
+				struct dentry *dir)
+{
+	int i, rc = 0, nperms;
+	char **perms;
+
+	rc = security_get_permissions(objclass, &perms, &nperms);
+	if (rc)
+		goto out;
+
+	for (i = 0; i < nperms; i++) {
+		struct inode *inode;
+		struct dentry *dentry;
+
+		dentry = d_alloc_name(dir, perms[i]);
+		if (!dentry) {
+			rc = -ENOMEM;
+			goto out1;
+		}
+
+		inode = sel_make_inode(dir->d_sb, S_IFREG|S_IRUGO);
+		if (!inode) {
+			rc = -ENOMEM;
+			goto out1;
+		}
+		inode->i_fop = &sel_perm_ops;
+		/* i+1 since perm values are 1-indexed */
+		inode->i_ino = sel_perm_to_ino(classvalue, i+1);
+		d_add(dentry, inode);
+	}
+
+out1:
+	for (i = 0; i < nperms; i++)
+		kfree(perms[i]);
+	kfree(perms);
+out:
+	return rc;
+}
+
+static int sel_make_class_dir_entries(char *classname, int index,
+					struct dentry *dir)
+{
+	struct dentry *dentry = NULL;
+	struct inode *inode = NULL;
+	int rc;
+
+	dentry = d_alloc_name(dir, "index");
+	if (!dentry) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	inode = sel_make_inode(dir->d_sb, S_IFREG|S_IRUGO);
+	if (!inode) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	inode->i_fop = &sel_class_ops;
+	inode->i_ino = sel_class_to_ino(index);
+	d_add(dentry, inode);
+
+	dentry = d_alloc_name(dir, "perms");
+	if (!dentry) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = sel_make_dir(dir->d_inode, dentry, &last_class_ino);
+	if (rc)
+		goto out;
+
+	rc = sel_make_perm_files(classname, index, dentry);
+
+out:
+	return rc;
+}
+
+static void sel_remove_classes(void)
+{
+	struct list_head *class_node;
+
+	list_for_each(class_node, &class_dir->d_subdirs) {
+		struct dentry *class_subdir = list_entry(class_node,
+					struct dentry, d_u.d_child);
+		struct list_head *class_subdir_node;
+
+		list_for_each(class_subdir_node, &class_subdir->d_subdirs) {
+			struct dentry *d = list_entry(class_subdir_node,
+						struct dentry, d_u.d_child);
+
+			if (d->d_inode)
+				if (d->d_inode->i_mode & S_IFDIR)
+					sel_remove_entries(d);
+		}
+
+		sel_remove_entries(class_subdir);
+	}
+
+	sel_remove_entries(class_dir);
+}
+
+static int sel_make_classes(void)
+{
+	int rc = 0, nclasses, i;
+	char **classes;
+
+	/* delete any existing entries */
+	sel_remove_classes();
+
+	rc = security_get_classes(&classes, &nclasses);
+	if (rc < 0)
+		goto out;
+
+	/* +2 since classes are 1-indexed */
+	last_class_ino = sel_class_to_ino(nclasses+2);
+
+	for (i = 0; i < nclasses; i++) {
+		struct dentry *class_name_dir;
+
+		class_name_dir = d_alloc_name(class_dir, classes[i]);
+		if (!class_name_dir) {
+			rc = -ENOMEM;
+			goto out1;
+		}
+
+		rc = sel_make_dir(class_dir->d_inode, class_name_dir,
+				&last_class_ino);
+		if (rc)
+			goto out1;
+
+		/* i+1 since class values are 1-indexed */
+		rc = sel_make_class_dir_entries(classes[i], i+1,
+				class_name_dir);
+		if (rc)
+			goto out1;
+	}
+
+out1:
+	for (i = 0; i < nclasses; i++)
+		kfree(classes[i]);
+	kfree(classes);
+out:
+	return rc;
+}
+
 static int sel_make_dir(struct inode *dir, struct dentry *dentry,
 			unsigned long *ino)
 {
@@ -1407,6 +1644,18 @@ static int sel_fill_super(struct super_block * sb, void * data, int silent)
 	if (ret)
 		goto err;
 
+	dentry = d_alloc_name(sb->s_root, "class");
+	if (!dentry) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ret = sel_make_dir(root_inode, dentry, &sel_last_ino);
+	if (ret)
+		goto err;
+
+	class_dir = dentry;
+
 out:
 	return ret;
 err:
-- 
1.5.0.6

