Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbYGBV1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbYGBV1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbYGBV1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:27:06 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:35609 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYGBV1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:27:05 -0400
Message-ID: <486BF272.2010703@skyrush.com>
Date: Wed, 02 Jul 2008 16:26:10 -0500
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080514)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <87fxqurqpz.fsf@denkblock.local>
In-Reply-To: <87fxqurqpz.fsf@denkblock.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
> -			/*
> -			 * Echo character, and then send the signal.
> -			 * Note that we do not use isig() here because we want
> -			 * the order to be:
> -			 * 1) flush, 2) echo, 3) signal
> -			 */
> -			if (!L_NOFLSH(tty)) {
> -				n_tty_flush_buffer(tty);
> -				tty_driver_flush_buffer(tty);
> -			}
>  			if (L_ECHO(tty))
>  				echo_char(c, tty);
> -			if (tty->pgrp)
> -				kill_pgrp(tty->pgrp, signal, 1);
> +			isig(signal, tty, 0);
>  			return;

I've been doing some experimenting with the order of the three
operations (flush, echo, and signal), and the behavior is slightly
different with each.

The way I have it in the code now matches the order used by FreeBSD, so
there may actually be a good reason to flush the tty buffers *before*
issuing the signal.  Here is their snippet of code:

if (ISSET(lflag, ISIG)) {
    if (CCEQ(cc[VINTR], c) || CCEQ(cc[VQUIT], c)) {
        if (!ISSET(lflag, NOFLSH))
            ttyflush(tp, FREAD | FWRITE);
        ttyecho(c, tp);
        if (tp->t_pgrp != NULL) {
            PGRP_LOCK(tp->t_pgrp);
            pgsignal(tp->t_pgrp,
                     CCEQ(cc[VINTR], c) ? SIGINT : SIGQUIT, 1);
            PGRP_UNLOCK(tp->t_pgrp);
        }
        goto endcase;
    }
    if (CCEQ(cc[VSUSP], c)) {
        if (!ISSET(lflag, NOFLSH))
            ttyflush(tp, FREAD);
        ttyecho(c, tp);
        if (tp->t_pgrp != NULL) {
            PGRP_LOCK(tp->t_pgrp);
            pgsignal(tp->t_pgrp, SIGTSTP, 1);
            PGRP_UNLOCK(tp->t_pgrp);
        }
        goto endcase;
    }
}

The first section handles ^C and ^\ (and flushes read and write), and
the second handles ^Z (only flushes read).

In any case, we should consider if the flush in Linux should precede the
signal.  Perhaps interrupting before the flush can happen is bad?
Perhaps this has something to do with anomalies observed (below) with
other ordering, or maybe I'm seeing other latent bugs not involved with
this at all.


Now to the results of the ordering...

flush, echo, signal (the way it is now)
-------------------
* Follows FreeBSD's ordering
* works on both console and xterm
* seems to delay interrupt when process is IO bound

echo, signal, flush (proposed in Elias' patch)
-------------------
* seems to fix IO bound issue
* echo works in console but not xterm

signal, flush, echo
-------------------
* works in both console and xterm
* may cause late echo (and does not match BSD order)
* I tested inserting an artificial delay between flush and echo:
  strange result: in console, echo does not appear; in xterm,
                  ^C appears right before next prompt, but sometimes
                  echo does not appear, along with final program output
                  (something eats the output)

signal, echo, flush
-------------------
* same as above


So changing the order seems to always introduce some bugs or issues.
I'm still experimenting; feedback welcome!

						-Joe
