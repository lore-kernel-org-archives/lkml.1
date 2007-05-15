Return-Path: <linux-kernel-owner+w=401wt.eu-S1762114AbXEOHSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762114AbXEOHSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760858AbXEOHQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:16:53 -0400
Received: from ns.suse.de ([195.135.220.2]:56865 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760819AbXEOHQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:16:52 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 15 May 2007 17:16:43 +1000
Message-Id: <1070515071643.16331@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 006 of 8] knfsd: exportfs: move acceptable check into find_acceptable_alias
References: <20070515170405.15621.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Christoph Hellwig <hch@infradead.org>

All callers of find_acceptable_alias check if the current dentry
is acceptable before looking for other acceptable aliases using
find_acceptable_alias.  Move the check into find_acceptable_alias
to make the code a little more dense and add a comment to
find_acceptable_alias that documents its intent.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/exportfs/expfs.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff .prev/fs/exportfs/expfs.c ./fs/exportfs/expfs.c
--- .prev/fs/exportfs/expfs.c	2007-05-14 11:15:37.000000000 +1000
+++ ./fs/exportfs/expfs.c	2007-05-14 11:15:46.000000000 +1000
@@ -37,6 +37,9 @@ static int exportfs_get_name(struct dent
 		return get_name(dir, name, child);
 }
 
+/*
+ * Check if the dentry or any of it's aliases is acceptable.
+ */
 static struct dentry *
 find_acceptable_alias(struct dentry *result,
 		int (*acceptable)(void *context, struct dentry *dentry),
@@ -44,6 +47,9 @@ find_acceptable_alias(struct dentry *res
 {
 	struct dentry *dentry, *toput = NULL;
 
+	if (acceptable(context, result))
+		return result;
+
 	spin_lock(&dcache_lock);
 	list_for_each_entry(dentry, &result->d_inode->i_dentry, d_alias) {
 		dget_locked(dentry);
@@ -126,9 +132,6 @@ find_exported_dentry(struct super_block 
 
 		target_dir = dget(result);
 	} else {
-		if (acceptable(context, result))
-			return result;
-
 		alias = find_acceptable_alias(result, acceptable, context);
 		if (alias)
 			return alias;
@@ -289,9 +292,6 @@ find_exported_dentry(struct super_block 
 		}
 	}
 	dput(target_dir);
-	/* now result is properly connected, it is our best bet */
-	if (acceptable(context, result))
-		return result;
 
 	alias = find_acceptable_alias(result, acceptable, context);
 	if (alias)
