Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbZG2AeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbZG2AeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbZG2AeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 20:34:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55622 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753830AbZG2AeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 20:34:11 -0400
Date: Wed, 29 Jul 2009 01:34:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090729013442.493effa6@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0907281651160.3186@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
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
	<20090729004639.71f0eabc@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907281651160.3186@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok. So the end result is that Ogawa-san's fix is the right one. Then we 
> can revert the low_latency=1 thing for pty's entirely. No?

No

> So does this work for everyone? I haven't tested it yet myself, but this 
> is the patch that "looks" right.

Looks pretty but breaks hangup events and hotplug.

The rules for hangup and thus hot unplug etc are

- The driver ensures that it will not call
  tty_flip_buffer_push/flush_to_ldisc again for this port until re-opened
- The driver calls tty_hangup
- tty_hangup ensures that tty_flip_buffer_push cannot occur again
  (by killing the workqueue)
- resources may well then get freed before close()

The same rules apply for an ldisc change via TIOCSETD

Ogawa's patch violates this by calling tty_flush_to_ldisc. If that
bridges a hangup then it will call into the ldisc for the dead port and
that in turn will call the write method of the driver which will in some
cases jump to free memory.

To make that work (and I agree its a very sane looking expression of the
intent) you would need to ensure that your new tty_flush_to_ldisc routine
was interlocked against already being hung up, tty_hangup and against an
ldisc change. I think (haven't verified) you get ldisc_change for free as
you are in the ldisc code so the ldisc ref is held and a set_ldisc will
block.

The hangup is tty_io:do_tty_hangup which calls tty_ldisc:
tty_ldisc_hangup which calls ld->ops->hangup which n_tty doesn't
currently have but which it could grow and which may block.

So my guess is you need to make your new flush to ldisc routine

	interlock versus do_tty_hangup
	check if the TTY_HUPPED flag is clear
	only if so and do_tty_hangup cannot be running actually run the
		ldisc code


the hangup code is still evil lock_kernel (and in parts "prayer_lock()"
code)

