Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbYJLSA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbYJLSA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 14:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbYJLSAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 14:00:20 -0400
Received: from sunrise.pg.gda.pl ([153.19.40.230]:55321 "EHLO
	sunrise.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbYJLSAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 14:00:19 -0400
Date: Sun, 12 Oct 2008 19:59:57 +0200
From: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: 7eggert@gmx.de, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH 0/2] SIGWINCH problem with terminal apps still alive
Message-ID: <20081012195957.50feada3@merlin.oi.pg.gda.pl>
In-Reply-To: <20081012152200.4a8f14c4@lxorguk.ukuu.org.uk>
References: <bjXel-4CU-17@gated-at.bofh.it>
	<bjYap-5Q0-25@gated-at.bofh.it>
	<bk30i-3Gx-1@gated-at.bofh.it>
	<bk6AV-8ms-7@gated-at.bofh.it>
	<bkrvO-1HF-49@gated-at.bofh.it>
	<blePJ-6rI-3@gated-at.bofh.it>
	<blmDC-7ZU-7@gated-at.bofh.it>
	<E1Kof4h-0005Q3-Ns@be1.7eggert.dyndns.org>
	<20081011185821.0dab4c81@lxorguk.ukuu.org.uk>
	<20081012143231.6ef9e590@merlin.oi.pg.gda.pl>
	<20081012152200.4a8f14c4@lxorguk.ukuu.org.uk>
Organization: =?UTF-8?B?R2RhxYRzaw==?= University of Technology
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sun, 12 Oct 2008 15:22:00 +0100 - Alan Cox <alan@lxorguk.ukuu.org.uk>:

> O> real_tty structures. TIOCSWINSZ and TIOCGWINSZ ioctls could be
> > called on tty and real_tty at the same time. To avoid race condition
> 
> No they can't. Would you please bother to spend five minutes actually
> reading the source code and following through your assumptions to see
> if they make sense before posting.
> 
> tiocgwinsz is never called for the pty side of a pty pair.

I've read the code. The race problem with xterm or other pty using
program in 2.6.26 appeared because one app called ioctl(TIOCSWINSZ) on
the master side while other read winsize (TIOCGWINSZ) using client side
(slave). So in one ioctl() call tty == master and in other tty ==
real_tty. Of course we can have the opposite situaction so terminal app
is using ioctl(TIOCSWINSZ) on its side (slave) and xterm is using ioctl
on its side to know to which size resize itself. Not working now as I
tested but possible.

Anyway I think that you miss the point. Why using
real_tty->termios_mutex instead of tty->termios_mutex in tty_do_resize
called from tiocswins() so from ioctl(TIOCSWINSZ) closes the race. If as
you said tiocgwinsz is called on tty and not real_tty then
tty->termios_mutex should be valid here.
Mutexes work and it is not a scheduler problem as I wrongly assumed.
The scheduler just exposed this problem doing an app switch.
It's just wrong mutex used.

Look at the  tty_ioctl(struct file *file, unsigned int cmd, unsigned
long arg) in tty_io.c.

	tty = (struct tty_struct *)file->private_data;

so if you calling ioctl on master side we have tty = master
and on client side tty = real_tty in ioctl entry;
next

	real_tty = tty;
	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
            tty->driver->subtype == PTY_TYPE_MASTER)
                real_tty = tty->link;

if tty is the master one we set real_tty but in case of client side
tty == real_tty already so real_tty points to the same structure.

So it seems that tty->termios_mutex could point to different
location in different calls but real_tty->termios_mutex always points
to the same location.
 
Regards

-- 
Adam Tlałka       mailto:atlka@pg.gda.pl    ^v^ ^v^ ^v^
System  & Network Administration Group       - - - ~~~~~~
Computer Center, Gdańsk University of Technology, Poland
