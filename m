Return-Path: <linux-kernel-owner+w=401wt.eu-S1762052AbXEOHRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762052AbXEOHRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760106AbXEOHQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:16:45 -0400
Received: from mx1.suse.de ([195.135.220.2]:56857 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760038AbXEOHQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:16:44 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 15 May 2007 17:16:36 +1000
Message-Id: <1070515071636.16315@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 005 of 8] knfsd: exportfs: untangle ISDIR logic in find_exported_dentry
References: <20070515170405.15621.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Christoph Hellwig <hch@infradead.org>

Rework some logic in find_exported_dentry so that we only have a single
S_ISDIR check and logic that makes clear to the reader what we're really
doing here.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/exportfs/expfs.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff .prev/fs/exportfs/expfs.c ./fs/exportfs/expfs.c
--- .prev/fs/exportfs/expfs.c	2007-05-14 11:15:34.000000000 +1000
+++ ./fs/exportfs/expfs.c	2007-05-14 11:15:37.000000000 +1000
@@ -116,30 +116,23 @@ find_exported_dentry(struct super_block 
 	if (IS_ERR(result))
 		return result;
 
-	if (S_ISDIR(result->d_inode->i_mode) &&
-	    (result->d_flags & DCACHE_DISCONNECTED)) {
-		/* it is an unconnected directory, we must connect it */
-		;
-	} else {
-		if (acceptable(context, result))
-			return result;
-		if (S_ISDIR(result->d_inode->i_mode)) {
+	if (S_ISDIR(result->d_inode->i_mode)) {
+		if (!(result->d_flags & DCACHE_DISCONNECTED)) {
+			if (acceptable(context, result))
+				return result;
 			err = -EACCES;
 			goto err_result;
 		}
 
+		target_dir = dget(result);
+	} else {
+		if (acceptable(context, result))
+			return result;
+
 		alias = find_acceptable_alias(result, acceptable, context);
 		if (alias)
 			return alias;
-	}			
 
-	/* It's a directory, or we are required to confirm the file's
-	 * location in the tree based on the parent information
- 	 */
-	dprintk("find_exported_dentry: need to look harder for %s/%d\n",sb->s_id,*(int*)obj);
-	if (S_ISDIR(result->d_inode->i_mode))
-		target_dir = dget(result);
-	else {
 		if (parent == NULL)
 			goto err_result;
 
@@ -149,6 +142,7 @@ find_exported_dentry(struct super_block 
 			goto err_result;
 		}
 	}
+
 	/*
 	 * Now we need to make sure that target_dir is properly connected.
 	 * It may already be, as the flag isn't always updated when connection
