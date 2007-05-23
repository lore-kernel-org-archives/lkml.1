Return-Path: <linux-kernel-owner+w=401wt.eu-S1759199AbXEWIGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199AbXEWIGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 04:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbXEWIGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 04:06:06 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:44957 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbXEWIGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 04:06:04 -0400
To: viro@ftp.linux.org.uk
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-reply-to: <20070523073658.GO4095@ftp.linux.org.uk> (message from Al Viro on
	Wed, 23 May 2007 08:36:58 +0100)
Subject: Re: [RFC PATCH] file as directory
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070522221045.GH4095@ftp.linux.org.uk> <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu> <20070523070306.GM4095@ftp.linux.org.uk> <E1Hql7t-0001EQ-00@dorka.pomaz.szeredi.hu> <20070523073658.GO4095@ftp.linux.org.uk>
Message-Id: <E1HqlqT-0001KD-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 May 2007 10:05:21 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Eh...  Arbitrary limitations are fun, aren't they?
> > 
> > But these mounts _are_ special.  There is really no point in moving or
> > pivoting them.
> 
> pivoting - probably true, moving... why not?

I don't see any use for that.  But indeed, it should not be too hard
to do.

> > > What about MNT_SLAVE stuff being set up prior to that lookup?
> > 
> > These mounts are not propagated.  Or at least I hope so.  Propagation
> > stuff is a bit too complicated for my poor little brain.
> 
> Er...  These mounts might not be propagated, but what about a bind
> over another instance of such file in master tree?

So your question is, which mount takes priority on the lookup?  It
probably should be the propagated real mount, rather than the
dir-on-file one, shouldn't it?

> > I think they should be the same superblock, same dentry.  What would
> > be the advantage of doing otherwise?
> 
> Then you are going to have interesting time with locking in final mntput().

Final mntput of what?

> BTW, what about having several links to the same file?  You have i_mutex
> on the inode, so serialization of those is not a problem, but...

Sorry, I lost it...

> > I think doing this recursively should be allowed.  "Releasing last ref
> > cleans up the mess" should work in that case.
> 
> Releasing the last reference will lead to cascade of umounts in that
> case...  IOW, need to be careful with locking.

I think it's done right: detach_mnt() with namespace_sem and
vfsmount_lock, then release locks, and path_release(&old_nd).

If the recursion is extremely deep we could have stack overflow
problems though, aargh...

Miklos
