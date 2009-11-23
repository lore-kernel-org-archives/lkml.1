Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbZKWL3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbZKWL3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757007AbZKWL3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:29:23 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40763 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756935AbZKWL3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:29:22 -0500
Date: Mon, 23 Nov 2009 11:31:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Robert Swan <swan.r.l@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [bisected] pty performance problem
Message-ID: <20091123113110.15063a0a@lxorguk.ukuu.org.uk>
In-Reply-To: <1258952431.6261.38.camel@marge.simson.net>
References: <20091121222319.GA3905@swanrl.gmail.com>
	<20091122063926.GA18224@elte.hu>
	<20091122122312.71a343d9@lxorguk.ukuu.org.uk>
	<1258952431.6261.38.camel@marge.simson.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
> index 66fa4e1..92a0864 100644
> --- a/drivers/char/tty_buffer.c
> +++ b/drivers/char/tty_buffer.c
> @@ -495,7 +495,7 @@ void tty_flip_buffer_push(struct tty_struct *tty)
>  	if (tty->low_latency)
>  		flush_to_ldisc(&tty->buf.work.work);
>  	else
> -		schedule_delayed_work(&tty->buf.work, 1);
> +		schedule_delayed_work(&tty->buf.work, 0);
>  }
>  EXPORT_SYMBOL(tty_flip_buffer_push);

Another possibility is to do

	if (tty->low_latency)
		schedule_delayed_work(&tty->buf.work, 0);
	else
		schedule_delayed_work(&tty->buf.work, 1);

At the moment the ->low_latency flag is just used by a few drivers that
want to avoid a double delay (eg if the process events off a work queue
not in the IRQ handler), and they have to jump through other hoops around
re-entrancy. Doing it that way might make the processing a miniscule more
slow for those cases but would also let the low_latency flag do something
useful for the many drivers that don't work byte at a time and want stuff
to be blocked up.

The general case is things like UART chips where you get one char and one
push per byte receiving so usually don't want one run through the ldisc
each time when a lot of data is arriving.

If low_latency means schedule ASAP not call inline then pty can use
low_latency and we can avoid suddenly changing the behaviour of every
device but instead do them as they make sense (eg all USB should probably
be low_latency with that queueing change)

Alan
