Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYG3Co5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYG3Co5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbYG3CoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:44:19 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46237 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbYG3CoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:44:16 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, miklos@szeredi.hu,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 10/19] Unionfs: cache coherency fixes
Date: Tue, 29 Jul 2008 22:43:40 -0400
Message-Id: <12173858381175-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
References: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle unhashed or silly-renamed lower dentries properly.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    3 +-
 fs/unionfs/debug.c      |    2 +-
 fs/unionfs/dentry.c     |   49 +++++++++++++++++++++++++++++++++++++++++-----
 fs/unionfs/main.c       |    3 --
 4 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index df002d5..d64272b 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -466,7 +466,8 @@ reval_dentry:
 	dgen = atomic_read(&UNIONFS_D(dentry)->generation);
 
 	if (unlikely(sbgen > dgen)) {
-		pr_debug("unionfs: retry (locked) dentry revalidation\n");
+		pr_debug("unionfs: retry (locked) dentry %s revalidation\n",
+			 dentry->d_name.name);
 		schedule();
 		goto reval_dentry;
 	}
diff --git a/fs/unionfs/debug.c b/fs/unionfs/debug.c
index d154c32..4da4f0b 100644
--- a/fs/unionfs/debug.c
+++ b/fs/unionfs/debug.c
@@ -313,7 +313,7 @@ check_inode:
 			}
 		}
 	/* check if lower inode is newer than upper one (it shouldn't) */
-	if (unlikely(is_newer_lower(dentry))) {
+	if (unlikely(is_newer_lower(dentry) && !is_negative_lower(dentry))) {
 		PRINT_CALLER(fname, fxn, line);
 		for (bindex = ibstart(inode); bindex <= ibend(inode);
 		     bindex++) {
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index cd4611b..dfa4755 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -23,11 +23,16 @@ bool is_negative_lower(const struct dentry *dentry)
 	int bindex;
 	struct dentry *lower_dentry;
 
-	BUG_ON(!dentry || dbstart(dentry) < 0);
+	BUG_ON(!dentry);
+	/* cache coherency: check if file was deleted on lower branch */
+	if (dbstart(dentry) < 0)
+		return true;
 	for (bindex = dbstart(dentry); bindex <= dbend(dentry); bindex++) {
 		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		/* XXX: what if lower_dentry is NULL? */
-		if (lower_dentry && lower_dentry->d_inode)
+		/* unhashed (i.e., unlinked) lower dentries don't count */
+		if (lower_dentry && lower_dentry->d_inode &&
+		    !d_deleted(lower_dentry) &&
+		    !(lower_dentry->d_flags & DCACHE_NFSFS_RENAMED))
 			return false;
 	}
 	return true;
@@ -75,6 +80,7 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 	verify_locked(dentry);
 	verify_locked(dentry->d_parent);
 
+	sbgen = atomic_read(&UNIONFS_SB(dentry->d_sb)->generation);
 	/* if the dentry is unhashed, do NOT revalidate */
 	if (d_deleted(dentry))
 		goto out;
@@ -83,7 +89,6 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 	if (dentry->d_inode)
 		positive = 1;
 	dgen = atomic_read(&UNIONFS_D(dentry)->generation);
-	sbgen = atomic_read(&UNIONFS_SB(dentry->d_sb)->generation);
 	/*
 	 * If we are working on an unconnected dentry, then there is no
 	 * revalidation to be done, because this file does not exist within
@@ -103,6 +108,21 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 		/* Free the pointers for our inodes and this dentry. */
 		bstart = dbstart(dentry);
 		bend = dbend(dentry);
+
+		/*
+		 * mntput unhashed lower dentries, because those files got
+		 * deleted or rmdir'ed.
+		 */
+		for (bindex = bstart; bindex <= bend; bindex++) {
+			lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+			if (!lower_dentry)
+				continue;
+			if (!d_deleted(lower_dentry) &&
+			    !(lower_dentry->d_flags & DCACHE_NFSFS_RENAMED))
+			    continue;
+			unionfs_mntput(dentry, bindex);
+		}
+
 		__dput_lowers(dentry, bstart, bend);
 		dbstart(dentry) = dbend(dentry) = -1;
 
@@ -112,8 +132,12 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 			iput_lowers_all(dentry->d_inode, true);
 		}
 
-		result = unionfs_lookup_backend(dentry, &lowernd,
-						interpose_flag);
+		if (realloc_dentry_private_data(dentry) != 0) {
+			valid = false;
+			goto out;
+		}
+
+		result = unionfs_lookup_full(dentry, &lowernd, interpose_flag);
 		if (result) {
 			if (IS_ERR(result)) {
 				valid = false;
@@ -179,6 +203,9 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 	}
 
 out:
+	if (valid)
+		atomic_set(&UNIONFS_D(dentry)->generation, sbgen);
+
 	return valid;
 }
 
@@ -241,6 +268,16 @@ bool is_newer_lower(const struct dentry *dentry)
 			return true;
 		}
 	}
+
+	/*
+	 * Last check: if this is a positive dentry, but somehow all lower
+	 * dentries are negative or unhashed, then this dentry needs to be
+	 * revalidated, because someone probably deleted the objects from
+	 * the lower branches directly.
+	 */
+	if (is_negative_lower(dentry))
+		return true;
+
 	return false;		/* default: lower is not newer */
 }
 
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index a9d2cb6..1fd67c6 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -88,9 +88,6 @@ struct dentry *unionfs_interpose(struct dentry *dentry, struct super_block *sb,
 
 	verify_locked(dentry);
 
-	/* Make sure that we didn't get a negative dentry. */
-	BUG_ON(is_negative_lower(dentry));
-
 	/*
 	 * We allocate our new inode below by calling unionfs_iget,
 	 * which will initialize some of the new inode's fields
-- 
1.5.2.2

