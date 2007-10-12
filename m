Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbXJLQGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbXJLQGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760038AbXJLQFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:05:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759734AbXJLQFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:05:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/52] CRED: Introduce a COW credentials record
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:05:24 +0100
Message-ID: <20071012160524.15119.18793.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a copy on write credentials record (struct cred).  The fsuid, fsgid,
supplementary groups list move into it (DAC security).  The session, process
and thread keyrings are reflected in it, but don't primarily reside there as
they aren't per-thread and occasionally need to be instantiated or replaced by
other threads or processes.

The LSM security information (MAC security) does *not* migrate from task_struct
at this point, but will be addressed by a later patch.

task_struct then gains an RCU-governed pointer to the credentials as a
replacement to the members it lost.

struct file gains a pointer to (f_cred) and a reference on the cred struct that
the opener was using at the time the file was opened.  This replaces f_uid and
f_gid.

To alter the credentials record, a copy must be made.  This copy may then be
altered and then the pointer in the task_struct redirected to it.  From that
point on the new record should be considered immutable.

In addition, the default setting of i_uid and i_gid to fsuid and fsgid has been
moved from the callers of new_inode() into new_inode() itself.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/ia64/kernel/perfmon.c                |    4 -
 arch/mips/kernel/kspd.c                   |    9 +-
 arch/powerpc/platforms/cell/spufs/inode.c |    4 -
 drivers/isdn/capi/capifs.c                |    4 -
 drivers/usb/core/inode.c                  |    4 -
 fs/9p/vfs_inode.c                         |    4 -
 fs/9p/vfs_super.c                         |    4 -
 fs/affs/inode.c                           |    4 -
 fs/anon_inodes.c                          |    4 -
 fs/attr.c                                 |    4 -
 fs/bfs/dir.c                              |    4 -
 fs/cifs/cifsproto.h                       |    2 
 fs/cifs/dir.c                             |   12 +-
 fs/cifs/inode.c                           |    8 +
 fs/cifs/misc.c                            |    4 -
 fs/coda/cache.c                           |    6 +
 fs/coda/file.c                            |    2 
 fs/coda/upcall.c                          |    4 -
 fs/devpts/inode.c                         |    4 -
 fs/dquot.c                                |    2 
 fs/exec.c                                 |   29 ++++-
 fs/ext2/balloc.c                          |    2 
 fs/ext2/ialloc.c                          |    4 -
 fs/ext3/balloc.c                          |    2 
 fs/ext3/ialloc.c                          |    4 -
 fs/ext4/balloc.c                          |    2 
 fs/ext4/ialloc.c                          |    4 -
 fs/file_table.c                           |    3 -
 fs/fuse/dev.c                             |    4 -
 fs/gfs2/inode.c                           |   10 +-
 fs/hfs/inode.c                            |    4 -
 fs/hfsplus/inode.c                        |    4 -
 fs/hpfs/namei.c                           |   24 ++--
 fs/hugetlbfs/inode.c                      |   16 +--
 fs/jffs2/fs.c                             |    4 -
 fs/jfs/jfs_inode.c                        |    4 -
 fs/locks.c                                |    2 
 fs/minix/bitmap.c                         |    4 -
 fs/namei.c                                |    8 +
 fs/nfsd/auth.c                            |   32 ++++--
 fs/nfsd/nfs4callback.c                    |   16 ++-
 fs/nfsd/nfs4recover.c                     |   54 +++++-----
 fs/nfsd/vfs.c                             |    4 -
 fs/ocfs2/dlm/dlmfs.c                      |    8 +
 fs/ocfs2/namei.c                          |    4 -
 fs/open.c                                 |   21 ++--
 fs/pipe.c                                 |    4 -
 fs/posix_acl.c                            |    4 -
 fs/proc/array.c                           |   12 +-
 fs/ramfs/inode.c                          |    4 -
 fs/reiserfs/namei.c                       |    4 -
 fs/sysv/ialloc.c                          |    4 -
 fs/udf/ialloc.c                           |    4 -
 fs/udf/namei.c                            |    2 
 fs/ufs/ialloc.c                           |    4 -
 fs/xfs/linux-2.6/xfs_cred.h               |    4 -
 fs/xfs/linux-2.6/xfs_linux.h              |    4 -
 fs/xfs/xfs_acl.c                          |    6 +
 include/linux/binfmts.h                   |    1 
 include/linux/cred.h                      |  163 +++++++++++++++++++++++++++++
 include/linux/fs.h                        |    5 +
 include/linux/init_task.h                 |    4 -
 include/linux/sched.h                     |    7 +
 include/linux/sunrpc/auth.h               |   18 +--
 ipc/mqueue.c                              |    4 -
 kernel/Makefile                           |    2 
 kernel/auditsc.c                          |   13 ++
 kernel/cpuset.c                           |    4 -
 kernel/cred.c                             |  123 ++++++++++++++++++++++
 kernel/exit.c                             |    1 
 kernel/fork.c                             |   22 +++-
 kernel/kernel-int.h                       |   15 +++
 kernel/sys.c                              |  144 +++++++++++++++++++-------
 kernel/uid16.c                            |    7 +
 mm/shmem.c                                |    8 +
 net/9p/client.c                           |    2 
 net/socket.c                              |    4 -
 net/sunrpc/auth.c                         |   25 +---
 net/sunrpc/auth_gss/auth_gss.c            |    6 +
 net/sunrpc/auth_null.c                    |    4 -
 net/sunrpc/auth_unix.c                    |    6 +
 security/commoncap.c                      |    8 +
 security/dummy.c                          |   13 ++
 security/keys/key.c                       |    3 -
 security/keys/keyctl.c                    |    2 
 security/keys/permission.c                |   16 ++-
 security/keys/process_keys.c              |    6 +
 security/keys/request_key.c               |   14 +-
 security/keys/request_key_auth.c          |    2 
 89 files changed, 740 insertions(+), 334 deletions(-)

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 14b8e5a..b063444 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2212,8 +2212,8 @@ pfm_alloc_fd(struct file **cfile)
 	DPRINT(("new inode ino=%ld @%p\n", inode->i_ino, inode));
 
 	inode->i_mode = S_IFCHR|S_IRUGO;
-	inode->i_uid  = current->fsuid;
-	inode->i_gid  = current->fsgid;
+	inode->i_uid  = current->cred->uid;
+	inode->i_gid  = current->cred->gid;
 
 	sprintf(name, "[%lu]", inode->i_ino);
 	this.name = name;
diff --git a/arch/mips/kernel/kspd.c b/arch/mips/kernel/kspd.c
index d2c2e00..96eca0b 100644
--- a/arch/mips/kernel/kspd.c
+++ b/arch/mips/kernel/kspd.c
@@ -174,11 +174,10 @@ static unsigned int translate_open_flags(int flags)
 
 static void sp_setfsuidgid( uid_t uid, gid_t gid)
 {
-	current->fsuid = uid;
-	current->fsgid = gid;
-
-	key_fsuid_changed(current);
-	key_fsgid_changed(current);
+	struct cred *cred = dup_cred(current->cred);
+	change_fsuid(cred, uid);
+	change_fsgid(cred, gid);
+	set_current_cred(cred);
 }
 
 /*
diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 1109874..274f08b 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -85,8 +85,8 @@ spufs_new_inode(struct super_block *sb, int mode)
 		goto out;
 
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current->cred->uid;
+	inode->i_gid = current->cred->gid;
 	inode->i_blocks = 0;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 out:
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
index cd4f111..1f0e75d 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -246,8 +246,8 @@ static struct inode *usbfs_get_inode (struct super_block *sb, int mode, dev_t de
 
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current->cred->uid;
+		inode->i_gid = current->cred->gid;
 		inode->i_blocks = 0;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		switch (mode & S_IFMT) {
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 53444f0..d08fcef 100644
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
index edea76c..c0998c1 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -311,8 +311,8 @@ affs_new_inode(struct inode *dir)
 	mark_buffer_dirty_inode(bh, inode);
 	affs_brelse(bh);
 
-	inode->i_uid     = current->fsuid;
-	inode->i_gid     = current->fsgid;
+	inode->i_uid     = current->cred->uid;
+	inode->i_gid     = current->cred->gid;
 	inode->i_ino     = block;
 	inode->i_nlink   = 1;
 	inode->i_mtime   = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index b4a7588..de05856 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -163,8 +163,8 @@ static struct inode *anon_inode_mkinode(void)
 	 */
 	inode->i_state = I_DIRTY;
 	inode->i_mode = S_IRUSR | S_IWUSR;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current->cred->uid;
+	inode->i_gid = current->cred->gid;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	return inode;
 }
