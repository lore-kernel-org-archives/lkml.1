Return-Path: <linux-kernel-owner+w=401wt.eu-S932429AbZHYXms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbZHYXms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932372AbZHYXmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:42:46 -0400
Received: from netrider.rowland.org ([192.131.102.5]:35953 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932282AbZHYXmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:42:45 -0400
Date: Tue, 25 Aug 2009 19:42:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
In-Reply-To: <20090825221918.4de9e30f@neptune.home>
Message-ID: <Pine.LNX.4.44L0.0908251921390.3665-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009, Bruno [UTF-8] Prémont wrote:

> On Mon, 24 August 2009 Alan Stern <stern@rowland.harvard.edu> wrote:
> > Apparently the tty isn't getting removed from the driver the way it
> > should when minicom closes it the first time.  And no wonder -- I just
> > realized that my new serial_shutdown() routine doesn't call
> > tty_shutdown(tty).  Try inserting such a call right before
> > tty->driver_data gets set to NULL.
> 
> Done that, it brings us to n_tty_set_termios() this time:

> [  200.248102] BUG: unable to handle kernel NULL pointer dereference at 0000000c
> [  200.248257] IP: [<c115ff36>] n_tty_set_termios+0x1a6/0x410

> My actions:
>   plug-in ftdi
>   run minicom
>   exit minicom
>   run minicom -> bang
> 
> Bang at:
> /tmp/linux-2.6.31-rc6-gregkh/drivers/char/n_tty.c:1456
> 
> 1449:	if (canon_change) {
> 1450:		memset(&tty->read_flags, 0, sizeof tty->read_flags);
> 1451:		tty->canon_head = tty->read_tail;
> 1452:		tty->canon_data = 0;
> 1453:		tty->erasing = 0;
> 1454:	}
> 1455:
> 1456:	if (canon_change && !L_ICANON(tty) && tty->read_cnt)
> 1457:		wake_up_interruptible(&tty->read_wait);
> 
> Not sure which part of the if() it is that explodes, I would guess
> it's !L_ICANON(tty):
> 
> 	#define ICANON      0000002
> 	#define _L_FLAG(tty, f) ((tty)->termios->c_lflag & (f))
> 	#define L_ICANON(tty)  _L_FLAG((tty), ICANON)
> =>
> 	if (canon_change && !((tty)->termios->c_lflag & (ICANON)) && tty->read_cnt)
> =>
> 	tty->termios is probably NULL

Unquestionably that is the problem.

It looks like something is wrong in serial_install().  We want to call 
tty_init_termios(tty) always, regardless of whether 
tty->driver->termios[idx] is NULL.  But after the call it definitely 
won't be NULL, so the test has to be made before the call is done.  
Something like this:

	struct ktermios *t = tty->driver->termios[idx];

	/* perform the standard setup */
	retval = tty_init_termios(tty);
	if (retval)
		return retval;

	/* If the specialized termios setup has yet to be done */
	if (!t) {
		...

Want to try that?

Alan Stern

