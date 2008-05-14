Return-Path: <linux-kernel-owner+w=401wt.eu-S1758411AbYENWD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbYENWD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbYENWDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:03:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60693 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbYENWDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:03:50 -0400
Message-ID: <482B61C2.9070106@firstfloor.org>
Date: Thu, 15 May 2008 00:03:46 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
References: <20080514174955.GA515@elte.hu> <87fxsk7n7e.fsf@basil.nowhere.org> <20080514220034.51eae9e0@core> <482B5614.3060203@firstfloor.org> <20080514221957.6edb2d60@core> <alpine.LFD.1.10.0805141435540.3019@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805141435540.3019@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 14 May 2008, Alan Cox wrote:
>> That in itself is a problem Ingo's stuff won't help with: We have lots of
>> "magic" accidental, undocumented and pot luck BKL locking semantics
>> between subsystems that are not even visible.
> 
> The good news is that I suspect they are going away. It probably is mainly 
> tty and /proc by now, and /proc is pretty close to done.

Character devices in general.

And what's pretty nasty is that some interfaces force BKL still, so
not even new code can opt out.

> In the VFS layer, we still have 
> 
>  - the ioctl thing, obviously. That's just mind-numbing "move things 
>    down", not hard per se. But there's a *lot* of them (and I suspect the 
>    huge majority of them don't actually need it, since they'd already be 
>    racing against read/write anyway if they did).
> 
>  - default_llseek(). Probably the same, just a lot less of it.

I had some patches for those.

> 
>  - superblock read/write.
> 

- fasync

[had some patches for "fasync_locked", not sure if it's worth it]

- character device open

That's a nasty one. Either open_unlocked or a special cdev_init?

> and the latter one in particular is really dubious (we already have 
> "[un]lock_super()" around it all, I think).
> 
> The core kernel, VM and networking already don't really do BKL. And it's 
> seldom the case that subsystems interact with other unrelated subsystems 
> outside of the core areas.
> 
> So it's a lot of work, no doubt, but I do think we should be able to do 
> it. The most mind-numbing part is literally all the ioctl crud. There's 
> more ioctl points than there are lock_kernel() calls left anywhere else.

I tried to recruit kernel janitors some time ago to just do all the
ioctl -> ioctl_unlocked/explicit lock_kernel changes. There were a few
patches generated but the effort died down then.

BTW for ioctl the dynamic instrumentation method proposed also won't
work because it's basically impossible to exercise all these ioctls

-Andi


