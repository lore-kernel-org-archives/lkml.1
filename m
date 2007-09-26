Return-Path: <linux-kernel-owner+w=401wt.eu-S1760889AbXIZOYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889AbXIZOYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759106AbXIZOWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:22:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254AbXIZOWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:22:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/24] CRED: Fix up the other credentials references
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 26 Sep 2007 15:21:25 +0100
Message-ID: <20070926142125.2656.46272.stgit@warthog.procyon.org.uk>
In-Reply-To: <20070926142059.2656.27100.stgit@warthog.procyon.org.uk>
References: <20070926142059.2656.27100.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the other credentials references to use the new COW cred struct.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/ia64/ia32/sys_ia32.c                 |    7 ++--
 arch/ia64/kernel/perfmon.c                |    2 -
 arch/powerpc/platforms/cell/spufs/inode.c |    2 -
 arch/s390/kernel/compat_linux.c           |   18 +++-------
 arch/sparc64/kernel/sys_sparc32.c         |   18 +++-------
 drivers/isdn/capi/capifs.c                |    4 +-
 drivers/usb/core/inode.c                  |    2 -
 fs/9p/vfs_inode.c                         |    4 +-
 fs/9p/vfs_super.c                         |    4 +-
 fs/affs/inode.c                           |    4 +-
 fs/bfs/dir.c                              |    4 +-
 fs/cifs/cifsproto.h                       |    2 +
 fs/cifs/dir.c                             |   12 +++---
 fs/cifs/inode.c                           |    8 ++--
 fs/cifs/misc.c                            |    4 +-
 fs/coda/cache.c                           |    6 ++-
 fs/coda/file.c                            |    2 +
 fs/coda/upcall.c                          |    4 +-
 fs/ext2/balloc.c                          |    2 +
 fs/ext2/ialloc.c                          |    4 +-
 fs/ext4/balloc.c                          |    2 +
 fs/ext4/ialloc.c                          |    4 +-
 fs/fuse/dev.c                             |    4 +-
 fs/gfs2/inode.c                           |   10 +++--
 fs/hfs/inode.c                            |    4 +-
 fs/hfsplus/inode.c                        |    4 +-
 fs/hpfs/namei.c                           |   24 ++++++-------
 fs/hugetlbfs/inode.c                      |   16 ++++-----
 fs/jffs2/fs.c                             |    4 +-
 fs/jfs/jfs_inode.c                        |    4 +-
 fs/minix/bitmap.c                         |    4 +-
 fs/nfsd/auth.c                            |   32 +++++++++++------
 fs/nfsd/nfs4callback.c                    |   16 +++++----
 fs/nfsd/nfs4recover.c                     |   54 +++++++++++++++--------------
 fs/nfsd/vfs.c                             |    2 +
 fs/ocfs2/dlm/dlmfs.c                      |    4 --
 fs/ocfs2/namei.c                          |    4 +-
 fs/reiserfs/namei.c                       |    3 --
 fs/sysv/ialloc.c                          |    4 +-
 fs/udf/ialloc.c                           |    3 --
 fs/udf/namei.c                            |    1 -
 fs/ufs/ialloc.c                           |    4 +-
 fs/xfs/linux-2.6/xfs_linux.h              |    4 +-
 fs/xfs/xfs_acl.c                          |    6 ++-
 ipc/mqueue.c                              |    4 +-
 kernel/cpuset.c                           |    4 +-
 net/9p/client.c                           |    2 +
 net/ipv4/netfilter/ipt_LOG.c              |    3 +-
 net/ipv4/netfilter/ipt_owner.c            |    4 +-
 net/ipv6/netfilter/ip6t_LOG.c             |    3 +-
 net/ipv6/netfilter/ip6t_owner.c           |    4 +-
 net/netfilter/nfnetlink_log.c             |    2 +
 52 files changed, 167 insertions(+), 189 deletions(-)

diff --git a/arch/ia64/ia32/sys_ia32.c b/arch/ia64/ia32/sys_ia32.c
index a3405b3..8bbed57 100644
--- a/arch/ia64/ia32/sys_ia32.c
+++ b/arch/ia64/ia32/sys_ia32.c
@@ -2088,25 +2088,24 @@ groups16_from_user(struct group_info *group_info, short __user *grouplist)
 asmlinkage long
 sys32_getgroups16 (int gidsetsize, short __user *grouplist)
 {
+	struct group_info *groups = current->cred->group_info;
 	int i;
 
 	if (gidsetsize < 0)
 		return -EINVAL;
 
-	get_group_info(current->group_info);
-	i = current->group_info->ngroups;
+	i = groups->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups16_to_user(grouplist, current->group_info)) {
+		if (groups16_to_user(grouplist, groups)) {
 			i = -EFAULT;
 			goto out;
 		}
 	}
 out:
-	put_group_info(current->group_info);
 	return i;
 }
 
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 14b8e5a..862b7e3 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2212,8 +2212,6 @@ pfm_alloc_fd(struct file **cfile)
 	DPRINT(("new inode ino=%ld @%p\n", inode->i_ino, inode));
 
 	inode->i_mode = S_IFCHR|S_IRUGO;
-	inode->i_uid  = current->fsuid;
-	inode->i_gid  = current->fsgid;
 
 	sprintf(name, "[%lu]", inode->i_ino);
 	this.name = name;
diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index b3d0dd1..dd8b8be 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -84,8 +84,6 @@ spufs_new_inode(struct super_block *sb, int mode)
 		goto out;
 
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
 	inode->i_blocks = 0;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 out:
diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index 5236fdb..a6bf370 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -213,25 +213,19 @@ static int groups16_from_user(struct group_info *group_info, u16 __user *groupli
 
 asmlinkage long sys32_getgroups16(int gidsetsize, u16 __user *grouplist)
 {
+	struct group_info *groups = current->cred->group_info;
 	int i;
 
 	if (gidsetsize < 0)
 		return -EINVAL;
 
-	get_group_info(current->group_info);
-	i = current->group_info->ngroups;
+	i = groups->ngroups;
 	if (gidsetsize) {
-		if (i > gidsetsize) {
-			i = -EINVAL;
-			goto out;
-		}
-		if (groups16_to_user(grouplist, current->group_info)) {
-			i = -EFAULT;
-			goto out;
-		}
+		if (i > gidsetsize)
+			return -EINVAL;
+		if (groups16_to_user(grouplist, groups))
+			return -EFAULT;
 	}
-out:
-	put_group_info(current->group_info);
 	return i;
 }
 
diff --git a/arch/sparc64/kernel/sys_sparc32.c b/arch/sparc64/kernel/sys_sparc32.c
index e8dce90..504e2f7 100644
--- a/arch/sparc64/kernel/sys_sparc32.c
+++ b/arch/sparc64/kernel/sys_sparc32.c
@@ -171,25 +171,19 @@ static int groups16_from_user(struct group_info *group_info, u16 __user *groupli
 
 asmlinkage long sys32_getgroups16(int gidsetsize, u16 __user *grouplist)
 {
+	struct group_info *groups = current->cred->group_info;
 	int i;
 
 	if (gidsetsize < 0)
 		return -EINVAL;
 
-	get_group_info(current->group_info);
-	i = current->group_info->ngroups;
+	i = groups->ngroups;
 	if (gidsetsize) {
-		if (i > gidsetsize) {
-			i = -EINVAL;
-			goto out;
-		}
-		if (groups16_to_user(grouplist, current->group_info)) {
-			i = -EFAULT;
-			goto out;
-		}
+		if (i > gidsetsize)
+			return -EINVAL;
+		if (groups16_to_user(grouplist, groups))
+			return -EFAULT;
 	}
-out:
-	put_group_info(current->group_info);
 	return i;
 }
 
diff --git a/drivers/isdn/capi/capifs.c b/drivers/isdn/capi/capifs.c
index 2dd1b57..1b99663 100644
--- a/drivers/isdn/capi/capifs.c
+++ b/drivers/isdn/capi/capifs.c
@@ -148,8 +148,8 @@ void capifs_new_ncci(unsigned int number, dev_t device)
 	if (!inode)
 		return;
 	inode->i_ino = number+2;
-	inode->i_uid = config.setuid ? config.uid : current->fsuid;
-	inode->i_gid = config.setgid ? config.gid : current->fsgid;
+	inode->i_uid = config.setuid ? config.uid : current->cred->uid;
+	inode->i_gid = config.setgid ? config.gid : current->cred->gid;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	init_special_inode(inode, S_IFCHR|config.mode, device);
 	//inode->i_op = &capifs_file_inode_operations;
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index cd4f111..30aea5b 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -246,8 +246,6 @@ static struct inode *usbfs_get_inode (struct super_block *sb, int mode, dev_t de
 
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
 		inode->i_blocks = 0;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		switch (mode & S_IFMT) {
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index e5c45ee..2766dad 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -202,8 +202,8 @@ struct inode *v9fs_get_inode(struct super_block *sb, int mode)
 	inode = new_inode(sb);
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current->cred->uid;
+		inode->i_gid = current->cred->gid;
 		inode->i_blocks = 0;
 		inode->i_rdev = 0;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index ba90437..fe32357 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -112,8 +112,8 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
 	struct v9fs_session_info *v9ses = NULL;
 	struct p9_stat *st = NULL;
 	int mode = S_IRWXUGO | S_ISVTX;
-	uid_t uid = current->fsuid;
-	gid_t gid = current->fsgid;
+	uid_t uid = current->cred->uid;
+	gid_t gid = current->cred->gid;
 	struct p9_fid *fid;
 	int retval = 0;
 
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 4609a6c..16e3ea1 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -305,8 +305,8 @@ affs_new_inode(struct inode *dir)
 	mark_buffer_dirty_inode(bh, inode);
 	affs_brelse(bh);
 
-	inode->i_uid     = current->fsuid;
-	inode->i_gid     = current->fsgid;
+	inode->i_uid     = current->cred->uid;
+	inode->i_gid     = current->cred->gid;
 	inode->i_ino     = block;
 	inode->i_nlink   = 1;
 	inode->i_mtime   = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 097f149..4ba8198 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -99,8 +99,8 @@ static int bfs_create(struct inode * dir, struct dentry * dentry, int mode,
 	}
 	set_bit(ino, info->si_imap);	
 	info->si_freei--;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = (dir->i_mode & S_ISGID) ? dir->i_gid : current->fsgid;
+	inode->i_uid = current->cred->uid;
+	inode->i_gid = (dir->i_mode & S_ISGID) ? dir->i_gid : current->cred->gid;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	inode->i_blocks = 0;
 	inode->i_op = &bfs_file_inops;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 04a69da..8a79ce3 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -39,7 +39,7 @@ extern int smb_send(struct socket *, struct smb_hdr *,
 			unsigned int /* length */ , struct sockaddr *);
 extern unsigned int _GetXid(void);
 extern void _FreeXid(unsigned int);
-#define GetXid() (int)_GetXid(); cFYI(1,("CIFS VFS: in %s as Xid: %d with uid: %d",__FUNCTION__, xid,current->fsuid));
+#define GetXid() (int)_GetXid(); cFYI(1,("CIFS VFS: in %s as Xid: %d with uid: %d",__FUNCTION__, xid,current->cred->uid));
 #define FreeXid(curr_xid) {_FreeXid(curr_xid); cFYI(1,("CIFS VFS: leaving %s (xid = %d) rc = %d",__FUNCTION__,curr_xid,(int)rc));}
 extern char *build_path_from_dentry(struct dentry *);
 extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 4830acc..f1b6808 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -211,8 +211,8 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 			mode &= ~current->fs->umask;
 			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
 				CIFSSMBUnixSetPerms(xid, pTcon, full_path, mode,
-					(__u64)current->fsuid,
-					(__u64)current->fsgid,
+					(__u64)current->cred->uid,
+					(__u64)current->cred->gid,
 					0 /* dev */,
 					cifs_sb->local_nls,
 					cifs_sb->mnt_cifs_flags &
@@ -246,8 +246,8 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 				if ((oplock & CIFS_CREATE_ACTION) &&
 				    (cifs_sb->mnt_cifs_flags &
 				     CIFS_MOUNT_SET_UID)) {
-					newinode->i_uid = current->fsuid;
-					newinode->i_gid = current->fsgid;
+					newinode->i_uid = current->cred->uid;
+					newinode->i_gid = current->cred->gid;
 				}
 			}
 		}
@@ -340,8 +340,8 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 		mode &= ~current->fs->umask;
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
 			rc = CIFSSMBUnixSetPerms(xid, pTcon, full_path,
-				mode, (__u64)current->fsuid,
-				(__u64)current->fsgid,
+				mode, (__u64)current->cred->uid,
+				(__u64)current->cred->gid,
 				device_number, cifs_sb->local_nls,
 				cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index dd41677..6263591 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1003,8 +1003,8 @@ mkdir_get_info:
 			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
 				CIFSSMBUnixSetPerms(xid, pTcon, full_path,
 						    mode,
-						    (__u64)current->fsuid,
-						    (__u64)current->fsgid,
+						    (__u64)current->cred->uid,
+						    (__u64)current->cred->gid,
 						    0 /* dev_t */,
 						    cifs_sb->local_nls,
 						    cifs_sb->mnt_cifs_flags &
@@ -1027,9 +1027,9 @@ mkdir_get_info:
 				if (cifs_sb->mnt_cifs_flags &
 				     CIFS_MOUNT_SET_UID) {
 					direntry->d_inode->i_uid =
-						current->fsuid;
+						current->cred->uid;
 					direntry->d_inode->i_gid =
-						current->fsgid;
+						current->cred->gid;
 				}
 			}
 		}
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 0bcec08..8ed3d16 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -352,13 +352,13 @@ header_assemble(struct smb_hdr *buffer, char smb_command /* command */ ,
 		/*  BB Add support for establishing new tCon and SMB Session  */
 		/*      with userid/password pairs found on the smb session   */
 		/*	for other target tcp/ip addresses 		BB    */
-				if (current->fsuid != treeCon->ses->linux_uid) {
+				if (current->cred->uid != treeCon->ses->linux_uid) {
 					cFYI(1, ("Multiuser mode and UID "
 						 "did not match tcon uid"));
 					read_lock(&GlobalSMBSeslock);
 					list_for_each(temp_item, &GlobalSMBSessionList) {
 						ses = list_entry(temp_item, struct cifsSesInfo, cifsSessionList);
-						if (ses->linux_uid == current->fsuid) {
+						if (ses->linux_uid == current->cred->uid) {
 							if (ses->server == treeCon->ses->server) {
 								cFYI(1, ("found matching uid substitute right smb_uid"));
 								buffer->Uid = ses->Suid;
diff --git a/fs/coda/cache.c b/fs/coda/cache.c
index 8a23703..10120dd 100644
--- a/fs/coda/cache.c
+++ b/fs/coda/cache.c
@@ -32,8 +32,8 @@ void coda_cache_enter(struct inode *inode, int mask)
 	struct coda_inode_info *cii = ITOC(inode);
 
 	cii->c_cached_epoch = atomic_read(&permission_epoch);
-	if (cii->c_uid != current->fsuid) {
-                cii->c_uid = current->fsuid;
+	if (cii->c_uid != current->cred->uid) {
+                cii->c_uid = current->cred->uid;
                 cii->c_cached_perm = mask;
         } else
                 cii->c_cached_perm |= mask;
@@ -60,7 +60,7 @@ int coda_cache_check(struct inode *inode, int mask)
         int hit;
 	
         hit = (mask & cii->c_cached_perm) == mask &&
-		cii->c_uid == current->fsuid &&
+		cii->c_uid == current->cred->uid &&
 		cii->c_cached_epoch == atomic_read(&permission_epoch);
 
         return hit;
diff --git a/fs/coda/file.c b/fs/coda/file.c
index 29137ff..9d8f92c 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -174,7 +174,7 @@ int coda_release(struct inode *coda_inode, struct file *coda_file)
 	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
 
 	err = venus_close(coda_inode->i_sb, coda_i2f(coda_inode),
-			  coda_flags, coda_file->f_uid);
+			  coda_flags, coda_file->f_cred->uid);
 
 	host_inode = cfi->cfi_container->f_path.dentry->d_inode;
 	cii = ITOC(coda_inode);
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index cdb4c07..0e978ba 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -54,9 +54,9 @@ static void *alloc_upcall(int opcode, int size)
 	inp->ih.pgid = process_group(current);
 #ifdef CONFIG_CODA_FS_OLD_API
 	memset(&inp->ih.cred, 0, sizeof(struct coda_cred));
-	inp->ih.cred.cr_fsuid = current->fsuid;
+	inp->ih.cred.cr_fsuid = current->cred->uid;
 #else
-	inp->ih.uid = current->fsuid;
+	inp->ih.uid = current->cred->uid;
 #endif
 	return (void*)inp;
 }
diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index baf71dd..3517fce 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -112,7 +112,7 @@ static int reserve_blocks(struct super_block *sb, int count)
 		count = free_blocks;
 
 	if (free_blocks < root_blocks + count && !capable(CAP_SYS_RESOURCE) &&
-	    sbi->s_resuid != current->fsuid &&
+	    sbi->s_resuid != current->cred->uid &&
 	    (sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
 		/*
 		 * We are too close to reserve and we are not privileged.
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 2cb545b..3f8d92c 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -562,15 +562,13 @@ got:
 
 	sb->s_dirt = 1;
 	mark_buffer_dirty(bh2);
-	inode->i_uid = current->fsuid;
 	if (test_opt (sb, GRPID))
 		inode->i_gid = dir->i_gid;
 	else if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-	} else
-		inode->i_gid = current->fsgid;
+	}
 	inode->i_mode = mode;
 
 	inode->i_ino = ino;
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e53b4af..1628c1b 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1377,7 +1377,7 @@ static int ext4_has_free_blocks(struct ext4_sb_info *sbi)
 	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
 	root_blocks = ext4_r_blocks_count(sbi->s_es);
 	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current->fsuid &&
+		sbi->s_resuid != current->cred->uid &&
 		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
 		return 0;
 	}
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 427f830..d3a6377 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -549,15 +549,13 @@ got:
 		percpu_counter_inc(&sbi->s_dirs_counter);
 	sb->s_dirt = 1;
 
-	inode->i_uid = current->fsuid;
 	if (test_opt (sb, GRPID))
 		inode->i_gid = dir->i_gid;
 	else if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-	} else
-		inode->i_gid = current->fsgid;
+	}
 	inode->i_mode = mode;
 
 	inode->i_ino = ino;
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 3ad22be..6436840 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -79,8 +79,8 @@ static void __fuse_put_request(struct fuse_req *req)
 
 static void fuse_req_init_context(struct fuse_req *req)
 {
-	req->in.h.uid = current->fsuid;
-	req->in.h.gid = current->fsgid;
+	req->in.h.uid = current->cred->uid;
+	req->in.h.gid = current->cred->gid;
 	req->in.h.pid = current->pid;
 }
 
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 34f7bcd..6d819d9 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -633,18 +633,18 @@ static void munge_mode_uid_gid(struct gfs2_inode *dip, unsigned int *mode,
 	    (dip->i_inode.i_mode & S_ISUID) && dip->i_inode.i_uid) {
 		if (S_ISDIR(*mode))
 			*mode |= S_ISUID;
-		else if (dip->i_inode.i_uid != current->fsuid)
+		else if (dip->i_inode.i_uid != current->cred->uid)
 			*mode &= ~07111;
 		*uid = dip->i_inode.i_uid;
 	} else
-		*uid = current->fsuid;
+		*uid = current->cred->uid;
 
 	if (dip->i_inode.i_mode & S_ISGID) {
 		if (S_ISDIR(*mode))
 			*mode |= S_ISGID;
 		*gid = dip->i_inode.i_gid;
 	} else
-		*gid = current->fsgid;
+		*gid = current->cred->gid;
 }
 
 static int alloc_dinode(struct gfs2_inode *dip, u64 *no_addr, u64 *generation)
@@ -1048,8 +1048,8 @@ int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 		return -EPERM;
 
 	if ((dip->i_inode.i_mode & S_ISVTX) &&
-	    dip->i_inode.i_uid != current->fsuid &&
-	    ip->i_inode.i_uid != current->fsuid && !capable(CAP_FOWNER))
+	    dip->i_inode.i_uid != current->cred->uid &&
+	    ip->i_inode.i_uid != current->cred->uid && !capable(CAP_FOWNER))
 		return -EPERM;
 
 	if (IS_APPEND(&dip->i_inode))
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index bc835f2..43fe09f 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -151,8 +151,8 @@ struct inode *hfs_new_inode(struct inode *dir, struct qstr *name, int mode)
 	hfs_cat_build_key(sb, (btree_key *)&HFS_I(inode)->cat_key, dir->i_ino, name);
 	inode->i_ino = HFS_SB(sb)->next_id++;
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current->cred->uid;
+	inode->i_gid = current->cred->gid;
 	inode->i_nlink = 1;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	HFS_I(inode)->flags = 0;
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 6f7c662..e7ccd30 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -308,8 +308,8 @@ struct inode *hfsplus_new_inode(struct super_block *sb, int mode)
 
 	inode->i_ino = HFSPLUS_SB(sb).next_cnid++;
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current->cred->uid;
+	inode->i_gid = current->cred->gid;
 	inode->i_nlink = 1;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	INIT_LIST_HEAD(&HFSPLUS_I(inode).open_dir_list);
diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index d256559..121d7d5 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -92,11 +92,11 @@ static int hpfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	inc_nlink(dir);
 	insert_inode_hash(result);
 
-	if (result->i_uid != current->fsuid ||
-	    result->i_gid != current->fsgid ||
+	if (result->i_uid != current->cred->uid ||
+	    result->i_gid != current->cred->gid ||
 	    result->i_mode != (mode | S_IFDIR)) {
-		result->i_uid = current->fsuid;
-		result->i_gid = current->fsgid;
+		result->i_uid = current->cred->uid;
+		result->i_gid = current->cred->gid;
 		result->i_mode = mode | S_IFDIR;
 		hpfs_write_inode_nolock(result);
 	}
@@ -184,11 +184,11 @@ static int hpfs_create(struct inode *dir, struct dentry *dentry, int mode, struc
 
 	insert_inode_hash(result);
 
-	if (result->i_uid != current->fsuid ||
-	    result->i_gid != current->fsgid ||
+	if (result->i_uid != current->cred->uid ||
+	    result->i_gid != current->cred->gid ||
 	    result->i_mode != (mode | S_IFREG)) {
-		result->i_uid = current->fsuid;
-		result->i_gid = current->fsgid;
+		result->i_uid = current->cred->uid;
+		result->i_gid = current->cred->gid;
 		result->i_mode = mode | S_IFREG;
 		hpfs_write_inode_nolock(result);
 	}
@@ -247,8 +247,8 @@ static int hpfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t
 	result->i_mtime.tv_nsec = 0;
 	result->i_atime.tv_nsec = 0;
 	hpfs_i(result)->i_ea_size = 0;
-	result->i_uid = current->fsuid;
-	result->i_gid = current->fsgid;
+	result->i_uid = current->cred->uid;
+	result->i_gid = current->cred->gid;
 	result->i_nlink = 1;
 	result->i_size = 0;
 	result->i_blocks = 1;
@@ -325,8 +325,8 @@ static int hpfs_symlink(struct inode *dir, struct dentry *dentry, const char *sy
 	result->i_atime.tv_nsec = 0;
 	hpfs_i(result)->i_ea_size = 0;
 	result->i_mode = S_IFLNK | 0777;
-	result->i_uid = current->fsuid;
-	result->i_gid = current->fsgid;
+	result->i_uid = current->cred->uid;
+	result->i_gid = current->cred->gid;
 	result->i_blocks = 1;
 	result->i_nlink = 1;
 	result->i_size = strlen(symlink);
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 950c2fb..354f545 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -422,9 +422,9 @@ static int hugetlbfs_mknod(struct inode *dir,
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else {
-		gid = current->fsgid;
+		gid = current->cred->gid;
 	}
-	inode = hugetlbfs_get_inode(dir->i_sb, current->fsuid, gid, mode, dev);
+	inode = hugetlbfs_get_inode(dir->i_sb, current->cred->uid, gid, mode, dev);
 	if (inode) {
 		dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 		d_instantiate(dentry, inode);
@@ -457,9 +457,9 @@ static int hugetlbfs_symlink(struct inode *dir,
 	if (dir->i_mode & S_ISGID)
 		gid = dir->i_gid;
 	else
-		gid = current->fsgid;
+		gid = current->cred->gid;
 
-	inode = hugetlbfs_get_inode(dir->i_sb, current->fsuid,
+	inode = hugetlbfs_get_inode(dir->i_sb, current->cred->uid,
 					gid, S_IFLNK|S_IRWXUGO, 0);
 	if (inode) {
 		int l = strlen(symname)+1;
@@ -697,8 +697,8 @@ hugetlbfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	config.nr_blocks = -1; /* No limit on size by default */
 	config.nr_inodes = -1; /* No limit on number of inodes by default */
-	config.uid = current->fsuid;
-	config.gid = current->fsgid;
+	config.uid = current->cred->uid;
+	config.gid = current->cred->gid;
 	config.mode = 0755;
 	ret = hugetlbfs_parse_options(data, &config);
 	if (ret)
@@ -816,8 +816,8 @@ struct file *hugetlb_file_setup(const char *name, size_t size)
 		goto out_dentry;
 
 	error = -ENOSPC;
-	inode = hugetlbfs_get_inode(root->d_sb, current->fsuid,
-				current->fsgid, S_IFREG | S_IRWXUGO, 0);
+	inode = hugetlbfs_get_inode(root->d_sb, current->cred->uid,
+				current->cred->gid, S_IFREG | S_IRWXUGO, 0);
 	if (!inode)
 		goto out_file;
 
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 8bc727b..2b9e7c0 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -422,14 +422,14 @@ struct inode *jffs2_new_inode (struct inode *dir_i, int mode, struct jffs2_raw_i
 
 	memset(ri, 0, sizeof(*ri));
 	/* Set OS-specific defaults for new inodes */
-	ri->uid = cpu_to_je16(current->fsuid);
+	ri->uid = cpu_to_je16(current->cred->uid);
 
 	if (dir_i->i_mode & S_ISGID) {
 		ri->gid = cpu_to_je16(dir_i->i_gid);
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else {
-		ri->gid = cpu_to_je16(current->fsgid);
+		ri->gid = cpu_to_je16(current->cred->gid);
 	}
 	ri->mode =  cpu_to_jemode(mode);
 	ret = jffs2_do_new_inode (c, f, mode, ri);
diff --git a/fs/jfs/jfs_inode.c b/fs/jfs/jfs_inode.c
index ed6574b..c913156 100644
--- a/fs/jfs/jfs_inode.c
+++ b/fs/jfs/jfs_inode.c
@@ -93,13 +93,13 @@ struct inode *ialloc(struct inode *parent, umode_t mode)
 		return ERR_PTR(rc);
 	}
 
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current->cred->uid;
 	if (parent->i_mode & S_ISGID) {
 		inode->i_gid = parent->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current->cred->gid;
 
 	/*
 	 * New inodes need to save sane values on disk when
diff --git a/fs/minix/bitmap.c b/fs/minix/bitmap.c
index 99a12f1..b085565 100644
--- a/fs/minix/bitmap.c
+++ b/fs/minix/bitmap.c
@@ -262,8 +262,8 @@ struct inode * minix_new_inode(const struct inode * dir, int * error)
 		iput(inode);
 		return NULL;
 	}
-	inode->i_uid = current->fsuid;
-	inode->i_gid = (dir->i_mode & S_ISGID) ? dir->i_gid : current->fsgid;
+	if (dir->i_mode & S_ISGID)
+		inode->i_gid = dir->i_gid;
 	inode->i_ino = j;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	inode->i_blocks = 0;
diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index 2192805..2024f96 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -29,9 +29,13 @@ int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp)
 int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 {
 	struct svc_cred	cred = rqstp->rq_cred;
+	struct cred *vfscred;
 	int i;
 	int flags = nfsexp_flags(rqstp, exp);
-	int ret;
+
+	vfscred = dup_cred(current->cred);
+	if (!vfscred)
+		return -ENOMEM;
 
 	if (flags & NFSEXP_ALLSQUASH) {
 		cred.cr_uid = exp->ex_anon_uid;
@@ -55,24 +59,30 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 	} else
 		get_group_info(cred.cr_group_info);
 
+	if (!cred.cr_group_info) {
+		put_cred(vfscred);
+		return -ENOMEM;
+	}
+
 	if (cred.cr_uid != (uid_t) -1)
-		current->fsuid = cred.cr_uid;
+		change_fsuid(vfscred, cred.cr_uid);
 	else
-		current->fsuid = exp->ex_anon_uid;
+		change_fsuid(vfscred, exp->ex_anon_uid);
 	if (cred.cr_gid != (gid_t) -1)
-		current->fsgid = cred.cr_gid;
+		change_fsgid(vfscred, cred.cr_gid);
 	else
-		current->fsgid = exp->ex_anon_gid;
+		change_fsgid(vfscred, exp->ex_anon_gid);
 
-	if (!cred.cr_group_info)
-		return -ENOMEM;
-	ret = set_current_groups(cred.cr_group_info);
+	change_groups(vfscred, cred.cr_group_info);
 	put_group_info(cred.cr_group_info);
 	if ((cred.cr_uid)) {
-		cap_t(current->cap_effective) &= ~CAP_NFSD_MASK;
+		cap_t(vfscred->cap_effective) &= ~CAP_NFSD_MASK;
 	} else {
-		cap_t(current->cap_effective) |= (CAP_NFSD_MASK &
+		cap_t(vfscred->cap_effective) |= (CAP_NFSD_MASK &
 						  current->cap_permitted);
 	}
-	return ret;
+
+	current->_cap_effective = vfscred->cap_effective;
+	set_current_cred(vfscred);
+	return 0;
 }
diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 31d6633..29c566c 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -349,19 +349,21 @@ static struct rpc_version *	nfs_cb_version[] = {
 static struct rpc_cred *
 nfsd4_lookupcred(struct nfs4_client *clp, int taskflags)
 {
-        struct auth_cred acred;
+        struct cred *acred;
 	struct rpc_clnt *clnt = clp->cl_callback.cb_client;
 	struct rpc_cred *ret;
 
-        get_group_info(clp->cl_cred.cr_group_info);
-        acred.uid = clp->cl_cred.cr_uid;
-        acred.gid = clp->cl_cred.cr_gid;
-        acred.group_info = clp->cl_cred.cr_group_info;
+	acred = dup_cred(&init_cred);
+	if (!acred)
+		return ERR_PTR(-ENOMEM);
+        change_fsuid(acred, clp->cl_cred.cr_uid);
+        change_fsgid(acred, clp->cl_cred.cr_gid);
+        change_groups(acred, clp->cl_cred.cr_group_info);
 
         dprintk("NFSD:     looking up %s cred\n",
                 clnt->cl_auth->au_ops->au_name);
-        ret = rpcauth_lookup_credcache(clnt->cl_auth, &acred, taskflags);
-        put_group_info(clp->cl_cred.cr_group_info);
+        ret = rpcauth_lookup_credcache(clnt->cl_auth, acred, taskflags);
+	put_cred(acred);
         return ret;
 }
 
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index ebd03cc..4935871 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -53,20 +53,26 @@
 static struct nameidata rec_dir;
 static int rec_dir_init = 0;
 
-static void
-nfs4_save_user(uid_t *saveuid, gid_t *savegid)
+static struct cred nfs4recover_cred = {
+	.usage	= ATOMIC_INIT(1),
+	.uid	= 0,
+	.gid	= 0,
+};
+
+static struct cred *
+nfs4_save_user(void)
 {
-	*saveuid = current->fsuid;
-	*savegid = current->fsgid;
-	current->fsuid = 0;
-	current->fsgid = 0;
+	/* swap in the recovery creds without adjusting the usage count on
+	 * either */
+	return __set_current_cred(&nfs4recover_cred);
 }
 
 static void
-nfs4_reset_user(uid_t saveuid, gid_t savegid)
+nfs4_reset_user(struct cred *orig_cred)
 {
-	current->fsuid = saveuid;
-	current->fsgid = savegid;
+	/* swap back the original creds without adjusting the usage count on
+	 * either */
+	__set_current_cred(orig_cred);
 }
 
 static void
@@ -132,8 +138,7 @@ nfsd4_create_clid_dir(struct nfs4_client *clp)
 {
 	char *dname = clp->cl_recdir;
 	struct dentry *dentry;
-	uid_t uid;
-	gid_t gid;
+	struct cred *orig_cred;
 	int status;
 
 	dprintk("NFSD: nfsd4_create_clid_dir for \"%s\"\n", dname);
@@ -141,7 +146,7 @@ nfsd4_create_clid_dir(struct nfs4_client *clp)
 	if (!rec_dir_init || clp->cl_firststate)
 		return 0;
 
-	nfs4_save_user(&uid, &gid);
+	orig_cred = nfs4_save_user();
 
 	/* lock the parent */
 	mutex_lock(&rec_dir.dentry->d_inode->i_mutex);
@@ -165,7 +170,7 @@ out_unlock:
 		clp->cl_firststate = 1;
 		nfsd4_sync_rec_dir();
 	}
-	nfs4_reset_user(uid, gid);
+	nfs4_reset_user(orig_cred);
 	dprintk("NFSD: nfsd4_create_clid_dir returns %d\n", status);
 	return status;
 }
@@ -214,14 +219,13 @@ nfsd4_list_rec_dir(struct dentry *dir, recdir_func *f)
 	};
 	struct list_head *dentries = &dla.dentries;
 	struct dentry_list *child;
-	uid_t uid;
-	gid_t gid;
+	struct cred *orig_cred;
 	int status;
 
 	if (!rec_dir_init)
 		return 0;
 
-	nfs4_save_user(&uid, &gid);
+	orig_cred = nfs4_save_user();
 
 	filp = dentry_open(dget(dir), mntget(rec_dir.mnt), O_RDONLY);
 	status = PTR_ERR(filp);
@@ -246,7 +250,7 @@ out:
 		dput(child->dentry);
 		kfree(child);
 	}
-	nfs4_reset_user(uid, gid);
+	nfs4_reset_user(orig_cred);
 	return status;
 }
 
@@ -308,17 +312,16 @@ out:
 void
 nfsd4_remove_clid_dir(struct nfs4_client *clp)
 {
-	uid_t uid;
-	gid_t gid;
+	struct cred *orig_cred;
 	int status;
 
 	if (!rec_dir_init || !clp->cl_firststate)
 		return;
 
 	clp->cl_firststate = 0;
-	nfs4_save_user(&uid, &gid);
+	orig_cred = nfs4_save_user();
 	status = nfsd4_unlink_clid_dir(clp->cl_recdir, HEXDIR_LEN-1);
-	nfs4_reset_user(uid, gid);
+	nfs4_reset_user(orig_cred);
 	if (status == 0)
 		nfsd4_sync_rec_dir();
 	if (status)
@@ -389,16 +392,15 @@ nfsd4_recdir_load(void) {
 void
 nfsd4_init_recdir(char *rec_dirname)
 {
-	uid_t			uid = 0;
-	gid_t			gid = 0;
-	int 			status;
+	struct cred *orig_cred;
+	int status;
 
 	printk("NFSD: Using %s as the NFSv4 state recovery directory\n",
 			rec_dirname);
 
 	BUG_ON(rec_dir_init);
 
-	nfs4_save_user(&uid, &gid);
+	orig_cred = nfs4_save_user();
 
 	status = path_lookup(rec_dirname, LOOKUP_FOLLOW | LOOKUP_DIRECTORY,
 			&rec_dir);
@@ -408,7 +410,7 @@ nfsd4_init_recdir(char *rec_dirname)
 
 	if (!status)
 		rec_dir_init = 1;
-	nfs4_reset_user(uid, gid);
+	nfs4_reset_user(orig_cred);
 }
 
 void
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 7867151..aef5933 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1875,7 +1875,7 @@ nfsd_permission(struct svc_rqst *rqstp, struct svc_export *exp,
 	 * with NFSv3.
 	 */
 	if ((acc & MAY_OWNER_OVERRIDE) &&
-	    inode->i_uid == current->fsuid)
+	    inode->i_uid == current->cred->uid)
 		return 0;
 
 	err = permission(inode, acc & (MAY_READ|MAY_WRITE|MAY_EXEC), NULL);
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 7418dc8..f2056ae 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -329,8 +329,6 @@ static struct inode *dlmfs_get_root_inode(struct super_block *sb)
 		ip = DLMFS_I(inode);
 
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
 		inode->i_blocks = 0;
 		inode->i_mapping->backing_dev_info = &dlmfs_backing_dev_info;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
@@ -355,8 +353,6 @@ static struct inode *dlmfs_get_inode(struct inode *parent,
 		return NULL;
 
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
 	inode->i_blocks = 0;
 	inode->i_mapping->backing_dev_info = &dlmfs_backing_dev_info;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 701e6d0..f1c81e9 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -542,13 +542,13 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	fe->i_blkno = cpu_to_le64(fe_blkno);
 	fe->i_suballoc_bit = cpu_to_le16(suballoc_bit);
 	fe->i_suballoc_slot = cpu_to_le16(osb->slot_num);
-	fe->i_uid = cpu_to_le32(current->fsuid);
+	fe->i_uid = cpu_to_le32(current->cred->uid);
 	if (dir->i_mode & S_ISGID) {
 		fe->i_gid = cpu_to_le32(dir->i_gid);
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		fe->i_gid = cpu_to_le32(current->fsgid);
+		fe->i_gid = cpu_to_le32(current->cred->gid);
 	fe->i_mode = cpu_to_le16(mode);
 	if (S_ISCHR(mode) || S_ISBLK(mode))
 		fe->id1.dev1.i_rdev = cpu_to_le64(huge_encode_dev(dev));
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index b378eea..78127e2 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -582,7 +582,6 @@ static int new_inode_init(struct inode *inode, struct inode *dir, int mode)
 	/* the quota init calls have to know who to charge the quota to, so
 	 ** we have to set uid and gid here
 	 */
-	inode->i_uid = current->fsuid;
 	inode->i_mode = mode;
 	/* Make inode invalid - just in case we are going to drop it before
 	 * the initialization happens */
@@ -592,8 +591,6 @@ static int new_inode_init(struct inode *inode, struct inode *dir, int mode)
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			inode->i_mode |= S_ISGID;
-	} else {
-		inode->i_gid = current->fsgid;
 	}
 	DQUOT_INIT(inode);
 	return 0;
diff --git a/fs/sysv/ialloc.c b/fs/sysv/ialloc.c
index 115ab0d..d96fbd7 100644
--- a/fs/sysv/ialloc.c
+++ b/fs/sysv/ialloc.c
@@ -164,10 +164,8 @@ struct inode * sysv_new_inode(const struct inode * dir, mode_t mode)
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-	} else
-		inode->i_gid = current->fsgid;
+	}
 
-	inode->i_uid = current->fsuid;
 	inode->i_ino = fs16_to_cpu(sbi, ino);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	inode->i_blocks = 0;
diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index 636d8f6..c93dbab 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -105,13 +105,10 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 	}
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
 	if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-	} else {
-		inode->i_gid = current->fsgid;
 	}
 
 	UDF_I_LOCATION(inode).logicalBlockNum = block;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index bec96a6..bf206ac 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -636,7 +636,6 @@ static int udf_mknod(struct inode *dir, struct dentry *dentry, int mode,
 	if (!inode)
 		goto out;
 
-	inode->i_uid = current->fsuid;
 	init_special_inode(inode, mode, rdev);
 	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err))) {
 		inode->i_nlink--;
diff --git a/fs/ufs/ialloc.c b/fs/ufs/ialloc.c
index c28a8b6..928420f 100644
--- a/fs/ufs/ialloc.c
+++ b/fs/ufs/ialloc.c
@@ -303,13 +303,11 @@ cg_found:
 
 	inode->i_ino = cg * uspi->s_ipg + bit;
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
 	if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			inode->i_mode |= S_ISGID;
-	} else
-		inode->i_gid = current->fsgid;
+	}
 
 	inode->i_blocks = 0;
 	inode->i_generation = 0;
diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index 330c4ba..4e68ad4 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -127,8 +127,8 @@
 
 #define current_cpu()		(raw_smp_processor_id())
 #define current_pid()		(current->pid)
-#define current_fsuid(cred)	(current->fsuid)
-#define current_fsgid(cred)	(current->fsgid)
+#define current_fsuid(___cred)	(current->cred->uid)
+#define current_fsgid(___cred)	(current->cred->gid)
 #define current_test_flags(f)	(current->flags & (f))
 #define current_set_flags_nested(sp, f)		\
 		(*(sp) = current->flags, current->flags |= (f))
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 4ca4beb..a460508 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -383,7 +383,7 @@ xfs_acl_allow_set(
 	error = bhv_vop_getattr(vp, &va, 0, NULL);
 	if (error)
 		return error;
-	if (va.va_uid != current->fsuid && !capable(CAP_FOWNER))
+	if (va.va_uid != current->cred->uid && !capable(CAP_FOWNER))
 		return EPERM;
 	return error;
 }
@@ -457,13 +457,13 @@ xfs_acl_access(
 		switch (fap->acl_entry[i].ae_tag) {
 		case ACL_USER_OBJ:
 			seen_userobj = 1;
-			if (fuid != current->fsuid)
+			if (fuid != current->cred->uid)
 				continue;
 			matched.ae_tag = ACL_USER_OBJ;
 			matched.ae_perm = allows;
 			break;
 		case ACL_USER:
-			if (fap->acl_entry[i].ae_id != current->fsuid)
+			if (fap->acl_entry[i].ae_id != current->cred->uid)
 				continue;
 			matched.ae_tag = ACL_USER;
 			matched.ae_perm = allows;
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 145d5a0..87ce737 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -113,8 +113,8 @@ static struct inode *mqueue_get_inode(struct super_block *sb, int mode,
 	inode = new_inode(sb);
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current->cred->uid;
+		inode->i_gid = current->cred->gid;
 		inode->i_blocks = 0;
 		inode->i_mtime = inode->i_ctime = inode->i_atime =
 				CURRENT_TIME;
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 57e6448..215eaf8 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -286,8 +286,8 @@ static struct inode *cpuset_new_inode(mode_t mode)
 
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current->cred->uid;
+		inode->i_gid = current->cred->gid;
 		inode->i_blocks = 0;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		inode->i_mapping->backing_dev_info = &cpuset_backing_dev_info;
diff --git a/net/9p/client.c b/net/9p/client.c
index cb17075..c47a7ae 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -935,7 +935,7 @@ static struct p9_fid *p9_fid_create(struct p9_client *clnt)
 	fid->rdir_fpos = 0;
 	fid->rdir_pos = 0;
 	fid->rdir_fcall = NULL;
-	fid->uid = current->fsuid;
+	fid->uid = current->cred->uid;
 	fid->clnt = clnt;
 	fid->aux = NULL;
 
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 127a5e8..a2f3c64 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -337,7 +337,8 @@ static void dump_packet(const struct nf_loginfo *info,
 	if ((logflags & IPT_LOG_UID) && !iphoff && skb->sk) {
 		read_lock_bh(&skb->sk->sk_callback_lock);
 		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
-			printk("UID=%u ", skb->sk->sk_socket->file->f_uid);
+			printk("UID=%u ",
+			       skb->sk->sk_socket->file->f_cred->uid);
 		read_unlock_bh(&skb->sk->sk_callback_lock);
 	}
 
diff --git a/net/ipv4/netfilter/ipt_owner.c b/net/ipv4/netfilter/ipt_owner.c
index b14e77d..0c289a5 100644
--- a/net/ipv4/netfilter/ipt_owner.c
+++ b/net/ipv4/netfilter/ipt_owner.c
@@ -37,13 +37,13 @@ match(const struct sk_buff *skb,
 		return false;
 
 	if(info->match & IPT_OWNER_UID) {
-		if ((skb->sk->sk_socket->file->f_uid != info->uid) ^
+		if ((skb->sk->sk_socket->file->f_cred->uid != info->uid) ^
 		    !!(info->invert & IPT_OWNER_UID))
 			return false;
 	}
 
 	if(info->match & IPT_OWNER_GID) {
-		if ((skb->sk->sk_socket->file->f_gid != info->gid) ^
+		if ((skb->sk->sk_socket->file->f_cred->gid != info->gid) ^
 		    !!(info->invert & IPT_OWNER_GID))
 			return false;
 	}
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 6ab9900..579c49c 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -362,7 +362,8 @@ static void dump_packet(const struct nf_loginfo *info,
 	if ((logflags & IP6T_LOG_UID) && recurse && skb->sk) {
 		read_lock_bh(&skb->sk->sk_callback_lock);
 		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
-			printk("UID=%u ", skb->sk->sk_socket->file->f_uid);
+			printk("UID=%u ",
+			       skb->sk->sk_socket->file->f_cred->uid);
 		read_unlock_bh(&skb->sk->sk_callback_lock);
 	}
 }
diff --git a/net/ipv6/netfilter/ip6t_owner.c b/net/ipv6/netfilter/ip6t_owner.c
index 6036613..ca78c0d 100644
--- a/net/ipv6/netfilter/ip6t_owner.c
+++ b/net/ipv6/netfilter/ip6t_owner.c
@@ -39,12 +39,12 @@ match(const struct sk_buff *skb,
 		return false;
 
 	if (info->match & IP6T_OWNER_UID)
-		if ((skb->sk->sk_socket->file->f_uid != info->uid) ^
+		if ((skb->sk->sk_socket->file->f_cred->uid != info->uid) ^
 		    !!(info->invert & IP6T_OWNER_UID))
 			return false;
 
 	if (info->match & IP6T_OWNER_GID)
-		if ((skb->sk->sk_socket->file->f_gid != info->gid) ^
+		if ((skb->sk->sk_socket->file->f_cred->gid != info->gid) ^
 		    !!(info->invert & IP6T_OWNER_GID))
 			return false;
 
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 2351533..5aa3288 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -502,7 +502,7 @@ __build_packet_message(struct nfulnl_instance *inst,
 	if (skb->sk) {
 		read_lock_bh(&skb->sk->sk_callback_lock);
 		if (skb->sk->sk_socket && skb->sk->sk_socket->file) {
-			__be32 uid = htonl(skb->sk->sk_socket->file->f_uid);
+			__be32 uid = htonl(skb->sk->sk_socket->file->f_cred->uid);
 			/* need to unlock here since NFA_PUT may goto */
 			read_unlock_bh(&skb->sk->sk_callback_lock);
 			NFA_PUT(inst->skb, NFULA_UID, sizeof(uid), &uid);

