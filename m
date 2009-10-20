Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbZJTFuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbZJTFuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 01:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZJTFuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 01:50:18 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49377 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZJTFuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 01:50:17 -0400
Date: Mon, 19 Oct 2009 23:50:21 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH 2/3] Sysfs: Allow directories to be populated dynamically
Message-ID: <20091020055021.GE29158@parisc-linux.org>
References: <20091020054740.GC29158@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020054740.GC29158@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Matthew Wilcox <willy@linux.intel.com>
Date: Mon, 19 Oct 2009 01:02:38 -0400
Subject: [PATCH 2/3] Sysfs: Allow directories to be populated dynamically

Use function pointers to populate and depopulate sysfs directories with
dynamically files.  Include one user, the attribute groups.
---
 fs/sysfs/dir.c   |   49 ++++++++++++++++-------
 fs/sysfs/group.c |  115 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/sysfs/sysfs.h |    5 ++
 3 files changed, 150 insertions(+), 19 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 5fad489..e32a11d 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -294,9 +294,13 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 		goto repeat;
 }
 
-static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
+static void sysfs_d_iput(struct dentry *dentry, struct inode *inode)
 {
-	struct sysfs_dirent * sd = dentry->d_fsdata;
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+
+	if ((sysfs_type(sd) == SYSFS_DIR) && sd->s_dir.depopulate)
+		sd->s_dir.depopulate(dentry, sd);
+	sd->s_flags &= ~SYSFS_FLAG_POPULATED;
 
 	sysfs_put(sd);
 	iput(inode);
@@ -574,6 +578,22 @@ repeat:
 	iput(inode);
 }
 
+void sysfs_kill_removed_dirents(struct sysfs_addrm_cxt *acxt)
+{
+	/* kill removed sysfs_dirents */
+	while (acxt->removed) {
+		struct sysfs_dirent *sd = acxt->removed;
+
+		acxt->removed = sd->s_sibling;
+		sd->s_sibling = NULL;
+
+		sysfs_drop_dentry(sd);
+		sysfs_deactivate(sd);
+		unmap_bin_file(sd);
+		sysfs_put(sd);
+	}
+}
+
 /**
  *	sysfs_addrm_finish - finish up sysfs_dirent add/remove
  *	@acxt: addrm context to finish up
@@ -600,18 +620,7 @@ void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
 		iput(inode);
 	}
 
-	/* kill removed sysfs_dirents */
-	while (acxt->removed) {
-		struct sysfs_dirent *sd = acxt->removed;
-
-		acxt->removed = sd->s_sibling;
-		sd->s_sibling = NULL;
-
-		sysfs_drop_dentry(sd);
-		sysfs_deactivate(sd);
-		unmap_bin_file(sd);
-		sysfs_put(sd);
-	}
+	sysfs_kill_removed_dirents(acxt);
 }
 
 /**
@@ -731,6 +740,17 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 
 	mutex_lock(&sysfs_mutex);
 
+	if (!(parent_sd->s_flags & SYSFS_FLAG_POPULATED)) {
+		if (parent_sd->s_dir.populate) {
+			int err = parent_sd->s_dir.populate(dentry->d_parent,
+								parent_sd);
+			if (err) {
+				ret = ERR_PTR(err);
+				goto out_unlock;
+			}
+		}
+		parent_sd->s_flags |= SYSFS_FLAG_POPULATED;
+	}
 	sd = sysfs_find_dirent(parent_sd, dentry->d_name.name);
 
 	/* no such entry */
@@ -1012,7 +1032,6 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	return 0;
 }
 
-
 const struct file_operations sysfs_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= sysfs_readdir,
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 0c4d342..37ac584 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -16,6 +16,102 @@
 #include "sysfs.h"
 
 
