Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbZG1XqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbZG1XqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbZG1XqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:46:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53034 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752703AbZG1XqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:46:22 -0400
Date: Wed, 29 Jul 2009 00:46:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090729004639.71f0eabc@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0907281158120.3186@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
	<20090727142303.41096bf5@lxorguk.ukuu.org.uk>
	<877hxujkuv.fsf@devron.myhome.or.jp>
	<20090727145805.690afe5d@lxorguk.ukuu.org.uk>
	<87fxci6ub9.fsf@devron.myhome.or.jp>
	<20090727161424.GA4233@skywalker>
	<20090727174252.2d987830@lxorguk.ukuu.org.uk>
	<20090727171213.GB4233@skywalker>
	<87skgikjr8.fsf@devron.myhome.or.jp>
	<20090727222010.1a5efb7b@lxorguk.ukuu.org.uk>
	<87r5w19xsb.fsf@devron.myhome.or.jp>
	<20090728112203.7b70adba@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907280848090.3186@localhost.localdomain>
	<20090728174213.5e927428@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907280944150.3186@localhost.localdomain>
	<20090728180649.596c5412@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907281141070.3186@localhost.localdomain>
	<20090728195651.3a402a31@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907281158120.3186@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Let me quote one of your first emails as I got cc'd on this thread:

Which is not about the emacs bug but old versions of kdesu relying upon
data boundaries happening to occur in the "right" places.

> And no, that was not a fluke. TODAY, you sent out an email saying that 
> EWOUDLBLOCK/EAGAIN would be "correct". Despite me having told you that it 
> _clearly_ is not correct, and despite you knowing that it breaks user 
> space.

I did not as you seem to think ever advocate not fixing the emacs problem.
Clearly we need to fix the behaviour because apps rely on it and its not
an outright "duh.." on the app side its a reasonable expectation in the
simple case.

Instead I got a whole collection of mail from you most of which indicated
you hadn't even understood the problem.

BTW: The tty->low_latency fix doesn't work, because the ->write method
can be called from an IRQ and that means we can't use ->low_latency=1 as
we take mutexes.

If you don't take the mutexes you revert the fixes that stop high speed
data sessions such as 3G Modem randomly hanging until you disconnect from
your provider and try again.

So the current state of play is
	as is breaks emacs
	revert pty changes breaks ppp, 
	tty->low_latency breaks ppp
	Ogawa's patch can lock up and races including exploitable jumps
		into freed memory
	blocking in close deadlocks if both ends get stuck that way

The best suggestion I can come up with for the new maintainer is to
implement a block in close() on the slave side only, and probably with an
interruptible wait. Set TTY_EOFPENDING when you enter close, sleep on
TTY_EOF being set when the workqueue flushing data into the ldisc
finishes shovelling. Providing exit() closes the file handles before
sending the signal that'll then give expected semantics. A pty master
close is "magic" anyway as it triggers a hangup event.

> The fact is, breaking regular user applications is simply not acceptable. 
> Trying to blame kernel breakage on the app being "buggy" is not ok. And 
> arguing for almost a week against fixing it - that's just crazy.

The security exploits on 2.6.27 don't work on 2.6.30, please fix
the regression so I get root again. Get real, that is what you just
claimed and its donkey poo. There is a point at which you fix stuff and a
point at which you don't.

The thing I advocated not fixing is that in some cases kdesu fails
because some old versions at least do

	read(fd, buf, lots);
	if (buf starts with something I want) {
		while(read more data)
			look for pattern
	}

but never looks for pattern in the first read data after the start it
wanted - ie it relied upon magic happy chance buffer boundary
preservation. Thats well beyond what is sane to try and preserve unless
it is easy to do which its not.

The emacs assumption is wrong, actually always untrue for some cases
(fork, child inherits pty, parent exits for one) but worth preserving for
the cases it happens to work. I've never argued otherwise.

Alan
