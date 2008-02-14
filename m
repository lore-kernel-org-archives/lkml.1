Return-Path: <linux-kernel-owner+w=401wt.eu-S1765838AbYBNWTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765838AbYBNWTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbYBNWTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:19:19 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48835 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbYBNWTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:19:18 -0500
To: trond.myklebust@fys.uio.no
CC: miklos@szeredi.hu, menage@google.com, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <1203016675.18369.21.camel@heimdal.trondhjem.org> (message from
	Trond Myklebust on Thu, 14 Feb 2008 14:17:55 -0500)
Subject: Re: [PATCH] Add MS_BIND_FLAGS mount flag
References: <47B283EB.8070209@google.com>
	 <E1JPZUb-00013Z-0U@pomaz-ex.szeredi.hu>
	 <6599ad830802140719l270d6fdfyd6d17806eda12a8d@mail.gmail.com>
	 <E1JPgYm-0002dm-IX@pomaz-ex.szeredi.hu>
	 <1203006419.8343.48.camel@heimdal.trondhjem.org>
	 <E1JPi3u-0002rp-Nz@pomaz-ex.szeredi.hu> <1203016675.18369.21.camel@heimdal.trondhjem.org>
Message-Id: <E1JPmPw-0003au-SF@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 14 Feb 2008 23:18:56 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2008-02-14 at 18:39 +0100, Miklos Szeredi wrote:
> > > > And I'm not against doing it with the "at*" variants, as Trond
> > > > suggested.
> > > 
> > > If you're going to change the syscall, then you should ensure that it
> > > solves _all_ the problems that are known at this time. Ignoring the
> > > automounter issue is just going to force us to redo the syscall in a
> > > couple of months...
> > 
> > Sure.
> > 
> > Although, an (almost) equivalent userspace code would be:
> > 
> > mount_fooat(int fd, const char *path)
> > {
> > 	char tmpbuf[64];
> > 	int tmpfd = openat(fd, path);
> > 
> > 	sprintf(tmpbuf, "/proc/self/fd/%i", tmpfd);
> > 	return mount_foo(tmpbuf, ...);
> > }
> >
> > Or is there something (other than not requiring proc) that the *at
> > variant gives?
> 
> The ability to have a daemon handle mounting onto a directory that only
> exists in another process's private namespace.
> 
> Say I'm running in my private namespace that contains paths that are not
> shared by the trusted 'init' namespace. If I were to step on an
> autofs-like trap, I'd like for the kernel to be able to notify the
> automounter that is running in the trusted namespace set up by 'init',
> and have it mount the directory onto my namespace. This should happen
> even if the path is not shared.
> 
> With mountat() the kernel can still pass the necessary information to
> the automounter by giving it a directory file descriptor 'fd' that
> points to the directory on top of which it wants the mount to occur.
> Then automounter then executes
> 
>      mountat(AT_FDCWD, dev_name, fd, '.', type, flags, data);
> 
> and hey presto, the magic occurs.

I understand perfectly that this is what you want to do.  And I'm
saying that the following code snippet should do exactly the same,
without having to add a new syscall:

	char tmpbuf[64];
	sprintf(tmpbuf, "/proc/self/fd/%i", fd);
	mount(dev_name, tmpbuf, type, flags, data);

[ You could actually try to read people's responses, instead of
immediately assuming they don't understand :-/ ]

So again, what is the advantage of a mountat() syscall over just using
the proc trick?

Miklos
