Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab0BDRd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:33:56 -0500
Received: from kroah.org ([198.145.64.141]:34668 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933108Ab0BDRVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:45 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:01 2010
Message-Id: <20100204171500.998418130@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [22/74] Fix failure exits in bfs_fill_super()
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 5998649f779b7148a8a0c10c46cfa99e27d34dfe upstream.

double iput(), leaks...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/bfs/inode.c |   43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -353,35 +353,35 @@ static int bfs_fill_super(struct super_b
 	struct inode *inode;
 	unsigned i, imap_len;
 	struct bfs_sb_info *info;
-	long ret = -EINVAL;
+	int ret = -EINVAL;
 	unsigned long i_sblock, i_eblock, i_eoff, s_size;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
+	mutex_init(&info->bfs_lock);
 	s->s_fs_info = info;
 
 	sb_set_blocksize(s, BFS_BSIZE);
 
-	bh = sb_bread(s, 0);
-	if(!bh)
+	info->si_sbh = sb_bread(s, 0);
+	if (!info->si_sbh)
 		goto out;
-	bfs_sb = (struct bfs_super_block *)bh->b_data;
+	bfs_sb = (struct bfs_super_block *)info->si_sbh->b_data;
 	if (le32_to_cpu(bfs_sb->s_magic) != BFS_MAGIC) {
 		if (!silent)
 			printf("No BFS filesystem on %s (magic=%08x)\n", 
 				s->s_id,  le32_to_cpu(bfs_sb->s_magic));
-		goto out;
+		goto out1;
 	}
 	if (BFS_UNCLEAN(bfs_sb, s) && !silent)
 		printf("%s is unclean, continuing\n", s->s_id);
 
 	s->s_magic = BFS_MAGIC;
-	info->si_sbh = bh;
 
 	if (le32_to_cpu(bfs_sb->s_start) > le32_to_cpu(bfs_sb->s_end)) {
 		printf("Superblock is corrupted\n");
-		goto out;
+		goto out1;
 	}
 
 	info->si_lasti = (le32_to_cpu(bfs_sb->s_start) - BFS_BSIZE) /
@@ -390,7 +390,7 @@ static int bfs_fill_super(struct super_b
 	imap_len = (info->si_lasti / 8) + 1;
 	info->si_imap = kzalloc(imap_len, GFP_KERNEL);
 	if (!info->si_imap)
-		goto out;
+		goto out1;
 	for (i = 0; i < BFS_ROOT_INO; i++)
 		set_bit(i, info->si_imap);
 
@@ -398,15 +398,13 @@ static int bfs_fill_super(struct super_b
 	inode = bfs_iget(s, BFS_ROOT_INO);
 	if (IS_ERR(inode)) {
 		ret = PTR_ERR(inode);
-		kfree(info->si_imap);
-		goto out;
+		goto out2;
 	}
 	s->s_root = d_alloc_root(inode);
 	if (!s->s_root) {
 		iput(inode);
 		ret = -ENOMEM;
-		kfree(info->si_imap);
-		goto out;
+		goto out2;
 	}
 
 	info->si_blocks = (le32_to_cpu(bfs_sb->s_end) + 1) >> BFS_BSIZE_BITS;
@@ -419,10 +417,8 @@ static int bfs_fill_super(struct super_b
 	bh = sb_bread(s, info->si_blocks - 1);
 	if (!bh) {
 		printf("Last block not available: %lu\n", info->si_blocks - 1);
-		iput(inode);
 		ret = -EIO;
-		kfree(info->si_imap);
-		goto out;
+		goto out3;
 	}
 	brelse(bh);
 
@@ -459,11 +455,8 @@ static int bfs_fill_super(struct super_b
 			printf("Inode 0x%08x corrupted\n", i);
 
 			brelse(bh);
-			s->s_root = NULL;
-			kfree(info->si_imap);
-			kfree(info);
-			s->s_fs_info = NULL;
-			return -EIO;
+			ret = -EIO;
+			goto out3;
 		}
 
 		if (!di->i_ino) {
@@ -483,11 +476,17 @@ static int bfs_fill_super(struct super_b
 		s->s_dirt = 1;
 	} 
 	dump_imap("read_super", s);
-	mutex_init(&info->bfs_lock);
 	return 0;
 
+out3:
+	dput(s->s_root);
+	s->s_root = NULL;
+out2:
+	kfree(info->si_imap);
+out1:
+	brelse(info->si_sbh);
 out:
-	brelse(bh);
+	mutex_destroy(&info->bfs_lock);
 	kfree(info);
 	s->s_fs_info = NULL;
 	return ret;


