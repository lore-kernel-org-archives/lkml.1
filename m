Return-Path: <linux-kernel-owner+w=401wt.eu-S1765146AbYEVHBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765146AbYEVHBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 03:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758048AbYEVHAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 03:00:55 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46530 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001AbYEVHAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 03:00:54 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, hch@infradead.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080521202914.GP28946@ZenIV.linux.org.uk> (message from Al Viro
	on Wed, 21 May 2008 21:29:14 +0100)
Subject: Re: [patch 07/14] vfs: pass dentry to permission()
References: <20080521171458.077908538@szeredi.hu> <20080521171551.453155765@szeredi.hu> <20080521202914.GP28946@ZenIV.linux.org.uk>
Message-Id: <E1Jz4n9-00079l-Ub@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 May 2008 09:00:47 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > The following patches clean up the i_op->permission() method and the
> > related VFS API.
> > 
> > Here's an overview of the changes:
> > 
> >  - ->permission() is passed a dentry instead of an inode
> >  - ->permission() is passed a integer flags parameter instead of a
> >    nameidata pointer
> 
> No.  Take a good look at the instances.
> 
> 	a) only one aberrant case cares about dentry, and for extremely
> wrong reasons.  /proc/sys/ stuff.  ecryptfs, of course, will be happy
> with any variant.

Yeah.  The real reason I changed to dentry is not /proc/sys or
ecryptfs, but because it's the Right Thing.  And if we have to touch
all instances anyway, then it basically comes for free.

Why dentry?  Because of filesystems which operate on names and not
inodes.  Currently all these manage to get by, because their
->permission() just uses the cached attributes.  But that should not
necessarily be the case.

Look at the inode_operations, each and every one passes a dentry (or
dentries) to the filesystem, except permission().

OTOH there isn't any immediate need for this, it's just an interface
rationalization thing, so...

> 	b) few flags that are looked at are trivially mapped to new MAY_...

OK.

> I have a patch series that does it, but it involves tons of fixing the
> sysctl handling to be finished ;-/  And yes, we need sysctl to quit
> doing the "I want to get ctl_table entry, so I'll do very painful search
> by dentry every damn time" in any case - look at that code, it's far
> too ugly to live.

I shut my eyes and just squinted while touching that code ;)

> 
> IOW, consider this ->permission() API change NAKed.

I'll fix b) and repost.  There's a bit more to this series, than just
the ->permission() API change.

Miklos
