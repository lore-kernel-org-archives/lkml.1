Return-Path: <linux-kernel-owner+w=401wt.eu-S934575AbZJOGFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934575AbZJOGFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934526AbZJOGFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:05:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:35366 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933941AbZJOGE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:04:57 -0400
Message-Id: <20091015050048.435915481@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Thu, 15 Oct 2009 15:40:29 +1100
From: npiggin@suse.de
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [patch 3/6] fs: dcache remove d_mounted
References: <20091015044026.319860788@suse.de>
Content-Disposition: inline; filename=fs-dcache-remove-d_mounted.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than keep a d_mounted count in the dentry (which is only used to
speculatively take a look in the mount hash table if it is non-zero), set a
dentry flag instead. The flag can be cleared by checking the hash table to see
if there are any mounts left. It is not time critical because it is performed
at detach time.

This saves 4 bytes on 32-bit, nothing on 64-bit but it does provide a hole I
might use later (and some configs have larger than 32-bit spinlocks which might
make use of the hole).

Autofs4 conversion and changelog by Ian Kent <raven@themaw.net>:
In autofs4, when expring direct (or offset) mounts we need to ensure that we
block user path walks into the autofs mount, which is covered by another mount.
To do this we clear the mounted status so that follows stop before walking into
the mount and are essentially blocked until the expire is completed. The
automount daemon still finds the correct dentry for the umount due to the
follow mount logic in fs/autofs4/root.c:autofs4_follow_link(), which is set as
an inode operation for direct and offset mounts only and is called following
the lookup that stopped at the covered mount.

At the end of the expire the covering mount probably has gone away so the
mounted status need not be restored. But we need to check this and only restore
the mounted status if the expire failed.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/autofs4/expire.c    |   13 +++++++++++--
 fs/dcache.c            |    1 -
 fs/namespace.c         |   17 ++++++++++++++---
 include/linux/dcache.h |   42 +++++++++++++++++++++---------------------
 4 files changed, 46 insertions(+), 27 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -947,7 +947,6 @@ struct dentry *d_alloc(struct dentry * p
 	dentry->d_sb = NULL;
 	dentry->d_op = NULL;
 	dentry->d_fsdata = NULL;
-	dentry->d_mounted = 0;
 	INIT_HLIST_NODE(&dentry->d_hash);
 	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c
+++ linux-2.6/fs/namespace.c
@@ -467,6 +467,15 @@ static void __touch_mnt_namespace(struct
 	}
 }
 
