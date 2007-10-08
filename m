Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbXJHL6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbXJHL6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 07:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXJHL6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 07:58:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54599 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753593AbXJHL6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 07:58:07 -0400
Date: Mon, 8 Oct 2007 13:02:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Paul Hardwick <p.hardwick@option.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nozomi: ERESTARTSYS to userspace?
Message-ID: <20071008130220.78b265f2@the-village.bc.nu>
In-Reply-To: <470A05DF.5080405@gmail.com>
References: <470A05DF.5080405@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>         if (unlikely(down_trylock(&port->tty_sem))) {
>                 /*
>                  * must test lock as tty layer wraps calls
>                  * to this function with BKL
>                  */
>                 dev_err(&dc->pdev->dev, "Would have deadlocked - "
>                         "return ERESTARTSYS\n");
>                 return -ERESTARTSYS;
>         }
> 
> The use of ERESTARTSYS seems bogus to me, no signal is pending and this flag
> would reach userspace (that is not permitted), am I right?

serial driver write methods are called from the ldisc not the tty so the
code is in fact totally bogus.

I suspect what is needed (other than to take the entire driver to bits
and put it back together using serial_core) is 

	if (down_trylock(&port->tty_sem))
		return 0;

and the driver is then required to wake the write wait queue when that
condition becomes false - or at least before/when it runs out of
data (which currently it doesn't seem to for all cases).

Lots of other breakage in it as well (termios function is totally bogus,
tty_flip_queue_function is a no-op) etc etc

Alan
