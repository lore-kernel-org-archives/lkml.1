Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZG2BFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZG2BFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 21:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbZG2BFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 21:05:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234AbZG2BFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 21:05:14 -0400
Date: Tue, 28 Jul 2009 18:04:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
In-Reply-To: <20090729013442.493effa6@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0907281736260.3161@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <20090727145805.690afe5d@lxorguk.ukuu.org.uk> <87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker> <20090727174252.2d987830@lxorguk.ukuu.org.uk> <20090727171213.GB4233@skywalker>
 <87skgikjr8.fsf@devron.myhome.or.jp> <20090727222010.1a5efb7b@lxorguk.ukuu.org.uk> <87r5w19xsb.fsf@devron.myhome.or.jp> <20090728112203.7b70adba@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280848090.3186@localhost.localdomain> <20090728174213.5e927428@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907280944150.3186@localhost.localdomain> <20090728180649.596c5412@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281141070.3186@localhost.localdomain> <20090728195651.3a402a31@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281158120.3186@localhost.localdomain>
 <20090729004639.71f0eabc@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281651160.3186@localhost.localdomain> <20090729013442.493effa6@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 29 Jul 2009, Alan Cox wrote:
> 
> The rules for hangup and thus hot unplug etc are
> 
> - The driver ensures that it will not call
>   tty_flip_buffer_push/flush_to_ldisc again for this port until re-opened

That's just bogus.

The work is already scheduled to be flushed by a timer. The only thing we 
do is to make it happen _immediately_ (rather than later) when we do that 
tty_flush_to_ldisc().

IOW, it's not changing what the kernel _does_. It's just moving something 
that will be done to a slightly earlier point.

If that is wrong as per hangup code, then the bug is in the hangup 
handling, not in the tty_flush_to_ldisc().

> - The driver calls tty_hangup
> - tty_hangup ensures that tty_flip_buffer_push cannot occur again
>   (by killing the workqueue)
> - resources may well then get freed before close()

They had better not be, since all the data structures touched are inside 
the 'tty_struct' (which we're dereferencing in other ways anyway in that 
whole routine).

So the only thing that the hangup code needs to do is to make that the 
"tty->buf.work.work" function pointer is a nop. And it does, as far as I
can tell.

> The same rules apply for an ldisc change via TIOCSETD
> 
> Ogawa's patch violates this by calling tty_flush_to_ldisc. If that
> bridges a hangup then it will call into the ldisc for the dead port and
> that in turn will call the write method of the driver which will in some
> cases jump to free memory.

What you describe is just crazy talk. If Ogawa's fix really causes 
problems, then the hangup code is broken, not Ogawa's trivial patch to 
make sure the work is done when trying to read a tty.

So regardless, by now we have moved from "trivial bug that bites people in 
real life" to "theoretical bug that looks impossible to trigger".

That's already a big step forward - along with making the code make more 
sense. Which is always good in itself.

> The hangup is tty_io:do_tty_hangup which calls tty_ldisc:
> tty_ldisc_hangup which calls ld->ops->hangup which n_tty doesn't
> currently have but which it could grow and which may block.

Well, put this way: the only thing that actually stops the outstanding 
timer (for the delayed work) is the tty_ldisc_halt() call in 
tty_ldisc_hangup(). If that _isn't_ called, then your argument is 
pointless, since the tty_flush_to_ldisc() will be done by a timer later 
(and Ogawa's patch thus clearly introduces nothing new).

And when it _is_ called, it also clears TTY_LDISC, so now tty_ldisc_ref() 
will return NULL, so then flush_to_ldisc() will be a no-op.

So as far as I can tell, we already protect against this whole case: if we 
call flush_to_ldisc() after the tty has been HUP'ed, it just won't _do_ 
anything (unless the work hasn't been canceled, but in that case the timer 
would have done the same thing, so nothing new is introduced).

			Linus
