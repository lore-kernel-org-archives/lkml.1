Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbZHCSTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbZHCSTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbZHCSTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:19:14 -0400
Received: from kroah.org ([198.145.64.141]:53922 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbZHCSTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:19:14 -0400
Date: Mon, 3 Aug 2009 11:18:11 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] proper tty-ldisc refcounting (was Re: WARNING at:
 drivers/char/tty_ldisc.c)
Message-ID: <20090803181811.GA15848@kroah.com>
References: <20090802120120.GA3097@localdomain.by>
 <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain>
 <20090802190514.GA3278@localdomain.by>
 <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain>
 <87k51l9apo.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain>
 <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
 <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 10:55:34AM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 2 Aug 2009, Linus Torvalds wrote:
> > 
> > > You could just finish the ldisc refcounting. The last set of patches you
> > > had off me split tty->ldisc from struct tty ready to do exactly that and
> > > I don't think there is anything left that stops it happening now (It was
> > > just not ready in time)
> > 
> > I considered it, and it didn't look horrible (the thing really is pretty 
> > self-contained in tty_ldisc_try() and tty_ldisc_deref()).
> 
> Here we are.
> 
> It wasn't a straight conversion, because the old code really didn't think 
> of the refcounts as lifetimes, but it wasn't too bad either. And doing the 
> proper refcounting makes all the stupid "wait for idle" go away, so it 
> actually removes code:
> 
>  drivers/char/tty_ldisc.c  |  145 ++++++++++++++------------------------------
>  include/linux/tty_ldisc.h |    2 +-
>  2 files changed, 47 insertions(+), 100 deletions(-)
> 
> and generally simplifies the logic.
> 
> That said, looking through the code as I did this, I consciously avoided 
> doing some other cleanups that really should be done some day. The code is 
> chock-full of crazy stuff, where we just do
> 
> 	o_ldisc = tty->ldisc;
> 
> with dubious locking. None of that is _new_ though, and most of it is in 
> the "replace one ldisc with another" code. And for all I know, maybe it's 
> all fine, it's just very much not _obviously_ correct.
> 
> As far as I can tell, this short series should not introduce any new 
> problems, but hey, maybe it leaks ldisc references like mad because I made 
> some silly mistake. It's a _fairly_ straightforward cleanup, but it's a 
> big cnnceptual change to go from a model with a "wait until idle and then 
> free" to a model of "count users and free on last use", and I could easily 
> have screwed up something.
> 
> "It works for me"(tm), including a shutdown/reboot cycle. 
> 
> Sergey, mind testing? You seem to be very good at consistently triggering 
> odd things in the tty layer that few other people seem to ever hit.
> 
> Greg - I've signed off on these, but I wasn't planning on committing them 
> to my master branch. So perhaps you could do these as the new tty 
> maintainer, assuming we get an ack from Alan and testing by Sergey.

Ok, I'll queue them up if they pass Sergey's testing.

thanks,

greg k-h
