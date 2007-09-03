Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbXICUq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbXICUq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 16:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbXICUqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 16:46:21 -0400
Received: from 71-33-32-97.albq.qwest.net ([71.33.32.97]:50314 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753512AbXICUqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 16:46:19 -0400
X-Greylist: delayed 1689 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Sep 2007 16:46:18 EDT
Date: Mon, 3 Sep 2007 14:18:06 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org
Subject: [PATCH] 9p: attach-per-user
Message-ID: <20070903201806.GA21504@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The 9P2000 protocol requires the authentication and permission checks to be
done in the file server. For that reason every user that accesses the file
server tree has to authenticate and attach to the server separately.
Multiple users can share the same connection to the server.

Currently v9fs does a single attach and executes all I/O operations as a
single user. This makes using v9fs in multiuser environment unsafe as it
depends on the client doing the permission checking.

This patch improves the 9P2000 support by allowing every user to attach
separately. The patch defines three modes of access (new mount option
'access'):

- attach-per-user (access=user)
 If a user tries to access a file served by v9fs for the first time, v9fs
 sends an attach command to the server (Tattach) specifying the user. If
 the attach succeeds, the user can access the v9fs tree.
 As there is no uname->uid (string->integer) mapping yet, this mode works
 only with the 9P2000.u dialect.

- allow only one user to access the tree (access=<uid>)
 Only the user with uid can access the v9fs tree. Other users that attempt
 to access it will get EPERM error.

- do all operations as a single user (access=any)
 V9fs does a single attach and all operations are done as a single user.
 If this mode is selected, the v9fs behavior is identical with the current
 one.

The patch also renames uid and gid options to dfltuid and dfltgid. The new
names describe better the values they set.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
commit 836f166ce5578b084c1cd75807e29474586bab61
tree c7e1eb631c3e6b0f1cd773ae7884379776c2857d
parent 3ec910913c8c743cbe4cd9cdde17df26a75d02ec
author Latchesar Ionkov <lucho@eregion.(none)> Mon, 03 Sep 2007 14:09:29 -0600
committer Latchesar Ionkov <lucho@eregion.(none)> Mon, 03 Sep 2007 14:09:29 -0600

 fs/9p/fid.c             |  157 +++++++++++++++++++++++++++++++++++++----------
 fs/9p/v9fs.c            |   87 +++++++++++++++++++-------
 fs/9p/v9fs.h            |   27 +++++++-
 fs/9p/vfs_inode.c       |   52 ++++++++--------
 include/net/9p/9p.h     |    7 +-
 include/net/9p/client.h |    5 +
 net/9p/client.c         |   10 ++-
 net/9p/conv.c           |   32 ++++++++--
 8 files changed, 278 insertions(+), 99 deletions(-)

diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 15e05a1..b16b14b 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -1,6 +1,7 @@
 /*
  * V9FS FID Management
  *
+ *  Copyright (C) 2007 by Latchesar Ionkov <lucho@ionkov.net>
  *  Copyright (C) 2005, 2006 by Eric Van Hensbergen <ericvh@gmail.com>
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -34,9 +35,9 @@
 #include "fid.h"
 
 /**
- * v9fs_fid_insert - add a fid to a dentry
+ * v9fs_fid_add - add a fid to a dentry
+ * @dentry: dentry that the fid is being added to
  * @fid: fid to add
- * @dentry: dentry that it is being added to
  *
  */
 
@@ -66,52 +67,144 @@ int v9fs_fid_add(struct dentry *dentry, struct p9_fid *fid)
 }
 
 /**
- * v9fs_fid_lookup - return a locked fid from a dentry
+ * v9fs_fid_find - retrieve a fid that belongs to the specified uid
  * @dentry: dentry to look for fid in
- *
- * find a fid in the dentry, obtain its semaphore and return a reference to it.
- * code calling lookup is responsible for releasing lock
- *
- * TODO: only match fids that have the same uid as current user
+ * @uid: return fid that belongs to the specified user
+ * @any: if non-zero, return any fid associated with the dentry
  *
  */
 
-struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
+static struct p9_fid *v9fs_fid_find(struct dentry *dentry, u32 uid, int any)
 {
 	struct v9fs_dentry *dent;
-	struct p9_fid *fid;
-
-	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
-	dent = dentry->d_fsdata;
-	if (dent)
-		fid = list_entry(dent->fidlist.next, struct p9_fid, dlist);
-	else
-		fid = ERR_PTR(-EBADF);
+	struct p9_fid *fid, *ret;
+
+	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p) uid %d any %d\n",
+		dentry->d_iname, dentry, uid, any);
+	dent = (struct v9fs_dentry *) dentry->d_fsdata;
+	ret = NULL;
+	if (dent) {
+		spin_lock(&dent->lock);
+		list_for_each_entry(fid, &dent->fidlist, dlist) {
+			if (any || fid->uid == uid) {
+				ret = fid;
+				break;
+			}
+		}
+		spin_unlock(&dent->lock);
+	}
 
-	P9_DPRINTK(P9_DEBUG_VFS, " fid: %p\n", fid);
-	return fid;
+	return ret;
 }
 
 /**
- * v9fs_fid_clone - lookup the fid for a dentry, clone a private copy and
- * 	release it
+ * v9fs_fid_lookup - lookup for a fid, try to walk if not found
  * @dentry: dentry to look for fid in
  *
- * find a fid in the dentry and then clone to a new private fid
- *
- * TODO: only match fids that have the same uid as current user
- *
+ * Look for a fid in the specified dentry for the current user.
+ * If no fid is found, try to create one walking from a fid from the parent
+ * dentry (if it has one), or the root dentry. If the user haven't accessed
+ * the fs yet, attach now and walk from the root.
  */
 
-struct p9_fid *v9fs_fid_clone(struct dentry *dentry)
+struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
 {
-	struct p9_fid *ofid, *fid;
+	int i, n, l, clone, any, access;
+	u32 uid;
+	struct p9_fid *fid;
+	struct dentry *d, *ds;
+	struct v9fs_session_info *v9ses;
+	char **wnames, *uname;
+
+	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	access = v9ses->flags & V9FS_ACCESS_MASK;
+	switch (access) {
+	case V9FS_ACCESS_SINGLE:
+	case V9FS_ACCESS_USER:
+		uid = current->fsuid;
+		any = 0;
+		break;
+
+	case V9FS_ACCESS_ANY:
+		uid = v9ses->uid;
+		any = 1;
+		break;
+
+	default:
+		uid = ~0;
+		any = 0;
+		break;
+	}
 
-	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
-	ofid = v9fs_fid_lookup(dentry);
-	if (IS_ERR(ofid))
-		return ofid;
+	fid = v9fs_fid_find(dentry, uid, any);
+	if (fid)
+		return fid;
+
+	ds = dentry->d_parent;
+	fid = v9fs_fid_find(ds, uid, any);
+	if (!fid) { /* walk from the root */
+		n = 0;
+		for(ds = dentry; !IS_ROOT(ds); ds = ds->d_parent)
+			n++;
+
+		fid = v9fs_fid_find(ds, uid, any);
+		if (!fid) { /* the user is not attached to the fs yet */
+			if (access == V9FS_ACCESS_SINGLE)
+				return ERR_PTR(-EPERM);
+
+			if (v9fs_extended(v9ses))
+				uname = NULL;
+			else
+				uname = v9ses->uname;
+
+			fid = p9_client_attach(v9ses->clnt, NULL, uname, uid,
+				v9ses->aname);
+
+			if (IS_ERR(fid))
+				return fid;
+
+			v9fs_fid_add(ds, fid);
+		}
+	} else /* walk from the parent */
+		n = 1;
+
+	if (ds == dentry)
+		return fid;
+
+	wnames = kmalloc(sizeof(char *) * n, GFP_KERNEL);
+	if (!wnames)
+		return ERR_PTR(-ENOMEM);
+
+	for(d = dentry, i = n; i >= 0; i--, d = d->d_parent)
+		wnames[i] = (char *) d->d_name.name;
+
+	clone = 1;
+	i = 0;
+	while (i < n) {
+		l = min(n - i, P9_MAXWELEM);
+		fid = p9_client_walk(fid, l, &wnames[i], clone);
+		if (!fid) {
+			kfree(wnames);
+			return fid;
+		}
+
+		i += l;
+		clone = 0;
+	}
 
-	fid = p9_client_walk(ofid, 0, NULL, 1);
+	kfree(wnames);
+	v9fs_fid_add(dentry, fid);
 	return fid;
 }
