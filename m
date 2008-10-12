Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbYJLTCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbYJLTCO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 15:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYJLTB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 15:01:59 -0400
Received: from sunrise.pg.gda.pl ([153.19.40.230]:62122 "EHLO
	sunrise.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbYJLTB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 15:01:58 -0400
Date: Sun, 12 Oct 2008 21:01:40 +0200
From: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: 7eggert@gmx.de, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH 0/2] SIGWINCH problem with terminal apps still alive
Message-ID: <20081012210140.15cecf78@merlin.oi.pg.gda.pl>
In-Reply-To: <20081012190312.0bd04ab8@lxorguk.ukuu.org.uk>
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
	<20081012195957.50feada3@merlin.oi.pg.gda.pl>
	<20081012190312.0bd04ab8@lxorguk.ukuu.org.uk>
Organization: =?UTF-8?B?R2RhxYRzaw==?= University of Technology
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sun, 12 Oct 2008 19:03:12 +0100 - Alan Cox <alan@lxorguk.ukuu.org.uk>:
> Then we end up with both using real_tty.
> 
> > Anyway I think that you miss the point. Why using
> > real_tty->termios_mutex instead of tty->termios_mutex in
> > tty_do_resize
> 
> To avoid deadlocks if you took both as you updated both structures.

Actually to avoid race and not valid winsize reading because
ioctl(TIOCGWINSZ) is done with tty == real_tty so we have to use this
mutex and not the other one.
What is more because we are using real_tty we could safely use only
real_tty->winsize and forget about master tty->winsize.
 
> > So it seems that tty->termios_mutex could point to different
> > location in different calls but real_tty->termios_mutex always
> > points to the same location.
> 
> You've finally got there - we always work off real_tty. That is why we
> can safely use the mutex on the real_tty side.

typically ioctl(,TIOCSWINSZ,) is called on master side but
ioctl(,TIOCGWINSZ,) is called on slave side so tty is not the same in
both calls inside ioctl() in tty_io.c. Only real_tty variable has the
same value for the same master/slave pair. So we must use real_tty
mutex all the time because we not always work from the same side IMHO.

That is why I propose usage of real_tty in ioctl() handling:

case TIOCGWINSZ:
                return tiocgwinsz(real_tty, p);


Regards

-- 
Adam Tlałka       mailto:atlka@pg.gda.pl    ^v^ ^v^ ^v^
System  & Network Administration Group       - - - ~~~~~~
Computer Center, Gdańsk University of Technology, Poland
