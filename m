Return-Path: <linux-kernel-owner+w=401wt.eu-S1422895AbXCGRbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422895AbXCGRbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422892AbXCGRbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:31:41 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:58887 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965555AbXCGRbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:31:36 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] epoll use a single inode ...
Date: Wed, 7 Mar 2007 18:31:36 +0100
User-Agent: KMail/1.9.5
Cc: Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
References: <45ED1A3C.6030707@argo.co.il> <45EE6125.3010702@cosmosbay.com> <Pine.LNX.4.64.0703070859070.5963@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703070859070.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_4bv7F1xQGgHoDi8"
Message-Id: <200703071831.36930.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_4bv7F1xQGgHoDi8
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 07 March 2007 18:02, Linus Torvalds wrote:
> On Wed, 7 Mar 2007, Eric Dumazet wrote:
> > I would definitly *love* saving dentries for pipes (and sockets too), but
> > how are you going to get the inode ?
>
> Don't use an inode at all.

Lovely :)

>
> > pipes()/sockets() can use read()/write()/rw_verify_area() and thus need
> > file->f_path.dentry->d_inode (so each pipe needs a separate dentry)
>
> No, at least pipes could easily just use "file->f_private_data" instead.
>
> Now, sockets really do want the inode (or it would be really really big
> changes), but pipes really just want a "struct pipe_inode_info" pointer,
> which we could hide away directly in the file descriptor itself.

sockets already uses file->private_data.

But calls to read()/write() (not send()/recv()) still need to go through the 
dentry, before entering socket land.

>
> That's what Davide already did (on my suggestion) for signalfd - there's a
> *single* inode, and the real data is in the per-fd f_private_data.


Please find enclosed the following patch, to prepare this path.

[PATCH] Delay the dentry name generation on sockets and pipes.

1) Introduces a new method in 'struct dentry_operations'. This method called 
d_dname() might be called from d_path() to be able to provide a dentry name 
for special filesystems. It is called without locks.

Future patches (if we succeed in having one common dentry for all pipes) may 
need to change prototype of this method, but we now use :
char *d_dname(struct dentry *dentry, char *buffer, int buflen)


2) Use this new method for sockets : No more sprintf() at socket creation. 
This is delayed up to the moment someone does an access to /proc/pid/fd/...
We also avoid mntput()/mntget() on sock_mnt

3) Use this new method for pipes : No more sprintf() at pipe creation. This is 
delayed up to the moment someone does an access to /proc/pid/fd/...
We also avoid mntput()/mntget() on pipe_mnt

A benchmark consisting of 1.000.000 calls to pipe()/close()/close() gives a 
*nice* speedup on my Pentium(M) 1.6 Ghz :

3.090 s instead of 3.450 s

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

 fs/dcache.c            |    3 +++
 fs/pipe.c              |   16 +++++++++++-----
 include/linux/dcache.h |    1 +
 net/socket.c           |   15 +++++++++++----
 4 files changed, 26 insertions(+), 9 deletions(-)


--Boundary-00=_4bv7F1xQGgHoDi8
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="introduce_d_dname.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="introduce_d_dname.patch"

