Return-Path: <linux-kernel-owner+w=401wt.eu-S933147AbXCNUPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147AbXCNUPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933153AbXCNUPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:15:43 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40584 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933147AbXCNUPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:15:42 -0400
Date: Wed, 14 Mar 2007 15:15:41 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] eCryptfs: Fix possible NULL ptr deref in ecryptfs_d_release()
Message-ID: <20070314201541.GB3676@us.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ecryptfs_d_release() first dereferences a pointer (via
ecryptfs_dentry_to_lower()) and then afterwards checks to see if the
pointer it just dereferenced is NULL (via
ecryptfs_dentry_to_private()). This patch moves all of the work done
on the dereferenced pointer inside a block governed by the condition
that the pointer is non-NULL.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/dentry.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/ecryptfs/dentry.c b/fs/ecryptfs/dentry.c
index 329efcd..cb20b96 100644
--- a/fs/ecryptfs/dentry.c
+++ b/fs/ecryptfs/dentry.c
@@ -78,18 +78,13 @@ struct kmem_cache *ecryptfs_dentry_info_cache;
  */
 static void ecryptfs_d_release(struct dentry *dentry)
 {
-	struct dentry *lower_dentry;
-
-	lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	if (ecryptfs_dentry_to_private(dentry))
+	if (ecryptfs_dentry_to_private(dentry)) {
+		if (ecryptfs_dentry_to_lower(dentry)) {
+			mntput(ecryptfs_dentry_to_lower_mnt(dentry));
+			dput(ecryptfs_dentry_to_lower(dentry));
+		}
 		kmem_cache_free(ecryptfs_dentry_info_cache,
 				ecryptfs_dentry_to_private(dentry));
-	if (lower_dentry) {
-		struct vfsmount *lower_mnt =
-			ecryptfs_dentry_to_lower_mnt(dentry);
-
-		mntput(lower_mnt);
-		dput(lower_dentry);
 	}
 	return;
 }
-- 
1.4.4.4

