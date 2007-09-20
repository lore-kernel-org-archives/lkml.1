Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbXITIcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbXITIcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbXITIbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:31:49 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:51507 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbXITIbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:31:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=lQVV7xma6TGOUMNzEqgEU30nhOeDNtzie5bNXXmkAK3msoVrS4+JTw3i8m05SCEdJ/y5LDClqrSL7APj7q7Uu7s9spMPJEFTW4LXdO1s0IIKvGviiNliCZrZj2OSjeYO3xV7/Ajs2JZChqRAURVAO3YLBl5R/s2Y/ntdxYzl5m4=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 2/8] sysfs: add name formatting support for symlinks
In-Reply-To: <11902770971822-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:31:37 +0900
Message-Id: <1190277097938-git-send-email-htejun@gmail.com>
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

This patch implements sysfs name formatting.  sysfs_add_link() is
passed @name_fmt instead of @fmt.  In the format string only
"%[:alnum:]" and "%%" are handled specially.  "%0" is substitued with
the name of @target, "%3" with the name of the third ancestor of
@target, "%[aA]" the 10th and "%[zZ]" with 35th.  "%%" is substituted
with "%".

This formatting is mainly to make symlink renaming automatic such that
when the target or one of its ancestors gets renamed the symlink can
be renamed together automatically & atomically.  It also simplifies
sysfs creation a bit by allowing callers to use static format string
instead of formatting symlink name itself.

@name to kobject based sysfs_create_link() is not interpreted as
format string to keep backward compatibility.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c        |    3 +
 fs/sysfs/kobject.c    |    2 +-
 fs/sysfs/symlink.c    |  245 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/sysfs/sysfs.h      |    9 ++
 include/linux/sysfs.h |    6 +-
 5 files changed, 250 insertions(+), 15 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index d50d3ac..b042a2e 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -295,6 +295,9 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 		sysfs_put(sd->s_link.target);
 	if (sd->s_flags & SYSFS_FLAG_NAME_COPIED)
 		kfree(sd->s_name);
+	if (sd->s_flags & SYSFS_FLAG_LINK_NAME_FMT_COPIED)
+		kfree(sd->s_link.name_fmt);
+
 	kfree(sd->s_iattr);
 	sysfs_free_ino(sd->s_ino);
 	kmem_cache_free(sysfs_dir_cachep, sd);
diff --git a/fs/sysfs/kobject.c b/fs/sysfs/kobject.c
index 16e10de..7ea9186 100644
--- a/fs/sysfs/kobject.c
+++ b/fs/sysfs/kobject.c
@@ -425,7 +425,7 @@ int sysfs_create_link(struct kobject *kobj, struct kobject *target,
 	if (!target_sd)
 		return -ENOENT;
 
-	sd = sysfs_add_link(parent_sd, name, SYSFS_COPY_NAME, target_sd);
+	sd = __sysfs_add_link(parent_sd, name, SYSFS_COPY_NAME, target_sd, 0);
 
 	sysfs_put(target_sd);
 
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 42ecb69..296fef5 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/namei.h>
 #include <linux/mutex.h>
+#include <linux/ctype.h>
 
 #include "sysfs.h"
 
@@ -43,16 +44,162 @@ static void fill_object_path(struct sysfs_dirent *sd, char *buffer, int length)
 	}
 }
 
