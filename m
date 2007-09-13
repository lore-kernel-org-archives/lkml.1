Return-Path: <linux-kernel-owner+w=401wt.eu-S1765414AbXIMFNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765414AbXIMFNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 01:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760227AbXIMFND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 01:13:03 -0400
Received: from 70-56-219-218.albq.qwest.net ([70.56.219.218]:60779 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750979AbXIMFM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 01:12:56 -0400
Date: Wed, 12 Sep 2007 22:48:03 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
       ericvh@gmail.com
Subject: [PATCH] 9p: attach-per-user
Message-ID: <20070913044803.GC2675@ionkov.net>
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

- attach-per-user (access=user) (default mode for 9P2000.u)
 If a user tries to access a file served by v9fs for the first time, v9fs
 sends an attach command to the server (Tattach) specifying the user. If
 the attach succeeds, the user can access the v9fs tree.
 As there is no uname->uid (string->integer) mapping yet, this mode works
 only with the 9P2000.u dialect.

- allow only one user to access the tree (access=<uid>)
 Only the user with uid can access the v9fs tree. Other users that attempt
 to access it will get EPERM error.

- do all operations as a single user (access=any) (default for 9P2000)
 V9fs does a single attach and all operations are done as a single user.
 If this mode is selected, the v9fs behavior is identical with the current
 one.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
commit c3daf49339c2ba13b1d8bc5087c196093f2f78f5
tree a401d3d055bbfa3be2a4c7259f3b25f81f8c1272
parent 13bf527796712619df072c0963e3f6c8c00189b8
author Latchesar Ionkov <lucho@eregion.(none)> Wed, 12 Sep 2007 22:38:59 -0600
committer Latchesar Ionkov <lucho@eregion.(none)> Wed, 12 Sep 2007 22:38:59 -0600

 Documentation/filesystems/9p.txt |   10 ++
 fs/9p/fid.c                      |  157 ++++++++++++++++++++++++++++++--------
 fs/9p/v9fs.c                     |   67 +++++++++++++---
 fs/9p/v9fs.h                     |   11 ++-
 fs/9p/vfs_inode.c                |   20 ++---
 include/net/9p/9p.h              |    7 +-
 include/net/9p/client.h          |    5 +
 net/9p/client.c                  |   10 +-
 net/9p/conv.c                    |   32 +++++++-
 9 files changed, 247 insertions(+), 72 deletions(-)

diff --git a/Documentation/filesystems/9p.txt b/Documentation/filesystems/9p.txt
index e694cd1..d6fd6c6 100644
--- a/Documentation/filesystems/9p.txt
+++ b/Documentation/filesystems/9p.txt
@@ -88,6 +88,16 @@ OPTIONS
   		This can be used to share devices/named pipes/sockets between
 		hosts.  This functionality will be expanded in later versions.
 
+  access	there are three access modes.
+			user  = if a user tries to access a file on v9fs
+			        filesystem for the first time, v9fs sends an
+			        attach command (Tattach) for that user.
+				This is the default mode.
+			<uid> = allows only user with uid=<uid> to access
+				the files on the mounted filesystem
+			any   = v9fs does single attach and performs all
+				operations as one user
+
 RESOURCES
 =========
 
diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 15e05a1..b364da7 100644
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
+		for (ds = dentry; !IS_ROOT(ds); ds = ds->d_parent)
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
+	for (d = dentry, i = n; i >= 0; i--, d = d->d_parent)
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
index 68f82be..89ee0ba 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -91,6 +91,8 @@ enum {
 	Opt_legacy, Opt_nodevmap,
 	/* Cache options */
 	Opt_cache_loose,
+	/* Access options */
+	Opt_access,
 	/* Error token */
 	Opt_err
 };
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
-	v9ses->flags = V9FS_EXTENDED;
 	v9ses->afid = ~0;
 	v9ses->debug = 0;
 	v9ses->cache = 0;
@@ -172,10 +175,10 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)
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
 			v9ses->flags &= ~V9FS_EXTENDED;
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
@@ -207,21 +226,22 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
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
+	v9ses->flags = V9FS_EXTENDED | V9FS_ACCESS_USER;
+	strcpy(v9ses->uname, V9FS_DEFUSER);
+	strcpy(v9ses->aname, V9FS_DEFANAME);
+	v9ses->uid = ~0;
 	v9ses->dfltuid = V9FS_DEFUID;
 	v9ses->dfltgid = V9FS_DEFGID;
-
 	v9ses->options = kstrdup(data, GFP_KERNEL);
 	v9fs_parse_options(v9ses);
 
@@ -255,8 +275,20 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
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
@@ -264,6 +296,11 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 		goto error;
 	}
 
+	if ((v9ses->flags & V9FS_ACCESS_MASK) == V9FS_ACCESS_SINGLE)
+		fid->uid = v9ses->uid;
+	else
+		fid->uid = ~0;
+
 	return fid;
 
 error:
@@ -284,8 +321,8 @@ void v9fs_session_close(struct v9fs_session_info *v9ses)
 		v9ses->clnt = NULL;
 	}
 
-	__putname(v9ses->name);
-	__putname(v9ses->remotename);
+	__putname(v9ses->uname);
+	__putname(v9ses->aname);
 	kfree(v9ses->options);
 }
 
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 5d0280a..280dbd4 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -36,10 +36,11 @@ struct v9fs_session_info {
 	unsigned int cache;	/* cache mode */
 
 	char *options;		/* copy of mount options */
-	char *name;		/* user name to mount as */
-	char *remotename;	/* name of remote hierarchy being mounted */
+	char *uname;		/* user name to mount as */
+	char *aname;		/* name of remote hierarchy being mounted */
 	unsigned int dfltuid;	/* default uid/muid for legacy support */
 	unsigned int dfltgid;	/* default gid for legacy support */
+	u32 uid;		/* if ACCESS_SINGLE, the uid that has access */
 	struct p9_trans_module *trans; /* 9p transport */
 	struct p9_client *clnt;	/* 9p client */
 	struct dentry *debugfs_dir;
@@ -47,7 +48,11 @@ struct v9fs_session_info {
 
 /* session flags */
 enum {
-	V9FS_EXTENDED,
+	V9FS_EXTENDED		= 0x01,	/* 9P2000.u */
+	V9FS_ACCESS_MASK	= 0x06,	/* access mask */
+	V9FS_ACCESS_SINGLE	= 0x02,	/* only one user can access the files */
+	V9FS_ACCESS_USER	= 0x04,	/* attache per user */
+	V9FS_ACCESS_ANY		= 0x06,	/* use the same attach for all users */
 };
 
 /* possible values of ->cache */
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index f08a35d..175b4d9 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
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
 
@@ -887,7 +887,7 @@ static int v9fs_readlink(struct dentry *dentry, char *buffer, int buflen)
 	retval = -EPERM;
 	v9ses = v9fs_inode2v9ses(dentry->d_inode);
 	fid = v9fs_fid_lookup(dentry);
-	if(IS_ERR(fid))
+	if (IS_ERR(fid))
 		return PTR_ERR(fid);
 
 	if (!v9fs_extended(v9ses))
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