+
+struct p9_fid *v9fs_fid_clone(struct dentry *dentry)
+{
+	struct p9_fid *fid, *ret;
+
+	fid = v9fs_fid_lookup(dentry);
+	if (IS_ERR(fid))
+		return fid;
+
+	ret = p9_client_walk(fid, 0, NULL, 1);
+	return ret;
+}
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 08d880f..89ee0ba 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -84,13 +84,15 @@ static struct p9_trans_module *v9fs_match_trans(const substring_t *name)
 
 enum {
 	/* Options that take integer arguments */
-	Opt_debug, Opt_msize, Opt_uid, Opt_gid, Opt_afid,
+	Opt_debug, Opt_msize, Opt_dfltuid, Opt_dfltgid, Opt_afid,
 	/* String options */
 	Opt_uname, Opt_remotename, Opt_trans,
 	/* Options that take no arguments */
 	Opt_legacy, Opt_nodevmap,
 	/* Cache options */
 	Opt_cache_loose,
+	/* Access options */
+	Opt_access,
 	/* Error token */
 	Opt_err
 };
@@ -98,8 +100,8 @@ enum {
 static match_table_t tokens = {
 	{Opt_debug, "debug=%x"},
 	{Opt_msize, "msize=%u"},
-	{Opt_uid, "uid=%u"},
-	{Opt_gid, "gid=%u"},
+	{Opt_dfltuid, "dfltuid=%u"},
+	{Opt_dfltgid, "dfltgid=%u"},
 	{Opt_afid, "afid=%u"},
 	{Opt_uname, "uname=%s"},
 	{Opt_remotename, "aname=%s"},
@@ -108,6 +110,7 @@ static match_table_t tokens = {
 	{Opt_nodevmap, "nodevmap"},
 	{Opt_cache_loose, "cache=loose"},
 	{Opt_cache_loose, "loose"},
+	{Opt_access, "access=%s"},
 	{Opt_err, NULL}
 };
 
@@ -125,10 +128,10 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)
 	char *p;
 	int option;
 	int ret;
+	char *s, *e;
 
 	/* setup defaults */
 	v9ses->maxdata = 8192;
-	v9ses->extended = 1;
 	v9ses->afid = ~0;
 	v9ses->debug = 0;
 	v9ses->cache = 0;
@@ -159,11 +162,11 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)
 		case Opt_msize:
 			v9ses->maxdata = option;
 			break;
-		case Opt_uid:
-			v9ses->uid = option;
+		case Opt_dfltuid:
+			v9ses->dfltuid = option;
 			break;
-		case Opt_gid:
-			v9ses->gid = option;
+		case Opt_dfltgid:
+			v9ses->dfltgid = option;
 			break;
 		case Opt_afid:
 			v9ses->afid = option;
@@ -172,13 +175,13 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)
 			v9ses->trans = v9fs_match_trans(&args[0]);
 			break;
 		case Opt_uname:
-			match_strcpy(v9ses->name, &args[0]);
+			match_strcpy(v9ses->uname, &args[0]);
 			break;
 		case Opt_remotename:
-			match_strcpy(v9ses->remotename, &args[0]);
+			match_strcpy(v9ses->aname, &args[0]);
 			break;
 		case Opt_legacy:
-			v9ses->extended = 0;
+			v9ses->flags &= ~V9FS_EXTENDED;
 			break;
 		case Opt_nodevmap:
 			v9ses->nodev = 1;
@@ -186,6 +189,22 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)
 		case Opt_cache_loose:
 			v9ses->cache = CACHE_LOOSE;
 			break;
+
+		case Opt_access:
+			s = match_strdup(&args[0]);
+			v9ses->flags &= ~V9FS_ACCESS_MASK;
+			if (strcmp(s, "user") == 0)
+				v9ses->flags |= V9FS_ACCESS_USER;
+			else if (strcmp(s, "any") == 0)
+				v9ses->flags |= V9FS_ACCESS_ANY;
+			else {
+				v9ses->flags |= V9FS_ACCESS_SINGLE;
+				v9ses->uid = simple_strtol(s, &e, 10);
+				if (*e != '\0')
+					v9ses->uid = ~0;
+			}
+			break;
+
 		default:
 			continue;
 		}
@@ -207,19 +226,22 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 	struct p9_trans *trans = NULL;
 	struct p9_fid *fid;
 
-	v9ses->name = __getname();
-	if (!v9ses->name)
+	v9ses->uname = __getname();
+	if (!v9ses->uname)
 		return ERR_PTR(-ENOMEM);
 
