Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbZGHLOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbZGHLOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbZGHLOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:14:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56424 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbZGHLOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:14:22 -0400
Date: Wed, 8 Jul 2009 13:14:20 +0200
From: Jan Kara <jack@suse.cz>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 4/4] fs: tmpfs, ext2 use new truncate
Message-ID: <20090708111420.GB20924@duck.suse.cz>
References: <20090707144423.GC2714@wotan.suse.de> <20090707144918.GF2714@wotan.suse.de> <20090707163829.GB14947@infradead.org> <20090708065327.GM2714@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708065327.GM2714@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 08-07-09 08:53:27, Nick Piggin wrote:
> On Tue, Jul 07, 2009 at 12:38:29PM -0400, Christoph Hellwig wrote:
> > > @@ -68,7 +70,7 @@ void ext2_delete_inode (struct inode * i
> > >  
> > >  	inode->i_size = 0;
> > >  	if (inode->i_blocks)
> > > -		ext2_truncate (inode);
> > > +		ext2_truncate_blocks(inode, 0);
> > >  	ext2_free_inode (inode);
> > >  
> > >  	return;
> > 
> > > -void ext2_truncate(struct inode *inode)
> > > +static void ext2_truncate_blocks(struct inode *inode, loff_t offset)
> > >  {
> > >  	__le32 *i_data = EXT2_I(inode)->i_data;
> > >  	struct ext2_inode_info *ei = EXT2_I(inode);
> > > @@ -1032,27 +1074,8 @@ void ext2_truncate(struct inode *inode)
> > >  	int n;
> > >  	long iblock;
> > >  	unsigned blocksize;
> > > -
> > > -	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> > > -	    S_ISLNK(inode->i_mode)))
> > > -		return;
> > > -	if (ext2_inode_is_fast_symlink(inode))
> > > -		return;
> > > -	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> > > -		return;
> > > -
> > 
> > We can't move this to the caller easily.  ext2_delete_inode gets
> > called for all inodes, but we only want to go on truncating for the
> > limited set that passes this check.
> 
> Hmm, shouldn't they have no ->i_blocks in that case?
  Not necessarily. Inode can have extended attributes set and those can
be stored in a special block which is accounted in i_blocks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
