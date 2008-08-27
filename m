Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbYH0Nsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbYH0Nsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756732AbYH0Nr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:47:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756426AbYH0NrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:47:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/59] CRED: Wrap task credential accesses in the CIFS
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Steve French <sfrench@samba.org>,
       linux-cifs-client@lists.samba.org
Date: Wed, 27 Aug 2008 14:47:20 +0100
Message-ID: <20080827134720.19980.57458.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Steve French <sfrench@samba.org>
Cc: linux-cifs-client@lists.samba.org
---

 fs/cifs/cifs_fs_sb.h |    2 +-
 fs/cifs/cifsproto.h  |    2 +-
 fs/cifs/connect.c    |    4 ++--
 fs/cifs/dir.c        |   12 ++++++------
 fs/cifs/inode.c      |    8 ++++----
 fs/cifs/ioctl.c      |    2 +-
 fs/cifs/misc.c       |    4 ++--
 7 files changed, 17 insertions(+), 17 deletions(-)


diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 877c854..1e7b874 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -19,7 +19,7 @@
 #define _CIFS_FS_SB_H
 
 #define CIFS_MOUNT_NO_PERM      1 /* do not do client vfs_perm check */
-#define CIFS_MOUNT_SET_UID      2 /* set current->euid in create etc. */
+#define CIFS_MOUNT_SET_UID      2 /* set current's euid in create etc. */
 #define CIFS_MOUNT_SERVER_INUM  4 /* inode numbers from uniqueid from server */
 #define CIFS_MOUNT_DIRECT_IO    8 /* do not write nor read through page cache */
 #define CIFS_MOUNT_NO_XATTR     0x10  /* if set - disable xattr support       */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index a729d08..440c50a 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -39,7 +39,7 @@ extern int smb_send(struct socket *, struct smb_hdr *,
 			unsigned int /* length */ , struct sockaddr *);
 extern unsigned int _GetXid(void);
 extern void _FreeXid(unsigned int);
-#define GetXid() (int)_GetXid(); cFYI(1,("CIFS VFS: in %s as Xid: %d with uid: %d",__func__, xid,current->fsuid));
+#define GetXid() (int)_GetXid(); cFYI(1,("CIFS VFS: in %s as Xid: %d with uid: %d",__func__, xid,current_fsuid()));
 #define FreeXid(curr_xid) {_FreeXid(curr_xid); cFYI(1,("CIFS VFS: leaving %s (xid = %d) rc = %d",__func__,curr_xid,(int)rc));}
 extern char *build_path_from_dentry(struct dentry *);
 extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4c13bcd..c2669c1 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -822,8 +822,8 @@ cifs_parse_mount_options(char *options, const char *devname,
 	/* null target name indicates to use *SMBSERVR default called name
 	   if we end up sending RFC1001 session initialize */
 	vol->target_rfc1001_name[0] = 0;
-	vol->linux_uid = current->uid;	/* current->euid instead? */
-	vol->linux_gid = current->gid;
+	vol->linux_uid = current_uid();  /* use current_euid() instead? */
+	vol->linux_gid = current_gid();
 	vol->dir_mode = S_IRWXUGO;
 	/* 2767 perms indicate mandatory locking support */
 	vol->file_mode = (S_IRWXUGO | S_ISGID) & (~S_IXGRP);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index e962e75..2f02c52 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -235,11 +235,11 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 			};
 
 			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
-				args.uid = (__u64) current->fsuid;
+				args.uid = (__u64) current_fsuid();
 				if (inode->i_mode & S_ISGID)
 					args.gid = (__u64) inode->i_gid;
 				else
-					args.gid = (__u64) current->fsgid;
+					args.gid = (__u64) current_fsgid();
 			} else {
 				args.uid = NO_CHANGE_64;
 				args.gid = NO_CHANGE_64;
@@ -271,13 +271,13 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 				if ((oplock & CIFS_CREATE_ACTION) &&
 				    (cifs_sb->mnt_cifs_flags &
 				     CIFS_MOUNT_SET_UID)) {
-					newinode->i_uid = current->fsuid;
+					newinode->i_uid = current_fsuid();
 					if (inode->i_mode & S_ISGID)
 						newinode->i_gid =
 							inode->i_gid;
 					else
 						newinode->i_gid =
-							current->fsgid;
+							current_fsgid();
 				}
 			}
 		}
@@ -375,8 +375,8 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 			.device	= device_number,
 		};
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
-			args.uid = (__u64) current->fsuid;
-			args.gid = (__u64) current->fsgid;
+			args.uid = (__u64) current_fsuid();
+			args.gid = (__u64) current_fsgid();
 		} else {
 			args.uid = NO_CHANGE_64;
 			args.gid = NO_CHANGE_64;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 9c548f1..d4677ab 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1002,11 +1002,11 @@ mkdir_get_info:
 				.device	= 0,
 			};
 			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
-				args.uid = (__u64)current->fsuid;
+				args.uid = (__u64)current_fsuid();
 				if (inode->i_mode & S_ISGID)
 					args.gid = (__u64)inode->i_gid;
 				else
-					args.gid = (__u64)current->fsgid;
+					args.gid = (__u64)current_fsgid();
 			} else {
 				args.uid = NO_CHANGE_64;
 				args.gid = NO_CHANGE_64;
@@ -1035,13 +1035,13 @@ mkdir_get_info:
 				if (cifs_sb->mnt_cifs_flags &
 				     CIFS_MOUNT_SET_UID) {
 					direntry->d_inode->i_uid =
-						current->fsuid;
+						current_fsuid();
 					if (inode->i_mode & S_ISGID)
 						direntry->d_inode->i_gid =
 							inode->i_gid;
 					else
 						direntry->d_inode->i_gid =
-							current->fsgid;
+							current_fsgid();
 				}
 			}
 		}
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 0088a5b..f946506 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -65,7 +65,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 	switch (command) {
 		case CIFS_IOC_CHECKUMOUNT:
 			cFYI(1, ("User unmount attempted"));
-			if (cifs_sb->mnt_uid == current->uid)
+			if (cifs_sb->mnt_uid == current_uid())
 				rc = 0;
 			else {
 				rc = -EACCES;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 4b17f8f..99f939e 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -351,13 +351,13 @@ header_assemble(struct smb_hdr *buffer, char smb_command /* command */ ,
 		/*  BB Add support for establishing new tCon and SMB Session  */
 		/*      with userid/password pairs found on the smb session   */
 		/*	for other target tcp/ip addresses 		BB    */
-				if (current->fsuid != treeCon->ses->linux_uid) {
+				if (current_fsuid() != treeCon->ses->linux_uid) {
 					cFYI(1, ("Multiuser mode and UID "
 						 "did not match tcon uid"));
 					read_lock(&GlobalSMBSeslock);
 					list_for_each(temp_item, &GlobalSMBSessionList) {
 						ses = list_entry(temp_item, struct cifsSesInfo, cifsSessionList);
-						if (ses->linux_uid == current->fsuid) {
+						if (ses->linux_uid == current_fsuid()) {
 							if (ses->server == treeCon->ses->server) {
 								cFYI(1, ("found matching uid substitute right smb_uid"));
 								buffer->Uid = ses->Suid;

