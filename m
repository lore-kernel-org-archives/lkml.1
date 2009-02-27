Return-Path: <linux-kernel-owner+w=401wt.eu-S1760101AbZB0Ufb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbZB0Ufb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759705AbZB0Uef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:34:35 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59976 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759638AbZB0Ued (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:34:33 -0500
Subject: [RFC][PATCH 3/8] create fs flags to mark c/r supported fs's
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>, hch@infradead.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 27 Feb 2009 12:34:28 -0800
References: <20090227203425.F3B51176@kernel>
In-Reply-To: <20090227203425.F3B51176@kernel>
Message-Id: <20090227203428.556600DA@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are plenty of filesystems that are not supported for
c/r at this point.  Think of things like hugetlbfs which
are externally visible or pipefs which are kernel-internal.

This provides a quick way to mark the filesystems as they
get supported.  We won't mark wery many filesystems
explicitly for now.  That's because we will assume that
FS_REQUIRES_DEV implies FS_CHECKPOINTABLE for now.  This
assumption may need to get overridden in the future, but
it should be OK for now.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/nfs/super.c     |   13 ++++++++-----
 linux-2.6.git-dave/include/linux/fs.h |    1 +
 2 files changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/nfs/super.c~FS_CHECKPOINTABLE-flag fs/nfs/super.c
--- linux-2.6.git/fs/nfs/super.c~FS_CHECKPOINTABLE-flag	2009-02-27 12:07:38.000000000 -0800
+++ linux-2.6.git-dave/fs/nfs/super.c	2009-02-27 12:07:38.000000000 -0800
@@ -233,12 +233,15 @@ static int nfs_xdev_get_sb(struct file_s
 static void nfs_kill_super(struct super_block *);
 static int nfs_remount(struct super_block *sb, int *flags, char *raw_data);
 
+#define NFS_FS_FLAGS FS_RENAME_DOES_D_MOVE|FS_REVAL_DOT|\
+		     FS_BINARY_MOUNTDATA|FS_CHECKPOINTABLE
+
 static struct file_system_type nfs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "nfs",
 	.get_sb		= nfs_get_sb,
 	.kill_sb	= nfs_kill_super,
-	.fs_flags	= FS_RENAME_DOES_D_MOVE|FS_REVAL_DOT|FS_BINARY_MOUNTDATA,
+	.fs_flags	= NFS_FS_FLAGS,
 };
 
 struct file_system_type nfs_xdev_fs_type = {
@@ -246,7 +249,7 @@ struct file_system_type nfs_xdev_fs_type
 	.name		= "nfs",
 	.get_sb		= nfs_xdev_get_sb,
 	.kill_sb	= nfs_kill_super,
-	.fs_flags	= FS_RENAME_DOES_D_MOVE|FS_REVAL_DOT|FS_BINARY_MOUNTDATA,
+	.fs_flags	= NFS_FS_FLAGS,
 };
 
 static const struct super_operations nfs_sops = {
@@ -275,7 +278,7 @@ static struct file_system_type nfs4_fs_t
 	.name		= "nfs4",
 	.get_sb		= nfs4_get_sb,
 	.kill_sb	= nfs4_kill_super,
-	.fs_flags	= FS_RENAME_DOES_D_MOVE|FS_REVAL_DOT|FS_BINARY_MOUNTDATA,
+	.fs_flags	= NFS_FS_FLAGS,
 };
 
 struct file_system_type nfs4_xdev_fs_type = {
@@ -283,7 +286,7 @@ struct file_system_type nfs4_xdev_fs_typ
 	.name		= "nfs4",
 	.get_sb		= nfs4_xdev_get_sb,
 	.kill_sb	= nfs4_kill_super,
-	.fs_flags	= FS_RENAME_DOES_D_MOVE|FS_REVAL_DOT|FS_BINARY_MOUNTDATA,
+	.fs_flags	= NFS_FS_FLAGS,
 };
 
 struct file_system_type nfs4_referral_fs_type = {
@@ -291,7 +294,7 @@ struct file_system_type nfs4_referral_fs
 	.name		= "nfs4",
 	.get_sb		= nfs4_referral_get_sb,
 	.kill_sb	= nfs4_kill_super,
-	.fs_flags	= FS_RENAME_DOES_D_MOVE|FS_REVAL_DOT|FS_BINARY_MOUNTDATA,
+	.fs_flags	= NFS_FS_FLAGS,
 };
 
 static const struct super_operations nfs4_sops = {
diff -puN include/linux/fs.h~FS_CHECKPOINTABLE-flag include/linux/fs.h
--- linux-2.6.git/include/linux/fs.h~FS_CHECKPOINTABLE-flag	2009-02-27 12:07:38.000000000 -0800
+++ linux-2.6.git-dave/include/linux/fs.h	2009-02-27 12:07:38.000000000 -0800
@@ -109,6 +109,7 @@ struct inodes_stat_t {
 #define FS_REQUIRES_DEV 1 
 #define FS_BINARY_MOUNTDATA 2
 #define FS_HAS_SUBTYPE 4
+#define FS_CHECKPOINTABLE 8
 #define FS_REVAL_DOT	16384	/* Check the paths ".", ".." for staleness */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move()
 					 * during rename() internally.
_
