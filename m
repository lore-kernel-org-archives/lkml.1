Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbZGGQik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbZGGQik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZGGQib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:38:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36656 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbZGGQia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:38:30 -0400
Date: Tue, 7 Jul 2009 12:38:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 4/4] fs: tmpfs, ext2 use new truncate
Message-ID: <20090707163829.GB14947@infradead.org>
References: <20090707144423.GC2714@wotan.suse.de> <20090707144918.GF2714@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707144918.GF2714@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd still prefer this to be split into one patch for shmem, and one for
ext2 to make bisecting easier.

> @@ -68,7 +70,7 @@ void ext2_delete_inode (struct inode * i
>  
>  	inode->i_size = 0;
>  	if (inode->i_blocks)
> -		ext2_truncate (inode);
> +		ext2_truncate_blocks(inode, 0);
>  	ext2_free_inode (inode);
>  
>  	return;

> -void ext2_truncate(struct inode *inode)
> +static void ext2_truncate_blocks(struct inode *inode, loff_t offset)
>  {
>  	__le32 *i_data = EXT2_I(inode)->i_data;
>  	struct ext2_inode_info *ei = EXT2_I(inode);
> @@ -1032,27 +1074,8 @@ void ext2_truncate(struct inode *inode)
>  	int n;
>  	long iblock;
>  	unsigned blocksize;
> -
> -	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> -	    S_ISLNK(inode->i_mode)))
> -		return;
> -	if (ext2_inode_is_fast_symlink(inode))
> -		return;
> -	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> -		return;
> -

We can't move this to the caller easily.  ext2_delete_inode gets
called for all inodes, but we only want to go on truncating for the
limited set that passes this check.



> -	if (mapping_is_xip(inode->i_mapping))
> -		xip_truncate_page(inode->i_mapping, inode->i_size);
> -	else if (test_opt(inode->i_sb, NOBH))
> -		nobh_truncate_page(inode->i_mapping,
> -				inode->i_size, ext2_get_block);
> -	else
> -		block_truncate_page(inode->i_mapping,
> -				inode->i_size, ext2_get_block);

The patch header should have an explanation for why we don't need this
anymore for the various existing callers.

