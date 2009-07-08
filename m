Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbZGHKrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbZGHKrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZGHKrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:47:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58954 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbZGHKrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:47:03 -0400
Date: Wed, 8 Jul 2009 06:47:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 3/4] fs: new truncate sequence
Message-ID: <20090708104701.GA31419@infradead.org>
References: <20090707144423.GC2714@wotan.suse.de> <20090707144823.GE2714@wotan.suse.de> <20090707145820.GA9976@infradead.org> <20090707150257.GG2714@wotan.suse.de> <20090707150758.GA18075@infradead.org> <20090707154809.GH2714@wotan.suse.de> <20090707163042.GA14947@infradead.org> <20090708063225.GL2714@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708063225.GL2714@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 08:32:25AM +0200, Nick Piggin wrote:
> Thanks for the patch, I think I will fold it in to the series. I
> think we probably do need to call simple_setsize in inode_setattr
> though (unless you propose to eventually convert every filesystem
> to define a .setattr). This would also require eg. your ext2
> conversion to strip ATTR_SIZE before passing through to inode_setattr.

Yes, we should eventually make .setattr mandatory.  Doing a default
action when a method lacks tends to cause more issues than it solves.

I'm happy to help in doing that part of the conversion (and also other
bits)

> >  int ext2_setattr(struct dentry *dentry, struct iattr *iattr)
> >  {
> >  	struct inode *inode = dentry->d_inode;
> >  	int error;
> >  
> > +	if (iattr->ia_valid & ATTR_SIZE) {
> > +		error = ext2_setsize(inode, iattr->ia_size);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> >  	error = inode_change_ok(inode, iattr);
> >  	if (error)
> >  		return error;
> 
> Probably want to call inode_change_ok first here.

Right now I tried to no reorder anything versus the previous patch.

But yes, we should do all the checks first.  Possibly we can even add
a call to inode_newsize_ok to inode_change_ok, but I'd like to defer
that until all conversions are done and we can easily audit it.
