Return-Path: <linux-kernel-owner+w=401wt.eu-S1751477AbXBMXpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbXBMXpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 18:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbXBMXpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 18:45:52 -0500
Received: from ms-smtp-04.texas.rr.com ([24.93.47.43]:52938 "EHLO
	ms-smtp-04.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbXBMXpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 18:45:51 -0500
From: Eric Van Hensbergen <ericvh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net,
       Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH] 9p: implement optional loose read cache
Date: Tue, 13 Feb 2007 17:45:45 -0600
Message-Id: <1171410345433-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.5.0.rc1.gde38
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While cacheing is generally frowned upon in the 9p world, it has its
place -- particularly in situations where the remote file system is
exclusive and/or read-only.  The vacfs views of venti content addressable
store are a real-world instance of such a situation.  To facilitate higher
performance for these workloads (and eventually use the fscache patches),
we have enabled a "loose" cache mode which does not attempt to maintain
any form of consistency on the page-cache or dcache.  This results in over
two orders of magnitude performance improvement for cacheable block reads
in the Bonnie benchmark.  The more aggressive use of the dcache also seems
to improve metadata operational performance.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 Documentation/filesystems/00-INDEX |    4 ++--
 Documentation/filesystems/9p.txt   |    4 ++++
 fs/9p/fid.c                        |    3 ++-
 fs/9p/v9fs.c                       |    9 ++++++++-
 fs/9p/v9fs.h                       |    9 ++++++++-
 fs/9p/v9fs_vfs.h                   |    2 ++
 fs/9p/vfs_addr.c                   |    2 ++
 fs/9p/vfs_dentry.c                 |   26 ++++++++++++++++++++++++++
 fs/9p/vfs_file.c                   |   18 ++++++++++++++++++
 fs/9p/vfs_inode.c                  |   20 ++++++++++++++++----
 10 files changed, 88 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
index 4dc28cc..5717858 100644
--- a/Documentation/filesystems/00-INDEX
+++ b/Documentation/filesystems/00-INDEX
@@ -4,6 +4,8 @@ Exporting
 	- explanation of how to make filesystems exportable.
 Locking
 	- info on locking rules as they pertain to Linux VFS.
+9p.txt
+	- 9p (v9fs) is an implementation of the Plan 9 remote fs protocol.
 adfs.txt
 	- info and mount options for the Acorn Advanced Disc Filing System.
 afs.txt
@@ -82,8 +84,6 @@ udf.txt
 	- info and mount options for the UDF filesystem.
 ufs.txt
 	- info on the ufs filesystem.
-v9fs.txt
-	- v9fs is a Unix implementation of the Plan 9 9p remote fs protocol.
 vfat.txt
 	- info on using the VFAT filesystem used in Windows NT and Windows 95
 vfs.txt
diff --git a/Documentation/filesystems/9p.txt b/Documentation/filesystems/9p.txt
index 4d075a4..bbd8b28 100644
--- a/Documentation/filesystems/9p.txt
+++ b/Documentation/filesystems/9p.txt
@@ -40,6 +40,10 @@ OPTIONS
   aname=name	aname specifies the file tree to access when the server is
   		offering several exported file systems.
 
+  cache=mode	specifies a cacheing policy.  By default, no caches are used.
+			loose = no attempts are made at consistency,
+                                intended for exclusive, read-only mounts
+
   debug=n	specifies debug level.  The debug level is a bitmask.
   			0x01 = display verbose error messages
 			0x02 = developer debug (DEBUG_CURRENT)
diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index a9b6301..9041971 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -136,7 +136,8 @@ struct v9fs_fid *v9fs_fid_lookup(struct 
 }
 
 /**
- * v9fs_fid_clone - lookup the fid for a dentry, clone a private copy and release it
+ * v9fs_fid_clone - lookup the fid for a dentry, clone a private copy and
+ * 			release it
  * @dentry: dentry to look for fid in
  *
  * find a fid in the dentry and then clone to a new private fid
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index d9b561b..6ad6f19 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -53,6 +53,8 @@ enum {
 	Opt_uname, Opt_remotename,
 	/* Options that take no arguments */
 	Opt_legacy, Opt_nodevmap, Opt_unix, Opt_tcp, Opt_fd,
