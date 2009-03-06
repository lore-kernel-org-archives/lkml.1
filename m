Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbZCFWiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbZCFWiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbZCFWif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:38:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755394AbZCFWif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:38:35 -0500
Date: Fri, 6 Mar 2009 14:37:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       graf.yang@analog.com, cooloney@kernel.org
Subject: Re: [PATCH 01/18] Blackfin Serial Driver: Add a debug function to
 serial driver.
Message-Id: <20090306143749.5d4e8459.akpm@linux-foundation.org>
In-Reply-To: <1236321780-28718-2-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	<1236321780-28718-2-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Mar 2009 14:42:43 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Graf Yang <graf.yang@analog.com>
> 
> Signed-off-by: Graf Yang <graf.yang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/serial/bfin_5xx.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 44 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
> index 318d69d..52ccc27 100644
> --- a/drivers/serial/bfin_5xx.c
> +++ b/drivers/serial/bfin_5xx.c
> @@ -21,6 +21,7 @@
>  #include <linux/tty.h>
>  #include <linux/tty_flip.h>
>  #include <linux/serial_core.h>
> +#include <stdarg.h>
>  
>  #if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
>  	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
> @@ -1177,6 +1178,49 @@ struct console __init *bfin_earlyserial_init(unsigned int port,
>  
>  #endif /* CONFIG_EARLY_PRINTK */
>  
> +#ifdef CONFIG_DEBUG_KERNEL
> +void bfin_serial_debug(const char *fmt, ...)
> +{
> +	struct bfin_serial_port *uart = &bfin_serial_ports[0];
> +	unsigned short status, tmp;
> +	int flags, i, count;
> +	char buf[128];
> +	va_list ap;
> +
> +	if (bfin_serial_console.index < 0)
> +		return;		/* Too early. */
> +
> +	va_start(ap, fmt);
> +	vsprintf(buf, fmt, ap);
> +	va_end(ap);
> +	count = strlen(buf);
> +
> +	spin_lock_irqsave(&uart->port.lock, flags);
> +
> +	for (i = 0; i < count; i++) {
> +		do {
> +			status = UART_GET_LSR(uart);
> +		} while (!(status & THRE));
> +
> +#ifndef CONFIG_BF54x
> +		tmp = UART_GET_LCR(uart);
> +		tmp &= ~DLAB;
> +		UART_PUT_LCR(uart, tmp);
> +#endif
> +		UART_PUT_CHAR(uart, buf[i]);
> +		if (buf[i] == '\n') {
> +			do {
> +				status = UART_GET_LSR(uart);
> +			} while (!(status & THRE));
> +			UART_PUT_CHAR(uart, '\r');
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&uart->port.lock, flags);
> +}
> +EXPORT_SYMBOL(bfin_serial_debug);
> +#endif

This function is used in later bugfix patches - otherwise it wouldn't
be a 2.6.29 patch.

I shall update the changelog to reflect this.
