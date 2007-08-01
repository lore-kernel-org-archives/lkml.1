Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbXHAGxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbXHAGxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 02:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbXHAGxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 02:53:11 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:47158 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbXHAGxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 02:53:10 -0400
To: kzak@redhat.com
CC: chuck.lever@oracle.com, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, sfrench@samba.org,
       trond.myklebust@fys.uio.no, mark.fasheh@oracle.com,
       kurt.hackel@oracle.com
In-reply-to: <20070731222141.GB3180@petra.dvoda.cz> (message from Karel Zak on
	Wed, 1 Aug 2007 00:21:41 +0200)
Subject: Re: request for patches: showing mount options
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu> <46AA4AC5.2050200@oracle.com> <E1IEW21-0001kL-00@dorka.pomaz.szeredi.hu> <46AA51CA.7030105@oracle.com> <E1IEezF-0002g6-00@dorka.pomaz.szeredi.hu> <46AE01C2.3000008@oracle.com> <E1IFnSa-0002BL-00@dorka.pomaz.szeredi.hu> <46AF450D.5020106@oracle.com> <20070731222141.GB3180@petra.dvoda.cz>
Message-Id: <E1IG84S-00064z-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 01 Aug 2007 08:52:36 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The removal of /etc/mtab in favor of /proc/mounts is a new requirement, 
> > and is not as trivial as you might hope.  Internally the NFS client 
> > represents the mount options as a binary data structure, and it contains 
> > only the information that has traditionally been passed into the kernel 
> > by the current mount command.  The user-space-only options are not 
> > passed to the kernel nor stored in the data structure.
> > 
> > Adding facilities to store information about every possible mount 
> > option, including the user-space-only ones, will take a bit of time, but 
> > is possible, if not straightforward.  We just have to understand all the 
> > dependencies.
> 
>  I still have doubts. The removal of /etc/mtab is nice, but a little
>  unreal wish. Do we really want to store non-kernel data (options) in
>  kernel? What about options that are not closely related to any
>  filesystem -- for example "loop="?

"loop=DEV" is special, we've already talked about that.

For example if we have an mtab entry like this:

  /dir/foo.iso /mnt/image ext3 rw,loop=/dev/loop/0 0 0

It says: /dev/loop/0 has been automatically set up by mount(8) from
/dir/foo.iso and so needs to be torn down by umount(8).  It is not a
property of the mount, rather the property of the device.

So what we really want is a file to store this, and only this info:

/var/lib/mount/loop:

/dev/loop/0 /dir/foo.iso
/dev/loop/2 /dir/bar.img
...

Notice, there's nothing about the _mountpoint_ in this file.

>  Maybe we can replace /etc/mtab with something more useful
>  (e.g. /var/run/mount/<mntid>.tab) for really user-space-only information.

The problem with storing mount options in userspace is that
unprivileged mounts/umounts won't work in the presense of those, we
cannot _force_ an unprivileged user to update a file.

So we want to avoid storing options in userspace as long as possible.

Miklos
