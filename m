Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0BAWZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:25:15 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57954 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab0BAWZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:25:13 -0500
Date: Mon, 1 Feb 2010 22:25:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH][RFC] %pd - for printing dentry name
Message-ID: <20100201222511.GA12882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	There's a lot of places doing printks with ->d_name of various
dentries.  Unfortunately, as often as not they are b0rken due to races
with rename().

	I propose to add a new format - %pd.  It would print dentry name.
However, unlike everything else in vsnprintf, it would NOT be locking-agnostic.
It would grab and release dentry->d_lock.  And yes, I hate that as much as
anyone.  I don't see any sane alternative.

	Patch below implements it and fixes some obvious races in ocfs2
and ubifs by switch to that sucker.  There are many more places of
that kind and a _lot_ of those are racy.  Adding ->d_lock in every caller
is not a good solution, IMO...

	Rules are:
* don't use %pd under dentry->d_lock, use dentry->d_name.name instead; in
that case it *is* safe.  Incidentally, ->d_lock isn't held a lot.
* if we don't hold dentry->d_lock, feel free to use %pd....,dentry

	Comments?

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 06ccf6a..64769c6 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -104,8 +104,7 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
 	int mode = file->f_flags;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
-	mlog_entry("(0x%p, 0x%p, '%.*s')\n", inode, file,
-		   file->f_path.dentry->d_name.len, file->f_path.dentry->d_name.name);
+	mlog_entry("(0x%p, 0x%p, '%pd')\n", inode, file, file->f_path.dentry);
 
 	spin_lock(&oi->ip_lock);
 
@@ -145,9 +144,7 @@ static int ocfs2_file_release(struct inode *inode, struct file *file)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
-	mlog_entry("(0x%p, 0x%p, '%.*s')\n", inode, file,
-		       file->f_path.dentry->d_name.len,
-		       file->f_path.dentry->d_name.name);
+	mlog_entry("(0x%p, 0x%p, '%pd')\n", inode, file, file->f_path.dentry);
 
 	spin_lock(&oi->ip_lock);
 	if (!--oi->ip_open_count)
@@ -181,8 +178,7 @@ static int ocfs2_sync_file(struct file *file,
 	struct inode *inode = dentry->d_inode;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	mlog_entry("(0x%p, 0x%p, %d, '%.*s')\n", file, dentry, datasync,
-		   dentry->d_name.len, dentry->d_name.name);
+	mlog_entry("(0x%p, 0x%p, '%pd')\n", inode, file, file->f_path.dentry);
 
 	err = ocfs2_sync_inode(dentry->d_inode);
 	if (err)
@@ -947,8 +943,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	struct dquot *transfer_from[MAXQUOTAS] = { };
 	struct dquot *transfer_to[MAXQUOTAS] = { };
 
-	mlog_entry("(0x%p, '%.*s')\n", dentry,
-	           dentry->d_name.len, dentry->d_name.name);
+	mlog_entry("(0x%p, '%pd')\n", dentry, dentry);
 
 	/* ensuring we don't even attempt to truncate a symlink */
 	if (S_ISLNK(inode->i_mode))
@@ -1916,10 +1911,9 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	mlog_entry("(0x%p, %u, '%.*s')\n", file,
+	mlog_entry("(0x%p, %u, '%pd')\n", file,
 		   (unsigned int)nr_segs,
-		   file->f_path.dentry->d_name.len,
-		   file->f_path.dentry->d_name.name);
+		   file->f_path.dentry);
 
 	if (iocb->ki_left == 0)
 		return 0;
@@ -2096,10 +2090,9 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 		.u.file = out,
 	};
 
-	mlog_entry("(0x%p, 0x%p, %u, '%.*s')\n", out, pipe,
+	mlog_entry("(0x%p, 0x%p, %u, '%pd')\n", out, pipe,
 		   (unsigned int)len,
-		   out->f_path.dentry->d_name.len,
-		   out->f_path.dentry->d_name.name);
+		   out->f_path.dentry);
 
 	if (pipe->inode)
 		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_PARENT);
