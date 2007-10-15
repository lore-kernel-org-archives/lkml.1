Return-Path: <linux-kernel-owner+w=401wt.eu-S933176AbXJOUdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176AbXJOUdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbXJOUdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:33:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50921 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473AbXJOUdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:33:41 -0400
Date: Mon, 15 Oct 2007 13:33:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, bryan.wu@analog.com
Subject: Re: [PATCH 3/3] Blackfin serial driver: this driver enable SPORTs
 on Blackfin emulate UART
Message-Id: <20071015133326.995a4f38.akpm@linux-foundation.org>
In-Reply-To: <1192098220-25828-4-git-send-email-bryan.wu@analog.com>
References: <1192098220-25828-1-git-send-email-bryan.wu@analog.com>
	<1192098220-25828-4-git-send-email-bryan.wu@analog.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [PATCH 3/3] Blackfin serial driver: this driver enable SPORTs on Blackfin emulate UART

That's a bit hard to parse.

On Thu, 11 Oct 2007 18:23:40 +0800
Bryan Wu <bryan.wu@analog.com> wrote:

> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> ---
>  drivers/serial/Kconfig           |   43 +++
>  drivers/serial/Makefile          |    1 +
>  drivers/serial/bfin_sport_uart.c |  614 ++++++++++++++++++++++++++++++++++++++
>  drivers/serial/bfin_sport_uart.h |   63 ++++
>  include/linux/serial_core.h      |    2 +
>  5 files changed, 723 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/serial/bfin_sport_uart.c
>  create mode 100644 drivers/serial/bfin_sport_uart.h
> 
> diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
> index 81b52b7..f3bfbe1 100644
> --- a/drivers/serial/Kconfig
> +++ b/drivers/serial/Kconfig
> @@ -1259,4 +1259,47 @@ config SERIAL_OF_PLATFORM
>  	  Currently, only 8250 compatible ports are supported, but
>  	  others can easily be added.
>  
> +config SERIAL_BFIN_SPORT
> +	tristate "Blackfin SPORT emulate UART (EXPERIMENTAL)"
> +	depends on BFIN && EXPERIMENTAL
> +	select SERIAL_CORE
> +	help
> +	  Enble support SPORT emulate UART on Blackfin series.

There's a typo there.  Also the text is pretty meaningless - I'd fix it up
but I'm not sure what it's trying to tell us!

> +//#define DEBUG

Probably this shouldn't be here at all - DEBUG is passed in from the gcc
command line.

> +#include <linux/module.h>
> +#include <linux/ioport.h>
> +#include <linux/init.h>
> +#include <linux/console.h>
> +#include <linux/sysrq.h>
> +#include <linux/platform_device.h>
> +#include <linux/tty.h>
> +#include <linux/tty_flip.h>
> +#include <linux/serial_core.h>
> +
> +#include <asm/delay.h>
> +#include <asm/portmux.h>
> +
> +#include "bfin_sport_uart.h"
> +
> +unsigned short bfin_uart_pin_req_sport0[] =
> +	{P_SPORT0_TFS, P_SPORT0_DTPRI, P_SPORT0_TSCLK, P_SPORT0_RFS, \
> +	 P_SPORT0_DRPRI, P_SPORT0_RSCLK, P_SPORT0_DRSEC, P_SPORT0_DTSEC, 0};
> +
> +unsigned short bfin_uart_pin_req_sport1[] =
> +	{P_SPORT1_TFS, P_SPORT1_DTPRI, P_SPORT1_TSCLK, P_SPORT1_RFS, \
> +	P_SPORT1_DRPRI, P_SPORT1_RSCLK, P_SPORT1_DRSEC, P_SPORT1_DTSEC, 0};

I don't think these need global scope?

