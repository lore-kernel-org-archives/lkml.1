Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbXCHQ6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbXCHQ6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:58:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbXCHQ6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:58:04 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:50002 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbXCHQ6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:58:03 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] VFS : Delay the dentry name generation on sockets and pipes.
Date: Thu, 8 Mar 2007 17:58:07 +0100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <45ED1A3C.6030707@argo.co.il> <200703081211.20662.dada1@cosmosbay.com> <Pine.LNX.4.64.0703080751490.10832@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703080751490.10832@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_fCE8Ft/h09YgOSv"
Message-Id: <200703081758.07179.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_fCE8Ft/h09YgOSv
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Andrew

Could you please put this final version in mm for testing ?

Thank's to all contributors.

[PATCH] VFS : Delay the dentry name generation on sockets and pipes.

1) Introduces a new method in 'struct dentry_operations'. This method called 
d_dname() might be called from d_path() to build a pathname 
for special filesystems. It is called without locks.

Future patches (if we succeed in having one common dentry for all 
pipes/sockets) may need to change prototype of this method, but we now use :
char *d_dname(struct dentry *dentry, char *buffer, int buflen);


2) Use this new method for sockets : No more sprintf() at socket creation. 
This is delayed up to the moment someone does an access to /proc/pid/fd/...

3) Use this new method for pipes : No more sprintf() at pipe creation. This is 
delayed up to the moment someone does an access to /proc/pid/fd/...

A benchmark consisting of 1.000.000 calls to pipe()/close()/close() gives a 
*nice* speedup on my Pentium(M) 1.6 Ghz :

3.090 s instead of 3.450 s

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>

 Documentation/filesystems/Locking |    2 ++
 Documentation/filesystems/vfs.txt |   12 +++++++++++-
 fs/dcache.c                       |   10 ++++++++++
 fs/pipe.c                         |   15 +++++++++------
 include/linux/dcache.h            |    1 +
 net/socket.c                      |   17 ++++++++++-------
 6 files changed, 43 insertions(+), 14 deletions(-)


--Boundary-00=_fCE8Ft/h09YgOSv
Content-Type: text/plain;
  charset="iso-8859-1";
  name="introduce_d_dname.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="introduce_d_dname.patch"

--- linux-2.6.21-rc3/include/linux/dcache.h	2007-03-07 17:23:55.000000000 +0100
+++ linux-2.6.21-rc3-ed/include/linux/dcache.h	2007-03-08 11:57:41.000000000 +0100
@@ -133,6 +133,7 @@ struct dentry_operations {
 	int (*d_delete)(struct dentry *);
 	void (*d_release)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
+	char *(*d_dname)(struct dentry *, char *, int);
 };
 
 /* the dentry parameter passed to d_hash and d_compare is the parent
--- linux-2.6.21-rc3/Documentation/filesystems/vfs.txt	2007-03-08 10:14:38.000000000 +0100
+++ linux-2.6.21-rc3-ed/Documentation/filesystems/vfs.txt	2007-03-08 12:08:56.000000000 +0100
@@ -827,7 +827,7 @@ This describes how a filesystem can over
 operations. Dentries and the dcache are the domain of the VFS and the
 individual filesystem implementations. Device drivers have no business
 here. These methods may be set to NULL, as they are either optional or
-the VFS uses a default. As of kernel 2.6.13, the following members are
+the VFS uses a default. As of kernel 2.6.22, the following members are
 defined:
 
 struct dentry_operations {
@@ -837,6 +837,7 @@ struct dentry_operations {
 	int (*d_delete)(struct dentry *);
 	void (*d_release)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
+	char *(*d_dname)(struct dentry *, char *, int);
 };
 
   d_revalidate: called when the VFS needs to revalidate a dentry. This
@@ -859,6 +860,15 @@ struct dentry_operations {
 	VFS calls iput(). If you define this method, you must call
 	iput() yourself
 
+  d_dname: called when the pathname of a dentry should be generated.
+	Usefull for some pseudo filesystems (sockfs, pipefs, ...) to delay
+	pathname generation. (Instead of doing it when dentry is created,
+	its done only when the path is needed.). Real filesystems probably
+	dont want to use it, because their dentries are present in global
+	dcache hash, so their hash should be an invariant. As no lock is
+	held, d_dname() should not try to modify the dentry itself, unless
+	appropriate SMP safety is used.
+
 Each dentry has a pointer to its parent dentry, as well as a hash list
 of child dentries. Child dentries are basically like files in a
 directory.
--- linux-2.6.21-rc3/Documentation/filesystems/Locking	2007-03-08 10:29:04.000000000 +0100
+++ linux-2.6.21-rc3-ed/Documentation/filesystems/Locking	2007-03-08 12:08:56.000000000 +0100
@@ -15,6 +15,7 @@ prototypes:
 	int (*d_delete)(struct dentry *);
 	void (*d_release)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
+	char *(*d_dname)((struct dentry *dentry, char *buffer, int buflen);
 
 locking rules:
 	none have BKL
@@ -25,6 +26,7 @@ d_compare:	no		yes		no		no 
 d_delete:	yes		no		yes		no
 d_release:	no		no		no		yes
 d_iput:		no		no		no		yes
+d_dname:	no		no		no		no
 
 --------------------------- inode_operations --------------------------- 
 prototypes:
--- linux-2.6.21-rc3/fs/dcache.c	2007-03-07 17:23:55.000000000 +0100
+++ linux-2.6.21-rc3-ed/fs/dcache.c	2007-03-08 17:47:04.000000000 +0100
@@ -1823,6 +1823,16 @@ char * d_path(struct dentry *dentry, str
 	struct vfsmount *rootmnt;
 	struct dentry *root;
 
+	/*
+	 * We have various synthetic filesystems that never get mounted.  On
+	 * these filesystems dentries are never used for lookup purposes, and
+	 * thus don't need to be hashed.  They also don't need a name until a
+	 * user wants to identify the object in /proc/*/fd/.  The little hack
+	 * below allows us to generate a name for these objects on demand:
+	 */
+	if (dentry->d_op && dentry->d_op->d_dname)
+		return dentry->d_op->d_dname(dentry, buf, buflen);
+
 	read_lock(&current->fs->lock);
 	rootmnt = mntget(current->fs->rootmnt);
 	root = dget(current->fs->root);
