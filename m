Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbXITHIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbXITHIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbXITHFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:05:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:43685 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbXITHFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:05:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=HoyOf7PNKGUDYmJoAMjtEWCvYkoNmzcrIMLnZrslYeKOHehsPhd9RlSnOsmStDjENvvrPVsQ+Y9v+g56s4u52hzWVLT1rjKnZSWH/en2QKQNmoajVdyMigNIdLtqpLJr7cruFOtJf7nuNXKOief7m8PrhuOveMXak2iqV4Izdfw=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 10/15] sysfs: make s_elem an anonymous union
In-Reply-To: <11902719091692-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:05:11 +0900
Message-Id: <11902719113234-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make s_elem an anonymous union.  Prefixing with s_elem makes things
needlessly longer without any advantage.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/bin.c     |   14 +++++++-------
 fs/sysfs/dir.c     |    4 ++--
 fs/sysfs/file.c    |   14 +++++++-------
 fs/sysfs/inode.c   |    2 +-
 fs/sysfs/symlink.c |    4 ++--
 fs/sysfs/sysfs.h   |   10 +++++-----
 6 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 9c8f882..247ea19 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -30,8 +30,8 @@ static int
 fill_read(struct dentry *dentry, char *buffer, loff_t off, size_t count)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
-	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
+	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	int rc;
 
 	/* need attr_sd for attr, its parent for kobj */
@@ -87,8 +87,8 @@ static int
 flush_write(struct dentry *dentry, char *buffer, loff_t offset, size_t count)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
-	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
+	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	int rc;
 
 	/* need attr_sd for attr, its parent for kobj */
@@ -140,8 +140,8 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct bin_buffer *bb = file->private_data;
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
-	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
+	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	int rc;
 
 	mutex_lock(&bb->mutex);
@@ -167,7 +167,7 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 static int open(struct inode * inode, struct file * file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
+	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
 	struct bin_buffer *bb = NULL;
 	int error;
 
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e85206c..942d8e3 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -273,7 +273,7 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 	parent_sd = sd->s_parent;
 
 	if (sysfs_type(sd) == SYSFS_KOBJ_LINK)
-		sysfs_put(sd->s_elem.symlink.target_sd);
+		sysfs_put(sd->s_symlink.target_sd);
 	if (sysfs_type(sd) & SYSFS_COPY_NAME)
 		kfree(sd->s_name);
 	kfree(sd->s_iattr);
@@ -626,7 +626,7 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 	sd = sysfs_new_dirent(name, mode, SYSFS_DIR);
 	if (!sd)
 		return -ENOMEM;
-	sd->s_elem.dir.kobj = kobj;
+	sd->s_dir.kobj = kobj;
 
 	/* link in */
 	sysfs_addrm_start(&acxt, parent_sd);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 8f1ebd8..3c91a57 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -73,7 +73,7 @@ struct sysfs_buffer {
 static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	struct sysfs_ops * ops = buffer->ops;
 	int ret = 0;
 	ssize_t count;
@@ -88,7 +88,7 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 		return -ENODEV;
 
 	buffer->event = atomic_read(&attr_sd->s_event);
-	count = ops->show(kobj, attr_sd->s_elem.attr.attr, buffer->page);
+	count = ops->show(kobj, attr_sd->s_attr.attr, buffer->page);
 
 	sysfs_put_active_two(attr_sd);
 
@@ -188,7 +188,7 @@ static int
 flush_write_buffer(struct dentry * dentry, struct sysfs_buffer * buffer, size_t count)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	struct sysfs_ops * ops = buffer->ops;
 	int rc;
 
@@ -196,7 +196,7 @@ flush_write_buffer(struct dentry * dentry, struct sysfs_buffer * buffer, size_t
 	if (!sysfs_get_active_two(attr_sd))
 		return -ENODEV;
 
-	rc = ops->store(kobj, attr_sd->s_elem.attr.attr, buffer->page, count);
+	rc = ops->store(kobj, attr_sd->s_attr.attr, buffer->page, count);
 
 	sysfs_put_active_two(attr_sd);
 
@@ -240,7 +240,7 @@ sysfs_write_file(struct file *file, const char __user *buf, size_t count, loff_t
 static int sysfs_open_file(struct inode *inode, struct file *file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
 	int error;
@@ -336,7 +336,7 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 {
 	struct sysfs_buffer * buffer = filp->private_data;
 	struct sysfs_dirent *attr_sd = filp->f_path.dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 
 	/* need parent for the kobj, grab both */
 	if (!sysfs_get_active_two(attr_sd))
@@ -396,7 +396,7 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 	sd = sysfs_new_dirent(attr->name, mode, type);
 	if (!sd)
 		return -ENOMEM;
-	sd->s_elem.attr.attr = (void *)attr;
+	sd->s_attr.attr = (void *)attr;
 
 	sysfs_addrm_start(&acxt, dir_sd);
 	rc = sysfs_add_one(&acxt, sd);
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 0d706a8..b6ac4e6 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -172,7 +172,7 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 		inode->i_fop = &sysfs_file_operations;
 		break;
 	case SYSFS_KOBJ_BIN_ATTR:
-		bin_attr = sd->s_elem.bin_attr.bin_attr;
+		bin_attr = sd->s_bin_attr.bin_attr;
 		inode->i_size = bin_attr->size;
 		inode->i_fop = &bin_fops;
 		break;
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 8ad38bc..ffa82e9 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -86,7 +86,7 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 	if (!sd)
 		goto out_put;
 
-	sd->s_elem.symlink.target_sd = target_sd;
+	sd->s_symlink.target_sd = target_sd;
 	target_sd = NULL;	/* reference is now owned by the symlink */
 
 	sysfs_addrm_start(&acxt, parent_sd);
@@ -142,7 +142,7 @@ static int sysfs_getlink(struct dentry *dentry, char * path)
 {
 	struct sysfs_dirent *sd = dentry->d_fsdata;
 	struct sysfs_dirent *parent_sd = sd->s_parent;
-	struct sysfs_dirent *target_sd = sd->s_elem.symlink.target_sd;
+	struct sysfs_dirent *target_sd = sd->s_symlink.target_sd;
 	int error;
 
 	mutex_lock(&sysfs_mutex);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 6cf61c8..2a68bfa 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -32,11 +32,11 @@ struct sysfs_dirent {
 	const char		*s_name;
 
 	union {
-		struct sysfs_elem_dir		dir;
-		struct sysfs_elem_symlink	symlink;
-		struct sysfs_elem_attr		attr;
-		struct sysfs_elem_bin_attr	bin_attr;
-	}			s_elem;
+		struct sysfs_elem_dir		s_dir;
+		struct sysfs_elem_symlink	s_symlink;
+		struct sysfs_elem_attr		s_attr;
+		struct sysfs_elem_bin_attr	s_bin_attr;
+	};
 
 	unsigned int		s_flags;
 	ino_t			s_ino;
-- 
1.5.0.3


