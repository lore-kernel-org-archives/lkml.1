Return-Path: <linux-kernel-owner+w=401wt.eu-S965749AbXEOHSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965749AbXEOHSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761288AbXEOHQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:16:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234AbXEOHQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:16:58 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 15 May 2007 17:16:50 +1000
Message-Id: <1070515071650.16345@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 007 of 8] knfsd: exportfs: add find_disconnected_root helper
References: <20070515170405.15621.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Christoph Hellwig <hch@infradead.org>

Break the loop that finds the root of a disconnected subtree
into a helper of its own to make reading easier and
document the intent.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/exportfs/expfs.c |   39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff .prev/fs/exportfs/expfs.c ./fs/exportfs/expfs.c
--- .prev/fs/exportfs/expfs.c	2007-05-14 11:15:46.000000000 +1000
+++ ./fs/exportfs/expfs.c	2007-05-14 11:15:51.000000000 +1000
@@ -70,6 +70,27 @@ find_acceptable_alias(struct dentry *res
 	return NULL;
 }
 
+/*
+ * Find root of a disconnected subtree and return a reference to it.
+ */
+static struct dentry *
+find_disconnected_root(struct dentry *dentry)
+{
+	dget(dentry);
+	spin_lock(&dentry->d_lock);
+	while (!IS_ROOT(dentry) &&
+	       (dentry->d_parent->d_flags & DCACHE_DISCONNECTED)) {
+		struct dentry *parent = dentry->d_parent;
+		dget(parent);
+		spin_unlock(&dentry->d_lock);
+		dput(dentry);
+		dentry = parent;
+		spin_lock(&dentry->d_lock);
+	}
+	spin_unlock(&dentry->d_lock);
+	return dentry;
+}
+
 /**
  * find_exported_dentry - helper routine to implement export_operations->decode_fh
  * @sb:		The &super_block identifying the filesystem
@@ -164,23 +185,9 @@ find_exported_dentry(struct super_block 
 	 * the noprogress counter.  If we go through the loop 10 times (2 is
 	 * probably enough) without getting anywhere, we just give up
 	 */
-	noprogress= 0;
+	noprogress = 0;
 	while (target_dir->d_flags & DCACHE_DISCONNECTED && noprogress++ < 10) {
-		struct dentry *pd = target_dir;
-
-		dget(pd);
-		spin_lock(&pd->d_lock);
-		while (!IS_ROOT(pd) &&
-				(pd->d_parent->d_flags&DCACHE_DISCONNECTED)) {
-			struct dentry *parent = pd->d_parent;
-
-			dget(parent);
-			spin_unlock(&pd->d_lock);
-			dput(pd);
-			pd = parent;
-			spin_lock(&pd->d_lock);
-		}
-		spin_unlock(&pd->d_lock);
+		struct dentry *pd = find_disconnected_root(target_dir);
 
 		if (!IS_ROOT(pd)) {
 			/* must have found a connected parent - great */
