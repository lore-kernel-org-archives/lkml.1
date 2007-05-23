Return-Path: <linux-kernel-owner+w=401wt.eu-S1760441AbXEWGgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441AbXEWGgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 02:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbXEWGgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 02:36:45 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:52952 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbXEWGgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 02:36:44 -0400
To: viro@ftp.linux.org.uk
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-reply-to: <20070522221045.GH4095@ftp.linux.org.uk> (message from Al Viro on
	Tue, 22 May 2007 23:10:46 +0100)
Subject: Re: [RFC PATCH] file as directory
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070522221045.GH4095@ftp.linux.org.uk>
Message-Id: <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 May 2007 08:36:04 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > When a non-directory object is accessed without a trailing slash, then
> > path resolution returns the object itself as usual.
> > 
> > If a non-directory object is accessed with a trailing slash, then the
> > filesystem may opt to let the file be accessed as a directory.  In
> > this case "something" (as supplied by the filesystem) is mounted on
> > top of the non-directory object.
> > 
> > This mount will have special properties:
> > 
> >  - If there's no trailing slash is after the file name, the mount
> >    won't be followed, even if the path resolution would otherwise
> >    follow mounts.
> > 
> >  - The mount only stays there while it is referenced by some external
> >    object, like a pwd or an open file.  When it is no longer
> >    referenced, it is automatically unmounted.
> > 
> >  - Unlike "real" mounts, this won't block unlink(2) or rename(2) on
> >    the underlying object.
> 
> Interesting...  How do you deal with mount propagation and things like
> mount --move?

Moving (or doing other mount operations on) an ancestor shouldn't be a
problem.  Moving this mount itself is not allowed, and neither is
doing bind or pivot_root.  Maybe bind could be allowed...

When doing recursive bind on ancestor, these mounts are skipped.

> As for unlink...  How do you deal with having that thing
> mounted, mounting something _under_ it (so that vfsmount would be kept
> busy) and then unlinking that sucker?

Yeah, that's a good point.  Current patch doesn't deal with that.
Simplest solution could be to disallow submounting these.  Don't think
it makes much sense anyway.

> I'll look through the patch tonight; it sounds interesting, assuming that
> we don't run into serious crap with locking and <shudder> revalidation
> logics.

Revalidation shouln't be a problem.  We'll just end up with an
unhashed dentry with a mount over it, which will be detached when the
vfsmount ref is dropped.

Miklos
