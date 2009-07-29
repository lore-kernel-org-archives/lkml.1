Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbZG2QG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbZG2QG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZG2QGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:06:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891AbZG2QGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:06:25 -0400
Date: Wed, 29 Jul 2009 09:05:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
In-Reply-To: <20090729165513.2a1ccb7c@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0907290859230.3161@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <87skgikjr8.fsf@devron.myhome.or.jp> <20090727222010.1a5efb7b@lxorguk.ukuu.org.uk> <87r5w19xsb.fsf@devron.myhome.or.jp> <20090728112203.7b70adba@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280848090.3186@localhost.localdomain>
 <20090728174213.5e927428@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280944150.3186@localhost.localdomain> <20090728180649.596c5412@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281141070.3186@localhost.localdomain> <20090728195651.3a402a31@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907281158120.3186@localhost.localdomain> <20090729004639.71f0eabc@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281651160.3186@localhost.localdomain> <20090729013442.493effa6@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281736260.3161@localhost.localdomain>
 <20090729095923.4ca5ca3e@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907290842420.3161@localhost.localdomain> <20090729165513.2a1ccb7c@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 29 Jul 2009, Alan Cox wrote:

> > The tty_ldisc_hangup() already does tty_ldisc_wait_idle() after disabling 
> > the timer (and clearing the TTY_LDISC bit), so that all seems fine 
> > already. No?
> 
> We only do tty_ldisc_wait_idle if tty->driver->flags & TTY_RESET_TERMIOS
> is set that I can see ?

I agree, but that's also the only time we do that 'tty_ldisc_halt()' that 
cancels the timer. So if there is something that depends on the 
flush_to_ldisc() not happening, the bug was pre-existing since it never 
got rid of the flush to begin with, so the flush_to_ldisc() would happen 
at some random later time as a result of the delayed-work timer.

That said, I suspect that from a sanity standpoint, I suspect something 
like the appended migth be a good idea. But I think it's an independent 
issue (and unless somebody can actually point to an actual problem, I'd 
only apply something like this during the merge window, not after -rc4).

		Linus
---
 drivers/char/tty_ldisc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index acd76b7..640b100 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -778,6 +778,8 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 		if (ld->ops->hangup)
 			ld->ops->hangup(tty);
 		tty_ldisc_deref(ld);
+		tty_ldisc_halt(tty);
+		tty_ldisc_wait_idle(tty);
 	}
 	/*
 	 * FIXME: Once we trust the LDISC code better we can wait here for
@@ -794,8 +796,6 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 		mutex_lock(&tty->ldisc_mutex);
 		if (tty->ldisc) {	/* Not yet closed */
 			/* Switch back to N_TTY */
-			tty_ldisc_halt(tty);
-			tty_ldisc_wait_idle(tty);
 			tty_ldisc_reinit(tty);
 			/* At this point we have a closed ldisc and we want to
 			   reopen it. We could defer this to the next open but
