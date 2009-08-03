Return-Path: <linux-kernel-owner+w=401wt.eu-S1751838AbZHCAku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbZHCAku (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 20:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZHCAku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 20:40:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934AbZHCAkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 20:40:49 -0400
Date: Sun, 2 Aug 2009 17:40:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: WARNING at: drivers/char/tty_ldisc.c
In-Reply-To: <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
References: <20090802120120.GA3097@localdomain.by> <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain> <20090802190514.GA3278@localdomain.by> <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain> <87k51l9apo.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain> <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 2 Aug 2009, Alan Cox wrote:
> > 
> > So exactly what _does_ happen if we get rid of that hack?
> 
> Serial console breaks if I remember rightly because the hangup takes out
> the port and printk can't then use the resources that were attached to
> it.

Hmm. That sounds like a likely explanation for the hack, but we do 
re-initialize the tty sufficiently that I don't see why the serial console 
would be unable to use it - it's not like we go through the "filp" anyway.

So it must be something about /dev/console itself, not so much the serial 
lines and serial consoles.

I wonder if the hack is strictly necessary, or could perhaps at least be 
moved down a bit. The comment around that area seems to imply there were 
other issues ("will cause tty->count and state->count to go out of sync"), 
and that whole tty->count thing is some seriously old code, and the tty 
layer has changed a lot since 1992.

So I do get the feeling that it may be just old code that simply nobody 
has dared remove - it may have made more sense back when then it does 
now, and has just been carried around.

If it actually were to cause problems with the tty->count thing, I think 
Sergey should have seen it thanks to us still doing that old 
CHECK_TTY_COUNT thing.

> redirected_tty_write should I think count for the redirection to
> hung_up_tty_fops, but I'm not sure you want to do the hangup instead of
> close.

I'll try with a serial console on one of my machines to see if I can see 
anything wrong. It _would_ be nice to get rid of that thing, since it 
clearly causes problems.

> You could just finish the ldisc refcounting. The last set of patches you
> had off me split tty->ldisc from struct tty ready to do exactly that and
> I don't think there is anything left that stops it happening now (It was
> just not ready in time)

I considered it, and it didn't look horrible (the thing really is pretty 
self-contained in tty_ldisc_try() and tty_ldisc_deref()). But the counts 
are off-by-one (ie zero means "one user - the tty itself"), and it really 
isn't the kind of thing I'd like to do surgery on after -rc5 (or even 
after -rc1, for that matter).

But yeah, it _should_ be possible to just get rid of tty_ldisc_wait_idle() 
entirely if we were to just make tty_ldisc_deref() free the ldisc, and 
started the ldisc->refcount from 1. Then "tty_ldisc_put()" should be just 
a regular tty_ldisc_deref() (it would _normally_ be the one that makes it 
go to zero and frees the 'struct ldisc', unless there are outstanding 
references).

So it doesn't look bad. It's just that if it turns out that console 
hackery isn't necessary, I'd much rather get rid of that.

And right now it looks like the console hackery not only isn't necessary, 
but is actively the thing that breaks - the "odd" thing about the 
single-user shutdown is exactly the fact that it opens /dev/console 
instead of a regular tty.

			Linus
