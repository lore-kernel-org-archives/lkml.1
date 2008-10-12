Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbYJLSES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbYJLSES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 14:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYJLSEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 14:04:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51135 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754701AbYJLSEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 14:04:04 -0400
Date: Sun, 12 Oct 2008 19:03:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
Cc: 7eggert@gmx.de, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH 0/2] SIGWINCH problem with terminal apps still alive
Message-ID: <20081012190312.0bd04ab8@lxorguk.ukuu.org.uk>
In-Reply-To: <20081012195957.50feada3@merlin.oi.pg.gda.pl>
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

> I've read the code. The race problem with xterm or other pty using

Clearly not.

> program in 2.6.26 appeared because one app called ioctl(TIOCSWINSZ) on
> the master side while other read winsize (TIOCGWINSZ) using client side
> (slave). So in one ioctl() call tty == master and in other tty ==
> real_tty. Of course we can have the opposite situaction so terminal app

Then we end up with both using real_tty.

> Anyway I think that you miss the point. Why using
> real_tty->termios_mutex instead of tty->termios_mutex in tty_do_resize

To avoid deadlocks if you took both as you updated both structures.

> So it seems that tty->termios_mutex could point to different
> location in different calls but real_tty->termios_mutex always points
> to the same location.

You've finally got there - we always work off real_tty. That is why we
can safely use the mutex on the real_tty side.

Alan
