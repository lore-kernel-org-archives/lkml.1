Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbYKMLU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbYKMLU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 06:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbYKMLUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 06:20:12 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52998 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYKMLUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 06:20:11 -0500
To: tj@kernel.org
CC: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
In-reply-to: <491BC3E3.7040903@kernel.org> (message from Tejun Heo on Thu, 13
	Nov 2008 15:06:27 +0900)
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491A96AE.3080600@kernel.org> <491BC3E3.7040903@kernel.org>
Message-Id: <E1L0aEn-0006dh-BK@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 13 Nov 2008 12:19:49 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008, Tejun Heo wrote:
> Tejun Heo wrote:
> >> I still got qualms about this ioctl thing.  One is the security
> >> aspect, but that could be dealt with.  The other is that I really
> >> really don't want people to start implementing new custom ioctls for
> >> their filesystems, as I think that way lies madness.  We could limit
> >> ioctls to CUSE and that would be fine with me.  Or for non-CUSE users
> >> we could enforce the "standard" format where the type and length is
> >> encoded in the command number.
> > 
> > For now, I'll limit ioctl to CUSE.  Hmmm... Yeah, limiting ioctl to
> > well-formatted ones sounds like a good idea.
> > 
> >> I don't have any problems with the iterative way you implemented
> >> ioctls.  We just need some additional restrictions to the current
> >> implementation, I think.
> 
> I've been thinking about this a bit more.  What do you think about
> putting the following restrictions?
> 
> 1. FUSE server can only support well-formed ioctls.  At the kernel side,
> the interfaces remains the same for both FUSE and CUSE but libfuse only
> exports well-formed ioctl API.
> 
> 2. ioctl can only be used by FUSE server running as root (would this be
> necessary?  I'm not sure.  To me it seems all the necessary protections
> are already there).

Not with '-oallow_other'.  Consider the case that the caller invoked a
non well formed ioctl, but since there's no way to know this we
allowed the fuse server to tinker with the caller's address space
_as if_ the ioctl was well formed.

So we should always make sure that the server has enough privilege to
read/write the caller's memory, i.e. it can ptrace the caller.

At this point we could allow any ioctls, not just well formed ones.
But I don't want that for a different reason: if the possibility is
there people will find new "innovative" uses for it and just get
themselves into a big mess.

Miklos
