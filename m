Return-Path: <linux-kernel-owner+w=401wt.eu-S1760654AbXKBRKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760654AbXKBRKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760122AbXKBRKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:10:09 -0400
Received: from 71-33-33-68.albq.qwest.net ([71.33.33.68]:45760 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759325AbXKBRJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:09:58 -0400
Date: Fri, 2 Nov 2007 11:09:56 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] 9p: marshalling to/from scatter list
Message-ID: <20071102170956.GK16063@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In order to achieve zero-copy of the data in the 9P client and server
code, the marshalling code needs to be modified to serialize/deserialize to
a scatterlist instead of continuous memory block.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
 fs/9p/v9fs_vfs.h        |    2 +-
 fs/9p/vfs_dir.c         |    8 +-
 fs/9p/vfs_inode.c       |   32 +-
 fs/9p/vfs_super.c       |    2 +-
 include/net/9p/9p.h     |   65 ++--
 include/net/9p/client.h |    8 +-
 net/9p/client.c         |  122 ++++---
 net/9p/conv.c           | 1048 ++++++++++++++++++++++++++++++++++------------
 net/9p/fcprint.c        |  116 +++---
 net/9p/ramfs/ramfs.c    |   28 +-
 net/9p/srv.c            |   18 +-
 11 files changed, 992 insertions(+), 457 deletions(-)

diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index fd01d90..f2681fb 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -46,7 +46,7 @@ extern struct dentry_operations v9fs_cached_dentry_operations;
 
 struct inode *v9fs_get_inode(struct super_block *sb, int mode);
 ino_t v9fs_qid2ino(struct p9_qid *qid);
-void v9fs_stat2inode(struct p9_stat *, struct inode *, struct super_block *);
+void v9fs_stat2inode(struct p9_wstat *, struct inode *, struct super_block *);
 int v9fs_dir_release(struct inode *inode, struct file *filp);
 int v9fs_file_open(struct inode *inode, struct file *file);
 void v9fs_inode2stat(struct inode *inode, struct p9_stat *stat);
diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 0924d44..6c87fcb 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -45,7 +45,7 @@
  *
  */
 
-static inline int dt_type(struct p9_stat *mistat)
+static inline int dt_type(struct p9_wstat *mistat)
 {
 	unsigned long perm = mistat->mode;
 	int rettype = DT_REG;
@@ -72,7 +72,7 @@ static int v9fs_dir_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	struct p9_fid *fid;
 	struct v9fs_session_info *v9ses;
 	struct inode *inode;
-	struct p9_stat *st;
+	struct p9_wstat *st;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "name %s\n", filp->f_path.dentry->d_name.name);
 	inode = filp->f_path.dentry->d_inode;
@@ -82,13 +82,13 @@ static int v9fs_dir_readdir(struct file *filp, void *dirent, filldir_t filldir)
 		if (IS_ERR(st))
 			return PTR_ERR(st);
 
-		over = filldir(dirent, st->name.str, st->name.len, filp->f_pos,
+		over = filldir(dirent, st->name, strlen(st->name), filp->f_pos,
 			v9fs_qid2ino(&st->qid), dt_type(st));
 
 		if (over)
 			break;
 
-		filp->f_pos += st->size;
+		filp->f_pos += st->size + 2;
 		kfree(st);
 		st = NULL;
 	}
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 23581bc..44e5a5f 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -313,7 +313,7 @@ v9fs_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
 {
 	int err, umode;
 	struct inode *ret;
-	struct p9_stat *st;
+	struct p9_wstat *st;
 
 	ret = NULL;
 	st = p9_client_stat(fid);
@@ -711,7 +711,7 @@ v9fs_vfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	int err;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid;
-	struct p9_stat *st;
+	struct p9_wstat *st;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "dentry: %p\n", dentry);
 	err = -EPERM;
@@ -792,11 +792,9 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
  */
 
 void
-v9fs_stat2inode(struct p9_stat *stat, struct inode *inode,
+v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 	struct super_block *sb)
 {
-	int n;
-	char ext[32];
 	struct v9fs_session_info *v9ses = sb->s_fs_info;
 
 	inode->i_nlink = 1;
@@ -819,12 +817,7 @@ v9fs_stat2inode(struct p9_stat *stat, struct inode *inode,
 		int major = -1;
 		int minor = -1;
 
-		n = stat->extension.len;
-		if (n > sizeof(ext)-1)
-			n = sizeof(ext)-1;
-		memmove(ext, stat->extension.str, n);
-		ext[n] = 0;
-		sscanf(ext, "%c %u %u", &type, &major, &minor);
+		sscanf(stat->extension, "%c %u %u", &type, &major, &minor);
 		switch (type) {
 		case 'c':
 			inode->i_mode &= ~S_IFBLK;
@@ -834,8 +827,8 @@ v9fs_stat2inode(struct p9_stat *stat, struct inode *inode,
 			break;
 		default:
 			P9_DPRINTK(P9_DEBUG_ERROR,
-				"Unknown special type %c (%.*s)\n", type,
-				stat->extension.len, stat->extension.str);
+				"Unknown special type %c (%s)\n", type,
+				stat->extension);
 		};
 		inode->i_rdev = MKDEV(major, minor);
 	} else
@@ -881,7 +874,7 @@ static int v9fs_readlink(struct dentry *dentry, char *buffer, int buflen)
 
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid;
-	struct p9_stat *st;
+	struct p9_wstat *st;
 
 	P9_DPRINTK(P9_DEBUG_VFS, " %s\n", dentry->d_name.name);
 	retval = -EPERM;
@@ -903,17 +896,12 @@ static int v9fs_readlink(struct dentry *dentry, char *buffer, int buflen)
 	}
 
 	/* copy extension buffer into buffer */
-	if (st->extension.len < buflen)
-		buflen = st->extension.len + 1;
-
-	memmove(buffer, st->extension.str, buflen - 1);
-	buffer[buflen-1] = 0;
+	strncpy(buffer, st->extension, buflen);
 
 	P9_DPRINTK(P9_DEBUG_VFS,
-		"%s -> %.*s (%s)\n", dentry->d_name.name, st->extension.len,
-		st->extension.str, buffer);
+		"%s -> %s (%s)\n", dentry->d_name.name, st->extension, buffer);
 
-	retval = buflen;
+	retval = strlen(buffer);
 
 done:
 	kfree(st);
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index bb0cef9..2f85f20 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -110,7 +110,7 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
 	struct inode *inode = NULL;
 	struct dentry *root = NULL;
 	struct v9fs_session_info *v9ses = NULL;
-	struct p9_stat *st = NULL;
+	struct p9_wstat *st = NULL;
 	int mode = S_IRWXUGO | S_ISVTX;
 	uid_t uid = current->fsuid;
 	gid_t gid = current->fsgid;
diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index a913cdb..1b76952 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -148,9 +148,11 @@ enum {
 /* ample room for Twrite/Rread header */
 #define P9_IOHDRSZ	24
 
-struct p9_str {
-	u16 len;
-	char *str;
+struct p9_data {
+	int sglen;
+	struct scatterlist *sg;
+	int offset;     /* offset from the first element in sg */
+	int length;
 };
 
 /* qids are the unique ID for a file (like an inode */
@@ -170,11 +172,11 @@ struct p9_stat {
 	u32 atime;
 	u32 mtime;
 	u64 length;
-	struct p9_str name;
-	struct p9_str uid;
-	struct p9_str gid;
-	struct p9_str muid;
-	struct p9_str extension;	/* 9p2000.u extensions */
+	struct p9_data name;
+	struct p9_data uid;
+	struct p9_data gid;
+	struct p9_data muid;
+	struct p9_data extension;	/* 9p2000.u extensions */
 	u32 n_uid;			/* 9p2000.u extensions */
 	u32 n_gid;			/* 9p2000.u extensions */
 	u32 n_muid;			/* 9p2000.u extensions */
@@ -206,18 +208,18 @@ struct p9_wstat {
 /* Structures for Protocol Operations */
 struct p9_tversion {
 	u32 msize;
-	struct p9_str version;
+	struct p9_data version;
 };
 
 struct p9_rversion {
 	u32 msize;
-	struct p9_str version;
+	struct p9_data version;
 };
 
 struct p9_tauth {
 	u32 afid;
-	struct p9_str uname;
-	struct p9_str aname;
+	struct p9_data uname;
+	struct p9_data aname;
 	u32 n_uname;		/* 9P2000.u extensions */
 };
 
@@ -226,7 +228,7 @@ struct p9_rauth {
 };
 
 struct p9_rerror {
-	struct p9_str error;
+	struct p9_data error;
 	u32 errno;		/* 9p2000.u extension */
 };
 
@@ -240,8 +242,8 @@ struct p9_rflush {
 struct p9_tattach {
 	u32 fid;
 	u32 afid;
-	struct p9_str uname;
-	struct p9_str aname;
+	struct p9_data uname;
+	struct p9_data aname;
 	u32 n_uname;		/* 9P2000.u extensions */
 };
 
@@ -253,7 +255,7 @@ struct p9_twalk {
 	u32 fid;
 	u32 newfid;
 	u16 nwname;
-	struct p9_str wnames[16];
+	struct p9_data wnames[16];
 };
 
 struct p9_rwalk {
@@ -273,10 +275,10 @@ struct p9_ropen {
 
 struct p9_tcreate {
 	u32 fid;
-	struct p9_str name;
+	struct p9_data name;
 	u32 perm;
 	u8 mode;
-	struct p9_str extension;
+	struct p9_data extension;
 };
 
 struct p9_rcreate {
@@ -292,14 +294,14 @@ struct p9_tread {
 
 struct p9_rread {
 	u32 count;
-	u8 *data;
+	struct p9_data data;
 };
 
 struct p9_twrite {
 	u32 fid;
 	u64 offset;
 	u32 count;
-	u8 *data;
+	struct p9_data data;
 };
 
 struct p9_rwrite {
@@ -345,7 +347,10 @@ struct p9_fcall {
 	u32 size;
 	u8 id;
 	u16 tag;
-	void *sdata;
+	/* The scatterlist contains the content of the message in
+	the wire format. */
+	int sglen;
+	struct scatterlist *sg;
 
 	union {
 		struct p9_tversion tversion;
@@ -381,8 +386,16 @@ struct p9_fcall {
 struct p9_idpool;
 extern struct kset p9_subsys;
 
-int p9_serialize_stat(struct p9_wstat *wstat, u8 *buf, int buflen, int dotu);
-int p9_deserialize_stat(void *buf, u32 buflen, struct p9_stat *stat,
+int p9_strncpy(char *dst, int dstlen, struct p9_data *str);
+int p9_strcpy(char *dst, struct p9_data *str);
+char *p9_strdup(struct p9_data *str);
+int p9_data_get(char *dst, int dstlen, struct p9_data *data);
+int p9_user_data_get(char __user *dst, int dstlen, struct p9_data *data);
+int p9_data_put(struct p9_data *data, char *dst, int dstlen);
+int p9_user_data_put(struct p9_data *data, char *dst, int dstlen);
+
+int p9_serialize_stat(struct p9_wstat *wstat, struct p9_data *buf, int dotu);
+struct p9_wstat *p9_deserialize_stat(struct p9_data *data, u32 offset,
 	int dotu);
 int p9_deserialize_fcall(struct p9_fcall *fc, int dotu);
 void p9_set_tag(struct p9_fcall *fc, u16 tag);
@@ -401,10 +414,11 @@ struct p9_fcall *p9_create_topen(u32 fid, u8 mode);
 struct p9_fcall *p9_create_tcreate(u32 fid, char *name, u32 perm, u8 mode,
 	char *extension, int dotu);
 struct p9_fcall *p9_create_tread(u32 fid, u64 offset, u32 count);
-struct p9_fcall *p9_create_twrite(u32 fid, u64 offset, u32 count,
-	const char *data);
+struct p9_fcall *p9_create_twrite(u32 fid, u64 offset, u32 count, char *data);
 struct p9_fcall *p9_create_twrite_u(u32 fid, u64 offset, u32 count,
 	const char __user *data);
+struct p9_fcall *p9_create_twrite_sg(u32 fid, u64 offset, u32 count,
+	int sglen, struct scatterlist *sg);
 struct p9_fcall *p9_create_tclunk(u32 fid);
 struct p9_fcall *p9_create_tremove(u32 fid);
 struct p9_fcall *p9_create_tstat(u32 fid);
@@ -419,6 +433,7 @@ int p9_create_rwalk(struct p9_fcall *, int nwqid, struct p9_qid *wqids);
 int p9_create_ropen(struct p9_fcall *, struct p9_qid *qid, u32 iounit);
 int p9_create_rcreate(struct p9_fcall *, struct p9_qid *qid, u32 iounit);
 int p9_init_rread(struct p9_fcall *fc);
+struct p9_fcall *p9_alloc_rread_sg(struct scatterlist *sg, u32 sglen);
 void p9_set_rread_count(struct p9_fcall *fc, u32 count);
 int p9_create_rwrite(struct p9_fcall *, u32 count);
 int p9_create_rclunk(struct p9_fcall *);
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 5efb57a..343ccbf 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -74,9 +74,13 @@ int p9_client_uread(struct p9_fid *fid, char __user *data, u64 offset,
 								u32 count);
 int p9_client_uwrite(struct p9_fid *fid, const char __user *data, u64 offset,
 								u32 count);
-struct p9_stat *p9_client_stat(struct p9_fid *fid);
+int p9_client_read_sg(struct p9_fid *fid, u64 offset, u32 count,
+	struct scatterlist *sg, int sglen);
+int p9_client_write_sg(struct p9_fid *fid, u64 offset, u32 count,
+	struct scatterlist *sg, int sglen);
+struct p9_wstat *p9_client_stat(struct p9_fid *fid);
 int p9_client_wstat(struct p9_fid *fid, struct p9_wstat *wst);
-struct p9_stat *p9_client_dirread(struct p9_fid *fid, u64 offset);
+struct p9_wstat *p9_client_dirread(struct p9_fid *fid, u64 offset);
 
 void p9_client_req_incref(struct p9_trans_req *req);
 void p9_client_req_decref(struct p9_trans_req *req);
diff --git a/net/9p/client.c b/net/9p/client.c
index 63d266d..93a0102 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -52,15 +52,15 @@ enum {
 
 static struct p9_fid *p9_fid_create(struct p9_client *clnt);
 static void p9_fid_destroy(struct p9_fid *fid);
-static struct p9_stat *p9_clone_stat(struct p9_stat *st, int dotu);
+static struct p9_wstat *p9_clone_wstat(struct p9_stat *st, int dotu);
 
 struct p9_client *p9_client_create(struct p9_trans *trans, int msize,
 								   int dotu)
 {
 	int err, n;
+	char ver[10];
 	struct p9_client *clnt;
 	struct p9_fcall *tc, *rc;
-	struct p9_str *version;
 
 	err = 0;
 	tc = NULL;
@@ -104,10 +104,10 @@ struct p9_client *p9_client_create(struct p9_trans *trans, int msize,
 	if (err)
 		goto error;
 
-	version = &rc->params.rversion.version;
-	if (version->len == 8 && !memcmp(version->str, "9P2000.u", 8))
+	p9_strncpy(ver, sizeof(ver), &rc->params.rversion.version);
+	if (!strcmp(ver, "9P2000.u"))
 		clnt->dotu = 1;
-	else if (version->len == 6 && !memcmp(version->str, "9P2000", 6))
+	else if (!strcmp(ver, "9P2000"))
 		clnt->dotu = 0;
 	else {
 		err = -EREMOTEIO;
@@ -510,7 +510,10 @@ int p9_client_read(struct p9_fid *fid, char *data, u64 offset, u32 count)
 		if (n > count)
 			n = count;
 
-		memmove(data, rc->params.rread.data, n);
+		err = p9_data_get(data, n, &rc->params.rread.data);
+		if (err < 0)
+			goto error;
+
 		count -= n;
 		data += n;
 		offset += n;
@@ -621,11 +624,9 @@ p9_client_uread(struct p9_fid *fid, char __user *data, u64 offset, u32 count)
 		if (n > count)
 			n = count;
 
-		err = copy_to_user(data, rc->params.rread.data, n);
-		if (err) {
-			err = -EFAULT;
-			goto error;
-		}
+                err = p9_user_data_get(data, n, &rc->params.rread.data);
+                if (err < 0)
+                        goto error;
 
 		count -= n;
 		data += n;
@@ -727,12 +728,12 @@ int p9_client_readn(struct p9_fid *fid, char *data, u64 offset, u32 count)
 }
 EXPORT_SYMBOL(p9_client_readn);
 
-struct p9_stat *p9_client_stat(struct p9_fid *fid)
+struct p9_wstat *p9_client_stat(struct p9_fid *fid)
 {
 	int err;
 	struct p9_fcall *tc, *rc;
 	struct p9_client *clnt;
-	struct p9_stat *ret;
+	struct p9_wstat *ret;
 
 	P9_DPRINTK(P9_DEBUG_9P, "fid %d\n", fid->fid);
 	err = 0;
@@ -752,7 +753,7 @@ struct p9_stat *p9_client_stat(struct p9_fid *fid)
 	if (err)
 		goto error;
 
-	ret = p9_clone_stat(&rc->params.rstat.stat, clnt->dotu);
+	ret = p9_clone_wstat(&rc->params.rstat.stat, clnt->dotu);
 	if (IS_ERR(ret)) {
 		err = PTR_ERR(ret);
 		ret = NULL;
@@ -799,12 +800,12 @@ done:
 }
 EXPORT_SYMBOL(p9_client_wstat);
 
-struct p9_stat *p9_client_dirread(struct p9_fid *fid, u64 offset)
+struct p9_wstat *p9_client_dirread(struct p9_fid *fid, u64 offset)
 {
 	int err, n, m;
 	struct p9_fcall *tc, *rc;
 	struct p9_client *clnt;
-	struct p9_stat st, *ret;
+	struct p9_wstat *ret;
 
 	P9_DPRINTK(P9_DEBUG_9P, "fid %d offset %llu\n", fid->fid,
 						(long long unsigned) offset);
@@ -869,22 +870,15 @@ struct p9_stat *p9_client_dirread(struct p9_fid *fid, u64 offset)
 	if (m < 0)
 		goto done;
 
-	n = p9_deserialize_stat(fid->rdir_fcall->params.rread.data + m,
-		fid->rdir_fcall->params.rread.count - m, &st, clnt->dotu);
+	ret = p9_deserialize_stat(&fid->rdir_fcall->params.rread.data, m,
+		clnt->dotu);
 
-	if (!n) {
-		err = -EIO;
-		goto error;
-	}
-
-	fid->rdir_pos += n;
-	st.size = n;
-	ret = p9_clone_stat(&st, clnt->dotu);
 	if (IS_ERR(ret)) {
 		err = PTR_ERR(ret);
 		ret = NULL;
 		goto error;
 	}
+	fid->rdir_pos += ret->size + 2;
 
 done:
 	kfree(tc);
@@ -899,39 +893,65 @@ error:
 }
 EXPORT_SYMBOL(p9_client_dirread);
 
-static struct p9_stat *p9_clone_stat(struct p9_stat *st, int dotu)
+static struct p9_wstat *p9_clone_wstat(struct p9_stat *st, int dotu)
 {
-	int n;
+	int n, err;
 	char *p;
-	struct p9_stat *ret;
+	struct p9_wstat *ret;
 
-	n = sizeof(struct p9_stat) + st->name.len + st->uid.len + st->gid.len +
-		st->muid.len;
+	n = sizeof(struct p9_wstat) + st->name.length + st->uid.length +
+		st->gid.length + st->muid.length + 4;
 
 	if (dotu)
-		n += st->extension.len;
+		n += st->extension.length + 1;
 
 	ret = kmalloc(n, GFP_KERNEL);
 	if (!ret)
 		return ERR_PTR(-ENOMEM);
 
-	memmove(ret, st, sizeof(struct p9_stat));
-	p = ((char *) ret) + sizeof(struct p9_stat);
-	memmove(p, st->name.str, st->name.len);
-	p += st->name.len;
-	memmove(p, st->uid.str, st->uid.len);
-	p += st->uid.len;
-	memmove(p, st->gid.str, st->gid.len);
-	p += st->gid.len;
-	memmove(p, st->muid.str, st->muid.len);
-	p += st->muid.len;
+	p = ((char *) ret) + sizeof(*ret);
+	ret->size = st->size;
+	ret->type = st->type;
+	ret->dev = st->dev;
+	ret->qid = st->qid;
+	ret->mode = st->mode;
+	ret->atime = st->atime;
+	ret->mtime = st->mtime;
+	ret->length = st->length;
+	ret->name = p;
+	if ((err = p9_strcpy(p, &st->name)) < 0)
+		goto error;
+	ret->name = p;
+	p += err;
+
+	if ((err = p9_strcpy(p, &st->uid)) < 0)
+		goto error;
+	ret->uid = p;
+	p += err;
+
+	if ((err = p9_strcpy(p, &st->gid)) < 0)
+		goto error;
+	ret->gid = p;
+	p += err;
+
+	if ((err = p9_strcpy(p, &st->muid)) < 0)
+		goto error;
+	ret->muid = p;
+	p += err;
 
 	if (dotu) {
-		memmove(p, st->extension.str, st->extension.len);
-		p += st->extension.len;
-	}
+		if ((err = p9_strcpy(p, &st->extension)) < 0)
+			goto error;
+		ret->extension = p;
+		p += err;
+	} else
+		ret->extension = NULL;
 
 	return ret;
+
+error:
+	kfree(ret);
+	return ERR_PTR(err);
 }
 
 static struct p9_fid *p9_fid_create(struct p9_client *clnt)
@@ -1058,7 +1078,7 @@ EXPORT_SYMBOL(p9_client_req_decref);
 
 static void p9_client_rpcnb_cb(struct p9_trans *trans, struct p9_trans_req *req)
 {
-	struct p9_str *ename;
+	char *ename;
 	struct p9_client_req *creq;
 	struct p9_client *clnt;
 
@@ -1066,6 +1086,7 @@ static void p9_client_rpcnb_cb(struct p9_trans *trans, struct p9_trans_req *req)
 	creq = container_of(req, struct p9_client_req, req);
 	clnt = creq->clnt;
 
+	P9_DPRINTK(P9_DEBUG_9P, "tag %d\n", req->tag);
 	if (test_and_set_bit(Respond, &creq->status))
 		return;
 
@@ -1084,15 +1105,16 @@ static void p9_client_rpcnb_cb(struct p9_trans *trans, struct p9_trans_req *req)
 			req->err = -req->rc->params.rerror.errno;
 
 		if (!req->err) {
-			ename = &req->rc->params.rerror.error;
-			req->err = p9_errstr2errno(ename->str, ename->len);
+			ename = p9_strdup(&req->rc->params.rerror.error);
+			req->err = p9_errstr2errno(ename, strlen(ename));
 
 			if (!req->err) {
-				P9_DPRINTK(P9_DEBUG_ERROR, "unknown err: %.*s",
-					ename->len, ename->str);
+				P9_DPRINTK(P9_DEBUG_ERROR, "unknown err: %s",
+					ename);
 
 				req->err = -ESERVERFAULT;
 			}
+			kfree(ename);
 		}
 	} else if (req->rc && req->rc->id != req->tc->id + 1) {
 		P9_DPRINTK(P9_DEBUG_ERROR,
diff --git a/net/9p/conv.c b/net/9p/conv.c
index ed119bc..5780451 100644
--- a/net/9p/conv.c
+++ b/net/9p/conv.c
@@ -24,113 +24,269 @@
  *
  */
 
+#include <asm/page.h>
+#include <asm/scatterlist.h>
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/idr.h>
 #include <linux/uaccess.h>
+#include <linux/mm.h>
+#include <linux/highmem.h>
+#include <linux/scatterlist.h>
 #include <net/9p/9p.h>
 
 /*
  * Buffer to help with string parsing
  */
 struct cbuf {
-	unsigned char *sp;
+	struct scatterlist *sg;
+	int sglen;
+	int sgcur;
+
 	unsigned char *p;
 	unsigned char *ep;
 };
 
+static void buf_seek_slow(struct cbuf *buf, int offset);
 static int p9_size_wstat(struct p9_wstat *wstat, int dotu);
 
-static inline void buf_init(struct cbuf *buf, void *data, int datalen)
+static inline void buf_seek(struct cbuf *buf, int offset)
+{
+	buf->p += offset;
+	if (buf->p >= buf->ep) {
+		offset = buf->p - buf->ep;
+		buf_seek_slow(buf, offset);
+	}
+}
+
+static void buf_seek_slow(struct cbuf *buf, int offset)
+{
+	int n;
+	char *p, *ep, *np;
+	struct scatterlist *sg;
+
+	if (buf->sgcur >= buf->sglen)
+		return;
+
+	if (buf->sgcur >= 0 && PageHighMem(sg_page(&buf->sg[buf->sgcur])))
+		kunmap_atomic(sg_page(&buf->sg[buf->sgcur]), KM_USER0);
+
+	offset = buf->p - buf->ep;
+	buf->p = buf->ep;
+	while (offset >= 0) {
+		buf->sgcur++;
+		if (buf->sgcur == buf->sglen) {
+			if (offset == 0)
+				return;
+			else
+				goto overflow;
+		}
+
+		offset -= buf->sg[buf->sgcur].length;
+	}
+
+	offset += buf->sg[buf->sgcur].length;
+	sg = &buf->sg[buf->sgcur];
+	if (PageHighMem(sg_page(sg))) {
+		p = kmap_atomic(sg_page(sg), KM_USER0);
+		if (!p) {
+			buf->sgcur = buf->sglen;
+			return;
+		}
+		p += sg->offset;
+		ep = p + sg->length;
+	} else {
+		/* if the entries in the scatterlist point to
+		   continuous memory, set the end pointer to
+		   the end of the last */
+		p = page_address(sg_page(sg)) + sg->offset;
+		ep = p + sg->length;
+again:
+		n = buf->sgcur + 1;
+		if (n < buf->sglen && !PageHighMem(sg_page(&buf->sg[n]))) {
+			np = page_address(sg_page(&buf->sg[n])) +
+				buf->sg[n].offset;
+			if (ep == np) {
+				ep += buf->sg[n].length;
+				buf->sgcur++;
+				goto again;
+			}
+		}
+	}
+
+	buf->p = p + offset;
+	buf->ep = ep;
+	return;
+
+overflow:
+	buf->sgcur = buf->sglen + 1;
+}
+
+static inline void buf_init(struct cbuf *buf, struct scatterlist *sg, int sglen)
 {
-	buf->sp = buf->p = data;
-	buf->ep = data + datalen;
+	buf->sg = sg;
+	buf->sglen = sglen;
+	buf->sgcur = -1;
+	buf->p = NULL;
+	buf->ep = NULL;
+	buf_seek(buf, 0);
+}
+
+static inline void buf_destroy(struct cbuf *buf)
+{
+	if (buf->sgcur >= 0 && buf->sgcur < buf->sglen &&
+				PageHighMem(sg_page(&buf->sg[buf->sgcur])))
+	kunmap_atomic(sg_page(&buf->sg[buf->sgcur]), KM_USER0);
 }
 
 static inline int buf_check_overflow(struct cbuf *buf)
 {
-	return buf->p > buf->ep;
+	return buf->sgcur > buf->sglen;
 }
 
-static int buf_check_size(struct cbuf *buf, int len)
+static inline void buf_set_overflow(struct cbuf *buf)
 {
-	if (buf->p + len > buf->ep) {
-		if (buf->p < buf->ep) {
-			P9_EPRINTK(KERN_ERR,
-				"buffer overflow: want %d has %d\n", len,
-				(int)(buf->ep - buf->p));
-			dump_stack();
-			buf->p = buf->ep + 1;
-		}
+	buf->p = NULL;
+	buf->ep = NULL;
+	buf->sgcur = buf->sglen + 1;
+}
 
-		return 0;
+static inline int buf_check_size(struct cbuf *buf, int len)
+{
+	return buf->p + len < buf->ep;
+}
+
+static inline void buf_ptr(struct cbuf *buf, struct p9_data *data)
+{
+	int i;
+	struct page *p;
+
+	p = virt_to_page(buf->p);
+	for(i = buf->sgcur; i >= 0 && p != sg_page(&buf->sg[i]); i--)
+		;
+
+	if (i < 0) {
+		int n;
+
+		P9_DPRINTK(P9_DEBUG_ERROR, "i %d sgcur %d sglen %d page %p\n",
+			i, buf->sgcur, buf->sglen, p);
+
+		for(n = 0; n < buf->sglen; n++)
+			P9_DPRINTK(P9_DEBUG_ERROR, "+++ %d page %p offset %d length %d\n",
+				n, sg_page(&buf->sg[n]), buf->sg[n].offset, buf->sg[n].length);
 	}
 
-	return 1;
+	BUG_ON(i < 0);
+	data->length = 0;
+	data->sg = &buf->sg[i];
+	data->sglen = buf->sglen - i;
+	data->offset = (unsigned long)buf->p % PAGE_SIZE - buf->sg[i].offset;
 }
 
-static void *buf_alloc(struct cbuf *buf, int len)
+static inline int buf_put(struct cbuf *buf, void *data, int datalen)
 {
-	void *ret = NULL;
+	int n, len;
+	char *p;
 
-	if (buf_check_size(buf, len)) {
-		ret = buf->p;
-		buf->p += len;
+	p = data;
+	len = 0;
+	while (datalen > 0 && buf->sgcur < buf->sglen) {
+		n = min(datalen, (int) (buf->ep - buf->p));
+		memmove(buf->p, p, n);
+		datalen -= n;
+		len += n;
+		p += n;
+		buf_seek(buf, n);
 	}
 
-	return ret;
+	if (buf->sgcur == buf->sglen && datalen > 0)
+		buf_set_overflow(buf);
+
+	return len;
 }
 
+static inline int buf_put_u(struct cbuf *buf, const void __user *data, int datalen)
+{
+	int n, len, err;
+	char __user *p;
+
+	p = (char *) data;
+	len = 0;
+	while (datalen > 0 && buf->sgcur < buf->sglen) {
+		n = min(datalen, (int) (buf->ep - buf->p));
+		err = copy_from_user(buf->p, p, n);
+		if (err) {
+			buf_set_overflow(buf);
+			return -EFAULT;
+		}
+
+		datalen -= n;
+		len += n;
+		p += n;
+		buf_seek(buf, n);
+	}
+
+	if (buf->sgcur == buf->sglen && datalen > 0)
+		buf_set_overflow(buf);
+
+	return len;
+}
+
+
 static void buf_put_int8(struct cbuf *buf, u8 val)
 {
 	if (buf_check_size(buf, 1)) {
 		buf->p[0] = val;
-		buf->p++;
-	}
+		buf_seek(buf, 1);
+	} else
+		buf_put(buf, &val, 1);
 }
 
 static void buf_put_int16(struct cbuf *buf, u16 val)
 {
+	__le16 v;
+
+	v = cpu_to_le16(val);
 	if (buf_check_size(buf, 2)) {
-		*(__le16 *) buf->p = cpu_to_le16(val);
-		buf->p += 2;
-	}
+		*(__le16 *) buf->p = v;
+		buf_seek(buf, 2);
+	} else
+		buf_put(buf, &v, 2);
 }
 
 static void buf_put_int32(struct cbuf *buf, u32 val)
 {
+	__le32 v;
+
+	v = cpu_to_le32(val);
 	if (buf_check_size(buf, 4)) {
-		*(__le32 *)buf->p = cpu_to_le32(val);
-		buf->p += 4;
-	}
+		*(__le32 *)buf->p = v;
+		buf_seek(buf, 4);
+	} else
+		buf_put(buf, &v, 4);
 }
 
 static void buf_put_int64(struct cbuf *buf, u64 val)
 {
+	__le64 v;
+
+	v = cpu_to_le64(val);
 	if (buf_check_size(buf, 8)) {
-		*(__le64 *)buf->p = cpu_to_le64(val);
-		buf->p += 8;
-	}
+		*(__le64 *)buf->p = v;
+		buf_seek(buf, 8);
+	} else
+		buf_put(buf, &v, 8);
 }
 
-static char *buf_put_stringn(struct cbuf *buf, const char *s, u16 slen)
+static inline void buf_put_stringn(struct cbuf *buf, char *s, u16 slen)
 {
-	char *ret;
-
-	ret = NULL;
-	if (buf_check_size(buf, slen + 2)) {
-		buf_put_int16(buf, slen);
-		ret = buf->p;
-		memcpy(buf->p, s, slen);
-		buf->p += slen;
-	}
-
-	return ret;
+	buf_put_int16(buf, slen);
+	buf_put(buf, s, slen);
 }
 
-static inline void buf_put_string(struct cbuf *buf, const char *s)
+static inline void buf_put_string(struct cbuf *buf, char *s)
 {
 	buf_put_stringn(buf, s, s?strlen(s):0);
 }
@@ -148,6 +304,7 @@ static inline void buf_put_wstat(struct cbuf *bufp, struct p9_wstat *wstat,
 	int statsz;
 
 	statsz = p9_size_wstat(wstat, dotu);
+	wstat->size = statsz;
 	buf_put_int16(bufp, statsz);
 	buf_put_int16(bufp, wstat->type);
 	buf_put_int32(bufp, wstat->dev);
@@ -170,13 +327,62 @@ static inline void buf_put_wstat(struct cbuf *bufp, struct p9_wstat *wstat,
 	}
 }
 
+static int buf_get(struct cbuf *buf, void *data, int datalen)
+{
+	int n, len;
+	char *p;
+
+	p = data;
+	len = 0;
+	while (datalen > 0 && buf->sgcur < buf->sglen) {
+		n = min(datalen, (int)(buf->ep - buf->p));
+		memmove(p, buf->p, n);
+		datalen -= n;
+		len += n;
+		p += n;
+		buf_seek(buf, n);
+	}
+
+	if (buf->sgcur == buf->sglen && datalen > 0) {
+		BUG_ON(datalen > 0);
+		buf_set_overflow(buf);
+	}
+
+	return len;
+}
+
+static int buf_get_u(struct cbuf *buf, void __user *data, int datalen)
+{
+	int n, err, len;
+	char __user *p;
+
+	p = data;
+	len = 0;
+	while (datalen > 0 && buf->sgcur < buf->sglen) {
+		n = min(datalen, (int) (buf->ep - buf->p));
+		err = copy_to_user(p, buf->p, n);
+		if (err)
+			return -EFAULT;
+
+		datalen -= n;
+		len += n;
+		p += n;
+		buf_seek(buf, n);
+	}
+
+	if (buf->sgcur == buf->sglen && datalen > 0)
+		buf_set_overflow(buf);
+
+	return len;
+}
+
 static u8 buf_get_int8(struct cbuf *buf)
 {
 	u8 ret = 0;
 
 	if (buf_check_size(buf, 1)) {
 		ret = buf->p[0];
-		buf->p++;
+		buf_seek(buf, 1);
 	}
 
 	return ret;
@@ -184,59 +390,90 @@ static u8 buf_get_int8(struct cbuf *buf)
 
 static u16 buf_get_int16(struct cbuf *buf)
 {
-	u16 ret = 0;
+	__le16 v;
 
+	v = 0;
 	if (buf_check_size(buf, 2)) {
-		ret = le16_to_cpu(*(__le16 *)buf->p);
-		buf->p += 2;
-	}
+		v = *(__le16 *) buf->p;
+		buf_seek(buf, 2);
+	} else
+		buf_get(buf, &v, 2);
 
-	return ret;
+	return le16_to_cpu(v);
 }
 
 static u32 buf_get_int32(struct cbuf *buf)
 {
-	u32 ret = 0;
+	__le32 v;
 
 	if (buf_check_size(buf, 4)) {
-		ret = le32_to_cpu(*(__le32 *)buf->p);
-		buf->p += 4;
-	}
+		v = *(__le32 *) buf->p;
+		buf_seek(buf, 4);
+	} else
+		buf_get(buf, &v, 4);
 
-	return ret;
+	return le32_to_cpu(v);
 }
 
 static u64 buf_get_int64(struct cbuf *buf)
 {
-	u64 ret = 0;
+	__le64 v;
 
 	if (buf_check_size(buf, 8)) {
-		ret = le64_to_cpu(*(__le64 *)buf->p);
-		buf->p += 8;
-	}
+		v = *(__le64 *) buf->p;
+		buf_seek(buf, 8);
+	} else
+		buf_get(buf, &v, 8);
 
-	return ret;
+	return le64_to_cpu(v);
 }
 
-static void buf_get_data(struct cbuf *buf, u32 count, u8 **data)
+static void buf_get_data(struct cbuf *buf, u32 count, struct p9_data *data)
 {
-	if (buf_check_size(buf, count)) {
-		*data = buf->p;
-		buf->p += count;
-	} else
-		*data = NULL;
+	if (buf->sgcur < buf->sglen) {
+		buf_ptr(buf, data);
+		data->length = count;
+	}
+
+	buf_seek(buf, count);
+	if (buf_check_overflow(buf)) {
+		data->sg = NULL;
+		data->sglen = 0;
+		data->offset = 0;
+		data->length = 0;
+	}
 }
 
-static void buf_get_str(struct cbuf *buf, struct p9_str *vstr)
+static void buf_get_str(struct cbuf *buf, struct p9_data *vstr)
 {
-	vstr->len = buf_get_int16(buf);
-	if (!buf_check_overflow(buf) && buf_check_size(buf, vstr->len)) {
-		vstr->str = buf->p;
-		buf->p += vstr->len;
-	} else {
-		vstr->len = 0;
-		vstr->str = NULL;
+	u32 len;
+
+	len = buf_get_int16(buf);
+	if (buf_check_overflow(buf)) {
+		vstr->sg = NULL;
+		vstr->sglen = 0;
+		vstr->offset = 0;
+		vstr->length = 0;
+		return;
 	}
+
+
+	buf_get_data(buf, len, vstr);
+}
+
+static inline int buf_strncpy(struct cbuf *bufp, char *buf, int buflen)
+{
+	int n;
+
+	n = buf_get_int16(bufp);
+	if (n + 1 > buflen)
+		return -ENOMEM;
+
+	if (buf_get(bufp, buf, n) != n)
+		return -ENOMEM;
+
+	buf[n] = '\0';
+	return n + 1;
 }
 
 static void buf_get_qid(struct cbuf *bufp, struct p9_qid *qid)
@@ -330,31 +567,110 @@ buf_get_stat(struct cbuf *bufp, struct p9_stat *stat, int dotu)
 }
 
 /**
+ * buf_get_wstat - safely decode a recieved metadata structure into
+ *    a newly created buffer.
+ *
+ * @bufp: buffer to deserialize
+ * @dotu: non-zero if 9P2000.u
+ *
+ * The function allocates memory for the p9_wstat structure and all
+ * strings its fields point to. It is responsibility of the caller
+ * to kfree the return value when no longer needed.
+ *
+ */
+
+static struct p9_wstat *buf_get_wstat(struct cbuf *bufp, int dotu)
+{
+	int n, err;
+	u16 size;
+	char *buf;
+	struct p9_wstat *stat;
+
+	size = buf_get_int16(bufp);
+	stat = kmalloc(sizeof(*stat) + size, GFP_KERNEL);
+	buf = (char *) stat + sizeof(*stat);
+	stat->size = size;
+	stat->type = buf_get_int16(bufp);
+	stat->dev = buf_get_int32(bufp);
+
+	stat->qid.type = buf_get_int8(bufp);
+	stat->qid.version = buf_get_int32(bufp);
+	stat->qid.path = buf_get_int64(bufp);
+	stat->mode = buf_get_int32(bufp);
+	stat->atime = buf_get_int32(bufp);
+	stat->mtime = buf_get_int32(bufp);
+	stat->length = buf_get_int64(bufp);
+
+	n = size;
+	stat->name = buf;
+	if ((err = buf_strncpy(bufp, buf, n)) < 0)
+		goto error;
+	buf += err;
+	n -= err;
+
+	stat->uid = buf;
+	if ((err = buf_strncpy(bufp, buf, n)) < 0)
+		goto error;
+	buf += err;
+	n -= err;
+
+	stat->gid = buf;
+	if ((err = buf_strncpy(bufp, buf, n)) < 0)
+		goto error;
+	buf += err;
+	n -= err;
+
+	stat->muid = buf;
+	if ((err = buf_strncpy(bufp, buf, n)) < 0)
+		goto error;
+	buf += err;
+	n -= err;
+
+	if (dotu) {
+		stat->extension = buf;
+		if ((err = buf_strncpy(bufp, buf, n)) < 0)
+			goto error;
+		buf += err;
+		n -= err;
+
+		stat->n_uid = buf_get_int32(bufp);
+		stat->n_gid = buf_get_int32(bufp);
+		stat->n_muid = buf_get_int32(bufp);
+	}
+
+	if (buf_check_overflow(bufp)) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+	return stat;
+
+error:
+	kfree(stat);
+	return ERR_PTR(err);
+}
+
+/**
  * p9_deserialize_stat - decode a received metadata structure
- * @buf: buffer to deserialize
- * @buflen: length of received buffer
- * @stat: metadata structure to decode into
+ * @data: buffer to deserialize
+ * @offset: offset into the buffer
  * @dotu: non-zero if 9P2000.u
  *
- * Note: stat will point to the buf region.
+ * Note: The caller has to free the returned p9_wstat when no longer needed
  */
 
-int
-p9_deserialize_stat(void *buf, u32 buflen, struct p9_stat *stat,
-		int dotu)
+struct p9_wstat *p9_deserialize_stat(struct p9_data *data, u32 offset, int dotu)
 {
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-	unsigned char *p;
+	struct cbuf buf, *bufp;
+	struct p9_wstat *wst;
 
-	buf_init(bufp, buf, buflen);
-	p = bufp->p;
-	buf_get_stat(bufp, stat, dotu);
+	bufp = &buf;
+	buf_init(bufp, data->sg, data->sglen);
+	buf_seek(bufp, data->offset + offset);
+	wst = buf_get_wstat(bufp, dotu);
+	buf_destroy(bufp);
 
-	if (buf_check_overflow(bufp))
-		return 0;
-	else
-		return bufp->p - p;
+	return wst;
 }
 EXPORT_SYMBOL(p9_deserialize_stat);
 
@@ -370,12 +686,13 @@ EXPORT_SYMBOL(p9_deserialize_stat);
 
 int p9_deserialize_fcall(struct p9_fcall *rcall, int dotu)
 {
+	int err;
 	u32 size;
 	struct cbuf buffer;
 	struct cbuf *bufp = &buffer;
 	int i = 0;
 
-	buf_init(bufp, rcall->sdata, rcall->size);
+	buf_init(bufp, rcall->sg, rcall->sglen);
 
 	size = buf_get_int32(bufp);
 	if (size > rcall->size)
@@ -391,7 +708,8 @@ int p9_deserialize_fcall(struct p9_fcall *rcall, int dotu)
 	switch (rcall->id) {
 	default:
 		P9_EPRINTK(KERN_ERR, "unknown message type: %d\n", rcall->id);
-		return -EPROTO;
+		err = -EPROTO;
+		goto error;
 	case P9_TVERSION:
 		rcall->params.tversion.msize = buf_get_int32(bufp);
 		buf_get_str(bufp, &rcall->params.tversion.version);
@@ -443,7 +761,8 @@ int p9_deserialize_fcall(struct p9_fcall *rcall, int dotu)
 			P9_EPRINTK(KERN_ERR,
 				"Rwalk with more than %d qids: %d\n",
 				P9_MAXWELEM, rcall->params.twalk.nwname);
-			return -EPROTO;
+			err = -EPROTO;
+			goto error;
 		}
 
 		for (i = 0; i < rcall->params.twalk.nwname; i++)
@@ -455,7 +774,8 @@ int p9_deserialize_fcall(struct p9_fcall *rcall, int dotu)
 			P9_EPRINTK(KERN_ERR,
 					"Rwalk with more than %d qids: %d\n",
 					P9_MAXWELEM, rcall->params.rwalk.nwqid);
-			return -EPROTO;
+			err = -EPROTO;
+			goto error;
 		}
 
 		for (i = 0; i < rcall->params.rwalk.nwqid; i++)
@@ -534,10 +854,15 @@ int p9_deserialize_fcall(struct p9_fcall *rcall, int dotu)
 
 	if (buf_check_overflow(bufp)) {
 		P9_DPRINTK(P9_DEBUG_ERROR, "buffer overflow\n");
-		return -EIO;
+		err = -EIO;
+		goto error;
 	}
 
-	return bufp->p - bufp->sp;
+	return rcall->size;
+
+error:
+	buf_destroy(bufp);
+	return err;
 }
 EXPORT_SYMBOL(p9_deserialize_fcall);
 
@@ -565,22 +890,60 @@ static inline void p9_put_int64(struct cbuf *bufp, u64 val, u64 * p)
 	buf_put_int64(bufp, val);
 }
 
+static int p9_put_data(struct cbuf *bufp, char *data, int datalen,
+	struct p9_data *dat)
+{
+	int ret;
+
+	if (dat) {
+		buf_ptr(bufp, dat);
+		dat->length = datalen;
+	}
+
+	ret = buf_put(bufp, data, datalen);
+	if (dat && ret != datalen) {
+		dat->length = 0;
+		dat->sg = NULL;
+		dat->sglen = 0;
+		dat->offset = 0;
+	}
+
+	return ret;
+}
+
+static int p9_put_user_data(struct cbuf *bufp, const char __user *data,
+	int datalen, struct p9_data *dat)
+{
+	int err;
+
+	if (dat) {
+		buf_ptr(bufp, dat);
+		dat->length = datalen;
+	}
+
+	err = buf_put_u(bufp, data, datalen);
+	if (dat && (err < 0 || buf_check_overflow(bufp))) {
+		dat->length = 0;
+		dat->sg = NULL;
+		dat->sglen = 0;
+		dat->offset = 0;
+	}
+
+	return err;
+}
+
 static void
-p9_put_str(struct cbuf *bufp, char *data, struct p9_str *str)
+p9_put_str(struct cbuf *bufp, char *data, struct p9_data *str)
 {
 	int len;
-	char *s;
 
 	if (data)
 		len = strlen(data);
 	else
 		len = 0;
 
-	s = buf_put_stringn(bufp, data, len);
-	if (str) {
-		str->len = len;
-		str->str = s;
-	}
+	buf_put_int16(bufp, len);
+	p9_put_data(bufp, data, len, str);
 }
 
 static void p9_put_qid(struct cbuf *buf, struct p9_qid *qid,
@@ -591,23 +954,6 @@ static void p9_put_qid(struct cbuf *buf, struct p9_qid *qid,
 	p9_put_int64(buf, qid->path, &pqid->path);
 }
 
-static int
-p9_put_data(struct cbuf *bufp, const char *data, int count,
-		   unsigned char **pdata)
-{
-	*pdata = buf_alloc(bufp, count);
-	memmove(*pdata, data, count);
-	return count;
-}
-
-static int
-p9_put_user_data(struct cbuf *bufp, const char __user *data, int count,
-		   unsigned char **pdata)
-{
-	*pdata = buf_alloc(bufp, count);
-	return copy_from_user(*pdata, data, count);
-}
-
 static void
 p9_put_wstat(struct cbuf *bufp, struct p9_wstat *wstat,
 	       struct p9_stat *stat, int statsz, int dotu)
@@ -615,9 +961,7 @@ p9_put_wstat(struct cbuf *bufp, struct p9_wstat *wstat,
 	p9_put_int16(bufp, statsz, &stat->size);
 	p9_put_int16(bufp, wstat->type, &stat->type);
 	p9_put_int32(bufp, wstat->dev, &stat->dev);
-	p9_put_int8(bufp, wstat->qid.type, &stat->qid.type);
-	p9_put_int32(bufp, wstat->qid.version, &stat->qid.version);
-	p9_put_int64(bufp, wstat->qid.path, &stat->qid.path);
+	p9_put_qid(bufp, &wstat->qid, &stat->qid);
 	p9_put_int32(bufp, wstat->mode, &stat->mode);
 	p9_put_int32(bufp, wstat->atime, &stat->atime);
 	p9_put_int32(bufp, wstat->mtime, &stat->mtime);
@@ -636,33 +980,60 @@ p9_put_wstat(struct cbuf *bufp, struct p9_wstat *wstat,
 	}
 }
 
-int p9_serialize_stat(struct p9_wstat *wstat, u8 *buf, int buflen, int dotu)
+int p9_serialize_stat(struct p9_wstat *wstat, struct p9_data *data, int dotu)
 {
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-	unsigned char *p;
+	int ret, len;
+        struct cbuf buffer;
+        struct cbuf *bufp = &buffer;
 
-	buf_init(bufp, buf, buflen);
-	p = bufp->p;
+	buf_init(bufp, data->sg, data->sglen);
+	buf_seek(bufp, data->offset);
 	buf_put_wstat(bufp, wstat, dotu);
-
+	len = data->length;
+	buf_ptr(bufp, data);
+	data->length = len - wstat->size;
 	if (buf_check_overflow(bufp))
-		return 0;
+		ret = -EFAULT;
 	else
-		return bufp->p - p;
+		ret = wstat->size + 2;
+
+	buf_destroy(bufp);
+
+	return ret;
 }
 EXPORT_SYMBOL(p9_serialize_stat);
 
 struct p9_fcall *p9_fcall_alloc(u32 size)
 {
+	int i, n;
 	struct p9_fcall *fc;
+	u8 *b, *e;
 
-	fc = kmalloc(sizeof(struct p9_fcall) + size, GFP_KERNEL);
-	if (!fc)
+	size += 4 + 1 + 2;	/* size[4] id[1] tag[2] */
+	n = size / PAGE_SIZE + 2;
+	b = kmalloc(sizeof(*fc) + n * sizeof(struct scatterlist) + size, GFP_KERNEL);
+	if (!b)
 		return ERR_PTR(-ENOMEM);
 
+	fc = (struct p9_fcall *) b;
+	fc->sg = (struct scatterlist *) (b + sizeof(*fc));
+	b += sizeof(*fc) + n * sizeof(struct scatterlist);
+	e = b + size;
+	sg_set_page(&fc->sg[0], virt_to_page(b));
+	fc->sg[0].offset = (unsigned long) b % PAGE_SIZE;
+	fc->sg[0].length = min((PAGE_SIZE - fc->sg[0].offset),
+		(unsigned long) (e - b));
+
+	b += fc->sg[0].length;
+	for(i = 1; b < e; i++, b += PAGE_SIZE) {
+		sg_set_page(&fc->sg[i], virt_to_page(b));
+		fc->sg[i].offset = 0;
+		fc->sg[i].length = min(PAGE_SIZE, (unsigned long) (e - b));
+	}
+
+	fc->sglen = i;
 	fc->size = size;
-	fc->sdata = (char *)fc + sizeof(*fc);
+
 	return fc;
 }
 EXPORT_SYMBOL(p9_fcall_alloc);
@@ -674,7 +1045,7 @@ static int p9_fcall_init(struct cbuf *bufp, struct p9_fcall *fc,
 	if (fc->size < size)
 		return -ENOMEM;
 
-	buf_init(bufp, (char *)fc->sdata, size);
+	buf_init(bufp, fc->sg, fc->sglen);
 	p9_put_int32(bufp, size, &fc->size);
 	p9_put_int8(bufp, id, &fc->id);
 	p9_put_int16(bufp, P9_NOTAG, &fc->tag);
@@ -687,11 +1058,12 @@ static inline int p9_fcall_finish(struct cbuf *bufp)
 	int ret;
 
 	ret = buf_check_overflow(bufp)?-ENOMEM:0;
+	buf_destroy(bufp);
 	return ret;
 }
 
-static struct p9_fcall *
-p9_create_common(struct cbuf *bufp, u32 size, u8 id)
+static inline struct p9_fcall *p9_fcall_create(struct cbuf *bufp, u32 size,
+	u8 id)
 {
 	int n, err;
 	struct p9_fcall *fc;
@@ -710,10 +1082,40 @@ p9_create_common(struct cbuf *bufp, u32 size, u8 id)
 	return fc;
 }
 
+static inline struct p9_fcall *p9_fcall_check(struct p9_fcall *fc,
+	struct cbuf *bufp)
+{
+	int err;
+
+	err = p9_fcall_finish(bufp);
+	if (err < 0) {
+		kfree(fc);
+		fc = ERR_PTR(err);
+	}
+
+	return fc;
+}
+
 void p9_set_tag(struct p9_fcall *fc, u16 tag)
 {
+	int highmem;
+	char *p;
+
+	if (fc->sglen < 1)
+		return;
+
+	highmem = PageHighMem(sg_page(&fc->sg[0]));
 	fc->tag = tag;
-	*(__le16 *) (fc->sdata + 5) = cpu_to_le16(tag);
+
+	if (highmem)
+		p = kmap_atomic(sg_page(&fc->sg[0]), KM_USER0);
+	else
+		p = page_address(sg_page(&fc->sg[0]));
+
+	*(__le16 *) (p + fc->sg[0].offset + 5) = cpu_to_le16(tag);
+
+	if (highmem)
+		kunmap_atomic(sg_page(&fc->sg[0]), KM_USER0);
 }
 EXPORT_SYMBOL(p9_set_tag);
 
@@ -725,19 +1127,14 @@ struct p9_fcall *p9_create_tversion(u32 msize, char *version)
 	struct cbuf *bufp = &buffer;
 
 	size = 4 + 2 + strlen(version);	/* msize[4] version[s] */
-	fc = p9_create_common(bufp, size, P9_TVERSION);
+	fc = p9_fcall_create(bufp, size, P9_TVERSION);
 	if (IS_ERR(fc))
-		goto error;
+		return fc;
 
 	p9_put_int32(bufp, msize, &fc->params.tversion.msize);
 	p9_put_str(bufp, version, &fc->params.tversion.version);
 
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-error:
-	return fc;
+	return p9_fcall_check(fc, bufp);
 }
 EXPORT_SYMBOL(p9_create_tversion);
 
@@ -760,9 +1157,9 @@ struct p9_fcall *p9_create_tauth(u32 afid, char *uname, char *aname,
 	if (dotu)
 		size += 4;	/* n_uname */
 
-	fc = p9_create_common(bufp, size, P9_TAUTH);
+	fc = p9_fcall_create(bufp, size, P9_TAUTH);
 	if (IS_ERR(fc))
-		goto error;
+		return fc;
 
 	p9_put_int32(bufp, afid, &fc->params.tauth.afid);
 	p9_put_str(bufp, uname, &fc->params.tauth.uname);
@@ -770,17 +1167,11 @@ struct p9_fcall *p9_create_tauth(u32 afid, char *uname, char *aname,
 	if (dotu)
 		p9_put_int32(bufp, n_uname, &fc->params.tauth.n_uname);
 
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-error:
-	return fc;
+	return p9_fcall_check(fc, bufp);
 }
 EXPORT_SYMBOL(p9_create_tauth);
 
-struct p9_fcall *
-p9_create_tattach(u32 fid, u32 afid, char *uname, char *aname,
+struct p9_fcall *p9_create_tattach(u32 fid, u32 afid, char *uname, char *aname,
 	u32 n_uname, int dotu)
 {
 	int size;
@@ -799,9 +1190,9 @@ p9_create_tattach(u32 fid, u32 afid, char *uname, char *aname,
 	if (dotu)
 		size += 4;	/* n_uname */
 
-	fc = p9_create_common(bufp, size, P9_TATTACH);
+	fc = p9_fcall_create(bufp, size, P9_TATTACH);
 	if (IS_ERR(fc))
-		goto error;
+		return fc;
 
 	p9_put_int32(bufp, fid, &fc->params.tattach.fid);
 	p9_put_int32(bufp, afid, &fc->params.tattach.afid);
@@ -810,8 +1201,7 @@ p9_create_tattach(u32 fid, u32 afid, char *uname, char *aname,
 	if (dotu)
 		p9_put_int32(bufp, n_uname, &fc->params.tattach.n_uname);
 
-error:
-	return fc;
+	return p9_fcall_check(fc, bufp);
 }
 EXPORT_SYMBOL(p9_create_tattach);
 
@@ -823,18 +1213,13 @@ struct p9_fcall *p9_create_tflush(u16 oldtag)
 	struct cbuf *bufp = &buffer;
 
 	size = 2;		/* oldtag[2] */
-	fc = p9_create_common(bufp, size, P9_TFLUSH);
+	fc = p9_fcall_create(bufp, size, P9_TFLUSH);
 	if (IS_ERR(fc))
-		goto error;
+		return fc;
 
 	p9_put_int16(bufp, oldtag, &fc->params.tflush.oldtag);
 
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-error:
-	return fc;
+	return p9_fcall_check(fc, bufp);
 }
 EXPORT_SYMBOL(p9_create_tflush);
 
@@ -848,7 +1233,7 @@ struct p9_fcall *p9_create_twalk(u32 fid, u32 newfid, u16 nwname,
 
 	if (nwname > P9_MAXWELEM) {
 		P9_DPRINTK(P9_DEBUG_ERROR, "nwname > %d\n", P9_MAXWELEM);
-		return NULL;
+		return ERR_PTR(-E2BIG);
 	}
 
 	size = 4 + 4 + 2;	/* fid[4] newfid[4] nwname[2] ... */
@@ -856,9 +1241,9 @@ struct p9_fcall *p9_create_twalk(u32 fid, u32 newfid, u16 nwname,
 		size += 2 + strlen(wnames[i]);	/* wname[s] */
 	}
 
-	fc = p9_create_common(bufp, size, P9_TWALK);
+	fc = p9_fcall_create(bufp, size, P9_TWALK);
 	if (IS_ERR(fc))
-		goto error;
+		return fc;
 
 	p9_put_int32(bufp, fid, &fc->params.twalk.fid);
 	p9_put_int32(bufp, newfid, &fc->params.twalk.newfid);
@@ -867,12 +1252,7 @@ struct p9_fcall *p9_create_twalk(u32 fid, u32 newfid, u16 nwname,
 		p9_put_str(bufp, wnames[i], &fc->params.twalk.wnames[i]);
 	}
 
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-error:
-	return fc;
+	return p9_fcall_check(fc, bufp);
 }
 EXPORT_SYMBOL(p9_create_twalk);
 
@@ -884,19 +1264,14 @@ struct p9_fcall *p9_create_topen(u32 fid, u8 mode)
 	struct cbuf *bufp = &buffer;
 
 	size = 4 + 1;		/* fid[4] mode[1] */
-	fc = p9_create_common(bufp, size, P9_TOPEN);
+	fc = p9_fcall_create(bufp, size, P9_TOPEN);
 	if (IS_ERR(fc))
-		goto error;
+		return fc;
 
 	p9_put_int32(bufp, fid, &fc->params.topen.fid);
 	p9_put_int8(bufp, mode, &fc->params.topen.mode);
 
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-error:
-	return fc;
+	return p9_fcall_check(fc, bufp);
 }
 EXPORT_SYMBOL(p9_create_topen);
 
@@ -915,9 +1290,9 @@ struct p9_fcall *p9_create_tcreate(u32 fid, char *name, u32 perm, u8 mode,
 		    (extension == NULL ? 0 : strlen(extension));
 	}
 
-	fc = p9_create_common(bufp, size, P9_TCREATE);
+	fc = p9_fcall_create(bufp, size, P9_TCREATE);
 	if (IS_ERR(fc))
-		goto error;
+		return fc;
 
 	p9_put_int32(bufp, fid, &fc->params.tcreate.fid);
 	p9_put_str(bufp, name, &fc->params.tcreate.name);
@@ -926,12 +1301,7 @@ struct p9_fcall *p9_create_tcreate(u32 fid, char *name, u32 perm, u8 mode,
 	if (dotu)
 		p9_put_str(bufp, extension, &fc->params.tcreate.extension);
 
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-error:
-	return fc;
+	return p9_fcall_check(fc, bufp);
 }
 EXPORT_SYMBOL(p9_create_tcreate);
 
@@ -943,53 +1313,37 @@ struct p9_fcall *p9_create_tread(u32 fid, u64 offset, u32 count)
 	struct cbuf *bufp = &buffer;
 
 	size = 4 + 8 + 4;	/* fid[4] offset[8] count[4] */
-	fc = p9_create_common(bufp, size, P9_TREAD);
+	fc = p9_fcall_create(bufp, size, P9_TREAD);
 	if (IS_ERR(fc))
-		goto error;
+		return fc;
 
 	p9_put_int32(bufp, fid, &fc->params.tread.fid);
 	p9_put_int64(bufp, offset, &fc->params.tread.offset);
 	p9_put_int32(bufp, count, &fc->params.tread.count);
 
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-error:
-	return fc;
+	return p9_fcall_check(fc, bufp);
 }
 EXPORT_SYMBOL(p9_create_tread);
 
-struct p9_fcall *p9_create_twrite(u32 fid, u64 offset, u32 count,
-				      const char *data)
+struct p9_fcall *p9_create_twrite(u32 fid, u64 offset, u32 count, char *data)
 {
-	int size, err;
+	int size;
 	struct p9_fcall *fc;
 	struct cbuf buffer;
 	struct cbuf *bufp = &buffer;
 
 	/* fid[4] offset[8] count[4] data[count] */
 	size = 4 + 8 + 4 + count;
-	fc = p9_create_common(bufp, size, P9_TWRITE);
+	fc = p9_fcall_create(bufp, size, P9_TWRITE);
 	if (IS_ERR(fc))
-		goto error;
+		return fc;
 
 	p9_put_int32(bufp, fid, &fc->params.twrite.fid);
 	p9_put_int64(bufp, offset, &fc->params.twrite.offset);
 	p9_put_int32(bufp, count, &fc->params.twrite.count);
-	err = p9_put_data(bufp, data, count, &fc->params.twrite.data);
-	if (err) {
-		kfree(fc);
-		fc = ERR_PTR(err);
-		goto error;
-	}
+	p9_put_data(bufp, data, count, &fc->params.twrite.data);
 
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-error:
-	return fc;
+	return p9_fcall_check(fc, bufp);
 }
 EXPORT_SYMBOL(p9_create_twrite);
 
@@ -1003,29 +1357,61 @@ struct p9_fcall *p9_create_twrite_u(u32 fid, u64 offset, u32 count,
 
 	/* fid[4] offset[8] count[4] data[count] */
 	size = 4 + 8 + 4 + count;
-	fc = p9_create_common(bufp, size, P9_TWRITE);
+	fc = p9_fcall_create(bufp, size, P9_TWRITE);
 	if (IS_ERR(fc))
-		goto error;
+		return fc;
 
 	p9_put_int32(bufp, fid, &fc->params.twrite.fid);
 	p9_put_int64(bufp, offset, &fc->params.twrite.offset);
 	p9_put_int32(bufp, count, &fc->params.twrite.count);
 	err = p9_put_user_data(bufp, data, count, &fc->params.twrite.data);
-	if (err) {
+	if (err < 0) {
+		p9_fcall_finish(bufp);
 		kfree(fc);
-		fc = ERR_PTR(err);
-		goto error;
+		return ERR_PTR(err);
 	}
 
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-error:
-	return fc;
+	return p9_fcall_check(fc, bufp);
 }
 EXPORT_SYMBOL(p9_create_twrite_u);
 
+struct p9_fcall *p9_create_twrite_sg(u32 fid, u64 offset, u32 count,
+	int sglen, struct scatterlist *sg)
+{
+	int i, size;
+	char *data;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	/* size[4] id[1] tag[2] fid[4] offset[8] count[4] */
+	size = 4 + 1 + 2 + 4 + 8 + 4;
+	fc = kmalloc(sizeof(struct p9_fcall) + size +
+		(sglen + 1) * sizeof(struct scatterlist), GFP_KERNEL);
+	if (!fc)
+		return ERR_PTR(-ENOMEM);
+
+	fc->sglen = sglen + 1;
+	fc->sg = (struct scatterlist *) ((char *) fc + sizeof(fc));
+	data = (char *) fc->sg + (sglen + 1) * sizeof(struct scatterlist);
+	sg_set_page(&fc->sg[0], virt_to_page(data));
+	fc->sg[0].offset = (unsigned long) data % PAGE_SIZE;
+	fc->sg[0].length = size;
+	for(i = 0; i < sglen; i++)
+		fc->sg[i + 1] = sg[i];
+
+	buf_init(bufp, fc->sg, fc->sglen);
+	p9_put_int32(bufp, size + count, &fc->size);
+	p9_put_int8(bufp, P9_TWRITE, &fc->id);
+	p9_put_int16(bufp, P9_NOTAG, &fc->tag);
+	p9_put_int32(bufp, fid, &fc->params.twrite.fid);
+	p9_put_int64(bufp, offset, &fc->params.twrite.offset);
+	p9_put_int32(bufp, count, &fc->params.twrite.count);
+
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_twrite_sg);
+
 struct p9_fcall *p9_create_tclunk(u32 fid)
 {
 	int size;
@@ -1034,18 +1420,13 @@ struct p9_fcall *p9_create_tclunk(u32 fid)
 	struct cbuf *bufp = &buffer;
 
 	size = 4;		/* fid[4] */
-	fc = p9_create_common(bufp, size, P9_TCLUNK);
+	fc = p9_fcall_create(bufp, size, P9_TCLUNK);
 	if (IS_ERR(fc))
-		goto error;
+		return fc;
 
 	p9_put_int32(bufp, fid, &fc->params.tclunk.fid);
 
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-error:
-	return fc;
+	return p9_fcall_check(fc, bufp);
 }
 EXPORT_SYMBOL(p9_create_tclunk);
 
@@ -1057,18 +1438,13 @@ struct p9_fcall *p9_create_tremove(u32 fid)
 	struct cbuf *bufp = &buffer;
 
 	size = 4;		/* fid[4] */
-	fc = p9_create_common(bufp, size, P9_TREMOVE);
+	fc = p9_fcall_create(bufp, size, P9_TREMOVE);
 	if (IS_ERR(fc))
-		goto error;
+		return fc;
 
 	p9_put_int32(bufp, fid, &fc->params.tremove.fid);
 
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-error:
-	return fc;
+	return p9_fcall_check(fc, bufp);
 }
 EXPORT_SYMBOL(p9_create_tremove);
 
@@ -1080,18 +1456,13 @@ struct p9_fcall *p9_create_tstat(u32 fid)
 	struct cbuf *bufp = &buffer;
 
 	size = 4;		/* fid[4] */
-	fc = p9_create_common(bufp, size, P9_TSTAT);
+	fc = p9_fcall_create(bufp, size, P9_TSTAT);
 	if (IS_ERR(fc))
-		goto error;
+		return fc;
 
 	p9_put_int32(bufp, fid, &fc->params.tstat.fid);
 
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-error:
-	return fc;
+	return p9_fcall_check(fc, bufp);
 }
 EXPORT_SYMBOL(p9_create_tstat);
 
@@ -1105,20 +1476,15 @@ struct p9_fcall *p9_create_twstat(u32 fid, struct p9_wstat *wstat,
 
 	statsz = p9_size_wstat(wstat, dotu);
 	size = 4 + 2 + 2 + statsz;	/* fid[4] stat[n] */
-	fc = p9_create_common(bufp, size, P9_TWSTAT);
+	fc = p9_fcall_create(bufp, size, P9_TWSTAT);
 	if (IS_ERR(fc))
-		goto error;
+		return fc;
 
 	p9_put_int32(bufp, fid, &fc->params.twstat.fid);
 	buf_put_int16(bufp, statsz + 2);
 	p9_put_wstat(bufp, wstat, &fc->params.twstat.stat, statsz, dotu);
 
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-error:
-	return fc;
+	return p9_fcall_check(fc, bufp);
 }
 EXPORT_SYMBOL(p9_create_twstat);
 
@@ -1278,23 +1644,59 @@ int p9_init_rread(struct p9_fcall *fc)
 		return err;
 
 	p9_put_int32(bufp, 0, &fc->params.rread.count);
-	buf_get_data(bufp, fc->size - P9_IOHDRSZ, &fc->params.rread.data);
+	buf_ptr(bufp, &fc->params.rread.data);
+	fc->params.rread.data.length = fc->size - P9_IOHDRSZ;
 
 	return p9_fcall_finish(bufp);
 }
 EXPORT_SYMBOL(p9_init_rread);
 
+struct p9_fcall *p9_alloc_rread_sg(struct scatterlist *sg, u32 sglen)
+{
+	int i, size;
+	char *data;
+	struct p9_fcall *fc;
+
+	size = 4 + 1 + 2 + 4 + 4; /* size[4] id[1] tag[2] fid[4] count[4] */
+	fc = kmalloc(sizeof(struct p9_fcall) + size +
+		(sglen + 1) * sizeof(struct scatterlist), GFP_KERNEL);
+	if (!fc)
+		return ERR_PTR(-ENOMEM);
+
+	fc->sglen = sglen + 1;
+	fc->sg = (struct scatterlist *) ((char *) fc + sizeof(fc));
+	data = (char *) fc->sg + (sglen + 1) * sizeof(struct scatterlist);
+	sg_set_page(&fc->sg[0], virt_to_page(data));
+	fc->sg[0].offset = (unsigned long) data % PAGE_SIZE;
+	fc->sg[0].length = size;
+	for(i = 0; i < sglen; i++)
+		fc->sg[i + 1] = sg[i];
+
+	return fc;
+}
+EXPORT_SYMBOL(p9_alloc_rread_sg);
+
 void p9_set_rread_count(struct p9_fcall *fc, u32 count)
 {
-	int n;
+	int n, highmem;
 	char *p;
 
+	highmem = PageHighMem(sg_page(&fc->sg[0]));
 	n = 4 + 1 + 2 + 4 + count;/*size[4] id[1] tag[2] count[4] data[count]*/
+	fc->params.rread.data.length = count;
 	fc->params.rread.count = count;
 	fc->size = n;
-	p = fc->sdata;
-	*(__le32 *) p = cpu_to_le32(n);
-	*(__le32 *) (p + 7) = cpu_to_le32(count);
+
+	if (highmem)
+		p = kmap_atomic(sg_page(&fc->sg[0]), KM_USER0);
+	else
+		p = page_address(sg_page(&fc->sg[0]));
+
+	*(__le32 *) (p + fc->sg[0].offset) = cpu_to_le32(n);
+	*(__le32 *) (p + fc->sg[0].offset + 7) = cpu_to_le32(count);
+
+	if (highmem)
+		kunmap_atomic(sg_page(&fc->sg[0]), KM_USER0);
 }
 EXPORT_SYMBOL(p9_set_rread_count);
 
@@ -1381,20 +1783,118 @@ EXPORT_SYMBOL(p9_create_rwstat);
 
 int p9_fcall_get(char *dst, int dstlen, struct p9_fcall *fc)
 {
+	int ret;
+	struct cbuf buf, *bufp;
+
 	if (dstlen > fc->size)
 		dstlen = fc->size;
 
-	memmove(dst, fc->sdata, dstlen);
-	return dstlen;
+	bufp = &buf;
+	buf_init(bufp, fc->sg, fc->sglen);
+	ret = buf_get(bufp, dst, dstlen);
+	buf_destroy(bufp);
+
+	return ret;
 }
 EXPORT_SYMBOL(p9_fcall_get);
 
 int p9_fcall_put(struct p9_fcall *fc, char *src, int srclen)
 {
+	int ret;
+	struct cbuf buf, *bufp;
+
 	if (srclen > fc->size)
 		return -ENOMEM;
 
-	memmove(fc->sdata, src, srclen);
-	return srclen;
+	bufp = &buf;
+	buf_init(bufp, fc->sg, fc->sglen);
+	ret = buf_put(bufp, src, srclen);
+	buf_destroy(bufp);
+
+	return ret;
 }
 EXPORT_SYMBOL(p9_fcall_put);
+
+int p9_data_get(char *dst, int dstlen, struct p9_data *str)
+{
+	int ret;
+	struct cbuf buf, *bufp;
+
+	if (dstlen > str->length)
+		dstlen = str->length;
+
+	bufp = &buf;
+	buf_init(bufp, str->sg, str->sglen);
+	buf_seek(bufp, str->offset);
+	ret = buf_get(bufp, dst, dstlen);
+	buf_destroy(bufp);
+
+	return ret;
+}
+EXPORT_SYMBOL(p9_data_get);
+
+int p9_user_data_get(char __user *dst, int dstlen, struct p9_data *str)
+{
+	int ret;
+	struct cbuf buf, *bufp;
+
+	if (dstlen > str->length)
+		dstlen = str->length;
+
+	bufp = &buf;
+	buf_init(bufp, str->sg, str->sglen);
+	buf_seek(bufp, str->offset);
+	ret = buf_get_u(bufp, dst, dstlen);
+	buf_destroy(bufp);
+
+	return ret;
+}
+EXPORT_SYMBOL(p9_user_data_get);
+
+int p9_data_put(struct p9_data *str, char *dst, int dstlen)
+{
+	int ret;
+	struct cbuf buf, *bufp;
+
+	if (dstlen > str->length)
+		dstlen = str->length;
+
+	bufp = &buf;
+	buf_init(bufp, str->sg, str->sglen);
+	buf_seek(bufp, str->offset);
+	ret = buf_put(bufp, dst, dstlen);
+	buf_destroy(bufp);
+
+	return ret;
+}
+EXPORT_SYMBOL(p9_data_put);
+
+int p9_strncpy(char *dst, int dstlen, struct p9_data *str)
+{
+	int ret;
+
+	ret = p9_data_get(dst, dstlen - 1, str);
+	dst[ret] = '\0';
+
+	return ret + 1;
+}
+EXPORT_SYMBOL(p9_strncpy);
+
+int p9_strcpy(char *dst, struct p9_data *str)
+{
+	return p9_strncpy(dst, str->length, str);
+}
+EXPORT_SYMBOL(p9_strcpy);
+
+char *p9_strdup(struct p9_data *str)
+{
+	char *ret;
+
+	ret = kmalloc(str->length + 1, GFP_KERNEL);
+	if (!ret)
+		return NULL;
+
+	p9_strncpy(ret, str->length + 1, str);
+	return ret;
+}
+EXPORT_SYMBOL(p9_strdup);
diff --git a/net/9p/fcprint.c b/net/9p/fcprint.c
index 3c5cd83..dee81f4 100644
--- a/net/9p/fcprint.c
+++ b/net/9p/fcprint.c
@@ -88,17 +88,26 @@ static int
 p9_printstat(char *buf, int buflen, struct p9_stat *st, int extended)
 {
 	int n;
+	char *name, *uid, *gid, *muid, *ext;
 
-	n = scnprintf(buf, buflen, "'%.*s' '%.*s'", st->name.len,
-		st->name.str, st->uid.len, st->uid.str);
+	name = p9_strdup(&st->name);
+	uid = p9_strdup(&st->uid);
+	gid = p9_strdup(&st->gid);
+	muid = p9_strdup(&st->muid);
+	if (extended)
+		ext = p9_strdup(&st->extension);
+	else
+		ext = NULL;
+
+	n = scnprintf(buf, buflen, "'%s' '%s'", name, uid);
 	if (extended)
 		n += scnprintf(buf+n, buflen-n, "(%d)", st->n_uid);
 
-	n += scnprintf(buf+n, buflen-n, " '%.*s'", st->gid.len, st->gid.str);
+	n += scnprintf(buf+n, buflen-n, " '%s'", gid);
 	if (extended)
 		n += scnprintf(buf+n, buflen-n, "(%d)", st->n_gid);
 
-	n += scnprintf(buf+n, buflen-n, " '%.*s'", st->muid.len, st->muid.str);
+	n += scnprintf(buf+n, buflen-n, " '%s'", muid);
 	if (extended)
 		n += scnprintf(buf+n, buflen-n, "(%d)", st->n_muid);
 
@@ -110,42 +119,43 @@ p9_printstat(char *buf, int buflen, struct p9_stat *st, int extended)
 		st->atime, st->mtime, (long long int) st->length);
 
 	if (extended)
-		n += scnprintf(buf+n, buflen-n, " ext '%.*s'",
-			st->extension.len, st->extension.str);
+		n += scnprintf(buf+n, buflen-n, " ext '%s'", ext);
+
+	kfree(name);
+	kfree(uid);
+	kfree(gid);
+	kfree(muid);
+	kfree(ext);
 
 	return n;
 }
 
 static int
-p9_dumpdata(char *buf, int buflen, u8 *data, int datalen)
+p9_printdata(char *buf, int buflen, struct p9_data *data)
 {
-	int i, n;
+	int i, n, len;
+	unsigned char b[16];
+
+	if ((len = p9_data_get(b, sizeof(b), data)) < 0)
+		return len;
 
-	i = n = 0;
-	while (i < datalen) {
-		n += scnprintf(buf + n, buflen - n, "%02x", data[i]);
+	n = 0;
+	for(i = 0; i < len && buflen > n; i++) {
+		n += scnprintf(buf + n, buflen - n, "%02x", b[i]);
 		if (i%4 == 3)
 			n += scnprintf(buf + n, buflen - n, " ");
-		if (i%32 == 31)
-			n += scnprintf(buf + n, buflen - n, "\n");
-
-		i++;
 	}
+
 	n += scnprintf(buf + n, buflen - n, "\n");
 
 	return n;
 }
 
-static int
-p9_printdata(char *buf, int buflen, u8 *data, int datalen)
-{
-	return p9_dumpdata(buf, buflen, data, datalen < 16?datalen:16);
-}
-
 int
 p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
 {
 	int i, ret, type, tag;
+	char *s, *t;
 
 	if (!fc)
 		return scnprintf(buf, buflen, "<NULL>");
@@ -156,27 +166,29 @@ p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
 	ret = 0;
 	switch (type) {
 	case P9_TVERSION:
+		s = p9_strdup(&fc->params.tversion.version);
 		ret += scnprintf(buf+ret, buflen-ret,
-				"Tversion tag %u msize %u version '%.*s'", tag,
-				fc->params.tversion.msize,
-				fc->params.tversion.version.len,
-				fc->params.tversion.version.str);
+				"Tversion tag %u msize %u version '%s'", tag,
+				fc->params.tversion.msize, s);
+		kfree(s);
 		break;
 
 	case P9_RVERSION:
+		s = p9_strdup(&fc->params.rversion.version);
 		ret += scnprintf(buf+ret, buflen-ret,
-				"Rversion tag %u msize %u version '%.*s'", tag,
-				fc->params.rversion.msize,
-				fc->params.rversion.version.len,
-				fc->params.rversion.version.str);
+				"Rversion tag %u msize %u version '%s'", tag,
+				fc->params.rversion.msize, s);
+		kfree(s);
 		break;
 
 	case P9_TAUTH:
+		s = p9_strdup(&fc->params.tauth.uname);
+		t = p9_strdup(&fc->params.tauth.aname);
 		ret += scnprintf(buf+ret, buflen-ret,
-			"Tauth tag %u afid %d uname '%.*s' aname '%.*s'", tag,
-			fc->params.tauth.afid, fc->params.tauth.uname.len,
-			fc->params.tauth.uname.str, fc->params.tauth.aname.len,
-			fc->params.tauth.aname.str);
+			"Tauth tag %u afid %d uname '%s' aname '%s'", tag,
+			fc->params.tauth.afid, s, t);
+		kfree(s);
+		kfree(t);
 		break;
 
 	case P9_RAUTH:
@@ -185,11 +197,13 @@ p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
 		break;
 
 	case P9_TATTACH:
+		s = p9_strdup(&fc->params.tattach.uname);
+		t = p9_strdup(&fc->params.tattach.aname);
 		ret += scnprintf(buf+ret, buflen-ret,
-		 "Tattach tag %u fid %d afid %d uname '%.*s' aname '%.*s'", tag,
-		 fc->params.tattach.fid, fc->params.tattach.afid,
-		 fc->params.tattach.uname.len, fc->params.tattach.uname.str,
-		 fc->params.tattach.aname.len, fc->params.tattach.aname.str);
+		 "Tattach tag %u fid %d afid %d uname '%s' aname '%s'", tag,
+		 fc->params.tattach.fid, fc->params.tattach.afid, s, t);
+		kfree(s);
+		kfree(t);
 		break;
 
 	case P9_RATTACH:
@@ -199,13 +213,13 @@ p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
 		break;
 
 	case P9_RERROR:
+		s = p9_strdup(&fc->params.rerror.error);
 		ret += scnprintf(buf+ret, buflen-ret,
-				"Rerror tag %u ename '%.*s'", tag,
-				fc->params.rerror.error.len,
-				fc->params.rerror.error.str);
+				"Rerror tag %u ename '%s'", tag, s);
 		if (extended)
 			ret += scnprintf(buf+ret, buflen-ret, " ecode %d\n",
 				fc->params.rerror.errno);
+		kfree(s);
 		break;
 
 	case P9_TFLUSH:
@@ -222,10 +236,11 @@ p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
 			"Twalk tag %u fid %d newfid %d nwname %d", tag,
 			fc->params.twalk.fid, fc->params.twalk.newfid,
 			fc->params.twalk.nwname);
-		for (i = 0; i < fc->params.twalk.nwname; i++)
-			ret += scnprintf(buf+ret, buflen-ret, " '%.*s'",
-				fc->params.twalk.wnames[i].len,
-				fc->params.twalk.wnames[i].str);
+		for (i = 0; i < fc->params.twalk.nwname; i++) {
+			s = p9_strdup(&fc->params.twalk.wnames[i]);
+			ret += scnprintf(buf+ret, buflen-ret, " '%s'", s);
+			kfree(s);
+		}
 		break;
 
 	case P9_RWALK:
@@ -250,15 +265,16 @@ p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
 		break;
 
 	case P9_TCREATE:
+		s = p9_strdup(&fc->params.tcreate.name);
 		ret += scnprintf(buf+ret, buflen-ret,
-			"Tcreate tag %u fid %d name '%.*s' perm ", tag,
-			fc->params.tcreate.fid, fc->params.tcreate.name.len,
-			fc->params.tcreate.name.str);
+			"Tcreate tag %u fid %d name '%s' perm ", tag,
+			fc->params.tcreate.fid, s);
 
 		ret += p9_printperm(buf+ret, buflen-ret,
 						fc->params.tcreate.perm);
 		ret += scnprintf(buf+ret, buflen-ret, " mode %d",
 			fc->params.tcreate.mode);
+		kfree(s);
 		break;
 
 	case P9_RCREATE:
@@ -281,8 +297,7 @@ p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
 		ret += scnprintf(buf+ret, buflen-ret,
 			"Rread tag %u count %u data ", tag,
 			fc->params.rread.count);
-		ret += p9_printdata(buf+ret, buflen-ret, fc->params.rread.data,
-			fc->params.rread.count);
+		ret += p9_printdata(buf+ret, buflen-ret, &fc->params.rread.data);
 		break;
 
 	case P9_TWRITE:
@@ -291,8 +306,7 @@ p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
 			tag, fc->params.twrite.fid,
 			(long long int) fc->params.twrite.offset,
 			fc->params.twrite.count);
-		ret += p9_printdata(buf+ret, buflen-ret, fc->params.twrite.data,
-			fc->params.twrite.count);
+		ret += p9_printdata(buf+ret, buflen-ret, &fc->params.twrite.data);
 		break;
 
 	case P9_RWRITE:
diff --git a/net/9p/ramfs/ramfs.c b/net/9p/ramfs/ramfs.c
index 3aff620..2b6386b 100644
--- a/net/9p/ramfs/ramfs.c
+++ b/net/9p/ramfs/ramfs.c
@@ -3,7 +3,7 @@
  *
  * Simple RAM filesystem
  *
- *  Copyright (C) 2007 by Latchesar Ionkov <lucho@ionkov.net>
+ *  Copyright (C) 200xz7 by Latchesar Ionkov <lucho@ionkov.net>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2
@@ -97,17 +97,6 @@ static void ramfs_fiddestroy(struct p9srv_fid *fid);
 static void ramfs_connopen(struct p9srv_conn *conn);
 static void ramfs_connclose(struct p9srv_conn *conn);
 
-static char *p9_strdup(struct p9_str *str)
-{
-	char *ret;
-
-	ret = kmalloc(str->len + 1, GFP_KERNEL);
-	memmove(ret, str->str, str->len);
-	ret[str->len] = '\0';
-
-	return ret;
-}
-
 static void file_incref(struct ramfs_file *f)
 {
 	if (!f)
@@ -573,7 +562,7 @@ static void ramfs_read(struct p9srv_req *req)
 	struct ramfs_fid *fid;
 	struct ramfs_file *file, *cf;
 	struct p9_wstat wstat;
-	u8 *data;
+	struct p9_data data;
 
 	tc = req->tcall;
 	rc = req->rcall;
@@ -592,14 +581,14 @@ static void ramfs_read(struct p9srv_req *req)
 			fid->diroffset = 0;
 		}
 
+		n = 0;
 		cf = fid->dirent;
 		for (n = 0, cf = fid->dirent; (n < count) && (cf != NULL);
 							cf = cf->next) {
 			BUG_ON(test_bit(Removed, &cf->status));
 			file2wstat(cf, &wstat);
 			P9_DPRINTK(P9SRV_DEBUG_FS, "name %s\n", wstat.name);
-			i = p9_serialize_stat(&wstat, data + n, count - n - 1,
-				req->conn->dotu);
+			i = p9_serialize_stat(&wstat, &data, req->conn->dotu);
 			if (i == 0)
 				break;
 
@@ -619,7 +608,7 @@ static void ramfs_read(struct p9srv_req *req)
 		if (n < 0)
 			n = 0;
 
-		memmove(data, file->data + offset, n);
+		p9_data_put(&data, file->data + offset, n);
 	}
 
 /*
@@ -675,7 +664,8 @@ static void ramfs_write(struct p9srv_req *req)
 	}
 
 	if (count)
-		memmove(file->data + offset, tc->params.twrite.data, count);
+		p9_data_get(file->data + offset, count,
+					&tc->params.twrite.data);
 
 	mutex_lock(&file->lock);
 	file->qid.version++;
@@ -809,12 +799,12 @@ static void ramfs_wstat(struct p9srv_req *req)
 	mutex_lock(&file->lock);
 	lockfile = 1;
 
-	lockparent = stat->name.len != 0 && file->parent != file;
+	lockparent = stat->name.length != 0 && file->parent != file;
 	if (lockparent)
 		mutex_lock(&file->parent->lock);
 
 	oldname = NULL;
-	if (stat->name.len != 0) {
+	if (stat->name.length != 0) {
 		if (!check_perm(req, file->parent, req->fid->uid, 2))
 			goto out;
 
diff --git a/net/9p/srv.c b/net/9p/srv.c
index 1541ece..fade82d 100644
--- a/net/9p/srv.c
+++ b/net/9p/srv.c
@@ -330,6 +330,7 @@ static void p9srv_preq_work(struct work_struct *work)
 	if (tc->id < P9_FIRST || tc->id > P9_LAST ||
 		!p9srv_fcall[(tc->id - P9_FIRST)/2] || tc->id%2 == 1) {
 
+		P9_DPRINTK(P9SRV_DEBUG_SRV, "unsupported message %d\n", tc->id);
 		p9srv_respond_error(req, "unsupported message", EIO);
 		return;
 	}
@@ -739,7 +740,7 @@ EXPORT_SYMBOL(p9srv_listener_del);
 static void p9srv_version(struct p9srv_req *req)
 {
 	int msize;
-	struct p9_str *version;
+	char *version;
 	struct p9srv *srv;
 	struct p9srv_conn *conn;
 	struct p9_fcall *tc;
@@ -754,14 +755,14 @@ static void p9srv_version(struct p9srv_req *req)
 		return;
 	}
 
-	version = &tc->params.tversion.version;
-	if ((version->len != 8 || memcmp(version->str, "9P2000.u", 8)) &&
-		(version->len != 6 || memcmp(version->str, "9P2000", 6))) {
-
+	version = p9_strdup(&tc->params.tversion.version);
+	if (strcmp(version, "9P2000.u") && strcmp(version, "9P2000")) {
 		p9srv_respond_error(req, "unsupported protocol version", EIO);
+		kfree(version);
 		return;
 	}
 
+	kfree(version);
 	p9srv_conn_reset(conn, req);
 	p9_create_rversion(req->rcall, conn->msize,
 		conn->dotu?"9P2000.u":"9P2000");
@@ -1497,7 +1498,7 @@ EXPORT_SYMBOL(p9srv_conn_destroy);
 void p9srv_conn_reset(struct p9srv_conn *conn, struct p9srv_req *vreq)
 {
 	int i, n;
-	struct p9_str *version;
+	char *version;
 	struct p9srv *srv;
 	struct p9srv_req *req, *rptr;
 	struct p9srv_req *wreqs[16];
@@ -1560,9 +1561,10 @@ again:
 			conn->msize = srv->msize;
 
 		conn->dotu = srv->dotu;
-		version = &vreq->tcall->params.tversion.version;
-		if (version->len != 8 || memcmp(version->str, "9P2000.u", 8) != 0)
+		version = p9_strdup(&vreq->tcall->params.tversion.version);
+		if (strcmp(version, "9P2000.u"))
 			conn->dotu = 0;
+		kfree(version);
 	}
 
 	clear_bit(Reset, &conn->status);