+static void dentry_reset_mounted(struct vfsmount *mnt, struct dentry *dentry)
+{
+	if (!__lookup_mnt(mnt, dentry, 0)) {
+		spin_lock(&dentry->d_lock);
+		dentry->d_flags &= ~DCACHE_MOUNTED;
+		spin_unlock(&dentry->d_lock);
+	}
+}
+
 static void detach_mnt(struct vfsmount *mnt, struct path *old_path)
 {
 	old_path->dentry = mnt->mnt_mountpoint;
@@ -475,7 +484,7 @@ static void detach_mnt(struct vfsmount *
 	mnt->mnt_mountpoint = mnt->mnt_root;
 	list_del_init(&mnt->mnt_child);
 	list_del_init(&mnt->mnt_hash);
-	old_path->dentry->d_mounted--;
+	dentry_reset_mounted(old_path->mnt, old_path->dentry);
 }
 
 void mnt_set_mountpoint(struct vfsmount *mnt, struct dentry *dentry,
@@ -483,7 +492,9 @@ void mnt_set_mountpoint(struct vfsmount
 {
 	child_mnt->mnt_parent = mntget(mnt);
 	child_mnt->mnt_mountpoint = dget(dentry);
-	dentry->d_mounted++;
+	spin_lock(&dentry->d_lock);
+	dentry->d_flags |= DCACHE_MOUNTED;
+	spin_unlock(&dentry->d_lock);
 }
 
 static void attach_mnt(struct vfsmount *mnt, struct path *path)
@@ -1015,7 +1026,7 @@ void umount_tree(struct vfsmount *mnt, i
 		list_del_init(&p->mnt_child);
 		if (p->mnt_parent != p) {
 			p->mnt_parent->mnt_ghosts++;
-			p->mnt_mountpoint->d_mounted--;
+			dentry_reset_mounted(p->mnt_parent, p->mnt_mountpoint);
 		}
 		change_mnt_propagation(p, MS_PRIVATE);
 	}
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -83,14 +83,13 @@ full_name_hash(const unsigned char *name
 #ifdef CONFIG_64BIT
 #define DNAME_INLINE_LEN_MIN 32 /* 192 bytes */
 #else
-#define DNAME_INLINE_LEN_MIN 40 /* 128 bytes */
+#define DNAME_INLINE_LEN_MIN 44 /* 128 bytes */
 #endif
 
 struct dentry {
 	atomic_t d_count;
 	unsigned int d_flags;		/* protected by d_lock */
 	spinlock_t d_lock;		/* per dentry lock */
-	int d_mounted;
 	struct inode *d_inode;		/* Where the name belongs to - NULL is
 					 * negative */
 	/*
@@ -161,30 +160,31 @@ d_iput:		no		no		no       yes
 
 /* d_flags entries */
 #define DCACHE_AUTOFS_PENDING 0x0001    /* autofs: "under construction" */
-#define DCACHE_NFSFS_RENAMED  0x0002    /* this dentry has been "silly
-					 * renamed" and has to be
-					 * deleted on the last dput()
-					 */
-#define	DCACHE_DISCONNECTED 0x0004
-     /* This dentry is possibly not currently connected to the dcache tree,
-      * in which case its parent will either be itself, or will have this
-      * flag as well.  nfsd will not use a dentry with this bit set, but will
-      * first endeavour to clear the bit either by discovering that it is
-      * connected, or by performing lookup operations.   Any filesystem which
-      * supports nfsd_operations MUST have a lookup function which, if it finds
-      * a directory inode with a DCACHE_DISCONNECTED dentry, will d_move
-      * that dentry into place and return that dentry rather than the passed one,
-      * typically using d_splice_alias.
-      */
+#define DCACHE_NFSFS_RENAMED  0x0002
+     /* this dentry has been "silly renamed" and has to be deleted on the last
+      * dput() */
+
+#define	DCACHE_DISCONNECTED	0x0004
+     /* This dentry is possibly not currently connected to the dcache tree, in
+      * which case its parent will either be itself, or will have this flag as
+      * well.  nfsd will not use a dentry with this bit set, but will first
+      * endeavour to clear the bit either by discovering that it is connected,
+      * or by performing lookup operations.   Any filesystem which supports
+      * nfsd_operations MUST have a lookup function which, if it finds a
+      * directory inode with a DCACHE_DISCONNECTED dentry, will d_move that
+      * dentry into place and return that dentry rather than the passed one,
+      * typically using d_splice_alias. */
 
 #define DCACHE_REFERENCED	0x0008  /* Recently used, don't discard. */
 #define DCACHE_UNHASHED		0x0010	
-
-#define DCACHE_INOTIFY_PARENT_WATCHED	0x0020 /* Parent inode is watched by inotify */
+#define DCACHE_INOTIFY_PARENT_WATCHED 0x0020
+     /* Parent inode is watched by inotify */
 
 #define DCACHE_COOKIE		0x0040	/* For use by dcookie subsystem */
+#define DCACHE_FSNOTIFY_PARENT_WATCHED 0x0080
+     /* Parent inode is watched by some fsnotify listener */
 
-#define DCACHE_FSNOTIFY_PARENT_WATCHED	0x0080 /* Parent inode is watched by some fsnotify listener */
+#define DCACHE_MOUNTED		0x0100	/* is a mountpoint */
 
 extern spinlock_t dcache_lock;
 extern seqlock_t rename_lock;
@@ -372,7 +372,7 @@ extern void dput(struct dentry *);
 
 static inline int d_mountpoint(struct dentry *dentry)
 {
-	return dentry->d_mounted;
+	return dentry->d_flags & DCACHE_MOUNTED;
 }
 
 extern struct vfsmount *lookup_mnt(struct path *);
Index: linux-2.6/fs/autofs4/expire.c
===================================================================
--- linux-2.6.orig/fs/autofs4/expire.c
+++ linux-2.6/fs/autofs4/expire.c
@@ -276,7 +276,9 @@ struct dentry *autofs4_expire_direct(str
 		struct autofs_info *ino = autofs4_dentry_ino(root);
 		if (d_mountpoint(root)) {
 			ino->flags |= AUTOFS_INF_MOUNTPOINT;
-			root->d_mounted--;
+			spin_lock(&root->d_lock);
+			root->d_flags &= ~DCACHE_MOUNTED;
+			spin_unlock(&root->d_lock);
 		}
 		ino->flags |= AUTOFS_INF_EXPIRING;
 		init_completion(&ino->expire_complete);
@@ -499,7 +501,14 @@ int autofs4_do_expire_multi(struct super
 
 		spin_lock(&sbi->fs_lock);
 		if (ino->flags & AUTOFS_INF_MOUNTPOINT) {
-			sb->s_root->d_mounted++;
+			spin_lock(&sb->s_root->d_lock);
+			/*
+			 * If we haven't been expired away, then reset
+			 * mounted status.
+			 */
+			if (mnt->mnt_parent != mnt)
+				sb->s_root->d_flags |= DCACHE_MOUNTED;
+			spin_unlock(&sb->s_root->d_lock);
 			ino->flags &= ~AUTOFS_INF_MOUNTPOINT;
 		}
 		ino->flags &= ~AUTOFS_INF_EXPIRING;


