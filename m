Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab0AOKp1 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 05:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950Ab0AOKp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 05:45:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52810 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751338Ab0AOKp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 05:45:26 -0500
Date: Fri, 15 Jan 2010 10:48:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ldisc switching on a HUPped pty hangs the caller
Message-ID: <20100115104834.4765b584@lxorguk.ukuu.org.uk>
In-Reply-To: <1263532072.22171.24.camel@kiste>
References: <1263532072.22171.24.camel@kiste>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I recently upgraded my gateway machine to 2.6.31. This caused
> ppp-over-ssh to stop working. Indeed, the PPP process got wedged into
> noninterruptible sleep, which this patch fixes.
> 
> (The comment, by the way, seems to be wrong. There was no race.) 

Really ?

Think about

					set_ldisc
	hangup
	close
	open
	set to N_TTY etc
					Now what ???

 
> The underlying problem, however, turns out to be the vhangup() syscall
> which the SSH server emits before exec'ing pppd. This causes the tty's
> HUPPED bit to get set, which in turn causes the above error.

vhangup sets the huppet bit to make sure that anything touching the tty
beyond that point goes away and dies.

> diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
> index aafdbae..bb92f5e 100644
> --- a/drivers/char/tty_ldisc.c
> +++ b/drivers/char/tty_ldisc.c
> @@ -621,9 +621,8 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
>  		/* We were raced by the hangup method. It will have stomped
>  		   the ldisc data and closed the ldisc down */
>  		clear_bit(TTY_LDISC_CHANGING, &tty->flags);
> -		mutex_unlock(&tty->ldisc_mutex);
> -		tty_ldisc_put(new_ldisc);
> -		return -EIO;
> +		retval = -EIO;
> +		goto out;
>  	}
>  
>  	/* Shutdown the current discipline. */
> @@ -652,7 +651,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
>  	/*
>  	 *	Allow ldisc referencing to occur again
>  	 */
> -
> +out:
>  	tty_ldisc_enable(tty);
>  	if (o_tty)
>  		tty_ldisc_enable(o_tty);

And falls through to restart work queues and stuff that may not be safe
to do


So: NAK

I agree there is a bug but you've swapped one bug for sevral nastier bugs.

As far as  I can see from a quick look the real problem in your case is
that we don't do enough work in the case where tty->driver->flags doesn't
contain TTY_DRIVER_RESET_TERMIOS. We need to reinit the ldisc either way.