-	v9ses->remotename = __getname();
-	if (!v9ses->remotename) {
-		__putname(v9ses->name);
+	v9ses->aname = __getname();
+	if (!v9ses->aname) {
+		__putname(v9ses->uname);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	strcpy(v9ses->name, V9FS_DEFUSER);
-	strcpy(v9ses->remotename, V9FS_DEFANAME);
-
+	v9ses->flags = V9FS_EXTENDED | V9FS_ACCESS_USER;
+	strcpy(v9ses->uname, V9FS_DEFUSER);
+	strcpy(v9ses->aname, V9FS_DEFANAME);
+	v9ses->uid = ~0;
+	v9ses->dfltuid = V9FS_DEFUID;
+	v9ses->dfltgid = V9FS_DEFGID;
 	v9ses->options = kstrdup(data, GFP_KERNEL);
 	v9fs_parse_options(v9ses);
 
@@ -244,7 +266,7 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 		v9ses->maxdata = v9ses->trans->maxsize-P9_IOHDRSZ;
 
 	v9ses->clnt = p9_client_create(trans, v9ses->maxdata+P9_IOHDRSZ,
-		v9ses->extended);
+		v9fs_extended(v9ses));
 
 	if (IS_ERR(v9ses->clnt)) {
 		retval = PTR_ERR(v9ses->clnt);
@@ -253,8 +275,20 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 		goto error;
 	}
 
-	fid = p9_client_attach(v9ses->clnt, NULL, v9ses->name,
-							v9ses->remotename);
+	if (!v9ses->clnt->dotu)
+		v9ses->flags &= ~V9FS_EXTENDED;
+
+	/* for legacy mode, fall back to V9FS_ACCESS_ANY */
+	if (!v9fs_extended(v9ses) &&
+		((v9ses->flags&V9FS_ACCESS_MASK) == V9FS_ACCESS_USER)) {
+
+		v9ses->flags &= ~V9FS_ACCESS_MASK;
+		v9ses->flags |= V9FS_ACCESS_ANY;
+		v9ses->uid = ~0;
+	}
+
+	fid = p9_client_attach(v9ses->clnt, NULL, v9ses->uname, ~0,
+							v9ses->aname);
 	if (IS_ERR(fid)) {
 		retval = PTR_ERR(fid);
 		fid = NULL;
@@ -262,6 +296,11 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 		goto error;
 	}
 
+	if ((v9ses->flags & V9FS_ACCESS_MASK) == V9FS_ACCESS_SINGLE)
+		fid->uid = v9ses->uid;
+	else
+		fid->uid = ~0;
+
 	return fid;
 
 error:
@@ -282,8 +321,8 @@ void v9fs_session_close(struct v9fs_session_info *v9ses)
 		v9ses->clnt = NULL;
 	}
 
-	__putname(v9ses->name);
-	__putname(v9ses->remotename);
+	__putname(v9ses->uname);
+	__putname(v9ses->aname);
 	kfree(v9ses->options);
 }
 
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 7eb135c..280dbd4 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -29,22 +29,32 @@
 struct v9fs_session_info {
 	/* options */
 	unsigned int maxdata;
-	unsigned char extended;	/* set to 1 if we are using UNIX extensions */
+	unsigned char flags;	/* session flags */
 	unsigned char nodev;	/* set to 1 if no disable device mapping */
 	unsigned short debug;	/* debug level */
 	unsigned int afid;	/* authentication fid */
 	unsigned int cache;	/* cache mode */
 
 	char *options;		/* copy of mount options */
-	char *name;		/* user name to mount as */
-	char *remotename;	/* name of remote hierarchy being mounted */
-	unsigned int uid;	/* default uid/muid for legacy support */
-	unsigned int gid;	/* default gid for legacy support */
+	char *uname;		/* user name to mount as */
+	char *aname;		/* name of remote hierarchy being mounted */
+	unsigned int dfltuid;	/* default uid/muid for legacy support */
+	unsigned int dfltgid;	/* default gid for legacy support */
+	u32 uid;		/* if ACCESS_SINGLE, the uid that has access */
 	struct p9_trans_module *trans; /* 9p transport */
 	struct p9_client *clnt;	/* 9p client */
 	struct dentry *debugfs_dir;
 };
 
