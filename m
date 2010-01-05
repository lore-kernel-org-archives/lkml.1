Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154Ab0AEHCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0AEHCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 02:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126Ab0AEHCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 02:02:53 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34568 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab0AEHCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 02:02:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hXVFVAmWFgZPXQE/cVpjK4U2dACRHX23XpaG260qaJRp76wQPMFEFLwoSIHMfQv0Rx
         gjSusmlzzJdVNx8+ysBBwTD6mavkKfz30dlWQcv4brecs7nPrvBVNzBnCT4Y4zC1ox4D
         dbwErIlgTPOW94hsINQUFlsHgsQJP96fTQTvY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/3] reiserfs: Relax lock on xattr removing
Date: Tue,  5 Jan 2010 08:02:38 +0100
Message-Id: <1262674958-23312-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1262674958-23312-1-git-send-regression-fweisbec@gmail.com>
References: <1262674958-23312-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we remove an xattr, we call lookup_and_delete_xattr()
that takes some private xattr inodes mutexes. But we hold
the reiserfs lock at this time, which leads to dependency
inversions.

We can safely call lookup_and_delete_xattr() without the
reiserfs lock, where xattr inodes lookups only need the
xattr inodes mutexes.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 fs/reiserfs/xattr.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 75d3706..4899d78 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -451,7 +451,9 @@ static int lookup_and_delete_xattr(struct inode *inode, const char *name)
 	}
 
 	if (dentry->d_inode) {
+		reiserfs_write_lock(inode->i_sb);
 		err = xattr_unlink(xadir->d_inode, dentry);
+		reiserfs_write_unlock(inode->i_sb);
 		update_ctime(inode);
 	}
 
@@ -485,10 +487,14 @@ reiserfs_xattr_set_handle(struct reiserfs_transaction_handle *th,
 	if (get_inode_sd_version(inode) == STAT_DATA_V1)
 		return -EOPNOTSUPP;
 
-	if (!buffer)
-		return lookup_and_delete_xattr(inode, name);
-
 	reiserfs_write_unlock(inode->i_sb);
+
+	if (!buffer) {
+		err = lookup_and_delete_xattr(inode, name);
+		reiserfs_write_lock(inode->i_sb);
+		return err;
+	}
+
 	dentry = xattr_lookup(inode, name, flags);
 	if (IS_ERR(dentry)) {
 		reiserfs_write_lock(inode->i_sb);
-- 
1.6.2.3

