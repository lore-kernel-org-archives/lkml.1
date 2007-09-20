Return-Path: <linux-kernel-owner+w=401wt.eu-S1758512AbXITJLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512AbXITJLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 05:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbXITJKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 05:10:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbXITJKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 05:10:50 -0400
Date: Thu, 20 Sep 2007 05:10:41 -0400
Message-Id: <200709200910.l8K9AfBQ001328@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 1/7] ecryptfs: allow lower fs to interpret ATTR_KILL_S*ID
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net,
       ecryptfs-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org,
       unionfs@filesystems.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure ecryptfs doesn't trip the BUG() in notify_change. This also
allows the lower filesystem to interpret ATTR_KILL_S*ID in its own way.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ecryptfs/inode.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index fc4c6cb..23a2fef 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -959,6 +959,14 @@ static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 		if (rc < 0)
 			goto out;
 	}
+
+	/*
+	 * mode change is for clearing setuid/setgid bits. Allow lower fs
+	 * to interpret this in its own way.
+	 */
+	if (ia->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
+		ia->ia_valid &= ~ATTR_MODE;
+
 	rc = notify_change(lower_dentry, ia);
 out:
 	fsstack_copy_attr_all(inode, lower_inode);
-- 
1.5.2.1