+/* session flags */
+enum {
+	V9FS_EXTENDED		= 0x01,	/* 9P2000.u */
+	V9FS_ACCESS_MASK	= 0x06,	/* access mask */
+	V9FS_ACCESS_SINGLE	= 0x02,	/* only one user can access the files */
+	V9FS_ACCESS_USER	= 0x04,	/* attache per user */
+	V9FS_ACCESS_ANY		= 0x06,	/* use the same attach for all users */
+};
+
 /* possible values of ->cache */
 /* eventually support loose, tight, time, session, default always none */
 enum {
@@ -65,8 +75,15 @@ void v9fs_session_cancel(struct v9fs_session_info *v9ses);
 #define V9FS_PORT		564
 #define V9FS_DEFUSER	"nobody"
 #define V9FS_DEFANAME	""
+#define V9FS_DEFUID	(0)
+#define V9FS_DEFGID	(0)
 
 static inline struct v9fs_session_info *v9fs_inode2v9ses(struct inode *inode)
 {
 	return (inode->i_sb->s_fs_info);
 }
+
+static inline int v9fs_extended(struct v9fs_session_info *v9ses)
+{
+	return v9ses->flags & V9FS_EXTENDED;
+}
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index e5c45ee..fbc4cb1 100644
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
@@ -364,7 +364,7 @@ static int v9fs_remove(struct inode *dir, struct dentry *file, int rmdir)
 	file_inode = file->d_inode;
 	v9ses = v9fs_inode2v9ses(file_inode);
 	v9fid = v9fs_fid_clone(file);
-	if(IS_ERR(v9fid))
+	if (IS_ERR(v9fid))
 		return PTR_ERR(v9fid);
 
 	return p9_client_remove(v9fid);
@@ -398,7 +398,7 @@ v9fs_create(struct v9fs_session_info *v9ses, struct inode *dir,
 	fid = NULL;
 	name = (char *) dentry->d_name.name;
 	dfid = v9fs_fid_clone(dentry->d_parent);
-	if(IS_ERR(dfid)) {
+	if (IS_ERR(dfid)) {
 		err = PTR_ERR(dfid);
 		dfid = NULL;
 		goto error;
@@ -432,7 +432,7 @@ v9fs_create(struct v9fs_session_info *v9ses, struct inode *dir,
 		goto error;
 	}
 
-	if(v9ses->cache)
+	if (v9ses->cache)
 		dentry->d_op = &v9fs_cached_dentry_operations;
 	else
 		dentry->d_op = &v9fs_dentry_operations;
@@ -593,7 +593,7 @@ static struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 	if (result < 0)
 		goto error;
 
-	if((fid->qid.version)&&(v9ses->cache))
+	if ((fid->qid.version) && (v9ses->cache))
 		dentry->d_op = &v9fs_cached_dentry_operations;
 	else
 		dentry->d_op = &v9fs_dentry_operations;
@@ -658,17 +658,17 @@ v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old_inode = old_dentry->d_inode;
 	v9ses = v9fs_inode2v9ses(old_inode);
 	oldfid = v9fs_fid_lookup(old_dentry);
-	if(IS_ERR(oldfid))
+	if (IS_ERR(oldfid))
 		return PTR_ERR(oldfid);
 
 	olddirfid = v9fs_fid_clone(old_dentry->d_parent);
-	if(IS_ERR(olddirfid)) {
+	if (IS_ERR(olddirfid)) {
 		retval = PTR_ERR(olddirfid);
 		goto done;
 	}
 
 	newdirfid = v9fs_fid_clone(new_dentry->d_parent);
-	if(IS_ERR(newdirfid)) {
+	if (IS_ERR(newdirfid)) {
 		retval = PTR_ERR(newdirfid);
 		goto clunk_olddir;
 	}
@@ -682,7 +682,7 @@ v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 
 	v9fs_blank_wstat(&wstat);
-	wstat.muid = v9ses->name;
+	wstat.muid = v9ses->uname;
 	wstat.name = (char *) new_dentry->d_name.name;
 	retval = p9_client_wstat(oldfid, &wstat);
 
@@ -752,7 +752,7 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	retval = -EPERM;
 	v9ses = v9fs_inode2v9ses(dentry->d_inode);
 	fid = v9fs_fid_lookup(dentry);
-	if(IS_ERR(fid))
+	if (IS_ERR(fid))
 		return PTR_ERR(fid);
 
 	v9fs_blank_wstat(&wstat);
@@ -768,7 +768,7 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	if (iattr->ia_valid & ATTR_SIZE)
 		wstat.length = iattr->ia_size;
 
-	if (v9ses->extended) {
+	if (v9fs_extended(v9ses)) {
 		if (iattr->ia_valid & ATTR_UID)
 			wstat.n_uid = iattr->ia_uid;
 
@@ -805,10 +805,10 @@ v9fs_stat2inode(struct p9_stat *stat, struct inode *inode,
 	inode->i_mtime.tv_sec = stat->mtime;
 	inode->i_ctime.tv_sec = stat->mtime;
 
-	inode->i_uid = v9ses->uid;
-	inode->i_gid = v9ses->gid;
+	inode->i_uid = v9ses->dfltuid;
+	inode->i_gid = v9ses->dfltgid;
 
-	if (v9ses->extended) {
+	if (v9fs_extended(v9ses)) {
 		inode->i_uid = stat->n_uid;
 		inode->i_gid = stat->n_gid;
 	}
@@ -887,10 +887,10 @@ static int v9fs_readlink(struct dentry *dentry, char *buffer, int buflen)
 	retval = -EPERM;
 	v9ses = v9fs_inode2v9ses(dentry->d_inode);
 	fid = v9fs_fid_lookup(dentry);
-	if(IS_ERR(fid))
+	if (IS_ERR(fid))
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
@@ -1070,7 +1070,7 @@ v9fs_vfs_link(struct dentry *old_dentry, struct inode *dir,
 		old_dentry->d_name.name);
 
 	oldfid = v9fs_fid_clone(old_dentry);
-	if(IS_ERR(oldfid))
+	if (IS_ERR(oldfid))
 		return PTR_ERR(oldfid);
 
 	name = __getname();
diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 88884d3..cd693e3 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -216,6 +216,7 @@ struct p9_tauth {
 	u32 afid;
 	struct p9_str uname;
 	struct p9_str aname;
+	u32 n_uname;		/* 9P2000.u extensions */
 };
 
 struct p9_rauth {
@@ -239,6 +240,7 @@ struct p9_tattach {
 	u32 afid;
 	struct p9_str uname;
 	struct p9_str aname;
+	u32 n_uname;		/* 9P2000.u extensions */
 };
 
 struct p9_rattach {
@@ -382,8 +384,9 @@ int p9_deserialize_fcall(void *buf, u32 buflen, struct p9_fcall *fc, int dotu);
 void p9_set_tag(struct p9_fcall *fc, u16 tag);
 struct p9_fcall *p9_create_tversion(u32 msize, char *version);
 struct p9_fcall *p9_create_tattach(u32 fid, u32 afid, char *uname,
-	char *aname);
-struct p9_fcall *p9_create_tauth(u32 afid, char *uname, char *aname);
+	char *aname, u32 n_uname, int dotu);
+struct p9_fcall *p9_create_tauth(u32 afid, char *uname, char *aname,
+	u32 n_uname, int dotu);
 struct p9_fcall *p9_create_tflush(u16 oldtag);
 struct p9_fcall *p9_create_twalk(u32 fid, u32 newfid, u16 nwname,
 	char **wnames);
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 0adafdb..9b9221a 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -57,8 +57,9 @@ struct p9_client *p9_client_create(struct p9_trans *trans, int msize,
 void p9_client_destroy(struct p9_client *clnt);
 void p9_client_disconnect(struct p9_client *clnt);
 struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
-						     char *uname, char *aname);
-struct p9_fid *p9_client_auth(struct p9_client *clnt, char *uname, char *aname);
+					char *uname, u32 n_uname, char *aname);
+struct p9_fid *p9_client_auth(struct p9_client *clnt, char *uname,
+						u32 n_uname, char *aname);
 struct p9_fid *p9_client_walk(struct p9_fid *oldfid, int nwname, char **wnames,
 								int clone);
 int p9_client_open(struct p9_fid *fid, int mode);
diff --git a/net/9p/client.c b/net/9p/client.c
index e161012..d83cc12 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -146,7 +146,7 @@ void p9_client_disconnect(struct p9_client *clnt)
 EXPORT_SYMBOL(p9_client_disconnect);
 
 struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
-	char *uname, char *aname)
+	char *uname, u32 n_uname, char *aname)
 {
 	int err;
 	struct p9_fcall *tc, *rc;
@@ -165,7 +165,8 @@ struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
 		goto error;
 	}
 
-	tc = p9_create_tattach(fid->fid, afid?afid->fid:P9_NOFID, uname, aname);
+	tc = p9_create_tattach(fid->fid, afid?afid->fid:P9_NOFID, uname, aname,
+		n_uname, clnt->dotu);
 	if (IS_ERR(tc)) {
 		err = PTR_ERR(tc);
 		tc = NULL;
@@ -190,7 +191,8 @@ error:
 }
 EXPORT_SYMBOL(p9_client_attach);
 
-struct p9_fid *p9_client_auth(struct p9_client *clnt, char *uname, char *aname)
+struct p9_fid *p9_client_auth(struct p9_client *clnt, char *uname,
+	u32 n_uname, char *aname)
 {
 	int err;
 	struct p9_fcall *tc, *rc;
@@ -209,7 +211,7 @@ struct p9_fid *p9_client_auth(struct p9_client *clnt, char *uname, char *aname)
 		goto error;
 	}
 
-	tc = p9_create_tauth(fid->fid, uname, aname);
+	tc = p9_create_tauth(fid->fid, uname, aname, n_uname, clnt->dotu);
 	if (IS_ERR(tc)) {
 		err = PTR_ERR(tc);
 		tc = NULL;
diff --git a/net/9p/conv.c b/net/9p/conv.c
index d979d95..aa2aa98 100644
--- a/net/9p/conv.c
+++ b/net/9p/conv.c
@@ -547,7 +547,8 @@ error:
 }
 EXPORT_SYMBOL(p9_create_tversion);
 
-struct p9_fcall *p9_create_tauth(u32 afid, char *uname, char *aname)
+struct p9_fcall *p9_create_tauth(u32 afid, char *uname, char *aname,
+	u32 n_uname, int dotu)
 {
 	int size;
 	struct p9_fcall *fc;
@@ -555,7 +556,16 @@ struct p9_fcall *p9_create_tauth(u32 afid, char *uname, char *aname)
 	struct cbuf *bufp = &buffer;
 
 	/* afid[4] uname[s] aname[s] */
-	size = 4 + 2 + strlen(uname) + 2 + strlen(aname);
+	size = 4 + 2 + 2;
+	if (uname)
+		size += strlen(uname);
+
+	if (aname)
+		size += strlen(aname);
+
+	if (dotu)
+		size += 4;	/* n_uname */
+
 	fc = p9_create_common(bufp, size, P9_TAUTH);
 	if (IS_ERR(fc))
 		goto error;
@@ -563,6 +573,8 @@ struct p9_fcall *p9_create_tauth(u32 afid, char *uname, char *aname)
 	p9_put_int32(bufp, afid, &fc->params.tauth.afid);
 	p9_put_str(bufp, uname, &fc->params.tauth.uname);
 	p9_put_str(bufp, aname, &fc->params.tauth.aname);
+	if (dotu)
+		p9_put_int32(bufp, n_uname, &fc->params.tauth.n_uname);
 
 	if (buf_check_overflow(bufp)) {
 		kfree(fc);
@@ -574,7 +586,8 @@ error:
 EXPORT_SYMBOL(p9_create_tauth);
 
 struct p9_fcall *
-p9_create_tattach(u32 fid, u32 afid, char *uname, char *aname)
+p9_create_tattach(u32 fid, u32 afid, char *uname, char *aname,
+	u32 n_uname, int dotu)
 {
 	int size;
 	struct p9_fcall *fc;
@@ -582,7 +595,16 @@ p9_create_tattach(u32 fid, u32 afid, char *uname, char *aname)
 	struct cbuf *bufp = &buffer;
 
 	/* fid[4] afid[4] uname[s] aname[s] */
-	size = 4 + 4 + 2 + strlen(uname) + 2 + strlen(aname);
+	size = 4 + 4 + 2 + 2;
+	if (uname)
+		size += strlen(uname);
+
+	if (aname)
+		size += strlen(aname);
+
+	if (dotu)
+		size += 4;	/* n_uname */
+
 	fc = p9_create_common(bufp, size, P9_TATTACH);
 	if (IS_ERR(fc))
 		goto error;
@@ -591,6 +613,8 @@ p9_create_tattach(u32 fid, u32 afid, char *uname, char *aname)
 	p9_put_int32(bufp, afid, &fc->params.tattach.afid);
 	p9_put_str(bufp, uname, &fc->params.tattach.uname);
 	p9_put_str(bufp, aname, &fc->params.tattach.aname);
+	if (dotu)
+		p9_put_int32(bufp, n_uname, &fc->params.tattach.n_uname);
 
 error:
 	return fc;