+/*
+ * i_mutex is not held, but this inode is on its way out of the system, so
+ * nobody gets to mess with it.  We can't take the sysfs_mutex here as it
+ * leads to a deadlock scenario where it's held in a path that can run
+ * reclaim, and this function can be called from reclaim context.  I guess
+ * prayer is the only solution here (other than splitting sysfs_mutex)
+ */
+void sysfs_depopulate_group(struct dentry *dentry,
+					const struct attribute_group *grp)
+						
+{
+	struct sysfs_dirent *dir_sd = dentry->d_fsdata;
+	struct sysfs_addrm_cxt acxt;
+	struct attribute **attrp;
+
+	memset(&acxt, 0, sizeof(acxt));
+	acxt.parent_sd = dir_sd;
+	acxt.parent_inode = dentry->d_inode;
+
+	for (attrp = grp->attrs; *attrp; attrp++) {
+		struct attribute *attr = *attrp;
+		struct sysfs_dirent *sd;
+
+		sd = sysfs_find_dirent(dir_sd, attr->name);
+		if (sd)
+			sysfs_remove_one(&acxt, sd);
+	}
+
+	sysfs_kill_removed_dirents(&acxt);
+}
+EXPORT_SYMBOL(sysfs_depopulate_group);
+
+/*
+ * inode->i_mutex is held by the VFS, and sysfs_mutex is held by
+ * sysfs_lookup, so there's no need to call sysfs_addrm_start/finish here.
+ * Nor is there a need to mess around with reference counts.
+ */
+int sysfs_populate_group(struct dentry *dentry,
+					const struct attribute_group *grp)
+						
+{
+	struct sysfs_dirent *dir_sd = dentry->d_fsdata;
+	struct kobject *kobj = dir_sd->s_dir.kobj;
+	struct sysfs_addrm_cxt acxt;
+	struct attribute **attrp;
+	int i = 0, error = 0;
+
+	memset(&acxt, 0, sizeof(acxt));
+	acxt.parent_sd = dir_sd;
+	acxt.parent_inode = dentry->d_inode;
+
+	for (attrp = grp->attrs; *attrp; attrp++) {
+		struct attribute *attr = *attrp;
+		mode_t mode = attr->mode;
+		struct sysfs_dirent *sd;
+
+		if (grp->is_visible) {
+			mode_t vis = grp->is_visible(kobj, attr, i++);
+			if (!vis)
+				continue;
+			mode |= vis;
+		}
+
+		sd = sysfs_new_dirent(attr->name, mode, SYSFS_KOBJ_ATTR);
+		if (!sd) {
+			error = -ENOMEM;
+			break;
+		}
+		sd->s_attr.attr = (void *)attr;
+
+		error = sysfs_add_one(&acxt, sd);
+		if (error) {
+			sysfs_put(sd);
+			break;
+		}
+	}
+	if (error)
+		sysfs_depopulate_group(dentry, grp);
+	return error;
+}
+EXPORT_SYMBOL(sysfs_populate_group);
+
+static
+int group_populate(struct dentry *dentry, struct sysfs_dirent *sd)
+{
+	struct attribute_group *grp = sd->s_dir.data;
+	return sysfs_populate_group(dentry, grp);
+}
+
+static
+void group_depopulate(struct dentry *dentry, struct sysfs_dirent *sd)
+{
+	struct attribute_group *grp = sd->s_dir.data;
+	sysfs_depopulate_group(dentry, grp);
+}
+
 static void remove_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
 			 const struct attribute_group *grp)
 {
@@ -32,6 +128,10 @@ static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
 	struct attribute *const* attr;
 	int error = 0, i;
 
+	/* Directory isn't currently instantiated; nothing to do */
+	if (!(dir_sd->s_flags & SYSFS_FLAG_POPULATED))
+		return 0;
+
 	for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++) {
 		mode_t mode = 0;
 
@@ -55,7 +155,6 @@ static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
 	return error;
 }
 
-
 static int internal_create_group(struct kobject *kobj, int update,
 				 const struct attribute_group *grp)
 {
@@ -82,10 +181,18 @@ static int internal_create_group(struct kobject *kobj, int update,
 	} else {
 		sd = sysfs_get(kobj->sd);
 	}
-	error = create_files(sd, kobj, grp, update);
-	if (error) {
-		if (grp->name)
+
+	error = 0;
+	if (update) {
+		error = create_files(sd, kobj, grp, update);
+		if (error && grp->name)
 			sysfs_remove_subdir(sd);
+	} else if (!sd->s_dir.populate) {
+		sd->s_dir.populate = group_populate;
+		sd->s_dir.depopulate = group_depopulate;
+		sd->s_dir.data = (void *)grp;
+	} else if (sd->s_dir.populate != group_populate) {
+		error = -EEXIST;
 	}
 	sysfs_put(sd);
 	return error;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index af4c4e7..13843fa 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -17,6 +17,9 @@ struct sysfs_elem_dir {
 	struct kobject		*kobj;
 	/* children list starts here and goes through sd->s_sibling */
 	struct sysfs_dirent	*children;
+	int (*populate)(struct dentry *, struct sysfs_dirent *);
+	void (*depopulate)(struct dentry *, struct sysfs_dirent *);
+	void *data;
 };
 
 struct sysfs_elem_symlink {
@@ -77,6 +80,7 @@ struct sysfs_dirent {
 #define SYSFS_COPY_NAME			(SYSFS_DIR | SYSFS_KOBJ_LINK)
 
 #define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
+#define SYSFS_FLAG_POPULATED		0x0100
 #define SYSFS_FLAG_REMOVED		0x0200
 
 static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
@@ -120,6 +124,7 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
 int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
 void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
 void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
+void sysfs_kill_removed_dirents(struct sysfs_addrm_cxt *acxt);
 
 struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
 				       const unsigned char *name);
-- 
1.6.3.3

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
