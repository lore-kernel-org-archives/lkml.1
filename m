Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbYJQLk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbYJQLk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 07:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYJQLkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 07:40:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43748 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752998AbYJQLkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 07:40:14 -0400
Date: Fri, 17 Oct 2008 12:40:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tilman Schmidt <tilman@imap.cc>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Hansjoerg Lipp <hjlipp@web.de>
Subject: Re: [PATCH 72/80] tty: fix up gigaset a bit
Message-ID: <20081017124004.64d3f2cf@lxorguk.ukuu.org.uk>
In-Reply-To: <48F762CA.4080608@imap.cc>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
	<20081013094438.21645.30934.stgit@localhost.localdomain>
	<48F762CA.4080608@imap.cc>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  	/* prevent other callers from entering ldisc methods */
> > +	/* FIXME: should use the tty state flags */
> >  	tty->disc_data = NULL;
> >  
> >  	if (!cs->hw.ser)
> 
> Do you know of an example line discipline that has got this right?
> My model for this code was drivers/net/ppp_async.c but now it seems
> that this was not as exemplary as I had hoped.

If you want to know if the tty has been closed for further I/O then you
can use test_bit(TTY_IO_ERROR, &tty->flags). This gets set at the right
points on close/hangup/etc.

> > @@ -680,6 +675,8 @@ gigaset_tty_ioctl(struct tty_struct *tty, struct file *file,
> >  /*
> >   * Poll on the tty.
> >   * Unused, always return zero.
> > + *
> > + * FIXME: should probably return an exception - especially on hangup
> >   */
> >  static unsigned int
> >  gigaset_tty_poll(struct tty_struct *tty, struct file *file, poll_table *wait)
> 
> Looking around, I see that many LDs don't even provide a poll method.
> So I'm thinking of just dropping this one. Would that be ok?

PPP doesn't route characters via the tty interface while you seem to do
so for the AT emulation so you do need it. In the hangup case you want to
return an exception event too: probably you want

	POLLIN|POLLOUT|POLLERR|POLLHUP|POLLRDNORM|POLLWRNORM

for that case.

Alan
