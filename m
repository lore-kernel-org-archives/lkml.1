Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbYDJPdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbYDJPdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbYDJPdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:33:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38117 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756255AbYDJPdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:33:15 -0400
Date: Thu, 10 Apr 2008 16:28:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH 5/7] PPS: serial clients support.
Message-ID: <20080410162812.39414ec5@core>
In-Reply-To: <1207840560-24015-6-git-send-email-giometti@linux.it>
References: <1207840560-24015-1-git-send-email-giometti@linux.it>
	<1207840560-24015-2-git-send-email-giometti@linux.it>
	<1207840560-24015-3-git-send-email-giometti@linux.it>
	<1207840560-24015-4-git-send-email-giometti@linux.it>
	<1207840560-24015-5-git-send-email-giometti@linux.it>
	<1207840560-24015-6-git-send-email-giometti@linux.it>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008 17:15:58 +0200
Rodolfo Giometti <giometti@linux.it> wrote:

> Adds support for the PPS sources connected with the CD (Carrier
> Detect) pin of a serial port.

Ok why does this need to hack the driver layer ?

> -static void uart_change_speed(struct uart_state *state,
> -					struct ktermios *old_termios);
> +static void uart_change_speed(struct uart_state *state, struct ktermios *old_termios);

NAK. Please remove random formatting changes

> -#define uart_set_mctrl(port, set)	uart_update_mctrl(port, set, 0)
> -#define uart_clear_mctrl(port, clear)	uart_update_mctrl(port, 0, clear)
> +#define uart_set_mctrl(port,set)	uart_update_mctrl(port,set,0)
> +#define uart_clear_mctrl(port,clear)	uart_update_mctrl(port,0,clear)

Ditto

>  
>  /*
>   * Startup the port.  This will be called once per open.  All calls
> @@ -291,7 +291,7 @@ uart_update_timeout(struct uart_port *port, unsigned int cflag,
>  		break;
>  	default:
>  		bits = 10;
> -		break; /* CS8 */
> +		break; // CS8

Ditto

> -			baud = tty_termios_baud_rate(old);
> -			tty_termios_encode_baud_rate(termios, baud, baud);
> +			termios->c_cflag |= old->c_cflag & CBAUD;

NAK. Breaks the tty layer code

>  			old = NULL;
>  			continue;
>  		}
> @@ -382,7 +381,7 @@ uart_get_baud_rate(struct uart_port *port, struct ktermios *termios,
>  		 * As a last resort, if the quotient is zero,
>  		 * default to 9600 bps
>  		 */
> -		tty_termios_encode_baud_rate(termios, 9600, 9600);
> +		termios->c_cflag |= B9600;

NAK breaks the tty layer code

> +#ifdef CONFIG_PPS_CLIENT_UART

wrong layer - this means only some ports will work.


> @@ -789,8 +845,7 @@ static int uart_set_info(struct uart_state *state,
>  			 * We failed anyway.
>  			 */
>  			retval = -EBUSY;
> -			/* Added to return the correct error -Ram Gupta */
> -			goto exit;
> +			goto exit;  // Added to return the correct error -Ram Gupta

More format mangling

> +	/* PPS support enabled/disabled? */
> +	if ((old_flags & UPF_HARDPPS_CD) != (new_flags & UPF_HARDPPS_CD)) {

How is this flag set ?


> -static void uart_set_termios(struct tty_struct *tty,
> -						struct ktermios *old_termios)
> +static void uart_set_termios(struct tty_struct *tty, struct ktermios *old_termios)

NAK - more format mangling

>  {
>  	struct uart_state *state = tty->driver_data;
>  	unsigned long flags;
> @@ -1464,8 +1526,9 @@ uart_block_til_ready(struct file *filp, struct uart_state *state)
>  		 */
>  		if ((filp->f_flags & O_NONBLOCK) ||
>  		    (info->tty->termios->c_cflag & CLOCAL) ||
> -		    (info->tty->flags & (1 << TTY_IO_ERROR)))
> +		    (info->tty->flags & (1 << TTY_IO_ERROR))) {

And more - and so it goes on. Please clean up the mess and submit a
proposal which is just the relevant changes so it can be read. Then we
can talk about putting it in the right place.

My guess is that PPS like FIR should be a line discipline and they both
and a couple of other cases want the tty layer to grow

	tty->ops->report_event();

and
	tty->ops->set_event_mask();

for nicer ways to monitor modem bits in the ldisc.

Alan
