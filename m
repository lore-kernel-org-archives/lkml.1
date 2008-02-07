Return-Path: <linux-kernel-owner+w=401wt.eu-S1762218AbYBGUIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762218AbYBGUIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933126AbYBGUDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:03:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:39216 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110AbYBGUDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:03:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mPMvS66wfvUkVM8Si+QlLvkXRWWaWd+bN3eRmERcsGti/OP4C/kAESwQ4xw7deu9tx3ts35wtsoiD1oOZ+Mxy79VkP2ffRHubM53JL+ag4rC/KFeuuoehfeq8mGkz280OqzMP46U0Dl+EqWusPufNqADmd/Vhrc8OCC5Ynyl8Gg=
Message-ID: <6101e8c40802071203n78a10d40ycb414e0b03ce2545@mail.gmail.com>
Date: Thu, 7 Feb 2008 21:03:45 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {11/14} - NFS: Fix nfs_reval_fsid() - on top of 2.6.22.17
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aka: nfs-fix-nfs-reval-fsid.patch

Patch-mainline: 2.6.24
References: 271803
GIT: a0356862bcbeb20acf64bc1a82d28a4c5bb957a7 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Tue, 5 Jun 2007 13:26:15 -0400

Subject: [PATCH] NFS: Fix nfs_reval_fsid()

mainline: a0356862bcbeb20acf64bc1a82d28a4c5bb957a7

We don't need to revalidate the fsid on the root directory. It suffices to
revalidate it on the current directory.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: NeilBrown <neilb@suse.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>

---
 fs/nfs/dir.c   |    9 ++++-----
 fs/nfs/inode.c |    4 ++--
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 4948ec1..c02a796 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -897,14 +897,13 @@ int nfs_is_exclusive_create(struct inode *dir,
struct nameidata *nd)
 	return (nd->intent.open.flags & O_EXCL) != 0;
 }

-static inline int nfs_reval_fsid(struct vfsmount *mnt, struct inode *dir,
-				 struct nfs_fh *fh, struct nfs_fattr *fattr)
+static inline int nfs_reval_fsid(struct inode *dir, const struct
nfs_fattr *fattr)
 {
 	struct nfs_server *server = NFS_SERVER(dir);

 	if (!nfs_fsid_equal(&server->fsid, &fattr->fsid))
-		/* Revalidate fsid on root dir */
-		return __nfs_revalidate_inode(server, mnt->mnt_root->d_inode);
+		/* Revalidate fsid using the parent directory */
+		return __nfs_revalidate_inode(server, dir);
 	return 0;
 }

@@ -946,7 +945,7 @@ static struct dentry *nfs_lookup(struct inode
*dir, struct dentry * dentry, stru
 		res = ERR_PTR(error);
 		goto out_unlock;
 	}
-	error = nfs_reval_fsid(nd->mnt, dir, &fhandle, &fattr);
+	error = nfs_reval_fsid(dir, &fattr);
 	if (error < 0) {
 		res = ERR_PTR(error);
 		goto out_unlock;
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 23ecf03..7bcb3df 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -961,8 +961,8 @@ static int nfs_update_inode(struct inode *inode,
struct nfs_fattr *fattr)
 		goto out_changed;

 	server = NFS_SERVER(inode);
-	/* Update the fsid if and only if this is the root directory */
-	if (inode == inode->i_sb->s_root->d_inode
+	/* Update the fsid? */
+	if (S_ISDIR(inode->i_mode)
 			&& !nfs_fsid_equal(&server->fsid, &fattr->fsid))
 		server->fsid = fattr->fsid;

-- 
1.5.3.6


-- 
Thanks,
Oliver
