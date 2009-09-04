Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbZIDHDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbZIDHDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932760AbZIDHAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:00:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:56568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932803AbZIDG6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:58:43 -0400
Message-Id: <20090904065539.239315813@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 04 Sep 2009 16:52:14 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 33/33] fs: improve scalability of pseudo filesystems
References: <20090904065142.114706411@nick.local0.net>
Content-Disposition: inline; filename=fs-scale-pseudo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regardless of how much we possibly try to scale dcache, there is likely
always going to be some fundamental contention when adding or removing children
under the same parent. Pseudo filesystems do not seem need to have connected
dentries because by definition they are disconnected.

XXX: is this right? I can't see any reason why they need to have a real
parent.

TODO: add a d_instantiate_something() and avoid adding the extra checks
for !d_parent
---
 fs/anon_inodes.c                 |    2 +-
 fs/notify/inotify/inotify.c      |    2 +-
 fs/pipe.c                        |    2 +-
 include/linux/fsnotify_backend.h |    2 +-
 net/socket.c                     |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -268,7 +268,7 @@ void inotify_d_instantiate(struct dentry
 {
 	struct dentry *parent;
 
-	if (!inode)
+	if (!inode || !entry->d_parent)
 		return;
 
 	/* XXX: need parent lock in place of dcache_lock? */
Index: linux-2.6/include/linux/fsnotify_backend.h
===================================================================
--- linux-2.6.orig/include/linux/fsnotify_backend.h
+++ linux-2.6/include/linux/fsnotify_backend.h
@@ -291,7 +291,7 @@ static inline void __fsnotify_update_dca
  */
 static inline void __fsnotify_d_instantiate(struct dentry *dentry, struct inode *inode)
 {
-	if (!inode)
+	if (!inode || !dentry->d_parent)
 		return;
 
 	spin_lock(&dentry->d_lock);
Index: linux-2.6/net/socket.c
===================================================================
--- linux-2.6.orig/net/socket.c
+++ linux-2.6/net/socket.c
@@ -367,7 +367,7 @@ static int sock_attach_fd(struct socket
 	struct dentry *dentry;
 	struct qstr name = { .name = "" };
 
-	dentry = d_alloc(sock_mnt->mnt_sb->s_root, &name);
+	dentry = d_alloc(NULL, &name);
 	if (unlikely(!dentry))
 		return -ENOMEM;
 
Index: linux-2.6/fs/anon_inodes.c
===================================================================
--- linux-2.6.orig/fs/anon_inodes.c
+++ linux-2.6/fs/anon_inodes.c
@@ -95,7 +95,7 @@ int anon_inode_getfd(const char *name, c
 	this.name = name;
 	this.len = strlen(name);
 	this.hash = 0;
-	dentry = d_alloc(anon_inode_mnt->mnt_sb->s_root, &this);
+	dentry = d_alloc(NULL, &this);
 	if (!dentry)
 		goto err_put_unused_fd;
 
Index: linux-2.6/fs/pipe.c
===================================================================
--- linux-2.6.orig/fs/pipe.c
+++ linux-2.6/fs/pipe.c
@@ -952,7 +952,7 @@ struct file *create_write_pipe(int flags
 		goto err;
 
 	err = -ENOMEM;
-	dentry = d_alloc(pipe_mnt->mnt_sb->s_root, &name);
+	dentry = d_alloc(NULL, &name);
 	if (!dentry)
 		goto err_inode;
 


