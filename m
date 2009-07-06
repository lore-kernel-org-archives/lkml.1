Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbZGFSKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbZGFSKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 14:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbZGFSKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 14:10:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:56912 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbZGFSKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 14:10:23 -0400
Date: Mon, 6 Jul 2009 20:10:26 +0200
From: Nick Piggin <npiggin@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, jack@suse.cz,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [rfc][patch 1/3] fs: new truncate sequence
Message-ID: <20090706181026.GW2714@wotan.suse.de>
References: <20090706165438.GQ2714@wotan.suse.de> <E1MNsU3-0002Lx-8T@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1MNsU3-0002Lx-8T@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 08:00:07PM +0200, Miklos Szeredi wrote:
> > Index: linux-2.6/mm/truncate.c
> > ===================================================================
> > --- linux-2.6.orig/mm/truncate.c
> > +++ linux-2.6/mm/truncate.c
> > @@ -465,3 +465,79 @@ int invalidate_inode_pages2(struct addre
> >  	return invalidate_inode_pages2_range(mapping, 0, -1);
> >  }
> >  EXPORT_SYMBOL_GPL(invalidate_inode_pages2);
> > +
> > +/**
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
> 
> This is not true for fuse (and NFS?) as i_size isn't protected by
> i_mutex during attribute revalidation, and so it can change during the
> truncate.

Hmm, that's probably OK now. filemap_fault has some tricky code
to avoid faulting in pages past i_size, but since that has been
changed to use page lock a while back, the i_size checks can
probably go away.

So long as your filesystems obviously have to ensure the truncate
will not truncate the wrong pages, I can remove the VM_BUG_ON
just fine.

Thanks,
Nick
