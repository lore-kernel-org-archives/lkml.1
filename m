Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbZGHGcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbZGHGcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZGHGc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:32:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbZGHGc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:32:27 -0400
Date: Wed, 8 Jul 2009 08:32:25 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [rfc][patch 3/4] fs: new truncate sequence
Message-ID: <20090708063225.GL2714@wotan.suse.de>
References: <20090707144423.GC2714@wotan.suse.de> <20090707144823.GE2714@wotan.suse.de> <20090707145820.GA9976@infradead.org> <20090707150257.GG2714@wotan.suse.de> <20090707150758.GA18075@infradead.org> <20090707154809.GH2714@wotan.suse.de> <20090707163042.GA14947@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707163042.GA14947@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 12:30:42PM -0400, Christoph Hellwig wrote:
> On Tue, Jul 07, 2009 at 05:48:09PM +0200, Nick Piggin wrote:
> > OK, so what do you suggest? If the filesystem defines
> > ->setsize then do not pass ATTR_SIZE changes into setattr?
> > But then do you also not pass in ATTR_TIME cchanges to setattr
> > iff they  are together with ATTR_SIZE change? It sees also like
> > quite a difficult calling convention.
> 
> Ok, I played around with these ideas and your patches a bit.  I think
> we're actually best of to return to one of the early ideas and just
> get rid of ->truncate without any replacement, e.g. let ->setattr
> handle all of it.

Yes I do agree. ->setsize inside inode_setattr would have been
OK as wel I think, but this is probably even cleaner even though
it might be a bit more work.

 
> Below is a patch ontop of you four patches that implements exactly that
> and it looks surprisingly nice.  The only gotcha I can see is that we
> need to audit for existing filesystems not implementing ->truncate
> getting a behaviour change due to the checks to decide if we want
> to call vmtruncate.  But most likely any existing filesystems without
> ->truncate using the buffer.c helper or direct I/O is buggy anyway.

Thanks for the patch, I think I will fold it in to the series. I
think we probably do need to call simple_setsize in inode_setattr
though (unless you propose to eventually convert every filesystem
to define a .setattr). This would also require eg. your ext2
conversion to strip ATTR_SIZE before passing through to inode_setattr.

We could just add some temporary field for example in the i_op
structure to test for and remove it when everybody is converted,
which woud guarantee back compatibility.


> Note that it doesn't touch i_alloc_mutex locking for now - if we go
> down this route I would do the lock shift in one patch at the end of
> the series.

Yeah fine by me (or do it in a new series).

 
>  int ext2_setattr(struct dentry *dentry, struct iattr *iattr)
>  {
>  	struct inode *inode = dentry->d_inode;
>  	int error;
>  
> +	if (iattr->ia_valid & ATTR_SIZE) {
> +		error = ext2_setsize(inode, iattr->ia_size);
> +		if (error)
> +			return error;
> +	}
> +
>  	error = inode_change_ok(inode, iattr);
>  	if (error)
>  		return error;

Probably want to call inode_change_ok first here.

