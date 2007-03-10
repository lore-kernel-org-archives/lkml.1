Return-Path: <linux-kernel-owner+w=401wt.eu-S2992672AbXCJBVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992672AbXCJBVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 20:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993156AbXCJBVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 20:21:42 -0500
Received: from sp604003mt.neufgp.fr ([84.96.92.56]:51312 "EHLO smTp.neuf.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992672AbXCJBVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 20:21:40 -0500
Date: Sat, 10 Mar 2007 02:21:32 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
Subject: [PATCH, take3] VFS : Delay the dentry name generation on sockets and
 pipes.
In-reply-to: <200703091118.58990.dada1@cosmosbay.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200703100221.32894.dada1@cosmosbay.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_WtTKCCAEwmqnAfOukjxmsA)"
References: <45ED1A3C.6030707@argo.co.il>
 <200703081929.58265.dada1@cosmosbay.com>
 <200703091118.58990.dada1@cosmosbay.com>
User-Agent: KMail/1.9.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Boundary_(ID_WtTKCCAEwmqnAfOukjxmsA)
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline

Hi Andrew

Please find take3 of this patch : Linus suggested to introduce a helper 
function to factorize work done by most d_dname() implementations.

Thank you

[PATCH] VFS : Delay the dentry name generation on sockets and pipes.

1) Introduces a new method in 'struct dentry_operations'. This method called 
d_dname() might be called from d_path() to build a pathname 
for special filesystems. It is called without locks.

Future patches (if we succeed in having one common dentry for all 
pipes/sockets) may need to change prototype of this method, but we now use :
char *d_dname(struct dentry *dentry, char *buffer, int buflen);

2) Adds a dynamic_dname() helper function that eases d_dname() implementations

3) Defines d_dname method for sockets : No more sprintf() at socket creation. 
This is delayed up to the moment someone does an access to /proc/pid/fd/...

4) Defines d_dname method for pipes : No more sprintf() at pipe creation.
This is delayed up to the moment someone does an access to /proc/pid/fd/...

A benchmark consisting of 1.000.000 calls to pipe()/close()/close() gives a 
*nice* speedup on my Pentium(M) 1.6 Ghz :

3.090 s instead of 3.450 s

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>

--Boundary_(ID_WtTKCCAEwmqnAfOukjxmsA)
Content-type: text/plain; charset=utf-8; name=introduce_d_dname_3.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=introduce_d_dname_3.patch

--- linux-2.6.21-rc3/include/linux/dcache.h	2007-03-07 17:23:55.000000000 +0100
+++ linux-2.6.21-rc3-ed/include/linux/dcache.h	2007-03-09 20:08:36.000000000 +0100
@@ -133,6 +133,7 @@ struct dentry_operations {
 	int (*d_delete)(struct dentry *);
 	void (*d_release)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
+	char *(*d_dname)(struct dentry *, char *, int);
 };
 
 /* the dentry parameter passed to d_hash and d_compare is the parent
@@ -293,6 +294,11 @@ extern struct dentry * d_hash_and_lookup
 /* validate "insecure" dentry pointer */
 extern int d_validate(struct dentry *, struct dentry *);
 
+/*
+ * helper function for dentry_operations.d_dname() members
+ */
+extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
+
 extern char * d_path(struct dentry *, struct vfsmount *, char *, int);
   
 /* Allocation counts.. */