--- linux-2.6.21-rc3/include/linux/dcache.h	2007-03-07 17:23:55.000000000 +0100
+++ linux-2.6.21-rc3-ed/include/linux/dcache.h	2007-03-07 17:27:39.000000000 +0100
@@ -133,6 +133,7 @@ struct dentry_operations {
 	int (*d_delete)(struct dentry *);
 	void (*d_release)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
+	char * (*d_dname)(struct dentry *, char *, int);
 };
 
 /* the dentry parameter passed to d_hash and d_compare is the parent
--- linux-2.6.21-rc3/fs/dcache.c	2007-03-07 17:23:55.000000000 +0100
+++ linux-2.6.21-rc3-ed/fs/dcache.c	2007-03-07 17:28:46.000000000 +0100
@@ -1823,6 +1823,9 @@ char * d_path(struct dentry *dentry, str
 	struct vfsmount *rootmnt;
 	struct dentry *root;
 
+	if (dentry->d_op && dentry->d_op->d_dname)
+		return (dentry->d_op->d_dname)(dentry, buf, buflen);
+
 	read_lock(&current->fs->lock);
 	rootmnt = mntget(current->fs->rootmnt);
 	root = dget(current->fs->root);
--- linux-2.6.21-rc3/fs/pipe.c	2007-03-07 17:42:36.000000000 +0100
+++ linux-2.6.21-rc3-ed/fs/pipe.c	2007-03-07 18:01:40.000000000 +0100
@@ -841,8 +841,15 @@ static int pipefs_delete_dentry(struct d
 	return 0;
 }
 
+static char * pipefs_dname(struct dentry *dentry, char *buffer, int buflen)
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
@@ -888,7 +895,6 @@ struct file *create_write_pipe(void)
 	struct inode *inode;
 	struct file *f;
 	struct dentry *dentry;
-	char name[32];
 	struct qstr this;
 
 	f = get_empty_filp();
@@ -899,8 +905,8 @@ struct file *create_write_pipe(void)
 	if (!inode)
 		goto err_file;
 
-	this.len = sprintf(name, "[%lu]", inode->i_ino);
-	this.name = name;
+	this.len = 0;
+	this.name = NULL;
 	this.hash = 0;
 	err = -ENOMEM;
 	dentry = d_alloc(pipe_mnt->mnt_sb->s_root, &this);
@@ -915,7 +921,7 @@ struct file *create_write_pipe(void)
 	 */
 	dentry->d_flags &= ~DCACHE_UNHASHED;
 	d_instantiate(dentry, inode);
-	f->f_path.mnt = mntget(pipe_mnt);
+	f->f_path.mnt = NULL;
 	f->f_path.dentry = dentry;
 	f->f_mapping = inode->i_mapping;
 
@@ -949,7 +955,7 @@ struct file *create_read_pipe(struct fil
 		return ERR_PTR(-ENFILE);
 
 	/* Grab pipe from the writer */
-	f->f_path.mnt = mntget(wrf->f_path.mnt);
+	f->f_path.mnt = NULL;
 	f->f_path.dentry = dget(wrf->f_path.dentry);
 	f->f_mapping = wrf->f_path.dentry->d_inode->i_mapping;
 
--- linux-2.6.21-rc3/net/socket.c	2007-03-07 17:37:56.000000000 +0100
+++ linux-2.6.21-rc3-ed/net/socket.c	2007-03-07 17:54:53.000000000 +0100
@@ -314,8 +314,16 @@ static int sockfs_delete_dentry(struct d
 	dentry->d_flags |= DCACHE_UNHASHED;
 	return 0;
 }
+
+static char * sockfs_dname(struct dentry *dentry, char *buffer, int buflen)
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
@@ -356,10 +364,9 @@ static int sock_alloc_fd(struct file **f
 static int sock_attach_fd(struct socket *sock, struct file *file)
 {
 	struct qstr this;
-	char name[32];
 
-	this.len = sprintf(name, "[%lu]", SOCK_INODE(sock)->i_ino);
-	this.name = name;
+	this.len = 0;
+	this.name = NULL;
 	this.hash = 0;
 
 	file->f_path.dentry = d_alloc(sock_mnt->mnt_sb->s_root, &this);
@@ -374,7 +381,7 @@ static int sock_attach_fd(struct socket 
 	 */
 	file->f_path.dentry->d_flags &= ~DCACHE_UNHASHED;
 	d_instantiate(file->f_path.dentry, SOCK_INODE(sock));
-	file->f_path.mnt = mntget(sock_mnt);
+	file->f_path.mnt = NULL;
 	file->f_mapping = file->f_path.dentry->d_inode->i_mapping;
 
 	sock->file = file;

--Boundary-00=_4bv7F1xQGgHoDi8--
