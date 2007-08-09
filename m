Return-Path: <linux-kernel-owner+w=401wt.eu-S1764933AbXHIUMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764933AbXHIUMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759162AbXHIULG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:11:06 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:34502 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758368AbXHIULD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:11:03 -0400
To: serge@hallyn.com
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org
In-reply-to: <20070809192045.GA16682@vino.hallyn.com> (serge@hallyn.com)
Subject: Re: [RFC PATCH 4/4] VFS: allow filesystem to override mknod capability checks
References: <20070809152744.519270818@szeredi.hu> <20070809152909.203254312@szeredi.hu> <20070809192045.GA16682@vino.hallyn.com>
Message-Id: <E1IJEKl-0007XB-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 09 Aug 2007 22:10:15 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Add a new filesystem flag, that results in the VFS not checking if the
> > current process has enough privileges to do an mknod().
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
> Could we enforce at do_new_mount() that if
> type->fs_flags&FS_MKNOD_CHECKS_PERM then mnt_flags |= MS_NODEV?

Well, the problem with that is, there will be fuse filesystems which
will want devices to work and for those the capability checks will be
reenabled inside ->mknod().  In fact, for backward compatibility all
filesystems will have the mknod checks, except ones which explicitly
request to turn it off.

Since unprivileged fuse mounts always have "nodev", the only way
security could be screwed up, is if a filesystem running with
privileges disabled the mknod checks.

I will probably add some safety guards against that into the fuse
library, but of course there's no way to stop a privileged user from
screwing up security anyway.

If for example there's a loop mount, where the disk image file is
writable by a user, and root mounts it without "nodev", the user can
still create device nodes (by modifying the image) even if the mknod
checks are enabled.

Miklos