--- linux-2.6.21-rc3/fs/pipe.c	2007-03-07 17:42:36.000000000 +0100
+++ linux-2.6.21-rc3-ed/fs/pipe.c	2007-03-08 17:44:06.000000000 +0100
@@ -841,8 +841,15 @@ static int pipefs_delete_dentry(struct d
 	return 0;
 }
 
+static char *pipefs_dname(struct dentry *dentry, char *buffer, int buflen)
+{
+	snprintf(buffer, buflen, "pipe:[%lu]", dentry->d_inode->i_ino);
+	return buffer;
+}
+
 static struct dentry_operations pipefs_dentry_operations = {
 	.d_delete	= pipefs_delete_dentry,
+	.d_dname	= pipefs_dname,
 };
 
 static struct inode * get_pipe_inode(void)
@@ -888,8 +895,7 @@ struct file *create_write_pipe(void)
 	struct inode *inode;
 	struct file *f;
 	struct dentry *dentry;
-	char name[32];
-	struct qstr this;
+	struct qstr name = { .name = "" };
 
 	f = get_empty_filp();
 	if (!f)
@@ -899,11 +905,8 @@ struct file *create_write_pipe(void)
 	if (!inode)
 		goto err_file;
 
-	this.len = sprintf(name, "[%lu]", inode->i_ino);
-	this.name = name;
-	this.hash = 0;
 	err = -ENOMEM;
-	dentry = d_alloc(pipe_mnt->mnt_sb->s_root, &this);
+	dentry = d_alloc(pipe_mnt->mnt_sb->s_root, &name);
 	if (!dentry)
 		goto err_inode;
 
--- linux-2.6.21-rc3/net/socket.c	2007-03-07 17:37:56.000000000 +0100
+++ linux-2.6.21-rc3-ed/net/socket.c	2007-03-08 11:57:41.000000000 +0100
@@ -314,8 +314,16 @@ static int sockfs_delete_dentry(struct d
 	dentry->d_flags |= DCACHE_UNHASHED;
 	return 0;
 }
+
+static char *sockfs_dname(struct dentry *dentry, char *buffer, int buflen)
+{
+	snprintf(buffer, buflen, "socket:[%lu]", dentry->d_inode->i_ino);
+	return buffer;
+}
+
 static struct dentry_operations sockfs_dentry_operations = {
 	.d_delete = sockfs_delete_dentry,
+	.d_dname  = sockfs_dname,
 };
 
 /*
@@ -355,14 +363,9 @@ static int sock_alloc_fd(struct file **f
 
 static int sock_attach_fd(struct socket *sock, struct file *file)
 {
-	struct qstr this;
-	char name[32];
-
-	this.len = sprintf(name, "[%lu]", SOCK_INODE(sock)->i_ino);
-	this.name = name;
-	this.hash = 0;
+	struct qstr name = { .name = "" };
 
-	file->f_path.dentry = d_alloc(sock_mnt->mnt_sb->s_root, &this);
+	file->f_path.dentry = d_alloc(sock_mnt->mnt_sb->s_root, &name);
 	if (unlikely(!file->f_path.dentry))
 		return -ENOMEM;
 

--Boundary-00=_fCE8Ft/h09YgOSv--
