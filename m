Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbXJBM1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbXJBM1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 08:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbXJBM0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 08:26:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40643 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbXJBM0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 08:26:53 -0400
Date: Tue, 2 Oct 2007 14:26:52 +0200
From: Jan Kara <jack@suse.cz>
To: David Howells <dhowells@redhat.com>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 13/30] IGET: Stop EXT4 from using iget() and read_inode()
Message-ID: <20071002122652.GE25647@atrey.karlin.mff.cuni.cz>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk> <20071001131028.29339.94415.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001131028.29339.94415.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 427f830..8bb63f2 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -682,9 +682,14 @@ struct inode *ext4_orphan_get(struct super_block *sb, unsigned long ino)
>  	 * is a valid orphan (no e2fsck run on fs).  Orphans also include
>  	 * inodes that were being truncated, so we can't check i_nlink==0.
>  	 */
> -	if (!ext4_test_bit(bit, bitmap_bh->b_data) ||
> -			!(inode = iget(sb, ino)) || is_bad_inode(inode) ||
> -			NEXT_ORPHAN(inode) > max_ino) {
> +	if (ext4_test_bit(bit, bitmap_bh->b_data))
> +		goto out;
> +
> +	inode = ext4_iget(sb, ino);
> +	if (IS_ERR(inode))
> +		goto out;
> +
> +	if (NEXT_ORPHAN(inode) > max_ino) {
>  		ext4_warning(sb, __FUNCTION__,
>  			     "bad orphan inode %lu!  e2fsck was run?", ino);
>  		printk(KERN_NOTICE "ext4_test_bit(bit=%d, block=%llu) = %d\n",
  Same comments as for ext3 - I think you reversed ext4_test_bit() test
and also the warning won't be issued in some cases which is wrong.

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 5fdb862..af98d07 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1044,17 +1044,11 @@ static struct dentry *ext4_lookup(struct inode * dir, struct dentry *dentry, str
>  		if (!ext4_valid_inum(dir->i_sb, ino)) {
>  			ext4_error(dir->i_sb, "ext4_lookup",
>  				   "bad inode number: %lu", ino);
> -			inode = NULL;
> -		} else
> -			inode = iget(dir->i_sb, ino);
> -
> -		if (!inode)
>  			return ERR_PTR(-EACCES);
  -EIO more appropriate here?

										Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
