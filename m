Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYCKE1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYCKE1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYCKE04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:26:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847AbYCKE04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:26:56 -0400
Date: Mon, 10 Mar 2008 21:26:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_ioctl: Soft carrier handling
Message-Id: <20080310212647.19a31a23.akpm@linux-foundation.org>
In-Reply-To: <20080310215613.43c7acb0@core>
References: <20080310215613.43c7acb0@core>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 21:56:13 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> First cut at moving the soft carrier handling knowledge entirely into the
> core code. One or two drivers still needed to snoop these functions to
> track CLOCAL internally. Instead make TIOCSSOFTCAR generate the same
> driver calls as other termios ioctls changing the clocal flag. This
> allows us to remove any driver knowledge and special casing. Also while
> we are at it we can fix the error handling.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc3-mm1/drivers/char/tty_ioctl.c linux-2.6.25-rc3-mm1/drivers/char/tty_ioctl.c
> --- linux.vanilla-2.6.25-rc3-mm1/drivers/char/tty_ioctl.c	2008-03-10 12:57:53.000000000 +0000
> +++ linux-2.6.25-rc3-mm1/drivers/char/tty_ioctl.c	2008-03-10 13:27:09.000000000 +0000
> @@ -753,6 +756,32 @@
>  }
>  
>  /**
> + *	tty_change_softcar	-	carrier change ioctl helper
> + *	@tty: tty to update
> + *	@arg: enable/disable CLOCAL
> + *
> + *	Perform a change to the CLOCAL state and call into the driver
> + *	layer to make it visible. All done with the termios mutex
> + */
> + 
> +static int tty_change_softcar(struct tty_struct *tty, int arg)
> +{
> +	int ret = 0;
> +	int bit = arg ? CLOCAL : 0;
> +	struct ktermios old = *tty->termios;
> +	
> +	mutex_lock(&tty->termios_mutex);

change_termios() modifies tty->termios under tty->termios_mutex, which is
very sensible.

Hence (surely?) all code which takes a copy of tty->termios should do so
under tty->termios_mutex so that it doesn't get a copy of an internally 
inconsistent, half-overwritten structure.

But this code doesn't do that, nor does change_termios(), set_termios() and
perhaps other places.

Confused.

> +	tty->termios->c_cflag &= ~CLOCAL;
> +	tty->termios->c_cflag |= bit;
> +	if (tty->driver->set_termios)
> +		tty->driver->set_termios(tty, &old);
> +	if ((tty->termios->c_cflag & CLOCAL) != bit)
> +		ret = -EINVAL;	
> +	mutex_unlock(&tty->termios_mutex);
> +	return ret;
> +}

