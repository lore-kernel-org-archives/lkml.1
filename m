Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967AbXBFJwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbXBFJwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXBFJwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:52:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57318 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbXBFJwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:52:36 -0500
Date: Tue, 6 Feb 2007 09:52:31 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Tony Jones <tonyj@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Message-ID: <20070206095231.GD5328@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andreas Gruenbacher <agruen@suse.de>, Tony Jones <tonyj@suse.de>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
	viro@zeniv.linux.org.uk
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <20070205184410.GA20672@infradead.org> <200702051813.26958.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702051813.26958.agruen@suse.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 06:13:26PM -0800, Andreas Gruenbacher wrote:
> On Monday 05 February 2007 10:44, Christoph Hellwig wrote:
> > Looking at the actual patches I see you're lazy in a lot of places.
> > Please make sure that when you introduce a vfsmount argument somewhere
> > that it is _always_ passed and not just when it's conveniant.  Yes, that's
> > more work, but then again if you're not consistant anyone half-serious
> > will laught at a security model using this infrasturcture.
> 
> It may appear like laziness, but it's not. Let's look at where we're passing 
> NULL at the moment:

You know, I've tracked a lot of this down previously when I submitted patches
to add vfsmount arguments to the vfs_ helpers, just to get tought by Al
that this is a bad idea :)

> fs/hpfs/namei.c
> 
> 	In hpfs_unlink, hpfs truncates one of its own inodes through
> 	notify_change(). You definitely don't want any lsms to interfere here,
> 	pathname based or not; hpfs should probably truncate its inode itself
> 	instead. But given that hpfs goes via the vfs, we at least pass NULL
> 	to indicate that this file really has no meaningful paths to it
> 	anymore. (In addition, we don't really have a vfsmount at this
> 	point anymore, and neither would it make sense to pass it there.)
> 
> 	To play more nicely with other lsms, hpfs could mark the inode as
> 	private before attempting the truncate.

The right fix would be to not go through the vfs.  Or even better to
remove the utter hack.  See my previous patch on this subject and the
discussion started on it.

> fs/reiserfs/xattr.c
> 
> 	The directories an files that reiserfs uses internally to store xattrs
> 	are hanging off ".reiserfs_priv/xattrs" in the filesystem. This part
> 	of the namespace is not accessible or visible from user space though
> 	except through the xattr syscalls.
> 
> 	Reiserfs should probably just mark all its xattr inodes as private in order
> 	to play nicely with other lsms. As far as pathname based lsms are concerned,
> 	pathnames to those fs-internal objects are meaningless though, and so we
> 	pass NULL here.

Well, the 100% correct fix would be to rip out the braindead reiserfs
xattr code :)
Of course that's not an option, but reiserfs would be much better of
stop using vfs_rmdir.  It really doesn't need most of the checks in there
and should just call into reiserfs_rmdir instead of doing this useless
trip into vfs land.

> fs/sysfs/file.c

> fs/nfsd/vfs.c and fs/nfsd/nfs4recover.c
> 
> 	For nfsd, the concept of pathnames is a bit peculiar. I'll try to respond to
> 	that separately.

the actually nfsd filehandle code is conceptually trivially fixable,
although with quite a bit of code churn.  As mention I'll soon submit
a patch for it.  nfs4recover.c is broken beyond repair and should just
be deleted from the tree.
