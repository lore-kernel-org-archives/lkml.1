Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbXDZWkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbXDZWkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbXDZWkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:40:32 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59134 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755175AbXDZWkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:40:16 -0400
Date: Fri, 27 Apr 2007 00:40:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070426224005.GA21926@elf.ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> <1177573348.5025.224.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > * Doing things in the right order? (Prepare the image, then do the
> > atomic copy, then save).
> 
> I'd actually like to discuss this a bit..
> 
> I'm obviously not a huge fan of the whole user/kernel level split and 
> interfaces, but I actually do think that there is *one* split that makes 
> sense:
> 
>  - generate the (whole) snapshot image entirely inside the kernel
> 
>  - do nothing else (ie no IO at all), and just export it as a single image 
>    to user space (literally just mapping the pages into user space). 
>    *one* interface. None of the "pretty UI update" crap. Just a single 
>    system call:
> 
> 	void *snapshot_system(u32 *size);
> 
>    which will map in the snapshot, return the mapped address and the size 
>    (and if you want to support snapshots > 4GB, be my guest, but I suspect 
>    you're actually *better* off just admitting that if you cannot shrink 
>    the snapshot to less than 32 bits, it's not worth doing)

This is basically how uswsusp is designed. (We do not use system call,
you just read from /dev/snapshot, and you have to make few ioctls to
stop the other tasks).

> and for testing, you should be able to basically do
> 
> 	u32 size;
> 	void *buffer = snapshot_system(&size);
> 	if (buffer != MAP_FAILED)
> 		resume_snapshot(buffer, size);
> 
> and it should obviously work.

Which is what I did long time ago, during uswsusp development.

> Once you have that snapshot image in user space you can do anything you 
> want. And again: you'd hav a fully working system: not any degradation 
> *at*all*. If you're in X, then X will continue running etc even after the 
> snapshotting, although obviously the snapshotting will have tried to page 
> a lot of stuff out in order to make the snapshot smaller, so you'll likely 
> be crawling.

Well... We decided not to do this in the fully working system. SIGSTOP
is just not strong enough, and we want the snapshot atomic.

Now, it would be _very_ nice to be able to snapshot system and
continue running, but I just don't see how to do it without extensive
filesystem support.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
