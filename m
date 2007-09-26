Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbXIZD3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbXIZD3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757590AbXIZD3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:29:16 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35008 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565AbXIZD3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:29:15 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 21/25] Unionfs: add un/likely conditionals on readdir ops
Date: Tue, 25 Sep 2007 23:10:00 -0400
Message-Id: <1190776213460-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/rdstate.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/unionfs/rdstate.c b/fs/unionfs/rdstate.c
index 0a18d5c..7ec7f95 100644
--- a/fs/unionfs/rdstate.c
+++ b/fs/unionfs/rdstate.c
@@ -45,7 +45,7 @@ int unionfs_init_filldir_cache(void)
 
 void unionfs_destroy_filldir_cache(void)
 {
-	if (unionfs_filldir_cachep)
+	if (likely(unionfs_filldir_cachep))
 		kmem_cache_destroy(unionfs_filldir_cachep);
 }
 
@@ -72,7 +72,8 @@ static int guesstimate_hash_size(struct inode *inode)
 		return UNIONFS_I(inode)->hashsize;
 
 	for (bindex = ibstart(inode); bindex <= ibend(inode); bindex++) {
-		if (!(lower_inode = unionfs_lower_inode_idx(inode, bindex)))
+		lower_inode = unionfs_lower_inode_idx(inode, bindex);
+		if (unlikely(!lower_inode))
 			continue;
 
 		if (lower_inode->i_size == DENTPAGE)
@@ -136,7 +137,7 @@ struct unionfs_dir_state *alloc_rdstate(struct inode *inode, int bindex)
 		sizeof(struct list_head);
 
 	rdstate = kmalloc(mallocsize, GFP_KERNEL);
-	if (!rdstate)
+	if (unlikely(!rdstate))
 		return NULL;
 
 	spin_lock(&UNIONFS_I(inode)->rdlock);
@@ -217,7 +218,7 @@ struct filldir_node *find_filldir_node(struct unionfs_dir_state *rdstate,
 			 * if the duplicate is in this branch, then the file
 			 * system is corrupted.
 			 */
-			if (cursor->bindex == rdstate->bindex) {
+			if (unlikely(cursor->bindex == rdstate->bindex)) {
 				printk(KERN_DEBUG "unionfs: filldir: possible "
 				       "I/O error: a file is duplicated "
 				       "in the same branch %d: %s\n",
@@ -227,7 +228,7 @@ struct filldir_node *find_filldir_node(struct unionfs_dir_state *rdstate,
 		}
 	}
 
-	if (!found)
+	if (unlikely(!found))
 		cursor = NULL;
 
 	return cursor;
@@ -249,7 +250,7 @@ int add_filldir_node(struct unionfs_dir_state *rdstate, const char *name,
 	head = &(rdstate->list[index]);
 
 	new = kmem_cache_alloc(unionfs_filldir_cachep, GFP_KERNEL);
-	if (!new) {
+	if (unlikely(!new)) {
 		err = -ENOMEM;
 		goto out;
 	}
@@ -264,7 +265,7 @@ int add_filldir_node(struct unionfs_dir_state *rdstate, const char *name,
 		new->name = new->iname;
 	else {
 		new->name = kmalloc(namelen + 1, GFP_KERNEL);
-		if (!new->name) {
+		if (unlikely(!new->name)) {
 			kmem_cache_free(unionfs_filldir_cachep, new);
 			new = NULL;
 			goto out;
-- 
1.5.2.2

