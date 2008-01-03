Return-Path: <linux-kernel-owner+w=401wt.eu-S1760462AbYACF6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760462AbYACF6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 00:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbYACF6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 00:58:12 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50706 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbYACF6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 00:58:10 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 2/3] Unionfs: locking fixes
Date: Thu,  3 Jan 2008 00:57:39 -0500
Message-Id: <119933986346-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11993398601-git-send-email-ezk@cs.sunysb.edu>
References: <11993398601-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lock parent dentries during revalidation.
Reduce total number of lockdep classes used.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |   13 ++++++++++++-
 fs/unionfs/fanout.h |    3 ++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 0369d93..7646828 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -42,6 +42,7 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 		memset(&lowernd, 0, sizeof(struct nameidata));
 
 	verify_locked(dentry);
+	verify_locked(dentry->d_parent);
 
 	/* if the dentry is unhashed, do NOT revalidate */
 	if (d_deleted(dentry))
@@ -351,7 +352,10 @@ bool __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd,
 	 * to child order.
 	 */
 	for (i = 0; i < chain_len; i++) {
-		unionfs_lock_dentry(chain[i], UNIONFS_DMUTEX_REVAL+i);
+		unionfs_lock_dentry(chain[i], UNIONFS_DMUTEX_REVAL_CHILD);
+		if (chain[i] != chain[i]->d_parent)
+			unionfs_lock_dentry(chain[i]->d_parent,
+					    UNIONFS_DMUTEX_REVAL_PARENT);
 		saved_bstart = dbstart(chain[i]);
 		saved_bend = dbend(chain[i]);
 		sbgen = atomic_read(&UNIONFS_SB(dentry->d_sb)->generation);
@@ -366,6 +370,8 @@ bool __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd,
 			     bindex++)
 				unionfs_mntput(chain[i], bindex);
 		}
+		if (chain[i] != chain[i]->d_parent)
+			unionfs_unlock_dentry(chain[i]->d_parent);
 		unionfs_unlock_dentry(chain[i]);
 
 		if (unlikely(!valid))
@@ -376,6 +382,9 @@ bool __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd,
 out_this:
 	/* finally, lock this dentry and revalidate it */
 	verify_locked(dentry);
+	if (dentry != dentry->d_parent)
+		unionfs_lock_dentry(dentry->d_parent,
+				    UNIONFS_DMUTEX_REVAL_PARENT);
 	dgen = atomic_read(&UNIONFS_D(dentry)->generation);
 
 	if (unlikely(is_newer_lower(dentry))) {
@@ -394,6 +403,8 @@ out_this:
 			purge_inode_data(dentry->d_inode);
 	}
 	valid = __unionfs_d_revalidate_one(dentry, nd);
+	if (dentry != dentry->d_parent)
+		unionfs_unlock_dentry(dentry->d_parent);
 
 	/*
 	 * If __unionfs_d_revalidate_one() succeeded above, then it will
diff --git a/fs/unionfs/fanout.h b/fs/unionfs/fanout.h
index 5f31015..4d9a45f 100644
--- a/fs/unionfs/fanout.h
+++ b/fs/unionfs/fanout.h
@@ -290,7 +290,8 @@ enum unionfs_dentry_lock_class {
 	UNIONFS_DMUTEX_PARENT,
 	UNIONFS_DMUTEX_CHILD,
 	UNIONFS_DMUTEX_WHITEOUT,
-	UNIONFS_DMUTEX_REVAL,	/* for file/dentry revalidate */
+	UNIONFS_DMUTEX_REVAL_PARENT, /* for file/dentry revalidate */
+	UNIONFS_DMUTEX_REVAL_CHILD,   /* for file/dentry revalidate */
 };
 
 static inline void unionfs_lock_dentry(struct dentry *d,
-- 
1.5.2.2

