Return-Path: <linux-kernel-owner+w=401wt.eu-S1761296AbXFQTMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296AbXFQTMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761173AbXFQTKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:10:03 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36870 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761098AbXFQTKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:10:00 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 02/16] Unionfs: Don't revalidate dropped dentries
Date: Sun, 17 Jun 2007 15:09:09 -0400
Message-Id: <11821073631223-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
References: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

This fixes a harmless but annoying message that unionfs prints if a dropped
dentry is being revalidated, which could happen if you unlink open files.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 1045e51..89a236b 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -305,9 +305,12 @@ int unionfs_file_revalidate(struct file *file, int willwrite)
 	unionfs_lock_dentry(dentry);
 	sb = dentry->d_sb;
 
-	/* first revalidate the dentry inside struct file */
-	if (!__unionfs_d_revalidate_chain(dentry, NULL) &&
-	    !d_deleted(dentry)) {
+	/*
+	 * First revalidate the dentry inside struct file,
+	 * but not unhashed dentries.
+	 */
+	if (!d_deleted(dentry) &&
+	    !__unionfs_d_revalidate_chain(dentry, NULL)) {
 		err = -ESTALE;
 		goto out_nofree;
 	}
-- 
1.5.2.rc1.165.gaf9b

