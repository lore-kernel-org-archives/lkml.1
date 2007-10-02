Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbXJBK2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbXJBK2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 06:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXJBK2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 06:28:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:53800 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbXJBK2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 06:28:43 -0400
Date: Tue, 2 Oct 2007 12:28:42 +0200
From: Jan Kara <jack@suse.cz>
To: David Howells <dhowells@redhat.com>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 12/30] IGET: Stop EXT3 from using iget() and read_inode()
Message-ID: <20071002102842.GC25647@atrey.karlin.mff.cuni.cz>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk> <20071001131023.29339.51838.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001131023.29339.51838.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  And one more thing...

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
  You inverted the test here, didn't you?

										Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
