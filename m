Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbZGMOFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbZGMOFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 10:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbZGMOFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 10:05:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:45010 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001AbZGMOFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 10:05:17 -0400
Date: Mon, 13 Jul 2009 16:05:15 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 3/4] fs: new truncate sequence
Message-ID: <20090713140515.GB10739@wotan.suse.de>
References: <20090707163042.GA14947@infradead.org> <20090708063225.GL2714@wotan.suse.de> <20090708104701.GA31419@infradead.org> <20090708123412.GQ2714@wotan.suse.de> <4A54C435.1000503@panasas.com> <20090709075100.GU2714@wotan.suse.de> <4A59A517.1080605@panasas.com> <20090712144717.GA18163@infradead.org> <20090713065917.GO14666@wotan.suse.de> <20090713135324.GB3685@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090713135324.GB3685@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 09:53:24AM -0400, Christoph Hellwig wrote:
> On Mon, Jul 13, 2009 at 08:59:17AM +0200, Nick Piggin wrote:
> > Agreed, if it is a common sequence / requirement for filesystems
> > then of course I will not object to a helper to make things clearer
> > or share code.
> > 
> > I would like to see inode_setattr renamed into simple_setattr, and
> > then also .setattr made mandatory, so I don't like to cut code out
> > of inode_setattr which makes it unable to be the simple_setattr
> > after the old truncate code is removed.
> 
> But inode_setattr isn't anything like simple_setattr.  Except for
> the truncate special case it's really just a helper to copy values
> into the inode.  It doesn't even even have the same prototype as
> ->setattr.
> 
> A simple_setattr would look like the following:

OK that's kind of what I imagine inode_setattr becomes, but now
that you make me look at it in that perspective, it is better to
say inode_setattr returns to a plain helper to copy values into
the inode once we move the truncate code out of there.

It would be good to add your simple_setattr and factor it out
from fnotify_change, then. I guess this is what you plan to do
after my patchset?

> 
> int simple_setattr(struct dentry *dentry, struct iattr *iattr)
> {
> 	struct inode *inode = dentry->d_inode;
> 	int error;
> 
> 	error = inode_change_ok(inode, iattr);
>         if (error)
>                 return error;
> 
> 	if ((iattr->ia_valid & ATTR_UID && iattr->ia_uid != inode->i_uid) ||
> 	    (iattr->ia_valid & ATTR_GID && iattr->ia_gid != inode->i_gid)) {
> 		if (vfs_dq_transfer(inode, iattr))
> 			return -EDQUOT;
> 	}
> 
> 	if (iattr->ia_valid & ATTR_ATTR_SIZE &&
> 	    iattr->ia_size !== i_size_read(inode) &&
> 	    inode->i_op->new_truncate) {
> 		error = simple_setsize(inode, attr->ia_size);
> 		if (error)
> 			return error;
> 	}
> 
> 	return inode_setattr(inode, attr);
> }