> ...
>
> +/* Reqeust IRQ, Setup clock */
> +static int sport_startup(struct uart_port *port)
> +{
> +	struct sport_uart_port *up = (struct sport_uart_port *)port;
> +	char buffer[20];
> +	int retval;
> +
> +	pr_debug("%s enter\n", __FUNCTION__);
> +	memset(buffer, 20, '\0');

I don't think this memset is needed.

> +	snprintf(buffer, 20, "%s rx", up->name);
> +	retval = request_irq(up->rx_irq, sport_uart_rx_irq, IRQF_SAMPLE_RANDOM, buffer, up);
> +	if (retval) {
> +		printk(KERN_ERR "Unable to request interrupt %s\n", buffer);
> +		return retval;
> +	}
> +
> +	snprintf(buffer, 20, "%s tx", up->name);
> +	retval = request_irq(up->tx_irq, sport_uart_tx_irq, IRQF_SAMPLE_RANDOM, buffer, up);
> +	if (retval) {
> +		printk(KERN_ERR "Unable to request interrupt %s\n", buffer);
> +		goto fail1;
> +	}
> +
> +	snprintf(buffer, 20, "%s err", up->name);
> +	retval = request_irq(up->err_irq, sport_uart_err_irq, IRQF_SAMPLE_RANDOM, buffer, up);
> +	if (retval) {
> +		printk(KERN_ERR "Unable to request interrupt %s\n", buffer);
> +		goto fail2;
> +	}

It is not a good idea to create files in /proc which have spaces in their
names.  Yes, userspace _should_ be able to cope with that in all cases, but
all software sucks, even including userspace ;)

I'd suggest that we be defensive here, and avoid using spaces in filenames.

> +	if (port->line) {
> +		if (peripheral_request_list(bfin_uart_pin_req_sport1, DRV_NAME))
> +			goto fail3;
> +	} else {
> +		if (peripheral_request_list(bfin_uart_pin_req_sport0, DRV_NAME))
> +			goto fail3;
> +	}
> +
> +	sport_uart_setup(up, get_sclk(), port->uartclk);
> +
> +	/* Enable receive interrupt */
> +	SPORT_PUT_RCR1(up, (SPORT_GET_RCR1(up) | RSPEN));
> +	SSYNC();
> +
> +	return 0;
> +
> +
> +fail3:
> +	printk(KERN_ERR DRV_NAME
> +		": Requesting Peripherals failed\n");

s/P/p/

> +	free_irq(up->err_irq, up);
> +fail2:
> +	free_irq(up->tx_irq, up);
> +fail1:
> +	free_irq(up->rx_irq, up);
> +
> +	return retval;
> +
> +}
>
> ...
>
> +static void sport_shutdown(struct uart_port *port)
> +{
> +	struct sport_uart_port *up = (struct sport_uart_port *)port;

That's a bit ugly.  Perhaps using container_of() would be clearer.  it
would also remove the requirement that uart_port be the first member of
sport_uart_port.

> +	pr_debug("%s enter\n", __FUNCTION__);
> +
> +	/* Disable sport */
> +	SPORT_PUT_TCR1(up, (SPORT_GET_TCR1(up) & ~TSPEN));
> +	SPORT_PUT_RCR1(up, (SPORT_GET_RCR1(up) & ~RSPEN));
> +	SSYNC();
> +
> +	if (port->line) {
> +		peripheral_free_list(bfin_uart_pin_req_sport1);
> +	} else {
> +		peripheral_free_list(bfin_uart_pin_req_sport0);
> +	}

Please use checkpatch.  This patch generates a world record number of
warnings.

> +struct uart_ops sport_uart_ops = {
> +	.tx_empty	= sport_tx_empty,
> +	.set_mctrl	= sport_set_mctrl,
> +	.get_mctrl	= sport_get_mctrl,
> +	.stop_tx	= sport_stop_tx,
> +	.start_tx	= sport_start_tx,
> +	.stop_rx	= sport_stop_rx,
> +	.enable_ms	= sport_enable_ms,
> +	.break_ctl	= sport_break_ctl,
> +	.startup	= sport_startup,
> +	.shutdown	= sport_shutdown,
> +	.set_termios	= sport_set_termios,
> +	.type		= sport_type,
> +	.release_port	= sport_release_port,
> +	.request_port	= sport_request_port,
> +	.config_port	= sport_config_port,
> +	.verify_port	= sport_verify_port,
> +};

Does it need to have global scope?


