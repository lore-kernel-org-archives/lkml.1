Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbZKWK0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbZKWK0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbZKWK0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:26:55 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54323 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753791AbZKWK0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:26:54 -0500
Date: Mon, 23 Nov 2009 10:28:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Robert Swan <swan.r.l@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [bisected] pty performance problem
Message-ID: <20091123102844.25757450@lxorguk.ukuu.org.uk>
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

> Hm.  Looks to me like it's doing what it was told to do.

Yes. I realised this morning too.
> 
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
>  
> Telling it to execute now made test proggy happy.. and likely broke tons
> of things that need a delay there.  So, what's wrong with delaying, when
> that's what the customer asked for?  /me must be missing something.  It
> could know that no delay is needed?

The old model the tty code used was to queue bytes and process them each
timer tick. The idea is that this avoids thrashing the locks and stuff
gets processed more efficiently.

It's probably completely the wrong model today and removing the delay
will now only hit fine grained locks, and will get better flow control
behaviour at high speeds.

Try it and see - worst case it becomes some kind of per tty property.

Alan
