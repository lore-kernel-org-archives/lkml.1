Return-Path: <linux-kernel-owner+w=401wt.eu-S1751661AbXDNXR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbXDNXR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 19:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbXDNXR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 19:17:29 -0400
Received: from mx2.netapp.com ([216.240.18.37]:16866 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbXDNXR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 19:17:28 -0400
X-IronPort-AV: i="4.14,411,1170662400"; 
   d="scan'208"; a="51167782:sNHT46633412"
Subject: NFS: Fix an Oops in nfs_setattr()
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Sat, 14 Apr 2007 19:07:28 -0400
Message-Id: <1176592048.6089.23.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 14 Apr 2007 23:07:34.0367 (UTC) FILETIME=[AFB47EF0:01C77EE9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like nfs_setattr() and nfs_rename() also need to test whether the
target is a regular file before calling nfs_wb_all()...

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/dir.c   |    3 ++-
 fs/nfs/inode.c |    6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 92d8ec8..cd34697 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1684,7 +1684,8 @@ go_ahead:
 	 * ... prune child dentries and writebacks if needed.
 	 */
 	if (atomic_read(&old_dentry->d_count) > 1) {
-		nfs_wb_all(old_inode);
+		if (S_ISREG(old_inode->i_mode))
+			nfs_wb_all(old_inode);
 		shrink_dcache_parent(old_dentry);
 	}
 	nfs_inode_return_delegation(old_inode);
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 93d046c..44aa9b7 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -341,8 +341,10 @@ nfs_setattr(struct dentry *dentry, struct iattr *attr)
 	lock_kernel();
 	nfs_begin_data_update(inode);
 	/* Write all dirty data */
-	filemap_write_and_wait(inode->i_mapping);
-	nfs_wb_all(inode);
+	if (S_ISREG(inode->i_mode)) {
+		filemap_write_and_wait(inode->i_mapping);
+		nfs_wb_all(inode);
+	}
 	/*
 	 * Return any delegations if we're going to change ACLs
 	 */
