Return-Path: <linux-kernel-owner+w=401wt.eu-S1763483AbYDBVyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763483AbYDBVyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764233AbYDBVsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:48:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59678 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761799AbYDBVsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:48:52 -0400
Date: Wed, 2 Apr 2008 22:48:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
Message-ID: <20080402214824.GP9785@ZenIV.linux.org.uk>
References: <20080402201247.358430231@szeredi.hu> <20080402201321.062856131@szeredi.hu> <20080402205450.GO9785@ZenIV.linux.org.uk> <E1JhAF9-0007Zx-Rq@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JhAF9-0007Zx-Rq@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 11:11:39PM +0200, Miklos Szeredi wrote:

> It is an interface with at least 3 callers at the moment: syscalls,
> nfsd and ecryptfs and unionfs in the future. It is an interface
> because all external accesses to the filesystem *are* done through the
> namespace and not directly on filesystem internals.
> 
> Such direct access would be conceivable, but I don't think we should
> base the design on theoretically possible uses.  If those uses appear,
> we can change the interface to fit that.
> 
> This "move everything to callers" thing is wrong because it just
> results in bloat and bugs, none of which is desirable in the kernel.

I disagree.  First of all, clear separation between operations on
_filesystem_, which should all be namespace-agnostic and things
that depend on vfsmount is a Good Thing(tm).  Think of that as
of separation between server (superblock and everything related
to it, starting with dentry tree) and clients; mixing those is a
bloody bad idea.

What's more, I'm not at all convinced that for nfsd it's the right
set of checks, to start with.  The same goes for future users.

As for ecryptfs, looking at their "lower_mnt" thing...  I'd say that
it's a nonsense.  For one thing, duplicating a reference into ever
dentry out there (and it's simply duplicated) makes no sense whatsoever.
For another...  I'm not at all sure that remount of the underlying
vfsmount r/o *should* take that sucker read-only.  And if it should,
it's clearly an action that should have a visible effect on superblock
flags of ecryptfs.

	Incidentally, looking at ecryptfs open(), WTF is protecting
crypt_stat->flags?  We take crypt_stat->cs_mutex, do nothing but
check-and-modify of ->flags under it, then drop and several lines
later do crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED); with no ->cs_mutex
held...
