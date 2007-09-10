Return-Path: <linux-kernel-owner+w=401wt.eu-S1760654AbXIJOyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760654AbXIJOyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 10:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760526AbXIJOwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 10:52:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760367AbXIJOwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 10:52:45 -0400
Date: Mon, 10 Sep 2007 10:52:32 -0400
Message-Id: <200709101452.l8AEqWgZ016277@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 3/7] reiserfs: turn of ATTR_KILL_S*ID at beginning of reiserfs_setattr
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net,
       ecryptfs-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org,
       unionfs@filesystems.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

reiserfs_setattr can call notify_change recursively using the same
iattr struct. This could cause it to trip the BUG() in notify_change.
Fix reiserfs to clear those bits near the beginning of the function.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/reiserfs/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 9ea1200..0804289 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3061,7 +3061,11 @@ int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
-	unsigned int ia_valid = attr->ia_valid;
+	unsigned int ia_valid;
+
+	/* must be turned off for recursive notify_change calls */
+	ia_valid = attr->ia_valid &= ~(ATTR_KILL_SUID|ATTR_KILL_SGID);
+
 	reiserfs_write_lock(inode->i_sb);
 	if (attr->ia_valid & ATTR_SIZE) {
 		/* version 2 items will be caught by the s_maxbytes check
-- 
1.5.2.1

