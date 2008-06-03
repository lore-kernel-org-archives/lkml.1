Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbYFCQLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbYFCQLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 12:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYFCQK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 12:10:59 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39378 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511AbYFCQK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:10:58 -0400
X-Sasl-enc: I/wgdTzGCtAG9hoaqjX47YK/nhfWty0MqtLx7kb9f/Fz 1212509456
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
       jesper@krogh.cc, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
	 <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk>
	 <20080603095713.GR28946@ZenIV.linux.org.uk>
	 <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk>
	 <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>
	 <20080603104035.GT28946@ZenIV.linux.org.uk>
	 <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
	 <20080603105258.GV28946@ZenIV.linux.org.uk>
	 <1212499623.3025.46.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 00:07:42 +0800
Message-Id: <1212509263.3025.66.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-03 at 08:01 -0700, Linus Torvalds wrote:
> 
> On Tue, 3 Jun 2008, Ian Kent wrote:
> > > 
> > > > I think it must be autofs4 doing something weird.  Like this in
> > > > autofs4_lookup_unhashed():
> > > > 
> > > > 			/*
> > > > 			 * Make the rehashed dentry negative so the VFS
> > > > 			 * behaves as it should.
> > > > 			 */
> > > > 			if (inode) {
> > > > 				dentry->d_inode = NULL;
> 
> Uhhuh. Yeah, that's not allowed.
> 
> A dentry inode can start _out_ as NULL, but it can never later become NULL 
> again until it is totally unused.
> 
> > > Lovely.  If we ever step into that with somebody else (no matter who)
> > > holding a reference to that dentry, we are certainly well and truly
> > > buggered.  It's not just mount(2) - everything in the tree assumes that
> > > holding a reference to positive dentry guarantees that it remains
> > > positive.
> 
> Indeed. Things like regular file ops won't even test the inode, since they 
> know that "open()" will only open a dentry with a positive entry, so they 
> know that the dentry->inode is non-NULL.
> 
> [ Although some code-paths do test - but that is just because people are 
>   so used to testign that pointers are non-NULL. ]
> 
> > The intent here is that, the dentry above is unhashed at this point, and
> > if hasn't been reclaimed by the VFS, it is made negative and replaces
> > the unhashed negative dentry passed to ->lookup(). The reference count
> > is incremented to account for the reference held by the path walk.
> > 
> > What am I doing wrong here?
> 
> What's wrong is that you can't do that "dentry->d_inode = NULL". EVER.

OK.

> 
> Why would you want to? If the dentry is already unhashed, then no _new_ 
> lookups will ever find it anyway, so it's effectively unfindable anyway. 
> Except by people who *have* to find it, ie the people who already hold it 
> open (because, for example, they opened it earlier, or because they 
> chdir()'ed into a subdirectory).

The code we're talking about deals with a race between expiring and
mounting an autofs mount point at the same time. 

I'll have a closer look and see if I can make it work without turning
the dentry negative.

> 
> So why don't you just return a NULL dentry instead, for a unhashed dentry? 
> Or do the "goto next" thing?

That just won't work for the case this is meant to deal with.

Ian


