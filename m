Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbYFCPCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbYFCPCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 11:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYFCPCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 11:02:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbYFCPCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 11:02:39 -0400
Date: Tue, 3 Jun 2008 08:01:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
       jesper@krogh.cc, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
In-Reply-To: <1212499623.3025.46.camel@raven.themaw.net>
Message-ID: <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>  <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk>  <20080603095713.GR28946@ZenIV.linux.org.uk>  <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk> 
 <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>  <20080603104035.GT28946@ZenIV.linux.org.uk>  <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>  <20080603105258.GV28946@ZenIV.linux.org.uk> <1212499623.3025.46.camel@raven.themaw.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Jun 2008, Ian Kent wrote:
> > 
> > > I think it must be autofs4 doing something weird.  Like this in
> > > autofs4_lookup_unhashed():
> > > 
> > > 			/*
> > > 			 * Make the rehashed dentry negative so the VFS
> > > 			 * behaves as it should.
> > > 			 */
> > > 			if (inode) {
> > > 				dentry->d_inode = NULL;

Uhhuh. Yeah, that's not allowed.

A dentry inode can start _out_ as NULL, but it can never later become NULL 
again until it is totally unused.

> > Lovely.  If we ever step into that with somebody else (no matter who)
> > holding a reference to that dentry, we are certainly well and truly
> > buggered.  It's not just mount(2) - everything in the tree assumes that
> > holding a reference to positive dentry guarantees that it remains
> > positive.

Indeed. Things like regular file ops won't even test the inode, since they 
know that "open()" will only open a dentry with a positive entry, so they 
know that the dentry->inode is non-NULL.

[ Although some code-paths do test - but that is just because people are 
  so used to testign that pointers are non-NULL. ]

> The intent here is that, the dentry above is unhashed at this point, and
> if hasn't been reclaimed by the VFS, it is made negative and replaces
> the unhashed negative dentry passed to ->lookup(). The reference count
> is incremented to account for the reference held by the path walk.
> 
> What am I doing wrong here?

What's wrong is that you can't do that "dentry->d_inode = NULL". EVER.

Why would you want to? If the dentry is already unhashed, then no _new_ 
lookups will ever find it anyway, so it's effectively unfindable anyway. 
Except by people who *have* to find it, ie the people who already hold it 
open (because, for example, they opened it earlier, or because they 
chdir()'ed into a subdirectory).

So why don't you just return a NULL dentry instead, for a unhashed dentry? 
Or do the "goto next" thing?

			Linus