+size_t sysfs_format_link_name(const char *fmt, struct sysfs_dirent *target,
+			      char *buf, struct sysfs_dirent *renamed_sd,
+			      struct sysfs_dirent *new_parent,
+			      const char *new_name)
+{
+	char *dst = buf;
+	int cnt = 0;
+
+	while (*fmt != '\0') {
+		char ch = *fmt++, next = *fmt;
+		struct sysfs_dirent *tsd;
+		const char *tname;
+		int level;
+		size_t len;
+
+		if (ch != '%' || !isalnum(next)) {
+			if (dst)
+				*dst++ = ch;
+			cnt++;
+			/* %% is % */
+			if (ch== '%' && next == '%')
+				fmt++;
+			continue;
+		}
+
+		/* Seen %[:alnum:].  %0 is the target's name.  %z is
+		 * the name of the 35th ancestor of the target.
+		 */
+		fmt++;
+		if (isdigit(next))
+			level = next - '0';
+		else
+			level = tolower(next) - 'a' + 10;
+
+		/* Work up level times and use its name.  It's a bit
+		 * complicated due to the renamed node handling.
+		 */
+		tsd = target;
+		while (level && tsd->s_parent) {
+			if (tsd == renamed_sd)
+				tsd = new_parent;
+			else
+				tsd = tsd->s_parent;
+			level--;
+		}
+		WARN_ON(level);
+
+		tname = tsd->s_name;
+		if (tsd == renamed_sd)
+			tname = new_name;
+
+		/* got the name, copy it */
+		len = strlen(tname);
+		if (dst) {
+			memcpy(dst, tname, len);
+			dst += len;
+		}
+		cnt += len;
+	}
+
+	if (dst)
+		*dst = '\0';
+	return cnt;
+}
+
 /**
- *	sysfs_add_link - add a new sysfs symlink
+ *	sysfs_link_name - format the name of symlink
+ *	@fmt: format string
+ *	@target: target sysfs_dirent the symlink points to
+ *	@link_name: out parameter for the formatted string
+ *	@renamed_sd: renamed sysfs_dirent (can be NULL)
+ *	@new_parent: new parent of @renamed_sd (NULL if !@renamed_sd)
+ *	@new_name: new name of @renamed_sd (NULL if !@renamed_sd)
+ *
+ *	Format the name of the symlink according to @fmt and given
+ *	parameters.
+ *
+ *	%[:alnum:] has special meaning in the format string.  %0 is
+ *	substituted with the target's name.  %1 is the parent, %2 the
+ *	parent's parent, %9 the 9th ancestor, %a or %A the 10th
+ *	ancestor and so on upto %z or %Z which is substitued with the
+ *	name of the 35th ancestor.  %% is substituted with %. All
+ *	other sequences are copied verbatim.
+ *
+ *	@renamed_sd is used to override the specified sd's parent and
+ *	name.  If a sd which matches @renamed_sd is in the path
+ *	between sysfs_root and @sd, @new_parent is used instead of
+ *	sd->s_parent and @new_name is used instead of sd->s_name.
+ *	This is used to format new symlink name while preparing to
+ *	rename the target or one of the ancestors of it.
+ *
+ *	LOCKING:
+ *	mutex_lock(sysfs_op_mutex)
+ *
+ *	RETURNS:
+ *	1 if success and the buffer *@link_name points to needs to be
+ *	freed later.  0 if success and *@link_name points to @fmt
+ *	directly.  -errno on failure.
+ */
+int sysfs_link_name(const char *fmt, struct sysfs_dirent *target,
+		    const char **link_name, struct sysfs_dirent *renamed_sd,
+		    struct sysfs_dirent *new_parent, const char *new_name)
+{
+	size_t len;
+	char *buf;
+
+	/* nothing to format? */
+	if (!strchr(fmt, '%')) {
+		*link_name = fmt;
+		return 0;
+	}
+
+	/* determine length and allocate space for the formatted string */
+	len = sysfs_format_link_name(fmt, target, NULL,
+				     renamed_sd, new_parent, new_name);
+	buf = kmalloc(len + 1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	/* format it */
+	sysfs_format_link_name(fmt, target, buf,
+			       renamed_sd, new_parent, new_name);
+	*link_name = buf;
+	return 1;
+}
+
+/**
+ *	__sysfs_add_link - add a new sysfs symlink
  *	@parent: sysfs_dirent to add symlink under
- *	@name: name of the symlink
+ *	@name_fmt: format string for the name of the symlink
  *	@mode: SYSFS_* flags for the new symlink
  *	@target: target of the symlink
+ *	@format: whether format symlink name or not
  *
  *	Add a new symlink which points to @target under @parent with
  *	the specified parameters.
  *
+ *	If @format is not zero, @name_fmt is interpreted as format
+ *	string and the symlink name will be formatted accordingly.
+ *	Also, the symlink will be chained into the links list of the
+ *	@target and will be renamed automatically when the @target is
+ *	renamed or moved.
+ *
+ *	If @format is zero, @name_fmt is taken as verbatim name of the
+ *	symlink and won't be renamed automatically no matter what
+ *	happens to the @target.
+ *
+ *	SYSFS_COPY_NAME always specifies that the string @name_fmt
+ *	points to should be copied whether it's interpreted as format
+ *	string or not.
+ *
+ *	This is an internal function to be used to implement
+ *	sysfs_add_link() and sysfs_create_link().  @format is
+ *	necessary to support the original sysfs_create_link()
+ *	semantics where the symlink name is specified verbatim.
+ *
  *	LOCKING:
  *	Kernel thread context (may sleep).
  *
@@ -60,27 +207,103 @@ static void fill_object_path(struct sysfs_dirent *sd, char *buffer, int length)
  *	Pointer to the new sysfs_dirent on success, ERR_PTR() value on
  *	error.
  */
-struct sysfs_dirent *sysfs_add_link(struct sysfs_dirent *parent,
-				    const char *name, mode_t mode,
-				    struct sysfs_dirent *target)
+struct sysfs_dirent *__sysfs_add_link(struct sysfs_dirent *parent,
+				      const char *name_fmt, mode_t mode,
+				      struct sysfs_dirent *target, int format)
 {
-	struct sysfs_dirent *sd;
+	struct sysfs_dirent *sd = NULL;
+	unsigned int flags = 0;
+	const char *name;
+	struct sysfs_addrm_cxt acxt;
+	int rc;
+
+	/* acquire locks early for link name formatting */
+	sysfs_addrm_start(&acxt);
 
 	/* Only symlink to directories are allowed.  This is an
-	 * artificial limitation.  If ever needed, allowing symlinks
-	 * to point to other types of sysfs nodes isn't difficult.
+	 * artificial limitation mainly to reduce the size of
+	 * sysfs_dirent by putting the links head into s_dir union
+	 * member.  If ever needed, allowing symlinks to point to
+	 * other types of sysfs nodes isn't difficult.
 	 */
+	rc = -EINVAL;
 	if (sysfs_type(target) != SYSFS_DIR)
-		return ERR_PTR(-EINVAL);
+		goto err;
+
+	if (format) {
+		/* SYSFS_COPY_NAME means 'copy the format string' */
+		rc = -ENOMEM;
+		if (mode & SYSFS_COPY_NAME) {
+			name_fmt = kstrdup(name_fmt, GFP_KERNEL);
+			if (!name_fmt)
+				goto err;
+			mode &= ~SYSFS_COPY_NAME;
+			flags |= SYSFS_FLAG_LINK_NAME_FMT_COPIED;
+		}
+
+		/* format name */
+		rc = sysfs_link_name(name_fmt, target, &name, NULL, NULL, NULL);
+		if (rc < 0)
+			goto err;
+		/* set NAME_COPIED if name has been allocated and formatted */
+		if (rc)
+			flags |= SYSFS_FLAG_NAME_COPIED;
+	} else
+		name = name_fmt;
 
 	/* allocate & initialize */
+	rc = -ENOMEM;
 	sd = sysfs_new_dirent(name, mode | S_IRWXUGO, SYSFS_LINK);
 	if (!sd)
-		return ERR_PTR(-ENOMEM);
+		goto err;
 
+	sd->s_flags |= flags;
+	sd->s_link.name_fmt = name_fmt;
 	sd->s_link.target = sysfs_get(target);
 
-	return sysfs_insert_one(parent, sd);
+	/* add the new node */
+	rc = sysfs_add_one(&acxt, parent, sd);
+	if (rc) {
+		sysfs_put(sd);	/* target is put when sd is released */
+		goto err;
+	}
+
+	sysfs_addrm_finish(&acxt);
+	return sd;
+
+ err:
+	sysfs_addrm_finish(&acxt);
+	if (flags & SYSFS_FLAG_LINK_NAME_FMT_COPIED)
+		kfree(name_fmt);
+	if (flags & SYSFS_FLAG_NAME_COPIED)
+		kfree(name);
+	return ERR_PTR(rc);
+}
+
+/**
+ *	sysfs_add_link - add a new sysfs symlink
+ *	@parent: sysfs_dirent to add symlink under
+ *	@name_fmt: format string for the name of the symlink
+ *	@mode: SYSFS_* flags for the new symlink
+ *	@target: target of the symlink
+ *
+ *	Add a new symlink which points to @target under @parent with
+ *	the specified parameters.  @name_fmt is always interpreted as
+ *	format string for symlink name.  See __sysfs_add_link() for
+ *	details.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	Pointer to the new sysfs_dirent on success, ERR_PTR() value on
+ *	error.
+ */
+struct sysfs_dirent *sysfs_add_link(struct sysfs_dirent *parent,
+				    const char *name, mode_t mode,
+				    struct sysfs_dirent *target)
+{
+	return __sysfs_add_link(parent, name, mode, target, 1);
 }
 EXPORT_SYMBOL_GPL(sysfs_add_link);
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 732b292..9167032 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -9,6 +9,7 @@ struct sysfs_elem_dir {
 
 struct sysfs_elem_link {
 	struct sysfs_dirent	*target;
+	const char		*name_fmt;
 };
 
 struct sysfs_elem_file {
@@ -62,6 +63,7 @@ struct sysfs_dirent {
 #define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
 #define SYSFS_FLAG_REMOVED		0x0200
 #define SYSFS_FLAG_NAME_COPIED		0x0400
+#define SYSFS_FLAG_LINK_NAME_FMT_COPIED	0x0800
 
 static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 {
@@ -152,4 +154,11 @@ extern const struct file_operations sysfs_bin_file_operations;
 /*
  * symlink.c
  */
+struct sysfs_dirent *__sysfs_add_link(struct sysfs_dirent *parent,
+				      const char *name, mode_t mode,
+				      struct sysfs_dirent *target, int format);
+int sysfs_link_name(const char *fmt, struct sysfs_dirent *target,
+		    const char **link_name, struct sysfs_dirent *renamed_sd,
+		    struct sysfs_dirent *new_parent, const char *new_name);
+
 extern const struct inode_operations sysfs_link_inode_operations;
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index f0279a7..5afe3bd 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -29,7 +29,7 @@ struct vm_area_struct;
  * specific flags.
  */
 #define SYSFS_DIR_MODE		(S_IRWXU | S_IRUGO | S_IXUGO)
-#define SYSFS_COPY_NAME		010000	/* copy passed @name */
+#define SYSFS_COPY_NAME		010000	/* copy passed @name[_fmt] */
 
 /* collection of all flags for verification */
 #define SYSFS_MODE_FLAGS	SYSFS_COPY_NAME
@@ -61,7 +61,7 @@ struct sysfs_dirent *sysfs_add_bin(struct sysfs_dirent *parent,
 			const char *name, mode_t mode, size_t size,
 			const struct sysfs_bin_ops *bops, void *data);
 struct sysfs_dirent *sysfs_add_link(struct sysfs_dirent *parent,
-			const char *name, mode_t mode,
+			const char *name_fmt, mode_t mode,
 			struct sysfs_dirent *target);
 
 struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
@@ -100,7 +100,7 @@ static inline struct sysfs_dirent *sysfs_add_bin(struct sysfs_dirent *parent,
 }
 
 static inline struct sysfs_dirent *sysfs_add_link(struct sysfs_dirent *parent,
-			const char *name, mode_t mode,
+			const char *name_fmt, mode_t mode,
 			struct sysfs_dirent *target)
 {
 	return NULL;
-- 
1.5.0.3


