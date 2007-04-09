Return-Path: <linux-kernel-owner+w=401wt.eu-S933801AbXDIO6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801AbXDIO6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933798AbXDIO6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:58:25 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:44009 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933740AbXDIOyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:54:40 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 17/21] Unionfs: vfsmount reference counting fixes
Date: Mon,  9 Apr 2007 10:54:08 -0400
Message-Id: <1176130455765-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.268.g3dda
In-Reply-To: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 4756b78..b08842f 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -235,8 +235,8 @@ int __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd)
 		valid = __unionfs_d_revalidate_one(chain[i], nd);
 		/* XXX: is this the correct mntput condition?! */
 		if (valid && chain_len > 0 &&
-		    sbgen != dgen && dentry->d_inode &&
-		    S_ISDIR(dentry->d_inode->i_mode)) {
+		    sbgen != dgen && chain[i]->d_inode &&
+		    S_ISDIR(chain[i]->d_inode->i_mode)) {
 			for (bindex = saved_bstart; bindex <= saved_bend; bindex++)
 				unionfs_mntput(chain[i], bindex);
 		}
@@ -256,9 +256,7 @@ int __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd)
 	saved_bend = dbend(dentry);
 	valid = __unionfs_d_revalidate_one(dentry, nd);
 
-	if (valid && chain_len > 0 &&
-	    sbgen != dgen && dentry->d_inode &&
-	    S_ISDIR(dentry->d_inode->i_mode)) {
+	if (valid && chain_len > 0 && sbgen != dgen) {
 		for (bindex = saved_bstart; bindex <= saved_bend; bindex++)
 			unionfs_mntput(dentry, bindex);
 	}
-- 
1.5.0.3.268.g3dda

