Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZGFLtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZGFLtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 07:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbZGFLte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 07:49:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbZGFLtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 07:49:33 -0400
Date: Mon, 6 Jul 2009 13:49:35 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/11] vfs: Add better VFS support for page_mkwrite when blocksize < pagesize
Message-ID: <20090706114935.GN2714@wotan.suse.de>
References: <1245088797-29533-1-git-send-email-jack@suse.cz> <1245088797-29533-3-git-send-email-jack@suse.cz> <20090625161753.GB30755@wotan.suse.de> <20090625174754.GA21957@infradead.org> <20090626084225.GA12201@wotan.suse.de> <20090630173716.GA3150@infradead.org> <20090702072225.GC2714@wotan.suse.de> <20090704151801.GA19682@infradead.org> <20090706090804.GM2714@wotan.suse.de> <20090706103539.GA2611@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090706103539.GA2611@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 06:35:40AM -0400, Christoph Hellwig wrote:
> On Mon, Jul 06, 2009 at 11:08:04AM +0200, Nick Piggin wrote:
> > OK, hmm, but I wonder -- most of the time do_truncate will need to
> > call notify_change anyway, so I wonder if avoiding the double
> > indirection saves us anything? (It requires 2 indirect calls either
> > way). And if we call ->setsize from ->setattr, then a filesystem
> > which implements its own ->setattr could avoid one of those indirect
> > calls. Not so if do_truncate has to call ->setattr then ->setsize.
> 
> I don't quite understand what you mean here. In the end there should
> be one single indirect call, ->setsize (or whatever it's called by
> then).
> 
> In the first round we'd split up a helper just for size updates from
> notify_change, ala:
> 
> int vfs_truncate(struct dentry *dentry, loff_t size, int flags, file)
> {
> 	int error;
> 
> 	error = security_inode_truncate(dentry, size, flags, file);
> 	if (error)
> 		return error;
> 
> 	if (inode->i_op->setsize) {
> 		inode->i_op->setsize(dentry, size, flags, file);
> 
> 	} else {
> 		<... built up iattr here ...>
> 
> 		if (inode->i_op->setattr) {	
> 			down_write(&dentry->d_inode->i_alloc_sem);
> 			error = inode->i_op->setattr(dentry, attr);
> 			up_write(&dentry->d_inode->i_alloc_sem);
> 		} else {
> 			down_write(&dentry->d_inode->i_alloc_sem);
> 			error = inode_setattr(inode, attr);
> 			up_write(&dentry->d_inode->i_alloc_sem);
> 		}
> 	}
> 
> 	if (!error)
> 		fsnotify_truncate(dentry, size, flags);
> 	return error;
> }
> 
> One all filesistem are converted to have a setsize method (either their
> own or simple_setsize) the !inode->i_op->setsize case can go away.
> 
> Note that the above variant moves taking i_alloc_sem into ->setsize as
> it's not required for most filesystems (I think only extN need for
> O_DIRECT).
> 
> Also the above doesn't deal with killing the SUID/SGID bits yet, we'll
> need some good way for that.
> 
> Actually it might be better to just pass the iattr to ->setsize to so
> we can have the parsing for those arguments once, and that filesystems
> can re-use parts of their ->setattr for ->setsize if it's complex enough
> (timestamp updates and suid/sgid killing)

^^^^
Yes this was the problem I was thinking about. Because for exampe
the truncate setattr call is also used for timestamp update as well
as should_remove_setuid. The alternative to both ->setsize and ->setattr
calls here is to reuse some of the ->setattr functionality in ->setsize
as you say.

So it will be a simpler change to call the new ->setsize from
inside ->setattr. I guess that doesn't avoid your i_alloc_sem
probem, but maybe we should move that into implementations if only
a few filesystems require it.

