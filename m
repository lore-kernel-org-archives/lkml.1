Return-Path: <linux-kernel-owner+w=401wt.eu-S1765331AbXIMFNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765331AbXIMFNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 01:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbXIMFM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 01:12:57 -0400
Received: from 70-56-219-218.albq.qwest.net ([70.56.219.218]:60780 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750940AbXIMFMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 01:12:55 -0400
X-Greylist: delayed 1603 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Sep 2007 01:12:55 EDT
Date: Wed, 12 Sep 2007 22:46:10 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
       ericvh@gmail.com
Subject: [PATCH] 9p: define session flags
Message-ID: <20070913044610.GA2675@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create more general flags field in the v9fs_session_info struct and move the
'extended' flag as a bit in the flags.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
commit 52f23404fd5bd77b619460e00930087463ec0cd9
tree 41c68f68a211796fb65d9c772120e7b7587dc945
parent ce1bfbeb6af28c96b990a95b7d7dde52c601fb8c
author Latchesar Ionkov <lucho@eregion.(none)> Wed, 12 Sep 2007 22:36:43 -0600
committer Latchesar Ionkov <lucho@eregion.(none)> Wed, 12 Sep 2007 22:36:43 -0600

 fs/9p/v9fs.c      |    6 +++---
 fs/9p/v9fs.h      |   12 +++++++++++-
 fs/9p/vfs_inode.c |   26 +++++++++++++-------------
 3 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 08d880f..8ac2467 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -128,7 +128,7 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)
 
 	/* setup defaults */
 	v9ses->maxdata = 8192;
-	v9ses->extended = 1;
+	v9ses->flags = V9FS_EXTENDED;
 	v9ses->afid = ~0;
 	v9ses->debug = 0;
 	v9ses->cache = 0;
@@ -178,7 +178,7 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)
 			match_strcpy(v9ses->remotename, &args[0]);
 			break;
 		case Opt_legacy:
-			v9ses->extended = 0;
+			v9ses->flags &= ~V9FS_EXTENDED;
 			break;
 		case Opt_nodevmap:
 			v9ses->nodev = 1;