+	/* Cache options */
+	Opt_cache_loose,
 	/* Error token */
 	Opt_err
 };
@@ -76,6 +78,8 @@ static match_table_t tokens = {
 	{Opt_fd, "fd"},
 	{Opt_legacy, "noextend"},
 	{Opt_nodevmap, "nodevmap"},
+	{Opt_cache_loose, "cache=loose"},
+	{Opt_cache_loose, "loose"},
 	{Opt_err, NULL}
 };
 
@@ -106,6 +110,7 @@ static void v9fs_parse_options(char *opt
 	v9ses->debug = 0;
 	v9ses->rfdno = ~0;
 	v9ses->wfdno = ~0;
+	v9ses->cache = 0;
 
 	if (!options)
 		return;
@@ -121,7 +126,6 @@ static void v9fs_parse_options(char *opt
 					"integer field, but no integer?\n");
 				continue;
 			}
-
 		}
 		switch (token) {
 		case Opt_port:
@@ -169,6 +173,9 @@ static void v9fs_parse_options(char *opt
 		case Opt_nodevmap:
 			v9ses->nodev = 1;
 			break;
+		case Opt_cache_loose:
+			v9ses->cache = CACHE_LOOSE;
+			break;
 		default:
 			continue;
 		}
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index c134d10..820bf5c 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -47,7 +47,7 @@ struct v9fs_session_info {
 	unsigned int afid;	/* authentication fid */
 	unsigned int rfdno;	/* read file descriptor number */
 	unsigned int wfdno;	/* write file descriptor number */
-
+	unsigned int cache;	/* cache mode */
 
 	char *name;		/* user name to mount as */
 	char *remotename;	/* name of remote hierarchy being mounted */
@@ -73,6 +73,13 @@ enum {
 	PROTO_FD,
 };
 
+/* possible values of ->cache */
+/* eventually support loose, tight, time, session, default always none */
+enum {
+	CACHE_NONE,		/* default */
+	CACHE_LOOSE,		/* no consistency */
+};
+
 extern struct dentry *v9fs_debugfs_root;
 
 int v9fs_session_init(struct v9fs_session_info *, const char *, char *);
diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index 450b0c1..8ada4c5 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -40,8 +40,10 @@
 extern struct file_system_type v9fs_fs_type;
 extern const struct address_space_operations v9fs_addr_operations;
 extern const struct file_operations v9fs_file_operations;
+extern const struct file_operations v9fs_cached_file_operations;
 extern const struct file_operations v9fs_dir_operations;
 extern struct dentry_operations v9fs_dentry_operations;
+extern struct dentry_operations v9fs_cached_dentry_operations;
 
 struct inode *v9fs_get_inode(struct super_block *sb, int mode);
 ino_t v9fs_qid2ino(struct v9fs_qid *qid);
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index cc24abf..bed48fa 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -63,6 +63,8 @@ static int v9fs_vfs_readpage(struct file
 	int total = 0;
 	int result = 0;
 
+	dprintk(DEBUG_VFS, "\n");
+
 	buffer = kmap(page);
 	do {
 		if (count < rsize)
diff --git a/fs/9p/vfs_dentry.c b/fs/9p/vfs_dentry.c
index 062daa6..ddffd8a 100644
--- a/fs/9p/vfs_dentry.c
+++ b/fs/9p/vfs_dentry.c
@@ -53,10 +53,31 @@ #include "fid.h"
 static int v9fs_dentry_delete(struct dentry *dentry)
 {
 	dprintk(DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+
 	return 1;
 }
 
 /**
+ * v9fs_cached_dentry_delete - called when dentry refcount equals 0
+ * @dentry:  dentry in question
+ *
+ * Only return 1 if our inode is invalid.  Only non-synthetic files
+ * (ones without mtime == 0) should be calling this function.
+ *
+ */
+
+static int v9fs_cached_dentry_delete(struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	dprintk(DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+
+	if(!inode)
+		return 1;
+
+	return 0;
+}
+
+/**
  * v9fs_dentry_release - called when dentry is going to be freed
  * @dentry:  dentry that is being release
  *
@@ -87,6 +108,11 @@ void v9fs_dentry_release(struct dentry *
 	}
 }
 
+struct dentry_operations v9fs_cached_dentry_operations = {
+	.d_delete = v9fs_cached_dentry_delete,
+	.d_release = v9fs_dentry_release,
+};
+
 struct dentry_operations v9fs_dentry_operations = {
 	.d_delete = v9fs_dentry_delete,
 	.d_release = v9fs_dentry_release,
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 6c78343..653dfa5 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -79,6 +79,13 @@ int v9fs_file_open(struct inode *inode, 
 	vfid->filp = file;
 	kfree(fcall);
 
+	if((vfid->qid.version) && (v9ses->cache)) {
+		dprintk(DEBUG_VFS, "cached");
+		/* enable cached file options */
+		if(file->f_op == &v9fs_file_operations)
+			file->f_op = &v9fs_cached_file_operations;
+	}
+
 	return 0;
 
 Clunk_Fid:
@@ -238,6 +245,17 @@ v9fs_file_write(struct file *filp, const
 	return total;
 }
 
+const struct file_operations v9fs_cached_file_operations = {
+	.llseek = generic_file_llseek,
+	.read = do_sync_read,
+	.aio_read = generic_file_aio_read,
+	.write = v9fs_file_write,
+	.open = v9fs_file_open,
+	.release = v9fs_dir_release,
+	.lock = v9fs_file_lock,
+	.mmap = generic_file_mmap,
+};
+
 const struct file_operations v9fs_file_operations = {
 	.llseek = generic_file_llseek,
 	.read = v9fs_file_read,
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 5cf2213..124a085 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -504,7 +504,10 @@ v9fs_vfs_create(struct inode *dir, struc
 		goto error;
 	}
 
-	dentry->d_op = &v9fs_dentry_operations;
+	if(v9ses->cache)
+		dentry->d_op = &v9fs_cached_dentry_operations;
+	else
+		dentry->d_op = &v9fs_dentry_operations;
 	d_instantiate(dentry, inode);
 
 	if (nd && nd->flags & LOOKUP_OPEN) {
@@ -589,7 +592,10 @@ static int v9fs_vfs_mkdir(struct inode *
 		goto error;
 	}
 
-	dentry->d_op = &v9fs_dentry_operations;
+	if(v9ses->cache)
+		dentry->d_op = &v9fs_cached_dentry_operations;
+	else
+		dentry->d_op = &v9fs_dentry_operations;
 	d_instantiate(dentry, inode);
 	return 0;
 
@@ -626,7 +632,6 @@ static struct dentry *v9fs_vfs_lookup(st
 
 	sb = dir->i_sb;
 	v9ses = v9fs_inode2v9ses(dir);
-	dentry->d_op = &v9fs_dentry_operations;
 	dirfid = v9fs_fid_lookup(dentry->d_parent);
 
 	if(IS_ERR(dirfid))
@@ -697,6 +702,10 @@ static struct dentry *v9fs_vfs_lookup(st
 
 	fid->qid = fcall->params.rstat.stat.qid;
 	v9fs_stat2inode(&fcall->params.rstat.stat, inode, inode->i_sb);
+	if((fid->qid.version)&&(v9ses->cache))
+		dentry->d_op = &v9fs_cached_dentry_operations;
+	else
+		dentry->d_op = &v9fs_dentry_operations;
 
 	d_add(dentry, inode);
 	kfree(fcall);
@@ -1184,7 +1193,10 @@ static int v9fs_vfs_mkspecial(struct ino
 		goto free_vfid;
 	}
 
-	dentry->d_op = &v9fs_dentry_operations;
+	if(v9ses->cache)
+		dentry->d_op = &v9fs_cached_dentry_operations;
+	else
+		dentry->d_op = &v9fs_dentry_operations;
 	d_instantiate(dentry, inode);
 	return 0;
 
-- 
1.4.1

