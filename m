Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYGRGC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYGRGC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 02:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbYGRGCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 02:02:51 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:42623 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYGRGCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 02:02:50 -0400
Date: Fri, 18 Jul 2008 08:02:45 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
cc: drzeus-mmc@drzeus.cx, Andrew Morton <akpm@linux-foundation.org>,
       alan@redhat.com,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix SDIO break control to now return success or an error
In-Reply-To: <20080710112847.22339.88592.stgit@warthog.procyon.org.uk>
Message-ID: <Pine.LNX.4.64.0807180801220.20605@anakin>
References: <20080710112847.22339.88592.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008, David Howells wrote:
> Fix SDIO break control to now return success or an error.

This patch is now in mainline as commit
c43d8636971c39da993e94082fd65bfff421618e.

> This is a consequence of patch 9ea761bfef52c116fed4715d4043392c2503fe6a.

But this isn't, causing

| drivers/mmc/card/sdio_uart.c:1007: warning: initialization from incompatible pointer type

> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  drivers/mmc/card/sdio_uart.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
> index eeea84c..78ad487 100644
> --- a/drivers/mmc/card/sdio_uart.c
> +++ b/drivers/mmc/card/sdio_uart.c
> @@ -885,12 +885,14 @@ static void sdio_uart_set_termios(struct tty_struct *tty, struct ktermios *old_t
>  	sdio_uart_release_func(port);
>  }
>  
> -static void sdio_uart_break_ctl(struct tty_struct *tty, int break_state)
> +static int sdio_uart_break_ctl(struct tty_struct *tty, int break_state)
>  {
>  	struct sdio_uart_port *port = tty->driver_data;
> +	int result;
>  
> -	if (sdio_uart_claim_func(port) != 0)
> -		return;
> +	result = sdio_uart_claim_func(port);
> +	if (result != 0)
> +		return result;
>  
>  	if (break_state == -1)
>  		port->lcr |= UART_LCR_SBC;
> @@ -899,6 +901,7 @@ static void sdio_uart_break_ctl(struct tty_struct *tty, int break_state)
>  	sdio_out(port, UART_LCR, port->lcr);
>  
>  	sdio_uart_release_func(port);
> +	return 0;
>  }
>  
>  static int sdio_uart_tiocmget(struct tty_struct *tty, struct file *file)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
