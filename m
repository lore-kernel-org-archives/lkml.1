Return-Path: <linux-kernel-owner+w=401wt.eu-S1752027AbXBFNAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbXBFNAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 08:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXBFNAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 08:00:37 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:64021 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751956AbXBFNAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 08:00:36 -0500
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Tony Jones <tonyj@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
       viro@zeniv.linux.org.uk
In-Reply-To: <200702051813.26958.agruen@suse.de>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
	 <20070205184410.GA20672@infradead.org>  <200702051813.26958.agruen@suse.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 06 Feb 2007 07:55:39 -0500
Message-Id: <1170766539.12293.370.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 18:13 -0800, Andreas Gruenbacher wrote:
> On Monday 05 February 2007 10:44, Christoph Hellwig wrote:
> > Looking at the actual patches I see you're lazy in a lot of places.
> > Please make sure that when you introduce a vfsmount argument somewhere
> > that it is _always_ passed and not just when it's conveniant.  Yes, that's
> > more work, but then again if you're not consistant anyone half-serious
> > will laught at a security model using this infrasturcture.
> 
> It may appear like laziness, but it's not. Let's look at where we're passing 
> NULL at the moment:
> 
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
> 
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

That should be handled by the current marking of reiserfs xattr inodes
with S_PRIVATE and the tests for IS_PRIVATE in include/linux/security.h
(and in one instance, within SELinux itself).

-- 
Stephen Smalley
National Security Agency

