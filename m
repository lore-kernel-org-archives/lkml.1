Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbXJBKYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbXJBKYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 06:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbXJBKYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 06:24:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40270 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbXJBKYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 06:24:03 -0400
Date: Tue, 2 Oct 2007 12:24:01 +0200
From: Jan Kara <jack@suse.cz>
To: David Howells <dhowells@redhat.com>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 12/30] IGET: Stop EXT3 from using iget() and read_inode()
Message-ID: <20071002102401.GB25647@atrey.karlin.mff.cuni.cz>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk> <20071001131023.29339.51838.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001131023.29339.51838.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
> index e45dbd6..c2f0a0d 100644
> --- a/fs/ext3/ialloc.c
> +++ b/fs/ext3/ialloc.c
> @@ -646,7 +646,7 @@ struct inode *ext3_orphan_get(struct super_block *sb, unsigned long ino)
>  	unsigned long block_group;
>  	int bit;
>  	struct buffer_head *bitmap_bh = NULL;
> -	struct inode *inode = NULL;
> +	struct inode *inode = ERR_PTR(-EIO);
>  
>  	/* Error cases - e2fsck has already cleaned up for us */
>  	if (ino > max_ino) {
> @@ -668,9 +668,14 @@ struct inode *ext3_orphan_get(struct super_block *sb, unsigned long ino)
>  	 * is a valid orphan (no e2fsck run on fs).  Orphans also include
>  	 * inodes that were being truncated, so we can't check i_nlink==0.
>  	 */
> -	if (!ext3_test_bit(bit, bitmap_bh->b_data) ||
> -			!(inode = iget(sb, ino)) || is_bad_inode(inode) ||
> -			NEXT_ORPHAN(inode) > max_ino) {
> +	if (ext3_test_bit(bit, bitmap_bh->b_data))
> +		goto out;
> +
> +	inode = ext3_iget(sb, ino);
> +	if (IS_ERR(inode))
> +		goto out;
> +
> +	if (NEXT_ORPHAN(inode) > max_ino) {
>  		ext3_warning(sb, __FUNCTION__,
>  			     "bad orphan inode %lu!  e2fsck was run?", ino);
>  		printk(KERN_NOTICE "ext3_test_bit(bit=%d, block=%llu) = %d\n",
  But if you 'goto out' in some branches, we loose the ext3_warning()
which we probably don't want.

> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index c1fa190..78bfab5 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -1046,17 +1046,11 @@ static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, str
>  		if (!ext3_valid_inum(dir->i_sb, ino)) {
>  			ext3_error(dir->i_sb, "ext3_lookup",
>  				   "bad inode number: %lu", ino);
> -			inode = NULL;
> -		} else
> -			inode = iget(dir->i_sb, ino);
> -
> -		if (!inode)
>  			return ERR_PTR(-EACCES);
  Wouldn't here -EIO be more appropriate?

> @@ -1085,18 +1079,13 @@ struct dentry *ext3_get_parent(struct dentry *child)
>  	if (!ext3_valid_inum(child->d_inode->i_sb, ino)) {
>  		ext3_error(child->d_inode->i_sb, "ext3_get_parent",
>  			   "bad inode number: %lu", ino);
> -		inode = NULL;
> -	} else
> -		inode = iget(child->d_inode->i_sb, ino);
> -
> -	if (!inode)
>  		return ERR_PTR(-EACCES);
  And similarly here...

> @@ -1415,6 +1413,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  	int db_count;
>  	int i;
>  	int needs_recovery;
> +	int ret = -EINVAL;
>  	__le32 features;
>  
>  	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
> @@ -1770,19 +1769,25 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  	 * so we can safely mount the rest of the filesystem now.
>  	 */
>  
> -	root = iget(sb, EXT3_ROOT_INO);
> -	sb->s_root = d_alloc_root(root);
> -	if (!sb->s_root) {
> +	root = ext3_iget(sb, EXT3_ROOT_INO);
> +	if (IS_ERR(root)) {
>  		printk(KERN_ERR "EXT3-fs: get root inode failed\n");
> -		iput(root);
> +		if (PTR_ERR(root) == -ENOMEM)
> +			ret = -ENOMEM;
  Why don't we use PTR_ERR() always? Is there some reason not to return
-EIO?

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
