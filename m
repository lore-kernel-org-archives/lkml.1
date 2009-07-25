Return-Path: <linux-kernel-owner+w=401wt.eu-S1751842AbZGYPcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbZGYPcb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 11:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbZGYPca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 11:32:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34325 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751666AbZGYPca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 11:32:30 -0400
Date: Sat, 25 Jul 2009 16:32:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] kdesu broken
Message-ID: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
In-Reply-To: <87ab2sx15g.fsf@devron.myhome.or.jp>
References: <200907240145.31935.rjw@sisk.pl>
	<2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
	<200907241721.45943.rjw@sisk.pl>
	<20090724164058.21a054e6@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907240930120.3960@localhost.localdomain>
	<87ws5xjo2x.fsf@devron.myhome.or.jp>
	<20090725150510.35e8854d@lxorguk.ukuu.org.uk>
	<87ab2sx15g.fsf@devron.myhome.or.jp>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jul 2009 23:55:39 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> > Actually try this:
> 
> Thanks. This patch improved situation. However, if slave writes big data
> to buffer, it seems we still have the problem.
> 
> > +	tty_flip_buffer_push(tty->link);
> 
> This is handling the pending buffer, but in flush_to_ldisc(), if
> !tty->receive_room, it seems still delay the ->receive_buf().

Agreed - we could

	wait_event_interruptible(tty->write_wait,
			tty->link->receive_room);

or similar.

Good to know the initial fix works. To actually do it cleanly probably
wants a way to pass a logical channel close through the tty layer which
isn't I think too hard

	set a new TTY_OTHER_CLOSING in the pty code
	set TTY_OTHER_CLOSED in the flip_buffer_push code if we empty the
	buffer queue and TTY_OTHER_CLOSING is set.

That would also avoid using tty->low_latency=1 in the pty layer which I
worry may harm PPP gateway performance and the like.
