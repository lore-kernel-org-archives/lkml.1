Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbZELW0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbZELW0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZELW0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:26:25 -0400
Received: from mx2.netapp.com ([216.240.18.37]:51318 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbZELW0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:26:25 -0400
X-IronPort-AV: E=Sophos;i="4.41,184,1241420400"; 
   d="scan'208";a="171192781"
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH] NFS: Fix the notifications when renaming onto an existing
 file
To: stable@kernel.org
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 12 May 2009 18:24:20 -0400
Message-ID: <20090512222420.6972.25308.stgit@heimdal.trondhjem.org>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 12 May 2009 22:26:20.0678 (UTC) FILETIME=[ACCDC260:01C9D350]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NFS appears to be returning an unnecessary "delete" notification when
we're doing an atomic rename. See

  http://bugzilla.gnome.org/show_bug.cgi?id=575684

The fix is to get rid of the redundant call to d_delete().

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
Please apply to 2.6.27 - 2.6.29 stable series...


 fs/nfs/dir.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)


diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 672368f..3b2f697 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1624,8 +1624,7 @@ static int nfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		} else if (atomic_read(&new_dentry->d_count) > 1)
 			/* dentry still busy? */
 			goto out;
-	} else
-		nfs_drop_nlink(new_inode);
+	}
 
 go_ahead:
 	/*
@@ -1638,10 +1637,8 @@ go_ahead:
 	}
 	nfs_inode_return_delegation(old_inode);
 
-	if (new_inode != NULL) {
+	if (new_inode != NULL)
 		nfs_inode_return_delegation(new_inode);
-		d_delete(new_dentry);
-	}
 
 	error = NFS_PROTO(old_dir)->rename(old_dir, &old_dentry->d_name,
 					   new_dir, &new_dentry->d_name);
@@ -1650,6 +1647,8 @@ out:
 	if (rehash)
 		d_rehash(rehash);
 	if (!error) {
+		if (new_inode != NULL)
+			nfs_drop_nlink(new_inode);
 		d_move(old_dentry, new_dentry);
 		nfs_set_verifier(new_dentry,
 					nfs_save_change_attribute(new_dir));

