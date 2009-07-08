Return-Path: <linux-kernel-owner+w=401wt.eu-S1759876AbZGHGxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876AbZGHGxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbZGHGx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:53:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:60397 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbZGHGx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:53:28 -0400
Date: Wed, 8 Jul 2009 08:53:27 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [rfc][patch 4/4] fs: tmpfs, ext2 use new truncate
Message-ID: <20090708065327.GM2714@wotan.suse.de>
References: <20090707144423.GC2714@wotan.suse.de> <20090707144918.GF2714@wotan.suse.de> <20090707163829.GB14947@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707163829.GB14947@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 12:38:29PM -0400, Christoph Hellwig wrote:
> I'd still prefer this to be split into one patch for shmem, and one for
> ext2 to make bisecting easier.

Definitely agreed. I would prefer to even send individual fs patches
to respective maintainers so they can do their specific review and
QA on them and merge them as appropriate. The core change is
nicely back compatible, so there is no reason to tie it to the fs
patches.

 
> > @@ -68,7 +70,7 @@ void ext2_delete_inode (struct inode * i
> >  
> >  	inode->i_size = 0;
> >  	if (inode->i_blocks)
> > -		ext2_truncate (inode);
> > +		ext2_truncate_blocks(inode, 0);
> >  	ext2_free_inode (inode);
> >  
> >  	return;
> 
> > -void ext2_truncate(struct inode *inode)
> > +static void ext2_truncate_blocks(struct inode *inode, loff_t offset)
> >  {
> >  	__le32 *i_data = EXT2_I(inode)->i_data;
> >  	struct ext2_inode_info *ei = EXT2_I(inode);
> > @@ -1032,27 +1074,8 @@ void ext2_truncate(struct inode *inode)
> >  	int n;
> >  	long iblock;
> >  	unsigned blocksize;
> > -
> > -	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> > -	    S_ISLNK(inode->i_mode)))
> > -		return;
> > -	if (ext2_inode_is_fast_symlink(inode))
> > -		return;
> > -	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> > -		return;
> > -
> 
> We can't move this to the caller easily.  ext2_delete_inode gets
> called for all inodes, but we only want to go on truncating for the
> limited set that passes this check.

Hmm, shouldn't they have no ->i_blocks in that case?


> > -	if (mapping_is_xip(inode->i_mapping))
> > -		xip_truncate_page(inode->i_mapping, inode->i_size);
> > -	else if (test_opt(inode->i_sb, NOBH))
> > -		nobh_truncate_page(inode->i_mapping,
> > -				inode->i_size, ext2_get_block);
> > -	else
> > -		block_truncate_page(inode->i_mapping,
> > -				inode->i_size, ext2_get_block);
> 
> The patch header should have an explanation for why we don't need this
> anymore for the various existing callers.

OK. I guess it's not needed when blocks were completely outside
of i_size or the inode no longer has references and all blocks
will be freed. I will add the description.