diff --git a/fs/attr.c b/fs/attr.c
index f8dfc22..3e6b911 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -29,13 +29,13 @@ int inode_change_ok(struct inode *inode, struct iattr *attr)
 
 	/* Make sure a caller can chown. */
 	if ((ia_valid & ATTR_UID) &&
-	    (current->fsuid != inode->i_uid ||
+	    (current->cred->uid != inode->i_uid ||
 	     attr->ia_uid != inode->i_uid) && !capable(CAP_CHOWN))
 		goto error;
 
 	/* Make sure caller can chgrp. */
 	if ((ia_valid & ATTR_GID) &&
-	    (current->fsuid != inode->i_uid ||
+	    (current->cred->uid != inode->i_uid ||
 	    (!in_group_p(attr->ia_gid) && attr->ia_gid != inode->i_gid)) &&
 	    !capable(CAP_CHOWN))
 		goto error;
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 03c8bdb..275de1e 100644
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
index 48966b9..7f31094 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1020,8 +1020,8 @@ mkdir_get_info:
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
@@ -1044,9 +1044,9 @@ mkdir_get_info:
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
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 06ef9a2..b6829ab 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -172,8 +172,8 @@ int devpts_pty_new(struct tty_struct *tty)
 		return -ENOMEM;
 
 	inode->i_ino = number+2;
-	inode->i_uid = config.setuid ? config.uid : current->fsuid;
-	inode->i_gid = config.setgid ? config.gid : current->fsgid;
+	inode->i_uid = config.setuid ? config.uid : current->cred->uid;
+	inode->i_gid = config.setgid ? config.gid : current->cred->gid;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	init_special_inode(inode, S_IFCHR|config.mode, device);
 	inode->i_private = tty;
diff --git a/fs/dquot.c b/fs/dquot.c
index de9a29f..f1748c6 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -832,7 +832,7 @@ static inline int need_print_warning(struct dquot *dquot)
 
 	switch (dquot->dq_type) {
 		case USRQUOTA:
-			return current->fsuid == dquot->dq_id;
+			return current->cred->uid == dquot->dq_id;
 		case GRPQUOTA:
 			return in_group_p(dquot->dq_id);
 	}
diff --git a/fs/exec.c b/fs/exec.c
index 073b0b8..3faef59 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1137,6 +1137,11 @@ int prepare_binprm(struct linux_binprm *bprm)
 		}
 	}
 
+	/* prepare the new credentials */
+	bprm->cred = dup_cred(current->cred);
+	if (!bprm->cred)
+		return -ENOMEM;
+
 	/* fill in binprm security blob */
 	retval = security_bprm_set(bprm);
 	if (retval)
@@ -1178,7 +1183,9 @@ void compute_creds(struct linux_binprm *bprm)
 	task_lock(current);
 	unsafe = unsafe_exec(current);
 	security_bprm_apply_creds(bprm, unsafe);
+	set_current_cred(bprm->cred);
 	task_unlock(current);
+	bprm->cred = NULL;
 	security_bprm_post_apply_creds(bprm);
 }
 EXPORT_SYMBOL(compute_creds);
@@ -1409,6 +1416,8 @@ out:
 	free_arg_pages(bprm);
 	if (bprm->security)
 		security_bprm_free(bprm);
+	if (bprm->cred)
+		put_cred(bprm->cred);
 
 out_mm:
 	if (bprm->mm)
@@ -1716,8 +1725,8 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	struct linux_binfmt * binfmt;
 	struct inode * inode;
 	struct file * file;
+	struct cred *cred;
 	int retval = 0;
-	int fsuid = current->fsuid;
 	int flag = 0;
 	int ispipe = 0;
 
@@ -1732,6 +1741,10 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 		goto fail;
 	}
 
+	cred = dup_cred(current->cred);
+	if (!cred)
+		goto fail;
+
 	/*
 	 *	We cannot trust fsuid as being the "true" uid of the
 	 *	process nor do we know its entire history. We only know it
@@ -1739,13 +1752,13 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	 */
 	if (get_dumpable(mm) == 2) {	/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
-		current->fsuid = 0;	/* Dump root private */
+		change_fsuid(cred, 0);	/* Dump root private */
 	}
 	set_dumpable(mm, 0);
 
 	retval = coredump_wait(exit_code);
 	if (retval < 0)
-		goto fail;
+		goto fail_cred;
 
 	/*
 	 * Clear any false indication of pending signals that might
@@ -1763,19 +1776,20 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
  	lock_kernel();
 	ispipe = format_corename(corename, core_pattern, signr);
 	unlock_kernel();
+	cred = __set_current_cred(cred);
  	if (ispipe) {
 		/* SIGPIPE can happen, but it's just never processed */
  		if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
