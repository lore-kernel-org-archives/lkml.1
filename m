Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbXIDOiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbXIDOiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 10:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbXIDOhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 10:37:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbXIDOhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 10:37:14 -0400
Date: Tue, 4 Sep 2007 10:37:04 -0400
Message-Id: <200709041437.l84Eb4lw010007@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 2/7] NFS: if ATTR_KILL_S*ID bits are set, then skip mode change
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net,
       ecryptfs-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org,
       unionfs@filesystems.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the ATTR_KILL_S*ID bits are set then any mode change is only for
clearing the setuid/setgid bits. For NFS skip the mode change and
let the server handle it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/nfs/inode.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 45633f9..441bd8b 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -327,6 +327,10 @@ nfs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	nfs_inc_stats(inode, NFSIOS_VFSSETATTR);
 
+	/* skip mode change if it's just for clearing setuid/setgid */
+	if (attr->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
+		attr->ia_valid &= ~ATTR_MODE;
+
 	if (attr->ia_valid & ATTR_SIZE) {
 		if (!S_ISREG(inode->i_mode) || attr->ia_size == i_size_read(inode))
 			attr->ia_valid &= ~ATTR_SIZE;
-- 
1.5.2.1

