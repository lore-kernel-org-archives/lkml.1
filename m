Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbZCFWkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbZCFWkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbZCFWjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:39:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757108AbZCFWjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:39:12 -0500
Date: Fri, 6 Mar 2009 14:38:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, rpm@xenomai.org,
       cooloney@kernel.org
Subject: Re: [PATCH 15/18] Blackfin Serial Driver: merge the upstream
 adeos/xenomai
Message-Id: <20090306143826.fbbbf56c.akpm@linux-foundation.org>
In-Reply-To: <1236321780-28718-16-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	<1236321780-28718-16-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Mar 2009 14:42:57 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Philippe Gerum <rpm@xenomai.org>
> 
> add ipipe serial debug function for adeos
> 
> Signed-off-by: Philippe Gerum <rpm@xenomai.org>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Changelog is useless.

>  1 files changed, 45 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
> index 71a9e6b..8aa0e37 100644
> --- a/drivers/serial/bfin_5xx.c
> +++ b/drivers/serial/bfin_5xx.c
> @@ -1145,6 +1145,51 @@ static void bfin_serial_console_putchar(struct uart_port *port, int ch)
>  	SSYNC();
>  }
>  
> +#ifdef CONFIG_IPIPE
> +
> +#include <stdarg.h>
> +
> +void __ipipe_serial_debug(const char *fmt, ...)
> +{
> +	struct bfin_serial_port *uart = &bfin_serial_ports[0];
> +	unsigned short status, tmp;
> +	int flags, i, count;
> +	char buf[128];
> +	va_list ap;
> +
> +	va_start(ap, fmt);
> +	vsprintf(buf, fmt, ap);
> +	va_end(ap);
> +	count = strlen(buf);
> +
> +	local_irq_save_hw(flags);
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
> +
> +		UART_PUT_CHAR(uart, buf[i]);
> +		if (buf[i] == '\n') {
> +			do {
> +				status = UART_GET_LSR(uart);
> +			} while (!(status & THRE));
> +			UART_PUT_CHAR(uart, '\r');
> +		}
> +	}
> +
> +	local_irq_restore_hw(flags);
> +}
> +EXPORT_SYMBOL(__ipipe_serial_debug);
> +
> +#endif /* CONFIG_IPIPE */

What does this do?  What bug does it fix?  Why is it needed in 2.6.29?

None of the other patches add references to this symbol.

Why is it exported to modules?
