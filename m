Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbXL1Usw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbXL1Usw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbXL1UoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:44:13 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37129 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbXL1Unp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:45 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 16/30] Unionfs: remove unnecessary lock in read_inode
Date: Fri, 28 Dec 2007 15:42:50 -0500
Message-Id: <11988745934036-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our read_inode doesn't need to grab the superblock rwsem because there no
chance it could be affected by branch management.  But our read_inode was
called from other places which did grab need to grab that rwsem, and lockdep
complained.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/super.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index c474c86..8b70aca 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -29,8 +29,6 @@ static void unionfs_read_inode(struct inode *inode)
 	int size;
 	struct unionfs_inode_info *info = UNIONFS_I(inode);
 
-	unionfs_read_lock(inode->i_sb);
-
 	memset(info, 0, offsetof(struct unionfs_inode_info, vfs_inode));
 	info->bstart = -1;
 	info->bend = -1;
@@ -63,7 +61,6 @@ static void unionfs_read_inode(struct inode *inode)
 	inode->i_mtime.tv_sec = inode->i_mtime.tv_nsec = 0;
 	inode->i_ctime.tv_sec = inode->i_ctime.tv_nsec = 0;
 
-	unionfs_read_unlock(inode->i_sb);
 }
 
 /*
-- 
1.5.2.2

