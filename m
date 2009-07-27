Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbZG0N6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbZG0N6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbZG0N6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:58:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32947 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751508AbZG0N6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:58:24 -0400
Date: Mon, 27 Jul 2009 14:58:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090727145805.690afe5d@lxorguk.ukuu.org.uk>
In-Reply-To: <877hxujkuv.fsf@devron.myhome.or.jp>
References: <200907240145.31935.rjw@sisk.pl>
	<2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
	<200907241721.45943.rjw@sisk.pl>
	<20090724164058.21a054e6@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907240930120.3960@localhost.localdomain>
	<87ws5xjo2x.fsf@devron.myhome.or.jp>
	<20090725150510.35e8854d@lxorguk.ukuu.org.uk>
	<87ab2sx15g.fsf@devron.myhome.or.jp>
	<20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87bpn7mzli.fsf@devron.myhome.or.jp>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
	<20090727142303.41096bf5@lxorguk.ukuu.org.uk>
	<877hxujkuv.fsf@devron.myhome.or.jp>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	/* Indicate that the other end is now closed, set the
> > +	   ENDPENDING marker so that the true end can be processed by
> 
> This seems typo s/ENDPENDING/EOFPENDING/

I renamed it but missed that.

> > @@ -47,13 +50,22 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
> 
> [...]
> 
> > +	set_bit(TTY_EOFPENDING, &pair->flags);
> > +	set_bit(TTY_OTHER_CLOSED, &pair->flags);
> > +	spin_unlock_irqrestore(&pair->buf.lock, flags);
> 
> 	tty_flip_buffer_push() or something?
> 
> > +	wake_up_interruptible(&pair->read_wait);
> > +	wake_up_interruptible(&pair->write_wait);
> 
> It seems, this sets TTY_EOFPENDING, but if flush_to_ldisc() was done
> already here, anybody doesn't set TTY_EOF for master.

Does putting a tty_flip_buffer_push() at that point fix it. I had thought
I could remove it but you are right that creates a situation where EOF
may never get set.
