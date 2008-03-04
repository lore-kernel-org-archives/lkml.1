Return-Path: <linux-kernel-owner+w=401wt.eu-S1763298AbYCDHNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763298AbYCDHNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 02:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbYCDHNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 02:13:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756428AbYCDHNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 02:13:46 -0500
Date: Mon, 3 Mar 2008 23:13:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uart_get_baud_rate: stop mangling termios
Message-Id: <20080303231332.a960132c.akpm@linux-foundation.org>
In-Reply-To: <20080220204406.1d5f74bc@core>
References: <20080220204406.1d5f74bc@core>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 20:44:06 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Russell King noticed this one: We have to avoid replacing B0 when we pick
> a baud rate for a "hung up" port. Ugly but the proper fix is in the tty
> layer and means changing the tty<->serial interfaces so we will defer
> that for now.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/serial/serial_core.c linux-2.6.25-rc2-mm1/drivers/serial/serial_core.c
> --- linux.vanilla-2.6.25-rc2-mm1/drivers/serial/serial_core.c	2008-02-19 11:03:01.000000000 +0000
> +++ linux-2.6.25-rc2-mm1/drivers/serial/serial_core.c	2008-02-20 16:22:49.000000000 +0000
> @@ -329,13 +329,15 @@
>   *	If it's still invalid, we try 9600 baud.
>   *
>   *	Update the @termios structure to reflect the baud rate
> - *	we're actually going to be using.
> + *	we're actually going to be using. Don't do this for the case
> + *	where B0 is requested ("hang up").
>   */
>  unsigned int
>  uart_get_baud_rate(struct uart_port *port, struct ktermios *termios,
>  		   struct ktermios *old, unsigned int min, unsigned int max)
>  {
>  	unsigned int try, baud, altbaud = 38400;
> +	int hung_up;
>  	upf_t flags = port->flags & UPF_SPD_MASK;
>  
>  	if (flags == UPF_SPD_HI)
> @@ -360,8 +362,10 @@
>  		/*
>  		 * Special case: B0 rate.
>  		 */
> -		if (baud == 0)
> +		if (baud == 0) {
> +			hung_up = 1;
>  			baud = 9600;
> +		}
>  
>  		if (baud >= min && baud <= max)
>  			return baud;
> @@ -373,7 +377,9 @@
>  		termios->c_cflag &= ~CBAUD;
>  		if (old) {
>  			baud = tty_termios_baud_rate(old);
> -			tty_termios_encode_baud_rate(termios, baud, baud);
> +			if (!hung_up)
> +				tty_termios_encode_baud_rate(termios,
> +								baud, baud);
>  			old = NULL;
>  			continue;
>  		}
> @@ -382,7 +388,8 @@
>  		 * As a last resort, if the quotient is zero,
>  		 * default to 9600 bps
>  		 */
> -		tty_termios_encode_baud_rate(termios, 9600, 9600);
> +		if (!hung_up)
> +			tty_termios_encode_baud_rate(termios, 9600, 9600);
>  	}
>  
>  	return 0;

drivers/serial/serial_core.c: In function 'uart_get_baud_rate':
drivers/serial/serial_core.c:340: warning: 'hung_up' may be used uninitialized in this function

It isn't completely obvious that this is a falsie.

