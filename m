Return-Path: <linux-kernel-owner+w=401wt.eu-S932153AbZHUIMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbZHUIMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 04:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932100AbZHUIMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 04:12:50 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57158 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072AbZHUIMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 04:12:49 -0400
Date: Fri, 21 Aug 2009 10:12:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, zheng.yan@oracle.com
Subject: [GIT PULL] btrfs rb corruption fix
Message-ID: <20090821081250.GY12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Nick found a bad rb tree corruption problem in btrfs with fsx. It would
be nice to have this in 2.6.31, so please pull. Thanks!

  git://git.kernel.dk/linux-2.6-block.git btrfs

From: Nick Piggin (1):
      btrfs: fix inode rbtree corruption

 fs/btrfs/inode.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 272b9b2..59cba18 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3099,8 +3099,12 @@ static void inode_tree_add(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_inode *entry;
-	struct rb_node **p = &root->inode_tree.rb_node;
-	struct rb_node *parent = NULL;
+	struct rb_node **p;
+	struct rb_node *parent;
+
+again:
+	p = &root->inode_tree.rb_node;
+	parent = NULL;
 
 	spin_lock(&root->inode_lock);
 	while (*p) {
@@ -3108,13 +3112,16 @@ static void inode_tree_add(struct inode *inode)
 		entry = rb_entry(parent, struct btrfs_inode, rb_node);
 
 		if (inode->i_ino < entry->vfs_inode.i_ino)
-			p = &(*p)->rb_left;
+			p = &parent->rb_left;
 		else if (inode->i_ino > entry->vfs_inode.i_ino)
-			p = &(*p)->rb_right;
+			p = &parent->rb_right;
 		else {
 			WARN_ON(!(entry->vfs_inode.i_state &
 				  (I_WILL_FREE | I_FREEING | I_CLEAR)));
-			break;
+			rb_erase(parent, &root->inode_tree);
+			RB_CLEAR_NODE(parent);
+			spin_unlock(&root->inode_lock);
+			goto again;
 		}
 	}
 	rb_link_node(&BTRFS_I(inode)->rb_node, parent, p);
@@ -3126,12 +3133,12 @@ static void inode_tree_del(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
+	spin_lock(&root->inode_lock);
 	if (!RB_EMPTY_NODE(&BTRFS_I(inode)->rb_node)) {
-		spin_lock(&root->inode_lock);
 		rb_erase(&BTRFS_I(inode)->rb_node, &root->inode_tree);
-		spin_unlock(&root->inode_lock);
 		RB_CLEAR_NODE(&BTRFS_I(inode)->rb_node);
 	}
+	spin_unlock(&root->inode_lock);
 }
 
 static noinline void init_btrfs_i(struct inode *inode)

-- 
Jens Axboe