@@ -244,7 +244,7 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 		v9ses->maxdata = v9ses->trans->maxsize-P9_IOHDRSZ;
 
 	v9ses->clnt = p9_client_create(trans, v9ses->maxdata+P9_IOHDRSZ,
-		v9ses->extended);
+		v9fs_extended(v9ses));
 
 	if (IS_ERR(v9ses->clnt)) {
 		retval = PTR_ERR(v9ses->clnt);
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 7eb135c..804b3ef 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -29,7 +29,7 @@
 struct v9fs_session_info {
 	/* options */
 	unsigned int maxdata;
-	unsigned char extended;	/* set to 1 if we are using UNIX extensions */
+	unsigned char flags;	/* session flags */
 	unsigned char nodev;	/* set to 1 if no disable device mapping */
 	unsigned short debug;	/* debug level */
 	unsigned int afid;	/* authentication fid */
@@ -45,6 +45,11 @@ struct v9fs_session_info {
 	struct dentry *debugfs_dir;
 };
 
+/* session flags */
+enum {
+	V9FS_EXTENDED,
+};
+
 /* possible values of ->cache */
 /* eventually support loose, tight, time, session, default always none */
 enum {
@@ -70,3 +75,8 @@ static inline struct v9fs_session_info *v9fs_inode2v9ses(struct inode *inode)
 {
 	return (inode->i_sb->s_fs_info);
 }
+
+static inline int v9fs_extended(struct v9fs_session_info *v9ses)
+{
+	return v9ses->flags & V9FS_EXTENDED;
+}
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index e5c45ee..2270d06 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -59,7 +59,7 @@ static int unixmode2p9mode(struct v9fs_session_info *v9ses, int mode)
 	res = mode & 0777;
 	if (S_ISDIR(mode))
 		res |= P9_DMDIR;
-	if (v9ses->extended) {
+	if (v9fs_extended(v9ses)) {
 		if (S_ISLNK(mode))
 			res |= P9_DMSYMLINK;
 		if (v9ses->nodev == 0) {
@@ -99,21 +99,21 @@ static int p9mode2unixmode(struct v9fs_session_info *v9ses, int mode)
 
 	if ((mode & P9_DMDIR) == P9_DMDIR)
 		res |= S_IFDIR;
-	else if ((mode & P9_DMSYMLINK) && (v9ses->extended))
+	else if ((mode & P9_DMSYMLINK) && (v9fs_extended(v9ses)))
 		res |= S_IFLNK;
-	else if ((mode & P9_DMSOCKET) && (v9ses->extended)
+	else if ((mode & P9_DMSOCKET) && (v9fs_extended(v9ses))
 		 && (v9ses->nodev == 0))
 		res |= S_IFSOCK;
-	else if ((mode & P9_DMNAMEDPIPE) && (v9ses->extended)
+	else if ((mode & P9_DMNAMEDPIPE) && (v9fs_extended(v9ses))
 		 && (v9ses->nodev == 0))
 		res |= S_IFIFO;
-	else if ((mode & P9_DMDEVICE) && (v9ses->extended)
+	else if ((mode & P9_DMDEVICE) && (v9fs_extended(v9ses))
 		 && (v9ses->nodev == 0))
 		res |= S_IFBLK;
 	else
 		res |= S_IFREG;
 
-	if (v9ses->extended) {
+	if (v9fs_extended(v9ses)) {
 		if ((mode & P9_DMSETUID) == P9_DMSETUID)
 			res |= S_ISUID;
 
@@ -214,7 +214,7 @@ struct inode *v9fs_get_inode(struct super_block *sb, int mode)
 		case S_IFBLK:
 		case S_IFCHR:
 		case S_IFSOCK:
-			if(!v9ses->extended) {
+			if (!v9fs_extended(v9ses)) {
 				P9_DPRINTK(P9_DEBUG_ERROR,
 				      "special files without extended mode\n");
 				return ERR_PTR(-EINVAL);
@@ -227,7 +227,7 @@ struct inode *v9fs_get_inode(struct super_block *sb, int mode)
 			inode->i_fop = &v9fs_file_operations;
 			break;
 		case S_IFLNK:
-			if(!v9ses->extended) {
+			if (!v9fs_extended(v9ses)) {
 				P9_DPRINTK(P9_DEBUG_ERROR,
 					"extended modes used w/o 9P2000.u\n");
 				return ERR_PTR(-EINVAL);
@@ -236,7 +236,7 @@ struct inode *v9fs_get_inode(struct super_block *sb, int mode)
 			break;
 		case S_IFDIR:
 			inc_nlink(inode);
-			if(v9ses->extended)
+			if (v9fs_extended(v9ses))
 				inode->i_op = &v9fs_dir_inode_operations_ext;
 			else
 				inode->i_op = &v9fs_dir_inode_operations;
@@ -768,7 +768,7 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	if (iattr->ia_valid & ATTR_SIZE)
 		wstat.length = iattr->ia_size;
 
-	if (v9ses->extended) {
+	if (v9fs_extended(v9ses)) {
 		if (iattr->ia_valid & ATTR_UID)
 			wstat.n_uid = iattr->ia_uid;
 
@@ -808,7 +808,7 @@ v9fs_stat2inode(struct p9_stat *stat, struct inode *inode,
 	inode->i_uid = v9ses->uid;
 	inode->i_gid = v9ses->gid;
 
-	if (v9ses->extended) {
+	if (v9fs_extended(v9ses)) {
 		inode->i_uid = stat->n_uid;
 		inode->i_gid = stat->n_gid;
 	}
@@ -890,7 +890,7 @@ static int v9fs_readlink(struct dentry *dentry, char *buffer, int buflen)
 	if(IS_ERR(fid))
 		return PTR_ERR(fid);
 
-	if (!v9ses->extended)
+	if (!v9fs_extended(v9ses))
 		return -EBADF;
 
 	st = p9_client_stat(fid);
@@ -1011,7 +1011,7 @@ static int v9fs_vfs_mkspecial(struct inode *dir, struct dentry *dentry,
 	struct p9_fid *fid;
 
 	v9ses = v9fs_inode2v9ses(dir);
-	if (!v9ses->extended) {
+	if (!v9fs_extended(v9ses)) {
 		P9_DPRINTK(P9_DEBUG_ERROR, "not extended\n");
 		return -EPERM;
 	}
