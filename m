Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbXIQLaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbXIQLaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 07:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbXIQL32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 07:29:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbXIQL30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 07:29:26 -0400
Date: Mon, 17 Sep 2007 07:29:10 -0400
Message-Id: <200709171129.l8HBTA7D024365@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 1/7] ecryptfs: allow lower fs to interpret ATTR_KILL_S*ID
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net,
       ecryptfs-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org,
       unionfs@filesystems.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes sure ecryptfs doesn't trip the BUG() in notify_change.
It also allows the lower filesystem to interpret ATTR_KILL_S*ID in its
own way.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ecryptfs/inode.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 131954b..dac4199 100644
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
 	fsstack_copy_attr_all(inode, lower_inode, NULL);
-- 
1.5.2.1

