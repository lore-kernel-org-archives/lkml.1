Return-Path: <linux-kernel-owner+w=401wt.eu-S1760313AbXITHJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313AbXITHJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbXITHFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:05:34 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:64799 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbXITHF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:05:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=cRia+KsKyDkebHj6lHru85CkfjUmRQepSoOAlfpUs/q3jB1aSKI2AXZ87PPIOEv8j9phs46yGJ+znXfMouyfrmY6zRIIDamSz4DgwcnN26e/+30WKuvnsh2sggJfMlhdK/tYxaJAHGGaq+8QlXoXivNGDzAFDb0c5fpjlWBnm1s=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 14/15] sysfs: implement sysfs_open_dirent
In-Reply-To: <11902719091692-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:05:12 +0900
Message-Id: <11902719123491-git-send-email-htejun@gmail.com>
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

Implement sysfs_open_dirent which represents an open file (attribute)
sysfs_dirent.  A file sysfs_dirent with one or more open files have
one sysfs_dirent and all sysfs_buffers (one for each open instance)
are linked to it.

sysfs_open_dirent doesn't actually do anything yet but will be used to
off-load things which are specific for open file sysfs_dirent from it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/file.c  |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/sysfs/sysfs.h |    3 +
 2 files changed, 111 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 3c91a57..b13ba94 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -49,6 +49,22 @@ static struct sysfs_ops subsys_sysfs_ops = {
 	.store	= subsys_attr_store,
 };
 
+/*
+ * There's one sysfs_buffer for each open file and one
+ * sysfs_open_dirent for each sysfs_dirent with one or more open
+ * files.
+ *
+ * filp->private_data points to sysfs_buffer and
+ * sysfs_dirent->s_attr.open points to sysfs_open_dirent.  s_attr.open
+ * is protected by sysfs_open_dirent_lock.
+ */
+static spinlock_t sysfs_open_dirent_lock = SPIN_LOCK_UNLOCKED;
+
+struct sysfs_open_dirent {
+	atomic_t		refcnt;
+	struct list_head	buffers; /* goes through sysfs_buffer.list */
+};
+
 struct sysfs_buffer {
 	size_t			count;
 	loff_t			pos;
@@ -57,6 +73,7 @@ struct sysfs_buffer {
 	struct mutex		mutex;
 	int			needs_read_fill;
 	int			event;
+	struct list_head	list;
 };
 
 /**
@@ -237,6 +254,86 @@ sysfs_write_file(struct file *file, const char __user *buf, size_t count, loff_t
 	return len;
 }
 
+/**
+ *	sysfs_get_open_dirent - get or create sysfs_open_dirent
+ *	@sd: target sysfs_dirent
+ *	@buffer: sysfs_buffer for this instance of open
+ *
+ *	If @sd->s_attr.open exists, increment its reference count;
+ *	otherwise, create one.  @buffer is chained to the buffers
+ *	list.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, -errno on failure.
+ */
+static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
+				 struct sysfs_buffer *buffer)
+{
+	struct sysfs_open_dirent *od, *new_od = NULL;
+
+ retry:
+	spin_lock(&sysfs_open_dirent_lock);
+
+	if (!sd->s_attr.open && new_od) {
+		sd->s_attr.open = new_od;
+		new_od = NULL;
+	}
+
+	od = sd->s_attr.open;
+	if (od) {
+		atomic_inc(&od->refcnt);
+		list_add_tail(&buffer->list, &od->buffers);
+	}
+
+	spin_unlock(&sysfs_open_dirent_lock);
+
+	if (od) {
+		kfree(new_od);
+		return 0;
+	}
+
+	/* not there, initialize a new one and retry */
+	new_od = kmalloc(sizeof(*new_od), GFP_KERNEL);
+	if (!new_od)
+		return -ENOMEM;
+
+	atomic_set(&new_od->refcnt, 0);
+	INIT_LIST_HEAD(&new_od->buffers);
+	goto retry;
+}
+
+/**
+ *	sysfs_put_open_dirent - put sysfs_open_dirent
+ *	@sd: target sysfs_dirent
+ *	@buffer: associated sysfs_buffer
+ *
+ *	Put @sd->s_attr.open and unlink @buffer from the buffers list.
+ *	If reference count reaches zero, disassociate and free it.
+ *
+ *	LOCKING:
+ *	None.
+ */
+static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
+				  struct sysfs_buffer *buffer)
+{
+	struct sysfs_open_dirent *od = sd->s_attr.open;
+
+	spin_lock(&sysfs_open_dirent_lock);
+
+	list_del(&buffer->list);
+	if (atomic_dec_and_test(&od->refcnt))
+		sd->s_attr.open = NULL;
+	else
+		od = NULL;
+
+	spin_unlock(&sysfs_open_dirent_lock);
+
+	kfree(od);
+}
+
 static int sysfs_open_file(struct inode *inode, struct file *file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
@@ -298,19 +395,29 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	buffer->ops = ops;
 	file->private_data = buffer;
 
+	/* make sure we have open dirent struct */
+	error = sysfs_get_open_dirent(attr_sd, buffer);
+	if (error)
+		goto err_free;
+
 	/* open succeeded, put active references */
 	sysfs_put_active_two(attr_sd);
 	return 0;
 
+ err_free:
+	kfree(buffer);
  err_out:
 	sysfs_put_active_two(attr_sd);
 	return error;
 }
 
-static int sysfs_release(struct inode * inode, struct file * filp)
+static int sysfs_release(struct inode *inode, struct file *filp)
 {
+	struct sysfs_dirent *sd = filp->f_path.dentry->d_fsdata;
 	struct sysfs_buffer *buffer = filp->private_data;
 
+	sysfs_put_open_dirent(sd, buffer);
+
 	if (buffer->page)
 		free_page((unsigned long)buffer->page);
 	kfree(buffer);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 42b0327..3adce7d 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -1,3 +1,5 @@
+struct sysfs_open_dirent;
+
 /* type-specific structures for sysfs_dirent->s_* union members */
 struct sysfs_elem_dir {
 	struct kobject		*kobj;
@@ -11,6 +13,7 @@ struct sysfs_elem_symlink {
 
 struct sysfs_elem_attr {
 	struct attribute	*attr;
+	struct sysfs_open_dirent *open;
 };
 
 struct sysfs_elem_bin_attr {
-- 
1.5.0.3


