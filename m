Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbXITIGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbXITIGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbXITIFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:05:49 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:33382 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbXITIFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=J4H7/38vZ8OCP/+IgNzkdbqZ8YeU/bNlg9m+abtaROw3M0buf8vWBVvT7W94dEGqBZ6eiNz/xXueJHuPF0c8xL7x8bA0hqlHNNAXuENs0UOLEESua6arrLWQBHXJaP3SnP06g8I9ACMrgWzQMz1WoJ4BrwlvCwagfPVE1QJNevo=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 04/22] sysfs: make SYSFS_COPY_NAME a flag
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:39 +0900
Message-Id: <11902755393780-git-send-email-htejun@gmail.com>
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

Currently name is implicitly copied for directory and symlink nodes.
Make the behavior flexible by making it a flag.  If SYSFS_COPY_NAME
bit is specified in @mode when calling sysfs_new_dirent(), the name is
copied.

SYSFS_COPY_NAME is defined as S_IFMT so that it can be specified with
@mode bits.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c        |   21 +++++++++++++++------
 fs/sysfs/symlink.c    |    3 ++-
 fs/sysfs/sysfs.h      |    2 +-
 include/linux/sysfs.h |   10 ++++++++++
 4 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 02918d3..584f17c 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -14,6 +14,11 @@
 #include <linux/mutex.h>
 #include "sysfs.h"
 
+/* verify all mode flags are inside S_IFMT */
+#if (SYSFS_MODE_FLAGS & ~S_IFMT)
+#error SYSFS mode flags out of S_IFMT
+#endif
+
 DEFINE_MUTEX(sysfs_mutex);
 DEFINE_MUTEX(sysfs_rename_mutex);
 spinlock_t sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
@@ -275,7 +280,7 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 
 	if (sysfs_type(sd) == SYSFS_KOBJ_LINK)
 		sysfs_put(sd->s_symlink.target_sd);
-	if (sysfs_type(sd) & SYSFS_COPY_NAME)
+	if (sd->s_flags & SYSFS_FLAG_NAME_COPIED)
 		kfree(sd->s_name);
 	kfree(sd->s_iattr);
 	sysfs_free_ino(sd->s_ino);
@@ -301,11 +306,12 @@ static struct dentry_operations sysfs_dentry_ops = {
 /**
  *	sysfs_new_dirent - allocate and initialize sysfs_dirent
  *	@name: name for the new sysfs_dirent
- *	@mode: mask of bits from S_IRWXUGO
+ *	@mode: mask of bits from S_IRWXUGO | SYSFS_COPY_NAME
  *	@type: one of SYSFS_{DIR|FILE|BIN|LINK}
  *
  *	Allocate and initialize a sysfs_dirent with the specified
- *	parameters.
+ *	parameters.  If SYSFS_COPY_NAME is specified in @mode, @name
+ *	is duplicated.
  *
  *	LOCKING:
  *	Kernel thread context (may sleep).
@@ -316,14 +322,17 @@ static struct dentry_operations sysfs_dentry_ops = {
  */
 struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 {
+	unsigned int flags = type;
 	char *dup_name = NULL;
 	struct sysfs_dirent *sd;
 
 	/* need to copy name? */
-	if (type & SYSFS_COPY_NAME) {
+	if (mode & SYSFS_COPY_NAME) {
 		name = dup_name = kstrdup(name, GFP_KERNEL);
 		if (!name)
 			return NULL;
+
+		flags |= SYSFS_FLAG_NAME_COPIED;
 	}
 
 	/* normalize mode */
@@ -355,7 +364,7 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 
 	sd->s_name = name;
 	sd->s_mode = mode;
-	sd->s_flags = type;
+	sd->s_flags = flags;
 
 	return sd;
 
@@ -647,7 +656,7 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 	int rc;
 
 	/* allocate */
-	sd = sysfs_new_dirent(name, mode, SYSFS_DIR);
+	sd = sysfs_new_dirent(name, mode | SYSFS_COPY_NAME, SYSFS_DIR);
 	if (!sd)
 		return -ENOMEM;
 	sd->s_dir.kobj = kobj;
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index bf96bcd..982085c 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -82,7 +82,8 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 		goto out_put;
 
 	error = -ENOMEM;
-	sd = sysfs_new_dirent(name, S_IRWXUGO, SYSFS_KOBJ_LINK);
+	sd = sysfs_new_dirent(name, S_IRWXUGO | SYSFS_COPY_NAME,
+			      SYSFS_KOBJ_LINK);
 	if (!sd)
 		goto out_put;
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 9180e2c..db1a433 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -55,10 +55,10 @@ struct sysfs_dirent {
 #define SYSFS_KOBJ_ATTR			0x0002
 #define SYSFS_KOBJ_BIN_ATTR		0x0004
 #define SYSFS_KOBJ_LINK			0x0008
-#define SYSFS_COPY_NAME			(SYSFS_DIR | SYSFS_KOBJ_LINK)
 
 #define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
 #define SYSFS_FLAG_REMOVED		0x0200
+#define SYSFS_FLAG_NAME_COPIED		0x0400
 
 static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 {
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 38b73f9..5646e56 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -20,6 +20,16 @@
 
 struct vm_area_struct;
 
+/*
+ * @mode bits for sysfs_add_*() functions.  Only S_IALLUGO bits are
+ * valid as real mode bits.  Bits in S_IFMT are used to set sysfs
+ * specific flags.
+ */
+#define SYSFS_COPY_NAME		010000	/* copy passed @name */
+
+/* collection of all flags for verification */
+#define SYSFS_MODE_FLAGS	SYSFS_COPY_NAME
+
 #ifdef CONFIG_SYSFS
 
 int __must_check sysfs_init(void);
-- 
1.5.0.3


