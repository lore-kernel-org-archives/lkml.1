Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbZG2BYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbZG2BYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 21:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbZG2BYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 21:24:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754859AbZG2BYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 21:24:03 -0400
Date: Tue, 28 Jul 2009 18:23:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
In-Reply-To: <alpine.LFD.2.01.0907281736260.3161@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0907281814400.3161@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker> <20090727174252.2d987830@lxorguk.ukuu.org.uk> <20090727171213.GB4233@skywalker> <87skgikjr8.fsf@devron.myhome.or.jp>
 <20090727222010.1a5efb7b@lxorguk.ukuu.org.uk> <87r5w19xsb.fsf@devron.myhome.or.jp> <20090728112203.7b70adba@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280848090.3186@localhost.localdomain> <20090728174213.5e927428@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907280944150.3186@localhost.localdomain> <20090728180649.596c5412@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281141070.3186@localhost.localdomain> <20090728195651.3a402a31@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281158120.3186@localhost.localdomain>
 <20090729004639.71f0eabc@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281651160.3186@localhost.localdomain> <20090729013442.493effa6@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281736260.3161@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Jul 2009, Linus Torvalds wrote:
> 
> And when it _is_ called, it also clears TTY_LDISC, so now tty_ldisc_ref() 
> will return NULL, so then flush_to_ldisc() will be a no-op.
> 
> So as far as I can tell, we already protect against this whole case: if we 
> call flush_to_ldisc() after the tty has been HUP'ed, it just won't _do_ 
> anything (unless the work hasn't been canceled, but in that case the timer 
> would have done the same thing, so nothing new is introduced).

Btw, if you worry about the fact that this all could happen concurrently 
(ie the hangup is done on one cpu, just as the other cpu is doing that 
flush_to_ldisc() thing), then again, Ogawa's patch doesn't actually change 
anything. The synchronous flush_to_ldisc() (done by Ogawa's patch) could 
equally have been an asynchronous (done by a timer), and the timer may 
already have triggered - so 'tty_ldisc_halt()' doing a cancel on the 
delayed work is too late.

So I don't think there are any new races wrt concurrency there either, 
even though we do not take any locks in the tty_flush_to_ldisc() case. 
Because the timer wouldn't have taken any locks either..

Of course, if "tty_ldisc_halt()" (to remove any pending timer) and 
"tty_ldisc_wait_idle()" (to make sure nothing else is executing right 
then) is not sufficient, then there's a possible problem there if you hit 
the timing just right, but again, that would be true _regardless_ of 
Ogawa's changes as far as I can tell. 

IOW, the whole argument really hinges on the fact that calling 
flush_to_ldisc() manually (without any locking) is really not 
fundamentally any different from the delayed work doing it from a timer. 

And when we _do_ disable the timer, we also make that flush_to_ldisc() 
function be a no-op, so the "tty_ldisc_halt()" effectively stops both the 
timer and (conceptually) the manual call case too. 

So now we have one remaining case, namely the case of the ldisc then being 
re-initialized and TTY_LDISC is set again. But at that point, calling 
flush_to_ldisc() had better be ok again, wouldn't you agree?

		Linus
