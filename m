Return-Path: <linux-kernel-owner+w=401wt.eu-S933200AbZIDHGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200AbZIDHGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932913AbZIDHE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:04:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756697AbZIDG6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:58:39 -0400
Message-Id: <20090904065538.060835953@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 04 Sep 2009 16:52:07 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 26/33] fs: inode atomic last_ino, iunique lock
References: <20090904065142.114706411@nick.local0.net>
Content-Disposition: inline; filename=fs-inode_lock-scale-6c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make last_ino atomic in preperation for removing inode_lock.
Make a new lock for iunique counter, for removing inode_lock.
---
 fs/inode.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -728,7 +728,7 @@ struct inode *new_inode(struct super_blo
 	 * error if st_ino won't fit in target struct field. Use 32bit counter
 	 * here to attempt to avoid that.
 	 */
-	static unsigned int last_ino;
+	static atomic_t last_ino = ATOMIC_INIT(0);
 	struct inode *inode;
 
 	spin_lock_prefetch(&inode_lock);
@@ -738,7 +738,7 @@ struct inode *new_inode(struct super_blo
 		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
-		inode->i_ino = ++last_ino;
+		inode->i_ino = atomic_inc_return(&last_ino);
 		inode->i_state = 0;
 		__inode_add_to_lists(sb, NULL, inode);
 		spin_unlock(&inode->i_lock);
@@ -887,6 +887,22 @@ static struct inode *get_new_inode_fast(
 	return inode;
 }
 
+static int test_inode_iunique(struct super_block * sb, struct hlist_head *head, unsigned long ino)
+{
+	struct hlist_node *node;
+	struct inode * inode = NULL;
+
+	spin_lock(&inode_hash_lock);
+	hlist_for_each_entry(inode, node, head, i_hash) {
+		if (inode->i_ino == ino && inode->i_sb == sb) {
+			spin_unlock(&inode_hash_lock);
+			return 0;
+		}
+	}
+	spin_unlock(&inode_hash_lock);
+	return 1;
+}
+
 /**
  *	iunique - get a unique inode number
  *	@sb: superblock
@@ -908,20 +924,20 @@ ino_t iunique(struct super_block *sb, in
 	 * error if st_ino won't fit in target struct field. Use 32bit counter
 	 * here to attempt to avoid that.
 	 */
+	static DEFINE_SPINLOCK(unique_lock);
 	static unsigned int counter;
-	struct inode *inode;
 	struct hlist_head *head;
 	ino_t res;
 
 	spin_lock(&inode_lock);
+	spin_lock(&unique_lock);
 	do {
 		if (counter <= max_reserved)
 			counter = max_reserved + 1;
 		res = counter++;
 		head = inode_hashtable + hash(sb, res);
-		inode = find_inode_fast(sb, head, res);
-		spin_unlock(&inode->i_lock);
-	} while (inode != NULL);
+	} while (!test_inode_iunique(sb, head, res));
+	spin_unlock(&unique_lock);
 	spin_unlock(&inode_lock);
 
 	return res;