- 			goto fail_unlock;
+			goto fail_restore_cred;
  		}
  	} else
  		file = filp_open(corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
 	if (IS_ERR(file))
-		goto fail_unlock;
+		goto fail_restore_cred;
 	inode = file->f_path.dentry->d_inode;
 	if (inode->i_nlink > 1)
 		goto close_fail;	/* multiple links - don't dump */
@@ -1799,9 +1813,12 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 		current->signal->group_exit_code |= 0x80;
 close_fail:
 	filp_close(file, NULL);
+fail_restore_cred:
+	set_current_cred(cred);
 fail_unlock:
-	current->fsuid = fsuid;
 	complete_all(&mm->core_done);
+fail_cred:
+	put_cred(cred);
 fail:
 	return retval;
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
index 2cb545b..03b9287 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -562,7 +562,7 @@ got:
 
 	sb->s_dirt = 1;
 	mark_buffer_dirty(bh2);
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current->cred->uid;
 	if (test_opt (sb, GRPID))
 		inode->i_gid = dir->i_gid;
 	else if (dir->i_mode & S_ISGID) {
@@ -570,7 +570,7 @@ got:
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current->cred->gid;
 	inode->i_mode = mode;
 
 	inode->i_ino = ino;
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index ca8aee6..6c4e82f 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1360,7 +1360,7 @@ static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
 	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
 	root_blocks = le32_to_cpu(sbi->s_es->s_r_blocks_count);
 	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current->fsuid &&
+		sbi->s_resuid != current->cred->uid &&
 		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
 		return 0;
 	}
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 5724adb..195e9e8 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -546,7 +546,7 @@ got:
 		percpu_counter_inc(&sbi->s_dirs_counter);
 	sb->s_dirt = 1;
 
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current->cred->uid;
 	if (test_opt (sb, GRPID))
 		inode->i_gid = dir->i_gid;
 	else if (dir->i_mode & S_ISGID) {
@@ -554,7 +554,7 @@ got:
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current->cred->gid;
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
index 4fba007..488cc2b 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -549,7 +549,7 @@ got:
 		percpu_counter_inc(&sbi->s_dirs_counter);
 	sb->s_dirt = 1;
 
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current->cred->uid;
 	if (test_opt (sb, GRPID))
 		inode->i_gid = dir->i_gid;
 	else if (dir->i_mode & S_ISGID) {
@@ -557,7 +557,7 @@ got:
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current->cred->gid;
 	inode->i_mode = mode;
 
 	inode->i_ino = ino;
diff --git a/fs/file_table.c b/fs/file_table.c
index d17fd69..f4c772c 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -115,8 +115,7 @@ struct file *get_empty_filp(void)
 	INIT_LIST_HEAD(&f->f_u.fu_list);
 	atomic_set(&f->f_count, 1);
 	rwlock_init(&f->f_owner.lock);
-	f->f_uid = tsk->fsuid;
-	f->f_gid = tsk->fsgid;
+	f->f_cred = get_current_cred();
 	eventpoll_init_file(f);
 	/* f->f_version: 0 */
 	return f;
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
index 498844f..6dbd255 100644
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
index 900be8b..a3ae187 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -434,14 +434,14 @@ struct inode *jffs2_new_inode (struct inode *dir_i, int mode, struct jffs2_raw_i
 
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
diff --git a/fs/locks.c b/fs/locks.c
index c795eaa..6d82706 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1341,7 +1341,7 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 	struct inode *inode = dentry->d_inode;
 	int error, rdlease_count = 0, wrlease_count = 0;
 
-	if ((current->fsuid != inode->i_uid) && !capable(CAP_LEASE))
+	if ((current->cred->uid != inode->i_uid) && !capable(CAP_LEASE))
 		return -EACCES;
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
diff --git a/fs/minix/bitmap.c b/fs/minix/bitmap.c
index 99a12f1..daacbf0 100644
--- a/fs/minix/bitmap.c
+++ b/fs/minix/bitmap.c
@@ -262,8 +262,8 @@ struct inode * minix_new_inode(const struct inode * dir, int * error)
 		iput(inode);
 		return NULL;
 	}
-	inode->i_uid = current->fsuid;
-	inode->i_gid = (dir->i_mode & S_ISGID) ? dir->i_gid : current->fsgid;
+	inode->i_uid = current->cred->uid;
+	inode->i_gid = (dir->i_mode & S_ISGID) ? dir->i_gid : current->cred->gid;
 	inode->i_ino = j;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	inode->i_blocks = 0;
diff --git a/fs/namei.c b/fs/namei.c
index a83160a..3e10fff 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -185,7 +185,7 @@ int generic_permission(struct inode *inode, int mask,
 {
 	umode_t			mode = inode->i_mode;
 
-	if (current->fsuid == inode->i_uid)
+	if (current->cred->uid == inode->i_uid)
 		mode >>= 6;
 	else {
 		if (IS_POSIXACL(inode) && (mode & S_IRWXG) && check_acl) {
@@ -437,7 +437,7 @@ static int exec_permission_lite(struct inode *inode,
 	if (inode->i_op && inode->i_op->permission)
 		return -EAGAIN;
 
-	if (current->fsuid == inode->i_uid)
+	if (current->cred->uid == inode->i_uid)
 		mode >>= 6;
 	else if (in_group_p(inode->i_gid))
 		mode >>= 3;
@@ -1406,9 +1406,9 @@ static inline int check_sticky(struct inode *dir, struct inode *inode)
 {
 	if (!(dir->i_mode & S_ISVTX))
 		return 0;
-	if (inode->i_uid == current->fsuid)
+	if (inode->i_uid == current->cred->uid)
 		return 0;
-	if (dir->i_uid == current->fsuid)
+	if (dir->i_uid == current->cred->uid)
 		return 0;
 	return !capable(CAP_FOWNER);
 }
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
index 7867151..6452ca1 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1833,7 +1833,7 @@ nfsd_permission(struct svc_rqst *rqstp, struct svc_export *exp,
 		IS_APPEND(inode)?	" append" : "",
 		IS_RDONLY(inode)?	" ro" : "");
 	dprintk("      owner %d/%d user %d/%d\n",
-		inode->i_uid, inode->i_gid, current->fsuid, current->fsgid);
+		inode->i_uid, inode->i_gid, current->cred->uid, current->cred->gid);
 #endif
 
 	/* Normally we reject any write/sattr etc access on a read-only file
@@ -1875,7 +1875,7 @@ nfsd_permission(struct svc_rqst *rqstp, struct svc_export *exp,
 	 * with NFSv3.
 	 */
 	if ((acc & MAY_OWNER_OVERRIDE) &&
-	    inode->i_uid == current->fsuid)
+	    inode->i_uid == current->cred->uid)
 		return 0;
 
 	err = permission(inode, acc & (MAY_READ|MAY_WRITE|MAY_EXEC), NULL);
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 7418dc8..708c87a 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -329,8 +329,8 @@ static struct inode *dlmfs_get_root_inode(struct super_block *sb)
 		ip = DLMFS_I(inode);
 
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current->cred->uid;
+		inode->i_gid = current->cred->gid;
 		inode->i_blocks = 0;
 		inode->i_mapping->backing_dev_info = &dlmfs_backing_dev_info;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
@@ -355,8 +355,8 @@ static struct inode *dlmfs_get_inode(struct inode *parent,
 		return NULL;
 
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current->cred->uid;
+	inode->i_gid = current->cred->gid;
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
diff --git a/fs/open.c b/fs/open.c
index 1d9e5e9..c383efe 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -421,19 +421,26 @@ out:
 asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 {
 	struct nameidata nd;
-	int old_fsuid, old_fsgid;
 	kernel_cap_t old_cap;
+	struct cred *cred;
 	int res;
 
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
 		return -EINVAL;
 
-	old_fsuid = current->fsuid;
-	old_fsgid = current->fsgid;
 	old_cap = current->cap_effective;
 
-	current->fsuid = current->uid;
-	current->fsgid = current->gid;
+	if (current->cred->uid != current->uid ||
+	    current->cred->gid != current->gid) {
+		cred = dup_cred(current->cred);
+		if (!cred)
+			return -ENOMEM;
+
+		change_fsuid(cred, current->uid);
+		change_fsgid(cred, current->gid);
+	} else {
+		cred = get_current_cred();
+	}
 
 	/*
 	 * Clear the capabilities if we switch to a non-root user
@@ -448,6 +455,7 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 	else
 		current->cap_effective = current->cap_permitted;
 
+	cred = __set_current_cred(cred);
 	res = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW|LOOKUP_ACCESS, &nd);
 	if (res)
 		goto out;
@@ -464,8 +472,7 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 out_path_release:
 	path_release(&nd);
 out:
-	current->fsuid = old_fsuid;
-	current->fsgid = old_fsgid;
+	set_current_cred(cred);
 	current->cap_effective = old_cap;
 
 	return res;
diff --git a/fs/pipe.c b/fs/pipe.c
index 6b3d91a..5143262 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -939,8 +939,8 @@ static struct inode * get_pipe_inode(void)
 	 */
 	inode->i_state = I_DIRTY;
 	inode->i_mode = S_IFIFO | S_IRUSR | S_IWUSR;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current->cred->uid;
+	inode->i_gid = current->cred->gid;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 
 	return inode;
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index aec931e..b36c79f 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -217,11 +217,11 @@ posix_acl_permission(struct inode *inode, const struct posix_acl *acl, int want)
                 switch(pa->e_tag) {
                         case ACL_USER_OBJ:
 				/* (May have been checked already) */
-                                if (inode->i_uid == current->fsuid)
+				if (inode->i_uid == current->cred->uid)
                                         goto check_perm;
                                 break;
                         case ACL_USER:
-                                if (pa->e_id == current->fsuid)
+				if (pa->e_id == current->cred->uid)
                                         goto mask;
 				break;
                         case ACL_GROUP_OBJ:
diff --git a/fs/proc/array.c b/fs/proc/array.c
index ee4814d..dc2f83a 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -159,10 +159,12 @@ static inline const char *get_task_state(struct task_struct *tsk)
 static inline char *task_state(struct task_struct *p, char *buffer)
 {
 	struct group_info *group_info;
+	struct cred *cred;
 	int g;
 	struct fdtable *fdt = NULL;
 
 	rcu_read_lock();
+	cred = get_task_cred(p);
 	buffer += sprintf(buffer,
 		"State:\t%s\n"
 		"Tgid:\t%d\n"
@@ -175,8 +177,8 @@ static inline char *task_state(struct task_struct *p, char *buffer)
 		p->tgid, p->pid,
 		pid_alive(p) ? rcu_dereference(p->real_parent)->tgid : 0,
 		pid_alive(p) && p->ptrace ? rcu_dereference(p->parent)->pid : 0,
-		p->uid, p->euid, p->suid, p->fsuid,
-		p->gid, p->egid, p->sgid, p->fsgid);
+		p->uid, p->euid, p->suid, cred->uid,
+		p->gid, p->egid, p->sgid, cred->gid);
 
 	task_lock(p);
 	if (p->files)
@@ -186,14 +188,12 @@ static inline char *task_state(struct task_struct *p, char *buffer)
 		"Groups:\t",
 		fdt ? fdt->max_fds : 0);
 	rcu_read_unlock();
-
-	group_info = p->group_info;
-	get_group_info(group_info);
 	task_unlock(p);
 
+	group_info = cred->group_info;
 	for (g = 0; g < min(group_info->ngroups, NGROUPS_SMALL); g++)
 		buffer += sprintf(buffer, "%d ", GROUP_AT(group_info, g));
-	put_group_info(group_info);
+	put_cred(cred);
 
 	buffer += sprintf(buffer, "\n");
 	return buffer;
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index ef2b46d..fe3642a 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -55,8 +55,8 @@ struct inode *ramfs_get_inode(struct super_block *sb, int mode, dev_t dev)
 
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current->cred->uid;
+		inode->i_gid = current->cred->gid;
 		inode->i_blocks = 0;
 		inode->i_mapping->a_ops = &ramfs_aops;
 		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index b378eea..f5fbd5f 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -582,7 +582,7 @@ static int new_inode_init(struct inode *inode, struct inode *dir, int mode)
 	/* the quota init calls have to know who to charge the quota to, so
 	 ** we have to set uid and gid here
 	 */
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current->cred->uid;
 	inode->i_mode = mode;
 	/* Make inode invalid - just in case we are going to drop it before
 	 * the initialization happens */
@@ -593,7 +593,7 @@ static int new_inode_init(struct inode *inode, struct inode *dir, int mode)
 		if (S_ISDIR(mode))
 			inode->i_mode |= S_ISGID;
 	} else {
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current->cred->gid;
 	}
 	DQUOT_INIT(inode);
 	return 0;
diff --git a/fs/sysv/ialloc.c b/fs/sysv/ialloc.c
index 115ab0d..bbde666 100644
--- a/fs/sysv/ialloc.c
+++ b/fs/sysv/ialloc.c
@@ -165,9 +165,9 @@ struct inode * sysv_new_inode(const struct inode * dir, mode_t mode)
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current->cred->gid;
 
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current->cred->uid;
 	inode->i_ino = fs16_to_cpu(sbi, ino);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	inode->i_blocks = 0;
diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index 636d8f6..875fde7 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -105,13 +105,13 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 	}
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current->cred->uid;
 	if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else {
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current->cred->gid;
 	}
 
 	UDF_I_LOCATION(inode).logicalBlockNum = block;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index bec96a6..acb3570 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -636,7 +636,7 @@ static int udf_mknod(struct inode *dir, struct dentry *dentry, int mode,
 	if (!inode)
 		goto out;
 
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current->cred->uid;
 	init_special_inode(inode, mode, rdev);
 	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err))) {
 		inode->i_nlink--;
diff --git a/fs/ufs/ialloc.c b/fs/ufs/ialloc.c
index c28a8b6..f0fc61d 100644
--- a/fs/ufs/ialloc.c
+++ b/fs/ufs/ialloc.c
@@ -303,13 +303,13 @@ cg_found:
 
 	inode->i_ino = cg * uspi->s_ipg + bit;
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current->cred->uid;
 	if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			inode->i_mode |= S_ISGID;
 	} else
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current->cred->gid;
 
 	inode->i_blocks = 0;
 	inode->i_generation = 0;
diff --git a/fs/xfs/linux-2.6/xfs_cred.h b/fs/xfs/linux-2.6/xfs_cred.h
index e7f3da6..957bbe3 100644
--- a/fs/xfs/linux-2.6/xfs_cred.h
+++ b/fs/xfs/linux-2.6/xfs_cred.h
@@ -23,9 +23,7 @@
 /*
  * Credentials
  */
-typedef struct cred {
-	/* EMPTY */
-} cred_t;
+typedef struct cred cred_t;
 
 extern struct cred *sys_cred;
 
diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index 330c4ba..73ac671 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -127,8 +127,8 @@
 
 #define current_cpu()		(raw_smp_processor_id())
 #define current_pid()		(current->pid)
-#define current_fsuid(cred)	(current->fsuid)
-#define current_fsgid(cred)	(current->fsgid)
+#define current_fsuid(_cred)	(current->cred->uid)
+#define current_fsgid(_cred)	(current->cred->gid)
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
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 91c8c07..f20f057 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -39,6 +39,7 @@ struct linux_binprm{
 	int e_uid, e_gid;
 	kernel_cap_t cap_inheritable, cap_permitted, cap_effective;
 	void *security;
+	struct cred *cred;
 	int argc, envc;
 	char * filename;	/* Name of binary as seen by procps */
 	char * interp;		/* Name of the binary really executed. Most
diff --git a/include/linux/cred.h b/include/linux/cred.h
new file mode 100644
index 0000000..6ec0132
--- /dev/null
+++ b/include/linux/cred.h
@@ -0,0 +1,163 @@
+/* Credentials management
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_CRED_H
+#define _LINUX_CRED_H
+
+#include <linux/rcupdate.h>
+
+#ifdef __KERNEL__
+
+/*
+ * credentials record
+ * - COW semantics apply
+ */
+struct cred {
+	atomic_t		usage;
+	uid_t			uid;		/* fsuid as was */
+	gid_t			gid;		/* fsgid as was */
+	struct rcu_head		exterminate;	/* cred destroyer */
+	struct group_info	*group_info;
+};
+
+extern struct cred init_cred;
+
+struct inode;
+
+extern struct cred *dup_cred(const struct cred *);
+extern void put_cred(struct cred *);
+extern void change_fsuid(struct cred *, uid_t);
+extern void change_fsgid(struct cred *, gid_t);
+extern void change_groups(struct cred *, struct group_info *);
+
+/**
+ * get_cred - Get an extra reference on a credentials record
+ * @cred: The credentials record to reference
+ *
+ * Get an extra reference on a credentials record.  This must be released by
+ * calling put_cred().
+ */
+static inline struct cred *get_cred(struct cred *cred)
+{
+	atomic_inc(&cred->usage);
+	return cred;
+}
+
+/**
+ * get_current_cred - Get an extra reference on the current's credentials record
+ *
+ * Get an extra reference on the credentials record attached to the current
+ * task.  This must be released by calling put_cred().
+ */
+#define get_current_cred() \
+	({ get_cred(current->cred); })
+
+/**
+ * task_cred - Access the credentials of another task
+ * @tsk: The task to access
+ *
+ * Get a pointer to the credentials record of the given task.  The caller must
+ * have done rcu_read_lock() first.  The credentials record is can only be
+ * accessed as long as the RCU readlock is held by the caller.  If the
+ * credentials are required for longer, then a reference should be obtained on
+ * the cred struct.
+ *
+ * This is not required for the a task to access its own credentials.  Tasks
+ * may not alter the credentials of other tasks.
+ */
+#define task_cred(tsk) \
+	({ rcu_dereference((tsk)->cred); })
+
+/**
+ * __task_fsuid - Get the FSUID of another task (caller holds RCU read lock)
+ * task_fsuid - Get the FSUID of another task
+ * @tsk: The task to access
+ *
+ * Get the active filesystem access UID of another task.  __task_fsuid()
+ * requires the caller to hold the RCU read lock, task_fsuid() does not.
+ */
+#define __task_fsuid(tsk)	(task_cred(tsk)->uid)
+#define task_fsuid(tsk)				\
+({						\
+	uid_t ____x;				\
+	rcu_read_lock();			\
+	____x = __task_fsuid(tsk);		\
+	rcu_read_unlock();			\
+	____x;					\
+})
+
+/**
+ * __task_fsgid - Get the FSGID of another task (caller holds RCU read lock)
+ * task_fsgid - Get the FSGID of another task
+ * @tsk: The task to access
+ *
+ * Get the active filesystem access GID of another task.  __task_fsgid()
+ * requires the caller to hold the RCU read lock, task_fsgid() does not.
+ */
+#define __task_fsgid(tsk)	(task_cred(tsk)->gid)
+#define task_fsgid(tsk)				\
+({						\
+	gid_t ____x;				\
+	rcu_read_lock();			\
+	____x = __task_fsgid(tsk);		\
+	rcu_read_unlock();			\
+	____x;					\
+})
+
+/**
+ * get_task_cred - Get an extra reference on a credentials record of a task
+ * @tsk: The task to look in
+ *
+ * Get an extra reference on a credentials record of the given task and return
+ * a pointer to it.  This must be released by calling put_cred().  The caller
+ * must have done rcu_read_lock() first.
+ */
+#define get_task_cred(tsk) \
+	({ get_cred(task_cred((tsk))); })
+
+/**
+ * __set_current_cred - Swap the current credentials on the current task
+ * @cred: The revised credentials
+ *
+ * Exchange the credential record of the current task for an updated one.  This
+ * transfers a reference on the passed credential to the current task_struct,
+ * so the caller may need to get an extra reference first.  The old credentials
+ * are returned and must be disposed of appropriately.
+ *
+ * Write-locking is achieved by the fact that a thread's credentials may only
+ * be changed by that thread itself, so no explicit locking is required.
+ */
+#define __set_current_cred(CRED)			\
+({							\
+	struct cred *___old = current->cred;		\
+	rcu_assign_pointer(current->cred, (CRED));	\
+	___old;						\
+})
+
+/**
+ * set_current_cred - Change the current credentials on the current task
+ * @cred: The revised credentials
+ *
+ * Exchange the credential record of the current task for an updated one.  This
+ * transfers a reference on the passed credential to the current task_struct,
+ * so the caller may need to get an extra reference first.  The old credentials
+ * are released.
+ *
+ * Write-locking is achieved by the fact that a thread's credentials may only
+ * be changed by that thread itself, so no explicit locking is required.
+ */
+#define set_current_cred(CRED)				\
+do {							\
+	put_cred(__set_current_cred(CRED));		\
+} while (0)
+
+#endif /* __KERNEL__ */
+#endif /* _LINUX_CRED_H */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 42aabc1..1be33c8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -285,6 +285,7 @@ extern int dir_notify_enable;
 #include <linux/mutex.h>
 #include <linux/sysctl.h>
 #include <linux/capability.h>
+#include <linux/cred.h>
 
 #include <asm/atomic.h>
 #include <asm/semaphore.h>
@@ -736,7 +737,7 @@ struct file {
 	mode_t			f_mode;
 	loff_t			f_pos;
 	struct fown_struct	f_owner;
-	unsigned int		f_uid, f_gid;
+	struct cred		*f_cred;
 	struct file_ra_state	f_ra;
 
 	unsigned long		f_version;
@@ -999,7 +1000,7 @@ enum {
 #define has_fs_excl() atomic_read(&current->fs_excl)
 
 #define is_owner_or_cap(inode)	\
-	((current->fsuid == (inode)->i_uid) || capable(CAP_FOWNER))
+	((current->cred->uid == (inode)->i_uid) || capable(CAP_FOWNER))
 
 /* not quite ready to be deprecated, but... */
 extern void lock_super(struct super_block *);
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 513bc3e..2ff9d8e 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -91,8 +91,6 @@ extern struct nsproxy init_nsproxy;
 	.signalfd_wqh	= __WAIT_QUEUE_HEAD_INITIALIZER(sighand.signalfd_wqh),	\
 }
 
-extern struct group_info init_groups;
-
 #define INIT_STRUCT_PID {						\
 	.count 		= ATOMIC_INIT(1),				\
 	.nr		= 0, 						\
@@ -144,7 +142,7 @@ extern struct group_info init_groups;
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
 	.group_leader	= &tsk,						\
-	.group_info	= &init_groups,					\
+	.cred		= &init_cred,					\
 	.cap_effective	= CAP_INIT_EFF_SET,				\
 	.cap_inheritable = CAP_INIT_INH_SET,				\
 	.cap_permitted	= CAP_FULL_SET,					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 833f7dc..fee8b1e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -80,6 +80,7 @@ struct sched_param {
 #include <linux/rcupdate.h>
 #include <linux/futex.h>
 #include <linux/rtmutex.h>
+#include <linux/cred.h>
 
 #include <linux/time.h>
 #include <linux/param.h>
@@ -1034,9 +1035,9 @@ struct task_struct {
 	struct list_head cpu_timers[3];
 
 /* process credentials */
-	uid_t uid,euid,suid,fsuid;
-	gid_t gid,egid,sgid,fsgid;
-	struct group_info *group_info;
+	struct cred *cred;
+	uid_t uid,euid,suid;
+	gid_t gid,egid,sgid;
 	kernel_cap_t   cap_effective, cap_inheritable, cap_permitted;
 	unsigned keep_capabilities:1;
 	struct user_struct *user;
diff --git a/include/linux/sunrpc/auth.h b/include/linux/sunrpc/auth.h
index 7a69ca3..8f97f9a 100644
--- a/include/linux/sunrpc/auth.h
+++ b/include/linux/sunrpc/auth.h
@@ -21,13 +21,6 @@
 /* size of the nodename buffer */
 #define UNX_MAXNODENAME	32
 
-/* Work around the lack of a VFS credential */
-struct auth_cred {
-	uid_t	uid;
-	gid_t	gid;
-	struct group_info *group_info;
-};
-
 /*
  * Client user credentials
  */
@@ -94,6 +87,7 @@ struct rpc_auth {
 /*
  * Client authentication ops
  */
+struct cred;
 struct rpc_authops {
 	struct module		*owner;
 	rpc_authflavor_t	au_flavor;	/* flavor (RPC_AUTH_*) */
@@ -103,8 +97,8 @@ struct rpc_authops {
 	struct rpc_auth *	(*create)(struct rpc_clnt *, rpc_authflavor_t);
 	void			(*destroy)(struct rpc_auth *);
 
-	struct rpc_cred *	(*lookup_cred)(struct rpc_auth *, struct auth_cred *, int);
-	struct rpc_cred *	(*crcreate)(struct rpc_auth*, struct auth_cred *, int);
+	struct rpc_cred *	(*lookup_cred)(struct rpc_auth *, struct cred *, int);
+	struct rpc_cred *	(*crcreate)(struct rpc_auth*, struct cred *, int);
 };
 
 struct rpc_credops {
@@ -112,7 +106,7 @@ struct rpc_credops {
 	int			(*cr_init)(struct rpc_auth *, struct rpc_cred *);
 	void			(*crdestroy)(struct rpc_cred *);
 
-	int			(*crmatch)(struct auth_cred *, struct rpc_cred *, int);
+	int			(*crmatch)(struct cred *, struct rpc_cred *, int);
 	__be32 *		(*crmarshal)(struct rpc_task *, __be32 *);
 	int			(*crrefresh)(struct rpc_task *);
 	__be32 *		(*crvalidate)(struct rpc_task *, __be32 *);
@@ -133,8 +127,8 @@ int			rpcauth_register(const struct rpc_authops *);
 int			rpcauth_unregister(const struct rpc_authops *);
 struct rpc_auth *	rpcauth_create(rpc_authflavor_t, struct rpc_clnt *);
 void			rpcauth_release(struct rpc_auth *);
-struct rpc_cred *	rpcauth_lookup_credcache(struct rpc_auth *, struct auth_cred *, int);
-void			rpcauth_init_cred(struct rpc_cred *, const struct auth_cred *, struct rpc_auth *, const struct rpc_credops *);
+struct rpc_cred *	rpcauth_lookup_credcache(struct rpc_auth *, struct cred *, int);
+void			rpcauth_init_cred(struct rpc_cred *, const struct cred *, struct rpc_auth *, const struct rpc_credops *);
 struct rpc_cred *	rpcauth_lookupcred(struct rpc_auth *, int);
 struct rpc_cred *	rpcauth_bindcred(struct rpc_task *);
 void			rpcauth_holdcred(struct rpc_task *);
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 24df334..d3d97ab 100644
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
diff --git a/kernel/Makefile b/kernel/Makefile
index 2a99983..1f1f17b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o die_notifier.o \
-	    utsname.o
+	    utsname.o cred.o
 
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 04f3ffb..282e041 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -303,7 +303,8 @@ static int audit_filter_rules(struct task_struct *tsk,
 			result = audit_comparator(tsk->suid, f->op, f->val);
 			break;
 		case AUDIT_FSUID:
-			result = audit_comparator(tsk->fsuid, f->op, f->val);
+			result = audit_comparator(task_fsuid(tsk), f->op,
+						  f->val);
 			break;
 		case AUDIT_GID:
 			result = audit_comparator(tsk->gid, f->op, f->val);
@@ -315,7 +316,8 @@ static int audit_filter_rules(struct task_struct *tsk,
 			result = audit_comparator(tsk->sgid, f->op, f->val);
 			break;
 		case AUDIT_FSGID:
-			result = audit_comparator(tsk->fsgid, f->op, f->val);
+			result = audit_comparator(task_fsgid(tsk), f->op,
+						  f->val);
 			break;
 		case AUDIT_PERS:
 			result = audit_comparator(tsk->personality, f->op, f->val);
@@ -885,12 +887,15 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	context->gid = tsk->gid;
 	context->euid = tsk->euid;
 	context->suid = tsk->suid;
-	context->fsuid = tsk->fsuid;
 	context->egid = tsk->egid;
 	context->sgid = tsk->sgid;
-	context->fsgid = tsk->fsgid;
 	context->personality = tsk->personality;
 
+	rcu_read_lock();
+	context->fsuid = __task_fsuid(tsk);
+	context->fsgid = __task_fsgid(tsk);
+	rcu_read_unlock();
+
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_SYSCALL);
 	if (!ab)
 		return;		/* audit_panic has been called */
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
diff --git a/kernel/cred.c b/kernel/cred.c
new file mode 100644
index 0000000..35a2d43
--- /dev/null
+++ b/kernel/cred.c
@@ -0,0 +1,123 @@
+/* Credential caching/management
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/security.h>
+#include <linux/key.h>
+#include "kernel-int.h"
+
+/*
+ * the credentials for the init task
+ * - the usage count is elevated so that this is never freed
+ */
+struct cred init_cred = {
+	.usage		= ATOMIC_INIT(2),
+	.group_info	= &init_groups,
+};
+
+EXPORT_SYMBOL(init_cred);
+
+/**
+ * dup_cred - Duplicate a credentials structure
+ * @pcred: The credentials record to duplicate
+ *
+ * Duplicate and return a credentials structure so that the copy can be
+ * modified.  NULL is returned if there is insufficient memory to make the
+ * copy.
+ */
+struct cred *dup_cred(const struct cred *pcred)
+{
+	struct cred *cred;
+
+	cred = kmalloc(sizeof(struct cred), GFP_KERNEL);
+	if (likely(cred)) {
+		*cred = *pcred;
+		atomic_set(&cred->usage, 1);
+		get_group_info(cred->group_info);
+	}
+	return cred;
+}
+
+EXPORT_SYMBOL(dup_cred);
+
+/*
+ * RCU-based credentials destroyer
+ */
+static void put_cred_rcu(struct rcu_head *rcu)
+{
+	struct cred *cred = container_of(rcu, struct cred, exterminate);
+
+	put_group_info(cred->group_info);
+	kfree(cred);
+}
+
+/**
+ * put_cred - Release a reference to a credentials record
+ * cred: The credentials record to release
+ *
+ * Release a reference to a credentials record.  When the last reference is
+ * released, the record will be deleted with due care for RCU accesses still
+ * ongoing.
+ */
+void put_cred(struct cred *cred)
+{
+	if (atomic_dec_and_test(&cred->usage))
+		call_rcu(&cred->exterminate, put_cred_rcu);
+}
+
+EXPORT_SYMBOL(put_cred);
+
+/**
+ * change_fsuid - Change the VFS applicable UID in a new credential record
+ * @cred: The credential record to alter
+ * @uid: The user ID to set
+ *
+ * Change the VFS access and creation user ID in a new credential record.
+ */
+void change_fsuid(struct cred *cred, uid_t uid)
+{
+	cred->uid = uid;
+}
+
+EXPORT_SYMBOL(change_fsuid);
+
+/**
+ * change_fsgid - Change the VFS applicable GID in a new credential record
+ * @cred: The credential record to alter
+ * @gid: The group ID to set
+ *
+ * Change the VFS access and creation group ID in a new credential record.
+ */
+void change_fsgid(struct cred *cred, gid_t gid)
+{
+	cred->gid = gid;
+}
+
+EXPORT_SYMBOL(change_fsgid);
+
+/**
+ * change_groups - Change the supplementary groups in a new credential record
+ * @cred: The credential record to alter
+ * @group_info: The supplementary groups to attach
+ *
+ * Change the VFS access supplementary group list in a new credential record.
+ */
+void change_groups(struct cred *cred, struct group_info *group_info)
+{
+	struct group_info *old = cred->group_info;
+
+	get_group_info(group_info);
+	cred->group_info = group_info;
+	put_group_info(old);
+}
+
+EXPORT_SYMBOL(change_groups);
diff --git a/kernel/exit.c b/kernel/exit.c
index 993369e..c366ae7 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -288,6 +288,7 @@ static void reparent_to_kthreadd(void)
 	/* cpus_allowed? */
 	/* rt_priority? */
 	/* signals? */
+	set_current_cred(get_cred(&init_cred));
 	security_task_reparent_to_init(current);
 	memcpy(current->signal->rlim, init_task.signal->rlim,
 	       sizeof(current->signal->rlim));
diff --git a/kernel/fork.c b/kernel/fork.c
index 5e67f90..b1f8899 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -121,7 +121,7 @@ void __put_task_struct(struct task_struct *tsk)
 
 	security_task_free(tsk);
 	free_uid(tsk->user);
-	put_group_info(tsk->group_info);
+	put_cred(tsk->cred);
 	delayacct_tsk_free(tsk);
 
 	if (!profile_handoff_task(tsk))
@@ -949,6 +949,16 @@ static inline void rt_mutex_init_task(struct task_struct *p)
 }
 
 /*
+ * Copy a set of credentials
+ * - share it unless it contains something we can't copy
+ */
+static int copy_cred(struct task_struct *p)
+{
+	atomic_inc(&p->cred->usage);
+	return 0;
+}
+
+/*
  * This creates a new process as a copy of the old one,
  * but does not actually start it yet.
  *
@@ -1010,7 +1020,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	atomic_inc(&p->user->__count);
 	atomic_inc(&p->user->processes);
-	get_group_info(p->group_info);
+	if ((retval = copy_cred(p) < 0))
+		goto bad_fork_cleanup_count;
 
 	/*
 	 * If multiple threads are within copy_process(), then this check
@@ -1018,10 +1029,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 * to stop root fork bombs.
 	 */
 	if (nr_threads >= max_threads)
-		goto bad_fork_cleanup_count;
+		goto bad_fork_cleanup_cred;
 
 	if (!try_module_get(task_thread_info(p)->exec_domain->module))
-		goto bad_fork_cleanup_count;
+		goto bad_fork_cleanup_cred;
 
 	if (p->binfmt && !try_module_get(p->binfmt->module))
 		goto bad_fork_cleanup_put_domain;
@@ -1309,8 +1320,9 @@ bad_fork_cleanup_delays_binfmt:
 		module_put(p->binfmt->module);
 bad_fork_cleanup_put_domain:
 	module_put(task_thread_info(p)->exec_domain->module);
+bad_fork_cleanup_cred:
+	put_cred(p->cred);
 bad_fork_cleanup_count:
-	put_group_info(p->group_info);
 	atomic_dec(&p->user->processes);
 	free_uid(p->user);
 bad_fork_free:
diff --git a/kernel/kernel-int.h b/kernel/kernel-int.h
new file mode 100644
index 0000000..16c68e3
--- /dev/null
+++ b/kernel/kernel-int.h
@@ -0,0 +1,15 @@
+/* kernel/ internal definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+/*
+ * sys.c
+ */
+extern struct group_info init_groups;
diff --git a/kernel/sys.c b/kernel/sys.c
index 8ae2e63..ff25530 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -42,6 +42,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/unistd.h>
+#include "kernel-int.h"
 
 #ifndef SET_UNALIGN_CTL
 # define SET_UNALIGN_CTL(a,b)	(-EINVAL)
@@ -1013,6 +1014,7 @@ void ctrl_alt_del(void)
  */
 asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 {
+	struct cred *cred;
 	int old_rgid = current->gid;
 	int old_egid = current->egid;
 	int new_rgid = old_rgid;
@@ -1040,6 +1042,11 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 		else
 			return -EPERM;
 	}
+
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (new_egid != old_egid) {
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
@@ -1047,9 +1054,10 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 	if (rgid != (gid_t) -1 ||
 	    (egid != (gid_t) -1 && egid != old_rgid))
 		current->sgid = new_egid;
-	current->fsgid = new_egid;
 	current->egid = new_egid;
 	current->gid = new_rgid;
+	change_fsgid(cred, new_egid);
+	set_current_cred(cred);
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
 	return 0;
@@ -1062,6 +1070,7 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
  */
 asmlinkage long sys_setgid(gid_t gid)
 {
+	struct cred *cred;
 	int old_egid = current->egid;
 	int retval;
 
@@ -1069,22 +1078,29 @@ asmlinkage long sys_setgid(gid_t gid)
 	if (retval)
 		return retval;
 
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (capable(CAP_SETGID)) {
 		if (old_egid != gid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->gid = current->egid = current->sgid = current->fsgid = gid;
+		current->gid = current->egid = current->sgid = gid;
 	} else if ((gid == current->gid) || (gid == current->sgid)) {
 		if (old_egid != gid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->egid = current->fsgid = gid;
-	}
-	else
+		current->egid = gid;
+	} else {
+		put_cred(cred);
 		return -EPERM;
+	}
 
+	change_fsgid(cred, gid);
+	set_current_cred(cred);
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
 	return 0;
@@ -1132,6 +1148,7 @@ static int set_user(uid_t new_ruid, int dumpclear)
  */
 asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 {
+	struct cred *cred;
 	int old_ruid, old_euid, old_suid, new_ruid, new_euid;
 	int retval;
 
@@ -1160,19 +1177,26 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 			return -EPERM;
 	}
 
-	if (new_ruid != old_ruid && set_user(new_ruid, new_euid != old_euid) < 0)
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
+	if (new_ruid != old_ruid && set_user(new_ruid, new_euid != old_euid) < 0) {
+		put_cred(cred);
 		return -EAGAIN;
+	}
 
 	if (new_euid != old_euid) {
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
-	current->fsuid = current->euid = new_euid;
+	current->euid = new_euid;
 	if (ruid != (uid_t) -1 ||
 	    (euid != (uid_t) -1 && euid != old_ruid))
 		current->suid = current->euid;
-	current->fsuid = current->euid;
 
+	change_fsuid(cred, new_euid);
+	set_current_cred(cred);
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
 
@@ -1194,6 +1218,7 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
  */
 asmlinkage long sys_setuid(uid_t uid)
 {
+	struct cred *cred;
 	int old_euid = current->euid;
 	int old_ruid, old_suid, new_suid;
 	int retval;
@@ -1202,24 +1227,33 @@ asmlinkage long sys_setuid(uid_t uid)
 	if (retval)
 		return retval;
 
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	old_ruid = current->uid;
 	old_suid = current->suid;
 	new_suid = old_suid;
 	
 	if (capable(CAP_SETUID)) {
-		if (uid != old_ruid && set_user(uid, old_euid != uid) < 0)
+		if (uid != old_ruid && set_user(uid, old_euid != uid) < 0) {
+			put_cred(cred);
 			return -EAGAIN;
+		}
 		new_suid = uid;
-	} else if ((uid != current->uid) && (uid != new_suid))
+	} else if ((uid != current->uid) && (uid != new_suid)) {
+		put_cred(cred);
 		return -EPERM;
+	}
 
 	if (old_euid != uid) {
 		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
-	current->fsuid = current->euid = uid;
+	current->euid = uid;
 	current->suid = new_suid;
-
+	change_fsuid(cred, uid);
+	set_current_cred(cred);
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
 
@@ -1233,6 +1267,7 @@ asmlinkage long sys_setuid(uid_t uid)
  */
 asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 {
+	struct cred *cred;
 	int old_ruid = current->uid;
 	int old_euid = current->euid;
 	int old_suid = current->suid;
@@ -1253,9 +1288,16 @@ asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 		    (suid != current->euid) && (suid != current->suid))
 			return -EPERM;
 	}
+
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (ruid != (uid_t) -1) {
-		if (ruid != current->uid && set_user(ruid, euid != current->euid) < 0)
+		if (ruid != current->uid && set_user(ruid, euid != current->euid) < 0) {
+			put_cred(cred);
 			return -EAGAIN;
+		}
 	}
 	if (euid != (uid_t) -1) {
 		if (euid != current->euid) {
@@ -1264,10 +1306,10 @@ asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 		}
 		current->euid = euid;
 	}
-	current->fsuid = current->euid;
 	if (suid != (uid_t) -1)
 		current->suid = suid;
-
+	change_fsuid(cred, current->euid);
+	set_current_cred(cred);
 	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
 
@@ -1290,6 +1332,7 @@ asmlinkage long sys_getresuid(uid_t __user *ruid, uid_t __user *euid, uid_t __us
  */
 asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 {
+	struct cred *cred;
 	int retval;
 
 	retval = security_task_setgid(rgid, egid, sgid, LSM_SETID_RES);
@@ -1307,6 +1350,11 @@ asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 		    (sgid != current->egid) && (sgid != current->sgid))
 			return -EPERM;
 	}
+
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (egid != (gid_t) -1) {
 		if (egid != current->egid) {
 			set_dumpable(current->mm, suid_dumpable);
@@ -1314,12 +1362,13 @@ asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 		}
 		current->egid = egid;
 	}
-	current->fsgid = current->egid;
 	if (rgid != (gid_t) -1)
 		current->gid = rgid;
 	if (sgid != (gid_t) -1)
 		current->sgid = sgid;
 
+	change_fsgid(cred, current->egid);
+	set_current_cred(cred);
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
 	return 0;
@@ -1345,23 +1394,31 @@ asmlinkage long sys_getresgid(gid_t __user *rgid, gid_t __user *egid, gid_t __us
  */
 asmlinkage long sys_setfsuid(uid_t uid)
 {
+	struct cred *cred;
 	int old_fsuid;
 
-	old_fsuid = current->fsuid;
+	old_fsuid = current->cred->uid;
 	if (security_task_setuid(uid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS))
 		return old_fsuid;
 
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (uid == current->uid || uid == current->euid ||
-	    uid == current->suid || uid == current->fsuid || 
+	    uid == current->suid || uid == current->cred->uid ||
 	    capable(CAP_SETUID)) {
 		if (uid != old_fsuid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->fsuid = uid;
+		change_fsuid(cred, uid);
+		set_current_cred(cred);
+		key_fsuid_changed(current);
+	} else {
+		put_cred(cred);
 	}
 
-	key_fsuid_changed(current);
 	proc_id_connector(current, PROC_EVENT_UID);
 
 	security_task_post_setuid(old_fsuid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS);
@@ -1374,22 +1431,30 @@ asmlinkage long sys_setfsuid(uid_t uid)
  */
 asmlinkage long sys_setfsgid(gid_t gid)
 {
+	struct cred *cred;
 	int old_fsgid;
 
-	old_fsgid = current->fsgid;
+	old_fsgid = current->cred->gid;
 	if (security_task_setgid(gid, (gid_t)-1, (gid_t)-1, LSM_SETID_FS))
 		return old_fsgid;
 
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
+
 	if (gid == current->gid || gid == current->egid ||
-	    gid == current->sgid || gid == current->fsgid || 
+	    gid == current->sgid || gid == current->cred->gid ||
 	    capable(CAP_SETGID)) {
 		if (gid != old_fsgid) {
 			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
-		current->fsgid = gid;
+		change_fsgid(cred, gid);
+		set_current_cred(cred);
 		key_fsgid_changed(current);
 		proc_id_connector(current, PROC_EVENT_GID);
+	} else {
+		put_cred(cred);
 	}
 	return old_fsgid;
 }
@@ -1756,23 +1821,20 @@ int groups_search(struct group_info *group_info, gid_t grp)
 /* validate and set current->group_info */
 int set_current_groups(struct group_info *group_info)
 {
+	struct cred *cred;
 	int retval;
-	struct group_info *old_info;
 
 	retval = security_task_setgroups(group_info);
 	if (retval)
 		return retval;
 
-	groups_sort(group_info);
-	get_group_info(group_info);
-
-	task_lock(current);
-	old_info = current->group_info;
-	current->group_info = group_info;
-	task_unlock(current);
-
-	put_group_info(old_info);
+	cred = dup_cred(current->cred);
+	if (!cred)
+		return -ENOMEM;
 
+	groups_sort(group_info);
+	change_groups(cred, group_info);
+	set_current_cred(cred);
 	return 0;
 }
 
@@ -1780,24 +1842,24 @@ EXPORT_SYMBOL(set_current_groups);
 
 asmlinkage long sys_getgroups(int gidsetsize, gid_t __user *grouplist)
 {
+	struct group_info *group_info = current->cred->group_info;
 	int i = 0;
 
 	/*
-	 *	SMP: Nobody else can change our grouplist. Thus we are
-	 *	safe.
+	 *	SMP: Nobody else can change our credentials.  Thus we are safe.
 	 */
 
 	if (gidsetsize < 0)
 		return -EINVAL;
 
 	/* no need to grab task_lock here; it cannot change */
-	i = current->group_info->ngroups;
+	i = group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups_to_user(grouplist, current->group_info)) {
+		if (groups_to_user(grouplist, group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
@@ -1841,9 +1903,11 @@ asmlinkage long sys_setgroups(int gidsetsize, gid_t __user *grouplist)
  */
 int in_group_p(gid_t grp)
 {
+	struct cred *cred = current->cred;
 	int retval = 1;
-	if (grp != current->fsgid)
-		retval = groups_search(current->group_info, grp);
+
+	if (grp != cred->gid)
+		retval = groups_search(cred->group_info, grp);
 	return retval;
 }
 
@@ -1853,7 +1917,7 @@ int in_egroup_p(gid_t grp)
 {
 	int retval = 1;
 	if (grp != current->egid)
-		retval = groups_search(current->group_info, grp);
+		retval = groups_search(current->cred->group_info, grp);
 	return retval;
 }
 
diff --git a/kernel/uid16.c b/kernel/uid16.c
index dd308ba..5a8b95e 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -161,25 +161,24 @@ static int groups16_from_user(struct group_info *group_info,
 
 asmlinkage long sys_getgroups16(int gidsetsize, old_gid_t __user *grouplist)
 {
+	struct group_info *group_info = current->cred->group_info;
 	int i = 0;
 
 	if (gidsetsize < 0)
 		return -EINVAL;
 
-	get_group_info(current->group_info);
-	i = current->group_info->ngroups;
+	i = group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups16_to_user(grouplist, current->group_info)) {
+		if (groups16_to_user(grouplist, group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
 	}
 out:
-	put_group_info(current->group_info);
 	return i;
 }
 
diff --git a/mm/shmem.c b/mm/shmem.c
index fcd19d3..e1fa1c3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1394,8 +1394,8 @@ shmem_get_inode(struct super_block *sb, int mode, dev_t dev)
 	inode = new_inode(sb);
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current->cred->uid;
+		inode->i_gid = current->cred->gid;
 		inode->i_blocks = 0;
 		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_mapping->backing_dev_info = &shmem_backing_dev_info;
@@ -2212,8 +2212,8 @@ static int shmem_fill_super(struct super_block *sb,
 	struct inode *inode;
 	struct dentry *root;
 	int mode   = S_IRWXUGO | S_ISVTX;
-	uid_t uid = current->fsuid;
-	gid_t gid = current->fsgid;
+	uid_t uid = current->cred->uid;
+	gid_t gid = current->cred->gid;
 	int err = -ENOMEM;
 	struct shmem_sb_info *sbinfo;
 	unsigned long blocks = 0;
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
 
diff --git a/net/socket.c b/net/socket.c
index 379b3a3..dc40a5e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -484,8 +484,8 @@ static struct socket *sock_alloc(void)
 	sock = SOCKET_I(inode);
 
 	inode->i_mode = S_IFSOCK | S_IRWXUGO;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current->cred->uid;
+	inode->i_gid = current->cred->gid;
 
 	get_cpu_var(sockets_in_use)++;
 	put_cpu_var(sockets_in_use);
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 1ea2755..362a0de 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -267,7 +267,7 @@ rpcauth_cache_shrinker(int nr_to_scan, gfp_t gfp_mask)
  * Look up a process' credentials in the authentication cache
  */
 struct rpc_cred *
-rpcauth_lookup_credcache(struct rpc_auth *auth, struct auth_cred * acred,
+rpcauth_lookup_credcache(struct rpc_auth *auth, struct cred *acred,
 		int flags)
 {
 	LIST_HEAD(free);
@@ -336,23 +336,13 @@ out:
 struct rpc_cred *
 rpcauth_lookupcred(struct rpc_auth *auth, int flags)
 {
-	struct auth_cred acred = {
-		.uid = current->fsuid,
-		.gid = current->fsgid,
-		.group_info = current->group_info,
-	};
-	struct rpc_cred *ret;
-
 	dprintk("RPC:       looking up %s cred\n",
 		auth->au_ops->au_name);
-	get_group_info(acred.group_info);
-	ret = auth->au_ops->lookup_cred(auth, &acred, flags);
-	put_group_info(acred.group_info);
-	return ret;
+	return auth->au_ops->lookup_cred(auth, current->cred, flags);
 }
 
 void
-rpcauth_init_cred(struct rpc_cred *cred, const struct auth_cred *acred,
+rpcauth_init_cred(struct rpc_cred *cred, const struct cred *acred,
 		  struct rpc_auth *auth, const struct rpc_credops *ops)
 {
 	INIT_HLIST_NODE(&cred->cr_hash);
@@ -372,25 +362,18 @@ struct rpc_cred *
 rpcauth_bindcred(struct rpc_task *task)
 {
 	struct rpc_auth *auth = task->tk_client->cl_auth;
-	struct auth_cred acred = {
-		.uid = current->fsuid,
-		.gid = current->fsgid,
-		.group_info = current->group_info,
-	};
 	struct rpc_cred *ret;
 	int flags = 0;
 
 	dprintk("RPC: %5u looking up %s cred\n",
 		task->tk_pid, task->tk_client->cl_auth->au_ops->au_name);
-	get_group_info(acred.group_info);
 	if (task->tk_flags & RPC_TASK_ROOTCREDS)
 		flags |= RPCAUTH_LOOKUP_ROOTCREDS;
-	ret = auth->au_ops->lookup_cred(auth, &acred, flags);
+	ret = auth->au_ops->lookup_cred(auth, current->cred, flags);
 	if (!IS_ERR(ret))
 		task->tk_msg.rpc_cred = ret;
 	else
 		task->tk_status = PTR_ERR(ret);
-	put_group_info(acred.group_info);
 	return ret;
 }
 
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 53995af..bad2698 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -793,13 +793,13 @@ gss_destroy_cred(struct rpc_cred *cred)
  * Lookup RPCSEC_GSS cred for the current process
  */
 static struct rpc_cred *
-gss_lookup_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
+gss_lookup_cred(struct rpc_auth *auth, struct cred *acred, int flags)
 {
 	return rpcauth_lookup_credcache(auth, acred, flags);
 }
 
 static struct rpc_cred *
-gss_create_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
+gss_create_cred(struct rpc_auth *auth, struct cred *acred, int flags)
 {
 	struct gss_auth *gss_auth = container_of(auth, struct gss_auth, rpc_auth);
 	struct gss_cred	*cred = NULL;
@@ -840,7 +840,7 @@ gss_cred_init(struct rpc_auth *auth, struct rpc_cred *cred)
 }
 
 static int
-gss_match(struct auth_cred *acred, struct rpc_cred *rc, int flags)
+gss_match(struct cred *acred, struct rpc_cred *rc, int flags)
 {
 	struct gss_cred *gss_cred = container_of(rc, struct gss_cred, gc_base);
 
diff --git a/net/sunrpc/auth_null.c b/net/sunrpc/auth_null.c
index 537d0e8..c2fcefa 100644
--- a/net/sunrpc/auth_null.c
+++ b/net/sunrpc/auth_null.c
@@ -34,7 +34,7 @@ nul_destroy(struct rpc_auth *auth)
  * Lookup NULL creds for current process
  */
 static struct rpc_cred *
-nul_lookup_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
+nul_lookup_cred(struct rpc_auth *auth, struct cred *acred, int flags)
 {
 	return get_rpccred(&null_cred);
 }
@@ -51,7 +51,7 @@ nul_destroy_cred(struct rpc_cred *cred)
  * Match cred handle against current process
  */
 static int
-nul_match(struct auth_cred *acred, struct rpc_cred *cred, int taskflags)
+nul_match(struct cred *acred, struct rpc_cred *cred, int taskflags)
 {
 	return 1;
 }
diff --git a/net/sunrpc/auth_unix.c b/net/sunrpc/auth_unix.c
index 5ed91e5..f5ab6d7 100644
--- a/net/sunrpc/auth_unix.c
+++ b/net/sunrpc/auth_unix.c
@@ -51,13 +51,13 @@ unx_destroy(struct rpc_auth *auth)
  * Lookup AUTH_UNIX creds for current process
  */
 static struct rpc_cred *
-unx_lookup_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
+unx_lookup_cred(struct rpc_auth *auth, struct cred *acred, int flags)
 {
 	return rpcauth_lookup_credcache(auth, acred, flags);
 }
 
 static struct rpc_cred *
-unx_create_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
+unx_create_cred(struct rpc_auth *auth, struct cred *acred, int flags)
 {
 	struct unx_cred	*cred;
 	int		i;
@@ -115,7 +115,7 @@ unx_destroy_cred(struct rpc_cred *cred)
  * request root creds (e.g. for NFS swapping).
  */
 static int
-unx_match(struct auth_cred *acred, struct rpc_cred *rcred, int flags)
+unx_match(struct cred *acred, struct rpc_cred *rcred, int flags)
 {
 	struct unx_cred	*cred = container_of(rcred, struct unx_cred, uc_base);
 	int		i;
diff --git a/security/commoncap.c b/security/commoncap.c
index 7520361..a39eae7 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -162,8 +162,8 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 		}
 	}
 
-	current->suid = current->euid = current->fsuid = bprm->e_uid;
-	current->sgid = current->egid = current->fsgid = bprm->e_gid;
+	current->suid = current->euid = current->cred->uid = bprm->e_uid;
+	current->sgid = current->egid = current->cred->gid = bprm->e_gid;
 
 	/* For init, we want to retain the capabilities set
 	 * in the init_task struct. Thus we skip the usual
@@ -280,11 +280,11 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
 			 */
 
 			if (!issecure (SECURE_NO_SETUID_FIXUP)) {
-				if (old_fsuid == 0 && current->fsuid != 0) {
+				if (old_fsuid == 0 && current->cred->uid != 0) {
 					cap_t (current->cap_effective) &=
 					    ~CAP_FS_MASK;
 				}
-				if (old_fsuid != 0 && current->fsuid == 0) {
+				if (old_fsuid != 0 && current->cred->uid == 0) {
 					cap_t (current->cap_effective) |=
 					    (cap_t (current->cap_permitted) &
 					     CAP_FS_MASK);
diff --git a/security/dummy.c b/security/dummy.c
index 853ec22..62de89c 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -43,10 +43,12 @@ static int dummy_capget (struct task_struct *target, kernel_cap_t * effective,
 			*permitted |= (~0 & ~CAP_FS_MASK);
 			*effective |= (~0 & ~CAP_TO_MASK(CAP_SETPCAP) & ~CAP_FS_MASK);
 		}
-		if (target->fsuid == 0) {
+		rcu_read_lock();
+		if (task_cred(target)->uid == 0) {
 			*permitted |= CAP_FS_MASK;
 			*effective |= CAP_FS_MASK;
 		}
+		rcu_read_unlock();
 	}
 	return 0;
 }
@@ -138,8 +140,11 @@ static void dummy_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 		}
 	}
 
-	current->suid = current->euid = current->fsuid = bprm->e_uid;
-	current->sgid = current->egid = current->fsgid = bprm->e_gid;
+	current->suid = current->euid = bprm->e_uid;
+	current->sgid = current->egid = bprm->e_gid;
+
+	change_fsuid(bprm->cred, bprm->e_uid);
+	change_fsgid(bprm->cred, bprm->e_gid);
 
 	dummy_capget(current, &current->cap_effective, &current->cap_inheritable, &current->cap_permitted);
 }
@@ -572,7 +577,7 @@ static int dummy_task_prctl (int option, unsigned long arg2, unsigned long arg3,
 
 static void dummy_task_reparent_to_init (struct task_struct *p)
 {
-	p->euid = p->fsuid = 0;
+	p->euid = 0;
 	return;
 }
 
diff --git a/security/keys/key.c b/security/keys/key.c
index 654d23b..c11f408 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -817,7 +817,8 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 		perm |= KEY_USR_WRITE;
 
 	/* allocate a new key */
-	key = key_alloc(ktype, description, current->fsuid, current->fsgid,
+	key = key_alloc(ktype, description,
+			current->cred->uid, current->cred->gid,
 			current, perm, flags);
 	if (IS_ERR(key)) {
 		key_ref = ERR_CAST(key);
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 8ec8432..39e7971 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -806,7 +806,7 @@ long keyctl_setperm_key(key_serial_t id, key_perm_t perm)
 	down_write(&key->sem);
 
 	/* if we're not the sysadmin, we can only change a key that we own */
-	if (capable(CAP_SYS_ADMIN) || key->uid == current->fsuid) {
+	if (capable(CAP_SYS_ADMIN) || key->uid == current->cred->uid) {
 		key->perm = perm;
 		ret = 0;
 	}
diff --git a/security/keys/permission.c b/security/keys/permission.c
index 3b41f9b..f0f0452 100644
--- a/security/keys/permission.c
+++ b/security/keys/permission.c
@@ -22,14 +22,19 @@ int key_task_permission(const key_ref_t key_ref,
 			struct task_struct *context,
 			key_perm_t perm)
 {
+	struct cred *cred;
 	struct key *key;
 	key_perm_t kperm;
 	int ret;
 
+	rcu_read_lock();
+	cred = get_task_cred(context);
+	rcu_read_unlock();
+
 	key = key_ref_to_ptr(key_ref);
 
 	/* use the second 8-bits of permissions for keys the caller owns */
-	if (key->uid == context->fsuid) {
+	if (key->uid == cred->uid) {
 		kperm = key->perm >> 16;
 		goto use_these_perms;
 	}
@@ -37,15 +42,12 @@ int key_task_permission(const key_ref_t key_ref,
 	/* use the third 8-bits of permissions for keys the caller has a group
 	 * membership in common with */
 	if (key->gid != -1 && key->perm & KEY_GRP_ALL) {
-		if (key->gid == context->fsgid) {
+		if (key->gid == cred->gid) {
 			kperm = key->perm >> 8;
 			goto use_these_perms;
 		}
 
-		task_lock(context);
-		ret = groups_search(context->group_info, key->gid);
-		task_unlock(context);
-
+		ret = groups_search(cred->group_info, key->gid);
 		if (ret) {
 			kperm = key->perm >> 8;
 			goto use_these_perms;
@@ -56,6 +58,8 @@ int key_task_permission(const key_ref_t key_ref,
 	kperm = key->perm;
 
 use_these_perms:
+	put_cred(cred);
+
 	/* use the top 8-bits of permissions for keys the caller possesses
 	 * - possessor permissions are additive with other permissions
 	 */
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index c886a2b..b8c1a42 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -357,13 +357,14 @@ int suid_keys(struct task_struct *tsk)
 /*****************************************************************************/
 /*
  * the filesystem user ID changed
+ * - can only be used for current task
  */
 void key_fsuid_changed(struct task_struct *tsk)
 {
 	/* update the ownership of the thread keyring */
 	if (tsk->thread_keyring) {
 		down_write(&tsk->thread_keyring->sem);
-		tsk->thread_keyring->uid = tsk->fsuid;
+		tsk->thread_keyring->uid = tsk->cred->uid;
 		up_write(&tsk->thread_keyring->sem);
 	}
 
@@ -372,13 +373,14 @@ void key_fsuid_changed(struct task_struct *tsk)
 /*****************************************************************************/
 /*
  * the filesystem group ID changed
+ * - can only be used for current task
  */
 void key_fsgid_changed(struct task_struct *tsk)
 {
 	/* update the ownership of the thread keyring */
 	if (tsk->thread_keyring) {
 		down_write(&tsk->thread_keyring->sem);
-		tsk->thread_keyring->gid = tsk->fsgid;
+		tsk->thread_keyring->gid = tsk->cred->gid;
 		up_write(&tsk->thread_keyring->sem);
 	}
 
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 5ecc505..4c2f0e2 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -76,8 +76,8 @@ static int call_sbin_request_key(struct key_construction *cons,
 	/* allocate a new session keyring */
 	sprintf(desc, "_req.%u", key->serial);
 
-	keyring = keyring_alloc(desc, current->fsuid, current->fsgid, current,
-				KEY_ALLOC_QUOTA_OVERRUN, NULL);
+	keyring = keyring_alloc(desc, current->cred->uid, current->cred->gid,
+				current, KEY_ALLOC_QUOTA_OVERRUN, NULL);
 	if (IS_ERR(keyring)) {
 		ret = PTR_ERR(keyring);
 		goto error_alloc;
@@ -89,8 +89,8 @@ static int call_sbin_request_key(struct key_construction *cons,
 		goto error_link;
 
 	/* record the UID and GID */
-	sprintf(uid_str, "%d", current->fsuid);
-	sprintf(gid_str, "%d", current->fsgid);
+	sprintf(uid_str, "%d", current->cred->uid);
+	sprintf(gid_str, "%d", current->cred->gid);
 
 	/* we say which key is under construction */
 	sprintf(key_str, "%d", key->serial);
@@ -277,8 +277,8 @@ static int construct_alloc_key(struct key_type *type,
 	mutex_lock(&user->cons_lock);
 
 	key = key_alloc(type, description,
-			current->fsuid, current->fsgid, current, KEY_POS_ALL,
-			flags);
+			current->cred->uid, current->cred->gid, current,
+			KEY_POS_ALL, flags);
 	if (IS_ERR(key))
 		goto alloc_failed;
 
@@ -339,7 +339,7 @@ static struct key *construct_key_and_link(struct key_type *type,
 	struct key *key;
 	int ret;
 
-	user = key_user_lookup(current->fsuid);
+	user = key_user_lookup(current->cred->uid);
 	if (!user)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index e42b525..82712bf 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -192,7 +192,7 @@ struct key *request_key_auth_new(struct key *target, const char *callout_info)
 	sprintf(desc, "%x", target->serial);
 
 	authkey = key_alloc(&key_type_request_key_auth, desc,
-			    current->fsuid, current->fsgid, current,
+			    current->cred->uid, current->cred->gid, current,
 			    KEY_POS_VIEW | KEY_POS_READ | KEY_POS_SEARCH |
 			    KEY_USR_VIEW, KEY_ALLOC_NOT_IN_QUOTA);
 	if (IS_ERR(authkey)) {

