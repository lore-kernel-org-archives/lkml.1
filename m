Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbYGAONv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbYGAONv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbYGAONl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:13:41 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:35478 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbYGAONk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:13:40 -0400
Message-ID: <486A3B4A.2090005@skyrush.com>
Date: Tue, 01 Jul 2008 08:12:26 -0600
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
> The following patch to 2.6.26-rc8 fixes the issue for me. Perhaps we
> really want to do something else, but since I'm not all that familiar
> with the standard behaviour on other Unices and since the comment
> describing the changed order of function calls in the original commit
> didn't give the reason for that change, I leave that to more
> knowledgeable people.
> 
>  drivers/char/n_tty.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
> index 8096389..74018ef 100644
> --- a/drivers/char/n_tty.c
> +++ b/drivers/char/n_tty.c
> @@ -759,20 +759,9 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
>  		signal = SIGTSTP;
>  		if (c == SUSP_CHAR(tty)) {
>  send_signal:
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
>  		}
>  	}

I noticed the original post in this thread mentioned that the problem
has been seen since 2.6.21 or 2.6.23:

> I use 2.6.25-2 and 2.6.26-rc8 now; I don't recall seeing this
> behaviour with old kernels (IIRC I see this since 2.6.21 or 2.6.23).
>
> Is this intended behaviour, or should I report a bug?

The echo patch that is altered in the patch above only appeared recently
(in 2.6.25).  Is there a way for you try try the test case on a
pre-2.6.25 kernel and see if the issue exists there?  If so, it is
strange that the above fixes it.

						-Joe
