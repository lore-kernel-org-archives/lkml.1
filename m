Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbZDTTHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbZDTTHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZDTTHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:07:21 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49565 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbZDTTHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:07:19 -0400
Subject: Re: [PATCH] filesystems: start using roundup_to_blocksize and
 bytes_to_blocks
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49EB72A3.3060902@gmail.com>
References: <49EB7087.70302@gmail.com>  <49EB72A3.3060902@gmail.com>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 14:07:15 -0500
Message-Id: <1240254435.7068.43.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good from a jfs perspective.  Really cleans up that code.

On Sun, 2009-04-19 at 20:51 +0200, Marcin Slusarz wrote:
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

> ---
> If requested I can create one patch per filesystem, but it would be easier
> if the first patch could be applied to 2.6.30.

If the first patch goes in by itself, I'd be happy to break out and push
the jfs piece.

Thanks,
Shaggy

> ---
>  fs/adfs/inode.c         |    3 +-
>  fs/btrfs/extent_io.c    |   10 ++----
>  fs/btrfs/ioctl.c        |    2 +-
>  fs/fat/cache.c          |    7 +---
>  fs/hfs/extent.c         |    2 +-
>  fs/hfs/inode.c          |    2 +-
>  fs/hfsplus/extents.c    |    2 +-
>  fs/hfsplus/inode.c      |    2 +-
>  fs/jfs/xattr.c          |   25 +++++-----------
>  fs/minix/itree_common.c |    2 +-
>  fs/nfs/super.c          |   10 ++----
>  fs/nilfs2/inode.c       |    4 +--
>  fs/ntfs/aops.c          |    6 ++--
>  fs/ocfs2/namei.c        |    2 +-
>  fs/reiserfs/inode.c     |    5 +--
>  fs/sysv/itree.c         |    7 +---
>  fs/udf/inode.c          |   74 ++++++++++++++++++++--------------------------
>  fs/udf/namei.c          |    2 +-
>  fs/udf/truncate.c       |    9 ++----
>  19 files changed, 67 insertions(+), 109 deletions(-)
> 
> diff --git a/fs/adfs/inode.c b/fs/adfs/inode.c
> index e647200..8baec96 100644
> --- a/fs/adfs/inode.c
> +++ b/fs/adfs/inode.c
> @@ -273,8 +273,7 @@ adfs_iget(struct super_block *sb, struct object_info *obj)
>  	inode->i_ino	 = obj->file_id;
>  	inode->i_size	 = obj->size;
>  	inode->i_nlink	 = 2;
> -	inode->i_blocks	 = (inode->i_size + sb->s_blocksize - 1) >>
> -			    sb->s_blocksize_bits;
> +	inode->i_blocks	 = bytes_to_blocks(inode->i_size, sb);
> 
>  	/*
>  	 * we need to save the parent directory ID so that
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index eb2bee8..582bf76 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1959,7 +1959,6 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
>  	size_t page_offset = 0;
>  	size_t iosize;
>  	size_t disk_io_size;
> -	size_t blocksize = inode->i_sb->s_blocksize;
>  	unsigned long this_bio_flag = 0;
> 
>  	set_page_extent_mapped(page);
> @@ -2008,7 +2007,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
> 
>  		iosize = min(extent_map_end(em) - cur, end - cur + 1);
>  		cur_end = min(extent_map_end(em) - 1, end);
> -		iosize = (iosize + blocksize - 1) & ~((u64)blocksize - 1);
> +		iosize = roundup_to_blocksize(iosize, inode->i_sb);
>  		if (this_bio_flag & EXTENT_BIO_COMPRESSED) {
>  			disk_io_size = em->block_len;
>  			sector = em->block_start >> 9;
> @@ -2129,7 +2128,6 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
>  	int ret;
>  	int nr = 0;
>  	size_t pg_offset = 0;
> -	size_t blocksize;
>  	loff_t i_size = i_size_read(inode);
>  	unsigned long end_index = i_size >> PAGE_CACHE_SHIFT;
>  	u64 nr_delalloc;
> @@ -2221,7 +2219,6 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
>  	}
> 
>  	set_extent_uptodate(tree, start, page_end, GFP_NOFS);
> -	blocksize = inode->i_sb->s_blocksize;
> 
>  	while (cur <= end) {
>  		if (cur >= last_byte) {
> @@ -2244,7 +2241,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
>  		BUG_ON(extent_map_end(em) <= cur);
>  		BUG_ON(end < cur);
>  		iosize = min(extent_map_end(em) - cur, end - cur + 1);
> -		iosize = (iosize + blocksize - 1) & ~((u64)blocksize - 1);
> +		iosize = roundup_to_blocksize(iosize, inode->i_sb);
>  		sector = (em->block_start + extent_offset) >> 9;
>  		bdev = em->bdev;
>  		block_start = em->block_start;
> @@ -2616,9 +2613,8 @@ int extent_invalidatepage(struct extent_io_tree *tree,
>  {
>  	u64 start = ((u64)page->index << PAGE_CACHE_SHIFT);
>  	u64 end = start + PAGE_CACHE_SIZE - 1;
> -	size_t blocksize = page->mapping->host->i_sb->s_blocksize;
> 
> -	start += (offset + blocksize - 1) & ~(blocksize - 1);
> +	start += roundup_to_blocksize(offset, page->mapping->host->i_sb);
>  	if (start > end)
>  		return 0;
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 7594bec..1eeedbe 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -804,7 +804,7 @@ static long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>  		olen = len = src->i_size - off;
>  	/* if we extend to eof, continue to block boundary */
>  	if (off + len == src->i_size)
> -		len = ((src->i_size + bs-1) & ~(bs-1))
> +		len = roundup_to_blocksize(src->i_size, root->fs_info->sb)
>  			- off;
> 
>  	/* verify the end result is block aligned */
> diff --git a/fs/fat/cache.c b/fs/fat/cache.c
> index b426022..93fe0ce 100644
> --- a/fs/fat/cache.c
> +++ b/fs/fat/cache.c
> @@ -297,8 +297,6 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
>  {
>  	struct super_block *sb = inode->i_sb;
>  	struct msdos_sb_info *sbi = MSDOS_SB(sb);
> -	const unsigned long blocksize = sb->s_blocksize;
> -	const unsigned char blocksize_bits = sb->s_blocksize_bits;
>  	sector_t last_block;
>  	int cluster, offset;
> 
> @@ -312,7 +310,7 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
>  		return 0;
>  	}
> 
> -	last_block = (i_size_read(inode) + (blocksize - 1)) >> blocksize_bits;
> +	last_block = bytes_to_blocks(i_size_read(inode), inode->i_sb);
>  	if (sector >= last_block) {
>  		if (!create)
>  			return 0;
> @@ -321,8 +319,7 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
>  		 * ->mmu_private can access on only allocation path.
>  		 * (caller must hold ->i_mutex)
>  		 */
> -		last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
> -			>> blocksize_bits;
> +		last_block = bytes_to_blocks(MSDOS_I(inode)->mmu_private, inode->i_sb);
>  		if (sector >= last_block)
>  			return 0;
>  	}
> diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
> index 2c16316..6b0860d 100644
> --- a/fs/hfs/extent.c
> +++ b/fs/hfs/extent.c
> @@ -519,7 +519,7 @@ void hfs_file_truncate(struct inode *inode)
>  	HFS_I(inode)->alloc_blocks = blk_cnt;
>  out:
>  	HFS_I(inode)->phys_size = inode->i_size;
> -	HFS_I(inode)->fs_blocks = (inode->i_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
> +	HFS_I(inode)->fs_blocks = bytes_to_blocks(inode->i_size, sb);
>  	inode_set_bytes(inode, HFS_I(inode)->fs_blocks << sb->s_blocksize_bits);
>  	mark_inode_dirty(inode);
>  }
> diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
> index a1cbff2..25b1e2a 100644
> --- a/fs/hfs/inode.c
> +++ b/fs/hfs/inode.c
> @@ -243,7 +243,7 @@ void hfs_inode_read_fork(struct inode *inode, struct hfs_extent *ext,
>  	HFS_I(inode)->first_blocks = count;
> 
>  	inode->i_size = HFS_I(inode)->phys_size = log_size;
> -	HFS_I(inode)->fs_blocks = (log_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
> +	HFS_I(inode)->fs_blocks = bytes_to_blocks(log_size, sb);
>  	inode_set_bytes(inode, HFS_I(inode)->fs_blocks << sb->s_blocksize_bits);
>  	HFS_I(inode)->alloc_blocks = be32_to_cpu(phys_size) /
>  				     HFS_SB(sb)->alloc_blksz;
> diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
> index 0022eec..9245716 100644
> --- a/fs/hfsplus/extents.c
> +++ b/fs/hfsplus/extents.c
> @@ -500,7 +500,7 @@ void hfsplus_file_truncate(struct inode *inode)
>  	HFSPLUS_I(inode).alloc_blocks = blk_cnt;
>  out:
>  	HFSPLUS_I(inode).phys_size = inode->i_size;
> -	HFSPLUS_I(inode).fs_blocks = (inode->i_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
> +	HFSPLUS_I(inode).fs_blocks = bytes_to_blocks(inode->i_size, sb);
>  	inode_set_bytes(inode, HFSPLUS_I(inode).fs_blocks << sb->s_blocksize_bits);
>  	mark_inode_dirty(inode);
>  }
> diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
> index 1bcf597..0c95bd5 100644
> --- a/fs/hfsplus/inode.c
> +++ b/fs/hfsplus/inode.c
> @@ -377,7 +377,7 @@ void hfsplus_inode_read_fork(struct inode *inode, struct hfsplus_fork_raw *fork)
> 
>  	HFSPLUS_I(inode).alloc_blocks = be32_to_cpu(fork->total_blocks);
>  	inode->i_size = HFSPLUS_I(inode).phys_size = be64_to_cpu(fork->total_size);
> -	HFSPLUS_I(inode).fs_blocks = (inode->i_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
> +	HFSPLUS_I(inode).fs_blocks = bytes_to_blocks(inode->i_size, sb);
>  	inode_set_bytes(inode, HFSPLUS_I(inode).fs_blocks << sb->s_blocksize_bits);
>  	HFSPLUS_I(inode).clump_blocks = be32_to_cpu(fork->clump_size) >> HFSPLUS_SB(sb).alloc_blksz_shift;
>  	if (!HFSPLUS_I(inode).clump_blocks)
> diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
> index 61dfa81..59aefb1 100644
> --- a/fs/jfs/xattr.c
> +++ b/fs/jfs/xattr.c
> @@ -257,7 +257,7 @@ static int ea_write(struct inode *ip, struct jfs_ea_list *ealist, int size,
>  	}
> 
>  	/* figure out how many blocks we need */
> -	nblocks = (size + (sb->s_blocksize - 1)) >> sb->s_blocksize_bits;
> +	nblocks = bytes_to_blocks(size, sb);
> 
>  	/* Allocate new blocks to quota. */
>  	if (vfs_dq_alloc_block(ip, nblocks)) {
> @@ -284,9 +284,7 @@ static int ea_write(struct inode *ip, struct jfs_ea_list *ealist, int size,
>  		 * the nearest aggregate block size
>  		 */
>  		nb = min(PSIZE, nbytes);
> -		bytes_to_write =
> -		    ((((nb + sb->s_blocksize - 1)) >> sb->s_blocksize_bits))
> -		    << sb->s_blocksize_bits;
> +		bytes_to_write = roundup_to_blocksize(nb, sb);
> 
>  		if (!(mp = get_metapage(ip, blkno + i, bytes_to_write, 1))) {
>  			rc = -EIO;
> @@ -424,9 +422,7 @@ static int ea_read(struct inode *ip, struct jfs_ea_list *ealist)
>  		 * the nearest aggregate block size
>  		 */
>  		nb = min(PSIZE, nbytes);
> -		bytes_to_read =
> -		    ((((nb + sb->s_blocksize - 1)) >> sb->s_blocksize_bits))
> -		    << sb->s_blocksize_bits;
> +		bytes_to_read = roundup_to_blocksize(nb, sb);
> 
>  		if (!(mp = read_metapage(ip, blkno + i, bytes_to_read, 1)))
>  			return -EIO;
> @@ -505,8 +501,7 @@ static int ea_get(struct inode *inode, struct ea_buffer *ea_buf, int min_size)
>  			jfs_error(sb, "ea_get: invalid ea.flag)");
>  			return -EIO;
>  		}
> -		current_blocks = (ea_size + sb->s_blocksize - 1) >>
> -		    sb->s_blocksize_bits;
> +		current_blocks = bytes_to_blocks(ea_size, sb);
>  	}
>  	size = max(min_size, ea_size);
> 
> @@ -520,8 +515,7 @@ static int ea_get(struct inode *inode, struct ea_buffer *ea_buf, int min_size)
>  			return -ENOMEM;
> 
>  		ea_buf->flag = EA_MALLOC;
> -		ea_buf->max_size = (size + sb->s_blocksize - 1) &
> -		    ~(sb->s_blocksize - 1);
> +		ea_buf->max_size = roundup_to_blocksize(size, sb);
> 
>  		if (ea_size == 0)
>  			return 0;
> @@ -533,8 +527,7 @@ static int ea_get(struct inode *inode, struct ea_buffer *ea_buf, int min_size)
>  		}
>  		goto size_check;
>  	}
> -	blocks_needed = (min_size + sb->s_blocksize - 1) >>
> -	    sb->s_blocksize_bits;
> +	blocks_needed = bytes_to_blocks(min_size, sb);
> 
>  	if (blocks_needed > current_blocks) {
>  		/* Allocate new blocks to quota. */
> @@ -564,8 +557,7 @@ static int ea_get(struct inode *inode, struct ea_buffer *ea_buf, int min_size)
>  			goto clean_up;
>  		}
>  		ea_buf->xattr = ea_buf->mp->data;
> -		ea_buf->max_size = (min_size + sb->s_blocksize - 1) &
> -		    ~(sb->s_blocksize - 1);
> +		ea_buf->max_size = roundup_to_blocksize(min_size, sb);
>  		if (ea_size == 0)
>  			return 0;
>  		if ((rc = ea_read(inode, ea_buf->xattr))) {
> @@ -584,8 +576,7 @@ static int ea_get(struct inode *inode, struct ea_buffer *ea_buf, int min_size)
>  		goto clean_up;
>  	}
>  	ea_buf->xattr = ea_buf->mp->data;
> -	ea_buf->max_size = (ea_size + sb->s_blocksize - 1) &
> -	    ~(sb->s_blocksize - 1);
> +	ea_buf->max_size = roundup_to_blocksize(ea_size, sb);
> 
>        size_check:
>  	if (EALIST_SIZE(ea_buf->xattr) != ea_size) {
> diff --git a/fs/minix/itree_common.c b/fs/minix/itree_common.c
> index a731cab..52832b4 100644
> --- a/fs/minix/itree_common.c
> +++ b/fs/minix/itree_common.c
> @@ -302,7 +302,7 @@ static inline void truncate (struct inode * inode)
>  	int first_whole;
>  	long iblock;
> 
> -	iblock = (inode->i_size + sb->s_blocksize -1) >> sb->s_blocksize_bits;
> +	iblock = bytes_to_blocks(inode->i_size, sb);
>  	block_truncate_page(inode->i_mapping, inode->i_size, get_block);
> 
>  	n = block_to_path(inode, iblock, offsets);
> diff --git a/fs/nfs/super.c b/fs/nfs/super.c
> index 6717200..b9be272 100644
> --- a/fs/nfs/super.c
> +++ b/fs/nfs/super.c
> @@ -385,8 +385,6 @@ void nfs_sb_deactive(struct super_block *sb)
>  static int nfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  {
>  	struct nfs_server *server = NFS_SB(dentry->d_sb);
> -	unsigned char blockbits;
> -	unsigned long blockres;
>  	struct nfs_fh *fh = NFS_FH(dentry->d_inode);
>  	struct nfs_fattr fattr;
>  	struct nfs_fsstat res = {
> @@ -414,11 +412,9 @@ static int nfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	 * fields in units of f_bsize.
>  	 */
>  	buf->f_bsize = dentry->d_sb->s_blocksize;
> -	blockbits = dentry->d_sb->s_blocksize_bits;
> -	blockres = (1 << blockbits) - 1;
> -	buf->f_blocks = (res.tbytes + blockres) >> blockbits;
> -	buf->f_bfree = (res.fbytes + blockres) >> blockbits;
> -	buf->f_bavail = (res.abytes + blockres) >> blockbits;
> +	buf->f_blocks = roundup_to_blocksize(res.tbytes, dentry->d_sb);
> +	buf->f_bfree = roundup_to_blocksize(res.fbytes, dentry->d_sb);
> +	buf->f_bavail = roundup_to_blocksize(res.abytes, dentry->d_sb);
> 
>  	buf->f_files = res.tfiles;
>  	buf->f_ffree = res.afiles;
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 49ab4a4..0fae142 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -581,7 +581,6 @@ static void nilfs_truncate_bmap(struct nilfs_inode_info *ii,
>  void nilfs_truncate(struct inode *inode)
>  {
>  	unsigned long blkoff;
> -	unsigned int blocksize;
>  	struct nilfs_transaction_info ti;
>  	struct super_block *sb = inode->i_sb;
>  	struct nilfs_inode_info *ii = NILFS_I(inode);
> @@ -591,8 +590,7 @@ void nilfs_truncate(struct inode *inode)
>  	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
>  		return;
> 
> -	blocksize = sb->s_blocksize;
> -	blkoff = (inode->i_size + blocksize - 1) >> sb->s_blocksize_bits;
> +	blkoff = bytes_to_blocks(inode->i_size, sb);
>  	nilfs_transaction_begin(sb, &ti, 0); /* never fails */
> 
>  	block_truncate_page(inode->i_mapping, inode->i_size, nilfs_get_block);
> diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
> index b38f944..3316812 100644
> --- a/fs/ntfs/aops.c
> +++ b/fs/ntfs/aops.c
> @@ -231,7 +231,7 @@ static int ntfs_read_block(struct page *page)
>  	 */
>  	iblock = (s64)page->index << (PAGE_CACHE_SHIFT - blocksize_bits);
>  	read_lock_irqsave(&ni->size_lock, flags);
> -	lblock = (ni->allocated_size + blocksize - 1) >> blocksize_bits;
> +	lblock = bytes_to_blocks(ni->allocated_size, vol->sb);
>  	init_size = ni->initialized_size;
>  	i_size = i_size_read(vi);
>  	read_unlock_irqrestore(&ni->size_lock, flags);
> @@ -239,7 +239,7 @@ static int ntfs_read_block(struct page *page)
>  		/* Race with shrinking truncate. */
>  		init_size = i_size;
>  	}
> -	zblock = (init_size + blocksize - 1) >> blocksize_bits;
> +	zblock = bytes_to_blocks(init_size, vol->sb);
> 
>  	/* Loop through all the buffers in the page. */
>  	rl = NULL;
> @@ -970,7 +970,7 @@ static int ntfs_write_mst_block(struct page *page,
>  			(PAGE_CACHE_SHIFT - bh_size_bits);
> 
>  	/* The first out of bounds block for the data size. */
> -	dblock = (i_size_read(vi) + bh_size - 1) >> bh_size_bits;
> +	dblock = bytes_to_blocks(i_size_read(vi), vol->sb);
> 
>  	rl = NULL;
>  	err = err2 = nr_bhs = nr_recs = nr_locked_nis = 0;
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 2220f93..51ca438 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -1481,7 +1481,7 @@ static int ocfs2_create_symlink_data(struct ocfs2_super *osb,
>  	bytes_left = i_size_read(inode) + 1;
>  	/* we can't trust i_blocks because we're actually going to
>  	 * write i_size + 1 bytes. */
> -	blocks = (bytes_left + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
> +	blocks = bytes_to_blocks(bytes_left, sb);
> 
>  	mlog_entry("i_blocks = %llu, i_size = %llu, blocks = %d\n",
>  			(unsigned long long)inode->i_blocks,
> diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
> index 6fd0f47..6f1616f 100644
> --- a/fs/reiserfs/inode.c
> +++ b/fs/reiserfs/inode.c
> @@ -1053,7 +1053,6 @@ reiserfs_readpages(struct file *file, struct address_space *mapping,
>  static int real_space_diff(struct inode *inode, int sd_size)
>  {
>  	int bytes;
> -	loff_t blocksize = inode->i_sb->s_blocksize;
> 
>  	if (S_ISLNK(inode->i_mode) || S_ISDIR(inode->i_mode))
>  		return sd_size;
> @@ -1066,9 +1065,7 @@ static int real_space_diff(struct inode *inode, int sd_size)
>  	 ** tail, we add 4 bytes to pretend there really is an unformatted
>  	 ** node pointer
>  	 */
> -	bytes =
> -	    ((inode->i_size +
> -	      (blocksize - 1)) >> inode->i_sb->s_blocksize_bits) * UNFM_P_SIZE +
> +	bytes = bytes_to_blocks(inode->i_size, inode->i_sb) * UNFM_P_SIZE +
>  	    sd_size;
>  	return bytes;
>  }
> diff --git a/fs/sysv/itree.c b/fs/sysv/itree.c
> index f042eec..f221b6b 100644
> --- a/fs/sysv/itree.c
> +++ b/fs/sysv/itree.c
> @@ -369,15 +369,12 @@ void sysv_truncate (struct inode * inode)
>  	sysv_zone_t nr = 0;
>  	int n;
>  	long iblock;
> -	unsigned blocksize;
> 
>  	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
>  	    S_ISLNK(inode->i_mode)))
>  		return;
> 
> -	blocksize = inode->i_sb->s_blocksize;
> -	iblock = (inode->i_size + blocksize-1)
> -					>> inode->i_sb->s_blocksize_bits;
> +	iblock = bytes_to_blocks(inode->i_size, inode->i_sb);
> 
>  	block_truncate_page(inode->i_mapping, inode->i_size, get_block);
> 
> @@ -430,7 +427,7 @@ static unsigned sysv_nblocks(struct super_block *s, loff_t size)
>  	struct sysv_sb_info *sbi = SYSV_SB(s);
>  	int ptrs_bits = sbi->s_ind_per_block_bits;
>  	unsigned blocks, res, direct = DIRECT, i = DEPTH;
> -	blocks = (size + s->s_blocksize - 1) >> s->s_blocksize_bits;
> +	blocks = bytes_to_blocks(size, s);
>  	res = blocks;
>  	while (--i && blocks > direct) {
>  		blocks = ((blocks - direct - 1) >> ptrs_bits) + 1;
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index e7533f7..55b20e2 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -376,13 +376,9 @@ int udf_extend_file(struct inode *inode, struct extent_position *last_pos,
>  	iinfo = UDF_I(inode);
>  	/* Round the last extent up to a multiple of block size */
>  	if (last_ext->extLength & (sb->s_blocksize - 1)) {
> -		last_ext->extLength =
> -			(last_ext->extLength & UDF_EXTENT_FLAG_MASK) |
> -			(((last_ext->extLength & UDF_EXTENT_LENGTH_MASK) +
> -			  sb->s_blocksize - 1) & ~(sb->s_blocksize - 1));
> -		iinfo->i_lenExtents =
> -			(iinfo->i_lenExtents + sb->s_blocksize - 1) &
> -			~(sb->s_blocksize - 1);
> +		last_ext->extLength = (last_ext->extLength & UDF_EXTENT_FLAG_MASK) |
> +			roundup_to_blocksize(last_ext->extLength & UDF_EXTENT_LENGTH_MASK, sb);
> +		iinfo->i_lenExtents = roundup_to_blocksize(iinfo->i_lenExtents, sb);
>  	}
> 
>  	/* Last extent are just preallocated blocks? */
> @@ -527,8 +523,7 @@ static struct buffer_head *inode_getblk(struct inode *inode, sector_t block,
> 
>  		if (etype != (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
>  			pgoal = eloc.logicalBlockNum +
> -				((elen + inode->i_sb->s_blocksize - 1) >>
> -				 inode->i_sb->s_blocksize_bits);
> +				bytes_to_blocks(elen, inode->i_sb);
> 
>  		count++;
>  	} while (lbcount + elen <= b_off);
> @@ -548,8 +543,7 @@ static struct buffer_head *inode_getblk(struct inode *inode, sector_t block,
>  	if (etype == (EXT_RECORDED_ALLOCATED >> 30)) {
>  		if (elen & (inode->i_sb->s_blocksize - 1)) {
>  			elen = EXT_RECORDED_ALLOCATED |
> -				((elen + inode->i_sb->s_blocksize - 1) &
> -				 ~(inode->i_sb->s_blocksize - 1));
> +				roundup_to_blocksize(elen, inode->i_sb);
>  			etype = udf_write_aext(inode, &cur_epos, &eloc, elen, 1);
>  		}
>  		brelse(prev_epos.bh);
> @@ -709,8 +703,9 @@ static void udf_split_extents(struct inode *inode, int *c, int offset,
>  	    (laarr[*c].extLength >> 30) ==
>  				(EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) {
>  		int curr = *c;
> -		int blen = ((laarr[curr].extLength & UDF_EXTENT_LENGTH_MASK) +
> -			    blocksize - 1) >> blocksize_bits;
> +		int blen = bytes_to_blocks(
> +				laarr[curr].extLength & UDF_EXTENT_LENGTH_MASK,
> +				inode->i_sb);
>  		int8_t etype = (laarr[curr].extLength >> 30);
> 
>  		if (blen == 1)
> @@ -778,10 +773,8 @@ static void udf_prealloc_extents(struct inode *inode, int c, int lastblock,
>  					(EXT_NOT_RECORDED_ALLOCATED >> 30)) {
>  			start = c + 1;
>  			length = currlength =
> -				(((laarr[c + 1].extLength &
> -					UDF_EXTENT_LENGTH_MASK) +
> -				inode->i_sb->s_blocksize - 1) >>
> -				inode->i_sb->s_blocksize_bits);
> +				bytes_to_blocks(laarr[c + 1].extLength &
> +					UDF_EXTENT_LENGTH_MASK, inode->i_sb);
>  		} else
>  			start = c;
>  	}
> @@ -792,19 +785,17 @@ static void udf_prealloc_extents(struct inode *inode, int c, int lastblock,
>  				length += UDF_DEFAULT_PREALLOC_BLOCKS;
>  		} else if ((laarr[i].extLength >> 30) ==
>  				(EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) {
> -			length += (((laarr[i].extLength &
> -						UDF_EXTENT_LENGTH_MASK) +
> -				    inode->i_sb->s_blocksize - 1) >>
> -				    inode->i_sb->s_blocksize_bits);
> +			length += bytes_to_blocks(laarr[i].extLength &
> +						UDF_EXTENT_LENGTH_MASK,
> +						inode->i_sb);
>  		} else
>  			break;
>  	}
> 
>  	if (length) {
>  		int next = laarr[start].extLocation.logicalBlockNum +
> -			(((laarr[start].extLength & UDF_EXTENT_LENGTH_MASK) +
> -			  inode->i_sb->s_blocksize - 1) >>
> -			  inode->i_sb->s_blocksize_bits);
> +			bytes_to_blocks(laarr[start].extLength &
> +					UDF_EXTENT_LENGTH_MASK, inode->i_sb);
>  		int numalloc = udf_prealloc_blocks(inode->i_sb, inode,
>  				laarr[start].extLocation.partitionReferenceNum,
>  				next, (UDF_DEFAULT_PREALLOC_BLOCKS > length ?
> @@ -831,10 +822,9 @@ static void udf_prealloc_extents(struct inode *inode, int c, int lastblock,
>  			}
> 
>  			for (i = start + 1; numalloc && i < *endnum; i++) {
> -				int elen = ((laarr[i].extLength &
> -						UDF_EXTENT_LENGTH_MASK) +
> -					    inode->i_sb->s_blocksize - 1) >>
> -					    inode->i_sb->s_blocksize_bits;
> +				int elen = bytes_to_blocks(laarr[i].extLength &
> +						UDF_EXTENT_LENGTH_MASK,
> +						inode->i_sb);
> 
>  				if (elen > numalloc) {
>  					laarr[i].extLength -=
> @@ -875,8 +865,9 @@ static void udf_merge_extents(struct inode *inode,
>  				(EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) ||
>  			((lip1->extLocation.logicalBlockNum -
>  			  li->extLocation.logicalBlockNum) ==
> -			(((li->extLength & UDF_EXTENT_LENGTH_MASK) +
> -			blocksize - 1) >> blocksize_bits)))) {
> +					bytes_to_blocks(li->extLength &
> +							UDF_EXTENT_LENGTH_MASK,
> +							inode->i_sb)))) {
> 
>  			if (((li->extLength & UDF_EXTENT_LENGTH_MASK) +
>  				(lip1->extLength & UDF_EXTENT_LENGTH_MASK) +
> @@ -897,9 +888,9 @@ static void udf_merge_extents(struct inode *inode,
>  						blocksize_bits);
>  			} else {
>  				li->extLength = lip1->extLength +
> -					(((li->extLength &
> -						UDF_EXTENT_LENGTH_MASK) +
> -					 blocksize - 1) & ~(blocksize - 1));
> +					roundup_to_blocksize(li->extLength &
> +						UDF_EXTENT_LENGTH_MASK,
> +						inode->i_sb);
>  				if (*endnum > (i + 2))
>  					memmove(&laarr[i + 1], &laarr[i + 2],
>  						sizeof(struct long_ad) *
> @@ -912,9 +903,8 @@ static void udf_merge_extents(struct inode *inode,
>  			   ((lip1->extLength >> 30) ==
>  				(EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))) {
>  			udf_free_blocks(inode->i_sb, inode, &li->extLocation, 0,
> -					((li->extLength &
> -					  UDF_EXTENT_LENGTH_MASK) +
> -					 blocksize - 1) >> blocksize_bits);
> +					bytes_to_blocks(li->extLength &
> +					  UDF_EXTENT_LENGTH_MASK, inode->i_sb));
>  			li->extLocation.logicalBlockNum = 0;
>  			li->extLocation.partitionReferenceNum = 0;
> 
> @@ -932,9 +922,9 @@ static void udf_merge_extents(struct inode *inode,
>  						blocksize;
>  			} else {
>  				li->extLength = lip1->extLength +
> -					(((li->extLength &
> -						UDF_EXTENT_LENGTH_MASK) +
> -					  blocksize - 1) & ~(blocksize - 1));
> +					roundup_to_blocksize(li->extLength &
> +						UDF_EXTENT_LENGTH_MASK,
> +						inode->i_sb);
>  				if (*endnum > (i + 2))
>  					memmove(&laarr[i + 1], &laarr[i + 2],
>  						sizeof(struct long_ad) *
> @@ -946,9 +936,9 @@ static void udf_merge_extents(struct inode *inode,
>  					(EXT_NOT_RECORDED_ALLOCATED >> 30)) {
>  			udf_free_blocks(inode->i_sb, inode,
>  					&li->extLocation, 0,
> -					((li->extLength &
> -						UDF_EXTENT_LENGTH_MASK) +
> -					 blocksize - 1) >> blocksize_bits);
> +					bytes_to_blocks(li->extLength &
> +						UDF_EXTENT_LENGTH_MASK,
> +						inode->i_sb));
>  			li->extLocation.logicalBlockNum = 0;
>  			li->extLocation.partitionReferenceNum = 0;
>  			li->extLength = (li->extLength &
> diff --git a/fs/udf/namei.c b/fs/udf/namei.c
> index 6a29fa3..78550ef 100644
> --- a/fs/udf/namei.c
> +++ b/fs/udf/namei.c
> @@ -410,7 +410,7 @@ static struct fileIdentDesc *udf_add_entry(struct inode *dir,
>  add:
>  	/* Is there any extent whose size we need to round up? */
>  	if (dinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB && elen) {
> -		elen = (elen + sb->s_blocksize - 1) & ~(sb->s_blocksize - 1);
> +		elen = roundup_to_blocksize(elen, sb);
>  		if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
>  			epos.offset -= sizeof(struct short_ad);
>  		else if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
> diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
> index 225527c..6fa3839 100644
> --- a/fs/udf/truncate.c
> +++ b/fs/udf/truncate.c
> @@ -32,10 +32,8 @@ static void extent_trunc(struct inode *inode, struct extent_position *epos,
>  			 uint32_t nelen)
>  {
>  	struct kernel_lb_addr neloc = {};
> -	int last_block = (elen + inode->i_sb->s_blocksize - 1) >>
> -		inode->i_sb->s_blocksize_bits;
> -	int first_block = (nelen + inode->i_sb->s_blocksize - 1) >>
> -		inode->i_sb->s_blocksize_bits;
> +	int last_block = bytes_to_blocks(elen, inode->i_sb);
> +	int first_block = bytes_to_blocks(nelen, inode->i_sb);
> 
>  	if (nelen) {
>  		if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
> @@ -256,8 +254,7 @@ void udf_truncate_extents(struct inode *inode)
>  						udf_get_lb_pblock(sb, &eloc, 0));
>  				if (elen)
>  					indirect_ext_len =
> -						(elen + sb->s_blocksize - 1) >>
> -						sb->s_blocksize_bits;
> +						bytes_to_blocks(elen, sb);
>  				else
>  					indirect_ext_len = 1;
>  			} else {
-- 
David Kleikamp
IBM Linux Technology Center

