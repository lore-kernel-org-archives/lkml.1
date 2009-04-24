Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbZDXHHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbZDXHHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZDXHHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:07:13 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:50597 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbZDXHHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:07:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=gOFGanCTGxScdiyuxyfsz1GK88jQcbhkMo3/pwF59mghcjOPyI8BVOTrcmIq70tk21
         Ud6o+4E6W57oxgCSfZPRzuWWSFraQhklWCGgETcabFU0PjnWqbGAjOqnv+T5IsNZ2HmA
         nUb3juBKRmqOOY5U/HaITCm4Z4z4/8MeiLX3g=
From: Alessio Igor Bogani <abogani@texware.it>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 1/1] vfs: umount_begin BKL pushdown v2
Date: Fri, 24 Apr 2009 09:06:53 +0200
Message-Id: <1240556813-8739-2-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1240556813-8739-1-git-send-email-abogani@texware.it>
References: <20090423191934.GW1926@parisc-linux.org>
 <1240556813-8739-1-git-send-email-abogani@texware.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/9p/vfs_super.c |    6 +++++-
 fs/cifs/cifsfs.c  |   15 ++++++++++++---
 fs/fuse/inode.c   |    3 +++
 fs/namespace.c    |    2 --
 fs/nfs/super.c    |    7 ++++++-
 5 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 5f8ab8a..7d23214 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -37,6 +37,7 @@
 #include <linux/mount.h>
 #include <linux/idr.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 
@@ -230,9 +231,12 @@ static int v9fs_show_options(struct seq_file *m, struct vfsmount *mnt)
 static void
 v9fs_umount_begin(struct super_block *sb)
 {
-	struct v9fs_session_info *v9ses = sb->s_fs_info;
+	struct v9fs_session_info *v9ses;
 
+	lock_kernel();
+	v9ses = sb->s_fs_info;
 	v9fs_session_cancel(v9ses);
+	unlock_kernel();
 }
 
 static const struct super_operations v9fs_super_ops = {
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 0d6d8b5..eef568c 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -35,6 +35,7 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/smp_lock.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
 #define DECLARE_GLOBALS_HERE
@@ -520,15 +521,22 @@ static struct quotactl_ops cifs_quotactl_ops = {
 
 static void cifs_umount_begin(struct super_block *sb)
 {
-	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct cifs_sb_info *cifs_sb;
 	struct cifsTconInfo *tcon;
 
-	if (cifs_sb == NULL)
+	lock_kernel();
+	cifs_sb = CIFS_SB(sb);
+
+	if (cifs_sb == NULL) {
+		unlock_kernel();
 		return;
+	}
 
 	tcon = cifs_sb->tcon;
-	if (tcon == NULL)
+	if (tcon == NULL) {
+		unlock_kernel();
 		return;
+	}
 
 	read_lock(&cifs_tcp_ses_lock);
 	if (tcon->tc_count == 1)
@@ -548,6 +556,7 @@ static void cifs_umount_begin(struct super_block *sb)
 	}
 /* BB FIXME - finish add checks for tidStatus BB */
 
+	unlock_kernel();
 	return;
 }
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 459b73d..d1bc4d3 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -19,6 +19,7 @@
 #include <linux/random.h>
 #include <linux/sched.h>
 #include <linux/exportfs.h>
+#include <linux/smp_lock.h>
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
 MODULE_DESCRIPTION("Filesystem in Userspace");
@@ -259,7 +260,9 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 
 static void fuse_umount_begin(struct super_block *sb)
 {
+	lock_kernel();
 	fuse_abort_conn(get_fuse_conn_super(sb));
+	unlock_kernel();
 }
 
 static void fuse_send_destroy(struct fuse_conn *fc)
diff --git a/fs/namespace.c b/fs/namespace.c
index 4119620..0d2003f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1073,9 +1073,7 @@ static int do_umount(struct vfsmount *mnt, int flags)
 	 */
 
 	if (flags & MNT_FORCE && sb->s_op->umount_begin) {
-		lock_kernel();
 		sb->s_op->umount_begin(sb);
-		unlock_kernel();
 	}
 
 	/*
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 6717200..1679a16 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -683,9 +683,12 @@ static int nfs_show_stats(struct seq_file *m, struct vfsmount *mnt)
  */
 static void nfs_umount_begin(struct super_block *sb)
 {
-	struct nfs_server *server = NFS_SB(sb);
+	struct nfs_server *server;
 	struct rpc_clnt *rpc;
 
+	lock_kernel();
+
+	server = NFS_SB(sb);
 	/* -EIO all pending I/O */
 	rpc = server->client_acl;
 	if (!IS_ERR(rpc))
@@ -693,6 +696,8 @@ static void nfs_umount_begin(struct super_block *sb)
 	rpc = server->client;
 	if (!IS_ERR(rpc))
 		rpc_killall_tasks(rpc);
+
+	unlock_kernel();
 }
 
 /*
-- 
1.6.0.4

