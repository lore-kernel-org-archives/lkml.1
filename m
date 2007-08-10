Return-Path: <linux-kernel-owner+w=401wt.eu-S938606AbXHJOq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938606AbXHJOq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939333AbXHJOox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:44:53 -0400
Received: from smtp119.sbc.mail.re3.yahoo.com ([66.196.96.92]:30558 "HELO
	smtp119.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S939261AbXHJOou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:44:50 -0400
X-YMail-OSG: YaKNz.AVM1kMIJI96mcpxvUdJy63PwAUutLsNsW5P2zOuzK5k5tn9jJdF5aKBfmOV0rwANDAOOKa7V8.j9Zs83ZOmvtWb0iko_QqFDMa8l4TaTyqvXLOPqjtlWx3TEIzW_0oA3gdUbDd.Lo-
Date: Fri, 10 Aug 2007 09:44:46 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serge@hallyn.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org
Subject: Re: [RFC PATCH 4/4] VFS: allow filesystem to override mknod capability checks
Message-ID: <20070810144445.GA23584@vino.hallyn.com>
References: <20070809152744.519270818@szeredi.hu> <20070809152909.203254312@szeredi.hu> <20070809192045.GA16682@vino.hallyn.com> <E1IJEKl-0007XB-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IJEKl-0007XB-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > 
> > > Add a new filesystem flag, that results in the VFS not checking if the
> > > current process has enough privileges to do an mknod().
> > > 
> > > This is needed on filesystems, where an unprivileged user may be able
> > > to create a device node, without causing security problems.
> > > 
> > > One such example is "mountlo" a loopback mount utility implemented
> > > with fuse and UML, which runs as an unprivileged userspace process.
> > > In this case the user does in fact have the right to create device
> > > nodes within the filesystem image, as long as the user has write
> > > access to the image.  Since the filesystem is mounted with "nodev",
> > > adding device nodes is not a security concern.
> > 
> > Could we enforce at do_new_mount() that if
> > type->fs_flags&FS_MKNOD_CHECKS_PERM then mnt_flags |= MS_NODEV?
> 
> Well, the problem with that is, there will be fuse filesystems which
> will want devices to work

Crud, sorry, I forgot all fuse filesystems will have the same fs_flags.

> and for those the capability checks will be
> reenabled inside ->mknod().  In fact, for backward compatibility all
> filesystems will have the mknod checks, except ones which explicitly
> request to turn it off.
> 
> Since unprivileged fuse mounts always have "nodev", the only way

Ah yes, I'd forgotten that we do if (!capable(mknod)) mnt_flags |= MNT_NODEV

No objections then anyway.  Thanks for indulging me :)

> security could be screwed up, is if a filesystem running with
> privileges disabled the mknod checks.
> 
> I will probably add some safety guards against that into the fuse
> library, but of course there's no way to stop a privileged user from
> screwing up security anyway.

Agreed.

> If for example there's a loop mount, where the disk image file is
> writable by a user, and root mounts it without "nodev", the user can
> still create device nodes (by modifying the image) even if the mknod
> checks are enabled.

thanks,
-serge

