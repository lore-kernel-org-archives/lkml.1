Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbYIJMdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbYIJMdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYIJMdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:33:40 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:2275 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYIJMdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:33:38 -0400
Date: Wed, 10 Sep 2008 08:33:24 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: __getblk infinite loop
Message-ID: <20080910123324.GA6194@hash.localnet>
References: <20080905032411.GB13208@hash.localnet> <20080904223836.54fbabb1.akpm@linux-foundation.org> <20080905092017.GA2712@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905092017.GA2712@alice>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 11:20:17AM +0200, Eric Sesterhenn wrote:
> > Yes, it's always a case of garbage in, garbage out (or nothing out, as
> > the case may be).
> > 
> > No, it's not particularly programmer-friendly behaviour.
> 
> Wouldnt it make sense to limit the loop in __getblk_slow()?

Back on this again, some patch like the following helps, but not enough
because s_num_blocks could also be wrong (and is in the case of the 
fuzzed image #138).  Unfortunately mounting a device where FS 
blocks > actual disk blocks is actually a handy use case.

I'm sure I'm showing my profound ignorance, but couldn't the address_ops
of the loop device reject mapping the buffer since it knows it's outside
the gendisk size?

NOT for applying:

In case of filesystem corruption, passing unchecked block numbers into
sb_bread can result in an infinite loop in __getblk().  Introduce a wrapper
function omfs_sbread() to check the block numbers and to also perform the
clus_to_blk scaling.

---
 fs/omfs/dir.c   |   22 ++++++++--------------
 fs/omfs/file.c  |    8 ++++----
 fs/omfs/inode.c |   27 ++++++++++++++++-----------
 fs/omfs/omfs.h  |    1 +
 4 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/omfs/dir.c b/fs/omfs/dir.c
index c0757e9..35fca1f 100644
--- a/fs/omfs/dir.c
+++ b/fs/omfs/dir.c
@@ -25,11 +25,10 @@ static struct buffer_head *omfs_get_bucket(struct inode *dir,
 		const char *name, int namelen, int *ofs)
 {
 	int nbuckets = (dir->i_size - OMFS_DIR_START)/8;
-	int block = clus_to_blk(OMFS_SB(dir->i_sb), dir->i_ino);
 	int bucket = omfs_hash(name, namelen, nbuckets);
 
 	*ofs = OMFS_DIR_START + bucket * 8;
-	return sb_bread(dir->i_sb, block);
+	return omfs_bread(dir->i_sb, dir->i_ino);
 }
 
 static struct buffer_head *omfs_scan_list(struct inode *dir, u64 block,
@@ -42,8 +41,7 @@ static struct buffer_head *omfs_scan_list(struct inode *dir, u64 block,
 	*prev_block = ~0;
 
 	while (block != ~0) {
-		bh = sb_bread(dir->i_sb,
-			clus_to_blk(OMFS_SB(dir->i_sb), block));
+		bh = omfs_bread(dir->i_sb, block);
 		if (!bh) {
 			err = -EIO;
 			goto err;
@@ -86,11 +84,10 @@ static struct buffer_head *omfs_find_entry(struct inode *dir,
 int omfs_make_empty(struct inode *inode, struct super_block *sb)
 {
 	struct omfs_sb_info *sbi = OMFS_SB(sb);
-	int block = clus_to_blk(sbi, inode->i_ino);
 	struct buffer_head *bh;
 	struct omfs_inode *oi;
 
-	bh = sb_bread(sb, block);
+	bh = omfs_bread(sb, inode->i_ino);
 	if (!bh)
 		return -ENOMEM;
 
@@ -134,7 +131,7 @@ static int omfs_add_link(struct dentry *dentry, struct inode *inode)
 	brelse(bh);
 
 	/* now set the sibling and parent pointers on the new inode */
-	bh = sb_bread(dir->i_sb, clus_to_blk(OMFS_SB(dir->i_sb), inode->i_ino));
+	bh = omfs_bread(dir->i_sb, inode->i_ino);
 	if (!bh)
 		goto out;
 
@@ -190,8 +187,7 @@ static int omfs_delete_entry(struct dentry *dentry)
 	if (prev != ~0) {
 		/* found in middle of list, get list ptr */
 		brelse(bh);
-		bh = sb_bread(dir->i_sb,
-			clus_to_blk(OMFS_SB(dir->i_sb), prev));
+		bh = omfs_bread(dir->i_sb, prev);
 		if (!bh)
 			goto out;
 
@@ -224,8 +220,7 @@ static int omfs_dir_is_empty(struct inode *inode)
 	u64 *ptr;
 	int i;
 
-	bh = sb_bread(inode->i_sb, clus_to_blk(OMFS_SB(inode->i_sb),
-			inode->i_ino));
+	bh = omfs_bread(inode->i_sb, inode->i_ino);
 
 	if (!bh)
 		return 0;
@@ -353,8 +348,7 @@ static int omfs_fill_chain(struct file *filp, void *dirent, filldir_t filldir,
 
 	/* follow chain in this bucket */
 	while (fsblock != ~0) {
-		bh = sb_bread(dir->i_sb, clus_to_blk(OMFS_SB(dir->i_sb),
-				fsblock));
+		bh = omfs_bread(dir->i_sb, fsblock);
 		if (!bh)
 			goto out;
 
@@ -466,7 +460,7 @@ static int omfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	hchain = (filp->f_pos >> 20) - 1;
 	hindex = filp->f_pos & 0xfffff;
 
-	bh = sb_bread(dir->i_sb, clus_to_blk(OMFS_SB(dir->i_sb), dir->i_ino));
+	bh = omfs_bread(dir->i_sb, dir->i_ino);
 	if (!bh)
 		goto out;
 
diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index 834b233..8719161 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -65,7 +65,7 @@ int omfs_shrink_inode(struct inode *inode)
 	if (inode->i_size != 0)
 		goto out;
 
-	bh = sb_bread(inode->i_sb, clus_to_blk(sbi, next));
+	bh = omfs_bread(inode->i_sb, next);
 	if (!bh)
 		goto out;
 
@@ -105,7 +105,7 @@ int omfs_shrink_inode(struct inode *inode)
 		if (next == ~0)
 			break;
 
-		bh = sb_bread(inode->i_sb, clus_to_blk(sbi, next));
+		bh = omfs_bread(inode->i_sb, next);
 		if (!bh)
 			goto out;
 		oe = (struct omfs_extent *) (&bh->b_data[OMFS_EXTENT_CONT]);
@@ -247,7 +247,7 @@ static int omfs_get_block(struct inode *inode, sector_t block,
 	int remain;
 
 	ret = -EIO;
-	bh = sb_bread(inode->i_sb, clus_to_blk(sbi, inode->i_ino));
+	bh = omfs_bread(inode->i_sb, inode->i_ino);
 	if (!bh)
 		goto out;
 
@@ -280,7 +280,7 @@ static int omfs_get_block(struct inode *inode, sector_t block,
 			break;
 
 		brelse(bh);
-		bh = sb_bread(inode->i_sb, clus_to_blk(sbi, next));
+		bh = omfs_bread(inode->i_sb, next);
 		if (!bh)
 			goto out;
 		oe = (struct omfs_extent *) (&bh->b_data[OMFS_EXTENT_CONT]);
diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index d29047b..447d534 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -18,6 +18,15 @@ MODULE_AUTHOR("Bob Copeland <me@bobcopeland.com>");
 MODULE_DESCRIPTION("OMFS (ReplayTV/Karma) Filesystem for Linux");
 MODULE_LICENSE("GPL");
 
+struct buffer_head *omfs_bread(struct super_block *sb, sector_t block)
+{
+	struct omfs_sb_info *sbi = OMFS_SB(sb);
+	if (block >= sbi->s_num_blocks)
+		return NULL;
+
+	return sb_bread(sb, clus_to_blk(sbi, block));
+}
+
 struct inode *omfs_new_inode(struct inode *dir, int mode)
 {
 	struct inode *inode;
@@ -95,15 +104,13 @@ static int omfs_write_inode(struct inode *inode, int wait)
 	struct omfs_inode *oi;
 	struct omfs_sb_info *sbi = OMFS_SB(inode->i_sb);
 	struct buffer_head *bh, *bh2;
-	unsigned int block;
 	u64 ctime;
 	int i;
 	int ret = -EIO;
 	int sync_failed = 0;
 
 	/* get current inode since we may have written sibling ptrs etc. */
-	block = clus_to_blk(sbi, inode->i_ino);
-	bh = sb_bread(inode->i_sb, block);
+	bh = omfs_bread(inode->i_sb, inode->i_ino);
 	if (!bh)
 		goto out;
 
@@ -142,8 +149,7 @@ static int omfs_write_inode(struct inode *inode, int wait)
 
 	/* if mirroring writes, copy to next fsblock */
 	for (i = 1; i < sbi->s_mirrors; i++) {
-		bh2 = sb_bread(inode->i_sb, block + i *
-			(sbi->s_blocksize / sbi->s_sys_blocksize));
+		bh2 = omfs_bread(inode->i_sb, inode->i_ino + i);
 		if (!bh2)
 			goto out_brelse;
 
@@ -190,7 +196,6 @@ struct inode *omfs_iget(struct super_block *sb, ino_t ino)
 	struct omfs_sb_info *sbi = OMFS_SB(sb);
 	struct omfs_inode *oi;
 	struct buffer_head *bh;
-	unsigned int block;
 	u64 ctime;
 	unsigned long nsecs;
 	struct inode *inode;
@@ -201,8 +206,7 @@ struct inode *omfs_iget(struct super_block *sb, ino_t ino)
 	if (!(inode->i_state & I_NEW))
 		return inode;
 
-	block = clus_to_blk(sbi, ino);
-	bh = sb_bread(inode->i_sb, block);
+	bh = omfs_bread(inode->i_sb, ino);
 	if (!bh)
 		goto iget_failed;
 
@@ -311,6 +315,9 @@ static int omfs_get_imap(struct super_block *sb)
 		goto nomem;
 
 	block = clus_to_blk(sbi, sbi->s_bitmap_ino);
+	if (block >= sbi->s_num_blocks)
+		goto nomem;
+
 	ptr = sbi->s_imap;
 	for (count = bitmap_size; count > 0; count -= sb->s_blocksize) {
 		bh = sb_bread(sb, block++);
@@ -409,7 +416,6 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct omfs_root_block *omfs_rb;
 	struct omfs_sb_info *sbi;
 	struct inode *root;
-	sector_t start;
 	int ret = -EINVAL;
 
 	save_mount_options(sb, (char *) data);
@@ -478,8 +484,7 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_block_shift = get_bitmask_order(sbi->s_blocksize) -
 		get_bitmask_order(sbi->s_sys_blocksize);
 
-	start = clus_to_blk(sbi, be64_to_cpu(omfs_sb->s_root_block));
-	bh2 = sb_bread(sb, start);
+	bh2 = omfs_bread(sb, be64_to_cpu(omfs_sb->s_root_block));
 	if (!bh2)
 		goto out_brelse_bh;
 
diff --git a/fs/omfs/omfs.h b/fs/omfs/omfs.h
index 2bc0f06..f043a67 100644
--- a/fs/omfs/omfs.h
+++ b/fs/omfs/omfs.h
@@ -58,6 +58,7 @@ extern void omfs_make_empty_table(struct buffer_head *bh, int offset);
 extern int omfs_shrink_inode(struct inode *inode);
 
 /* inode.c */
+extern struct buffer_head *omfs_bread(struct super_block *sb, sector_t block);
 extern struct inode *omfs_iget(struct super_block *sb, ino_t inode);
 extern struct inode *omfs_new_inode(struct inode *dir, int mode);
 extern int omfs_reserve_block(struct super_block *sb, sector_t block);
-- 
1.5.4.2.182.gb3092



-- 
Bob Copeland %% www.bobcopeland.com

