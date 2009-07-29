Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZG2Ptw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZG2Ptw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 11:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbZG2Ptv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 11:49:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535AbZG2Ptu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 11:49:50 -0400
Date: Wed, 29 Jul 2009 08:48:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
In-Reply-To: <20090729095923.4ca5ca3e@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0907290842420.3161@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <20090727161424.GA4233@skywalker> <20090727174252.2d987830@lxorguk.ukuu.org.uk> <20090727171213.GB4233@skywalker> <87skgikjr8.fsf@devron.myhome.or.jp> <20090727222010.1a5efb7b@lxorguk.ukuu.org.uk>
 <87r5w19xsb.fsf@devron.myhome.or.jp> <20090728112203.7b70adba@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280848090.3186@localhost.localdomain> <20090728174213.5e927428@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280944150.3186@localhost.localdomain>
 <20090728180649.596c5412@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281141070.3186@localhost.localdomain> <20090728195651.3a402a31@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281158120.3186@localhost.localdomain> <20090729004639.71f0eabc@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907281651160.3186@localhost.localdomain> <20090729013442.493effa6@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281736260.3161@localhost.localdomain> <20090729095923.4ca5ca3e@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 29 Jul 2009, Alan Cox wrote:
> > 
> > > - The driver calls tty_hangup
> > > - tty_hangup ensures that tty_flip_buffer_push cannot occur again
> > >   (by killing the workqueue)
> > > - resources may well then get freed before close()
> > 
> > They had better not be, since all the data structures touched are inside 
> > the 'tty_struct' (which we're dereferencing in other ways anyway in that 
> > whole routine).
> 
> You are only looking at pty. That code is used for all the real physical
> tty devices too. With real devices the underlying physical device and its
> structures can get dumped. When you run the n_tty ldisc you call back out
> to the drivers for echo etc.

I actually only meant the "flush_to_ldisc()" part. We'll never get any 
further than that due to the reasons I outlined.

> > So the only thing that the hangup code needs to do is to make that the 
> > "tty->buf.work.work" function pointer is a nop. And it does, as far as I
> > can tell.
> 
> What happens if the hangup occurs just after you start running the ldisc
> on another CPU ?

But Alan, that was my point: Ogawa's patch in no way changes any existing 
behavior. The case you mention ALREADY HAPPENS, regardless of Ogawa's 
patch.

If a timer goes off at the same time hangup happens, you have the exact 
same situation. You can have one CPU doing hangup processing, and one CPU 
having just triggered the timeout and doing flush_to_ldisc.

> Consider a real tty for a bit
> 
> 	CPU0					CPU1
> n_tty methods
> 	flush_to_ldisc
> 	get ldisc ref
> 						INTERRUPT
> 						tty_hangup
> 						do_tty_hangup

Yes. Consider exactly that. And notice how it happens with or without 
Ogawa's patch. Just instead of "n_tty methods", you have "delayed-work 
timer".

> So as I said before you need to fix flush_to_ldisc and the hangup running
> against one another. At the very least I think you need a
> tty_ldisc_wait_idle(tty); just before
> 
>         if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {
> 
> so that you stall the hangup until n_tty exits the ldisc.

The tty_ldisc_hangup() already does tty_ldisc_wait_idle() after disabling 
the timer (and clearing the TTY_LDISC bit), so that all seems fine 
already. No?

				Linus
