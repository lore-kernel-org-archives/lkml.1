Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbYLVVtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbYLVVtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbYLVVsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:48:45 -0500
Received: from mail.suse.de ([195.135.220.2]:41542 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbYLVVso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:48:44 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 01/56] quota: Add callbacks for allocating and destroying dquot structures
Date: Mon, 22 Dec 2008 13:47:42 -0800
Message-Id: <1229982517-3455-2-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Some filesystems would like to keep private information together with each
dquot. Add callbacks alloc_dquot and destroy_dquot allowing filesystem to
allocate larger dquots from their private slab in a similar fashion we
currently allocate inodes.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/dquot.c            |   27 ++++++++++++++++++++++-----
 include/linux/quota.h |    2 ++
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 5e95261..5512e38 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -415,6 +415,16 @@ out_dqlock:
 	return ret;
 }
 
+static void dquot_destroy(struct dquot *dquot)
+{
+	kmem_cache_free(dquot_cachep, dquot);
+}
+
+static inline void do_destroy_dquot(struct dquot *dquot)
+{
+	dquot->dq_sb->dq_op->destroy_dquot(dquot);
+}
+
 /* Invalidate all dquots on the list. Note that this function is called after
  * quota is disabled and pointers from inodes removed so there cannot be new
  * quota users. There can still be some users of quotas due to inodes being
@@ -463,7 +473,7 @@ restart:
 		remove_dquot_hash(dquot);
 		remove_free_dquot(dquot);
 		remove_inuse(dquot);
-		kmem_cache_free(dquot_cachep, dquot);
+		do_destroy_dquot(dquot);
 	}
 	spin_unlock(&dq_list_lock);
 }
@@ -527,7 +537,7 @@ static void prune_dqcache(int count)
 		remove_dquot_hash(dquot);
 		remove_free_dquot(dquot);
 		remove_inuse(dquot);
-		kmem_cache_free(dquot_cachep, dquot);
+		do_destroy_dquot(dquot);
 		count--;
 		head = free_dquots.prev;
 	}
@@ -625,11 +635,16 @@ we_slept:
 	spin_unlock(&dq_list_lock);
 }
 
+static struct dquot *dquot_alloc(struct super_block *sb, int type)
+{
+	return kmem_cache_zalloc(dquot_cachep, GFP_NOFS);
+}
+
 static struct dquot *get_empty_dquot(struct super_block *sb, int type)
 {
 	struct dquot *dquot;
 
-	dquot = kmem_cache_zalloc(dquot_cachep, GFP_NOFS);
+	dquot = sb->dq_op->alloc_dquot(sb, type);
 	if(!dquot)
 		return NODQUOT;
 
@@ -682,7 +697,7 @@ we_slept:
 		dqstats.lookups++;
 		spin_unlock(&dq_list_lock);
 		if (empty)
-			kmem_cache_free(dquot_cachep, empty);
+			do_destroy_dquot(empty);
 	}
 	/* Wait for dq_lock - after this we know that either dquot_release() is already
 	 * finished or it will be canceled due to dq_count > 1 test */
@@ -1533,7 +1548,9 @@ struct dquot_operations dquot_operations = {
 	.acquire_dquot	= dquot_acquire,
 	.release_dquot	= dquot_release,
 	.mark_dirty	= dquot_mark_dquot_dirty,
-	.write_info	= dquot_commit_info
+	.write_info	= dquot_commit_info,
+	.alloc_dquot	= dquot_alloc,
+	.destroy_dquot	= dquot_destroy,
 };
 
 static inline void set_enable_flags(struct quota_info *dqopt, int type)
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 40401b5..3ce708c 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -292,6 +292,8 @@ struct dquot_operations {
 	int (*free_inode) (const struct inode *, unsigned long);
 	int (*transfer) (struct inode *, struct iattr *);
 	int (*write_dquot) (struct dquot *);		/* Ordinary dquot write */
+	struct dquot *(*alloc_dquot)(struct super_block *, int);	/* Allocate memory for new dquot */
+	void (*destroy_dquot)(struct dquot *);		/* Free memory for dquot */
 	int (*acquire_dquot) (struct dquot *);		/* Quota is going to be created on disk */
 	int (*release_dquot) (struct dquot *);		/* Quota is going to be deleted from disk */
 	int (*mark_dirty) (struct dquot *);		/* Dquot is marked dirty */
-- 
1.5.6

