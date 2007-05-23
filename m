Return-Path: <linux-kernel-owner+w=401wt.eu-S1763693AbXEWHUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763693AbXEWHUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760685AbXEWHUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:20:00 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:35934 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760517AbXEWHT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:19:59 -0400
To: viro@ftp.linux.org.uk
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-reply-to: <20070523070306.GM4095@ftp.linux.org.uk> (message from Al Viro on
	Wed, 23 May 2007 08:03:06 +0100)
Subject: Re: [RFC PATCH] file as directory
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070522221045.GH4095@ftp.linux.org.uk> <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu> <20070523070306.GM4095@ftp.linux.org.uk>
Message-Id: <E1Hql7t-0001EQ-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 May 2007 09:19:17 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Interesting...  How do you deal with mount propagation and things like
> > > mount --move?
> > 
> > Moving (or doing other mount operations on) an ancestor shouldn't be a
> > problem.  Moving this mount itself is not allowed, and neither is
> > doing bind or pivot_root.  Maybe bind could be allowed...
> 
> Eh...  Arbitrary limitations are fun, aren't they?

But these mounts _are_ special.  There is really no point in moving or
pivoting them.

> > When doing recursive bind on ancestor, these mounts are skipped.
> 
> What about clone copying your namespace?

In that case they are cloned, but only those survive which have refs
in the new namespace.

> What about MNT_SLAVE stuff being set up prior to that lookup?

These mounts are not propagated.  Or at least I hope so.  Propagation
stuff is a bit too complicated for my poor little brain.

> More interesting question: should independent lookups of that sucker
> on different paths end up with the same superblock (and vfsmount for
> each) or should we get fully independent mount on each?  The latter
> would be interesting wrt cache coherency...

I think they should be the same superblock, same dentry.  What would
be the advantage of doing otherwise?

> > > As for unlink...  How do you deal with having that thing
> > > mounted, mounting something _under_ it (so that vfsmount would be kept
> > > busy) and then unlinking that sucker?
> > 
> > Yeah, that's a good point.  Current patch doesn't deal with that.
> > Simplest solution could be to disallow submounting these.  Don't think
> > it makes much sense anyway.
> 
> Arbitrary limitations... (and that's where revalidate horrors come in, BTW).
> BTW^2: what if fs mounted that way will happen to have such node itself?

I think doing this recursively should be allowed.  "Releasing last ref
cleans up the mess" should work in that case.

> I'm not saying that it's unfeasible or won't lead to interesting things,
> but it really needs semantics done right...

Agreed :)

Miklos
