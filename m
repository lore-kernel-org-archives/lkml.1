Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbZGFRrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbZGFRrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 13:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbZGFRrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 13:47:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbZGFRq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 13:46:59 -0400
Date: Mon, 6 Jul 2009 19:47:00 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [rfc][patch 1/3] fs: new truncate sequence
Message-ID: <20090706174700.GT2714@wotan.suse.de>
References: <20090706165438.GQ2714@wotan.suse.de> <20090706172241.GA26042@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090706172241.GA26042@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for review.

On Mon, Jul 06, 2009 at 01:22:41PM -0400, Christoph Hellwig wrote:
> On Mon, Jul 06, 2009 at 06:54:38PM +0200, Nick Piggin wrote:
> > +int inode_truncate_ok(struct inode *inode, loff_t offset)
> 
> This one needs a good kernel doc comment I think.

Will do.


> >  int inode_setattr(struct inode * inode, struct iattr * attr)
> >  {
> >  	unsigned int ia_valid = attr->ia_valid;
> >  
> > -	if (ia_valid & ATTR_SIZE &&
> > -	    attr->ia_size != i_size_read(inode)) {
> > -		int error = vmtruncate(inode, attr->ia_size);
> > -		if (error)
> > -			return error;
> > +	if (ia_valid & ATTR_SIZE) {
> > +		loff_t offset = attr->ia_size;
> > +
> > +		if (offset != inode->i_size) {
> > +			int error;
> > +
> > +			if (inode->i_op->ftruncate) {
> > +				struct file *filp = NULL;
> > +				int open = 0;
> > +
> > +				if (ia_valid & ATTR_FILE)
> > +					filp = attr->ia_file;
> > +				if (ia_valid & ATTR_OPEN)
> > +					open = 1;
> > +				error = inode->i_op->ftruncate(filp, open,
> > +							inode, offset);
> > +			} else
> 
> This is layered quite horribly.  The new truncate method should be
> called from notify_change. not inode_setattr which is the default
> implementation for ->setattr.

OK, that probably is a better idea. That could allow us to move
i_alloc_sem into new implementations too, perhaps.


> ftruncate as a name for a method also used for truncate without a file
> is also not so good naming.  I'd also pass down the dentry as some thing
> like cifs want this (requires calling it from notify_change instead of
> inode_setattr, too), and turn the open boolean into a flags value.
> 
> Also passing file as the first argument when it's optional is a quite
> ugly calling convention, the fundamental object we operate on is the
> dentry.

All good points. I don't know what name to use though -- your idea
of renaming ->truncate then reusing it is nice but people will cry
about breaking external modules. I'll call it ->setsize and defer
having to think about it for now.


> > + * truncate_pagecache - unmap mappings "freed" by truncate() syscall
> > + * @inode: inode
> > + * @old: old file offset
> > + * @new: new file offset
> > + *
> > + * inode's new i_size must already be written before truncate_pagecache
> > + * is called.
> > + */
> > +void truncate_pagecache(struct inode * inode, loff_t old, loff_t new)
> > +{
> > +	VM_BUG_ON(inode->i_size != new);
> > +
> > +	if (new < old) {
> > +		struct address_space *mapping = inode->i_mapping;
> > +
> > +#ifdef CONFIG_MMU
> > +		/*
> > +		 * unmap_mapping_range is called twice, first simply for
> > +		 * efficiency so that truncate_inode_pages does fewer
> > +		 * single-page unmaps.  However after this first call, and
> > +		 * before truncate_inode_pages finishes, it is possible for
> > +		 * private pages to be COWed, which remain after
> > +		 * truncate_inode_pages finishes, hence the second
> > +		 * unmap_mapping_range call must be made for correctness.
> > +		 */
> > +		unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
> > +		truncate_inode_pages(mapping, new);
> > +		unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
> > +#else
> > +		truncate_inode_pages(mapping, new);
> > +#endif
> > +	}
> > +}
> > +EXPORT_SYMBOL(truncate_pagecache);
> 
> unmap_mapping_range is a noop stub for !CONFIG_MMU so we can just use
> the mmu version unconditionally.

Ah, I missed that. Thanks.

 
> > +int truncate_blocks(struct inode *inode, loff_t offset)
> > +{
> > +	if (inode->i_op->ftruncate) /* these guys handle it themselves */
> > +		return 0;
> > +
> > +	return vmtruncate(inode, offset);
> > +}
> > +EXPORT_SYMBOL(truncate_blocks);
> 
> Even if this one is temporary it probably needs a small comment
> explaining it

OK. Maybe it's stupid to have that and should just check (and comment)
in callers until all conversions are done. truncate_blocks is misleading
for such a thing too.

 
> > @@ -1992,9 +1992,12 @@ int block_write_begin(struct file *file,
> >  			 * prepare_write() may have instantiated a few blocks
> >  			 * outside i_size.  Trim these off again. Don't need
> >  			 * i_size_read because we hold i_mutex.
> > +			 *
> > +			 * Filesystems which define ->ftruncate must handle
> > +			 * this themselves.
> >  			 */
> >  			if (pos + len > inode->i_size)
> > -				vmtruncate(inode, inode->i_size);
> > +				truncate_blocks(inode, inode->i_size);
> 
> How would they do that?
> 
> >  	if (pos + len > inode->i_size)
> > -		vmtruncate(inode, inode->i_size);
> > +		truncate_blocks(inode, inode->i_size);
> 
> Same here.
> 
> >  		if (end > isize && dio_lock_type == DIO_LOCKING)
> > -			vmtruncate(inode, isize);
> > +			truncate_blocks(inode, isize);
> >  	}

See in patch 3. Basically in the case of errors then they should
ensure they have not allocated any blocks past isize, and trim
them off if needed. My conversion for ext2 is very basic, but
presumably some filesystems could actually check for errors or
do the metadata manipulations atomically etc.

