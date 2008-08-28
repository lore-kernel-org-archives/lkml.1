Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbYH1UDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbYH1UDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175AbYH1UCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:02:30 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45563 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033AbYH1UC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:02:29 -0400
To: tj@kernel.org
CC: miklos@szeredi.hu, greg@kroah.com, fuse-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <48B6FFB6.7000104@kernel.org> (message from Tejun Heo on Thu, 28
	Aug 2008 21:42:46 +0200)
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org> <48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu> <48B6EBBD.6050406@kernel.org> <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu> <48B6EF98.4070008@kernel.org> <E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu> <48B6FFB6.7000104@kernel.org>
Message-Id: <E1KYnhA-0004Ei-3t@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 28 Aug 2008 22:02:16 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, Tejun Heo wrote:
> Miklos Szeredi wrote:
> >> Well, it's only 240 lines with good amount of comments and iovec copying
> >> function.  The ioctl itself isn't too complex.  I'm a bit skeptical
> >> about direct access.  It can easily introduce security vulnerabilities
> >> as there really is no way to hold a pid.
> > 
> > I don't understand.  No new vulnerabilities are introduced, since it
> > would just use existing infrastructure.
> > 
> > Why is it better if the kernel does the copying of memory regions
> > instructed by the userspace filesystem, than if the userspace
> > filesystem does that copying itself?  I feel they are totally
> > equivalent, except that the latter needs more complexity in the
> > kernel.
> 
> I'm no security expert but it feels pretty dangerous to me.  First of
> all, there are cases where the calling process can exit before the
> userland FUSE is finished with an operation, so it might not be always
> possible for the FUSE client to tell the PID it got is the correct one.

OK, I grant this one.  But then it's easy to protect against by
getting a ref on the task (or just the task ID, I don't know if that's
possible) for the duration of the ioctl.

> Another thing is that as it currently stands, the kernel side FUSE
> implementation forms a nice safety net taking responsibility of most
> security concerns and insulating the mistakes the client may make.
> Letting userland client to access and possibly modify the caller's
> memory directly weakens that insulation.

The same stupid mistakes can be done by giving the wrong instructions
to the kernel about what to modify, thus thrashing the calling
process.

> Pushing memory access to userland feels a bit too risky to me.  There
> seem to be too many loose components in security sensitive path and I
> have a nagging feeling that someone will come up with something we can't
> think of at the moment.

I don't see the difference.  You have to be careful either way, it's
not possible to do ioctls safely as the rest of fuse unfortunately.
This obviously also means, that it's impossible to run the filesystem
as an unprivileged user, as it has to have access to the whole address
space of the calling process either way (or ioctls have to be
restricted somehow).

Miklos