--- linux-2.6.21-rc3/Documentation/filesystems/vfs.txt	2007-03-08 10:14:38.000000000 +0100
+++ linux-2.6.21-rc3-ed/Documentation/filesystems/vfs.txt	2007-03-09 20:08:36.000000000 +0100
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
@@ -859,6 +860,26 @@ struct dentry_operations {
 	VFS calls iput(). If you define this method, you must call
 	iput() yourself
 
+  d_dname: called when the pathname of a dentry should be generated.
+	Usefull for some pseudo filesystems (sockfs, pipefs, ...) to delay
+	pathname generation. (Instead of doing it when dentry is created,
+	its done only when the path is needed.). Real filesystems probably
+	dont want to use it, because their dentries are present in global
+	dcache hash, so their hash should be an invariant. As no lock is
+	held, d_dname() should not try to modify the dentry itself, unless
+	appropriate SMP safety is used. CAUTION : d_path() logic is quite
+	tricky. The correct way to return for example "Hello" is to put it
+	at the end of the buffer, and returns a pointer to the first char.
+	dynamic_dname() helper function is provided to take care of this.
+
+Example :
+
+static char *pipefs_dname(struct dentry *dent, char *buffer, int buflen)
+{
+	return dynamic_dname(dentry, buffer, buflen, "pipe:[%lu]",
+				dentry->d_inode->i_ino);
+}
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
+++ linux-2.6.21-rc3-ed/fs/dcache.c	2007-03-09 20:12:26.000000000 +0100
@@ -1823,6 +1823,16 @@ char * d_path(struct dentry *dentry, str
 	struct vfsmount *rootmnt;
 	struct dentry *root;
 
+	/*
+	 * We have various synthetic filesystems that never get mounted.  On
+	 * these filesystems dentries are never used for lookup purposes, and
+	 * thus don't need to be hashed.  They also don't need a name until a
+	 * user wants to identify the object in /proc/pid/fd/.  The little hack
+	 * below allows us to generate a name for these objects on demand:
+	 */
+	if (dentry->d_op && dentry->d_op->d_dname)
+		return dentry->d_op->d_dname(dentry, buf, buflen);
+
 	read_lock(&current->fs->lock);
 	rootmnt = mntget(current->fs->rootmnt);
 	root = dget(current->fs->root);
@@ -1836,6 +1846,27 @@ char * d_path(struct dentry *dentry, str
 }
 
 /*
+ * Helper function for dentry_operations.d_dname() members
+ */
+char *dynamic_dname(struct dentry *dentry, char *buffer, int buflen,
+			const char *fmt, ...)
+{
+	va_list args;
+	char temp[64];
+	int sz;
+
+	va_start(args, fmt);
+	sz = vsnprintf(temp, sizeof(temp), fmt, args) + 1;
+	va_end(args);
+
+	if (sz > sizeof(temp) || sz > buflen)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	buffer += buflen - sz;
+	return memcpy(buffer, temp, sz);
+}
+
+/*
  * NOTE! The user-level library version returns a
  * character pointer. The kernel system call just
  * returns the length of the buffer filled (which
--- linux-2.6.21-rc3/fs/pipe.c	2007-03-07 17:42:36.000000000 +0100
+++ linux-2.6.21-rc3-ed/fs/pipe.c	2007-03-09 19:58:22.000000000 +0100
@@ -841,8 +841,18 @@ static int pipefs_delete_dentry(struct d
 	return 0;
 }
 
+/*
+ * pipefs_dname() is called from d_path().
+ */
+static char *pipefs_dname(struct dentry *dentry, char *buffer, int buflen)
+{
+	return dynamic_dname(dentry, buffer, buflen, "pipe:[%lu]",
+				dentry->d_inode->i_ino);
+}
+
 static struct dentry_operations pipefs_dentry_operations = {
 	.d_delete	= pipefs_delete_dentry,
+	.d_dname	= pipefs_dname,
 };
 
 static struct inode * get_pipe_inode(void)
@@ -888,8 +898,7 @@ struct file *create_write_pipe(void)
 	struct inode *inode;
 	struct file *f;
 	struct dentry *dentry;
-	char name[32];
-	struct qstr this;
+	struct qstr name = { .name = "" };
 
 	f = get_empty_filp();
 	if (!f)
@@ -899,11 +908,8 @@ struct file *create_write_pipe(void)
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
+++ linux-2.6.21-rc3-ed/net/socket.c	2007-03-09 19:58:22.000000000 +0100
@@ -314,8 +314,19 @@ static int sockfs_delete_dentry(struct d
 	dentry->d_flags |= DCACHE_UNHASHED;
 	return 0;
 }
+
+/*
+ * sockfs_dname() is called from d_path().
+ */
+static char *sockfs_dname(struct dentry *dentry, char *buffer, int buflen)
+{
+	return dynamic_dname(dentry, buffer, buflen, "socket:[%lu]",
+				dentry->d_inode->i_ino);
+}
+
 static struct dentry_operations sockfs_dentry_operations = {
 	.d_delete = sockfs_delete_dentry,
+	.d_dname  = sockfs_dname,
 };
 
 /*
@@ -355,14 +366,9 @@ static int sock_alloc_fd(struct file **f
 
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
 

--Boundary_(ID_WtTKCCAEwmqnAfOukjxmsA)--
