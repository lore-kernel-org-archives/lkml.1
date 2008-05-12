Return-Path: <linux-kernel-owner+w=401wt.eu-S1760041AbYELLZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041AbYELLZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759552AbYELLZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:25:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56829 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759291AbYELLZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:25:14 -0400
Date: Mon, 12 May 2008 12:18:39 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: linux-kernel@vger.kernel.org, Oleksiy Kebkal <kebkal@gmail.com>,
       Oleksiy Kebkal <lesha@evologics.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] [serial/core]: This patch leaves RTS alone when CRTSCTS is not set.
Message-ID: <20080512111839.GA15305@flint.arm.linux.org.uk>
References: <1210587614-10016-1-git-send-email-cooloney@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210587614-10016-1-git-send-email-cooloney@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 06:20:14PM +0800, Bryan Wu wrote:
> diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
> index eab0327..903360b 100644
> --- a/drivers/serial/serial_core.c
> +++ b/drivers/serial/serial_core.c
> @@ -179,11 +179,15 @@ static int uart_startup(struct uart_state *state, int init_hw)
>  			uart_change_speed(state, NULL);
>  
>  			/*
> -			 * Setup the RTS and DTR signals once the
> -			 * port is open and ready to respond.
> +			 * Setup the RTS (in the case of hardware flow control)
> +			 * and DTR signals once the port is open and ready to
> +			 * respond.
>  			 */
> -			if (info->tty->termios->c_cflag & CBAUD)
> -				uart_set_mctrl(port, TIOCM_RTS | TIOCM_DTR);
> +			if (info->tty->termios->c_cflag & CBAUD) {
> +				uart_set_mctrl(port, TIOCM_DTR);
> +				if (info->flags & UIF_CTS_FLOW)

We have access to termios->c_cflag here, please use that in preference
to testing info->flags.

> +					uart_set_mctrl(port, TIOCM_RTS);
> +			}
>  		}
>  
>  		if (info->flags & UIF_CTS_FLOW) {
> @@ -224,10 +228,14 @@ static void uart_shutdown(struct uart_state *state)
>  		info->flags &= ~UIF_INITIALIZED;
>  
>  		/*
> -		 * Turn off DTR and RTS early.
> +		 * Turn off DTR and RTS (in the case of hardware flow control)
> +		 * early.
>  		 */
> -		if (!info->tty || (info->tty->termios->c_cflag & HUPCL))
> -			uart_clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
> +		if (!info->tty || (info->tty->termios->c_cflag & HUPCL)) {
> +			uart_clear_mctrl(port, TIOCM_DTR);
> +			if (info->flags & UIF_CTS_FLOW)

Ditto.

> +				uart_clear_mctrl(port, TIOCM_RTS);
> +               }
>  
>  		/*
>  		 * clear delta_msr_wait queue to avoid mem leaks: we may free
> @@ -1190,14 +1198,16 @@ static void uart_set_termios(struct tty_struct *tty,
>  	uart_change_speed(state, old_termios);
>  
>  	/* Handle transition to B0 status */
> -	if ((old_termios->c_cflag & CBAUD) && !(cflag & CBAUD))
> -		uart_clear_mctrl(state->port, TIOCM_RTS | TIOCM_DTR);
> +	if ((old_termios->c_cflag & CBAUD) && !(cflag & CBAUD)) {
> +		uart_clear_mctrl(state->port, TIOCM_DTR);
> +		if (state->info->flags & UIF_CTS_FLOW)

Ditto.

> +			uart_clear_mctrl(state->port, TIOCM_RTS);
> +       }
>  
>  	/* Handle transition away from B0 status */
>  	if (!(old_termios->c_cflag & CBAUD) && (cflag & CBAUD)) {
>  		unsigned int mask = TIOCM_DTR;
> -		if (!(cflag & CRTSCTS) ||
> -		    !test_bit(TTY_THROTTLED, &tty->flags))
> +		if (!test_bit(TTY_THROTTLED, &tty->flags))
>  			mask |= TIOCM_RTS;

This is inconsistent with your other changes - with your change, it will
always set RTS when switching away from B0 status.

>  		uart_set_mctrl(state->port, mask);
>  	}
> @@ -1441,10 +1451,14 @@ static void uart_update_termios(struct uart_state *state)
>  		uart_change_speed(state, NULL);
>  
>  		/*
> -		 * And finally enable the RTS and DTR signals.
> +		 * And finally enable the RTS (in the of case hardware flow
> +		 * control) and DTR signals.
>  		 */
> -		if (tty->termios->c_cflag & CBAUD)
> -			uart_set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
> +		if (tty->termios->c_cflag & CBAUD) {
> +			uart_set_mctrl(port, TIOCM_DTR);
> +			if (state->info->flags & UIF_CTS_FLOW)

We have access to termios->c_cflag here, please use that in preference
to testing info->flags.

> +				uart_set_mctrl(port, TIOCM_RTS);
> +		}
>  	}
>  }
>  

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
