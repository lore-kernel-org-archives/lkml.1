Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbYJNJhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbYJNJhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbYJNJhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:37:31 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44234 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbYJNJha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:37:30 -0400
To: tj@kernel.org
CC: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
In-reply-to: <48F4568B.7000609@kernel.org> (message from Tejun Heo on Tue, 14
	Oct 2008 17:21:31 +0900)
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org>
Message-Id: <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 14 Oct 2008 11:37:14 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Tue, 14 Oct 2008, Tejun Heo wrote:
> Hello, Miklos.
> 
> I'm about ready to send the next round of this patchset w/ mmap support,
> which I'm sure gonna stir up some discussion. :-) Several things I wanna
> hear your comments about.

Great.  Just yesterday evening I was looking through your patches to
see which ones I can submit for 2.6.28, and I've already applied

  0001-FUSE-add-include-protectors.patch
  0003-FUSE-implement-nonseekable-open.patch

Comments about the others:

  0002-FUSE-pass-nonblock-flag-to-client.patch

this is not needed, f_flags are already passed to userspace for read
and write.

  0004-FUSE-implement-direct-lseek-support.patch

this is trickier to get the interface right I think.  If we want to
allow filesystems to implement a custom lseek, then we also want them
to keep track of the file position, which means we must differentiate
between a write(2) and a pwrite(2) and similarly for reads.  AFAICS
this isn't needed for CUSE so we can leave this to later.

  0005-FUSE-implement-ioctl-support.patch

See below.

  0006-FUSE-implement-unsolicited-notification.patch
  0007-FUSE-implement-poll-support.patch

This would be nice, but...  I don't really like the fact that it uses
the file handle.  Could we have a separate "poll handle" that is
returned in the POLL reply?

> 1. I'll try to incorporate all other comments here but regarding ioctl I
> don't think we've reached any better solution, so I'm sticking with the
> original one.

I still got qualms about this ioctl thing.  One is the security
aspect, but that could be dealt with.  The other is that I really
really don't want people to start implementing new custom ioctls for
their filesystems, as I think that way lies madness.  We could limit
ioctls to CUSE and that would be fine with me.  Or for non-CUSE users
we could enforce the "standard" format where the type and length is
encoded in the command number.

I don't have any problems with the iterative way you implemented
ioctls.  We just need some additional restrictions to the current
implementation, I think.

> 2. You told me that the version branching in the userland library wasn't
> necessary.  Can you explain to me when FUSE version bumping is necessary?

The version number has to be bumped anyway.  But if you are only
adding new functions to the end of fuse_operations and
fuse_lowlevel_ops, then the interface can handle that, without needing
new compatibility functions.

> 3. Any other things on you mind?

One other thing I was thinking about is that do we really need
emulated char devices to be char devices?  What I mean is, what would
happen if instead of a char device /dev/dsp would be a regular file
mounted on /dev/dsp (which implements all the necessary interfaces:
ioctls, poll, etc)?

Thanks,
Miklos
