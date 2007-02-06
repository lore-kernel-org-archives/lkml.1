Return-Path: <linux-kernel-owner+w=401wt.eu-S965462AbXBFCNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965462AbXBFCNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 21:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965458AbXBFCNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 21:13:49 -0500
Received: from ns.suse.de ([195.135.220.2]:42951 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965456AbXBFCNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 21:13:47 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Date: Mon, 5 Feb 2007 18:13:26 -0800
User-Agent: KMail/1.9.5
Cc: Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <20070205184410.GA20672@infradead.org>
In-Reply-To: <20070205184410.GA20672@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702051813.26958.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 February 2007 10:44, Christoph Hellwig wrote:
> Looking at the actual patches I see you're lazy in a lot of places.
> Please make sure that when you introduce a vfsmount argument somewhere
> that it is _always_ passed and not just when it's conveniant.  Yes, that's
> more work, but then again if you're not consistant anyone half-serious
> will laught at a security model using this infrasturcture.

It may appear like laziness, but it's not. Let's look at where we're passing 
NULL at the moment:

fs/hpfs/namei.c

	In hpfs_unlink, hpfs truncates one of its own inodes through
	notify_change(). You definitely don't want any lsms to interfere here,
	pathname based or not; hpfs should probably truncate its inode itself
	instead. But given that hpfs goes via the vfs, we at least pass NULL
	to indicate that this file really has no meaningful paths to it
	anymore. (In addition, we don't really have a vfsmount at this
	point anymore, and neither would it make sense to pass it there.)

	To play more nicely with other lsms, hpfs could mark the inode as
	private before attempting the truncate.

fs/reiserfs/xattr.c

	The directories an files that reiserfs uses internally to store xattrs
	are hanging off ".reiserfs_priv/xattrs" in the filesystem. This part
	of the namespace is not accessible or visible from user space though
	except through the xattr syscalls.

	Reiserfs should probably just mark all its xattr inodes as private in order
	to play nicely with other lsms. As far as pathname based lsms are concerned,
	pathnames to those fs-internal objects are meaningless though, and so we
	pass NULL here.

fs/sysfs/file.c
fs/nfsd/vfs.c and fs/nfsd/nfs4recover.c

	For nfsd, the concept of pathnames is a bit peculiar. I'll try to respond to
	that separately.

Thanks,
Andreas
