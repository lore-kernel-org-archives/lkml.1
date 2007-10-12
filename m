Return-Path: <linux-kernel-owner+w=401wt.eu-S932486AbXJLQIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbXJLQIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760183AbXJLQGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:06:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760153AbXJLQGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:06:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/52] CRED: Pass credentials down to ext2 block allocator
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:05:55 +0100
Message-ID: <20071012160555.15119.4217.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials down to the ext2 block allocator.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext2/balloc.c |   11 ++++++-----
 fs/ext2/ext2.h   |    2 +-
 fs/ext2/inode.c  |   18 +++++++++++-------
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index ca88579..6ec7e47 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -98,7 +98,7 @@ error_out:
  * Set sb->s_dirt here because the superblock was "logically" altered.  We
  * need to recalculate its free blocks count and flush it out.
  */
-static int reserve_blocks(struct super_block *sb, int count)
+static int reserve_blocks(struct super_block *sb, int count, struct cred *cred)
 {
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	struct ext2_super_block *es = sbi->s_es;
@@ -112,9 +112,9 @@ static int reserve_blocks(struct super_block *sb, int count)
 		count = free_blocks;
 
 	if (free_blocks < root_blocks + count && !capable(CAP_SYS_RESOURCE) &&
-	    sbi->s_resuid != current->cred->uid &&
+	    sbi->s_resuid != cred->uid &&
 	    (sbi->s_resgid == 0 ||
-	     !in_group_p (current->cred, sbi->s_resgid))) {
+	     !in_group_p (cred, sbi->s_resgid))) {
 		/*
 		 * We are too close to reserve and we are not privileged.
 		 * Can we allocate anything at all?
@@ -325,7 +325,8 @@ got_it:
  * This function also updates quota and i_blocks field.
  */
 int ext2_new_block(struct inode *inode, unsigned long goal,
-			u32 *prealloc_count, u32 *prealloc_block, int *err)
+			u32 *prealloc_count, u32 *prealloc_block, int *err,
+			struct cred *cred)
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct buffer_head *gdp_bh;	/* bh2 */
@@ -357,7 +358,7 @@ int ext2_new_block(struct inode *inode, unsigned long goal,
 		prealloc_goal--;
 
 	dq_alloc = prealloc_goal + 1;
-	es_alloc = reserve_blocks(sb, dq_alloc);
+	es_alloc = reserve_blocks(sb, dq_alloc, cred);
 	if (!es_alloc) {
 		*err = -ENOSPC;
 		goto out_dquot;
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 85ca3de..47d68aa 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -92,7 +92,7 @@ static inline struct ext2_inode_info *EXT2_I(struct inode *inode)
 extern int ext2_bg_has_super(struct super_block *sb, int group);
 extern unsigned long ext2_bg_num_gdb(struct super_block *sb, int group);
 extern int ext2_new_block (struct inode *, unsigned long,
-			   __u32 *, __u32 *, int *);
+			   __u32 *, __u32 *, int *, struct cred *);
 extern void ext2_free_blocks (struct inode *, unsigned long,
 			      unsigned long);
 extern unsigned long ext2_count_free_blocks (struct super_block *);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index fa5e115..a5a6bb4 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -107,7 +107,8 @@ void ext2_discard_prealloc (struct inode * inode)
 #endif
 }
 
-static int ext2_alloc_block (struct inode * inode, unsigned long goal, int *err)
+static int ext2_alloc_block (struct inode * inode, unsigned long goal, int *err,
+			     struct cred *cred)
 {
 #ifdef EXT2FS_DEBUG
 	static unsigned long alloc_hits, alloc_attempts;
@@ -134,9 +135,10 @@ static int ext2_alloc_block (struct inode * inode, unsigned long goal, int *err)
 		if (S_ISREG(inode->i_mode))
 			result = ext2_new_block (inode, goal, 
 				 &ei->i_prealloc_count,
-				 &ei->i_prealloc_block, err);
+				 &ei->i_prealloc_block, err, cred);
 		else
-			result = ext2_new_block(inode, goal, NULL, NULL, err);
+			result = ext2_new_block(inode, goal, NULL, NULL, err,
+						cred);
 	}
 #else
 	result = ext2_new_block (inode, goal, 0, 0, err);
@@ -419,19 +421,20 @@ static int ext2_alloc_branch(struct inode *inode,
 			     int num,
 			     unsigned long goal,
 			     int *offsets,
-			     Indirect *branch)
+			     Indirect *branch,
+			     struct cred *cred)
 {
 	int blocksize = inode->i_sb->s_blocksize;
 	int n = 0;
 	int err;
 	int i;
-	int parent = ext2_alloc_block(inode, goal, &err);
+	int parent = ext2_alloc_block(inode, goal, &err, cred);
 
 	branch[0].key = cpu_to_le32(parent);
 	if (parent) for (n = 1; n < num; n++) {
 		struct buffer_head *bh;
 		/* Allocate the next block */
-		int nr = ext2_alloc_block(inode, parent, &err);
+		int nr = ext2_alloc_block(inode, parent, &err, cred);
 		if (!nr)
 			break;
 		branch[n].key = cpu_to_le32(nr);
@@ -546,6 +549,7 @@ changed:
 
 int ext2_get_block(struct inode *inode, sector_t iblock, struct buffer_head *bh_result, int create)
 {
+	struct cred *cred = current->cred;
 	int err = -EIO;
 	int offsets[4];
 	Indirect chain[4];
@@ -597,7 +601,7 @@ out:
 
 	left = (chain + depth) - partial;
 	err = ext2_alloc_branch(inode, left, goal,
-					offsets+(partial-chain), partial);
+					offsets+(partial-chain), partial, cred);
 	if (err)
 		goto cleanup;
 

