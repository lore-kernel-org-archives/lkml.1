Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbXITJMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbXITJMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 05:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757275AbXITJLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 05:11:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083AbXITJLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 05:11:08 -0400
Date: Thu, 20 Sep 2007 05:10:57 -0400
Message-Id: <200709200910.l8K9AvRm001343@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 4/7] unionfs: fix unionfs_setattr to handle ATTR_KILL_S*ID
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net,
       ecryptfs-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org,
       unionfs@filesystems.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow unionfs_setattr to trip the BUG() in notify_change. Clear
ATTR_MODE if the either ATTR_KILL_S*ID is set. This also allows the
lower filesystem to interpret these bits in its own way.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/unionfs/inode.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 687b9a7..9cb54d9 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -1021,6 +1021,13 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 	bend = dbend(dentry);
 	inode = dentry->d_inode;
 
+	/*
+	 * mode change is for clearing setuid/setgid. Allow lower filesystem
+	 * to reinterpret it in its own way.
+	 */
+	if (ia->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
+		ia->ia_valid &= ~ATTR_MODE;
+
 	for (bindex = bstart; (bindex <= bend) || (bindex == bstart);
 	     bindex++) {
 		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-- 
1.5.2.1

