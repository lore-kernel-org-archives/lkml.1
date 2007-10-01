Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbXJASIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbXJASIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbXJASHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:07:52 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:48894 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbXJASHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:07:50 -0400
To: neilb@suse.de
CC: hch@infradead.org, trond.myklebust@fys.uio.no, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <18172.27035.251565.338666@notabene.brown> (message from Neil
	Brown on Fri, 28 Sep 2007 12:40:27 +1000)
Subject: Re: [patch 2/2] VFS: allow filesystem to override mknod capability checks
References: <E1IZmze-0003q9-00@dorka.pomaz.szeredi.hu>
	<E1IZn0c-0003qS-00@dorka.pomaz.szeredi.hu> <18172.27035.251565.338666@notabene.brown>
Message-Id: <E1IcPfE-0000Mk-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 01 Oct 2007 20:06:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Monday September 24, miklos@szeredi.hu wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Add a new super block flag, that results in the VFS not checking if
> > the current process has enough privileges to do an mknod().
> > 
> > If this flag is set, all mounts for this super block will have the
> > "nodev" flag implied.
> > 
> > This is needed on filesystems, where an unprivileged user may be able
> > to create a device node, without causing security problems.
> > 
> > One such example is "mountlo" a loopback mount utility implemented
> > with fuse and UML, which runs as an unprivileged userspace process.
> > In this case the user does in fact have the right to create device
> > nodes within the filesystem image, as long as the user has write
> > access to the image.  Since the filesystem is mounted with "nodev",
> > adding device nodes is not a security concern.
> 
> I must admit that I don't feel very comfortable about this.  I wonder
> how many more flags we might be tempted to add to allow
> user-controlled filesystems to do interesting things.  Somehow I doubt
> this will be the last, so we should be very careful allowing it to be
> the first (or is it the second already?)

Or third ;)

Yes, I've always argued, that permission checking needs to be pushed
to the filesystem, since the VFS can't always do a good enough job.

My usual example is sshfs, where it is just impossible to know the
uid/gid mapping between the server and the client.  So any permission
checking based on uid or gid on the client simply can't work, the only
sane thing to do is to delegate the permission checking to the server.
Which works beautifully, since the server is an unprivileged process,
and everything automatically works out.

All the fuse kernel module has to do is to basically define
->permission() to always return success, and let the userspace
filesystem do the permission checking.

This works fine, except a couple of things, like checking the sticky
bit on a directory, and mknod().

> A more concrete comment on the patch:  Is it really necessary to
> introduce IS_MNT_NODEV??  Why not simply test both the flags
> (MS_MKNOD_NOCAP and MNT_NODEV) before allowing the mknod?

Because we need MNT_NODEV on _all_ mounts belonging to a superblock,
not just the one on which mknod was performed on, which would get
really ugly.  This way it's simple: if the MS_MKNOD_NOCAP is specified
for the super block, that implies, that devices can't be opened.

> Do we actually need a new flag?  Would not a combination of MS_NODEV
> and MS_SETUSER achieve the same thing (near enough)?

See above.

> Do you imagine this flag being set as a mount option (-o unprivmknod)
> or does the filesystem set it itself?

I imagine this flag to usually be set by the filesystem itself.  But
it could be a separate mount option.  I guess it could make sense in
some non-fuse cases as well.

> If the latter, maybe this test should be moved down into the
> filesystems ->mknod operation.  Most filesystems get
>  
> 	if ((S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD))
>  		return -EPERM;
> 
> at the top of ->mknod.  fuse can do whatever it likes without
> bothering common code.

Yes, that's one of the options, but it would be a huge change, with
nasty security implications for past and future filesystems.

> According to fs.h, we only support 32 fs-independent mount-flags, and
> over half are in use.  I'm not convinced we should spend one on such a
> narrow requirement.

I think there's consensus on the need for a new mount API.  Not just
because the 32 bits for the flags will be exhausted sooner or later
anyway, but the current API is limited in lots of other ways.

Miklos
