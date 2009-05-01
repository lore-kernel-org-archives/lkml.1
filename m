Return-Path: <linux-kernel-owner+w=401wt.eu-S1765575AbZEAUTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765575AbZEAUTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762410AbZEAUTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:19:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50603 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbZEAUTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:19:33 -0400
Date: Fri, 1 May 2009 16:16:46 -0400
From: Josef Bacik <josef@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josef Bacik <josef@redhat.com>, jbacik@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       sandeen@redhat.com, stable@kernel.org
Subject: Re: [PATCH] fiemap: fix problem with setting FIEMAP_EXTENT_LAST
Message-ID: <20090501201646.GK7076@unused.rdu.redhat.com>
References: <1241113491-9031-1-git-send-email-jbacik@redhat.com> <20090430154047.5485759f.akpm@linux-foundation.org> <20090501143517.GF7076@unused.rdu.redhat.com> <20090501125043.11da02f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501125043.11da02f3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 12:50:43PM -0700, Andrew Morton wrote:
> On Fri, 1 May 2009 10:35:17 -0400
> Josef Bacik <josef@redhat.com> wrote:
> 
> > 
> > Here is an updated patch.
> 
> This looks heaps better to me.
> 
> Officially we shouldn't do this sort of thing in a -stable/-rc4 patch. 
> We should go for a minimal backportable fixup then do the cleanups
> later, in an -rc1.
> 
> But we could sneak this in anyway, I expect.  Which way would you
> prefer?
> 
> >  What am I supposed to do about these types?
> > inode->i_size is loff_t, bh->b_size is size_t, bh->b_blocknr is sector_t, not to
> > mention that all of the fieinfo fields are either u64 or u32.
> 
> We're missing a number of types and sometimes it's hard to find one
> which is appropriate for the problem at hand.
> 
> It is appropriate that the fields which are communicated with userspace
> have the bare u32/u64 types.  One way of handling these
> information-free types is to name them well.  Another is to avoid using
> them until the last possible moment - choose well-typed and well-named
> locals and copy then to/from the target structure immediately
> before/after the userspace copy in/out.
> 
> >  Is what I've done
> > acceptable, or is there some other magic I'm supposed to be doing?
> 
> Looks better ;)
> 
> >  I've looked
> > around some and it seems that people just kind of ignore the types, they're just
> > there to explain the variables.
> 
> Yup, explaiing the variables is a major reason for the existence of 
> these types.
> 
> This sort of code tends to get very confusing.  Look at
> do_mpage_readpage() and weep.
> 
> >  I just would like to better understand this so
> > I can avoid getting chewed out in the future.
> 
> yeah, well, sorry, that was a bit of a rant.  I saw the patch and tried
> to understand it but this required understanding the surrounding code,
> and it immediately became clear that this was going to take waaaay more
> time that it should.
> 
> > --- a/fs/ioctl.c
> > +++ b/fs/ioctl.c
> > @@ -228,13 +228,22 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
> >  
> >  #ifdef CONFIG_BLOCK
> >  
> > -#define blk_to_logical(inode, blk) (blk << (inode)->i_blkbits)
> > -#define logical_to_blk(inode, offset) (offset >> (inode)->i_blkbits);
> > +static inline sector_t logical_to_blk(struct inode *inode, loff_t offset)
> > +{
> > +	return (offset >> inode->i_blkbits);
> > +}
> > +
> > +static inline loff_t blk_to_logical(struct inode *inode, sector_t blk)
> > +{
> > +	return (blk << inode->i_blkbits);
> > +}
> 
> That is so much better!
> 
> >  /**
> >   * __generic_block_fiemap - FIEMAP for block based inodes (no locking)
> >   * @inode - the inode to map
> > - * @arg - the pointer to userspace where we copy everything to
> > + * @fieinfo - the fiemap info struct that will be passed back to userspace
> > + * @start - where to start mapping in the inode
> > + * @len - how much space to map
> 
> space_to_map ;)
> 
> >   * @get_block - the fs's get_block function
> >   *
> >   * This does FIEMAP for block based inodes.  Basically it will just loop
> > @@ -250,43 +259,63 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
> >   */
> >  
> >  int __generic_block_fiemap(struct inode *inode,
> > -			   struct fiemap_extent_info *fieinfo, u64 start,
> > -			   u64 len, get_block_t *get_block)
> > +			   struct fiemap_extent_info *fieinfo, loff_t start,
> > +			   loff_t len, get_block_t *get_block)
> >  {
> > -	struct buffer_head tmp;
> > -	unsigned int start_blk;
> > -	long long length = 0, map_len = 0;
> > +	struct buffer_head map_bh;
> 
> yep, map_bh is a well-known identifier for an on-stack bh which is
> going to be used for get_block()ing.  Sticking to established patterns
> is good.
> 
> 
> > +	sector_t start_blk;
> > +	loff_t end;
> 
> "end" of what?  file/sector/block/page/extent/etc?  The type loff_t is
> a hint that it's measuring a file length.
> 
> >  	u64 logical = 0, phys = 0, size = 0;
> >  	u32 flags = FIEMAP_EXTENT_MERGED;
> > +	bool past_eof = false, whole_file = false;
> >  	int ret = 0;
> >
> > ...
> >
> 
> Are you really really confident that this is still correct?  No
> mysterious shift overflows from type changes, nothing subtle like that?
> 
> Or would you be more confident if we ran with version 1 for now?

Thanks for the review, that was helpful.  I think this late in the game it's
probably best to just go with whats already in the kernel for now, and I'll
rework some of this stuff and work with Eric to get a good test suite set up to
make sure everything is working properly, and then shoot for -31.  Does that
sound good?  Thanks,

Josef
