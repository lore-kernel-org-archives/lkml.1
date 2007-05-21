Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbXEUGkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbXEUGkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 02:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbXEUGkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 02:40:39 -0400
Received: from hu-out-0506.google.com ([72.14.214.238]:30363 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbXEUGki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 02:40:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=LSfJcR/Bt7RhQGcgIK9BMULoZ3g5mzGqXrPVll5zM7LhHiaC1GdVZwO5Ws2I/RS06C1NYX0U8kma50mUw7TTUXwMpma3zKeO4uBtGhX71X2ErHnnk39lUOwyK0abODpxF1XeGu0LidsygJQXd9ECQnJ+e+HgsyX/rqajKHTTjbI=
Message-ID: <2c0942db0705202340j4dade008v321d605585231d6@mail.gmail.com>
Date: Sun, 20 May 2007 23:40:37 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Ken Chen" <kenchen@google.com>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Cc: "Andrey Borzenkov" <arvidjaar@mail.ru>, "Uwe Bugla" <uwe.bugla@gmx.de>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <b040c32a0705202308h7fda56c1r85bac3ce4c172488@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F42F3.1080300@madrabbit.org>
	 <20070519191751.E51233A23A2@muan.mtu.ru>
	 <200705200124.13026.uwe.bugla@gmx.de>
	 <200705200845.43621.arvidjaar@mail.ru>
	 <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com>
	 <b040c32a0705202308h7fda56c1r85bac3ce4c172488@mail.gmail.com>
X-Google-Sender-Auth: d62a181fbdb5c51d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Ken Chen <kenchen@google.com> wrote:
> On 5/19/07, Ray Lee <ray-lk@madrabbit.org> wrote:
> > Yeah, that's the only one left. I was hoping it wasn't that one, as it
> > claimed to have been tested extensively. Guess it wasn't tested with
> > udev.
> >
> > Ken? Ball's in your court. As the patch isn't providing a killer
> > feature for 2.6.22, I'd suggest just reverting it for now until the
> > issues are ironed out.
>
> The real solution is to have the user space tool to create these
> device nodes in advance.

Maybe. But requiring people upgrade their userspace tools or setup for
2.6.22 isn't a reasonable solution.

> The original loop patch was coded such that when we open a loop device
> N, the immediate adjacent device "N + 1" is created.  This will keep
> "mount -o loop" happy because it typically does a linear scan to find
> a free device.  This might be somewhat hackary, but certainly will be
> backward compatible before user space solution is deployed.

Except userspace is currently expecting 8 loop nodes upon bootup.
Creating n+1 when n is opened is good, but racy if userspace tries to
mount serveral loop devices in parallel.

If the loop device instantiates 8 (or max_loop) upon init, then we're
compatible with how things are being done in 2.6.21 and earlier.

> However, the code was removed by Al in this commit:

> commit 07002e995638b83a6987180f43722a0eb39d4932
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Sat May 12 16:23:15 2007 -0400

>   fix the dynamic allocation and probe in loop.c

No, backing that code out wasn't good enough -- the reporter tested
reverting both of Al's patches out and was still getting errors on
boot. It took reverting your original one out as well to make it work.

So, a compromise? Let's start with 8 (or max_loop) populated, and then
we can move forward separately with teaching userspace new loop
tricks.