@@ -2156,10 +2149,9 @@ static ssize_t ocfs2_file_splice_read(struct file *in,
 	int ret = 0, lock_level = 0;
 	struct inode *inode = in->f_path.dentry->d_inode;
 
-	mlog_entry("(0x%p, 0x%p, %u, '%.*s')\n", in, pipe,
+	mlog_entry("(0x%p, 0x%p, %u, '%pd')\n", in, pipe,
 		   (unsigned int)len,
-		   in->f_path.dentry->d_name.len,
-		   in->f_path.dentry->d_name.name);
+		   in->f_path.dentry);
 
 	/*
 	 * See the comment in ocfs2_file_aio_read()
@@ -2187,10 +2179,9 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	struct file *filp = iocb->ki_filp;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 
-	mlog_entry("(0x%p, %u, '%.*s')\n", filp,
+	mlog_entry("(0x%p, %u, '%pd')\n", filp,
 		   (unsigned int)nr_segs,
-		   filp->f_path.dentry->d_name.len,
-		   filp->f_path.dentry->d_name.name);
+		   filp->f_path.dentry);
 
 	if (!inode) {
 		ret = -EINVAL;
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index 195830f..fac5dbc 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -304,8 +304,8 @@ int ubifs_setxattr(struct dentry *dentry, const char *name,
 	union ubifs_key key;
 	int err, type;
 
-	dbg_gen("xattr '%s', host ino %lu ('%.*s'), size %zd", name,
-		host->i_ino, dentry->d_name.len, dentry->d_name.name, size);
+	dbg_gen("xattr '%s', host ino %lu ('%pd'), size %zd", name,
+		host->i_ino, dentry, size);
 	ubifs_assert(mutex_is_locked(&host->i_mutex));
 
 	if (size > UBIFS_MAX_INO_DATA)
@@ -368,8 +368,8 @@ ssize_t ubifs_getxattr(struct dentry *dentry, const char *name, void *buf,
 	union ubifs_key key;
 	int err;
 
-	dbg_gen("xattr '%s', ino %lu ('%.*s'), buf size %zd", name,
-		host->i_ino, dentry->d_name.len, dentry->d_name.name, size);
+	dbg_gen("xattr '%s', ino %lu ('%pd'), buf size %zd", name,
+		host->i_ino, dentry, dentry, size);
 
 	err = check_namespace(&nm);
 	if (err < 0)
@@ -427,8 +427,8 @@ ssize_t ubifs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 	int err, len, written = 0;
 	struct qstr nm = { .name = NULL };
 
-	dbg_gen("ino %lu ('%.*s'), buffer size %zd", host->i_ino,
-		dentry->d_name.len, dentry->d_name.name, size);
+	dbg_gen("ino %lu ('%pd'), buffer size %zd", host->i_ino,
+		dentry, size);
 
 	len = host_ui->xattr_names + host_ui->xattr_cnt;
 	if (!buffer)
@@ -530,8 +530,7 @@ int ubifs_removexattr(struct dentry *dentry, const char *name)
 	union ubifs_key key;
 	int err;
 
-	dbg_gen("xattr '%s', ino %lu ('%.*s')", name,
-		host->i_ino, dentry->d_name.len, dentry->d_name.name);
+	dbg_gen("xattr '%s', ino %lu ('%pd')", name, host->i_ino, dentry);
 	ubifs_assert(mutex_is_locked(&host->i_mutex));
 
 	err = check_namespace(&nm);
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3b8aeec..52a09dc 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -880,6 +880,18 @@ static char *uuid_string(char *buf, char *end, const u8 *addr,
 	return string(buf, end, uuid, spec);
 }
 
+static char *dname_string(char *buf, char *end, struct dentry *d,
+			 struct printf_spec spec)
+{
+	char *res;
+	spin_lock(&d->d_lock);
+	if (spec.precision > d->d_name.len)
+		spec.precision = d->d_name.len;
+	res = string(buf, end, d->d_name.name, spec);
+	spin_unlock(&d->d_lock);
+	return res;
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -915,6 +927,8 @@ static char *uuid_string(char *buf, char *end, const u8 *addr,
  *             [0][1][2][3]-[4][5]-[6][7]-[8][9]-[10][11][12][13][14][15]
  *           little endian output byte order is:
  *             [3][2][1][0]-[5][4]-[7][6]-[8][9]-[10][11][12][13][14][15]
+ * - 'd' For dentry name.  NOTE: don't use under dentry->d_lock, there
+ *       you can safely use ->d_name.name instead.
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -958,6 +972,8 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		break;
 	case 'U':
 		return uuid_string(buf, end, ptr, spec, fmt);
+	case 'd':
+		return dname_string(buf, end, ptr, spec);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
@@ -1191,6 +1207,7 @@ qualifier:
  *   http://tools.ietf.org/html/draft-ietf-6man-text-addr-representation-00
  * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
  *   case.
+ * %pd print dentry name
  * %n is ignored
  *
  * The return value is the number of characters which would
