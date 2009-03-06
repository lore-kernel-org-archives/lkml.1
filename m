Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbZCFWko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbZCFWko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757331AbZCFWjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:39:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757249AbZCFWjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:39:18 -0500
Date: Fri, 6 Mar 2009 14:38:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       sonic.zhang@analog.com, cooloney@kernel.org
Subject: Re: [PATCH 17/18] Blackfin Serial Driver: Fix bug - Enable hardware
 based CTS and RTS for bf548.
Message-Id: <20090306143831.2b8c6c83.akpm@linux-foundation.org>
In-Reply-To: <1236321780-28718-18-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	<1236321780-28718-18-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Mar 2009 14:42:59 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Both software emulated and hardware based CTS and RTS are enabled in
> serial driver.
> 
> The CTS RTS PIN connection on BF548 UART port is defined as a modem
> device not as a host device. In order to test it under Linux, please
> nake a cross UART cable to exchange CTS and RTS signal.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  .../mach-bf518/include/mach/bfin_serial_5xx.h      |   10 +-
>  .../mach-bf527/include/mach/bfin_serial_5xx.h      |   10 +-
>  .../mach-bf533/include/mach/bfin_serial_5xx.h      |    9 +-
>  .../mach-bf537/include/mach/bfin_serial_5xx.h      |   10 +-
>  .../mach-bf538/include/mach/bfin_serial_5xx.h      |   10 +-
>  .../mach-bf548/include/mach/bfin_serial_5xx.h      |   72 ++++-----
>  .../mach-bf561/include/mach/bfin_serial_5xx.h      |    9 +-
>  drivers/serial/Kconfig                             |   26 +++-
>  drivers/serial/bfin_5xx.c                          |  169 ++++++++++++++------
>  9 files changed, 209 insertions(+), 116 deletions(-)

This is a huge patch for us to be merging into -rc7.

> --- a/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
> +++ b/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
> @@ -53,9 +53,9 @@
>  #define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart, UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
>  #define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart, UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
>  
> -#define UART_GET_CTS(x) gpio_get_value(x->cts_pin)
> -#define UART_SET_RTS(x) gpio_set_value(x->rts_pin, 1)
> -#define UART_CLEAR_RTS(x) gpio_set_value(x->rts_pin, 0)
> +#define UART_GET_CTS(x) (!gpio_get_value(x->cts_pin))
> +#define UART_DISABLE_RTS(x) gpio_set_value(x->rts_pin, 1)
> +#define UART_ENABLE_RTS(x) gpio_set_value(x->rts_pin, 0)
>  #define UART_ENABLE_INTS(x, v) UART_PUT_IER(x, v)
>  #define UART_DISABLE_INTS(x) UART_PUT_IER(x, 0)
>  
> @@ -74,6 +74,7 @@
>  struct bfin_serial_port {
>          struct uart_port        port;
>          unsigned int            old_status;
> +	int			status_irq;
>  	unsigned int lsr;

whitepace bustage in here.
